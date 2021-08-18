Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904943EF78B
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Aug 2021 03:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235253AbhHRBcB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Aug 2021 21:32:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39314 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233027AbhHRBcA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 21:32:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629250286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=BnsovWDUzTA6dI/8EGNxtI4m/GNXj+4Xk4I8UO9T3ss=;
        b=jRw9UosvAuEd+bOK+ddJFCZoWhzuCnriLhk7k4j6TiRkfMPuxfT+Bx1ahHd+ZDFhBhoRsc
        L+C6ERNth1YhZ2obG8LeIWoGd5vZ9UZ4fcMYHrDME5rkKQWCwenge9K2Ji6lZ5e0kMZ1yW
        inegstwuis+JGwv1owYvyfavRHKblH4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-Qd22mPMnPDiQoLIni2S70A-1; Tue, 17 Aug 2021 21:31:25 -0400
X-MC-Unique: Qd22mPMnPDiQoLIni2S70A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 253F1801AC0;
        Wed, 18 Aug 2021 01:31:24 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F3F160916;
        Wed, 18 Aug 2021 01:31:21 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3] ceph: try to reconnect to the export targets
Date:   Wed, 18 Aug 2021 09:31:19 +0800
Message-Id: <20210818013119.76694-1-xiubli@redhat.com>
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

V3:
- switch to bitmap and on the stack
- put the ceph_put_mds_session() out of the mdsc->mutex lock scope


 fs/ceph/mds_client.c | 55 +++++++++++++++++++++++++++++++++++++++++++-
 fs/ceph/mdsmap.c     | 10 +++++---
 2 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index e49dbeb6c06f..c2fca06b09a0 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -11,6 +11,7 @@
 #include <linux/ratelimit.h>
 #include <linux/bits.h>
 #include <linux/ktime.h>
+#include <linux/bitmap.h>
 
 #include "super.h"
 #include "mds_client.h"
@@ -4197,13 +4198,19 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 			  struct ceph_mdsmap *newmap,
 			  struct ceph_mdsmap *oldmap)
 {
-	int i;
+	int i, err;
 	int oldstate, newstate;
 	struct ceph_mds_session *s;
+	unsigned long targets[DIV_ROUND_UP(CEPH_MAX_MDS, sizeof(unsigned long))] = {0};
 
 	dout("check_new_map new %u old %u\n",
 	     newmap->m_epoch, oldmap->m_epoch);
 
+	if (newmap->m_info) {
+		for (i = 0; i < newmap->m_info->num_export_targets; i++)
+			set_bit(newmap->m_info->export_targets[i], targets);
+	}
+
 	for (i = 0; i < oldmap->possible_max_rank && i < mdsc->max_sessions; i++) {
 		if (!mdsc->sessions[i])
 			continue;
@@ -4257,6 +4264,7 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 		if (s->s_state == CEPH_MDS_SESSION_RESTARTING &&
 		    newstate >= CEPH_MDS_STATE_RECONNECT) {
 			mutex_unlock(&mdsc->mutex);
+			clear_bit(i, targets);
 			send_mds_reconnect(mdsc, s);
 			mutex_lock(&mdsc->mutex);
 		}
@@ -4279,6 +4287,51 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 		}
 	}
 
+	/*
+	 * Only open and reconnect sessions that don't exist yet.
+	 */
+	for (i = 0; i < newmap->possible_max_rank; i++) {
+		/*
+		 * In case the import MDS is crashed just after
+		 * the EImportStart journal is flushed, so when
+		 * a standby MDS takes over it and is replaying
+		 * the EImportStart journal the new MDS daemon
+		 * will wait the client to reconnect it, but the
+		 * client may never register/open the session yet.
+		 *
+		 * Will try to reconnect that MDS daemon if the
+		 * rank number is in the export targets array and
+		 * is the up:reconnect state.
+		 */
+		newstate = ceph_mdsmap_get_state(newmap, i);
+		if (!test_bit(i, targets) || newstate != CEPH_MDS_STATE_RECONNECT)
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
+		ceph_put_mds_session(s);
+		mutex_lock(&mdsc->mutex);
+	}
+
 	for (i = 0; i < newmap->possible_max_rank && i < mdsc->max_sessions; i++) {
 		s = mdsc->sessions[i];
 		if (!s)
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

