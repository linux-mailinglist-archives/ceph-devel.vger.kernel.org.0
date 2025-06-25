Return-Path: <ceph-devel+bounces-3209-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CCF9BAE7FAA
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Jun 2025 12:38:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C26C172660
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Jun 2025 10:38:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 520802BDC10;
	Wed, 25 Jun 2025 10:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MFomjSGn"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF120285CB8
	for <ceph-devel@vger.kernel.org>; Wed, 25 Jun 2025 10:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750847842; cv=none; b=fD0BQuLuqgul7BR8udl/wpIMIFBLM6e9Kmb6Ops/oIwBXgZoHRhXBxvIyChv2GGdTp5MukOkuJWpk4x+lNfzN0eeXov0MJoi4UBC1bPhrjKbWyUrWCEwjFlazXUANgOgQqBlPrCgkgha8Xe98j4FL+PYl8Fk68XbR9Y813Dh5ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750847842; c=relaxed/simple;
	bh=RFjd235L7/G9kW2qDRezkDrJvYAmAVxhzg6JrL2fuBc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jkrSAQsKYhYvZ+sQKycDeeGJGkLKZun+exSNxT9zHs3Sbzav44VG1JYOS6WzJivjCfgRD/eBWcuZJNAMhfd+qQUnPTa1/PPn/5yk/NSHL8eLGsBD027MuzWDECDEkymxYCZ63stprPc0lnjuXZltihkdO0rS3KvU61bOoYLxTQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MFomjSGn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750847838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V/i6X5rNkwtkA0z3dVR9ep6Ga20RqSlPFLO6q4Jo+/c=;
	b=MFomjSGnWU/LNmVS3BRFTSWXr/xzrwvunYpkFAKeKYkEgmIWsWEPT7XikZv5rb4fhZPz4x
	2iiKtGfZO7+DnF5NZYUrJtsfKk5i2qnLJdW7RdMH88oLLrEeiNoJMIoZnLWFdxbZ2yTLZk
	EPISJrleaOS5MyB4At16Ff+dmcs2ICI=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-9FJn-4vHO7K2X9-PCsN71g-1; Wed, 25 Jun 2025 06:37:17 -0400
X-MC-Unique: 9FJn-4vHO7K2X9-PCsN71g-1
X-Mimecast-MFC-AGG-ID: 9FJn-4vHO7K2X9-PCsN71g_1750847837
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-4e98c14da9bso324805137.1
        for <ceph-devel@vger.kernel.org>; Wed, 25 Jun 2025 03:37:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750847837; x=1751452637;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V/i6X5rNkwtkA0z3dVR9ep6Ga20RqSlPFLO6q4Jo+/c=;
        b=ok7Ncf2As2mu0NySpSYWPhVcJ4if+nLEugJvDCMk5VBugHNMrxMDTbxzHOPPWFU3xP
         QWnQ8hrUtf3MB4DDuUY9QzwFLms7IRUhsK+TONN2OuGSsRjQCaI0HAoQZf211iasSpSf
         RYA2g6dJyW1bYzNMJxQ4OSna8z9BngxuEdxosJzOHA+rCIMkE4Syl/omN9+kJEGlBufL
         RNL1r8ASdjIZPvPdw7PST/5Ddpv4DOkyXqZh13BWJnGv55Fu3+CQ9CXxLqvhsztUcQ9S
         PN/8pcJ9nZuBs0ekDiUN5Lh5sNa2ld4qHtTNXsMS9u8ZbAh+14gR3U8aLdQ5t02LzXSY
         fuuQ==
X-Gm-Message-State: AOJu0YxdRtUBIZk8sUCOcuJjT+SadV0d8Y5Zjx7SMDIPdmoYXSh9etYK
	rFX1iBp1+GGj2QjcDjNM3ZzdfSmcEbeLtQ7uevQRwYTZliAShOE/e6ajvnptdrDXZbJ/LjdiqOE
	tCMc6DQusURRp5Si0oCsrk8Amqg1PqmiCdmQsSqkmC6rGSdEebQSvdShklMrlx6W9eoPKgEEBoc
	smmV1Tx1ddJ+6QJ4y47euy2NFraHcmZsKxF80zUg==
X-Gm-Gg: ASbGncsqkAXcw7Us67ZmBF2XaJOyjjknSkFg+q8YIrheFJk/MJzrhWHDgd37LXggY5u
	aT7EKsQkClCqPcK34ypF/Pk87USzYGCmbkL2uAD5USbPJiNjENsubGJnE8ysQssTbgg1if9X4T2
	xR
X-Received: by 2002:a05:6102:c0a:b0:4e9:968b:4414 with SMTP id ada2fe7eead31-4ecc76b5e32mr1155760137.22.1750847836964;
        Wed, 25 Jun 2025 03:37:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEjmoE/3Y+PAxOwo1N9Ubp8LCBIElRgF9CCRTyuKPdkdQMhC0WeUYbbn48B3y/Vk6EqzEU2KbbXj4tvlr3EqvQ=
X-Received: by 2002:a05:6102:c0a:b0:4e9:968b:4414 with SMTP id
 ada2fe7eead31-4ecc76b5e32mr1155756137.22.1750847836631; Wed, 25 Jun 2025
 03:37:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250613183453.596900-1-slava@dubeyko.com>
In-Reply-To: <20250613183453.596900-1-slava@dubeyko.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Wed, 25 Jun 2025 13:37:06 +0300
X-Gm-Features: Ac12FXw8zPCUBCoR_LcSrwIyPH209rQ9V46iiLqHrxIn7kQRVzE_ZjitLYeAsrA
Message-ID: <CAO8a2SjLCq1ztLfYe7bPjhyDqAqX0AGBRdQ-cAuX7gzTrmm70g@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix potential race condition in ceph_ioctl_lazyio()
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, 
	linux-fsdevel@vger.kernel.org, pdonnell@redhat.com, Slava.Dubeyko@ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good work addressing the Coverity finding. The fix properly eliminates
the race condition by moving the check inside the lock.

Reviewed-by: Alex Markuze amarkuze@redhat.com

On Fri, Jun 13, 2025 at 9:35=E2=80=AFPM Viacheslav Dubeyko <slava@dubeyko.c=
om> wrote:
>
> From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
>
> The Coverity Scan service has detected potential
> race condition in ceph_ioctl_lazyio() [1].
>
> The CID 1591046 contains explanation: "Check of thread-shared
> field evades lock acquisition (LOCK_EVASION). Thread1 sets
> fmode to a new value. Now the two threads have an inconsistent
> view of fmode and updates to fields correlated with fmode
> may be lost. The data guarded by this critical section may
> be read while in an inconsistent state or modified by multiple
> racing threads. In ceph_ioctl_lazyio: Checking the value of
> a thread-shared field outside of a locked region to determine
> if a locked operation involving that thread shared field
> has completed. (CWE-543)".
>
> The patch places fi->fmode field access under ci->i_ceph_lock
> protection. Also, it introduces the is_file_already_lazy
> variable that is set under the lock and it is checked later
> out of scope of critical section.
>
> [1] https://scan5.scan.coverity.com/#/project-view/64304/10063?selectedIs=
sue=3D1591046
>
> Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> ---
>  fs/ceph/ioctl.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
> index e861de3c79b9..60410cf27a34 100644
> --- a/fs/ceph/ioctl.c
> +++ b/fs/ceph/ioctl.c
> @@ -246,21 +246,27 @@ static long ceph_ioctl_lazyio(struct file *file)
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
>         struct ceph_mds_client *mdsc =3D ceph_inode_to_fs_client(inode)->=
mdsc;
>         struct ceph_client *cl =3D mdsc->fsc->client;
> +       bool is_file_already_lazy =3D false;
>
> +       spin_lock(&ci->i_ceph_lock);
>         if ((fi->fmode & CEPH_FILE_MODE_LAZY) =3D=3D 0) {
> -               spin_lock(&ci->i_ceph_lock);
>                 fi->fmode |=3D CEPH_FILE_MODE_LAZY;
>                 ci->i_nr_by_mode[ffs(CEPH_FILE_MODE_LAZY)]++;
>                 __ceph_touch_fmode(ci, mdsc, fi->fmode);
> -               spin_unlock(&ci->i_ceph_lock);
> +       } else
> +               is_file_already_lazy =3D true;
> +       spin_unlock(&ci->i_ceph_lock);
> +
> +       if (is_file_already_lazy) {
> +               doutc(cl, "file %p %p %llx.%llx already lazy\n", file, in=
ode,
> +                     ceph_vinop(inode));
> +       } else {
>                 doutc(cl, "file %p %p %llx.%llx marked lazy\n", file, ino=
de,
>                       ceph_vinop(inode));
>
>                 ceph_check_caps(ci, 0);
> -       } else {
> -               doutc(cl, "file %p %p %llx.%llx already lazy\n", file, in=
ode,
> -                     ceph_vinop(inode));
>         }
> +
>         return 0;
>  }
>
> --
> 2.49.0
>


