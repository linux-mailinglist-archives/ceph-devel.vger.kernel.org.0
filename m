Return-Path: <ceph-devel+bounces-3283-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 357EAAFE34E
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Jul 2025 10:56:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F2B7A1BC0FD1
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Jul 2025 08:56:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BE2D27EFE9;
	Wed,  9 Jul 2025 08:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hyntAGnk"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C50123B60A
	for <ceph-devel@vger.kernel.org>; Wed,  9 Jul 2025 08:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752051373; cv=none; b=gzxx/HyLsdhO7itEt08LQfqKTtl8rzDInaFL4Rp3esOr1BXk+vGzkFoEO3kPlmGtahffhbov/EAUDdPTIxpNLQe9w41xKuyUxLBCkCpRZSRK8khNMagZySDl8qeRSdjmHgbU2EHHno0DwzHtMi2R1D61vCFDkOTWW5HY7OZPIMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752051373; c=relaxed/simple;
	bh=ATPW2EHfzjUlVS4i9Ykg3zv03PfVzz8O/ElPL/zZWpY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iDT+9sQwNwV6p1pasPaNgR0ghEJ5Or1qRxiEjgSqAfdswwpkPSO11nEXg1eLCnxk4XFz9TSCXKb2SejkORT4PJvcquOKKPJN6GhgM090MLp4xAU2UVw0n46sgCC7eK0coVOz4PA1KPpBL6AXzV7sDcmg2sf6pnZiEpe/5Pzusow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hyntAGnk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752051370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bc8uPmeYOycbFMe165Vbw6XN1XEdFe8ah0c81JC6488=;
	b=hyntAGnk/0lIKp31poDp4KERk2f3SPl8BDFe5A8mpbrs1PSRjrX6t3Dc13NmY1/hwLQExS
	ADaZaYpS78P7afrb/oF5L8W04BBAhCWqs3+U2zYxUu80lBiT7X3NCg+7OsiubE70ROfgG9
	qDqomuxa1XuRP6G843m1p0Z8hFkvTlw=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-b1f4e-qsM7K1Gktk40Q5Rw-1; Wed, 09 Jul 2025 04:56:08 -0400
X-MC-Unique: b1f4e-qsM7K1Gktk40Q5Rw-1
X-Mimecast-MFC-AGG-ID: b1f4e-qsM7K1Gktk40Q5Rw_1752051368
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-87f21c86defso535324241.0
        for <ceph-devel@vger.kernel.org>; Wed, 09 Jul 2025 01:56:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752051368; x=1752656168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bc8uPmeYOycbFMe165Vbw6XN1XEdFe8ah0c81JC6488=;
        b=MCsVmFeVVxeoBalLVpFO8lotpSNRgrQUMdqe2DAf4mROE8YKXl2UkkwWqhMxXCKR/V
         +6eOVyKBF/SbYKSfInRO7VZ1GrGB8ccR1RavOrziW4wdAA+bNXFx5KaITZVKblF7XzWI
         8Xa4R4Hh2uv3XxiXIUWSgYue3kyAmaUcD0Yup5TCNWN8ulLdjR76m4+0hfUPdlhc69Ij
         0Kk1DSpijZ7rKQ8lMMnd6rmhq76oj9sr1K1oUM7/StG27WCM+kynWuWAT9Gg48mHCvyU
         SZJXL81Nt5ubZawD4hHgySKdcRr821T6YV/7nXpVnA4YYwtBpozWHey5rwL53zkV5mJ0
         cTXg==
X-Gm-Message-State: AOJu0YwSFUBexl1NhEGZwewXs4rCGIGQP71TcZMkw9wpPGtwwA1U4OHy
	Iqa4mZg22+YsK1F3/LHLszE7Q6HjJgjASL5fj5gf6X8KrD21NsBcfklV+QhAkhFnuSrFV8aFXuC
	00YzacCZRnHjJ0wxz87zKhTOPt9CflYjZXjVN7L3A9vWuxGkN8my8nOE0QE/pB684gAdpQI0qbB
	FiEogB4MMHE15d5yf3ZcIS81EdtVhITqjVZq4MBFwlx+SAub1dEfA=
X-Gm-Gg: ASbGncvu+ubaI88nS02P9HXKT8Ln/97jXI7ve+/zxmkNJQ2fM3AtBmWg36E3OU2Heg4
	+h7OjZWCm1pTm9Pn+ickNwYf9SR6Xn0vsTZb6l817Jd/wwsD5m9iSw93uO1RFjc4r0aKPtNz0P5
	4RLlXX
X-Received: by 2002:a05:6102:390d:b0:4ec:285:72e1 with SMTP id ada2fe7eead31-4f541524062mr769447137.6.1752051368002;
        Wed, 09 Jul 2025 01:56:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDwp7S7fLTg7nuPSyJsRUvVU4owSqcs7YVGuW019isEpPCumT/5EbLYFFPVpBGMEgyvIr0jBioKiB/nj91j1E=
X-Received: by 2002:a05:6102:390d:b0:4ec:285:72e1 with SMTP id
 ada2fe7eead31-4f541524062mr769436137.6.1752051367207; Wed, 09 Jul 2025
 01:56:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250708192057.539725-1-slava@dubeyko.com>
In-Reply-To: <20250708192057.539725-1-slava@dubeyko.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Wed, 9 Jul 2025 11:55:56 +0300
X-Gm-Features: Ac12FXxDEPq9O9r15wiWz4SJsQdVoPLzsIFRFEX7z4Eyu-xR7Py417QLZsYShwc
Message-ID: <CAO8a2Shb+wRFiuGr5q2GWd3YGn-9kE61kUiogwbf_36e61_MPw@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: refactor wake_up_bit() pattern of calling
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, 
	linux-fsdevel@vger.kernel.org, pdonnell@redhat.com, Slava.Dubeyko@ibm.com, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good cleanup.

Reviewed-by: Alex Markuze amarkuze@redhat.com

On Tue, Jul 8, 2025 at 10:21=E2=80=AFPM Viacheslav Dubeyko <slava@dubeyko.c=
om> wrote:
>
> From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
>
> The wake_up_bit() is called in ceph_async_unlink_cb(),
> wake_async_create_waiters(), and ceph_finish_async_create().
> It makes sense to switch on clear_bit() function, because
> it makes the code much cleaner and easier to understand.
> More important rework is the adding of smp_mb__after_atomic()
> memory barrier after the bit modification and before
> wake_up_bit() call. It can prevent potential race condition
> of accessing the modified bit in other threads. Luckily,
> clear_and_wake_up_bit() already implements the required
> functionality pattern:
>
> static inline void clear_and_wake_up_bit(int bit, unsigned long *word)
> {
>         clear_bit_unlock(bit, word);
>         /* See wake_up_bit() for which memory barrier you need to use. */
>         smp_mb__after_atomic();
>         wake_up_bit(word, bit);
> }
>
> Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> ---
>  fs/ceph/dir.c  | 3 +--
>  fs/ceph/file.c | 6 ++----
>  2 files changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index a321aa6d0ed2..1535b6540e9d 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -1261,8 +1261,7 @@ static void ceph_async_unlink_cb(struct ceph_mds_cl=
ient *mdsc,
>         spin_unlock(&fsc->async_unlink_conflict_lock);
>
>         spin_lock(&dentry->d_lock);
> -       di->flags &=3D ~CEPH_DENTRY_ASYNC_UNLINK;
> -       wake_up_bit(&di->flags, CEPH_DENTRY_ASYNC_UNLINK_BIT);
> +       clear_and_wake_up_bit(CEPH_DENTRY_ASYNC_UNLINK_BIT, &di->flags);
>         spin_unlock(&dentry->d_lock);
>
>         synchronize_rcu();
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index a7254cab44cc..57451958624e 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -580,8 +580,7 @@ static void wake_async_create_waiters(struct inode *i=
node,
>
>         spin_lock(&ci->i_ceph_lock);
>         if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
> -               ci->i_ceph_flags &=3D ~CEPH_I_ASYNC_CREATE;
> -               wake_up_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT);
> +               clear_and_wake_up_bit(CEPH_ASYNC_CREATE_BIT, &ci->i_ceph_=
flags);
>
>                 if (ci->i_ceph_flags & CEPH_I_ASYNC_CHECK_CAPS) {
>                         ci->i_ceph_flags &=3D ~CEPH_I_ASYNC_CHECK_CAPS;
> @@ -765,8 +764,7 @@ static int ceph_finish_async_create(struct inode *dir=
, struct inode *inode,
>         }
>
>         spin_lock(&dentry->d_lock);
> -       di->flags &=3D ~CEPH_DENTRY_ASYNC_CREATE;
> -       wake_up_bit(&di->flags, CEPH_DENTRY_ASYNC_CREATE_BIT);
> +       clear_and_wake_up_bit(CEPH_DENTRY_ASYNC_CREATE_BIT, &di->flags);
>         spin_unlock(&dentry->d_lock);
>
>         return ret;
> --
> 2.49.0
>


