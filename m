Return-Path: <ceph-devel+bounces-1093-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EAED8A90CA
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Apr 2024 03:40:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52E1C1F22C97
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Apr 2024 01:40:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F2E41755B;
	Thu, 18 Apr 2024 01:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mgt2iQSu"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C016A3BBFF
	for <ceph-devel@vger.kernel.org>; Thu, 18 Apr 2024 01:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713404417; cv=none; b=qJ+UfSDFAyVZBBf62zV6Tc/6vAuTu7n2vvdq6DzLASxJJ8KyMDgEweGyqNAdVhRG66FWomwT+OkRyr38qik03DUrOBp6ia2Ws+S/KpRB8ezmsPUCoWqA9Z2JHZ0qvdDG+jKHcrZi5Vp9kCRs7Ome27tD2bi/Zc4QXh/UH3aKr14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713404417; c=relaxed/simple;
	bh=e3bCTdtHrF2UnBnEbVCk1MkmyVmZb9X8WMo8KFpypjk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GUnr+PI19ypTVV1wT94dm7xl0KbadtZI9+JGGvHN1MH4lVc9y7WuuV0yG4zqU0X+tUwdrGURO/1CY0g/CMdUx5J5cYDMe2UZv7Wmc+Rc3BIawZAOlHxQ/ClulwwH9FOzlYcI7DpQoqYf8Lg1prEG9jroRIh34ajuiZCk900R5us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mgt2iQSu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713404414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JVgKAS9nz/LG4ge1C9xAdcQzyy8X8VEwsLz7Mq7LgFw=;
	b=Mgt2iQSuFwm+ip7wsMoAXotGtV2PaUbnNw3CqrgYX3V0iMsFA7cxNGXPpzchfzVu7GSMTA
	TaWiym1TTVRAwOPySzLWkPtEEhwTQSxDBv+3ZiJaPDH/4daiMG0K1NfGXxi7uOktMZOOLw
	5NVfjNb0Tpn4SyWgJFtAPSZbR1XR+7w=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-92-QRbsT0XSP_CnZ5Y5_TRs6Q-1; Wed, 17 Apr 2024 21:40:13 -0400
X-MC-Unique: QRbsT0XSP_CnZ5Y5_TRs6Q-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1e2bbb6049eso5364485ad.0
        for <ceph-devel@vger.kernel.org>; Wed, 17 Apr 2024 18:40:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713404412; x=1714009212;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JVgKAS9nz/LG4ge1C9xAdcQzyy8X8VEwsLz7Mq7LgFw=;
        b=Q/UXwnHOKJr8J5BcPXepVV90RFaNVBREsZOhgT1VBkq0sDGDX646ckB8hzRv5Ncmr/
         UvSfnCqskVPbANfET2wtcxj7vStz30Fl958EEvwSWXl5UCSbVHAwtYVr1zKHcCvZbRCQ
         fdjhS7j3QpVIQDrUxnI/7wFb0n0wfLWB7bKcP8RiFkVw6Bcek2Xg1lyuu/AOyg5f5sf1
         1zbOcB2CIVMQu49gG8R0xWWIX6zjuPtSaouBmP1cSRKZGg3RQ9VPltTa89rPpbDnIeDk
         ldJ3adbic2+MKYoMUlEJvEGpHugAt30ayeYvLJ+WF9xNX5PFt3E4rEGKjugpBYtHy05E
         ld2w==
X-Forwarded-Encrypted: i=1; AJvYcCUVMf9A2L6q/IZ9vtnuQ2+G/n0iksp1+sRSKZqh2qu1gIMGqmcC/WKG6eNgA6YhvqViz9Pc0tVWgu7yREWjmuCs8xvo7Bj0NwKJNA==
X-Gm-Message-State: AOJu0YzxsX3Wb8NcEfu9Tc/uH+/ZT9cR3hpWHpT+9s7FgRuCam8/QrAL
	YNrN6VqlWXg+7Kwjm9YG05nv51iOEfRQA6rHGvZPIFAjV2LFCHIlDmPZT8/7BoTudeyUnqIrWzV
	YvUzTZGbrDGk90sXDLAgQPnzx0ROql9/lsNRn1+H21XlehdFaizO92/90yIQ=
X-Received: by 2002:a17:903:228b:b0:1e4:55d8:dfae with SMTP id b11-20020a170903228b00b001e455d8dfaemr1685027plh.4.1713404412271;
        Wed, 17 Apr 2024 18:40:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6VvtdAGo5TIQeytuXP1dbMJEhF6NhbLbnVJumMJQ8ijnoQzNd5M6jQzcmCzrBaveFaQNpmw==
X-Received: by 2002:a17:903:228b:b0:1e4:55d8:dfae with SMTP id b11-20020a170903228b00b001e455d8dfaemr1685010plh.4.1713404411924;
        Wed, 17 Apr 2024 18:40:11 -0700 (PDT)
Received: from [10.72.116.40] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id t20-20020a170902b21400b001e3e081dea1sm314514plr.0.2024.04.17.18.40.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Apr 2024 18:40:11 -0700 (PDT)
Message-ID: <e5b9172c-3123-4926-bd1d-1c1c93f610bb@redhat.com>
Date: Thu, 18 Apr 2024 09:40:04 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/8] ceph: drop usage of page_index
To: Matthew Wilcox <willy@infradead.org>
Cc: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>, "Huang, Ying"
 <ying.huang@intel.com>, Chris Li <chrisl@kernel.org>,
 Barry Song <v-songbaohua@oppo.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Neil Brown <neilb@suse.de>, Minchan Kim <minchan@kernel.org>,
 Hugh Dickins <hughd@google.com>, David Hildenbrand <david@redhat.com>,
 Yosry Ahmed <yosryahmed@google.com>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
 Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
References: <20240417160842.76665-1-ryncsn@gmail.com>
 <20240417160842.76665-5-ryncsn@gmail.com>
 <fc89e5b9-cfc4-4303-b3ff-81f00a891488@redhat.com>
 <ZiB3rp6m4oWCdszj@casper.infradead.org>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <ZiB3rp6m4oWCdszj@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/18/24 09:30, Matthew Wilcox wrote:
> On Thu, Apr 18, 2024 at 08:28:22AM +0800, Xiubo Li wrote:
>> Thanks for you patch and will it be doable to switch to folio_index()
>> instead ?
> No.  Just use folio->index.  You only need folio_index() if the folio
> might belong to the swapcache instead of a file.
>
Hmm, Okay.

Thanks

- Xiubo


