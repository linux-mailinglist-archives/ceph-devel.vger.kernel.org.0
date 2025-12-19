Return-Path: <ceph-devel+bounces-4204-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EB96ACD0147
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Dec 2025 14:35:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ADE88301D595
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Dec 2025 13:35:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0B2231E11C;
	Fri, 19 Dec 2025 13:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WM2RY2Un"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361B32153FB
	for <ceph-devel@vger.kernel.org>; Fri, 19 Dec 2025 13:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766151326; cv=none; b=GuvMADVJlmOuZjfDO8ZImzua1k0alp+ztKVQ9TICsJFlbwLishcAkCfJkto27kXEpoDZX8gIvkkB0vDb4Cj29H5aAGm5LiIvjr0ADlC55IA+DJ+uzI8t/TFB1dQZ+jg3OQ0FPhvOcQY+gkKIr+O+pVpuGhu4T49LyX7S2RUR9CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766151326; c=relaxed/simple;
	bh=ubWSsOONJUgb/5Crt2rpTUwTvf6PO7/GvFSXZXEPurc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=svvY8e68Zi+i8xf84WIza28Y+eDQN14zEUpUbQGSB3hlNtXRvC+ESCYe88Fzx3hLf2XdMdCeN0MBz60ykl+3gL88awNaAeFdKqOd1MVmVh8C/qk20r9LD20Yoz3+uFGWvyVq8qVu/16JidPWxX6L/ETYmzFdgYy2UgEX47POyv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WM2RY2Un; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a0a33d0585so16972055ad.1
        for <ceph-devel@vger.kernel.org>; Fri, 19 Dec 2025 05:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766151324; x=1766756124; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s0vqpR5ZtmBq8KtvBsCktukhNuDQarmW55mouB9X5fo=;
        b=WM2RY2UniSohqS5XNERw31MSLny+76qyIAXt1Q8iaZHhRQkiKs7bA1HXrTvKgutXkd
         003mg3MKpuxZFyNq3futJMcmOB68gfeiPkwhzt4VS+QNxlXGIyP27Ib9fIfVNxRwRFr6
         a7NZxK2XKQv0+nRhxzcyZmZWUktAp2oib9KwD+g2rALJzFOlwP6iBH1RR3lToa2bdP+d
         tLe1MPOQUKypMCchTk474knEq9hAknnRJmTeG8YhmAqzPiO6tACYvk/jRMoORX1Ssqyr
         gcCEjHo7YmxpqnA39NnvE5qkymWnUEYYG+sDJ8TGznq5iNo1idIZWKnIIGaQ+JzmIEIL
         TqGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766151324; x=1766756124;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s0vqpR5ZtmBq8KtvBsCktukhNuDQarmW55mouB9X5fo=;
        b=rXy6vhcDOZjq0IAEn6wjSzdzHOazB2gB1ss3fKcwyX8BJJgABc1XimSCtK9G57P9St
         9myKyHCBxPY9g8xlGFTfUWuwGJOAJSpPdHpJiCvGx2Z3BL/Hl8tZ+v4eVNq5QHRfS+wl
         w5BKjCsuBr+iMYLHk9oVINtxlA5TQROxryIdp5EVKefCV/YTvDumBRB1gpRkj0a5JLqZ
         qPcKe0ePIdgzbgqWgyphq7fbqSZHvV0roQ/dPZWawWBM524IRqBqaqdpnSME72Y0RsNI
         bFiLfuPkljGmQxgM0J76eWIz0LRspouCtayPTNNaLuGOjcFryYmKKruszqhjrrHB4C8x
         8U6g==
X-Forwarded-Encrypted: i=1; AJvYcCUacPHRbE6r3EZLHtJUPMb96zJxjs6FVv26S5WnblmCMlR2st5vDnJsPPMejk1vUOUQiWda8LcCRSdX@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv/pLAyoP6jbmxRtEpG1fkS+hOonN0Vse85jVTYv6ntJG7jAqV
	Sa4jpX1B4/5KVMKM7AMIUXOugmwgdnaeKJ/4pigc5plfnHRf4SRnn/3M+YUaDAYbQuvuJ/y+tXP
	fhpR1VhzmQk1yvfGXGHY1ss1L2Tqw3S0=
X-Gm-Gg: AY/fxX7j5AnKlltRJ5B9Lvqh6qTl5eI7hwidw+wPjtEBtzvD7O2g5UZTo5aLpClvjtM
	fpnWFQIfwDTdesOoxiUjehYVlSs+ENMMTwNXnwnQQpm1Ia5CygqGRqsXAoKu9J4M4MN7PZXhaP2
	DT2HFeCnzYcS1XnMfVfSDKBNL+YtrxedZgp6Qg6MGvep098wcr07xkIqtOmQiE3xDXMLgCNN/zB
	tK7uOIP6Ux4xx+ko9qUpH/Ex2sR8xEZwD20jQGXQuDYy9rrpsik5RmjQVQdt8L5SyOv7Tg=
X-Google-Smtp-Source: AGHT+IG9/6FrzhlRCJqqFLfPLVygUh9QB9KCoCD60N/GmMH2HUREmhewoPGA2HNCV47lFhbX4SlqBsaVLG3CZsUEQaI=
X-Received: by 2002:a05:7022:428b:b0:119:e56b:91da with SMTP id
 a92af1059eb24-121722aae70mr3586776c88.11.1766151322955; Fri, 19 Dec 2025
 05:35:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251218075603.8797-1-islituo@gmail.com> <f9f2ef979100a8809d7e3ac6106362f7a273e1e0.camel@ibm.com>
 <CADm8TenqC62ddsVdo3ipC_HL3S1w7jC-=54NbU3qWvJUvyB+Xg@mail.gmail.com>
In-Reply-To: <CADm8TenqC62ddsVdo3ipC_HL3S1w7jC-=54NbU3qWvJUvyB+Xg@mail.gmail.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Fri, 19 Dec 2025 14:35:11 +0100
X-Gm-Features: AQt7F2rIz20crVtpxXwlITXzZsBawMOSWzQy-dnGQJBHOqf56TLbZHVrd6At9CA
Message-ID: <CAOi1vP9Ho5eObbH4o-_66M9RFks=g7OUNnUyPUFMq1CgnBxfKQ@mail.gmail.com>
Subject: Re: [PATCH] net: ceph: Fix a possible null-pointer dereference in decode_choose_args()
To: Tuo Li <islituo@gmail.com>
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>, Xiubo Li <xiubli@redhat.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 19, 2025 at 7:26=E2=80=AFAM Tuo Li <islituo@gmail.com> wrote:
>
> Hi Slava,
>
> On Fri, Dec 19, 2025 at 3:11=E2=80=AFAM Viacheslav Dubeyko
> <Slava.Dubeyko@ibm.com> wrote:
> >
> > On Thu, 2025-12-18 at 15:56 +0800, Tuo Li wrote:
> > > In decode_choose_args(), arg_map->size is updated before memory is
> > > allocated for arg_map->args using kcalloc(). If kcalloc() fails, exec=
ution
> > > jumps to the fail label, where free_choose_arg_map() is called to rel=
ease
> > > resources. However, free_choose_arg_map() unconditionally iterates ov=
er
> > > arg_map->args using arg_map->size, which can lead to a NULL pointer
> > > dereference when arg_map->args is NULL:
> > >
> > >   for (i =3D 0; i < arg_map->size; i++) {
> > >     struct crush_choose_arg *arg =3D &arg_map->args[i];
> > >
> > >       for (j =3D 0; j < arg->weight_set_size; j++)
> > >         kfree(arg->weight_set[j].weights);
> > >     kfree(arg->weight_set);
> > >       kfree(arg->ids);
> > >   }
> > >
> > > To prevent this potential NULL pointer dereference, move the assignme=
nt to
> > > arg_map->size to after successful allocation of arg_map->args. This e=
nsures
> > > that when allocation fails, arg_map->size remains zero and the loop i=
n
> > > free_choose_arg_map() is not executed.
> > >
> > > Signed-off-by: Tuo Li <islituo@gmail.com>
> > > ---
> > >  net/ceph/osdmap.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
> > > index d245fa508e1c..f67a87b3a7c8 100644
> > > --- a/net/ceph/osdmap.c
> > > +++ b/net/ceph/osdmap.c
> > > @@ -363,13 +363,13 @@ static int decode_choose_args(void **p, void *e=
nd, struct crush_map *c)
> > >
> > >               ceph_decode_64_safe(p, end, arg_map->choose_args_index,
> > >                                   e_inval);
> > > -             arg_map->size =3D c->max_buckets;
> >
> > The arg_map->size defines the size of memory allocation. If you remove =
the
> > assignment here, then which size kcalloc() will allocate. I assume we c=
ould have
> > two possible scenarios here: (1) arg_map->size is equal to zero -> no a=
llocation
> > happens, (2) arg_map->size contains garbage value -> any failure could =
happen.
> >
> > Have you reproduced the declared issue that you are trying to fix? Are =
you sure
> > that your patch can fix the issue? Have you tested your patch at all?
> >
> > Thanks,
> > Slava.
>
> Thanks for your careful review.
>
> I found this issue through static analysis. It is indeed hard to reproduc=
e
> in practice, since intentionally triggering a kcalloc() failure is not
> easy, but I think the NULL-dereference on the error path is theoretically
> possible.
>
> You are absolutely right that my original fix is incorrect, as kcalloc()
> relies on arg_map->size, and moving the assignment can introduce a new
> bug. I am so sorry for the oversight.
>
> After reading the code again, I see two possible approaches:
>
> 1. Keep the assignment to arg_map->size after the allocation, but use
> c->max_buckets directly as the allocation size when calling kcalloc().
>
> 2. Keep the assignment before kcalloc(), but explicitly set
> arg_map->size =3D 0 before jumping to fail, so that free_choose_arg_map()
> does not iterate over a NULL pointer.
>
> I would appreciate your thoughts on which approach is preferable, or if
> there is a better alternative.

Hi Tuo,

I think it would be better to make free_choose_arg_map() more resilient
instead.  The pattern that is followed elsewhere in the surrounding code
(e.g. crush_destroy()) is that the size of the array is considered valid
only the array itself is allocated.  Something like this:

static void free_choose_arg_map(struct crush_choose_arg_map *arg_map)
{
        int i, j;

        if (!arg_map)
                return;

        WARN_ON(!RB_EMPTY_NODE(&arg_map->node));

        if (arg_map->args) {
                for (i =3D 0; i < arg_map->size; i++) {
                        struct crush_choose_arg *arg =3D &arg_map->args[i];
                        if (arg->weight_set) {
                                for (j =3D 0; j < arg->weight_set_size; j++=
)
                                        kfree(arg->weight_set[j].weights);
                                kfree(arg->weight_set);
                        }
                        kfree(arg->ids);
                }
                kfree(arg_map->args);
        }
        kfree(arg_map);
}

Thanks,

                Ilya

