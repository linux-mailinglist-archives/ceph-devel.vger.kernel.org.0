Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37A26AB6EF
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2019 13:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbfIFLNc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 Sep 2019 07:13:32 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:39978 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbfIFLNc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 Sep 2019 07:13:32 -0400
Received: by mail-yw1-f66.google.com with SMTP id k200so2047750ywa.7
        for <ceph-devel@vger.kernel.org>; Fri, 06 Sep 2019 04:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poochiereds-net.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=molT4XNuqa+IcuJ8QUxL52Cw0LQYnDwoCBJfZjWN92o=;
        b=okaEXWNGPvtz/z024MWtnOENOkfqjzNJZUFFC9eCAtL9GnAJMYZGgyRvbyMbJX+hrG
         NmYTbW4XDIdGV7DbpvNpRwPE59NSizhcDJg+SrO9RWii16mN8n5IMH9y80rAFqVB6JRF
         KZDSc5yOivGWcYuRxEmKBEX48gg9TwqE4NqNlROqtFiExSPEz18qWHE9Qdybog2uMYf4
         9LB2x6pGAjsZ2K07vBqWF9xALN/u+9VovHPTn/187OzLDPlSITAH+faTwLaiKcar8VQp
         Rr14KaCthqA21JeUBOx5vLE62GNOH57s2rOg/9skjnlGsYEqSaXsoqfBcZOTU98BoiwC
         GHuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=molT4XNuqa+IcuJ8QUxL52Cw0LQYnDwoCBJfZjWN92o=;
        b=YGUXNjo3t9yZxC4iIouqW631dX5xKeOfVy0D830zg7qqd6bVgAB+eknjyF5P/14VTV
         Vl1slfFkbUKLrrH9C9TK+yHCQCIy/JKq0A7L7VrHzvZcpUFayT7Ql9hx09c/bTrSgHr7
         ZLNLV4qICJrUXvvxU77gieYnS7+JAX86UHlxM4tJNpG4ufv9AsbfFioH6odP2+9lfvHj
         xhvz23kATTR1whkz9jeCjMadPADH4pAz4XbOg3re9IESDB2wJKEXhe4ocvkIis4lk0Mz
         Buqw4MsR1dGoT+NBtuT8rnEZasLgNRsvp9HImtpsuFCgHCUkYVszWX7eoIuRl6igGFQX
         KC0Q==
X-Gm-Message-State: APjAAAXT/nzujeKxyphdmJVsfM7kQF38ifbWzvOFddlYpccfGX9lRJ0W
        +NCUv3VGAxTy+jn4spgo9vsrBg==
X-Google-Smtp-Source: APXvYqw6Cc12NKgFP9brtLur/giQ10eHWh8+slog7IdLy8c0jER072tRpGvnJot99xulsyi75yuP9Q==
X-Received: by 2002:a81:2a83:: with SMTP id q125mr6339097ywq.395.1567768411712;
        Fri, 06 Sep 2019 04:13:31 -0700 (PDT)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id k138sm1056006ywk.47.2019.09.06.04.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2019 04:13:30 -0700 (PDT)
Message-ID: <1168eadb8203ae747c9d2c8b035aee97a697e1da.camel@poochiereds.net>
Subject: Re: [PATCH] add mount opt, optoauth, to force to send req to auth
 mds In larger clusters (hundreds of millions of files). We have to pin the
 directory on a fixed mds now. Some op of client use USE_ANY_MDS mode to
 access mds, which may result in requests being sent to noauth mds and then
 forwarded to authmds. the opt is used to reduce forward op.
From:   Jeff Layton <jlayton@poochiereds.net>
To:     simon gao <simon29rock@gmail.com>, ceph-devel@vger.kernel.org
Date:   Fri, 06 Sep 2019 07:13:29 -0400
In-Reply-To: <1567761088-125167-1-git-send-email-simon29rock@gmail.com>
References: <1567761088-125167-1-git-send-email-simon29rock@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

It's ok to use line breaks so you don't end up with a subject line that
long.

On Fri, 2019-09-06 at 05:11 -0400, simon gao wrote:
> ---
>  fs/ceph/mds_client.c | 7 ++++++-
>  fs/ceph/super.c      | 7 +++++++
>  fs/ceph/super.h      | 1 +
>  3 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 920e9f0..3574e8f 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -878,6 +878,7 @@ static struct inode *get_nonsnap_parent(struct dentry *dentry)
>  static int __choose_mds(struct ceph_mds_client *mdsc,
>  			struct ceph_mds_request *req)
>  {
> +	struct ceph_mount_options *ma = mdsc->fsc->mount_options;
>  	struct inode *inode;
>  	struct ceph_inode_info *ci;
>  	struct ceph_cap *cap;
> @@ -900,7 +901,11 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>  
>  	if (mode == USE_RANDOM_MDS)
>  		goto random;
> -
> +	// force to send the req to auth mds
> +	if (ma->flags & CEPH_MOUNT_OPT_OPTOAUTH && mode != USE_AUTH_MDS){

The mode check here doesn't seem to be necessary. Did you mainly add it
so that the dout() message would fire when this is overridden?

> +		dout("change mode %d => USE_AUTH_MDS", mode);
> +		mode = USE_AUTH_MDS;
> +	}
>  	inode = NULL;
>  	if (req->r_inode) {
>  		if (ceph_snap(req->r_inode) != CEPH_SNAPDIR) {
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index ab4868c..fbe8e2f 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -169,6 +169,7 @@ enum {
>  	Opt_noquotadf,
>  	Opt_copyfrom,
>  	Opt_nocopyfrom,
> +	Opt_optoauth,
>  };
>  
>  static match_table_t fsopt_tokens = {
> @@ -210,6 +211,7 @@ enum {
>  	{Opt_noquotadf, "noquotadf"},
>  	{Opt_copyfrom, "copyfrom"},
>  	{Opt_nocopyfrom, "nocopyfrom"},
> +	{Opt_optoauth, "optoauth"},

I'm not crazy about this option name as it's not very clear. Maybe
something like "always_auth" would be better?

>  	{-1, NULL}
>  };
>  
> @@ -381,6 +383,9 @@ static int parse_fsopt_token(char *c, void *private)
>  	case Opt_noacl:
>  		fsopt->sb_flags &= ~SB_POSIXACL;
>  		break;
> +	case Opt_optoauth:
> +		fsopt->flags |= CEPH_MOUNT_OPT_OPTOAUTH;
> +		break;
>  	default:
>  		BUG_ON(token);
>  	}
> @@ -563,6 +568,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
>  		seq_puts(m, ",nopoolperm");
>  	if (fsopt->flags & CEPH_MOUNT_OPT_NOQUOTADF)
>  		seq_puts(m, ",noquotadf");
> +	if (fsopt->flags & CEPH_MOUNT_OPT_OPTOAUTH)
> +		seq_puts(m, ",optoauth");
>  
>  #ifdef CONFIG_CEPH_FS_POSIX_ACL
>  	if (fsopt->sb_flags & SB_POSIXACL)
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 6b9f1ee..2710d5b 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -41,6 +41,7 @@
>  #define CEPH_MOUNT_OPT_MOUNTWAIT       (1<<12) /* mount waits if no mds is up */
>  #define CEPH_MOUNT_OPT_NOQUOTADF       (1<<13) /* no root dir quota in statfs */
>  #define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<14) /* don't use RADOS 'copy-from' op */
> +#define CEPH_MOUNT_OPT_OPTOAUTH        (1<<15) /* send op to auth mds, not to replicative mds */
>  
>  #define CEPH_MOUNT_OPT_DEFAULT			\
>  	(CEPH_MOUNT_OPT_DCACHE |		\

-- 
Jeff Layton <jlayton@poochiereds.net>

