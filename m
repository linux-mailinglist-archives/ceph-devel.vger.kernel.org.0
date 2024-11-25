Return-Path: <ceph-devel+bounces-2193-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 748F39D798D
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Nov 2024 01:53:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9F11162826
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Nov 2024 00:53:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92BDFBE40;
	Mon, 25 Nov 2024 00:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UQnAu51i"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66AC4A06
	for <ceph-devel@vger.kernel.org>; Mon, 25 Nov 2024 00:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732496003; cv=none; b=E0hSIlHGIZXpJoYYGCRH3amaDZUxbWmIGexSO2SEHJ5bL0rj3tKsxgHk5BnoCKQlzCXiPzlBi7tHdzUrSxvDqhngbDij4ThYjP89mDPwRHInlYkvBPbEJhasniQfBgybd/Bhb8PzeX5ITEvfPxLSRrr3MfNiu9QX8s4ZRCxRgbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732496003; c=relaxed/simple;
	bh=rBiPXAWhL7prSEE+oWNLyafaf94BI4KgDg7Xs99syVc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nRe+9ciH/FT8jM1D0BQvuRm1099/uMNYknvLrQLsxAk0bWSo6Jz878cHaF/1bZAXKKSjzoPhnPtKB84F6i5bDik9S2jjUnLkWd0M1FwHx6Qqd9OQMMNseFeszvmv0KbBJpgqOrUJU0EC2pL4YdUBKD0wWrXzcH3qZq271muxhWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UQnAu51i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732496000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UYCrh/uGGFSMSiT9SxGgZt0ghT6J1XSTHnQBI60venY=;
	b=UQnAu51iCoBDCjw0v10gHgO6Z/jRBT+ADa/GARALuiePCAc1mgMmmOgmcGMTF79Zlkg5ki
	gFAH7LsYENwvWAOrIBMrdkSAcx3kX2LqSNXbO6ywKXyOdkGsGU/M/tM/2AWh1bQ2rlGJu5
	MxhmWAHTPozTgBFGHJy7XLJdVJEmbmM=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-YcruPdGpMgScI67wsh4Ztg-1; Sun, 24 Nov 2024 19:53:17 -0500
X-MC-Unique: YcruPdGpMgScI67wsh4Ztg-1
X-Mimecast-MFC-AGG-ID: YcruPdGpMgScI67wsh4Ztg
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2126573a5b0so44360145ad.2
        for <ceph-devel@vger.kernel.org>; Sun, 24 Nov 2024 16:53:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732495996; x=1733100796;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UYCrh/uGGFSMSiT9SxGgZt0ghT6J1XSTHnQBI60venY=;
        b=T2okIHSsLmQlhzwR5oZeF8wC3gYd9IKpnjYMuFQ0tfTnXl6Q+Kycmsil2UlLJDcQ6m
         bvtrpL1SjvBneqsuKYvm5/7CQ0IKj72t22VwZbAjt18tOL56YygfcamrE0Zm+5f2fWfp
         PZmmVv8qaJLrU2X7s1Q0RYtsCjTxtCGkZ9abwAX/W2lmxv6T8IwegSYZeWrcpnve/gze
         xYqeS5fRqE3vvcu2ACnt7h56LMYQb08mdeSNZa/0fohm1ZleJOIRYLD8S40PVyTS3Nem
         e7z23I+DNnxOr+YxFXp51QPAnQsKWdLUS8UQ1Txtpvae+BXDYD819nh0ow48cTMNIkZg
         P0wg==
X-Forwarded-Encrypted: i=1; AJvYcCWCtkkGz71Hrz1GX6V0xn0wAUbC9Idt0M4TgtHtwGHSBAnVnH5WlaEtQg1HAnYwmlFE0m8Evh0ORSID@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4r2gd6MX4aVLsW+rQwmJ4SO4SKuYh2UGeMi4ArsD6nzPymUFg
	KzwFkO5N3ZGf1dNuuQPx/c7kPVjPgkWsd3yemmcNnTBBS+9EAFlFHrGuvPDaTRo6PG0+IHYzUDt
	vK8S1kMHYV86zw14q9aF8XmwjZomnrj07Plsu7I5NTo9By+9qB0pN5rS62MU=
X-Gm-Gg: ASbGncsjv/nELBIQ07RU1y2PszJeWL9Jmzp4xUBs0IMAO55h9ibQa2ksXSVkCsnLGTj
	NW/9u9BJgqWGAb71d10d503qx135zjzNSx/fkQr1mG+if6pDVVuoktbk8PimKR+N+WK/IKuhLty
	cZeJKP2+jTp/NJW0+x1ntySbq6K6izMOhbVRf/wlWIbky8m//KDbLOtelh8ETOb8IxJXBx5qjwo
	FVcqlk66mOhdDHgXtCe87+6wik/nHO1CUZcVoIuMxJsuTBxf7Y=
X-Received: by 2002:a17:902:dad1:b0:20c:b052:7e14 with SMTP id d9443c01a7336-2129f28eca5mr115297605ad.50.1732495996306;
        Sun, 24 Nov 2024 16:53:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEAh+2ElGAo++jlH3jK1mILWLPx5UAnw782BdEH0pmmssykaMkDOYS40gPooRfs1G0LDoOczQ==
X-Received: by 2002:a17:902:dad1:b0:20c:b052:7e14 with SMTP id d9443c01a7336-2129f28eca5mr115297435ad.50.1732495996002;
        Sun, 24 Nov 2024 16:53:16 -0800 (PST)
Received: from [10.72.112.30] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2129dba27dfsm52456895ad.111.2024.11.24.16.53.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Nov 2024 16:53:15 -0800 (PST)
Message-ID: <b52a83ea-6e74-4bf4-b634-8d77e369e873@redhat.com>
Date: Mon, 25 Nov 2024 08:53:05 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] fs/ceph/mds_client: fix cred leak in
 ceph_mds_check_access()
To: Max Kellermann <max.kellermann@ionos.com>, idryomov@gmail.com,
 ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
References: <20241123072121.1897163-1-max.kellermann@ionos.com>
 <20241123072121.1897163-2-max.kellermann@ionos.com>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20241123072121.1897163-2-max.kellermann@ionos.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/23/24 15:21, Max Kellermann wrote:
> get_current_cred() increments the reference counter, but the
> put_cred() call was missing.
>
> Fixes: 596afb0b8933 ("ceph: add ceph_mds_check_access() helper")
> Cc: stable@vger.kernel.org
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>   fs/ceph/mds_client.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index e8a5994de8b6..35d83c8c2874 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -5742,6 +5742,7 @@ int ceph_mds_check_access(struct ceph_mds_client *mdsc, char *tpath, int mask)
>   
>   		err = ceph_mds_auth_match(mdsc, s, cred, tpath);
>   		if (err < 0) {
> +			put_cred(cred);
>   			return err;
>   		} else if (err > 0) {
>   			/* always follow the last auth caps' permision */
> @@ -5757,6 +5758,8 @@ int ceph_mds_check_access(struct ceph_mds_client *mdsc, char *tpath, int mask)
>   		}
>   	}
>   
> +	put_cred(cred);
> +
>   	doutc(cl, "root_squash_perms %d, rw_perms_s %p\n", root_squash_perms,
>   	      rw_perms_s);
>   	if (root_squash_perms && rw_perms_s == NULL) {

Good catch.

Reviewed-by: Xiubo Li <xiubli@redhat.com>



