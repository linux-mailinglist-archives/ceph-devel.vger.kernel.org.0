Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995163B7155
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 13:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbhF2Led (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 07:34:33 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:41918 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233260AbhF2Lec (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Jun 2021 07:34:32 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CEE75203D2;
        Tue, 29 Jun 2021 11:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624966324; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S+NUUMWHCy/yEUGIifTWegyGaQcZnUpnRf6DHPvh2ds=;
        b=tL7SiPiYb4r2rJbv2PN6ZPFbMe6pF4SdIuk6y4mt4l+6qgRTYuGD6cz7h7o0GqPVXOVqWc
        7tEp9pBJ9TChsEGCmDrqaHEpd5sBL/SHVmgU+Bl067FNCm+k79XIcbIzPtaxOYhbaYsmZm
        sM4E7XDzsY03jDnkDHOaN7OVhibrq6k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624966324;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S+NUUMWHCy/yEUGIifTWegyGaQcZnUpnRf6DHPvh2ds=;
        b=SA8ed597Xm2UX0CRfrZCO3NomsRGDbXcFUbfv8k1qIxeQVLiMV7J/X1e9pG1WsKur0RKKm
        Hrm3hj3h91jnOsAA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 7385A11906;
        Tue, 29 Jun 2021 11:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624966324; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S+NUUMWHCy/yEUGIifTWegyGaQcZnUpnRf6DHPvh2ds=;
        b=tL7SiPiYb4r2rJbv2PN6ZPFbMe6pF4SdIuk6y4mt4l+6qgRTYuGD6cz7h7o0GqPVXOVqWc
        7tEp9pBJ9TChsEGCmDrqaHEpd5sBL/SHVmgU+Bl067FNCm+k79XIcbIzPtaxOYhbaYsmZm
        sM4E7XDzsY03jDnkDHOaN7OVhibrq6k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624966324;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S+NUUMWHCy/yEUGIifTWegyGaQcZnUpnRf6DHPvh2ds=;
        b=SA8ed597Xm2UX0CRfrZCO3NomsRGDbXcFUbfv8k1qIxeQVLiMV7J/X1e9pG1WsKur0RKKm
        Hrm3hj3h91jnOsAA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 0BkvGLQE22BsKwAALh3uQQ
        (envelope-from <lhenriques@suse.de>); Tue, 29 Jun 2021 11:32:04 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 31b90813;
        Tue, 29 Jun 2021 11:32:03 +0000 (UTC)
Date:   Tue, 29 Jun 2021 12:32:03 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     Venky Shankar <vshankar@redhat.com>
Cc:     jlayton@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org
Subject: Re: [PATCH 1/4] ceph: new device mount syntax
Message-ID: <YNsEs9IwTEEqOTHj@suse.de>
References: <20210628075545.702106-1-vshankar@redhat.com>
 <20210628075545.702106-2-vshankar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210628075545.702106-2-vshankar@redhat.com>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

[ As I said, I didn't fully reviewed this patch.  Just sending out a few
  comments. ]

On Mon, Jun 28, 2021 at 01:25:42PM +0530, Venky Shankar wrote:
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
>   cephuser@fsid.mycephfs2=/path
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
>  fs/ceph/super.c | 117 +++++++++++++++++++++++++++++++++++++++++++-----
>  fs/ceph/super.h |   3 ++
>  2 files changed, 110 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 9b1b7f4cfdd4..950a28ad9c59 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -145,6 +145,7 @@ enum {
>  	Opt_mds_namespace,
>  	Opt_recover_session,
>  	Opt_source,
> +	Opt_mon_addr,
>  	/* string args above */
>  	Opt_dirstat,
>  	Opt_rbytes,
> @@ -196,6 +197,7 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
>  	fsparam_u32	("rsize",			Opt_rsize),
>  	fsparam_string	("snapdirname",			Opt_snapdirname),
>  	fsparam_string	("source",			Opt_source),
> +	fsparam_string	("mon_addr",			Opt_mon_addr),
>  	fsparam_u32	("wsize",			Opt_wsize),
>  	fsparam_flag_no	("wsync",			Opt_wsync),
>  	{}
> @@ -226,10 +228,68 @@ static void canonicalize_path(char *path)
>  	path[j] = '\0';
>  }
>  
> +static int ceph_parse_old_source(const char *dev_name, const char *dev_name_end,
> +				 struct fs_context *fc)
> +{
> +	int r;
> +	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
> +	struct ceph_mount_options *fsopt = pctx->opts;
> +
> +	if (*dev_name_end != ':')
> +		return invalfc(fc, "separator ':' missing in source");
> +
> +	r = ceph_parse_mon_ips(dev_name, dev_name_end - dev_name,
> +			       pctx->copts, fc->log.log);
> +	if (r)
> +		return r;
> +
> +	fsopt->new_dev_syntax = false;
> +	return 0;
> +}
> +
> +static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
> +				 struct fs_context *fc)
> +{
> +	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
> +	struct ceph_mount_options *fsopt = pctx->opts;
> +	char *fsid_start, *fs_name_start;
> +
> +	if (*dev_name_end != '=')
> +                return invalfc(fc, "separator '=' missing in source");

An annoying thing is that we'll always see this error message when falling
back to the old_source method.

(Also, is there a good reason for using '=' instead of ':'?  I probably
missed this discussion somewhere else already...)

> +
> +	fsid_start = strchr(dev_name, '@');
> +	if (!fsid_start)
> +		return invalfc(fc, "missing cluster fsid");
> +	++fsid_start; /* start of cluster fsid */
> +
> +	fs_name_start = strchr(fsid_start, '.');
> +	if (!fs_name_start)
> +		return invalfc(fc, "missing file system name");
> +
> +	++fs_name_start; /* start of file system name */
> +	fsopt->mds_namespace = kstrndup(fs_name_start,
> +					dev_name_end - fs_name_start, GFP_KERNEL);
> +	if (!fsopt->mds_namespace)
> +		return -ENOMEM;
> +	dout("file system (mds namespace) '%s'\n", fsopt->mds_namespace);
> +
> +	fsopt->new_dev_syntax = true;
> +	return 0;
> +}
> +
>  /*
> - * Parse the source parameter.  Distinguish the server list from the path.
> + * Parse the source parameter for new device format. Distinguish the device
> + * spec from the path. Try parsing new device format and fallback to old
> + * format if needed.
>   *
> - * The source will look like:
> + * New device syntax will looks like:
> + *     <device_spec>=/<path>
> + * where
> + *     <device_spec> is name@fsid.fsname
> + *     <path> is optional, but if present must begin with '/'
> + * (monitor addresses are passed via mount option)
> + *
> + * Old device syntax is:
>   *     <server_spec>[,<server_spec>...]:[<path>]
>   * where
>   *     <server_spec> is <ip>[:<port>]
> @@ -262,22 +322,48 @@ static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
>  		dev_name_end = dev_name + strlen(dev_name);
>  	}
>  
> -	dev_name_end--;		/* back up to ':' separator */
> -	if (dev_name_end < dev_name || *dev_name_end != ':')
> -		return invalfc(fc, "No path or : separator in source");
> +	dev_name_end--;		/* back up to separator */
> +	if (dev_name_end < dev_name)
> +		return invalfc(fc, "path missing in source");
>  
>  	dout("device name '%.*s'\n", (int)(dev_name_end - dev_name), dev_name);
>  	if (fsopt->server_path)
>  		dout("server path '%s'\n", fsopt->server_path);
>  
> -	ret = ceph_parse_mon_ips(param->string, dev_name_end - dev_name,
> -				 pctx->copts, fc->log.log);
> +	dout("trying new device syntax");
> +	ret = ceph_parse_new_source(dev_name, dev_name_end, fc);
> +	if (ret == 0)
> +		goto done;
> +
> +	dout("trying old device syntax");
> +	ret = ceph_parse_old_source(dev_name, dev_name_end, fc);
>  	if (ret)
> -		return ret;
> +		goto out;
>  
> + done:
>  	fc->source = param->string;
>  	param->string = NULL;
> -	return 0;
> + out:
> +	return ret;
> +}
> +
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

I think this will result in a memory leak.  Why don't we simply set
fsopt->mon_addr to param->string instead of kstrdup'ing it?

Cheers,
--
Luís

> +	return r;
>  }
>  
>  static int ceph_parse_mount_param(struct fs_context *fc,
> @@ -322,6 +408,8 @@ static int ceph_parse_mount_param(struct fs_context *fc,
>  		if (fc->source)
>  			return invalfc(fc, "Multiple sources specified");
>  		return ceph_parse_source(param, fc);
> +	case Opt_mon_addr:
> +		return ceph_parse_mon_addr(param, fc);
>  	case Opt_wsize:
>  		if (result.uint_32 < PAGE_SIZE ||
>  		    result.uint_32 > CEPH_MAX_WRITE_SIZE)
> @@ -473,6 +561,7 @@ static void destroy_mount_options(struct ceph_mount_options *args)
>  	kfree(args->mds_namespace);
>  	kfree(args->server_path);
>  	kfree(args->fscache_uniq);
> +	kfree(args->mon_addr);
>  	kfree(args);
>  }
>  
> @@ -516,6 +605,10 @@ static int compare_mount_options(struct ceph_mount_options *new_fsopt,
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
> @@ -571,9 +664,13 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
>  	if ((fsopt->flags & CEPH_MOUNT_OPT_NOCOPYFROM) == 0)
>  		seq_puts(m, ",copyfrom");
>  
> -	if (fsopt->mds_namespace)
> +	/* dump mds_namespace when old device syntax is in use */
> +	if (fsopt->mds_namespace && !fsopt->new_dev_syntax)
>  		seq_show_option(m, "mds_namespace", fsopt->mds_namespace);
>  
> +	if (fsopt->mon_addr)
> +		seq_printf(m, ",mon_addr=%s", fsopt->mon_addr);
> +
>  	if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
>  		seq_show_option(m, "recover_session", "clean");
>  
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 839e6b0239ee..557348ff3203 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -88,6 +88,8 @@ struct ceph_mount_options {
>  	unsigned int max_readdir;       /* max readdir result (entries) */
>  	unsigned int max_readdir_bytes; /* max readdir result (bytes) */
>  
> +	bool new_dev_syntax;
> +
>  	/*
>  	 * everything above this point can be memcmp'd; everything below
>  	 * is handled in compare_mount_options()
> @@ -97,6 +99,7 @@ struct ceph_mount_options {
>  	char *mds_namespace;  /* default NULL */
>  	char *server_path;    /* default NULL (means "/") */
>  	char *fscache_uniq;   /* default NULL */
> +	char *mon_addr;
>  };
>  
>  struct ceph_fs_client {
> -- 
> 2.27.0
> 
