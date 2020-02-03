Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05B5A150F0D
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Feb 2020 19:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729424AbgBCSBh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Feb 2020 13:01:37 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:40375 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgBCSBh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Feb 2020 13:01:37 -0500
Received: by mail-io1-f67.google.com with SMTP id x1so17736699iop.7;
        Mon, 03 Feb 2020 10:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z9057ta5cgBUrBBYxo7ttO773bFS2liOdA8y8tESSGA=;
        b=hX1fAH9H79vSzNpD6rWHAWOhZZu8r7dZ+KJRsLklE67b/T5ATk8SgcnL3KjmFteeui
         8F8bQtzJbRy3tnXw4BwpWKjl/pTZ6FDi4tWIDHNUiO3akY/BZNm6vy8T4bAZeWOfoDxn
         TnjaSdjs+/8RyxB4R3fk7oQgDw8RZUnOlcgFhETFt5uhdn9eko8dx7tvfx6kS7ts+n05
         psjTxPhmWGw++MXUDD+GKdrDH1/G+2nhXM1UvJlGyfucXJ1I2SDjHAl/Z+n/MtDsKNDj
         WL1npOjC3j40MV5Muxpuy3M0Sej4MeaycRk4TA+QGdercVcWJX4OYi0qkt/m7q/6LzYU
         yzaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z9057ta5cgBUrBBYxo7ttO773bFS2liOdA8y8tESSGA=;
        b=qjYBfjzyB3928kyXu/uwIOpquzFFeHSzRp+nQb2wzkTQLg2jaLlzqMuRJnsOgVh4WI
         g4NAQ+BS+FudnOi4YWKV2dy1sv9K+95ZbB+oQATo4tAPi3OEE5OOY+vh9kErwP1KzgYm
         I+HAxh4VdQk8REt1wHg3jaaruakYM8WqbXTPgaa1MNxdoDBcDxIzkvBoiFQlyRTY/JUv
         uTGNR95Ocit6V3KnrS7obU7EhpmQTXEEKdY/fev2q+b7VbNwAtdb0Z1z89Rel797rtJj
         XuBF7Zz2N4s6KK4pxIhdgjLLCB0Ea4lsaNOTZutoGBhhP3bnvIqDG8YXNTah+98Pve8v
         U6VA==
X-Gm-Message-State: APjAAAUef6fIQEcHkel8E1v/3DZTUACOJsyizJkzH/X8ulUeAZ+isAXP
        KJ2ZWIh3w9zevfJ5NyIneduJ5ntZCUKzUcJ4iFc=
X-Google-Smtp-Source: APXvYqxoqzreMF4QG6Btb0eXSkGiZPeePJ8ycqkURTFiAeSO8LWiVvwH/cUXyJvssRqbFO8aYTvYvI9KBPkZ2/wcJnU=
X-Received: by 2002:a5d:9707:: with SMTP id h7mr20874326iol.112.1580752896623;
 Mon, 03 Feb 2020 10:01:36 -0800 (PST)
MIME-Version: 1.0
References: <20200131103739.136098-1-hare@suse.de> <20200131103739.136098-12-hare@suse.de>
In-Reply-To: <20200131103739.136098-12-hare@suse.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 3 Feb 2020 19:01:49 +0100
Message-ID: <CAOi1vP-x5whO0U8oECsgGB0K2FyEnMFUKW=uQJrjQ_1cgeRYww@mail.gmail.com>
Subject: Re: [PATCH 11/15] rbd: drop state_mutex in __rbd_img_handle_request()
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
> The use of READ_ONCE/WRITE_ONCE for the image request state allows
> us to drop the state_mutex in __rbd_img_handle_request().
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/block/rbd.c | 26 +++++++++-----------------
>  1 file changed, 9 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 671e941d6edf..db04401c4d8b 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -349,7 +349,6 @@ struct rbd_img_request {
>         struct list_head        object_extents; /* obj_req.ex structs */
>         struct mutex            object_mutex;
>
> -       struct mutex            state_mutex;
>         int                     pending_result;
>         struct work_struct      work;
>         struct kref             kref;
> @@ -1674,7 +1673,6 @@ static struct rbd_img_request *rbd_img_request_create(
>
>         INIT_LIST_HEAD(&img_request->lock_item);
>         INIT_LIST_HEAD(&img_request->object_extents);
> -       mutex_init(&img_request->state_mutex);
>         mutex_init(&img_request->object_mutex);
>         kref_init(&img_request->kref);
>
> @@ -2529,7 +2527,7 @@ static int __rbd_img_fill_request(struct rbd_img_request *img_req)
>                 }
>         }
>         mutex_unlock(&img_req->object_mutex);
> -       img_req->state = RBD_IMG_START;
> +       WRITE_ONCE(img_req->state, RBD_IMG_START);
>         return 0;
>  }
>
> @@ -3652,15 +3650,15 @@ static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
>         int ret;
>
>         dout("%s: img %p state %d\n", __func__, img_req, img_req->state);
> -       switch (img_req->state) {
> +       switch (READ_ONCE(img_req->state)) {
>         case RBD_IMG_START:
>                 rbd_assert(!*result);
>
> -               img_req->state = RBD_IMG_EXCLUSIVE_LOCK;
> +               WRITE_ONCE(img_req->state, RBD_IMG_EXCLUSIVE_LOCK);
>                 ret = rbd_img_exclusive_lock(img_req);
>                 if (ret < 0) {
>                         *result = ret;
> -                       img_req->state = RBD_IMG_DONE;
> +                       WRITE_ONCE(img_req->state, RBD_IMG_DONE);
>                         return true;
>                 }
>                 if (ret == 0)
> @@ -3668,17 +3666,17 @@ static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
>                 /* fall through */
>         case RBD_IMG_EXCLUSIVE_LOCK:
>                 if (*result) {
> -                       img_req->state = RBD_IMG_DONE;
> +                       WRITE_ONCE(img_req->state, RBD_IMG_DONE);
>                         return true;
>                 }
>
>                 rbd_assert(!need_exclusive_lock(img_req) ||
>                            __rbd_is_lock_owner(rbd_dev));
>
> -               img_req->state = RBD_IMG_OBJECT_REQUESTS;
> +               WRITE_ONCE(img_req->state, RBD_IMG_OBJECT_REQUESTS);
>                 if (!rbd_img_object_requests(img_req)) {
>                         *result = img_req->pending_result;
> -                       img_req->state = RBD_IMG_DONE;
> +                       WRITE_ONCE(img_req->state, RBD_IMG_DONE);
>                         return true;
>                 }
>                 return false;
> @@ -3686,7 +3684,7 @@ static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
>                 if (rbd_img_object_requests_pending(img_req))
>                         return false;
>                 *result = img_req->pending_result;
> -               img_req->state = RBD_IMG_DONE;
> +               WRITE_ONCE(img_req->state, RBD_IMG_DONE);
>                 /* fall through */
>         case RBD_IMG_DONE:
>                 return true;
> @@ -3706,16 +3704,12 @@ static bool __rbd_img_handle_request(struct rbd_img_request *img_req,
>
>         if (need_exclusive_lock(img_req)) {
>                 down_read(&rbd_dev->lock_rwsem);
> -               mutex_lock(&img_req->state_mutex);
>                 done = rbd_img_advance(img_req, result);
>                 if (done)
>                         rbd_lock_del_request(img_req);
> -               mutex_unlock(&img_req->state_mutex);
>                 up_read(&rbd_dev->lock_rwsem);
>         } else {
> -               mutex_lock(&img_req->state_mutex);
>                 done = rbd_img_advance(img_req, result);
> -               mutex_unlock(&img_req->state_mutex);
>         }
>
>         if (done && *result) {
> @@ -3985,10 +3979,8 @@ static void wake_lock_waiters(struct rbd_device *rbd_dev, int result)
>         }
>
>         list_for_each_entry(img_req, &rbd_dev->acquiring_list, lock_item) {
> -               mutex_lock(&img_req->state_mutex);
> -               rbd_assert(img_req->state == RBD_IMG_EXCLUSIVE_LOCK);
> +               rbd_assert(READ_ONCE(img_req->state) == RBD_IMG_EXCLUSIVE_LOCK);
>                 rbd_img_schedule(img_req, result);
> -               mutex_unlock(&img_req->state_mutex);
>         }
>
>         list_splice_tail_init(&rbd_dev->acquiring_list, &rbd_dev->running_list);

->state_mutex doesn't just protect ->state or ->pending_result,
it is meant to be a code lock.  In the future, we will be adding
support for timeouts and forceful unmapping of rbd devices, which
means cancelling requests at arbitrary points.  These state machines
need to be reentrant, not just from the inside (i.e. object requests)
but also from the outside.  Getting that right when ->state is managed
through READ/WRITE_ONCE and must be carefully set before dispatching
anything that might change it is going to be very challenging.

In the cover letter, this patch is listed as one of the required
steps for up to 25% speedup.  Is that really the case?  It doesn't
make top-30 contended locks in my tests...

Do you have the numbers without this and any of the preceding patches
or possibly just with patch 15?

Thanks,

                Ilya
