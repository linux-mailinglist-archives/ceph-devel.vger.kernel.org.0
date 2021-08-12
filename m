Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB443E9D36
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Aug 2021 06:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbhHLELZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Aug 2021 00:11:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20642 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233426AbhHLELZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 00:11:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628741460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tIWWedtbfl2zmGZsxMkMvquSb9vfixVctvKMTEJlhCU=;
        b=XuTLOjWBq0JATqORx7rul/F5SZmpiA59EfYwQBS/zkNpwkUF6fiPHjFEsH9PpY3DfXyMhj
        9HlEi4uq1Um/v7M5jDaRaDJEdv/H86VCXCXdUyBJzE0maRlNcQFS4aVE3I/zxguBCYVI3E
        5tEPOzbylr4649WnwFCR7PmqulpSdAc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-VJ28hVzwNyCZ8Yc4EA4Irg-1; Thu, 12 Aug 2021 00:10:58 -0400
X-MC-Unique: VJ28hVzwNyCZ8Yc4EA4Irg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13D7D100962A;
        Thu, 12 Aug 2021 04:10:57 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E7BF6A056;
        Thu, 12 Aug 2021 04:10:54 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: try to reconnect to the export targets
Date:   Thu, 12 Aug 2021 12:10:42 +0800
Message-Id: <20210812041042.132984-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

In case the export MDS is crashed just after the EImportStart journal
is flushed, so when a standby MDS takes over it and when replaying
the EImportStart journal the MDS will wait the client to reconnect,
but the client may never register/open the sessions yet.

We will try to reconnect that MDSes if they're in the export targets
and in RECONNECT state.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 58 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 14e44de05812..7dfe7a804320 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4182,13 +4182,24 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 			  struct ceph_mdsmap *newmap,
 			  struct ceph_mdsmap *oldmap)
 {
-	int i;
+	int i, err;
+	int *export_targets;
 	int oldstate, newstate;
 	struct ceph_mds_session *s;
+	struct ceph_mds_info *m_info;
 
 	dout("check_new_map new %u old %u\n",
 	     newmap->m_epoch, oldmap->m_epoch);
 
+	m_info = newmap->m_info;
+	export_targets = kcalloc(newmap->possible_max_rank, sizeof(int), GFP_NOFS);
+	if (export_targets && m_info) {
+		for (i = 0; i < m_info->num_export_targets; i++) {
+			BUG_ON(m_info->export_targets[i] >= newmap->possible_max_rank);
+			export_targets[m_info->export_targets[i]] = 1;
+		}
+	}
+
 	for (i = 0; i < oldmap->possible_max_rank && i < mdsc->max_sessions; i++) {
 		if (!mdsc->sessions[i])
 			continue;
@@ -4242,6 +4253,8 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 		if (s->s_state == CEPH_MDS_SESSION_RESTARTING &&
 		    newstate >= CEPH_MDS_STATE_RECONNECT) {
 			mutex_unlock(&mdsc->mutex);
+			if (export_targets)
+				export_targets[i] = 0;
 			send_mds_reconnect(mdsc, s);
 			mutex_lock(&mdsc->mutex);
 		}
@@ -4264,6 +4277,47 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 		}
 	}
 
+	for (i = 0; i < newmap->possible_max_rank; i++) {
+		if (!export_targets)
+			break;
+
+		/*
+		 * Only open and reconnect sessions that don't
+		 * exist yet.
+		 */
+		if (!export_targets[i] || __have_session(mdsc, i))
+			continue;
+
+		/*
+		 * In case the export MDS is crashed just after
+		 * the EImportStart journal is flushed, so when
+		 * a standby MDS takes over it and is replaying
+		 * the EImportStart journal the new MDS daemon
+		 * will wait the client to reconnect it, but the
+		 * client may never register/open the sessions
+		 * yet.
+		 *
+		 * It will try to reconnect that MDS daemons if
+		 * the MDSes are in the export targets and is the
+		 * RECONNECT state.
+		 */
+		newstate = ceph_mdsmap_get_state(newmap, i);
+		if (newstate != CEPH_MDS_STATE_RECONNECT)
+			continue;
+		s = __open_export_target_session(mdsc, i);
+		if (IS_ERR(s)) {
+			err = PTR_ERR(s);
+			pr_err("failed to open export target session, err %d\n",
+			       err);
+			continue;
+		}
+		dout("send reconnect to target mds.%d\n", i);
+		mutex_unlock(&mdsc->mutex);
+		send_mds_reconnect(mdsc, s);
+		mutex_lock(&mdsc->mutex);
+		ceph_put_mds_session(s);
+	}
+
 	for (i = 0; i < newmap->possible_max_rank && i < mdsc->max_sessions; i++) {
 		s = mdsc->sessions[i];
 		if (!s)
@@ -4278,6 +4332,8 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 			__open_export_target_sessions(mdsc, s);
 		}
 	}
+
+	kfree(export_targets);
 }
 
 
-- 
2.27.0

