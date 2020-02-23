Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6FF816982D
	for <lists+ceph-devel@lfdr.de>; Sun, 23 Feb 2020 15:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgBWO5C (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 23 Feb 2020 09:57:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:34380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgBWO5C (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 09:57:02 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B49C20637;
        Sun, 23 Feb 2020 14:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582469820;
        bh=399O5KBqvVynn8NVFvzvY7g3J9Qb6IT8xLhSNDyFcB8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=S2dY6z9+eNr1Rqj+IjTY/+fDSft3bdGLg++pkPqz+tZKLj2j9UVNG2Eh7b5LUYXwc
         Lu6e16c/Tzsu80GUDWlWMZMDYE4H6PPnW9RhnLq6L3mW7pCwa/OsMpiGUM3lVHPBeD
         B7X3MY6RA5gji5CrX2gUfIIA2Av9/WlKHdfRVATk=
Message-ID: <552341c730d2835b1492599fce319ae91a34f504.camel@kernel.org>
Subject: Re: [PATCH] ceph: add 'fs' mount option support
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Sun, 23 Feb 2020 09:56:58 -0500
In-Reply-To: <20200223021440.40257-1-xiubli@redhat.com>
References: <20200223021440.40257-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2020-02-22 at 21:14 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The 'fs' here will be cleaner when specifying the ceph fs name,
> and we can easily get the corresponding name from the `ceph fs
> dump`:
> 
> [...]
> Filesystem 'a' (1)
> fs_name	a
> epoch	12
> flags	12
> [...]
> 
> The 'fs' here just an alias name for 'mds_namespace' mount options,
> and we will keep 'mds_namespace' for backwards compatibility.
> 
> URL: https://tracker.ceph.com/issues/44214
> Signed-off-by: Xiubo Li <xiubli@redhat.com>

It looks like mds_namespace feature went into the kernel in 2016 (in
v4.7). We're at v5.5 today, so that's a large swath of kernels in the
field that only support the old option.

While I agree that 'fs=' would have been cleaner and more user-friendly, 
I've found that it's just not worth it to add mount option aliases like
this unless you have a really good reason. It all ends up being a huge
amount of churn for little benefit.

The problem with changing it after the fact like this is that you still
have to support both options forever. Removing support isn't worth the
pain as you can break working environments. When working environments
upgrade they won't change to use the new option (why bother?)

Maybe it would be good to start this change by doing a "fs=" to
"mds_namespace=" translation in the mount helper? That would make the
new option work across older kernel releases too, and make it simpler to
document what options are supported.

> ---
>  fs/ceph/mds_client.c |  8 ++++----
>  fs/ceph/super.c      | 21 +++++++++++----------
>  fs/ceph/super.h      |  2 +-
>  3 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 3e792eca6af7..82f63ef2694c 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4590,7 +4590,7 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
>  void ceph_mdsc_handle_fsmap(struct ceph_mds_client *mdsc, struct ceph_msg *msg)
>  {
>  	struct ceph_fs_client *fsc = mdsc->fsc;
> -	const char *mds_namespace = fsc->mount_options->mds_namespace;
> +	const char *fs_name = fsc->mount_options->fs_name;
>  	void *p = msg->front.iov_base;
>  	void *end = p + msg->front.iov_len;
>  	u32 epoch;
> @@ -4634,9 +4634,9 @@ void ceph_mdsc_handle_fsmap(struct ceph_mds_client *mdsc, struct ceph_msg *msg)
>  		namelen = ceph_decode_32(&info_p);
>  		ceph_decode_need(&info_p, info_end, namelen, bad);
>  
> -		if (mds_namespace &&
> -		    strlen(mds_namespace) == namelen &&
> -		    !strncmp(mds_namespace, (char *)info_p, namelen)) {
> +		if (fs_name &&
> +		    strlen(fs_name) == namelen &&
> +		    !strncmp(fs_name, (char *)info_p, namelen)) {
>  			mount_fscid = fscid;
>  			break;
>  		}
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index c7f150686a53..31acb4fe1f2c 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -140,7 +140,7 @@ enum {
>  	Opt_congestion_kb,
>  	/* int args above */
>  	Opt_snapdirname,
> -	Opt_mds_namespace,
> +	Opt_fs,
>  	Opt_recover_session,
>  	Opt_source,
>  	/* string args above */
> @@ -181,7 +181,8 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
>  	fsparam_flag_no	("fsc",				Opt_fscache), // fsc|nofsc
>  	fsparam_string	("fsc",				Opt_fscache), // fsc=...
>  	fsparam_flag_no ("ino32",			Opt_ino32),
> -	fsparam_string	("mds_namespace",		Opt_mds_namespace),
> +	fsparam_string	("mds_namespace",		Opt_fs), // backwards compatibility
> +	fsparam_string	("fs",				Opt_fs), // new alias for mds_namespace
>  	fsparam_flag_no ("poolperm",			Opt_poolperm),
>  	fsparam_flag_no ("quotadf",			Opt_quotadf),
>  	fsparam_u32	("rasize",			Opt_rasize),
> @@ -300,9 +301,9 @@ static int ceph_parse_mount_param(struct fs_context *fc,
>  		fsopt->snapdir_name = param->string;
>  		param->string = NULL;
>  		break;
> -	case Opt_mds_namespace:
> -		kfree(fsopt->mds_namespace);
> -		fsopt->mds_namespace = param->string;
> +	case Opt_fs:
> +		kfree(fsopt->fs_name);
> +		fsopt->fs_name = param->string;
>  		param->string = NULL;
>  		break;
>  	case Opt_recover_session:
> @@ -460,7 +461,7 @@ static void destroy_mount_options(struct ceph_mount_options *args)
>  		return;
>  
>  	kfree(args->snapdir_name);
> -	kfree(args->mds_namespace);
> +	kfree(args->fs_name);
>  	kfree(args->server_path);
>  	kfree(args->fscache_uniq);
>  	kfree(args);
> @@ -494,7 +495,7 @@ static int compare_mount_options(struct ceph_mount_options *new_fsopt,
>  	if (ret)
>  		return ret;
>  
> -	ret = strcmp_null(fsopt1->mds_namespace, fsopt2->mds_namespace);
> +	ret = strcmp_null(fsopt1->fs_name, fsopt2->fs_name);
>  	if (ret)
>  		return ret;
>  
> @@ -561,8 +562,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
>  	if ((fsopt->flags & CEPH_MOUNT_OPT_NOCOPYFROM) == 0)
>  		seq_puts(m, ",copyfrom");
>  
> -	if (fsopt->mds_namespace)
> -		seq_show_option(m, "mds_namespace", fsopt->mds_namespace);
> +	if (fsopt->fs_name)
> +		seq_show_option(m, "fs", fsopt->fs_name);

Someone will mount with mds_namespace= but then that will be converted
to fs= when displaying options here. It's not necessarily a problem but
it may be noticed by some users.

>  
>  	if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
>  		seq_show_option(m, "recover_session", "clean");
> @@ -643,7 +644,7 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
>  	fsc->client->extra_mon_dispatch = extra_mon_dispatch;
>  	ceph_set_opt(fsc->client, ABORT_ON_FULL);
>  
> -	if (!fsopt->mds_namespace) {
> +	if (!fsopt->fs_name) {
>  		ceph_monc_want_map(&fsc->client->monc, CEPH_SUB_MDSMAP,
>  				   0, true);
>  	} else {
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 4b269dc845bb..fc4c125b42fb 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -90,7 +90,7 @@ struct ceph_mount_options {
>  	 */
>  
>  	char *snapdir_name;   /* default ".snap" */
> -	char *mds_namespace;  /* default NULL */
> +	char *fs_name;        /* default NULL */
>  	char *server_path;    /* default NULL (means "/") */
>  	char *fscache_uniq;   /* default NULL */
>  };

-- 
Jeff Layton <jlayton@kernel.org>

