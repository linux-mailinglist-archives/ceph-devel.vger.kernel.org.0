Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3F03FE073
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Sep 2021 18:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345000AbhIAQzM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Sep 2021 12:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344971AbhIAQzJ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 1 Sep 2021 12:55:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B2A961102;
        Wed,  1 Sep 2021 16:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630515247;
        bh=ITk3kwC97wUzUJEZBiYHr27Q2YCkDgpvIcdugxmgETM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=m11+leE3CrcgsHF+V7UbqQMUdLkp2PHp2jDpE6pFKtRuzVXWLPpNjhoQ2xAh5jTnl
         XK4GzoEdV5TKQF8CvjkC6JyWLy67ylUv1TrcgsVJiyYR7krPWkiHGUpkPtkJ+gQS6i
         0z28T9o0RD4njQAiwS+knVddMEUSKH8eHaNieAKYNVadimg3fOQHZTXpfPgGbb0QzV
         OHmos1YX8e+P7Fw/WTGm004FO76g5Lz4h8A2yhe7nPcOqlY6unJ6HpJV+xXgV3OAIL
         KuKz2KE3KoF4+DsbnNPMXKjAe798TR4XWuilCM0oyEwieTmMr+RXqw5vyqScULil5H
         6n9dkSw0jL9Sw==
Message-ID: <6aeae1ddabffc701e1b039e99464c116c682a3fa.camel@kernel.org>
Subject: Re: [PATCH] ceph: enable async dirops by default
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>
Date:   Wed, 01 Sep 2021 12:54:06 -0400
In-Reply-To: <20210809164410.27750-1-jlayton@kernel.org>
References: <20210809164410.27750-1-jlayton@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-08-09 at 12:44 -0400, Jeff Layton wrote:
> Async dirops have been supported in mainline kernels for quite some time
> now, and we've recently (as of June) started doing regular testing in
> teuthology with '-o nowsync'. So far, that hasn't uncovered any issues,
> so I think the time is right to flip the default for this option.
> 
> Enable async dirops by default, and change /proc/mounts to show "wsync"
> when they are disabled rather than "nowsync" when they are enabled.
> 
> Cc: Patrick Donnelly <pdonnell@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/super.c | 4 ++--
>  fs/ceph/super.h | 3 ++-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 609ffc8c2d78..f517ad9eeb26 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -698,8 +698,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
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
> index 389b45ac291b..0bc36cf4c683 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -48,7 +48,8 @@
>  
>  #define CEPH_MOUNT_OPT_DEFAULT			\
>  	(CEPH_MOUNT_OPT_DCACHE |		\
> -	 CEPH_MOUNT_OPT_NOCOPYFROM)
> +	 CEPH_MOUNT_OPT_NOCOPYFROM |		\
> +	 CEPH_MOUNT_OPT_ASYNC_DIROPS)
>  
>  #define ceph_set_mount_opt(fsc, opt) \
>  	(fsc)->mount_options->flags |= CEPH_MOUNT_OPT_##opt

I think we ought to wait to merge this into mainline just yet, but I'd
like to leave it in the "testing" branch for now. 

I've been working this bug with Patrick for the last month or two:

    https://tracker.ceph.com/issues/51279

In at least one case, the problem seems to be that the MDS failed an
async create with an ENOSPC error. The kclient's error handling around
this is pretty non-existent right now, so it caused an unmount to hang. 

It's a pity we still don't have revoke()...

I've started working on a series to clean this up, but in the meantime I
think we ought to wait until that's in place before we make nowsync the
default.

Sound ok?
-- 
Jeff Layton <jlayton@kernel.org>

