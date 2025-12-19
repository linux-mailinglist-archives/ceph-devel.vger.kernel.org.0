Return-Path: <ceph-devel+bounces-4201-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 40CD4CCEA47
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Dec 2025 07:26:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ABE91301C926
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Dec 2025 06:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20DEF2D7DC8;
	Fri, 19 Dec 2025 06:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gJlpsOGG"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773432C0283
	for <ceph-devel@vger.kernel.org>; Fri, 19 Dec 2025 06:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766125576; cv=none; b=lxFek0EIBhbxLN06jZr5wLUqSM2XbAV5jAfzUiKduAvlOMIE83/5Fo/jJiELoahKTk9O7lL3UA5B1YHwyeRlcartOOOJrx/2ujTOWlJuQUP4GFqk4/+4awRIlSOvsRu1uRKLReHSS4GUg8rB6ET350dGjlCKsOJil0+wOqIF5Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766125576; c=relaxed/simple;
	bh=jx79Fl8dQDLqGhOincbaeVRjPeGRovIP9b9H4cUWiIs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HXz5pMK/O8j0mhVsQBsDbY2jwlBRtCFLPUKf6SlnGG3HMgZn/hnfg6DT/eAevc6kJ1F9vw6irp/MJqGtwtIx2jxfvGY7lyV2LYynOe8bASthYmOfpZfdO5xNWNwViL3Q5V2Hho1Tl9DqJ/7wSTf5Hfe3rNLpNvWy4gZT1HqC3k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gJlpsOGG; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-34c2f335681so1141675a91.1
        for <ceph-devel@vger.kernel.org>; Thu, 18 Dec 2025 22:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766125575; x=1766730375; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tiFZBwRpUSfXQo7C9Yk70odyVU66O6DZGzCnSDbS4no=;
        b=gJlpsOGGxw8OKTLGPRtA0E9KWI/MCeDUX8PujUjQjikQAgzzVigLwkW8FMpmzWktVE
         fQYDS5pNtfa8f38swcpGts4sEQBER1aQKe0iIItZp1li2X37onVYR25tRVawp5Km8OQd
         42CgTdi42B4bHMw2yXn33qD1nm2PWAg561vOJKOGaPix8xE7MBzG8pnBVP8jKqSuY0fd
         7HH+onccWHoT/axBKgBnxpj42Rwwq0cG6D4p7rBIml8IDrrrG3F5xkR7KwezA1soARKN
         2qx5cK956aEwghP02RKPjmQGHzrlHJ7JgBuZmPjiRyJzEtLhagNHY9+5vjwipbNEdqKK
         mTTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766125575; x=1766730375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tiFZBwRpUSfXQo7C9Yk70odyVU66O6DZGzCnSDbS4no=;
        b=nVGjKomqeGC4FtITL5Vnwf718OUa46XF4vhj+mkQdlqpgHhKCQyoIDarjKRbOZlZVx
         nrgIgRBNw7mMkCVoAfZTMkZiKYEXNgB0SFi6yGUzZIhuyaCiT1j4WOMdsC6VZsc/eqjL
         296qlBLB/vnOn8nt4gqDbdY6dQA72r25P07rSsK4ZndPc/TpLHpN3t+KOlTI5vAdFGn6
         ZfvYMk2/pcTcUuwAVZhWoF65S8fCq45mZDAFJe2cwJs+9XSRkKJYKTStu0paLLKhCJ+E
         1SaMJHc7ihNJF/4e6k7btZFP/5ZQ0E2ERJwjfn/e9puWEpFytnrm2vT6Gtrh/eQl8fpM
         rY/A==
X-Forwarded-Encrypted: i=1; AJvYcCVkBsLEPH35yKLf6F/pT85JUo4br7v6srJgku0pIweN4DlCvZ5kdK2Ab3TuIBjhCJa+c4iECXjMtCFV@vger.kernel.org
X-Gm-Message-State: AOJu0YyQKLgmlr2Ds8PEl10jgxbvRCW1ZutZbeZyRoIR2p/AtHlZ4s0u
	lnPIxGme/eHGZNWfJTfTN4ZLnJ12XetFgjHflBpLX/SH3r7nuKDPV4Nru2Nb9DLAy7/Qnb2hB7n
	LCv4hW8u0hZKis005nAMyzejiYUvoQn8=
X-Gm-Gg: AY/fxX5vvRvINgW6TuH7SwK/7eo77lU3uIQjc0Q/lwrvZ8519/OmHnWfASaqiLwmpI3
	JRujQEAKlYphhftRSDy7B2ohih8IUB8NJu+YwabcpqKF79PEdejI0uIPfHGPsb7cDlZQQ3DxvZg
	hU5dnwGdcux/AYdFs0rYbiP1Q7XgzH3CI+Qolen+N7w/p2/GhR1G9bdKPvN/+1HXLlnsdb+ttdR
	rl55jYpAQl4sblOr5PPJdCkYRsX5vRpEl+rOY+qEFB/2ip+Mx6UDBspI5dZNIsVdyvr4Ak=
X-Google-Smtp-Source: AGHT+IEPSOUOYyMKxV8+sEC9WI/YG2Y1C2CDef8O+FEtFWAUZQJsxcrlOjD/4wrUQDAJHqKA90hSKnl8DnqE5z6HMQ8=
X-Received: by 2002:a05:7022:68a1:b0:119:e56b:91f4 with SMTP id
 a92af1059eb24-121722eb8cfmr1979117c88.37.1766125574534; Thu, 18 Dec 2025
 22:26:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251218075603.8797-1-islituo@gmail.com> <f9f2ef979100a8809d7e3ac6106362f7a273e1e0.camel@ibm.com>
In-Reply-To: <f9f2ef979100a8809d7e3ac6106362f7a273e1e0.camel@ibm.com>
From: Tuo Li <islituo@gmail.com>
Date: Fri, 19 Dec 2025 14:26:00 +0800
X-Gm-Features: AQt7F2oPDNi3a6WFcVs-CA_pymw48NM4gE_4M3YByh2JuPoxqA7Ak25fkMK40Ss
Message-ID: <CADm8TenqC62ddsVdo3ipC_HL3S1w7jC-=54NbU3qWvJUvyB+Xg@mail.gmail.com>
Subject: Re: [PATCH] net: ceph: Fix a possible null-pointer dereference in decode_choose_args()
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "idryomov@gmail.com" <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Slava,

On Fri, Dec 19, 2025 at 3:11=E2=80=AFAM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Thu, 2025-12-18 at 15:56 +0800, Tuo Li wrote:
> > In decode_choose_args(), arg_map->size is updated before memory is
> > allocated for arg_map->args using kcalloc(). If kcalloc() fails, execut=
ion
> > jumps to the fail label, where free_choose_arg_map() is called to relea=
se
> > resources. However, free_choose_arg_map() unconditionally iterates over
> > arg_map->args using arg_map->size, which can lead to a NULL pointer
> > dereference when arg_map->args is NULL:
> >
> >   for (i =3D 0; i < arg_map->size; i++) {
> >     struct crush_choose_arg *arg =3D &arg_map->args[i];
> >
> >       for (j =3D 0; j < arg->weight_set_size; j++)
> >         kfree(arg->weight_set[j].weights);
> >     kfree(arg->weight_set);
> >       kfree(arg->ids);
> >   }
> >
> > To prevent this potential NULL pointer dereference, move the assignment=
 to
> > arg_map->size to after successful allocation of arg_map->args. This ens=
ures
> > that when allocation fails, arg_map->size remains zero and the loop in
> > free_choose_arg_map() is not executed.
> >
> > Signed-off-by: Tuo Li <islituo@gmail.com>
> > ---
> >  net/ceph/osdmap.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
> > index d245fa508e1c..f67a87b3a7c8 100644
> > --- a/net/ceph/osdmap.c
> > +++ b/net/ceph/osdmap.c
> > @@ -363,13 +363,13 @@ static int decode_choose_args(void **p, void *end=
, struct crush_map *c)
> >
> >               ceph_decode_64_safe(p, end, arg_map->choose_args_index,
> >                                   e_inval);
> > -             arg_map->size =3D c->max_buckets;
>
> The arg_map->size defines the size of memory allocation. If you remove th=
e
> assignment here, then which size kcalloc() will allocate. I assume we cou=
ld have
> two possible scenarios here: (1) arg_map->size is equal to zero -> no all=
ocation
> happens, (2) arg_map->size contains garbage value -> any failure could ha=
ppen.
>
> Have you reproduced the declared issue that you are trying to fix? Are yo=
u sure
> that your patch can fix the issue? Have you tested your patch at all?
>
> Thanks,
> Slava.

Thanks for your careful review.

I found this issue through static analysis. It is indeed hard to reproduce
in practice, since intentionally triggering a kcalloc() failure is not
easy, but I think the NULL-dereference on the error path is theoretically
possible.

You are absolutely right that my original fix is incorrect, as kcalloc()
relies on arg_map->size, and moving the assignment can introduce a new
bug. I am so sorry for the oversight.

After reading the code again, I see two possible approaches:

1. Keep the assignment to arg_map->size after the allocation, but use
c->max_buckets directly as the allocation size when calling kcalloc().

2. Keep the assignment before kcalloc(), but explicitly set
arg_map->size =3D 0 before jumping to fail, so that free_choose_arg_map()
does not iterate over a NULL pointer.

I would appreciate your thoughts on which approach is preferable, or if
there is a better alternative.

Thanks again for your feedback!

Sincerely,
Tuo Li

>
> >               arg_map->args =3D kcalloc(arg_map->size, sizeof(*arg_map-=
>args),
> >                                       GFP_NOIO);
> >               if (!arg_map->args) {
> >                       ret =3D -ENOMEM;
> >                       goto fail;
> >               }
> > +             arg_map->size =3D c->max_buckets;
> >
> >               ceph_decode_32_safe(p, end, num_buckets, e_inval);
> >               while (num_buckets--) {

