Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8624C3DE040
	for <lists+ceph-devel@lfdr.de>; Mon,  2 Aug 2021 21:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhHBToj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Aug 2021 15:44:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229607AbhHBToj (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 15:44:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BBED60F58;
        Mon,  2 Aug 2021 19:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627933469;
        bh=mqo8i2isz6To/vwKvLMwFooLGtCt4Xo0CuNdbyHW1I8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=E6JF4H0rNEnTd6wrMXp4gcZq7eHkRRJfvUJMAsB/AsOscoNsY2T2DzlZq2NVbogwY
         cgyYc43K0OmQUq82y6i2hGcJzbBlr0Xr1uXfwJ9w8ccOowC9AtCQcsz8Q+oY+AOiuj
         u01x3+at06YmeuinmHulZr0Ya5Lpualeyb8jSJX7hD9RW7c6UFUN05BD1+koFUTRDO
         yrIcSCqK0Z4C3wThTQQXo4TQdHlYitQUmHgAif0iWlQdUNZ3Wh0vVI0dfsah8hOM8t
         rleDBYt0Fw0NXLxdqzyfxxfytipqOiSWYZ6y2Qi4aQbZFk1GC7madI0FpARVLqZAXz
         ZPl4LuL/l3OmQ==
Message-ID: <d4f5f4238721e71ea6eaba0191b13d95fa99f24d.camel@kernel.org>
Subject: Re: [PATCH] ceph: print more information when we can't find
 snaprealm during ceph_add_cap
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Sage Weil <sage@redhat.com>
Date:   Mon, 02 Aug 2021 15:44:28 -0400
In-Reply-To: <20210802193916.98176-1-jlayton@kernel.org>
References: <20210802193916.98176-1-jlayton@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-08-02 at 15:39 -0400, Jeff Layton wrote:
> Print a bit more information when we can't find the realm during
> ceph_add_cap. Show both the inode number and the old realm inode
> number.
> 
> URL: https://tracker.ceph.com/issues/46419
> Suggested-by: Sage Weil <sage@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index cecd4f66a60d..b4c3546def01 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -703,13 +703,12 @@ void ceph_add_cap(struct inode *inode,
>  		 */
>  		struct ceph_snap_realm *realm = ceph_lookup_snap_realm(mdsc,
>  							       realmino);
> -		if (realm) {
> +		if (realm)
>  			ceph_change_snap_realm(inode, realm);
> -		} else {
> -			pr_err("ceph_add_cap: couldn't find snap realm %llx\n",
> -			       realmino);
> -			WARN_ON(!realm);
> -		}
> +		else
> +			WARN("ceph_add_cap: couldn't find snap realm 0x%llx (ino 0x%llx oldrealm 0x%llx)\n",
> +			     realmino, ci->vino.ino,
> +			     ci->i_snap_realm ? ci->i_snap_realm->ino : 0);
>  	}
>  
>  	__check_cap_issue(ci, cap, issued);

Doh! I sent a broken version of this patch.

The first argument to warn is the condition so this should read "WARN(1,
"ceph_add_cap...". The version in testing branch is correct.

Sorry for the noise!
-- 
Jeff Layton <jlayton@kernel.org>

