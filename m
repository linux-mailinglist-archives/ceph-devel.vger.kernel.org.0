Return-Path: <ceph-devel+bounces-1694-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C40019560B7
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Aug 2024 03:07:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D7C2281744
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Aug 2024 01:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6421E1EB3E;
	Mon, 19 Aug 2024 01:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IPqQRrlk"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2156A1BDC8
	for <ceph-devel@vger.kernel.org>; Mon, 19 Aug 2024 01:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724029619; cv=none; b=GqH9MftRx50zBZ6b3HPK6Fkg5gTaIJOZehie5boDmjfiVj43TYNt3KpLLUiqb64YepoGqwVPw8z+W0I29O8Y4lkR+cP+uuSUaBncAbc13AiITpHcaHkvW4cjbPKhVjPiMZfO/Cr/k1nYXdtDv6wM+NwS0iT8J2IOZJhYbbleZ4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724029619; c=relaxed/simple;
	bh=L6c1J2WXrp7NVX37JVowYQZSo6lUpBH4Ibe6W3H0r+0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p6brkdjXppp1Y5Ka8GzDiKFuRQdVHAiMknS0nIL26vK27hshuawy+3eLqVPnu8rKusGyFpScDNSBBo3Ho+FXLtmrOy65u6asFlPhJJ+TSpGxmW15qUEBWzxVktXusSXonIIxwksOXlFJ1mMrV5P5HKc3/dDeOP1FyzoZl3Xi4Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IPqQRrlk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724029616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6UJxCUfooDx982PsvxoAPnrAaQ78Ph8CMB2TyRJoz2g=;
	b=IPqQRrlk3oMPHzeIUJ9HIoorLUPltQp6CD812nEF6S6iX6Ch93VWjb6IgZ4TACQsrGAonD
	LNidU1A5NfCnwrV3XbP3BkOkHSD5zYDXDR0TMEBIx4AEYqOQsYjtoAFiWgVKLl3Sztw9Q2
	hHro/Xv0mH5jsguzCF7MnQ6CJc/LvVw=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-520-Z97Ew8jTPJq8WulMPgrgQQ-1; Sun, 18 Aug 2024 21:06:52 -0400
X-MC-Unique: Z97Ew8jTPJq8WulMPgrgQQ-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-713ca4e7af3so2823767b3a.1
        for <ceph-devel@vger.kernel.org>; Sun, 18 Aug 2024 18:06:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724029611; x=1724634411;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6UJxCUfooDx982PsvxoAPnrAaQ78Ph8CMB2TyRJoz2g=;
        b=i85yfLuQc8Pr0mXV757MlHBrdGO30RhIIPVweeMl5lAnGqBOHavZYpi/g+SmmGPEC4
         BJjGZdIE9n2iz/bRq9rCunLTnjDkJNdUPlP9DI+/Eb0OOgJAi6ccpW5U+3ZbSBla3wNh
         d7hwDqn5PnhZykbxuUHfDwWd/ti0/3hCmZuxfNxi2V7hNh6oLsYryPaGIK1+85SQTVr7
         lBnpWFoeywWXFqyXA5bhLpYaVB+IsnZI2UCuY/5x8elpR48KhHj1Ti9bur8T7Ih9pC/7
         WdGL18mIp6xaUxa5zlSFgVTPWhcKfY27C7dj6fNPOLvgWdz/XB2mClRlD/4HlWitiZD3
         uTLQ==
X-Gm-Message-State: AOJu0YzkhNu8ffknUoSewCMzKGdDgNQiZ/2XMcoJWg6JjlIUX7ZfmNgn
	T5q0sBcJDWOd2VlDJ5mfXG5C00qxp93U1XM2K/p/+iqtpuSBia6K92+3bxcQgylCzy2/Tm2FGNd
	5ZHYchtaB+wgHM6njANWY9qKs6YhORxuV/CwxT9h0A+izlJjacZGtEe3JLRU=
X-Received: by 2002:a05:6a00:c94:b0:70d:2a5d:867f with SMTP id d2e1a72fcca58-713c4ef433fmr12334990b3a.21.1724029611389;
        Sun, 18 Aug 2024 18:06:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE//KdPTvqm57ETLoKkIWgG6I19lqqUn2OnAzMMhg/yCUF7bwIQ9qbAigULIcGNWz8ku3u71w==
X-Received: by 2002:a05:6a00:c94:b0:70d:2a5d:867f with SMTP id d2e1a72fcca58-713c4ef433fmr12334967b3a.21.1724029610885;
        Sun, 18 Aug 2024 18:06:50 -0700 (PDT)
Received: from [10.72.116.30] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127aef6590sm5686002b3a.131.2024.08.18.18.06.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Aug 2024 18:06:50 -0700 (PDT)
Message-ID: <b8c6e357-29f2-4da2-ab57-7035627b0bd2@redhat.com>
Date: Mon, 19 Aug 2024 09:06:45 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ceph: fix memory in MDS client cap_auths
To: "Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
 Ilya Dryomov <idryomov@gmail.com>, Milind Changire <mchangir@redhat.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240814101750.13293-1-luis.henriques@linux.dev>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20240814101750.13293-1-luis.henriques@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Luis,

Good catch!

On 8/14/24 18:17, Luis Henriques (SUSE) wrote:
> The cap_auths that are allocated during an MDS session opening are never
> released, causing a memory leak detected by kmemleak.  Fix this by freeing
> the memory allocated when shutting down the mds client.
>
> Fixes: 1d17de9534cb ("ceph: save cap_auths in MDS client when session is opened")
> Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
> ---
>   fs/ceph/mds_client.c | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 276e34ab3e2c..d798d0a5b2b1 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -6015,6 +6015,20 @@ static void ceph_mdsc_stop(struct ceph_mds_client *mdsc)
>   		ceph_mdsmap_destroy(mdsc->mdsmap);
>   	kfree(mdsc->sessions);
>   	ceph_caps_finalize(mdsc);
> +
> +	if (mdsc->s_cap_auths) {
> +		int i;
> +
> +		mutex_lock(&mdsc->mutex);

BTW, is the lock really needed here ?

IMO it should be safe to remove it because once here the sb has already 
been killed and the 'mdsc->stopping' will help guarantee that there 
won't be any other thread will access to 'mdsc', Isn't it ?

Else we need to do the lock from the beginning of this function.

Thanks

- Xiubo

> +		for (i = 0; i < mdsc->s_cap_auths_num; i++) {
> +			kfree(mdsc->s_cap_auths[i].match.gids);
> +			kfree(mdsc->s_cap_auths[i].match.path);
> +			kfree(mdsc->s_cap_auths[i].match.fs_name);
> +		}
> +		kfree(mdsc->s_cap_auths);
> +		mutex_unlock(&mdsc->mutex);
> +	}
> +
>   	ceph_pool_perm_destroy(mdsc);
>   }
>   
>


