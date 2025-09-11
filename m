Return-Path: <ceph-devel+bounces-3589-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30894B53BC3
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Sep 2025 20:44:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5BD15A0C3D
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Sep 2025 18:44:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC6192DC77E;
	Thu, 11 Sep 2025 18:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VQgqIXNq"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251BB2DC772
	for <ceph-devel@vger.kernel.org>; Thu, 11 Sep 2025 18:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757616287; cv=none; b=byPzPilyAdRcKECwwl/VbZizke2XXN+BN1tr245hPPV8nIuG86O9G7z4ntOQvUZUKRSttHm9v3Z51LrynlN/J+T8mI7sCF+5NqjK619K1Cj9M7bAqXsMTFUOtPtvBoTTPflxOITfJCqUW5i2Bzrz30ELAp/ol1JOIFH2rNItye0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757616287; c=relaxed/simple;
	bh=nekUaG33fEAWzybEqGTfbDRvFa0BGk/CASa1SijE7r0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bqHf54sG+pTpfi5hQfMzzAZAqojvAc0Z+jZQbei8VeUyJ9JQt4TG+V0w4g0iPSZw1KhQPnCL8t34Hv966PKvv0DIhFKnS9gMlbZsO+S3ARc2r9+YOOVpsV/KzPoVE0mOJCRTQbD6Y5ik5bjYAortIxq1f28rmvFFoj/R6fO9RmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VQgqIXNq; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-76e4fc419a9so956019b3a.0
        for <ceph-devel@vger.kernel.org>; Thu, 11 Sep 2025 11:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757616285; x=1758221085; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tWvv0dO99lFH0+UcixSCK2Xe0maLZGpO3NhcPA2OOyE=;
        b=VQgqIXNq02ps/XAcfW5EMqPa0rLjkD10NOw+RU4yyJ949etBAtEMjOISNLTdwhnPBL
         zCn/VwBT+6ggoWmwU2UQNK2RMK+me6Ce3Kl2s4MzbIuv2V0xnLOTZLbOhv0lHy9UpGc1
         FQQ2Zb10KZgtQ94EOpnewzD8elZPQAwDmSqUzU8lTqZ71gk28HXaCPTD8UR8j1xrB93E
         nDXBRtbMRoPVB+GDcGhSDHd4vjjncP29TYlHkENRNxZBOSo+rvHvLxw8QAmlHlFFLWrD
         b/o+3xwi/C8tAfYjksg6bmyA3mGDnPltFHmdBb/HkU/wFTRFL+DskhH+s7SWgi1GA4kI
         t2/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757616285; x=1758221085;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tWvv0dO99lFH0+UcixSCK2Xe0maLZGpO3NhcPA2OOyE=;
        b=SEzo4mfWYQz3Br0loTf+OOe02MmbEdFzNkuszaKJoZtmR+cGmmtR4YNRpf1AhwktS5
         mMu5k6Yzr+iQYGdJ+RL4XLzPBBC2f2AKGJ/8rUE/0adDQCkKfXpqRpNPuPgZni+5c6Vk
         IqmU81cZ2gAVEBgChWOZiZ7nRMRuwcf2YX7LrCd5p4LdVIrrrrJWCJI5f1hxqzhxg3lH
         rd+2B6VC1jSR4lA9uOdnQlhYr8gIVeomvCDvJNd/U9Y/4s8acd7DNUIojX7u69TTiPnj
         7ZcXBLLirXlIxX1iTU4/PzP8pKd/mZz0QtfvNsT8/inh2Ik4ulI/GFqZwV2k196xJOWI
         h3NA==
X-Forwarded-Encrypted: i=1; AJvYcCUnx7DWoAE0muY8RlaudjmdIJbNV+OHmuU8aqxlWTwpUfdxRHC0JxLyLLuYutL+qx6n9D7NKwOF5K5E@vger.kernel.org
X-Gm-Message-State: AOJu0YxzKzPgOLe5bqX+sBiqQiCtevZyqxk57JqN7xN52XOVAQRinaL3
	J4QY6supwdMgvwgmfLfstkPX9/BxfYlRxd/I5ts6BSxbrs037Jyzk6rF
X-Gm-Gg: ASbGncudHlglzWfX8SUtXNLJCEDytC+T0piQciJfmyRsrSF2gegtyS9yv2G3FGaSycU
	zEPvix7OU8ecTeoV/QHRDbOcsIUSd8chtXfWUVLT8A/gBTk1CZx+pI05JlozaNNK9aaFhgTtK+m
	JGwRqejxDGtDeaNuKHOZiK6zxVJYGcLdNCypV8wtiCcCx1vpxx0SenNJNlT7+PJ7CDVhIYm8WwI
	EF069ODCXAb6Kmy9xrHlI3YzyCCMhIAzoybXfwdZdu0OmpX5e81HwUdScLlXx02vFOqndYCBPZv
	W/oHdwqK3oM9RxoPDnGaTusgZhC9ZvpSHTPswIXYD5nCq/7ohAsrzxb+l68ysznAdlhI6d4n3qN
	xam5XOTsb6e+SmQwGiAuA2X+X/fNbM52C663AeLM7PEAzvqL/ptxsFAeyHDta
X-Google-Smtp-Source: AGHT+IFKDe0caW6LVNj4UrcnbNbED3hTtYmCrg74uCtGPOQ9WMmIh1BkKDM+jjzJW+4ZpB3MwiOPTg==
X-Received: by 2002:a05:6a20:3d83:b0:24d:56d5:3681 with SMTP id adf61e73a8af0-2602a3a6eb3mr386297637.7.1757616285443;
        Thu, 11 Sep 2025 11:44:45 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77607b331e4sm2760887b3a.70.2025.09.11.11.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 11:44:45 -0700 (PDT)
Date: Fri, 12 Sep 2025 02:44:41 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Guan-Chun Wu <409411716@gms.tku.edu.tw>, akpm@linux-foundation.org,
	axboe@kernel.dk, ceph-devel@vger.kernel.org, hch@lst.de,
	home7438072@gmail.com, idryomov@gmail.com, jaegeuk@kernel.org,
	kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	sagi@grimberg.me, tytso@mit.edu, xiubli@redhat.com
Subject: Re: [PATCH v2 1/5] lib/base64: Replace strchr() for better
 performance
Message-ID: <aMMYmfVfmkm7Ei+6@visitorckw-System-Product-Name>
References: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
 <20250911073204.574742-1-409411716@gms.tku.edu.tw>
 <20250911181418.GB1376@sol>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250911181418.GB1376@sol>

Hi Eric,

On Thu, Sep 11, 2025 at 11:14:18AM -0700, Eric Biggers wrote:
> On Thu, Sep 11, 2025 at 03:32:04PM +0800, Guan-Chun Wu wrote:
> > From: Kuan-Wei Chiu <visitorckw@gmail.com>
> > 
> > The base64 decoder previously relied on strchr() to locate each
> > character in the base64 table. In the worst case, this requires
> > scanning all 64 entries, and even with bitwise tricks or word-sized
> > comparisons, still needs up to 8 checks.
> > 
> > Introduce a small helper function that maps input characters directly
> > to their position in the base64 table. This reduces the maximum number
> > of comparisons to 5, improving decoding efficiency while keeping the
> > logic straightforward.
> > 
> > Benchmarks on x86_64 (Intel Core i7-10700 @ 2.90GHz, averaged
> > over 1000 runs, tested with KUnit):
> > 
> > Decode:
> >  - 64B input: avg ~1530ns -> ~126ns (~12x faster)
> >  - 1KB input: avg ~27726ns -> ~2003ns (~14x faster)
> > 
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > ---
> >  lib/base64.c | 17 ++++++++++++++++-
> >  1 file changed, 16 insertions(+), 1 deletion(-)
> > 
> > diff --git a/lib/base64.c b/lib/base64.c
> > index b736a7a43..9416bded2 100644
> > --- a/lib/base64.c
> > +++ b/lib/base64.c
> > @@ -18,6 +18,21 @@
> >  static const char base64_table[65] =
> >  	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
> >  
> > +static inline const char *find_chr(const char *base64_table, char ch)
> > +{
> > +	if ('A' <= ch && ch <= 'Z')
> > +		return base64_table + ch - 'A';
> > +	if ('a' <= ch && ch <= 'z')
> > +		return base64_table + 26 + ch - 'a';
> > +	if ('0' <= ch && ch <= '9')
> > +		return base64_table + 26 * 2 + ch - '0';
> > +	if (ch == base64_table[26 * 2 + 10])
> > +		return base64_table + 26 * 2 + 10;
> > +	if (ch == base64_table[26 * 2 + 10 + 1])
> > +		return base64_table + 26 * 2 + 10 + 1;
> > +	return NULL;
> > +}
> > +
> >  /**
> >   * base64_encode() - base64-encode some binary data
> >   * @src: the binary data to encode
> > @@ -78,7 +93,7 @@ int base64_decode(const char *src, int srclen, u8 *dst)
> >  	u8 *bp = dst;
> >  
> >  	for (i = 0; i < srclen; i++) {
> > -		const char *p = strchr(base64_table, src[i]);
> > +		const char *p = find_chr(base64_table, src[i]);
> >  
> >  		if (src[i] == '=') {
> >  			ac = (ac << 6);
> 
> But this makes the contents of base64_table no longer be used, except
> for entries 62 and 63.  So this patch doesn't make sense.  Either we
> should actually use base64_table, or we should remove base64_table and
> do the mapping entirely in code.
> 
For base64_decode(), you're right. After this patch it only uses the last
two entries of base64_table. However, base64_encode() still makes use of
the entire table.

I'm a bit unsure why it would be unacceptable if only one of the two
functions relies on the full base64 table.

Regards,
Kuan-Wei


