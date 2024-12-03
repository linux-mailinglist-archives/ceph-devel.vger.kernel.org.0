Return-Path: <ceph-devel+bounces-2238-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36FD39E28AA
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Dec 2024 18:06:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACE88165788
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Dec 2024 17:06:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F8461FA150;
	Tue,  3 Dec 2024 17:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=riscstar-com.20230601.gappssmtp.com header.i=@riscstar-com.20230601.gappssmtp.com header.b="skKCDx1u"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4343F1F9EAB
	for <ceph-devel@vger.kernel.org>; Tue,  3 Dec 2024 17:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733245614; cv=none; b=asE1jVdrsOiA95CfUzMvoiJfnEi8RQ0ISTjNt05hk4jTmNZRjGtmd/+73xxwKSk82QS7Nj9+L8tiJAL7Vc4Lbxdiok3hARWNI96wrJTSV1OGhHKGAwkaU0NgkwelTBf37svXPtVMDE0ymWMJnv80O+chv2UkmI9HQ1Ilu33KmAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733245614; c=relaxed/simple;
	bh=0XoWssJ6y6p9XSwLV0zjPrXW3FLwRAmKMq6Y5HqQAsk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ttru57Q9A7Y19W7gPgvZo8wbEtCzVFdpZDoVQ7J0EnlnukChntw/LMCv7Jtfk7fVfoHWt/kMlAdYeXZBTYPNlvx41jnfVtjVhY6KIEQzrf3fX7m6ZdNVk7xRHXDLpwJ3NBKbTluA9CqHg99mLvwlo6WxVYfLO92j/qD1DNRKLq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=riscstar.com; spf=pass smtp.mailfrom=riscstar.com; dkim=pass (2048-bit key) header.d=riscstar-com.20230601.gappssmtp.com header.i=@riscstar-com.20230601.gappssmtp.com header.b=skKCDx1u; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=riscstar.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riscstar.com
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-843671e1426so197082339f.0
        for <ceph-devel@vger.kernel.org>; Tue, 03 Dec 2024 09:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=riscstar-com.20230601.gappssmtp.com; s=20230601; t=1733245611; x=1733850411; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Auzl9x2fi87FFx1qgQfRqwYzhPEi6BaSaoSaUWxRHgU=;
        b=skKCDx1u3jAzRwADFHnKj7+M5/cBbV9vT+ixpqskT1Q9u2w18agUosmTN5r/NFxaqC
         lJ6mJiErxMeaUzXI7Q6+6Y2eRRgrZhbM1Xqv+yzPJWJD1wfH7UW6TBy1mdDTgEmLsO9l
         NacQGncW4qXTu8hxx3wMPonX4fCwmDf8j/eQZqt57DE6bG0XdbX37Zh5d1+7jvTuej1m
         pWn9tLLnBeMdWjwEvvfX9c/t9KMA9fbOYqJFWY3OSO5wPQCNPPUj2HCUriv+/kqGVhmT
         QhE/rqlnpP60XZ5RdZYzwo0PRwD8fixUQRiK+8kuRsxJZ1GssmoH1O0rP/+vIGWrQqHs
         CI3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733245611; x=1733850411;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Auzl9x2fi87FFx1qgQfRqwYzhPEi6BaSaoSaUWxRHgU=;
        b=UzoIq4W8eYLH1zwJP4zYTYvL1WnYlZnYav9ULAKEeFoUhXjcbFjmBUo4RrIGFQIBj7
         lx7yYthS7xSAalFjA/4+qi7mX/v1fEdkdHA5JmBPdyEkpIi4CkYpetxPjKwo6hQg588E
         Uql2UHdMiXvvhrNJSJyY2sH/dPe6rr9Kb/DbWRvnAlRY+AZVb9P1+stjPIiZBIQzVRRV
         HPEeOg+qgYMkQjZSeuZKgsf9DM5GcAaFw7bWXS459eWUDP5Wp2PyCz3l99n9ymK4cWFf
         BtiX+LngVEVTe65xtBELY9YejQq0JICg/exxteCLovOJUc5r2ze/NLzw+zwGbQm90wJv
         9bOw==
X-Gm-Message-State: AOJu0YzbtDlfIegcFl7DxchS/rqhO+4wp5f/m/eKF0Oxa6lp5cawkMrE
	v3d4eZnkIT5enN/ewNmuWLNHl7mA5g1XrzMwYdvvKO/fV/lAz1p2T+4qXs4GTNUA4r2Dn69OXi8
	+wMI=
X-Gm-Gg: ASbGnctggk9Or2NKT2UAIF95EbUxHNlQb8MqIPQ1ERfRxSL2Uwp6x4BjVvQdVilZVwN
	MiaVcDOb4YPwE9aar/6jb75snZZ+2EuPMDoCWharw4A+eesNF0ixovkkluFCmSMF9p/+0Lz1wbX
	9og9O6oqQeCkR5SL0QuY8rHFOwKeFjJ3GEqMWn31D2KFDMREIeBbuH2M8G9XNYDlMBxpPZ/FDV7
	45GgWtWEF3J+PCjkItmlfvFt2RxWhqpZ+UyP8+O0A3YKu6Fr4y0Wu0Gdso0WDOyyb5LE1RhYM6F
	cw8YQoJSF/3ASQ==
X-Google-Smtp-Source: AGHT+IEIP7qkIbojuqBeX0iktSHOwIaA5dYMIB3T16B9Rnjv4CuXO5NVd4O0/Rjr/HQA75lPKyxHOA==
X-Received: by 2002:a05:6602:27c9:b0:837:7d54:acf1 with SMTP id ca18e2360f4ac-8445b53e7e1mr498524439f.2.1733245611248;
        Tue, 03 Dec 2024 09:06:51 -0800 (PST)
Received: from [172.22.22.28] (c-73-228-159-35.hsd1.mn.comcast.net. [73.228.159.35])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-84405f97c0asm263759439f.32.2024.12.03.09.06.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 09:06:50 -0800 (PST)
Message-ID: <d75b6bb5-f960-4e75-90f3-e7246a2cd295@riscstar.com>
Date: Tue, 3 Dec 2024 11:06:50 -0600
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] ceph: decode interval_sets for delegated inos
To: Dan Carpenter <dan.carpenter@linaro.org>, Jeff Layton <jlayton@kernel.org>
Cc: ceph-devel@vger.kernel.org
References: <e660f348-5a0e-486d-8bae-e6c229f0e047@stanley.mountain>
Content-Language: en-US
From: Alex Elder <elder@riscstar.com>
In-Reply-To: <e660f348-5a0e-486d-8bae-e6c229f0e047@stanley.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/24 2:19 AM, Dan Carpenter wrote:
> Hello Jeff Layton,
> 
> Commit d48464878708 ("ceph: decode interval_sets for delegated inos")
> from Nov 15, 2019 (linux-next), leads to the following Smatch static
> checker warning:
> 
> 	fs/ceph/mds_client.c:644 ceph_parse_deleg_inos()
> 	warn: potential user controlled sizeof overflow 'sets * 2 * 8' '0-u32max * 8'
> 
> fs/ceph/mds_client.c
>      637 static int ceph_parse_deleg_inos(void **p, void *end,
>      638                                  struct ceph_mds_session *s)
>      639 {
>      640         u32 sets;
>      641
>      642         ceph_decode_32_safe(p, end, sets, bad);
>                                              ^^^^
> set to user data here.
> 
>      643         if (sets)
> --> 644                 ceph_decode_skip_n(p, end, sets * 2 * sizeof(__le64), bad);
>                                                     ^^^^^^^^^^^^^^^^^^^^^^^^^
> This is safe on 64bit but on 32bit systems it can integer overflow/wrap.

So the point of this is that "sets" is u32, and because that is
multiplied by 16 when passed to ceph_decode_skip_n(), the result
could exceed 32 bits?  I.e., would this address it?

	if (sets) {
	    size_t scale = 2 * sizeof(__le64);

	    if (sets < SIZE_MAX / scale)
		ceph_decode_skip_n(p, end, sets * scale, bad);
	    else
		goto bad;
	}

					-Alex


>      645         return 0;
>      646 bad:
>      647         return -EIO;
>      648 }
>      649
>      650 u64 ceph_get_deleg_ino(struct ceph_mds_session *s)
>      651 {
>      652         return 0;
>      653 }
>      654
> 
> regards,
> dan carpenter
> 


