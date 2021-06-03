Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB1B39A4C9
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Jun 2021 17:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhFCPkN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Jun 2021 11:40:13 -0400
Received: from mail-ua1-f54.google.com ([209.85.222.54]:45790 "EHLO
        mail-ua1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhFCPkH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 3 Jun 2021 11:40:07 -0400
Received: by mail-ua1-f54.google.com with SMTP id m23so3515173uao.12
        for <ceph-devel@vger.kernel.org>; Thu, 03 Jun 2021 08:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7DKVf+GiS9951bpd4cfEBh88PiRutTQ//wVEud26id8=;
        b=XGhrfqnzBbfnTVSNkFDv5GHmpnKX09udhfIYlIGvsHf5udWupM3hEeaCuAp1/iGcK2
         itxazCeDLeGnN0Ew9V7mjQKrXGASjKXLT43xef2dS4qB5N1wZq329ew5d1FZXKKcqiVw
         6FD/vr0CrXQkvA5Vx5CUZuiBjtgVFz1ZbiUU7kgR3MEWuPhMcO948V0XjU30zv2QSu9a
         tohz+jrjUWOtrbk55SyLep3Y8Ie2TFo0EIpc+U1g5ZdabSEhCf2ga/7pzz9IJem82LbC
         xz7dKg0/t3XaDdcBysnSaVg/DwjADlBkyj4crHUSmvNFlYRf/JXspkWoLbMUskTXooPD
         5/eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7DKVf+GiS9951bpd4cfEBh88PiRutTQ//wVEud26id8=;
        b=DEwqtwNDMx6vd4CK5JG6YiJnhj2669IfDGsgn30kMsMXJfK71ZcjUFanoivF11aMkG
         LraYzJslai+VqvM4o92WkC/JLQzdSDPxd14OxYbM2jlJyvNJ7x6EFmOEhD8aAg+IFyC6
         mT9JVPRf/UdUACPaMacuXDivwT0ObvWCHXUB99V92vqUY4C+T9qUZwSHQP2SR3XTSNNi
         q91O0oGzI34PuDHTmGP1hK9hj9qhiGemz83KCgrX3YeVRwh6pENSys2LI9+kioHjPIHj
         AGl3SscaLXI9MbOFqi3j8GE/QfbOA3b66QrZtQRNUgR9ewvhodsoG/FKB3LfYaP2ZmOx
         WHxw==
X-Gm-Message-State: AOAM530rRDSgbNhO/FXjnWBdsROsjRGisSMYzOkxXVhre7b6YCn6m20B
        Xso4i73xxi16pCbHGxAaCny7h3D8tZEfrvVoDxTkcg==
X-Google-Smtp-Source: ABdhPJyc/MDglzj7ZqHuKLnfpO6vVPHNJJJjAhghObYaMjdvGQtxzeGy+jhwPjnJIpGZowWwyMtWi1MuD2fSyYUnfEo=
X-Received: by 2002:ab0:7c5b:: with SMTP id d27mr407242uaw.15.1622734642855;
 Thu, 03 Jun 2021 08:37:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210602065345.355274-1-hch@lst.de> <20210602065345.355274-9-hch@lst.de>
In-Reply-To: <20210602065345.355274-9-hch@lst.de>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 3 Jun 2021 17:36:45 +0200
Message-ID: <CAPDyKFoh6HKx2rHHRXvw--Ou53TR2wLFGrKCDuetigxQ8QbvfQ@mail.gmail.com>
Subject: Re: [PATCH 08/30] mspro: use blk_mq_alloc_disk
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Justin Sanders <justin@coraid.com>,
        Denis Efremov <efremov@linux.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Tim Waugh <tim@cyberelk.net>,
        Geoff Levand <geoff@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        dm-devel@redhat.com, linux-block <linux-block@vger.kernel.org>,
        nbd@other.debian.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2 Jun 2021 at 08:54, Christoph Hellwig <hch@lst.de> wrote:
>
> Use the blk_mq_alloc_disk API to simplify the gendisk and request_queue
> allocation.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe


> ---
>  drivers/memstick/core/mspro_block.c | 26 +++++++++++---------------
>  1 file changed, 11 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
> index cf7fe0d58ee7..22778d0e24f5 100644
> --- a/drivers/memstick/core/mspro_block.c
> +++ b/drivers/memstick/core/mspro_block.c
> @@ -1205,21 +1205,17 @@ static int mspro_block_init_disk(struct memstick_dev *card)
>         if (disk_id < 0)
>                 return disk_id;
>
> -       msb->disk = alloc_disk(1 << MSPRO_BLOCK_PART_SHIFT);
> -       if (!msb->disk) {
> -               rc = -ENOMEM;
> +       rc = blk_mq_alloc_sq_tag_set(&msb->tag_set, &mspro_mq_ops, 2,
> +                                    BLK_MQ_F_SHOULD_MERGE);
> +       if (rc)
>                 goto out_release_id;
> -       }
>
> -       msb->queue = blk_mq_init_sq_queue(&msb->tag_set, &mspro_mq_ops, 2,
> -                                               BLK_MQ_F_SHOULD_MERGE);
> -       if (IS_ERR(msb->queue)) {
> -               rc = PTR_ERR(msb->queue);
> -               msb->queue = NULL;
> -               goto out_put_disk;
> +       msb->disk = blk_mq_alloc_disk(&msb->tag_set, card);
> +       if (IS_ERR(msb->disk)) {
> +               rc = PTR_ERR(msb->disk);
> +               goto out_free_tag_set;
>         }
> -
> -       msb->queue->queuedata = card;
> +       msb->queue = msb->disk->queue;
>
>         blk_queue_max_hw_sectors(msb->queue, MSPRO_BLOCK_MAX_PAGES);
>         blk_queue_max_segments(msb->queue, MSPRO_BLOCK_MAX_SEGS);
> @@ -1228,10 +1224,10 @@ static int mspro_block_init_disk(struct memstick_dev *card)
>
>         msb->disk->major = major;
>         msb->disk->first_minor = disk_id << MSPRO_BLOCK_PART_SHIFT;
> +       msb->disk->minors = 1 << MSPRO_BLOCK_PART_SHIFT;
>         msb->disk->fops = &ms_block_bdops;
>         msb->usage_count = 1;
>         msb->disk->private_data = msb;
> -       msb->disk->queue = msb->queue;
>
>         sprintf(msb->disk->disk_name, "mspblk%d", disk_id);
>
> @@ -1247,8 +1243,8 @@ static int mspro_block_init_disk(struct memstick_dev *card)
>         msb->active = 1;
>         return 0;
>
> -out_put_disk:
> -       put_disk(msb->disk);
> +out_free_tag_set:
> +       blk_mq_free_tag_set(&msb->tag_set);
>  out_release_id:
>         mutex_lock(&mspro_block_disk_lock);
>         idr_remove(&mspro_block_disk_idr, disk_id);
> --
> 2.30.2
>
