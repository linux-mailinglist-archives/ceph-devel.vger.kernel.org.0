Return-Path: <ceph-devel+bounces-14-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04B137DB210
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Oct 2023 03:30:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E5ED1C20A89
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Oct 2023 02:30:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21CDE1379;
	Mon, 30 Oct 2023 02:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FteXrfTp"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0EF1378
	for <ceph-devel@vger.kernel.org>; Mon, 30 Oct 2023 02:30:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBC5BE
	for <ceph-devel@vger.kernel.org>; Sun, 29 Oct 2023 19:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698633003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/HpUXC3JPrBrGax2FnC82K3XfMYa1e9s8tOjT5ZffiY=;
	b=FteXrfTpVBlI3NOz2Xcka3fFIG8Lq1yfrnJWTj9BmkUpH34SQc4uqklLsQkPvh9G7+IU5K
	Lv4vN1BQxWeL0OghJfg/n7t8cHkYK8Vr9KCDCg6Z9iB++3J5I8yQaqOGJmtdP9ZSyfOChC
	ZNXcGX/7sHOJfG6zOO5eVJ2rxQXH9rU=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-sA0SSVDkOUeiPjexN93eLg-1; Sun, 29 Oct 2023 22:30:01 -0400
X-MC-Unique: sA0SSVDkOUeiPjexN93eLg-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-280184b2741so1334299a91.0
        for <ceph-devel@vger.kernel.org>; Sun, 29 Oct 2023 19:30:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698633000; x=1699237800;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/HpUXC3JPrBrGax2FnC82K3XfMYa1e9s8tOjT5ZffiY=;
        b=glqk3g8qsPbkn7n5KTJgLqaGAe0V5HqtkvSa0JpuSizXZObl/6NEgXpZoQytun8Gmz
         kM0OQbd+edcHTqHxukOXZYP0gwMJMa0TiZr+t8TQvHX8r1HvzebmlpdxNkGg8tlIIcng
         aGuni2Lh+f004mDyFjGErSd+UHGe2/CnGT/OtK3EHU32oMHwEXsDezUJkEg1cbLS33mW
         H9c/oq6PXzAJy+C8UcrB+gpI5o2+ijYchPYxPinCFWyA/ev0K3oB8ScE9aL7t3yzT71M
         v2toY+ZZIeyFqGlqwWACG4PKjaZxtsd3YsUADmhj9F207kdJmFS7bmnH5bfzK7fQ6Ke2
         BxAQ==
X-Gm-Message-State: AOJu0Yy8WIgt729gMx9I6DbcMmdA2MJPnGz9R0mHopvNvMOgw2C0bN+1
	FmqSeJJZ3T2+BlKuCxrmpA3R5kl+v3klCsH3t33Zc0xysxxhAzHOhNqekMBxUT5Q4058aUl/dVP
	pEJ8/vc0l2I0ZuhHMYQYdz/XlL4SeDiAQvVs=
X-Received: by 2002:a17:90b:38c6:b0:280:1df1:cbc7 with SMTP id nn6-20020a17090b38c600b002801df1cbc7mr3226193pjb.19.1698633000470;
        Sun, 29 Oct 2023 19:30:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG0oU7E/0LQcG9ncujTjZpkf0rLEVN6z1PkBcPgrCwMikCgvLJ4kdha+NU745fBGfA6qDJ76w==
X-Received: by 2002:a17:90b:38c6:b0:280:1df1:cbc7 with SMTP id nn6-20020a17090b38c600b002801df1cbc7mr3226183pjb.19.1698633000110;
        Sun, 29 Oct 2023 19:30:00 -0700 (PDT)
Received: from [10.72.112.142] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id pm1-20020a17090b3c4100b002805740d668sm1136675pjb.4.2023.10.29.19.29.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Oct 2023 19:29:59 -0700 (PDT)
Message-ID: <209b187c-f471-6921-4cda-7293e362d729@redhat.com>
Date: Mon, 30 Oct 2023 10:29:55 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ceph_wait_on_conflict_unlink(): grab reference before
 dropping ->d_lock
Content-Language: en-US
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org
References: <20231026022115.GK800259@ZenIV>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20231026022115.GK800259@ZenIV>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 10/26/23 10:21, Al Viro wrote:
> [at the moment in viro/vfs.git#fixes]
> Use of dget() after we'd dropped ->d_lock is too late - dentry might
> be gone by that point.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>   fs/ceph/mds_client.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 615db141b6c4..293b93182955 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -861,8 +861,8 @@ int ceph_wait_on_conflict_unlink(struct dentry *dentry)
>   		if (!d_same_name(udentry, pdentry, &dname))
>   			goto next;
>   
> +		found = dget_dlock(udentry);
>   		spin_unlock(&udentry->d_lock);
> -		found = dget(udentry);
>   		break;
>   next:
>   		spin_unlock(&udentry->d_lock);

Good catch.

Thanks Al.

- Xiubo



