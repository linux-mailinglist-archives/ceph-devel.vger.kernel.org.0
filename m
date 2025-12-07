Return-Path: <ceph-devel+bounces-4164-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A8B0DCAB80A
	for <lists+ceph-devel@lfdr.de>; Sun, 07 Dec 2025 18:02:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 77A68301E938
	for <lists+ceph-devel@lfdr.de>; Sun,  7 Dec 2025 17:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C43C0246BD5;
	Sun,  7 Dec 2025 17:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kF7Xa7GU"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690511A840A
	for <ceph-devel@vger.kernel.org>; Sun,  7 Dec 2025 17:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765126949; cv=none; b=bq+gWhvYnIsQ0VWWSNOUUKAEZJmsA/tIYzISX5XytgSI6DhODZkQMjWviHV1mEETakVnsjY+3BdNckC15Lx+hCSxOdQYCOStYUVWQsmEnhxRRIIcGawioen9BkP0iPbSxen7+nvUbe+qP6jVu+UBhzMQ6kB1cPOypH8a9d8WMGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765126949; c=relaxed/simple;
	bh=q+iJJXZXofdDxTT3F6VKU4IHB/OFqTjXvn7NU3MackY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X42YzwSPPr3ECBsWqRVrFwEpY/1+q38vMNiwF2LdUYkItpup73o/CFz0DEsYWsu1fVoyHC+VzCe8EKcT/OIzJ7AiYL8GPaS7LxEe6WboXSL6sTHhxPId7edg/YXrcsyMisXmjHLH/yHG+2wCk/M+fY5Wug7WbLAYhSynmwCLpvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kF7Xa7GU; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7b22ffa2a88so3830203b3a.1
        for <ceph-devel@vger.kernel.org>; Sun, 07 Dec 2025 09:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765126947; x=1765731747; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mXmxu9JUPtLkDzsajDsLtuCJsGzo35pEE1RhmwAUM9M=;
        b=kF7Xa7GUpx5sVqaKGIMm0CjuY0s99QPBo/WQFC8iaYBIBRfxWiSHzpIifRH66LX1SI
         RjuJxyv3G9DXSA2fwSmV3HLKBOd6fbtSF/gPvTOKxcItsJa5YesEgM3Rxo/lPwWkGxmy
         ypKbaQMNEstADp5vdzahhHcs5/+Rl71E8+uHtz2C2MZcZwINq5FF+XiSnfL6XYLYkJA+
         haMoz/3Vts/uJrRWH8jeVNr8LsA2x+SWQyoCHOjEJshJWeRHvacid5X113q76GfkgfNV
         nTb3d7bmr1aEq4cZeTwyqrNEJJYL9Nopm60V281lKAwD8am0YxbNTS4DxnbXnLKLG7PN
         o8uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765126947; x=1765731747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mXmxu9JUPtLkDzsajDsLtuCJsGzo35pEE1RhmwAUM9M=;
        b=ODC4Hkeex3H1Jrl6Qo7a5Va/UTws7DHlqSxqBhyhrWA6maBbe0yK5VnuKiJMc6f+i7
         W2WDQAE1OwbVSVz55bc5KF88yob9B2e/zW68xhAa+MFxAOXulKam3Y/vgy0Ah/hcwFVP
         25N/ZcXBV/m5XZk5JpCwnoW7+R3WA2vFlIzffCrl22SYLMoSL0++lw/o19SJ5brjFqEH
         51qpekoes7YtBNX8tSCg6qm8I7MCFRLihw4JWZKPbgFk0ROK/E7CCYxPQzu1xS0QIaVc
         afMJDFjozgjebhd3eGEGq0QHzOjHwKJhmJWXSp1PXa9vEdf8zDt7JQgsNeu03/9yVcxv
         tHCw==
X-Forwarded-Encrypted: i=1; AJvYcCUkKRGgzPNT+XDriCw7lhLysAO40q/iiDjeshwEeLoNkK4u3zo28mqYn+AVJuPUYkEguDU+ytDAX4lS@vger.kernel.org
X-Gm-Message-State: AOJu0YxtROK0pk+Cy+2VmSPnjC5zv7B9wxI/u99qjAaVrMRUVQ+UgeHz
	SfOBonnQ3d7bN/+FFKRvyJsxS5QFNLC3ejxQ8dDqMYa9BhNSzG/RP2Xb/nX35EW1Ax+Qnhho5zj
	x8HcBGutuWn/8+LEMUxx6y0oRh8MCoqs=
X-Gm-Gg: ASbGncty0dU7YyXmPsjmLhKCmZqyQWAYfmEZ8AmRAOKTeiMY6833BjBrLynKlMUrkHN
	PW/NSotWBCSENlZqb9GBqrCufM5Cr1U6dm0c/vLUeqGrQaHNTj8Zk8ncjHOz6QprRE/uVAn72ZY
	dqlckhkWR0XLaLs+hoCM7ocaGcMMVEx/L31nxpzLqRK4p84QJIcJNmYgOfu2QZOoQAiyR2v/Tpe
	vUNly2aoZf60akhlCC9dsZpbuqLN3U9jms9uSviaeEEIdIZ2OUwKilqUGFFbnmxomRAhjM=
X-Google-Smtp-Source: AGHT+IHHOYrLIs5p7sJptyjdXIn7V8FiSzrl/VMdndFmlUYo6hQdpIvxEduW1xN+3E62qJiDSX8hlTyzcvwP/903nx4=
X-Received: by 2002:a05:7022:3f08:b0:119:e569:f260 with SMTP id
 a92af1059eb24-11e0315fa68mr3707906c88.9.1765126946550; Sun, 07 Dec 2025
 09:02:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251206072948.194501-1-lihaoxiang@isrc.iscas.ac.cn>
In-Reply-To: <20251206072948.194501-1-lihaoxiang@isrc.iscas.ac.cn>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Sun, 7 Dec 2025 18:02:14 +0100
X-Gm-Features: AQt7F2rGPt3cdzDjetYLwWkTp-pLh8sVU6mEhDkVPBBaBxQ3UPayiKC-UabD8Yk
Message-ID: <CAOi1vP8X+aQXPMHYE6J=GvmE4_EiM8r6fb_Fx0Lw=-9XPKhvGQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: Drop the string reference in __ceph_pool_perm_get()
To: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Cc: xiubli@redhat.com, zyan@redhat.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 6, 2025 at 8:29=E2=80=AFAM Haoxiang Li <lihaoxiang@isrc.iscas.a=
c.cn> wrote:
>
> After calling ceph_get_string(), ceph_put_string() is required
> to drop the reference in error paths.

Hi Haoxiang,

I think the reference is moved to the OSD request (i.e. rd_req).  It's
dropped when the OSD request is destroyed in ceph_osdc_release_request()
via target_destroy() and ceph_oloc_destroy().  Do you see evidence of
the opposite?

Thanks,

                Ilya

>
> Fixes: 779fe0fb8e18 ("ceph: rados pool namespace support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
> ---
>  fs/ceph/addr.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 322ed268f14a..690a54b4c316 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -2440,13 +2440,13 @@ static int __ceph_pool_perm_get(struct ceph_inode=
_info *ci,
>
>         err =3D ceph_osdc_alloc_messages(rd_req, GFP_NOFS);
>         if (err)
> -               goto out_unlock;
> +               goto put_string;
>
>         wr_req =3D ceph_osdc_alloc_request(&fsc->client->osdc, NULL,
>                                          1, false, GFP_NOFS);
>         if (!wr_req) {
>                 err =3D -ENOMEM;
> -               goto out_unlock;
> +               goto put_string;
>         }
>
>         wr_req->r_flags =3D CEPH_OSD_FLAG_WRITE;
> @@ -2456,13 +2456,13 @@ static int __ceph_pool_perm_get(struct ceph_inode=
_info *ci,
>
>         err =3D ceph_osdc_alloc_messages(wr_req, GFP_NOFS);
>         if (err)
> -               goto out_unlock;
> +               goto put_string;
>
>         /* one page should be large enough for STAT data */
>         pages =3D ceph_alloc_page_vector(1, GFP_KERNEL);
>         if (IS_ERR(pages)) {
>                 err =3D PTR_ERR(pages);
> -               goto out_unlock;
> +               goto put_string;
>         }
>
>         osd_req_op_raw_data_in_pages(rd_req, 0, pages, PAGE_SIZE,
> @@ -2480,7 +2480,7 @@ static int __ceph_pool_perm_get(struct ceph_inode_i=
nfo *ci,
>         else if (err !=3D -EPERM) {
>                 if (err =3D=3D -EBLOCKLISTED)
>                         fsc->blocklisted =3D true;
> -               goto out_unlock;
> +               goto put_string;
>         }
>
>         if (err2 =3D=3D 0 || err2 =3D=3D -EEXIST)
> @@ -2489,14 +2489,14 @@ static int __ceph_pool_perm_get(struct ceph_inode=
_info *ci,
>                 if (err2 =3D=3D -EBLOCKLISTED)
>                         fsc->blocklisted =3D true;
>                 err =3D err2;
> -               goto out_unlock;
> +               goto put_string;
>         }
>
>         pool_ns_len =3D pool_ns ? pool_ns->len : 0;
>         perm =3D kmalloc(struct_size(perm, pool_ns, pool_ns_len + 1), GFP=
_NOFS);
>         if (!perm) {
>                 err =3D -ENOMEM;
> -               goto out_unlock;
> +               goto put_string;
>         }
>
>         perm->pool =3D pool;
> @@ -2509,6 +2509,8 @@ static int __ceph_pool_perm_get(struct ceph_inode_i=
nfo *ci,
>         rb_link_node(&perm->node, parent, p);
>         rb_insert_color(&perm->node, &mdsc->pool_perm_tree);
>         err =3D 0;
> +put_string:
> +       ceph_put_string(rd_req->r_base_oloc.pool_ns);
>  out_unlock:
>         up_write(&mdsc->pool_perm_rwsem);
>
> --
> 2.25.1
>

