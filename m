Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 285F8150E72
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Feb 2020 18:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgBCRNr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Feb 2020 12:13:47 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:33233 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728679AbgBCRNr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Feb 2020 12:13:47 -0500
Received: by mail-il1-f194.google.com with SMTP id s18so13299295iln.0;
        Mon, 03 Feb 2020 09:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ekr1618Kj/kVCQ3/czem0HogD0JeQ+2uUBKI4c7KGmA=;
        b=L5jiTkff8yNF2ZNWthOR0i4od2+qRfx7fUKp+dNqFIiq/aEojZ0mHflTw4AvaTx2mx
         2ZtAt4ZJR+iv322f7O1fqeuymVWHbykifVUOfzvLUqA9h8K5ofkZzuVGV1T8HLgejJtz
         fYJCAp50WpCVNOdiNti36vxfChSwcWvfbznA/+PaYQtrh2Uvp78bsl5Ksnkm3MpBQsYT
         VZ3MBE6kTztQPpyH5TepAHZXgyxKyK78fVENQsXKePotl70wd0Az6VdMZUU03gks82+p
         IA7ecWEymt32vIAVl3JpHmVmdOsG+aH912eJImwgJ/N3a1D8J1pviSs5mMCzwHJ+e9Mx
         y4tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ekr1618Kj/kVCQ3/czem0HogD0JeQ+2uUBKI4c7KGmA=;
        b=SHPGkzYrOBTh1tk+TIN9nBDU2xENMKdmDNLEJnBUzGYii15tOvBkEBKaIZcGXben51
         5lyY3cW/BC7oHEJLR6S5BlpbxrsCvdH3UI5360qNlkY+ZF/gJHzSJsK+XRgGIZamU1g2
         0tkDc/qR6ixhrtMXGpxfx2ccBMo3W5U+UCLFq+2otObFlTwTb8f8nd7ZiJdX8L1QLZzB
         WxYrtXF89dayocbyX/EpBz29QGrq45vZRuzLW6Bc6t51zqKnxT2czqFQsQkpd+SMUXV8
         XYw+a4G4zMp0fyLh6F5Y83wmMARTpS8nmdBgfRoSleG4w163Xv1TcNz/vy6TjWm5lhjx
         Qm6Q==
X-Gm-Message-State: APjAAAXPZeYc7wNoMgJzZ79PXYFTAIcwozNXlc46GlB0TqUxdUep8nXj
        LJetm47snwv0ANutvJNpgk9zH1PLZODhkM0TDCw=
X-Google-Smtp-Source: APXvYqwAjSBX9H5PeN5w1CIgd8pqzBUHn1fIojGWYaAfLHv1m+81mUKpXMDAZ0PRlxYBS3w34tCYulKQBePaIsimL04=
X-Received: by 2002:a92:ccd0:: with SMTP id u16mr14957299ilq.215.1580750026280;
 Mon, 03 Feb 2020 09:13:46 -0800 (PST)
MIME-Version: 1.0
References: <20200131103739.136098-1-hare@suse.de> <20200131103739.136098-8-hare@suse.de>
In-Reply-To: <20200131103739.136098-8-hare@suse.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 3 Feb 2020 18:13:59 +0100
Message-ID: <CAOi1vP-Fn=EM7Bw57snxcf=YDw0Dft=fSSGcG7GX8q9iJnSeiQ@mail.gmail.com>
Subject: Re: [PATCH 07/15] rbd: use callback for image request completion
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
> Using callbacks to simplify code and to separate out the different
> code paths for parent and child requests.
>
> Suggested-by: David Disseldorp <ddiss@suse.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/block/rbd.c | 61 +++++++++++++++++++++++++++++------------------------
>  1 file changed, 33 insertions(+), 28 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index c31507a5fdd2..8cfd9407cbb8 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -317,6 +317,9 @@ struct rbd_obj_request {
>         struct kref             kref;
>  };
>
> +typedef void (*rbd_img_request_cb_t)(struct rbd_img_request *img_request,
> +                                    int result);
> +
>  enum img_req_flags {
>         IMG_REQ_CHILD,          /* initiator: block = 0, child image = 1 */
>         IMG_REQ_LAYERED,        /* ENOENT handling: normal = 0, layered = 1 */
> @@ -339,11 +342,8 @@ struct rbd_img_request {
>                 u64                     snap_id;        /* for reads */
>                 struct ceph_snap_context *snapc;        /* for writes */
>         };
> -       union {
> -               struct request          *rq;            /* block request */
> -               struct rbd_obj_request  *obj_request;   /* obj req initiator */
> -       };
> -
> +       void                    *callback_data;
> +       rbd_img_request_cb_t    callback;
>         struct list_head        lock_item;
>         struct list_head        object_extents; /* obj_req.ex structs */
>         struct mutex            object_mutex;
> @@ -506,6 +506,8 @@ static ssize_t add_single_major_store(struct bus_type *bus, const char *buf,
>  static ssize_t remove_single_major_store(struct bus_type *bus, const char *buf,
>                                          size_t count);
>  static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth);
> +static void rbd_img_end_child_request(struct rbd_img_request *img_req,
> +                                     int result);
>
>  static int rbd_dev_id_to_minor(int dev_id)
>  {
> @@ -2882,7 +2884,8 @@ static int rbd_obj_read_from_parent(struct rbd_obj_request *obj_req)
>                 return -ENOMEM;
>
>         __set_bit(IMG_REQ_CHILD, &child_img_req->flags);
> -       child_img_req->obj_request = obj_req;
> +       child_img_req->callback = rbd_img_end_child_request;
> +       child_img_req->callback_data = obj_req;
>
>         dout("%s child_img_req %p for obj_req %p\n", __func__, child_img_req,
>              obj_req);
> @@ -3506,14 +3509,12 @@ static bool __rbd_obj_handle_request(struct rbd_obj_request *obj_req,
>         return done;
>  }
>
> -/*
> - * This is open-coded in rbd_img_handle_request() to avoid parent chain
> - * recursion.
> - */
>  static void rbd_obj_handle_request(struct rbd_obj_request *obj_req, int result)
>  {
> -       if (__rbd_obj_handle_request(obj_req, &result))
> +       if (__rbd_obj_handle_request(obj_req, &result)) {
> +               /* Recurse into parent */
>                 rbd_img_handle_request(obj_req->img_request, result);
> +       }
>  }
>
>  static bool need_exclusive_lock(struct rbd_img_request *img_req)
> @@ -3695,26 +3696,29 @@ static bool __rbd_img_handle_request(struct rbd_img_request *img_req,
>         return done;
>  }
>
> -static void rbd_img_handle_request(struct rbd_img_request *img_req, int result)
> +static void rbd_img_end_child_request(struct rbd_img_request *img_req,
> +                                     int result)
>  {
> -again:
> -       if (!__rbd_img_handle_request(img_req, &result))
> -               return;
> +       struct rbd_obj_request *obj_req = img_req->callback_data;
>
> -       if (test_bit(IMG_REQ_CHILD, &img_req->flags)) {
> -               struct rbd_obj_request *obj_req = img_req->obj_request;
> +       rbd_img_request_put(img_req);
> +       rbd_obj_handle_request(obj_req, result);
> +}
>
> -               rbd_img_request_put(img_req);
> -               if (__rbd_obj_handle_request(obj_req, &result)) {
> -                       img_req = obj_req->img_request;
> -                       goto again;
> -               }
> -       } else {
> -               struct request *rq = img_req->rq;
> +static void rbd_img_end_request(struct rbd_img_request *img_req, int result)
> +{
> +       struct request *rq = img_req->callback_data;
>
> -               rbd_img_request_put(img_req);
> -               blk_mq_end_request(rq, errno_to_blk_status(result));
> -       }
> +       rbd_img_request_put(img_req);
> +       blk_mq_end_request(rq, errno_to_blk_status(result));
> +}
> +
> +void rbd_img_handle_request(struct rbd_img_request *img_req, int result)
> +{
> +       if (!__rbd_img_handle_request(img_req, &result))
> +               return;
> +
> +       img_req->callback(img_req, result);
>  }
>
>  static const struct rbd_client_id rbd_empty_cid;
> @@ -4840,7 +4844,8 @@ static void rbd_queue_workfn(struct work_struct *work)
>                 result = -ENOMEM;
>                 goto err_rq;
>         }
> -       img_request->rq = rq;
> +       img_request->callback = rbd_img_end_request;
> +       img_request->callback_data = rq;
>         snapc = NULL; /* img_request consumes a ref */
>
>         dout("%s rbd_dev %p img_req %p %s %llu~%llu\n", __func__, rbd_dev,

We walked away from callbacks to avoid recursion described here:

  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6d69bb536bac0d403d83db1ca841444981b280cd

The title says "on rbd map", but it was on the I/O path as well.
The functions have changed, but the gist is the same: some object
request completes, which completes its image request, which completes
the object request in the child image, which completes the image
request in the child image, etc.

The plan is to get rid of RBD_MAX_PARENT_CHAIN_LEN after refactoring
header read-in code.  If rbd_img_handle_request() is confusing, let's
add a comment.  There already is one (removed in this patch), but it
is far away, so I can see how that logic may seem over-complicated.

Thanks,

                Ilya
