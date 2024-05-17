Return-Path: <ceph-devel+bounces-1143-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE5BB8C7F37
	for <lists+ceph-devel@lfdr.de>; Fri, 17 May 2024 02:32:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2CC51C2162C
	for <lists+ceph-devel@lfdr.de>; Fri, 17 May 2024 00:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E9DA38F;
	Fri, 17 May 2024 00:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fRHFVjzN"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B217389
	for <ceph-devel@vger.kernel.org>; Fri, 17 May 2024 00:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715905936; cv=none; b=OUQcQ8STeOCRSbhoiTN3RquH6LZEkHJ5T1HDpWaa32BsSX//EIa2Y6FPRvYF43on0P0BTUA3rMy8WKJQv+xO/kh4O9rBRLcVHTHfahG1zkRljRYGijgK7XfJe4egRlbdRSOxWSypSlH/5X4In4pk2u8K/x+KqoGK67J6bXzqkTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715905936; c=relaxed/simple;
	bh=+1UWA0mcH/Tjhxk6nd6OqwvZ6BbaKE6EGknMI7p9qhU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dyx/n9ENcMfpHhUId9C86l94DKih3wUlyCkL2kVgKyFJPjSBsK+RFRo3oRJALcepz8c5DmVOghYPhUIDDXZv8O0Xjpptd24xDtAH1mJa7ezcmpYqm7L55+1dDT8/jV6+zkIwVd5gNp1N/U2RYpzBE4qf0jUOHBeSihUZEPnvo0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fRHFVjzN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715905933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bcV1xBvkcSNQot3LIomkCVVxXlR7B9GPZeUZhJ2dIV0=;
	b=fRHFVjzN/xgQQxDtXUZHyETU7NRYC4Nu1DbuoPRzbjY/srIvZ0Z0W1DhgAn15aLbze4OKN
	SvCBUZ3Lt66EUbHaacMsemdwTEd/RS80SEcgVlRxD4LFxgNmCR/SUnD5mEkLlf7yTkDrTL
	2c9IWL1CVw7YX+KQGxDNXRKr+2PQ238=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-wxgF-eGNNqyn_gMOdhMCUg-1; Thu, 16 May 2024 20:32:11 -0400
X-MC-Unique: wxgF-eGNNqyn_gMOdhMCUg-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6f441afba80so9749662b3a.3
        for <ceph-devel@vger.kernel.org>; Thu, 16 May 2024 17:32:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715905930; x=1716510730;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bcV1xBvkcSNQot3LIomkCVVxXlR7B9GPZeUZhJ2dIV0=;
        b=DnVSjYlrUUDwJf3lco/kow6/7vi+k9jyHsir8jJcgIlRBJBvotCiPsxwAGHwCmeK0E
         vGwYjMg1EGtry3PV9C0C79GrlWAuA6YFvUtd5JA8yAg0IGfE8QbCs6r0vHbJIs3J80OI
         0zjhWOIgGoFpgzWZG/Y3ZoSjbYLDTVFjiQyRG5loS2BOo0xAmpbPBulNGdnlYeMx4XYo
         Rz8s8rgJgMM/gatunbmV/Wibz8KWOuHIxgXQ5wOOU2m4V6t0N3Co+iQrnX1uLW9DVr58
         5mhLfQGaFQo075kyPyjCIC70RZI4GwommbYcgW8YgDDCI9aLPBgNJAZK/wblTyMivnbT
         k3nA==
X-Forwarded-Encrypted: i=1; AJvYcCUxJiSuatcgUhHH8Bab3VmI164HQXdN+UH1UQhBL6ykQ0DCSSz5D3f6A5JRd5PYmPgfllaeizO0r22GUtqpht/ZgwPsYzRgVY99EQ==
X-Gm-Message-State: AOJu0YyvGGtq1yzCc+5UbRJqiLvzGcNMZkRlGqgN5QHUdlIg+u9qq1UD
	4z855SNrNtqFRdI+wAGMjzQa9XAunzULhchGajmeDV5pKwcltBhpTgwpNkCE5++6yc6wyi5jQyX
	8vl57FCvZavq3eQftCkFhYUdKU+mquMzltZR37jIciEiAJ6B9FobISkL1VlKwiU08BNtPzw==
X-Received: by 2002:a05:6a20:9743:b0:1af:96e8:7b9c with SMTP id adf61e73a8af0-1afde1b7014mr18945762637.47.1715905930091;
        Thu, 16 May 2024 17:32:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZd/Z2rkLzV+15nai1u3XRDVeHbKsPm4XUnP1+54NkyC2o2dJe+wv4JnSf0HKFX/M/x+xl8A==
X-Received: by 2002:a05:6a20:9743:b0:1af:96e8:7b9c with SMTP id adf61e73a8af0-1afde1b7014mr18945749637.47.1715905929599;
        Thu, 16 May 2024 17:32:09 -0700 (PDT)
Received: from [10.72.116.87] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2a6646bsm14100884b3a.15.2024.05.16.17.32.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 May 2024 17:32:09 -0700 (PDT)
Message-ID: <8d0dd0c9-a587-4eb9-9169-26e444a27ba0@redhat.com>
Date: Fri, 17 May 2024 08:32:05 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ceph: fix stale xattr when using read() on dir with '-o
 dirstat'
To: Thorsten Fuchs <t.fuchs@thofu.net>, ceph-devel@vger.kernel.org
References: <20240516170021.3738-1-t.fuchs@thofu.net>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20240516170021.3738-1-t.fuchs@thofu.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Thorsten,

Thanks for your patch.

BTW, could share the steps to reproduce this issue you are trying to fix ?

Maybe this worth to add a test case in ceph qa suite.

Thanks

- Xiubo

On 5/17/24 01:00, Thorsten Fuchs wrote:
> Fixes stale recursive stats (rbytes, rentries, ...) being returned for
> a directory after creating/deleting entries in subdirectories.
>
> Now `getfattr` and `cat` return the same values for the attributes.
>
> Signed-off-by: Thorsten Fuchs <t.fuchs@thofu.net>
> ---
>   fs/ceph/dir.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 0e9f56eaba1e..e3cf76660305 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -2116,12 +2116,16 @@ static ssize_t ceph_read_dir(struct file *file, char __user *buf, size_t size,
>   	struct ceph_dir_file_info *dfi = file->private_data;
>   	struct inode *inode = file_inode(file);
>   	struct ceph_inode_info *ci = ceph_inode(inode);
> -	int left;
> +	int left, err;
>   	const int bufsize = 1024;
>   
>   	if (!ceph_test_mount_opt(ceph_sb_to_fs_client(inode->i_sb), DIRSTAT))
>   		return -EISDIR;
>   
> +	err = ceph_do_getattr(inode, CEPH_STAT_CAP_XATTR, true);
> +	if (err)
> +		return err;
> +
>   	if (!dfi->dir_info) {
>   		dfi->dir_info = kmalloc(bufsize, GFP_KERNEL);
>   		if (!dfi->dir_info)


