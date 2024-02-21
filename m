Return-Path: <ceph-devel+bounces-888-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 57D9985CED0
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Feb 2024 04:35:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B842A284F9B
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Feb 2024 03:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8E7236120;
	Wed, 21 Feb 2024 03:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cuFmdtba"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C608838FB2
	for <ceph-devel@vger.kernel.org>; Wed, 21 Feb 2024 03:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708486511; cv=none; b=u+6zAuxLgWKvfMF5p0XaNd+yMipNSmGOI6rl5KGXu6z2Kbq2aaYSzsSKMkwUjFm3hE6Iba11WFYENb4U8a4MHgkXdOUBLWpJvVUyUNb7RhZ7NCeimlIfGcANugE+c5RodMWN8QMA3GVhJ9GaRCFaNpi+uK5pl54G3d5lCV9R/LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708486511; c=relaxed/simple;
	bh=5BziNW8USmPGLvxnyXU9KX1OyZcSbEQaVDi2Up8/CPo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pgp8zyv6aWNIMCWDAzzRDqjSYMDLFFGEauvGovm4e2SqCTs1wbPp727cXbhEo+19W4NYj2C8gSPE9S0JOd47YlyeX2g584zrcJVf+NbLWdHyoJ60ZTqJU85V3ES2ZkZ5+DrMD831lXBVgsA6xXBX7Jx1BGho9Yyq3jhN6sA/KEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cuFmdtba; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708486508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=epCW2Ek0UaTCw4FoBCG5DLW0EkybU6amAkaJ2Ltn0wk=;
	b=cuFmdtba8ldcID95a46FeX0O72dJwJQshETmRtTVgjppSncrAr3QFfB9GHb0rywjdzWyYN
	asA5+19oYXV4NhW85GUKh6JyauCQB7G5PwrTsdPoCGCtaaUiTPByIDJamG0+n7W/JxknaK
	AjoocBgpBpRvC2Uhw/ELTNIMN+Pido0=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-33-kdLAIUkDPmyBQ4rVo645Hw-1; Tue, 20 Feb 2024 22:34:59 -0500
X-MC-Unique: kdLAIUkDPmyBQ4rVo645Hw-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-42dbfd1fe8cso2839611cf.1
        for <ceph-devel@vger.kernel.org>; Tue, 20 Feb 2024 19:34:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708486499; x=1709091299;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=epCW2Ek0UaTCw4FoBCG5DLW0EkybU6amAkaJ2Ltn0wk=;
        b=Xx0MfLS5eJc2OvCOCMWlN8iTWwJ46BGRVNmTsjf1eoTdqUfnXfG6kCYlnEa4wRotih
         ca9lFTzhEn1hPxiPFnr5WcRhKASBTCFtKv7lhywMeNYroJ+SgOPxxd++XwyxxCeiQxbp
         LXxhOWL25dSkMv9E9IKjEBjy8cnGE3g3BPVdT1RDxsIAV+tGQVgwCYduhSsOBvs4rjW4
         TeElw04H+x8F4xpvGzpl4dZKexBQRmOFJWJJueOjfWqooHQ03H7KJFCWnZwWU50vnqYJ
         E58zTdhfbj+8JTloojWkE4rgXDQcU6QR8DQumKFZ/vZipx4YdkORjVkw+YuTxX1SWI8K
         afkA==
X-Gm-Message-State: AOJu0YwO4aqI18QEWckHonYbN+KZbbRBGNtrD8tb1wlRc7rldi2t0edA
	2IaJfgLXHXkzHK2SxEQrswAZmg1c7Qild3RqATbo+NK8MnJi5fL5rFQ8AC/rUIi60hYaYXhgFtx
	BpecN50jB5bKUq5tG8ITMj1RtfndgTnVdOPn5x/UpvwWWvSdFyc6YIb8brzkMh9FTW8JogZ1Gx0
	JRNhuJm3OpDaHMNbhIvTW64F1z5TwkE738bA==
X-Received: by 2002:ac8:5c4d:0:b0:42e:b1b:22c9 with SMTP id j13-20020ac85c4d000000b0042e0b1b22c9mr10423526qtj.5.1708486499166;
        Tue, 20 Feb 2024 19:34:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE5hNQTs1ccnymUn/EtS16BAaUfKsm7dQG6NySUIWwA/QdPYzimfjisLP22OVV+2/8jcYDUka7dd1vIPpkkKYc=
X-Received: by 2002:ac8:5c4d:0:b0:42e:b1b:22c9 with SMTP id
 j13-20020ac85c4d000000b0042e0b1b22c9mr10423514qtj.5.1708486498943; Tue, 20
 Feb 2024 19:34:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240221031052.68959-1-xiubli@redhat.com>
In-Reply-To: <20240221031052.68959-1-xiubli@redhat.com>
From: Patrick Donnelly <pdonnell@redhat.com>
Date: Tue, 20 Feb 2024 22:34:33 -0500
Message-ID: <CA+2bHPb-rTz3Ajk3VFkp1_vycTjjH2hP3dtD668PVbnr-ErLyw@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: reverse MDSMap dencoding of max_xattr_size/bal_rank_mask
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, jlayton@kernel.org, 
	vshankar@redhat.com, mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 20, 2024 at 10:13=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> Ceph added the bal_rank_mask with encoded (ev) version 17.  This
> was merged into main Oct 2022 and made it into the reef release
> normally. While a latter commit added the max_xattr_size also
> with encoded (ev) version 17 but places it before bal_rank_mask.
>
> And this will breaks some usages, for example when upgrading old
> cephs to newer versions.
>
> URL: https://tracker.ceph.com/issues/64440
> Reported-by: Patrick Donnelly <pdonnell@redhat.com>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V2:
> - minor fix in the comment
>
>
>
>
>
>  fs/ceph/mdsmap.c | 7 ++++---
>  fs/ceph/mdsmap.h | 6 +++++-
>  2 files changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index fae97c25ce58..8109aba66e02 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -380,10 +380,11 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_=
mds_client *mdsc, void **p,
>                 ceph_decode_skip_8(p, end, bad_ext);
>                 /* required_client_features */
>                 ceph_decode_skip_set(p, end, 64, bad_ext);
> +               /* bal_rank_mask */
> +               ceph_decode_skip_string(p, end, bad_ext);
> +       }
> +       if (mdsmap_ev >=3D 18) {
>                 ceph_decode_64_safe(p, end, m->m_max_xattr_size, bad_ext)=
;
> -       } else {
> -               /* This forces the usage of the (sync) SETXATTR Op */
> -               m->m_max_xattr_size =3D 0;
>         }
>  bad_ext:
>         doutc(cl, "m_enabled: %d, m_damaged: %d, m_num_laggy: %d\n",
> diff --git a/fs/ceph/mdsmap.h b/fs/ceph/mdsmap.h
> index 89f1931f1ba6..43337e9ed539 100644
> --- a/fs/ceph/mdsmap.h
> +++ b/fs/ceph/mdsmap.h
> @@ -27,7 +27,11 @@ struct ceph_mdsmap {
>         u32 m_session_timeout;          /* seconds */
>         u32 m_session_autoclose;        /* seconds */
>         u64 m_max_file_size;
> -       u64 m_max_xattr_size;           /* maximum size for xattrs blob *=
/
> +       /*
> +        * maximum size for xattrs blob.
> +        * Setting it to 0 will force the usage of the (sync) SETXATTR Op=
.

Minor nit, I would reword as: "Zeroed by default to force the usage of
the (sync) SETXATTR Op."

Reviewed-by: Patrick Donnelly <pdonnell@ibm.com>

--=20
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


