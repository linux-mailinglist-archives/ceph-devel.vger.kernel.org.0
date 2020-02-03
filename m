Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA323150FC2
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Feb 2020 19:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbgBCSkB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Feb 2020 13:40:01 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:40772 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729379AbgBCSkB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Feb 2020 13:40:01 -0500
Received: by mail-io1-f67.google.com with SMTP id x1so17872358iop.7;
        Mon, 03 Feb 2020 10:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/V4hzZYWVEsuUdGZwm6Xm8GVUq6qorIeWngqmvPL9aI=;
        b=B9BK8wbzs53w/Imo8Fc5SBsM9+UCS2wOstUeylBFOGOahegmn8hi8lhupTG9J63wR8
         8eanT7Sy+/eewIMUUocvT4THps27H3DgVZKLrvDoUE12Zo5uELn2InESCO5FcXrRc41R
         tmOGrxsqCGem4YphyaeqQb8M8KTBs81ydiBFygV5K9GGyr/9GgAx0hwcgzQrWpBoYTBH
         FNE5pguGZVV1vopHPtZvhEL4Gcg53g/UozrH1ooW5unMCgmsOtOm+b6RBCuvhr/af5TA
         tq+GU6Ekt4V27nPkhnnSo364y8HfPsUP6EH94tdPYz8fvCm1SY33wxIRGZa98whI9TjT
         zAug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/V4hzZYWVEsuUdGZwm6Xm8GVUq6qorIeWngqmvPL9aI=;
        b=tJpgpabHYKypqrsH5FAG9ZctpSK4MKqA2UkhZjT+EJ5IVvJg2DhyNIcemyNHVymruS
         mt/eU9Tg/nFn75J1YESUFOhYxImBpcPccyQtmnEzblEmGckdgWV06lJjw/jezv/+RBub
         lpFFUyQW08vkHjysiaYmm1dvG5Es/GXY8nzx76e6qrhFtYpmzVdGsAS3SZ1ofR5LahGE
         Xcdry/JK1pLvGmCUT98Ed+okiRa4StyF0JfoU1CE0lJ6xKf2peUTJKp2WAWby6hDJ7fn
         piMo5wJTn+pS8rh0v7+bhWLGrBQVw1jkM4S3V/lcOq51t3ANd0HBbmQ8uYswJID7s8oQ
         2brQ==
X-Gm-Message-State: APjAAAXN58g4zJqGwgyf96WeCZ+EvFJWAvAv7w/JjieBvlkqWvyhHgeD
        8gMHZU/eU6NueBlxdELWHvviuwNeC44UIAXMCBI=
X-Google-Smtp-Source: APXvYqyGpPTrTUi4NwM9IJSc4py35UEbHU0cmbLf710+bA+o1yTr3+pNejzArP2FRNlXagDz17lxJbVxOIZw5Xa2VD8=
X-Received: by 2002:a6b:17c4:: with SMTP id 187mr19617401iox.143.1580755199953;
 Mon, 03 Feb 2020 10:39:59 -0800 (PST)
MIME-Version: 1.0
References: <20200131103739.136098-1-hare@suse.de> <20200131103739.136098-14-hare@suse.de>
In-Reply-To: <20200131103739.136098-14-hare@suse.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 3 Feb 2020 19:40:13 +0100
Message-ID: <CAOi1vP9D7qrmzX8bAK9AtEFQ=ke+DAOtzWfkf6fSWtFuj+C8YQ@mail.gmail.com>
Subject: Re: [PATCH 13/15] rbd: schedule image_request after preparation
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
> Instead of pushing I/O directly to the workqueue we should be
> preparing it first, and push it onto the workqueue as the last
> step. This allows us to signal some back-pressure to the block
> layer in case the queue fills up.

I assume what you mean is signal BLK_STS_RESOURCE (i.e.  ENOMEM), not
the queue full condition, as that is handled intrinsically?

>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/block/rbd.c | 52 +++++++++++++++-------------------------------------
>  1 file changed, 15 insertions(+), 37 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 2566d6bd8230..9829f225c57d 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -4775,9 +4775,10 @@ static int rbd_obj_method_sync(struct rbd_device *rbd_dev,
>         return ret;
>  }
>
> -static void rbd_queue_workfn(struct work_struct *work)
> +static blk_status_t rbd_queue_rq(struct blk_mq_hw_ctx *hctx,
> +               const struct blk_mq_queue_data *bd)
>  {
> -       struct request *rq = blk_mq_rq_from_pdu(work);
> +       struct request *rq = bd->rq;
>         struct rbd_device *rbd_dev = rq->q->queuedata;
>         struct rbd_img_request *img_request;
>         struct ceph_snap_context *snapc = NULL;
> @@ -4802,24 +4803,14 @@ static void rbd_queue_workfn(struct work_struct *work)
>                 break;
>         default:
>                 dout("%s: non-fs request type %d\n", __func__, req_op(rq));
> -               result = -EIO;
> -               goto err;
> -       }
> -
> -       /* Ignore/skip any zero-length requests */
> -
> -       if (!length) {
> -               dout("%s: zero-length request\n", __func__);
> -               result = 0;
> -               goto err_rq;
> +               return BLK_STS_IOERR;
>         }
>
>         if (op_type != OBJ_OP_READ) {
>                 if (rbd_is_ro(rbd_dev)) {
>                         rbd_warn(rbd_dev, "%s on read-only mapping",
>                                  obj_op_name(op_type));
> -                       result = -EIO;
> -                       goto err;
> +                       return BLK_STS_IOERR;
>                 }
>                 rbd_assert(!rbd_is_snap(rbd_dev));
>         }
> @@ -4827,11 +4818,17 @@ static void rbd_queue_workfn(struct work_struct *work)
>         if (offset && length > U64_MAX - offset + 1) {
>                 rbd_warn(rbd_dev, "bad request range (%llu~%llu)", offset,
>                          length);
> -               result = -EINVAL;
> -               goto err_rq;    /* Shouldn't happen */
> +               return BLK_STS_NOSPC;   /* Shouldn't happen */
>         }
>
>         blk_mq_start_request(rq);
> +       /* Ignore/skip any zero-length requests */
> +       if (!length) {
> +               dout("%s: zero-length request\n", __func__);
> +               result = 0;
> +               goto err;
> +       }
> +
>
>         mapping_size = READ_ONCE(rbd_dev->mapping.size);
>         if (op_type != OBJ_OP_READ) {
> @@ -4868,8 +4865,8 @@ static void rbd_queue_workfn(struct work_struct *work)
>         if (result)
>                 goto err_img_request;
>
> -       rbd_img_handle_request(img_request, 0);
> -       return;
> +       rbd_img_schedule(img_request, 0);
> +       return BLK_STS_OK;
>
>  err_img_request:
>         rbd_img_request_destroy(img_request);
> @@ -4880,15 +4877,6 @@ static void rbd_queue_workfn(struct work_struct *work)
>         ceph_put_snap_context(snapc);
>  err:
>         blk_mq_end_request(rq, errno_to_blk_status(result));
> -}
> -
> -static blk_status_t rbd_queue_rq(struct blk_mq_hw_ctx *hctx,
> -               const struct blk_mq_queue_data *bd)
> -{
> -       struct request *rq = bd->rq;
> -       struct work_struct *work = blk_mq_rq_to_pdu(rq);
> -
> -       queue_work(rbd_wq, work);
>         return BLK_STS_OK;
>  }
>
> @@ -5055,18 +5043,8 @@ static int rbd_dev_refresh(struct rbd_device *rbd_dev)
>         return ret;
>  }
>
> -static int rbd_init_request(struct blk_mq_tag_set *set, struct request *rq,
> -               unsigned int hctx_idx, unsigned int numa_node)
> -{
> -       struct work_struct *work = blk_mq_rq_to_pdu(rq);
> -
> -       INIT_WORK(work, rbd_queue_workfn);
> -       return 0;
> -}
> -
>  static const struct blk_mq_ops rbd_mq_ops = {
>         .queue_rq       = rbd_queue_rq,
> -       .init_request   = rbd_init_request,
>  };
>
>  static int rbd_init_disk(struct rbd_device *rbd_dev)

Is .queue_rq allowed to block?  AFAIK it's not, or at least not unless
BLK_MQ_F_BLOCKING is specified and I remember hearing about performance
issues with BLK_MQ_F_BLOCKING -- it is basically an offload to kblockd
workqueue, with a single work item per hw queue.

We don't have any device specific resources, the only thing we need is
memory which we can't preallocate upfront because of too many variable
sized pieces, both in rbd and in libceph.  Small GFP_NOIO allocations
don't really fail, so I wonder how important returning something other
than BLK_STS_OK is?

Thanks,

                Ilya
