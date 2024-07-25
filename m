Return-Path: <ceph-devel+bounces-1563-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 256BA93BFD3
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2024 12:23:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F50F1F21F46
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2024 10:23:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 318EC198A19;
	Thu, 25 Jul 2024 10:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EEhdSIc2"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F132198857
	for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2024 10:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721902986; cv=none; b=aDqQ/IRGKdQjfzqTE3wAebngEbSqT3aho0nOmP0D6f7FyHoDlEa2gsO24W1NVhpn5+EIPzo0pJIrC0TiFybHqwTzZPVV1hBppoZUxQLM6xVCWjGQh84zxy0T2ijB2T2J9ZoH2Rj6cVT8lLZsXk6r9q2uLwMgfrBmU67pfImz+fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721902986; c=relaxed/simple;
	bh=QvfmDE+OfynWQCoc5r9xzvThkRTcLCfdKtWVG0H1E/U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ifSAQtwEGI6phXGYaw6rsCvuDihyFgqH7qqnYUCCMOu1bwg72A98kqzgL7RVl64ZyB4m5oo1ZtCTM20CrVE1ZhvNrq3O079qc7ggPYxB5E4fyzGCDIijDtzFv6q3kbk0w8uSKRNXn1S+07h7B5O8qwyG1A9TE7Qd1Yv9dgRlouw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EEhdSIc2; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3db14cc9066so267083b6e.3
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2024 03:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721902984; x=1722507784; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nJmmTS/xveWyxvQoDcjiTbpUA4N6RjBBPxaxi/RrVYQ=;
        b=EEhdSIc22zpXRGhQ2X5e0RA+XBhr40dtrH6o9GjNjpORPS4UsYKGnAk4AtDfu8SOfL
         YgFkKPfqZKwm4iCXRHDGbxtyIQ8aYsZQYgQsTig7k42x//J4vx6PaeBoe84ng1AZoGF0
         Yd3uHhvqqItAvEH5lzOR14J+Ru74o1wOlAlSrwmIJL5JuYA4Iqb4LfJkGPefMaYmpDDh
         fiJH84cM+SXPaiUIrKV18bqMuVGKvM5zDsj9iz/1C7g4FiR43I4BHNDy9VAMsTkNCr5U
         wzz7D3igX2k5LWEKGcXoTm8mA3d9XNWq1A1vQGP5tDJFjDXckY7OXSy0vZQXWNKTXo4B
         RmKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721902984; x=1722507784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nJmmTS/xveWyxvQoDcjiTbpUA4N6RjBBPxaxi/RrVYQ=;
        b=Nz8peOUuQBZSl/KoAGCNV6KmDKhRGJj1K6nT253R29zTTVu3+YIZCiN7AK4A9TnzMW
         hNsQ5zEasDl2biHf0pKyGcroU+w158HaeXvxKZE65acN4w2a4D/y1lLW5CaPJjq+auIk
         Sb5WYGMoOJbRfx8kdE7kwkFimPhonYpkc3oZNLiC3Vl39/PVZ1dmLx5IT99y35alTmtF
         PEVxr/8uQQctIXoRfTeCKhed20Ms32DhYacmlYj/Oxdaib16+HcdK7S9D/6PCE7Jz8cl
         DeXg8v+mo8NNiTnrhxH4spaFPGDe9IK8iz/zMhGX7FXxtkF80wuj6EhXtL1GXowE7YxV
         toRQ==
X-Gm-Message-State: AOJu0YwrszjYQ/lM1aszuvvr2qcdXpvg01KI96yM6yWbEXU/7g1e+U2V
	gZguKpF1SZ+lXU0sRbg2PmToYiGsLo1hu9Z8xzcdHu/KQqHkpFooOhQS3Ot5v5ebYB8+k+CMzq2
	8TPKOFXEIvEH2e8Z55e9qzES7WhlXFLr1
X-Google-Smtp-Source: AGHT+IGgSwruBDt821JSlg55PRWD6uPB47Lv6KOA4eG1/ToN4c1NZ7Kgf8a7SAmc5W71TKgwmcMTrQhzdTd/UxIGaz4=
X-Received: by 2002:a05:6808:1204:b0:3db:fe8:f744 with SMTP id
 5614622812f47-3db10fe88e9mr2535819b6e.24.1721902983722; Thu, 25 Jul 2024
 03:23:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240724062914.667734-1-idryomov@gmail.com> <20240724062914.667734-4-idryomov@gmail.com>
 <9c6bdd62-58a4-e660-9e59-f2f999795d9b@linux.dev> <CAOi1vP_wyoEhawoArdUmX4i0w1u37Ei7f7nbjy=_ub0gogRd4Q@mail.gmail.com>
 <dea0f277-3fe8-4539-24d1-285e6d5c1a76@linux.dev>
In-Reply-To: <dea0f277-3fe8-4539-24d1-285e6d5c1a76@linux.dev>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 25 Jul 2024 12:22:51 +0200
Message-ID: <CAOi1vP8LWYJma8zZZEnFssAZ4Dra3iDVAxcoxzdsgeWJ6tZYrw@mail.gmail.com>
Subject: Re: [PATCH 3/3] rbd: don't assume rbd_is_lock_owner() for exclusive mappings
To: Dongsheng Yang <dongsheng.yang@linux.dev>
Cc: ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 25, 2024 at 12:08=E2=80=AFPM Dongsheng Yang
<dongsheng.yang@linux.dev> wrote:
>
>
>
> =E5=9C=A8 2024/7/25 =E6=98=9F=E6=9C=9F=E5=9B=9B =E4=B8=8B=E5=8D=88 5:31, =
Ilya Dryomov =E5=86=99=E9=81=93:
> > On Thu, Jul 25, 2024 at 10:45=E2=80=AFAM Dongsheng Yang
> > <dongsheng.yang@linux.dev> wrote:
> >>
> >>
> >>
> >> =E5=9C=A8 2024/7/24 =E6=98=9F=E6=9C=9F=E4=B8=89 =E4=B8=8B=E5=8D=88 2:2=
9, Ilya Dryomov =E5=86=99=E9=81=93:
> >>> Expanding on the previous commit, assuming that rbd_is_lock_owner()
> >>> always returns true (i.e. that we are either in RBD_LOCK_STATE_LOCKED
> >>> or RBD_LOCK_STATE_QUIESCING) if the mapping is exclusive is wrong too=
.
> >>> In case ceph_cls_set_cookie() fails, the lock would be temporarily
> >>> released even if the mapping is exclusive, meaning that we can end up
> >>> even in RBD_LOCK_STATE_UNLOCKED.
> >>>
> >>> IOW, exclusive mappings are really "just" about disabling automatic
> >>> lock transitions (as documented in the man page), not about grabbing
> >>> the lock and holding on to it whatever it takes.
> >>
> >> Hi Ilya,
> >>          Could you explain more about "disabling atomic lock transitio=
ns"? To be
> >> honest, I was thinking --exclusive means "grabbing
> >> the lock and holding on to it whatever it takes."
> >
> > Hi Dongsheng,
> >
> > Here are the relevant excerpts from the documentation [1]:
> >
> >> To maintain multi-client access, the exclusive-lock feature
> >> implements automatic cooperative lock transitions between clients.
> >>
> >> Whenever a client that holds an exclusive lock on an RBD image gets
> >> a request to release the lock, it stops handling writes, flushes its
> >> caches and releases the lock.
> >>
> >> By default, the exclusive-lock feature does not prevent two or more
> >> concurrently running clients from opening the same RBD image and
> >> writing to it in turns (whether on the same node or not). In effect,
> >> their writes just get linearized as the lock is automatically
> >> transitioned back and forth in a cooperative fashion.
> >>
> >> To disable automatic lock transitions between clients, the
> >> RBD_LOCK_MODE_EXCLUSIVE flag may be specified when acquiring the
> >> exclusive lock. This is exposed by the --exclusive option for rbd
> >> device map command.
> >
> > This is mostly equivalent to "grab the lock and hold on to it", but
> > it's not guaranteed that the lock would never be released.  If a watch
> > error occurs, the lock cookie needs to be updated after the watch is
> > reestablished.  If ceph_cls_set_cookie() fails, we have no choice but
> > to release the lock and immediately attempt to reacquire it because
> > otherwise the lock cookie would disagree with that of the new watch.
> >
> > The code in question has always behaved this way.  Prior to commit
> > 14bb211d324d ("rbd: support updating the lock cookie without releasing
> > the lock"), the lock was (briefly) released on watch errors
> > unconditionally.
>
> Thanx Ilya, it clarify things. then
>
> Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
>
> For all of these 3 patches.

Thanks for the speedy review!  I have fixed the typo in the description
of patch 1 and also appended stable tags to patches 2 and 3.

                Ilya

