Return-Path: <ceph-devel+bounces-3508-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 84B2DB4181A
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Sep 2025 10:11:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C09BD3BF73A
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Sep 2025 08:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 740082E8896;
	Wed,  3 Sep 2025 08:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NXyHSDiG"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38C02E62C3
	for <ceph-devel@vger.kernel.org>; Wed,  3 Sep 2025 08:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756887096; cv=none; b=pTs1Zxk/aNWyVHr3mbyAecNmKRgLaz6ZfH8mLgMyrxhFD5BIcaTdexLN+wsycL1hAMGMEG+Zs5potBeJVYn2xOCmWwD929Eiq4lXYp21+vhY8AJzGj524eQLudZr6+CpgYPbEa6Wi8RImCS1Nm789ntkzaPEaY/Cjljdk0W2VrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756887096; c=relaxed/simple;
	bh=yPPFHPVGkTfhQqnYgocV38mjxCEjrrdjnK5uTBkj6f8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F5HfUdn0HQ3g7Kw2ZFjmhwzFlEM0I2dsRWfofjb5qbB9x+FNMTtyxYzFSc5RKis1Pq/NsR58rI/27xsqHZ+N7B9lS7JHVIbzgW/oXTEY93Vxvwj9wg0Wr7Qfyd9D5RQ/V1Rpwi5bardgx2nXNnMXH2dADIsgHGAlPYlE5Np0qV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NXyHSDiG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756887093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AWbrsDPZF5rw/2MySsWvOtVkJCl17t5vDebsQXLakRA=;
	b=NXyHSDiG2wFS1FpMfrbWBS/EB7K5MD32NcHkniVwJ1kO9MhaT1DVT1vaGfIM4dUyhZnPru
	m5+JeLhagPvEE/XimMtH6B9lAGlMvtjJvKhyceHzkuaeGeTqpcY4hIEps+58d1TwK5JCSG
	Av4smUpgUHqmw1Gkw1hZnsV5Bryi9ZI=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-pOJc5ieVPUiLQSnUy84rvQ-1; Wed, 03 Sep 2025 04:11:32 -0400
X-MC-Unique: pOJc5ieVPUiLQSnUy84rvQ-1
X-Mimecast-MFC-AGG-ID: pOJc5ieVPUiLQSnUy84rvQ_1756887091
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-53b1736edb9so6743487e0c.1
        for <ceph-devel@vger.kernel.org>; Wed, 03 Sep 2025 01:11:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756887091; x=1757491891;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AWbrsDPZF5rw/2MySsWvOtVkJCl17t5vDebsQXLakRA=;
        b=ncSkYa0wFrwS8JmNm8+oqC8A6T3XzPpq3K4gtpfm2p6Cx4rBxEeomiEShvnzpH8HZ5
         T4BGDn4ShAn84e91VkbtS43CBMlPoFUShg7NyA+5tiYK5S7Tx8ZzdOr0BPA4ACUX8vnY
         vc5W4IU0Bkd74cOmzF7MzwlF3i/CiQIEhxMGI2oDeWV5Q4y27XjxIeP80R4dyRo1CLbD
         lMjROGDk70eOp96k6SRJsIlqoZTwOT7zAJfwX/ttcrRXZtFLs7ahCoo3rA27OBF68qOL
         LIb9Imht78sMFiC8IFzYhPCBnzUzPzcX2QBcfpJuDYzZ8zYA3YgD5C1AkdVfUyXERKSo
         t57Q==
X-Gm-Message-State: AOJu0Yx0g6VfLm0pIKvwpQN3HATTwXxuNsBAskRC5qXMPo4yI/au+0Wg
	PZd8sFTah7FCgBe7Tc82mFR7cO9N35Kj1tS/Bax0z/0twbwE+d3aZAjJIFx5OzyTE41icKfiP3Y
	pg6sBAObJoE3vAOgaEUkGhNNZYxKBxv4iFRzDLf/bL4OGUcuD4j+ovsuXjuSLHO0dywPuD9XOrq
	EFUY1b02COp/+sfN6XEt2psiRjzB2ZLQ5Yw4JqQw==
X-Gm-Gg: ASbGncu+VekY9/P0SP0J9phl6qLghEZA2G3JK7fCpidylfRQHv++y/nIABKJxApdaoR
	iOMGPH11ruNSp9FeUPg5vDpVnmA6OdqtCQeoniDmWN0jZ0NUURUK+ffs2qAc/SXOppNMcb12PJB
	bVyid0VtZZRJIj6vbe2pe3CVJbZ7a0wQFE7sTKg/zW
X-Received: by 2002:a05:6102:2ace:b0:51f:66fc:53af with SMTP id ada2fe7eead31-52b1ca8bc34mr5404000137.34.1756887091466;
        Wed, 03 Sep 2025 01:11:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNvHtMHPVAafc4aTNTJCTpPkPmS0akJQxiG4M2z+jxVTI14cy7yMkFg6QtV2L/JKlMlIBUcv9RdqlgrQ6Z3lw=
X-Received: by 2002:a05:6102:2ace:b0:51f:66fc:53af with SMTP id
 ada2fe7eead31-52b1ca8bc34mr5403991137.34.1756887091163; Wed, 03 Sep 2025
 01:11:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250902190844.125833-2-slava@dubeyko.com>
In-Reply-To: <20250902190844.125833-2-slava@dubeyko.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Wed, 3 Sep 2025 11:11:20 +0300
X-Gm-Features: Ac12FXwqnTvEhufT7NqXho7_gzKmdz5V3KCi9PNhaAIIdUHVlfJLCJRKfS2xYLU
Message-ID: <CAO8a2SjMCTmwpSDRKE-_EuZt5AHn1gcH9CmZMn7V7ju4rt1sqQ@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: cleanup in ceph_alloc_readdir_reply_buffer()
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, 
	linux-fsdevel@vger.kernel.org, pdonnell@redhat.com, Slava.Dubeyko@ibm.com, 
	vdubeyko@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Alex Markuze <amarkuze@redhat.com>

On Tue, Sep 2, 2025 at 10:09=E2=80=AFPM Viacheslav Dubeyko <slava@dubeyko.c=
om> wrote:
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
> v2
> Alex Markuze suggested to add unlikely() macro
> for introduced condition checks.
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
> index 0f497c39ff82..992987801753 100644
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
> +       if (unlikely(bytes_count > ULONG_MAX))
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
> +       if (!rinfo->dir_entries || unlikely(order < 0))
>                 return -ENOMEM;
>
>         num_entries =3D (PAGE_SIZE << order) / size;
> --
> 2.51.0
>


