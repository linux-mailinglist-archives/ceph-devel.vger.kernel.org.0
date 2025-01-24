Return-Path: <ceph-devel+bounces-2559-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0E74A1BDA6
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Jan 2025 21:51:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4EA518904BA
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Jan 2025 20:51:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AE651DBB36;
	Fri, 24 Jan 2025 20:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WreCpMpV"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4123E1DB366
	for <ceph-devel@vger.kernel.org>; Fri, 24 Jan 2025 20:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737751913; cv=none; b=Sy9JfpN6+G3tfTfEbChKQTfeiPFGXrksX5JKme7TXDGrh3yQ0clTrOf8/WqiYWZWMCqMs0nMKj0Zm3AMjapEXm7Yf6WDtPxPqJKLh2NFQj2coGmeaI/7SysiwxdoBcWWocDHPgRbxsJRTn+gADWjVGvFR7WIrsTGTfzJXZbr4j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737751913; c=relaxed/simple;
	bh=1Wy0+AMl5lTH+SHOelTuWFzEXL+eHACl5fGCtsxftlg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=frItDacMs78PJCGFrb/Xvv5WUN7HFt9w676cTNMKTe1nOK+z2sOvq2GcWrWw9SwlwknwCaGypmxU0o1e49ttQp0sX+tdFvkXfT4yxGh/WazqOJ3JA8/40wi6MNAaFdfT2Dt1ODGZ9ztyaiBkzM5cLrI8GxT0C2TjwysSa3T12UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WreCpMpV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737751911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WnDKRYStVFF2O5PoN6RSjUIWL60O6LRmi/up6YGopUY=;
	b=WreCpMpVOEeAhc/A/OHjvQ0ZO083Tu2KT7vpIjL9rL4/ts9u8kQlXETiXWXEkxKaDw+qh1
	YyLNGTqZCW4oMPjpgUOtV13Ysbn7Ry3Dg4r5vzbBcHbRj4WGBrHSlgdkSxw2C58aWTtoVW
	nBNOr1T08XSLy08H+jTmFF0EDqR1JiM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-4llXjrk2NjWGIRToX9upzA-1; Fri, 24 Jan 2025 15:51:50 -0500
X-MC-Unique: 4llXjrk2NjWGIRToX9upzA-1
X-Mimecast-MFC-AGG-ID: 4llXjrk2NjWGIRToX9upzA
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7b6e241d34eso326600485a.0
        for <ceph-devel@vger.kernel.org>; Fri, 24 Jan 2025 12:51:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737751909; x=1738356709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WnDKRYStVFF2O5PoN6RSjUIWL60O6LRmi/up6YGopUY=;
        b=kAO/zp1oZxJwIGMqxFxKnEJXG1MzjGe2Te3Sh56t972hIv5t+EwANMGqpEGkKmrAwa
         U7Kia0tVXYyqrg+vID651fNCMr9jXqj8PmTpwfxJD5ytSp8VeDT3EW3SjjydK65ZWUe+
         rKqMo6bVFRhCKi1YKMUCYelKdpwDnaAjXcx4quP8GSgtYBTu4+KRZ1uIf/NXY7WD3MHU
         Dg4bmuvNeyKga6e+T0ngIdicLtl71rm0a4rz9um03VStq2xohgMM2T55qspTWDee4Grx
         ZlZ8AlmNGjUSQwNwQRrAp0yrujN1rBznGAmFX//jqFX4z+bS6tYRyGMYow+YdhzUlhx5
         46GA==
X-Gm-Message-State: AOJu0YyiBMoA5a4vUGOKFHNyWVqTB6Y/QRJaJ5SLVlfyPIHVfTwrSH5K
	kwz+xn9bDotH1he3SnjQpp9hEoFFaay7MlvYa5I4hTDeAHkfYmGg3z2FHK7QqRwg09i0vLWLemV
	1d0U5I5mu/Zm3wElnC6wM6YHNb9kjZ3l92fdiGqVrek2P7pgLFYKlcv+whJ0QInesMd2galRXSZ
	HlqVLx3fzRcVJacAFgzvA5SovqbQcRGBxt2w==
X-Gm-Gg: ASbGncuGhLGjGHC4jzaJ6VM3HYk2Xl3P4jfa6/vht/uIPH0WzIJr5zM0YSKk3AuY5Y1
	6pl0YVlel01pf9/fAmJJsKMoHWju9k1pHX7Ke8no5GDXcO/TjCqk=
X-Received: by 2002:a05:620a:1a07:b0:7b6:d97a:2608 with SMTP id af79cd13be357-7be6321c005mr4741129485a.17.1737751909684;
        Fri, 24 Jan 2025 12:51:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFlQYEC/ET/acRO8eOALZe6FdUxkpevtt90ZWb5S2lfnmgT90M1F+3wFQEHr7lQn2mMhYC2pofzS2C7YpkTrUI=
X-Received: by 2002:a05:620a:1a07:b0:7b6:d97a:2608 with SMTP id
 af79cd13be357-7be6321c005mr4741127885a.17.1737751909460; Fri, 24 Jan 2025
 12:51:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124194623.19699-1-slava@dubeyko.com>
In-Reply-To: <20250124194623.19699-1-slava@dubeyko.com>
From: Patrick Donnelly <pdonnell@redhat.com>
Date: Fri, 24 Jan 2025 15:51:23 -0500
X-Gm-Features: AWEUYZmcrCmqkBW_qx0NobEAPNVA_lVJbUALU-0J_3qCaT4SMmzm5ZQxDCUOqDc
Message-ID: <CA+2bHPbkATtMp_BgX=ySuPZkMSqd5EwjoRdsAsoOOxuoN3wzTw@mail.gmail.com>
Subject: Re: [PATCH] ceph: exchange hardcoded value on NAME_MAX
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, 
	linux-fsdevel@vger.kernel.org, amarkuze@redhat.com, Slava.Dubeyko@ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 24, 2025 at 2:46=E2=80=AFPM Viacheslav Dubeyko <slava@dubeyko.c=
om> wrote:
>
> From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
>
> Initially, ceph_fs_debugfs_init() had temporary
> name buffer with hardcoded length of 80 symbols.
> Then, it was hardcoded again for 100 symbols.
> Finally, it makes sense to exchange hardcoded
> value on properly defined constant and 255 symbols
> should be enough for any name case.
>
> Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> ---
>  fs/ceph/debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index fdf9dc15eafa..fdd404fc8112 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -412,7 +412,7 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *f=
sc)
>
>  void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
>  {
> -       char name[100];
> +       char name[NAME_MAX];
>
>         doutc(fsc->client, "begin\n");
>         fsc->debugfs_congestion_kb =3D
> --
> 2.48.0
>
>

Reviewed-by: Patrick Donnelly <pdonnell@ibm.com>

--=20
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


