Return-Path: <ceph-devel+bounces-360-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA859816514
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Dec 2023 03:51:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66D292817D7
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Dec 2023 02:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E661A3C36;
	Mon, 18 Dec 2023 02:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KywYHlYq"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B52A5228
	for <ceph-devel@vger.kernel.org>; Mon, 18 Dec 2023 02:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702867869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=icPsuqAL/RWdl4k8H9rLPctNnOC70TqFRcsZSRHgwSQ=;
	b=KywYHlYq1qcyR+gLjvvWtZGJWtdGoh7t8KgJJxEJckEC+XSDX/PbfOUbjsmg4dg93Ayzfr
	2BZ+ZdR0r5k8KLIVBG9xiw91nh57qeogcExFQX8dl6x8tQn7/eVIEUBvvpk9S9BPUsXZmR
	MKyxHyDZAPkJCHmlCvz4k8opDmkNLr0=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-227-vJXhn8FpPQmYL66tHef0BQ-1; Sun, 17 Dec 2023 21:51:07 -0500
X-MC-Unique: vJXhn8FpPQmYL66tHef0BQ-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-28b7adf8ef6so759010a91.1
        for <ceph-devel@vger.kernel.org>; Sun, 17 Dec 2023 18:51:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702867867; x=1703472667;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=icPsuqAL/RWdl4k8H9rLPctNnOC70TqFRcsZSRHgwSQ=;
        b=q8kH0poWZ0xWRu6FpyGQrKzdmmg5R9eqN1+YGlmqeRbj11mQA7QH3fXUBQuqB+gZiz
         eNs1R/UMK2GUByQGrrm6Q0ZBBhzWgCbAV0J7XmADuO48erIcr+RUhuXctrex3YRbnRFh
         eQIwBWnRA5IyjW7FMtEfrdoittH7s9pxank06GfheH3+LnwiLrMzOaaQXjtC39sla3DX
         9EqOI6l11v96ZLITfUfhsHU0rlJBvtkU3DS+ar0iXD/ska1F7CPi47U5DvgGT2h2y7fW
         kPn2qM/bkz0YOLXkQ5uYsB9eST7AmDQItdKYTbEbvv3IWvqi6WhbEkQRA2ZReJbR86Px
         TuZw==
X-Gm-Message-State: AOJu0Yx/bwVlHXuXdugc+AxdaO/X5HTewyXKArOpNo4kQo8eyxrn8xoY
	PTmH+FitFK4Pa3q4sPOb3NngZEm+tkTd0Wtjly2meJi4KKM1JLHwCVVBaTiLG38Vg1nUH7cDE7G
	fUpH/Z9YQU7GDHVZLWTtn/Q==
X-Received: by 2002:a17:90a:5d11:b0:28b:5cd7:84d0 with SMTP id s17-20020a17090a5d1100b0028b5cd784d0mr787989pji.80.1702867866966;
        Sun, 17 Dec 2023 18:51:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFTSMKgDq7tWrXVUBSE4n6rbOgKZ8rdwCoNcSXYRmqgQBb7JQJaDMH4IwqxNytcdJeXP3fOsw==
X-Received: by 2002:a17:90a:5d11:b0:28b:5cd7:84d0 with SMTP id s17-20020a17090a5d1100b0028b5cd784d0mr787978pji.80.1702867866663;
        Sun, 17 Dec 2023 18:51:06 -0800 (PST)
Received: from [10.72.113.27] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 10-20020a17090a19ca00b0028ad9d801e3sm3696630pjj.46.2023.12.17.18.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Dec 2023 18:51:06 -0800 (PST)
Message-ID: <ab373a38-7800-4056-9ac4-31fef643c6b1@redhat.com>
Date: Mon, 18 Dec 2023 10:50:57 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v39 20/42] LSM: Use lsmcontext in
 security_dentry_init_security
Content-Language: en-US
To: Casey Schaufler <casey@schaufler-ca.com>, paul@paul-moore.com,
 linux-security-module@vger.kernel.org
Cc: jmorris@namei.org, serge@hallyn.com, keescook@chromium.org,
 john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
 stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
 mic@digikod.net, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org
References: <20231215221636.105680-1-casey@schaufler-ca.com>
 <20231215221636.105680-21-casey@schaufler-ca.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20231215221636.105680-21-casey@schaufler-ca.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 12/16/23 06:16, Casey Schaufler wrote:
> Replace the (secctx,seclen) pointer pair with a single
> lsmcontext pointer to allow return of the LSM identifier
> along with the context and context length. This allows
> security_release_secctx() to know how to release the
> context. Callers have been modified to use or save the
> returned data from the new structure.
>
> Special care is taken in the NFS code, which uses the
> same data structure for its own copied labels as it does
> for the data which comes from security_dentry_init_security().
> In the case of copied labels the data has to be freed, not
> released.
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Cc: ceph-devel@vger.kernel.org
> Cc: linux-nfs@vger.kernel.org
> ---
>   fs/ceph/super.h               |  3 +--
>   fs/ceph/xattr.c               | 19 ++++++-------------
>   fs/fuse/dir.c                 | 35 ++++++++++++++++++-----------------
>   fs/nfs/dir.c                  |  2 +-
>   fs/nfs/inode.c                | 17 ++++++++++-------
>   fs/nfs/internal.h             |  8 +++++---
>   fs/nfs/nfs4proc.c             | 22 +++++++++-------------
>   fs/nfs/nfs4xdr.c              | 22 ++++++++++++----------
>   include/linux/lsm_hook_defs.h |  2 +-
>   include/linux/nfs4.h          |  8 ++++----
>   include/linux/nfs_fs.h        |  2 +-
>   include/linux/security.h      |  7 +++----
>   security/security.c           |  9 ++++-----
>   security/selinux/hooks.c      |  9 +++++----
>   14 files changed, 80 insertions(+), 85 deletions(-)
>
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index fe0f64a0acb2..d503cc7478b7 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1133,8 +1133,7 @@ struct ceph_acl_sec_ctx {
>   	void *acl;
>   #endif
>   #ifdef CONFIG_CEPH_FS_SECURITY_LABEL
> -	void *sec_ctx;
> -	u32 sec_ctxlen;
> +	struct lsmcontext lsmctx;
>   #endif
>   #ifdef CONFIG_FS_ENCRYPTION
>   	struct ceph_fscrypt_auth *fscrypt_auth;
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 113956d386c0..4c767a20ac4c 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -1383,8 +1383,7 @@ int ceph_security_init_secctx(struct dentry *dentry, umode_t mode,
>   	int err;
>   
>   	err = security_dentry_init_security(dentry, mode, &dentry->d_name,
> -					    &name, &as_ctx->sec_ctx,
> -					    &as_ctx->sec_ctxlen);
> +					    &name, &as_ctx->lsmctx);
>   	if (err < 0) {
>   		WARN_ON_ONCE(err != -EOPNOTSUPP);
>   		err = 0; /* do nothing */
> @@ -1409,7 +1408,7 @@ int ceph_security_init_secctx(struct dentry *dentry, umode_t mode,
>   	 */
>   	name_len = strlen(name);
>   	err = ceph_pagelist_reserve(pagelist,
> -				    4 * 2 + name_len + as_ctx->sec_ctxlen);
> +				    4 * 2 + name_len + as_ctx->lsmctx.len);
>   	if (err)
>   		goto out;
>   
> @@ -1429,11 +1428,9 @@ int ceph_security_init_secctx(struct dentry *dentry, umode_t mode,
>   		as_ctx->pagelist = pagelist;
>   	}
>   
> -	ceph_pagelist_encode_32(pagelist, name_len);
> -	ceph_pagelist_append(pagelist, name, name_len);
> -

Why remove these ?

> -	ceph_pagelist_encode_32(pagelist, as_ctx->sec_ctxlen);
> -	ceph_pagelist_append(pagelist, as_ctx->sec_ctx, as_ctx->sec_ctxlen);
> +	ceph_pagelist_encode_32(pagelist, as_ctx->lsmctx.len);
> +	ceph_pagelist_append(pagelist, as_ctx->lsmctx.context,
> +			     as_ctx->lsmctx.len);
>   
>   
[...]

Thanks,

- Xiubo


