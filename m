Return-Path: <ceph-devel+bounces-3457-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6864AB27A05
	for <lists+ceph-devel@lfdr.de>; Fri, 15 Aug 2025 09:23:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6ACF1CC19A3
	for <lists+ceph-devel@lfdr.de>; Fri, 15 Aug 2025 07:24:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 993B82C21E3;
	Fri, 15 Aug 2025 07:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VekgzIcj"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E3E2C21C8
	for <ceph-devel@vger.kernel.org>; Fri, 15 Aug 2025 07:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755242613; cv=none; b=H+iQqdiGkHV4TAc0Ks+2czxghwtizx5RZGcmr/66rA3idkP+OfkNXbMXrSyUJZdl6O9xaSFmneNqT9ShidCL6nEhjTDgB1ilBWIRPxXIbO3xMraGSbSOYSkoTu5k/2SzalREp8CQNZyuWfJQI48NVBN5E/lJ3ZByreFNVDN9Q80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755242613; c=relaxed/simple;
	bh=ujBNpOKfYWZcb/8qUnJOmIycNz0tsY6banW0Hl+Wkww=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LVsWqXCKSM5MrSUnmpg8iHsUI7NIN1Seh3HZIytsZ3A3gTb3Cr36GeG7C2WVWLwrzXs3FlmSG2SoS8JLwngzwfJFZBWlkN5dR8p2yrWhB5ZXzYtOXktpbIUhx+aOU1rP1pWB3A2lorWvCJgoSfJ7DMiZja3wEpTDoZUEx4aC9/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VekgzIcj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755242610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/+rfPseL9xHEDQ2kpg3fsrFo9VadEuf37AWQ4NGG0Fc=;
	b=VekgzIcjP6J91kH2mbxaZK5CBD65aoJ3QSv9RpRHOiy15baWZ1vm18pULh4TjAJzZ5eppe
	XnqJQdPEzmC4rnoiDM7KAan9LYIKTgm7Kys59vVS0qAITGG1Th5coVR36KxDswwEqzy1v9
	nrKc76fZo13a7f76sVVa7N3J0P3dpw0=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-35sFZF51MBeCR36mkkVDyg-1; Fri, 15 Aug 2025 03:23:28 -0400
X-MC-Unique: 35sFZF51MBeCR36mkkVDyg-1
X-Mimecast-MFC-AGG-ID: 35sFZF51MBeCR36mkkVDyg_1755242608
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-890190c7894so1984878241.2
        for <ceph-devel@vger.kernel.org>; Fri, 15 Aug 2025 00:23:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755242608; x=1755847408;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/+rfPseL9xHEDQ2kpg3fsrFo9VadEuf37AWQ4NGG0Fc=;
        b=WFkvO7wUgciNJtIeKTdSNGfF61OEnr2a9yyR75xMm/wHo7LrE7HW5Q5D4yWKyhHwaO
         boqH/XRvs7yYbja7A9Vaq2rw7MbVewosSV6hlB4sfYHonpB8Crs9axlByuoIz9uqS7Dr
         A1fWwbF9XVsfs6kDRCcSZJOeFnVdTAUT1SkSNV6IXmd58/tytChwYLLNG5QA+7G0tqOG
         agx9p9hv28sxfeyX28gPQszq8Y9UPzfW61CiLGmLRle932YY9Mdvv6BFTSVp5Fi4RwUi
         34pPd4dUnDaHN9JFUei5EX8IGCqt0jyD1QCqJnrPd7pykr2H81QzP5eqdqXA+utHXp0s
         WLWA==
X-Gm-Message-State: AOJu0YwofsYzYZ7nNBYj+hu7m4Go/J3vzt5lT8v9z8NQ8AEaC+UBhRAr
	8bfBXAFyG/zFVWodA95zBxmDm6+3TPOU8WVZ17YyJve8HuItxKSAT+DP1POTvjiM+Gk2ysMA/iG
	eNk7AQwuk90AzFWMBtDcKePpkWW8yeecENA+K/9u+QsYfSYnK/uLxqPthQfwklX/d60B5Pv7A0d
	Hng/PLIT30Mr13+un92ECqW6qxUKuwPacz/0mE8w==
X-Gm-Gg: ASbGncs8Z5LtKn2XwntdRtr+jaTL/jSHf6O/OfohHuWJEn6fCYgHTw8zR9tN4h7IoT/
	aYV4gsJ8vlf/zoQTImj5TN37q9QbON4jmBO1qGiy9+lsQwEXFu565kkxeX3cm1K2hwTHNBhx3sT
	HMikkkFsqr5jlpMMWUx2/A
X-Received: by 2002:a05:6102:dc8:b0:4e6:f7e9:c4a5 with SMTP id ada2fe7eead31-5126d30d22emr241158137.22.1755242608039;
        Fri, 15 Aug 2025 00:23:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFA8H3p9x8GchzMfhpPWFUT2fxPCVsmHHhroNKsenYhovDmb2aFXZePL8Cz+ELVwRfatycacEAebkEKuMWWmgM=
X-Received: by 2002:a05:6102:dc8:b0:4e6:f7e9:c4a5 with SMTP id
 ada2fe7eead31-5126d30d22emr241154137.22.1755242607650; Fri, 15 Aug 2025
 00:23:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aJ7YmI6alo2Yg2wo@stanley.mountain>
In-Reply-To: <aJ7YmI6alo2Yg2wo@stanley.mountain>
From: Alex Markuze <amarkuze@redhat.com>
Date: Fri, 15 Aug 2025 11:23:16 +0400
X-Gm-Features: Ac12FXx13-MOZOS2yk6oztJ5d47hZDIUhhI60NjShuTQNP4H1-BRKN4kK6cku3U
Message-ID: <CAO8a2Sh4JL_6Oc1o8zLhsxP6gOXp-mxC3xoJw9xMnf6Xh_Kogg@mail.gmail.com>
Subject: Re: [bug report] ceph: fix race condition where r_parent becomes
 stale before sending message
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks, Dan. I'll send a fix.

On Fri, Aug 15, 2025 at 10:50=E2=80=AFAM Dan Carpenter <dan.carpenter@linar=
o.org> wrote:
>
> Hello Alex Markuze,
>
> Commit a69ac54928a4 ("ceph: fix race condition where r_parent becomes
> stale before sending message") from Aug 12, 2025 (linux-next), leads
> to the following Smatch static checker warning:
>
>         fs/ceph/inode.c:1591 ceph_fill_trace()
>         error: 'dir' dereferencing possible ERR_PTR()
>
> fs/ceph/inode.c
>     78  static struct inode *ceph_get_reply_dir(struct super_block *sb,
>     79                                          struct inode *parent,
>     80                                          struct ceph_mds_reply_inf=
o_parsed *rinfo)
>     81  {
>     82          struct ceph_vino vino;
>     83
>     84          if (unlikely(!rinfo->diri.in))
>     85                  return parent; /* nothing to compare against */
>     86
>     87          /* If we didn't have a cached parent inode to begin with,=
 just bail out. */
>     88          if (!parent)
>     89                  return NULL;
>                         ^^^^^^^^^^^^
> This returns NULL
>
>     90
>     91          vino.ino  =3D le64_to_cpu(rinfo->diri.in->ino);
>     92          vino.snap =3D le64_to_cpu(rinfo->diri.in->snapid);
>     93
>     94          if (likely(ceph_vino_matches_parent(parent, vino)))
>     95                  return parent; /* matches =E2=80=93 use the origi=
nal reference */
>     96
>     97          /* Mismatch =E2=80=93 this should be rare.  Emit a WARN a=
nd obtain the correct inode. */
>     98          WARN_ONCE(1, "ceph: reply dir mismatch (parent valid %llx=
.%llx reply %llx.%llx)\n",
>     99                    ceph_ino(parent), ceph_snap(parent), vino.ino, =
vino.snap);
>    100
>    101          return ceph_get_inode(sb, vino, NULL);
>                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> This returns error pointers, but the caller only checks for NULL.
>
>    102  }
>
> regards,
> dan carpenter
>


