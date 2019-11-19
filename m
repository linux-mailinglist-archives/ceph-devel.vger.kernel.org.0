Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2B781023A8
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2019 12:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbfKSLyo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Nov 2019 06:54:44 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:44895 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfKSLyo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 Nov 2019 06:54:44 -0500
Received: by mail-io1-f66.google.com with SMTP id j20so11789343ioo.11
        for <ceph-devel@vger.kernel.org>; Tue, 19 Nov 2019 03:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8gJ0HgWuhBd3xEBPbkauosx78axln0i9bOOJ4YsaTJM=;
        b=eOpWzCCFQhQIj+Ybk6Pud+s3v3woB21j0Y+EeA34H+0NLXGhiXywDL7H7fRT6udz4P
         YI6MTMNMZZ3OYRUcxAILoGVdg5fcWzaJ8LeGC+z+z0XlHM66/+kXgFSoG5XzVZpo/5EQ
         waN+wkzogaSlFGjtUuZXnloGHjuQZOIQefRhLkpi3OFrdcirAtLOU/0ORfjqBDJSvAca
         v0KvBCfOF19uwgTiqngEB+gxd7zPN4bEcrroPd2szX5uk5N4eGb7LHdnW44vDxfjPC7+
         gaJy0MPD+iz2KBjSiWotS3lLzmg40FOrltGG05b3iGXPdTtjVxfXo0NGZ0hZiCmU9dPv
         oOng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8gJ0HgWuhBd3xEBPbkauosx78axln0i9bOOJ4YsaTJM=;
        b=N+5wzucqGQVj0mms5WK370Mco3lxfRSfuma/Yg77bjmFc3KTW0mc7n9uhDmb5ltHXV
         UQ5QLk0P7kPwLQp6Ga9GV7Yf5ttgJKpERficXhoWZp+TFk5g82m/2gRuqek8TZMBpVcC
         dXeSEevxS6EiDW8wH7rh34BN67Jb/q9Jf7aY/tQGiRwcUDkQEoF2pknmsL2i7d27a/Jy
         YWuiwY61ij8nXRIj8TozuYhkeqndrOMD0sHn1v/WJ86qYDbSexyGclx7exG18hZCf8nK
         pEV1wI5fQCkDSI4/9YXBiolfXkMYyHysWxsjQ7l7xlNhernBy480DU2PipDOHFgEEf1y
         no3A==
X-Gm-Message-State: APjAAAVB3UbQ1LG4cIIL7gbPe87Tc+sxAYgJEZd7OmIHNeDKrP4ellMC
        o++M0BQqkddd9F4tSkYLvOPK88T9Dem7jz0rDRsP15WW
X-Google-Smtp-Source: APXvYqxhKg4im1ND7kI0rttFD6hFP0vsvPxQyIyeJ0nHYqxdSjOfZKoJFlWvw4rrRgdGbU1xw/rw5z/XCH9fTJvV/hc=
X-Received: by 2002:a02:cc72:: with SMTP id j18mr18081596jaq.144.1574164483481;
 Tue, 19 Nov 2019 03:54:43 -0800 (PST)
MIME-Version: 1.0
References: <20191118133816.3963-1-idryomov@gmail.com> <20191118133816.3963-9-idryomov@gmail.com>
 <5DD3A9EA.6050108@easystack.cn>
In-Reply-To: <5DD3A9EA.6050108@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 19 Nov 2019 12:55:14 +0100
Message-ID: <CAOi1vP_Yn4HJAvMqYk5MH_z0uawLy-Aky_cBsdNG6g=WBqzZ5A@mail.gmail.com>
Subject: Re: [PATCH 8/9] rbd: don't query snapshot features
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Nov 19, 2019 at 9:38 AM Dongsheng Yang
<dongsheng.yang@easystack.cn> wrote:
>
>
>
> On 11/18/2019 09:38 PM, Ilya Dryomov wrote:
> > Since infernalis, ceph.git commit 281f87f9ee52 ("cls_rbd: get_features
> > on snapshots returns HEAD image features"), querying and checking that
> > is pointless.  Userspace support for manipulating image features after
> > image creation came also in infernalis, so a snapshot with a different
> > set of features wasn't ever possible.
> >
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
>
> Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
>
> Just one small nit below.
> > ---
> >   drivers/block/rbd.c | 38 +-------------------------------------
> >   1 file changed, 1 insertion(+), 37 deletions(-)
> >
> > diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> > index aba60e37b058..935b66808e40 100644
> > --- a/drivers/block/rbd.c
> > +++ b/drivers/block/rbd.c
> > @@ -377,7 +377,6 @@ struct rbd_client_id {
> >
> >   struct rbd_mapping {
> >       u64                     size;
> > -     u64                     features;
> >   };
> >
> >   /*
> > @@ -644,8 +643,6 @@ static const char *rbd_dev_v2_snap_name(struct rbd_device *rbd_dev,
> >                                       u64 snap_id);
> >   static int _rbd_dev_v2_snap_size(struct rbd_device *rbd_dev, u64 snap_id,
> >                               u8 *order, u64 *snap_size);
> > -static int _rbd_dev_v2_snap_features(struct rbd_device *rbd_dev, u64 snap_id,
> > -             u64 *snap_features);
> >   static int rbd_dev_v2_get_flags(struct rbd_device *rbd_dev);
> >
> >   static void rbd_obj_handle_request(struct rbd_obj_request *obj_req, int result);
> > @@ -1303,51 +1300,23 @@ static int rbd_snap_size(struct rbd_device *rbd_dev, u64 snap_id,
> >       return 0;
> >   }
> >
> > -static int rbd_snap_features(struct rbd_device *rbd_dev, u64 snap_id,
> > -                     u64 *snap_features)
> > -{
> > -     rbd_assert(rbd_image_format_valid(rbd_dev->image_format));
> > -     if (snap_id == CEPH_NOSNAP) {
> > -             *snap_features = rbd_dev->header.features;
> > -     } else if (rbd_dev->image_format == 1) {
> > -             *snap_features = 0;     /* No features for format 1 */
> > -     } else {
> > -             u64 features = 0;
> > -             int ret;
> > -
> > -             ret = _rbd_dev_v2_snap_features(rbd_dev, snap_id, &features);
>
> Just nit:
>
> _rbd_dev_v2_snap_features has only one caller now. we can implement it directly in rbd_dev_v2_features().

I kept both to minimize code churn and also because I actually expect
rbd_dev_v2_features() to be removed in the future.  We need to get away
from using rbd_dev as a global variable (and thus functions that take
just rbd_dev and both read from and write to it).

Thanks,

                Ilya
