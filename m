Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9088459985
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Nov 2021 02:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhKWBNr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 22 Nov 2021 20:13:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38500 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230201AbhKWBNq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 20:13:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637629839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fDZ4QC7mkPSUsLnVG9XVrKUi8o3lZ1KM+UM/vtFTqUw=;
        b=hydrvsUQpTdF1ODW3/NTAbHaPYVBWX9Gzb9CKGXDldQgipgG2zH2eOOOX3UkghORmxFlME
        LPo1iYUZx+2COgETN6pg4gSxWs40E5G2BTz+DIgK2nfqvNzbOO09nqlpLMzuI6FSPvcZh9
        ZxPLtAKAGnQH6RZtJsS1tWjQSHFNRIM=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-cgfFpCCLOiOKRAWnG0890w-1; Mon, 22 Nov 2021 20:10:37 -0500
X-MC-Unique: cgfFpCCLOiOKRAWnG0890w-1
Received: by mail-pg1-f198.google.com with SMTP id y18-20020a634952000000b002ecc060ccc8so7057009pgk.17
        for <ceph-devel@vger.kernel.org>; Mon, 22 Nov 2021 17:10:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=fDZ4QC7mkPSUsLnVG9XVrKUi8o3lZ1KM+UM/vtFTqUw=;
        b=ZtGgtxNTzkU37fQDm7er/34AQ+5oDCtoS6y+AXKT7l9gb/jrq9/1I336G1ULdyPxhn
         OJo2D8Y1U9nvKSnOD4f0jxoZf/SxstEHLKKCYJY+XmeKLWpbO85Vq1fBxk2SRg+8XoZo
         dfgV4Z+RJuyaS0neyTXCOZpQugblTg3mvE5i+ZKLg8DX2DwYnzkaJeq5MZDtNrsC59vt
         7XJnSAmgKv9hq8PjYWia28YvqMPyYMsUEhU/9b/Z4uSmqHJL7webHOJG8mih0Pz/hfIp
         0Pcf1fAQVptYErkSdxj0E9oU7jfGOXl4Go3N8k4N2uyN2KYavWg4D1VDHsbZmgSG/ofD
         Xl/Q==
X-Gm-Message-State: AOAM532d7bsPPkmWJPCzrMtvyvEdKt+AyNMNPNp8+lGJybU+rqTtxbxx
        RHosFNjdZBMPwRgzNLykCMvIDbYyZbHdAH564oRWWC5CwaEkCZyg5vxl5ps4zU0nKBWZBRvuwCe
        CiddDWY+0VWKCaEtyivra74DVmTGg9EN3AlgwgvOUi2+pdOvL+3AQFOMVLZQLIfM9CrBgLIs=
X-Received: by 2002:a63:ea51:: with SMTP id l17mr919859pgk.363.1637629835743;
        Mon, 22 Nov 2021 17:10:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwPSF0CzxU6S20ACGVW3v8X13j7dy/+RMmSlR/Ed7RDWTd1xKIJT0otJY9ojHNHE6HvUH3EYg==
X-Received: by 2002:a63:ea51:: with SMTP id l17mr919812pgk.363.1637629835239;
        Mon, 22 Nov 2021 17:10:35 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p37sm8277308pfh.97.2021.11.22.17.10.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 17:10:34 -0800 (PST)
Subject: Re: [PATCH] ceph: fix duplicate increment of opened_inodes metric
To:     Hu Weiwen <sehuww@mail.scut.edu.cn>, ceph-devel@vger.kernel.org
References: <20211122142212.1621-1-sehuww@mail.scut.edu.cn>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <0a5ca59d-6170-f8ef-24da-1e0c44d262fc@redhat.com>
Date:   Tue, 23 Nov 2021 09:10:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211122142212.1621-1-sehuww@mail.scut.edu.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/22/21 10:22 PM, Hu Weiwen wrote:
> opened_inodes is incremented twice when the same inode is opened twice
> with O_RDONLY and O_WRONLY respectively.
>
> To reproduce, run this python script, then check the metrics:
>
> import os
> for _ in range(10000):
>      fd_r = os.open('a', os.O_RDONLY)
>      fd_w = os.open('a', os.O_WRONLY)
>      os.close(fd_r)
>      os.close(fd_w)
>
> Fixes: 1dd8d4708136 ("ceph: metrics for opened files, pinned caps and opened inodes")
> Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> ---
>   fs/ceph/caps.c | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index b9460b6fb76f..c447fa2e2d1f 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4350,7 +4350,7 @@ void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
>   {
>   	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(ci->vfs_inode.i_sb);
>   	int bits = (fmode << 1) | 1;
> -	bool is_opened = false;
> +	bool already_opened = false;
>   	int i;
>   
>   	if (count == 1)
> @@ -4358,19 +4358,19 @@ void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
>   
>   	spin_lock(&ci->i_ceph_lock);
>   	for (i = 0; i < CEPH_FILE_MODE_BITS; i++) {
> -		if (bits & (1 << i))
> -			ci->i_nr_by_mode[i] += count;
> -
>   		/*
> -		 * If any of the mode ref is larger than 1,
> +		 * If any of the mode ref is larger than 0,
>   		 * that means it has been already opened by
>   		 * others. Just skip checking the PIN ref.
>   		 */
> -		if (i && ci->i_nr_by_mode[i] > 1)
> -			is_opened = true;
> +		if (i && ci->i_nr_by_mode[i])
> +			already_opened = true;
> +
> +		if (bits & (1 << i))
> +			ci->i_nr_by_mode[i] += count;
>   	}
>   
> -	if (!is_opened)
> +	if (!already_opened)
>   		percpu_counter_inc(&mdsc->metric.opened_inodes);
>   	spin_unlock(&ci->i_ceph_lock);
>   }

LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>



