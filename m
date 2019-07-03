Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A13C5DFB6
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 10:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfGCIY7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 04:24:59 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46222 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbfGCIY7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Jul 2019 04:24:59 -0400
Received: by mail-io1-f65.google.com with SMTP id i10so2676263iol.13
        for <ceph-devel@vger.kernel.org>; Wed, 03 Jul 2019 01:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lhBxtlGBOqv9YH7XzGthn37Xc+5L5xC1JeBkehRaQts=;
        b=HcgypfRwX7x3ySrQCSkJhcQAxdn8xlS9kg1hpmvqLheYT2dGN2vh+7bYVN00KImL17
         TID2b2CZ3YF+NnCqCrigM4hk6S6or/W3BBYpniXnDVlCOZLQclCebEkVeDOtOhuM1pH6
         SLwN5UGkzpCjLfG+BDY2aOVRc3w7N293CkPYCOkqWa4hieKI+GShLSubr0YXfOINtxqC
         dZM9e4+yqnwZKdrITmrkxLiRfc+sN0g5RnGdxrrHyjNrjMx3PO4HXZ9qP4Xz9zLm2I3F
         48hJIdZ4D7PejHxtYu7IMD2EdheX0UOspZ94YeG+7zip/DKbcswUgbU1IIqX3ZzoGnZ8
         IDrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lhBxtlGBOqv9YH7XzGthn37Xc+5L5xC1JeBkehRaQts=;
        b=WXH7X7rUKdmEb0duPcbxGryrBp004YihXP67exTdskI558zEcqj0PF2t/K1c7039LT
         u18NfoiKkGikHmAdCY2hVO4GjL21QgnE7xHaDzXHWxGzVxM7hHzimXcrCC1f9TfnVzHb
         yonG6nlcPKKx47PF34wvOF5ng/GUMJtRPsqzgjw2y/r5FEWmVowoM2l6X3cDVQTLBPdo
         foL4nTFH3X4EQMCLaSUc8Q2qimVUQm26r7Wx1nbriyLHkS2EddcMJ4NkSh3JMqIsZtVC
         d60hy0gnk6D6mwBRHqUQjfZyynYKOLIwGX7wM9jXUCYiCCTf0EtomuFIX7yfcUAebw+Q
         1fgA==
X-Gm-Message-State: APjAAAUDLaRMjHvVvD2Sf5CFv5pE8N1SHsv1zntk0O1uS5kYl97EhuOY
        dRCzGJQPxPHDIyIZ0UXKwtwn+m+UygxkzrS6Mek=
X-Google-Smtp-Source: APXvYqxOJt3cqF9jruhrqTL18ZlQqEBoreF8wPpPVgh5yTfUaKKwn3BmazlS3Ja4LStmutOeiBxI+oFjeMGXVOAjOoA=
X-Received: by 2002:a6b:7311:: with SMTP id e17mr39683297ioh.112.1562142298262;
 Wed, 03 Jul 2019 01:24:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190625144111.11270-1-idryomov@gmail.com> <20190625144111.11270-5-idryomov@gmail.com>
 <5D1999FD.3060904@easystack.cn>
In-Reply-To: <5D1999FD.3060904@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 3 Jul 2019 10:27:38 +0200
Message-ID: <CAOi1vP-4VYm3gpr9BZbYP6f0vM-rW5cSQ1NiX5DVdy1m3+qVnQ@mail.gmail.com>
Subject: Re: [PATCH 04/20] rbd: move OSD request submission into object
 request state machines
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
> > Start eliminating asymmetry where the initial OSD request is allocated
> > and submitted from outside the state machine, making error handling and
> > restarts harder than they could be.  This commit deals with submission,
> > a commit that deals with allocation will follow.
> >
> > Note that this commit adds parent chain recursion on the submission
> > side:
> >
> >    rbd_img_request_submit
> >      rbd_obj_handle_request
> >        __rbd_obj_handle_request
> >          rbd_obj_handle_read
> >            rbd_obj_handle_write_guard
> >              rbd_obj_read_from_parent
> >                rbd_img_request_submit
> >
> > This will be fixed in the next commit.
> >
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> >   drivers/block/rbd.c | 60 ++++++++++++++++++++++++++++++++++++---------
> >   1 file changed, 49 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> > index 488da877a2bb..9c6be82353c0 100644
> > --- a/drivers/block/rbd.c
> > +++ b/drivers/block/rbd.c
> > @@ -223,7 +223,8 @@ enum obj_operation_type {
> >   #define RBD_OBJ_FLAG_COPYUP_ENABLED         (1U << 1)
> >
> >   enum rbd_obj_read_state {
> > -     RBD_OBJ_READ_OBJECT = 1,
> > +     RBD_OBJ_READ_START = 1,
> > +     RBD_OBJ_READ_OBJECT,
> >       RBD_OBJ_READ_PARENT,
> >   };
> >
> > @@ -253,7 +254,8 @@ enum rbd_obj_read_state {
> >    * even if there is a parent).
> >    */
> >   enum rbd_obj_write_state {
> > -     RBD_OBJ_WRITE_OBJECT = 1,
> > +     RBD_OBJ_WRITE_START = 1,
> > +     RBD_OBJ_WRITE_OBJECT,
> >       RBD_OBJ_WRITE_READ_FROM_PARENT,
> >       RBD_OBJ_WRITE_COPYUP_EMPTY_SNAPC,
> >       RBD_OBJ_WRITE_COPYUP_OPS,
> > @@ -284,6 +286,7 @@ struct rbd_obj_request {
> >
> >       struct ceph_osd_request *osd_req;
> >
> > +     struct mutex            state_mutex;
> >       struct kref             kref;
> >   };
> >
> > @@ -1560,6 +1563,7 @@ static struct rbd_obj_request *rbd_obj_request_create(void)
> >               return NULL;
> >
> >       ceph_object_extent_init(&obj_request->ex);
> > +     mutex_init(&obj_request->state_mutex);
> >       kref_init(&obj_request->kref);
> >
> >       dout("%s %p\n", __func__, obj_request);
> > @@ -1802,7 +1806,7 @@ static int rbd_obj_setup_read(struct rbd_obj_request *obj_req)
> >       rbd_osd_req_setup_data(obj_req, 0);
> >
> >       rbd_osd_req_format_read(obj_req);
> > -     obj_req->read_state = RBD_OBJ_READ_OBJECT;
> > +     obj_req->read_state = RBD_OBJ_READ_START;
> >       return 0;
> >   }
> >
> > @@ -1885,7 +1889,7 @@ static int rbd_obj_setup_write(struct rbd_obj_request *obj_req)
> >                       return ret;
> >       }
> >
> > -     obj_req->write_state = RBD_OBJ_WRITE_OBJECT;
> > +     obj_req->write_state = RBD_OBJ_WRITE_START;
> >       __rbd_obj_setup_write(obj_req, which);
> >       return 0;
> >   }
> > @@ -1943,7 +1947,7 @@ static int rbd_obj_setup_discard(struct rbd_obj_request *obj_req)
> >                                      off, next_off - off, 0, 0);
> >       }
> >
> > -     obj_req->write_state = RBD_OBJ_WRITE_OBJECT;
> > +     obj_req->write_state = RBD_OBJ_WRITE_START;
> >       rbd_osd_req_format_write(obj_req);
> >       return 0;
> >   }
> > @@ -2022,7 +2026,7 @@ static int rbd_obj_setup_zeroout(struct rbd_obj_request *obj_req)
> >                       return ret;
> >       }
> >
> > -     obj_req->write_state = RBD_OBJ_WRITE_OBJECT;
> > +     obj_req->write_state = RBD_OBJ_WRITE_START;
> >       __rbd_obj_setup_zeroout(obj_req, which);
> >       return 0;
> >   }
> > @@ -2363,11 +2367,17 @@ static void rbd_img_request_submit(struct rbd_img_request *img_request)
> >
> >       rbd_img_request_get(img_request);
> >       for_each_obj_request(img_request, obj_request)
> > -             rbd_obj_request_submit(obj_request);
> > +             rbd_obj_handle_request(obj_request, 0);
> >
> >       rbd_img_request_put(img_request);
> >   }
> >
> > +static int rbd_obj_read_object(struct rbd_obj_request *obj_req)
> > +{
> > +     rbd_obj_request_submit(obj_req);
> > +     return 0;
> always return 0? So if I understand it correctly, this function will be
> filled by other operations in later commits, right?

Correct.

Thanks,

                Ilya
