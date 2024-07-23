Return-Path: <ceph-devel+bounces-1547-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BCC859399D3
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jul 2024 08:35:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A5FB1F229BB
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jul 2024 06:35:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59AA714A0A0;
	Tue, 23 Jul 2024 06:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BmVX45Gh"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFAD13C8F9
	for <ceph-devel@vger.kernel.org>; Tue, 23 Jul 2024 06:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721716507; cv=none; b=rrQIzhYttwUgw12gblKOUtLzU0URjus1EA9l4Lh3eBlG7JmLWajV94nCmwI6QXoPgsKgtMnBf7KdtOvFJAUtw9SrBWdDnCH/UFZLGjlCMDX1rrmwI/v5ukgf07YvzJenk01nAoqHC2BQBD5Cl4t4l6bNsm6HliV2EuFkREqJgQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721716507; c=relaxed/simple;
	bh=xpCh+y4usFfzjYtz++QE84bwl6CGQM5YLeWlXRFWsP4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XWIh7G3EbvHmIGHwkApz1LZ8qT1S6vY9f3wwDl5zqy2b/Iqy/iTLNo9dWnnfn3+zGMTnoh+WVCnSQcsjNSOXSl7MnTXtmPhG56gKdHTyOF1/A5XIzq406BqNSDlvDFGGMrNuJhN4SslJnNDJi0kXCPnF025OU2uuRncWBrlV7CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BmVX45Gh; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3d92df7e83cso2432662b6e.0
        for <ceph-devel@vger.kernel.org>; Mon, 22 Jul 2024 23:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721716504; x=1722321304; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b3x+8+zQoaHWOBZ0l1XX939EYfAe4z31KNtEz8p4HSc=;
        b=BmVX45Ghr7TWAKUDCjOlc3oiQ2St3jHmnhIUaUy3R1XPpyD26ZNTwVSMv7at3nn9L5
         jlODganERfm9G9VBCiXMrQDqmxVatlB9tvO8wT0s16X+jgMmrma0nsj3Cdk/fNtev4yG
         fqLJdccdHx4lOXlMiCFttfWkCeN1rkMxywxHUoEjqiNz9AoDPxVd5accGgOw8zCrKMtD
         31LEvsH/MoSGeUjBSddipQdHKYDCBulaiiuBPRjAQyVfJB/lpUi7Q+Nl6Dj1aSdZYqj7
         JMrW/av50n+f2zPN8oh4y51bYBebH6CFrv3yC0i3IxWw632ebfrR+HRFE2P61/03378w
         gR1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721716504; x=1722321304;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b3x+8+zQoaHWOBZ0l1XX939EYfAe4z31KNtEz8p4HSc=;
        b=aHlqyfDyMXYG50aRmzuvxh998meR9mHVW0CL+dWQ2wlXAr2pJahGjrzeXl3ASx7P/C
         Qs2c0v1vZjnNKFV0yAtVsULKbNR0AdiRh5OZwVD0omrFIZb1ThmMdBnUGyaqsJLMlfvH
         KERw5NhBAIpOlvXndd8IBhM9m/Qm7vUa8yxUC1sXD1kNhyiO27q8EjRiFV/yE8jh1iUO
         k9txZEZzaAD7Nb0RcluI+jyE7rfDko9/iuHGaKa2LUP29DpB9LN6jAs/4zoidDqraDFz
         cqvWNgOES1mQ4rrIMh2LXYrWE4c/2XVceKjukagXBL5BTy/QBHD/l16mXQRczz9gMVQ1
         9UAA==
X-Forwarded-Encrypted: i=1; AJvYcCXUYwB+9DKlrQPGfcQvucoWxUrD9oemPWOo+86wheWeUIlp61F67WrTK5w/GqZG3c02YhUnZFz2iNo7kw28bHUuEF/S5XKmS7+ssA==
X-Gm-Message-State: AOJu0YygoUSdu/n3uIS3oaZssh5p9vlo3PGvaOQeaNr1wtvR8nkALouX
	m1ZltPvaDldR1M3LZ1mDJr2YFxZuLVAWTmeCFNUkFQlLrIhBV89Z4iT5LsVZKulWCAAz9l37wQJ
	2az/Biw11Na6n118sjlOm+XfUYSE=
X-Google-Smtp-Source: AGHT+IHZJu/a/VBMmV7KVhufyQxyTcW+c6Xw87i8eWAKxDYgi+Z0/6q6mBBN6Xv9iZ4FDv6cP3bXPtHE+i/LPBkx/1o=
X-Received: by 2002:a05:6808:4186:b0:3d5:188d:46cf with SMTP id
 5614622812f47-3dafffef604mr511558b6e.10.1721716504582; Mon, 22 Jul 2024
 23:35:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240711064756.334775-1-ethanwu@synology.com> <b7738e0d-23bd-4527-9bef-ae15715921b3@redhat.com>
In-Reply-To: <b7738e0d-23bd-4527-9bef-ae15715921b3@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 23 Jul 2024 08:34:52 +0200
Message-ID: <CAOi1vP91g=g=Fc3RVtaGw7RRmjVzF6PG3sARn8=SQYMq-h8ihQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix incorrect kmalloc size of pagevec mempool
To: Xiubo Li <xiubli@redhat.com>
Cc: ethanwu <ethanwu@synology.com>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 15, 2024 at 4:10=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 7/11/24 14:47, ethanwu wrote:
> > The kmalloc size of pagevec mempool is incorrectly calculated.
> > It misses the size of page pointer and only accounts the number for the=
 array.
> >
> > Fixes: a0102bda5bc0 ("ceph: move sb->wb_pagevec_pool to be a global mem=
pool")
> > Signed-off-by: ethanwu <ethanwu@synology.com>
> > ---
> >   fs/ceph/super.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index 885cb5d4e771..46f640514561 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -961,7 +961,8 @@ static int __init init_caches(void)
> >       if (!ceph_mds_request_cachep)
> >               goto bad_mds_req;
> >
> > -     ceph_wb_pagevec_pool =3D mempool_create_kmalloc_pool(10, CEPH_MAX=
_WRITE_SIZE >> PAGE_SHIFT);
> > +     ceph_wb_pagevec_pool =3D mempool_create_kmalloc_pool(10,
> > +                             (CEPH_MAX_WRITE_SIZE >> PAGE_SHIFT) * siz=
eof(struct page *));
> >       if (!ceph_wb_pagevec_pool)
> >               goto bad_pagevec_pool;
> >
>
> Good cache, LGTM.

I don't think this matters in practice since 64M / 4K =3D 16K * 10 =3D 160K
of memory reserved just for page pointers is already quite a lot...

However, since commit a0102bda5bc0 is talking about moving a pool to be
global without adjusting its parameters, I agree that this fix is valid.

Thanks,

                Ilya

