Return-Path: <ceph-devel+bounces-831-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DE1784B119
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Feb 2024 10:25:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E420B1F24B73
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Feb 2024 09:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88C8E12D15E;
	Tue,  6 Feb 2024 09:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HLS0sgh0"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FB612D769
	for <ceph-devel@vger.kernel.org>; Tue,  6 Feb 2024 09:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707211452; cv=none; b=pymline0LrrCP6dfJjYPem01JD3gHMoJgRXvlSYThoAxjKuz5OppJRetVeGMP0n5fmfuVHQFTkorrqdlv0+Xeu+6HXK/6v3iuIzV++ZU/z83yHZclINbDnhUHjNAKefaq2fDO6BbzK0K5C1Eo/jPG+Z/C2klKgEg8Lwhvla1qK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707211452; c=relaxed/simple;
	bh=cSZCd48xzhqkdiJv08M3EHwMq0qryQC6ogB4MipCRKM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QRcYILF2fZ7lwY5+ZqzOB1gHc25sqK1pv0oAR2BqaRX5hdqtpRO4RqcHscUInq3W5JKVr1LUh5jnDe+0CLit72zym9/5+dQLfsCPh+aOWmzLXuRcx8d0vA6xITrpzv5hGJ0WDRGkvlbS80+BWs5dLMpcEir58j1Nqi6ms/fArVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HLS0sgh0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707211449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W07bwaFUYjmQBPaLb1gF1PXRtF3bAqadz5M7JIr4e/w=;
	b=HLS0sgh0UfvGEImDtPGyYkcaSHr2v1/5flIxE+/p1aPCiQhL4d5/u3HoBc+3L4zbUS++Nu
	O3clbLOn6E+R69mTerWmBMKfGY/DiLa2XyJrvkCvhmVFEZoInL0Cw8jvJ6Sx/p1HLa0w3S
	vXkxl/OvVkcCMqPs1n70BD0WP66oiO8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-358dQ-7vMymInh6vB00WjA-1; Tue, 06 Feb 2024 04:24:07 -0500
X-MC-Unique: 358dQ-7vMymInh6vB00WjA-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a2f71c83b7eso332782866b.1
        for <ceph-devel@vger.kernel.org>; Tue, 06 Feb 2024 01:24:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707211447; x=1707816247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W07bwaFUYjmQBPaLb1gF1PXRtF3bAqadz5M7JIr4e/w=;
        b=noYcNpv7f1tsBb6W60i5zBRh0Nd7gXV7PoR3XM48EtpPmTYt7F7prtukM8o0QBb+Zp
         m9TP+X0PPl4EC1h7wRE/Yr2SW2USQecsC9LF3r/mg8vO8PENzMogSBQzn05p5d/Y91uL
         73pHUaporI5WBiSlNwTO23VIZE5AMTk2Fb7l0khh+WsrEQ6DPvWbz3NV+vWhtA+tP7Ym
         7ZJGa/HWV8e9/6EApP7JH6van2nZlDBgsFp2pfJQNOJlgi8fDyJJyAU+BQQGYgH7etQh
         6nLpvThYSm+IVU1HUhE5yV8mWqRIIiOtMLPF5ZddVLuRGzCOwcEY6aJNj/SGgiqJgRHL
         HxzA==
X-Gm-Message-State: AOJu0YxwusDbk/OIXdU6L3AVe//LLAE3VfAvou3LqxNnitVI97QlyZUD
	yjcvG2T1PlJkLsJxKUxr/Gfk34RlEi1mMUhfRVPSDT3hKMQh/vNrNeTBZXGx+Mpf5eL+2HVheWi
	2GBr8TUct6qMfCMIduI6BWt8GVumEL8lbzuJSGwoTdjRvbyEgi41qmLWIsDOSZRlf5czM2dktkY
	BTM6/pMtUMZZxrJrSU2gGyTMPnwVEYu2JgDA==
X-Received: by 2002:a17:906:568b:b0:a37:c159:60a8 with SMTP id am11-20020a170906568b00b00a37c15960a8mr1346211ejc.29.1707211446906;
        Tue, 06 Feb 2024 01:24:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEMJiZz5SLyQxw+EJ7j2VKV1rQFQ3pLrhX5jPBbVUd4+q7HAOVUHlrP4UkvFe/QDIxfD2UxbV6pROYtWZOHTIo=
X-Received: by 2002:a17:906:568b:b0:a37:c159:60a8 with SMTP id
 am11-20020a170906568b00b00a37c15960a8mr1346194ejc.29.1707211446623; Tue, 06
 Feb 2024 01:24:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231107025423.302404-1-xiubli@redhat.com>
In-Reply-To: <20231107025423.302404-1-xiubli@redhat.com>
From: Venky Shankar <vshankar@redhat.com>
Date: Tue, 6 Feb 2024 14:53:30 +0530
Message-ID: <CACPzV1kxqXP_XTpWjvZHeFOLOyyhLGt7gYQrLbjbJARTgEYSAg@mail.gmail.com>
Subject: Re: [PATCH 0/2] ceph: allocate a smaller extent map if possible
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, jlayton@kernel.org, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 7, 2023 at 8:26=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> For fscrypt case mostly we can predict the max count of the extent
> map, so try to allocate a smaller size instead.
>
>
> Xiubo Li (2):
>   libceph: specify the sparse read extent count
>   ceph: try to allocate a smaller extent map for sparse read
>
>  fs/ceph/addr.c                  |  4 +++-
>  fs/ceph/file.c                  |  8 ++++++--
>  fs/ceph/super.h                 | 14 ++++++++++++++
>  include/linux/ceph/osd_client.h |  6 ++++--
>  4 files changed, 27 insertions(+), 5 deletions(-)
>
> --
> 2.41.0
>

Tested-by: Venky Shankar <vshankar@redhat.com>

--=20
Cheers,
Venky


