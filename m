Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFF7229D11
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Jul 2020 18:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgGVQXv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Jul 2020 12:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgGVQXv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 22 Jul 2020 12:23:51 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE76C0619DC
        for <ceph-devel@vger.kernel.org>; Wed, 22 Jul 2020 09:23:51 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id z6so3183119iow.6
        for <ceph-devel@vger.kernel.org>; Wed, 22 Jul 2020 09:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5Ku9XIIpyMSVV1kPXoKaarL9WLuUdEhzno6w4cYMo5M=;
        b=n6I3jnmCxZgWfGVM9zL8kdCgXTSuw+wIRCRAUZ+CV69S8J0sWuqEpMdL7euBXLlS7l
         0oLqw5i6QdGiQbUiZHC/sh1Gdwa+riN5Xo0zJx8/Sdgh+7OJY5O3ullMjZY2Q4e7MRNO
         c2IcG6r6z/Gcz2tfbaue3FczfrslzORRCRbAYKjdJ+bmgCSJJRC7yzCVwNtzzhkQlFf7
         d0kOecVbxRwxPahN+MnF6RCeR2TxjGsBeVKzcuSxT0bhUDxPRlDBE+ZMcd8Z+aJXmHFe
         XT+iQB5JRXFcH90jupHOUwX/GCge2LiFaPtaAWpSVcPST1yvS/2DB9IseHcjuxpDzfgj
         3oAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5Ku9XIIpyMSVV1kPXoKaarL9WLuUdEhzno6w4cYMo5M=;
        b=fjzP0/+oU1J34hc83ffgtqMCbeEwIXpAhMUy3Ps8aMavAfewED3lAdcoGYWZlKX5St
         AgllvpiQYNWFiJLTVqew5uuY2TMO5tcrYLiFKINf4gFP2bvc2Q8juOBahBIUQXrouyho
         4wWoCsc42jRzKOTAmBAYN5omLkiqgytUbkEmbKYOVSqpy7axVZYCigbUDcb9H/RdlkYR
         6udV8t9NKkg8JfVZdDHdPzm4JLd3WKSydSYnbhnpYmFGJqlq7vZpBAr8S7nc/UhsbvRd
         De0EL0WuPXEljpjhI/evb82QAqhmr+/lNKhucqnw7bJaqPemGF28fvndjq0+Ey0TUq+d
         CeOw==
X-Gm-Message-State: AOAM533MWMp4pIHAnBOHk/dDSGN2q3+TOw+2BjtMPpK5iwefYLDTO/W9
        epNXrQ0/IF0GpfxRc3RDVBWXAz73FQUpdDc6H0qB6dFpctA=
X-Google-Smtp-Source: ABdhPJwAiwP59z006qGtYaI3QFZWZiU+LmCfRrS225HIylWr2djF4KiT3bt2seFXJNCPdAPzqhG+nxF4i37Oplx9uSA=
X-Received: by 2002:a5d:9c0e:: with SMTP id 14mr523573ioe.109.1595435030546;
 Wed, 22 Jul 2020 09:23:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200722134604.3026-1-jiayang5@huawei.com> <CAOi1vP9kMKVTr4K0WzEpr1cjvguuH-gOy8vnOrMm3ELdiBfk_A@mail.gmail.com>
 <a2264c76c59e6bcb39acc7704fb169856d28f7b4.camel@kernel.org>
In-Reply-To: <a2264c76c59e6bcb39acc7704fb169856d28f7b4.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 22 Jul 2020 18:23:47 +0200
Message-ID: <CAOi1vP9avh+h0d7vqLeLMfojzN8nWVk9OrnBZwUppMOQpDDm1w@mail.gmail.com>
Subject: Re: [PATCH V2] fs:ceph: Remove unused variables in ceph_mdsmap_decode()
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Jia Yang <jiayang5@huawei.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jul 22, 2020 at 5:59 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2020-07-22 at 15:53 +0200, Ilya Dryomov wrote:
> > On Wed, Jul 22, 2020 at 3:39 PM Jia Yang <jiayang5@huawei.com> wrote:
> > > Fix build warnings:
> > >
> > > fs/ceph/mdsmap.c: In function =E2=80=98ceph_mdsmap_decode=E2=80=99:
> > > fs/ceph/mdsmap.c:192:7: warning:
> > > variable =E2=80=98info_cv=E2=80=99 set but not used [-Wunused-but-set=
-variable]
> > > fs/ceph/mdsmap.c:177:7: warning:
> > > variable =E2=80=98state_seq=E2=80=99 set but not used [-Wunused-but-s=
et-variable]
> > > fs/ceph/mdsmap.c:123:15: warning:
> > > variable =E2=80=98mdsmap_cv=E2=80=99 set but not used [-Wunused-but-s=
et-variable]
> > >
> > > Use ceph_decode_skip_* instead of ceph_decode_*, because p is
> > > increased in ceph_decode_*.
> > >
> > > Signed-off-by: Jia Yang <jiayang5@huawei.com>
> > > ---
> > >  fs/ceph/mdsmap.c | 10 ++++------
> > >  1 file changed, 4 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> > > index 889627817e52..7455ba83822a 100644
> > > --- a/fs/ceph/mdsmap.c
> > > +++ b/fs/ceph/mdsmap.c
> > > @@ -120,7 +120,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, =
void *end)
> > >         const void *start =3D *p;
> > >         int i, j, n;
> > >         int err;
> > > -       u8 mdsmap_v, mdsmap_cv;
> > > +       u8 mdsmap_v;
> > >         u16 mdsmap_ev;
> > >
> > >         m =3D kzalloc(sizeof(*m), GFP_NOFS);
> > > @@ -129,7 +129,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, =
void *end)
> > >
> > >         ceph_decode_need(p, end, 1 + 1, bad);
> > >         mdsmap_v =3D ceph_decode_8(p);
> > > -       mdsmap_cv =3D ceph_decode_8(p);
> > > +       ceph_decode_skip_8(p, end, bad);
> >
> > Hi Jia,
> >
> > The bounds are already checked in ceph_decode_need(), so using
> > ceph_decode_skip_*() is unnecessary.  Just increment the position
> > with *p +=3D 1, staying consistent with ceph_decode_8(), which does
> > not bounds check.
> >
>
> I suggested using ceph_decode_skip_*, mostly just because it's more
> self-documenting and I didn't think it that significant an overhead.
> Just incrementing the pointer will also work too, of course.

Either is fine (the overhead is negligible), but I prefer to be
consistent: either ceph_decode_need() + unsafe variants or safe
variants (i.e. ceph_decode_*_safe / ceph_decode_skip_*).

>
> While you're doing that though, please also make note of what would have
> been decoded there too. So in this case, something like this is what I'd
> suggest:
>
>         *p +=3D 1;        /* mdsmap_cv */
>
> These sorts of comments are helpful later, esp. with a protocol like
> ceph that continually has fields being deprecated.

Yup, definitely useful and done in many other places.

Thanks,

                Ilya
