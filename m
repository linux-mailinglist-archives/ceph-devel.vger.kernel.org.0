Return-Path: <ceph-devel+bounces-3982-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4961FC492A1
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Nov 2025 21:00:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBD80188E082
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Nov 2025 20:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CA9D33F37B;
	Mon, 10 Nov 2025 20:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HSyY5wen";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="D8h3qk/y"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE70E3328F8
	for <ceph-devel@vger.kernel.org>; Mon, 10 Nov 2025 20:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762804823; cv=none; b=RLr8FjBf6lf+yC69uRtq3hZs8p4rBElbnBzR/xYxqfWvedugDuH/g4NqTkAlP54iI6Wn39E4WBQHA7lEioFd9cLfM2tzOsJccf8rpp34sp4TNyNCxptoHjqE2Pvj3mn1MulSfeq1Cix5AJnG5KTnK9nC1btg6LucB0mE0DN64QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762804823; c=relaxed/simple;
	bh=zcdFR4zEaHAMDLPFj+HUILSwXKAEiJgNobQnWMf90EE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aaR7huZiX/BtbPUaqHY2/qC6b0+WpV1X+b1SeW5bmNabNjDzrWHyE3QlYtpGhReaIpiX3ufnGeHd4Q+fSWzfZbU4waNJ+v+NxPNND3NSDlnpYQ066xPXxrGdh/yAzmn4eF+qlzUS4neXOyIdXm95hANVUvzd4ie1lbZxknR53Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HSyY5wen; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=D8h3qk/y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762804820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LPlXcM2TXZ28oMJMDNj38NBq4Bia9yji9rEj+Y+MXL0=;
	b=HSyY5wenAfljeVtE6i8lJ1FZd/MfivJkwDipDnXx/52/7nWDSZZuJ7N0ciQHhr686v/9Sq
	i7n7DevMs2OFSzSpgSftVaNlnL/reVTKmhqYDFVnaJC0UpcPqReX/YOFrbYH/rc8MQeIgA
	0SCA4nd6ZXSRhMjB2syM0CyTR5Tlxj0=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-550-Nlgzww6kOX2l5Y6-n6di6w-1; Mon, 10 Nov 2025 15:00:19 -0500
X-MC-Unique: Nlgzww6kOX2l5Y6-n6di6w-1
X-Mimecast-MFC-AGG-ID: Nlgzww6kOX2l5Y6-n6di6w_1762804818
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-33da1f30fdfso8192689a91.3
        for <ceph-devel@vger.kernel.org>; Mon, 10 Nov 2025 12:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762804818; x=1763409618; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LPlXcM2TXZ28oMJMDNj38NBq4Bia9yji9rEj+Y+MXL0=;
        b=D8h3qk/y9J+N2L/5B89vKpmLZTMMb9Sd+ypiKRHXUQcHfLZFP2l6bne76vf1ffoox6
         rEKYGxHJf6GIhyG62xWoCbpvKUT8oAY6Tby/qvr1cztpXc7C1uOI1WqYRYFFL+R6d2hg
         DWWPs2r59I4jexJFsL+iPWAtvsTMk3q9qdx3prlhZkxbsr7jODmCypCv51Q9eXg0uNJY
         mnfNZIiiNrddn7ZW5YvpD59oeNq4I13LahwyNdmbvGdroGa6ucH/CmtmvuyCEKK/x+CQ
         awKyocwSm0X2u1aFIBkksCUqCd1SFMqx+9EkA5s41wCPquBBqsWHV8w+aa4NX13MmYR7
         UpPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762804818; x=1763409618;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LPlXcM2TXZ28oMJMDNj38NBq4Bia9yji9rEj+Y+MXL0=;
        b=XIXugmlsSQ5qo/dEzolSFYfcKj5+oGPnIDUWPqo2Ziov8DhMaTL1A+CWwfTk9oKVz+
         jOSQpPxWaxAg3C+gTGPGMQdQ7QsWAwC806Vw7HzAtReJXrsDIm+o4qOLlICMl6zhydOP
         mXbzf2tAzsLhGF95PZKdCLvC4gcntBmzip1mg5ywy1sYbmAAfwTfHmgPuTJfms/kqKFT
         XoQsM7YPzw/7xMMaOJRyYbN4qFyGhveAt7Rmx1G2EOLbGSGheIualAmzT44C+mc8eAGI
         5NcZnYCHA6tZuiHeoFMELtpQ1sHHKV8w6rf9J/eVwcYp5nDwHvOFaonwub5s9kRfI2kD
         PGXg==
X-Forwarded-Encrypted: i=1; AJvYcCUNJ9qL74SQxZeBN+0NvbAG6O3q7JplOMg5Gw9ccyBivSrLyR6vVwk7hvtMjHnpBuBdh0OoPP84Itnc@vger.kernel.org
X-Gm-Message-State: AOJu0YzuoOcDIMLwMmvahR2oIx4TTOoBzJE6jeNhojX8ZcodWTtCenRt
	qtWApGUTrC8sUArZyMwZmGX7kdO2fqV4bljC9Q0RjZrzCulchjZQJlw8BCCavU6E6On734FJjuR
	epzbN+kBILYV2/Ets0WwYSpeOaqkTEOfwUh572SYHlUWIBc4kb2Fj1ib/6D8DTcf9zpr5F8BkXN
	skPKnKaBvf1LF2lL6tnsyav4kSoOfaspa/tKt0ag==
X-Gm-Gg: ASbGncs+wtm7YuTDC2Ha3BEA1kDxjrXv0i+XiFEN7FMe+whA8J+ydhEJpUJF/JC+gxa
	gKXMu/qjptwILrPFeDU4C8/peEXiIxwSTjfE1WOiWLT5C7m665FxDvuJ++v4Mz/37plYtD7n5tj
	3pa2gS+PAI+RZOCODe0sUw/FvPHO2MfrWOJBXTVAPbkgcNHmd/JhzOhSg=
X-Received: by 2002:a17:90b:35c6:b0:340:dd2c:a3f5 with SMTP id 98e67ed59e1d1-3436cb22be6mr10884386a91.3.1762804818124;
        Mon, 10 Nov 2025 12:00:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEb+bxxFY9OWpl3OFV8BnoluTx7SV2gRJxCLgMj57gkggbCR2gb9gdx/qVop9Ke2skamLq294H1NixnZqF8zVQ=
X-Received: by 2002:a17:90b:35c6:b0:340:dd2c:a3f5 with SMTP id
 98e67ed59e1d1-3436cb22be6mr10884348a91.3.1762804817633; Mon, 10 Nov 2025
 12:00:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251110144404.369928-1-andriy.shevchenko@linux.intel.com>
 <9f7339a71c281e9f9e5b1ff34f7c277f62c89a69.camel@ibm.com> <CAJ4mKGYPoxPS62yFigmqFPPTHOSwgtj+WKwEtdpNGsu3BJya3w@mail.gmail.com>
 <01593a9ca971421a39c483819855d41c251da905.camel@ibm.com>
In-Reply-To: <01593a9ca971421a39c483819855d41c251da905.camel@ibm.com>
From: Gregory Farnum <gfarnum@redhat.com>
Date: Mon, 10 Nov 2025 12:00:06 -0800
X-Gm-Features: AWmQ_bkLhINwAMY_PPv_LXya3jPoLyDARUiNgeAe2clS2vVBulPodTBPVrixOB4
Message-ID: <CAJ4mKGbrXjC=kX5YDsX=RZUw6mK0PVPiinVsujhp+XfPVsrVVg@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] ceph: Amend checking to fix `make W=1` build breakage
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Xiubo Li <xiubli@redhat.com>, "justinstitt@google.com" <justinstitt@google.com>, 
	"andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>, 
	"llvm@lists.linux.dev" <llvm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nathan@kernel.org" <nathan@kernel.org>, 
	"morbo@google.com" <morbo@google.com>, "idryomov@gmail.com" <idryomov@gmail.com>, 
	"nick.desaulniers+lkml@gmail.com" <nick.desaulniers+lkml@gmail.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 11:57=E2=80=AFAM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Mon, 2025-11-10 at 11:48 -0800, Gregory Farnum wrote:
> > On Mon, Nov 10, 2025 at 11:42=E2=80=AFAM Viacheslav Dubeyko
> > <Slava.Dubeyko@ibm.com> wrote:
> > >
> > > On Mon, 2025-11-10 at 15:44 +0100, Andy Shevchenko wrote:
> > > > In a few cases the code compares 32-bit value to a SIZE_MAX derived
> > > > constant which is much higher than that value on 64-bit platforms,
> > > > Clang, in particular, is not happy about this
> > > >
> > > > fs/ceph/snap.c:377:10: error: result of comparison of constant 2305=
843009213693948 with expression of type 'u32' (aka 'unsigned int') is alway=
s false [-Werror,-Wtautological-constant-out-of-range-compare]
> > > >   377 |         if (num > (SIZE_MAX - sizeof(*snapc)) / sizeof(u64)=
)
> > > >       |             ~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > >
> > > > Fix this by casting to size_t. Note, that possible replacement of S=
IZE_MAX
> > > > by U32_MAX may lead to the behaviour changes on the corner cases.
> > > >
> > > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > > ---
> > > >  fs/ceph/snap.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > > > index c65f2b202b2b..521507ea8260 100644
> > > > --- a/fs/ceph/snap.c
> > > > +++ b/fs/ceph/snap.c
> > > > @@ -374,7 +374,7 @@ static int build_snap_context(struct ceph_mds_c=
lient *mdsc,
> > > >
> > > >       /* alloc new snap context */
> > > >       err =3D -ENOMEM;
> > > > -     if (num > (SIZE_MAX - sizeof(*snapc)) / sizeof(u64))
> > > > +     if ((size_t)num > (SIZE_MAX - sizeof(*snapc)) / sizeof(u64))
> > >
> > > The same question is here. Does it makes sense to declare num as size=
_t? Could
> > > it be more clean solution? Or could it introduce another warnings/err=
ors?
> >
> > Given that the number of snaps is constrained over the wire as a
> > 32-bit integer, you probably want to keep that mapping...(Though I
> > guess it's the sum of two 32-bit integers which technically could
> > overflow, and I'm not sure what happens if you actually hit those
> > boundaries on the server =E2=80=94 but nobody generates snapshots on th=
e same
> > file in that quantity).
> >
> > All that said, it'd be kind of nice if we could just annotate for
> > clang that we are perfectly happy for the evaluation to always be true
> > on a 64-bit architecture (as snapids are 64 bits, we will always be
> > able to count them).
>
> So, are you suggesting to declare num as u64 here? Am I correct?

What? No, the whole point of this block is checking that it can track
all the snapshots and allocate them (on a <32-bit architecture, which
are the only ones at risk), isn't it?


