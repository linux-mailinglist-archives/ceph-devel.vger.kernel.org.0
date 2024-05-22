Return-Path: <ceph-devel+bounces-1159-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 458F98CB6C4
	for <lists+ceph-devel@lfdr.de>; Wed, 22 May 2024 02:38:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1187286E98
	for <lists+ceph-devel@lfdr.de>; Wed, 22 May 2024 00:38:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC8222595;
	Wed, 22 May 2024 00:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BL0kEqqg"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61E81FA1
	for <ceph-devel@vger.kernel.org>; Wed, 22 May 2024 00:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716338285; cv=none; b=fHFyXw2Y2c3ZhirrYj/6lX6DMeS+MJm57M18sEkOxquQJMuK/7kvU1GDq6yv0qmZsuRou1PfkZ9E/T84VZ0/cNOeJuU9jhgzMUE5f9pAaQM5Y1IAcMGzs4rbfsaV1uU1rzpdMNphAToaYL1t1g3fhkZGlLjSW/PjjpclDdSNrAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716338285; c=relaxed/simple;
	bh=LAj1b+bnCms4/xk1W3Z5rJaeVNK1RzfKlW1mijUnq80=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HfRhmW1jDztLbGEPv8h2Z2Z+M5hHTErKFEAsjOfnlbPYpNQuCjqYFIojKiPfRmAqO9SqIexY7DylMUt4Fh6GhzsPrWZ4ozKO3dirIzn44AS4mDsIUzSPV365EvvAzKQRCgVJUGsufjgYlP0AQ5nJXGzeKXpFSBhvCwYG9CMjngk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BL0kEqqg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716338282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z5+Ml59SARQSuVhVqvLQWFYKARbZIUTwBnysaBLWgyU=;
	b=BL0kEqqgPxvC/qKElxaY4ensU9xUectRs0VwJYY2kvftfGkha68v4JOPB/or0EYwfLzrON
	X64qrcChwis+6Cghqm00relrOwpQz8gZeCNMm4wGdyT9zL4tBsKnakBz4e6/++yAE2ZYnk
	Fjt6kQYtUHpv9GrIi10DuFzlEU4nXJk=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-Qi19qi2yPhuh_0VrGewSRQ-1; Tue, 21 May 2024 20:38:01 -0400
X-MC-Unique: Qi19qi2yPhuh_0VrGewSRQ-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6f6a41800baso319111b3a.0
        for <ceph-devel@vger.kernel.org>; Tue, 21 May 2024 17:38:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716338280; x=1716943080;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z5+Ml59SARQSuVhVqvLQWFYKARbZIUTwBnysaBLWgyU=;
        b=l5RrRfKEbryPMsR5Z8AfyJQ7hxl5MoNxqh7s9fLZr/X/8Tbz4UegM+2dDNU+f2DXjH
         x22wHGJ1ej84yaQTydsNi4GPXA+agBLRDKL9uPyTKeGo6a+mBe9FO703+N9OHEde2arg
         wYLnno4JLr/rnNaREvrN0k5zzBRaRw5hoKgIq4lXXuv+yaz3JSUicf5CttO6ttF3vZ5+
         PvISgrjDzQ4iIQ1n80LUCubKmYYBxp5kDHpR45glCM+F2GzBi4v/e7Y1r8NgxxDdF92+
         l6Qmsp0VsIISqsMH66dRqY80p+CX7cxS4lI4lB56t5FfxVazcfO3uINaCUZEuMQWVGfx
         zlBA==
X-Forwarded-Encrypted: i=1; AJvYcCWGtR5CiKmqkswcrFlHJxXIhqZ0fYvVFkTXmDhpv9cIsY8aub3S0o6byNsFTJqnXn27Lhf1axMauuxxFg1H3HNvZjVItxIWh/QGaA==
X-Gm-Message-State: AOJu0YxCAP3W8d+JPdD5IV6H/nShBNH9kcAshticFjKpBXK5O+4fuzkG
	2YopDN8bxeTzCVeNlptEw7TP2sdkiUpcFgKWm1s+wf5A95oHHMBlQbX1xUm3vycfwJRZpYwwLec
	1muyb1SNvsEWo18CurCTcAORx7m5eqnZty/Xlw8BOB9dQl5EXhR4l3glTXKk=
X-Received: by 2002:a05:6a00:2e02:b0:6f4:9fc7:d239 with SMTP id d2e1a72fcca58-6f69fc6d156mr18259124b3a.14.1716338279931;
        Tue, 21 May 2024 17:37:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG8g4v0rGDxwPSEFVgieLMxzSKkG2WDTV5Q9c2aX+9gur91SnL1iT4TrvoZ73SO1oZm9pnZtw==
X-Received: by 2002:a05:6a00:2e02:b0:6f4:9fc7:d239 with SMTP id d2e1a72fcca58-6f69fc6d156mr18259049b3a.14.1716338278556;
        Tue, 21 May 2024 17:37:58 -0700 (PDT)
Received: from [10.72.116.32] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d6b71760sm21601587b3a.97.2024.05.21.17.37.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 May 2024 17:37:58 -0700 (PDT)
Message-ID: <d8d3eeea-5425-48d4-ab80-a37cc340e8d2@redhat.com>
Date: Wed, 22 May 2024 08:37:51 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/11] ceph: drop usage of page_index
To: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Huang, Ying" <ying.huang@intel.com>, Matthew Wilcox <willy@infradead.org>,
 Chris Li <chrisl@kernel.org>, Barry Song <v-songbaohua@oppo.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Neil Brown <neilb@suse.de>,
 Minchan Kim <minchan@kernel.org>, David Hildenbrand <david@redhat.com>,
 Hugh Dickins <hughd@google.com>, Yosry Ahmed <yosryahmed@google.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>,
 ceph-devel@vger.kernel.org
References: <20240521175854.96038-1-ryncsn@gmail.com>
 <20240521175854.96038-4-ryncsn@gmail.com>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20240521175854.96038-4-ryncsn@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 5/22/24 01:58, Kairui Song wrote:
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
> index 99561fddcb38..a69570ea2c19 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1863,7 +1863,7 @@ static int fill_readdir_cache(struct inode *dir, struct dentry *dn,
>   	unsigned idx = ctl->index % nsize;
>   	pgoff_t pgoff = ctl->index / nsize;
>   
> -	if (!ctl->page || pgoff != page_index(ctl->page)) {
> +	if (!ctl->page || pgoff != ctl->page->index) {
>   		ceph_readdir_cache_release(ctl);
>   		if (idx == 0)
>   			ctl->page = grab_cache_page(&dir->i_data, pgoff);

Reviewed-by: Xiubo Li <xiubli@redhat.com>



