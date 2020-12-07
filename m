Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431902D142F
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Dec 2020 15:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgLGO6J (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Dec 2020 09:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbgLGO6J (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Dec 2020 09:58:09 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0F8C061749;
        Mon,  7 Dec 2020 06:57:29 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id y9so12448868ilb.0;
        Mon, 07 Dec 2020 06:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BdzMWmghWMnmqJzPNphPqafzWOiOvEaXvaPDnRpTyig=;
        b=XAbT0sIGBd/lF/JpvMHWnpZhkY6ndEKj+4VNfzBQa+YwFTpXwWhd82chdPi99aEdtR
         TJfRyYD7rqsjkjYOtmVR9fkbdH3SXZii52oM+mc7xsE2GI5CyRu3lDB5DFVOX0Af3saH
         0cjWRLbl/3VTVuxnR1/sgozX4ifKxZUAfq4kodrdjf3JSrfLySW6hU2/h036dSXZpwaB
         18HvdbtEJo5jUs6y+1SKBCyHRXkiQO7CjoMU6QSHtFzOZBSKYKdTczI+DuJa6vgfQbH2
         Brt5cucKMyHJWrLnvsxu8EpYRjASHs0KY0TzYcT1fT3m7V1bjRnp79R2unvmGEr9iWbw
         gVRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BdzMWmghWMnmqJzPNphPqafzWOiOvEaXvaPDnRpTyig=;
        b=UL8X68euvIHcDDz1UE/Hbh7iZ7NqdmC3jgotkGvTqG4vAnfUxJ+Kl/Ey64p34hIv9O
         60HlJ8/GGUFTLue7jn8NlcpkH4GXe4fdEfNrGMC+wgINlYTMLOI5TAoM83FVywvSVzVS
         83ouOmNeATWwyZ1PIQHYG7lxQr5qiVHeqlZuj9NQJYrxjGfEB6xlYVy+qXEFFrFEuoMp
         VnQprKAszDW06I7SUSChzIJjQVpsrYljTp+rj5nQmnZjFfAzD0Lf/0siwbKDt34QzJvA
         wgJgqSuO+VEcFSIwaXVrajrMnEwAuMPq8Y+KYg/itl5x9ZkevdexkNBzvNGjlZkSWibw
         6YwA==
X-Gm-Message-State: AOAM533Y6Vo0ISoYOBYKaM3S3C1yBurbWYoXFsoQJ/JzPH3qX1jF7Ac0
        r7+dQMsvZeh3Vxs9d/thPxrgrbcykQyYWJsdtd4=
X-Google-Smtp-Source: ABdhPJzWgUFyUwn4oRQGFwhc7sjEZmk8MIUigwiYjc70guXN2OnSLrKLaIK50f+C57huiWudj+gdKgGdrTXAcHcP4D8=
X-Received: by 2002:a92:4c3:: with SMTP id 186mr21869621ile.177.1607353048343;
 Mon, 07 Dec 2020 06:57:28 -0800 (PST)
MIME-Version: 1.0
References: <20201207131918.2252553-1-hch@lst.de> <20201207131918.2252553-6-hch@lst.de>
In-Reply-To: <20201207131918.2252553-6-hch@lst.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 7 Dec 2020 15:57:21 +0100
Message-ID: <CAOi1vP9q7iGLmDryWJ0Duk2uQODr5W=5RCt2GAAxKk+N_k9OOg@mail.gmail.com>
Subject: Re: [PATCH 5/6] rbd: remove the ->set_read_only method
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Oleksii Kurochko <olkuroch@cisco.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Mike Snitzer <snitzer@redhat.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        dm-devel@redhat.com, linux-block <linux-block@vger.kernel.org>,
        linux-nvme@lists.infradead.org, Hannes Reinecke <hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Dec 7, 2020 at 2:21 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Now that the hardware read-only state can't be changed by the BLKROSET
> ioctl, the code in this method is not required anymore.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/block/rbd.c | 19 -------------------
>  1 file changed, 19 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 2ed79b09439a82..2c64ca15ca079f 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -692,29 +692,10 @@ static void rbd_release(struct gendisk *disk, fmode_t mode)
>         put_device(&rbd_dev->dev);
>  }
>
> -static int rbd_set_read_only(struct block_device *bdev, bool ro)
> -{
> -       struct rbd_device *rbd_dev = bdev->bd_disk->private_data;
> -
> -       /*
> -        * Both images mapped read-only and snapshots can't be marked
> -        * read-write.
> -        */
> -       if (!ro) {
> -               if (rbd_is_ro(rbd_dev))
> -                       return -EROFS;
> -
> -               rbd_assert(!rbd_is_snap(rbd_dev));
> -       }
> -
> -       return 0;
> -}
> -
>  static const struct block_device_operations rbd_bd_ops = {
>         .owner                  = THIS_MODULE,
>         .open                   = rbd_open,
>         .release                = rbd_release,
> -       .set_read_only          = rbd_set_read_only,
>  };
>
>  /*
> --
> 2.29.2
>

If nothing can mess with read-only state after set_disk_ro(disk, true),
looks good.

Acked-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya
