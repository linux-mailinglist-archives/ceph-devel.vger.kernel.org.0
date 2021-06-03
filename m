Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F75839A678
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Jun 2021 18:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhFCQ7I (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Jun 2021 12:59:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229719AbhFCQ7I (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 3 Jun 2021 12:59:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37CD661159;
        Thu,  3 Jun 2021 16:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622739443;
        bh=bKqrfNl7vm7fmziBgX9j/vDBDS8F59HQHS+Zgywygrs=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=jR+e9lrteVozr9qg0oNwLrKGcHEbhBkFzG0ODT+32WqHjtaN7C9lyFbmt58uKC6pR
         mJarTPfNDJuo52RG1MlmHmgvuPNgegnWbO3QHbVmxdxpRvDCMBY6g6EKUgNy8dA+nT
         FrMXMZ+CeYJAL9QseLo8WKooQbxpZdwgow0UwckRYweO0dTFAFXTMe10RoJNSEGEqp
         MOZm8NYkxkTPJ45aPy5p584IkAz0XSegN7Tpph9quPLjNGx4rUyS7OTgiOQF5WpVJ6
         mE8bU/yGH4tDAfBwM647DVLOCRJEl5XI3kIk3jUDz0gUcM3L2d9E8uGGB7LQb8pCHj
         5UGhtzkLH/MPA==
Message-ID: <6cd5b19cbcee46474709a97b273c4270088fb241.camel@kernel.org>
Subject: Re: [PATCH] ceph: ensure we flush delayed caps when unmounting
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Date:   Thu, 03 Jun 2021 12:57:22 -0400
In-Reply-To: <20210603134812.80276-1-jlayton@kernel.org>
References: <20210603134812.80276-1-jlayton@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-06-03 at 09:48 -0400, Jeff Layton wrote:
> I've seen some warnings when testing recently that indicate that there
> are caps still delayed on the delayed list even after we've started
> unmounting.
> 
> When checking delayed caps, process the whole list if we're unmounting,
> and check for delayed caps after setting the stopping var and flushing
> dirty caps.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c       | 3 ++-
>  fs/ceph/mds_client.c | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index a5e93b185515..68b4c6dfe4db 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4236,7 +4236,8 @@ void ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
>  		ci = list_first_entry(&mdsc->cap_delay_list,
>  				      struct ceph_inode_info,
>  				      i_cap_delay_list);
> -		if ((ci->i_ceph_flags & CEPH_I_FLUSH) == 0 &&
> +		if (!mdsc->stopping &&
> +		    (ci->i_ceph_flags & CEPH_I_FLUSH) == 0 &&
>  		    time_before(jiffies, ci->i_hold_caps_max))
>  			break;
>  		list_del_init(&ci->i_cap_delay_list);
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index e5af591d3bd4..916af5497829 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4691,6 +4691,7 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
>  
>  	lock_unlock_sessions(mdsc);
>  	ceph_flush_dirty_caps(mdsc);
> +	ceph_check_delayed_caps(mdsc);
>  	wait_requests(mdsc);
>  
>  	/*

I'm going to self-NAK this patch for now. Initially this looked good in
testing, but I think it's just papering over the real problem, which is
that ceph_async_iput can queue a job to a workqueue after the point
where we've flushed that workqueue on umount.

I think the right approach is to look at how to ensure that calling iput
doesn't end up taking these coarse-grained locks so we don't need to
queue it in so many codepaths.
-- 
Jeff Layton <jlayton@kernel.org>

