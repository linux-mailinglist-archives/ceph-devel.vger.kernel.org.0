Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D349571623
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jul 2019 12:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731003AbfGWKfw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 23 Jul 2019 06:35:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbfGWKfv (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 06:35:51 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A220223DD;
        Tue, 23 Jul 2019 10:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563878150;
        bh=SwSNXJQxLYKzFP08JGpvbUdpAJ5BS2tuAlAShX0OZxo=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=zFqjNcP1x9Y9ZJHhmoBKAobmqFsioJ1zUPTRE33ZksFsWv1Gy5VDl4W6xrBSin4rX
         n8ethSaC1CzmhRcqi4zNOH4qYdzkHl4QDFTiyKJ4cBjD5u4pD53T9EWTOHXyxZzomb
         pC1g5RumsAi7Fb7kdqfWL74b/D9kadV2BiyWjSm8=
Message-ID: <6ee307ee11261d9e1c5beb73ffbb4cc750415227.camel@kernel.org>
Subject: Re: [PATCH] ceph: clear page dirty before invalidate page
From:   Jeff Layton <jlayton@kernel.org>
To:     erqi chen <chenerqi@gmail.com>, ceph-devel@vger.kernel.org
Date:   Tue, 23 Jul 2019 06:35:49 -0400
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

It might be cleaner to just add:

    && clear_page_dirty_for_io(page)

to the existing if statement -- that will reduce the level of
indentation (which is already pretty far here).

> +                               }
>                                 unlock_page(page);
>                                 continue;
>                         }
> --
> 1.8.3.1

This patch looks good at first glance, but there is some whitespace
damage here and it does not apply. It looks like you may have cut and
pasted it into an email? Could you resend it? Maybe look into using
the git-send-email script to send it.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

