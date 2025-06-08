Return-Path: <ceph-devel+bounces-3080-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48E61AD12D8
	for <lists+ceph-devel@lfdr.de>; Sun,  8 Jun 2025 17:06:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F7471683F2
	for <lists+ceph-devel@lfdr.de>; Sun,  8 Jun 2025 15:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7110224EAAB;
	Sun,  8 Jun 2025 15:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AiYWIozn"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBB124E014
	for <ceph-devel@vger.kernel.org>; Sun,  8 Jun 2025 15:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749395211; cv=none; b=k/dRj37mx77yvrfSlU99p6nXkuyBdcC8XU/6kvA7KCeohxi/xXHG0h5HylmfhPctm7tJ8+JURc+LLAzUQI34maZHug41IkrpX7ZnVdvsh1H+8LE4omlKyaHz9lolPL50RgaAWFV507OqWmhLC/KhcJZsYIf7PeWKfa8Z3AlN+Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749395211; c=relaxed/simple;
	bh=MITcrC3F5nd5i2+Vqe9MmqvGNbrT9JumcAsIUER5kzg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fj2RWVY0uHTqL1u2wVxoNFgNW1SAasnvVoX2Jj+YvFY60CyBXOSHkKV2td/k9+nrT/CdH88OXngjWbQ8FPebMuQY9eyyPxZDRLIPRsJXViGRmC60xHwrp444Gc6EXoaBd29LXS0SlFW/hizgV2oyOE/zc7j+cGlx4NtYlNbakvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AiYWIozn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749395208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=32hTUAw/xpZ+1jdocsdQHGZ/eU502h+xQ6g/nDhB37w=;
	b=AiYWIoznYT7WOvZUh4UJAbuClntS+A0fLPZcjctjUcAiB1svrcnI2xys8s63oEPz183xkX
	pFfphBAXxridP0jMzeHD+/6mKMwl0QSfzEfc2k01wPmZ6xumak9V5IIC/AcSeTI+DCAvmZ
	IoZGL3DO/DHNHeIttTZ5SfM8wRFWxeQ=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-278-ph7uGIKWNcKo9cFKZR2oQg-1; Sun, 08 Jun 2025 11:06:46 -0400
X-MC-Unique: ph7uGIKWNcKo9cFKZR2oQg-1
X-Mimecast-MFC-AGG-ID: ph7uGIKWNcKo9cFKZR2oQg_1749395206
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-4e45d9ce7f7so352054137.3
        for <ceph-devel@vger.kernel.org>; Sun, 08 Jun 2025 08:06:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749395206; x=1750000006;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=32hTUAw/xpZ+1jdocsdQHGZ/eU502h+xQ6g/nDhB37w=;
        b=jfZm/5ff/BxKwj1xxNaB5Of4ItUhVsOm9LO1j+yehwxjiUEmiwdgAQSVeC64SbVINP
         et8t1yo96ORwhZfeYo9uEw7De1qzImU/qhwBXRMZp3YbzpsWJEQ8rLzTSExgFSRiqRvn
         aUPp5xoYpup5ymcPe+j/WHeKCNYyMKEhbHU0vWTBaSyxfHFreZrK7DfmRGDjO3D5f1vT
         PbwQhDdGdIislc2nLnLpGM/LZGw9dpQ9njszaZl4U6C4EugpTgVwxPQb1FhyTpwDDvED
         si4K6Egw8qBogPtvHbOWG80X5pLkPf4e42WN6K2vsDVM3eKFQjBnCObxdl5XTtwIkzV6
         iD+A==
X-Gm-Message-State: AOJu0YzwBVtqzmhxRc6qoNuyE1Hk9e8ir+jpk9EkqPlZ7TSRwFdnd3y5
	spMKHru9Lv9/pYNlKGsju2K8Kh9GX9xYXDUAOz3jPNNsKNyY106DtQdVDR4tatiHdJImkS79KkW
	iOe7eX7bGycNTde8UkRQJWijoxPXWbbFO5AhZuxLybmgnMC0fZXh9mgvUmSCUMljt2njVg/Uh9q
	BVj8Q9fYbNzRSSkuMFoOrxL3YvrzM07VjKTvl3BA==
X-Gm-Gg: ASbGncs3EE/kiUyBMaixHxdckb/nR3WgBsUhjqcPhXk9eFt06aD4ouQcNNmyDYDYJyL
	ARax4OySuTXSrbyLYwMYbepoyBBoCkx4OZZSR9HoSILYVUaBHm7ae99nWfpgxnYXK86uOo9ZHhe
	eZv+A=
X-Received: by 2002:a05:6102:458a:b0:4e5:93f5:e834 with SMTP id ada2fe7eead31-4e772ade074mr9247919137.24.1749395206261;
        Sun, 08 Jun 2025 08:06:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmU7O5VbKAYIwDPSdC251qcnesmgsa6yOTiFhiI07/Aryqa52oyHAzSdbVa9G2kY63iGJJFwgpJIvbdxMoEH4=
X-Received: by 2002:a05:6102:458a:b0:4e5:93f5:e834 with SMTP id
 ada2fe7eead31-4e772ade074mr9247884137.24.1749395205956; Sun, 08 Jun 2025
 08:06:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250606190521.438216-1-slava@dubeyko.com>
In-Reply-To: <20250606190521.438216-1-slava@dubeyko.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Sun, 8 Jun 2025 18:06:35 +0300
X-Gm-Features: AX0GCFvciVRCAjxa1zpih-dLhNmd4RBOeZ4q6loeeFbMdgN2huyJ_qLoKl-Ggzk
Message-ID: <CAO8a2SgJd+hB-6f+6i1ViibR=UmHj=kX7c7mnOSO_vWQ4i4UaQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix wrong sizeof argument issue in register_session()
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, 
	linux-fsdevel@vger.kernel.org, pdonnell@redhat.com, Slava.Dubeyko@ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed by: Alex Markuze <amarkuze@redhat.com>

On Fri, Jun 6, 2025 at 10:05=E2=80=AFPM Viacheslav Dubeyko <slava@dubeyko.c=
om> wrote:
>
> From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
>
> The Coverity Scan service has detected the wrong sizeof
> argument in register_session() [1]. The CID 1598909 defect
> contains explanation: "The wrong sizeof value is used in
> an expression or as argument to a function. The result is
> an incorrect value that may cause unexpected program behaviors.
> In register_session: The sizeof operator is invoked on
> the wrong argument (CWE-569)".
>
> The patch introduces a ptr_size variable that is initialized
> by sizeof(struct ceph_mds_session *). And this variable is used
> instead of sizeof(void *) in the code.
>
> [1] https://scan5.scan.coverity.com/#/project-view/64304/10063?selectedIs=
sue=3D1598909
>
> Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> ---
>  fs/ceph/mds_client.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 230e0c3f341f..5181798643d7 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -979,14 +979,15 @@ static struct ceph_mds_session *register_session(st=
ruct ceph_mds_client *mdsc,
>         if (mds >=3D mdsc->max_sessions) {
>                 int newmax =3D 1 << get_count_order(mds + 1);
>                 struct ceph_mds_session **sa;
> +               size_t ptr_size =3D sizeof(struct ceph_mds_session *);
>
>                 doutc(cl, "realloc to %d\n", newmax);
> -               sa =3D kcalloc(newmax, sizeof(void *), GFP_NOFS);
> +               sa =3D kcalloc(newmax, ptr_size, GFP_NOFS);
>                 if (!sa)
>                         goto fail_realloc;
>                 if (mdsc->sessions) {
>                         memcpy(sa, mdsc->sessions,
> -                              mdsc->max_sessions * sizeof(void *));
> +                              mdsc->max_sessions * ptr_size);
>                         kfree(mdsc->sessions);
>                 }
>                 mdsc->sessions =3D sa;
> --
> 2.49.0
>


