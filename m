Return-Path: <ceph-devel+bounces-867-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 43A288569BD
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 17:41:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68D1C1C244F9
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 16:41:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 094E3135A78;
	Thu, 15 Feb 2024 16:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r203VKEn"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC86135A68
	for <ceph-devel@vger.kernel.org>; Thu, 15 Feb 2024 16:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708015276; cv=none; b=HK8sLVOESTOC+MsIsDDmMUMsNStNZdQjhVvjm477azqwU7gyIGnVmPDnLIL5zMxGAN4e8mDSAUdPywk2CpQzIC8dyplkvnFJyiRyEoSBbtonsmzXryKh0CiwE3CuAv+eA5AsoJGVU2BU2IRNgUc0nUmOoOdlGTEQKRo7vISuPYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708015276; c=relaxed/simple;
	bh=OPOmUM8x/T6u7SG3sTcYlpplT+d4U1av3lPMC3w9wdo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EdhFmZHIy63qo1YJz3UivXj1E5Kxq35kpd6NoBjSCD3/WGbJQdsq9oTD7gB0D4PRKWByw+WlWS4tgZ1CIzVpqDisD26wHAJViPMesGU8MIu8VyDR+73GvopjeEjxUA7I9PuAi6Jqc4Fsev90sMvis+sRwVMXOdgOPOwC79ygNBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=r203VKEn; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-dcc73148611so1155995276.3
        for <ceph-devel@vger.kernel.org>; Thu, 15 Feb 2024 08:41:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708015274; x=1708620074; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=H4Op1mHkAoDc0mHLSW+FBWR2Je9xZ4vfS+3TMPGtYlI=;
        b=r203VKEn9ZKuLrbc7i1PNPMaPkSTrl7Lpt0ypR01aHJGIrCo8CFHdvWSCdJ7Cu5Ch9
         aT8BiAfq172f5AlUi5cVqHZxuIihWfNN7JWzCw8p632HXnAIwcVKIs+HnI9pYxP16ApD
         gZiuiQ4rdYCpPakhAQnKB5A2mLUtdPrmh66THKYUNibCygBK7hu9DP78YmzpbLxZXbG2
         PfI5BZiuR/ShICI6rkEMEHljtZoVXIrUUuURNKG+w0Co6mFpQa/gwxX1gpZDDBV424Em
         a7lrFFC+g0uZwagwWawZEhzw/ScoOpdw9yNH2fd+uwxnQjd578Kb5lVIXCyRkxNH3alA
         66jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708015274; x=1708620074;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H4Op1mHkAoDc0mHLSW+FBWR2Je9xZ4vfS+3TMPGtYlI=;
        b=vqlYL/YtwL1Ydw4dts1Iymw/1RLqszreRqZceOBEHCBmGSKCDgkwoCU0gKLS1j+lMd
         Zk6UrAX202jVMWp3ajqlNw4o2Qprd8SRmtepnIlIhmFyXNPjV7NlyqOJGWcgn2YPtmf5
         +h7huiesChAUv5FYDD4SN4mJSlXk8e14OT+lYZk5z55FnkUWLFvJp1E8ycH1uWpOPjIf
         rZA0pbGrakpK4FurgklzsQPs8kilOkYCpyB8c1Wccw25/1Nq9zU2XfkxS5QFvlamIq8q
         Y0+4GfpM8Hu3imHJvJWodRKydxYD5S5xfKpXosvSxXz3YhHf3MLMgBao5W3VFuiL0Lme
         foEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTaEmoAnIh+LELq2IDWR+oal6s+EbLMD360FHIEu7X1znFMWXLEQ4WT132Ja1TD9tXn5s0om9H7H5dJjx2Cc1CqDm3s4MrXPmtVA==
X-Gm-Message-State: AOJu0YxV0U6XOJo5JOEblzup53Ef7HXprZQSp4O2mlOSUU24NGnHEQZJ
	ZK4J3p4FZ+vXciyGWyajdNIi3Gs0YD+HRusI1msiIjl5jXwVnLEUeeQ1buDdxVkYYWR9G1J9RTm
	rbBiBoMeJQknuHeaZgvElxfz17FYFFv6N1c5nBQ==
X-Google-Smtp-Source: AGHT+IFKk2OJo3wt7UAgLQt1W8r38i0clrc+x8E5AwuuzUAnApHg2BAocf9JmfWpH758YmJPnpp1To3HfbUpjO81kIA=
X-Received: by 2002:a81:8492:0:b0:607:abfe:e82b with SMTP id
 u140-20020a818492000000b00607abfee82bmr2204534ywf.49.1708015273570; Thu, 15
 Feb 2024 08:41:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240215070300.2200308-1-hch@lst.de> <20240215070300.2200308-18-hch@lst.de>
In-Reply-To: <20240215070300.2200308-18-hch@lst.de>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Thu, 15 Feb 2024 17:40:37 +0100
Message-ID: <CAPDyKFqPnC9jwWnoVz+UVJJ_SGYnB4CrB8jmJOSxCnT7AYQrKg@mail.gmail.com>
Subject: Re: [PATCH 17/17] mmc: pass queue_limits to blk_mq_alloc_disk
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Justin Sanders <justin@coraid.com>, Denis Efremov <efremov@linux.com>, 
	Josef Bacik <josef@toxicpanda.com>, Geoff Levand <geoff@infradead.org>, 
	Ilya Dryomov <idryomov@gmail.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, 
	Jack Wang <jinpu.wang@ionos.com>, Ming Lei <ming.lei@redhat.com>, 
	Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Vineeth Vijayan <vneethv@linux.ibm.com>, linux-block@vger.kernel.org, nbd@other.debian.org, 
	ceph-devel@vger.kernel.org, linux-mmc@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 15 Feb 2024 at 08:04, Christoph Hellwig <hch@lst.de> wrote:
>
> Pass the queue limit set at initialization time directly to
> blk_mq_alloc_disk instead of updating it right after the allocation.
>
> This requires refactoring the code a bit so that what was mmc_setup_queue
> before also allocates the gendisk now and actually sets all limits.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks like $subject patch, patch11 and patch12  have already been
queued up as they are cooking linux-next. Normally I prefer to funnel
these via my mmc tree, to avoid potential conflicts (mostly for mmc,
where more active developments are ongoing).

Let's leave this as is for the moment, but if we encounter non-trivial
conflicts, I assume you can drop the patches from your tree?

Kind regards
Uffe




> ---
>  drivers/mmc/core/queue.c | 97 +++++++++++++++++++++-------------------
>  1 file changed, 52 insertions(+), 45 deletions(-)
>
> diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
> index 67ad186d132a69..2ae60d208cdf1e 100644
> --- a/drivers/mmc/core/queue.c
> +++ b/drivers/mmc/core/queue.c
> @@ -174,8 +174,8 @@ static struct scatterlist *mmc_alloc_sg(unsigned short sg_len, gfp_t gfp)
>         return sg;
>  }
>
> -static void mmc_queue_setup_discard(struct request_queue *q,
> -                                   struct mmc_card *card)
> +static void mmc_queue_setup_discard(struct mmc_card *card,
> +               struct queue_limits *lim)
>  {
>         unsigned max_discard;
>
> @@ -183,15 +183,17 @@ static void mmc_queue_setup_discard(struct request_queue *q,
>         if (!max_discard)
>                 return;
>
> -       blk_queue_max_discard_sectors(q, max_discard);
> -       q->limits.discard_granularity = card->pref_erase << 9;
> -       /* granularity must not be greater than max. discard */
> -       if (card->pref_erase > max_discard)
> -               q->limits.discard_granularity = SECTOR_SIZE;
> +       lim->max_hw_discard_sectors = max_discard;
>         if (mmc_can_secure_erase_trim(card))
> -               blk_queue_max_secure_erase_sectors(q, max_discard);
> +               lim->max_secure_erase_sectors = max_discard;
>         if (mmc_can_trim(card) && card->erased_byte == 0)
> -               blk_queue_max_write_zeroes_sectors(q, max_discard);
> +               lim->max_write_zeroes_sectors = max_discard;
> +
> +       /* granularity must not be greater than max. discard */
> +       if (card->pref_erase > max_discard)
> +               lim->discard_granularity = SECTOR_SIZE;
> +       else
> +               lim->discard_granularity = card->pref_erase << 9;
>  }
>
>  static unsigned short mmc_get_max_segments(struct mmc_host *host)
> @@ -341,40 +343,53 @@ static const struct blk_mq_ops mmc_mq_ops = {
>         .timeout        = mmc_mq_timed_out,
>  };
>
> -static void mmc_setup_queue(struct mmc_queue *mq, struct mmc_card *card)
> +static struct gendisk *mmc_alloc_disk(struct mmc_queue *mq,
> +               struct mmc_card *card)
>  {
>         struct mmc_host *host = card->host;
> -       unsigned block_size = 512;
> +       struct queue_limits lim = { };
> +       struct gendisk *disk;
>
> -       blk_queue_flag_set(QUEUE_FLAG_NONROT, mq->queue);
> -       blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, mq->queue);
>         if (mmc_can_erase(card))
> -               mmc_queue_setup_discard(mq->queue, card);
> +               mmc_queue_setup_discard(card, &lim);
>
>         if (!mmc_dev(host)->dma_mask || !*mmc_dev(host)->dma_mask)
> -               blk_queue_bounce_limit(mq->queue, BLK_BOUNCE_HIGH);
> -       blk_queue_max_hw_sectors(mq->queue,
> -               min(host->max_blk_count, host->max_req_size / 512));
> -       if (host->can_dma_map_merge)
> -               WARN(!blk_queue_can_use_dma_map_merging(mq->queue,
> -                                                       mmc_dev(host)),
> -                    "merging was advertised but not possible");
> -       blk_queue_max_segments(mq->queue, mmc_get_max_segments(host));
> -
> -       if (mmc_card_mmc(card) && card->ext_csd.data_sector_size) {
> -               block_size = card->ext_csd.data_sector_size;
> -               WARN_ON(block_size != 512 && block_size != 4096);
> -       }
> +               lim.bounce = BLK_BOUNCE_HIGH;
> +
> +       lim.max_hw_sectors = min(host->max_blk_count, host->max_req_size / 512);
> +
> +       if (mmc_card_mmc(card) && card->ext_csd.data_sector_size)
> +               lim.logical_block_size = card->ext_csd.data_sector_size;
> +       else
> +               lim.logical_block_size = 512;
> +
> +       WARN_ON_ONCE(lim.logical_block_size != 512 &&
> +                    lim.logical_block_size != 4096);
>
> -       blk_queue_logical_block_size(mq->queue, block_size);
>         /*
> -        * After blk_queue_can_use_dma_map_merging() was called with succeed,
> -        * since it calls blk_queue_virt_boundary(), the mmc should not call
> -        * both blk_queue_max_segment_size().
> +        * Setting a virt_boundary implicity sets a max_segment_size, so try
> +        * to set the hardware one here.
>          */
> -       if (!host->can_dma_map_merge)
> -               blk_queue_max_segment_size(mq->queue,
> -                       round_down(host->max_seg_size, block_size));
> +       if (host->can_dma_map_merge) {
> +               lim.virt_boundary_mask = dma_get_merge_boundary(mmc_dev(host));
> +               lim.max_segments = MMC_DMA_MAP_MERGE_SEGMENTS;
> +       } else {
> +               lim.max_segment_size =
> +                       round_down(host->max_seg_size, lim.logical_block_size);
> +               lim.max_segments = host->max_segs;
> +       }
> +
> +       disk = blk_mq_alloc_disk(&mq->tag_set, &lim, mq);
> +       if (IS_ERR(disk))
> +               return disk;
> +       mq->queue = disk->queue;
> +
> +       if (mmc_host_is_spi(host) && host->use_spi_crc)
> +               blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, mq->queue);
> +       blk_queue_rq_timeout(mq->queue, 60 * HZ);
> +
> +       blk_queue_flag_set(QUEUE_FLAG_NONROT, mq->queue);
> +       blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, mq->queue);
>
>         dma_set_max_seg_size(mmc_dev(host), queue_max_segment_size(mq->queue));
>
> @@ -386,6 +401,7 @@ static void mmc_setup_queue(struct mmc_queue *mq, struct mmc_card *card)
>         init_waitqueue_head(&mq->wait);
>
>         mmc_crypto_setup_queue(mq->queue, host);
> +       return disk;
>  }
>
>  static inline bool mmc_merge_capable(struct mmc_host *host)
> @@ -447,18 +463,9 @@ struct gendisk *mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card)
>                 return ERR_PTR(ret);
>
>
> -       disk = blk_mq_alloc_disk(&mq->tag_set, NULL, mq);
> -       if (IS_ERR(disk)) {
> +       disk = mmc_alloc_disk(mq, card);
> +       if (IS_ERR(disk))
>                 blk_mq_free_tag_set(&mq->tag_set);
> -               return disk;
> -       }
> -       mq->queue = disk->queue;
> -
> -       if (mmc_host_is_spi(host) && host->use_spi_crc)
> -               blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, mq->queue);
> -       blk_queue_rq_timeout(mq->queue, 60 * HZ);
> -
> -       mmc_setup_queue(mq, card);
>         return disk;
>  }
>
> --
> 2.39.2
>

