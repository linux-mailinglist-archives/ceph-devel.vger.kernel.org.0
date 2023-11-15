Return-Path: <ceph-devel+bounces-87-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15CAE7EBA9D
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Nov 2023 01:36:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F4C31C20B1E
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Nov 2023 00:36:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 711AE396;
	Wed, 15 Nov 2023 00:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YDDYLNLv"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DF6181
	for <ceph-devel@vger.kernel.org>; Wed, 15 Nov 2023 00:36:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A19E4
	for <ceph-devel@vger.kernel.org>; Tue, 14 Nov 2023 16:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700008558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L+qBxi2zv75rbxCrPxryNoF5AVHcLiK4v1bHRUG29OY=;
	b=YDDYLNLvVTIaP8O6SA7irJ8iU0BXOZu/NFF9oV5mM9BK1p2zwvwmSkhJk7C62pMetN1Ohy
	z6RREb3ejJJXQDt5uauk05UfDtRQD6k3Vp6gzzEhrDgazIBjnrRuYwHp3Fq+E7kot1Kb8p
	zYhMYKSV6kKR0PI/Vba8uJdl0VdACMo=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-505-RTg3i2rjOkSGxY6-M1yD-w-1; Tue, 14 Nov 2023 19:35:56 -0500
X-MC-Unique: RTg3i2rjOkSGxY6-M1yD-w-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-6baaa9c0ba5so6735022b3a.0
        for <ceph-devel@vger.kernel.org>; Tue, 14 Nov 2023 16:35:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700008556; x=1700613356;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L+qBxi2zv75rbxCrPxryNoF5AVHcLiK4v1bHRUG29OY=;
        b=fPxHGVahYr3+GfjAspPDJbU5nLNb9Fn8o1kK5ZlJFRWdbgDDPoStirSI8pONAP24x0
         +7jzhV6Yec0c8tOPih1nK40y2E9DnvuFk5vCLRgXhxGvZbyFxCClnULPC+d1oM7NgT4/
         hKNfKB2KzN8OMwexn785jkRrlwljcwVXqar9JANpmUoIvnafsAKKEvUS+9I2X3H8ApGL
         SSthVvvUl45qZcbOXkI8oRgHarF8F8chpi1nk+1cZ+CusvKMATWayrrLdF8ycNBITvcx
         KFKWkz3IPkWQ/l+C51RpF7/OxzVzYsE69cfqx8nq4VZi0syH7Nkbq/uHg81rA2QYgFB0
         ffow==
X-Gm-Message-State: AOJu0Yyr3GV0bo2CYIC1d29Xvm3/5wP9uLMKRDz+btekA/knQWk3zs/L
	ge5na7aZ2BkL2JIKQiIilHecyBEaHnt2PSo2aW/P5vdZjD4ggc94MG4Vcq+GsJKyHSDv8GI0PIX
	iJg1/ffGNrVibVVOXnfPrOQ==
X-Received: by 2002:a05:6a00:b4e:b0:6b7:b42f:e438 with SMTP id p14-20020a056a000b4e00b006b7b42fe438mr10351056pfo.8.1700008555679;
        Tue, 14 Nov 2023 16:35:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFZlHALYAfVi6+dTLG0CQtCK2CG0LfW1MNn2kFBFV7ENAXN52ZqeUNfXq0J256Xu5xoSs2Dxw==
X-Received: by 2002:a05:6a00:b4e:b0:6b7:b42f:e438 with SMTP id p14-20020a056a000b4e00b006b7b42fe438mr10351028pfo.8.1700008555111;
        Tue, 14 Nov 2023 16:35:55 -0800 (PST)
Received: from [10.72.112.63] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y19-20020a62b513000000b006c4eb4e7f98sm1755436pfe.169.2023.11.14.16.35.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Nov 2023 16:35:54 -0800 (PST)
Message-ID: <af8549c8-a468-6505-6dd1-3589fc76be8e@redhat.com>
Date: Wed, 15 Nov 2023 08:35:50 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ceph: quota: Fix invalid pointer access in
Content-Language: en-US
To: Wenchao Hao <haowenchao2@huawei.com>, Ilya Dryomov <idryomov@gmail.com>,
 Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: louhongxiang@huawei.com
References: <20231114153108.1932884-1-haowenchao2@huawei.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20231114153108.1932884-1-haowenchao2@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/14/23 23:31, Wenchao Hao wrote:
> This issue is reported by smatch, get_quota_realm() might return
> ERR_PTR, so we should using IS_ERR_OR_NULL here to check the return
> value.
>
> Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
> ---
>   fs/ceph/quota.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index 9d36c3532de1..c4b2929c6a83 100644
> --- a/fs/ceph/quota.c
> +++ b/fs/ceph/quota.c
> @@ -495,7 +495,7 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
>   	realm = get_quota_realm(mdsc, d_inode(fsc->sb->s_root),
>   				QUOTA_GET_MAX_BYTES, true);
>   	up_read(&mdsc->snap_rwsem);
> -	if (!realm)
> +	if (IS_ERR_OR_NULL(realm))
>   		return false;
>   
>   	spin_lock(&realm->inodes_with_caps_lock);

Good catch.

Reviewed-by: Xiubo Li <xiubli@redhat.com>

We should CC the stable mail list.

Thanks

- Xiubo


