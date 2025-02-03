Return-Path: <ceph-devel+bounces-2623-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F232A25E73
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Feb 2025 16:22:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F3993A71D0
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Feb 2025 15:14:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7970D20ADC2;
	Mon,  3 Feb 2025 15:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NkiN9Xns"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25961209F5D
	for <ceph-devel@vger.kernel.org>; Mon,  3 Feb 2025 15:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738595529; cv=none; b=fLSBJ8rqZ7JP2IB4C9gjTI/waT5VSMqk18YbV4Ifs///SrVKQEUHb2VkNhBxFSpL979elXFAlFgNdSGW4W1I+y8gIRJUIhwcZkNFK/apMHT4u8//3xyh1rWTrTKZmT8XDEG4THA0wVRaeYYtp6P543VrsFKKv+KQBl0NP2W/Z0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738595529; c=relaxed/simple;
	bh=J4WPyu2dCpa1wg3kBbT+yTxtUfiD3S5ZdeCx/ev+Q+4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uaxCbTOmQnitfpk1MyeLhDQE3kUkyDiLLHGLQfRVpjxvCF4HCM/DX7O6tnEq337bHexgIQJuDNbW8GnzaIMXx2wYh4lmq2REctymjh7zyHk121yLq8jCowCo8uOKGWlBL45LLyzrkvC73ChX8nFljEwWVn1QtutSbGDZgo3u8S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NkiN9Xns; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3ce85545983so12690745ab.0
        for <ceph-devel@vger.kernel.org>; Mon, 03 Feb 2025 07:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738595526; x=1739200326; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QRfpPZzgAZa6Zak9GDas5XD80wl2C6NIA/57szE4cSk=;
        b=NkiN9XnsNIc9MJ9+BQBMhqCoS4s4xFw7uobCWNFiNpbWh3HQBJG8zie61VQBnwy9f1
         xtB3skXdXs6TlGnbW441ecnT+L3SoGcBa6ziPKji25fhhj/7Vmbnd2X2hyA0yGlydm7h
         GnJpR285Ab4PoaqwEcy61WQc0YWmIFWBeJVUkJtxP0QtjUK0Rwqjdktp3vBzilq9CU05
         xqNpPMNt7k7pR69S3qmCvqbS7aiaftA/pRJ9QEWU3PpdTBmNzz7kyrExM8RLzm2Xa4UV
         a9rX7wbysZIu4dlZnE8fW9cMdxQCO2k96efKhkR2cvcse6u79Omc8qPp2bhUj/I60Jru
         9RtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738595526; x=1739200326;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QRfpPZzgAZa6Zak9GDas5XD80wl2C6NIA/57szE4cSk=;
        b=eH6/5rihyENgOTGjceK7IfMa97/kwQiBXn3ZM07v0b8/dGe2ixZT+lP13Lmt0jdtDh
         Lv/37PfHl1Onv3hHyqNJ1TJX4e1tjpS2goA4sRTVk48upak3jMGc0+Yzmxc2pQS15PeP
         bY8r3zeAzeyFjFeQSrZbdYjRZHEDL96kBsR/kQQrbG6JVVyoYN1XWKX6pZfuM2M/EpwV
         YmJhpIIKkRJyW7lUBiVFbiYXCXBUT0OS6VY7xM4H+GzK3wOykQD7tuCBzR1afKU7dXMK
         UH7xrwoq44+GOKcdjPWBGVIkyUYxiBTED3Mzuaj1Oo+Pky9lTfUicjW7kov8MoQ3wRH3
         AGFw==
X-Forwarded-Encrypted: i=1; AJvYcCX0fLWU7+5UaND1SDHW49KBC64/lWtntBbV1PzcZoUEey1GoD2j9vpH6V9f4xlnMNVwYa9VfAFCUo2z@vger.kernel.org
X-Gm-Message-State: AOJu0YyXB5s35WUdzm+AGbaU7GGNM4HpKH18rlkUvTEHo7yItQMVjNHS
	z5rsND/r7kSJh4fuorRwGIEYaI7r5RBn4anClQ3maY9J64MvxGVTESTayrPyGC8=
X-Gm-Gg: ASbGncs6j06UdHGwudyt3XcjYmknxHADGpgMXE161NPQVNqIfGwt8fDk47DzbwP0Mdg
	dX0wYyv79THLPCSx5hEgj621JRDU/i/4/xCvwcGmKYf3T6vZfdGpA0GPWYOehFE+cIQDo+WsDcI
	/r9r1OhaKKOnnTS3QRG/u4e+HsUlURQrKBQOpG15WK1iyn9ON3lc5n9/EdMqFTY5OPTR0jBIISm
	BKi4XxrmvffkPU2c8WswkSvkYTHTKifE0co4roOQf35hZzGCen7EC4LJFt5Yk5Fno4jM45j6ZxC
	S3uUktJBIcA=
X-Google-Smtp-Source: AGHT+IExPksUoM3E6ty6LrIuS+bUTXtJbAwi3WKcho/2VPhbuSKK1HIuLb1aeN5jPmbZBIOOLKzxHw==
X-Received: by 2002:a05:6e02:2688:b0:3cf:b2ca:39b7 with SMTP id e9e14a558f8ab-3d008e71836mr145248235ab.3.1738595526174;
        Mon, 03 Feb 2025 07:12:06 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d01c433734sm16125455ab.14.2025.02.03.07.12.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2025 07:12:05 -0800 (PST)
Message-ID: <262032e2-a248-40aa-b5bd-deccc6c405ca@kernel.dk>
Date: Mon, 3 Feb 2025 08:12:04 -0700
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: force noio scope in blk_mq_freeze_queue
To: Guenter Roeck <linux@roeck-us.net>, Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 nbd@other.debian.org, ceph-devel@vger.kernel.org,
 virtualization@lists.linux.dev, linux-mtd@lists.infradead.org,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20250131120352.1315351-1-hch@lst.de>
 <20250131120352.1315351-2-hch@lst.de>
 <2273ad20-ed56-429c-a6ef-ffdb3196782b@roeck-us.net>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2273ad20-ed56-429c-a6ef-ffdb3196782b@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/3/25 8:09 AM, Guenter Roeck wrote:
> On Fri, Jan 31, 2025 at 01:03:47PM +0100, Christoph Hellwig wrote:
>> When block drivers or the core block code perform allocations with a
>> frozen queue, this could try to recurse into the block device to
>> reclaim memory and deadlock.  Thus all allocations done by a process
>> that froze a queue need to be done without __GFP_IO and __GFP_FS.
>> Instead of tying to track all of them down, force a noio scope as
>> part of freezing the queue.
>>
>> Note that nvme is a bit of a mess here due to the non-owner freezes,
>> and they will be addressed separately.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> All sparc64 builds fail with this patch in the tree.

Yep, Stephen reported the same yesterday. The patch is queued up,
will most likely just send it out separately.

-- 
Jens Axboe


