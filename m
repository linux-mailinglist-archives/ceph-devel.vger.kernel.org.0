Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4893B2AF375
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Nov 2020 15:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgKKOYg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Nov 2020 09:24:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:38192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbgKKOYg (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Nov 2020 09:24:36 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B5A720756;
        Wed, 11 Nov 2020 14:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605104675;
        bh=p4jpqaewjKconkR7lGD+dwaOLv4r67cAo+hv7xc906U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Nf+yGYP1yyDAkG5Na76RyKyjGuCiU5CdGHfoengCYIsLlnBeqEbiO1bQUfBKl51HN
         iBOka/UGmPIvi6LJUGacSJmr39/0vuFweamD2rjZRFcPfpB7+D6mNmqhaSvQqqsdpk
         bxNNp4RpRUihxPZv3pWVq7F7sbBzlj72j/ASA/zc=
Message-ID: <49f1ee2a409c8f51594ada0605349d3b782d106b.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: guard against __ceph_remove_cap races
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     "Yan, Zheng" <ukernel@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Date:   Wed, 11 Nov 2020 09:24:33 -0500
In-Reply-To: <87mtzodluu.fsf@suse.de>
References: <20191212173159.35013-1-jlayton@kernel.org>
         <CAAM7YAmquOg5ESMAMa5y0gGAR-UAivYF8m+nqrJNmK=SzG6+wA@mail.gmail.com>
         <64d5a16d920098122144e0df8e03df0cadfb2784.camel@kernel.org>
         <871rh0f8w3.fsf@suse.de>
         <05512d3c3bf95eb551ea8ae4982b180f8c4deb0d.camel@kernel.org>
         <87mtzodluu.fsf@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-11-11 at 14:11 +0000, Luis Henriques wrote:
> 
> 

It think this looks reasonable. Minor nits below:

> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index ded4229c314a..917dfaf0bd01 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1140,12 +1140,17 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
>  {
>         struct ceph_mds_session *session = cap->session;
>         struct ceph_inode_info *ci = cap->ci;
> -       struct ceph_mds_client *mdsc =
> -               ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
> +       struct ceph_mds_client *mdsc;
> +

nit: remove the above newline

>         int removed = 0;
>  

Maybe add a comment here to the effect that a NULL cap->ci indicates
that the remove has already been done?

> +       if (!ci)
> +               return;
> +
>         dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
>  
> +       mdsc = ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
> +

There's a ceph_inode_to_client helper now that may make this a bit more
readable.

>         /* remove from inode's cap rbtree, and clear auth cap */
>         rb_erase(&cap->ci_node, &ci->i_caps);
>         if (ci->i_auth_cap == cap) {

-- 
Jeff Layton <jlayton@kernel.org>

