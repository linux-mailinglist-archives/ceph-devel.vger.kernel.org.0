Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3529B44FD47
	for <lists+ceph-devel@lfdr.de>; Mon, 15 Nov 2021 03:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbhKOC5V (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 14 Nov 2021 21:57:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44552 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229588AbhKOC5R (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 21:57:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636944861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jl5/NtO9ElL5IL5PR8hsbteYLA/rmFJOAG/ZAbvQVFs=;
        b=K5kmmHqdt3FlQMm4MKdhHWVBWcPeb3v8MJ3hRt6YybFVQlvMoVeFNzv5NmPKjb+vPA59YM
        SiKTDRRRIKZHjWUKu06VZdbG786eX9pZ1wqunqUxa4Y8xEGOUUE+FZc1v2QdZYSGAJXLM/
        uITgJ1hez0FhYDUvRF59otsZ2lujo2U=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-6ogHmA15Pd-B0X6Ujjd1rw-1; Sun, 14 Nov 2021 21:54:20 -0500
X-MC-Unique: 6ogHmA15Pd-B0X6Ujjd1rw-1
Received: by mail-pg1-f197.google.com with SMTP id j18-20020a63fc12000000b002dd2237eb1cso8471426pgi.5
        for <ceph-devel@vger.kernel.org>; Sun, 14 Nov 2021 18:54:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=jl5/NtO9ElL5IL5PR8hsbteYLA/rmFJOAG/ZAbvQVFs=;
        b=FHv7W39T+nsJ62gzakOd6kgzbIZ1zx9zbbFZQL3/WoptTOB4gJ9hgxo0oHyTV6dP87
         fwqwniTb/rQuTlPJBcsKW/HnYSDXBpG0YQsyt2Ili0U3V0SRiUWqgwatC4+YWy3xRVMS
         dx1jYVDrpp0FZ6G6pc3ceOQ61GUks7ejH6MrUeFLuVuRDpBgu7UsbBrgE2rTckzNWROt
         B0lNNOb9PARkzRTMKTlcOEEAtF1X5MBNrTTojcf99OXYKfiPjNoMnk9XnZKBC9d/rKaG
         Xyl2hKQAN2oLH6PWncLOYQZz8jJ9PU23LKUv/pvUAUNaMPESSuTNDIFx4X5mVBQ3N4Ks
         rZ9g==
X-Gm-Message-State: AOAM530tSnK62dDNoLtjyfpaxIS4kzGXXSoApUhXXTnxLRESZNtckQzE
        6jyytWMWjGhRqnyhj2TLQ/t432k/8SDk2ty0zNdnH3tjhsvd7CFMQ9xn7MuaVhoupI9+tdaTUdu
        iVBxzUQijFVGEFcPe+l/FEAoVYT7o45H9wvTk3gGkS/LLB4Y/PmmiMV7DnVvKPCCH6FWsZEU=
X-Received: by 2002:a63:5222:: with SMTP id g34mr21747292pgb.236.1636944859366;
        Sun, 14 Nov 2021 18:54:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxj4EYfXqEKwwOtZTopVhrHkCrVVwU6gZgckzCDgGFOZoM1SDDUX+eJhcsBCDtA37UtQZ2JxA==
X-Received: by 2002:a63:5222:: with SMTP id g34mr21747268pgb.236.1636944859056;
        Sun, 14 Nov 2021 18:54:19 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id fw21sm16307041pjb.25.2021.11.14.18.54.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Nov 2021 18:54:18 -0800 (PST)
Subject: Re: [PATCH v2 1/1] ceph: Fix incorrect statfs report for small quota
To:     khiremat@redhat.com, jlayton@redhat.com
Cc:     pdonnell@redhat.com, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
References: <20211110180021.20876-1-khiremat@redhat.com>
 <20211110180021.20876-2-khiremat@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <2bbf6340-0814-bbfa-0d35-2e1d1fff23de@redhat.com>
Date:   Mon, 15 Nov 2021 10:53:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211110180021.20876-2-khiremat@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/11/21 2:00 AM, khiremat@redhat.com wrote:
> From: Kotresh HR <khiremat@redhat.com>
>
> Problem:
> The statfs reports incorrect free/available space
> for quota less then CEPH_BLOCK size (4M).

s/then/than/


> Solution:
> For quota less than CEPH_BLOCK size, smaller block
> size of 4K is used. But if quota is less than 4K,
> it is decided to go with binary use/free of 4K
> block. For quota size less than 4K size, report the
> total=used=4K,free=0 when quota is full and
> total=free=4K,used=0 otherwise.
>
> Signed-off-by: Kotresh HR <khiremat@redhat.com>
> ---
>   fs/ceph/quota.c | 14 ++++++++++++++
>   fs/ceph/super.h |  1 +
>   2 files changed, 15 insertions(+)
>
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index 620c691af40e..24ae13ea2241 100644
> --- a/fs/ceph/quota.c
> +++ b/fs/ceph/quota.c
> @@ -494,10 +494,24 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
>   		if (ci->i_max_bytes) {
>   			total = ci->i_max_bytes >> CEPH_BLOCK_SHIFT;
>   			used = ci->i_rbytes >> CEPH_BLOCK_SHIFT;
> +			/* For quota size less than 4MB, use 4KB block size */
> +			if (!total) {
> +				total = ci->i_max_bytes >> CEPH_4K_BLOCK_SHIFT;
> +				used = ci->i_rbytes >> CEPH_4K_BLOCK_SHIFT;
> +	                        buf->f_frsize = 1 << CEPH_4K_BLOCK_SHIFT;
> +			}
>   			/* It is possible for a quota to be exceeded.
>   			 * Report 'zero' in that case
>   			 */
>   			free = total > used ? total - used : 0;
> +			/* For quota size less than 4KB, report the
> +			 * total=used=4KB,free=0 when quota is full
> +			 * and total=free=4KB, used=0 otherwise */
> +			if (!total) {
> +				total = 1;
> +				free = ci->i_max_bytes > ci->i_rbytes ? 1 : 0;
> +	                        buf->f_frsize = 1 << CEPH_4K_BLOCK_SHIFT;

The 'buf->f_frsize' has already been assigned above, this could be removed.

Thanks

-- Xiubo

> +			}
>   		}
>   		spin_unlock(&ci->i_ceph_lock);
>   		if (total) {
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index ed51e04739c4..387ee33894db 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -32,6 +32,7 @@
>    * large volume sizes on 32-bit machines. */
>   #define CEPH_BLOCK_SHIFT   22  /* 4 MB */
>   #define CEPH_BLOCK         (1 << CEPH_BLOCK_SHIFT)
> +#define CEPH_4K_BLOCK_SHIFT 12  /* 4 KB */
>   
>   #define CEPH_MOUNT_OPT_CLEANRECOVER    (1<<1) /* auto reonnect (clean mode) after blocklisted */
>   #define CEPH_MOUNT_OPT_DIRSTAT         (1<<4) /* `cat dirname` for stats */

