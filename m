Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35A545E056
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 10:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfGCI4d (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 04:56:33 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:39304 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfGCI4d (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Jul 2019 04:56:33 -0400
Received: by mail-io1-f66.google.com with SMTP id r185so2942755iod.6
        for <ceph-devel@vger.kernel.org>; Wed, 03 Jul 2019 01:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aFw0fMQmXYGTIyGbWDUL7oo9Lz5OHbKJefrsFXrWBRE=;
        b=nvZI2yoBWNcwztPu8p7BZ3/A2e1mSbt10W4mnVQZqsyj1w5Lj/G06tccxJzcO2zB04
         exUNz1CuXyHreS1mcdDD2rWj3kxway88xxyTANdjGGolOHszGnXx4jIxSdyuW5mCX39K
         Rsp4HSPaaIzIJfzzGw2oprGkWXYmlj88ksl9rMhvatHLOQdEVAPeKZjYj12+gj3wHCQ3
         GkeP92gMrFiMZxmj9BWe9rkeUftJ2Jd+iU4rLthvHWs8pSN0FuL6JPAbETRS5cQQy/kq
         iUmrRpco2lFoswqJpEaEuOwBZIb1iRPPtzNI3O+o6e6GuaHbQ/oxNMs0pIAbsJntZdO1
         LfVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aFw0fMQmXYGTIyGbWDUL7oo9Lz5OHbKJefrsFXrWBRE=;
        b=AXybC68+bxIGYHKoDXTYw4mtGFKkqAT1KxbaqW+uQGqGYYOOKJJh3Pe6sBHvW9yEdQ
         odN2oxjkzpBdoUA0FQ6zbgpLtTjWYU5LzMBXfiZTWiFPU2btJS9nmKG81CR55Pf4f0ZV
         ljiXoSGpKu/HIbP7DOIyurlzkYE+FsTi4KVrj6eQIxO3xzm+2VgiAItWwkeDeCa/g7bv
         3RJ2pD5d5T+7QTDUMk1UnRUY3TR80HkHbB4FLkY9+mDV4yTW7psxGf0MvG16PP/50YhG
         cgRckMPem18aUk5TtvcCtfICzyNeolv8tKQ8ImZl75DTs7A2Lq3ba1Xw1vVlvxK0+3xG
         yasA==
X-Gm-Message-State: APjAAAWPh3YMft7Nbt54d4VC86iKfsQIzwkM4GXB2iiMze+J118+rrh4
        CA3UfdnffRK6vEAdpKe2xJeb/f25zvRS18MGw9A=
X-Google-Smtp-Source: APXvYqxpd4UClmMou4dOSfML7CZU9e6xsg90+EzI3wwhYzWWAM2AbZs7BxBa1wBmQL5SdW5byyTiCNft8ABOQpqinTU=
X-Received: by 2002:a6b:ed02:: with SMTP id n2mr10743487iog.131.1562144192777;
 Wed, 03 Jul 2019 01:56:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190625144111.11270-1-idryomov@gmail.com> <20190625144111.11270-12-idryomov@gmail.com>
 <CA+aFP1AvrYNinvWh_+aY+XqmSsC0eiO97HBqaisPo_He3+7NQw@mail.gmail.com>
In-Reply-To: <CA+aFP1AvrYNinvWh_+aY+XqmSsC0eiO97HBqaisPo_He3+7NQw@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 3 Jul 2019 10:59:13 +0200
Message-ID: <CAOi1vP_+EYW3ps6=ytrZu+3520gnZoiW9k1XwLUVLJEcHVHc6w@mail.gmail.com>
Subject: Re: [PATCH 11/20] rbd: introduce copyup state machine
To:     Jason Dillaman <dillaman@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jul 1, 2019 at 4:42 PM Jason Dillaman <jdillama@redhat.com> wrote:
>
> On Tue, Jun 25, 2019 at 10:42 AM Ilya Dryomov <idryomov@gmail.com> wrote:
> >
> > Both write and copyup paths will get more complex with object map.
> > Factor copyup code out into a separate state machine.
> >
> > While at it, take advantage of obj_req->osd_reqs list and issue empty
> > and current snapc OSD requests together, one after another.
> >
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> >  drivers/block/rbd.c | 187 +++++++++++++++++++++++++++++---------------
> >  1 file changed, 123 insertions(+), 64 deletions(-)
> >
> > diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> > index 2bafdee61dbd..34bd45d336e6 100644
> > --- a/drivers/block/rbd.c
> > +++ b/drivers/block/rbd.c
> > @@ -226,6 +226,7 @@ enum obj_operation_type {
> >
> >  #define RBD_OBJ_FLAG_DELETION                  (1U << 0)
> >  #define RBD_OBJ_FLAG_COPYUP_ENABLED            (1U << 1)
> > +#define RBD_OBJ_FLAG_COPYUP_ZEROS              (1U << 2)
> >
> >  enum rbd_obj_read_state {
> >         RBD_OBJ_READ_START = 1,
> > @@ -261,9 +262,15 @@ enum rbd_obj_read_state {
> >  enum rbd_obj_write_state {
> >         RBD_OBJ_WRITE_START = 1,
> >         RBD_OBJ_WRITE_OBJECT,
> > -       RBD_OBJ_WRITE_READ_FROM_PARENT,
> > -       RBD_OBJ_WRITE_COPYUP_EMPTY_SNAPC,
> > -       RBD_OBJ_WRITE_COPYUP_OPS,
> > +       __RBD_OBJ_WRITE_COPYUP,
> > +       RBD_OBJ_WRITE_COPYUP,
> > +};
>
> Nit: should the state diagram above this enum be updated to match this change?

Yeah, I'll update these diagrams in a follow-up commit.

Thanks,

                Ilya
