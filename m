Return-Path: <ceph-devel+bounces-1793-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 05F8996F1FF
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2024 12:56:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A52791F253F9
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2024 10:56:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CF161CA69D;
	Fri,  6 Sep 2024 10:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I7LBn44k"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA3C158866
	for <ceph-devel@vger.kernel.org>; Fri,  6 Sep 2024 10:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725620202; cv=none; b=T8oaIvCM3cJHiuwqhI9i9oys5/ShtX48RiPZewuxIyIngdm9T46jXuuXzXcC+ErS9Xu61l9YGBewUQ1XSlCdZnxuimYMsSCuxiGs09Y3roqG2atuP7v0nF6SIcZ74Rrw7sIxmmymhauXL156wsyTzAmpMoCyXYFZR4rgPVLFth0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725620202; c=relaxed/simple;
	bh=NNdeWCVFjTBLpobba9Un19SlJdjLRrQl1Y6jaUWphxg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=od8hbUyIdolwftpOFPVZVINt052cDU0PnWYmcSam0Pu0JRMLjSFwrtb+qq73FKUBZmmKswzTaFShKFy3UnrfXpHVGzll/HhWVf73lzONeRp3YxtJkRYNmS9CRG+bl6saBaB1RA2+YUFELAvdlLkTFkzBZLjs+Xxj/2qyk3zo4IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I7LBn44k; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725620199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vuSlHpC2MXGEcWyJcm+G5MpLzeUZObO9MZVjWlQ6G8Y=;
	b=I7LBn44kp7I05zBbh8zOli1sMe8MvbL0gVbKgYkI2q0AH2fdQ/pN0HQ5JbvGygRnxmkYhm
	uFtLsAz0YrHEvRypqcQD2/kyCPfm5b18qkv+TfHo+YfMqgc7yTkbSUwClsQpr20XPx3V1C
	Mj7KmJs0jg2iqzxw6ghM0Krp1QCnceo=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-dZ2ZZheCOySdntEDucrGsQ-1; Fri, 06 Sep 2024 06:56:38 -0400
X-MC-Unique: dZ2ZZheCOySdntEDucrGsQ-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2d69603a62aso2410134a91.2
        for <ceph-devel@vger.kernel.org>; Fri, 06 Sep 2024 03:56:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725620197; x=1726224997;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vuSlHpC2MXGEcWyJcm+G5MpLzeUZObO9MZVjWlQ6G8Y=;
        b=KVqZ/Kc/D59cZ/GPLKg4x1sOwXQRQAh1uxwF0CUnMzpjrtLbgZ5QMt35nNlacLCnDA
         rGuYRy+3ieDdMbllIzty2GpBzPSX/3qP50MzZVV0MQA7gg/Io7k1Un+mjtms20SdwjiI
         Gb6ZsyGDWYcQieqRoQ8NlRBzFUhRhcm2P0dqpcuW/vcL/zq2DaEP5DYtssUirelx189X
         GeKZGxxFeGmsgVFP8MUAS5XgmIWARubsrgVWYhiy/kJ9VtQaOuzry/lptxV4rMi8KE15
         s6BKMTNUFKX0arpvxeUPJpQaEWdRxLzU7zje71NNHlJ3PzYiYpfLm/EmQQ7I+tSfhnCS
         7OaA==
X-Forwarded-Encrypted: i=1; AJvYcCX474T1bjwSdo3ai7N7tG/HQwEkghCS0JO9WiX5m8WLjlXyML5dMDEEAYWUfRqZ/d2oP1TePfCPJZ92@vger.kernel.org
X-Gm-Message-State: AOJu0Yws3/pU547AxpBWf5bvuxfWXMw2OpFdznQnLRjxMZAjTR5Z94VI
	lqTC18CldsbKouQfI/jnV6tasnPaZFTpdOdYFNUBf+2BWKZmnUhqNOoXtbk3InRyi3JgzK4CdkV
	rxEePrmU+El4H440f6VgDzZd8nmekEfLOvytILIxqC9w7JfPJCOiLF4Fg5e4=
X-Received: by 2002:a17:90b:fcb:b0:2c9:81fd:4c27 with SMTP id 98e67ed59e1d1-2dad4ef0cfcmr2471321a91.14.1725620196898;
        Fri, 06 Sep 2024 03:56:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHyzxaxsQ9arRle5OdIA4yXYKAMUkhdtufyelj/dgUNWzK5A7lAOUgSfuf6W+Ww96QxolSj6w==
X-Received: by 2002:a17:90b:fcb:b0:2c9:81fd:4c27 with SMTP id 98e67ed59e1d1-2dad4ef0cfcmr2471294a91.14.1725620196440;
        Fri, 06 Sep 2024 03:56:36 -0700 (PDT)
Received: from [10.72.116.139] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dadc082a4fsm1246335a91.35.2024.09.06.03.56.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2024 03:56:36 -0700 (PDT)
Message-ID: <c643888e-c450-4a0c-b675-f2b298581509@redhat.com>
Date: Fri, 6 Sep 2024 18:56:31 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ceph: Remove empty definition in header file
To: Zhang Zekun <zhangzekun11@huawei.com>, idryomov@gmail.com,
 ceph-devel@vger.kernel.org
Cc: chenjun102@huawei.com
References: <20240906060134.129970-1-zhangzekun11@huawei.com>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20240906060134.129970-1-zhangzekun11@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 9/6/24 14:01, Zhang Zekun wrote:
> The real definition of ceph_acl_chmod() has been removed since
> commit 4db658ea0ca2 ("ceph: Fix up after semantic merge conflict"),
> remain the empty definition untouched in the header files. Let's
> remove the empty definition.
>
> Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
> ---
>   fs/ceph/super.h | 4 ----
>   1 file changed, 4 deletions(-)
>
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index c88bf53f68e9..384eac22db57 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1206,10 +1206,6 @@ static inline void ceph_init_inode_acls(struct inode *inode,
>   					struct ceph_acl_sec_ctx *as_ctx)
>   {
>   }
> -static inline int ceph_acl_chmod(struct dentry *dentry, struct inode *inode)
> -{
> -	return 0;
> -}
>   
>   static inline void ceph_forget_all_cached_acls(struct inode *inode)
>   {

Hi Zekun,

Thanks for your patch and LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com


