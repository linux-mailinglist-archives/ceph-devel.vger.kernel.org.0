Return-Path: <ceph-devel+bounces-3772-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73B7BBAFFA7
	for <lists+ceph-devel@lfdr.de>; Wed, 01 Oct 2025 12:18:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A5253B21AF
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Oct 2025 10:18:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0243529992A;
	Wed,  1 Oct 2025 10:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="zcfH2aon"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3E0299A81
	for <ceph-devel@vger.kernel.org>; Wed,  1 Oct 2025 10:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759313925; cv=none; b=D49Y7T2CtsQ1aYDLb+reoVydyLDimQwckTM6fj9A4YNWd4H2xdEW8ZDIUTOQosYLoZHjUVTiMnWZ71TGTVQJ2GOw1j1dkrEso4DyMc3fTV3NduLoQ+xylY3x56nXqoUJHOK1DO2uzGmfAxbRNurSPVmLOCKE4aq8yUUXzYDr0Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759313925; c=relaxed/simple;
	bh=2jldrv1cxNT7hzEfL36BPqU35TGryZTltmK0m7lz1ck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UVaixjNoL3vu0j3zrfJIKUYlFUz5tk5MvnmE8OzZh5We1OC0AT7bWjimN2GDrEoZVE5sxuMxN7ghjmpzRP7dQxZ6fL6wx5/b4dc0KjTiIOPu1X2gch9djL73rjm9V3qoM+XaYe11ALSAUQdZmNHyYdrVj7rYhr5C0SucO7W5SWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=zcfH2aon; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3352018dfbcso5734691a91.0
        for <ceph-devel@vger.kernel.org>; Wed, 01 Oct 2025 03:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1759313921; x=1759918721; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oN9puFkb46cQNIS5IreI+mnmbbovgsA4IsgTPeMWaYs=;
        b=zcfH2aongeFYFzovTKgoSYdoB9MQcMIqBCKAIc9pSJM1X7mELsP4QWpu0MzubfzChS
         42dCvqgwg7A6eqE+MdSzBLWDYUZjjezXZKSeeAl4oN9yW5pXTHJ3m8sC3Gf3eHRwXVGK
         BkPD1CJ2can9SZAL6u3IZPDwh3m8W3Rcv1PjfrEV6of8XejwwZigRVDCJJdMm/FSJ9Ks
         XFKMoH2er0E9bWDsfBMUwNOfVRwJBMPVFFDZPE7uOoYBhBQ7zSGwtjFSTs6g4Ynf99TW
         jDa2wOGTK7AFkGm6QwiRAepn8H/WFCdhwSbICB9M5hO+xflPfQnsut9B5TkmZXJeyjiu
         v+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759313921; x=1759918721;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oN9puFkb46cQNIS5IreI+mnmbbovgsA4IsgTPeMWaYs=;
        b=Dnz1/BwDyn4XEdz1hWoAFpQRx3jtz7D2cRp8s+wZ9AgkVMLcJK08FETumfYcHLiyrc
         46rkJ8H5U6JI65m1tJYzIMVs+hQGB2ucnyyHv9pYvoJKv4rGwBQpn0dYh1RvvzT+luEV
         TdVwv4pfU5wcMdLN4jAdmLj6PHidy+zohcz0t+mPztxnhT0TOLEOQb8yRkf7g3yxT46m
         eBwZXDuyKpfFEiudIvcarF7P8F8BVnWr4J0Gd2WSDITLHClNJu4KPV2BPPcv5/P0Wu6Y
         crUXBXmZqjzg7YedWAIQA6ZDdfcGjaynvkNAAJeQXd7Y6wMYKB5w7LGQUq+ci7LeVnFX
         vgTg==
X-Forwarded-Encrypted: i=1; AJvYcCXEjX8b6ENTy8bmnLCvwxBuST7+kfb39j8kMcm5QYfO3I0GQhgRL1zgednKR0WMoZxzy3H51T7EJGu1@vger.kernel.org
X-Gm-Message-State: AOJu0YwzK/7DvKIUKVeeh4MhXHY8ToTtR23cx8+KHcEPGx54EM6dbTEO
	t0RkJcrDON3TOAnxedSRviyfbB3HifBhHwzn5sdB+SfB+KmUSxjuvPRMjp9RPKAPma0=
X-Gm-Gg: ASbGncuTBxxz5MWyZOJ6DdufjOwdompri3nuVJRV5f/J90Ya1IRAhRJ0w8bNj6dB4sD
	IF+Q4YVrVU0PAXXCpzNL0zaZfrOYyRac1dgjW6SlSX2hpPsfOO1/2bZwppmnhCz7RevAq8s9fob
	WRL8YSuxK+SQaRE3e0ZT1myTW7vGLBI/kRHahC3n/G5jFo/m9fGQEW6J8yL73XDmzkt69qzCoNh
	hNSAl9ss+gg0+QFDhzqNnxnZSQfX24ImdLIk9FMNhmOUHTBVJE7uW9TkBzzUgXnwYyv9x1C8h++
	HIo/mSQJyCBgjPk5otEe6MIu1KAuT1pa2o9jRKuXQvJJNtbSBayofnVp2/iNDBgQ3xJkf5/qUwg
	HT7KxX/yg2GdZbbgXgrrPXSNKVyJjHAyYXj+3Q3B1FKcxHd/ivx/mRvnaa8tWFak1xtat
X-Google-Smtp-Source: AGHT+IFs4kOlgU8X0QG7s3rpttQScpOUbtBqzYPxpTiDMADf9+c+J2mflBuEXTDwUDvWGGyPG/XFLw==
X-Received: by 2002:a17:90b:1652:b0:32a:e706:b7b6 with SMTP id 98e67ed59e1d1-339a6e75590mr2927307a91.11.1759313921134;
        Wed, 01 Oct 2025 03:18:41 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T ([2001:288:7001:2703:6af7:94e4:3a78:e342])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-339a6f20ebbsm1965811a91.24.2025.10.01.03.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 03:18:39 -0700 (PDT)
Date: Wed, 1 Oct 2025 18:18:35 +0800
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org,
	ebiggers@kernel.org, hch@lst.de, home7438072@gmail.com,
	idryomov@gmail.com, jaegeuk@kernel.org, kbusch@kernel.org,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, sagi@grimberg.me, tytso@mit.edu,
	visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v3 2/6] lib/base64: Optimize base64_decode() with reverse
 lookup tables
Message-ID: <aNz/+xLDnc2mKsKo@wu-Pro-E500-G6-WS720T>
References: <20250926065235.13623-1-409411716@gms.tku.edu.tw>
 <20250926065556.14250-1-409411716@gms.tku.edu.tw>
 <CADUfDZruZWyrsjRCs_Y5gjsbfU7dz_ALGG61pQ8qCM7K2_DjmA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZruZWyrsjRCs_Y5gjsbfU7dz_ALGG61pQ8qCM7K2_DjmA@mail.gmail.com>

On Fri, Sep 26, 2025 at 04:33:12PM -0700, Caleb Sander Mateos wrote:
> On Thu, Sep 25, 2025 at 11:59 PM Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:
> >
> > From: Kuan-Wei Chiu <visitorckw@gmail.com>
> >
> > Replace the use of strchr() in base64_decode() with precomputed reverse
> > lookup tables for each variant. This avoids repeated string scans and
> > improves performance. Use -1 in the tables to mark invalid characters.
> >
> > Decode:
> >   64B   ~1530ns  ->  ~75ns    (~20.4x)
> >   1KB  ~27726ns  -> ~1165ns   (~23.8x)
> >
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > ---
> >  lib/base64.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 61 insertions(+), 5 deletions(-)
> >
> > diff --git a/lib/base64.c b/lib/base64.c
> > index 1af557785..b20fdf168 100644
> > --- a/lib/base64.c
> > +++ b/lib/base64.c
> > @@ -21,6 +21,63 @@ static const char base64_tables[][65] = {
> >         [BASE64_IMAP] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,",
> >  };
> >
> > +static const s8 base64_rev_tables[][256] = {
> > +       [BASE64_STD] = {
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  -1,  -1,  -1,  63,
> > +        52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,
> > +        15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,
> > +        41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +       },
> > +       [BASE64_URLSAFE] = {
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  -1,  -1,
> > +        52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,
> > +        15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1,  -1,  -1,  63,
> > +        -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,
> > +        41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +       },
> > +       [BASE64_IMAP] = {
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  63,  -1,  -1,  -1,
> > +        52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,
> > +        15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,
> > +        41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +       },
> 
> Do we actually need 3 separate lookup tables? It looks like all 3
> variants agree on the value of any characters they have in common. So
> we could combine them into a single lookup table that would work for a
> valid base64 string of any variant. The only downside I can see is
> that base64 strings which are invalid in some variants might no longer
> be rejected by base64_decode().
>

In addition to the approach David mentioned, maybe we can use a common
lookup table for A–Z, a–z, and 0–9, and then handle the variant-specific
symbols with a switch.

For example:

static const s8 base64_rev_common[256] = {
    [0 ... 255] = -1,
    ['A'] = 0, ['B'] = 1, /* ... */, ['Z'] = 25,
    ['a'] = 26, /* ... */, ['z'] = 51,
    ['0'] = 52, /* ... */, ['9'] = 61,
};

static inline int base64_rev_lookup(u8 c, enum base64_variant variant) {
    s8 v = base64_rev_common[c];
    if (v != -1)
        return v;

    switch (variant) {
    case BASE64_STD:
        if (c == '+') return 62;
        if (c == '/') return 63;
        break;
    case BASE64_IMAP:
    	if (c == '+') return 62;
        if (c == ',') return 63;
        break;
    case BASE64_URLSAFE:
        if (c == '-') return 62;
        if (c == '_') return 63;
	break;
    }
    return -1;
}

What do you think?

Best regards,
Guan-Chun

> > +};
> > +
> >  /**
> >   * base64_encode() - Base64-encode some binary data
> >   * @src: the binary data to encode
> > @@ -82,11 +139,9 @@ int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base6
> >         int bits = 0;
> >         int i;
> >         u8 *bp = dst;
> > -       const char *base64_table = base64_tables[variant];
> > +       s8 ch;
> >
> >         for (i = 0; i < srclen; i++) {
> > -               const char *p = strchr(base64_table, src[i]);
> > -
> >                 if (src[i] == '=') {
> >                         ac = (ac << 6);
> >                         bits += 6;
> > @@ -94,9 +149,10 @@ int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base6
> >                                 bits -= 8;
> >                         continue;
> >                 }
> > -               if (p == NULL || src[i] == 0)
> > +               ch = base64_rev_tables[variant][(u8)src[i]];
> > +               if (ch == -1)
> 
> Checking for < 0 can save an additional comparison here.
> 
> Best,
> Caleb
> 
> >                         return -1;
> > -               ac = (ac << 6) | (p - base64_table);
> > +               ac = (ac << 6) | ch;
> >                 bits += 6;
> >                 if (bits >= 8) {
> >                         bits -= 8;
> > --
> > 2.34.1
> >
> >

