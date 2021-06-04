Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421D639B7BF
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Jun 2021 13:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhFDLRV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 4 Jun 2021 07:17:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229962AbhFDLRV (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 4 Jun 2021 07:17:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 173AA6136E;
        Fri,  4 Jun 2021 11:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622805335;
        bh=Rd1b/Y2pvO3BNcHdL++Rckmu/ikl9D+KwiyBV6areJI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hwYfzhacTdmyQEdC4M+5H7B14wdMWhxi1q5vy4PBe8l6FNf/IFxvEZHDgQz909xVo
         8fV8gfjhSAY2uUytIUy8TF0MEI2pHHtuzRiqoj9surmntGbdOebgHJUdm+/u/I9Ylg
         W+JF+0usXixP4eSd/Tdoiaz/LOfctBxfNQVNdg9FG8UCUzRaH9HwDJMbZ/9Qmpf4df
         2kdZy01K6sAsnXMpEsFvW73lT7lGA4ye859UDH4RJoEl3rp01WaeZEiwJW588vUhPJ
         vO65hsgBT6iuUFh9vnXJwYu3cyItCTcX6BhSDf7HVyrpxFnYiF8UJC2sFpWxHYqNvc
         TL8D9obljbUIA==
Message-ID: <c0d58ca68157e2f3ec527d63a8986ec6fc3be60f.camel@kernel.org>
Subject: Re: [PATCH 1/3] ceph: new device mount syntax
From:   Jeff Layton <jlayton@kernel.org>
To:     Venky Shankar <vshankar@redhat.com>
Cc:     ceph-devel@vger.kernel.org
Date:   Fri, 04 Jun 2021 07:15:34 -0400
In-Reply-To: <20210604050512.552649-2-vshankar@redhat.com>
References: <20210604050512.552649-1-vshankar@redhat.com>
         <20210604050512.552649-2-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-06-04 at 10:35 +0530, Venky Shankar wrote:
> Old mount device syntax (source) has the following problems:
> 
> - mounts to the same cluster but with different fsnames
>   and/or creds have identical device string which can
>   confuse xfstests.
> 
> - Userspace mount helper tool resolves monitor addresses
>   and fill in mon addrs automatically, but that means the
>   device shown in /proc/mounts is different than what was
>   used for mounting.
> 
> New device syntax is as follows:
> 
>   cephuser@mycephfs2=/path
> 
> Note, there is no "monitor address" in the device string.
> That gets passed in as mount option. This keeps the device
> string same when monitor addresses change (on remounts).
> 
> Also note that the userspace mount helper tool is backward
> compatible. I.e., the mount helper will fallback to using
> old syntax after trying to mount with the new syntax.
> 
> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>  fs/ceph/super.c | 69 +++++++++++++++++++++++++++++++++----------------
>  fs/ceph/super.h |  1 +
>  2 files changed, 48 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 9b1b7f4cfdd4..e273eabb0397 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -142,9 +142,9 @@ enum {
>  	Opt_congestion_kb,
>  	/* int args above */
>  	Opt_snapdirname,
> -	Opt_mds_namespace,

I don't think we can just remove the old mds_namespace option. What if
we have an old mount helper with the new kernel? It'll pass that in as
an option and it wouldn't be recognized.

>  	Opt_recover_session,
>  	Opt_source,
> +	Opt_mon_addr,
>  	/* string args above */
>  	Opt_dirstat,
>  	Opt_rbytes,
> @@ -184,7 +184,6 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
>  	fsparam_flag_no	("fsc",				Opt_fscache), // fsc|nofsc
>  	fsparam_string	("fsc",				Opt_fscache), // fsc=...
>  	fsparam_flag_no ("ino32",			Opt_ino32),
> -	fsparam_string	("mds_namespace",		Opt_mds_namespace),
>  	fsparam_flag_no ("poolperm",			Opt_poolperm),
>  	fsparam_flag_no ("quotadf",			Opt_quotadf),
>  	fsparam_u32	("rasize",			Opt_rasize),
> @@ -196,6 +195,7 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
>  	fsparam_u32	("rsize",			Opt_rsize),
>  	fsparam_string	("snapdirname",			Opt_snapdirname),
>  	fsparam_string	("source",			Opt_source),
> +	fsparam_string	("mon_addr",			Opt_mon_addr),
>  	fsparam_u32	("wsize",			Opt_wsize),
>  	fsparam_flag_no	("wsync",			Opt_wsync),
>  	{}
> @@ -227,12 +227,12 @@ static void canonicalize_path(char *path)
>  }
>  
>  /*
> - * Parse the source parameter.  Distinguish the server list from the path.
> + * Parse the source parameter.  Distinguish the device spec from the path.
>   *
>   * The source will look like:
> - *     <server_spec>[,<server_spec>...]:[<path>]
> + *     <device_spec>=/<path>
>   * where
> - *     <server_spec> is <ip>[:<port>]
> + *     <device_spec> is name@fsname
>   *     <path> is optional, but if present must begin with '/'
>   */
>  static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
> @@ -240,12 +240,17 @@ static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
>  	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
>  	struct ceph_mount_options *fsopt = pctx->opts;
>  	char *dev_name = param->string, *dev_name_end;
> -	int ret;
> +	char *fs_name_start;
>  
>  	dout("%s '%s'\n", __func__, dev_name);
>  	if (!dev_name || !*dev_name)
>  		return invalfc(fc, "Empty source");
>  
> +	fs_name_start = strchr(dev_name, '@');
> +	if (!fs_name_start)
> +		return invalfc(fc, "Missing file system name");
> +	++fs_name_start; /* start of file system name */
> +
>  	dev_name_end = strchr(dev_name, '/');
>  	if (dev_name_end) {
>  		/*
> @@ -262,24 +267,42 @@ static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
>  		dev_name_end = dev_name + strlen(dev_name);
>  	}
>  
> -	dev_name_end--;		/* back up to ':' separator */
> -	if (dev_name_end < dev_name || *dev_name_end != ':')
> -		return invalfc(fc, "No path or : separator in source");
> +	dev_name_end--;		/* back up to '=' separator */
> +	if (dev_name_end < dev_name || *dev_name_end != '=')
> +		return invalfc(fc, "No path or = separator in source");
>  
>  	dout("device name '%.*s'\n", (int)(dev_name_end - dev_name), dev_name);
> -	if (fsopt->server_path)
> -		dout("server path '%s'\n", fsopt->server_path);
>  
> -	ret = ceph_parse_mon_ips(param->string, dev_name_end - dev_name,
> -				 pctx->copts, fc->log.log);
> -	if (ret)
> -		return ret;
> +	fsopt->mds_namespace = kstrndup(fs_name_start,
> +					dev_name_end - fs_name_start, GFP_KERNEL);
> +	dout("file system (mds namespace) '%s'\n", fsopt->mds_namespace);
>  
> +	if (fsopt->server_path)
> +		dout("server path '%s'\n", fsopt->server_path);
>  	fc->source = param->string;
>  	param->string = NULL;
>  	return 0;
>  }
>  
> +static int ceph_parse_mon_addr(struct fs_parameter *param,
> +			       struct fs_context *fc)
> +{
> +	int r;
> +	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
> +	struct ceph_mount_options *fsopt = pctx->opts;
> +
> +	kfree(fsopt->mon_addr);
> +	fsopt->mon_addr = kstrdup(param->string, GFP_KERNEL);
> +	if (!fsopt->mon_addr)
> +		return -ENOMEM;
> +
> +	strreplace(param->string, '/', ',');
> +	r = ceph_parse_mon_ips(param->string, strlen(param->string),
> +			       pctx->copts, fc->log.log);
> +	param->string = NULL;
> +	return r;
> +}
> +
>  static int ceph_parse_mount_param(struct fs_context *fc,
>  				  struct fs_parameter *param)
>  {
> @@ -304,11 +327,6 @@ static int ceph_parse_mount_param(struct fs_context *fc,
>  		fsopt->snapdir_name = param->string;
>  		param->string = NULL;
>  		break;
> -	case Opt_mds_namespace:
> -		kfree(fsopt->mds_namespace);
> -		fsopt->mds_namespace = param->string;
> -		param->string = NULL;
> -		break;
>  	case Opt_recover_session:
>  		mode = result.uint_32;
>  		if (mode == ceph_recover_session_no)
> @@ -322,6 +340,8 @@ static int ceph_parse_mount_param(struct fs_context *fc,
>  		if (fc->source)
>  			return invalfc(fc, "Multiple sources specified");
>  		return ceph_parse_source(param, fc);
> +	case Opt_mon_addr:
> +		return ceph_parse_mon_addr(param, fc);
>  	case Opt_wsize:
>  		if (result.uint_32 < PAGE_SIZE ||
>  		    result.uint_32 > CEPH_MAX_WRITE_SIZE)
> @@ -473,6 +493,7 @@ static void destroy_mount_options(struct ceph_mount_options *args)
>  	kfree(args->mds_namespace);
>  	kfree(args->server_path);
>  	kfree(args->fscache_uniq);
> +	kfree(args->mon_addr);
>  	kfree(args);
>  }
>  
> @@ -516,6 +537,10 @@ static int compare_mount_options(struct ceph_mount_options *new_fsopt,
>  	if (ret)
>  		return ret;
>  
> +	ret = strcmp_null(fsopt1->mon_addr, fsopt2->mon_addr);
> +	if (ret)
> +		return ret;
> +
>  	return ceph_compare_options(new_opt, fsc->client);
>  }
>  
> @@ -571,8 +596,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
>  	if ((fsopt->flags & CEPH_MOUNT_OPT_NOCOPYFROM) == 0)
>  		seq_puts(m, ",copyfrom");
>  
> -	if (fsopt->mds_namespace)
> -		seq_show_option(m, "mds_namespace", fsopt->mds_namespace);
> +	if (fsopt->mon_addr)
> +		seq_printf(m, ",mon_addr=%s", fsopt->mon_addr);
>  
>  	if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
>  		seq_show_option(m, "recover_session", "clean");
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index db80d89556b1..ead73dfb8804 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -97,6 +97,7 @@ struct ceph_mount_options {
>  	char *mds_namespace;  /* default NULL */
>  	char *server_path;    /* default NULL (means "/") */
>  	char *fscache_uniq;   /* default NULL */
> +	char *mon_addr;
>  };
>  
>  struct ceph_fs_client {

-- 
Jeff Layton <jlayton@kernel.org>

