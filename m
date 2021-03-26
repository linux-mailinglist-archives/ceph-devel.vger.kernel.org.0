Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B981234AAF9
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Mar 2021 16:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhCZPJU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 26 Mar 2021 11:09:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:51496 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229945AbhCZPIt (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 26 Mar 2021 11:08:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A9E7EADFB;
        Fri, 26 Mar 2021 15:08:48 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 0925ffbd;
        Fri, 26 Mar 2021 15:10:06 +0000 (UTC)
Date:   Fri, 26 Mar 2021 15:10:06 +0000
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Subject: Re: [PATCH] ceph: only check pool permissions for regular files
Message-ID: <YF35TqQ/5klUxjAF@suse.de>
References: <20210325165606.41943-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210325165606.41943-1-jlayton@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Mar 25, 2021 at 12:56:06PM -0400, Jeff Layton wrote:
> There is no need to do a ceph_pool_perm_check() on anything that isn't a
> regular file, as the MDS is what handles talking to the OSD in those
> cases. Just return 0 if it's not a regular file.
> 
> Reported-by: Luis Henriques <lhenriques@suse.de>

Looks good to me, thanks!

[ Took me a while to find when/where I reported that -- it was completely
  swapped out from my memory!  But I finally found it on my IRC logs. ]

Cheers,
--
Luís

> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/addr.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index d26a88aca014..07cbf21099b8 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1940,6 +1940,10 @@ int ceph_pool_perm_check(struct inode *inode, int need)
>  	s64 pool;
>  	int ret, flags;
>  
> +	/* Only need to do this for regular files */
> +	if (!S_ISREG(inode->i_mode))
> +		return 0;
> +
>  	if (ci->i_vino.snap != CEPH_NOSNAP) {
>  		/*
>  		 * Pool permission check needs to write to the first object.
> -- 
> 2.30.2
> 

