Return-Path: <ceph-devel+bounces-3884-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CE16CC1337E
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Oct 2025 07:58:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BA9814E99E8
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Oct 2025 06:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E28212C11DE;
	Tue, 28 Oct 2025 06:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="jWJDhr5q"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE62C25A62E
	for <ceph-devel@vger.kernel.org>; Tue, 28 Oct 2025 06:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761634728; cv=none; b=akkEAYHxL0EBqYYkfYcV7vQN9KzWStiPt1aN6bIEV5mE9JdChb1HKpvM0YJu5rNRnNs7iJT/Ag4+1vpPP+Wbky/k0iws2pamo+2Ov0AVfVca0Qw8MB4C2XCRTQeONqWbEhyLB8nkoDGV9x9ae0PtYX6N6h4dXlu9z7r/3hqO7Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761634728; c=relaxed/simple;
	bh=IcpcehS5Fl0yImjYpIaQdsh2MtDqwKJCpu0+KpAln1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h+OjZiW7JRfQFqn5nmv57a7nLh27w+81+BWiLzu2YktF6+236FMaVL/nJy1yoUDGXFKeTPBv1Z2XwbItAlfPeCJSggzHW62xogScg0ZnXD4pRSIIqRaCnmDvUa43zf845qIiqD4P4ccBWbks0mAG0JTfBFD9fOswmGZnD27eyl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=jWJDhr5q; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-290d14e5c9aso78362975ad.3
        for <ceph-devel@vger.kernel.org>; Mon, 27 Oct 2025 23:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1761634725; x=1762239525; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fQ7p6xtC28C9VulZxo2oktqaX1uTl7IBrRCBfSYBTAg=;
        b=jWJDhr5q0gPLs8HF7sgH5yMPPez5imPdJ3wQh/rtFZqynn2bwF+jn1byZtbWUdPAG5
         78uOzYB3eFWxTDq/k7JqZHROoAXTuUymUGMbjGF2g81DBXTjIi+JW/NBOBWzmNC4fMXA
         HhbfuMhZhBeWeHgApSthiGUuVRnQ40uk/Wuv4OF3g0ze2xVY3/+DyBO/HtaitwrEZUm5
         Thx8o6ekIMc66EIWfwUjq7R+a6jC3fkYjDWq/civHTzoGCt7Iu+D7G6Gzx4YICIBUBgp
         AxDfQpJe7eT8w1SN+dRdpzPvdZEgcw1mMsChvLNV0JsYBfqwePtMfAVWnAlUftgbbmZF
         GD6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761634725; x=1762239525;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fQ7p6xtC28C9VulZxo2oktqaX1uTl7IBrRCBfSYBTAg=;
        b=ty8LjvW94+toLCMdT8DEu7VbaMcj1JxeuFgMvgtKKkLlRZ/BHNcdrT5RPvDwt8QoG1
         nepXMD2nj97w+O9Vu9sN4T3qIH948GFi8Dhkumum8abS+hNa8HwEj/pfvgLofWz43bOd
         ibbzTw85YCWJpTzSCCcw6LtJEDaumAJRKjaG2ub86J7mq5BgFB0u7xlARLCSGko5SMRW
         sKB2OGzttail+WNxnqGYdjsRcBJALzBTjCREuuvxY0MimkrkdzB2uuo9uoFeSCSRoPKC
         1x+XTouHbNicVZ4p954arPFROtBgN9DSG3719cwj365vnqZNDasp2IH51eiSlVwDShEV
         9HWw==
X-Forwarded-Encrypted: i=1; AJvYcCXDQwSocvfhQ6pVm8dd96PdYuvrk0lPQ3dTK47VjO1JyJVGKji11KxOAgsug6xh/90KyQMkEGRaV+9m@vger.kernel.org
X-Gm-Message-State: AOJu0YyybdFp9n9hqOB3GxjN5+QIwpIFbmQ4DpcbrCbqsy9/jJijYIbk
	dbqQL0gw7Sto0A+0UhJQicKjTgGadDUznIaVL/AQ+4z7Mu3BSBtuMbYoCY86Gl1MxOg=
X-Gm-Gg: ASbGnctMdEbAl8ig1BjSsV8C1jFV48lgWzKy035tJFw0iPsJZuZ81G4MlthN44uY6BI
	sdnz3lK0eNtSGjpbgGmk1XwiRjTCy5ribMg7AKahlnscqILCSK/3n5AQf/i0XBeRp0/IuXQGSKf
	UUzJZCkTIahx+6bu0ByxnpOR1V+B9iglahIcm5LL3ldBzcbcMysXZq7JH9m5aPKvUvJYC/V3reg
	Lh1cLLBidqHtgLmvPs5kUEMk6QQ1mOrBWOyyQDy7oxkjz1rGWG9MNFd680d0bzfC7ZPBo56IgJX
	N4iB4URuifTKyYmy93YwoJf50scWLlSjEBxPdA3tNJi4fx+panwIXbWhs30FEJnDYWybYskUz2k
	g44DBTeNlVq7/NHhkKFppnU8F26xrWenIRBgKO7XQvZSWrVBxakVSU6+N3ghV8MtEvWhhOYjDfn
	bX4Vs3qikuCsxj2WN1MXbXnQ==
X-Google-Smtp-Source: AGHT+IEQUls0hQ7f0z+eHUlXVig3EP8vmtgVoNPcCaAzKcFm3wz2AgyR/G6DDFlaIKDkK5sA6SsRRQ==
X-Received: by 2002:a17:902:ea0c:b0:269:91b2:e9d6 with SMTP id d9443c01a7336-294cb5196eamr33134075ad.46.1761634725462;
        Mon, 27 Oct 2025 23:58:45 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T ([2001:288:7001:2703:d6d5:e94f:6bb8:7d7f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d42558sm104262595ad.69.2025.10.27.23.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 23:58:45 -0700 (PDT)
Date: Tue, 28 Oct 2025 14:58:40 +0800
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: David Laight <david.laight.linux@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	akpm@linux-foundation.org, axboe@kernel.dk,
	ceph-devel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	home7438072@gmail.com, idryomov@gmail.com, jaegeuk@kernel.org,
	kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com,
	xiubli@redhat.com
Subject: Re: [PATCH v3 2/6] lib/base64: Optimize base64_decode() with reverse
 lookup tables
Message-ID: <aQBpoI+93UZg1SqN@wu-Pro-E500-G6-WS720T>
References: <20251005181803.0ba6aee4@pumpkin>
 <aOTPMGQbUBfgdX4u@wu-Pro-E500-G6-WS720T>
 <CADUfDZp6TA_S72+JDJRmObJgmovPgit=-Zf+-oC+r0wUsyg9Jg@mail.gmail.com>
 <20251007192327.57f00588@pumpkin>
 <aOeprat4/97oSWE0@wu-Pro-E500-G6-WS720T>
 <20251010105138.0356ad75@pumpkin>
 <aOzLQ2KSqGn1eYrm@wu-Pro-E500-G6-WS720T>
 <20251014091420.173dfc9c@pumpkin>
 <aP9voK9lE/MlanGl@wu-Pro-E500-G6-WS720T>
 <20251027141802.61dbfbb2@pumpkin>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251027141802.61dbfbb2@pumpkin>

On Mon, Oct 27, 2025 at 02:18:02PM +0000, David Laight wrote:
> On Mon, 27 Oct 2025 21:12:00 +0800
> Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:
> 
> ...
> > Hi David,
> > 
> > I noticed your suggested approach:
> > val_24 = t[b[0]] | t[b[1]] << 6 | t[b[2]] << 12 | t[b[3]] << 18;
> > Per the C11 draft, this can lead to undefined behavior.
> > "If E1 has a signed type and nonnegative value, and E1 × 2^E2 is
> > representable in the result type, then that is the resulting value;
> > otherwise, the behavior is undefined."
> > Therefore, left-shifting a negative signed value is undefined behavior.
> 
> Don't worry about that, there are all sorts of places in the kernel
> where shifts of negative values are technically undefined.
> 
> They are undefined because you get different values for 1's compliment
> and 'sign overpunch' signed integers.
> Even for 2's compliment C doesn't require a 'sign bit replicating'
> right shift.
> (And I suspect both gcc and clang only support 2's compliment.)
> 
> I don't think even clang is stupid enough to silently not emit any
> instructions for shifts of negative values.
> It is another place where it should be 'implementation defined' rather
> than 'undefined' behaviour.
>

Hi David,

Thanks for your explanation. I'll proceed with the modification according
to your original suggestion.

Best regards,
Guan-Chun

> > Perhaps we could change the code as shown below. What do you think?
> 
> If you are really worried, change the '<< n' to '* (1 << n)' which
> obfuscates the code.
> The compiler will convert it straight back to a simple shift.
> 
> I bet that if you look hard enough even 'a | b' is undefined if
> either is negative.
> 
> 	David
> 
> 
> 
> 	David

