Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E732FD035
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Jan 2021 13:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730147AbhATMge (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Jan 2021 07:36:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:45322 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730076AbhATLH7 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 20 Jan 2021 06:07:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 40043AC63;
        Wed, 20 Jan 2021 11:07:15 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 762a179b;
        Wed, 20 Jan 2021 11:07:57 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org
Subject: Re: [PATCH] ceph: enable async dirops by default
References: <20210119144430.337370-1-jlayton@kernel.org>
Date:   Wed, 20 Jan 2021 11:07:57 +0000
In-Reply-To: <20210119144430.337370-1-jlayton@kernel.org> (Jeff Layton's
        message of "Tue, 19 Jan 2021 09:44:30 -0500")
Message-ID: <87o8hjoohe.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> This has been behaving reasonably well in testing, and enabling this
> offers significant performance benefits. Enable async dirops by default
> in the kclient going forward, and change show_options to add "wsync"
> when they are disabled.

Sounds good!  Maybe it's worth adding this option to the mount options
listed in Documentation/filesystems/ceph.rst (although it's quite possible
that other mount options are already missing there).

Cheers,
-- 
Luis

>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/super.c | 4 ++--
>  fs/ceph/super.h | 5 +++--
>  2 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 9b1b7f4cfdd4..884e2ffabfaf 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -577,8 +577,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
>  	if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
>  		seq_show_option(m, "recover_session", "clean");
>  
> -	if (fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS)
> -		seq_puts(m, ",nowsync");
> +	if (!(fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS))
> +		seq_puts(m, ",wsync");
>  
>  	if (fsopt->wsize != CEPH_MAX_WRITE_SIZE)
>  		seq_printf(m, ",wsize=%u", fsopt->wsize);
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 13b02887b085..8ee2745f6257 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -46,8 +46,9 @@
>  #define CEPH_MOUNT_OPT_ASYNC_DIROPS    (1<<15) /* allow async directory ops */
>  
>  #define CEPH_MOUNT_OPT_DEFAULT			\
> -	(CEPH_MOUNT_OPT_DCACHE |		\
> -	 CEPH_MOUNT_OPT_NOCOPYFROM)
> +	(CEPH_MOUNT_OPT_DCACHE		|	\
> +	 CEPH_MOUNT_OPT_NOCOPYFROM	|	\
> +	 CEPH_MOUNT_OPT_ASYNC_DIROPS)
>  
>  #define ceph_set_mount_opt(fsc, opt) \
>  	(fsc)->mount_options->flags |= CEPH_MOUNT_OPT_##opt
> -- 
>
> 2.29.2
>
