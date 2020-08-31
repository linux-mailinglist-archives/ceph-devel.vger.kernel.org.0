Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69CEE257922
	for <lists+ceph-devel@lfdr.de>; Mon, 31 Aug 2020 14:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgHaMZN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 31 Aug 2020 08:25:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgHaMZL (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 31 Aug 2020 08:25:11 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB364207DA;
        Mon, 31 Aug 2020 12:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598876709;
        bh=GgQi27HXfvC3uw6ryzzOlFBCaURY31xnKoMV0zlKl/8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FBmlu14IHnZu/FSVIq5nKCaIkr9Gto2jucxnm7wdc+maSEnL59Qkj9uz5+C8yDQjR
         TopkSX/xtsF3v2lFquCHmtxH1m6d3mjuUYAftFyekW0M/PevpgAooCUpAW3LbVUANz
         2MGOobSTnYA+wyemCjW7cQxdmMDWSDAimIKLBTw4=
Message-ID: <3dd9d16f9d1ad67ebb9fd402895b7657017c1b75.camel@kernel.org>
Subject: Re: [PATCH v4 1/2] ceph: add helpers for parsing inode/ci/sb to mdsc
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Mon, 31 Aug 2020 08:25:07 -0400
In-Reply-To: <20200828021336.99898-2-xiubli@redhat.com>
References: <20200828021336.99898-1-xiubli@redhat.com>
         <20200828021336.99898-2-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-08-27 at 22:13 -0400, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> This will help simplify the code.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c  |  3 +--
>  fs/ceph/dir.c   | 22 ++++++++--------------
>  fs/ceph/file.c  | 12 +++++-------
>  fs/ceph/inode.c | 10 ++++------
>  fs/ceph/ioctl.c |  6 +++---
>  fs/ceph/locks.c |  2 +-
>  fs/ceph/quota.c |  8 ++++----
>  fs/ceph/snap.c  |  2 +-
>  fs/ceph/super.h | 24 ++++++++++++++++++++++++
>  fs/ceph/xattr.c |  2 +-
>  10 files changed, 52 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 55ccccf77cea..ad69c411afba 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1906,8 +1906,7 @@ bool __ceph_should_report_size(struct ceph_inode_info *ci)
>  void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>  		     struct ceph_mds_session *session)
>  {
> -	struct ceph_fs_client *fsc = ceph_inode_to_client(&ci->vfs_inode);
> -	struct ceph_mds_client *mdsc = fsc->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_ci_to_mdsc(ci);
>  	struct inode *inode = &ci->vfs_inode;
>  	struct ceph_cap *cap;
>  	u64 flush_tid, oldest_flush_tid;
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 060bdcc5ce32..ef0aafb37496 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -38,8 +38,7 @@ static int __dir_lease_try_check(const struct dentry *dentry);
>  static int ceph_d_init(struct dentry *dentry)
>  {
>  	struct ceph_dentry_info *di;
> -	struct ceph_fs_client *fsc = ceph_sb_to_client(dentry->d_sb);
> -	struct ceph_mds_client *mdsc = fsc->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dentry->d_sb);
>  
>  	di = kmem_cache_zalloc(ceph_dentry_cachep, GFP_KERNEL);
>  	if (!di)
> @@ -311,7 +310,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>  	struct inode *inode = file_inode(file);
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> -	struct ceph_mds_client *mdsc = fsc->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_inode_to_mdsc(inode);
>  	int i;
>  	int err;
>  	unsigned frag = -1;
> @@ -743,7 +742,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
>  				  unsigned int flags)
>  {
>  	struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
> -	struct ceph_mds_client *mdsc = fsc->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
>  	struct ceph_mds_request *req;
>  	int op;
>  	int mask;
> @@ -832,8 +831,7 @@ int ceph_handle_notrace_create(struct inode *dir, struct dentry *dentry)
>  static int ceph_mknod(struct inode *dir, struct dentry *dentry,
>  		      umode_t mode, dev_t rdev)
>  {
> -	struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
> -	struct ceph_mds_client *mdsc = fsc->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
>  	struct ceph_mds_request *req;
>  	struct ceph_acl_sec_ctx as_ctx = {};
>  	int err;
> @@ -894,8 +892,7 @@ static int ceph_create(struct inode *dir, struct dentry *dentry, umode_t mode,
>  static int ceph_symlink(struct inode *dir, struct dentry *dentry,
>  			    const char *dest)
>  {
> -	struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
> -	struct ceph_mds_client *mdsc = fsc->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
>  	struct ceph_mds_request *req;
>  	struct ceph_acl_sec_ctx as_ctx = {};
>  	int err;
> @@ -947,8 +944,7 @@ static int ceph_symlink(struct inode *dir, struct dentry *dentry,
>  
>  static int ceph_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
>  {
> -	struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
> -	struct ceph_mds_client *mdsc = fsc->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
>  	struct ceph_mds_request *req;
>  	struct ceph_acl_sec_ctx as_ctx = {};
>  	int err = -EROFS;
> @@ -1015,8 +1011,7 @@ static int ceph_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
>  static int ceph_link(struct dentry *old_dentry, struct inode *dir,
>  		     struct dentry *dentry)
>  {
> -	struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
> -	struct ceph_mds_client *mdsc = fsc->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
>  	struct ceph_mds_request *req;
>  	int err;
>  
> @@ -1197,8 +1192,7 @@ static int ceph_rename(struct inode *old_dir, struct dentry *old_dentry,
>  		       struct inode *new_dir, struct dentry *new_dentry,
>  		       unsigned int flags)
>  {
> -	struct ceph_fs_client *fsc = ceph_sb_to_client(old_dir->i_sb);
> -	struct ceph_mds_client *mdsc = fsc->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(old_dir->i_sb);
>  	struct ceph_mds_request *req;
>  	int op = CEPH_MDS_OP_RENAME;
>  	int err;
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 04ab99c0223a..c788cce7885b 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -182,8 +182,7 @@ static void put_bvecs(struct bio_vec *bvecs, int num_bvecs, bool should_dirty)
>  static struct ceph_mds_request *
>  prepare_open_request(struct super_block *sb, int flags, int create_mode)
>  {
> -	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
> -	struct ceph_mds_client *mdsc = fsc->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(sb);
>  	struct ceph_mds_request *req;
>  	int want_auth = USE_ANY_MDS;
>  	int op = (flags & O_CREAT) ? CEPH_MDS_OP_CREATE : CEPH_MDS_OP_OPEN;
> @@ -283,7 +282,7 @@ static int ceph_init_file(struct inode *inode, struct file *file, int fmode)
>   */
>  int ceph_renew_caps(struct inode *inode, int fmode)
>  {
> -	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_inode_to_mdsc(inode);
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_mds_request *req;
>  	int err, flags, wanted;
> @@ -340,8 +339,7 @@ int ceph_renew_caps(struct inode *inode, int fmode)
>  int ceph_open(struct inode *inode, struct file *file)
>  {
>  	struct ceph_inode_info *ci = ceph_inode(inode);
> -	struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
> -	struct ceph_mds_client *mdsc = fsc->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_inode_to_mdsc(inode);
>  	struct ceph_mds_request *req;
>  	struct ceph_file_info *fi = file->private_data;
>  	int err;
> @@ -1050,8 +1048,8 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
>  	struct inode *inode = req->r_inode;
>  	struct ceph_aio_request *aio_req = req->r_priv;
>  	struct ceph_osd_data *osd_data = osd_req_op_extent_osd_data(req, 0);
> -	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> -	struct ceph_client_metric *metric = &fsc->mdsc->metric;
> +	struct ceph_mds_client *mdsc = ceph_inode_to_mdsc(inode);
> +	struct ceph_client_metric *metric = &mdsc->metric;
>  
>  	BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_BVECS);
>  	BUG_ON(!osd_data->num_bvecs);
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 357c937699d5..39b1007903d9 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -559,8 +559,7 @@ void ceph_evict_inode(struct inode *inode)
>  	 * caps in i_snap_caps.
>  	 */
>  	if (ci->i_snap_realm) {
> -		struct ceph_mds_client *mdsc =
> -					ceph_inode_to_client(inode)->mdsc;
> +		struct ceph_mds_client *mdsc = ceph_inode_to_mdsc(inode);
>  		if (ceph_snap(inode) == CEPH_NOSNAP) {
>  			struct ceph_snap_realm *realm = ci->i_snap_realm;
>  			dout(" dropping residual ref to snap realm %p\n",
> @@ -740,7 +739,7 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
>  		    struct ceph_mds_session *session, int cap_fmode,
>  		    struct ceph_cap_reservation *caps_reservation)
>  {
> -	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_inode_to_mdsc(inode);
>  	struct ceph_mds_reply_inode *info = iinfo->in;
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	int issued, new_issued, info_caps;
> @@ -2027,7 +2026,7 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr)
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	unsigned int ia_valid = attr->ia_valid;
>  	struct ceph_mds_request *req;
> -	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_inode_to_mdsc(inode);
>  	struct ceph_cap_flush *prealloc_cf;
>  	int issued;
>  	int release = 0, dirtied = 0;
> @@ -2275,8 +2274,7 @@ int ceph_setattr(struct dentry *dentry, struct iattr *attr)
>  int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
>  		      int mask, bool force)
>  {
> -	struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
> -	struct ceph_mds_client *mdsc = fsc->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_inode_to_mdsc(inode);
>  	struct ceph_mds_request *req;
>  	int mode;
>  	int err;
> diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
> index 6e061bf62ad4..b4563bfce9e3 100644
> --- a/fs/ceph/ioctl.c
> +++ b/fs/ceph/ioctl.c
> @@ -64,7 +64,7 @@ static long __validate_layout(struct ceph_mds_client *mdsc,
>  static long ceph_ioctl_set_layout(struct file *file, void __user *arg)
>  {
>  	struct inode *inode = file_inode(file);
> -	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_inode_to_mdsc(inode);
>  	struct ceph_mds_request *req;
>  	struct ceph_ioctl_layout l;
>  	struct ceph_inode_info *ci = ceph_inode(file_inode(file));
> @@ -139,7 +139,7 @@ static long ceph_ioctl_set_layout_policy (struct file *file, void __user *arg)
>  	struct ceph_mds_request *req;
>  	struct ceph_ioctl_layout l;
>  	int err;
> -	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_inode_to_mdsc(inode);
>  
>  	/* copy and validate */
>  	if (copy_from_user(&l, arg, sizeof(l)))
> @@ -243,7 +243,7 @@ static long ceph_ioctl_lazyio(struct file *file)
>  	struct ceph_file_info *fi = file->private_data;
>  	struct inode *inode = file_inode(file);
>  	struct ceph_inode_info *ci = ceph_inode(inode);
> -	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_inode_to_mdsc(inode);
>  
>  	if ((fi->fmode & CEPH_FILE_MODE_LAZY) == 0) {
>  		spin_lock(&ci->i_ceph_lock);
> diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
> index d6b9166e71e4..6f00ed6a61ab 100644
> --- a/fs/ceph/locks.c
> +++ b/fs/ceph/locks.c
> @@ -63,7 +63,7 @@ static const struct file_lock_operations ceph_fl_lock_ops = {
>  static int ceph_lock_message(u8 lock_type, u16 operation, struct inode *inode,
>  			     int cmd, u8 wait, struct file_lock *fl)
>  {
> -	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_inode_to_mdsc(inode);
>  	struct ceph_mds_request *req;
>  	int err;
>  	u64 length = 0;
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index 198ddde5c1e6..b5f3df952f0a 100644
> --- a/fs/ceph/quota.c
> +++ b/fs/ceph/quota.c
> @@ -12,7 +12,7 @@
>  
>  void ceph_adjust_quota_realms_count(struct inode *inode, bool inc)
>  {
> -	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_inode_to_mdsc(inode);
>  	if (inc)
>  		atomic64_inc(&mdsc->quotarealms_count);
>  	else
> @@ -21,7 +21,7 @@ void ceph_adjust_quota_realms_count(struct inode *inode, bool inc)
>  
>  static inline bool ceph_has_realms_with_quotas(struct inode *inode)
>  {
> -	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_inode_to_mdsc(inode);
>  	struct super_block *sb = mdsc->fsc->sb;
>  
>  	if (atomic64_read(&mdsc->quotarealms_count) > 0)
> @@ -266,7 +266,7 @@ static struct ceph_snap_realm *get_quota_realm(struct ceph_mds_client *mdsc,
>  
>  static bool ceph_quota_is_same_realm(struct inode *old, struct inode *new)
>  {
> -	struct ceph_mds_client *mdsc = ceph_inode_to_client(old)->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_inode_to_mdsc(old);
>  	struct ceph_snap_realm *old_realm, *new_realm;
>  	bool is_same;
>  
> @@ -313,7 +313,7 @@ enum quota_check_op {
>  static bool check_quota_exceeded(struct inode *inode, enum quota_check_op op,
>  				 loff_t delta)
>  {
> -	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_inode_to_mdsc(inode);
>  	struct ceph_inode_info *ci;
>  	struct ceph_snap_realm *realm, *next;
>  	struct inode *in;
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 923be9399b21..958e13d5cdc0 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -602,7 +602,7 @@ int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
>  			    struct ceph_cap_snap *capsnap)
>  {
>  	struct inode *inode = &ci->vfs_inode;
> -	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_inode_to_mdsc(inode);
>  
>  	BUG_ON(capsnap->writing);
>  	capsnap->size = inode->i_size;
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 4c3c964b1c54..476d182c2ff0 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -451,6 +451,30 @@ ceph_sb_to_client(const struct super_block *sb)
>  	return (struct ceph_fs_client *)sb->s_fs_info;
>  }
>  
> +static inline struct ceph_fs_client *
> +ceph_ci_to_client(const struct ceph_inode_info *ci)
> +{
> +	return (struct ceph_fs_client *)ci->vfs_inode.i_sb->s_fs_info;
> +}
> +
> +static inline struct ceph_mds_client *
> +ceph_inode_to_mdsc(const struct inode *inode)
> +{
> +	return (struct ceph_mds_client *)ceph_inode_to_client(inode)->mdsc;
> +}
> +
> +static inline struct ceph_mds_client *
> +ceph_sb_to_mdsc(const struct super_block *sb)
> +{
> +	return (struct ceph_mds_client *)ceph_sb_to_client(sb)->mdsc;
> +}
> +
> +static inline struct ceph_mds_client *
> +ceph_ci_to_mdsc(const struct ceph_inode_info *ci)
> +{
> +	return (struct ceph_mds_client *)ceph_ci_to_client(ci)->mdsc;
> +}
> +

These sorts of cleanup patches are a pain for backports and I don't
think this really materially improves the code enough to make that
worthwhile. 

Also, this seems a bit like overkill -- 3 functions to get the mdsc from
various other structures? Maybe instead just keep ceph_sb_to_mdsc and
have all of these places call that after dereferencing the sb.

IOW, instead of:

    mdsc = ceph_ci_to_mdsc(ci);

...do this?

    mdsc = ceph_sb_to_mdsc(ci->vfs_inode.i_sb);

>  static inline struct ceph_vino
>  ceph_vino(const struct inode *inode)
>  {
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 3a733ac33d9b..9d9d9b766a11 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -1012,7 +1012,7 @@ int __ceph_setxattr(struct inode *inode, const char *name,
>  {
>  	struct ceph_vxattr *vxattr;
>  	struct ceph_inode_info *ci = ceph_inode(inode);
> -	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
> +	struct ceph_mds_client *mdsc = ceph_inode_to_mdsc(inode);
>  	struct ceph_cap_flush *prealloc_cf = NULL;
>  	struct ceph_buffer *old_blob = NULL;
>  	int issued;

-- 
Jeff Layton <jlayton@kernel.org>

