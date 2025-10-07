Return-Path: <ceph-devel+bounces-3791-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79B47BC260A
	for <lists+ceph-devel@lfdr.de>; Tue, 07 Oct 2025 20:24:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 101BC400713
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Oct 2025 18:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBB8A2DFA2F;
	Tue,  7 Oct 2025 18:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lDe6rU3e"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41872E8B62
	for <ceph-devel@vger.kernel.org>; Tue,  7 Oct 2025 18:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759861465; cv=none; b=b1zXdK3+DLm9d5gj0RHGAV4eBYsEZTOKWk4ufOQMBBO+6/rgXOB1906Wqcm0YGBugcsXNToZ6AaSETUey/O1wSx8rLgLOxi5j5TZ537d/LbuGhThmIkFezEvYEsVK4kPl5L5CWSwyhMH/2h4rp5uIyj9e615fvSEZpRX51DdBNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759861465; c=relaxed/simple;
	bh=Xa09G7kAEtQpxw4yOJ2reBncMLpC8/fWQifv/+f3CTY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jcjS8hy4QzBjid0gHrc3tt/m9Svx2JGi6yapAZT4NbOj4P1nbIXox7fEb876ob5vK2WCcT3KDRp+6tDIlJQAwgTKyjzbR2qYuNVpcR6tkIB6vOVoAZ2arg5FrLx+nvbas/Xa81jI6dIZgP/VLWGMnqqES634hprQw6oWqwnpvjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lDe6rU3e; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-46e6674caa5so907105e9.0
        for <ceph-devel@vger.kernel.org>; Tue, 07 Oct 2025 11:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759861462; x=1760466262; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eQmS4iGCIsqFscOYPI2pMSI5i8ARz15f5xJppXklNTg=;
        b=lDe6rU3eBNwmbFmjWhGDJuyiheMj39MAUWVbIJkwfW5raOHZrbRiGTUT7RHLqRGAZ/
         C4DsCCO1i8JmuQMSRB8QdBllKh9KP8khtjSTj9vdwjAWB19RTHcVZU/4y7QNVTQvG1tH
         +1iXqlMEyjjBVp68LluKyrU9s7O5QGL417ikM6+kuUBGUgPca31hbpy0j4QzykH6WaId
         rDDUfwC/b37DDfLA5es1OiEFncG++ktNolGwKUT1K9JisfrwXPjN7kUmdPkGBka/tIvu
         icRjCUuxqDNMB/3SpQ3QuQVKZ4oHmqh6YskN8W4vXVe2cdm17PnEra2j35tirywEZd03
         +n8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759861462; x=1760466262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eQmS4iGCIsqFscOYPI2pMSI5i8ARz15f5xJppXklNTg=;
        b=oFrd36r3OwZwMp9z7aHzA8O5bPagh//CG155swR8CcZ7Vg6a64tMyua5NK8vbcAs8a
         RdeIyo5Pfius/HMFdWvwrdWCafoNBKfG44IlPcuKlx3KM9DvxZ/jfYUV3TIxdiT1RBEH
         QVRH3d8CWChE75a3bFVCrpsroGuVJxChxJaQ4iLVp2QCsad8Sy9iIvHQIsjqPsRt6BBk
         42XWioInTqLnEisvaAFlxnht2EzJFBwL8/+NtLKFPsxB0WWE/hApxlv3jlNXZXz1tkB1
         PQ317xV/8Huqa89EceaCpeTNnQTMyWqYAB0Dyzt4gvBXN4W0fINmR94Y1fVQOxjQGCdh
         UffQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRA4FcCPSc6UDhfiVfG9rGA2lXvogpiRBRuL6QTMXojfs11lLyFtuLgfAp+KI6W+zGxliDIOZieUQS@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7W2EzKfBbF/Ta4pIrLUkrhPdRJ7cwyGKIKk0IGhT+DRiGo24b
	to+iF4bQfLPWy5UCndUGAVFXoUwdjlWKaaZFZeYrqVBmEovNKgODdKu3
X-Gm-Gg: ASbGnctB11IWYDa9+yNFkEZBouwnG+9fa612csUHHnVWE9L2BuLo7WHXSu1Xlne51aD
	wa/toAzRuNPORYy/5oANFWM9p2EDZqruAXgkpsQBs/9g/EEolELkVKDKtsNPT+dwtohqJnjFDgu
	UZRHmnBE4EwiYKodMzzsubGXFiCJc0aaWxzvXdgKg2/F9VzwmKUilgOXBj22NI5+GdAOh8LSjJO
	AMx8wXgNfLGZwwTdaUO/jbgi2YDuDqZaar4YK+xh/uLUVUhyuUJ04PhJb6BiYdDEZIKsZMWWNGN
	gZHumRHPNxQcTfQU3x8G1XwYU6H0dRFKDCTeU6tU/HrWfuWGcx3dvhDMe3jgJPWtxF5gbTyDHgQ
	rJflCcHMSUU0x76Eo6kahcApuvQyxZx3d61G+AjRksEp3GQ9De1VLRoxsuviqmBX+GI/nOU9fdo
	ERLIDfAaHcusNP
X-Google-Smtp-Source: AGHT+IGj/aZ4dREFNGfXsKOVw/xQDfcBe5qfV06LY9YeLiL2xFcvZXfiVKVcLJWLZMfSJ7R2lbSN1Q==
X-Received: by 2002:a05:600c:458b:b0:45d:5c71:769d with SMTP id 5b1f17b1804b1-46fa9e9a2e5mr2597245e9.8.1759861461807;
        Tue, 07 Oct 2025 11:24:21 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9d6269asm3998165e9.15.2025.10.07.11.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 11:24:21 -0700 (PDT)
Date: Tue, 7 Oct 2025 19:23:27 +0100
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
Message-ID: <20251007192327.57f00588@pumpkin>
In-Reply-To: <CADUfDZp6TA_S72+JDJRmObJgmovPgit=-Zf+-oC+r0wUsyg9Jg@mail.gmail.com>
References: <20250926065235.13623-1-409411716@gms.tku.edu.tw>
	<20250926065556.14250-1-409411716@gms.tku.edu.tw>
	<CADUfDZruZWyrsjRCs_Y5gjsbfU7dz_ALGG61pQ8qCM7K2_DjmA@mail.gmail.com>
	<aNz/+xLDnc2mKsKo@wu-Pro-E500-G6-WS720T>
	<CADUfDZq4c3dRgWpevv3+29frvd6L8G9RRdoVFpFnyRsF3Eve1Q@mail.gmail.com>
	<20251005181803.0ba6aee4@pumpkin>
	<aOTPMGQbUBfgdX4u@wu-Pro-E500-G6-WS720T>
	<CADUfDZp6TA_S72+JDJRmObJgmovPgit=-Zf+-oC+r0wUsyg9Jg@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Oct 2025 07:57:16 -0700
Caleb Sander Mateos <csander@purestorage.com> wrote:

> On Tue, Oct 7, 2025 at 1:28=E2=80=AFAM Guan-Chun Wu <409411716@gms.tku.ed=
u.tw> wrote:
> >
> > On Sun, Oct 05, 2025 at 06:18:03PM +0100, David Laight wrote: =20
> > > On Wed, 1 Oct 2025 09:20:27 -0700
> > > Caleb Sander Mateos <csander@purestorage.com> wrote:
> > > =20
> > > > On Wed, Oct 1, 2025 at 3:18=E2=80=AFAM Guan-Chun Wu <409411716@gms.=
tku.edu.tw> wrote: =20
> > > > >
> > > > > On Fri, Sep 26, 2025 at 04:33:12PM -0700, Caleb Sander Mateos wro=
te: =20
> > > > > > On Thu, Sep 25, 2025 at 11:59=E2=80=AFPM Guan-Chun Wu <40941171=
6@gms.tku.edu.tw> wrote: =20
> > > > > > >
> > > > > > > From: Kuan-Wei Chiu <visitorckw@gmail.com>
> > > > > > >
> > > > > > > Replace the use of strchr() in base64_decode() with precomput=
ed reverse
> > > > > > > lookup tables for each variant. This avoids repeated string s=
cans and
> > > > > > > improves performance. Use -1 in the tables to mark invalid ch=
aracters.
> > > > > > >
> > > > > > > Decode:
> > > > > > >   64B   ~1530ns  ->  ~75ns    (~20.4x)
> > > > > > >   1KB  ~27726ns  -> ~1165ns   (~23.8x)
> > > > > > >
> > > > > > > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > > > > > > Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > > > > > > Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > > > > > > ---
> > > > > > >  lib/base64.c | 66 ++++++++++++++++++++++++++++++++++++++++++=
++++++----
> > > > > > >  1 file changed, 61 insertions(+), 5 deletions(-)
> > > > > > >
> > > > > > > diff --git a/lib/base64.c b/lib/base64.c
> > > > > > > index 1af557785..b20fdf168 100644
> > > > > > > --- a/lib/base64.c
> > > > > > > +++ b/lib/base64.c
> > > > > > > @@ -21,6 +21,63 @@ static const char base64_tables[][65] =3D {
> > > > > > >         [BASE64_IMAP] =3D "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefgh=
ijklmnopqrstuvwxyz0123456789+,",
> > > > > > >  };
> > > > > > >
> > > > > > > +static const s8 base64_rev_tables[][256] =3D {
...
> > > > > > Do we actually need 3 separate lookup tables? It looks like all=
 3
> > > > > > variants agree on the value of any characters they have in comm=
on. So
> > > > > > we could combine them into a single lookup table that would wor=
k for a
> > > > > > valid base64 string of any variant. The only downside I can see=
 is
> > > > > > that base64 strings which are invalid in some variants might no=
 longer
> > > > > > be rejected by base64_decode().
> > > > > > =20
> > > > >
> > > > > In addition to the approach David mentioned, maybe we can use a c=
ommon
> > > > > lookup table for A=E2=80=93Z, a=E2=80=93z, and 0=E2=80=939, and t=
hen handle the variant-specific
> > > > > symbols with a switch. =20
> > >
> > > It is certainly possible to generate the initialiser from a #define to
> > > avoid all the replicated source.
> > > =20
> > > > >
> > > > > For example:
> > > > >
> > > > > static const s8 base64_rev_common[256] =3D {
> > > > >     [0 ... 255] =3D -1,
> > > > >     ['A'] =3D 0, ['B'] =3D 1, /* ... */, ['Z'] =3D 25, =20
> > >
> > > If you assume ASCII (I doubt Linux runs on any EBCDIC systems) you
> > > can assume the characters are sequential and miss ['B'] =3D etc to
> > > reduce the the line lengths.
> > > (Even EBCDIC has A-I J-R S-Z and 0-9 as adjacent values)
> > > =20
> > > > >     ['a'] =3D 26, /* ... */, ['z'] =3D 51,
> > > > >     ['0'] =3D 52, /* ... */, ['9'] =3D 61,
> > > > > };
> > > > >
> > > > > static inline int base64_rev_lookup(u8 c, enum base64_variant var=
iant) {
> > > > >     s8 v =3D base64_rev_common[c];
> > > > >     if (v !=3D -1)
> > > > >         return v;
> > > > >
> > > > >     switch (variant) {
> > > > >     case BASE64_STD:
> > > > >         if (c =3D=3D '+') return 62;
> > > > >         if (c =3D=3D '/') return 63;
> > > > >         break;
> > > > >     case BASE64_IMAP:
> > > > >         if (c =3D=3D '+') return 62;
> > > > >         if (c =3D=3D ',') return 63;
> > > > >         break;
> > > > >     case BASE64_URLSAFE:
> > > > >         if (c =3D=3D '-') return 62;
> > > > >         if (c =3D=3D '_') return 63;
> > > > >         break;
> > > > >     }
> > > > >     return -1;
> > > > > }
> > > > >
> > > > > What do you think? =20
> > > >
> > > > That adds several branches in the hot loop, at least 2 of which are
> > > > unpredictable for valid base64 input of a given variant (v !=3D -1 =
as
> > > > well as the first c check in the applicable switch case). =20
> > >
> > > I'd certainly pass in the character values for 62 and 63 so they are
> > > determined well outside the inner loop.
> > > Possibly even going as far as #define BASE64_STD ('+' << 8 | '/').
> > > =20
> > > > That seems like it would hurt performance, no?
> > > > I think having 3 separate tables
> > > > would be preferable to making the hot loop more branchy. =20
> > >
> > > Depends how common you think 62 and 63 are...
> > > I guess 63 comes from 0xff bytes - so might be quite common.
> > >
> > > One thing I think you've missed is that the decode converts 4 charact=
ers
> > > into 24 bits - which then need carefully writing into the output buff=
er.
> > > There is no need to check whether each character is valid.
> > > After:
> > >       val_24 =3D t[b[0]] | t[b[1]] << 6 | t[b[2]] << 12 | t[b[3]] << =
18;
> > > val_24 will be negative iff one of b[0..3] is invalid.
> > > So you only need to check every 4 input characters, not for every one.
> > > That does require separate tables.
> > > (Or have a decoder that always maps "+-" to 62 and "/,_" to 63.)
> > >
> > >       David
> > > =20
> >
> > Thanks for the feedback.
> > For the next revision, we=E2=80=99ll use a single lookup table that map=
s both +
> > and - to 62, and /, _, and , to 63.
> > Does this approach sound good to everyone? =20
>=20
> Sounds fine to me. Perhaps worth pointing out that the decision to
> accept any base64 variant in the decoder would likely be permanent,
> since users may come to depend on it. But I don't see any issue with
> it as long as all the base64 variants agree on the values of their
> common symbols.

If an incompatible version comes along it'll need a different function
(or similar). But there is no point over-engineering it now.

	David


>=20
> Best,
> Caleb


