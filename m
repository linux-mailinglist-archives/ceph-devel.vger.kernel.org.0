Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECF8272EBD
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2019 14:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbfGXMVu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Jul 2019 08:21:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40484 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728172AbfGXMVu (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 24 Jul 2019 08:21:50 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B70E77FDFB
        for <ceph-devel@vger.kernel.org>; Wed, 24 Jul 2019 12:21:49 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-93.pek2.redhat.com [10.72.12.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B521760BEC;
        Wed, 24 Jul 2019 12:21:47 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH v2 8/9] ceph: invalidate all write mode filp after reconnect
Date:   Wed, 24 Jul 2019 20:21:19 +0800
Message-Id: <20190724122120.17438-9-zyan@redhat.com>
In-Reply-To: <20190724122120.17438-1-zyan@redhat.com>
References: <20190724122120.17438-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 24 Jul 2019 12:21:49 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/caps.c  | 13 +++++++++++++
 fs/ceph/file.c  |  1 +
 fs/ceph/super.c |  2 ++
 fs/ceph/super.h |  3 +++
 4 files changed, 19 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 102192c90edd..d17bde5d4f9a 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2780,12 +2780,17 @@ int ceph_get_caps(struct file *filp, int need, int want,
 	struct ceph_file_info *fi = filp->private_data;
 	struct inode *inode = file_inode(filp);
 	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	int ret, _got, flags;
 
 	ret = ceph_pool_perm_check(inode, need);
 	if (ret < 0)
 		return ret;
 
+	if ((fi->fmode & CEPH_FILE_MODE_WR) &&
+	    fi->filp_gen != READ_ONCE(fsc->filp_gen))
+		return -EBADF;
+
 	while (true) {
 		if (endoff > 0)
 			check_max_size(inode, endoff);
@@ -2814,6 +2819,14 @@ int ceph_get_caps(struct file *filp, int need, int want,
 			if (ret == -EAGAIN)
 				continue;
 		}
+
+		if ((fi->fmode & CEPH_FILE_MODE_WR) &&
+		    fi->filp_gen != READ_ONCE(fsc->filp_gen)) {
+			if (ret >= 0 && _got)
+				ceph_put_cap_refs(ci, _got);
+			return -EBADF;
+		}
+
 		if (ret < 0) {
 			if (ret == -ESTALE) {
 				/* session was killed, try renew caps */
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index f3cdf1ed8d3d..42cb1453c602 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -234,6 +234,7 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
 	spin_lock_init(&fi->rw_contexts_lock);
 	INIT_LIST_HEAD(&fi->rw_contexts);
 	fi->meta_err = errseq_sample(&ci->i_meta_err);
+	fi->filp_gen = READ_ONCE(ceph_inode_to_client(inode)->filp_gen);
 
 	return 0;
 }
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 310a4c05961c..b55ab2fd73db 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -664,6 +664,7 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
 
 	fsc->sb = NULL;
 	fsc->mount_state = CEPH_MOUNT_MOUNTING;
+	fsc->filp_gen = 1;
 
 	atomic_long_set(&fsc->writeback_count, 0);
 
@@ -827,6 +828,7 @@ static void ceph_umount_begin(struct super_block *sb)
 	if (!fsc)
 		return;
 	fsc->mount_state = CEPH_MOUNT_SHUTDOWN;
+	fsc->filp_gen++; // invalidate open files
 	ceph_osdc_abort_requests(&fsc->client->osdc, -EIO);
 	ceph_mdsc_force_umount(fsc->mdsc);
 }
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index f3d3b26c499d..f64a5271cb1a 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -101,6 +101,8 @@ struct ceph_fs_client {
 	struct ceph_client *client;
 
 	unsigned long mount_state;
+
+	u32 filp_gen;
 	loff_t max_file_size;
 
 	struct ceph_mds_client *mdsc;
@@ -707,6 +709,7 @@ struct ceph_file_info {
 	struct list_head rw_contexts;
 
 	errseq_t meta_err;
+	u32 filp_gen;
 	atomic_t num_locks;
 };
 
-- 
2.20.1

