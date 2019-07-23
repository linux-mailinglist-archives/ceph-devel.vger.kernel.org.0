Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A255B715F8
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jul 2019 12:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730841AbfGWKZY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 23 Jul 2019 06:25:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726680AbfGWKZY (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 06:25:24 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0460622512;
        Tue, 23 Jul 2019 10:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563877523;
        bh=bRoKxIwnszcHzyV4O1FN5gXV2WKnJOwklk9TMRe6LWo=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=CI6SiDV/5ZFlEOgPsX9Z6azJvF8/fz+JD7DhjMLqKM58PeGJd5MhNZBGUMFGzQROl
         5WGCzNUpoCBKpTpPBJ2Rk73w9nZJz1bmX2okUvV6kVNOp84wc9sHUHUBH6pd91pL7q
         ssNcyuFRTFerfWaTWbeANuXi4/yuC9CnaF5pN41E=
Message-ID: <c98281cba3c3c38de4f19d7de3e7af37ac966bf6.camel@kernel.org>
Subject: Re: [PATCH] ceph: clear page dirty before invalidate page
From:   Jeff Layton <jlayton@kernel.org>
To:     erqi chen <chenerqi@gmail.com>, ceph-devel@vger.kernel.org
Date:   Tue, 23 Jul 2019 06:25:21 -0400
In-Reply-To: <CA+eEYqX6OkHEF0AhQ5E7DbSF16So7W0wiff=2uhgm9dmtsQGjQ@mail.gmail.com>
References: <CA+eEYqX6OkHEF0AhQ5E7DbSF16So7W0wiff=2uhgm9dmtsQGjQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-07-23 at 15:55 +0800, erqi chen wrote:
> From: Erqi Chen <chenerqi@gmail.com>
> 
> clear_page_dirty_for_io(page) before mapping->a_ops->invalidatepage().
> invalidatepage() clears page's private flag, if dirty flag is not
> cleared, the page may cause BUG_ON failure in ceph_set_page_dirty().
> 
> Fixes: https://tracker.ceph.com/issues/40862
> Signed-off-by: Erqi Chen chenerqi@gmail.com
> ---
>  fs/ceph/addr.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index e078cc5..5ad63bf 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -914,9 +914,11 @@ static int ceph_writepages_start(struct
> address_space *mapping,
>                                 dout("%p page eof %llu\n",
>                                      page, ceph_wbc.i_size);
>                                 if (ceph_wbc.size_stable ||
> -                                   page_offset(page) >= i_size_read(inode))
> -                                       mapping->a_ops->invalidatepage(page,
> -                                                               0, PAGE_SIZE);
> +                                   page_offset(page) >= i_size_read(inode)) {
> +                                   if (clear_page_dirty_for_io(page))
> +                                       mapping->a_ops->invalidatepage(page,
> +                                                               0, PAGE_SIZE);
> +                               }
>                                 unlock_page(page);
>                                 continue;
>                         }
> --
> 1.8.3.1

Looks good. I'll plan to do a bit of testing with this today and then
merge it into the testing branch.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

