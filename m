Return-Path: <ceph-devel+bounces-3602-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28501B559C4
	for <lists+ceph-devel@lfdr.de>; Sat, 13 Sep 2025 00:55:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BE9D3BB79C
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Sep 2025 22:55:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E4C6276038;
	Fri, 12 Sep 2025 22:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="le6rxRkY"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A82264A9E
	for <ceph-devel@vger.kernel.org>; Fri, 12 Sep 2025 22:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757717726; cv=none; b=dtE20YkJfaXiCWbe001dqUExxQRRhRGL2qfn4EahizzThtdJOnw4vE9KIC3SFwqrA38g60PovDEcnmSmDFfSzG1n9wmSiM7zyKuQjpN25MXInzQ/vlRGy7U67oJwNyDWmoHKDHVmiEczEcm7DpUnAO86dRNLT38OBL3URirQNs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757717726; c=relaxed/simple;
	bh=L9Ix8GUAXAZWYXV2ZEQHnHNqbdKz5TayVfN6Teb85ss=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pk4xukashhCwNMCZboLQ6ScTqWD5sEWO8z/z4S+oCwSV75fM2F6V/nz5s2GDvdQsqQuYrTiWFFllT5SqvgFZPbRS7tUiwvWpdnMwyrHk7Gm/bgMPxgeCXS+7GuVFTTyjEVtswuirOBA7kxIYRfSjkmzkFVqJm56q0144N62mfCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=le6rxRkY; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3df35a67434so1491216f8f.3
        for <ceph-devel@vger.kernel.org>; Fri, 12 Sep 2025 15:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757717723; x=1758322523; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bQQq41SVVRbn6631nZmi56Z4Of+AjJI4UHPGihR3J2Q=;
        b=le6rxRkYFJCluBSRJ5bFdNxLycE62jaB7IC6Y+ZNBZ3hCHwxODhDl+vMJGRbQTkLf2
         jtUPMkQmuzlyjB3Xc0TJeKvvL3dQZPXlEsreZCDRVXDNSepa4/CCscwzQgpiAmG5znH6
         zlmE/AhRlOMPCkTsRq+GfPvKBFtVFuZyrK34NfjDaTa9yGcBhKWnGQq9OtiPi1Ah3Z9O
         w6k7ZZcP06YHQ875NaAATBhbIwivqDa5b2ECvv/+jbviX2qHUQavfbWZxIqXrjDu4QBo
         MbMThUUZ6Q3FHxpzO5rLfWsU81BjeeSFJnAMBKBLlcVgkvzamYPVKGsXvBWliPbGagn5
         tuWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757717723; x=1758322523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bQQq41SVVRbn6631nZmi56Z4Of+AjJI4UHPGihR3J2Q=;
        b=FjxupPfhqy8LuBRwEDOLTCD73T/dbtthfcH5OvcLtsx1HI7XqOUMqjRpKX5WVtUS9V
         B+BqRTomGuNGe+X61T09asptz0hBRMyhqKwfJDl03E+2qgDknCHt/iZTg6Egd2//xsK4
         GXaq6AOKw91fRMBpIWgn+wEX0ZdB+eRaAWAxRxTHCA2TCtvagXfGk6Y7hFQNeXQ1UTFl
         icsPjdImKPiD6XcWvczffTKFKEaUYwv48Jfr+Ty+iG0v/8AXgk7EB/1i0w0J0UKzPMaW
         copqYLWW2np6HmdRf7rs41UdrJkxr1BXkZTOMx3Em78vyCgax+v1IjH3vFMP+Hpwtq2k
         Kiiw==
X-Forwarded-Encrypted: i=1; AJvYcCUYCWGtJqR2RmxPV0JVxtbf0s69cugx6tn8cX3kXHZP6BF1ucrapolS51WHd9fRUSnlOok+O5dYO+Hb@vger.kernel.org
X-Gm-Message-State: AOJu0YyZJgDEkR+gIS6XDyF9eY4KM6+7cx4FugWlCw7grmR7BtX7rRtb
	llxtV20qrpH3qE/9oG/tVRgNibgjHlP1QHOy23+QLDcKMQtcZ3lWUaFa
X-Gm-Gg: ASbGncviiuiaAFIpZ4+zCiclJLt/LZnQfxq22vO82m/yxQBHPnDy3yM/DqwR8JmhXzS
	X1u+gBWkY+qoV0xpy7vZAR5VIdJGE+mIiiyiSMeaOKdnjytQ+LnZ4Rf0Aj8jCYF+NQ3Pmy+tOBt
	DKG5j/Jb6lH6NXaAffT7KDqsGGHTEJtbmBtS2OT9Y4/1383aX481ppTVcaeOpogDhtRxIu0vjPN
	NeeiGoFpmxGOdWt7dUfY2U7RH4sLDkXLUmJ3Srqs/U05+3lttVjitXpTc15hlQpN3URnekk8qw8
	/M8zc9JijFlSdi6aNxsJpl1YHAdBpIDpZ694KKwh3UC/MCddzNZPdKwrolLC0I7MReWwhz01ZyX
	E2RflY7nA/eO4W1xwpqFsUw3kpkJ9V4E66/62ij+WPo2pMGtQbPQKz7EI2NT1JVpEJAAuHUSLWR
	EUZkAFNQ==
X-Google-Smtp-Source: AGHT+IHIf0xPTQSq2SGK+xjb3mFSGDk7HN3L2nA4JQ5Js7XJrtXXtnD62hWKhZUN18BtSlP72hjvRw==
X-Received: by 2002:a05:6000:420f:b0:3e5:955d:a81b with SMTP id ffacd0b85a97d-3e7659c4248mr4152680f8f.34.1757717722835;
        Fri, 12 Sep 2025 15:55:22 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e01578272sm84954695e9.9.2025.09.12.15.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 15:55:22 -0700 (PDT)
Date: Fri, 12 Sep 2025 23:54:56 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org,
 ebiggers@kernel.org, hch@lst.de, home7438072@gmail.com, idryomov@gmail.com,
 jaegeuk@kernel.org, kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v2 1/5] lib/base64: Replace strchr() for better
 performance
Message-ID: <20250912235456.6ba2c789@pumpkin>
In-Reply-To: <20250911073204.574742-1-409411716@gms.tku.edu.tw>
References: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
	<20250911073204.574742-1-409411716@gms.tku.edu.tw>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 Sep 2025 15:32:04 +0800
Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:

> From: Kuan-Wei Chiu <visitorckw@gmail.com>
> 
> The base64 decoder previously relied on strchr() to locate each
> character in the base64 table. In the worst case, this requires
> scanning all 64 entries, and even with bitwise tricks or word-sized
> comparisons, still needs up to 8 checks.
> 
> Introduce a small helper function that maps input characters directly
> to their position in the base64 table. This reduces the maximum number
> of comparisons to 5, improving decoding efficiency while keeping the
> logic straightforward.
> 
> Benchmarks on x86_64 (Intel Core i7-10700 @ 2.90GHz, averaged
> over 1000 runs, tested with KUnit):
> 
> Decode:
>  - 64B input: avg ~1530ns -> ~126ns (~12x faster)
>  - 1KB input: avg ~27726ns -> ~2003ns (~14x faster)
> 
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> ---
>  lib/base64.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/base64.c b/lib/base64.c
> index b736a7a43..9416bded2 100644
> --- a/lib/base64.c
> +++ b/lib/base64.c
> @@ -18,6 +18,21 @@
>  static const char base64_table[65] =
>  	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
>  
> +static inline const char *find_chr(const char *base64_table, char ch)
> +{
> +	if ('A' <= ch && ch <= 'Z')
> +		return base64_table + ch - 'A';
> +	if ('a' <= ch && ch <= 'z')
> +		return base64_table + 26 + ch - 'a';
> +	if ('0' <= ch && ch <= '9')
> +		return base64_table + 26 * 2 + ch - '0';
> +	if (ch == base64_table[26 * 2 + 10])
> +		return base64_table + 26 * 2 + 10;
> +	if (ch == base64_table[26 * 2 + 10 + 1])
> +		return base64_table + 26 * 2 + 10 + 1;
> +	return NULL;
> +}

That's still going to be really horrible with random data.
You'll get a lot of mispredicted branch penalties.
I think they are about 20 clocks each on my Zen-5.
A 256 byte lookup table might be better.
However if you assume ascii then 'ch' can be split 3:5 bits and
the top three used to determine the valid values for the low bits
(probably using shifts of constants rather than actual arrays).
So apart from the outlying '+' and '/' (and IIRC there is a variant
that uses different characters) which can be picked up in the error
path; it ought to be possible to code with no conditionals at all.

To late at night to write (and test) an implementation.

	David




> +
>  /**
>   * base64_encode() - base64-encode some binary data
>   * @src: the binary data to encode
> @@ -78,7 +93,7 @@ int base64_decode(const char *src, int srclen, u8 *dst)
>  	u8 *bp = dst;
>  
>  	for (i = 0; i < srclen; i++) {
> -		const char *p = strchr(base64_table, src[i]);
> +		const char *p = find_chr(base64_table, src[i]);
>  
>  		if (src[i] == '=') {
>  			ac = (ac << 6);


