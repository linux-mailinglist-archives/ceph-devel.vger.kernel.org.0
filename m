Return-Path: <ceph-devel+bounces-3067-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D00E7ACC446
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Jun 2025 12:25:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87ABD3A3904
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Jun 2025 10:24:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 823C51A9B39;
	Tue,  3 Jun 2025 10:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zwovo1Yb"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667754A35
	for <ceph-devel@vger.kernel.org>; Tue,  3 Jun 2025 10:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748946317; cv=none; b=nUAhMDyo8ehFxtooL1/b37MRSUmM8FaxXry9usOTzxcxrGEtZ3ngzgXpQd2uqfsPfgkABPgWuygjOvMryefUHb0XxA79jhFqk0+7qsg7xs7szjPjTQBo1MvUEBV1QldbxUEOBLImKF6nExU/P9YSOJSdkmKjcbVVR3lKAjqT/oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748946317; c=relaxed/simple;
	bh=drpbWQc8/RPHHtUSS98p2acdiM3zdIzIfLg/W6cC+U8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ucqSQ7FoGtInre26uQx8m7vJMDpoLzPKGUybwkYaVuFQBGvdWF0YLuVyVJl460mLbAKg3Cv7hiIxANjYxAX1oRzXT6XdyT8eIKEEVAmimfq+agctyryDrXTQ9ouxDd8Lt3ng8MpEv0qJKNGL6XRLKGBwLc8pwWB1j414p4jO0cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zwovo1Yb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748946314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9PoBry0tKpbA2i7zoepvlEvbKF+ynCdobMnd4RArtEk=;
	b=Zwovo1YbwKp7kKX6HXivd+GuNU+edhh1r6JLd4sr4s/Om1g8wcv6C+YLexidfuQHPy+4E2
	22GmNiHA05SNr4j3Vqx3Tdqd8h8vdyuJkcRNEVMFHzVt/+WNVatHcQ13i6rbMPMNwRhIiM
	FfEzn7xNjFwjGD9gFmcn6dpWVraLTMI=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-446-g2SdRUNMOk-fxriZTqDg5w-1; Tue, 03 Jun 2025 06:25:13 -0400
X-MC-Unique: g2SdRUNMOk-fxriZTqDg5w-1
X-Mimecast-MFC-AGG-ID: g2SdRUNMOk-fxriZTqDg5w_1748946312
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-52a6d60e21cso5090484e0c.2
        for <ceph-devel@vger.kernel.org>; Tue, 03 Jun 2025 03:25:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748946312; x=1749551112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9PoBry0tKpbA2i7zoepvlEvbKF+ynCdobMnd4RArtEk=;
        b=rtRH0IVCax4h6TB/DF/+m6CeDw3iFPFiwgPEVeQc7H3wJFQS5hMOmuXOXmRMEY+ST8
         JlZUKgxXgSLrcxRuNUoxfgWNBcmGwe78XOchv22XbCHbBFXJjnahXiGMsosozJkotxJq
         g/jIDjYReAJW6jNd2Z5A4SsrIeG4S+IJolIVN1ou28jkFBCW7hKuDhQFwFh8HRXuX8xi
         UV3sAzWQ/W56HEMCQWQ3EDZIt/wbeJMGjo2ODv7XwXbyHe9DLYH7DuECtj7yjYBTXRqQ
         JqoCoXMemkjeP3tZm3gZzTy3cDDFbEWIP0n5AjvwhR0Ywf7Hqtbvd1ROaRf2Nm3pY4rR
         pIWw==
X-Gm-Message-State: AOJu0Yzc3asZpoeotGTGb0tybKw9dYKa+hL3BTDjvU3jb5qsmFE972Q+
	PlP9Zksj4ccphE37vqrTu2En72kmGzmHXaedFMseHpKQqJCFsvPJKgGgfKC2dNg6/0GodZ145x+
	2gECy/mNXN/X3uvgg4MPMbN8I2JpWGTLzmb0zrO5NSzfx18TORLzRPlrRsRXYRvBSLFR5/822QM
	NiUMraeWjiYJ5B5vvg1dCMhA++GBjpEtKSUoUFBA==
X-Gm-Gg: ASbGncsFv3+4AySFSd5FehGA6Zk87wp0XXZ5zEmUiJX7hGOZs+uUT2TYYYLEQgUx1T4
	e0vc2+MMtgLSZMfzZgvPAwT6zKq5h/XM0ie36TI4eicq6Kr2mScccspkUH8ytadbZUFAmsfL/3B
	qdFsU=
X-Received: by 2002:a05:6122:4690:b0:530:6955:1889 with SMTP id 71dfb90a1353d-53080f5835dmr11925967e0c.1.1748946312463;
        Tue, 03 Jun 2025 03:25:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHaLv0Rul5zPwMMYP003yCD4PaDa+gcYWoZJEoc4T6DEUUELWsEYqO3OHENHlzdNx3AqF9p1NXtCgJpkZbpTuY=
X-Received: by 2002:a05:6122:4690:b0:530:6955:1889 with SMTP id
 71dfb90a1353d-53080f5835dmr11925955e0c.1.1748946312191; Tue, 03 Jun 2025
 03:25:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250602184956.58865-1-slava@dubeyko.com>
In-Reply-To: <20250602184956.58865-1-slava@dubeyko.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Tue, 3 Jun 2025 13:25:01 +0300
X-Gm-Features: AX0GCFu6ADoH-z_8jt1npgvjofdMj1rp6enEYpkeg1J0sV8yE530VuLqHJR_oMw
Message-ID: <CAO8a2SgsAQzOGCtejSka0JnvuzoespHDvwa0WNpg4A9L5QJcVA@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix variable dereferenced before check in ceph_umount_begin()
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, dan.carpenter@linaro.org, 
	lkp@intel.com, dhowells@redhat.com, brauner@kernel.org, willy@infradead.org, 
	linux-fsdevel@vger.kernel.org, pdonnell@redhat.com, Slava.Dubeyko@ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed by: Alex Markuze <amarkuze@redhat.com>

On Mon, Jun 2, 2025 at 9:50=E2=80=AFPM Viacheslav Dubeyko <slava@dubeyko.co=
m> wrote:
>
> From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
>
> smatch warnings:
> fs/ceph/super.c:1042 ceph_umount_begin() warn: variable dereferenced befo=
re check 'fsc' (see line 1041)
>
> vim +/fsc +1042 fs/ceph/super.c
>
> void ceph_umount_begin(struct super_block *sb)
> {
>         struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(sb);
>
>         doutc(fsc->client, "starting forced umount\n");
>               ^^^^^^^^^^^
> Dereferenced
>
>         if (!fsc)
>             ^^^^
> Checked too late.
>
>                 return;
>         fsc->mount_state =3D CEPH_MOUNT_SHUTDOWN;
>         __ceph_umount_begin(fsc);
> }
>
> The VFS guarantees that the superblock is still
> alive when it calls into ceph via ->umount_begin().
> Finally, we don't need to check the fsc and
> it should be valid. This patch simply removes
> the fsc check.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.kerne=
l.org_r_202503280852.YDB3pxUY-2Dlkp-40intel.com_&d=3DDwIBAg&c=3DBSDicqBQBDj=
DI9RkVyTcHQ&r=3Dq5bIm4AXMzc8NJu1_RGmnQ2fMWKq4Y4RAkElvUgSs00&m=3DUd7uNdqBY_Z=
7LJ_oI4fwdhvxOYt_5Q58tpkMQgDWhV3199_TCnINFU28Esc0BaAH&s=3DQOKWZ9HKLyd6XCxW-=
AUoKiFFg9roId6LOM01202zAk0&e=3D
> Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> ---
>  fs/ceph/super.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index f3951253e393..68a6d434093f 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1033,8 +1033,7 @@ void ceph_umount_begin(struct super_block *sb)
>         struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(sb);
>
>         doutc(fsc->client, "starting forced umount\n");
> -       if (!fsc)
> -               return;
> +
>         fsc->mount_state =3D CEPH_MOUNT_SHUTDOWN;
>         __ceph_umount_begin(fsc);
>  }
> --
> 2.49.0
>


