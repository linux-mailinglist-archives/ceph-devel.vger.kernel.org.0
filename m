Return-Path: <ceph-devel+bounces-3053-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AC30ABE15B
	for <lists+ceph-devel@lfdr.de>; Tue, 20 May 2025 18:56:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A69AD7B08E8
	for <lists+ceph-devel@lfdr.de>; Tue, 20 May 2025 16:55:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D184277021;
	Tue, 20 May 2025 16:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UQ8MXIB4"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2572701B6
	for <ceph-devel@vger.kernel.org>; Tue, 20 May 2025 16:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747760174; cv=none; b=eCXSNEM1CsD92HgxRT5uD3j0PUThdhRusGgKKDfR4YEoykSVhW87MagCGXLXJmnK7tagF/XsumLy3fg1WSVSBaNDyX22cGCYtZY9B02AaDhmvU4TBKJu2QuKaQKYDe6U1gdg3jBdJOU4vxc7TjYG/iMf7U0dyE/u0sWR231LQcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747760174; c=relaxed/simple;
	bh=wb9jveR8gfrm/HLOmEI3ZVUiaVgfP80NHuLXY6U2rvM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rk9yFTjQNZWVMLjWolSZ//w0x0mA5mtsV3BweISI5p2aTl2NrYruB1OOI61lArEVsGFFl9D4Po03YDRmlocKxGq4Z++O7lgKJ8vqW3cyFxA9500VWethDj9iJ6tFJJboOeEi0EuETC0HzenJuOQoER/LCBGlBxAJ8n7MKJZCd9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UQ8MXIB4; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3dc7830a386so6412145ab.1
        for <ceph-devel@vger.kernel.org>; Tue, 20 May 2025 09:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747760170; x=1748364970; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9+I4gTPT9Nr19IG2h0bYwR+TaspSdeGh5uzYNeV/gxE=;
        b=UQ8MXIB4zpYUk3VPcQfuuIS+NoTEux8yivljyuzPVnqf6JFkd3ckEmgKgF4KWQWNH7
         icZffsJpuMtgrCPymTT+TuTUNPdYUh6WPUe6WQQUMYyv4dOvtm5pYrVMXWA/FNRtkyNq
         7nVS128jCoIchq+3auu5wAFRY1E8fxyWrnsp5xwvQiC9hhAJWyniF4r8z/CErreE84XA
         ifrI3NNfqpHWL1Bufd+uEaTfZ0cA4bHWbb40dOphGOm1FscwxUECRYLNm49B903nEjQf
         kLQks2zMsgp8fRdTHw8usAZQ5zvBzVfXhpsm1/N6JvbppVJX/MYrfSaekue4lYUKCKT2
         JvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747760170; x=1748364970;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9+I4gTPT9Nr19IG2h0bYwR+TaspSdeGh5uzYNeV/gxE=;
        b=ixEF7/pIqOx37wYurULti3QEDkpGIdY2kOM/c4NKb6ew8U12SFkPtajGAGsB7pUKda
         o5b4jj9DgGjlFbFImC6OnnnnKRuE9Qd/w2x8RP6G/MdTncaePXrE/vZdAfUF1UqDAowP
         pWkRD/OA+cThNEtPKwQcgT3SMPyCis91gThuaCoKlCFOMMmFg2Bv/FM/HQDylZpo1Kd5
         eXtqQXsnb7InfjBrVB/Ibs5M7Gx/S3bV7lEBgkSPrlDFs7rJZgj2Cga7niVr4JnUfeVo
         xw5eDF9aS4VnJLJmea6SkNyPHmhkAUjp0+AyrqDqemjv+qTud7RKZzvgRX9WWsmS4t4q
         xjpg==
X-Forwarded-Encrypted: i=1; AJvYcCUJhIe0pbn/Go+MyOYm9F6K5KeU2D3AFzy3gduMuV8RIGpOECM/7PNumCn58oJobxsHS/eyyho0i7CQ@vger.kernel.org
X-Gm-Message-State: AOJu0YwWsASGLztGnvpGGYSLpXgKq1w7voCvVOBRTQbz3MJYY+7bPz4N
	LIxe3Cjyf79FmSlIVuTuj+aeY/pO7DCSG+v7QhUJDdClQo7vKYk9Q374308Y1fMQZWI=
X-Gm-Gg: ASbGncuVm3VXnhwlUs4lP+YmW2uKS6Laso++kjt6jf+eJ6+B7Af9d0oMeWJ1VAEG0jV
	i3dXhid7ZK79VusFQhY+4Aqs9aMAvTK7QWbnw1mDd9ntk8JMjue6ZgCzTu/f6ep77VdTRmmXa0f
	bV7lpQO4v5BHX4qlnQHSEKqhYBV9fAiRK138At/d9Bhig03kvUjZ/jsHIdSL6UCwAGrRA729lRd
	j6su/r78Nqt3YuKo3w2IEiMH5L751pV2FZzfky6rBHyZ5RZmZmV2WXy0MesyvNqD0M7oXSttepT
	WE5vfj6+l3EkvKYqQiHKe4k4DQdOAQxsjn6IM8dxFmAAru8=
X-Google-Smtp-Source: AGHT+IFGEk6WV38wfO2fNFtvLWC8v+J/V3qGJaKnt61cz/eASxvGslO2+1tn3+3paF9Jj9ay2Bch9Q==
X-Received: by 2002:a05:6e02:1909:b0:3dc:76ad:7990 with SMTP id e9e14a558f8ab-3dc76ad7baamr61593435ab.15.1747760170063;
        Tue, 20 May 2025 09:56:10 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3b1c90sm2302153173.56.2025.05.20.09.56.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 09:56:09 -0700 (PDT)
Message-ID: <7708ccbe-f967-4910-8a73-bb66bbca214e@kernel.dk>
Date: Tue, 20 May 2025 10:56:08 -0600
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] rbd: replace strcpy() with strscpy()
To: Alex Elder <elder@ieee.org>, Siddarth Gundu <siddarthsgml@gmail.com>,
 idryomov@gmail.com, dongsheng.yang@easystack.cn, ceph-devel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250519063840.6743-1-siddarthsgml@gmail.com>
 <f92ddea4-edf1-42f9-a738-51233ce3d45e@ieee.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f92ddea4-edf1-42f9-a738-51233ce3d45e@ieee.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/20/25 10:44 AM, Alex Elder wrote:
> On 5/19/25 1:38 AM, Siddarth Gundu wrote:
>> strcpy() is deprecated; use strscpy() instead.
>>
>> Both the destination and source buffer are of fixed length
>> so strscpy with 2-arguments is used.
>>
>> Introduce a typedef for cookie array to improve code clarity.
>>
>> Link: https://github.com/KSPP/linux/issues/88
>> Signed-off-by: Siddarth Gundu <siddarthsgml@gmail.com>
>> ---
>> changes since v1
>> - added a typedef for cookie arrays
>>
>> About the typedef: I was a bit hesitant to add it since the kernel
>> style guide is against adding new typedef but I wanted to follow
>> the review feedback for this.
> 
> I personally think the typedef here is the appropriate.  But
> it's really up to Ilya whether he likes this approach.  Get
> his input before you do more.

In any case, this should be 2 patches at that point, not collapsed
into one patch.

-- 
Jens Axboe


