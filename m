Return-Path: <ceph-devel+bounces-1699-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61A8A956897
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Aug 2024 12:33:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E25E283D9E
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Aug 2024 10:33:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4975115B15D;
	Mon, 19 Aug 2024 10:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W0nK3+GN"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764851607AB
	for <ceph-devel@vger.kernel.org>; Mon, 19 Aug 2024 10:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724063610; cv=none; b=D10gbEJoTN4Rd74kF5Yf2fQWG+SM3CUvbr42pM+5ikN6OgAmvNCfT4klcm9Ah1rkU5+NQTOqhqUhZ9zxtf9KdcNIFnBaUFny6aQq8GFBQpjAeDhqazAuVzu3R9T9RTE/4/6DsgNWI+B3TQBB9qudlkEr3UfYi6XywLjfMUmDw/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724063610; c=relaxed/simple;
	bh=ksM9jUYsIPvfvdmnq7YYGhoJD+RKEJJHwouJTHkKhKs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wk/R1k4Qj2HCIItJ2ELJAiPufDcftgwGP0qcRYh/W78xKOh1UaosuexdzQI0QoyzoFt07vA6rN7Mti+lrDlpAR5HOfFsrbf0pK/f4psdv2Tr5dm4poQQl4c2YpinT4zU+zmjTGjV1k3g5SNIN0NNHZ6XBSIsDXAgVPdjY9wI88Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W0nK3+GN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724063608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wmIbOrxDtvXOoZbZMr4nmgxGDaAym4vjdVSm0EMN42I=;
	b=W0nK3+GNHubyHaFctKZVydmvfEH+pFZI/+M/2wnltMDWDdkxjWfvAx5FiF9r3xOou8Z8Bu
	me5NVzQ2fwMTK5rT2EpMzPGX5j1WEnqN1coipaCgTU5/gItRjLcTl+oZ16mcpUdiIFjlQa
	cV16xA7OSVimDGeG3KDFGlW1nQ90zy4=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-27Sn9IwnMRuA6ol0tw3u9Q-1; Mon, 19 Aug 2024 06:33:27 -0400
X-MC-Unique: 27Sn9IwnMRuA6ol0tw3u9Q-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2d3c0088813so3720732a91.1
        for <ceph-devel@vger.kernel.org>; Mon, 19 Aug 2024 03:33:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724063606; x=1724668406;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wmIbOrxDtvXOoZbZMr4nmgxGDaAym4vjdVSm0EMN42I=;
        b=NUdPiyQ6v79AyXfW0DWNRcRYM+zhWEKep+X1kSvPhr2E8XVxiiW+xxu5lBDMKlTsbr
         aaUj8WSjzn4WxtczQ9H5jf23RkehgchLg305L11+Ds0/NyHwouSgF6InlkR9gYX5CpLF
         4lpTG416RtnDpnAnNOqlBOXV7GVsTXIMGlnVoEo2VNRduHx5lPcs7EIPAnduLhi1T36y
         TOMwhA6KcPOnNdHxrYjn7f7vwPTApiEbApR5ntNXD9FEk1ycX5BvuPvQmHmndCWNv/Gt
         jJ9cO3Xk/vfoyuWdj00W7gHEvAOB4UHyjXMJnSqi62z6hjZIBNu/pPOHw2oS1BKbWrgd
         sBvw==
X-Gm-Message-State: AOJu0YxMt+qsqLgR0UNtqXH8KpcYZrMbGRUT/mGDCPqjCV0JXUb4eVr+
	bd9iqdvmOwxqKR2WmUDY8QNgVG6hcfB8sbzhI4QMBfs7QMQdl/8qWvnUFbbnopJ0TlC7L2Nfw1Y
	kbIzqbomgoB+T+/BvEYlm8K4pAHsKb+P1DNHCIiNvOngWznbKp7O6f/CGRwc=
X-Received: by 2002:a17:90b:238d:b0:2c9:9eb3:8477 with SMTP id 98e67ed59e1d1-2d3dfc6b117mr8947533a91.16.1724063606064;
        Mon, 19 Aug 2024 03:33:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGqOEd9IUMwqTR7dUGvVwj2MvBYZAh4vjdUIO0TAjDZont7V9TKefsVCjoVrWsmSivBJiZCeg==
X-Received: by 2002:a17:90b:238d:b0:2c9:9eb3:8477 with SMTP id 98e67ed59e1d1-2d3dfc6b117mr8947517a91.16.1724063605615;
        Mon, 19 Aug 2024 03:33:25 -0700 (PDT)
Received: from [10.72.116.30] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d3e4a39279sm6842266a91.3.2024.08.19.03.33.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2024 03:33:25 -0700 (PDT)
Message-ID: <9385a27a-da34-4bb3-96a4-9e54f5273d0c@redhat.com>
Date: Mon, 19 Aug 2024 18:33:20 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ceph: fix memory in MDS client cap_auths
To: "Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
 Ilya Dryomov <idryomov@gmail.com>, Milind Changire <mchangir@redhat.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240819095217.6415-1-luis.henriques@linux.dev>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20240819095217.6415-1-luis.henriques@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 8/19/24 17:52, Luis Henriques (SUSE) wrote:
> The cap_auths that are allocated during an MDS session opening are never
> released, causing a memory leak detected by kmemleak.  Fix this by freeing
> the memory allocated when shutting down the mds client.
>
> Fixes: 1d17de9534cb ("ceph: save cap_auths in MDS client when session is opened")
> Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
> ---
> Changes since v1:
>   * dropped mdsc->mutex locking as we don't need it at this point
>
>   fs/ceph/mds_client.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 276e34ab3e2c..2e4b3ee7446c 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -6015,6 +6015,18 @@ static void ceph_mdsc_stop(struct ceph_mds_client *mdsc)
>   		ceph_mdsmap_destroy(mdsc->mdsmap);
>   	kfree(mdsc->sessions);
>   	ceph_caps_finalize(mdsc);
> +
> +	if (mdsc->s_cap_auths) {
> +		int i;
> +
> +		for (i = 0; i < mdsc->s_cap_auths_num; i++) {
> +			kfree(mdsc->s_cap_auths[i].match.gids);
> +			kfree(mdsc->s_cap_auths[i].match.path);
> +			kfree(mdsc->s_cap_auths[i].match.fs_name);
> +		}
> +		kfree(mdsc->s_cap_auths);
> +	}
> +
>   	ceph_pool_perm_destroy(mdsc);
>   }
>   

LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>

Will apply to the testing branch and run the tests.

Thanks Luis

- Xiubo



