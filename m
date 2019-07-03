Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 536275E92F
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 18:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfGCQdr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 12:33:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726928AbfGCQdq (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 12:33:46 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 052E9218A0;
        Wed,  3 Jul 2019 16:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562171625;
        bh=ktNAerFGbQZn3KVT3pQ8NIyte4UTPdVi/RkhIoUEYeo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JH3JQyp8x3l/vUTh+Hsf30HbLDYNfC9EAhVTElQ4ll0liaA/by7Sh4APCpGyEcQ/t
         PSD3lSxHAkdxXpj+yG15iQj7UOByHbCY+erwZKC33eyPZKUNdedP2WQFo8PZvPwn6u
         tJkf3P9G7cByKDDWdT2FkLxcLyIzz30vyM0qQ0Do=
Message-ID: <e3f1ecd6f68ed34df240346fae92f9c821503c68.camel@kernel.org>
Subject: Re: [PATCH v2 04/35] block: Use kmemdup rather than duplicating its
 implementation
From:   Jeff Layton <jlayton@kernel.org>
To:     Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Alex Elder <elder@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 03 Jul 2019 12:33:43 -0400
In-Reply-To: <20190703162650.32045-1-huangfq.daxian@gmail.com>
References: <20190703162650.32045-1-huangfq.daxian@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-07-04 at 00:26 +0800, Fuqian Huang wrote:
> kmemdup is introduced to duplicate a region of memory in a neat way.
> Rather than kmalloc/kzalloc + memcpy, which the programmer needs to
> write the size twice (sometimes lead to mistakes), kmemdup improves
> readability, leads to smaller code and also reduce the chances of mistakes.
> Suggestion to use kmemdup rather than using kmalloc/kzalloc + memcpy.
> 
> Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
> ---
> Changes in v2:
>   - Fix a typo in commit message (memset -> memcpy)
> 
>  drivers/block/rbd.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index e5009a34f9c2..47ad3772dc58 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -1068,7 +1068,7 @@ static int rbd_header_from_disk(struct rbd_device *rbd_dev,
>  
>  		if (snap_names_len > (u64)SIZE_MAX)
>  			goto out_2big;
> -		snap_names = kmalloc(snap_names_len, GFP_KERNEL);
> +		snap_names = kmemdup(&ondisk->snaps[snap_count], snap_names_len, GFP_KERNEL);
>  		if (!snap_names)
>  			goto out_err;
>  
> @@ -1088,7 +1088,6 @@ static int rbd_header_from_disk(struct rbd_device *rbd_dev,
>  		 * snap_names_len bytes beyond the end of the
>  		 * snapshot id array, this memcpy() is safe.
>  		 */
> -		memcpy(snap_names, &ondisk->snaps[snap_count], snap_names_len);
>  		snaps = ondisk->snaps;
>  		for (i = 0; i < snap_count; i++) {
>  			snapc->snaps[i] = le64_to_cpu(snaps[i].id);

Reviewed-by: Jeff Layton <jlayton@kernel.org>

