Return-Path: <ceph-devel+bounces-3598-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 507F8B543A0
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Sep 2025 09:15:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0552E3B5BBE
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Sep 2025 07:15:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B59A6215198;
	Fri, 12 Sep 2025 07:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="eCUyLUXY"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446F62BCF75
	for <ceph-devel@vger.kernel.org>; Fri, 12 Sep 2025 07:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757661330; cv=none; b=V4VZ0zOCH+u9yvkijRE8OboP4xnnqjeHzfzuH68JSgEwWkwoEic+w+gNMw6aL0m2oqmLApthgtqFBsTSoRmeM4+sbRo8miUKOJnMef1uk1LzWw9wK5O1BrLp0B1prYQ1tcOhea39UL7dNbjRTAr7FwTqPgyXFano7y8//UqUhLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757661330; c=relaxed/simple;
	bh=RRSculGpvqYieaZvwch2pN7GoLC1vvt6UwykLluhkOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VXdSRVcFl4cMefjdvIkYcdY2EKcFyywKz8tZwA9L2sY+YdD/bhgVPLFsoxlFOxAq4j2xC61kJjOgyaYIPOexNjRrRLAUcNgi0wXgaAdRJnOclQy55LetZnBZ6uWqZwRh2OVvhie5mUcp3IHA81AJqc/BtUxRlhpYavO76dZyAAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=eCUyLUXY; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b4d4881897cso992130a12.0
        for <ceph-devel@vger.kernel.org>; Fri, 12 Sep 2025 00:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1757661327; x=1758266127; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AW7tsP6xOhY4n2HUUy8zRpS39bN8hH1JOudjtFI/rVM=;
        b=eCUyLUXYn99m98fTpSqyviPYY7YceVpTT6pJQjfChTCzYZ73oHwMcUTC+5g1uxxq3J
         mn75ZqsAhN5cI7yszfB2OQMH0DlCvA9YAXGobDxw18m+clGQq1KAp+Pjem8bNZf3LmSV
         n9WNybByS07jTCT1gN8lB9hgEwqx3q3MvSyKiE/mCHb9ZkC8bQogXgXDUuALNoo0FtZt
         BUV5k3zqCinWLor31/YjaloFwAWlBJ5VXe6kH0kZ9d1pm6PePQKQe2j1lRpymXjEO76/
         FnfxE17scqnSJD8gpTnIJhJLvQ2F4siQsvQX6brhvyoD35QsuNxfwZRSfvILjm93LAX6
         SzqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757661327; x=1758266127;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AW7tsP6xOhY4n2HUUy8zRpS39bN8hH1JOudjtFI/rVM=;
        b=oKEuUqX+Wwr0KSurwJ0wZZ4ruhJgqeZ6I8e8wnpIzk9zBRZaWap71U0HreRDBUC4GG
         YdXx1gZ24ey9scpKMgT4k0CDBsvLzD0Uxd7ou+TF74YEMaYfeXkpG/MWPsn6xiP5w/Y0
         2loaP4/VOpgTdP/hZtmetMqM0V1MiUkmYp2n5140Zf3JQZfzU41zmNmoNahkgX4NUofe
         +pCOn8v4D7BDndn2ZHWwqZjb05xByvHXozSAJBON7cliOSGssL9si0Ir0ZvbaVHvrXBL
         pULvInuUNNzECmdpdM/aRB9o8dN1tbpYNDtZ+s10abQ8/fn4ZvcFrx1l19mQs/ESP313
         tcMg==
X-Forwarded-Encrypted: i=1; AJvYcCWflFXBRIdizATI5vkdzVrdqwAHbyJBhmfphZcCvoV0BTRTWX10cGCfE8ZqM8T825SjiCwglS5QX8lC@vger.kernel.org
X-Gm-Message-State: AOJu0YyCqJdnolJq9tv96vaVwd/XmU42fag1QlbU7nAVScmleoIXciaZ
	mR753HN/Jr92ls1/HbWJie82pVbj/lvCJmrUMKWyDMvPRQ0AQIllgj5pYc9rcB2LgNo=
X-Gm-Gg: ASbGnctG69VS6lbO6/mTHH6d73Fkeby6E/HH98bczCltYlHIaaDueZj0oMNdhPnHy6X
	J3ivpW9dEvzIcfH2yqqbeAiWO+RA7pypihoUa9wQeiPzhkVyFLPXAMezoREdnXbXOu90avZJ9wm
	1QqO/RFgsrXnKgMVxPaBpp9Ncdw/ikp5hKEuYpDU4kZYwPEr8j55DXFH761gDPN5QX3mUUNcOJI
	9fLvUgN7T5dP4OVQK4EAHRg/raz0K6G53WHOhe/G4q4dsGKoOVq/yNjSvvrF8iZdvZwtJqYYmov
	n/XH4NdIbRqSpPoJe53Urx49brqcvT17aLieOgJmtvzAekVWWeVsmuwrxiUD21YG4fDO5TZjc/r
	UUIaB1Iz9v2wlkggckcqnpxTmYZnAkzgVtoqFUbSoQhdi
X-Google-Smtp-Source: AGHT+IFW30ssn2TairJ8HtopqhokGY4ajOoSTmmyCvBDKvXwFswORwAcYfMn/Bm/7xA9nsncRM3K+A==
X-Received: by 2002:a17:902:fc4b:b0:24a:a2c5:a0a1 with SMTP id d9443c01a7336-25d248c9a0fmr24778485ad.21.1757661327374;
        Fri, 12 Sep 2025 00:15:27 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T ([2001:288:7001:2703:9e14:1074:637d:9ff6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c36cc6b06sm39911365ad.17.2025.09.12.00.15.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 00:15:26 -0700 (PDT)
Date: Fri, 12 Sep 2025 15:15:21 +0800
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: Eric Biggers <ebiggers@kernel.org>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org,
	hch@lst.de, home7438072@gmail.com, idryomov@gmail.com,
	jaegeuk@kernel.org, kbusch@kernel.org,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, sagi@grimberg.me, tytso@mit.edu,
	visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v2 2/5] lib/base64: rework encoder/decoder with
 customizable support and update nvme-auth
Message-ID: <aMPIiXe3baF2gDnQ@wu-Pro-E500-G6-WS720T>
References: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
 <20250911074159.656943-1-409411716@gms.tku.edu.tw>
 <20250911182742.GC1376@sol>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250911182742.GC1376@sol>

On Thu, Sep 11, 2025 at 11:27:42AM -0700, Eric Biggers wrote:
> On Thu, Sep 11, 2025 at 03:41:59PM +0800, Guan-Chun Wu wrote:
> > Rework base64_encode() and base64_decode() with extended interfaces
> > that support custom 64-character tables and optional '=' padding.
> > This makes them flexible enough to cover both standard RFC4648 Base64
> > and non-standard variants such as base64url.
> 
> RFC4648 specifies both base64 and base64url.
>

Got it, I'll update the commit message in the next version.

> > The encoder is redesigned to process input in 3-byte blocks, each
> > mapped directly into 4 output symbols. Base64 naturally encodes
> > 24 bits of input as four 6-bit values, so operating on aligned
> > 3-byte chunks matches the algorithm's structure. This block-based
> > approach eliminates the need for bit-by-bit streaming, reduces shifts,
> > masks, and loop iterations, and removes data-dependent branches from
> > the main loop.
> 
> There already weren't any data-dependent branches in the encoder.
> 

Got it, I'll update the commit message in the next version.

> > The decoder replaces strchr()-based lookups with direct table-indexed
> > mapping. It processes input in 4-character groups and supports both
> > padded and non-padded forms. Validation has been strengthened: illegal
> > characters and misplaced '=' padding now cause errors, preventing
> > silent data corruption.
> 
> The decoder already detected invalid inputs.
> 

You're right, the decoder already rejected invalid inputs.
What has been strengthened in the new version is the padding handling 
(length must be a multiple of 4, and = only allowed in the last two positions).

> > While this is a mechanical update following the lib/base64 rework,
> > nvme-auth also benefits from the performance improvements in the new
> > encoder/decoder, achieving faster encode/decode without altering the
> > output format.
> > 
> > The reworked encoder and decoder unify Base64 handling across the kernel
> > with higher performance, stricter correctness, and flexibility to support
> > subsystem-specific variants.
> 
> Which part is more strictly correct?
> 

The stricter correctness here refers to the decoder, specifically the padding
checks (length must be a multiple of 4, and = only allowed in the last two positions).

> > diff --git a/lib/base64.c b/lib/base64.c
> > index 9416bded2..b2bd5dab5 100644
> > --- a/lib/base64.c
> > +++ b/lib/base64.c
> > @@ -15,104 +15,236 @@
> >  #include <linux/string.h>
> >  #include <linux/base64.h>
> >  
> > -static const char base64_table[65] =
> > -	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
> > +#define BASE64_6BIT_MASK      0x3f /* Mask to extract lowest 6 bits */
> > +#define BASE64_BITS_PER_BYTE  8
> > +#define BASE64_CHUNK_BITS     6
> > +
> > +/* Output-char-indexed shifts: for output chars 0,1,2,3 respectively */
> > +#define BASE64_SHIFT_OUT0	(BASE64_CHUNK_BITS * 3) /* 18 */
> > +#define BASE64_SHIFT_OUT1	(BASE64_CHUNK_BITS * 2) /* 12 */
> > +#define BASE64_SHIFT_OUT2	(BASE64_CHUNK_BITS * 1) /* 6  */
> > +/* OUT3 uses 0 shift and just masks with BASE64_6BIT_MASK */
> > +
> > +/* For extracting bytes from the 24-bit value (decode main loop) */
> > +#define BASE64_SHIFT_BYTE0        (BASE64_BITS_PER_BYTE * 2) /* 16 */
> > +#define BASE64_SHIFT_BYTE1        (BASE64_BITS_PER_BYTE * 1) /* 8  */
> > +
> > +/* Tail (no padding) shifts to extract bytes */
> > +#define BASE64_TAIL2_BYTE0_SHIFT  ((BASE64_CHUNK_BITS * 2) - BASE64_BITS_PER_BYTE)       /* 4  */
> > +#define BASE64_TAIL3_BYTE0_SHIFT  ((BASE64_CHUNK_BITS * 3) - BASE64_BITS_PER_BYTE)       /* 10 */
> > +#define BASE64_TAIL3_BYTE1_SHIFT  ((BASE64_CHUNK_BITS * 3) - (BASE64_BITS_PER_BYTE * 2)) /* 2  */
> > +
> > +/* Extra: masks for leftover validation (no padding) */
> > +#define BASE64_MASK(n) ({        \
> > +	unsigned int __n = (n);  \
> > +	__n ? ((1U << __n) - 1U) : 0U; \
> > +})
> > +#define BASE64_TAIL2_UNUSED_BITS  (BASE64_CHUNK_BITS * 2 - BASE64_BITS_PER_BYTE)     /* 4 */
> > +#define BASE64_TAIL3_UNUSED_BITS  (BASE64_CHUNK_BITS * 3 - BASE64_BITS_PER_BYTE * 2) /* 2 */
> 
> These #defines make the code unnecessarily hard to read.  Most of them
> should just be replaced with the integer literals.
> 

Got it, thanks for the feedback. I'll simplify this in the next version.

> >   * This implementation hasn't been optimized for performance.
> 
> But the commit message claims performance improvements.
> 

That was my mistake. I forgot to update this part of the comment.
I’ll fix it in the next version.

> >   *
> >   * Return: the length of the resulting decoded binary data in bytes,
> >   *	   or -1 if the string isn't a valid base64 string.
> 
> base64 => Base64, since multiple variants are supported now.  Refer to
> the terminology used by RFC4686.  Base64 is the general term, and
> "base64" and "base64url" specific variants of Base64.
> 
> - Eric

Ok, I'll update the comments to use Base64.

Best regards,
Guan-chun

