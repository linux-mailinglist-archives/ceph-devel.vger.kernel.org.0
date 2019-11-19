Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A85B102374
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2019 12:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbfKSLm2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Nov 2019 06:42:28 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:40807 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbfKSLm2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 Nov 2019 06:42:28 -0500
Received: by mail-io1-f65.google.com with SMTP id p6so22786957iod.7
        for <ceph-devel@vger.kernel.org>; Tue, 19 Nov 2019 03:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nz/ujIziKnE7eFnx2fkfYhwMW9T+I1Gw2kA9Ef1sTY0=;
        b=AjaHj/+G+ONfchaMfDH2SxJVUFo2BQiAuhE8AYEgEFgr8+Q3id3vrFBMQB3cx1x7fO
         /fhPjScncnO6KDEw422LA+w49m0Jf2+kQ2wErCasb9nnsXAitMf3ePmvnmpb7dbQiOMK
         D3ou3S9/8TUUaqqDHb3CMab2ViUPLcAnTk6Ma5Sm5bKNyFOztKLtw6XIRXQ9VcRktZjn
         ZygHG7CaJjAhYoeEzHuDiXCPbSihxRsr+QLWxAjALKvbepRLpxdw6gzKFkE+QrKChc9N
         E8Pun81GLo+Tnw1RG9oPj/zJM3n6IJDa+/Fbohimajj8XhF4Eg1/YdOZeGFR6qfJByDe
         b+og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nz/ujIziKnE7eFnx2fkfYhwMW9T+I1Gw2kA9Ef1sTY0=;
        b=f4MEpZNMAukNYzspIOPOX2ruQyfqonThhu8GC+Sn2asaz8VTZCrd/lbkK7Dog95ktx
         +Q5rMfJjNdATF0mOCn0Isypnmzk8TDC/X+YC8p03/ALd7grw+JQ94VpPOt79GPND1An9
         Iy1aVQmps0MiQ6HP3QSk6o0YkT4NFZOk1WZHynXP8cpXoNYZOA/34+H2sOMooN6Pqfld
         XrFm1vgP1N9bwkzg3YtuVXXcW9IHL1YE94nhrH/xDwlW9XzZ8mOb4Z5QKl2gTaBBBjbZ
         QoQLbjKUwc1frxs/LWowg+kfij7B/jILe5Nzsk4AGnR818r/N/h0C6JLaxxu5hzWS26B
         YSgA==
X-Gm-Message-State: APjAAAWpSeLGYDCvnHGWDelLhZyl4X+GwIQTsesaDjR4hGKv/+H/134U
        hVJ6dxvAHewXGqETOsfQOqWr66lS9IO1Kqo3iHxeP4aa
X-Google-Smtp-Source: APXvYqw1NnTRZJvHycd1TEWuGfm3DwbE4IhEV1jjxJjAiQM+hM+QCUa3MDo2Wu3iCHmeshjhUIYhzoJq8lmkA2jQv4M=
X-Received: by 2002:a5e:870c:: with SMTP id y12mr9615851ioj.215.1574163746930;
 Tue, 19 Nov 2019 03:42:26 -0800 (PST)
MIME-Version: 1.0
References: <20191118133816.3963-1-idryomov@gmail.com> <20191118133816.3963-7-idryomov@gmail.com>
 <5DD3A9E3.3040002@easystack.cn>
In-Reply-To: <5DD3A9E3.3040002@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 19 Nov 2019 12:42:57 +0100
Message-ID: <CAOi1vP-vPSjsfHx3R_jPuk-D-u1w-0VXMpN9Gmd6Z62SpXJ7Gw@mail.gmail.com>
Subject: Re: [PATCH 6/9] rbd: don't establish watch for read-only mappings
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
> > With exclusive lock out of the way, watch is the only thing left that
> > prevents a read-only mapping from being used with read-only OSD caps.
> >
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> >   drivers/block/rbd.c | 41 +++++++++++++++++++++++++++--------------
> >   1 file changed, 27 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> > index aaa359561356..bfff195e8e23 100644
> > --- a/drivers/block/rbd.c
> > +++ b/drivers/block/rbd.c
> > @@ -6985,6 +6985,24 @@ static int rbd_dev_header_name(struct rbd_device *rbd_dev)
> >       return ret;
> >   }
> >
> > +static void rbd_print_dne(struct rbd_device *rbd_dev, bool is_snap)
> > +{
> > +     if (!is_snap) {
> > +             pr_info("image %s/%s%s%s does not exist\n",
> > +                     rbd_dev->spec->pool_name,
> > +                     rbd_dev->spec->pool_ns ?: "",
> > +                     rbd_dev->spec->pool_ns ? "/" : "",
> > +                     rbd_dev->spec->image_name);
> > +     } else {
> > +             pr_info("snap %s/%s%s%s@%s does not exist\n",
> > +                     rbd_dev->spec->pool_name,
> > +                     rbd_dev->spec->pool_ns ?: "",
> > +                     rbd_dev->spec->pool_ns ? "/" : "",
> > +                     rbd_dev->spec->image_name,
> > +                     rbd_dev->spec->snap_name);
> > +     }
> > +}
> > +
> >   static void rbd_dev_image_release(struct rbd_device *rbd_dev)
> >   {
> >       rbd_dev_unprobe(rbd_dev);
> > @@ -7003,6 +7021,7 @@ static void rbd_dev_image_release(struct rbd_device *rbd_dev)
> >    */
> >   static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
> >   {
> > +     bool need_watch = !depth && !rbd_is_ro(rbd_dev);
> >       int ret;
> >
> >       /*
> > @@ -7019,22 +7038,21 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
> >       if (ret)
> >               goto err_out_format;
> >
> > -     if (!depth) {
> > +     if (need_watch) {
> >               ret = rbd_register_watch(rbd_dev);
> >               if (ret) {
> >                       if (ret == -ENOENT)
> > -                             pr_info("image %s/%s%s%s does not exist\n",
> > -                                     rbd_dev->spec->pool_name,
> > -                                     rbd_dev->spec->pool_ns ?: "",
> > -                                     rbd_dev->spec->pool_ns ? "/" : "",
> > -                                     rbd_dev->spec->image_name);
> > +                             rbd_print_dne(rbd_dev, false);
> >                       goto err_out_format;
> >               }
> >       }
> >
> >       ret = rbd_dev_header_info(rbd_dev);
> > -     if (ret)
> > +     if (ret) {
> > +             if (ret == -ENOENT && !need_watch)
>
> It's not just "if (ret == -ENOENT)" here, could you explain it more
> about why we need "&& !need_watch"?

Just a mechanical transformation, I think.

There were two pr_infos before this patch, one for images and one for
snapshots.  Because we don't call rbd_register_watch() in the read-only
case anymore, we need a second pr_info for images.  One is "active" for
the normal case (need_watch), the other is "active" for the read-only
case (!need_watch).

Since only one ENOENT is expected, we could just "if (ret == -ENOENT)",
"&& !need_watch" isn't strictly needed.

> > +                     rbd_print_dne(rbd_dev, false);
> >               goto err_out_watch;
> > +     }
> >
> >       /*
> >        * If this image is the one being mapped, we have pool name and
> > @@ -7048,12 +7066,7 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
> >               ret = rbd_spec_fill_names(rbd_dev);
> >       if (ret) {
> >               if (ret == -ENOENT)
> > -                     pr_info("snap %s/%s%s%s@%s does not exist\n",
> > -                             rbd_dev->spec->pool_name,
> > -                             rbd_dev->spec->pool_ns ?: "",
> > -                             rbd_dev->spec->pool_ns ? "/" : "",
> > -                             rbd_dev->spec->image_name,
> > -                             rbd_dev->spec->snap_name);
> > +                     rbd_print_dne(rbd_dev, true);
>
> is_snap here is always true? IIUC, as we have a watcher for non-snap
> mapping, the rbd_spec_fill_snap_id()
> would not be fail with -ENOENT. Is that the reason? If so, can we add an
> rbd_assert(depth); and add
> a comment about why we use is_snap == true here?

I don't think we need an assert here.  This just wraps the pr_info that
has been there for years, no other change is made.

Thanks,

                Ilya
