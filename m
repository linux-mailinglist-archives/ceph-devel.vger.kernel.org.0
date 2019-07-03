Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19E715DFAA
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 10:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfGCIVW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 04:21:22 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37946 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbfGCIVW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Jul 2019 04:21:22 -0400
Received: by mail-io1-f68.google.com with SMTP id j6so2749273ioa.5
        for <ceph-devel@vger.kernel.org>; Wed, 03 Jul 2019 01:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Aj79oismbLC7yQIx40SyqSj8fHF86lFo1uCcUj+Lmfg=;
        b=Ixf4XYa11FnOFtssfIb02sPMk7XXnsCpBr+k8SBV1Tw2wgy1r/3ToZ+Je0fcJdnRDi
         V2oddwxSyL+GAXOOP8PuMpwKZiuXhLggrW7gJeS14DfuJzdq8BN1DO2EqtRrh7nWc4NF
         ynfBBhKSUyHUMY7RZVAjWdvV1ncujgC77V7eYYY/3ojSN+xM7TlVeFMR5X2Hn0lOZC+Y
         lS+uklkQY7zUKw3p+Sczl1jqDzZ7mGREMVP0duJ8QRONSFQYJuwLP+qDOK2JAXFKfSuz
         7GASo9ZUn3wxCTOmbdWxHxHG0cwY9O6tbeJBXmLeK8vAUhFrgFcG6LhCFPoMyaSdyY10
         qKJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Aj79oismbLC7yQIx40SyqSj8fHF86lFo1uCcUj+Lmfg=;
        b=f5eIZ+Z1OZJoAMycft8iPIQ6jetevs9OZS1i2NNxsfcy7noeu7GPlQbDjdLwj5Fc0K
         WQd328Dv6D3RHF4UUa/0kTtUG7CY55Crh97QZ3bOPwMsrNAVx+7sBnABV7vYH0zMQ4cb
         Itww99yuxem+TWweQi8ZXcVL3KBn+XzoL06P3a9JT45Sgy3ErYNbz43+HT74OT6CAbDa
         +JzSS4Z7n+kYUYLRZ7kSH+ZvrHFBqjY8x9SxVme3f/UMvhCpIOEG3Rj0JGek98zeUsbq
         7gWBCKmIKIzZAAaRkDqBk3LuJdttLWcif+5H4ScUQ6IUvbA8LvOQO/Vzf2/MWaHAtUYB
         QBQA==
X-Gm-Message-State: APjAAAUd6d3PBMwGMuWvj1lc2N4mdFmlURKkOXL3CmAlSn+FmQ7anZ9d
        HTo0WA1LMhm6O7+P8Pricl4zsKu+IdX6X7+oKGpbwws+
X-Google-Smtp-Source: APXvYqwyoCUlAN3HdwxW3VN2557HIBIUYlM8oNHkWAslNO6oh1sYFeLu2223f7TWByzVIhlRhP3don8aG1Hh30LQT7E=
X-Received: by 2002:a5d:9550:: with SMTP id a16mr16680142ios.106.1562142082058;
 Wed, 03 Jul 2019 01:21:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190625144111.11270-1-idryomov@gmail.com> <20190625144111.11270-3-idryomov@gmail.com>
 <5D1999EA.30102@easystack.cn>
In-Reply-To: <5D1999EA.30102@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 3 Jul 2019 10:24:02 +0200
Message-ID: <CAOi1vP_TaRcQv1Xo=nr_NMih+e3yBPhdkCTV0HzdJiMxHPrn5Q@mail.gmail.com>
Subject: Re: [PATCH 02/20] rbd: replace obj_req->tried_parent with obj_req->read_state
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jul 1, 2019 at 7:28 AM Dongsheng Yang
<dongsheng.yang@easystack.cn> wrote:
>
>
>
> On 06/25/2019 10:40 PM, Ilya Dryomov wrote:
> > Make rbd_obj_handle_read() look like a state machine and get rid of
> > the necessity to patch result in rbd_obj_handle_request(), completing
> > the removal of obj_req->xferred and img_req->xferred.
> >
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> >   drivers/block/rbd.c | 82 +++++++++++++++++++++++++--------------------
> >   1 file changed, 46 insertions(+), 36 deletions(-)
> >
> > diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> > index a9b0b23148f9..7925b2fdde79 100644
> > --- a/drivers/block/rbd.c
> > +++ b/drivers/block/rbd.c
> > @@ -219,6 +219,11 @@ enum obj_operation_type {
> >       OBJ_OP_ZEROOUT,
> >   };
> >
> > +enum rbd_obj_read_state {
> > +     RBD_OBJ_READ_OBJECT = 1,
> > +     RBD_OBJ_READ_PARENT,
> > +};
> > +
> >   /*
> >    * Writes go through the following state machine to deal with
> >    * layering:
> > @@ -255,7 +260,7 @@ enum rbd_obj_write_state {
> >   struct rbd_obj_request {
> >       struct ceph_object_extent ex;
> >       union {
> > -             bool                    tried_parent;   /* for reads */
> > +             enum rbd_obj_read_state  read_state;    /* for reads */
> >               enum rbd_obj_write_state write_state;   /* for writes */
> >       };
> >
> > @@ -1794,6 +1799,7 @@ static int rbd_obj_setup_read(struct rbd_obj_request *obj_req)
> >       rbd_osd_req_setup_data(obj_req, 0);
> >
> >       rbd_osd_req_format_read(obj_req);
> > +     obj_req->read_state = RBD_OBJ_READ_OBJECT;
> >       return 0;
> >   }
> >
> > @@ -2402,44 +2408,48 @@ static bool rbd_obj_handle_read(struct rbd_obj_request *obj_req, int *result)
> >       struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
> >       int ret;
> >
> > -     if (*result == -ENOENT &&
> > -         rbd_dev->parent_overlap && !obj_req->tried_parent) {
> > -             /* reverse map this object extent onto the parent */
> > -             ret = rbd_obj_calc_img_extents(obj_req, false);
> > -             if (ret) {
> > -                     *result = ret;
> > -                     return true;
> > -             }
> > -
> > -             if (obj_req->num_img_extents) {
> > -                     obj_req->tried_parent = true;
> > -                     ret = rbd_obj_read_from_parent(obj_req);
> > +     switch (obj_req->read_state) {
> > +     case RBD_OBJ_READ_OBJECT:
> > +             if (*result == -ENOENT && rbd_dev->parent_overlap) {
> > +                     /* reverse map this object extent onto the parent */
> > +                     ret = rbd_obj_calc_img_extents(obj_req, false);
> >                       if (ret) {
> >                               *result = ret;
> >                               return true;
> >                       }
> > -                     return false;
> > +                     if (obj_req->num_img_extents) {
> > +                             ret = rbd_obj_read_from_parent(obj_req);
> > +                             if (ret) {
> > +                                     *result = ret;
> > +                                     return true;
> > +                             }
> > +                             obj_req->read_state = RBD_OBJ_READ_PARENT;
> Seems there is a race window between the read request complete but the
> read_state is still RBD_OBJ_READ_OBJECT.

Yes, this is resolved with the addition of obj_req->state_mutex later
in the series.

> > +                             return false;
> > +                     }
> >               }
> > -     }
> >
> > -     /*
> > -      * -ENOENT means a hole in the image -- zero-fill the entire
> > -      * length of the request.  A short read also implies zero-fill
> > -      * to the end of the request.
> > -      */
> > -     if (*result == -ENOENT) {
> > -             rbd_obj_zero_range(obj_req, 0, obj_req->ex.oe_len);
> > -             *result = 0;
> > -     } else if (*result >= 0) {
> > -             if (*result < obj_req->ex.oe_len)
> > -                     rbd_obj_zero_range(obj_req, *result,
> > -                                        obj_req->ex.oe_len - *result);
> > -             else
> > -                     rbd_assert(*result == obj_req->ex.oe_len);
> > -             *result = 0;
> > +             /*
> > +              * -ENOENT means a hole in the image -- zero-fill the entire
> > +              * length of the request.  A short read also implies zero-fill
> > +              * to the end of the request.
> > +              */
> > +             if (*result == -ENOENT) {
> > +                     rbd_obj_zero_range(obj_req, 0, obj_req->ex.oe_len);
> > +                     *result = 0;
> > +             } else if (*result >= 0) {
> > +                     if (*result < obj_req->ex.oe_len)
> > +                             rbd_obj_zero_range(obj_req, *result,
> > +                                             obj_req->ex.oe_len - *result);
> > +                     else
> > +                             rbd_assert(*result == obj_req->ex.oe_len);
> > +                     *result = 0;
> > +             }
> > +             return true;
> > +     case RBD_OBJ_READ_PARENT:
> > +             return true;
> > +     default:
> > +             BUG();
> >       }
> > -
> > -     return true;
> >   }
> >
> >   /*
> > @@ -2658,11 +2668,11 @@ static bool rbd_obj_handle_write(struct rbd_obj_request *obj_req, int *result)
> >       case RBD_OBJ_WRITE_COPYUP_OPS:
> >               return true;
> >       case RBD_OBJ_WRITE_READ_FROM_PARENT:
> > -             if (*result < 0)
> > +             if (*result)
> >                       return true;
> >
> > -             rbd_assert(*result);
> > -             ret = rbd_obj_issue_copyup(obj_req, *result);
> > +             ret = rbd_obj_issue_copyup(obj_req,
> > +                                        rbd_obj_img_extents_bytes(obj_req));
> >               if (ret) {
> >                       *result = ret;
> >                       return true;
> > @@ -2757,7 +2767,7 @@ static void rbd_obj_handle_request(struct rbd_obj_request *obj_req, int result)
> >       rbd_assert(img_req->result <= 0);
> >       if (test_bit(IMG_REQ_CHILD, &img_req->flags)) {
> >               obj_req = img_req->obj_request;
> > -             result = img_req->result ?: rbd_obj_img_extents_bytes(obj_req);
> > +             result = img_req->result;
> >               rbd_img_request_put(img_req);
> >               goto again;
> >       }
> should this part be in 01/20 ?

No, 01/20 wouldn't pass a basic copyup test with that.

Thanks,

                Ilya
