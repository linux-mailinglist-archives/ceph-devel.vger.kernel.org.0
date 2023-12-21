Return-Path: <ceph-devel+bounces-379-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FCF081ABCB
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Dec 2023 01:36:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BDF2287316
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Dec 2023 00:36:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F90610EB;
	Thu, 21 Dec 2023 00:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S+GOoBUU"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A4D64A
	for <ceph-devel@vger.kernel.org>; Thu, 21 Dec 2023 00:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703118952;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z/Nsx0uTbT/aeaoVsFzkutbp6qKnM0H++hewV/P3G6o=;
	b=S+GOoBUUaoxmFpQ6joW4TPvBafLmNJZABwJkPJsROg3TeCup76vsTl3Gbp2zRJmt2QAsLw
	C8xY+vvRg6+brjvoaZzTeYZGjyjA6or1OozH84KxTbSgFmTZpooHoLfrPADxU1PEWIxqLw
	4PtIvQM1AamMiiTrFl99h/Y+oOs9Ot0=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-557-kjtpIUkOMCyQBsDe_NmwhA-1; Wed, 20 Dec 2023 19:35:51 -0500
X-MC-Unique: kjtpIUkOMCyQBsDe_NmwhA-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3ba2072052cso230520b6e.2
        for <ceph-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:35:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703118950; x=1703723750;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z/Nsx0uTbT/aeaoVsFzkutbp6qKnM0H++hewV/P3G6o=;
        b=c90h6Z2IFmxsQysp3ervIfjmBspMhReC9N0EUl3zsSdD5X/fTVGTLOTrYYTkXW5y8j
         VepHY2h9/c3XokIXGDXGt5C/JyHbN3goSsmpkQQcqupSVbqkucRBlW8v3FzDXsVytz0r
         b1gpYv5DW9CuGgDxFa1VhnOq85r+sIaTc2dHX4bYyk3yMC2anedGwbz7icTfC/ghnBAa
         xNXfVbTmLGEq/Xm9HDD0yumuvxU0rfPIDkk1XmHKLUPm5tM6WpULynTyMzuJ4nOo2WbE
         Xs3M1mGBzvB2eo/uQYrdE8BTpmsODyd89FekIkYysgy1cmKagJ2/jgbhzvKHDqJqYHkl
         0lWw==
X-Gm-Message-State: AOJu0YwZL7NlJAqhJwH8DH/Q+VXqVG5JVdqFHUkW+GmIXaxpIFgDij/A
	NoF22tpYihAEvw2kC9PUJVT1lDOTg7YMOH2yJOhQoVK0+EyrJ6hbBJ8BiNcEF7uVHzzlMx43xce
	XOklooImWpjEOgfBJEb0xPA==
X-Received: by 2002:a05:6359:6d87:b0:170:bfb9:fb41 with SMTP id tg7-20020a0563596d8700b00170bfb9fb41mr432990rwb.28.1703118950560;
        Wed, 20 Dec 2023 16:35:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF1EuksPrUcRRt6RWMnztC1dmmcfJQ0X2BtZJbZnTmW7Msq/4F8WlD/IQ25nxsZ1dMG/OaPYw==
X-Received: by 2002:a05:6359:6d87:b0:170:bfb9:fb41 with SMTP id tg7-20020a0563596d8700b00170bfb9fb41mr432986rwb.28.1703118950180;
        Wed, 20 Dec 2023 16:35:50 -0800 (PST)
Received: from [10.72.112.86] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id jx20-20020a17090b46d400b0028b66796002sm457065pjb.6.2023.12.20.16.35.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Dec 2023 16:35:49 -0800 (PST)
Message-ID: <aea7344d-6dcf-44dc-8916-56619d9113f2@redhat.com>
Date: Thu, 21 Dec 2023 08:35:44 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/22] ceph: d_obtain_{alias,root}(ERR_PTR(...)) will do
 the right thing
Content-Language: en-US
To: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Cc: ceph-devel@vger.kernel.org
References: <20231220051348.GY1674809@ZenIV> <20231220052054.GF1674809@ZenIV>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20231220052054.GF1674809@ZenIV>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 12/20/23 13:20, Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>   fs/ceph/export.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index 726af69d4d62..a79f163ae4ed 100644
> --- a/fs/ceph/export.c
> +++ b/fs/ceph/export.c
> @@ -286,8 +286,6 @@ static struct dentry *__snapfh_to_dentry(struct super_block *sb,
>   		doutc(cl, "%llx.%llx parent %llx hash %x err=%d", vino.ino,
>   		      vino.snap, sfh->parent_ino, sfh->hash, err);
>   	}
> -	if (IS_ERR(inode))
> -		return ERR_CAST(inode);
>   	/* see comments in ceph_get_parent() */
>   	return unlinked ? d_obtain_root(inode) : d_obtain_alias(inode);
>   }

Reviewed-by: Xiubo Li <xiubli@redhat.com>

Thanks!



