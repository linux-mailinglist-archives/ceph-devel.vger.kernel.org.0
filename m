Return-Path: <ceph-devel+bounces-3901-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B2356C2B413
	for <lists+ceph-devel@lfdr.de>; Mon, 03 Nov 2025 12:09:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 866651895317
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Nov 2025 11:08:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE6872F90D5;
	Mon,  3 Nov 2025 11:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O3UfXCBT"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C66230103C
	for <ceph-devel@vger.kernel.org>; Mon,  3 Nov 2025 11:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762168052; cv=none; b=olue3qGKMTseTc1/IdroT7VSvDkE0tuW7q57fSk8+MsY33L0vs2ROwTrOypNwDJWa58G9eIFN3tXbkCXSSYfl1Qg9eWpF6d7/R+0PCwtDJXb2kFGjCBTgA0ilPkqZpZyqnx89Mkep+CZTWXQNyxVR76Z1kRcq46IbDUsq3lgfp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762168052; c=relaxed/simple;
	bh=mA9KY7uIbnEgVR1SSsuX7u/ye9v5ngsAxc98lcuXZH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kNfovDh9qUdaZeQxVk25IPhAvkWQRSbkOKX63bUptKTWPadQ8kmUZPJWS3f/E9F2hrWxqRWn60KSLRgFko7znvCbtqyIlfp9rXw6/5P0DzlHVd41C2kEqG7lN78fFK0PIuxy6/XTuw3I9/ZrrfQQlKohd0ewc9N4fnNtqm3SC1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O3UfXCBT; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-33292adb180so4687988a91.3
        for <ceph-devel@vger.kernel.org>; Mon, 03 Nov 2025 03:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762168050; x=1762772850; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vd+5KBI+DcPHKtaahVWDgGYJD9ObtH7hyDt+uX2+Cpo=;
        b=O3UfXCBTarRt8XRvzh0S/4L1Y/dWHF1ZHDWIHX8SM33zfclszl7OUDhBtlIeihohf/
         hVOOnVcEC1VwBGjRyLOuU7m+rdVEamTTVxZxXx8sSw7mmqTQ80QlynmOozD65EovddkK
         fu1vkzrhGvzdLhBQFx+WSXE0md678a5lSCFKyCblshPVupCBVp90sBy6CQ96OwjPkjLR
         rhsvgLuS8lWbAqLoNvZprMWHomoWhp0L2Zs2bkqTVOuscTCzlCN6Ef1tK/idiBRSln96
         XsxEEtoTa/Ls2S6OWhADBVRUeOdIvopTAmoFkv110Krpshr9syxCgNFdk9SGj3weT8G7
         Oa3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762168050; x=1762772850;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vd+5KBI+DcPHKtaahVWDgGYJD9ObtH7hyDt+uX2+Cpo=;
        b=FNcGGRncd8lowWvLKjzbn68WJjR/2zyJIkCzb9Grhx/azBFjUjfAyVTIHzepYD6CAl
         WJM9vSUDcEjBtVPkOCpAGdzCF/WlezLpTJhKVW6Mt8BJmUsxkCCIFCyrF4R+Qqq3tBzU
         +1VnsedGX6BUycpgeqN29Kijz6BFgFSOJFt5bTVWrd7QN/YaUaG7gv9G8TOYoqz6E+ql
         /RmWTrtdsGoxYGQNseuTdOoeX3WvnGVP1vyG7CG32IwPvf6LoYZIrHMGxotbYB1+Li6r
         umFXHPIJjy1W9bRzlr1bjHjDOYi4i3hRSqZJijFG3j0y9tATVqDa7zfSMIEpQMa6B74E
         lsCA==
X-Forwarded-Encrypted: i=1; AJvYcCUvjSC0d+qO7iG6Oz4DjC+56MtTCNL8w8yuVs7cHoq7dlXd+ZFYdxCnDSZP/d/Q7jo7vITE9cfA98Ey@vger.kernel.org
X-Gm-Message-State: AOJu0YwtrMS/WWjT1QLy9PFEhVfJDQpTW5Xom6sPIdh3eEoEhw3D0lmg
	XiYIldKfBavpSKYACd9gPu+DCK16tPylPPzVwR1UN4D6b/i9wth+qzYZ
X-Gm-Gg: ASbGncuRifdUlIyPmWgVmBq64Aqgyx+7cw6A3DxAo87CrCeWo1UbSXHC+0MlNMjDfCv
	AawLbrjmm0x5NiDzVHafWsxmZplbhA8gGJM9c4zfjtp8L83x2pfmVPBA+Jtzlc8H6q7IPfd0SQ7
	s44CiV+PdJHnZ1IR3kqcd4bIBzndiKbQvBJAeKXG6g7ElJFAXpYGrqJZL18kPM/iJpJ9g5/lRSG
	/jp5WY03VhV6aqSgY+06/unjD9uirKjULILqWZmNOdYca4xWfysz55smahRMKNugNKqYDAt4/DE
	RqaIfMjygEuX0pbKrxAQT4sZhA66k0lZoiYvRna1D3vxyaeD+OpopWz/FQffn7TFzgp5DmjMsaK
	qmUTdKsPJoo6+VcSxRMFEt466BdbJVHwinpNBPuPhS7MGd7fueJvHd9KXvkSc7Y2XSmX4mDVhq0
	qhZgAHqc3lzojis9y/baYSMyjvuPveV9JcAXwkxnMoikSPMfW2EpbvjrQkjbOPQ1PNiIA=
X-Google-Smtp-Source: AGHT+IH4+9frysi9DNFV/2/WAly7wk4mYQWIlTpjWZue0G81QDWwZ4rfIb4hTAprNc33o6VQINfi4w==
X-Received: by 2002:a17:90b:314e:b0:340:d511:e15f with SMTP id 98e67ed59e1d1-340d511e56fmr7617741a91.18.1762168050210;
        Mon, 03 Nov 2025 03:07:30 -0800 (PST)
Received: from google.com (114-39-189-33.dynamic-ip.hinet.net. [114.39.189.33])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b93bf44e233sm10126135a12.34.2025.11.03.03.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 03:07:29 -0800 (PST)
Date: Mon, 3 Nov 2025 19:07:24 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@intel.com>,
	David Laight <david.laight.linux@gmail.com>,
	Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Guan-Chun Wu <409411716@gms.tku.edu.tw>, ebiggers@kernel.org,
	tytso@mit.edu, jaegeuk@kernel.org, xiubli@redhat.com,
	idryomov@gmail.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de,
	sagi@grimberg.me, home7438072@gmail.com,
	linux-nvme@lists.infradead.org, linux-fscrypt@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/6] lib/base64: add generic encoder/decoder, migrate
 users
Message-ID: <aQiM7OWWM0dXTT0J@google.com>
References: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
 <20251031210947.1d2b028da88ef526aebd890d@linux-foundation.org>
 <aQiC4zrtXobieAUm@black.igk.intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQiC4zrtXobieAUm@black.igk.intel.com>

+Cc David

Hi Guan-Chun,

If we need to respin this series, please Cc David when sending the next
version.

On Mon, Nov 03, 2025 at 11:24:35AM +0100, Andy Shevchenko wrote:
> On Fri, Oct 31, 2025 at 09:09:47PM -0700, Andrew Morton wrote:
> > On Wed, 29 Oct 2025 18:17:25 +0800 Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:
> > 
> > > This series introduces a generic Base64 encoder/decoder to the kernel
> > > library, eliminating duplicated implementations and delivering significant
> > > performance improvements.
> > > 
> > > The Base64 API has been extended to support multiple variants (Standard,
> > > URL-safe, and IMAP) as defined in RFC 4648 and RFC 3501. The API now takes
> > > a variant parameter and an option to control padding. As part of this
> > > series, users are migrated to the new interface while preserving their
> > > specific formats: fscrypt now uses BASE64_URLSAFE, Ceph uses BASE64_IMAP,
> > > and NVMe is updated to BASE64_STD.
> > > 
> > > On the encoder side, the implementation processes input in 3-byte blocks,
> > > mapping 24 bits directly to 4 output symbols. This avoids bit-by-bit
> > > streaming and reduces loop overhead, achieving about a 2.7x speedup compared
> > > to previous implementations.
> > > 
> > > On the decoder side, replace strchr() lookups with per-variant reverse tables
> > > and process input in 4-character groups. Each group is mapped to numeric values
> > > and combined into 3 bytes. Padded and unpadded forms are validated explicitly,
> > > rejecting invalid '=' usage and enforcing tail rules.
> > 
> > Looks like wonderful work, thanks.  And it's good to gain a selftest
> > for this code.
> > 
> > > This improves throughput by ~43-52x.
> > 
> > Well that isn't a thing we see every day.
> 
> I agree with the judgement, the problem is that this broke drastically a build:
> 
> lib/base64.c:35:17: error: initializer overrides prior initialization of this subobject [-Werror,-Winitializer-overrides]
>    35 |         [BASE64_STD] = BASE64_REV_INIT('+', '/'),
>       |                        ^~~~~~~~~~~~~~~~~~~~~~~~~
> lib/base64.c:26:11: note: expanded from macro 'BASE64_REV_INIT'
>    26 |         ['A'] =  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, \
>       |                  ^
> lib/base64.c:35:17: note: previous initialization is here
>    35 |         [BASE64_STD] = BASE64_REV_INIT('+', '/'),
>       |                        ^~~~~~~~~~~~~~~~~~~~~~~~~
> lib/base64.c:25:16: note: expanded from macro 'BASE64_REV_INIT'
>    25 |         [0 ... 255] = -1, \
>       |                       ^~
> ...
> fatal error: too many errors emitted, stopping now [-ferror-limit=]
> 20 errors generated.
> 
Since I didn't notice this build failure, I guess this happens during a
W=1 build? Sorry for that. Maybe I should add W=1 compilation testing
to my checklist before sending patches in the future. I also got an
email from the kernel test robot with a duplicate initialization
warning from the sparse tool [1], pointing to the same code.

This implementation was based on David's previous suggestion [2] to
first default all entries to -1 and then set the values for the 64
character entries. This was to avoid expanding the large 256 * 3 table
and improve code readability.

Hi David,

Since I believe many people test and care about W=1 builds, I think we
need to find another way to avoid this warning? Perhaps we could
consider what you suggested:

#define BASE64_REV_INIT(val_plus, val_comma, val_minus, val_slash, val_under) { \
	[ 0 ... '+'-1 ] = -1, \
	[ '+' ] = val_plus, val_comma, val_minus, -1, val_slash, \
	[ '0' ] = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, \
	[ '9'+1 ... 'A'-1 ] = -1, \
	[ 'A' ] = 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, \
		  23, 24, 25, 26, 27, 28, 28, 30, 31, 32, 33, 34, 35, \
	[ 'Z'+1 ... '_'-1 ] = -1, \
	[ '_' ] = val_under, \
	[ '_'+1 ... 'a'-1 ] = -1, \
	[ 'a' ] = 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, \
		  49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, \
	[ 'z'+1 ... 255 ] = -1 \
}

Or should we just expand the 256 * 3 table as it was before?

[1]: https://lore.kernel.org/oe-kbuild-all/202511021343.107utehN-lkp@intel.com/
[2]: https://lore.kernel.org/lkml/20250928195736.71bec9ae@pumpkin/

Regards,
Kuan-Wei

