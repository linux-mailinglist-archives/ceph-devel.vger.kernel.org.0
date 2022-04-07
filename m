Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6DF64F87A4
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Apr 2022 21:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbiDGTFY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Apr 2022 15:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiDGTFX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Apr 2022 15:05:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1C4DA2300BA
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 12:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649358200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pon5Ck2XRRCFnZm9wVEec+ZiDBI1n0xXQ/6Hgy8EXoM=;
        b=NynZGYr65Y/dcuh8POlBx0YFU0+6i6I/XJUAREAHJQ2Cz6mx9nIa8I/pnEypCQr4BtmkHf
        P1B4OOlrO27wtt7fvfTY0txZv0X7uUi3DPfZ/rH1HP5KVoFbrsrjD/9fDOD+tp42kGKsue
        wlNioMQof294B7cfi9mZqMYF3gY2ATI=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-6Op8FoQfNV6mRbhEC1ClMQ-1; Thu, 07 Apr 2022 15:03:18 -0400
X-MC-Unique: 6Op8FoQfNV6mRbhEC1ClMQ-1
Received: by mail-pl1-f198.google.com with SMTP id i16-20020a170902cf1000b001540b6a09e3so3320767plg.0
        for <ceph-devel@vger.kernel.org>; Thu, 07 Apr 2022 12:03:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=pon5Ck2XRRCFnZm9wVEec+ZiDBI1n0xXQ/6Hgy8EXoM=;
        b=yjS1R7sGhR4WCzuqvNXDu6xmAmwFn/tMEDaeAROqqx60H3NMh/Y+f7lmhXnoLrd1JC
         UdefMDRHl1CK+OyjYzffT4QJ/wecO0zJpQB5Kmpp47M+6+huPCAUaeWsw7ok/EUWX29Z
         bQUezT1+IXuMHOxIz+WqDPbw0pv5E/jO4SmttZhwHE0wUzQeipVI/byt7cAcLkD7707X
         E9fDTf+krIgYPojvRIE7zVKDsr0esY8584ZLQKNOa8JSzgB4hF35Flfu0e38VpBYDAyG
         8rzQy8nL7L2xjUShplGk26C+PDQz5o3s5DHMdq2fJWGaJh8AK5SOXP9H60vDT0s2mjWp
         uKsg==
X-Gm-Message-State: AOAM531OxZ1+G1KE6HbzBdJNt5C1eJBdvtCPJ/yTDJPY5Q5w/5pIukSa
        GSDBBHOIAq0dPGJsnYj2Z3gJvg43nAyv6x4+/DXtyaMBqv6GT7DgOkouhAzq/nwrdi4KSLDB90K
        YEUNzWUJeHBYt+DklcSth8g==
X-Received: by 2002:a17:90a:d0c5:b0:1c9:ec78:18e5 with SMTP id y5-20020a17090ad0c500b001c9ec7818e5mr17533268pjw.53.1649358197606;
        Thu, 07 Apr 2022 12:03:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylnAgooOiWm/xSsqvqv4wdUxkJJGLLkqcAUyb8cQzjPAYjuA6jtOkqXKk4Z5O9DTdmxReeoA==
X-Received: by 2002:a17:90a:d0c5:b0:1c9:ec78:18e5 with SMTP id y5-20020a17090ad0c500b001c9ec7818e5mr17533238pjw.53.1649358197272;
        Thu, 07 Apr 2022 12:03:17 -0700 (PDT)
Received: from [10.72.12.194] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 132-20020a62168a000000b004f40e8b3133sm24024855pfw.188.2022.04.07.12.03.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 12:03:16 -0700 (PDT)
Subject: Re: [PATCH v4] ceph: invalidate pages when doing direct/sync writes
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220407151521.7968-1-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <385d353d-56d8-8f2a-b468-2aae048f59ef@redhat.com>
Date:   Fri, 8 Apr 2022 03:03:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220407151521.7968-1-lhenriques@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/7/22 11:15 PM, Luís Henriques wrote:
> When doing a direct/sync write, we need to invalidate the page cache in
> the range being written to.  If we don't do this, the cache will include
> invalid data as we just did a write that avoided the page cache.
>
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
>   fs/ceph/file.c | 19 ++++++++++++++-----
>   1 file changed, 14 insertions(+), 5 deletions(-)
>
> Changes since v3:
> - Dropped initial call to invalidate_inode_pages2_range()
> - Added extra comment to document invalidation
>
> Changes since v2:
> - Invalidation needs to be done after a write
>
> Changes since v1:
> - Replaced truncate_inode_pages_range() by invalidate_inode_pages2_range
> - Call fscache_invalidate with FSCACHE_INVAL_DIO_WRITE if we're doing DIO
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 5072570c2203..97f764b2fbdd 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1606,11 +1606,6 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
>   		return ret;
>   
>   	ceph_fscache_invalidate(inode, false);
> -	ret = invalidate_inode_pages2_range(inode->i_mapping,
> -					    pos >> PAGE_SHIFT,
> -					    (pos + count - 1) >> PAGE_SHIFT);
> -	if (ret < 0)
> -		dout("invalidate_inode_pages2_range returned %d\n", ret);
>   
>   	while ((len = iov_iter_count(from)) > 0) {
>   		size_t left;
> @@ -1938,6 +1933,20 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
>   			break;
>   		}
>   		ceph_clear_error_write(ci);
> +
> +		/*
> +		 * we need to invalidate the page cache here, otherwise the
> +		 * cache will include invalid data in direct/sync writes.
> +		 */
> +		ret = invalidate_inode_pages2_range(

IMO we'd better use truncate_inode_pages_range() after write. The above 
means it's possibly will write the dirty pagecache back, which will 
overwrite and corrupt the disk data just wrote.

Though it seems impossible that these pagecaches will be marked dirty, 
but this call is misleading ?

-- Xiubo

> +				inode->i_mapping,
> +				pos >> PAGE_SHIFT,
> +				(pos + len - 1) >> PAGE_SHIFT);
> +		if (ret < 0) {
> +			dout("invalidate_inode_pages2_range returned %d\n",
> +			     ret);
> +			ret = 0;
> +		}
>   		pos += len;
>   		written += len;
>   		dout("sync_write written %d\n", written);
>

