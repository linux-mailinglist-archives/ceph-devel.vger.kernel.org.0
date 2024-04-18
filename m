Return-Path: <ceph-devel+bounces-1091-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17C3C8A9009
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Apr 2024 02:28:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1BD51F21796
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Apr 2024 00:28:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF5E2611B;
	Thu, 18 Apr 2024 00:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LpAptudi"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDA064F
	for <ceph-devel@vger.kernel.org>; Thu, 18 Apr 2024 00:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713400118; cv=none; b=s/MuuQdICA7Qr6D+NHRpBxI6lFGEAuaZkMu/zvDZMFw+PPJeBv1xXxsLbRuXNW3gohP4LjMSNg+1QBPRwCr/UZICDHYd2udjUQrU93TNNsA8XhOi8H+OJw/fin9lfE3iCWB9s0lbhYgduIpnFhKjnzxWOMrGr8HU24xgxc+t9/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713400118; c=relaxed/simple;
	bh=E4arsPzMD+QIZBCLrwwJ9l3JEyK6f+j621bQZwrrbNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EfB1JvmR57/BIanOrpkgX+Dhtg3c4iroOwMbqIZ/5d1TsNU6LVNMU3KxFS6OSDjClc1VE6s4O1yd+a+1zIJZAlhhR2BbKfC3o9JnQv865rXvemXlAMxfdrlrGtoM2eziPh0D6KqDo+CwqKK2D01aoWP+R5G6Tt0WR+s/10Ji214=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LpAptudi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713400113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3jV3NxPG2VkGcFSCoj+CqZoFen5LhNgf3imIldjqPCo=;
	b=LpAptudiZqQE0Cra/LOagUkqKfxyTJWZwTu0SFUZQapzNHo6XqBi7R3k5Lh4SXWCtXiKqe
	mO4b10Joi9g/I0kiSaBvRtmxvtViJRO0t6JPktmbWczX+AWtITrM2pmsdnYaUzvNBhGiL8
	wh0Axua7ewbIEwEPOF6UQ1kIznDnehE=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-152-ifirNl_EPnqef8zH4_tpcQ-1; Wed, 17 Apr 2024 20:28:32 -0400
X-MC-Unique: ifirNl_EPnqef8zH4_tpcQ-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1e5e5fa31dbso4082745ad.0
        for <ceph-devel@vger.kernel.org>; Wed, 17 Apr 2024 17:28:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713400111; x=1714004911;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3jV3NxPG2VkGcFSCoj+CqZoFen5LhNgf3imIldjqPCo=;
        b=O5ZUGn4FAFfM6s6VlL6BC4GnXCm2uC2GgdPSX0oS9JiQs/9cfCnV79Z8Ty8Fju8vCS
         FXh6wEBjg2ZVz1y1GlMyFde+ulCUj86xixwVN8we47IoCVQixqp/NNgocHKOHTtKcl1V
         d6GU/Z0M9dhYj01r1xbNWP/xYFb6xkVd0ckpQVyhC4URsJb7E7iougNvEw4tHiOGysZo
         7Gc22hmhLKXLwd2vBSByb63stxL8MDw6lXb4uYKYg0iZrvb5UX7yZ+ZykeOgYidH1jz9
         Y/WGnQ55gFTx+Tfi6RuUco6B9svUEly5FSPgiSnWn5SNQkhpyFA1CljgNdbdm2Zpx+16
         sOZA==
X-Forwarded-Encrypted: i=1; AJvYcCXrHJR+lB+4t84LVg1jMDnAE0GdoKseITXr+iO11WmyE8AZwKxitZFG/JSTh1rUfm1svUNCidMr3V0vVGPZ990rXuhGDR9ybgVttQ==
X-Gm-Message-State: AOJu0YwSVKOBs4v1twq0OpsPz5EzhPUHGFhmJ0JXYYzjR35RoBwo6rMC
	XCbjNvkHPXQaSaJh7MMBlRM/ZsVT47nTg74P7+A2DyJXulwwd/plTydiiIRPlZF8uPUjTLeq0Lr
	2Bsu46hPosGr1T+tjJboP1JSoQ8Rapw7uATrFWMlZlYY01rhU1/10H0+R188=
X-Received: by 2002:a17:902:a70b:b0:1de:e6a5:e51d with SMTP id w11-20020a170902a70b00b001dee6a5e51dmr1125497plq.16.1713400111275;
        Wed, 17 Apr 2024 17:28:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnGifVjUZc6JYr8+X4V1IU5XrfsR1gvJ+hBF0QCqo64SetRIuf3s/amABGErI5D2wT3b3w3Q==
X-Received: by 2002:a17:902:a70b:b0:1de:e6a5:e51d with SMTP id w11-20020a170902a70b00b001dee6a5e51dmr1125472plq.16.1713400110923;
        Wed, 17 Apr 2024 17:28:30 -0700 (PDT)
Received: from [10.72.116.40] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x2-20020a170902820200b001e042dc5202sm238888pln.80.2024.04.17.17.28.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Apr 2024 17:28:30 -0700 (PDT)
Message-ID: <fc89e5b9-cfc4-4303-b3ff-81f00a891488@redhat.com>
Date: Thu, 18 Apr 2024 08:28:22 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/8] ceph: drop usage of page_index
To: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Huang, Ying" <ying.huang@intel.com>, Matthew Wilcox <willy@infradead.org>,
 Chris Li <chrisl@kernel.org>, Barry Song <v-songbaohua@oppo.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Neil Brown <neilb@suse.de>,
 Minchan Kim <minchan@kernel.org>, Hugh Dickins <hughd@google.com>,
 David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>,
 ceph-devel@vger.kernel.org
References: <20240417160842.76665-1-ryncsn@gmail.com>
 <20240417160842.76665-5-ryncsn@gmail.com>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20240417160842.76665-5-ryncsn@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/18/24 00:08, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
>
> page_index is needed for mixed usage of page cache and swap cache,
> for pure page cache usage, the caller can just use page->index instead.
>
> It can't be a swap cache page here, so just drop it.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Cc: Xiubo Li <xiubli@redhat.com>
> Cc: Ilya Dryomov <idryomov@gmail.com>
> Cc: Jeff Layton <jlayton@kernel.org>
> Cc: ceph-devel@vger.kernel.org
> ---
>   fs/ceph/dir.c   | 2 +-
>   fs/ceph/inode.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 0e9f56eaba1e..570a9d634cc5 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -141,7 +141,7 @@ __dcache_find_get_entry(struct dentry *parent, u64 idx,
>   	if (ptr_pos >= i_size_read(dir))
>   		return NULL;
>   
> -	if (!cache_ctl->page || ptr_pgoff != page_index(cache_ctl->page)) {
> +	if (!cache_ctl->page || ptr_pgoff != cache_ctl->page->index) {
>   		ceph_readdir_cache_release(cache_ctl);
>   		cache_ctl->page = find_lock_page(&dir->i_data, ptr_pgoff);
>   		if (!cache_ctl->page) {
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 7b2e77517f23..1f92d3faaa6b 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1861,7 +1861,7 @@ static int fill_readdir_cache(struct inode *dir, struct dentry *dn,
>   	unsigned idx = ctl->index % nsize;
>   	pgoff_t pgoff = ctl->index / nsize;
>   
> -	if (!ctl->page || pgoff != page_index(ctl->page)) {
> +	if (!ctl->page || pgoff != ctl->page->index) {

Hi Kairui,

Thanks for you patch and will it be doable to switch to folio_index() 
instead ?

Cheers,

- Xiubo


>   		ceph_readdir_cache_release(ctl);
>   		if (idx == 0)
>   			ctl->page = grab_cache_page(&dir->i_data, pgoff);


