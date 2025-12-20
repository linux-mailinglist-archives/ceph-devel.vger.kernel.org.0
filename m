Return-Path: <ceph-devel+bounces-4211-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 47393CD2884
	for <lists+ceph-devel@lfdr.de>; Sat, 20 Dec 2025 07:25:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 31DE130155E0
	for <lists+ceph-devel@lfdr.de>; Sat, 20 Dec 2025 06:25:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FC3729346F;
	Sat, 20 Dec 2025 06:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dI6R/G+4"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36CF25C80E
	for <ceph-devel@vger.kernel.org>; Sat, 20 Dec 2025 06:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766211910; cv=none; b=p6aDlIJcJlLIiBuFLuwrMfl1eAGiBW9i4tBqYDllPCrTN856e1xMi3TRlHYoMuYYDNhjVVhuxlwLcJnyaKVhSCVQkyCLUYm0KtpV3Ii6J1tKxGLJz6nPwYHZ3OMVov4rfm7QrQTqN1jCKmmdq37DXzZtu0fVLmasG1Ow93CjCtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766211910; c=relaxed/simple;
	bh=D6FeS90Nj1iKMVHt3wpk0Fuh2gcwJBgtf5xoOr/OeIc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=apsjUb/IHU0kBLQeDygJIXjzcPp8nGWGNTNuKiPkCh0kPGoTchSr2XX0tG+41+m+Klfn4A0uL0iwHPAQspSpYPfMknVXzmSisKMDXRNtDa6J66Ttls8lVMifylfxOLRGLe518icGXWmBJiCUNqJ9Fb5pPFrYHTvcIh5kgdBD2K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dI6R/G+4; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a0d5c365ceso29934365ad.3
        for <ceph-devel@vger.kernel.org>; Fri, 19 Dec 2025 22:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766211908; x=1766816708; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bban3JBmQ/h0Y1kLfFj3ZIomZCy9kEdnoLpD/EjcgHQ=;
        b=dI6R/G+4vnH6UrpddUar4AsgTF106p1eVijdh6t2eCNTsV8nkxyyEwgZCoSdG7wqQ2
         no2QIXDwmF42d0tjPzB8nlIe4zG5n3CmwiRqVYGytRpMTvOYtSul1eFqhM8PDZvvsMD2
         9klIDvRL6Se/eTMKf1peZwYON5CHtevzC1Jv4B50Lknly0dgZokzOVtEZMUAkV0as+BG
         d4Go2D0JDS4jqvjwiyDXViy3bzsOmVDgRDqErkyykZQBksjjlciR+v+I0UCV2ivzoj+1
         ZF+ZM4TBKo2DAyAN8WK25Z4RVDhLDrty62BxcwHPkiw3v5qy8CopyO+2vW9XeofDR9h8
         i57w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766211908; x=1766816708;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Bban3JBmQ/h0Y1kLfFj3ZIomZCy9kEdnoLpD/EjcgHQ=;
        b=vUagtonezVKhBGH3qMNwZu5tUNIGPmGq7zPfvkWVwMMpVJ4ZwQmrWT+DpDRdop/eDp
         u05IvCSNps9DAu8BJthwnAMzEBsrXOV1NzGTMO/Ci0wpOZnH2MEb+gm1dy434YDoY7P8
         uFxwfAY08nMO91Fw41jZlNgS1jwctoVp0pfxFb77jrjBSUytaEtu4OnZJ1vDBfUTOjBM
         TiNBUbEWf0z2KYwXER07UzPZ/D6OX77qdL2s230G95y/YrlgGIRTLPHMpFewfNpQk/9f
         QZyEcn6qhYzkIRoFvti6LSTn8HrI/o1XJexhyajm/rHogHzrLOL1n9q/f0ji7AdaKwCG
         nr6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVOhNS54E5DOSwJK42LxBpMCH0sHq1Fsp8uEjsfVcS6OwtYeA2TZLWJgY4hWPZzb0N0XlCyjgdHsThy@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3Wja+xjQ6B5Oe/uJzIWvZSFrdWnDtCeEYqX7EEjmXCmvuplDj
	Tqs8YM2mN+FYwsGD2VxPKGWi4ttQjX9Lk5GhWrkfEz5RWgve4rgSliNI7EvMeROjVnTEyVBw5jT
	QdsjpDox4gVZi63KkgpwuKsWU4IH1ETpjHjxkyuo=
X-Gm-Gg: AY/fxX6spl4Eskt88FNBt+ZlkpEsmR2WTTWk+kFOg3Eyz87657mRzkkA3TFC8u5ZLYa
	VALZLUh7ukm66komKMrxj+MTh6onBz/dGfzsRlbR+4r3horThjIRWixqj+JNadIiYz9LNEI7QQx
	wD8w1cTTt+IrvZ2V+3n0AqsxHFk61xiFrOY/RkOhU4/a6HSi4KSxnoU5FdgOjjCnENffiBSx4Lv
	ymXCxY/4N010j/xt+N+lEoujEpETYSjn/iwaXt7O00HIn+6D1vwyHWkEa5yaarSMM4vFw==
X-Google-Smtp-Source: AGHT+IGuWkGPUOtPviWRmI7Cu2A0cbNbu9z/8pBOIVtN5JS2S2DjMuBO0S4Z86gQsXzRIl4WZKNGuJIJMY6PCU9Ib4g=
X-Received: by 2002:a05:7022:e803:b0:119:e569:f27f with SMTP id
 a92af1059eb24-121722eb27emr5673686c88.40.1766211907841; Fri, 19 Dec 2025
 22:25:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251218075603.8797-1-islituo@gmail.com> <f9f2ef979100a8809d7e3ac6106362f7a273e1e0.camel@ibm.com>
 <CADm8TenqC62ddsVdo3ipC_HL3S1w7jC-=54NbU3qWvJUvyB+Xg@mail.gmail.com> <CAOi1vP9Ho5eObbH4o-_66M9RFks=g7OUNnUyPUFMq1CgnBxfKQ@mail.gmail.com>
In-Reply-To: <CAOi1vP9Ho5eObbH4o-_66M9RFks=g7OUNnUyPUFMq1CgnBxfKQ@mail.gmail.com>
From: Tuo Li <islituo@gmail.com>
Date: Sat, 20 Dec 2025 14:24:56 +0800
X-Gm-Features: AQt7F2pz4Y32ACFDdQIiDrUDephlNa77rlzWIo1vOT9l-fQC8zHiDd8rMteoGPE
Message-ID: <CADm8TemRooH7BBpzW6E+S5yjMK=JG0gNARXJmttRX0Bp7ByQ9g@mail.gmail.com>
Subject: Re: [PATCH] net: ceph: Fix a possible null-pointer dereference in decode_choose_args()
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>, Xiubo Li <xiubli@redhat.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 19, 2025 at 9:35=E2=80=AFPM Ilya Dryomov <idryomov@gmail.com> w=
rote:
>
> On Fri, Dec 19, 2025 at 7:26=E2=80=AFAM Tuo Li <islituo@gmail.com> wrote:
> >
> > Hi Slava,
> >
> > On Fri, Dec 19, 2025 at 3:11=E2=80=AFAM Viacheslav Dubeyko
> > <Slava.Dubeyko@ibm.com> wrote:
> > >
> > > On Thu, 2025-12-18 at 15:56 +0800, Tuo Li wrote:
> > > > In decode_choose_args(), arg_map->size is updated before memory is
> > > > allocated for arg_map->args using kcalloc(). If kcalloc() fails, ex=
ecution
> > > > jumps to the fail label, where free_choose_arg_map() is called to r=
elease
> > > > resources. However, free_choose_arg_map() unconditionally iterates =
over
> > > > arg_map->args using arg_map->size, which can lead to a NULL pointer
> > > > dereference when arg_map->args is NULL:
> > > >
> > > >   for (i =3D 0; i < arg_map->size; i++) {
> > > >     struct crush_choose_arg *arg =3D &arg_map->args[i];
> > > >
> > > >       for (j =3D 0; j < arg->weight_set_size; j++)
> > > >         kfree(arg->weight_set[j].weights);
> > > >     kfree(arg->weight_set);
> > > >       kfree(arg->ids);
> > > >   }
> > > >
> > > > To prevent this potential NULL pointer dereference, move the assign=
ment to
> > > > arg_map->size to after successful allocation of arg_map->args. This=
 ensures
> > > > that when allocation fails, arg_map->size remains zero and the loop=
 in
> > > > free_choose_arg_map() is not executed.
> > > >
> > > > Signed-off-by: Tuo Li <islituo@gmail.com>
> > > > ---
> > > >  net/ceph/osdmap.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
> > > > index d245fa508e1c..f67a87b3a7c8 100644
> > > > --- a/net/ceph/osdmap.c
> > > > +++ b/net/ceph/osdmap.c
> > > > @@ -363,13 +363,13 @@ static int decode_choose_args(void **p, void =
*end, struct crush_map *c)
> > > >
> > > >               ceph_decode_64_safe(p, end, arg_map->choose_args_inde=
x,
> > > >                                   e_inval);
> > > > -             arg_map->size =3D c->max_buckets;
> > >
> > > The arg_map->size defines the size of memory allocation. If you remov=
e the
> > > assignment here, then which size kcalloc() will allocate. I assume we=
 could have
> > > two possible scenarios here: (1) arg_map->size is equal to zero -> no=
 allocation
> > > happens, (2) arg_map->size contains garbage value -> any failure coul=
d happen.
> > >
> > > Have you reproduced the declared issue that you are trying to fix? Ar=
e you sure
> > > that your patch can fix the issue? Have you tested your patch at all?
> > >
> > > Thanks,
> > > Slava.
> >
> > Thanks for your careful review.
> >
> > I found this issue through static analysis. It is indeed hard to reprod=
uce
> > in practice, since intentionally triggering a kcalloc() failure is not
> > easy, but I think the NULL-dereference on the error path is theoretical=
ly
> > possible.
> >
> > You are absolutely right that my original fix is incorrect, as kcalloc(=
)
> > relies on arg_map->size, and moving the assignment can introduce a new
> > bug. I am so sorry for the oversight.
> >
> > After reading the code again, I see two possible approaches:
> >
> > 1. Keep the assignment to arg_map->size after the allocation, but use
> > c->max_buckets directly as the allocation size when calling kcalloc().
> >
> > 2. Keep the assignment before kcalloc(), but explicitly set
> > arg_map->size =3D 0 before jumping to fail, so that free_choose_arg_map=
()
> > does not iterate over a NULL pointer.
> >
> > I would appreciate your thoughts on which approach is preferable, or if
> > there is a better alternative.
>
> Hi Tuo,
>
> I think it would be better to make free_choose_arg_map() more resilient
> instead.  The pattern that is followed elsewhere in the surrounding code
> (e.g. crush_destroy()) is that the size of the array is considered valid
> only the array itself is allocated.  Something like this:
>
> static void free_choose_arg_map(struct crush_choose_arg_map *arg_map)
> {
>         int i, j;
>
>         if (!arg_map)
>                 return;
>
>         WARN_ON(!RB_EMPTY_NODE(&arg_map->node));
>
>         if (arg_map->args) {
>                 for (i =3D 0; i < arg_map->size; i++) {
>                         struct crush_choose_arg *arg =3D &arg_map->args[i=
];
>                         if (arg->weight_set) {
>                                 for (j =3D 0; j < arg->weight_set_size; j=
++)
>                                         kfree(arg->weight_set[j].weights)=
;
>                                 kfree(arg->weight_set);
>                         }
>                         kfree(arg->ids);
>                 }
>                 kfree(arg_map->args);
>         }
>         kfree(arg_map);
> }
>
> Thanks,
>
>                 Ilya

Hi Ilya,

Thanks a lot for the detailed suggestion.

I think that making free_choose_arg_map() more resilient is better.

I will rework the fix accordingly and send a v2 patch shortly.

Thanks again for the review and guidance.

Sincerely,
Tuo

