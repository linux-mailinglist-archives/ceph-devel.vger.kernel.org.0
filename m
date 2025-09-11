Return-Path: <ceph-devel+bounces-3584-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C85F0B53896
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Sep 2025 18:03:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CD161CC5494
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Sep 2025 16:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99C16352FF4;
	Thu, 11 Sep 2025 16:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="BubZYe3h"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CD632F747
	for <ceph-devel@vger.kernel.org>; Thu, 11 Sep 2025 16:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757606563; cv=none; b=ZIxe7P3w4ag4fZaiO9EX98p+MZVC8tSUYS2X+MM8qXmBGqeobztqZNGW+EPjs2ZI5rDMxRwMnRnxxwRo5RB049Ft6nNBLMl8BG4mgktjyXgaibMdXyqwg7uy3MmER1khlnlGuQzjz6Fjk2vNl7U/awNLgXh4/IAeJaxy6GlPWuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757606563; c=relaxed/simple;
	bh=br6EOEaEXU1W5/Rb/Lht5jWrh+9mdSaxvvkmi3rL+Gw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qf0WkUDXIbd8kg9ntkDlto5BMC17C95nn8qYyOQlztAVzeXKdC0O+nL+7ku2nejGedH/EdhqPFiVH0IpqszvrwtX5Yhyos+WzOrY6uGBnsybokSYoa6vVEc1POzbIyfumOgGldsj51GMZpKQstmh1s6Sr+SG4ZjIMTI+fEXB7uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=BubZYe3h; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-24b14d062acso1369005ad.1
        for <ceph-devel@vger.kernel.org>; Thu, 11 Sep 2025 09:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1757606561; x=1758211361; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6obS77W4gL8mbr6C+eeuSSKKzH7RwZdvT4ZIG8wkffg=;
        b=BubZYe3hKelZ7gW5zAwsslrfefs8LcKZXEtM++XFeYYrWKyk2TN8F79rxKK++iHRrY
         iMbt8/apuklxainSeioD3ABaz3JjE+mLfcALfgfU+s4zVqQx1KssSrwZj++Zim1P7xGm
         NjHdLPiKFTlbcxQeWKnWfJ5IWBaNUBsHmf0xIEnV5ww/ywkWSjoBc2Aqa1WR5UQvJioS
         2JbviwHvVkmCTTf0SzfKBBp5aCvhdOUIvoHthay5GbB/GQ+XVAN/F3CqynEM2TMSzVhI
         7mBQ4qN151KMxxP52cNLlVK7BkmVXCRWGJv1aKyWOLdxDqyGvMM4WMxKTX0KhW6FsNJP
         znmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757606561; x=1758211361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6obS77W4gL8mbr6C+eeuSSKKzH7RwZdvT4ZIG8wkffg=;
        b=ICi2CJ0PnkdgZVpztRjzngHhLWER0UUfD7zXxcu+hWwAVCzhHZA61PcxXEaEv4Jh6e
         pAf6EXOJKDgdtxSqRlLLtMLVKmJ6ZIBtm8XMvwEnfCSRXUYVo36wUKLT7rCIC7ws89cC
         Yj6uzrEZ/nWvQi480IkzaG+dwLuixYK1x9aPga/f2/ZySHbVSGpbVT3la9G7rIL2xnGU
         KwD53xJsZUQHA9uPTVrtfiGfICKmDoWrjg9Y86NN2equmtAxm1NU5AaTNSociAiS+b+q
         gxgyIOOQvuZJvnG8n5mk2gLE42bdvdxJDwHv6EmHaBhbnrvU+f5NPex5640NeN6l3reQ
         V/nw==
X-Forwarded-Encrypted: i=1; AJvYcCUxSAFG5tOwwXCoL+KB5SIClzULni11jewD2NSQplqgDbLrbLjQVqn5YeT1XPuRwtvU3W9ZiH/4a4WJ@vger.kernel.org
X-Gm-Message-State: AOJu0YzJbS79C4kp8jZ1pIa5M1KCpTWaQV0qRUxQfZyUuejUK1umWcom
	m3vrLwpHrinWoK5+rK5enCg2JiEekHWX1fvI3wW0n1Al8ip9BvQaYqv787ZADCXHnTWqg0nc7QG
	L/I51Vs66wHalTtiKVcvuZmgn1d3D6DJqsd8njrkYUhyCElUzlpXvV3Wf4Q==
X-Gm-Gg: ASbGncv1LyeSbOxS9IhGgIEZDqWZmZ2gFL+qDQnxRnAkTBeuiy8qK/k1fe4zNUKp/FN
	6z/Lz5NO7q7Ok3WFjv82EJEahY3zCr1VkgMR8Teii8RJXfDxpN2PrDzJ4RxHHZ4tL2Lt1NUyIMX
	KqSvJn4QH5r4bdzB0OCC6EF4yIPX0WhzWS66DP5yY7r21o3GsMivy4B5Eqh8/aB92tsflJt378r
	Wscr8noIp2U3hwRQRye0xPjNP4JXyDIRMf2u/F9NhUU/YAsMQ==
X-Google-Smtp-Source: AGHT+IFBr1IxqXcIUO6bB0xT/+wQnm8xy0aPESUSNVEBROoDUbw28I831Lcf+8PW91sQeC1Tp7s6n5Wn1luV5rDxNOA=
X-Received: by 2002:a17:902:f708:b0:25c:8005:3f04 with SMTP id
 d9443c01a7336-25d217ec277mr163925ad.0.1757606559660; Thu, 11 Sep 2025
 09:02:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
 <20250911073204.574742-1-409411716@gms.tku.edu.tw> <CADUfDZqe2x+xaqs6M_BZm3nR=Ahu-quKbFNmKCv2QFb39qAYXg@mail.gmail.com>
In-Reply-To: <CADUfDZqe2x+xaqs6M_BZm3nR=Ahu-quKbFNmKCv2QFb39qAYXg@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 11 Sep 2025 09:02:26 -0700
X-Gm-Features: Ac12FXzfe0LPetqhsRB28hxh2v9SigeWVoVMRD9W7aqYfRcyJIKVJDep7LH3j1c
Message-ID: <CADUfDZo43a2w64umSCeqJyHrsujh2jHFTQADC5kGuX+d27RnVw@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] lib/base64: Replace strchr() for better performance
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org, 
	ebiggers@kernel.org, hch@lst.de, home7438072@gmail.com, idryomov@gmail.com, 
	jaegeuk@kernel.org, kbusch@kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com, xiubli@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2025 at 8:50=E2=80=AFAM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Thu, Sep 11, 2025 at 12:33=E2=80=AFAM Guan-Chun Wu <409411716@gms.tku.=
edu.tw> wrote:
> >
> > From: Kuan-Wei Chiu <visitorckw@gmail.com>
> >
> > The base64 decoder previously relied on strchr() to locate each
> > character in the base64 table. In the worst case, this requires
> > scanning all 64 entries, and even with bitwise tricks or word-sized
> > comparisons, still needs up to 8 checks.
> >
> > Introduce a small helper function that maps input characters directly
> > to their position in the base64 table. This reduces the maximum number
> > of comparisons to 5, improving decoding efficiency while keeping the
> > logic straightforward.
> >
> > Benchmarks on x86_64 (Intel Core i7-10700 @ 2.90GHz, averaged
> > over 1000 runs, tested with KUnit):
> >
> > Decode:
> >  - 64B input: avg ~1530ns -> ~126ns (~12x faster)
> >  - 1KB input: avg ~27726ns -> ~2003ns (~14x faster)
> >
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > ---
> >  lib/base64.c | 17 ++++++++++++++++-
> >  1 file changed, 16 insertions(+), 1 deletion(-)
> >
> > diff --git a/lib/base64.c b/lib/base64.c
> > index b736a7a43..9416bded2 100644
> > --- a/lib/base64.c
> > +++ b/lib/base64.c
> > @@ -18,6 +18,21 @@
> >  static const char base64_table[65] =3D
> >         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789=
+/";
>
> Does base64_table still need to be NUL-terminated?
>
> >
> > +static inline const char *find_chr(const char *base64_table, char ch)
>
> Don't see a need to pass in base64_table, the function could just
> access the global variable directly.

Never mind, I see the following patches pass in different base64_table valu=
es.

