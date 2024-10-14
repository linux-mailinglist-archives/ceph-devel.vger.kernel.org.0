Return-Path: <ceph-devel+bounces-1905-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7536099BD2B
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Oct 2024 02:57:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B4EC281E91
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Oct 2024 00:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A460FBE4F;
	Mon, 14 Oct 2024 00:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UTODvCNY"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3962B211C
	for <ceph-devel@vger.kernel.org>; Mon, 14 Oct 2024 00:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728867459; cv=none; b=jIS14nfKc2dOPvC8xLDY4IEp5ZHKux/+LPBKBmtjdhCbaEBDTXfEJLBCu7nwO5OYO65haxHCUb5mxvSTtW4+szZSBxw5C8va7vB5BzXhcXc3hVG5nnvDukGlsPWQtUTVbHi5z/tZlynWN+ElZcVFq3U9oePUznC/n65DGSz3rMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728867459; c=relaxed/simple;
	bh=MNZRtEQcNA2bYlupgfZ5llcyOuSzSIns7T+7nCQBj0k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=la9fXQ/u4WG0xTAWpF2QBESPigFx33mjPr8/jZH/Ffs4BDn+0qzdgnHZRW0ozbp8lIG69JgIAr8q39ASPpVpF+fz23HZOXy+3+8C3/Qx0LPY2B7OkIMgV0xUkp4eUNNg0/U93P0oNvFTbqbC1pJ8Vyyrj0KS/E92UD0FWOC7wAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UTODvCNY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728867455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2VKg9hw5z0yv51RE1dzmMffMtIuKjngcMIVN9+zQBqw=;
	b=UTODvCNYRYAvZ67QKJV0CXfkkrDfX7gwm6rEtvCkYT2Zu6Vt7wXnEHSZhxEtX5448ogEEi
	WToyibfn4Huh225W5tUWoNzdZwg7rucikIQfb2Qkgzz4MzaO1zlLkz313B8jPcXS1H2k5k
	F69JpznHzTNg0Lp7X0RHxVTomZWpwZU=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-xqZ5pw9QNB6z9eahb0Ocxg-1; Sun, 13 Oct 2024 20:57:33 -0400
X-MC-Unique: xqZ5pw9QNB6z9eahb0Ocxg-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-71e67b6eed7so740923b3a.0
        for <ceph-devel@vger.kernel.org>; Sun, 13 Oct 2024 17:57:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728867452; x=1729472252;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2VKg9hw5z0yv51RE1dzmMffMtIuKjngcMIVN9+zQBqw=;
        b=AX3IsW4tjPWDrRalouywvMnq/FrrX85wjxoCeIWfN+bhhsQmynbL7FUAD96Ui22ghA
         PevIouIzk90i66TcMKX/Rx4AMO2TffERiYHYt3O50n5MYEnVRzz+VHQTWtsvKQq6xL14
         SNaRTotUqb/sR16gsmpAdWIsceJyx2s7IZE5p9O08JkKNI8OnnQJZ+kYxIjP+1/mpsxX
         cRe0KoUgoSp1MFJVCzYtGt5sZLDaUZnjSkpFnncoXhjcs75dViOD5Z72E8MfK+vGr6+I
         NCpGe3dRW8Y2alFOQ28A0Vh+NfQHhac0+w3WVQmtBX+SR6YcjjCNR4pCSZQvCkg3YNHA
         QZ4A==
X-Forwarded-Encrypted: i=1; AJvYcCWcJ9l8/dkfiCYTHamsQgZge3VhBabxbAijZkku0ivrspIDvvjXfUd388cmj/mStjvJBHlwnjVGr+wA@vger.kernel.org
X-Gm-Message-State: AOJu0YxmkUVSTIIyUvZWxFyEB3kLFPgMDrgp+5QU6UZICVSuU3WQA1Ry
	2my7fuch318ShjXZCg7SMspkHNaWBIX7Lr9Ts+ed9HMen5m5g6Sq3A6FueH3IcyuIavhn5J/BEb
	p3t618T0LwoJEVtFDWrvsa2wDnV1il2K+6daOTWn9UnZVTFsvAuwLL0mgXtUdrEHWnCwL5g==
X-Received: by 2002:a05:6a21:6e4a:b0:1d8:a9c0:8853 with SMTP id adf61e73a8af0-1d8bcf3bd6amr17736896637.23.1728867452526;
        Sun, 13 Oct 2024 17:57:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEbiLGON7pO46TqAq+D0kZdT3Rg5X712Gt+rnnKYcRxTi7oVj0xDfS3kPmAjOEEmvpeBuoNQg==
X-Received: by 2002:a05:6a21:6e4a:b0:1d8:a9c0:8853 with SMTP id adf61e73a8af0-1d8bcf3bd6amr17736873637.23.1728867452199;
        Sun, 13 Oct 2024 17:57:32 -0700 (PDT)
Received: from [10.72.116.3] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ea4495a0e1sm5677327a12.63.2024.10.13.17.57.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Oct 2024 17:57:31 -0700 (PDT)
Message-ID: <3039501f-f7b2-443b-a727-c53c41b41ed9@redhat.com>
Date: Mon, 14 Oct 2024 08:57:23 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] ceph: correct ceph_mds_cap_item field name
To: Patrick Donnelly <batrick@batbytes.com>, Ilya Dryomov <idryomov@gmail.com>
Cc: Patrick Donnelly <pdonnell@redhat.com>, ceph-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20241013011642.555987-1-batrick@batbytes.com>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20241013011642.555987-1-batrick@batbytes.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Patrick,

Thanks for your patches.

BTW, I think this should be the V2, right ?

Then could you explain what's the difference between V1 and V2 ?Usually 
we will add this in the cover-letter.

And also we will add a version tag from the second version of the patch 
series, which is something like:

   [PATCH v2 0/3]
   [PATCH v2 1/3]
   ...
   [PATCH v2 3/3]

At the same time please add a cover-letter if there are more than 1 
patch in the series, which will be the '[PATCH 0/3]', and you can 
generate it by using the '--cover-letter' option:

   $ git patch-format -3 --cover-letter

Please note that in the cover-letter patch you need to add the title, a 
summary about this series and certainly a comment about the changes from 
the last version manually. One example about this please see 
https://lore.kernel.org/all/20240418142019.133191-1-xiubli@redhat.com/.

If there is only one patch in the series, then the cover-letter is not a 
must and you can just do it likes: 
https://patchwork.kernel.org/project/ceph-devel/patch/20240314073915.844541-1-xiubli@redhat.com/,

Thanks

- Xiubo


On 10/13/24 09:16, Patrick Donnelly wrote:
> The issue_seq is sent with bulk cap releases, not the current sequence number.
>
> See also ceph.git commit: "include/ceph_fs: correct ceph_mds_cap_item field name".
>
> See-also: https://tracker.ceph.com/issues/66704
> Signed-off-by: Patrick Donnelly <pdonnell@redhat.com>
> ---
>   fs/ceph/mds_client.c         | 2 +-
>   include/linux/ceph/ceph_fs.h | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index c4a5fd94bbbb..0be82de8a6da 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2362,7 +2362,7 @@ static void ceph_send_cap_releases(struct ceph_mds_client *mdsc,
>   		item->ino = cpu_to_le64(cap->cap_ino);
>   		item->cap_id = cpu_to_le64(cap->cap_id);
>   		item->migrate_seq = cpu_to_le32(cap->mseq);
> -		item->seq = cpu_to_le32(cap->issue_seq);
> +		item->issue_seq = cpu_to_le32(cap->issue_seq);
>   		msg->front.iov_len += sizeof(*item);
>   
>   		ceph_put_cap(mdsc, cap);
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index ee1d0e5f9789..4ff3ad5e9210 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -822,7 +822,7 @@ struct ceph_mds_cap_release {
>   struct ceph_mds_cap_item {
>   	__le64 ino;
>   	__le64 cap_id;
> -	__le32 migrate_seq, seq;
> +	__le32 migrate_seq, issue_seq;
>   } __attribute__ ((packed));
>   
>   #define CEPH_MDS_LEASE_REVOKE           1  /*    mds  -> client */
>
> base-commit: 75b607fab38d149f232f01eae5e6392b394dd659


