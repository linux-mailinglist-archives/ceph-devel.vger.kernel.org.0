Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0CE3EE530
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Aug 2021 05:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbhHQDp2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 Aug 2021 23:45:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38979 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233686AbhHQDp1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 16 Aug 2021 23:45:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629171894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PrNXWuhGxaawALFm6Gb6avEvY0MtenciPndrvfzxwvk=;
        b=Se/bLp7f8G85Yipqlg/Yfx4TCROc1eNJThrp/0b2nuH4zAh6OOvwHHX/OBtJUkCokDYdAX
        ZaDGa/2EbRmOUrotxQN+LnOoVxsMebSmjD4QSrp2voem+3B6hu94LGC04rmEUeC8oSBCRG
        gjQlLtjYBvTe9mbxpYA7IT5ELX2ZN9Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14--Q2wWLfmPhylkxmBXT33gw-1; Mon, 16 Aug 2021 23:44:51 -0400
X-MC-Unique: -Q2wWLfmPhylkxmBXT33gw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1EEFF802929;
        Tue, 17 Aug 2021 03:44:50 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 22C615D6A8;
        Tue, 17 Aug 2021 03:44:47 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: try to reconnect to the export targets
Date:   Tue, 17 Aug 2021 11:44:45 +0800
Message-Id: <20210817034445.405663-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

- check the export target rank when decoding the mdsmap instead of
BUG_ON
- fix issue that the sessions have been opened during the mutex's
unlock/lock gap


 fs/ceph/mds_client.c | 63 +++++++++++++++++++++++++++++++++++++++++++-
 fs/ceph/mdsmap.c     | 10 ++++---
 2 files changed, 69 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index e49dbeb6c06f..1e013fb09d73 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4197,13 +4197,22 @@ static void check_new_map(struct ceph_mds_client *mdsc,
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
+		for (i = 0; i < m_info->num_export_targets; i++)
+			export_targets[m_info->export_targets[i]] = 1;
+	}
+
 	for (i = 0; i < oldmap->possible_max_rank && i < mdsc->max_sessions; i++) {
 		if (!mdsc->sessions[i])
 			continue;
@@ -4257,6 +4266,8 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 		if (s->s_state == CEPH_MDS_SESSION_RESTARTING &&
 		    newstate >= CEPH_MDS_STATE_RECONNECT) {
 			mutex_unlock(&mdsc->mutex);
+			if (export_targets)
+				export_targets[i] = 0;
 			send_mds_reconnect(mdsc, s);
 			mutex_lock(&mdsc->mutex);
 		}
@@ -4279,6 +4290,54 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 		}
 	}
 
+	/*
+	 * Only open and reconnect sessions that don't exist yet.
+	 */
+	for (i = 0; i < newmap->possible_max_rank; i++) {
+		if (unlikely(!export_targets))
+			break;
+
+		/*
+		 * In case the import MDS is crashed just after
+		 * the EImportStart journal is flushed, so when
+		 * a standby MDS takes over it and is replaying
+		 * the EImportStart journal the new MDS daemon
+		 * will wait the client to reconnect it, but the
+		 * client may never register/open the session yet.
+		 *
+		 * Will try to reconnect that MDS daemon if the
+		 * rank number is in the export_targets array and
+		 * is the up:reconnect state.
+		 */
+		newstate = ceph_mdsmap_get_state(newmap, i);
+		if (!export_targets[i] || newstate != CEPH_MDS_STATE_RECONNECT)
+			continue;
+
+		/*
+		 * The session maybe registered and opened by some
+		 * requests which were choosing random MDSes during
+		 * the mdsc->mutex's unlock/lock gap below in rare
+		 * case. But the related MDS daemon will just queue
+		 * that requests and be still waiting for the client's
+		 * reconnection request in up:reconnect state.
+		 */
+		s = __ceph_lookup_mds_session(mdsc, i);
+		if (likely(!s)) {
+			s = __open_export_target_session(mdsc, i);
+			if (IS_ERR(s)) {
+				err = PTR_ERR(s);
+				pr_err("failed to open export target session, err %d\n",
+				       err);
+				continue;
+			}
+		}
+		dout("send reconnect to export target mds.%d\n", i);
+		mutex_unlock(&mdsc->mutex);
+		send_mds_reconnect(mdsc, s);
+		mutex_lock(&mdsc->mutex);
+		ceph_put_mds_session(s);
+	}
+
 	for (i = 0; i < newmap->possible_max_rank && i < mdsc->max_sessions; i++) {
 		s = mdsc->sessions[i];
 		if (!s)
@@ -4293,6 +4352,8 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 			__open_export_target_sessions(mdsc, s);
 		}
 	}
+
+	kfree(export_targets);
 }
 
 
diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 3c444b9cb17b..d995cb02d30c 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -122,6 +122,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
 	int err;
 	u8 mdsmap_v;
 	u16 mdsmap_ev;
+	u32 target;
 
 	m = kzalloc(sizeof(*m), GFP_NOFS);
 	if (!m)
@@ -260,9 +261,12 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
 						       sizeof(u32), GFP_NOFS);
 			if (!info->export_targets)
 				goto nomem;
-			for (j = 0; j < num_export_targets; j++)
-				info->export_targets[j] =
-				       ceph_decode_32(&pexport_targets);
+			for (j = 0; j < num_export_targets; j++) {
+				target = ceph_decode_32(&pexport_targets);
+				if (target >= m->possible_max_rank)
+					goto corrupt;
+				info->export_targets[j] = target;
+			}
 		} else {
 			info->export_targets = NULL;
 		}
-- 
2.27.0

