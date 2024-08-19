Return-Path: <ceph-devel+bounces-1695-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ECFCA9560CD
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Aug 2024 03:17:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8C1DBB21F65
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Aug 2024 01:17:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B45051946B;
	Mon, 19 Aug 2024 01:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MPNp7855"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87631B960
	for <ceph-devel@vger.kernel.org>; Mon, 19 Aug 2024 01:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724030222; cv=none; b=CbShR8udmfTPrtui3qgyJ861+zDvJ5KMrzRWwDv+JJjwCtledSISNBlGKe9QFHwpUjoPcB/QbLymUYd5i3v8xRuhht1D98IDfZ/SbpTNBMqwptE/4ZDpAEi2TxA9A5Taegjc0nTC3trhjiIbqmjqWPWtcmH37ubJuKlrbzDq440=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724030222; c=relaxed/simple;
	bh=tp/Xpdn1oemCOIemM7zlCWHNVyPm8ld8A4jJVsyxICU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pgfaZVjjErWW+e0m9zDFbK7iBpYuh7XVQRZTKRQDYwfxjXJiVEc5eXEcNhu9REBiHkvPHzKsPjbDgCS7uEBeTBEYYfsCygQGGVHLvKT9Joo+b4fP5sxHwzEhZN8dN1ddMhckxd6lvlKdzeNp4VSpkDRbuCjLacGZgIo4XiYWVTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MPNp7855; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724030219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n6JHQznnoP2B1M81XzspAZrHfEQzedoU2DAU6mxzvA0=;
	b=MPNp7855NgBnYJdmMjTLdO/g8JZ+oGXAbfmt0D5lbYPxacK+20M2DWoWb6MmdC3CpGAIxs
	sjZD44Gfij134qXVd4qx3Dh4PvdlRSL8G0OtIP/enj4O3BmZikGz0Rgvdb2HJtwqQd97VE
	ugLGkAfvF4w7RWsIwbwpbpJu1E5yx2U=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-55-l7rAojqsOSeYRs2bErBX3w-1; Sun, 18 Aug 2024 21:16:58 -0400
X-MC-Unique: l7rAojqsOSeYRs2bErBX3w-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-2701a253946so3987313fac.3
        for <ceph-devel@vger.kernel.org>; Sun, 18 Aug 2024 18:16:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724030217; x=1724635017;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n6JHQznnoP2B1M81XzspAZrHfEQzedoU2DAU6mxzvA0=;
        b=MtP7+NBqNPbZVEb69MoBtY9IkzxrY6pqbSSU81BH1wMP5Z7a02mE0oRcadxruy0ed4
         2csMEjaykjXUv/6k5yHXbDBgA5/NFbrwQtHtDL9G+jSY1716ZQM+jelrjz5Pzbpq3Bol
         1vRqlpJAUh1hsE1RbhG8CkYRxnZ/pOHCANpl3im0w07OpWq2KIgXPptzWQ4XY5TnlNiZ
         85gbK6wDgHRMBLhJ04oDumIrk2uOSOCRhy/eeKzgLwOamkqiAewHeu31zDb8LNbN2NFq
         PQiMW8nMX9A0eLJa2wyIAnekNKDpHSu1nitXZYAoaZWTSNQjH01gg8uep092u42yj/3G
         2zzg==
X-Gm-Message-State: AOJu0Yz4ckWU79S9SB7E1e3HWQGJFfhLc8jpJ+878QCE0VLZttj8w/zM
	MOkVA88mYOgOrrKAQd18jIdyABTFq33hBx/njfhhptped+IzChyB/8ZGLluMUuecpo0i+T2397x
	sWg+pmO0+oY6ggcxrGyrmNPHqKISIy0BD8WtWusN63l2VdJsGe2TOcEumkwA=
X-Received: by 2002:a05:6870:d287:b0:267:e2b2:ec52 with SMTP id 586e51a60fabf-2701c575da2mr11080123fac.49.1724030217411;
        Sun, 18 Aug 2024 18:16:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNijeH38JzYRoylQE2EDaHQsya4pFknB7VNjzjMz3uv9RcA0uMNAhd+JhGjC4VTEGgrfD3sw==
X-Received: by 2002:a05:6870:d287:b0:267:e2b2:ec52 with SMTP id 586e51a60fabf-2701c575da2mr11080105fac.49.1724030216967;
        Sun, 18 Aug 2024 18:16:56 -0700 (PDT)
Received: from [10.72.116.30] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127add6de9sm5930734b3a.12.2024.08.18.18.16.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Aug 2024 18:16:56 -0700 (PDT)
Message-ID: <74549d76-1187-4ed6-9589-e5978ba513d0@redhat.com>
Date: Mon, 19 Aug 2024 09:16:51 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] ceph: Remove unused declarations
To: Yue Haibing <yuehaibing@huawei.com>, idryomov@gmail.com,
 mchangir@redhat.com, jlayton@kernel.org
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240814033415.3800889-1-yuehaibing@huawei.com>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20240814033415.3800889-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 8/14/24 11:34, Yue Haibing wrote:
> These functions is never implemented and used.
>
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
> ---
>   fs/ceph/mds_client.h            | 3 ---
>   fs/ceph/super.h                 | 2 --
>   include/linux/ceph/osd_client.h | 2 --
>   3 files changed, 7 deletions(-)
>
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 9bcc7f181bfe..585ab5a6d87d 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -559,9 +559,6 @@ extern struct ceph_mds_session *
>   ceph_get_mds_session(struct ceph_mds_session *s);
>   extern void ceph_put_mds_session(struct ceph_mds_session *s);
>   
> -extern int ceph_send_msg_mds(struct ceph_mds_client *mdsc,
> -			     struct ceph_msg *msg, int mds);
> -
>   extern int ceph_mdsc_init(struct ceph_fs_client *fsc);
>   extern void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc);
>   extern void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc);
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 6e817bf1337c..c88bf53f68e9 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1056,8 +1056,6 @@ extern int ceph_fill_trace(struct super_block *sb,
>   extern int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>   				    struct ceph_mds_session *session);
>   
> -extern int ceph_inode_holds_cap(struct inode *inode, int mask);
> -
>   extern bool ceph_inode_set_size(struct inode *inode, loff_t size);
>   extern void __ceph_do_pending_vmtruncate(struct inode *inode);
>   
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index f66f6aac74f6..d7941478158c 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -449,8 +449,6 @@ extern int ceph_osdc_init(struct ceph_osd_client *osdc,
>   extern void ceph_osdc_stop(struct ceph_osd_client *osdc);
>   extern void ceph_osdc_reopen_osds(struct ceph_osd_client *osdc);
>   
> -extern void ceph_osdc_handle_reply(struct ceph_osd_client *osdc,
> -				   struct ceph_msg *msg);
>   extern void ceph_osdc_handle_map(struct ceph_osd_client *osdc,
>   				 struct ceph_msg *msg);
>   void ceph_osdc_update_epoch_barrier(struct ceph_osd_client *osdc, u32 eb);

Reviewed-by: Xiubo Li <xiubli@redhat.com>

Thanks!



