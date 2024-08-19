Return-Path: <ceph-devel+bounces-1696-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 228F09560E7
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Aug 2024 03:32:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC700282161
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Aug 2024 01:32:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E59621EB3D;
	Mon, 19 Aug 2024 01:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dckD/Va9"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAE01A270
	for <ceph-devel@vger.kernel.org>; Mon, 19 Aug 2024 01:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724031107; cv=none; b=iAPMVsslR+2ZXoAVKegbPx5kaq60oj9w4XpMenc78TUEIG4qU+0hr4yMFQDmIH3gXHtkl0jP4PODSO2pw0fWw08zJCUKppaPOGJVJrze3hyas/gW2Wksb8KLVuHbMcKkFsHDmJph6cM6MqP3Xv01x4qbDjTMCSesdGFtvjOdeAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724031107; c=relaxed/simple;
	bh=HQ5/dI0Bdm9EgRmrjx9EPAhLLGK7WM59NQ2TNadHhEY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dl0xP8O/KTElimCoTFxy3kSAPBs0hjd3x5gzKhozYo4TndjKeXIXNmQYhzTxbZJZrVRKR8xJS9JoLgFKS16eO3vMvkygU/zs9+Tj17xHYvuCG6JVq/7rPZc1gYPFhQrCXJqMzqMLeAYghoNAhAWT+lixRoPO8xaQ0/ap55H7N5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dckD/Va9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724031103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+CCs3r6hJH4DMfIS+VQJMNGzaRyfgBQFWrMHED7vXl8=;
	b=dckD/Va9vV6fg1h/SXbPOI9PcwJpa9hSdAjHeECxtN/y5Ln9oZ6JuzyKDpAn8VniQ2xe7Q
	TDiWkiRyj+JajNPQj06iAzFlzaVpXOhDIukC7k6hyvhIqmleCI+p3xMbthn7SkGNgNQ/qn
	iavUW78rGh7FxWen7yFTy6chZHah/J0=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-sNHuauoHOpiaNRYBN96-lg-1; Sun, 18 Aug 2024 21:31:42 -0400
X-MC-Unique: sNHuauoHOpiaNRYBN96-lg-1
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7092f2d50ceso2805033a34.2
        for <ceph-devel@vger.kernel.org>; Sun, 18 Aug 2024 18:31:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724031101; x=1724635901;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+CCs3r6hJH4DMfIS+VQJMNGzaRyfgBQFWrMHED7vXl8=;
        b=WTZ6hhr9dGoVqATFQaDo4ju/NLUvgKntrNSJIGxqbLr+l9fl/61Kc3ncUHSvhFVE6k
         H9l6k52qLXWKxKBN30AyPMPy+hEUfqty10IfBfoQvfy214a06vu6oUBnh9yx06yQs3Sb
         JGFOj0dF9283afxloVQ4a02ayXO5x+JNxvZ4kkK6uNT2G8aYGWMJgIuyb8heIr4VxInt
         qi5P37vR8hkPQdrohQqwGvCHyV54zLafjQideQaGACPoALmTbRgXvyaDvcFOU9CXFhK1
         wnTfzEgJNwuLYtSG/3iSQC7S1lBLtDZKOqqycStqo1jLmeHTRjKbAwdE4PkjkBCCkWBt
         5Xpg==
X-Forwarded-Encrypted: i=1; AJvYcCXRzqjsCHZOoUK/4lGHFErp2LQh1qHXc3za5h3X3uTPVSADqM6bjJYDPmF1uXKQEF2XaMKrfoc+12LNbD4HiyT1hziGsc1BRVStgw==
X-Gm-Message-State: AOJu0YwSRb9xLGcA1lgAHnjm2dCmYvDL4GZ/BbvsNukJZlIyoXNmENBo
	5QBP2cWflJOer+U2QHKcHUW6/mA0yj2+jcn/AVASYa2NHLgHdj92ZihYsl64LeBIODcJJHFXlWd
	xV+I02foNkmaIbb01s6cW8VPNkmtk8WYN1/5S2PccsChKicrspjKvMMJWVrw=
X-Received: by 2002:a05:6830:919:b0:709:47a6:627c with SMTP id 46e09a7af769-70cac84915emr9933895a34.4.1724031101678;
        Sun, 18 Aug 2024 18:31:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6X1a7pPkn+SUa6v7Wbgpm6Nj8OlxFtxYJDnVVkia7xEYC08b4X5v9+urMoiKWMtuL+brG/w==
X-Received: by 2002:a05:6830:919:b0:709:47a6:627c with SMTP id 46e09a7af769-70cac84915emr9933887a34.4.1724031101377;
        Sun, 18 Aug 2024 18:31:41 -0700 (PDT)
Received: from [10.72.116.30] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b61dd9c9sm6712306a12.41.2024.08.18.18.31.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Aug 2024 18:31:40 -0700 (PDT)
Message-ID: <de34373f-7e53-406f-9ac3-cd9d7dc1c889@redhat.com>
Date: Mon, 19 Aug 2024 09:31:32 +0800
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

Just back from PTOs.

This LGTM and I will run the test today locally.

Thanks David.

- Xiubo



