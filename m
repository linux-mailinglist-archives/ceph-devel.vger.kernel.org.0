Return-Path: <ceph-devel+bounces-515-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB7F2829A23
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jan 2024 13:06:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9C3F1C21FC7
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jan 2024 12:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59B5C481B7;
	Wed, 10 Jan 2024 12:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="PJtUFaYl"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955CF47A57
	for <ceph-devel@vger.kernel.org>; Wed, 10 Jan 2024 12:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6d9bbf71bc8so2018235b3a.1
        for <ceph-devel@vger.kernel.org>; Wed, 10 Jan 2024 04:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1704888363; x=1705493163; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l8cKztzv2ZktLOe0dzMuixqOyjC0S8dozIynxhbNLCA=;
        b=PJtUFaYlvrO5pZ/l4ETd5F/BPGWcdK9syqEBKz7ARCHtTxn3QP/aujLMCw3/Dejj/r
         abT6WdbwqedaIU90uhQbNbR0zGVsaEOavXLAe+teunPX13SkyMbgWujpBdSEWWg1uMV2
         A4ja+jyQdgycjg7qmn65D3XBbG8529pbOsdlFAWzhXAmePHu6cdBkx3mTIGz5p9aTASC
         Oi7GTnY5REMW+srPlJ2buiPKuL3+smB+duhsJv4ocXGfOa1h5FC16XBeOwO9iJ6XJ8ce
         a8a+yY1XLWZc4/wXe8QzNtDp7iWFGuf9/+yLHMm/vdpT/IfP/ukSEqxdX2iVHWqsz/Ho
         CzIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704888363; x=1705493163;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l8cKztzv2ZktLOe0dzMuixqOyjC0S8dozIynxhbNLCA=;
        b=ngo1BJwJ+GN7mMZjePQ5ntwd2RC7f48CSk7qHtiXhjgNTe0wChRMt1xlZWMQGklxeh
         m8R1snU2J6GaovLI1kqX58mFWcXFaKQkmcbjRjxnRm0oJHT/biNZPxCtML1c/ADUFFm2
         xss437atkTle7RuLlYC3soj1aloJCvvLENqjtaqt0Ks+wnmV6iD9+jA23yhz1k5mpKZC
         8dmrQ1DoS3wv2E7alz5Ls/6YwgyInAA3dFQOD+TkdhZARpJxLZWHSsSkrdhqOuEFuSwm
         FQ7GFK+bLuGDKMsHMwqtRsAGjSTaVrrMU/IEtz3ovceuw0f9t1eWa0WW9sEhxNEL8erM
         I4Eg==
X-Gm-Message-State: AOJu0YxN5h66HtXf1yvGiNYdSmZxFrQ/YV6Q4FMD/+Rv0jsTikdmhshJ
	oMBIzg2s84xgz68A+CF8MO6XDlLx+9/6gw==
X-Google-Smtp-Source: AGHT+IFsVj/4XzAFKalFZR2COx2846rqnoRx+GhgwtyxD4J0CYsNkiv/V9CNEvpVyo59dEDH4l9dyw==
X-Received: by 2002:a05:6a00:3204:b0:6da:63a5:3f32 with SMTP id bm4-20020a056a00320400b006da63a53f32mr612723pfb.66.1704888362874;
        Wed, 10 Jan 2024 04:06:02 -0800 (PST)
Received: from [10.255.187.86] ([139.177.225.245])
        by smtp.gmail.com with ESMTPSA id i128-20020a625486000000b006d99056c4edsm3470845pfb.187.2024.01.10.04.05.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jan 2024 04:06:02 -0800 (PST)
Message-ID: <abcc18ec-4006-4c51-96a8-e61d0ec2f092@bytedance.com>
Date: Wed, 10 Jan 2024 20:05:50 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] [PATCH 5/6] cachefiles: Fix signed/unsigned mixup
To: David Howells <dhowells@redhat.com>,
 Christian Brauner <christian@brauner.io>, Jeff Layton <jlayton@kernel.org>,
 Gao Xiang <hsiangkao@linux.alibaba.com>,
 Dominique Martinet <asmadeus@codewreck.org>
Cc: Steve French <smfrench@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 Marc Dionne <marc.dionne@auristor.com>, Paulo Alcantara <pc@manguebit.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Eric Van Hensbergen <ericvh@kernel.org>, Ilya Dryomov <idryomov@gmail.com>,
 linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
 linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
 ceph-devel@vger.kernel.org, v9fs@lists.linux.dev,
 linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Simon Horman <horms@kernel.org>, kernel test robot <lkp@intel.com>,
 Yiqun Leng <yqleng@linux.alibaba.com>, zhujia.zj@bytedance.com
References: <20240109112029.1572463-1-dhowells@redhat.com>
 <20240109112029.1572463-6-dhowells@redhat.com>
From: Jia Zhu <zhujia.zj@bytedance.com>
In-Reply-To: <20240109112029.1572463-6-dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Tested-by: Jia Zhu <zhujia.zj@bytedance.com>

在 2024/1/9 19:20, David Howells 写道:
> In __cachefiles_prepare_write(), the start and pos variables were made
> unsigned 64-bit so that the casts in the checking could be got rid of -
> which should be fine since absolute file offsets can't be negative, except
> that an error code may be obtained from vfs_llseek(), which *would* be
> negative.  This breaks the error check.
> 
> Fix this for now by reverting pos and start to be signed and putting back
> the casts.  Unfortunately, the error value checks cannot be replaced with
> IS_ERR_VALUE() as long might be 32-bits.
> 
> Fixes: 7097c96411d2 ("cachefiles: Fix __cachefiles_prepare_write()")
> Reported-by: Simon Horman <horms@kernel.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202401071152.DbKqMQMu-lkp@intel.com/
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: Simon Horman <horms@kernel.org>
> cc: Gao Xiang <hsiangkao@linux.alibaba.com>
> cc: Yiqun Leng <yqleng@linux.alibaba.com>
> cc: Jia Zhu <zhujia.zj@bytedance.com>
> cc: Jeff Layton <jlayton@kernel.org>
> cc: linux-cachefs@redhat.com
> cc: linux-erofs@lists.ozlabs.org
> cc: linux-fsdevel@vger.kernel.org
> cc: linux-mm@kvack.org
> ---
>   fs/cachefiles/io.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/cachefiles/io.c b/fs/cachefiles/io.c
> index 3eec26967437..9a2cb2868e90 100644
> --- a/fs/cachefiles/io.c
> +++ b/fs/cachefiles/io.c
> @@ -522,7 +522,7 @@ int __cachefiles_prepare_write(struct cachefiles_object *object,
>   			       bool no_space_allocated_yet)
>   {
>   	struct cachefiles_cache *cache = object->volume->cache;
> -	unsigned long long start = *_start, pos;
> +	loff_t start = *_start, pos;
>   	size_t len = *_len;
>   	int ret;
>   
> @@ -556,7 +556,7 @@ int __cachefiles_prepare_write(struct cachefiles_object *object,
>   					  cachefiles_trace_seek_error);
>   		return pos;
>   	}
> -	if (pos >= start + *_len)
> +	if ((u64)pos >= (u64)start + *_len)
>   		goto check_space; /* Unallocated region */
>   
>   	/* We have a block that's at least partially filled - if we're low on
> @@ -575,7 +575,7 @@ int __cachefiles_prepare_write(struct cachefiles_object *object,
>   					  cachefiles_trace_seek_error);
>   		return pos;
>   	}
> -	if (pos >= start + *_len)
> +	if ((u64)pos >= (u64)start + *_len)
>   		return 0; /* Fully allocated */
>   
>   	/* Partially allocated, but insufficient space: cull. */
> 

