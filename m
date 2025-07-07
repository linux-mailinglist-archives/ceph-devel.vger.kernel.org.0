Return-Path: <ceph-devel+bounces-3272-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C9F9AFB27B
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Jul 2025 13:42:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B06021AA2D3A
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Jul 2025 11:42:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9E3428C005;
	Mon,  7 Jul 2025 11:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U9Yygw2N"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE2F1C5485
	for <ceph-devel@vger.kernel.org>; Mon,  7 Jul 2025 11:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751888556; cv=none; b=fp/R4o+oVlPBEK1tn3zz6Z+zvjfTAPxIX//bYaY21i6AktkueQg8uxOarDWMLCi+Oyp74ltBaaYEkx4bc6f19wCmrb9+/c6MSqX50N/Z7nhYnyCO309x9e2eAS4Ed2WWlV7w7P/1AVnzMEPXNpf4dlHVqUz8zZaY2kfgeg8isEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751888556; c=relaxed/simple;
	bh=R0isa61IiXvrwo4Vdci4YWsOFbaSsqtDE3CNZvvRoHQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HLnSGQLjyoE+e7vpiw/buOzLvDR8+DiLzoMJsebRZamTqYPg/1rnOrD0EyiAya4DF8/zHm5cGv7zdy25SAT6pT84+05FPGHvQL5EB7LEqqK8GAlB0ca6ItNCDCcdmuMC3WGk+rECue5w7CdYAMa8zlEYDxJBrvP4/CoCxuzQvxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U9Yygw2N; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751888553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lV8ikuOgHWpVDwWKQx69+X3cVBM8Z8onUsJajKehDGs=;
	b=U9Yygw2NsZ8fBKCTxdJp+7C4J1LnyoS5vIzXBIOrcFT3xiiVYKJTvgNR70sJoskBlhec3H
	sPeVeMIPWU+tC4KUiyyq6htXs6vcIfPBhTerlYf/cBdPAErsiCbR66izDzVXW4vhIt5YgS
	7+t5dQDo/bJKhpvH2DIoEBPqNLDwJcs=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-46XWHF0eMvWuXOhBJos_6g-1; Mon, 07 Jul 2025 07:42:32 -0400
X-MC-Unique: 46XWHF0eMvWuXOhBJos_6g-1
X-Mimecast-MFC-AGG-ID: 46XWHF0eMvWuXOhBJos_6g_1751888552
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-532eb852e21so645235e0c.2
        for <ceph-devel@vger.kernel.org>; Mon, 07 Jul 2025 04:42:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751888552; x=1752493352;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lV8ikuOgHWpVDwWKQx69+X3cVBM8Z8onUsJajKehDGs=;
        b=Uo9dkOIdSOitJPWB4C3EfQzKAw2FrI1FTXv2RI4K3mzCXaIIVIeeDzKHmxz8Sh8sC7
         Gvxb5eCg5V1Tvq3v3LeYfNo37ZGF/s7uw3DEQeOq32kK+OIujxQJ9MKF+ktQXpa0W65m
         kacKHNtQKf6tzIjWhPGAZWmreKYsyLZ0AuRTgvCmM7GBzMjiFsUUpXGoC+dc2vvdglFl
         KdT2tthGt79dJsYSt3hTWG79fM4Y9W+L7bJmIZy3uO8T5FOsozoCfACAB/6+mUEy9VKb
         55+8SIC5jJAupF+nypqy3WKBqdMlr3bkG/8SerNrZa0Ib8vEAp/3KZcOqRmTBrjtk2LN
         Gt9A==
X-Gm-Message-State: AOJu0YzfHGXsiYh9kuwTHEZ9L/OAmpcPpXinbvFCwYdPatVEuHjrFm2r
	r7go55PpJUtS7xfENYXkJ7Um93UOs1o7eJROrUJ3xbmvBQsoqM3i3jgLFJGOYDCPKOcmRS9fy8U
	BK4pZ2jQHlqruT6/0qgwtW3rtVDLbdkbsK9/ROG6ZhpvGK0tHPzFk3wa86ptIDAvcjKvTGYEJdi
	mT54LoJuejFMl2Kc8mwGnz8qMbDwOUtCwPvZlwzILfwyVLw7UK
X-Gm-Gg: ASbGnctv9Sk120mJvDYyx+NwWK6YpQXE9RqRtcxc3Hc9ATyr2rbI0Fskyd+gmNv11QC
	0Rnpm0bwMuNyrxtm1LlLJbf6GAiRo3u3RuqYjVINJp5OReuCiZhk3PeTtuwHcbTEqbLSr4SgnVT
	p3wzpY
X-Received: by 2002:a05:6102:511e:b0:4e7:866c:5ccd with SMTP id ada2fe7eead31-4f2f1e71112mr6634078137.8.1751888551756;
        Mon, 07 Jul 2025 04:42:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IESmQT/CI3bhIV3H2ANewJX1wrCDUSGGvVR9w9aXibbI+Q/fCGbbnM0dy+vkNBvD5A2K24+d1ZZ7Qxn903FGtA=
X-Received: by 2002:a05:6102:511e:b0:4e7:866c:5ccd with SMTP id
 ada2fe7eead31-4f2f1e71112mr6634073137.8.1751888551396; Mon, 07 Jul 2025
 04:42:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <SEZPR04MB69722E22D60977F94BD6E875B745A@SEZPR04MB6972.apcprd04.prod.outlook.com>
In-Reply-To: <SEZPR04MB69722E22D60977F94BD6E875B745A@SEZPR04MB6972.apcprd04.prod.outlook.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Mon, 7 Jul 2025 14:42:00 +0300
X-Gm-Features: Ac12FXx2k6ms2-fi98VW-D7Fyup-cDsuPk5_g85MROyUz_468KgUa5af_52r4bU
Message-ID: <CAO8a2SjYNTd1v=rGtSpeRcqUyuAJj1adjKy98Q8mGkaGtgRJrw@mail.gmail.com>
Subject: Re: [RFC] Different flock/fcntl locking behaviors via libcephfs and
 cephfs kernel client
To: =?UTF-8?B?RnJhbmsgSHNpYW8g6JWt5rOV5a6j?= <frankhsiao@qnap.com>
Cc: Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Subject: Re: File locking semantics with CephFS via Samba and NFS (libcephf=
s)

________________________________

Hi Frank,


To your core questions:

Yes, the observed behavior is expected when using libcephfs. Unlike
the kernel CephFS client, libcephfs does not provide full POSIX lock
coordination across multiple client instances. Samba and NFS-Ganesha
are each using their own libcephfs context and thus maintain separate
lock states, and locks acquired on one side are not visible or
enforced on the other.

There are indeed known limitations when mixing protocols over
libcephfs. In particular, file locking, delegation, and caching
semantics are not shared across libcephfs consumers, and the Ceph MDS
doesn't currently merge lock states across independent user-space
clients unless mediated through the kernel client or coordinated
explicitly.



On Mon, Jul 7, 2025 at 12:59=E2=80=AFPM Frank Hsiao =E8=95=AD=E6=B3=95=E5=
=AE=A3 <frankhsiao@qnap.com> wrote:
>
> Hi all,
>
> I=E2=80=99m encountering unexpected behavior when testing file locking se=
mantics on
> CephFS accessed concurrently via Samba and NFS, both backed by libcephfs.
>
> I=E2=80=99m running a CephFS cluster with both Samba and NFS-Ganesha serv=
ices.
> All clients (Samba and NFS) use libcephfs as the underlying CephFS mount
> mechanism. My goal is to verify how file locking behaves across protocols
> (SMB and NFS) and whether POSIX lock interoperability is maintained.
>
> Ceph version: 19.2.2
> Samba version: 4.20.7
> Ganesha version: V5.5
> "posix locking =3D yes" is toggled in Samba
>
> For each combination of mount type and posix locking setting in Samba, we=
 test:
> 1. flock()/fcntl() from NFS and Samba clients.
> 2. Write attempts from the other side (e.g., NFS flock, then Samba write)=
.
>
> A. Samba with libcephfs + posix locking =3D yes
> - samba flock()/fcntl(), samba write() -> permission denied (expected)
> - nfs flock()/fcntl(),  samba write() -> write succeeds (unexpected)
> - samba flock()/fcntl(), nfs write() -> write succeeds (expected)
> - nfs flock()/fcntl(), nfs write() -> write succeeds (expected)
>
> B. Samba with libcephfs + posix locking =3D no
> - samba flock()/fcntl(), samba write() -> permission denied (expected)
> - nfs flock()/fcntl(),  samba write() -> write succeeds (expected)
> - samba flock()/fcntl(), nfs write() -> write succeeds (expected)
> - nfs flock()/fcntl(), nfs write() -> write succeeds (expected)
>
> We expected that if "posix locking =3D yes", locks obtained via NFS (via =
fcntl
> or flock) would be respected by Samba as POSIX locks, but in case A, they=
 are
> seemingly ignored.
>
> On the other hand, using ceph kernel mount for Samba (instead of libcephf=
s)
> respect NFS-side locks when "posix locking =3D yes". (deny write when NFS=
 obtain
> flock/fcntl locks)
>
> My questions are:
>
> 1. Is this behavior expected with libcephfs?
> 2. Are there known limitations when mixing cephfs use across protocols?
> 3. Is there a recommended practice for exporting cephfs volumes by Samba =
and
> NFS simultaneously?
>
> Any comments would be greatly appreciated, and please let me know if any
> additional logs or test code would be helpful.
>
> Thanks,
> Frank


