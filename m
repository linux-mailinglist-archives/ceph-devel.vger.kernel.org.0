Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C02385E0EE
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 11:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfGCJWV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 05:22:21 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37602 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbfGCJWV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Jul 2019 05:22:21 -0400
Received: by mail-io1-f65.google.com with SMTP id e5so3127114iok.4
        for <ceph-devel@vger.kernel.org>; Wed, 03 Jul 2019 02:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MR4UJYIukhcj9pFbdGiRdej5x4YMgqx+dUE46NgK5uU=;
        b=O6XbBKuKIxqMG70R8KSXAyrLG4eNnbgoBCSpb1KKwhUYulYb1on7zJa3sLo0JeTrj2
         QcNJPgEutWCohv8L58lAQA/hYhoy6ioLwT7t+eqRZPfSyuJ0t04hWCe4jZTBucYeqEWx
         7wrRNL9mDLLvbn8G03P0TBvSAQB8XXVEMppO9YLELiF532CptBXKVSnUYOOz0wrIh0Tt
         0XG3JfbPXyMYT+AHEZig5kG873CnsVfi/fXqeSPZTdcfx40xxoCxt18fVR4+yVd/78Ns
         zv2eNXUyt/+4jJPK2yvMH+3wk4MFT+buuNafRdJD3vxVvs1j/KBHeNHolOVQu+XcSPyv
         l9kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MR4UJYIukhcj9pFbdGiRdej5x4YMgqx+dUE46NgK5uU=;
        b=Audd7dvAoc+/dqCjGZP0NI2y9Ah0/weWXHEGCD5oQuQWhhyGoloRFZ4/IPvfajkB+G
         +JJ5gbDuFfte7Dl4nTeQmpyHBwr1z3HBfSRKUaQSZAuMDr3K+X7djVgUEIjXNhSAiEJf
         wnK/FY8PvuztHZkWRheIZmuYVJK92yzAB1U/nJgd9zTnlVC7YnR4EIXHkZ2PGAjJWOUj
         RfN7oS09NRMY1xtPZD7jF2nQ0VU78VEoNOoiZNIzkhGfCuAh9WCc/0FnWH8G6eCONC7g
         3kRSXu5R1aR6hfI86S77gsJJ4q56xwHQMmFSgC5ouYE0ZOcbAIFvsTkGWhAHjYzQrFiA
         D0lw==
X-Gm-Message-State: APjAAAVaHGVOC/yiNJPrY2MtZhqzO73ZFRXUjs4cAxKkbSEzJR88JXrL
        y0MVBje7nmCV2pzVDKh5qELb/Ch5uQeuwdQvjWcY2iZX
X-Google-Smtp-Source: APXvYqyGszoVun6kPyh7/LRZORrhbhcLJfJBoE+V9JvccOA2Iw/BLG8KieGV9m/QACMKgKKW5A/5SxY5UmL8uO7UIjc=
X-Received: by 2002:a02:7c2:: with SMTP id f185mr41979189jaf.16.1562145739875;
 Wed, 03 Jul 2019 02:22:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190625144111.11270-1-idryomov@gmail.com> <20190625144111.11270-15-idryomov@gmail.com>
 <5D199A43.1060005@easystack.cn>
In-Reply-To: <5D199A43.1060005@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 3 Jul 2019 11:24:59 +0200
Message-ID: <CAOi1vP-Z1nMYOArZ2hH9H2=j+CXO=D3+R82wz3EFjaJjrrxkrQ@mail.gmail.com>
Subject: Re: [PATCH 14/20] rbd: new exclusive lock wait/wake code
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jul 1, 2019 at 7:29 AM Dongsheng Yang
<dongsheng.yang@easystack.cn> wrote:
>
>
>
> On 06/25/2019 10:41 PM, Ilya Dryomov wrote:
> > rbd_wait_state_locked() is built around rbd_dev->lock_waitq and blocks
> > rbd worker threads while waiting for the lock, potentially impacting
> > other rbd devices.  There is no good way to pass an error code into
> > image request state machines when acquisition fails, hence the use of
> > RBD_DEV_FLAG_BLACKLISTED for everything and various other issues.
> >
> > Introduce rbd_dev->acquiring_list and move acquisition into image
> > request state machine.  Use rbd_img_schedule() for kicking and passing
> > error codes.  No blocking occurs while waiting for the lock, but
> > rbd_dev->lock_rwsem is still held across lock, unlock and set_cookie
> > calls.
> >
> > Always acquire the lock on "rbd map" to avoid associating the latency
> > of acquiring the lock with the first I/O request.
> >
> > A slight regression is that lock_timeout is now respected only if lock
> > acquisition is triggered by "rbd map" and not by I/O.  This is somewhat
> > compensated by the fact that we no longer block if the peer refuses to
> > release lock -- I/O is failed with EROFS right away.
> >
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
>
> Great, that's really what we need. Just two small question inline.

Yeah, long overdue!  The next step is exclusive lock state machine and
no lock_rwsem across lock, unlock and set_cookie calls.

>
> Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> > ---
> >   drivers/block/rbd.c | 325 +++++++++++++++++++++++++-------------------
> >   1 file changed, 182 insertions(+), 143 deletions(-)
> >
> > diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> > index 59d1fef35663..fd3f248ba9c2 100644
> > --- a/drivers/block/rbd.c
> > +++ b/drivers/block/rbd.c
> > @@ -312,6 +312,7 @@ enum img_req_flags {
> >
> >   enum rbd_img_state {
> >       RBD_IMG_START = 1,
> > +     RBD_IMG_EXCLUSIVE_LOCK,
> >       __RBD_IMG_OBJECT_REQUESTS,
> >       RBD_IMG_OBJECT_REQUESTS,
> >   };
> > @@ -412,9 +413,11 @@ struct rbd_device {
> >       struct delayed_work     lock_dwork;
> >       struct work_struct      unlock_work;
> >       spinlock_t              lock_lists_lock;
> > +     struct list_head        acquiring_list;
> >       struct list_head        running_list;
> > +     struct completion       acquire_wait;
> > +     int                     acquire_err;
> >       struct completion       releasing_wait;
> > -     wait_queue_head_t       lock_waitq;
> >
> >       struct workqueue_struct *task_wq;
> >
> > @@ -442,12 +445,10 @@ struct rbd_device {
> >    * Flag bits for rbd_dev->flags:
> >    * - REMOVING (which is coupled with rbd_dev->open_count) is protected
> >    *   by rbd_dev->lock
> > - * - BLACKLISTED is protected by rbd_dev->lock_rwsem
> >    */
> >   enum rbd_dev_flags {
> >       RBD_DEV_FLAG_EXISTS,    /* mapped snapshot has not been deleted */
> >       RBD_DEV_FLAG_REMOVING,  /* this mapping is being removed */
> > -     RBD_DEV_FLAG_BLACKLISTED, /* our ceph_client is blacklisted */
> >   };
> >
> >   static DEFINE_MUTEX(client_mutex);  /* Serialize client creation */
> > @@ -500,6 +501,8 @@ static int minor_to_rbd_dev_id(int minor)
> >
> >   static bool __rbd_is_lock_owner(struct rbd_device *rbd_dev)
> >   {
> > +     lockdep_assert_held(&rbd_dev->lock_rwsem);
> > +
> >       return rbd_dev->lock_state == RBD_LOCK_STATE_LOCKED ||
> >              rbd_dev->lock_state == RBD_LOCK_STATE_RELEASING;
> >   }
> > @@ -2895,15 +2898,21 @@ static bool need_exclusive_lock(struct rbd_img_request *img_req)
> >       return rbd_img_is_write(img_req);
> >   }
> >
> > -static void rbd_lock_add_request(struct rbd_img_request *img_req)
> > +static bool rbd_lock_add_request(struct rbd_img_request *img_req)
> >   {
> >       struct rbd_device *rbd_dev = img_req->rbd_dev;
> > +     bool locked;
> >
> >       lockdep_assert_held(&rbd_dev->lock_rwsem);
> > +     locked = rbd_dev->lock_state == RBD_LOCK_STATE_LOCKED;
> >       spin_lock(&rbd_dev->lock_lists_lock);
> >       rbd_assert(list_empty(&img_req->lock_item));
> > -     list_add_tail(&img_req->lock_item, &rbd_dev->running_list);
> > +     if (!locked)
> > +             list_add_tail(&img_req->lock_item, &rbd_dev->acquiring_list);
> > +     else
> > +             list_add_tail(&img_req->lock_item, &rbd_dev->running_list);
> >       spin_unlock(&rbd_dev->lock_lists_lock);
> > +     return locked;
> >   }
> >
> >   static void rbd_lock_del_request(struct rbd_img_request *img_req)
> > @@ -2922,6 +2931,30 @@ static void rbd_lock_del_request(struct rbd_img_request *img_req)
> >               complete(&rbd_dev->releasing_wait);
> >   }
> >
> > +static int rbd_img_exclusive_lock(struct rbd_img_request *img_req)
> > +{
> > +     struct rbd_device *rbd_dev = img_req->rbd_dev;
> > +
> > +     if (!need_exclusive_lock(img_req))
> > +             return 1;
> > +
> > +     if (rbd_lock_add_request(img_req))
> > +             return 1;
> > +
> > +     if (rbd_dev->opts->exclusive) {
> > +             WARN_ON(1); /* lock got released? */
> > +             return -EROFS;
> > +     }
> > +
> > +     /*
> > +      * Note the use of mod_delayed_work() in rbd_acquire_lock()
> > +      * and cancel_delayed_work() in wake_requests().
> > +      */
> > +     dout("%s rbd_dev %p queueing lock_dwork\n", __func__, rbd_dev);
> > +     queue_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork, 0);
> > +     return 0;
> > +}
> > +
> >   static void rbd_img_object_requests(struct rbd_img_request *img_req)
> >   {
> >       struct rbd_obj_request *obj_req;
> > @@ -2944,11 +2977,30 @@ static void rbd_img_object_requests(struct rbd_img_request *img_req)
> >
> >   static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
> >   {
> > +     struct rbd_device *rbd_dev = img_req->rbd_dev;
> > +     int ret;
> > +
> >   again:
> >       switch (img_req->state) {
> >       case RBD_IMG_START:
> >               rbd_assert(!*result);
> >
> > +             ret = rbd_img_exclusive_lock(img_req);
> > +             if (ret < 0) {
> > +                     *result = ret;
> > +                     return true;
> > +             }
> > +             img_req->state = RBD_IMG_EXCLUSIVE_LOCK;
> > +             if (ret > 0)
> > +                     goto again;
> > +             return false;
> > +     case RBD_IMG_EXCLUSIVE_LOCK:
> > +             if (*result)
> > +                     return true;
> > +
> > +             rbd_assert(!need_exclusive_lock(img_req) ||
> > +                        __rbd_is_lock_owner(rbd_dev));
> > +
> >               rbd_img_object_requests(img_req);
> >               if (!img_req->pending.num_pending) {
> >                       *result = img_req->pending.result;
> > @@ -3107,7 +3159,7 @@ static void rbd_unlock(struct rbd_device *rbd_dev)
> >       ret = ceph_cls_unlock(osdc, &rbd_dev->header_oid, &rbd_dev->header_oloc,
> >                             RBD_LOCK_NAME, rbd_dev->lock_cookie);
> >       if (ret && ret != -ENOENT)
> > -             rbd_warn(rbd_dev, "failed to unlock: %d", ret);
> > +             rbd_warn(rbd_dev, "failed to unlock header: %d", ret);
> >
> >       /* treat errors as the image is unlocked */
> >       rbd_dev->lock_state = RBD_LOCK_STATE_UNLOCKED;
> > @@ -3234,15 +3286,30 @@ static int rbd_request_lock(struct rbd_device *rbd_dev)
> >       goto out;
> >   }
> >
> > -static void wake_requests(struct rbd_device *rbd_dev, bool wake_all)
> > +static void wake_requests(struct rbd_device *rbd_dev, int result)
> This code cover two cases I think,
> (1) rbd mapping to waiting acquire_wait,
> (2) img_request state machine in RBD_IMG_EXCLUSIVE_LOCK.
>
> So the case (1) is not waking *requests* actually :). Can you add a
> comment here to make it clear?
> Maybe add some comment about that.

I'll rename this function to wake_lock_waiters() and add a comment.

> >   {
> > -     dout("%s rbd_dev %p wake_all %d\n", __func__, rbd_dev, wake_all);
> > +     struct rbd_img_request *img_req;
> > +
> > +     dout("%s rbd_dev %p result %d\n", __func__, rbd_dev, result);
> > +     lockdep_assert_held_exclusive(&rbd_dev->lock_rwsem);
> >
> >       cancel_delayed_work(&rbd_dev->lock_dwork);
> > -     if (wake_all)
> > -             wake_up_all(&rbd_dev->lock_waitq);
> > -     else
> > -             wake_up(&rbd_dev->lock_waitq);
> > +     if (!completion_done(&rbd_dev->acquire_wait)) {
> > +             rbd_assert(list_empty(&rbd_dev->acquiring_list) &&
> > +                        list_empty(&rbd_dev->running_list));
> > +             rbd_dev->acquire_err = result;
> > +             complete_all(&rbd_dev->acquire_wait);
> > +             return;
> > +     }
> > +
> > +     list_for_each_entry(img_req, &rbd_dev->acquiring_list, lock_item) {
> > +             mutex_lock(&img_req->state_mutex);
> > +             rbd_assert(img_req->state == RBD_IMG_EXCLUSIVE_LOCK);
> > +             rbd_img_schedule(img_req, result);
> > +             mutex_unlock(&img_req->state_mutex);
> > +     }
> > +
> > +     list_splice_tail_init(&rbd_dev->acquiring_list, &rbd_dev->running_list);
> >   }
>  From the code, above, there should be a window img_req will be in
> *running*, but it is not in running_list.
>
> But that can't happen because the lock_rwsem protect it, right?

Right.  wake_requests() is called with lock_rwsem held for write and
the whole image request state machine is under lock_rwsem for read if
need_exclusive_lock() says so.

Thanks,

                Ilya
