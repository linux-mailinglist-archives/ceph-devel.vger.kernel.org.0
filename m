Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51E79150E21
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Feb 2020 17:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbgBCQtv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Feb 2020 11:49:51 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:41783 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbgBCQtu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Feb 2020 11:49:50 -0500
Received: by mail-il1-f193.google.com with SMTP id f10so13191012ils.8;
        Mon, 03 Feb 2020 08:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GhU9wtjsqVRaoLJq8aFiOJlgKDwAr9ROO9cHtAu8H9k=;
        b=LaIdyf4Cw+NYAWaylBWaFk5MXrqVGPDQBNpXLDkARoYYyZJgHu7fXmkLW5VKfkN2TO
         DKaAvzUi1AUrPJOixP1RB23WA9HOTeCElP4GoZn5GV4vyHxjJgwRyqjA0MwVry1LW/XS
         DuR1NPcr7wRIXT3kizCMTBVVzzfCl+N7Ea+aG5emPSNXWNOlkvXZS+G3d8cDpVm3H4YJ
         iSy3A+wAwchWsa6AoWnsKJIw0Yuw0UZGJLqB8m5OKZib/7L36xTmzQx8Pq4Oeiaf2sWn
         aPmtbXb5y558mhWgJD5FkzmBxJ9VPqJTvBfxRwP6XkEyz1Byatxsm2xoiykRAM4aUbW6
         aN5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GhU9wtjsqVRaoLJq8aFiOJlgKDwAr9ROO9cHtAu8H9k=;
        b=Jq4KtmqquKZjtvoBOflL3pTEFIv8Vs7kb/Hj3FbgA1kcDB8CsP+h+T2RF4xlHTwpa2
         hzyHTt+dGpZ+aXve3emUS6qLBbB1gwvSoYOmIkHv0fs5XUhC4e3y4PeZCusYeFK0A0Ix
         wvYzEVBZTXQRZu8pfepK/VFlNhY1IyBZEKtXkNiQu4BiZz4wlnVrBtqgidMqtxW5HnFl
         yk5sgq8na173kallE8oslxuMUmZvofSJUfel6PFj3Gq/6L22kaA2T/mYXgqrrtyRv6aA
         P56EevGUUfqVObUY0iyjalo0rPWPZkKkl5zwojYJEL1WJQzCbZCTW24J3M660CtBHmTG
         halA==
X-Gm-Message-State: APjAAAV398EbGVV8FaNdN8UAqn9L/rmBHhlzD7WEXexro+5IkhfbT5V7
        LCQ9uIqEgCpmMQgkAZ2UEMLnQzIegshsjA3M7o4=
X-Google-Smtp-Source: APXvYqw2Irq4a26oD8auMXfFOnZxZKn04pTq0ks6F8vEqYaf/ZLh+tde1mZ3/bAv9ivJ6mhdRkxZZmGqFPlGnrV385Y=
X-Received: by 2002:a92:b749:: with SMTP id c9mr15631740ilm.143.1580748589961;
 Mon, 03 Feb 2020 08:49:49 -0800 (PST)
MIME-Version: 1.0
References: <20200131103739.136098-1-hare@suse.de> <20200131103739.136098-3-hare@suse.de>
In-Reply-To: <20200131103739.136098-3-hare@suse.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 3 Feb 2020 17:50:03 +0100
Message-ID: <CAOi1vP--6qWHtifpeBVWRYOP8J_CC+fvKOkG7Xdsjoxaa7mrDQ@mail.gmail.com>
Subject: Re: [PATCH 02/15] rbd: use READ_ONCE() when checking the mapping size
To:     Hannes Reinecke <hare@suse.de>
Cc:     Sage Weil <sage@redhat.com>, Daniel Disseldorp <ddiss@suse.com>,
        Jens Axboe <axboe@kernel.dk>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jan 31, 2020 at 11:38 AM Hannes Reinecke <hare@suse.de> wrote:
>
> The mapping size is changed only very infrequently, so we don't
> need to take the header mutex for checking; using READ_ONCE()
> is sufficient here. And it avoids having to take a mutex in the
> hot path.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/block/rbd.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index db80b964d8ea..792180548e89 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -4788,13 +4788,13 @@ static void rbd_queue_workfn(struct work_struct *work)
>
>         blk_mq_start_request(rq);
>
> -       down_read(&rbd_dev->header_rwsem);
> -       mapping_size = rbd_dev->mapping.size;
> +       mapping_size = READ_ONCE(rbd_dev->mapping.size);
>         if (op_type != OBJ_OP_READ) {
> +               down_read(&rbd_dev->header_rwsem);
>                 snapc = rbd_dev->header.snapc;
>                 ceph_get_snap_context(snapc);
> +               up_read(&rbd_dev->header_rwsem);
>         }
> -       up_read(&rbd_dev->header_rwsem);
>
>         if (offset + length > mapping_size) {
>                 rbd_warn(rbd_dev, "beyond EOD (%llu~%llu > %llu)", offset,
> @@ -4981,9 +4981,9 @@ static int rbd_dev_refresh(struct rbd_device *rbd_dev)
>         u64 mapping_size;
>         int ret;
>
> -       down_write(&rbd_dev->header_rwsem);
> -       mapping_size = rbd_dev->mapping.size;
> +       mapping_size = READ_ONCE(rbd_dev->mapping.size);
>
> +       down_write(&rbd_dev->header_rwsem);
>         ret = rbd_dev_header_info(rbd_dev);
>         if (ret)
>                 goto out;
> @@ -4999,7 +4999,7 @@ static int rbd_dev_refresh(struct rbd_device *rbd_dev)
>         }
>
>         rbd_assert(!rbd_is_snap(rbd_dev));
> -       rbd_dev->mapping.size = rbd_dev->header.image_size;
> +       WRITE_ONCE(rbd_dev->mapping.size, rbd_dev->header.image_size);
>
>  out:
>         up_write(&rbd_dev->header_rwsem);

Does this result in a measurable performance improvement?

I'd rather not go down the READ/WRITE_ONCE path and continue using
proper locking, especially given that it's only for reads.  FWIW the
plan is to replace header_rwsem with a spin lock, after refactoring
header read-in code to use a private buffer instead of reading into
rbd_dev directly.

Thanks,

                Ilya
