Return-Path: <ceph-devel+bounces-3498-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E689B3EB01
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Sep 2025 17:40:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A264482086
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Sep 2025 15:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEF0F2FB625;
	Mon,  1 Sep 2025 15:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U2kPqApH"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E1C320A04
	for <ceph-devel@vger.kernel.org>; Mon,  1 Sep 2025 15:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756740648; cv=none; b=rDcF+RRWMKTJ+DX8e6FDTHXbDss3HG6oIbcJXXYM33jMA96cbG8bJYemqzWVGezlcz570xLM2Uc7c+kG0GcixAqkCinq5ZGH4zJMh+/vODtkaHGa5a7BnZ+/us10z4x8L2xI8XaSGYG2XARWCtqfwQsjNc5C3/BunaXrMtFvGH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756740648; c=relaxed/simple;
	bh=Re2eITSr7ZVkx0QHCPWi/VXYjH4F8wsmV4e9n/+XOIo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X56Efu2p6hobslrjGlBpqxFBOT7GODg339jeluc9mxBPk0X1rM76MjFy3OZHiOVC6isSj/HLKWDbV7DCvPOYgVzIcNRq2mKiUM2pJ6JKNAdbV05FKrBYO5mAURab/mm4jpam52LMjPRjxzIrODvHbGXf6APZY0tUpVd933Pxqa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U2kPqApH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756740645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tFVtiH5tJPj3x4omBecuNnUjGMgEywt57A5bHlfnCCc=;
	b=U2kPqApHgFvoMYf0i3WQwgNoyOTjiEyx9FurenC5X41IHhZTUpk0fyZD0UsliY7+EDwN22
	Ln7DPQ4OVeOd5wt5yj4tRjV4ak+jd77RQomAx8mO+fuewi47HcLcpakVXJfxF2Jxrx1kx1
	BvMz6Av+S4iF8C7b52ywgWCxH9vXpag=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-8xPhjfSEOH-OI6bYPxrr-g-1; Mon, 01 Sep 2025 11:30:42 -0400
X-MC-Unique: 8xPhjfSEOH-OI6bYPxrr-g-1
X-Mimecast-MFC-AGG-ID: 8xPhjfSEOH-OI6bYPxrr-g_1756740642
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-5448b533d2dso1177624e0c.3
        for <ceph-devel@vger.kernel.org>; Mon, 01 Sep 2025 08:30:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756740642; x=1757345442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tFVtiH5tJPj3x4omBecuNnUjGMgEywt57A5bHlfnCCc=;
        b=OPZYmLZzn0ik7mzLio3S9Yxo9GJyUfh8T3JSPwaUS3dmoEENB+URG6QfgLvSjFUFhB
         i8zWcNIwU3JdWMsJ8ZMB0eiFEdYFZc2MDForOQXBUylJY9VdbTilf7++oEjHpwlmAmQP
         fMa16XKPOKgzzWEnCC7ZcPKgF8sYjV/89kYvToiFUOTYRpE/SBmIzZfv+Tt6NP7ipqju
         iGJpzV4mr+UHth77pbOiUJr2AP3V6NZTjk2U13zndC/QygJdPK6DsEr5uqMPyyTVISk0
         iUApzUBtLnPec43N7YD69N1fBfDthUCRSe1TdN+XMAd/R3RA0NZ1BFnpEW+j/kRQ8HsP
         0Rlg==
X-Gm-Message-State: AOJu0YwE6Mscr3hN/50rCLZ5R2BZNUi8tibQsDc40K2oagd37J/TaMzu
	/roRB8WA83c0OcI5QKB+oasEOPTXTb84vn9bKiE8rvXiwSvLvgMxty654MewxLorLpyhUeb5IBl
	QleIDaaHZK/Iz2uQtZezYctjWkrfDxxrhwzWFZaq4uyj7Hi2eTE7Qrwcq8UzrPJwKQVewOylG4A
	BoRFCM6Fw6sViCRn6V0sn9mveZg9+hslJMdk8wmA==
X-Gm-Gg: ASbGncs+Lcdp4lAdMxH5g6BhieLRytdb9MlNKRiAXVVOk2NL6kutBKvhmnienhcy6zm
	ruto0JcBYG5kaxgy5vRvPGIlNNEIA6yQop6D4TVXvhmE0QoxqnlPfPsoef6/mEUFAfpWyB7/n3O
	7GFzeQ49cMVU9UlwCzZcFbng==
X-Received: by 2002:a05:6122:218d:b0:539:27eb:ca76 with SMTP id 71dfb90a1353d-544a01a030emr1953139e0c.5.1756740641827;
        Mon, 01 Sep 2025 08:30:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2obOmrFflqm4DjIkjGd3v1u5gJQ0yXbv+gIeZxPne66lD8cx7UQKZmQL0+dzVb84ZuEXfutjbQEC52niJcQE=
X-Received: by 2002:a05:6122:218d:b0:539:27eb:ca76 with SMTP id
 71dfb90a1353d-544a01a030emr1953133e0c.5.1756740641224; Mon, 01 Sep 2025
 08:30:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250829212859.93312-2-slava@dubeyko.com>
In-Reply-To: <20250829212859.93312-2-slava@dubeyko.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Mon, 1 Sep 2025 18:30:30 +0300
X-Gm-Features: Ac12FXzU7CJ6W_mQ5dHq10kMM003vyr--0dm2Rrx_KueJd3Zczk4CqNiInK04gs
Message-ID: <CAO8a2ShN_=0dkgfWcRB3=q+C9o2hBONCQS1Os4ubG-NhsBhJ1w@mail.gmail.com>
Subject: Re: [PATCH] ceph: cleanup in ceph_alloc_readdir_reply_buffer()
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, 
	linux-fsdevel@vger.kernel.org, pdonnell@redhat.com, Slava.Dubeyko@ibm.com, 
	vdubeyko@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Lets add unlikely to these checks.

On Sat, Aug 30, 2025 at 12:29=E2=80=AFAM Viacheslav Dubeyko <slava@dubeyko.=
com> wrote:
>
> From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
>
> The Coverity Scan service has reported potential issue
> in ceph_alloc_readdir_reply_buffer() [1]. If order could
> be negative one, then it expects the issue in the logic:
>
> num_entries =3D (PAGE_SIZE << order) / size;
>
> Technically speaking, this logic [2] should prevent from
> making the order variable negative:
>
> if (!rinfo->dir_entries)
>     return -ENOMEM;
>
> However, the allocation logic requires some cleanup.
> This patch makes sure that calculated bytes count
> will never exceed ULONG_MAX before get_order()
> calculation. And it adds the checking of order
> variable on negative value to guarantee that second
> half of the function's code will never operate by
> negative value of order variable even if something
> will be wrong or to be changed in the first half of
> the function's logic.
>
> [1] https://scan5.scan.coverity.com/#/project-view/64304/10063?selectedIs=
sue=3D1198252
> [2] https://elixir.bootlin.com/linux/v6.17-rc3/source/fs/ceph/mds_client.=
c#L2553
>
> Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> cc: Alex Markuze <amarkuze@redhat.com>
> cc: Ilya Dryomov <idryomov@gmail.com>
> cc: Ceph Development <ceph-devel@vger.kernel.org>
> ---
>  fs/ceph/mds_client.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 0f497c39ff82..d783326d6183 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2532,6 +2532,7 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds=
_request *req,
>         struct ceph_mount_options *opt =3D req->r_mdsc->fsc->mount_option=
s;
>         size_t size =3D sizeof(struct ceph_mds_reply_dir_entry);
>         unsigned int num_entries;
> +       u64 bytes_count;
>         int order;
>
>         spin_lock(&ci->i_ceph_lock);
> @@ -2540,7 +2541,11 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_md=
s_request *req,
>         num_entries =3D max(num_entries, 1U);
>         num_entries =3D min(num_entries, opt->max_readdir);
>
> -       order =3D get_order(size * num_entries);
> +       bytes_count =3D (u64)size * num_entries;
> +       if (bytes_count > ULONG_MAX)
> +               bytes_count =3D ULONG_MAX;
> +
> +       order =3D get_order((unsigned long)bytes_count);
>         while (order >=3D 0) {
>                 rinfo->dir_entries =3D (void*)__get_free_pages(GFP_KERNEL=
 |
>                                                              __GFP_NOWARN=
 |
> @@ -2550,7 +2555,7 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds=
_request *req,
>                         break;
>                 order--;
>         }
> -       if (!rinfo->dir_entries)
> +       if (!rinfo->dir_entries || order < 0)
>                 return -ENOMEM;
>
>         num_entries =3D (PAGE_SIZE << order) / size;
> --
> 2.51.0
>


