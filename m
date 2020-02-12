Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C482915A87E
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Feb 2020 13:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgBLMBb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Feb 2020 07:01:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:57018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728032AbgBLMBb (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 Feb 2020 07:01:31 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CACA20848;
        Wed, 12 Feb 2020 12:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581508889;
        bh=dS+0gSACDWQuKIVfgf7ZyL10srX3Q45HcpEbKtObJ+c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=O9+Cq2A0+x+rjHv9j5pxo2LFK3e1WBw82cJpTWbW9gs0i92bmZtWUj4G0kyKYS5NQ
         thfH6HQ1ffhYWB8LpWbbj93eSjmOwzmkMy5QviyA3VV7sU+Kn8kqaZqqEvq0fz45ua
         Rxx6SaYrULTHc7v8MPbVP/7nbMMJTCjklkb3o/1E=
Message-ID: <c2571e75d3fe3f37ea77c5b1acaa5e3dcc45cb2b.camel@kernel.org>
Subject: Re: [PATCH] ceph: fs add reconfiguring superblock parameters support
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Wed, 12 Feb 2020 07:01:27 -0500
In-Reply-To: <20200212085454.35665-1-xiubli@redhat.com>
References: <20200212085454.35665-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-02-12 at 03:54 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> This will enable the remount and reconfiguring superblock params
> for the fs. Currently some mount options are not allowed to be
> reconfigured.
> 
> It will working like:
> $ mount.ceph :/ /mnt/cephfs -o remount,mount_timeout=100
> 
> URL:https://tracker.ceph.com/issues/44071
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  block/bfq-cgroup.c           |   1 +
>  drivers/block/rbd.c          |   2 +-
>  fs/ceph/caps.c               |   2 +
>  fs/ceph/mds_client.c         |   5 +-
>  fs/ceph/super.c              | 126 +++++++++++++++++++++++++++++------
>  fs/ceph/super.h              |   2 +
>  include/linux/ceph/libceph.h |   4 +-
>  net/ceph/ceph_common.c       |  83 ++++++++++++++++++++---
>  8 files changed, 192 insertions(+), 33 deletions(-)
> 
> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> index e1419edde2ec..b3d42200182e 100644
> --- a/block/bfq-cgroup.c
> +++ b/block/bfq-cgroup.c
> @@ -12,6 +12,7 @@
>  #include <linux/ioprio.h>
>  #include <linux/sbitmap.h>
>  #include <linux/delay.h>
> +#include <linux/rbtree.h>
>  
>  #include "bfq-iosched.h"
>  
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 4e494d5600cc..470de27cf809 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -6573,7 +6573,7 @@ static int rbd_add_parse_args(const char *buf,
>  	*(snap_name + len) = '\0';
>  	pctx.spec->snap_name = snap_name;
>  
> -	pctx.copts = ceph_alloc_options();
> +	pctx.copts = ceph_alloc_options(NULL);
>  	if (!pctx.copts)
>  		goto out_mem;
>  
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index b4f122eb74bb..020f83186f94 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -491,10 +491,12 @@ static void __cap_set_timeouts(struct ceph_mds_client *mdsc,
>  {
>  	struct ceph_mount_options *opt = mdsc->fsc->mount_options;
>  
> +	spin_lock(&opt->ceph_opt_lock);
>  	ci->i_hold_caps_min = round_jiffies(jiffies +
>  					    opt->caps_wanted_delay_min * HZ);
>  	ci->i_hold_caps_max = round_jiffies(jiffies +
>  					    opt->caps_wanted_delay_max * HZ);
> +	spin_unlock(&opt->ceph_opt_lock);
>  	dout("__cap_set_timeouts %p min %lu max %lu\n", &ci->vfs_inode,
>  	     ci->i_hold_caps_min - jiffies, ci->i_hold_caps_max - jiffies);
>  }
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 376e7cf1685f..451c3727cd0b 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2099,6 +2099,7 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
>  	struct ceph_inode_info *ci = ceph_inode(dir);
>  	struct ceph_mds_reply_info_parsed *rinfo = &req->r_reply_info;
>  	struct ceph_mount_options *opt = req->r_mdsc->fsc->mount_options;
> +	unsigned int max_readdir = opt->max_readdir;
>  	size_t size = sizeof(struct ceph_mds_reply_dir_entry);
>  	unsigned int num_entries;
>  	int order;
> @@ -2107,7 +2108,7 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
>  	num_entries = ci->i_files + ci->i_subdirs;
>  	spin_unlock(&ci->i_ceph_lock);
>  	num_entries = max(num_entries, 1U);
> -	num_entries = min(num_entries, opt->max_readdir);
> +	num_entries = min(num_entries, max_readdir);
>  
>  	order = get_order(size * num_entries);
>  	while (order >= 0) {
> @@ -2122,7 +2123,7 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
>  		return -ENOMEM;
>  
>  	num_entries = (PAGE_SIZE << order) / size;
> -	num_entries = min(num_entries, opt->max_readdir);
> +	num_entries = min(num_entries, max_readdir);
>  
>  	rinfo->dir_buf_size = PAGE_SIZE << order;
>  	req->r_num_caps = num_entries + 1;
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 9a21054059f2..8df506dd9039 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1175,7 +1175,57 @@ static void ceph_free_fc(struct fs_context *fc)
>  
>  static int ceph_reconfigure_fc(struct fs_context *fc)
>  {
> -	sync_filesystem(fc->root->d_sb);
> +	struct super_block *sb = fc->root->d_sb;
> +	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
> +	struct ceph_mount_options *fsopt = fsc->mount_options;
> +	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
> +	struct ceph_mount_options *new_fsopt = pctx->opts;
> +	int ret;
> +
> +	sync_filesystem(sb);
> +
> +	ret = ceph_reconfigure_copts(fc, pctx->copts, fsc->client->options);
> +	if (ret)
> +		return ret;
> +
> +	if (new_fsopt->snapdir_name != fsopt->snapdir_name)
> +		return invalf(fc, "ceph: reconfiguration of snapdir_name not allowed");
> +
> +	if (new_fsopt->mds_namespace != fsopt->mds_namespace)
> +		return invalf(fc, "ceph: reconfiguration of mds_namespace not allowed");
> +
> +	if (new_fsopt->wsize != fsopt->wsize)
> +		return invalf(fc, "ceph: reconfiguration of wsize not allowed");
> +	if (new_fsopt->rsize != fsopt->rsize)
> +		return invalf(fc, "ceph: reconfiguration of rsize not allowed");
> +	if (new_fsopt->rasize != fsopt->rasize)
> +		return invalf(fc, "ceph: reconfiguration of rasize not allowed");
> +

Odd. I would think the wsize, rsize and rasize are things you _could_
reconfigure at remount time.

In any case, I agree with Ilya. Not everything can be changed on a
remount. It'd be best to identify some small subset of mount options
that you do need to allow to be changed, and ensure we can do that.

> +#ifdef CONFIG_CEPH_FSCACHE
> +	if (strcmp_null(new_fsopt->fscache_uniq, fsopt->fscache_uniq))
> +		return invalf(fc, "ceph: reconfiguration of fscache not allowed");
> +#endif
> +
> +	fsopt->flags = new_fsopt->flags;
> +
> +	spin_lock(&fsopt->ceph_opt_lock);
> +	fsopt->caps_wanted_delay_min = new_fsopt->caps_wanted_delay_min;
> +	fsopt->caps_wanted_delay_max = new_fsopt->caps_wanted_delay_max;
> +	spin_unlock(&fsopt->ceph_opt_lock);
> +
> +	fsopt->max_readdir_bytes = new_fsopt->max_readdir_bytes;
> +	fsopt->congestion_kb = new_fsopt->congestion_kb;
> +
> +	fsopt->caps_max = new_fsopt->caps_max;
> +	fsopt->max_readdir = new_fsopt->max_readdir;
> +	ceph_adjust_caps_max_min(fsc->mdsc, fsopt);
> +
> +#ifdef CONFIG_CEPH_FS_POSIX_ACL
> +	if (fc->sb_flags & SB_POSIXACL)
> +		sb->s_flags |= SB_POSIXACL;
> +	else
> +		sb->s_flags &= ~SB_POSIXACL;
> +#endif
>  	return 0;
>  }
>  
> @@ -1193,38 +1243,77 @@ static int ceph_init_fs_context(struct fs_context *fc)
>  {
>  	struct ceph_parse_opts_ctx *pctx;
>  	struct ceph_mount_options *fsopt;
> +	struct ceph_options *copts = NULL;
>  
>  	pctx = kzalloc(sizeof(*pctx), GFP_KERNEL);
>  	if (!pctx)
>  		return -ENOMEM;
>  
> -	pctx->copts = ceph_alloc_options();
> -	if (!pctx->copts)
> -		goto nomem;
> -
>  	pctx->opts = kzalloc(sizeof(*pctx->opts), GFP_KERNEL);
>  	if (!pctx->opts)
>  		goto nomem;
>  
>  	fsopt = pctx->opts;
> -	fsopt->flags = CEPH_MOUNT_OPT_DEFAULT;
>  
> -	fsopt->wsize = CEPH_MAX_WRITE_SIZE;
> -	fsopt->rsize = CEPH_MAX_READ_SIZE;
> -	fsopt->rasize = CEPH_RASIZE_DEFAULT;
> -	fsopt->snapdir_name = kstrdup(CEPH_SNAPDIRNAME_DEFAULT, GFP_KERNEL);
> -	if (!fsopt->snapdir_name)
> -		goto nomem;
> +#ifdef CONFIG_CEPH_FS_POSIX_ACL
> +	fc->sb_flags |= SB_POSIXACL;
> +#endif
> +
> +	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
> +		struct super_block *sb = fc->root->d_sb;
> +		struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
> +		struct ceph_mount_options *old = fsc->mount_options;
> +
> +		copts = fsc->client->options;
> +
> +		fsopt->flags = old->flags;
>  
> -	fsopt->caps_wanted_delay_min = CEPH_CAPS_WANTED_DELAY_MIN_DEFAULT;
> -	fsopt->caps_wanted_delay_max = CEPH_CAPS_WANTED_DELAY_MAX_DEFAULT;
> -	fsopt->max_readdir = CEPH_MAX_READDIR_DEFAULT;
> -	fsopt->max_readdir_bytes = CEPH_MAX_READDIR_BYTES_DEFAULT;
> -	fsopt->congestion_kb = default_congestion_kb();
> +		fsopt->wsize = old->wsize;
> +		fsopt->rsize = old->rsize;
> +		fsopt->rasize = old->rasize;
> +
> +		fsopt->fscache_uniq = kstrdup(old->fscache_uniq, GFP_KERNEL);
> +		if (!fsopt->fscache_uniq)
> +			goto nomem;
> +
> +		fsopt->snapdir_name = kstrdup(old->snapdir_name, GFP_KERNEL);
> +		if (!fsopt->snapdir_name)
> +			goto nomem;
> +
> +		fsopt->caps_wanted_delay_min = old->caps_wanted_delay_min;
> +		fsopt->caps_wanted_delay_max = old->caps_wanted_delay_max;
> +		fsopt->max_readdir = old->max_readdir;
> +		fsopt->max_readdir_bytes = old->max_readdir_bytes;
> +		fsopt->congestion_kb = old->congestion_kb;
> +		fsopt->caps_max = old->caps_max;
> +		fsopt->max_readdir = old->max_readdir;
>  
>  #ifdef CONFIG_CEPH_FS_POSIX_ACL
> -	fc->sb_flags |= SB_POSIXACL;
> +		if (!(sb->s_flags & SB_POSIXACL))
> +			fc->sb_flags &= ~SB_POSIXACL;
>  #endif
> +	} else {
> +		fsopt->flags = CEPH_MOUNT_OPT_DEFAULT;
> +
> +		fsopt->wsize = CEPH_MAX_WRITE_SIZE;
> +		fsopt->rsize = CEPH_MAX_READ_SIZE;
> +		fsopt->rasize = CEPH_RASIZE_DEFAULT;
> +
> +		fsopt->snapdir_name = kstrdup(CEPH_SNAPDIRNAME_DEFAULT, GFP_KERNEL);
> +		if (!fsopt->snapdir_name)
> +			goto nomem;
> +
> +		fsopt->caps_wanted_delay_min = CEPH_CAPS_WANTED_DELAY_MIN_DEFAULT;
> +		fsopt->caps_wanted_delay_max = CEPH_CAPS_WANTED_DELAY_MAX_DEFAULT;
> +		fsopt->max_readdir = CEPH_MAX_READDIR_DEFAULT;
> +		fsopt->max_readdir_bytes = CEPH_MAX_READDIR_BYTES_DEFAULT;
> +		fsopt->congestion_kb = default_congestion_kb();
> +		spin_lock_init(&fsopt->ceph_opt_lock);
> +	}
> +
> +	pctx->copts = ceph_alloc_options(copts);
> +	if (!pctx->copts)
> +		goto nomem;
>  
>  	fc->fs_private = pctx;
>  	fc->ops = &ceph_context_ops;
> @@ -1232,7 +1321,6 @@ static int ceph_init_fs_context(struct fs_context *fc)
>  
>  nomem:
>  	destroy_mount_options(pctx->opts);
> -	ceph_destroy_options(pctx->copts);
>  	kfree(pctx);
>  	return -ENOMEM;
>  }
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 2acb09980432..ad44b98f3c3b 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -95,6 +95,8 @@ struct ceph_mount_options {
>  	char *mds_namespace;  /* default NULL */
>  	char *server_path;    /* default  "/" */
>  	char *fscache_uniq;   /* default NULL */
> +
> +	spinlock_t ceph_opt_lock;

I'm not sure we really need an extra lock around these fields,
particularly if you're intending to only allow a few different things to
be changed at remount.

>  };
>  
>  struct ceph_fs_client {
> diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> index 8fe9b80e80a5..407645adb2ad 100644
> --- a/include/linux/ceph/libceph.h
> +++ b/include/linux/ceph/libceph.h
> @@ -281,11 +281,13 @@ extern int ceph_check_fsid(struct ceph_client *client, struct ceph_fsid *fsid);
>  extern void *ceph_kvmalloc(size_t size, gfp_t flags);
>  
>  struct fs_parameter;
> -struct ceph_options *ceph_alloc_options(void);
> +struct ceph_options *ceph_alloc_options(struct ceph_options *old);
>  int ceph_parse_mon_ips(const char *buf, size_t len, struct ceph_options *opt,
>  		       struct fs_context *fc);
>  int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
>  		     struct fs_context *fc);
> +int ceph_reconfigure_copts(struct fs_context *fc, struct ceph_options *new_opts,
> +			   struct ceph_options *opts);
>  int ceph_print_client_options(struct seq_file *m, struct ceph_client *client,
>  			      bool show_all);
>  extern void ceph_destroy_options(struct ceph_options *opt);
> diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> index a9d6c97b5b0d..39e628996595 100644
> --- a/net/ceph/ceph_common.c
> +++ b/net/ceph/ceph_common.c
> @@ -295,7 +295,7 @@ static const struct fs_parameter_description ceph_parameters = {
>          .specs          = ceph_param_specs,
>  };
>  
> -struct ceph_options *ceph_alloc_options(void)
> +struct ceph_options *ceph_alloc_options(struct ceph_options *old)
>  {
>  	struct ceph_options *opt;
>  
> @@ -305,17 +305,49 @@ struct ceph_options *ceph_alloc_options(void)
>  
>  	opt->mon_addr = kcalloc(CEPH_MAX_MON, sizeof(*opt->mon_addr),
>  				GFP_KERNEL);
> -	if (!opt->mon_addr) {
> -		kfree(opt);
> -		return NULL;
> -	}
> +	if (!opt->mon_addr)
> +		goto err;
> +
> +	if (old) {
> +		memcpy(&opt->my_addr, &old->my_addr, sizeof(opt->my_addr));
> +		memcpy(&opt->fsid, &old->fsid, sizeof(opt->fsid));
> +		if (old->name) {
> +			opt->name = kstrdup(old->name, GFP_KERNEL);
> +			if (!opt->name)
> +				goto err;
> +		}
>  
> -	opt->flags = CEPH_OPT_DEFAULT;
> -	opt->osd_keepalive_timeout = CEPH_OSD_KEEPALIVE_DEFAULT;
> -	opt->mount_timeout = CEPH_MOUNT_TIMEOUT_DEFAULT;
> -	opt->osd_idle_ttl = CEPH_OSD_IDLE_TTL_DEFAULT;
> -	opt->osd_request_timeout = CEPH_OSD_REQUEST_TIMEOUT_DEFAULT;
> +		if (old->key) {
> +			opt->key = kmalloc(sizeof(*opt->key), GFP_KERNEL);
> +			if (!opt->key)
> +				goto err;
> +
> +			opt->key->type = old->key->type;
> +			opt->key->created.tv_sec = old->key->created.tv_sec;
> +			opt->key->created.tv_nsec = old->key->created.tv_nsec;
> +			opt->key->len = old->key->len;
> +			memcpy(opt->key->key, old->key->key, old->key->len);
> +		}
> +
> +		opt->osd_keepalive_timeout = old->osd_keepalive_timeout;
> +		opt->osd_idle_ttl = old->osd_idle_ttl;
> +		opt->mount_timeout = old->mount_timeout;
> +		opt->osd_request_timeout = old->osd_request_timeout;
> +		opt->flags = old->flags;
> +	} else {
> +		opt->flags = CEPH_OPT_DEFAULT;
> +		opt->osd_keepalive_timeout = CEPH_OSD_KEEPALIVE_DEFAULT;
> +		opt->mount_timeout = CEPH_MOUNT_TIMEOUT_DEFAULT;
> +		opt->osd_idle_ttl = CEPH_OSD_IDLE_TTL_DEFAULT;
> +		opt->osd_request_timeout = CEPH_OSD_REQUEST_TIMEOUT_DEFAULT;
> +	}
>  	return opt;
> +
> +err:
> +	kfree(opt->name);
> +	kfree(opt->mon_addr);
> +	kfree(opt);
> +	return NULL;
>  }
>  EXPORT_SYMBOL(ceph_alloc_options);
>  
> @@ -534,6 +566,37 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
>  }
>  EXPORT_SYMBOL(ceph_parse_param);
>  
> +int ceph_reconfigure_copts(struct fs_context *fc, struct ceph_options *new_opts,
> +			   struct ceph_options *opts)
> +{
> +	if (memcmp(&new_opts->my_addr, &opts->my_addr,
> +		   sizeof(opts->my_addr)))
> +		return invalf(fc, "ceph: reconfiguration of ip not allowed");
> +
> +	if (memcmp(&new_opts->fsid, &opts->fsid, sizeof(opts->fsid)))
> +		return invalf(fc, "ceph: reconfiguration of fsid not allowed");
> +
> +	if (strcmp_null(new_opts->name, opts->name))
> +		return invalf(fc, "ceph: reconfiguration of name not allowed");
> +
> +	if (new_opts->key && (!opts->key ||
> +		new_opts->key->type != opts->key->type ||
> +		new_opts->key->created.tv_sec != opts->key->created.tv_sec ||
> +		new_opts->key->created.tv_nsec != opts->key->created.tv_nsec ||
> +		new_opts->key->len != opts->key->len ||
> +		memcmp(new_opts->key->key, opts->key->key, opts->key->len)))
> +		return invalf(fc, "ceph: reconfiguration of secret not allowed");
> +
> +	opts->osd_keepalive_timeout = new_opts->osd_keepalive_timeout;
> +	opts->osd_idle_ttl = new_opts->osd_idle_ttl;
> +	opts->mount_timeout = new_opts->mount_timeout;
> +	opts->osd_request_timeout = new_opts->osd_request_timeout;
> +	opts->flags = new_opts->flags;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ceph_reconfigure_copts);
> +
>  int ceph_print_client_options(struct seq_file *m, struct ceph_client *client,
>  			      bool show_all)
>  {

-- 
Jeff Layton <jlayton@kernel.org>

