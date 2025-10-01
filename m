Return-Path: <ceph-devel+bounces-3775-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EB0A6BB13CC
	for <lists+ceph-devel@lfdr.de>; Wed, 01 Oct 2025 18:20:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 64B0F1927934
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Oct 2025 16:21:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6126283FEB;
	Wed,  1 Oct 2025 16:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="DUdfSOGD"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8601531C8
	for <ceph-devel@vger.kernel.org>; Wed,  1 Oct 2025 16:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759335641; cv=none; b=RBC2bJieLAdFtKEhwoepuwpqaDASxMrUpuiQuVXQLU+fm2qi8NNhiW0xQ2qJ5hPIpTGDQxrwbS0UlB/TOHMxwPYWaodYxUKSqtPUEUPaidaW5rsaM9mIOdTAGyGMCUhxp800cQ8p5ccU2siL/9//mWdX0+1YntVbKhmdgY3cJq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759335641; c=relaxed/simple;
	bh=bF4TapeByMmf2QIMlt+i6IMuYCh0cZxcnHBpdua+9A8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cu4DoczWoOh1x22C5acmpwhl3ZT6yinQEUqj6RFbMS8JWmNuvyFZFdOM8AoiuKxC/jUcnhJPxpxqKJpXG7tK2ZZJquP1rJthxcg2oCgnDXymkAfkwZqdKPA3JgBFr9ldZXz5zQ7evg2VbfrPw+aFP2ujh/HczDtwsjgwr0shWAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=DUdfSOGD; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-280fc0e9f50so10696245ad.3
        for <ceph-devel@vger.kernel.org>; Wed, 01 Oct 2025 09:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1759335639; x=1759940439; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EI/Oh8/PCAXf06I9PHPDwi4/0WefIWbrMGoTUuWrnBM=;
        b=DUdfSOGDFCywLhx0j2i0vLoE8X4BVHdwdrcXz3ZjbU07xeYqThI9ADFAKfBi93nAAz
         wJCGan0IRGr9c30eRpUvcx7/u8I5/0pRfJTPRuL2qwoBaOJF4XXxS93GfAHsKkxrPaeU
         2EiJLBlTW0l41mvZ3gPyFIkuXXvbou9blXA8wJHx1+n59bK3pZLGV+WEwqxfcPUIQtOk
         9ELe+XZrVaMn5N9aHFbNFKSKiPn9HJACpMv9bNB9xkKdYxTpkaHtNIqrB8ANdFOdZJwx
         q2XAehQO30P5rgEgVIy/1N9JXVjCQ6nekoCj801KgQpQXXEFUWwPsTFEQpLFtC1x470h
         wiXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759335639; x=1759940439;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EI/Oh8/PCAXf06I9PHPDwi4/0WefIWbrMGoTUuWrnBM=;
        b=Rm/v1GDFuyXw+4+nfYQuzi1MNkKIcHMBx30veXTBC/2BDeYkTWkqY8Fj2y1aknFvfd
         djJ6Tbjs1EDWGc4XTwyiAp75Z9ih2NpbFcyjt5p1wbXY3bg1YAcsZGFp0Tixdso50v64
         /ZZW8wyOwc885cNEF5le8t41useVeplXefsOPvnCg+y9eLjvrSEIK8SlTjLl77/dDfXg
         Q4kkROAg35n9hIKdRBi14Wx42U2saqvrhxgpfrC1vGmvIhsL4hPBuzbT3Q3lHVxxPF7v
         dCGZmL+xVJVVwkZceT8+nenXRC8JBsWcsv/rSVQq3x+R50Wrz8YEy0LUOLYdZV5gy7Bl
         tpBQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0dikXqMvbAIqlo8OfE3+Ih0JaNEXXT1WRfplQjpZxVRw7ecYt/QCR06woSlDS6ZXBo96KwFOQWZm9@vger.kernel.org
X-Gm-Message-State: AOJu0YwQ7B0yxqfaHkv0xiWGNXi5AXXu8sj7r36i3cqy2kmbV0ON+bL9
	WIieOibFbmY8hB2rzHYUM/eSpWXvn09fHtlZCPS0wfjCVU8HWZkmGd04s5dlv4owVg92KpahEJ4
	lmM04DpSUc4hkxRY1aie7DLT46t7raUVp3uPUOVIS1Q==
X-Gm-Gg: ASbGnctE/YAnLMW9S6B1A23H/xyctlAVzXZqGP3ERvqa0RzBlNi3ZysVezYEyZ6AXmp
	x6uTye9Lskvp+MFa3mJ/+FC7Tx4FnNDqm3mfUm/7w7EN+OO6OdGWVjoF7cH+G1riPFRfybB8+Qm
	OwWe9KdXh5c9hyw+QET6ZZd1UCEnSKnFJRScJ6dbpNcVD3DykeNvBg95mc+1RGXpl+2oo5DeD02
	/2bUPPDmo+RzEYbHBTd3BJOivu1fDKauIRRcNKaZlL/KxjnfQWX+3lajMl5DIs=
X-Google-Smtp-Source: AGHT+IFEIVnwr9ffJLEbYBthH98BS7huehwg+w3NxStPuNakBsASPv0qGndqlXbX/5EasnFoRUMSG34ReEMFLmrZsgY=
X-Received: by 2002:a17:902:c945:b0:258:a3a1:9aa5 with SMTP id
 d9443c01a7336-28e7ec77957mr31137405ad.0.1759335639054; Wed, 01 Oct 2025
 09:20:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250926065235.13623-1-409411716@gms.tku.edu.tw>
 <20250926065556.14250-1-409411716@gms.tku.edu.tw> <CADUfDZruZWyrsjRCs_Y5gjsbfU7dz_ALGG61pQ8qCM7K2_DjmA@mail.gmail.com>
 <aNz/+xLDnc2mKsKo@wu-Pro-E500-G6-WS720T>
In-Reply-To: <aNz/+xLDnc2mKsKo@wu-Pro-E500-G6-WS720T>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 1 Oct 2025 09:20:27 -0700
X-Gm-Features: AS18NWBzCQmPAr3kMe6kx-SwiJLpviu4tbIvpBzEeM52yLj1pwkHP5C3EVtP6wc
Message-ID: <CADUfDZq4c3dRgWpevv3+29frvd6L8G9RRdoVFpFnyRsF3Eve1Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] lib/base64: Optimize base64_decode() with reverse
 lookup tables
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org, 
	ebiggers@kernel.org, hch@lst.de, home7438072@gmail.com, idryomov@gmail.com, 
	jaegeuk@kernel.org, kbusch@kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com, xiubli@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 1, 2025 at 3:18=E2=80=AFAM Guan-Chun Wu <409411716@gms.tku.edu.=
tw> wrote:
>
> On Fri, Sep 26, 2025 at 04:33:12PM -0700, Caleb Sander Mateos wrote:
> > On Thu, Sep 25, 2025 at 11:59=E2=80=AFPM Guan-Chun Wu <409411716@gms.tk=
u.edu.tw> wrote:
> > >
> > > From: Kuan-Wei Chiu <visitorckw@gmail.com>
> > >
> > > Replace the use of strchr() in base64_decode() with precomputed rever=
se
> > > lookup tables for each variant. This avoids repeated string scans and
> > > improves performance. Use -1 in the tables to mark invalid characters=
.
> > >
> > > Decode:
> > >   64B   ~1530ns  ->  ~75ns    (~20.4x)
> > >   1KB  ~27726ns  -> ~1165ns   (~23.8x)
> > >
> > > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > > Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > > Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > > ---
> > >  lib/base64.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++--=
--
> > >  1 file changed, 61 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/lib/base64.c b/lib/base64.c
> > > index 1af557785..b20fdf168 100644
> > > --- a/lib/base64.c
> > > +++ b/lib/base64.c
> > > @@ -21,6 +21,63 @@ static const char base64_tables[][65] =3D {
> > >         [BASE64_IMAP] =3D "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnop=
qrstuvwxyz0123456789+,",
> > >  };
> > >
> > > +static const s8 base64_rev_tables[][256] =3D {
> > > +       [BASE64_STD] =3D {
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  =
-1,  -1,  -1,  63,
> > > +        52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  =
11,  12,  13,  14,
> > > +        15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  =
37,  38,  39,  40,
> > > +        41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +       },
> > > +       [BASE64_URLSAFE] =3D {
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  62,  -1,  -1,
> > > +        52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  =
11,  12,  13,  14,
> > > +        15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  =
-1,  -1,  -1,  63,
> > > +        -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  =
37,  38,  39,  40,
> > > +        41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +       },
> > > +       [BASE64_IMAP] =3D {
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  =
63,  -1,  -1,  -1,
> > > +        52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  =
11,  12,  13,  14,
> > > +        15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  =
37,  38,  39,  40,
> > > +        41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  =
-1,  -1,  -1,  -1,
> > > +       },
> >
> > Do we actually need 3 separate lookup tables? It looks like all 3
> > variants agree on the value of any characters they have in common. So
> > we could combine them into a single lookup table that would work for a
> > valid base64 string of any variant. The only downside I can see is
> > that base64 strings which are invalid in some variants might no longer
> > be rejected by base64_decode().
> >
>
> In addition to the approach David mentioned, maybe we can use a common
> lookup table for A=E2=80=93Z, a=E2=80=93z, and 0=E2=80=939, and then hand=
le the variant-specific
> symbols with a switch.
>
> For example:
>
> static const s8 base64_rev_common[256] =3D {
>     [0 ... 255] =3D -1,
>     ['A'] =3D 0, ['B'] =3D 1, /* ... */, ['Z'] =3D 25,
>     ['a'] =3D 26, /* ... */, ['z'] =3D 51,
>     ['0'] =3D 52, /* ... */, ['9'] =3D 61,
> };
>
> static inline int base64_rev_lookup(u8 c, enum base64_variant variant) {
>     s8 v =3D base64_rev_common[c];
>     if (v !=3D -1)
>         return v;
>
>     switch (variant) {
>     case BASE64_STD:
>         if (c =3D=3D '+') return 62;
>         if (c =3D=3D '/') return 63;
>         break;
>     case BASE64_IMAP:
>         if (c =3D=3D '+') return 62;
>         if (c =3D=3D ',') return 63;
>         break;
>     case BASE64_URLSAFE:
>         if (c =3D=3D '-') return 62;
>         if (c =3D=3D '_') return 63;
>         break;
>     }
>     return -1;
> }
>
> What do you think?

That adds several branches in the hot loop, at least 2 of which are
unpredictable for valid base64 input of a given variant (v !=3D -1 as
well as the first c check in the applicable switch case). That seems
like it would hurt performance, no? I think having 3 separate tables
would be preferable to making the hot loop more branchy.

Best,
Caleb

