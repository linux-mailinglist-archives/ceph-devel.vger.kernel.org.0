Return-Path: <ceph-devel+bounces-3280-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 89BB6AFC6BD
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Jul 2025 11:10:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48601188FE46
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Jul 2025 09:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA68D2BEC4A;
	Tue,  8 Jul 2025 09:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dRxDGXY8"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2FB2BEC3A
	for <ceph-devel@vger.kernel.org>; Tue,  8 Jul 2025 09:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751965799; cv=none; b=X40iRyGKWsBIWoK3zHargV/t67QfNgGlqSRHJVUnCfACk7Wc0xB2VjxOPpJrSvB9vK2QShQngdYWHs3r5THpx0Fij53Wc6c//H/Hg6QfvJWTdvRbuQarWtscQ+BAiuSXq/io8dRgSo4lgWs35j3xjLIRcDlfBjXL4l3lvFJi7a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751965799; c=relaxed/simple;
	bh=wM7ZfNBhkaufSk3KhsGdv97Ydj4Nl0+cLzZGdqlDAUI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MPOH5lt0iO6AVnXl8qNv4sSDfYPjqpGuoNFnkgPfyTHaRxf0gTo/gZha/7RS9eb04RJI8Etzg5Qy6+O6Sc4fwX0qcj5KBC6SL8xPrj1q+ADqH07NJVNkvpj7q/Wog4GqU3opv7JY8aAU5jRoHUR/oHtNAf+CeGyiW8eUYQINS74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dRxDGXY8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751965796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QnWgG0goWxx7fRL8vcacVmyjGfkQty2JifLyLhpG8wM=;
	b=dRxDGXY8M1bsur35aTOSlnDV22w8s0j2QrsicDdvuht8iFCHDkf7M0BEzVjE3PkGeqSlwA
	7HxSkIPLSCLY0n91FIGKB+QbmRnRKielPmtyb8LEIMad7JAHjvmGx595s9u6/9pN5R+pVM
	SSXf5Vscx5tBzzGnJ4QKcDvABCgqAtM=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-8gMf7OCoMRWzZQDnby3gKQ-1; Tue, 08 Jul 2025 05:09:55 -0400
X-MC-Unique: 8gMf7OCoMRWzZQDnby3gKQ-1
X-Mimecast-MFC-AGG-ID: 8gMf7OCoMRWzZQDnby3gKQ_1751965794
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-5314dd44553so1474920e0c.3
        for <ceph-devel@vger.kernel.org>; Tue, 08 Jul 2025 02:09:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751965794; x=1752570594;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QnWgG0goWxx7fRL8vcacVmyjGfkQty2JifLyLhpG8wM=;
        b=cqWF+0nH+R5VK7CEm2OEE+I8k4LXzJaZUIhGbMh5X9t05cYd7MJ8DcwTgfxrcFM38K
         mit9GAik27aBIDd6eG6CspTQAiT/lv6qO532w4UNb2OMwscwxaO2OyErMFgzc6Exqq97
         xMEnI2w5dlxZdVgDfXkTp+8DANNxXFcauFLuMClMn4rUFNjS8S+473jGsF547HFyDhWW
         zWxD9696L4RCjsO5F2nlEOlnwStCFHYuAdQbyYjurBh0Ksd2h98FqGJc8WfZcsyi8YbY
         XKLUiijuv7b603exc9mX2QymNHSBN+tfVFr7dD+78YAPaDe+69yFhGchIzFy2srdJK3j
         ZOeg==
X-Gm-Message-State: AOJu0Yw+nkK+khrk1rVjaupIIVDtQeAHp+TbGgwOr5l8abY6lLeYv6ku
	1wq8KB2fZjCMiuzPk1B2foNTZDFGT39GYmsaDO8Ya/WY4ZYgNqLxZXVc93a+6q+pqBKEdKi+1s/
	dCQZKzJ5uDMdbifwISeWKUNq7AGvYR2NSgrZg/DxeSbkmGwEB460tCTzipy3tEz9mKg/kzhPQ01
	K6YVubmnQm9zBEAdNilFZzNhOeeamN0Ct/nVDjUloV772Wv09PW9I=
X-Gm-Gg: ASbGncsci7+ruJHtMjrl5cWIsakk7+7Y/fL7EPjDnFb4cGa8uG2cljcn+63DHQWi3lK
	NTh0TAxAlhszjBBL/g3bt5RMN32N0zEyWg8pmV0UfpQ4UjwrnO3zCRyQe/EfVnoNgCzvwUmC3lJ
	X6wP9L
X-Received: by 2002:a05:6122:3b8e:b0:534:7f57:8e30 with SMTP id 71dfb90a1353d-535c5632cd1mr1134268e0c.10.1751965794460;
        Tue, 08 Jul 2025 02:09:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4AJsmhij0Hs+Z/XqRzy8DpoaOFfIRTzhBdqEJhu11l3B1q1Qktb03QvCYrmj4SpyW1/fZCCtmP0WIc1MWRAM=
X-Received: by 2002:a05:6122:3b8e:b0:534:7f57:8e30 with SMTP id
 71dfb90a1353d-535c5632cd1mr1134263e0c.10.1751965794077; Tue, 08 Jul 2025
 02:09:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <SEZPR04MB69722E22D60977F94BD6E875B745A@SEZPR04MB6972.apcprd04.prod.outlook.com>
 <CAO8a2SjYNTd1v=rGtSpeRcqUyuAJj1adjKy98Q8mGkaGtgRJrw@mail.gmail.com> <SEZPR04MB6972B4482065C457DEDD4976B74EA@SEZPR04MB6972.apcprd04.prod.outlook.com>
In-Reply-To: <SEZPR04MB6972B4482065C457DEDD4976B74EA@SEZPR04MB6972.apcprd04.prod.outlook.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Tue, 8 Jul 2025 12:09:43 +0300
X-Gm-Features: Ac12FXxJn0s2gubqFRrGrz42diK9W7aRCvssHamr0s-A28jVWdTL9mMhika6JcA
Message-ID: <CAO8a2Sg1bqA+xkKCy0NGzJFxMuEQjw9bZVytbtaqZxCjzPsgRg@mail.gmail.com>
Subject: Re: [RFC] Different flock/fcntl locking behaviors via libcephfs and
 cephfs kernel client
To: =?UTF-8?B?RnJhbmsgSHNpYW8g6JWt5rOV5a6j?= <frankhsiao@qnap.com>
Cc: Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The core issue here is the difference between kernel-space
(VFS-mediated) and user-space (libcephfs) access.

When you use the kernel CephFS client, file locking goes through the
Linux VFS, which enforces system-wide POSIX lock semantics. This
ensures that locks taken via one protocol (e.g., NFS) are respected by
others (e.g., Samba), because they all go through the same kernel
locking infrastructure.

In contrast, libcephfs operates entirely in user space. Each process
using libcephfs (Samba, NFS-Ganesha) has its own independent view of
file locking. There is no shared VFS layer to mediate and enforce
locks between them. As a result, locks are not visible or respected
across libcephfs clients, even if they access the same underlying
CephFS data.

The difference in behavior you=E2=80=99re seeing is expected and stems
directly from this VFS vs user-space isolation.

Best,
Alex

On Tue, Jul 8, 2025 at 6:50=E2=80=AFAM Frank Hsiao =E8=95=AD=E6=B3=95=E5=AE=
=A3 <frankhsiao@qnap.com> wrote:
>
> Hi Alex,
>
> Thank you for detailed explanation regarding the lock isolation between m=
ultiple
> libcephfs clients. I would like to follow up with a few questions:
>
> 1. Would it be advisable to switch to kernel mount in order to ensure con=
sistent
> lock coordination between multiple clients?
> 2. Are there lock/cache issues if I use a hybrid setup(Samba uses kernel =
client
> and NFS uses libcephfs, for example)? Or more generally, when running mul=
tiple
> protocols over the same CephFS backend, is there a recommended approach
> regarding libcephfs vs. kernel client usage?
>
> Thanks,
> Frank
>
>
> ________________________________________
> =E5=AF=84=E4=BB=B6=E8=80=85: Alex Markuze <amarkuze@redhat.com>
> =E5=AF=84=E4=BB=B6=E6=97=A5=E6=9C=9F: 2025=E5=B9=B47=E6=9C=887=E6=97=A5 =
=E4=B8=8B=E5=8D=88 07:42
> =E6=94=B6=E4=BB=B6=E8=80=85: Frank Hsiao =E8=95=AD=E6=B3=95=E5=AE=A3
> =E5=89=AF=E6=9C=AC: Ceph Development
> =E4=B8=BB=E6=97=A8: Re: [RFC] Different flock/fcntl locking behaviors via=
 libcephfs and cephfs kernel client
>
> Subject: Re: File locking semantics with CephFS via Samba and NFS (libcep=
hfs)
>
> ________________________________
>
> Hi Frank,
>
>
> To your core questions:
>
> Yes, the observed behavior is expected when using libcephfs. Unlike
> the kernel CephFS client, libcephfs does not provide full POSIX lock
> coordination across multiple client instances. Samba and NFS-Ganesha
> are each using their own libcephfs context and thus maintain separate
> lock states, and locks acquired on one side are not visible or
> enforced on the other.
>
> There are indeed known limitations when mixing protocols over
> libcephfs. In particular, file locking, delegation, and caching
> semantics are not shared across libcephfs consumers, and the Ceph MDS
> doesn't currently merge lock states across independent user-space
> clients unless mediated through the kernel client or coordinated
> explicitly.
>
>
>
> On Mon, Jul 7, 2025 at 12:59=E2=80=AFPM Frank Hsiao =E8=95=AD=E6=B3=95=E5=
=AE=A3 <frankhsiao@qnap.com> wrote:
> >
> > Hi all,
> >
> > I=E2=80=99m encountering unexpected behavior when testing file locking =
semantics on
> > CephFS accessed concurrently via Samba and NFS, both backed by libcephf=
s.
> >
> > I=E2=80=99m running a CephFS cluster with both Samba and NFS-Ganesha se=
rvices.
> > All clients (Samba and NFS) use libcephfs as the underlying CephFS moun=
t
> > mechanism. My goal is to verify how file locking behaves across protoco=
ls
> > (SMB and NFS) and whether POSIX lock interoperability is maintained.
> >
> > Ceph version: 19.2.2
> > Samba version: 4.20.7
> > Ganesha version: V5.5
> > "posix locking =3D yes" is toggled in Samba
> >
> > For each combination of mount type and posix locking setting in Samba, =
we test:
> > 1. flock()/fcntl() from NFS and Samba clients.
> > 2. Write attempts from the other side (e.g., NFS flock, then Samba writ=
e).
> >
> > A. Samba with libcephfs + posix locking =3D yes
> > - samba flock()/fcntl(), samba write() -> permission denied (expected)
> > - nfs flock()/fcntl(),  samba write() -> write succeeds (unexpected)
> > - samba flock()/fcntl(), nfs write() -> write succeeds (expected)
> > - nfs flock()/fcntl(), nfs write() -> write succeeds (expected)
> >
> > B. Samba with libcephfs + posix locking =3D no
> > - samba flock()/fcntl(), samba write() -> permission denied (expected)
> > - nfs flock()/fcntl(),  samba write() -> write succeeds (expected)
> > - samba flock()/fcntl(), nfs write() -> write succeeds (expected)
> > - nfs flock()/fcntl(), nfs write() -> write succeeds (expected)
> >
> > We expected that if "posix locking =3D yes", locks obtained via NFS (vi=
a fcntl
> > or flock) would be respected by Samba as POSIX locks, but in case A, th=
ey are
> > seemingly ignored.
> >
> > On the other hand, using ceph kernel mount for Samba (instead of libcep=
hfs)
> > respect NFS-side locks when "posix locking =3D yes". (deny write when N=
FS obtain
> > flock/fcntl locks)
> >
> > My questions are:
> >
> > 1. Is this behavior expected with libcephfs?
> > 2. Are there known limitations when mixing cephfs use across protocols?
> > 3. Is there a recommended practice for exporting cephfs volumes by Samb=
a and
> > NFS simultaneously?
> >
> > Any comments would be greatly appreciated, and please let me know if an=
y
> > additional logs or test code would be helpful.
> >
> > Thanks,
> > Frank
>


