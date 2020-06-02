Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F57B1EB767
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Jun 2020 10:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgFBIbZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 2 Jun 2020 04:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgFBIbZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 2 Jun 2020 04:31:25 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A70BC061A0E
        for <ceph-devel@vger.kernel.org>; Tue,  2 Jun 2020 01:31:25 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id d7so9966733ioq.5
        for <ceph-devel@vger.kernel.org>; Tue, 02 Jun 2020 01:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qcxJZFeGs0+3XOsQYt3NT9AJrbWH/RAvB4qPERyZ68A=;
        b=XBsAvcBNQ48AEoV+3XELwi+2QN17my6xoi91qZZwFlPOKyHC84V+VehfQZGL21yTRp
         oTg3shLDlq/gbory/Edyjt6+Vj2NaSQCW86fuk/WIqqP7MiUHtem8qEc2itFNFEGuD2b
         w7uDVO6kTp9OHh+28/uFduPI8lqDqabZdtL+2k9fzi1BiK2bSnqG7sAhnVAzg626guVB
         7m9WWBAj/3MCUIO8uBSIwXBYySCEDDzFbOc82UzcvFT+Bl9u57oZfoePKYXEFZCyR+kV
         YQFk6FFnjAux8ubhBJhG4PUC1jCWIbxj0DwkNqpmaKWYk+jIDU3iJYPOCBCjkFA8fUO1
         tqtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qcxJZFeGs0+3XOsQYt3NT9AJrbWH/RAvB4qPERyZ68A=;
        b=cXwIm4z6kvEMtATsfYodaXpgSNtFi9p7lawmt9wGhAQ1BmPS+c3OJaRoc4+DhdcgpK
         hytgYVso4V8pE9rrZ4QsRAcTQlOYVQ1IGIVbePicQq5f2yCWDqOFK6OTwxPFLjtIMI+/
         ZPXxVNuKc6ZRcL9lNJqV/zTi1HtyDKcD57kPouWvZ5sOykJbVnFZ6sBzSJMX5u+4cXhH
         p5T9wI5Ej0jKhFnpTBMSjtiRVbHlEyzizJ9uftn5qddAGz/eAOvq8OSNVz9uQ+wibKUR
         V8TawbRFvA09W9sia3VCWrJm8qCrF86RYETwX1scrnMkl0DeKdC3/N0D/w1leUw/EtG1
         P6Ag==
X-Gm-Message-State: AOAM531LLU4fgKRaxOBukhsr0wTrrfylJI5GGYG8V3VdsQn/UrHC28om
        31toP6PGg9/638c3MDOQ5A4AsYM744t7vQcb4ARi/mKw7AE=
X-Google-Smtp-Source: ABdhPJzz//wrFBTwsQDUEuh8eWfChlKHe3FJLKQ1vlieAFvMoyZhFTGP49sbmYaN30/RcawUOCpPHBeTORv+i5Aj0ZY=
X-Received: by 2002:a5d:9682:: with SMTP id m2mr9285141ion.143.1591086684640;
 Tue, 02 Jun 2020 01:31:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200601195826.17159-1-idryomov@gmail.com> <20200601195826.17159-3-idryomov@gmail.com>
 <e3446fba-65e9-89b4-9687-6735f6935196@easystack.cn>
In-Reply-To: <e3446fba-65e9-89b4-9687-6735f6935196@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 2 Jun 2020 10:31:31 +0200
Message-ID: <CAOi1vP9yu=xTJ-Oec=M-g0C0RKzb_oZ9DxjLDfmoqeNhyVpwHg@mail.gmail.com>
Subject: Re: [PATCH 2/2] rbd: compression_hint option
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Jason Dillaman <jdillama@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 2, 2020 at 4:34 AM Dongsheng Yang
<dongsheng.yang@easystack.cn> wrote:
>
> Hi Ilya,
>
> =E5=9C=A8 6/2/2020 3:58 AM, Ilya Dryomov =E5=86=99=E9=81=93:
> > Allow hinting to bluestore if the data should/should not be compressed.
> > The default is to not hint (compression_hint=3Dnone).
> >
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> >   drivers/block/rbd.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
> >   1 file changed, 42 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> > index b1cd41e671d1..e02089d550a4 100644
> > --- a/drivers/block/rbd.c
> > +++ b/drivers/block/rbd.c
> > @@ -836,6 +836,7 @@ enum {
> >       Opt_lock_timeout,
> >       /* int args above */
> >       Opt_pool_ns,
> > +     Opt_compression_hint,
> >       /* string args above */
> >       Opt_read_only,
> >       Opt_read_write,
> > @@ -844,8 +845,23 @@ enum {
> >       Opt_notrim,
> >   };
> >
> > +enum {
> > +     Opt_compression_hint_none,
> > +     Opt_compression_hint_compressible,
> > +     Opt_compression_hint_incompressible,
> > +};
> > +
> > +static const struct constant_table rbd_param_compression_hint[] =3D {
> > +     {"none",                Opt_compression_hint_none},
> > +     {"compressible",        Opt_compression_hint_compressible},
> > +     {"incompressible",      Opt_compression_hint_incompressible},
> > +     {}
> > +};
> > +
> >   static const struct fs_parameter_spec rbd_parameters[] =3D {
> >       fsparam_u32     ("alloc_size",                  Opt_alloc_size),
> > +     fsparam_enum    ("compression_hint",            Opt_compression_h=
int,
> > +                      rbd_param_compression_hint),
> >       fsparam_flag    ("exclusive",                   Opt_exclusive),
> >       fsparam_flag    ("lock_on_read",                Opt_lock_on_read)=
,
> >       fsparam_u32     ("lock_timeout",                Opt_lock_timeout)=
,
> > @@ -867,6 +883,8 @@ struct rbd_options {
> >       bool    lock_on_read;
> >       bool    exclusive;
> >       bool    trim;
> > +
> > +     u32 alloc_hint_flags;  /* CEPH_OSD_OP_ALLOC_HINT_FLAG_* */
> >   };
> >
> >   #define RBD_QUEUE_DEPTH_DEFAULT     BLKDEV_MAX_RQ
> > @@ -2254,7 +2272,7 @@ static void __rbd_osd_setup_write_ops(struct ceph=
_osd_request *osd_req,
> >               osd_req_op_alloc_hint_init(osd_req, which++,
> >                                          rbd_dev->layout.object_size,
> >                                          rbd_dev->layout.object_size,
> > -                                        0);
> > +                                        rbd_dev->opts->alloc_hint_flag=
s);
> >       }
> >
> >       if (rbd_obj_is_entire(obj_req))
> > @@ -6332,6 +6350,29 @@ static int rbd_parse_param(struct fs_parameter *=
param,
> >               pctx->spec->pool_ns =3D param->string;
> >               param->string =3D NULL;
> >               break;
> > +     case Opt_compression_hint:
> > +             switch (result.uint_32) {
> > +             case Opt_compression_hint_none:
> > +                     opt->alloc_hint_flags &=3D
> > +                         ~(CEPH_OSD_ALLOC_HINT_FLAG_COMPRESSIBLE |
> > +                           CEPH_OSD_ALLOC_HINT_FLAG_INCOMPRESSIBLE);
> > +                     break;
> > +             case Opt_compression_hint_compressible:
> > +                     opt->alloc_hint_flags |=3D
> > +                         CEPH_OSD_ALLOC_HINT_FLAG_COMPRESSIBLE;
> > +                     opt->alloc_hint_flags &=3D
> > +                         ~CEPH_OSD_ALLOC_HINT_FLAG_INCOMPRESSIBLE;
> > +                     break;
> > +             case Opt_compression_hint_incompressible:
> > +                     opt->alloc_hint_flags |=3D
> > +                         CEPH_OSD_ALLOC_HINT_FLAG_INCOMPRESSIBLE;
> > +                     opt->alloc_hint_flags &=3D
> > +                         ~CEPH_OSD_ALLOC_HINT_FLAG_COMPRESSIBLE;
> > +                     break;
>
>
> Just one little question here,
>
> (1) none opt means clear compressible related bits in hint flags, then
> lets the compressor in bluestore to decide compress or not.
>
> (2) compressible opt means set compressible bit and clear incompressible =
bit
>
> (3) incompressible opt means set incompressible bit and clear
> compressible bit
>
>
> Is there any scenario that alloc_hint_flags is not zero filled before
> rbd_parse_param(), then we have to clear the unexpected bit?

Hi Dongsheng,

This is to handle the case when the map option string has multiple
compression_hint options:

  name=3Dadmin,...,compression_hint=3Dcompressible,...,compression_hint=3Dn=
one

The last one wins and we always end up with either zero or just one
of the flags set, not both.

Thanks,

                Ilya
