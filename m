Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA1148345
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jun 2019 14:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbfFQM4K (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jun 2019 08:56:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51129 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbfFQM4K (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 08:56:10 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 82A982ED2C1
        for <ceph-devel@vger.kernel.org>; Mon, 17 Jun 2019 12:56:09 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-92.pek2.redhat.com [10.72.12.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C2517D66C;
        Mon, 17 Jun 2019 12:56:04 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 8/8] ceph: return -EIO if read/write against filp that lost file locks
Date:   Mon, 17 Jun 2019 20:55:29 +0800
Message-Id: <20190617125529.6230-9-zyan@redhat.com>
In-Reply-To: <20190617125529.6230-1-zyan@redhat.com>
References: <20190617125529.6230-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 17 Jun 2019 12:56:09 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

After mds evicts session, file locks get lost sliently. It's not safe to
let programs continue to do read/write.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/caps.c  | 28 ++++++++++++++++++++++------
 fs/ceph/locks.c |  8 ++++++--
 fs/ceph/super.h |  1 +
 3 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index f07767d3864c..d8efacd874b7 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2543,8 +2543,13 @@ static void __take_cap_refs(struct ceph_inode_info *ci, int got,
  *
  * FIXME: how does a 0 return differ from -EAGAIN?
  */
+enum {
+	NON_BLOCKING	= 1,
+	CHECK_FILELOCK	= 2,
+};
+
 static int try_get_cap_refs(struct inode *inode, int need, int want,
-			    loff_t endoff, bool nonblock, int *got)
+			    loff_t endoff, int flags, int *got)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
@@ -2559,6 +2564,13 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 again:
 	spin_lock(&ci->i_ceph_lock);
 
+	if ((flags & CHECK_FILELOCK) &&
+	    (ci->i_ceph_flags & CEPH_I_ERROR_FILELOCK)) {
+		dout("try_get_cap_refs %p error filelock\n", inode);
+		ret = -EIO;
+		goto out_unlock;
+	}
+
 	/* make sure file is actually open */
 	file_wanted = __ceph_caps_file_wanted(ci);
 	if ((file_wanted & need) != need) {
@@ -2620,7 +2632,7 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 					 * we can not call down_read() when
 					 * task isn't in TASK_RUNNING state
 					 */
-					if (nonblock) {
+					if (flags & NON_BLOCKING) {
 						ret = -EAGAIN;
 						goto out_unlock;
 					}
@@ -2725,7 +2737,8 @@ int ceph_try_get_caps(struct inode *inode, int need, int want,
 	if (ret < 0)
 		return ret;
 
-	ret = try_get_cap_refs(inode, need, want, 0, nonblock, got);
+	ret = try_get_cap_refs(inode, need, want, 0,
+			       (nonblock ? NON_BLOCKING : 0), got);
 	return ret == -EAGAIN ? 0 : ret;
 }
 
@@ -2737,9 +2750,10 @@ int ceph_try_get_caps(struct inode *inode, int need, int want,
 int ceph_get_caps(struct file *filp, int need, int want,
 		  loff_t endoff, int *got, struct page **pinned_page)
 {
+	struct ceph_file_info *fi = filp->private_data;
 	struct inode *inode = file_inode(filp);
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	int _got, ret;
+	int ret, _got, flags;
 
 	ret = ceph_pool_perm_check(inode, need);
 	if (ret < 0)
@@ -2749,17 +2763,19 @@ int ceph_get_caps(struct file *filp, int need, int want,
 		if (endoff > 0)
 			check_max_size(inode, endoff);
 
+		flags = atomic_read(&fi->num_locks) ? CHECK_FILELOCK : 0;
 		_got = 0;
 		ret = try_get_cap_refs(inode, need, want, endoff,
-				       false, &_got);
+				       flags, &_got);
 		if (ret == -EAGAIN)
 			continue;
 		if (!ret) {
 			DEFINE_WAIT_FUNC(wait, woken_wake_function);
 			add_wait_queue(&ci->i_cap_wq, &wait);
 
+			flags |= NON_BLOCKING;
 			while (!(ret = try_get_cap_refs(inode, need, want,
-							endoff, true, &_got))) {
+							endoff, flags, &_got))) {
 				if (signal_pending(current)) {
 					ret = -ERESTARTSYS;
 					break;
diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index ac9b53b89365..cb216501c959 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -32,14 +32,18 @@ void __init ceph_flock_init(void)
 
 static void ceph_fl_copy_lock(struct file_lock *dst, struct file_lock *src)
 {
-	struct inode *inode = file_inode(src->fl_file);
+	struct ceph_file_info *fi = dst->fl_file->private_data;
+	struct inode *inode = file_inode(dst->fl_file);
 	atomic_inc(&ceph_inode(inode)->i_filelock_ref);
+	atomic_inc(&fi->num_locks);
 }
 
 static void ceph_fl_release_lock(struct file_lock *fl)
 {
+	struct ceph_file_info *fi = fl->fl_file->private_data;
 	struct inode *inode = file_inode(fl->fl_file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
+	atomic_dec(&fi->num_locks);
 	if (atomic_dec_and_test(&ci->i_filelock_ref)) {
 		/* clear error when all locks are released */
 		spin_lock(&ci->i_ceph_lock);
@@ -73,7 +77,7 @@ static int ceph_lock_message(u8 lock_type, u16 operation, struct inode *inode,
 		 * window. Caller function will decrease the counter.
 		 */
 		fl->fl_ops = &ceph_fl_lock_ops;
-		atomic_inc(&ceph_inode(inode)->i_filelock_ref);
+		fl->fl_ops->fl_copy_lock(fl, NULL);
 	}
 
 	if (operation != CEPH_MDS_OP_SETFILELOCK || cmd == CEPH_LOCK_UNLOCK)
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index f45a06475f4f..999fd3244907 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -705,6 +705,7 @@ struct ceph_file_info {
 	struct list_head rw_contexts;
 
 	errseq_t meta_err;
+	atomic_t num_locks;
 };
 
 struct ceph_dir_file_info {
-- 
2.17.2

