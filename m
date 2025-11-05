Return-Path: <ceph-devel+bounces-3926-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 41AA9C36196
	for <lists+ceph-devel@lfdr.de>; Wed, 05 Nov 2025 15:39:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 753921A22C5E
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Nov 2025 14:39:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDBCD32E6B4;
	Wed,  5 Nov 2025 14:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TCICHe/S"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD54B32D0D8
	for <ceph-devel@vger.kernel.org>; Wed,  5 Nov 2025 14:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762353506; cv=none; b=msSmy8iEBs402qINztLgDpbbcmmqbZ/JIoIHhaPRfKoRm3Pogd39VlD6CZdzaSLJJXKjU++TAQVjob0s2X/8lnu4EssbDVuDQUxnVvGY5f31smMuJv3mIBFlAG10V0kTiEOZ3y5Hfm3rLPxujv80C0a88RxSJL9hSrnvh2iWUmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762353506; c=relaxed/simple;
	bh=YwmIrc9rncm8jYwO6rWq5RbLiYWZvoFNa6HUs4etLrc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hlI39dd3prXUKGEoae26fzA+kFx7WXdX9w79Gk2JJLrUK8Kv+X1TUlSyTURaNy1wB2lZcmhtW42OcuUcyDyaolLznAFQ0Ch2sU757G5b6iTA1jD1YpKCHgPl4IGgFVWVsTxNIz3XOcbRQwKNwfRODziahbiVlqCh3NWHU9SMWrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TCICHe/S; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-477442b1de0so26247365e9.1
        for <ceph-devel@vger.kernel.org>; Wed, 05 Nov 2025 06:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762353503; x=1762958303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/LkaRIn/NSiNJWnW7QBCmH2dkiWqmxXew9zG5Ks3bGA=;
        b=TCICHe/SRUFQeH3T2Y4BBy7jUFSkwnQkzEPadBCAFcYJEGohyxhmYwSzcZwycAuV16
         uce1XOg8+Id93v50iLyPF/yvG8fALVI6sPdik0ub2MtnZZPoEfFDct/XthB+u1qL8Adq
         hdE0l+7eT28mXolkFWCZ2jsJyS0TVSch5fB4Q4ozVbIS/bAJTRfaKkjd/UzLdtFBt5me
         IPxvxFND5gkimaZcD0q2/EJwIak7r6YBLRXdG+BkKhFh98ZbbFA1wEaOxV98UuBCvFFs
         IeiuissUmUdt8wT5B2hLO1rRkjBgcum0OFQ2eY2pYAXI3Q5GDou4oIwRMJUdyNuttAm+
         D+bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762353503; x=1762958303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/LkaRIn/NSiNJWnW7QBCmH2dkiWqmxXew9zG5Ks3bGA=;
        b=oc6AGudlr7TvRUmdS+ZzkUji93VAaUtOgNGbmpKscBFvTiPgTbiqa8s3PpmO5TiPM4
         Q7xiMJpoa5rCQKl2LjuQkA/bc7rk5dz5mjyITRP9a+92IxsN8XzaaK6n76KQ9j7M2+v/
         XDT4k5Og8/5PhEaS7iA7DeBERH/8cVc57omIpGVef2k9lx9iFBRF2R4LVqfTP1fcCg9J
         BzXsGXVrkI7oRu+4Mk/6vjzicLCtnc1j4l4ejLFGlBds2KkTopdqIrsbcBtkuycxQzch
         kSVn3T63FwCsDiNaJumxzwjqTOv5vlEfNEF0dnUM74fjEBpCsM9HJTd2ooAB1DgVrRSn
         Q1Dg==
X-Forwarded-Encrypted: i=1; AJvYcCWmfGGlK+XqrKY6qVHseBkOJyQC1WwXLmeQy4MfkzfbcPeRlnw16V9QtlO/bMP2LBXTP1rUOe91kC8J@vger.kernel.org
X-Gm-Message-State: AOJu0Yxw28urxnCejje6lL7aZu0zkGBA+M9JKtfKG4VG8r+fAvaleNOo
	ACklNIJ86sCtKSV79Kqcc0EOe/SZGWIQtu2NkmWjCdrvPDfD924HEsvj
X-Gm-Gg: ASbGncsushrbKGNtJQCSokQtKN9bXwywZ4JtZn/JUrLWHzbMPxGqdG66gKVB24VJlrk
	UlWAGKODhlyRXtQYpxw4m5gHnmS1jpJTU3MgMyR6Rr9iZ4GvyWrdKHCftLF8XVUVes5dsFUU/Jr
	ZuQcsAppfkLCEReFLfh2t2/lmm9YVpQFtKerhP6CZ/NfkkYA7miBqiLtawCrAPEA9+pkuyp23+Z
	dAFnw9OmbkI4n6D79b3ajxgRhokogWxrqTcLjz9U7IoyXhCYD5aqa5NJ/RWgSwtM8rksy1LVpCa
	TUDu4yJTDEfGaQwUq8V563sucO/Jnt+Wees/U1Ire+SCUCGtbphAG7aGcLfd29JwAAc2N6Awkqy
	r2oKpT2kycdlne/c3bGlEv+7yMW8KFVbo4Dpd8O/lH6v262yPASrg/HGELFXZqhQ6I0cTSDhego
	8pYU5hw63JSBvEE7wBB+cRDCCiYJ61A8Dp1bWoritcqZnYNZ0DcW2c
X-Google-Smtp-Source: AGHT+IEHIwFXlJwm0yt3wS2IwhGgmlEW/3ZYotu2V04LIxWOLcO6w3z/6QAwxlyH+LxvfC1sir4Grw==
X-Received: by 2002:a05:600c:348f:b0:46e:2801:84aa with SMTP id 5b1f17b1804b1-4775cd3bec8mr38687765e9.0.1762353502780;
        Wed, 05 Nov 2025 06:38:22 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4775cde39f9sm54314335e9.14.2025.11.05.06.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 06:38:22 -0800 (PST)
Date: Wed, 5 Nov 2025 14:38:20 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>, Guan-Chun Wu
 <409411716@gms.tku.edu.tw>, Andrew Morton <akpm@linux-foundation.org>,
 ebiggers@kernel.org, tytso@mit.edu, jaegeuk@kernel.org, xiubli@redhat.com,
 idryomov@gmail.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de,
 sagi@grimberg.me, home7438072@gmail.com, linux-nvme@lists.infradead.org,
 linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/6] lib/base64: add generic encoder/decoder, migrate
 users
Message-ID: <20251105143820.11558ca8@pumpkin>
In-Reply-To: <aQtbmWLqtFXvT8Bc@smile.fi.intel.com>
References: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
	<20251031210947.1d2b028da88ef526aebd890d@linux-foundation.org>
	<aQiC4zrtXobieAUm@black.igk.intel.com>
	<aQiM7OWWM0dXTT0J@google.com>
	<20251104090326.2040fa75@pumpkin>
	<aQnMCVYFNpdsd-mm@smile.fi.intel.com>
	<20251105094827.10e67b2d@pumpkin>
	<aQtbmWLqtFXvT8Bc@smile.fi.intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 5 Nov 2025 16:13:45 +0200
Andy Shevchenko <andriy.shevchenko@intel.com> wrote:

> On Wed, Nov 05, 2025 at 09:48:27AM +0000, David Laight wrote:
> > On Tue, 4 Nov 2025 11:48:57 +0200
> > Andy Shevchenko <andriy.shevchenko@intel.com> wrote:  
> > > On Tue, Nov 04, 2025 at 09:03:26AM +0000, David Laight wrote:  
> > > > On Mon, 3 Nov 2025 19:07:24 +0800
> > > > Kuan-Wei Chiu <visitorckw@gmail.com> wrote:    
> > > > > On Mon, Nov 03, 2025 at 11:24:35AM +0100, Andy Shevchenko wrote:    
> 
...
> > How about this one?  
> 
> Better than previous one(s) but quite cryptic to understand. Will need a
> comment explaining the logic behind, if we go this way.

My first version (of this version) had all three character ranges in the define:
so:
#define INIT_1(v, ch_62, ch_63) \
	[ v ] = (v) >= '0' && (v) <= '9' ? (v) - '0' \
		: (v) >= 'A' && (v) <= 'Z' ? (v) - 'A' + 10 \
		: (v) >= 'a' && (v) <= 'z' ? (v) - 'a' + 36 \
		: (v) == ch_62 ? 62 : (v) == ch_63 ? 63 : -1
Perhaps less cryptic - even if the .i line will be rather longer.
It could be replicated for all 256 bytes, but I think the range
initialisers are reasonable for the non-printable ranges.

I did wonder if the encode and decode lookup tables count be interleaved
and both initialisers generated from the same #define.
But I can't think of a way of generating 'x' and "X" from a #define parameter.
(I don't think "X"[0] is constant enough...)

	David

> 
> > #define INIT_1(v, ch_lo, ch_hi, off, ch_62, ch_63) \
> > 	[ v ] = ((v) >= ch_lo && (v) <= ch_hi) ? (v) - ch_lo + off \
> > 		: (v) == ch_62 ? 62 : (v) == ch_63 ? 63 : -1
> > #define INIT_2(v, ...) INIT_1(v, __VA_ARGS__), INIT_1((v) + 1, __VA_ARGS__)
> > #define INIT_4(v, ...) INIT_2(v, __VA_ARGS__), INIT_2((v) + 2, __VA_ARGS__)
> > #define INIT_8(v, ...) INIT_4(v, __VA_ARGS__), INIT_4((v) + 4, __VA_ARGS__)
> > #define INIT_16(v, ...) INIT_8(v, __VA_ARGS__), INIT_8((v) + 8, __VA_ARGS__)
> > #define INIT_32(v, ...) INIT_16(v, __VA_ARGS__), INIT_16((v) + 16, __VA_ARGS__)
> > 
> > #define BASE64_REV_INIT(ch_62, ch_63) { \
> > 	[ 0 ... 0x1f ] = -1, \
> > 	INIT_32(0x20, '0', '9', 0, ch_62, ch_63), \
> > 	INIT_32(0x40, 'A', 'Z', 10, ch_62, ch_63), \
> > 	INIT_32(0x60, 'a', 'z', 26, ch_62, ch_63), \
> > 	[ 0x80 ... 0xff ] = -1 }
> > 
> > which gets the pre-processor to do all the work.
> > ch_62 and ch_63 can be any printable characters.
> > 
> > Note that the #define names are all in a .c file - so don't need any
> > kind of namespace protection.  
> 
> > They can also all be #undef after the initialiser.  
> 
> Yes, that's too.
> 
> > > Moreover this table is basically a dup of the strings in the first array.
> > > Which already makes an unnecessary duplication.  
> > 
> > That is what the self tests are for.
> >   
> > > That's why I prefer to
> > > see a script (one source of data) to generate the header or something like
> > > this to have the tables and strings robust against typos.  
> > 
> > We have to differ on that one.
> > Especially in cases (like this) where generating that data is reasonably trivial.
> >   
> > > The above is simply an unreadable mess.  
> 


