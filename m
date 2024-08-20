Return-Path: <ceph-devel+bounces-1700-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 65BD9957E53
	for <lists+ceph-devel@lfdr.de>; Tue, 20 Aug 2024 08:38:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D05DD1F24756
	for <lists+ceph-devel@lfdr.de>; Tue, 20 Aug 2024 06:38:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB8301E4F06;
	Tue, 20 Aug 2024 06:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ecli/CT9"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6136D1DF68E
	for <ceph-devel@vger.kernel.org>; Tue, 20 Aug 2024 06:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724135631; cv=none; b=eMxp4Gyi4bbsFTwOWeVfJRkFqEATRZVY82Q8D4Vv9zMqLtGLiy0p6yVIlEfled6x7RSAsuGWP8JCRF2g1CJ9faTP44mVrkqE83z8pq2afmAK18IIKDCDtgKkLDqHnXUX7AS9f4gM9KI/OLjlawAxEUNuS0xlAs45Or9nc09u5UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724135631; c=relaxed/simple;
	bh=s6oLVLudE3Hlrcb3NSM12n/aL0wm6duShgC7tYMwKjk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TEFuHWjJ6bLSg/5hmvIsHM8UYCgMz2Cgg5IJtZrgYq4Wh4cy3/dhtGWcCr0NPFBEP/G8KGg8wqWLGU0TlqA/t+mITs5FREg9gMk8kqt8vALxl61b7jYx2sWXvFbsWVjanMblsmJrYT111tz88g97tfpa1pFmwfKljWOWEDt0/IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ecli/CT9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724135627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lxu/JaDhP8Y+hBmSZIP+97DXMICgK3G2N7aESVf67vs=;
	b=Ecli/CT9Eue15Yy7IQxrQVQaDbkZ0w1oIQ4qlliT/HL/cE8oGXmN1LFvpPN739haM7OLpO
	4Lq+Ru00MPSoM8dcSI7JCA9xc1J6c2rvwFX15IzZMOpXVNeDcMxrQSiY5d1N6rIwDPc8Dd
	fQdYP51HR5LnRyF1IzVDYMQThcDGaH0=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-WAVHK0juPnaTsn1EP0qfqg-1; Tue, 20 Aug 2024 02:33:45 -0400
X-MC-Unique: WAVHK0juPnaTsn1EP0qfqg-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3db1d480843so4456543b6e.2
        for <ceph-devel@vger.kernel.org>; Mon, 19 Aug 2024 23:33:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724135624; x=1724740424;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lxu/JaDhP8Y+hBmSZIP+97DXMICgK3G2N7aESVf67vs=;
        b=jlxngBf61AyyRhVCAOrS0kU/aHFKjQPpGP1KPG9YPpH2y2F25xbxCxanyrVkjiZyid
         IYrSdr0sKsEFBpPGQmSgWceIyUYqaTuvLgzK5p51gPMoHyHECZiNDn30iW/bL49J9xKm
         eo8Gq2sSuULduZyxUPgjCgwjA8sg4XL84K/iNOvy/PcqqbW8jkUC2znTbUBpdCWRItgi
         64MTZR8yEBjr+ESB7YmXAq/ZA7Ij+ZGxATWK85poOp/69H3gQPqgQWr6Oci1qYAXOmyo
         8uTvKD4qdBQV93Vpa+fGaUu4bJ9OO96mBCzVWugdgjGHJjd8i7/OptgJfXvnFzgelTBI
         RaFQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4gzdqNjIIpjgEKZmBEuMTZyXKpKmtgtX5xMqY2mSTXXyiWLxDXrqsSZvms3GLcCeeYUyd/gHjGhV2@vger.kernel.org
X-Gm-Message-State: AOJu0Yzk7y9bXYIBR8+ZIQBhRGwdTy+fLcsedUs9d9T8akBxygqdHT4U
	GEfvjVccdd6dx3hdEDvC2WH3gyCyWrt5CFLtk8V6JeDykSWGmFJvMUBoitMsAE7hMKa60ugNUob
	IZuEzJluRUKCBUO3LItTbLecQPUL4qu4A4uYsqDW9nbFRGvXrp0dco0Enc/I=
X-Received: by 2002:a05:6870:c18e:b0:261:1600:b1eb with SMTP id 586e51a60fabf-2701c5a0f1amr15718597fac.31.1724135624499;
        Mon, 19 Aug 2024 23:33:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH8KkMFHadnq0O47HFRRH7mfcRoBRFl5n5bs0K+MpLyDgPkvJUq6Qf7YTL/Zl0oYygtgXFAZQ==
X-Received: by 2002:a05:6870:c18e:b0:261:1600:b1eb with SMTP id 586e51a60fabf-2701c5a0f1amr15718588fac.31.1724135624177;
        Mon, 19 Aug 2024 23:33:44 -0700 (PDT)
Received: from [10.72.116.30] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b61c691csm8591114a12.21.2024.08.19.23.33.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2024 23:33:43 -0700 (PDT)
Message-ID: <cb360270-caf1-4128-918a-59b1bb6ab2d3@redhat.com>
Date: Tue, 20 Aug 2024 14:33:30 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] netfs, ceph: Partially revert "netfs: Replace PG_fscache
 by setting folio->private and marking dirty"
To: David Howells <dhowells@redhat.com>,
 Christian Brauner <brauner@kernel.org>
Cc: Max Kellermann <max.kellermann@ionos.com>,
 Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, ceph-devel@vger.kernel.org,
 netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <2181767.1723665003@warthog.procyon.org.uk>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <2181767.1723665003@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 8/15/24 03:50, David Howells wrote:
>      
> This partially reverts commit 2ff1e97587f4d398686f52c07afde3faf3da4e5c.
>
> In addition to reverting the removal of PG_private_2 wrangling from the
> buffered read code[1][2], the removal of the waits for PG_private_2 from
> netfs_release_folio() and netfs_invalidate_folio() need reverting too.
>
> It also adds a wait into ceph_evict_inode() to wait for netfs read and
> copy-to-cache ops to complete.
>
> Fixes: 2ff1e97587f4 ("netfs: Replace PG_fscache by setting folio->private and marking dirty")
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Max Kellermann <max.kellermann@ionos.com>
> cc: Ilya Dryomov <idryomov@gmail.com>
> cc: Xiubo Li <xiubli@redhat.com>
> cc: Jeff Layton <jlayton@kernel.org>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: ceph-devel@vger.kernel.org
> cc: netfs@lists.linux.dev
> cc: linux-fsdevel@vger.kernel.org
> cc: linux-mm@kvack.org
> Link: https://lore.kernel.org/r/3575457.1722355300@warthog.procyon.org.uk [1]
> Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8e5ced7804cb9184c4a23f8054551240562a8eda [2]
> ---
>   fs/ceph/inode.c |    1 +
>   fs/netfs/misc.c |    7 +++++++
>   2 files changed, 8 insertions(+)
>
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 71cd70514efa..4a8eec46254b 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -695,6 +695,7 @@ void ceph_evict_inode(struct inode *inode)
>   
>   	percpu_counter_dec(&mdsc->metric.total_inodes);
>   
> +	netfs_wait_for_outstanding_io(inode);
>   	truncate_inode_pages_final(&inode->i_data);
>   	if (inode->i_state & I_PINNING_NETFS_WB)
>   		ceph_fscache_unuse_cookie(inode, true);
> diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
> index 83e644bd518f..554a1a4615ad 100644
> --- a/fs/netfs/misc.c
> +++ b/fs/netfs/misc.c
> @@ -101,6 +101,8 @@ void netfs_invalidate_folio(struct folio *folio, size_t offset, size_t length)
>   
>   	_enter("{%lx},%zx,%zx", folio->index, offset, length);
>   
> +	folio_wait_private_2(folio); /* [DEPRECATED] */
> +
>   	if (!folio_test_private(folio))
>   		return;
>   
> @@ -165,6 +167,11 @@ bool netfs_release_folio(struct folio *folio, gfp_t gfp)
>   
>   	if (folio_test_private(folio))
>   		return false;
> +	if (unlikely(folio_test_private_2(folio))) { /* [DEPRECATED] */
> +		if (current_is_kswapd() || !(gfp & __GFP_FS))
> +			return false;
> +		folio_wait_private_2(folio);
> +	}
>   	fscache_note_page_release(netfs_i_cookie(ctx));
>   	return true;
>   }
>
Tested it and worked fine.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Tested-by: Xiubo Li <xiubli@redhat.com>

Thanks



