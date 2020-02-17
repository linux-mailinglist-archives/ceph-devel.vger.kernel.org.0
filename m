Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD671611FB
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Feb 2020 13:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgBQMZ4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Feb 2020 07:25:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgBQMZ4 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Feb 2020 07:25:56 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19CDE206F4;
        Mon, 17 Feb 2020 12:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581942355;
        bh=GYEALwPjz00DnqvUgn9T6scUfmWFn5WZTvX9hIe4G5g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Xw9MM/6kxQQEXTtAB1hRNIu3U2Z/lhswZ8cToEjaoMEInWxx+Iqby8/PMjp3XFSIe
         Dktsen2mu/JBnQuIhse6R4o0iT3OLqo2CbrjpIvmoouV+Im/Qt1Ot1McTKQStbPXdC
         foOvyx5J6RsQLfLoXwvXlVkLD19t2OMhxRQKiAmE=
Message-ID: <a619e7b18c81e927fdd0b08509d1ca9d4299cdf9.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix dout logs for null pointers
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Mon, 17 Feb 2020 07:25:53 -0500
In-Reply-To: <20200217112806.30738-1-xiubli@redhat.com>
References: <20200217112806.30738-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-02-17 at 06:28 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> For example, if dentry and inode is NULL, the log will be:
> ceph:  lookup result=000000007a1ca695
> ceph:  submit_request on 0000000041d5070e for inode 000000007a1ca695
> 
> The will be confusing without checking the corresponding code carefully.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/dir.c        | 2 +-
>  fs/ceph/mds_client.c | 6 +++++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index ffeaff5bf211..245a262ec198 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -798,7 +798,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
>  	err = ceph_handle_snapdir(req, dentry, err);
>  	dentry = ceph_finish_lookup(req, dentry, err);
>  	ceph_mdsc_put_request(req);  /* will dput(dentry) */
> -	dout("lookup result=%p\n", dentry);
> +	dout("lookup result=%d\n", err);
>  	return dentry;
>  }
>  

The existing error handling in this function is really hard to follow
(the way that "err" is passed to subsequent functions). It really took
me a minute to figure out whether this change would make sense for all
the cases. I think it does, but it might be nice to do a larger
reorganization of this code if you're interested in improving it.

> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index b6aa357f7c61..e34f159d262b 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2772,7 +2772,11 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
>  		ceph_get_cap_refs(ceph_inode(req->r_old_dentry_dir),
>  				  CEPH_CAP_PIN);
>  
> -	dout("submit_request on %p for inode %p\n", req, dir);
> +	if (dir)
> +		dout("submit_request on %p for inode %p\n", req, dir);
> +	else
> +		dout("submit_request on %p\n", req);
> +
>  	mutex_lock(&mdsc->mutex);
>  	__register_request(mdsc, req, dir);
>  	__do_request(mdsc, req);


I'll merge into testing later today.
-- 
Jeff Layton <jlayton@kernel.org>

