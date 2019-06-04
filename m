Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A65713436E
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2019 11:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfFDJjd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jun 2019 05:39:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20199 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727023AbfFDJjc (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 4 Jun 2019 05:39:32 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 46A8490906
        for <ceph-devel@vger.kernel.org>; Tue,  4 Jun 2019 09:39:32 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-98.pek2.redhat.com [10.72.12.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C907C61981;
        Tue,  4 Jun 2019 09:39:27 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 4/4] ceph: allow remounting aborted mount
Date:   Tue,  4 Jun 2019 17:39:08 +0800
Message-Id: <20190604093908.30491-4-zyan@redhat.com>
In-Reply-To: <20190604093908.30491-1-zyan@redhat.com>
References: <20190604093908.30491-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 04 Jun 2019 09:39:32 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When remounting aborted mount, also reset client's entity addr.
'umount -f /ceph; mount -o remount /ceph' can be used for recovering
from blacklist.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/mds_client.c | 14 ++++++++++++--
 fs/ceph/super.c      | 23 +++++++++++++++++++++--
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index f5c3499fdec6..eb3976a742ac 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1377,7 +1377,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 		struct ceph_cap_flush *cf;
 		struct ceph_mds_client *mdsc = fsc->mdsc;
 
-		if (ci->i_wrbuffer_ref > 0 &&
+		if (inode->i_data.nrpages > 0 &&
 		    READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN)
 			invalidate = true;
 
@@ -4347,6 +4347,7 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
 {
 	struct ceph_mds_session *session;
 	int mds;
+       LIST_HEAD(requests);
 
 	dout("force umount\n");
 
@@ -4355,7 +4356,12 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
 		session = __ceph_lookup_mds_session(mdsc, mds);
 		if (!session)
 			continue;
+
+		list_splice_init(&session->s_waiting, &requests);
+		if (session->s_state == CEPH_MDS_SESSION_REJECTED)
+			__unregister_session(mdsc, session);
 		mutex_unlock(&mdsc->mutex);
+
 		mutex_lock(&session->s_mutex);
 		__close_session(mdsc, session);
 		if (session->s_state == CEPH_MDS_SESSION_CLOSING) {
@@ -4364,10 +4370,14 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
 		}
 		mutex_unlock(&session->s_mutex);
 		ceph_put_mds_session(session);
+
 		mutex_lock(&mdsc->mutex);
 		kick_requests(mdsc, mds);
 	}
-	__wake_requests(mdsc, &mdsc->waiting_for_map);
+
+       list_splice_init(&mdsc->waiting_for_map, &requests);
+       __wake_requests(mdsc, &requests);
+
 	mutex_unlock(&mdsc->mutex);
 }
 
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 67eb9d592ab7..a6a3c065f697 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -833,8 +833,27 @@ static void ceph_umount_begin(struct super_block *sb)
 
 static int ceph_remount(struct super_block *sb, int *flags, char *data)
 {
-	sync_filesystem(sb);
-	return 0;
+	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
+
+	if (fsc->mount_state != CEPH_MOUNT_SHUTDOWN) {
+		sync_filesystem(sb);
+		return 0;
+	}
+
+	/* Make sure all page caches get invalidated.
+	 * see remove_session_caps_cb() */
+	flush_workqueue(fsc->inode_wq);
+	/* In case that we were blacklisted. This also reset
+	 * all mon/osd connections */
+	ceph_reset_client_addr(fsc->client);
+
+	ceph_osdc_clear_abort_err(&fsc->client->osdc);
+	fsc->mount_state = 0;
+
+	if (!sb->s_root)
+		return 0;
+	return __ceph_do_getattr(d_inode(sb->s_root), NULL,
+				 CEPH_STAT_CAP_INODE, true);
 }
 
 static const struct super_operations ceph_super_ops = {
-- 
2.17.2

