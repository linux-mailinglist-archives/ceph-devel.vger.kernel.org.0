Return-Path: <ceph-devel+bounces-3781-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E0E5BB99F5
	for <lists+ceph-devel@lfdr.de>; Sun, 05 Oct 2025 19:18:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C91663B2804
	for <lists+ceph-devel@lfdr.de>; Sun,  5 Oct 2025 17:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 691DC2441A6;
	Sun,  5 Oct 2025 17:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U/a6KOF0"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387CE2B9B9
	for <ceph-devel@vger.kernel.org>; Sun,  5 Oct 2025 17:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759684734; cv=none; b=IaT+AKk57mUFQ2eqAx72pwDaQZdqN3JzpeCwO/WBbVprqwr2jbxC8+bXfYinRoDe7VRjONgca6EIf32RXD9iCxLg8/v5Y+XM9QsvHiE6kJp70tYlXXvwC8ngz1i0HkwzBVrl2mGW3S2yqilM/0zaileXex5J2pSXMnY0kiUxZ2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759684734; c=relaxed/simple;
	bh=xDzUfeZ1vAo8rCEH7eM2+z4x0GgHtGzJwAUEEuMZBE4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J2KKN5hVDqYFRfS5HROLFY0XCZi5M4rsJbWwrX7K9MhiiSJgrPTU8zsJQ+e4Iz0AdUDLnCNkBs6ef5b9HLVf1hGPjZqCtCAKM432/+9gdJtNnqLkw4hH60Q9SuT046rY+JahsUtNq0dV8bfehnqGWVb1b3pPpKOfKJHWBRouRgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U/a6KOF0; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-46e34052bb7so43158625e9.2
        for <ceph-devel@vger.kernel.org>; Sun, 05 Oct 2025 10:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759684730; x=1760289530; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J0ULdM4RO6Y+nM8oAEAyBDinfjXj2njenLfdZojAe+c=;
        b=U/a6KOF0o7PmOgekaFIC06kTQ5M2VEZpOGt4ub0puAflHyGdQZpivc/4WYK6mss4Un
         OQmGDbJgYZ8oGcm5DTav2XSATvBb75kdbw1klT2injCuP4mNKHG1s9oW1ZsuQLxaYsmF
         z8fK2Qovds5/gPWsH9aAOJ2D9XoTvlC4UNWPnQu+WAB3xzUtZaZKPhYNQ/uNZNB1jWl6
         67HwzsfyX9La3/kv3z6DPQmwcJaC4d0cyLvtug5dRIOpzmAq57eCGuOlLbCvlmDg3CeE
         WGqCCDxeJC9urbU0ycV7z/mdSUDE7dz2ZGiTYGg4oj3eqMagUMrqzWMxuCgCWt9z+zjH
         Cs2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759684730; x=1760289530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J0ULdM4RO6Y+nM8oAEAyBDinfjXj2njenLfdZojAe+c=;
        b=gb4b/in7EKYulKCdIrcX5lFbX8tFUvT0mbvcZNQcA+P3vWpeJF6OCVA5jtwTGvfiLH
         9/dLmGPoj8tnyHUUM6rAu+oSt+t5LKmuW8POqEPa5mAgzf6Vn2Q613rW4+2X0tr9KkSc
         3FsONZZ5njGe78eemU3tKtFI/gPukt7HoJQB+mmBVhKC5TVRZvdHBijuiGowmd9OBF0I
         wE/WeaybYmBFrZMJKTM/KzrVEGzJWQEPM3h0Ce/+Yf1Ruvf6BX0WsdbYm+CTf8KMePiB
         R8q/tJGoP93d/q5MLmgkZkYkhKft4KZx76j9YNI8QF6qPchHkmTaj2g0lattXT3PhxUi
         yUlA==
X-Forwarded-Encrypted: i=1; AJvYcCWEmE/5nMH/ViXlFbMbX93ncjNcT/qgTPnuDoVNGv3dwl57uRWh3vV2v46/qywWh3Uy/ULIfkWKQSZK@vger.kernel.org
X-Gm-Message-State: AOJu0YwE2tEB4Wi/l10tmPKyk26Yf5ls2sMn/eA2BPiLSkG1FAusIszl
	sIQXDordgH7Y+2PvpOLDlTG3tSzP99QD+dEL3WTOIAQe+34f4olDax6h
X-Gm-Gg: ASbGncu9UyhL7y/JDOcWKSNpbE8jkqp05jKYCbBcWSQHHG2SFcgHYg96x9O/evdbrSt
	VTK6lgK19WfNyzFiZKRxa+y7Vgf2hW9pSlnbRXspbXATsPFjJ4Rnh09mWAS+e6fxf0bJHCuFx69
	UzE8kUQ4LLct3GdCi+CPqfzNY9rBWApTFRplQrdVdwhvcJSYjMlR+Ar8I/nm+jHOJd7C4VOhIrd
	mjPYPXpHfyhbH63Rj9HlR481VE/gldcLlefujQXIwHaKL08sQP95F9Fj0+/8mkY6uO9JeEV4CZM
	mgOTAThHDTcsGR2tS+/EwAPcyBWJaSRVunr+CtYxXzsVBZ9PUblgV7LZynjzAofbmhueLir29O0
	JQLn9mKHmO0m+vPiE+q+FhWQ9ekZ4WGMjo3hhTYvewH08yrJVFf79C092C5YFSoSmd+VatnDmIU
	0KvVW+SbIZ096u
X-Google-Smtp-Source: AGHT+IGVjN1kbt6UIzDiRaCKMzUM7GpwndVH8xqVRWPwdEAZd+Z/455EHR7od34KWx6ewjDoMtzyzw==
X-Received: by 2002:a05:600c:a14:b0:46e:3403:63df with SMTP id 5b1f17b1804b1-46e711043a5mr72182845e9.8.1759684730254;
        Sun, 05 Oct 2025 10:18:50 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f02a8sm17320240f8f.39.2025.10.05.10.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Oct 2025 10:18:49 -0700 (PDT)
Date: Sun, 5 Oct 2025 18:18:03 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Guan-Chun Wu <409411716@gms.tku.edu.tw>, akpm@linux-foundation.org,
 axboe@kernel.dk, ceph-devel@vger.kernel.org, ebiggers@kernel.org,
 hch@lst.de, home7438072@gmail.com, idryomov@gmail.com, jaegeuk@kernel.org,
 kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v3 2/6] lib/base64: Optimize base64_decode() with
 reverse lookup tables
Message-ID: <20251005181803.0ba6aee4@pumpkin>
In-Reply-To: <CADUfDZq4c3dRgWpevv3+29frvd6L8G9RRdoVFpFnyRsF3Eve1Q@mail.gmail.com>
References: <20250926065235.13623-1-409411716@gms.tku.edu.tw>
	<20250926065556.14250-1-409411716@gms.tku.edu.tw>
	<CADUfDZruZWyrsjRCs_Y5gjsbfU7dz_ALGG61pQ8qCM7K2_DjmA@mail.gmail.com>
	<aNz/+xLDnc2mKsKo@wu-Pro-E500-G6-WS720T>
	<CADUfDZq4c3dRgWpevv3+29frvd6L8G9RRdoVFpFnyRsF3Eve1Q@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Oct 2025 09:20:27 -0700
Caleb Sander Mateos <csander@purestorage.com> wrote:

> On Wed, Oct 1, 2025 at 3:18=E2=80=AFAM Guan-Chun Wu <409411716@gms.tku.ed=
u.tw> wrote:
> >
> > On Fri, Sep 26, 2025 at 04:33:12PM -0700, Caleb Sander Mateos wrote: =20
> > > On Thu, Sep 25, 2025 at 11:59=E2=80=AFPM Guan-Chun Wu <409411716@gms.=
tku.edu.tw> wrote: =20
> > > >
> > > > From: Kuan-Wei Chiu <visitorckw@gmail.com>
> > > >
> > > > Replace the use of strchr() in base64_decode() with precomputed rev=
erse
> > > > lookup tables for each variant. This avoids repeated string scans a=
nd
> > > > improves performance. Use -1 in the tables to mark invalid characte=
rs.
> > > >
> > > > Decode:
> > > >   64B   ~1530ns  ->  ~75ns    (~20.4x)
> > > >   1KB  ~27726ns  -> ~1165ns   (~23.8x)
> > > >
> > > > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > > > Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > > > Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > > > ---
> > > >  lib/base64.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++=
----
> > > >  1 file changed, 61 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/lib/base64.c b/lib/base64.c
> > > > index 1af557785..b20fdf168 100644
> > > > --- a/lib/base64.c
> > > > +++ b/lib/base64.c
> > > > @@ -21,6 +21,63 @@ static const char base64_tables[][65] =3D {
> > > >         [BASE64_IMAP] =3D "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmn=
opqrstuvwxyz0123456789+,",
> > > >  };
> > > >
> > > > +static const s8 base64_rev_tables[][256] =3D {
> > > > +       [BASE64_STD] =3D {
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,=
  -1,  -1,  -1,  63,
> > > > +        52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,=
  11,  12,  13,  14,
> > > > +        15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,=
  37,  38,  39,  40,
> > > > +        41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +       },
> > > > +       [BASE64_URLSAFE] =3D {
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  62,  -1,  -1,
> > > > +        52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,=
  11,  12,  13,  14,
> > > > +        15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,=
  -1,  -1,  -1,  63,
> > > > +        -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,=
  37,  38,  39,  40,
> > > > +        41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +       },
> > > > +       [BASE64_IMAP] =3D {
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,=
  63,  -1,  -1,  -1,
> > > > +        52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,=
  11,  12,  13,  14,
> > > > +        15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,=
  37,  38,  39,  40,
> > > > +        41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,=
  -1,  -1,  -1,  -1,
> > > > +       }, =20
> > >
> > > Do we actually need 3 separate lookup tables? It looks like all 3
> > > variants agree on the value of any characters they have in common. So
> > > we could combine them into a single lookup table that would work for a
> > > valid base64 string of any variant. The only downside I can see is
> > > that base64 strings which are invalid in some variants might no longer
> > > be rejected by base64_decode().
> > > =20
> >
> > In addition to the approach David mentioned, maybe we can use a common
> > lookup table for A=E2=80=93Z, a=E2=80=93z, and 0=E2=80=939, and then ha=
ndle the variant-specific
> > symbols with a switch.

It is certainly possible to generate the initialiser from a #define to
avoid all the replicated source.

> >
> > For example:
> >
> > static const s8 base64_rev_common[256] =3D {
> >     [0 ... 255] =3D -1,
> >     ['A'] =3D 0, ['B'] =3D 1, /* ... */, ['Z'] =3D 25,

If you assume ASCII (I doubt Linux runs on any EBCDIC systems) you
can assume the characters are sequential and miss ['B'] =3D etc to
reduce the the line lengths.
(Even EBCDIC has A-I J-R S-Z and 0-9 as adjacent values)

> >     ['a'] =3D 26, /* ... */, ['z'] =3D 51,
> >     ['0'] =3D 52, /* ... */, ['9'] =3D 61,
> > };
> >
> > static inline int base64_rev_lookup(u8 c, enum base64_variant variant) {
> >     s8 v =3D base64_rev_common[c];
> >     if (v !=3D -1)
> >         return v;
> >
> >     switch (variant) {
> >     case BASE64_STD:
> >         if (c =3D=3D '+') return 62;
> >         if (c =3D=3D '/') return 63;
> >         break;
> >     case BASE64_IMAP:
> >         if (c =3D=3D '+') return 62;
> >         if (c =3D=3D ',') return 63;
> >         break;
> >     case BASE64_URLSAFE:
> >         if (c =3D=3D '-') return 62;
> >         if (c =3D=3D '_') return 63;
> >         break;
> >     }
> >     return -1;
> > }
> >
> > What do you think? =20
>=20
> That adds several branches in the hot loop, at least 2 of which are
> unpredictable for valid base64 input of a given variant (v !=3D -1 as
> well as the first c check in the applicable switch case).

I'd certainly pass in the character values for 62 and 63 so they are
determined well outside the inner loop.
Possibly even going as far as #define BASE64_STD ('+' << 8 | '/').

> That seems like it would hurt performance, no?
> I think having 3 separate tables
> would be preferable to making the hot loop more branchy.

Depends how common you think 62 and 63 are...
I guess 63 comes from 0xff bytes - so might be quite common.

One thing I think you've missed is that the decode converts 4 characters
into 24 bits - which then need carefully writing into the output buffer.
There is no need to check whether each character is valid.
After:
	val_24 =3D t[b[0]] | t[b[1]] << 6 | t[b[2]] << 12 | t[b[3]] << 18;
val_24 will be negative iff one of b[0..3] is invalid.
So you only need to check every 4 input characters, not for every one.
That does require separate tables.
(Or have a decoder that always maps "+-" to 62 and "/,_" to 63.)

	David

>=20
> Best,
> Caleb
>=20


