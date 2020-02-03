Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A741150CA1
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Feb 2020 17:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730993AbgBCQiO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Feb 2020 11:38:14 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:43431 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731371AbgBCQiM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Feb 2020 11:38:12 -0500
Received: by mail-io1-f68.google.com with SMTP id n21so17421059ioo.10;
        Mon, 03 Feb 2020 08:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YOqEOwhpgBCRWfqs4eVovSKNPouGhlHCZPG60JDisiY=;
        b=FmeKHisAYbanhuQieHxEWHYYW5P9TY7gEXUsKcii09+QZqFvt7GUXLPh+qSozGPmaf
         RmB5boj9itacuvwkxDqg3tQsVlbOrAh6DpyEHgHe1pIlunHaRMaSu05KJzaZaKCP1jaR
         6G+i3+0aQoRYe7mAEtraTiGIrUAwb2J68Kq3j6SEuqC+A6Mo8Qh0w52HsmdT7l3qdGig
         26vvB8o1/Xq6M5dkyr4XBNqgqcovsd5sB1JoB1UovrVTJmNyljMGoMtfxfkiewf2C59Q
         V3a2iaml/wojGja3v4kewRHjD81gPUfHBAk7UORRzNQkrKLu872nYq4tRJ6sctlDHO8U
         Ky1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YOqEOwhpgBCRWfqs4eVovSKNPouGhlHCZPG60JDisiY=;
        b=hnxcn7g/gteyscgV04oXCCR0r06WBokQ8hgUe5PLLxVsszKeAbDOueBG7oroE4/hgj
         Q3LQ7R3/VKvbqBq7Lvl+49BHFARj8Uk/Q38lJwolJbTkPXKRgG6B+XbeeNot3tj91B3S
         wwGDQHG8RMU6UpZwPHc6SevCateumawCs7MVMIp6RVjBdD8IdOTAmj2DwpAW0rboBNQm
         qu4ER3Az0Rd9SvZAicdAgGlcxwoDXj1nuh7K0ps90iVZa4Mpow13hBWEhqoVJ2R8fjGZ
         1k5dHlXS3VU1aF188ncKg7x2Qdrv81vH/r6G7Qxk168R3+ElB9ANn9BYYefm1VNCDCRb
         gFvw==
X-Gm-Message-State: APjAAAXPIBonIrO7GbH2IGAR7/AbWRumWkCKbdpUfL9nkn01i7FkuaF2
        nvZ2WPIDhixPnd9SNpvo939AHgOEAamUbnUawNo=
X-Google-Smtp-Source: APXvYqxGlH6p7TlhVQ+lD4L0pLUsCW4emnxr1suKJoe38k9GfWePbaZ31QCGAbCEdn+z0BnpxdfHw53GV2a4CkKuUBw=
X-Received: by 2002:a6b:17c4:: with SMTP id 187mr19235416iox.143.1580747890550;
 Mon, 03 Feb 2020 08:38:10 -0800 (PST)
MIME-Version: 1.0
References: <20200131103739.136098-1-hare@suse.de> <20200131103739.136098-2-hare@suse.de>
In-Reply-To: <20200131103739.136098-2-hare@suse.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 3 Feb 2020 17:38:23 +0100
Message-ID: <CAOi1vP-ecyUEY2taqVsSBHXTUop513CssjLHS4Xn_YTOURwAjg@mail.gmail.com>
Subject: Re: [PATCH 01/15] rbd: lock object request list
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
> The object request list can be accessed from various contexts
> so we need to lock it to avoid concurrent modifications and
> random crashes.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/block/rbd.c | 36 ++++++++++++++++++++++++++++--------
>  1 file changed, 28 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 5710b2a8609c..db80b964d8ea 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -344,6 +344,7 @@ struct rbd_img_request {
>
>         struct list_head        lock_item;
>         struct list_head        object_extents; /* obj_req.ex structs */
> +       struct mutex            object_mutex;
>
>         struct mutex            state_mutex;
>         struct pending_result   pending;
> @@ -1664,6 +1665,7 @@ static struct rbd_img_request *rbd_img_request_create(
>         INIT_LIST_HEAD(&img_request->lock_item);
>         INIT_LIST_HEAD(&img_request->object_extents);
>         mutex_init(&img_request->state_mutex);
> +       mutex_init(&img_request->object_mutex);
>         kref_init(&img_request->kref);
>
>         return img_request;
> @@ -1680,8 +1682,10 @@ static void rbd_img_request_destroy(struct kref *kref)
>         dout("%s: img %p\n", __func__, img_request);
>
>         WARN_ON(!list_empty(&img_request->lock_item));
> +       mutex_lock(&img_request->object_mutex);
>         for_each_obj_request_safe(img_request, obj_request, next_obj_request)
>                 rbd_img_obj_request_del(img_request, obj_request);
> +       mutex_unlock(&img_request->object_mutex);
>
>         if (img_request_layered_test(img_request)) {
>                 img_request_layered_clear(img_request);
> @@ -2486,6 +2490,7 @@ static int __rbd_img_fill_request(struct rbd_img_request *img_req)
>         struct rbd_obj_request *obj_req, *next_obj_req;
>         int ret;
>
> +       mutex_lock(&img_req->object_mutex);
>         for_each_obj_request_safe(img_req, obj_req, next_obj_req) {
>                 switch (img_req->op_type) {
>                 case OBJ_OP_READ:
> @@ -2503,14 +2508,16 @@ static int __rbd_img_fill_request(struct rbd_img_request *img_req)
>                 default:
>                         BUG();
>                 }
> -               if (ret < 0)
> +               if (ret < 0) {
> +                       mutex_unlock(&img_req->object_mutex);
>                         return ret;
> +               }
>                 if (ret > 0) {
>                         rbd_img_obj_request_del(img_req, obj_req);
>                         continue;
>                 }
>         }
> -
> +       mutex_unlock(&img_req->object_mutex);
>         img_req->state = RBD_IMG_START;
>         return 0;
>  }
> @@ -2569,6 +2576,7 @@ static int rbd_img_fill_request_nocopy(struct rbd_img_request *img_req,
>          * position in the provided bio (list) or bio_vec array.
>          */
>         fctx->iter = *fctx->pos;
> +       mutex_lock(&img_req->object_mutex);
>         for (i = 0; i < num_img_extents; i++) {
>                 ret = ceph_file_to_extents(&img_req->rbd_dev->layout,
>                                            img_extents[i].fe_off,
> @@ -2576,10 +2584,12 @@ static int rbd_img_fill_request_nocopy(struct rbd_img_request *img_req,
>                                            &img_req->object_extents,
>                                            alloc_object_extent, img_req,
>                                            fctx->set_pos_fn, &fctx->iter);
> -               if (ret)
> +               if (ret) {
> +                       mutex_unlock(&img_req->object_mutex);
>                         return ret;
> +               }
>         }
> -
> +       mutex_unlock(&img_req->object_mutex);
>         return __rbd_img_fill_request(img_req);
>  }
>
> @@ -2620,6 +2630,7 @@ static int rbd_img_fill_request(struct rbd_img_request *img_req,
>          * or bio_vec array because when mapped, those bio_vecs can straddle
>          * stripe unit boundaries.
>          */
> +       mutex_lock(&img_req->object_mutex);
>         fctx->iter = *fctx->pos;
>         for (i = 0; i < num_img_extents; i++) {
>                 ret = ceph_file_to_extents(&rbd_dev->layout,
> @@ -2629,15 +2640,17 @@ static int rbd_img_fill_request(struct rbd_img_request *img_req,
>                                            alloc_object_extent, img_req,
>                                            fctx->count_fn, &fctx->iter);
>                 if (ret)
> -                       return ret;
> +                       goto out_unlock;
>         }
>
>         for_each_obj_request(img_req, obj_req) {
>                 obj_req->bvec_pos.bvecs = kmalloc_array(obj_req->bvec_count,
>                                               sizeof(*obj_req->bvec_pos.bvecs),
>                                               GFP_NOIO);
> -               if (!obj_req->bvec_pos.bvecs)
> -                       return -ENOMEM;
> +               if (!obj_req->bvec_pos.bvecs) {
> +                       ret = -ENOMEM;
> +                       goto out_unlock;
> +               }
>         }
>
>         /*
> @@ -2652,10 +2665,14 @@ static int rbd_img_fill_request(struct rbd_img_request *img_req,
>                                            &img_req->object_extents,
>                                            fctx->copy_fn, &fctx->iter);
>                 if (ret)
> -                       return ret;
> +                       goto out_unlock;
>         }
> +       mutex_unlock(&img_req->object_mutex);
>
>         return __rbd_img_fill_request(img_req);
> +out_unlock:
> +       mutex_unlock(&img_req->object_mutex);
> +       return ret;
>  }
>
>  static int rbd_img_fill_nodata(struct rbd_img_request *img_req,
> @@ -3552,18 +3569,21 @@ static void rbd_img_object_requests(struct rbd_img_request *img_req)
>
>         rbd_assert(!img_req->pending.result && !img_req->pending.num_pending);
>
> +       mutex_lock(&img_req->object_mutex);
>         for_each_obj_request(img_req, obj_req) {
>                 int result = 0;
>
>                 if (__rbd_obj_handle_request(obj_req, &result)) {
>                         if (result) {
>                                 img_req->pending.result = result;
> +                               mutex_unlock(&img_req->object_mutex);
>                                 return;
>                         }
>                 } else {
>                         img_req->pending.num_pending++;
>                 }
>         }
> +       mutex_unlock(&img_req->object_mutex);
>  }
>
>  static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)

Hi Hannes,

I asked for this in the previous posting, can you explain what
concurrent modifications are possible?  If you observed crashes,
please share stack traces.  This patch sounds like urgent material,
but I can't move forward on it until I understand the issue.

Thanks,

                Ilya
