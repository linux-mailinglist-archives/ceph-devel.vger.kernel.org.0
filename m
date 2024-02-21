Return-Path: <ceph-devel+bounces-890-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D5B7F85CF5C
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Feb 2024 05:46:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04B501C222BD
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Feb 2024 04:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73EEE38FAD;
	Wed, 21 Feb 2024 04:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XB0zC/3l"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F20E29424
	for <ceph-devel@vger.kernel.org>; Wed, 21 Feb 2024 04:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708490758; cv=none; b=Rm4xJA377kyogedLglpWqAkTm2Lwwkn0K2sFyXu7i7TRxLwvYdQEqFQAVEfDewjAA2Vy22Gdyh2jz0RtQ6xnlWApjHJDOZY8TRGNfJ0ebzh8/zUEnYyL/+PF/x9n7I4adknOkUXmVu4yhVNfybRpxFdU1frY6KAjJBweEvf8Xu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708490758; c=relaxed/simple;
	bh=8mtm+ZweoOTQhKGeSu7fOXXWnZ8wqt7AXRsseivYu6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pPYchjDbbYpktacOvGmrFy4Rybm/7Ft1mjrF+rVEcph7BIYFj4VzAMcOgDA0MDfGaGTc+ruAMehr/a2BSYN/M+fs73g7bFbmyCRJbCmmu8eZFstVsajLQqXdPbEXjcYOZps5l9c1ACb543ubpVc6s/JFUVXU2ukf8glD/0wbs8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XB0zC/3l; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708490755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=07e/vtnROomV5De/h9TGtS2GsdEA1MtWGZa/8fx8wFE=;
	b=XB0zC/3l1cRZNCHmeyCxNqWT/1UUCYBLWPLF8jzVFSvXdfW9AfSHFKhXoSfAgXquJo8AOe
	g5DZ+4p9Posf8BzNwMHZIzfM3zLpwl454ALxEXGsM78KzEKI3hJvC19kNKd95yUiuMnyYB
	ZYvUDJxi5ekLvAfpUb54D2+O6qHoX6s=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-WHJPJ4O9MkG0ifWXBghIGg-1; Tue, 20 Feb 2024 23:45:52 -0500
X-MC-Unique: WHJPJ4O9MkG0ifWXBghIGg-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6e4926ace7bso110508b3a.0
        for <ceph-devel@vger.kernel.org>; Tue, 20 Feb 2024 20:45:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708490751; x=1709095551;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=07e/vtnROomV5De/h9TGtS2GsdEA1MtWGZa/8fx8wFE=;
        b=RL5nWdnkvs20n211794Gtob6OiMPdduB3as8L0wCOACqNvBsFA44y04/fofCgQcxoz
         sb5Y7xSif2hHbO1e+tRMOyhKTq5jc9n+VeCazo0SwHjVgvEmhkvg/Jjp4V7hlZOg5gj2
         dXNZ77ZOZjz/zRhDYNO55v/NqgBBHfcu70ORm8TKQFIGl3YK4O7dVRsMbNWmEawa+OSz
         KEBOrgR9yTZ5nyZAbqe7jr59d8vOTbJPYquGsW7nYo6ylPBsq0d75QYGUchhpElhmzdb
         Y65LCsiwcPl54m230CgGX+rjLb3nBq8ZmbqVAXYvSTt/XXM0KeAFoQCWGsaFJiqXC+wR
         Mp6g==
X-Gm-Message-State: AOJu0YxHD3KkNjnjoenrG7fViHHSBfb3xJXLMWpd5waGPluExEkRIQkc
	ITzu3j9tl+Ir8f5NWydbdAGnKsw/o6T6NDqGny95bReg0FJgQRl0L+tLyXiedPbJjowsIvZQAN0
	CZTLeDu1P+DSAi4XP8c1/mfJOpLWXprVoBG0cRkU5XsGukf97hWIb9Wyq7b0=
X-Received: by 2002:a62:ac0a:0:b0:6da:bcea:4cd4 with SMTP id v10-20020a62ac0a000000b006dabcea4cd4mr18997330pfe.16.1708490751625;
        Tue, 20 Feb 2024 20:45:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF52YaLleJYpvpGxNcSiRhnua79c65vSUIJ84grHVcLq3q5BJZc8XlhCq7cwu8tQ+k5Nykb3g==
X-Received: by 2002:a62:ac0a:0:b0:6da:bcea:4cd4 with SMTP id v10-20020a62ac0a000000b006dabcea4cd4mr18997313pfe.16.1708490751321;
        Tue, 20 Feb 2024 20:45:51 -0800 (PST)
Received: from [10.72.112.141] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n16-20020aa79850000000b006e48fdf00fdsm272966pfq.168.2024.02.20.20.45.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 20:45:51 -0800 (PST)
Message-ID: <27468fb1-334c-42b7-b171-11f7267ec438@redhat.com>
Date: Wed, 21 Feb 2024 12:45:46 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ceph: reverse MDSMap dencoding of
 max_xattr_size/bal_rank_mask
Content-Language: en-US
To: Patrick Donnelly <pdonnell@redhat.com>
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, jlayton@kernel.org,
 vshankar@redhat.com, mchangir@redhat.com
References: <20240221031052.68959-1-xiubli@redhat.com>
 <CA+2bHPb-rTz3Ajk3VFkp1_vycTjjH2hP3dtD668PVbnr-ErLyw@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CA+2bHPb-rTz3Ajk3VFkp1_vycTjjH2hP3dtD668PVbnr-ErLyw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 2/21/24 11:34, Patrick Donnelly wrote:
> On Tue, Feb 20, 2024 at 10:13 PM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Ceph added the bal_rank_mask with encoded (ev) version 17.  This
>> was merged into main Oct 2022 and made it into the reef release
>> normally. While a latter commit added the max_xattr_size also
>> with encoded (ev) version 17 but places it before bal_rank_mask.
>>
>> And this will breaks some usages, for example when upgrading old
>> cephs to newer versions.
>>
>> URL: https://tracker.ceph.com/issues/64440
>> Reported-by: Patrick Donnelly <pdonnell@redhat.com>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V2:
>> - minor fix in the comment
>>
>>
>>
>>
>>
>>   fs/ceph/mdsmap.c | 7 ++++---
>>   fs/ceph/mdsmap.h | 6 +++++-
>>   2 files changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
>> index fae97c25ce58..8109aba66e02 100644
>> --- a/fs/ceph/mdsmap.c
>> +++ b/fs/ceph/mdsmap.c
>> @@ -380,10 +380,11 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_mds_client *mdsc, void **p,
>>                  ceph_decode_skip_8(p, end, bad_ext);
>>                  /* required_client_features */
>>                  ceph_decode_skip_set(p, end, 64, bad_ext);
>> +               /* bal_rank_mask */
>> +               ceph_decode_skip_string(p, end, bad_ext);
>> +       }
>> +       if (mdsmap_ev >= 18) {
>>                  ceph_decode_64_safe(p, end, m->m_max_xattr_size, bad_ext);
>> -       } else {
>> -               /* This forces the usage of the (sync) SETXATTR Op */
>> -               m->m_max_xattr_size = 0;
>>          }
>>   bad_ext:
>>          doutc(cl, "m_enabled: %d, m_damaged: %d, m_num_laggy: %d\n",
>> diff --git a/fs/ceph/mdsmap.h b/fs/ceph/mdsmap.h
>> index 89f1931f1ba6..43337e9ed539 100644
>> --- a/fs/ceph/mdsmap.h
>> +++ b/fs/ceph/mdsmap.h
>> @@ -27,7 +27,11 @@ struct ceph_mdsmap {
>>          u32 m_session_timeout;          /* seconds */
>>          u32 m_session_autoclose;        /* seconds */
>>          u64 m_max_file_size;
>> -       u64 m_max_xattr_size;           /* maximum size for xattrs blob */
>> +       /*
>> +        * maximum size for xattrs blob.
>> +        * Setting it to 0 will force the usage of the (sync) SETXATTR Op.
> Minor nit, I would reword as: "Zeroed by default to force the usage of
> the (sync) SETXATTR Op."

Sure, will revise this.

Thanks Patrick and Venky.

- Xiubo


> Reviewed-by: Patrick Donnelly <pdonnell@ibm.com>
>


