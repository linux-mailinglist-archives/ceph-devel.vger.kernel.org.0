Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67E80150EE3
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Feb 2020 18:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgBCRrY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Feb 2020 12:47:24 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:41461 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbgBCRrX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Feb 2020 12:47:23 -0500
Received: by mail-il1-f193.google.com with SMTP id f10so13364149ils.8;
        Mon, 03 Feb 2020 09:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lM51eLuQhYGUT+VHcEoTQk25G0DTfoFQ5ELZgazCGjA=;
        b=fslihnLQe5zgCAH3KUPMJM0psqhjaI/wlVgHAZnw3fmoXW1Zo254zmNnZiJku8qvi4
         G+X9ggQCXgY6PPN/Wa/7Mw8DzgjcEA4hkWnjjivpEjHrnutiSmm8QkMLjHgzIwHoYMz7
         cJ+/Bz+XE1QruU4XbhqMyzEl3diNhnycySKxILHG3kdIjVF4U/JYxexGaNDNyD6bRqYT
         9iL0tPFjasPBG20/Dq4FGhnebED6gQmYLqlL7m/8EXwrA/bJ3bDuU9SbWWTas0rmp9pd
         9JIWVQgk1QiY/q7mu5ivyrRH18vpAKuPJe42/++7wY9PZyrXbRK5Z7Q87hayI71D7Y8x
         niNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lM51eLuQhYGUT+VHcEoTQk25G0DTfoFQ5ELZgazCGjA=;
        b=J0cb0ZFqFjeC3wJJdq6ISBRayjPQcEz85sT85L/uwsM4ZegePPvY9p0UKl6lzOEcEp
         CJpsQQCsWO5N6qIBPD1XHXyiQoXte41oszYy699KSiOh/aHzYrXxhDpw2c3ScMIKAy+g
         va0segm539W7qF1lkgG4p7oLukSNwWOOepmq7K44/obw2pJ/behGeTEOoCa8/OeYKADS
         as1lEYH02SVvl4yK4EKhWxQXjLDl5BrO+QuFwBq15AcLagh/XAl0LCBqv3JYGoS0pjIs
         kNRMgYxGY7WhCXtL1fVGCFptJtk9buw8YGCubESJHdkeZGpmZ/1wtzwhItzih4BfCoJ6
         IDtw==
X-Gm-Message-State: APjAAAUIShw0wXtlxNBMr7irlnW/LwBusLqU19pBo0nsOVVn2QatIvwq
        bUkBCDhyErR73uT8m1jahsiOZC6hyHLYcqux5uQ=
X-Google-Smtp-Source: APXvYqxQ4nlNF4WSzLtfDN6iT3GeDnDj3xJnGO0CyAHVb7Vsi0jjaXKuovANETaXqK3X+0ZFffUNqHg31NkX8YEefLQ=
X-Received: by 2002:a92:3991:: with SMTP id h17mr16902018ilf.131.1580752042699;
 Mon, 03 Feb 2020 09:47:22 -0800 (PST)
MIME-Version: 1.0
References: <20200131103739.136098-1-hare@suse.de> <20200131103739.136098-10-hare@suse.de>
In-Reply-To: <20200131103739.136098-10-hare@suse.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 3 Feb 2020 18:47:36 +0100
Message-ID: <CAOi1vP9Z=7XPO3N7jajEG0eJDSUF+xnvn+arfU-waubra9pg-A@mail.gmail.com>
Subject: Re: [PATCH 09/15] rbd: count pending object requests in-line
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
> Instead of having a counter for outstanding object requests
> check the state and count only those which are not in the final
> state.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/block/rbd.c | 41 ++++++++++++++++++++++++++++++-----------
>  1 file changed, 30 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index b708f5ecda07..a6c95b6e9c0c 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -350,7 +350,7 @@ struct rbd_img_request {
>         struct mutex            object_mutex;
>
>         struct mutex            state_mutex;
> -       struct pending_result   pending;
> +       int                     pending_result;
>         struct work_struct      work;
>         int                     work_result;
>         struct kref             kref;
> @@ -3602,11 +3602,12 @@ static int rbd_img_exclusive_lock(struct rbd_img_request *img_req)
>         return 0;
>  }
>
> -static void rbd_img_object_requests(struct rbd_img_request *img_req)
> +static int rbd_img_object_requests(struct rbd_img_request *img_req)
>  {
>         struct rbd_obj_request *obj_req;
> +       int num_pending = 0;
>
> -       rbd_assert(!img_req->pending.result && !img_req->pending.num_pending);
> +       rbd_assert(!img_req->pending_result);
>
>         mutex_lock(&img_req->object_mutex);
>         for_each_obj_request(img_req, obj_req) {
> @@ -3617,15 +3618,33 @@ static void rbd_img_object_requests(struct rbd_img_request *img_req)
>                              __func__, obj_req, obj_req->img_request,
>                              img_req, result);
>                         if (result) {
> -                               img_req->pending.result = result;
> -                               mutex_unlock(&img_req->object_mutex);
> -                               return;
> +                               img_req->pending_result = result;
> +                               break;
>                         }
>                 } else {
> -                       img_req->pending.num_pending++;
> +                       num_pending++;
>                 }
>         }
>         mutex_unlock(&img_req->object_mutex);
> +       return num_pending;
> +}
> +
> +static int rbd_img_object_requests_pending(struct rbd_img_request *img_req)
> +{
> +       struct rbd_obj_request *obj_req;
> +       int num_pending = 0;
> +
> +       mutex_lock(&img_req->object_mutex);
> +       for_each_obj_request(img_req, obj_req) {
> +               if (obj_req->obj_state > 1)
> +                       num_pending++;
> +               else if (WARN_ON(obj_req->obj_state == 1))
> +                       num_pending++;
> +               else if (WARN_ON(obj_req->pending.num_pending))
> +                       num_pending++;
> +       }
> +       mutex_unlock(&img_req->object_mutex);
> +       return num_pending;
>  }
>
>  static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
> @@ -3658,16 +3677,16 @@ static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
>                            __rbd_is_lock_owner(rbd_dev));
>
>                 img_req->state = RBD_IMG_OBJECT_REQUESTS;
> -               rbd_img_object_requests(img_req);
> -               if (!img_req->pending.num_pending) {
> -                       *result = img_req->pending.result;
> +               if (!rbd_img_object_requests(img_req)) {
> +                       *result = img_req->pending_result;
>                         img_req->state = RBD_IMG_DONE;
>                         return true;
>                 }
>                 return false;
>         case RBD_IMG_OBJECT_REQUESTS:
> -               if (!pending_result_dec(&img_req->pending, result))
> +               if (rbd_img_object_requests_pending(img_req))
>                         return false;
> +               *result = img_req->pending_result;
>                 img_req->state = RBD_IMG_DONE;
>                 /* fall through */
>         case RBD_IMG_DONE:

This is just to be able to drop img_req->state_mutex in patch 11,
right?

Thanks,

                Ilya
