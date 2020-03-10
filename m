Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78EAD180504
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Mar 2020 18:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgCJRjb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Mar 2020 13:39:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbgCJRjb (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Mar 2020 13:39:31 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A15820675;
        Tue, 10 Mar 2020 17:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583861970;
        bh=Kw0BxZLxEXAerGxhe5aiIE/7X2E/iMLgaA6bHG52DF8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kEAwlUa/1Aqw0yGAUung87V17pAHWxE2aXiPOCqh3I0FRAfv1rw+mXUV6LD5J4197
         d+b/D+4aOAw6XxJluL7GURMLLU9iYJO8P5sj4bVVHnhzFp+zcXVZgW+AkPy5nC+mjg
         M99XVch0piHYKc0IFPS6prcpEDTKriwzsf1hrM50=
Message-ID: <7f684a1a23c007858d996346532971bd0de9f138.camel@kernel.org>
Subject: Re: [ceph-users] cephfs snap mkdir strange timestamp
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>,
        Marc Roos <M.Roos@f1-outsourcing.eu>
Cc:     ceph-users <ceph-users@ceph.io>, ceph-devel@vger.kernel.org
Date:   Tue, 10 Mar 2020 13:39:29 -0400
In-Reply-To: <20200310134613.GA74810@suse.com>
References: <"H000007100163fdf.1583792359.sx.f1-outsourcing.eu*"@MHS>
         <"H000007100164304.1583836879.sx.f1-outsourcing.eu*"@MHS>
         <20200310134613.GA74810@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-03-10 at 13:46 +0000, Luis Henriques wrote:
> [ CC'ing Jeff and ceph-devel@ ]
> 
> On Tue, Mar 10, 2020 at 11:41:19AM +0100, Marc Roos wrote:
> >  
> > 
> > If I make a directory in linux the directory has the date of now, why is 
> > this not with creating a snap dir? Is this not a bug? One expects this 
> > to be the same as in linux not????
> 
> I've noticed that long time ago, but I never checked the fuse client
> behaviour, which turns out to be different.  The fuse client seems to set
> ctime and atime to the same value as the parent directory (see
> Client::open_snapdir()).
> 
> The patch below mimics that behaviour, by simply copying those timestamps
> from the parent inode.
> 
> Cheers,
> --
> Luis
> 
> From 2c8e06e66e5453ddf8b634cf1689a812dc05a0c6 Mon Sep 17 00:00:00 2001
> From: Luis Henriques <lhenriques@suse.com>
> Date: Tue, 10 Mar 2020 13:35:11 +0000
> Subject: [PATCH] ceph: fix snapshot dir ctime and mtime
> 
> The .snap directory timestamps are kept at 0 (1970-01-01 00:00), which
> isn't consistent with what the fuse client does.  This patch makes the
> behaviour consistent, by setting these timestamps to those of the parent
> directory.
> 
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
>  fs/ceph/inode.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index d01710a16a4a..f4e78ade0871 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -82,6 +82,8 @@ struct inode *ceph_get_snapdir(struct inode *parent)
>  	inode->i_mode = parent->i_mode;
>  	inode->i_uid = parent->i_uid;
>  	inode->i_gid = parent->i_gid;
> +	inode->i_mtime = parent->i_mtime;
> +	inode->i_ctime = parent->i_ctime;
>  	inode->i_op = &ceph_snapdir_iops;
>  	inode->i_fop = &ceph_snapdir_fops;
>  	ci->i_snap_caps = CEPH_CAP_PIN; /* so we can open */

What about the atime, and the ci->i_btime ?
-- 
Jeff Layton <jlayton@kernel.org>

