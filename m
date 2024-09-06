Return-Path: <ceph-devel+bounces-1796-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DFBD496F2A3
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2024 13:18:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C8EF1F24CEC
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2024 11:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA5641CB14B;
	Fri,  6 Sep 2024 11:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aCe8Vxi2"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E517D1C9ED9
	for <ceph-devel@vger.kernel.org>; Fri,  6 Sep 2024 11:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725621475; cv=none; b=ZmOoEFWLhz8s20l0uE5D/BCfMpW1kmaoTi07H5CZa+vNcoO0Le9Jllgp4ysaAxqouuD9WNRWbCTnASGvQjB36dNdsJWXgcyn1riRtEmZ2eI/+n1wsHI7VgoyAXSZ9zhDFcn3dm/V9YSPyPh/soZ1vksbBuFj/F+54RotnYd7RCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725621475; c=relaxed/simple;
	bh=33WmJ6z4GVcj4ymBDnCPtgDMzJaZHvgBIQ/qO4MMz/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qc+kvGMK0BjeK/k9RANn3SMCqAn+FU8ELwnDbkV/BDnX32MtrAJJrIdYGMTfBDulLKEK7eE8jJ216Ib+1yEWApdJE5UlmemxlCSjSeOQAwtHqNybHPCiT0AQ/efeGHs08HtH49DylaLMHGPEm+GudM6/gqjGX5a9uJGAMK2MlYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aCe8Vxi2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725621473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5hd9vr/t5eqP45j4XGPsRu0IifOYzCYKx41RgaE9vsA=;
	b=aCe8Vxi2n09OHeoabzGswQpakAv8XXIaS47aNEkV4S+h/9KnZxslhjO2qDQbjU+l9vcFPg
	0y4OPb8XKipE3b/9wFsMuCJqhDR85unvGhKpl/LzezzUI0AvhVtuwL3z3RN0cGuZZ1l7+l
	gPoLjW+bSaLO8qCjoJRzlDGUZ2AwHcY=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-RXViK2_pNk-6ZUaMaG3sJg-1; Fri, 06 Sep 2024 07:17:52 -0400
X-MC-Unique: RXViK2_pNk-6ZUaMaG3sJg-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-5dfbd897bd7so1784877eaf.0
        for <ceph-devel@vger.kernel.org>; Fri, 06 Sep 2024 04:17:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725621471; x=1726226271;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5hd9vr/t5eqP45j4XGPsRu0IifOYzCYKx41RgaE9vsA=;
        b=bKXmxNiIkY3Js+zZeksKVRPExGaRWLHRPt76WexOxiX4ezwRFHossIj2T4xt7JWwea
         kJKWaGDl31urqxJIL6pGuZ34chpysYXOkKwpJg9aBlPuT+g5NqXSeUzxqDsSyp6wS3cG
         EvrU2LYEwY3dTO5X9E5/+mHRI5NCH2eoMP5HSCALTejaJ9qOLuFuMAS7Rj3FHJWf0oK7
         I2/K/Hzo0dh5esIibDEuOfvvSZyFlJwQKZ1/alkP/qL+LvznIDmRDSk6lOP63WsvQruD
         4jLZ+mO/1fm8vU+j3BVuldKjGGKcXunP86WE92reeGmW3spuI3gHW6XvhpRl4xe2Ilm5
         UqPg==
X-Gm-Message-State: AOJu0YwbRO+8vynKjcfvqGTZTVmU9yv3R3v1tk4qyy+AcsiniXXjkaEe
	IppZOYXv5xWRkrYaELa3V00EFfU+OzJ0NZidvYXGPux+g/Xvei9ssUgqiH5v7dzJ+v9v7TxMkYN
	yp2JpZ1E0sHrzaTC+UoxIE/q4G4jNNCoUbQg4DoZavlafh8RoA00vvY+hdbk=
X-Received: by 2002:a05:6358:42a3:b0:1b8:3468:3f3b with SMTP id e5c5f4694b2df-1b8385b2bd6mr270354055d.3.1725621471202;
        Fri, 06 Sep 2024 04:17:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0b3CPNWdr96k+swZHhVsna7JWFJ3f/bRXBMkN33eLrI4Nvyj7sEt7UIMTwmPlWyv3ea90Rg==
X-Received: by 2002:a05:6358:42a3:b0:1b8:3468:3f3b with SMTP id e5c5f4694b2df-1b8385b2bd6mr270351755d.3.1725621470785;
        Fri, 06 Sep 2024 04:17:50 -0700 (PDT)
Received: from [10.72.116.139] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-717971b2880sm1856736b3a.165.2024.09.06.04.17.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2024 04:17:50 -0700 (PDT)
Message-ID: <e1c50195-07a9-4634-be01-71f4567daa54@redhat.com>
Date: Fri, 6 Sep 2024 19:17:45 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2] ceph: ceph: fix out-of-bound array access when
 doing a file read
To: "Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
 Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240905135700.16394-1-luis.henriques@linux.dev>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20240905135700.16394-1-luis.henriques@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 9/5/24 21:57, Luis Henriques (SUSE) wrote:
> __ceph_sync_read() does not correctly handle reads when the inode size is
> zero.  It is easy to hit a NULL pointer dereference by continuously reading
> a file while, on another client, we keep truncating and writing new data
> into it.
>
> The NULL pointer dereference happens when the inode size is zero but the
> read op returns some data (ceph_osdc_wait_request()).  This will lead to
> 'left' being set to a huge value due to the overflow in:
>
> 	left = i_size - off;
>
> and, in the loop that follows, the pages[] array being accessed beyond
> num_pages.
>
> This patch fixes the issue simply by checking the inode size and returning
> if it is zero, even if there was data from the read op.
>
> Link: https://tracker.ceph.com/issues/67524
> Fixes: 1065da21e5df ("ceph: stop copying to iter at EOF on sync reads")
> Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
> ---
>   fs/ceph/file.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 4b8d59ebda00..41d4eac128bb 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1066,7 +1066,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>   	if (ceph_inode_is_shutdown(inode))
>   		return -EIO;
>   
> -	if (!len)
> +	if (!len || !i_size)
>   		return 0;
>   	/*
>   	 * flush any page cache pages in this range.  this
> @@ -1154,6 +1154,9 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>   		doutc(cl, "%llu~%llu got %zd i_size %llu%s\n", off, len,
>   		      ret, i_size, (more ? " MORE" : ""));
>   
> +		if (i_size == 0)
> +			ret = 0;
> +
>   		/* Fix it to go to end of extent map */
>   		if (sparse && ret >= 0)
>   			ret = ceph_sparse_ext_map_end(op);
>
Hi Luis,

BTW, so in the following code:

1202                 idx = 0;
1203                 if (ret <= 0)
1204                         left = 0;
1205                 else if (off + ret > i_size)
1206                         left = i_size - off;
1207                 else
1208                         left = ret;

The 'ret' should be larger than '0', right ?

If so we do not check anf fix it in the 'else if' branch instead?

Because currently the read path code won't exit directly and keep 
retrying to read if it found that the real content length is longer than 
the local 'i_size'.

Again I am afraid your current fix will break the MIX filelock semantic ?

Thanks

- Xiubo


