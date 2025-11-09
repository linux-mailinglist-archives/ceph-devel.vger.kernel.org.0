Return-Path: <ceph-devel+bounces-3943-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F330C43DC8
	for <lists+ceph-devel@lfdr.de>; Sun, 09 Nov 2025 13:36:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F54D188AB46
	for <lists+ceph-devel@lfdr.de>; Sun,  9 Nov 2025 12:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E35BD1FF1B5;
	Sun,  9 Nov 2025 12:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="CwmWzn64"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFE02EC54A
	for <ceph-devel@vger.kernel.org>; Sun,  9 Nov 2025 12:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762691782; cv=none; b=iRtbBh6j3YI4uxkoeDHQSPPY9rP+8nc+XjkIYj0YHqyNZeBwC4qIxEo97mAM/mVOlM6CO0kz/llqh8Uy/0AV65j3SQmFIq0wajlE5haBYW+oYqHz0Bv6JbdEMaakXo8dWQNm1S5SfEjJJya2zPSQSwNgHlr0Mfj0v0TkBbNqQzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762691782; c=relaxed/simple;
	bh=0U+Xecz6Fprk4dFBomPdZ52Cm4H0r6qZsfE5vgiz9io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tki8wheSfUFLrBWZXOwi77dJFayL2VQvQ0Nf5z1Rfmdz06P3hR/8N1v5c1/ZVmKWl1UPlmzPt2SQBNDuhbWY8Lj3mcFMPmy2CIyJEVoGh57vrGJdDIzv7DR7M7kN8qSWPOXNu1qZMBAEfhlcpW7zZbVBp/ZPrnIGdRFrliHLlx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=CwmWzn64; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-341988c720aso1746468a91.3
        for <ceph-devel@vger.kernel.org>; Sun, 09 Nov 2025 04:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1762691780; x=1763296580; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KJmBqFwSZPTgeDdxxWga7QZHqD9dNuDtkCKsKlOxCRA=;
        b=CwmWzn64xu6rrzwg0+7loMOilGb4rKuLRpuGdxCfxC4/Pq4PgNE7cjZ6xa6+Uq/MGk
         nbAT1eW4OlMtfBgw+FwbwqVy8DQ3wi20ii/by1ARkvNKyxPO3jVatFV2lIXlEchyTAfn
         6IQ4FG02B6BQaPdEgErQLX7DpMuMxGHoqnLUVYcca2LYFcRf/i+R+cJDzC6lwbZWvt6z
         zupquU7kEH9xcGYn438HppIwOCZuo0/iXge0cNC9gNDgngBntB2ZaMlDcBpUuHmrvtxl
         h+1nur/i0KSS6PoRjgw4euPENUAWbdXlxjgnXxzvJJwgmrSj5FsDIFC8GBEITLH+udRw
         WBwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762691780; x=1763296580;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KJmBqFwSZPTgeDdxxWga7QZHqD9dNuDtkCKsKlOxCRA=;
        b=h8RX7mf4F644CHPw+ksOd8NuDmeeVON5h4F0FVAItvPdgncS8zPqC15iUx50dFZdjs
         fOOKMt/oVepdx4wKWrqP4JOonMBMCmjEeraqToVqG55X7ewq0aqILBh8bsnPxMF9wNP+
         YkkmKjkFJC7GMa7yYTPJuDgeFDJw1yv/AcA/Xa0UCLQQr6NW1oBDyi8RwBfHbnIQ+jmW
         GDlm/hVOIM1e09wdPpckMNdEFR53M4jJ0dNqLmgZJe0zdfrJBWsD3UP7WYBrcb+4o/TE
         nRMYv8F1uDms1AgSWueLADm72djIgkuYRYWx4sJYk2iRK5zD1lwD3MHo0VSS1kr0QvuM
         G9Yw==
X-Forwarded-Encrypted: i=1; AJvYcCUl4ed+5Mg8n/pyyLM65EIuiykQZy1yE9Y7tj6aInQA4KsN/6uR6hbiNxjPpvOSyy9hkgplPe3PFw2N@vger.kernel.org
X-Gm-Message-State: AOJu0YxyuERcalwfGPg7nDcEjP/fl4wOIC4ITJz4ST5Mm7Rg87hE7fqi
	P8MgT83xJ2mWwMfEJh+ySBx/e/8zyCpBorVgguucb6tfYthkMkf35O6y+BY5fNPJeXg=
X-Gm-Gg: ASbGncuqhFLu9O8SBwVb2ubu7BX89ARyo0NmpS83WaQhYBPmIv7McDhqYyjgatHh8oF
	n4mqlqonhqY2ffYCwMr3kjQrvNQF9hO74VaYRMhhosC54LxB+qIW6dbqQUGmsGg2ywQV2gbsHEM
	Rgm0ViF/bxzgPBNYrgZC6bt7PqJkH9cPYZB2NxfahcJuPIirdoLCg1hj9RYWGVqIqyx1q8ZtBJ8
	iQICyBEOZIUt1zMhTJlNW4rlESo4x18ZJ7Ir04VNjj/U9CeM/1jqnv2+HIucJHKZnI0rsQZc3FF
	adSMvvNkCvbDqUwISoAnGDhdlIK74ocVW8qNNB7uQJ1wWyeUaWfrN7r/DvsiLKOdpmijniZoqMz
	xjxvMFxIDsQ+msZ2hD0d7YKdMAUChAvrgrLBAWPGlXT+eu2u9KdXq6MoNNXMFvMJo1Y9/pBMZ/e
	Koy1A/yiE00lmKkqZt8Z5W1vjijp13GOo=
X-Google-Smtp-Source: AGHT+IFJcX4kraEUbC8VOW05T7p2FeSFYukhwLNqfkAsi9st8xXB4csrxqTW846Kb3/6J4WQhJ7aog==
X-Received: by 2002:a17:90a:da8b:b0:33b:dec9:d9aa with SMTP id 98e67ed59e1d1-3436cbb171cmr5487179a91.25.1762691779910;
        Sun, 09 Nov 2025 04:36:19 -0800 (PST)
Received: from wu-Pro-E500-G6-WS720T ([2001:288:7001:2703:519d:1960:dc93:9d0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3434c337b20sm7781832a91.13.2025.11.09.04.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Nov 2025 04:36:18 -0800 (PST)
Date: Sun, 9 Nov 2025 20:36:12 +0800
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: David Laight <david.laight.linux@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, ebiggers@kernel.org,
	tytso@mit.edu, jaegeuk@kernel.org, xiubli@redhat.com,
	idryomov@gmail.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de,
	sagi@grimberg.me, home7438072@gmail.com,
	linux-nvme@lists.infradead.org, linux-fscrypt@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/6] lib/base64: add generic encoder/decoder, migrate
 users
Message-ID: <aRCKvJnJxmaDYKvI@wu-Pro-E500-G6-WS720T>
References: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
 <20251031210947.1d2b028da88ef526aebd890d@linux-foundation.org>
 <aQiC4zrtXobieAUm@black.igk.intel.com>
 <aQiM7OWWM0dXTT0J@google.com>
 <20251104090326.2040fa75@pumpkin>
 <aQnMCVYFNpdsd-mm@smile.fi.intel.com>
 <20251105094827.10e67b2d@pumpkin>
 <aQtbmWLqtFXvT8Bc@smile.fi.intel.com>
 <20251105143820.11558ca8@pumpkin>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251105143820.11558ca8@pumpkin>

On Wed, Nov 05, 2025 at 02:38:20PM +0000, David Laight wrote:
> On Wed, 5 Nov 2025 16:13:45 +0200
> Andy Shevchenko <andriy.shevchenko@intel.com> wrote:
> 
> > On Wed, Nov 05, 2025 at 09:48:27AM +0000, David Laight wrote:
> > > On Tue, 4 Nov 2025 11:48:57 +0200
> > > Andy Shevchenko <andriy.shevchenko@intel.com> wrote:  
> > > > On Tue, Nov 04, 2025 at 09:03:26AM +0000, David Laight wrote:  
> > > > > On Mon, 3 Nov 2025 19:07:24 +0800
> > > > > Kuan-Wei Chiu <visitorckw@gmail.com> wrote:    
> > > > > > On Mon, Nov 03, 2025 at 11:24:35AM +0100, Andy Shevchenko wrote:    
> > 
> ...
> > > How about this one?  
> > 
> > Better than previous one(s) but quite cryptic to understand. Will need a
> > comment explaining the logic behind, if we go this way.
> 
> My first version (of this version) had all three character ranges in the define:
> so:
> #define INIT_1(v, ch_62, ch_63) \
> 	[ v ] = (v) >= '0' && (v) <= '9' ? (v) - '0' \
> 		: (v) >= 'A' && (v) <= 'Z' ? (v) - 'A' + 10 \
> 		: (v) >= 'a' && (v) <= 'z' ? (v) - 'a' + 36 \
> 		: (v) == ch_62 ? 62 : (v) == ch_63 ? 63 : -1
> Perhaps less cryptic - even if the .i line will be rather longer.
> It could be replicated for all 256 bytes, but I think the range
> initialisers are reasonable for the non-printable ranges.
> 
> I did wonder if the encode and decode lookup tables count be interleaved
> and both initialisers generated from the same #define.
> But I can't think of a way of generating 'x' and "X" from a #define parameter.
> (I don't think "X"[0] is constant enough...)
> 
> 	David
>

Thanks for your reply!
We’ll adopt the approach you suggested in the next version.

Best regards,
Guan-Chun

> > 
> > > #define INIT_1(v, ch_lo, ch_hi, off, ch_62, ch_63) \
> > > 	[ v ] = ((v) >= ch_lo && (v) <= ch_hi) ? (v) - ch_lo + off \
> > > 		: (v) == ch_62 ? 62 : (v) == ch_63 ? 63 : -1
> > > #define INIT_2(v, ...) INIT_1(v, __VA_ARGS__), INIT_1((v) + 1, __VA_ARGS__)
> > > #define INIT_4(v, ...) INIT_2(v, __VA_ARGS__), INIT_2((v) + 2, __VA_ARGS__)
> > > #define INIT_8(v, ...) INIT_4(v, __VA_ARGS__), INIT_4((v) + 4, __VA_ARGS__)
> > > #define INIT_16(v, ...) INIT_8(v, __VA_ARGS__), INIT_8((v) + 8, __VA_ARGS__)
> > > #define INIT_32(v, ...) INIT_16(v, __VA_ARGS__), INIT_16((v) + 16, __VA_ARGS__)
> > > 
> > > #define BASE64_REV_INIT(ch_62, ch_63) { \
> > > 	[ 0 ... 0x1f ] = -1, \
> > > 	INIT_32(0x20, '0', '9', 0, ch_62, ch_63), \
> > > 	INIT_32(0x40, 'A', 'Z', 10, ch_62, ch_63), \
> > > 	INIT_32(0x60, 'a', 'z', 26, ch_62, ch_63), \
> > > 	[ 0x80 ... 0xff ] = -1 }
> > > 
> > > which gets the pre-processor to do all the work.
> > > ch_62 and ch_63 can be any printable characters.
> > > 
> > > Note that the #define names are all in a .c file - so don't need any
> > > kind of namespace protection.  
> > 
> > > They can also all be #undef after the initialiser.  
> > 
> > Yes, that's too.
> > 
> > > > Moreover this table is basically a dup of the strings in the first array.
> > > > Which already makes an unnecessary duplication.  
> > > 
> > > That is what the self tests are for.
> > >   
> > > > That's why I prefer to
> > > > see a script (one source of data) to generate the header or something like
> > > > this to have the tables and strings robust against typos.  
> > > 
> > > We have to differ on that one.
> > > Especially in cases (like this) where generating that data is reasonably trivial.
> > >   
> > > > The above is simply an unreadable mess.  
> > 
> 

