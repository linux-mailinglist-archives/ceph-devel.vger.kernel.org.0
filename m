Return-Path: <ceph-devel+bounces-1811-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 73742975EB0
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Sep 2024 04:01:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1847B1F236F4
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Sep 2024 02:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F5AF2A1D1;
	Thu, 12 Sep 2024 02:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="USzx/xwa"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCCB24211
	for <ceph-devel@vger.kernel.org>; Thu, 12 Sep 2024 02:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726106460; cv=none; b=Bxiaus3R/zLITLk2kGwsilQcladrkOjgOssuuRPLd28FDKGoekbOQdV4qIuxbe2/T2Rwjq51oaiYZ6irUXsK7REx4RvoLKOwI/yAR5qOyP4VJZJMJB/EQkMaaW2HOKpqz6zXDkkU7tnLqb8QRxisnbqhxyXRjI3zJTADBMKy9B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726106460; c=relaxed/simple;
	bh=KTqAiMtsDxIktsPNE9vhSnbzhIInxHk4U9ytkiGz8P0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r0BacwNQguxqWfBDRFtTC6616zuBG58raoKEYqHA8fpbcJQ0uLRoa2opaubJ7G380GJCVlL8Cs7loTWxTFgDkIwrGTgusKs8ug5F18Y1AVfvTI2T17Ziv4ceYifdWqkqlbOgBshAZRg7vQdO+phZFUgZ1ZJoYx0q8BEmmPCkzkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=USzx/xwa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726106457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MEeDXDP4NDLx5wLz02Qa65mtauP0cLnEIEN+qnxdGYc=;
	b=USzx/xwa5Gg8VZgPI5HXRacfk6JbyFXShORaoeOfG8/SDWLDviAO51azbchh5zKyPeovjK
	uEGXiGEaUmWmXhgZ0vzncVjQkLRjdzLenlTStJf6sd1R+3qT5vVE0vJsqi0ohJiSZWzVFH
	HLAiym0UR7AooQFfIBX9Tw4GDRuZIV0=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-aRhpEzNcNnemOJjPv0WJ3A-1; Wed, 11 Sep 2024 22:00:55 -0400
X-MC-Unique: aRhpEzNcNnemOJjPv0WJ3A-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-206e07915c2so5380275ad.3
        for <ceph-devel@vger.kernel.org>; Wed, 11 Sep 2024 19:00:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726106455; x=1726711255;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MEeDXDP4NDLx5wLz02Qa65mtauP0cLnEIEN+qnxdGYc=;
        b=JEz9TYkU7tZaAtk2WXPEkDT1GYNt/TuERon5zZeRdGR0lHBOzLu31YGugrgbrFg7ds
         5a6zgi+1qqBiTh+kcu++JglE1wvd/+kaxKizehxcwsjwohNYI/EKooR34vQIZgZy6M9z
         OaB7pokyxZ45+AegJjLusu+sGyLcfMTPF0ZmN9rFREXW9Kw0c08FDMrzGloK0BoMJv8J
         FiGmqcUgeg0VmP8BLXjzJSCz4TeaxEa9tY5b/RiJZJpvVWVdMEzHRTatmBAZs79S6YuJ
         +spBsDXxEI46+u5OmE4wN66bRu6VrkJbBNxmzoQb2DGKEujgVGJnx8SJZSp7I+SnigPb
         i/Qw==
X-Forwarded-Encrypted: i=1; AJvYcCXH3ihvEdwaEExheshnKA2e8GrJsq46P5T3IidV5nA4kiKt8bYdHG6CcFB7qgjUChXNMo1xiz4I1NZe@vger.kernel.org
X-Gm-Message-State: AOJu0YzakJbWfNXHZcB/6Vv2/nLs1oH0TyH9TGmLLM8ah0IXWmgshUxG
	N2FSLncp+lPIaovP4CvGFrApRKstdKlstxvUTZmqrfZ/u02IgJTZY8l9vU/Qfgal1jfdTJfHawK
	WE38YaDWikVQkAh8wFWO40CibFHttVD/hyJRTWZTMGxNcgjf4A9zieeJ6Q+k=
X-Received: by 2002:a17:902:e545:b0:205:6f40:221c with SMTP id d9443c01a7336-2076e3aef8dmr13674645ad.35.1726106454736;
        Wed, 11 Sep 2024 19:00:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFcADcGHi+f4kmNVvdThCUyObTn0GaFSHD6eWPYsHeJMfVa8dFZsfzIKDKUvZkTdfNmc3rqag==
X-Received: by 2002:a17:902:e545:b0:205:6f40:221c with SMTP id d9443c01a7336-2076e3aef8dmr13674365ad.35.1726106454363;
        Wed, 11 Sep 2024 19:00:54 -0700 (PDT)
Received: from [10.72.116.14] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2076af21c2csm5501995ad.18.2024.09.11.19.00.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2024 19:00:53 -0700 (PDT)
Message-ID: <8dfd2741-a2a4-4fbd-9800-5d19de2c4377@redhat.com>
Date: Thu, 12 Sep 2024 10:00:49 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fs/ceph/quota: ignore quota with CAP_SYS_RESOURCE
To: Patrick Donnelly <pdonnell@redhat.com>,
 Max Kellermann <max.kellermann@ionos.com>
Cc: idryomov@gmail.com, ceph-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <4b6aec51-dc23-4e49-86c5-0496823dfa3c@redhat.com>
 <20240911142452.4110190-1-max.kellermann@ionos.com>
 <CA+2bHPb+_=1NQQ2RaTzNy155c6+ng+sjbE6-di2-4mqgOK7ysg@mail.gmail.com>
 <CAKPOu+-Q7c7=EgY3r=vbo5BUYYTuXJzfwwe+XRVAxmjRzMprUQ@mail.gmail.com>
 <CA+2bHPYYCj1rWyXqdPEVfbKhvueG9+BNXG-6-uQtzpPSD90jiQ@mail.gmail.com>
 <CAKPOu+9KauLTWWkF+JcY4RXft+pyhCGnC0giyd82K35oJ2FraA@mail.gmail.com>
 <CA+2bHPbMwsg8NkvW=FCSwCs9p2B0wBkrfW6AbPj+SOWNHAD45w@mail.gmail.com>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CA+2bHPbMwsg8NkvW=FCSwCs9p2B0wBkrfW6AbPj+SOWNHAD45w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 9/12/24 04:14, Patrick Donnelly wrote:
> On Wed, Sep 11, 2024 at 3:21 PM Max Kellermann <max.kellermann@ionos.com> wrote:
>> On Wed, Sep 11, 2024 at 8:04 PM Patrick Donnelly <pdonnell@redhat.com> wrote:
>>> CephFS has many components that are cooperatively maintained by the
>>> MDS **and** the clients; i.e. the clients are trusted to follow the
>>> protocols and restrictions in the file system. For example,
>>> capabilities grant a client read/write permissions on an inode but a
>>> client could easily just open any file and write to it at will. There
>>> is no barrier preventing that misbehavior.
>> To me, that sounds like you confirm my assumption on how Ceph works -
>> both file permissions and quotas. As a superuser (CAP_DAC_OVERRIDE), I
>> can write arbitrary files, and just as well CAP_SYS_RESOURCE should
>> allow me to exceed quotas - that's how both capabilities are
>> documented.
>>
>>> Having root on a client does not extend to arbitrary superuser
>>> permissions on the distributed file system. Down that path lies chaos
>>> and inconsistency.
>> Fine for me - I'll keep my patch in our kernel fork (because we need
>> the feature), together with the other Ceph patches that were rejected.
> If you want to upstream this, the appropriate change would go in
> ceph.git as a new cephx capability (not cephfs capability) for the
> "mds" auth cap that would allow a client with root (or
> CAP_SYS_RESOURCE) to bypass quotas. I would support merging such a
> patch (and the corresponding userspace / kernel client changes).
>
Yeah, Patrick is correct. This really will by pass the protocols and 
restrictions in cephfs and introduces inconsistency. By adding a new 
cephx caps we can broadcast this to all the users or clients.

Thanks


