Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E130A2B04EA
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Nov 2020 13:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgKLMVp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Nov 2020 07:21:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:32976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbgKLMVo (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 07:21:44 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F7722068E;
        Thu, 12 Nov 2020 12:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605183703;
        bh=jCILeS3TmTG7+EYr41cDju+mXqTjz+ftOLjjqMARJTE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=07UB+BlTAU4rivVBHLhBA7wk0rodzZ+SmRp910cQfx+ZjEEg0Z9gbb8wJLBUakJft
         +p0yekIziDgjTIVvgRpUpuOTjfakp0H8aXTleZ6NRXhpNyU0UR4oCJf3TEx+aSFFVo
         RYjjGX+PQe7TqjAGL/+8GdsPhop3p3QOzn0jeoNw=
Message-ID: <357cdb432c2111770e24495618f32b2d7ef78bd7.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix race in concurrent __ceph_remove_cap
 invocations
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 12 Nov 2020 07:21:42 -0500
In-Reply-To: <20201112104512.17472-1-lhenriques@suse.de>
References: <20201112104512.17472-1-lhenriques@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-11-12 at 10:45 +0000, Luis Henriques wrote:
> A NULL pointer dereference may occur in __ceph_remove_cap with some of the
> callbacks used in ceph_iterate_session_caps, namely trim_caps_cb and
> remove_session_caps_cb.  These aren't protected against the concurrent
> execution of __ceph_remove_cap.
> 
> Since the callers of this function hold the i_ceph_lock, the fix is simply
> a matter of returning immediately if caps->ci is NULL.
> 
> Based on a patch from Jeff Layton.
> 
> Cc: stable@vger.kernel.org
> URL: https://tracker.ceph.com/issues/43272
> Link: https://www.spinics.net/lists/ceph-devel/msg47064.html
> Signed-off-by: Luis Henriques <lhenriques@suse.de>
> ---
>  fs/ceph/caps.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index ded4229c314a..443f164760d5 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1140,12 +1140,19 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>  {
>  	struct ceph_mds_session *session = cap->session;
>  	struct ceph_inode_info *ci = cap->ci;
> -	struct ceph_mds_client *mdsc =
> -		ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
> +	struct ceph_mds_client *mdsc;
>  	int removed = 0;
>  
> 
> +	/* 'ci' being NULL means he remove have already occurred */
> +	if (!ci) {
> +		dout("%s: cap inode is NULL\n", __func__);
> +		return;
> +	}
> +
>  	dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
>  
> 
> +	mdsc = ceph_inode_to_client(&ci->vfs_inode)->mdsc;
> +
>  	/* remove from inode's cap rbtree, and clear auth cap */
>  	rb_erase(&cap->ci_node, &ci->i_caps);
>  	if (ci->i_auth_cap == cap) {

Merged into testing branch (with a minor fix to the comment).
-- 
Jeff Layton <jlayton@kernel.org>

