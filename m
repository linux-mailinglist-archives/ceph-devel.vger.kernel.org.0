Return-Path: <ceph-devel+bounces-3921-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 48A42C302BA
	for <lists+ceph-devel@lfdr.de>; Tue, 04 Nov 2025 10:08:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40CE43AAE93
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Nov 2025 09:03:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 515E472605;
	Tue,  4 Nov 2025 09:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MLYsQD/x"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA32277011
	for <ceph-devel@vger.kernel.org>; Tue,  4 Nov 2025 09:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762247012; cv=none; b=SpEsC13UdiS+WsLy1drhPT7lJGzVqT6WRBBn6b/byAVj1v76wPz9Lc5xIuLgTZ7kxjEAocGeLZtSxrtE3Ff3DaBbevdpd1pAsvO5bD5ntAU0WMFpSxQo+QYMf+q/DRoYOAcaDwMSzC4vD3Y9tNQ3oapuhK4YNCiUm4j9XfX+tzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762247012; c=relaxed/simple;
	bh=9lxtNYjj4jYTq+uB3ZgnfzrzgEkVeMIER5czZKEczLE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uJ6hVJ8ZdoSuVJc5qIFSzwusrHJsN/1wkVfA2YaEY7iVPaJgq//CZWpZwS2ID71AMRpTjymWmOgLATKjXmEIpmopZBdNnpNBQ2W5ug3bATupzxoyjK5gRJeHCpBxnU0eykU3L070hhRHEFUj0dSfWUpaohKlaoymjM8/WnQ133M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MLYsQD/x; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-429bcddad32so3057613f8f.3
        for <ceph-devel@vger.kernel.org>; Tue, 04 Nov 2025 01:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762247009; x=1762851809; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zo+v+I4+4hNzyEdpTLX3lyu2mUDwsgwys0xGnDbMc1Y=;
        b=MLYsQD/xlgQRerOg/DP07fYRJYoH/WN1ESHJnKt5JkpP9kLla2malTOB6vFE9OSpLD
         WJCKkw3twTeCMbSBQVBekOaRz1rLqSapxnkmdZSJcDC3Xe7pC2SrB419g1BZ5Wbzyuy6
         RR9xt82e6hZGcz7Mxfo9bze/iAgKf8cqKPJo6Z4oS7NQA4iPxLR4fnTsB3pb1jhHKddi
         l7XSm3R5LCa3gD6kgsq8ziYEcOh/qgQsJkukJUjkWynhF1LUvNF1l28Earw8LOdGXg90
         ctZ6OL3UfBjgaIOJEFOXyw+RDLJtwXw4b6P6gMz4gJcg6J7fIxLYesqKO25SsH0OCoNk
         1vLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762247009; x=1762851809;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zo+v+I4+4hNzyEdpTLX3lyu2mUDwsgwys0xGnDbMc1Y=;
        b=F531u96CGNCs4Ba+uCrIqzA7aXJ/i0TQi7SVji2Tjzh7kx4Z+ysZUYoQFAWQGMptZB
         KFQFgHGdkBNHpy09U0+SL33GBmpyJIvlDDKtDAJgHvpPPOFi7zlLxecp14Mc8tFhqL9Z
         JoEvIrApN9F9OLCpBEsoAnLPWHst4OWoS74SsSSHOHLcuiy/uirLAymLuOW+4rNgb8vb
         c7zg3h//cdf8tI/jhiVxAZqvBeg9omEzrrtZgi0+QdR7U6BmhiFSeb+ZTGyAHAfF6AGP
         ieV1J92paHeSHQN+fZ59wfw+iaUAl6gbqVDslz4FWGpRbaJ3P93sGQg4dp7A+YIUVauL
         6wsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUo6KYneJkxs0GQfO/wle9wLbkYOA3GWdukpzuhbD3K/4IcVJP/iBVu690qKuuLOgGJQaTncJUN5Cll@vger.kernel.org
X-Gm-Message-State: AOJu0YxpWla/KfUNllImYZA9XYbOR3end/+xVk1uQw/wo9D3aziR53sU
	R0x3IDhfJfObqAoGTzcuvpfzYogUwqQkrSamrTDNa/pAx27nNnzHUboe
X-Gm-Gg: ASbGncsQYaCKiobBkC3DF3eRmlBeTBCKcRHP3QxDQOsJzY/IpBus3v6RJYouGVO/EF3
	6C8si2xd56/s61Il/I9JRWWVtP4xAM+210bmhKxUBsBNSUYUYybjTNCD46TeJW+1EG/IJxp8NNi
	rRjidvC7cm3LiJwhgrHNixRZ6Kb1wnLAA7x6zp5sXU2IPajkxYwjLvicxZ6DjKE++6vo54JfglH
	0tlSVRkkmEY+sR3f0uA+SnWEuAd+JJmVT6DX/wPMaccb+drMQHIazmhexYrYo5pT/qjAoTLtht1
	6+5yqBe+rONYCQprGeOAC3s+n4kX/e0zlrLdDz+mLdgTG7MAatrU3M35RqS+iRBPZviiueIKwGq
	dUK26pvfN8D/LZEfvRbDyGK7YZ5+K2A7BI6TDdWgL4RLM2kPv6ThevimM6eWcvsqe+ThzzS8oy8
	gbdmDv3UQJZVHH1NiZxpJx1iQ92xgOlfLI9UTnfglJUg==
X-Google-Smtp-Source: AGHT+IFSl8Yus2hXHqquAbsHWOjt30uW3Pr+rVQvYNkob8XHiLc9RfhluHaTs0Iiu4iVjKlOwvYm9A==
X-Received: by 2002:a05:6000:2387:b0:427:6c6:4e31 with SMTP id ffacd0b85a97d-429bd681254mr13032111f8f.22.1762247008372;
        Tue, 04 Nov 2025 01:03:28 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc18efb3sm3529487f8f.3.2025.11.04.01.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 01:03:27 -0800 (PST)
Date: Tue, 4 Nov 2025 09:03:26 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>, Guan-Chun Wu
 <409411716@gms.tku.edu.tw>, Andrew Morton <akpm@linux-foundation.org>,
 ebiggers@kernel.org, tytso@mit.edu, jaegeuk@kernel.org, xiubli@redhat.com,
 idryomov@gmail.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de,
 sagi@grimberg.me, home7438072@gmail.com, linux-nvme@lists.infradead.org,
 linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/6] lib/base64: add generic encoder/decoder, migrate
 users
Message-ID: <20251104090326.2040fa75@pumpkin>
In-Reply-To: <aQiM7OWWM0dXTT0J@google.com>
References: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
	<20251031210947.1d2b028da88ef526aebd890d@linux-foundation.org>
	<aQiC4zrtXobieAUm@black.igk.intel.com>
	<aQiM7OWWM0dXTT0J@google.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 3 Nov 2025 19:07:24 +0800
Kuan-Wei Chiu <visitorckw@gmail.com> wrote:

> +Cc David
> 
> Hi Guan-Chun,
> 
> If we need to respin this series, please Cc David when sending the next
> version.
> 
> On Mon, Nov 03, 2025 at 11:24:35AM +0100, Andy Shevchenko wrote:
...
> Hi David,
> 
> Since I believe many people test and care about W=1 builds, I think we
> need to find another way to avoid this warning? Perhaps we could
> consider what you suggested:
> 
> #define BASE64_REV_INIT(val_plus, val_comma, val_minus, val_slash, val_under) { \
> 	[ 0 ... '+'-1 ] = -1, \
> 	[ '+' ] = val_plus, val_comma, val_minus, -1, val_slash, \
> 	[ '0' ] = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, \
> 	[ '9'+1 ... 'A'-1 ] = -1, \
> 	[ 'A' ] = 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, \
> 		  23, 24, 25, 26, 27, 28, 28, 30, 31, 32, 33, 34, 35, \
> 	[ 'Z'+1 ... '_'-1 ] = -1, \
> 	[ '_' ] = val_under, \
> 	[ '_'+1 ... 'a'-1 ] = -1, \
> 	[ 'a' ] = 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, \
> 		  49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, \
> 	[ 'z'+1 ... 255 ] = -1 \
> }

I've a slightly better version:

#define INIT_62_63(ch, ch_62, ch_63) \
	[ ch ] = ch == ch_62 ? 62 : ch == ch_63 ? 63 : -1

#define BASE64_REV_INIT(ch_62, ch_63) { \
	[ 0 ... '0' - 6 ] = -1, \
	INIT_62_63('+', ch_62, ch_63), \
	INIT_62_63(',', ch_62, ch_63), \
	INIT_62_63('-', ch_62, ch_63), \
	INIT_62_63('.', ch_62, ch_63), \
	INIT_62_63('/', ch_62, ch_63), \
	[ '0' ] = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, \
	[ '9' + 1 ... 'A' - 1 ] = -1, \
	[ 'A' ] = 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, \
		  23, 24, 25, 26, 27, 28, 28, 30, 31, 32, 33, 34, 35, \
	[ 'Z' + 1 ... '_' - 1 ] = -1, \
	INIT_62_63('_', ch_62, ch_63), \
	[ '_' + 1 ... 'a' - 1 ] = -1, \
	[ 'a' ] = 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, \
		  49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, \
	[ 'z' + 1 ... 255 ] = -1 \
}

that only requires that INIT_62_63() be used for all the characters
that are used for 62 and 63 - it can be used for extra ones (eg '.').
If some code wants to use different characters; the -1 need replacing
with INIT_62_63() but nothing else has to be changed.

I used '0' - 6 (rather than '+' - 1 - or any other expression for 0x2a)
to (possibly) make the table obviously correct without referring to the
ascii code table.

	David




