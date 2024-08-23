Return-Path: <ceph-devel+bounces-1728-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84EF295C2F6
	for <lists+ceph-devel@lfdr.de>; Fri, 23 Aug 2024 03:48:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35BF0284B7A
	for <lists+ceph-devel@lfdr.de>; Fri, 23 Aug 2024 01:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A82C81CAA2;
	Fri, 23 Aug 2024 01:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C3J0ugtl"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8078F17997
	for <ceph-devel@vger.kernel.org>; Fri, 23 Aug 2024 01:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724377706; cv=none; b=qCsAd0FX+RauvaFE1K6OaTTYLqiLTGRxiY0Ikz6F3HGhuKHNc2gVFMAGvJgbx26x+gNCVpO1oODOCugZI+ugK2cgQelOsZ3wGzt0l7RaOZDm49Kot4AySfZBKRbclRNw0HVVYxfHvOCpSApA6z9di8Fc1/HV7d7fa5qzDQX3T2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724377706; c=relaxed/simple;
	bh=RpzL1uYe7SMAgvpYfvysMyvngm13XZG+cN+Z55yplPQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fP7xn9Idb3HWpeqemkMhh8nLAeiOfHv+ECv0BGOfhMTjkcwBdIoUfp0dd9QwJFPOcXPx9bM6pRQRGtUkD/8HFOi6oadsAxdYQ6EThK2L4CDx3c1MmLjRDB81ZDacj3HHEOkW4kXrtit/PxKi2oJAph1dlX//9VaLPBHFWo0bkcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C3J0ugtl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724377703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=om6Hp3Z9ltJn8YAX0+4J+Ujtm357YatEMZ9GIh0Ak2g=;
	b=C3J0ugtlnlp8QiuUP7vNB/ZGPlaYiatN/BMiGqGLFNmFKKDg5HyiIAPVxbEe9D0uPkkedO
	s9C177rMXZBt5YLOQO6BXE4LQqwigX2aQSXD5sp7vUrAJR47PCVhClItgRQLnVO2AsWnMZ
	3YT+B2AV+tW0cYxRXav8J1z7Jc4WA2s=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-IqJ1ywUsOqOpohY4prWULw-1; Thu, 22 Aug 2024 21:48:22 -0400
X-MC-Unique: IqJ1ywUsOqOpohY4prWULw-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-7143374da57so1484800b3a.1
        for <ceph-devel@vger.kernel.org>; Thu, 22 Aug 2024 18:48:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724377701; x=1724982501;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=om6Hp3Z9ltJn8YAX0+4J+Ujtm357YatEMZ9GIh0Ak2g=;
        b=UvvIBSPydhQksy5NzgIXnk/EAkVpMuOd2Dyvws6+d3FfS9FlJZ798LTyndjY0Ghumk
         oVxlrJrINyUUyjr62ras/j9I6gtTVCrA7dc8zROlXs9eKW+M2FRPUKE4HV9mRRQvWmcu
         XjG+FAy5XQM7T2t/FYp5celfVgnrsNRA+JsME+ttf00+PAaVKHiZ3JwsABIGMJCh8sH9
         mHkvq/XzSGTBZsMp/MpkrcQ/FY/p96k7w2/+OErviySx5wD8+/LLiNN6oJs7O3MguNrP
         xdityKqeXNxByvxPNBCtGXjcuOxoqTjPCd/luw2fUaTD5pbifNSAvKiLghqjT+VHcEqs
         XFBQ==
X-Gm-Message-State: AOJu0YyVqvrQyp4HXqkvDitxX/WwtGLcEmCIIyed9tsa0BVWdP2/L3ZI
	sV41z+FicdXWlp//NiUVWwStxGzereFimodiuqi7udlGxh5TxJ0dtDUIs2JblrEC0XpJ6LLSLDH
	NZTf7b1pqLsUPrOKTIKIQDXqvqz414jt69yGS+4pFmmu7rhQpx1xQJfYjHcs=
X-Received: by 2002:a05:6a00:2342:b0:706:726b:ae60 with SMTP id d2e1a72fcca58-71445d6c8aamr1099250b3a.17.1724377701075;
        Thu, 22 Aug 2024 18:48:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMZC1SZmVbqVUod4UUHgUNHtX1PNiy7EgYIE+f48qzu8OLT69CEEFQa70BqMQETsWrkWn4fg==
X-Received: by 2002:a05:6a00:2342:b0:706:726b:ae60 with SMTP id d2e1a72fcca58-71445d6c8aamr1099231b3a.17.1724377700607;
        Thu, 22 Aug 2024 18:48:20 -0700 (PDT)
Received: from [10.72.112.8] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7143422ec2esm1997320b3a.27.2024.08.22.18.48.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2024 18:48:20 -0700 (PDT)
Message-ID: <0205e0b6-fad9-4519-adec-f1d1b30d9ef9@redhat.com>
Date: Fri, 23 Aug 2024 09:48:16 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] ceph: fix out-of-bound array access when doing a file
 read
To: "Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
 Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240822150113.14274-1-luis.henriques@linux.dev>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20240822150113.14274-1-luis.henriques@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 8/22/24 23:01, Luis Henriques (SUSE) wrote:
> If, while doing a read, the inode is updated and the size is set to zero,
> __ceph_sync_read() may not be able to handle it.  It is thus easy to hit a
> NULL pointer dereferrence by continuously reading a file while, on another
> client, we keep truncating and writing new data into it.
>
> This patch fixes the issue by adding extra checks to avoid integer overflows
> for the case of a zero size inode.  This will prevent the loop doing page
> copies from running and thus accessing the pages[] array beyond num_pages.
>
> Link: https://tracker.ceph.com/issues/67524
> Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
> ---
> Hi!
>
> Please note that this patch is only lightly tested and, to be honest, I'm
> not sure if this is the correct way to fix this bug.  For example, if the
> inode size is 0, then maybe ceph_osdc_wait_request() should have returned
> 0 and the problem would be solved.  However, it seems to be returning the
> size of the reply message and that's not something easy to change.  Or maybe
> I'm just reading it wrong.  Anyway, this is just an RFC to see if there's
> other ideas.
>
> Also, the tracker contains a simple testcase for crashing the client.
>
>   fs/ceph/file.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 4b8d59ebda00..dc23d5e5b11e 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1200,9 +1200,9 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>   		}
>   
>   		idx = 0;
> -		if (ret <= 0)
> +		if ((ret <= 0) || (i_size == 0))

Hi Luis,

This change looks incorrect to me.

As I mentioned before when the 'IFILE' lock is in MIX state the 'Frw' 
caps could be issued to multiple clients at the same time. Which means 
the file could be updated by another client and the local 'i_size' may 
haven't been changed in time. So in this case the 'ret' will be larger 
than '0' and the 'i_size' could be '0'.


>   			left = 0;
> -		else if (off + ret > i_size)
> +		else if ((i_size >= off) && (off + ret > i_size))

And the 'off' also could equal to little than the 'i_size'.

BTW, could you reproduce the crash issue ?

Thanks

- Xiubo

>   			left = i_size - off;
>   		else
>   			left = ret;
> @@ -1210,6 +1210,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>   			size_t plen, copied;
>   
>   			plen = min_t(size_t, left, PAGE_SIZE - page_off);
> +			WARN_ON_ONCE(idx >= num_pages);
>   			SetPageUptodate(pages[idx]);
>   			copied = copy_page_to_iter(pages[idx++],
>   						   page_off, plen, to);
> @@ -1234,7 +1235,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
>   	}
>   
>   	if (ret > 0) {
> -		if (off >= i_size) {
> +		if ((i_size >= *ki_pos) && (off >= i_size)) {
>   			*retry_op = CHECK_EOF;
>   			ret = i_size - *ki_pos;
>   			*ki_pos = i_size;
>


