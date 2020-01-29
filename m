Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68DE614CD45
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Jan 2020 16:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgA2PWI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 Jan 2020 10:22:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726964AbgA2PWH (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 10:22:07 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F909206F0;
        Wed, 29 Jan 2020 15:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580311326;
        bh=VOrs5xqjD9awkYcbABQ8VhBeQzFATHEj9rpJwIVodj8=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=MtngM62GaaQhxlAAidTgkmcerT7aB7LhyPmImyIwRHnw/v8jAwWOu5kU/BqglAimP
         aYUIA+POr8CQpYG4KQCM5aBml+9M7TF9sub1kXkFOhbcVK1kZEv2uezRdB0H/4AzyF
         xexVndGXODT8QQHC9gPH/aiAVZ7zI4gBYD9No8xY=
Message-ID: <f557513cdb917f3bacfbe0475e3c04493d853c03.camel@kernel.org>
Subject: Re: [PATCH] libceph: drop CEPH_DEFINE_SHOW_FUNC
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Date:   Wed, 29 Jan 2020 10:22:05 -0500
In-Reply-To: <20200128201303.16352-1-idryomov@gmail.com>
References: <20200128201303.16352-1-idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-01-28 at 21:13 +0100, Ilya Dryomov wrote:
> Although CEPH_DEFINE_SHOW_FUNC is much older, it now duplicates
> DEFINE_SHOW_ATTRIBUTE from linux/seq_file.h.
> 
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  fs/ceph/debugfs.c            | 16 ++++++++--------
>  include/linux/ceph/debugfs.h | 14 --------------
>  net/ceph/debugfs.c           | 20 ++++++++++----------
>  3 files changed, 18 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index fb7cabd98e7b..481ac97b4d25 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -218,10 +218,10 @@ static int mds_sessions_show(struct seq_file *s, void *ptr)
>  	return 0;
>  }
>  
> -CEPH_DEFINE_SHOW_FUNC(mdsmap_show)
> -CEPH_DEFINE_SHOW_FUNC(mdsc_show)
> -CEPH_DEFINE_SHOW_FUNC(caps_show)
> -CEPH_DEFINE_SHOW_FUNC(mds_sessions_show)
> +DEFINE_SHOW_ATTRIBUTE(mdsmap);
> +DEFINE_SHOW_ATTRIBUTE(mdsc);
> +DEFINE_SHOW_ATTRIBUTE(caps);
> +DEFINE_SHOW_ATTRIBUTE(mds_sessions);
>  
>  
>  /*
> @@ -281,25 +281,25 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
>  					0400,
>  					fsc->client->debugfs_dir,
>  					fsc,
> -					&mdsmap_show_fops);
> +					&mdsmap_fops);
>  
>  	fsc->debugfs_mds_sessions = debugfs_create_file("mds_sessions",
>  					0400,
>  					fsc->client->debugfs_dir,
>  					fsc,
> -					&mds_sessions_show_fops);
> +					&mds_sessions_fops);
>  
>  	fsc->debugfs_mdsc = debugfs_create_file("mdsc",
>  						0400,
>  						fsc->client->debugfs_dir,
>  						fsc,
> -						&mdsc_show_fops);
> +						&mdsc_fops);
>  
>  	fsc->debugfs_caps = debugfs_create_file("caps",
>  						   0400,
>  						   fsc->client->debugfs_dir,
>  						   fsc,
> -						   &caps_show_fops);
> +						   &caps_fops);
>  }
>  
>  
> diff --git a/include/linux/ceph/debugfs.h b/include/linux/ceph/debugfs.h
> index cf5e840eec71..8b3a1a7a953a 100644
> --- a/include/linux/ceph/debugfs.h
> +++ b/include/linux/ceph/debugfs.h
> @@ -2,22 +2,8 @@
>  #ifndef _FS_CEPH_DEBUGFS_H
>  #define _FS_CEPH_DEBUGFS_H
>  
> -#include <linux/ceph/ceph_debug.h>
>  #include <linux/ceph/types.h>
>  
> -#define CEPH_DEFINE_SHOW_FUNC(name)					\
> -static int name##_open(struct inode *inode, struct file *file)		\
> -{									\
> -	return single_open(file, name, inode->i_private);		\
> -}									\
> -									\
> -static const struct file_operations name##_fops = {			\
> -	.open		= name##_open,					\
> -	.read		= seq_read,					\
> -	.llseek		= seq_lseek,					\
> -	.release	= single_release,				\
> -};
> -
>  /* debugfs.c */
>  extern void ceph_debugfs_init(void);
>  extern void ceph_debugfs_cleanup(void);
> diff --git a/net/ceph/debugfs.c b/net/ceph/debugfs.c
> index 7cb992e55475..1344f232ecc5 100644
> --- a/net/ceph/debugfs.c
> +++ b/net/ceph/debugfs.c
> @@ -383,11 +383,11 @@ static int client_options_show(struct seq_file *s, void *p)
>  	return 0;
>  }
>  
> -CEPH_DEFINE_SHOW_FUNC(monmap_show)
> -CEPH_DEFINE_SHOW_FUNC(osdmap_show)
> -CEPH_DEFINE_SHOW_FUNC(monc_show)
> -CEPH_DEFINE_SHOW_FUNC(osdc_show)
> -CEPH_DEFINE_SHOW_FUNC(client_options_show)
> +DEFINE_SHOW_ATTRIBUTE(monmap);
> +DEFINE_SHOW_ATTRIBUTE(osdmap);
> +DEFINE_SHOW_ATTRIBUTE(monc);
> +DEFINE_SHOW_ATTRIBUTE(osdc);
> +DEFINE_SHOW_ATTRIBUTE(client_options);
>  
>  void __init ceph_debugfs_init(void)
>  {
> @@ -414,31 +414,31 @@ void ceph_debugfs_client_init(struct ceph_client *client)
>  						      0400,
>  						      client->debugfs_dir,
>  						      client,
> -						      &monc_show_fops);
> +						      &monc_fops);
>  
>  	client->osdc.debugfs_file = debugfs_create_file("osdc",
>  						      0400,
>  						      client->debugfs_dir,
>  						      client,
> -						      &osdc_show_fops);
> +						      &osdc_fops);
>  
>  	client->debugfs_monmap = debugfs_create_file("monmap",
>  					0400,
>  					client->debugfs_dir,
>  					client,
> -					&monmap_show_fops);
> +					&monmap_fops);
>  
>  	client->debugfs_osdmap = debugfs_create_file("osdmap",
>  					0400,
>  					client->debugfs_dir,
>  					client,
> -					&osdmap_show_fops);
> +					&osdmap_fops);
>  
>  	client->debugfs_options = debugfs_create_file("client_options",
>  					0400,
>  					client->debugfs_dir,
>  					client,
> -					&client_options_show_fops);
> +					&client_options_fops);
>  }
>  
>  void ceph_debugfs_client_cleanup(struct ceph_client *client)


Reviewed-by: Jeff Layton <jlayton@kernel.org>

