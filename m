Return-Path: <ceph-devel+bounces-2343-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC9D59F2FD6
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Dec 2024 12:53:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5A0157A2D5D
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Dec 2024 11:53:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7808F204593;
	Mon, 16 Dec 2024 11:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZshBWIM6"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75209204595
	for <ceph-devel@vger.kernel.org>; Mon, 16 Dec 2024 11:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734349907; cv=none; b=GiA3pzrF5SycmRE8RBXrrT7V1F/JP5VFe3/Zn2oXqRVN+cIq61dI9g6lZhnuzzU4EQyq96faqdh07Qqc4FyqX8fB4TdTNECjejR0w3FZUe0VkMImwAfHot9f95UK6UUy1zqhLG8EASI2QszUSt695mvtBHPaFNUgnHnia6z7SOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734349907; c=relaxed/simple;
	bh=Yb8xemap43vrp8Jll3ugvIwH67YzG9iGIUqm2cpxdqc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HGZ3MvCC2pR6yRSwxpNg7Hko9OnuMaJKk89dWh6tTxE8Hq8omRqAiITvWnJOxTLrEbG+gqIbFyndSl9fmkaPeFEabt4zHxYXqaxLHXv5/fTWN6ynvOkdIXH9oTiW3z3V3wtbXw5RGhHBpNXWg+ykcYk2+5l3Iql2ziSyYmTkZ8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZshBWIM6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734349904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ngpuXi8fvLOINCWjENIs/MjP0R8Ooy0AzKXV9CUOuI4=;
	b=ZshBWIM6HxrnL6v3RFu+abozkpnGibiwqCuc2d+wLl5sdQAQb8hMjKA2sn42Zs/sghgf9B
	j8XoIJ6RNoH3+g/xlC2nONiJv7Z7aYw4vFLL2ywVVNsujAhrm77swqyysOQ8wnSS6LBrnV
	MXvKZtN4vrKSqgV/+hbkCzqcHAjrbic=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-235-jsEGx3rSMomPG7Hus2cLGg-1; Mon, 16 Dec 2024 06:51:43 -0500
X-MC-Unique: jsEGx3rSMomPG7Hus2cLGg-1
X-Mimecast-MFC-AGG-ID: jsEGx3rSMomPG7Hus2cLGg
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5d3cef3ed56so3600028a12.1
        for <ceph-devel@vger.kernel.org>; Mon, 16 Dec 2024 03:51:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734349902; x=1734954702;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ngpuXi8fvLOINCWjENIs/MjP0R8Ooy0AzKXV9CUOuI4=;
        b=KJ03kShjb+s7KcMUWBPhRJiZsqzi77RS3G6bVukPFULRNE1Ot/m4O5sSSDF29xoxx5
         6Rbyaqwp0YUXUGF+mpXr3ymK97DPhZH1cwqW3d1fVrqiGekMrcGf8HboR96RqyuCHrXe
         7SoPg7xtDXjbre+xYHq7A823m94DlbIA5CVtcgMFAYXcsRI4VVZotw/bK6vMocPqZzsq
         Dl5So8KoYu4QTE3IXLxR/mLNlsDU+pUopPzFOwhPjPcl5bis6I4aA2QmDflHkdqinTpe
         cDQDPfVaBJdNiqZfFBXZG60F1fRH1Rv5jGmJKftrt5OnWmU7MK/wwrRM99kLN8riqp/1
         6rJw==
X-Gm-Message-State: AOJu0YwTd0MtZEKWl2R3uu18ttzgDN9mK1Tgirt946pcytWV2IdZ53Ow
	Zi2F/EyGJTYTwqz9G2LLnY4kt7csNKh3CJnoh9dO03kDY+2KC8sSDW+Qz7mn/1bFRLJ4EOMTpsw
	TRZ8Jp/VlywX7sx8J4xaiheqRjH7Aq/xQtAYlOAuIyuGr/iEUnqJbgRVjSy9hX0bNOPaBY1noMi
	BwxBs4m/xyqve7YRNQtNSemBib99bRIStHnA==
X-Gm-Gg: ASbGncsMe7di/WLQzGBKhXfss9aV+4IBU8q5XLmV1/WpiYYlfnwni1kX6b/1DMypjYl
	TvWEVrSf9XD40HKU62+qh7EaGLMITLHU++K0=
X-Received: by 2002:a17:907:7211:b0:aa6:8ce6:1928 with SMTP id a640c23a62f3a-aab77e7b934mr1268255066b.48.1734349901936;
        Mon, 16 Dec 2024 03:51:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFTC6Lg3MlbPR/NW2epsqn/HAZNgjedYSecUMPq85WrPKHMYlGFOZhmHW56LyAe19fLYTVvDcl3cUa/BuNVPjg=
X-Received: by 2002:a17:907:7211:b0:aa6:8ce6:1928 with SMTP id
 a640c23a62f3a-aab77e7b934mr1268252666b.48.1734349901572; Mon, 16 Dec 2024
 03:51:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241207182622.97113-1-idryomov@gmail.com> <20241207182622.97113-3-idryomov@gmail.com>
In-Reply-To: <20241207182622.97113-3-idryomov@gmail.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Mon, 16 Dec 2024 13:51:30 +0200
Message-ID: <CAO8a2ShzME1BVUDorCxCKLjQHEHKGab1X000+4fPjD6ZjbCi1w@mail.gmail.com>
Subject: Re: [PATCH 2/2] ceph: allocate sparse_ext map only for sparse reads
To: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org, Max Kellermann <max.kellermann@ionos.com>, 
	Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Alex Markuze <amarkuze@redhat.com>

On Sat, Dec 7, 2024 at 8:26=E2=80=AFPM Ilya Dryomov <idryomov@gmail.com> wr=
ote:
>
> If mounted with sparseread option, ceph_direct_read_write() ends up
> making an unnecessarily allocation for O_DIRECT writes.
>
> Fixes: 03bc06c7b0bd ("ceph: add new mount option to enable sparse reads")
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  fs/ceph/file.c        | 2 +-
>  net/ceph/osd_client.c | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 0df2ffc69e92..f17bc4dc629c 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1558,7 +1558,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct i=
ov_iter *iter,
>                 }
>
>                 op =3D &req->r_ops[0];
> -               if (sparse) {
> +               if (!write && sparse) {
>                         extent_cnt =3D __ceph_sparse_read_ext_count(inode=
, size);
>                         ret =3D ceph_alloc_sparse_ext_map(op, extent_cnt)=
;
>                         if (ret) {
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 9b1168eb77ab..b24afec24138 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -1173,6 +1173,8 @@ EXPORT_SYMBOL(ceph_osdc_new_request);
>
>  int __ceph_alloc_sparse_ext_map(struct ceph_osd_req_op *op, int cnt)
>  {
> +       WARN_ON(op->op !=3D CEPH_OSD_OP_SPARSE_READ);
> +
>         op->extent.sparse_ext_cnt =3D cnt;
>         op->extent.sparse_ext =3D kmalloc_array(cnt,
>                                               sizeof(*op->extent.sparse_e=
xt),
> --
> 2.46.1
>


