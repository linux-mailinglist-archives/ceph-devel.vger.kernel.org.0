Return-Path: <ceph-devel+bounces-900-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15DD88667A2
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Feb 2024 02:43:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1EDA281847
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Feb 2024 01:43:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2E31D2FA;
	Mon, 26 Feb 2024 01:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mze7/Vwa"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6B3D502
	for <ceph-devel@vger.kernel.org>; Mon, 26 Feb 2024 01:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708911812; cv=none; b=LDc5Og65yrlkzKxTQAP81Oq5YB7R9Hepw9UUYT20qYBsbFs1q2wzyhpcqS6E93YLRa2bw9VkShsGIftBezEYHnzadm/+FTmOheXVd6+oviz/Hg0TWWKMMSvWNwnt0fUFGIu41HQe6fjcolfAfChfHBjoeH/KDhCh8nnckZUhLjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708911812; c=relaxed/simple;
	bh=uWcV2gTIGUl/QMgZBSgY4HqrX8vPTUW8Cno0GuaYuSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EohN6k1qUXOS3hNvWvIE/OW5Zb0RuJuR4yzSdyIk7iX77CbQcgx6I54P5HeJnKLOrz2nZbgbYVaxo3KF+DkClwVAA1zG41wFnKJESYc5wF0zDQBCCp3wirR68R7eqd52f0KDMfBeoBu4s3glHUUiS+BTOnmX2071hLVhBlt+0II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mze7/Vwa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708911809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lmMqCI/dOuk22TO51t0Np8k9xwWwCikISvrBZRgIdGg=;
	b=Mze7/VwaJsIRJFylNyR1m42Gq3WmPILBF1Gi2wnES4v+axYBHJ3SHwNOvc/VUMFsi5TDG4
	JdiQiOswl3chACckUvxfQ17cZQwSdA5sQPS2dvfPDuPgNv7Rtjc1hSRSGI/bwxgqV2hhEQ
	LppAu7cA6k+oMUOuzdWcGX9siAZRNLA=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-175-dIVfsFO9M5us5SYuI7UxXg-1; Sun, 25 Feb 2024 20:43:25 -0500
X-MC-Unique: dIVfsFO9M5us5SYuI7UxXg-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-59fe9adf734so2295997eaf.1
        for <ceph-devel@vger.kernel.org>; Sun, 25 Feb 2024 17:43:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708911805; x=1709516605;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lmMqCI/dOuk22TO51t0Np8k9xwWwCikISvrBZRgIdGg=;
        b=RO4Cx4vSDT6hZFWhEM2UyuCbZYj0a3f44AcyMmFtOGqsRsr7Uyl7MMotOhvqyr/TV6
         7iyUJIa+g3aQ+gJqgMsp74TAZMnRxNmy3Nx0Al3uIilWfG3n5alfKhTjkH5kAQfaTr9t
         uDTHQS5JLI/MhAjSniRHzZ/twM+K29eUVNfgB4ZDTlRSxGqRn7MWPkjKtCLv4DOPMjQR
         olMOPh/kAP9PKjpRsptOGJoBt6ExCJVegFjZdcqU456LWv4G4msMs40wbNvhouVgi6az
         Am2FaDG07iPKnV3G7s9R9pEVcy21Mp5yVVuvHr9RvHAH9oE0AzokBJxQpol6GQ2OPoRA
         2sbQ==
X-Gm-Message-State: AOJu0YxwhQa3YCxaqkJVkO4UGEa1/7g0gGM5nzNJByD+RqdjMTO5v4ca
	t3RiwLPYYWs/5rWwjUXorVoi4qJUG6n7VEBO0uKrm2fSmZ8PQsAEVq93muuz8TlF9JPx4x5qIgm
	v6iweeGWJUYSKxnLs5oepqTaTB8kCAwQchLfRGM5Muwcu9MbNs3zNdTvhaTE=
X-Received: by 2002:a05:6358:e491:b0:178:75b1:c403 with SMTP id by17-20020a056358e49100b0017875b1c403mr9350605rwb.9.1708911804948;
        Sun, 25 Feb 2024 17:43:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFa5F8YzBb5iYXJsjW1TiccfqBN9TvPu4sLUOXFO2MTebLlMq/RCQI18Qsh2vGE7IwOLIQfnw==
X-Received: by 2002:a05:6358:e491:b0:178:75b1:c403 with SMTP id by17-20020a056358e49100b0017875b1c403mr9350595rwb.9.1708911804680;
        Sun, 25 Feb 2024 17:43:24 -0800 (PST)
Received: from [10.72.112.131] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id li16-20020a17090b48d000b0029ab712f648sm1409442pjb.38.2024.02.25.17.43.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Feb 2024 17:43:24 -0800 (PST)
Message-ID: <b6083c49-5240-40e3-a028-bb1ba63ccdd7@redhat.com>
Date: Mon, 26 Feb 2024 09:43:19 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ceph: remove SLAB_MEM_SPREAD flag usage
Content-Language: en-US
To: chengming.zhou@linux.dev, idryomov@gmail.com, jlayton@kernel.org
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, vbabka@suse.cz, roman.gushchin@linux.dev,
 Xiongwei.Song@windriver.com, Chengming Zhou <zhouchengming@bytedance.com>
References: <20240224134715.829225-1-chengming.zhou@linux.dev>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20240224134715.829225-1-chengming.zhou@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Chengming,

Thanks for your patch.

BTW, could you share the link of the relevant patches to mark this a no-op ?

Thanks

- Xiubo

On 2/24/24 21:47, chengming.zhou@linux.dev wrote:
> From: Chengming Zhou <zhouchengming@bytedance.com>
>
> The SLAB_MEM_SPREAD flag is already a no-op as of 6.8-rc1, remove
> its usage so we can delete it from slab. No functional change.
>
> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
> ---
>   fs/ceph/super.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 5ec102f6b1ac..4dcbbaa297f6 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -928,36 +928,36 @@ static int __init init_caches(void)
>   	ceph_inode_cachep = kmem_cache_create("ceph_inode_info",
>   				      sizeof(struct ceph_inode_info),
>   				      __alignof__(struct ceph_inode_info),
> -				      SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD|
> -				      SLAB_ACCOUNT, ceph_inode_init_once);
> +				      SLAB_RECLAIM_ACCOUNT|SLAB_ACCOUNT,
> +				      ceph_inode_init_once);
>   	if (!ceph_inode_cachep)
>   		return -ENOMEM;
>   
> -	ceph_cap_cachep = KMEM_CACHE(ceph_cap, SLAB_MEM_SPREAD);
> +	ceph_cap_cachep = KMEM_CACHE(ceph_cap, 0);
>   	if (!ceph_cap_cachep)
>   		goto bad_cap;
> -	ceph_cap_snap_cachep = KMEM_CACHE(ceph_cap_snap, SLAB_MEM_SPREAD);
> +	ceph_cap_snap_cachep = KMEM_CACHE(ceph_cap_snap, 0);
>   	if (!ceph_cap_snap_cachep)
>   		goto bad_cap_snap;
>   	ceph_cap_flush_cachep = KMEM_CACHE(ceph_cap_flush,
> -					   SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
> +					   SLAB_RECLAIM_ACCOUNT);
>   	if (!ceph_cap_flush_cachep)
>   		goto bad_cap_flush;
>   
>   	ceph_dentry_cachep = KMEM_CACHE(ceph_dentry_info,
> -					SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
> +					SLAB_RECLAIM_ACCOUNT);
>   	if (!ceph_dentry_cachep)
>   		goto bad_dentry;
>   
> -	ceph_file_cachep = KMEM_CACHE(ceph_file_info, SLAB_MEM_SPREAD);
> +	ceph_file_cachep = KMEM_CACHE(ceph_file_info, 0);
>   	if (!ceph_file_cachep)
>   		goto bad_file;
>   
> -	ceph_dir_file_cachep = KMEM_CACHE(ceph_dir_file_info, SLAB_MEM_SPREAD);
> +	ceph_dir_file_cachep = KMEM_CACHE(ceph_dir_file_info, 0);
>   	if (!ceph_dir_file_cachep)
>   		goto bad_dir_file;
>   
> -	ceph_mds_request_cachep = KMEM_CACHE(ceph_mds_request, SLAB_MEM_SPREAD);
> +	ceph_mds_request_cachep = KMEM_CACHE(ceph_mds_request, 0);
>   	if (!ceph_mds_request_cachep)
>   		goto bad_mds_req;
>   


