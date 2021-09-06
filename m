Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B0A401F0A
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Sep 2021 19:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243996AbhIFRMM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Sep 2021 13:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243951AbhIFRMJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Sep 2021 13:12:09 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7C6C061796
        for <ceph-devel@vger.kernel.org>; Mon,  6 Sep 2021 10:10:58 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id c8so14550468lfi.3
        for <ceph-devel@vger.kernel.org>; Mon, 06 Sep 2021 10:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CW74dcoV+jr+H/cOee9EJDtMnYKDaAeGSoGkoOfBh0A=;
        b=fiBYOjOq+VBGQV/Z/w0zPvWtW2UdpSWfKvNcpoxD+K0WhuhAtoceEVoeVxOgsHPOhv
         efrzRbDV+uvCfhjgMPpEAyHUjdY3TNBRGO2ascjrj0a8sJkn7E+gp/dr4pWniQgzRRQF
         q98akxIU254+B/rN3gPB3vS2zoJRULAlh32sYQ3MgkDWtN5OmaO+jI6cVC8P0jEcXZjM
         5J9yOudkRCUkuEmbSVcv7bhsnzpejWiq8jfUXL/v/giNNCifV/BladKTn0Y7v9egF/vN
         7pklhCc4DE5X6amh2/h+2STJm39f2wwFex5emYYC4FcRMupzl4VSdjFxUGanzZUlpoBw
         tJyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CW74dcoV+jr+H/cOee9EJDtMnYKDaAeGSoGkoOfBh0A=;
        b=EcgZd7/0X7Xoh9vQgPKQT3adQ8xyuXt+kUk5rlAqH6o16naQBg60RIf/Djm0F0bLsG
         XO0YwfJ299gjGL7mxe227j/rKXmJWV2sC3gVFzBXmkCClheaF9GHVCZRNVf0txcizjDY
         +lujpts2i6bYRuppBFKzp4/IPmjTzt6z6V8JW01G9OKg9JRZD5xkLqp6pUdKqQ5+o+ru
         KeJuMWoc0TxHoXZcLhqXNKjocD3V0xCq6RDBDXsI1zJBKQwAYUu+IxsrkdZYHK+GpQpX
         CrweZP5nXnw18W+Ehmvfi1YMS6r7y554pDYH4l1MNlWJ77HA0jQr5D5kvRfykW4D5AQW
         Wq5w==
X-Gm-Message-State: AOAM532HPub5vJ81Ul7DHjXVoRjlIs8hrA0IhXjDn+RsT6yvluf+kIOJ
        +cl9TygivdNToOtHF51LIqLi6dIWtKVlN5XGvkPPZg==
X-Google-Smtp-Source: ABdhPJyhjHArMca68TR5pTBXzBL9tRGf14Q3uN8WTnzHOdYd8ltoCuxOYH+yY9mOHeyJ4NbktZ7AcuCVRlMvz/GSBvU=
X-Received: by 2002:a19:dc47:: with SMTP id f7mr9888628lfj.71.1630948256412;
 Mon, 06 Sep 2021 10:10:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210902174105.2418771-1-mcgrof@kernel.org> <20210902174105.2418771-3-mcgrof@kernel.org>
In-Reply-To: <20210902174105.2418771-3-mcgrof@kernel.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Mon, 6 Sep 2021 19:10:20 +0200
Message-ID: <CAPDyKFoZ1QqPMYi=N=3s2058mnbzcXYPodNFkexCi0eTbD4NmQ@mail.gmail.com>
Subject: Re: [PATCH 2/9] ms_block: add error handling support for add_disk()
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        chaitanya.kulkarni@wdc.com, atulgopinathan@gmail.com,
        Hannes Reinecke <hare@suse.de>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>,
        Colin King <colin.king@canonical.com>,
        Shubhankar Kuranagatti <shubhankarvk@gmail.com>,
        Jia-Ju Bai <baijiaju1990@gmail.com>, Tom Rix <trix@redhat.com>,
        dongsheng.yang@easystack.cn, ceph-devel@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh R <vigneshr@ti.com>, sth@linux.ibm.com,
        hoeppner@linux.ibm.com, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        oberpar@linux.ibm.com, Tejun Heo <tj@kernel.org>,
        linux-s390@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2 Sept 2021 at 19:41, Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> We never checked for errors on add_disk() as this function
> returned void. Now that this is fixed, use the shiny new
> error handling.
>
> Contrary to the typical removal which delays the put_disk()
> until later, since we are failing on a probe we immediately
> put the disk on failure from add_disk by using
> blk_cleanup_disk().
>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

Queued for v5.16 on the temporary devel branch, thanks!

Kind regards
Uffe


> ---
>  drivers/memstick/core/ms_block.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
> index 4a4573fa7b0f..86c626933c1a 100644
> --- a/drivers/memstick/core/ms_block.c
> +++ b/drivers/memstick/core/ms_block.c
> @@ -2156,10 +2156,14 @@ static int msb_init_disk(struct memstick_dev *card)
>                 set_disk_ro(msb->disk, 1);
>
>         msb_start(card);
> -       device_add_disk(&card->dev, msb->disk, NULL);
> +       rc = device_add_disk(&card->dev, msb->disk, NULL);
> +       if (rc)
> +               goto out_cleanup_disk;
>         dbg("Disk added");
>         return 0;
>
> +out_cleanup_disk:
> +       blk_cleanup_disk(msb->disk);
>  out_free_tag_set:
>         blk_mq_free_tag_set(&msb->tag_set);
>  out_release_id:
> --
> 2.30.2
>
