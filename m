Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF19B3B9F36
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Jul 2021 12:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhGBKqk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Jul 2021 06:46:40 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:34246 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbhGBKqj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 2 Jul 2021 06:46:39 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2F7C820082;
        Fri,  2 Jul 2021 10:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1625222647; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uSkwIld1UCaDFlLv9MNj900cq+ccFGpQiKXJDNYfFTc=;
        b=cZAPvy6Tl1vFzLQxXnDcrF0ebQPaK8h25+HfGkVnRKMNoAIZPy9286pq5ZSJ9nLSNnFUdI
        syBUlHi6S3f8OkdAUaVz4WxbroaHWxbjw5fb6eHYhh0hmI5mld93g9ISwLy+QmycbkGIar
        KpXvjuS5ahVPXXQm/Z/IIZxRcrnlSIQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1625222647;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uSkwIld1UCaDFlLv9MNj900cq+ccFGpQiKXJDNYfFTc=;
        b=x15MA0MHJINXA/LuXDFNk5iWOC3eGGE/2+L/CH5QeC7J+VvzNgjSGPE54Wci5u1ODZ5iAK
        BZ2eJN7K7CYpZbDA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id BE41811C84;
        Fri,  2 Jul 2021 10:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1625222647; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uSkwIld1UCaDFlLv9MNj900cq+ccFGpQiKXJDNYfFTc=;
        b=cZAPvy6Tl1vFzLQxXnDcrF0ebQPaK8h25+HfGkVnRKMNoAIZPy9286pq5ZSJ9nLSNnFUdI
        syBUlHi6S3f8OkdAUaVz4WxbroaHWxbjw5fb6eHYhh0hmI5mld93g9ISwLy+QmycbkGIar
        KpXvjuS5ahVPXXQm/Z/IIZxRcrnlSIQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1625222647;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uSkwIld1UCaDFlLv9MNj900cq+ccFGpQiKXJDNYfFTc=;
        b=x15MA0MHJINXA/LuXDFNk5iWOC3eGGE/2+L/CH5QeC7J+VvzNgjSGPE54Wci5u1ODZ5iAK
        BZ2eJN7K7CYpZbDA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id Zhr+Kvbt3mBVaAAALh3uQQ
        (envelope-from <lhenriques@suse.de>); Fri, 02 Jul 2021 10:44:06 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 81d245d3;
        Fri, 2 Jul 2021 10:44:06 +0000 (UTC)
Date:   Fri, 2 Jul 2021 11:44:05 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     Venky Shankar <vshankar@redhat.com>
Cc:     jlayton@redhat.com, idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] ceph: validate cluster FSID for new device syntax
Message-ID: <YN7t9TJlDG8YcbqM@suse.de>
References: <20210702064821.148063-1-vshankar@redhat.com>
 <20210702064821.148063-3-vshankar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210702064821.148063-3-vshankar@redhat.com>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jul 02, 2021 at 12:18:19PM +0530, Venky Shankar wrote:
> The new device syntax requires the cluster FSID as part
> of the device string. Use this FSID to verify if it matches
> the cluster FSID we get back from the monitor, failing the
> mount on mismatch.
> 
> Also, rename parse_fsid() to ceph_parse_fsid() as it is too
> generic.
> 
> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>  fs/ceph/super.c              | 9 +++++++++
>  fs/ceph/super.h              | 1 +
>  include/linux/ceph/libceph.h | 1 +
>  net/ceph/ceph_common.c       | 5 +++--
>  4 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 0b324e43c9f4..03e5f4bb2b6f 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -268,6 +268,9 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
>  	if (!fs_name_start)
>  		return invalfc(fc, "missing file system name");
>  
> +	if (ceph_parse_fsid(fsid_start, &fsopt->fsid))
> +		return invalfc(fc, "invalid fsid format");
> +
>  	++fs_name_start; /* start of file system name */
>  	fsopt->mds_namespace = kstrndup(fs_name_start,
>  					dev_name_end - fs_name_start, GFP_KERNEL);
> @@ -750,6 +753,12 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
>  	}
>  	opt = NULL; /* fsc->client now owns this */
>  
> +	/* help learn fsid */
> +	if (fsopt->new_dev_syntax) {
> +		ceph_check_fsid(fsc->client, &fsopt->fsid);

This call to ceph_check_fsid() made me wonder what would happen if I use
the wrong fsid with the new syntax.  And the result is:

[   41.882334] libceph: mon0 (1)192.168.155.1:40594 session established
[   41.884537] libceph: bad fsid, had d52783e6-efc2-4dce-ad01-aa3272fa5f66 got 90bdb539-9d95-402e-8f23-b0e26cba8b1b
[   41.885955] libceph: bad fsid, had d52783e6-efc2-4dce-ad01-aa3272fa5f66 got 90bdb539-9d95-402e-8f23-b0e26cba8b1b
[   41.889313] libceph: bad fsid, had d52783e6-efc2-4dce-ad01-aa3272fa5f66 got 90bdb539-9d95-402e-8f23-b0e26cba8b1b
[   41.892578] libceph: osdc handle_map corrupt msg

... followed by a msg dump.

I guess this means that manually setting the fsid requires changes to the
messenger (I've only tested with v1) so that it gracefully handles this
scenario.

Cheers,
--
Luís

> +		fsc->client->have_fsid = true;
> +	}
> +
>  	fsc->client->extra_mon_dispatch = extra_mon_dispatch;
>  	ceph_set_opt(fsc->client, ABORT_ON_FULL);
>  
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 8f71184b7c85..ce5fb90a01a4 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -99,6 +99,7 @@ struct ceph_mount_options {
>  	char *server_path;    /* default NULL (means "/") */
>  	char *fscache_uniq;   /* default NULL */
>  	char *mon_addr;
> +	struct ceph_fsid fsid;
>  };
>  
>  struct ceph_fs_client {
> diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> index 409d8c29bc4f..75d059b79d90 100644
> --- a/include/linux/ceph/libceph.h
> +++ b/include/linux/ceph/libceph.h
> @@ -296,6 +296,7 @@ extern bool libceph_compatible(void *data);
>  extern const char *ceph_msg_type_name(int type);
>  extern int ceph_check_fsid(struct ceph_client *client, struct ceph_fsid *fsid);
>  extern void *ceph_kvmalloc(size_t size, gfp_t flags);
> +extern int ceph_parse_fsid(const char *str, struct ceph_fsid *fsid);
>  
>  struct fs_parameter;
>  struct fc_log;
> diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> index 97d6ea763e32..da480757fcca 100644
> --- a/net/ceph/ceph_common.c
> +++ b/net/ceph/ceph_common.c
> @@ -217,7 +217,7 @@ void *ceph_kvmalloc(size_t size, gfp_t flags)
>  	return p;
>  }
>  
> -static int parse_fsid(const char *str, struct ceph_fsid *fsid)
> +int ceph_parse_fsid(const char *str, struct ceph_fsid *fsid)
>  {
>  	int i = 0;
>  	char tmp[3];
> @@ -247,6 +247,7 @@ static int parse_fsid(const char *str, struct ceph_fsid *fsid)
>  	dout("parse_fsid ret %d got fsid %pU\n", err, fsid);
>  	return err;
>  }
> +EXPORT_SYMBOL(ceph_parse_fsid);
>  
>  /*
>   * ceph options
> @@ -465,7 +466,7 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
>  		break;
>  
>  	case Opt_fsid:
> -		err = parse_fsid(param->string, &opt->fsid);
> +		err = ceph_parse_fsid(param->string, &opt->fsid);
>  		if (err) {
>  			error_plog(&log, "Failed to parse fsid: %d", err);
>  			return err;
> -- 
> 2.27.0
> 

