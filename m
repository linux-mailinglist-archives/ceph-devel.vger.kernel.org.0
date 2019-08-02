Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45DF67FE9F
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Aug 2019 18:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391249AbfHBQck (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Aug 2019 12:32:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391044AbfHBQck (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 12:32:40 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6B4A2087E;
        Fri,  2 Aug 2019 16:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564763559;
        bh=1dY9dkZC8/0rNIVNPhWlmJIGw2Fn+nke+Cx8Y2WqslE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=w9lC7d/J2b2evJ3hdfblytM+pyTOBE5/6j/xetCh1lnfVbAKbgleAivNvwuv+cK+I
         juOFzY+Rq5aV9tnRvib3kGBa/z6jlMrK1IN4ONnBBuq1OVB8IUcUL3WnQd2pcxMRna
         m5sZdGkNIZrGL3/J2MK86MjLYi2o6z5PRXqYVpww=
Message-ID: <89f2fdcbd007dcf6bb2b01772a17eb63459cac9d.camel@kernel.org>
Subject: Re: [PATCH] fs/ceph: don't return a value from void function
From:   Jeff Layton <jlayton@kernel.org>
To:     john.hubbard@gmail.com
Cc:     Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>
Date:   Fri, 02 Aug 2019 12:32:37 -0400
In-Reply-To: <20190802010658.18150-1-jhubbard@nvidia.com>
References: <20190802010658.18150-1-jhubbard@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-08-01 at 18:06 -0700, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> This fixes a build warning to that effect.
> 
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
> 
> Hi,
> 
> I ran into this while working on unrelated changes, to
> convert ceph over to put_user_page().
> 
> This patch is against the latest linux.git.
> 
> thanks,
> John Hubbard
> NVIDIA
> 
> 
>  fs/ceph/debugfs.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 2eb88ed22993..facb387c2735 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -294,7 +294,6 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
>  
>  void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
>  {
> -	return 0;
>  }
>  
>  void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)

Thanks. Merged into ceph-client/testing branch, we'll see about getting
this to Linus before v5.3 ships.
-- 
Jeff Layton <jlayton@kernel.org>

