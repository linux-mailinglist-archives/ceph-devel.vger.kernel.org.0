Return-Path: <ceph-devel+bounces-184-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B5DB7F576A
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Nov 2023 05:32:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9BFCDB211B1
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Nov 2023 04:32:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BF08BA45;
	Thu, 23 Nov 2023 04:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WeCicJ26"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E18111F
	for <ceph-devel@vger.kernel.org>; Wed, 22 Nov 2023 20:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700713954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p/RxEdVo2tTEZY1l5idatcfPWUNnH5H6CT5tTe4WQUs=;
	b=WeCicJ268YxnCf7hGvUYPffTxfrnwOmJfnDtHGCwq1Asl82gODOst6w49BE1coUnPTytUi
	7pefA7Ij1ajlVKaTSQPZUX6x0PKLQagBQS8ooWvcz7r1cMgOMlOjn3ISUKmIDgPnzIQs0W
	Th/xyILLCqQELu4tiUSicVaOtXCavOs=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-dbWmPabDNNGBYXo5jDKMuA-1; Wed, 22 Nov 2023 23:32:32 -0500
X-MC-Unique: dbWmPabDNNGBYXo5jDKMuA-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1cf6177552cso6336955ad.3
        for <ceph-devel@vger.kernel.org>; Wed, 22 Nov 2023 20:32:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700713951; x=1701318751;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p/RxEdVo2tTEZY1l5idatcfPWUNnH5H6CT5tTe4WQUs=;
        b=T/9cFLt4iSmUIvwStZzfLnj8f1EoghclvqFOeeafJRPE6x/lFTTeZ1YNmvWvWi/oBv
         kwRtfbDNXFGG8w+Orb4Ra64QkVzs2BLqf+TuQ+zfz3dzFQUEW6uw5pgkNS2v5OLo73rb
         2hQieDVrX5KJZIU9gOj5NDDA3pAOKralzdyEBw37okQisNBUvoDmeELtc4WQeCz6EEGh
         hxGdrxy5Rsx7YgeGEAebgR84ARL48N/exjknWl67P3n+BaWtUGkMD5Ko6y96GbhphVQK
         4mD6cowzb1V394ev7evTJSjdMEvzqgtBGTZcSe12wY8svvkTxAa4u6fcEwW7zyS+nms0
         rr6w==
X-Gm-Message-State: AOJu0YwQT2jWHOl9HzSsRXWB962HlG2qQjh0c2omGSSCZKEuUzpH4Xf7
	NhwYqHXOjTGfRWpavkNTSORaMYn8PXzjuxdtCFbeuAoa8M5P3kwnf/Sn67vZ8kYQNaX3GNSCMQG
	wH7HMG1mUC0gUg3ZsDfiZGQ==
X-Received: by 2002:a17:903:428b:b0:1c3:4b24:d89d with SMTP id ju11-20020a170903428b00b001c34b24d89dmr4875222plb.40.1700713951177;
        Wed, 22 Nov 2023 20:32:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGQx5QnyMOtAGiy5FcvtpmUEdGNjAQiaQOFyix6Z/4HvNl6UhF7Ywdql+khXKEwVycn23klaA==
X-Received: by 2002:a17:903:428b:b0:1c3:4b24:d89d with SMTP id ju11-20020a170903428b00b001c34b24d89dmr4875211plb.40.1700713950895;
        Wed, 22 Nov 2023 20:32:30 -0800 (PST)
Received: from [10.72.112.224] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id v3-20020a1709029a0300b001bf044dc1a6sm257314plp.39.2023.11.22.20.32.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Nov 2023 20:32:30 -0800 (PST)
Message-ID: <9df30dc2-bc1c-b0fc-156f-baad37def05b@redhat.com>
Date: Thu, 23 Nov 2023 12:32:27 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ceph: select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
Content-Language: en-US
To: Eric Biggers <ebiggers@kernel.org>, ceph-devel@vger.kernel.org
Cc: linux-fscrypt@vger.kernel.org, stable@vger.kernel.org
References: <20231123030838.46158-1-ebiggers@kernel.org>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20231123030838.46158-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/23/23 11:08, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> The kconfig options for filesystems that support FS_ENCRYPTION are
> supposed to select FS_ENCRYPTION_ALGS.  This is needed to ensure that
> required crypto algorithms get enabled as loadable modules or builtin as
> is appropriate for the set of enabled filesystems.  Do this for CEPH_FS
> so that there aren't any missing algorithms if someone happens to have
> CEPH_FS as their only enabled filesystem that supports encryption.
>
> Fixes: f061feda6c54 ("ceph: add fscrypt ioctls and ceph.fscrypt.auth vxattr")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>   fs/ceph/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
> index 94df854147d35..7249d70e1a43f 100644
> --- a/fs/ceph/Kconfig
> +++ b/fs/ceph/Kconfig
> @@ -1,19 +1,20 @@
>   # SPDX-License-Identifier: GPL-2.0-only
>   config CEPH_FS
>   	tristate "Ceph distributed file system"
>   	depends on INET
>   	select CEPH_LIB
>   	select LIBCRC32C
>   	select CRYPTO_AES
>   	select CRYPTO
>   	select NETFS_SUPPORT
> +	select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
>   	default n
>   	help
>   	  Choose Y or M here to include support for mounting the
>   	  experimental Ceph distributed file system.  Ceph is an extremely
>   	  scalable file system designed to provide high performance,
>   	  reliable access to petabytes of storage.
>   
>   	  More information at https://ceph.io/.
>   
>   	  If unsure, say N.
>
> base-commit: 9b6de136b5f0158c60844f85286a593cb70fb364

Thanks Eric. This looks good to me.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


