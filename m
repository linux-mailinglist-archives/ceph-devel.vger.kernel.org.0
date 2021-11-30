Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B97346351A
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Nov 2021 14:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236864AbhK3NLm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Nov 2021 08:11:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30598 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236431AbhK3NLk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 08:11:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638277700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6E++ExhbFoggwC5GZdsHFI3j4g+ZxuS6HTqxeM8zyao=;
        b=akkeUYqj5kBTaFdgpWB3CtBrlqYtDRwuEylx1TkD6u+2iafT3VPTnB0fj6CddAhFHPwP6y
        jSakJDOEH/9w74Zafi1IqhZhmf0JHMKK4SRswn33bKfTEGBIJeY4AqPwknH64b5Z65M0un
        3LEOdeijqNvPRw65S2IuVIEWqhyxweg=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-I0oLVe15NauHx_bLgHJfcg-1; Tue, 30 Nov 2021 08:08:19 -0500
X-MC-Unique: I0oLVe15NauHx_bLgHJfcg-1
Received: by mail-pl1-f198.google.com with SMTP id p24-20020a170902a41800b001438d6c7d71so8197739plq.7
        for <ceph-devel@vger.kernel.org>; Tue, 30 Nov 2021 05:08:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6E++ExhbFoggwC5GZdsHFI3j4g+ZxuS6HTqxeM8zyao=;
        b=JiofYSOhcjJwePA0mxbnXznN3AKuJ63fga/HqEnOEyqlvQ4Ob2/TjxHn1sWStAsICs
         qOHpTKx9nnHrV57IJP3mzUtoA7braUux/HWEsDEdNbN+9Qpfys2Qkatg9DWy6+541UNc
         C3evy8iXjCFjLv2ABNI6th3lbcHEliLmO/sMpTRkQgjw75qo3qu8SEUyTNy8GE+sDbVy
         c+wTzZd0gnbKEWtk00A0EaXEZyXuCX3e+beJqXihYBELZLFYGFpHsXQuNFQXlNX5cLVM
         kzKdW+sd7uIcBNVvgR9kCmO9+2EIn7FzWifV5kdsmmixcyclAw6aP6f05QoyuDI5vtNx
         eZ5g==
X-Gm-Message-State: AOAM533wfrJOnVtXkHIpkACp2GyOwVhr90pEXk9rWjZpTVr9GOAnAo1o
        3S0/RiCA2/YQJxd7peF/1fVvdD9tAb90yLTsW8KeMTE6zx43udTW6ogCXQskfX35K7YhuE8FtdD
        RYrmJmi8CiUypoZZ1h7AYfw==
X-Received: by 2002:a17:90a:dc15:: with SMTP id i21mr5894071pjv.183.1638277696266;
        Tue, 30 Nov 2021 05:08:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzT/T1Z+w/dhdWMhcOZbbUz9fKNFPmbzzQLLWmbvc7lyZ/dCRz5nz2begLvQl9Rj1FG07D0fA==
X-Received: by 2002:a17:90a:dc15:: with SMTP id i21mr5893617pjv.183.1638277693145;
        Tue, 30 Nov 2021 05:08:13 -0800 (PST)
Received: from [10.72.12.65] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 16sm8521459pgu.93.2021.11.30.05.08.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 05:08:12 -0800 (PST)
Subject: Re: [PATCH] ceph: drop send metrics debug message
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
References: <20211130125112.9710-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <caf69ace-37fb-7442-da68-c1b82bce467b@redhat.com>
Date:   Tue, 30 Nov 2021 21:08:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211130125112.9710-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/30/21 8:51 PM, Jeff Layton wrote:
> This pops every second and isn't very useful.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/metric.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> index c57699d8408d..0fcba68f9a99 100644
> --- a/fs/ceph/metric.c
> +++ b/fs/ceph/metric.c
> @@ -160,8 +160,6 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
>   	msg->hdr.version = cpu_to_le16(1);
>   	msg->hdr.compat_version = cpu_to_le16(1);
>   	msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
> -	dout("client%llu send metrics to mds%d\n",
> -	     ceph_client_gid(mdsc->fsc->client), s->s_mds);
>   	ceph_con_send(&s->s_con, msg);
>   
>   	return true;
Reviewed-by: Xiubo Li <xiubli@redhat.com>

