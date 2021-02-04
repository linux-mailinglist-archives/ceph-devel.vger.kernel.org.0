Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0D930F356
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Feb 2021 13:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236027AbhBDMoR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 Feb 2021 07:44:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:55046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235888AbhBDMoP (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 4 Feb 2021 07:44:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E66364F41;
        Thu,  4 Feb 2021 12:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612442613;
        bh=0Bl5sCuBq9eLjHUfp7MVQm5vlZu7Hm0NLBQa2oMkHpU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nKSB5kNTJ06y14lnwZKMEPzfw/jj0lQCX6nEzPJyWM6fKKczwhF9cPuif/i/GLWz2
         WdMXFVQVtbQAqf5efhmAzpq1UatncGhVRuTrE81FFkpPuALUPedltipBLhbRbw51uK
         8ECtve5eDfwuTBKm2wOqiDXKQHLlVTnNmSA5rionGwf023PzwwvmuINuhbwB8IG1HH
         lyJCpejLFBbB2QyqNWqLqIfa4f5QSdsIi2MYn5qckLgOhhAJDOEz34mkpkQLcWkXEr
         EecFkiDVlEOXmB20yToTZCig3MJDaxEXTqj9HtkxBIyCKJDuz6PYHtJr7ycbaMDEye
         3+0L3Z8Um3mHQ==
Message-ID: <f0b85edd381c9d111da5dacc3d9bd25490863e66.camel@kernel.org>
Subject: Re: [PATCH] ceph: minor coding style tweaks
From:   Jeff Layton <jlayton@kernel.org>
To:     Zhiyuan Dai <daizhiyuan@phytium.com.cn>, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 04 Feb 2021 07:43:31 -0500
In-Reply-To: <1612425294-7037-1-git-send-email-daizhiyuan@phytium.com.cn>
References: <1612425294-7037-1-git-send-email-daizhiyuan@phytium.com.cn>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-02-04 at 15:54 +0800, Zhiyuan Dai wrote:
> Fixed some coding style issues, improve code reading.
> 1. Move the pointer location
> 2. Move brace position
> 3. Alignment to open parenthesis
> 
> This patch adds whitespace to clearly separate the parameters.
> 
> Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
> ---
>  fs/ceph/addr.c       |  3 +--
>  fs/ceph/cache.c      | 14 +++++++-------
>  fs/ceph/caps.c       |  2 +-
>  fs/ceph/dir.c        |  6 +++---
>  fs/ceph/export.c     |  2 +-
>  fs/ceph/inode.c      |  6 +++---
>  fs/ceph/locks.c      |  2 +-
>  fs/ceph/mds_client.c |  8 ++++----
>  fs/ceph/mdsmap.c     |  4 ++--
>  fs/ceph/snap.c       |  6 +++---
>  fs/ceph/xattr.c      |  4 ++--
>  11 files changed, 28 insertions(+), 29 deletions(-)
> 


While I appreciate the effort, it has been my experience that coding-
style cleanup patches tend to be more trouble than they are worth. They
can make backporting hard by introducing trivial merge conflicts that
have to be resolved.

If you happen to be doing substantive work in an area, then by all
means, go ahead and clean up the coding style in that area, but this
sort of patch isn't terribly helpful. I'm going to plan to not merge
this unless you can articulate a very good reason to do so.

Thanks,
Jeff

> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 9505529..94ce73e 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -493,8 +493,7 @@ static int ceph_readpages(struct file *file, struct address_space *mapping,
>  	return rc;
>  }
>  
> 
> 
> 
> -struct ceph_writeback_ctl
> -{
> +struct ceph_writeback_ctl {
>  	loff_t i_size;
>  	u64 truncate_size;
>  	u32 truncate_seq;
> diff --git a/fs/ceph/cache.c b/fs/ceph/cache.c
> index 2f5cb6b..795523e 100644
> --- a/fs/ceph/cache.c
> +++ b/fs/ceph/cache.c
> @@ -50,7 +50,7 @@ void ceph_fscache_unregister(void)
>  	fscache_unregister_netfs(&ceph_cache_netfs);
>  }
>  
> 
> 
> 
> -int ceph_fscache_register_fs(struct ceph_fs_client* fsc, struct fs_context *fc)
> +int ceph_fscache_register_fs(struct ceph_fs_client *fsc, struct fs_context *fc)
>  {
>  	const struct ceph_fsid *fsid = &fsc->client->fsid;
>  	const char *fscache_uniq = fsc->mount_options->fscache_uniq;
> @@ -110,8 +110,8 @@ static enum fscache_checkaux ceph_fscache_inode_check_aux(
>  	loff_t object_size)
>  {
>  	struct ceph_aux_inode aux;
> -	struct ceph_inode_info* ci = cookie_netfs_data;
> -	struct inode* inode = &ci->vfs_inode;
> +	struct ceph_inode_info *ci = cookie_netfs_data;
> +	struct inode *inode = &ci->vfs_inode;
>  
> 
> 
> 
>  	if (dlen != sizeof(aux) ||
>  	    i_size_read(inode) != object_size)
> @@ -164,9 +164,9 @@ void ceph_fscache_register_inode_cookie(struct inode *inode)
>  	inode_unlock(inode);
>  }
>  
> 
> 
> 
> -void ceph_fscache_unregister_inode_cookie(struct ceph_inode_info* ci)
> +void ceph_fscache_unregister_inode_cookie(struct ceph_inode_info *ci)
>  {
> -	struct fscache_cookie* cookie;
> +	struct fscache_cookie *cookie;
>  
> 
> 
> 
>  	if ((cookie = ci->fscache) == NULL)
>  		return;
> @@ -296,7 +296,7 @@ void ceph_readpage_to_fscache(struct inode *inode, struct page *page)
>  		 fscache_uncache_page(ci->fscache, page);
>  }
>  
> 
> 
> 
> -void ceph_invalidate_fscache_page(struct inode* inode, struct page *page)
> +void ceph_invalidate_fscache_page(struct inode *inode, struct page *page)
>  {
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  
> 
> 
> 
> @@ -307,7 +307,7 @@ void ceph_invalidate_fscache_page(struct inode* inode, struct page *page)
>  	fscache_uncache_page(ci->fscache, page);
>  }
>  
> 
> 
> 
> -void ceph_fscache_unregister_fs(struct ceph_fs_client* fsc)
> +void ceph_fscache_unregister_fs(struct ceph_fs_client *fsc)
>  {
>  	if (fscache_cookie_valid(fsc->fscache)) {
>  		struct ceph_fscache_entry *ent;
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 255a512..39fe5d8 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2270,7 +2270,7 @@ static int caps_are_flushed(struct inode *inode, u64 flush_tid)
>  
> 
> 
> 
>  	spin_lock(&ci->i_ceph_lock);
>  	if (!list_empty(&ci->i_cap_flush_list)) {
> -		struct ceph_cap_flush * cf =
> +		struct ceph_cap_flush *cf =
>  			list_first_entry(&ci->i_cap_flush_list,
>  					 struct ceph_cap_flush, i_list);
>  		if (cf->tid <= flush_tid)
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 858ee73..2b7edd00 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -1269,7 +1269,7 @@ void __ceph_dentry_lease_touch(struct ceph_dentry_info *di)
>  	spin_unlock(&mdsc->dentry_list_lock);
>  }
>  
> 
> 
> 
> -static void __dentry_dir_lease_touch(struct ceph_mds_client* mdsc,
> +static void __dentry_dir_lease_touch(struct ceph_mds_client *mdsc,
>  				     struct ceph_dentry_info *di)
>  {
>  	di->flags &= ~(CEPH_DENTRY_LEASE_LIST | CEPH_DENTRY_REFERENCED);
> @@ -1351,7 +1351,7 @@ struct ceph_lease_walk_control {
>  {
>  	struct ceph_dentry_info *di, *tmp;
>  	struct dentry *dentry, *last = NULL;
> -	struct list_head* list;
> +	struct list_head *list;
>          LIST_HEAD(dispose);
>  	unsigned long freed = 0;
>  	int ret = 0;
> @@ -1498,7 +1498,7 @@ int ceph_trim_dentries(struct ceph_mds_client *mdsc)
>  	lwc.dir_lease = true;
>  	lwc.expire_dir_lease = freed < count;
>  	lwc.dir_lease_ttl = mdsc->fsc->mount_options->caps_wanted_delay_max * HZ;
> -	freed +=__dentry_leases_walk(mdsc, &lwc, __dir_lease_check);
> +	freed += __dentry_leases_walk(mdsc, &lwc, __dir_lease_check);
>  	if (!lwc.nr_to_scan) /* more to check */
>  		return -EAGAIN;
>  
> 
> 
> 
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index e088843..83ec43f 100644
> --- a/fs/ceph/export.c
> +++ b/fs/ceph/export.c
> @@ -343,7 +343,7 @@ static struct dentry *ceph_get_parent(struct dentry *child)
>  	struct dentry *dn;
>  
> 
> 
> 
>  	if (ceph_snap(inode) != CEPH_NOSNAP) {
> -		struct inode* dir;
> +		struct inode *dir;
>  		bool unlinked = false;
>  		/* do not support non-directory */
>  		if (!d_is_dir(child)) {
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index adc8fc3..a580ce2 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -309,8 +309,8 @@ static int ceph_fill_dirfrag(struct inode *inode,
>  
> 
> 
> 
>  static int frag_tree_split_cmp(const void *l, const void *r)
>  {
> -	struct ceph_frag_tree_split *ls = (struct ceph_frag_tree_split*)l;
> -	struct ceph_frag_tree_split *rs = (struct ceph_frag_tree_split*)r;
> +	struct ceph_frag_tree_split *ls = (struct ceph_frag_tree_split *)l;
> +	struct ceph_frag_tree_split *rs = (struct ceph_frag_tree_split *)r;
>  	return ceph_frag_compare(le32_to_cpu(ls->frag),
>  				 le32_to_cpu(rs->frag));
>  }
> @@ -1550,7 +1550,7 @@ static int fill_readdir_cache(struct inode *dir, struct dentry *dn,
>  			      struct ceph_mds_request *req)
>  {
>  	struct ceph_inode_info *ci = ceph_inode(dir);
> -	unsigned nsize = PAGE_SIZE / sizeof(struct dentry*);
> +	unsigned nsize = PAGE_SIZE / sizeof(struct dentry *);
>  	unsigned idx = ctl->index % nsize;
>  	pgoff_t pgoff = ctl->index / nsize;
>  
> 
> 
> 
> diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
> index fa8a847..9b5ce10 100644
> --- a/fs/ceph/locks.c
> +++ b/fs/ceph/locks.c
> @@ -128,7 +128,7 @@ static int ceph_lock_message(u8 lock_type, u16 operation, struct inode *inode,
>  		length = le64_to_cpu(req->r_reply_info.filelock_reply->start) +
>  						 le64_to_cpu(req->r_reply_info.filelock_reply->length);
>  		if (length >= 1)
> -			fl->fl_end = length -1;
> +			fl->fl_end = length - 1;
>  		else
>  			fl->fl_end = 0;
>  
> 
> 
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index d87bd85..626adcb 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1177,7 +1177,7 @@ static int encode_supported_features(void **p, void *end)
>  		ceph_encode_32(p, size);
>  		memset(*p, 0, size);
>  		for (i = 0; i < count; i++)
> -			((unsigned char*)(*p))[i / 8] |= BIT(feature_bits[i] % 8);
> +			((unsigned char *)(*p))[i / 8] |= BIT(feature_bits[i] % 8);
>  		*p += size;
>  	} else {
>  		if (WARN_ON_ONCE(*p + 4 > end))
> @@ -1248,7 +1248,7 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
>  	void *p, *end;
>  	int ret;
>  
> 
> 
> 
> -	const char* metadata[][2] = {
> +	const char *metadata[][2] = {
>  		{"hostname", mdsc->nodename},
>  		{"kernel_version", init_utsname()->release},
>  		{"entity_id", opt->name ? : ""},
> @@ -2237,7 +2237,7 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
>  
> 
> 
> 
>  	order = get_order(size * num_entries);
>  	while (order >= 0) {
> -		rinfo->dir_entries = (void*)__get_free_pages(GFP_KERNEL |
> +		rinfo->dir_entries = (void *)__get_free_pages(GFP_KERNEL |
>  							     __GFP_NOWARN,
>  							     order);
>  		if (rinfo->dir_entries)
> @@ -3681,7 +3681,7 @@ static int send_reconnect_partial(struct ceph_reconnect_state *recon_state)
>  	return err;
>  }
>  
> 
> 
> 
> -static struct dentry* d_find_primary(struct inode *inode)
> +static struct dentry *d_find_primary(struct inode *inode)
>  {
>  	struct dentry *alias, *dn = NULL;
>  
> 
> 
> 
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index abd9af7..775f063 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -82,7 +82,7 @@ int ceph_mdsmap_get_random_mds(struct ceph_mdsmap *m)
>  	} while (0)
>  
> 
> 
> 
>  
> 
> 
> 
> -static int __decode_and_drop_compat_set(void **p, void* end)
> +static int __decode_and_drop_compat_set(void **p, void *end)
>  {
>  	int i;
>  	/* compat, ro_compat, incompat*/
> @@ -185,7 +185,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
>  
> 
> 
> 
>  		ceph_decode_need(p, end, sizeof(u64) + 1, bad);
>  		global_id = ceph_decode_64(p);
> -		info_v= ceph_decode_8(p);
> +		info_v = ceph_decode_8(p);
>  		if (info_v >= 4) {
>  			u32 info_len;
>  			ceph_decode_need(p, end, 1 + sizeof(u32), bad);
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index b611f82..b29ccf9 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -306,7 +306,7 @@ static int cmpu64_rev(const void *a, const void *b)
>   * build the snap context for a given realm.
>   */
>  static int build_snap_context(struct ceph_snap_realm *realm,
> -			      struct list_head* dirty_realms)
> +			      struct list_head *dirty_realms)
>  {
>  	struct ceph_snap_realm *parent = realm->parent;
>  	struct ceph_snap_context *snapc;
> @@ -1007,7 +1007,7 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>  	return;
>  }
>  
> 
> 
> 
> -struct ceph_snapid_map* ceph_get_snapid_map(struct ceph_mds_client *mdsc,
> +struct ceph_snapid_map *ceph_get_snapid_map(struct ceph_mds_client *mdsc,
>  					    u64 snap)
>  {
>  	struct ceph_snapid_map *sm, *exist;
> @@ -1084,7 +1084,7 @@ struct ceph_snapid_map* ceph_get_snapid_map(struct ceph_mds_client *mdsc,
>  	return sm;
>  }
>  
> 
> 
> 
> -void ceph_put_snapid_map(struct ceph_mds_client* mdsc,
> +void ceph_put_snapid_map(struct ceph_mds_client *mdsc,
>  			 struct ceph_snapid_map *sm)
>  {
>  	if (!sm)
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 2499798..69be858 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -1319,12 +1319,12 @@ int ceph_security_init_secctx(struct dentry *dentry, umode_t mode,
>  		/* update count of KV pairs */
>  		BUG_ON(pagelist->length <= sizeof(__le32));
>  		if (list_is_singular(&pagelist->head)) {
> -			le32_add_cpu((__le32*)pagelist->mapped_tail, 1);
> +			le32_add_cpu((__le32 *)pagelist->mapped_tail, 1);
>  		} else {
>  			struct page *page = list_first_entry(&pagelist->head,
>  							     struct page, lru);
>  			void *addr = kmap_atomic(page);
> -			le32_add_cpu((__le32*)addr, 1);
> +			le32_add_cpu((__le32 *)addr, 1);
>  			kunmap_atomic(addr);
>  		}
>  	} else {

-- 
Jeff Layton <jlayton@kernel.org>

