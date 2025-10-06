Return-Path: <ceph-devel+bounces-3785-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D83FBBF65D
	for <lists+ceph-devel@lfdr.de>; Mon, 06 Oct 2025 22:52:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C6DD189AAB3
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Oct 2025 20:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC2BC25A2BB;
	Mon,  6 Oct 2025 20:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XRsExcMr"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287A7223DD1
	for <ceph-devel@vger.kernel.org>; Mon,  6 Oct 2025 20:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759783939; cv=none; b=cqj+EEaFG8GrqG6GtX00uRyzq1+nDPae0qM9xv4vB5/ZjyJD08RgkIKsfhvjlpzBIwQvMywWfao1ZntfbmZNEZYX+pv5bW32ScIvwx25+tJqZzKOFTWO9OCuJQu2aLouW5La9uqagOXmvOe5qSjU8361T9eNQMj29b7l5YXEDK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759783939; c=relaxed/simple;
	bh=SgZdgLfYa2RybFEsMrSySIU2QHr0Ijto9bld1Lp134Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NoCE7dZ3xvNh3V0ZzPjhf/lr8jWD8OfPRxADnvK3RZS/iq8ASHHeG19wGzHlDQCK69oleU3Gp7MqQQRq3qBTRYoirWLL4SKApMukoCGW8RAL3oDxXNB9+pRSGwyIOqq057PBN7801GbjuAUYXGk45LFudAogXwYYvGxrVDARw0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XRsExcMr; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-46e52279279so36445815e9.3
        for <ceph-devel@vger.kernel.org>; Mon, 06 Oct 2025 13:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759783934; x=1760388734; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sZhEGqG5f02SA+cxa1EF4uynlEuBc23Gw/Zg/k7vIsQ=;
        b=XRsExcMrubVkblxbtUw/rBmjTkRf6ORc3zWQLdycIMKz3PYSavyBRXFKzEqpQNTrc2
         Uqy21nJqBtj3Z76JFbZSAQKmUT0i4Q2n+XtzciIgOm9YAB3nqrnFx5+WQW6RmCb3KoSS
         d7/afsWg3LCqwYNrGsiEKDcV/jOwdHMmi07ePokVC+RVSUdO7A/7ALTSp6THQLd0Iba/
         Cb3WLtIw8amznnpMu18GpgDFv8aGoRmVCU3Pry+R3CM/RuyUR38ErYIMdFul/kfVurGX
         PBna8TyDHD3adPmDG6glLy2I4YcsVYA9YbNCNR9+kNKTsSl/4MXhfDbqGJZU5lPnQ2gA
         kHmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759783934; x=1760388734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sZhEGqG5f02SA+cxa1EF4uynlEuBc23Gw/Zg/k7vIsQ=;
        b=UQt3dfd0aoaR3g+aPE1t6nY1BbkztQWkC2xut/eLjHR9dvITVptYnFd7xR+0AVFJEp
         ciWb6S7bgbHGAQPFIftS5jt9Tk7x4lLU/yzYlKwPB2xC3V+LywxDXCkjGszdCIp4d4hT
         KoJsdXUQnxTh5o5Xg3X3H0XP1M2L0tqOAmYioU1c3faPma9/q5DMHb51pV8ZFwpKbuDF
         LB20beUcy0fwM8Lr8f35rwSGzu2TAUivOMmFeVcP04mYxXvbpwKmajq7YmotVtP/I/OJ
         0h4KINZnBjU+mTEUi41Uvwe2YMAfOC5X416itU1RIgbv3Uk4Hjq8u4KXciWiMZ1RLAi8
         e4XQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZQHaifuOOGin2GxHirkvChvp8zn0/+Dt5HCmcFwD6/KP+Ry7ZMDlq5lj5K10nZqgc3ZJX9vpDIKD9@vger.kernel.org
X-Gm-Message-State: AOJu0YxdEXRH6i1RcXQMvH1W3EpSYwliH3E4BaO1kbMWczqRQHDF2f9N
	ij4y0QsY8vvzTyzRAEvE7P9PY+xwly/WF5YnFaqCYc51+t5BF1P1SeWo
X-Gm-Gg: ASbGncvQb7y4rCkvIyBbmbFdz2xTH3vyAfMNt8NzTaeeXGAHQhZ86uGlbG9bMB5yov5
	GPEEsETQck1soKnhhJ6u4IatNNMBzqPK6bRdFp3ULq1I8zxR1FWf7a6tdajrKANEHnguZqcI1go
	quPNXxLW9P96A48hWkT8yqCdZ7fsWqRkB1FO7H5iJrBa9x+VX9WZaXbLUeD0n5sS7eYMTSnSMHm
	A0Ax5PExp2TQ3cbxavF4hHEDFJ0b5lTmSAwZL2TCv5RWsurA2f1xtFEXctYLls/1Y+zLONfjfnQ
	B+vn9PgXvhhse/TYPI5zG/N7/GXtlG1uuhDdhXRNa4KfZ9AE2wc05xe+d1vbRgd1bPFv6On6dJK
	RYH0LSI4qCcTEIXT5aHN2sKBAM21Dv4NxJYsbx3cbfKw7a4+VPqeYAdKCDJYMX3ZrrSXzXK1Y45
	jSLt6SnB9P5AIWTR/1cZe8oSw=
X-Google-Smtp-Source: AGHT+IFRLlb8uWC1dqxKo8J55feiaCNAhabM0Ub7mobnG4dCUMmuEgByLy76YakZhK1VJ6qhsA7FmQ==
X-Received: by 2002:a05:600c:8b6e:b0:46e:3d50:362a with SMTP id 5b1f17b1804b1-46e710ffff6mr85930215e9.4.1759783934211;
        Mon, 06 Oct 2025 13:52:14 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e723624b3sm171254835e9.17.2025.10.06.13.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 13:52:13 -0700 (PDT)
Date: Mon, 6 Oct 2025 21:52:12 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
 akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org,
 ebiggers@kernel.org, hch@lst.de, home7438072@gmail.com, idryomov@gmail.com,
 jaegeuk@kernel.org, kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v3 3/6] lib/base64: rework encode/decode for speed and
 stricter validation
Message-ID: <20251006215212.2920d571@pumpkin>
In-Reply-To: <aNz21InCM4Pa93TL@wu-Pro-E500-G6-WS720T>
References: <20250926065235.13623-1-409411716@gms.tku.edu.tw>
	<20250926065617.14361-1-409411716@gms.tku.edu.tw>
	<CADUfDZpu=rK4WwSmhNgxHQd2zeNvn8a7TmKCYuTL5T7dZ0x_4A@mail.gmail.com>
	<aNz21InCM4Pa93TL@wu-Pro-E500-G6-WS720T>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Oct 2025 17:39:32 +0800
Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:

> On Tue, Sep 30, 2025 at 05:11:12PM -0700, Caleb Sander Mateos wrote:
> > On Fri, Sep 26, 2025 at 12:01=E2=80=AFAM Guan-Chun Wu <409411716@gms.tk=
u.edu.tw> wrote: =20
> > >
> > > The old base64 implementation relied on a bit-accumulator loop, which=
 was
> > > slow for larger inputs and too permissive in validation. It would acc=
ept
> > > extra '=3D', missing '=3D', or even '=3D' appearing in the middle of =
the input,
> > > allowing malformed strings to pass. This patch reworks the internals =
to
> > > improve performance and enforce stricter validation.
> > >
> > > Changes:
> > >  - Encoder:
> > >    * Process input in 3-byte blocks, mapping 24 bits into four 6-bit
> > >      symbols, avoiding bit-by-bit shifting and reducing loop iteratio=
ns.
> > >    * Handle the final 1-2 leftover bytes explicitly and emit '=3D' on=
ly when
> > >      requested.
> > >  - Decoder:
> > >    * Based on the reverse lookup tables from the previous patch, deco=
de
> > >      input in 4-character groups.
> > >    * Each group is looked up directly, converted into numeric values,=
 and
> > >      combined into 3 output bytes.
> > >    * Explicitly handle padded and unpadded forms:
> > >       - With padding: input length must be a multiple of 4, and '=3D'=
 is
> > >         allowed only in the last two positions. Reject stray or early=
 '=3D'.
> > >       - Without padding: validate tail lengths (2 or 3 chars) and req=
uire
> > >         unused low bits to be zero.
> > >    * Removed the bit-accumulator style loop to reduce loop iterations.
> > >
> > > Performance (x86_64, Intel Core i7-10700 @ 2.90GHz, avg over 1000 run=
s,
> > > KUnit):
> > >
> > > Encode:
> > >   64B   ~90ns   -> ~32ns   (~2.8x)
> > >   1KB  ~1332ns  -> ~510ns  (~2.6x)
> > >
> > > Decode:
> > >   64B  ~1530ns  -> ~64ns   (~23.9x)
> > >   1KB ~27726ns  -> ~982ns  (~28.3x)
> > >
> > > Co-developed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > > Co-developed-by: Yu-Sheng Huang <home7438072@gmail.com>
> > > Signed-off-by: Yu-Sheng Huang <home7438072@gmail.com>
> > > Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > > ---
> > >  lib/base64.c | 150 +++++++++++++++++++++++++++++++++++++------------=
--
> > >  1 file changed, 110 insertions(+), 40 deletions(-)
> > >
> > > diff --git a/lib/base64.c b/lib/base64.c
> > > index b20fdf168..fd1db4611 100644
> > > --- a/lib/base64.c
> > > +++ b/lib/base64.c
> > > @@ -93,26 +93,43 @@ static const s8 base64_rev_tables[][256] =3D {
> > >  int base64_encode(const u8 *src, int srclen, char *dst, bool padding=
, enum base64_variant variant)
> > >  {
> > >         u32 ac =3D 0;
> > > -       int bits =3D 0;
> > > -       int i;
> > >         char *cp =3D dst;
> > >         const char *base64_table =3D base64_tables[variant];
> > >
> > > -       for (i =3D 0; i < srclen; i++) {
> > > -               ac =3D (ac << 8) | src[i];
> > > -               bits +=3D 8;
> > > -               do {
> > > -                       bits -=3D 6;
> > > -                       *cp++ =3D base64_table[(ac >> bits) & 0x3f];
> > > -               } while (bits >=3D 6);
> > > -       }
> > > -       if (bits) {
> > > -               *cp++ =3D base64_table[(ac << (6 - bits)) & 0x3f];
> > > -               bits -=3D 6;
> > > +       while (srclen >=3D 3) {
> > > +               ac =3D ((u32)src[0] << 16) |
> > > +                        ((u32)src[1] << 8) |
> > > +                        (u32)src[2];
> > > +
> > > +               *cp++ =3D base64_table[ac >> 18];
> > > +               *cp++ =3D base64_table[(ac >> 12) & 0x3f];
> > > +               *cp++ =3D base64_table[(ac >> 6) & 0x3f];
> > > +               *cp++ =3D base64_table[ac & 0x3f];
> > > +
> > > +               src +=3D 3;
> > > +               srclen -=3D 3;
> > >         }
> > > -       while (bits < 0) {
> > > -               *cp++ =3D '=3D';
> > > -               bits +=3D 2;
> > > +
> > > +       switch (srclen) {
> > > +       case 2:
> > > +               ac =3D ((u32)src[0] << 16) |
> > > +                    ((u32)src[1] << 8);
> > > +
> > > +               *cp++ =3D base64_table[ac >> 18];
> > > +               *cp++ =3D base64_table[(ac >> 12) & 0x3f];
> > > +               *cp++ =3D base64_table[(ac >> 6) & 0x3f];
> > > +               if (padding)
> > > +                       *cp++ =3D '=3D';
> > > +               break;
> > > +       case 1:
> > > +               ac =3D ((u32)src[0] << 16);
> > > +               *cp++ =3D base64_table[ac >> 18];
> > > +               *cp++ =3D base64_table[(ac >> 12) & 0x3f];
> > > +               if (padding) {
> > > +                       *cp++ =3D '=3D';
> > > +                       *cp++ =3D '=3D';
> > > +               }
> > > +               break;
> > >         }
> > >         return cp - dst;
> > >  }
> > > @@ -128,39 +145,92 @@ EXPORT_SYMBOL_GPL(base64_encode);
> > >   *
> > >   * Decodes a string using the selected Base64 variant.
> > >   *
> > > - * This implementation hasn't been optimized for performance.
> > > - *
> > >   * Return: the length of the resulting decoded binary data in bytes,
> > >   *        or -1 if the string isn't a valid Base64 string.
> > >   */
> > >  int base64_decode(const char *src, int srclen, u8 *dst, bool padding=
, enum base64_variant variant)
> > >  {
> > > -       u32 ac =3D 0;
> > > -       int bits =3D 0;
> > > -       int i;
> > >         u8 *bp =3D dst;
> > > -       s8 ch;
> > > -
> > > -       for (i =3D 0; i < srclen; i++) {
> > > -               if (src[i] =3D=3D '=3D') {
> > > -                       ac =3D (ac << 6);
> > > -                       bits +=3D 6;
> > > -                       if (bits >=3D 8)
> > > -                               bits -=3D 8;
> > > -                       continue;
> > > -               }
> > > -               ch =3D base64_rev_tables[variant][(u8)src[i]];
> > > -               if (ch =3D=3D -1)
> > > +       s8 input1, input2, input3, input4;
> > > +       u32 val;
> > > +
> > > +       if (srclen =3D=3D 0)
> > > +               return 0; =20
> >=20
> > Doesn't look like this special case is necessary; all the if and while
> > conditions below are false if srclen =3D=3D 0, so the function will just
> > end up returning 0 in that case anyways. It would be nice to avoid
> > this branch, especially as it seems like an uncommon case.
> > =20
>=20
> You're right. I'll remove it. Thanks.
>=20
> > > +
> > > +       /* Validate the input length for padding */
> > > +       if (unlikely(padding && (srclen & 0x03) !=3D 0))
> > > +               return -1;
> > > +
> > > +       while (srclen >=3D 4) {
> > > +               /* Decode the next 4 characters */
> > > +               input1 =3D base64_rev_tables[variant][(u8)src[0]];
> > > +               input2 =3D base64_rev_tables[variant][(u8)src[1]];
> > > +               input3 =3D base64_rev_tables[variant][(u8)src[2]];
> > > +               input4 =3D base64_rev_tables[variant][(u8)src[3]];
> > > +
> > > +               /* Return error if any Base64 character is invalid */
> > > +               if (unlikely(input1 < 0 || input2 < 0 || (!padding &&=
 (input3 < 0 || input4 < 0))))
> > > +                       return -1;
> > > +
> > > +               /* Handle padding */
> > > +               if (unlikely(padding && ((input3 < 0 && input4 >=3D 0=
) ||
> > > +                                        (input3 < 0 && src[2] !=3D '=
=3D') ||
> > > +                                        (input4 < 0 && src[3] !=3D '=
=3D') ||
> > > +                                        (srclen > 4 && (input3 < 0 |=
| input4 < 0))))) =20
> >=20
> > Would be preferable to check and strip the padding (i.e. decrease
> > srclen) before this main loop. That way we could avoid several
> > branches in this hot loop that are only necessary to handle the
> > padding chars.
> >  =20
>=20
> You're right. As long as we check and strip the padding first, the
> behavior with or without padding can be the same, and it could also
> reduce some unnecessary branches. I'll make the change.

As I said earlier.
Calculate 'val' first using signed arithmetic.
If it is non-negative there are three bytes to write.
If negative then check for src[2] and src[3] being '=3D' (etc) before error=
ing out.

That way there is only one check in the normal path.

	David

>=20
> Best regards,
> Guan-Chun
>=20
> > > +                       return -1;
> > > +               val =3D ((u32)input1 << 18) |
> > > +                     ((u32)input2 << 12) |
> > > +                     ((u32)((input3 < 0) ? 0 : input3) << 6) |
> > > +                     (u32)((input4 < 0) ? 0 : input4);
> > > +
> > > +               *bp++ =3D (u8)(val >> 16);
> > > +
> > > +               if (input3 >=3D 0)
> > > +                       *bp++ =3D (u8)(val >> 8);
> > > +               if (input4 >=3D 0)
> > > +                       *bp++ =3D (u8)val;
> > > +
> > > +               src +=3D 4;
> > > +               srclen -=3D 4;
> > > +       }
> > > +
> > > +       /* Handle leftover characters when padding is not used */
> > > +       if (!padding && srclen > 0) {
> > > +               switch (srclen) {
> > > +               case 2:
> > > +                       input1 =3D base64_rev_tables[variant][(u8)src=
[0]];
> > > +                       input2 =3D base64_rev_tables[variant][(u8)src=
[1]];
> > > +                       if (unlikely(input1 < 0 || input2 < 0))
> > > +                               return -1;
> > > +
> > > +                       val =3D ((u32)input1 << 6) | (u32)input2; /* =
12 bits */
> > > +                       if (unlikely(val & 0x0F))
> > > +                               return -1; /* low 4 bits must be zero=
 */
> > > +
> > > +                       *bp++ =3D (u8)(val >> 4);
> > > +                       break;
> > > +               case 3:
> > > +                       input1 =3D base64_rev_tables[variant][(u8)src=
[0]];
> > > +                       input2 =3D base64_rev_tables[variant][(u8)src=
[1]];
> > > +                       input3 =3D base64_rev_tables[variant][(u8)src=
[2]];
> > > +                       if (unlikely(input1 < 0 || input2 < 0 || inpu=
t3 < 0))
> > > +                               return -1;
> > > +
> > > +                       val =3D ((u32)input1 << 12) |
> > > +                             ((u32)input2 << 6) |
> > > +                             (u32)input3; /* 18 bits */
> > > +
> > > +                       if (unlikely(val & 0x03))
> > > +                               return -1; /* low 2 bits must be zero=
 */
> > > +
> > > +                       *bp++ =3D (u8)(val >> 10);
> > > +                       *bp++ =3D (u8)((val >> 2) & 0xFF); =20
> >=20
> > "& 0xFF" is redundant with the cast to u8.
> >=20
> > Best,
> > Caleb
> >  =20
> > > +                       break;
> > > +               default:
> > >                         return -1;
> > > -               ac =3D (ac << 6) | ch;
> > > -               bits +=3D 6;
> > > -               if (bits >=3D 8) {
> > > -                       bits -=3D 8;
> > > -                       *bp++ =3D (u8)(ac >> bits);
> > >                 }
> > >         }
> > > -       if (ac & ((1 << bits) - 1))
> > > -               return -1;
> > > +
> > >         return bp - dst;
> > >  }
> > >  EXPORT_SYMBOL_GPL(base64_decode);
> > > --
> > > 2.34.1
> > >
> > > =20
>=20


