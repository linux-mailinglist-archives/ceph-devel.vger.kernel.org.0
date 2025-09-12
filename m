Return-Path: <ceph-devel+bounces-3595-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EA914B5430F
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Sep 2025 08:38:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9AE7F1C85CD4
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Sep 2025 06:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6B2B2848A1;
	Fri, 12 Sep 2025 06:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="QkfToYcc"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D1E2848A9
	for <ceph-devel@vger.kernel.org>; Fri, 12 Sep 2025 06:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757659082; cv=none; b=Zyf1HljP7q1N1H98Uicl5yc5gJD6/YoaErfEjzc1tdVEzhsMeyo8LuLWWBz5VDU834nq52y2GwVSY3/hnt4uFRqyWMrXDUeZ5MezpkhR0Z5s9hDQQ4u3CoSei7L1fz5dqv/Qs/WWFQskx7EcyWUrHGWjiJei6vcM0QC+Wla0Y6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757659082; c=relaxed/simple;
	bh=epVwvlOvxHSIsmHW/NK0wpZGEnx1bOQUdmWZ1GXJE3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cvo2sTEXxfDuXe/Gg0hunegY9areNh0BTdrbxjxPdhlb1SyNs4wPV5PAuZjMGBC1QSxZJ3AgNZ7FGZdMOL9zRL5aP8Cgl5pJrKyj7zAaToOdxMErvhiGjXAq3bf62dd07sq9NP8yYl2/cHOql9WmsfYy/z2Fpne6mkTnYpKHaAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=QkfToYcc; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7722bcb989aso1115459b3a.1
        for <ceph-devel@vger.kernel.org>; Thu, 11 Sep 2025 23:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1757659080; x=1758263880; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WHuTi6TQfgFAtMCkxSDV0wAwRzh2olOxA10o4YRtx2Y=;
        b=QkfToYccXf69UvNrnI9srarYlMO8RkkPsxZKlV2TJg3llEi/hzXaeSDUsCuPP+9b2F
         R3pUAdwQKLolRI4SXIAKeCFEkvL2j1hSlb5AaEhCE3NzvKdhikal4etqRPI0KNxOs4j/
         ZlFpEUfmQC2E5b4PIQKyY/FVaIPINmhRdZjkzemnwrzVNouEJh4mPUIDz7IUsWPQP6KA
         Yvlqj8YacQBkjM9zR2nmNPjZRP2s02dvsMnrj1+bUL48etnIafpdy9Jb733kQ4GXNpiS
         35PFlqoF0WheBnltoYMF52RUmMyBO2iMf3uSV/agVbdYy5qRKP3lkhKDgFmkgXRQ83fs
         Gvsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757659080; x=1758263880;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WHuTi6TQfgFAtMCkxSDV0wAwRzh2olOxA10o4YRtx2Y=;
        b=iSZPBQr4hRHtBDxGrChUHNUfK+dDllOClu5hbtZASxIqkpO/HYsIghr/1uTEpDH9cV
         l4zfGT4YbI3ZPjZJiJZU1JxV7XUK78igMs5yNKyCHOiIePzA2ZeXT3FQTMtUtxEM/Bxr
         n3pcG2Us/FCeY+Xz6GrmEeH49K1c79zHTzUng8+vdNdu6V2cMnKFL+DTC60vNDVv0tpv
         3FIEI8wsNL1nkHu790r2/X79fX27h7F82N1fXk53muHq6309YuzCHvyjAKiVoVLqnm22
         51b0VhEs8ou8lAGU0/dEYjzCYrPCr6QJDBiSkv809z7SYG8jJq5UPQisPlYarJMctC0e
         kMYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgRTPwJgn5sP1DAGF6HHbaGLXOABKCfrgWAszvsJC3zwagC8cyd1GCBaPndNcToZTZrgGmi7Xb2+CT@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7e6pAd0jsLyxvBFQRkj15rt2c/EXJhwtFsgeeONB64zInvhOC
	RvNjSUc1INoqYX/0Xol9Zg2oj/y2n8GWEziTbsMPRupRV5bNVg/6XK7NBgnwdOuy1u8=
X-Gm-Gg: ASbGncuSqrUP7wHtQCSikZw4j+IeCoV0rGjAq/YnEP0W0jtKvv+dTuQYwpMUl0HvsSU
	31KrOJ/w/s4DvnaJB++Lb4WIu0mi4wbxm3xzYFMBOte1UsJKdCbSClRNf8JZerZmaDSpVChJRIR
	Tg2U5ZJF6fvIIRfkmhuBmOvJNbkU/8mBz/+gNVCaTFQE2hYz4C6lzG2FmEUOoX1zhPSExkbAy8h
	wtza+5kVC2O8I/LJR9EV3//wWIHhYMmDMoClJBZj1oVSS6knapxjwqT3qZByWRcmZ/uWrEhNjES
	QR/8FoBtA6O0t7er3OOKWCJ3jCHN6Ku16usrT1yQm7kzget/mu+/1f7xaL/ckB8A5ctNQSx4dk/
	UL4DVX9LPwsTBxtZD6C1GAJJCK1gDiaSl51jJ+vBLhGLYWDrUGiYw6lA=
X-Google-Smtp-Source: AGHT+IH14YJIU/pCQLxK6heygYQ8+5SPefXRMNU94Q5Y9SS8UUy1273yVEMkFePKwHp+1d4YOuXzeg==
X-Received: by 2002:a05:6a00:138f:b0:76e:885a:c338 with SMTP id d2e1a72fcca58-7761219fbc4mr2061714b3a.30.1757659079662;
        Thu, 11 Sep 2025 23:37:59 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T ([2001:288:7001:2703:9e14:1074:637d:9ff6])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77607c54a71sm4279534b3a.102.2025.09.11.23.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 23:37:58 -0700 (PDT)
Date: Fri, 12 Sep 2025 14:37:54 +0800
From: FIRST_NAME LAST_NAME <409411716@gms.tku.edu.tw>
To: Eric Biggers <ebiggers@kernel.org>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org,
	hch@lst.de, home7438072@gmail.com, idryomov@gmail.com,
	jaegeuk@kernel.org, kbusch@kernel.org,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, sagi@grimberg.me, tytso@mit.edu,
	visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v2 2/5] lib/base64: rework encoder/decoder with
 customizable support and update nvme-auth
Message-ID: <aMO/woLrAN7bn9Fd@wu-Pro-E500-G6-WS720T>
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

The stricter correctness here refers to the decoder — specifically the padding
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

That was my mistake — I forgot to update this part of the comment.
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

