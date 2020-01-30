Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4334F14DD9A
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Jan 2020 16:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbgA3PJS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Jan 2020 10:09:18 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:40116 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbgA3PJS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 Jan 2020 10:09:18 -0500
Received: by mail-il1-f195.google.com with SMTP id i7so3326035ilr.7;
        Thu, 30 Jan 2020 07:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GC/poygtKvBBIZvJnNHjYeRR8D2MPET2VGqC3rP4nYo=;
        b=ovIVwrKvXLYKRf3xmQtnJMBhyfHLFoYXxsc/F4liEh/JO8poaAHknP2F7uyvLcHD/g
         qfY9e82VmnukdzZQPq6qVsW/kBwrBHa5QMe2NYb/03KVuXwVVdv9dHyECKREiNffFDgA
         GWyrJpRs0VtRkF+rPzAn3quqeRbYBnVaC7I8Gx6XE1hh8mZchDtlFCdH/1/qW+/xVQHO
         5+He8NxR6NcDUcW7Bo8y9T27BSvQivyfBvBvDRbdqRkKjzaVEagaHIhLH4DBMuvMnBGL
         LsD7+Dkcn4EF4XeN9PuDwMjKr6i7iGQxZgFjVh8P2PmzwUcCgjf+vVtsghaUGoUjEJp/
         GwIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GC/poygtKvBBIZvJnNHjYeRR8D2MPET2VGqC3rP4nYo=;
        b=MlRbXd1KTFT6Mj/zOBTNfn+eZnfEY6zloGsr3UQynXUEUrPnceQpzG0OykmKpdGt8h
         ZPPRMk3uAOzukliiMyGWzO60Mm0Sb7aARL+shKzSdS+09cHx4qf/lL77kO+TZHX0Dg7p
         NppQbDGHL/hsusxT4BxK41bKvd9FnsFo+WPRwIciCQgAdL75e4WUfzlXLOgMzKvIqr5D
         jTqv+p4r7igiBBYO51l2JL6MwGrgxLtVxeNKWwiQqU0sN6m8K3bN0q2L8Cj8U2wOqR1h
         yj68wkrHgbMQckqJxmTkunnZPftIkIK+LySN66m3+8gMpyRubIJFjpcdpJMoRb8y1oP1
         KvMg==
X-Gm-Message-State: APjAAAWvB0z76UoXEcQPMoMJMOCXTN3mjmCchfAm3f8bzTO8OyDqleoC
        TlaZnNXLPkwLJ+9Hv6CcNkQtX7fsoMTfXm+3x8s=
X-Google-Smtp-Source: APXvYqzYy0TIEceLJ3fe6VTt6jeWaFzKV7HOsUO4f8K89iToVQSMy1CUrCe8rQl7htF9NG1MBKfvA4EMRju1DZpa4/g=
X-Received: by 2002:a92:b749:: with SMTP id c9mr4734497ilm.143.1580396956440;
 Thu, 30 Jan 2020 07:09:16 -0800 (PST)
MIME-Version: 1.0
References: <20200130114258.8482-1-hare@suse.de>
In-Reply-To: <20200130114258.8482-1-hare@suse.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 30 Jan 2020 16:09:26 +0100
Message-ID: <CAOi1vP9AyPrNmU-=O8WVKd++vgWj8s=uiQgUCPMQ5Dwe-7aZsg@mail.gmail.com>
Subject: Re: [PATCH] rbd: lock object request list
To:     Hannes Reinecke <hare@suse.de>
Cc:     Sage Weil <sage@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jan 30, 2020 at 12:43 PM Hannes Reinecke <hare@suse.de> wrote:
>
> The object request list can be accessed from various contexts
> so we need to lock it to avoid concurrent modifications and
> random crashes.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/block/rbd.c | 31 ++++++++++++++++++++++++-------
>  1 file changed, 24 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 5710b2a8609c..ddc170661607 100644
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
> @@ -2510,7 +2515,7 @@ static int __rbd_img_fill_request(struct rbd_img_request *img_req)
>                         continue;
>                 }
>         }
> -
> +       mutex_unlock(&img_req->object_mutex);
>         img_req->state = RBD_IMG_START;
>         return 0;
>  }
> @@ -2569,6 +2574,7 @@ static int rbd_img_fill_request_nocopy(struct rbd_img_request *img_req,
>          * position in the provided bio (list) or bio_vec array.
>          */
>         fctx->iter = *fctx->pos;
> +       mutex_lock(&img_req->object_mutex);
>         for (i = 0; i < num_img_extents; i++) {
>                 ret = ceph_file_to_extents(&img_req->rbd_dev->layout,
>                                            img_extents[i].fe_off,
> @@ -2576,10 +2582,12 @@ static int rbd_img_fill_request_nocopy(struct rbd_img_request *img_req,
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
> @@ -2620,6 +2628,7 @@ static int rbd_img_fill_request(struct rbd_img_request *img_req,
>          * or bio_vec array because when mapped, those bio_vecs can straddle
>          * stripe unit boundaries.
>          */
> +       mutex_lock(&img_req->object_mutex);
>         fctx->iter = *fctx->pos;
>         for (i = 0; i < num_img_extents; i++) {
>                 ret = ceph_file_to_extents(&rbd_dev->layout,
> @@ -2629,15 +2638,17 @@ static int rbd_img_fill_request(struct rbd_img_request *img_req,
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
> @@ -2652,10 +2663,14 @@ static int rbd_img_fill_request(struct rbd_img_request *img_req,
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
> @@ -3552,6 +3567,7 @@ static void rbd_img_object_requests(struct rbd_img_request *img_req)
>
>         rbd_assert(!img_req->pending.result && !img_req->pending.num_pending);
>
> +       mutex_lock(&img_req->object_mutex);
>         for_each_obj_request(img_req, obj_req) {
>                 int result = 0;
>
> @@ -3564,6 +3580,7 @@ static void rbd_img_object_requests(struct rbd_img_request *img_req)
>                         img_req->pending.num_pending++;
>                 }
>         }
> +       mutex_unlock(&img_req->object_mutex);
>  }
>
>  static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)

Hi Hannes,

I'm afraid I don't immediately see the issue and the commit
message is very light on details.  Can you elaborate on what
concurrent modifications are possible?  An example of a crash?

Thanks,

                Ilya
