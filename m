Return-Path: <ceph-devel+bounces-3751-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C0B00BA7678
	for <lists+ceph-devel@lfdr.de>; Sun, 28 Sep 2025 20:57:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C5753B6662
	for <lists+ceph-devel@lfdr.de>; Sun, 28 Sep 2025 18:57:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53A8A238D32;
	Sun, 28 Sep 2025 18:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q9GL2V4j"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8201D9A5F
	for <ceph-devel@vger.kernel.org>; Sun, 28 Sep 2025 18:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085862; cv=none; b=Eqifsd0rqlrc3mKu1rEySPY8Ta/zrfCLJkWVcXQIuxWvKJPxUYiuFa6ybU+WJ/2ubWgZ4Hlf/6OpgsLvS3c8n9PrV6XuCFzt/gAqmNJeugy1Pssj/qffzTpnCmdB0rUFacNso2McEvu+S9dQ5mfeVzMnEMqwfx41zQPZcDldU/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085862; c=relaxed/simple;
	bh=ODBJzFhKiIsXXG5/GMJYfh0owtM2QlHLhb+LFU0LClY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ot5taEc5gWjWIT2vWTRD1r0rsWZp8n3Jrd/9mXp8sAQEbMMxYNGGT+G2jkXiFgpHfOm+rp+VhYW9mTxdNtlZXs9qNnd+YxcRgVd+7JFMnBJ6UzU9h+p0nkeuBvAA5QiAQGIocVa2+mXOSsWagaLhDJYG5aXDMbE8H2KKMoGbYCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q9GL2V4j; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e42deffa8so25698545e9.0
        for <ceph-devel@vger.kernel.org>; Sun, 28 Sep 2025 11:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759085859; x=1759690659; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zmGgp8LZB8H7aPG6SX5XQzX0Iik7pnp4RAkYSd2NXzI=;
        b=Q9GL2V4jKB5V+gexC4MKH9kQpcSbZ+02RVLZFXBu7l4rC6dslLO03SHeisaFGl+oG5
         ObF6iSIN33pjcSQuURCOW5eL0C2bCv5x35xS+1riA4dBaFTZ5/m5lGkefWTz1lGrF4Pm
         4VUqeFpgOxMtjxn4ZXSvOPirmfTXCJH8xfmvRV3hdvfrv80aLcAuW9EXSG1FzQNbduTB
         SqgAamI9zyWLLXgltdKR8RzAyc9VtPjv2oB1dKmFs/GdTffDKGDLBdAMGO2psQ+IJVYc
         WJSFD6U/X8cypGckMw4Aq4ozkbCQBn+Kw9kot/ofKHTzW4uRXE/HF2tYVKJU02KuTWQM
         5hPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759085859; x=1759690659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zmGgp8LZB8H7aPG6SX5XQzX0Iik7pnp4RAkYSd2NXzI=;
        b=iecWriT+TkEAQbD9G4NLFlgGkeESq6patyKRJ+URLme513g0ZWm3sdg+BeXZBlyrZT
         PYDPfLDXvJHp5JTKPIgmEMWiOUnN/k+qpEytFLM0IlXHudveZhkvYiDAo18yAc2YISXX
         oo2h0zlivfrP4GpNM81ug4DBe73VFZGvGSoIPuoZiy3IgoSc+jGKZm4lUILCeWonnZvk
         QEP7vk9ceVZQzkfQ90frXbCLdqaG1IuGXEIVJTSg36D3vHhEYh4NcplNbtM4TBfI0v4m
         dVEufMjR7vII/4zgjgxBjBuupCFemJQSgH5kX4MdW29HGHcSviox2d1TBS2YzvDUq4fe
         GFqg==
X-Forwarded-Encrypted: i=1; AJvYcCVFV6gdLnQoQq8Rzn3CHUzXZGJeWXaadYqqCtTvF0YQaqVzhjN2ctIwujlRImfro3gyHRi0LzVoInmQ@vger.kernel.org
X-Gm-Message-State: AOJu0YxVd54vPyO3qhQ0KDxGEzRC6Psl1IUojKVJXL6nFrPDRC3rckTi
	IAfppgrr+NHVL1USyhsN8Qcm2ry3ho22kIpjuoLaxSy8IsMlcq1oj3Qe
X-Gm-Gg: ASbGncsr2VGLHoOISTv2oJCi3aNVPuk4cEkaBko6DLUO6ZjQ2xmtzIcyQTFpU9sEe+e
	JxnXGhKSvHJCJaeyw84Gw5dExR5RTEXsTzR1QbdXfReSQb6ZqFiVMeNYsjIhm2C3w1wH9RwCBIB
	5r+ZWJzn/U2bK4uJSVf90p+GhbBpB8hbdzJIVFxZ/EDTeJem1Hft4WcLiLbQOkSTu38fpoWS67T
	KaLKYgSK+vtcJW/ZhuyOPwtj3XJrbM2fclMVZL9FnApWYHPBjNjD/NpeHmBa4icQYvscylraM0A
	HkVnk4JP264PD5rLYZSA5V8tUUp4rOuLEU0ToafEn/I3TFge+co4CxgpggpUyRIs4Pf+ZzwuoBb
	wI1fLjNZ2BhAbx9MqaF7SEk95qsC5rIa2WnCw5qIeLKpL63dw8O3suWGYnPN4goSscVZWS1SW7Q
	Q=
X-Google-Smtp-Source: AGHT+IFdXSUmu1jDu9C+PMSkYOzc5SUURLTfRIaH+ROSnCKAviW3HCbfr6MunNZeaSZVBZNwp+b1tQ==
X-Received: by 2002:a05:600c:4508:b0:46e:3e72:a56 with SMTP id 5b1f17b1804b1-46e3e720b94mr81111745e9.1.1759085858562;
        Sun, 28 Sep 2025 11:57:38 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a9ac5basm222579525e9.7.2025.09.28.11.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 11:57:38 -0700 (PDT)
Date: Sun, 28 Sep 2025 19:57:36 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org,
 ebiggers@kernel.org, hch@lst.de, home7438072@gmail.com, idryomov@gmail.com,
 jaegeuk@kernel.org, kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v3 2/6] lib/base64: Optimize base64_decode() with
 reverse lookup tables
Message-ID: <20250928195736.71bec9ae@pumpkin>
In-Reply-To: <20250926065556.14250-1-409411716@gms.tku.edu.tw>
References: <20250926065235.13623-1-409411716@gms.tku.edu.tw>
	<20250926065556.14250-1-409411716@gms.tku.edu.tw>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 Sep 2025 14:55:56 +0800
Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:

> From: Kuan-Wei Chiu <visitorckw@gmail.com>
> 
> Replace the use of strchr() in base64_decode() with precomputed reverse
> lookup tables for each variant. This avoids repeated string scans and
> improves performance. Use -1 in the tables to mark invalid characters.
> 
> Decode:
>   64B   ~1530ns  ->  ~75ns    (~20.4x)
>   1KB  ~27726ns  -> ~1165ns   (~23.8x)
> 
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> ---
>  lib/base64.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 61 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/base64.c b/lib/base64.c
> index 1af557785..b20fdf168 100644
> --- a/lib/base64.c
> +++ b/lib/base64.c
> @@ -21,6 +21,63 @@ static const char base64_tables[][65] = {
>  	[BASE64_IMAP] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,",
>  };
>  
> +static const s8 base64_rev_tables[][256] = {
> +	[BASE64_STD] = {
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  -1,  -1,  -1,  63,
> +	 52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,
> +	 15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,
> +	 41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	},

Using:
	[BASE64_STD] = {
	[0 ... 255] = -1,
	['A'] =  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12,
		13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
	['a'] = 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38,
		39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 48, 50, 51,
	['0'] = 52, 53, 54, 55, 56, 57, 58, 59, 60, 61,
	['+'] = 62,
	['/'] = 63};
would be more readable.
(Assuming no one has turned on a warning that stops you defaulting the entries to -1.)

The is also definitely scope for a #define to common things up.
Even if it has to have the values for all the 5 special characters (-1 if not used)
rather than the characters for 62 and 63.

	David

> +	[BASE64_URLSAFE] = {
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  -1,  -1,
> +	 52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,
> +	 15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1,  -1,  -1,  63,
> +	 -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,
> +	 41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	},
> +	[BASE64_IMAP] = {
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  63,  -1,  -1,  -1,
> +	 52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,
> +	 15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,
> +	 41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	},
> +};
> +
>  /**
>   * base64_encode() - Base64-encode some binary data
>   * @src: the binary data to encode
> @@ -82,11 +139,9 @@ int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base6
>  	int bits = 0;
>  	int i;
>  	u8 *bp = dst;
> -	const char *base64_table = base64_tables[variant];
> +	s8 ch;
>  
>  	for (i = 0; i < srclen; i++) {
> -		const char *p = strchr(base64_table, src[i]);
> -
>  		if (src[i] == '=') {
>  			ac = (ac << 6);
>  			bits += 6;
> @@ -94,9 +149,10 @@ int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base6
>  				bits -= 8;
>  			continue;
>  		}
> -		if (p == NULL || src[i] == 0)
> +		ch = base64_rev_tables[variant][(u8)src[i]];
> +		if (ch == -1)
>  			return -1;
> -		ac = (ac << 6) | (p - base64_table);
> +		ac = (ac << 6) | ch;
>  		bits += 6;
>  		if (bits >= 8) {
>  			bits -= 8;


