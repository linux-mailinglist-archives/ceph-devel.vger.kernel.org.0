Return-Path: <ceph-devel+bounces-1770-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DBFEA961E5E
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Aug 2024 07:47:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 79DF5B20DDE
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Aug 2024 05:47:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C95341514C6;
	Wed, 28 Aug 2024 05:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jh59zb2W"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFABC14EC44
	for <ceph-devel@vger.kernel.org>; Wed, 28 Aug 2024 05:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724824040; cv=none; b=aQQq4GU3w3smlgYrQzCuZfnRU4CC+Levov2Zrdg/V7gvxiJ2/jAx+DZBR2XSQC0C2JL2QP4vGoZSnkRiwKq5IMCLC6nocne79VL+zmPZmC4DsuDKlwS59l36a0TRT3sDd8BW3RNCFnD7HPvVoY6r2RxlhP4g+oyzJ6PB5vfIFkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724824040; c=relaxed/simple;
	bh=RrLam6mqwyBGcfuSrxWmoW3n5YB6vJkgt4F0ExG4lRU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kTNOqzizbiT+4a9vl9T7smRFEVu8fGLzQUUXRGj+wLObUuVzNyB8oMtrFHl+sqzPIuftUUu3dQsVKupho/YC9MYaO/AhNHh9y4qG1sKeui0oJLNmMdfyuT/FdpahbczDWeXsv721Y+Qi8URzpZYRVSpeWqP9E0rjnd9tgaa7Gtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jh59zb2W; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724824037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ckZJuFCVMRgzqQidtTbaqZnRjLzSgCGjaZ05Ho69de8=;
	b=Jh59zb2WaYH83UWqqxVyo6dThn/NcCqldeqgiL0c5CltzDXi6YjtsygR1CHS0hYPfggA5w
	Mi9GqUxm5qiwLrWYhf8rkGs4z5xmuCRpgCFDwj+3XP/yc3sHoqdaFmpWaCbcEeXNCZkIvQ
	p93AGK+QDPjY4suvlaM/ag2+fY7pKuI=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-Cz5QN-BJO2isEjv9vBIY8Q-1; Wed, 28 Aug 2024 01:47:15 -0400
X-MC-Unique: Cz5QN-BJO2isEjv9vBIY8Q-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-201e24bd4d9so65736735ad.0
        for <ceph-devel@vger.kernel.org>; Tue, 27 Aug 2024 22:47:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724824035; x=1725428835;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ckZJuFCVMRgzqQidtTbaqZnRjLzSgCGjaZ05Ho69de8=;
        b=krO2CJkl+HS+vq6UX0hsrviuvHW28d7z8OM8iv7iw9LVgOvbr3Tsni/HEDcFl6nQGj
         qPCEN70ShmS6InhJGwQbel2hAAomPG213eKnE9c2UCfhWJddHiMl+DEqfFpXrAPC9RPr
         bIjnlDj0hhEINVMIzR4nnaFSOia0cUl5A/oBzoxHPmQsFtDg4yCvi1EVok3N3vPGyisM
         eu06/xz9sWojI9+Ac7k+iPe9pD5wxtbEvtKjNZS+j83nzE2rmlgWzRbTOIU/5QNkc700
         4ZuMG3pTTf5DYXiRZr4m8lab/AS60hLjh2S9WlQim0+stHiA/KX9EOjaj0Aq/cuAPx5E
         EB2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXAnVKM1AT83LngGGdJxaap7Y99KgmXZEX7K0ztTG1NJlNLWCd2qCO7hACBz6k6Vw1oE4RZvrs1RDpP@vger.kernel.org
X-Gm-Message-State: AOJu0YyrZr5g66Dt9BU6+GLlPrYBRIUiKlS/RJbGSKS0/uHTk2PZzkIE
	HwrOWkwwRyAyZv+RKke/6BBq/Fys/MvFYAtbQ9jd9A/nQ5OjM/V9cN/oP8MHRAaxMowj/DYmt2S
	p48v5fybt9fNJKmwbFHSBYkgUs5mDMIjFRyXcrvojDC2NuX4/76jq8WY5Wdg=
X-Received: by 2002:a17:902:d4cc:b0:203:a0c9:6953 with SMTP id d9443c01a7336-203a0c96986mr201053525ad.0.1724824034786;
        Tue, 27 Aug 2024 22:47:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+eoKXJOfQW0YjvLqpCE/9ty7ghlsendTsMnu/B13VMaWGHQQyiTP0Mu4p+h0BUfBvtZv58Q==
X-Received: by 2002:a17:902:d4cc:b0:203:a0c9:6953 with SMTP id d9443c01a7336-203a0c96986mr201053435ad.0.1724824034431;
        Tue, 27 Aug 2024 22:47:14 -0700 (PDT)
Received: from [10.72.116.72] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20385be0e08sm91516135ad.285.2024.08.27.22.47.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Aug 2024 22:47:14 -0700 (PDT)
Message-ID: <5d44ae23-4a68-446a-9ae8-f5b809437b32@redhat.com>
Date: Wed, 28 Aug 2024 13:47:10 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] ceph: fix out-of-bound array access when doing a file
 read
To: Luis Henriques <luis.henriques@linux.dev>
Cc: Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240822150113.14274-1-luis.henriques@linux.dev>
 <87mskyxf3l.fsf@linux.dev>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <87mskyxf3l.fsf@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 8/27/24 21:36, Luis Henriques wrote:
> On Thu, Aug 22 2024, Luis Henriques (SUSE) wrote:
>
>> If, while doing a read, the inode is updated and the size is set to zero,
>> __ceph_sync_read() may not be able to handle it.  It is thus easy to hit a
>> NULL pointer dereferrence by continuously reading a file while, on another
>> client, we keep truncating and writing new data into it.
>>
>> This patch fixes the issue by adding extra checks to avoid integer overflows
>> for the case of a zero size inode.  This will prevent the loop doing page
>> copies from running and thus accessing the pages[] array beyond num_pages.
>>
>> Link: https://tracker.ceph.com/issues/67524
>> Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
>> ---
>> Hi!
>>
>> Please note that this patch is only lightly tested and, to be honest, I'm
>> not sure if this is the correct way to fix this bug.  For example, if the
>> inode size is 0, then maybe ceph_osdc_wait_request() should have returned
>> 0 and the problem would be solved.  However, it seems to be returning the
>> size of the reply message and that's not something easy to change.  Or maybe
>> I'm just reading it wrong.  Anyway, this is just an RFC to see if there's
>> other ideas.
>>
>> Also, the tracker contains a simple testcase for crashing the client.
> Just for the record, I've done a quick bisect as this bug is easily
> reproducible.  The issue was introduced in v6.9-rc1, with commit
> 1065da21e5df ("ceph: stop copying to iter at EOF on sync reads").
> Reverting it makes the crash go away.

Thanks very much Luis.

So let's try to find the root cause of it and then improve the patch.

Thanks

- Xiubo


> Cheers,


