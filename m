Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 890BF72E1C
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2019 13:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbfGXLtJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Jul 2019 07:49:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726981AbfGXLtJ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 24 Jul 2019 07:49:09 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAB4722387;
        Wed, 24 Jul 2019 11:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563968948;
        bh=GfjQLYrBW6t/XkTZjIJu96vZFb0i15fesaB8xGyHz1w=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=C0ogcS393aRbOwCIT1OQLuPNzDuaXsM2gVuMHDrPJR1q71z+R5SR8nuy3MEqKKUUo
         TDiXkR61ZoOE7XcUXRD8TH08zpptVMIqyls1Kmi6Grdne8R3leOkRba461R7gKoJs6
         u4zQxSd+KTHEWPRSuOWsvvskAfhGQvARQybwOdK4=
Message-ID: <fd1289099c1580de7b3c0dee21959dd657fe147c.camel@kernel.org>
Subject: Re: [PATCH] ceph: clear page dirty before invalidate page
From:   Jeff Layton <jlayton@kernel.org>
To:     erqi chen <chenerqi@gmail.com>, ceph-devel@vger.kernel.org
Date:   Wed, 24 Jul 2019 07:49:06 -0400
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

Thanks for the patch!

This one looks good. I'm running some tests and they look good so far. I
will plan to merge this into the testing branch later today assuming
there are no issues.
-- 
Jeff Layton <jlayton@kernel.org>

