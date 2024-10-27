Return-Path: <ceph-devel+bounces-1989-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42DED9B20E8
	for <lists+ceph-devel@lfdr.de>; Sun, 27 Oct 2024 22:47:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 738CA1C20AC5
	for <lists+ceph-devel@lfdr.de>; Sun, 27 Oct 2024 21:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64C29187FE0;
	Sun, 27 Oct 2024 21:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g5/k4/8K"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F412F29;
	Sun, 27 Oct 2024 21:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730065661; cv=none; b=JBp27jflNDr/GsyCrDyVkHFjdbhjFZ8/QqCx+iEUZUVGL1FTqTOFD1kje2wylMHaTybJl6khTK9r4wYFpHduZMcr+zM9sG4Aytg8+QksAPrY0zCDsO9QJCkPqsbEe5fF2sd3hKAjB4zBVxD/TbMI8JPUhJfTSRNeU27TUGvNeP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730065661; c=relaxed/simple;
	bh=E9ay0mMc1LiBVWe1QS7FU55dRKoLEwsU28xDgenGGuY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oomT2eAr01CpA5sF/CXqSzkqWN1SeNl4yDhFjR5YtCxu5IluciNnAw67v8e3xX/ZIdlk2I404tn89MTtjPbn3/KdOBJuoGBmC2y03KflSd+cARg/6+cYWOC61UoHCbw7rZl5z1Sn3OjLwSkKMvOy0usmEY02APPRfH5Slt4c2FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g5/k4/8K; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-28c654c9e79so2682592fac.0;
        Sun, 27 Oct 2024 14:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730065658; x=1730670458; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=czFGuZH37xfXUKVCzisGCFtqlQFZWtqwrSLmk/1K+SI=;
        b=g5/k4/8KMSNI7pvP0bD287IYFmFUhaFkXLtxVtITbGcig492S1Aj9yLxb9SIU+B3VZ
         1vf86jIVniEIUM2IdKiOjVoZ6JqWDC90/GnjvHjZLfADq5oY7pnAmfh87xqLHhT2t0rq
         h28EpGBTF0kUSVE4Qr+X+5Rqdpcw1G2w3hLCfMYI06qUEuJFtnove6ZcDTrG7TaEGyYy
         v9vGcaHVEabFgLULJ1l7DWhQ4LDWV3Y//Hwu6YGExd1k5XIgkbCyo6+WayLPRe84l9ql
         CkjfJ8dlP/E4WUVIXhn/LImeyl6AyZmuDHPxZuCcrJJyab2NB3rwk5G6a0SuikSqMAp4
         8g5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730065658; x=1730670458;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=czFGuZH37xfXUKVCzisGCFtqlQFZWtqwrSLmk/1K+SI=;
        b=nzecu7/IT2N723AvhUyPEUeR+WVe3zX3m25FQSNttfs56eBKhM94OKqIH0btiDZr19
         6uhjsWvQWqdhCCzXxTpfxSzU8FoMb5Jyb5F4DlJjLXuHGxXEGeXkJ8sDsw/p6jDH5LLm
         lkfap54HnEd7vXRAMp7jypQLH9YseYMYzKDVMHTS5gO9N8TUHxHoab07Svtsw/Gp/lOg
         TpPnicpT0bUQwSzgafBQqBs7NFXzCI1Pie/K5Jj+4vSuIZtrQ4K4bg5iRbfWPzWcYF+8
         GXbxGB0qQNl6F2cWkZhnAXVLNi5hq0l/61QLUhaaRfPHBYX8421f9IucyPDSHnv4wdSf
         AOhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKilbdMGSbcO+t9d5p+W3o3/Jgxyx94t51m7FlsBT8yoCAL8YEJXRJUZCDXkyicm40694rkUuH@vger.kernel.org, AJvYcCVV6f9VY2tx7BjC76r/k6cBOCBeucJ9ZRk/tFGpQXJNnieC0UFcw/ebnQHvN4XehTnS1P9yGq9LHSBo@vger.kernel.org, AJvYcCWQM5qlmTLcgeLSm8lpkrMe30WYBsJL0YYAwxWMschvjaevVBrWz7wJBREDn68J11cyskSMwlSURgrF5V/Y@vger.kernel.org
X-Gm-Message-State: AOJu0YxwY/8G9tSLGhYXpHYvgI35SgpKyL7p8gyrHTHPGql3GX5W9W1A
	eDK7QF6o9VccqWhLZTXksZgdmNOXsZFDsYJdP4kVXMTcWjA1e8DRU0FSX9O/DVh2G64WPQrC9Lo
	rwMwmkocv8eTekzYNqXKX+sv1cWk=
X-Google-Smtp-Source: AGHT+IFJMI+fl1f+AgKDHdr+uBwadrtvNmsukRkx8Q3fpRfmRzb+MXFKxEpBsvQMKiTXBPeGclPvazUKwolNM9y/KrY=
X-Received: by 2002:a05:6870:210:b0:27c:a414:bdda with SMTP id
 586e51a60fabf-290510bc54amr4153581fac.13.1730065658341; Sun, 27 Oct 2024
 14:47:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241011224736.236863-1-linux@treblig.org> <CAOi1vP9au=SqKfmyD79YA3gCGOCj1FjLNJxtF9N_k0cafCJ3uw@mail.gmail.com>
 <Zx6qB75QaDqlEsi1@gallifrey>
In-Reply-To: <Zx6qB75QaDqlEsi1@gallifrey>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Sun, 27 Oct 2024 22:47:26 +0100
Message-ID: <CAOi1vP_rN_c6q5D25hdOHJqFFZO+AzgztH3jFnn=5Q1d_ocU7Q@mail.gmail.com>
Subject: Re: [PATCH] libceph: Remove crush deadcode
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: xiubli@redhat.com, ceph-devel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 27, 2024 at 10:00=E2=80=AFPM Dr. David Alan Gilbert
<linux@treblig.org> wrote:
>
> * Ilya Dryomov (idryomov@gmail.com) wrote:
> > On Sat, Oct 12, 2024 at 12:47=E2=80=AFAM <linux@treblig.org> wrote:
> > >
> > > From: "Dr. David Alan Gilbert" <linux@treblig.org>
> > >
> > > crush_bucket_alg_name(), crush_get_bucket_item_weight(), crush_hash32=
(),
> > > and crush_hash32_5() were added by commit
> > > 5ecc0a0f8128 ("ceph: CRUSH mapping algorithm")
> > > in 2009 but never used.
> > >
> > > crush_hash_name() was added a little later by commit
> > > fb690390e305 ("ceph: make CRUSH hash function a bucket property")
> > > and also not used.
> > >
> > > Remove them.
> >
> > Hi David,
> >
> > The implementation of the CRUSH algorithm is shared with userspace and
> > these functions are used there (except for crush_hash32_5() perhaps).
> > They are all trivial code, so I'd prefer to keep them for convenience.
>
> OK, no problem.
> (Although perhaps an ifndef __KERNEL__ might save a few bytes?)

I'm not sure that is worth the churn.  If shaving off a teeny tiny bit
from the text section in generic distro kernels (where Ceph modules are
enabled) is really desired, I'd probably just drop these functions
(i.e. apply the patch as is).

Thanks,

                Ilya

