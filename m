Return-Path: <ceph-devel+bounces-1509-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 38C9392CBCA
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jul 2024 09:18:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D36741F23A7A
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jul 2024 07:18:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B27D7174F;
	Wed, 10 Jul 2024 07:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b4/yAiz1"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A57D535
	for <ceph-devel@vger.kernel.org>; Wed, 10 Jul 2024 07:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720595893; cv=none; b=AONUSUPCWS7WQJCzjd/Mj8wTkmDScbw8Oj1oJeVTaDQkdQvdatN9n11hJ5Nr1F7J6Otj8z42HBslDF2XXMbc++uSVyUcxKa3B8i+bdZKzQmJyPvN+/UE+450Y6wzApJkPZNdSm3uW3rvBw+++pRhy3LxURlbbTb0hgSqz2EZ2lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720595893; c=relaxed/simple;
	bh=y/2Uwf84AKVLMAatdGxP40dKI8PxpoAEQkovgd2zjXQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XbfRvjczO8CTuoUVJ65B2ATQhatg21DK5BFy78TI4fsjdea/T8SaVkOi3XZZ+pwfPQtAuFNs6nVCr6u5cLtPX1tlcOAc3hwxi1XX6Heoaag9TvhZiyxikEf5Y0LVjmypfe4VnGjeZLtwxPOhBCIIynFFPEa8lIchf2yCdKy1ZrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b4/yAiz1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720595890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dr5XCf0gY+osLWRevdHMR9c5fdKc3782+BL3hUmPAxs=;
	b=b4/yAiz1QWuJ9Gv/vflg7fHcplU2mDgJbvu+KfW1xK5LhkuBaBWZwR5oRhxK0unwO+pzIv
	Ph6xxKL4pM8Izk81uPFSuKAf6L53n/2GnJhWslq3j5s/QAkO4kTyhbR2htvNuyYXxxhEJH
	KmTPYnZ+wQwoLkk0QF6KAFoTv92/qAI=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-255-rltiFud9PMOBgoJhYLyD7w-1; Wed, 10 Jul 2024 03:18:08 -0400
X-MC-Unique: rltiFud9PMOBgoJhYLyD7w-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-70af7dc9780so417584b3a.1
        for <ceph-devel@vger.kernel.org>; Wed, 10 Jul 2024 00:18:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720595887; x=1721200687;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dr5XCf0gY+osLWRevdHMR9c5fdKc3782+BL3hUmPAxs=;
        b=qFQc0liiXaqHZVsogWQvC2votOydaVurOWGBNVnaHe+f2i0D0TYWx68GTaz/x07nar
         j433EOm8tKOWk4VtOrrXOZ5gbr7YjG9f7wbHSi6qVaNdOobFHXif7jHXF+VPTnCr1bEn
         Baleljjxks42wUVNaolFF7kTERveFoGbiVPKZkB2ktIXcoXZ6YL62JuZwYhrTkVem8Lx
         jJTm8g6r67YfP3o9JH51hFvmKHd+5KPHjGMQXzeDotx8OsLlwZbrzx+Mh6uuyxPpbvpX
         4+8nqzMNQC2k98FdxDjAOEfRHXgU/FMWFzdfYKEuAg6c1ld65m0MRM973xWSaGcqWl35
         FLuw==
X-Gm-Message-State: AOJu0YzCCCznKwA8zkqDUUHLIPQP9FY+xypwFizi+4XBiNPZhLYBEi4+
	8fa3DdqO/EGcYiSTEPHYVXiuPYE8dSLTZu0OyQHg+EEkY3WehQZAqevnYfz/hcqE7UiST9mBa8T
	2gUVF+/KQJRhtB9FTG38avpOT4o92X/eqyWbTqbdKceC5HI+hb1pyNgRkK5s=
X-Received: by 2002:a05:6a00:2d0b:b0:6f6:76c8:122c with SMTP id d2e1a72fcca58-70b44dd31bemr6568588b3a.16.1720595887543;
        Wed, 10 Jul 2024 00:18:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHtKQKWIntnO93T2N5/0HkX4mUK4StkTYBoYwJlFsG21sb0V6OHhpb0kgUFy/S8AFfw69nf4Q==
X-Received: by 2002:a05:6a00:2d0b:b0:6f6:76c8:122c with SMTP id d2e1a72fcca58-70b44dd31bemr6568559b3a.16.1720595887130;
        Wed, 10 Jul 2024 00:18:07 -0700 (PDT)
Received: from [10.72.116.145] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b4396752esm3020696b3a.125.2024.07.10.00.18.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jul 2024 00:18:06 -0700 (PDT)
Message-ID: <0c9db292-7b13-4d95-bc5f-f96800ea91b7@redhat.com>
Date: Wed, 10 Jul 2024 15:18:00 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ceph: convert comma to semicolon
To: Chen Ni <nichen@iscas.ac.cn>, idryomov@gmail.com
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240709064400.869619-1-nichen@iscas.ac.cn>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20240709064400.869619-1-nichen@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 7/9/24 14:44, Chen Ni wrote:
> Replace a comma between expression statements by a semicolon.
>
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
> ---
>   fs/ceph/dir.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 5aadc56e0cc0..18c72b305858 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -1589,7 +1589,7 @@ void __ceph_dentry_dir_lease_touch(struct ceph_dentry_info *di)
>   	}
>   
>   	spin_lock(&mdsc->dentry_list_lock);
> -	__dentry_dir_lease_touch(mdsc, di),
> +	__dentry_dir_lease_touch(mdsc, di);
>   	spin_unlock(&mdsc->dentry_list_lock);
>   }
>   
Reviewed-by: Xiubo Li <xiubli@redhat.com>


