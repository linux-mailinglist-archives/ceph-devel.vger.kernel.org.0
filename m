Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 416A110225C
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2019 11:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbfKSKzA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Nov 2019 05:55:00 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:44531 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfKSKzA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 Nov 2019 05:55:00 -0500
Received: by mail-il1-f195.google.com with SMTP id i6so88283ilr.11
        for <ceph-devel@vger.kernel.org>; Tue, 19 Nov 2019 02:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GThEwnyaHYNxwh83WVj1BWimmh5xKI0lt9eiCPqECGE=;
        b=MggnTVFezTsuJJdfR6n/bxRAFu4UXVq0Vr/pj8y4Fvnit842qawgVhdUz6tAlcmxJB
         M4byEXtWuunvAjbBrj6ZE+/+++2HCnkG+EibEivxBPdRH/4zb92G3AsmYou2Rh9IxL1T
         p6eANiuTX/cU/pfMrGxREg2UJnHAb2o76Tztp1gvrF+mb/92s6A0SANKVgoAdrY+h89h
         rUQrFUyTWaqTI8fuAIxfRCDu3hD/tnzPxmK6ifVHvwOpw/FI6ZsgJLOdljxEWEEu8VZg
         riosaj3TMVZ3V72t33RXM9sE/SY9XHilqA5XEGSDGhsyNbZr9JJF+WUIYJ6B0n0D8WPI
         QZDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GThEwnyaHYNxwh83WVj1BWimmh5xKI0lt9eiCPqECGE=;
        b=ifYcsbCW7lrvzm6DyiTj8ScpzkqP9oOfvVFXSk1kUciGGh8ikk+dJEiRLpBXtwZfGm
         +IHAfK5gDaxQWgK0xDdiQqM6arClrxKpul2Tz5hrJigO5PlYxw37OgkbXokdIZzoyKOK
         2ZB6sLkegJsaCu+bz1z77iuPu7e1tPwBMsTKaDbD75IBpfSanQd1zex44bu3mjwrGebJ
         PeINJGJzmJoKih+fBJ+3i/XHjH76VO9ANvpkoy3FLepmhJmd48wVGxbXj2rnhC02AEwV
         AOetFD5CbNz8hyEAidhlvY7dY+dIapw92oQzmOvKN43WBdeZ9cJOpS8B6SF0EN+IP04O
         t45w==
X-Gm-Message-State: APjAAAWmaTUagbjKUK/SMmvo4OWxoh86/bpwR4T3FV3j+fA5gQsRN906
        eOQ7TBuXO97ZvCslJpn60pc2lGs66fNRboK1X0Q=
X-Google-Smtp-Source: APXvYqw5ulQxhe4I8yZAzVUDx5rgxJuiVpBf1KZ209r2QPMntUpkF+a+S7ZrUspP2skFisIGYHrMh5/xdepf3nvlmoU=
X-Received: by 2002:a92:7945:: with SMTP id u66mr20112641ilc.215.1574160899466;
 Tue, 19 Nov 2019 02:54:59 -0800 (PST)
MIME-Version: 1.0
References: <20191118133816.3963-1-idryomov@gmail.com> <20191118133816.3963-4-idryomov@gmail.com>
 <5DD3A9D6.4010908@easystack.cn>
In-Reply-To: <5DD3A9D6.4010908@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 19 Nov 2019 11:55:30 +0100
Message-ID: <CAOi1vP-Q0B4omNcoWCR7SX7V=4L_81o4HfZciH1EtOULmM=epA@mail.gmail.com>
Subject: Re: [PATCH 3/9] rbd: treat images mapped read-only seriously
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Nov 19, 2019 at 9:37 AM Dongsheng Yang
<dongsheng.yang@easystack.cn> wrote:
>
>
>
> On 11/18/2019 09:38 PM, Ilya Dryomov wrote:
> > Even though -o ro/-o read_only/--read-only options are very old, we
> > have never really treated them seriously (on par with snapshots).  As
> > a first step, fail writes to images mapped read-only just like we do
> > for snapshots.
> >
> > We need this check in rbd because the block layer basically ignores
> > read-only setting, see commit a32e236eb93e ("Partially revert "block:
> > fail op_is_write() requests to read-only partitions"").
> >
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> >   drivers/block/rbd.c | 13 ++++++++-----
> >   1 file changed, 8 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> > index 330d2789f373..842b92ef2c06 100644
> > --- a/drivers/block/rbd.c
> > +++ b/drivers/block/rbd.c
> > @@ -4820,11 +4820,14 @@ static void rbd_queue_workfn(struct work_struct *work)
> >               goto err_rq;
> >       }
> >
> > -     if (op_type != OBJ_OP_READ && rbd_is_snap(rbd_dev)) {
> > -             rbd_warn(rbd_dev, "%s on read-only snapshot",
> > -                      obj_op_name(op_type));
> > -             result = -EIO;
> > -             goto err;
> > +     if (op_type != OBJ_OP_READ) {
> > +             if (rbd_is_ro(rbd_dev)) {
> > +                     rbd_warn(rbd_dev, "%s on read-only mapping",
> > +                              obj_op_name(op_type));
> > +                     result = -EIO;
> > +                     goto err;
> > +             }
> > +             rbd_assert(!rbd_is_snap(rbd_dev));
>
> Just one question here, if block layer does not prevent write for
> readonly disk 100%,
> should we make it rbd-level readonly in rbd_ioctl_set_ro() when requested ?

No, the point is to divorce the read-only setting at the block layer
level from read-only setting in rbd.  Enforcing the block layer setting
is up to the block layer, rbd only enforces the rbd setting.  We allow
the block layer setting to be tweaked with BLKROSET, while rbd setting
is immutable (i.e. if you mapped with -o ro, you would have to unmap
and map without -o ro).  So we propagate rbd setting up to the block
layer, but the block layer setting isn't propagated down to rbd.

Thanks,

                Ilya
