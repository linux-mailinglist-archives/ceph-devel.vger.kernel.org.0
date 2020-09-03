Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15F725C1B9
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Sep 2020 15:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgICNhB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Sep 2020 09:37:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20020 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728908AbgICNB6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 3 Sep 2020 09:01:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599138116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=ptdk/N5UyZK5gEVb9yQzZbCu40ukEMbwyNYbi4qgo10=;
        b=Nf1pHGSVUKaFjqMIvYd7E5a1meqGPrphnnaMzB93FA6bpSgTx689crGt2TsKsLkukWOWND
        5j+AJbmL85hzxAi+XgXq11wHZ+KFXullpEWrN5hZOHj0J0tvTm1PH5r56vPIL9UuyTPH2M
        N4S8Z9J+IAi/dFujr5QoN8XPy7qzmqs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-cNy3ljXJM2ysJ6E9-Im8cQ-1; Thu, 03 Sep 2020 09:01:51 -0400
X-MC-Unique: cNy3ljXJM2ysJ6E9-Im8cQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB45E801AEC;
        Thu,  3 Sep 2020 13:01:50 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (vm37-202.gsslab.pek2.redhat.com [10.72.37.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A8B678B38;
        Thu,  3 Sep 2020 13:01:48 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v5 1/2] ceph: add ceph_sb_to_mdsc helper support to parse the mdsc
Date:   Thu,  3 Sep 2020 09:01:39 -0400
Message-Id: <20200903130140.799392-2-xiubli@redhat.com>
In-Reply-To: <20200903130140.799392-1-xiubli@redhat.com>
References: <20200903130140.799392-1-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This will help simplify the code.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c  |  3 +--
 fs/ceph/dir.c   | 20 +++++++-------------
 fs/ceph/file.c  |  8 +++-----
 fs/ceph/inode.c |  5 ++---
 fs/ceph/locks.c |  2 +-
 fs/ceph/quota.c | 10 +++++-----
 fs/ceph/snap.c  |  2 +-
 fs/ceph/super.h |  6 ++++++
 8 files changed, 26 insertions(+), 30 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 55ccccf77cea..0120fcb3503e 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1906,9 +1906,8 @@ bool __ceph_should_report_size(struct ceph_inode_info *ci)
 void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 		     struct ceph_mds_session *session)
 {
-	struct ceph_fs_client *fsc = ceph_inode_to_client(&ci->vfs_inode);
-	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct inode *inode = &ci->vfs_inode;
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
 	struct ceph_cap *cap;
 	u64 flush_tid, oldest_flush_tid;
 	int file_wanted, used, cap_used;
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 060bdcc5ce32..f7c0de3f41b5 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -38,8 +38,7 @@ static int __dir_lease_try_check(const struct dentry *dentry);
 static int ceph_d_init(struct dentry *dentry)
 {
 	struct ceph_dentry_info *di;
-	struct ceph_fs_client *fsc = ceph_sb_to_client(dentry->d_sb);
-	struct ceph_mds_client *mdsc = fsc->mdsc;
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dentry->d_sb);
 
 	di = kmem_cache_zalloc(ceph_dentry_cachep, GFP_KERNEL);
 	if (!di)
@@ -743,7 +742,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 				  unsigned int flags)
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
-	struct ceph_mds_client *mdsc = fsc->mdsc;
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
 	struct ceph_mds_request *req;
 	int op;
 	int mask;
@@ -832,8 +831,7 @@ int ceph_handle_notrace_create(struct inode *dir, struct dentry *dentry)
 static int ceph_mknod(struct inode *dir, struct dentry *dentry,
 		      umode_t mode, dev_t rdev)
 {
-	struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
-	struct ceph_mds_client *mdsc = fsc->mdsc;
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
 	struct ceph_mds_request *req;
 	struct ceph_acl_sec_ctx as_ctx = {};
 	int err;
@@ -894,8 +892,7 @@ static int ceph_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 static int ceph_symlink(struct inode *dir, struct dentry *dentry,
 			    const char *dest)
 {
-	struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
-	struct ceph_mds_client *mdsc = fsc->mdsc;
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
 	struct ceph_mds_request *req;
 	struct ceph_acl_sec_ctx as_ctx = {};
 	int err;
@@ -947,8 +944,7 @@ static int ceph_symlink(struct inode *dir, struct dentry *dentry,
 
 static int ceph_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
-	struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
-	struct ceph_mds_client *mdsc = fsc->mdsc;
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
 	struct ceph_mds_request *req;
 	struct ceph_acl_sec_ctx as_ctx = {};
 	int err = -EROFS;
@@ -1015,8 +1011,7 @@ static int ceph_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 static int ceph_link(struct dentry *old_dentry, struct inode *dir,
 		     struct dentry *dentry)
 {
-	struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
-	struct ceph_mds_client *mdsc = fsc->mdsc;
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
 	struct ceph_mds_request *req;
 	int err;
 
@@ -1197,8 +1192,7 @@ static int ceph_rename(struct inode *old_dir, struct dentry *old_dentry,
 		       struct inode *new_dir, struct dentry *new_dentry,
 		       unsigned int flags)
 {
-	struct ceph_fs_client *fsc = ceph_sb_to_client(old_dir->i_sb);
-	struct ceph_mds_client *mdsc = fsc->mdsc;
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(old_dir->i_sb);
 	struct ceph_mds_request *req;
 	int op = CEPH_MDS_OP_RENAME;
 	int err;
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 04ab99c0223a..29ee5f2e394a 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -182,8 +182,7 @@ static void put_bvecs(struct bio_vec *bvecs, int num_bvecs, bool should_dirty)
 static struct ceph_mds_request *
 prepare_open_request(struct super_block *sb, int flags, int create_mode)
 {
-	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
-	struct ceph_mds_client *mdsc = fsc->mdsc;
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(sb);
 	struct ceph_mds_request *req;
 	int want_auth = USE_ANY_MDS;
 	int op = (flags & O_CREAT) ? CEPH_MDS_OP_CREATE : CEPH_MDS_OP_OPEN;
@@ -283,7 +282,7 @@ static int ceph_init_file(struct inode *inode, struct file *file, int fmode)
  */
 int ceph_renew_caps(struct inode *inode, int fmode)
 {
-	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_request *req;
 	int err, flags, wanted;
@@ -1050,8 +1049,7 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
 	struct inode *inode = req->r_inode;
 	struct ceph_aio_request *aio_req = req->r_priv;
 	struct ceph_osd_data *osd_data = osd_req_op_extent_osd_data(req, 0);
-	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
-	struct ceph_client_metric *metric = &fsc->mdsc->metric;
+	struct ceph_client_metric *metric = &ceph_sb_to_mdsc(inode->i_sb)->metric;
 
 	BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_BVECS);
 	BUG_ON(!osd_data->num_bvecs);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 357c937699d5..9210cd1e859d 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -559,8 +559,7 @@ void ceph_evict_inode(struct inode *inode)
 	 * caps in i_snap_caps.
 	 */
 	if (ci->i_snap_realm) {
-		struct ceph_mds_client *mdsc =
-					ceph_inode_to_client(inode)->mdsc;
+		struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
 		if (ceph_snap(inode) == CEPH_NOSNAP) {
 			struct ceph_snap_realm *realm = ci->i_snap_realm;
 			dout(" dropping residual ref to snap realm %p\n",
@@ -740,7 +739,7 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 		    struct ceph_mds_session *session, int cap_fmode,
 		    struct ceph_cap_reservation *caps_reservation)
 {
-	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
 	struct ceph_mds_reply_inode *info = iinfo->in;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	int issued, new_issued, info_caps;
diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index d6b9166e71e4..048a435a29be 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -63,7 +63,7 @@ static const struct file_lock_operations ceph_fl_lock_ops = {
 static int ceph_lock_message(u8 lock_type, u16 operation, struct inode *inode,
 			     int cmd, u8 wait, struct file_lock *fl)
 {
-	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
 	struct ceph_mds_request *req;
 	int err;
 	u64 length = 0;
diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
index 198ddde5c1e6..4d3529f92091 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -12,7 +12,7 @@
 
 void ceph_adjust_quota_realms_count(struct inode *inode, bool inc)
 {
-	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
 	if (inc)
 		atomic64_inc(&mdsc->quotarealms_count);
 	else
@@ -21,8 +21,8 @@ void ceph_adjust_quota_realms_count(struct inode *inode, bool inc)
 
 static inline bool ceph_has_realms_with_quotas(struct inode *inode)
 {
-	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
-	struct super_block *sb = mdsc->fsc->sb;
+	struct super_block *sb = inode->i_sb;
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(sb);
 
 	if (atomic64_read(&mdsc->quotarealms_count) > 0)
 		return true;
@@ -266,7 +266,7 @@ static struct ceph_snap_realm *get_quota_realm(struct ceph_mds_client *mdsc,
 
 static bool ceph_quota_is_same_realm(struct inode *old, struct inode *new)
 {
-	struct ceph_mds_client *mdsc = ceph_inode_to_client(old)->mdsc;
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(old->i_sb);
 	struct ceph_snap_realm *old_realm, *new_realm;
 	bool is_same;
 
@@ -313,7 +313,7 @@ enum quota_check_op {
 static bool check_quota_exceeded(struct inode *inode, enum quota_check_op op,
 				 loff_t delta)
 {
-	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
 	struct ceph_inode_info *ci;
 	struct ceph_snap_realm *realm, *next;
 	struct inode *in;
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 923be9399b21..0da39c16dab4 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -602,7 +602,7 @@ int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
 			    struct ceph_cap_snap *capsnap)
 {
 	struct inode *inode = &ci->vfs_inode;
-	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
 
 	BUG_ON(capsnap->writing);
 	capsnap->size = inode->i_size;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 4c3c964b1c54..cd4137b47c2b 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -451,6 +451,12 @@ ceph_sb_to_client(const struct super_block *sb)
 	return (struct ceph_fs_client *)sb->s_fs_info;
 }
 
+static inline struct ceph_mds_client *
+ceph_sb_to_mdsc(const struct super_block *sb)
+{
+	return (struct ceph_mds_client *)ceph_sb_to_client(sb)->mdsc;
+}
+
 static inline struct ceph_vino
 ceph_vino(const struct inode *inode)
 {
-- 
2.18.4

