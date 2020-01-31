Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0D7614EA3E
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jan 2020 10:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbgAaJuD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 Jan 2020 04:50:03 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:39984 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728160AbgAaJuC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 31 Jan 2020 04:50:02 -0500
Received: by mail-io1-f68.google.com with SMTP id x1so7452376iop.7;
        Fri, 31 Jan 2020 01:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fmM/bFlNhYJ6pK3y4fj2TMdyoYPF2i614veuquv5rYA=;
        b=oc3LLI/RWNL3QTbNfmJPQ8/JdesRbh5tlwy1mo/InsGarsP79OFh6kHrDEhTeqqQa4
         N3ShmbiAbTkTVbCAM+iTUhuQz66KOXOeEteRrPmKYys9+60skMiuzKRbPp+T1CjZmx66
         zUvBKpZUPhbZMu7mLavki7HuVMCICTNKnfPR7djNJRvrM5WORILhueNacUnoRfTOzq8x
         GWRZ36eNV0EaWNxRVqIRSt6TsOLrbIxLSH9Zr7ZBFEZStbsG92wtWmKdTMHG1Z/hR07M
         fmhMjRoE7WFkrWQXFL5i5111EbTotrg3+j6rtvFSjaz+vqjtg/ZHr1Q/sCg2WfeW5Etz
         nfEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fmM/bFlNhYJ6pK3y4fj2TMdyoYPF2i614veuquv5rYA=;
        b=ZXN0Tcvsu6V0N4ky+qzWhIpHnF68nzzR3mS4XYB/WQBWrAEG7BiiyOfP9XlR26SBYP
         ScAa6BF09pVsYS5jh6lxzmrw9cYNTGtO6F7hHZMBwXj6tk3Ubv8ZbAXlZKgP3WZGW+nk
         Zbjzr6rVlK4A1uI1GaQvEIkqeZfPu6Y3Pv+7PK4po/SZdprb56LD+46P+CQx1BoYHom+
         fvDQGaJ/+AdlkOjG8B+KwpHi6NMXtFXoFpqHpkPw2gIrcRcid3XQvje8lNNbyH6QwjF7
         19mYzQXhXYHeXf7gyyeIgArTpw3D3fzGfkaFPiLS1JymmhrP8wjSCg7Dl7InceIKqLar
         fJBQ==
X-Gm-Message-State: APjAAAUwQNbZRJxptG1ipALf4IBdwK4hHb5R9t3moDdgFtnhv/VxGM46
        O1XdZrZX7OrLsxfvb5pwKwTv+4bJWDVgtkC46Nc=
X-Google-Smtp-Source: APXvYqx5mtx3j9hBpuAXIek6JBrbsplBDT4bCtGM+p18owB6Eot0XI+DijaiKL2UodCt44WmEG6jVqGKNwh2RAEh1nI=
X-Received: by 2002:a02:ce5c:: with SMTP id y28mr7739371jar.96.1580464201898;
 Fri, 31 Jan 2020 01:50:01 -0800 (PST)
MIME-Version: 1.0
References: <20200130114258.8482-1-hare@suse.de> <2fc165f5ad9ea0ec8a0878eabe800ca0af3e10b8.camel@redhat.com>
 <b786e9dd-02c1-e117-db92-aa3f50804bc7@suse.de>
In-Reply-To: <b786e9dd-02c1-e117-db92-aa3f50804bc7@suse.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 31 Jan 2020 10:50:12 +0100
Message-ID: <CAOi1vP8U=vpFiKmbeheMKQiy6y_XfGBgCvLZF_OQbhz78x2iTg@mail.gmail.com>
Subject: Re: [PATCH] rbd: lock object request list
To:     Hannes Reinecke <hare@suse.de>
Cc:     Laurence Oberman <loberman@redhat.com>,
        Sage Weil <sage@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jan 30, 2020 at 4:39 PM Hannes Reinecke <hare@suse.de> wrote:
>
> On 1/30/20 3:26 PM, Laurence Oberman wrote:
> > On Thu, 2020-01-30 at 12:42 +0100, Hannes Reinecke wrote:
> >> The object request list can be accessed from various contexts
> >> so we need to lock it to avoid concurrent modifications and
> >> random crashes.
> >>
> >> Signed-off-by: Hannes Reinecke <hare@suse.de>
> >> ---
> >>  drivers/block/rbd.c | 31 ++++++++++++++++++++++++-------
> >>  1 file changed, 24 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> >> index 5710b2a8609c..ddc170661607 100644
> >> --- a/drivers/block/rbd.c
> >> +++ b/drivers/block/rbd.c
> >> @@ -344,6 +344,7 @@ struct rbd_img_request {
> >>
> >>      struct list_head        lock_item;
> >>      struct list_head        object_extents; /* obj_req.ex structs */
> >> +    struct mutex            object_mutex;
> >>
> >>      struct mutex            state_mutex;
> >>      struct pending_result   pending;
> >> @@ -1664,6 +1665,7 @@ static struct rbd_img_request
> >> *rbd_img_request_create(
> >>      INIT_LIST_HEAD(&img_request->lock_item);
> >>      INIT_LIST_HEAD(&img_request->object_extents);
> >>      mutex_init(&img_request->state_mutex);
> >> +    mutex_init(&img_request->object_mutex);
> >>      kref_init(&img_request->kref);
> >>
> >>      return img_request;
> >> @@ -1680,8 +1682,10 @@ static void rbd_img_request_destroy(struct
> >> kref *kref)
> >>      dout("%s: img %p\n", __func__, img_request);
> >>
> >>      WARN_ON(!list_empty(&img_request->lock_item));
> >> +    mutex_lock(&img_request->object_mutex);
> >>      for_each_obj_request_safe(img_request, obj_request,
> >> next_obj_request)
> >>              rbd_img_obj_request_del(img_request, obj_request);
> >> +    mutex_unlock(&img_request->object_mutex);
> >>
> >>      if (img_request_layered_test(img_request)) {
> >>              img_request_layered_clear(img_request);
> >> @@ -2486,6 +2490,7 @@ static int __rbd_img_fill_request(struct
> >> rbd_img_request *img_req)
> >>      struct rbd_obj_request *obj_req, *next_obj_req;
> >>      int ret;
> >>
> >> +    mutex_lock(&img_req->object_mutex);
> >>      for_each_obj_request_safe(img_req, obj_req, next_obj_req) {
> >>              switch (img_req->op_type) {
> >>              case OBJ_OP_READ:
> >> @@ -2510,7 +2515,7 @@ static int __rbd_img_fill_request(struct
> >> rbd_img_request *img_req)
> >>                      continue;
> >>              }
> >>      }
> >> -
> >> +    mutex_unlock(&img_req->object_mutex);
> >>      img_req->state = RBD_IMG_START;
> >>      return 0;
> >>  }
> >> @@ -2569,6 +2574,7 @@ static int rbd_img_fill_request_nocopy(struct
> >> rbd_img_request *img_req,
> >>       * position in the provided bio (list) or bio_vec array.
> >>       */
> >>      fctx->iter = *fctx->pos;
> >> +    mutex_lock(&img_req->object_mutex);
> >>      for (i = 0; i < num_img_extents; i++) {
> >>              ret = ceph_file_to_extents(&img_req->rbd_dev->layout,
> >>                                         img_extents[i].fe_off,
> >> @@ -2576,10 +2582,12 @@ static int rbd_img_fill_request_nocopy(struct
> >> rbd_img_request *img_req,
> >>                                         &img_req->object_extents,
> >>                                         alloc_object_extent,
> >> img_req,
> >>                                         fctx->set_pos_fn, &fctx-
> >>> iter);
> >> -            if (ret)
> >> +            if (ret) {
> >> +                    mutex_unlock(&img_req->object_mutex);
> >>                      return ret;
> >> +            }
> >>      }
> >> -
> >> +    mutex_unlock(&img_req->object_mutex);
> >>      return __rbd_img_fill_request(img_req);
> >>  }
> >>
> >> @@ -2620,6 +2628,7 @@ static int rbd_img_fill_request(struct
> >> rbd_img_request *img_req,
> >>       * or bio_vec array because when mapped, those bio_vecs can
> >> straddle
> >>       * stripe unit boundaries.
> >>       */
> >> +    mutex_lock(&img_req->object_mutex);
> >>      fctx->iter = *fctx->pos;
> >>      for (i = 0; i < num_img_extents; i++) {
> >>              ret = ceph_file_to_extents(&rbd_dev->layout,
> >> @@ -2629,15 +2638,17 @@ static int rbd_img_fill_request(struct
> >> rbd_img_request *img_req,
> >>                                         alloc_object_extent,
> >> img_req,
> >>                                         fctx->count_fn, &fctx-
> >>> iter);
> >>              if (ret)
> >> -                    return ret;
> >> +                    goto out_unlock;
> >>      }
> >>
> >>      for_each_obj_request(img_req, obj_req) {
> >>              obj_req->bvec_pos.bvecs = kmalloc_array(obj_req-
> >>> bvec_count,
> >>                                            sizeof(*obj_req-
> >>> bvec_pos.bvecs),
> >>                                            GFP_NOIO);
> >> -            if (!obj_req->bvec_pos.bvecs)
> >> -                    return -ENOMEM;
> >> +            if (!obj_req->bvec_pos.bvecs) {
> >> +                    ret = -ENOMEM;
> >> +                    goto out_unlock;
> >> +            }
> >>      }
> >>
> >>      /*
> >> @@ -2652,10 +2663,14 @@ static int rbd_img_fill_request(struct
> >> rbd_img_request *img_req,
> >>                                         &img_req->object_extents,
> >>                                         fctx->copy_fn, &fctx->iter);
> >>              if (ret)
> >> -                    return ret;
> >> +                    goto out_unlock;
> >>      }
> >> +    mutex_unlock(&img_req->object_mutex);
> >>
> >>      return __rbd_img_fill_request(img_req);
> >> +out_unlock:
> >> +    mutex_unlock(&img_req->object_mutex);
> >> +    return ret;
> >>  }
> >>
> >>  static int rbd_img_fill_nodata(struct rbd_img_request *img_req,
> >> @@ -3552,6 +3567,7 @@ static void rbd_img_object_requests(struct
> >> rbd_img_request *img_req)
> >>
> >>      rbd_assert(!img_req->pending.result && !img_req-
> >>> pending.num_pending);
> >>
> >> +    mutex_lock(&img_req->object_mutex);
> >>      for_each_obj_request(img_req, obj_req) {
> >>              int result = 0;
> >>
> >> @@ -3564,6 +3580,7 @@ static void rbd_img_object_requests(struct
> >> rbd_img_request *img_req)
> >>                      img_req->pending.num_pending++;
> >>              }
> >>      }
> >> +    mutex_unlock(&img_req->object_mutex);
> >>  }
> >>
> >>  static bool rbd_img_advance(struct rbd_img_request *img_req, int
> >> *result)
> >
> > Looks good to me. Just wonder how we escaped this for so long.
> >
> > Reviewed-by: Laurence Oberman <loberman@redhat.com>
> >
> The whole state machine is utterly fragile.
> I'll be posting a patchset to clean stuff up somewhat,
> but it's still a beast.

What do you want me to do about this patch then?

> I'm rather surprised that it doesn't break more often ...

If you or Laurence saw it break, I would appreciate the details.

Thanks,

                Ilya
