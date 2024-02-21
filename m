Return-Path: <ceph-devel+bounces-889-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7848085CF2E
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Feb 2024 04:57:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17B8F1F252D8
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Feb 2024 03:57:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9561834CD5;
	Wed, 21 Feb 2024 03:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H32AUP4x"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9E21851
	for <ceph-devel@vger.kernel.org>; Wed, 21 Feb 2024 03:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708487853; cv=none; b=OSOxcQI+c1cMLlqOFatLI5VTCU1XKAotjodV2vD6YF7YX/3h7BMXxZROjWeNMAQ+qrH7jK4I8jZdLZBiKqgK0KAT+5h8y+aeB4DEZy45PhrALVW89wUvEa6L67B04Mhf207tovQcvBk+RmleIXdXBawoeoGelaJL5V4CdnkG3UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708487853; c=relaxed/simple;
	bh=51p99pvjB84wkwzsjde0yD66kQJPuhhruRtyyc6AOGE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ts+dGBJyZanPsrTrkusm5oOymQlF7/xXm30ecSC6V9yzD2xcQJpN1/L2WNQIXFSyTdK7aGUUn5ehD3pdq8Y6RQ6zAq9qK2j72r+NhCFH7SBLTw3/nX1ANoxdwbzZ+Getx0fe270y9cSW2FVMhCAdUysLk+07fGn3cm/IfuhVU+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H32AUP4x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708487850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lId361m3EYWlm2a2PjQKDj3n3/2VjM8NZ2B5VXcqrdg=;
	b=H32AUP4xt1yf+osV73A0EKX5GAu04NYNsoVML87zLyq4ORq218MwC9fyXOlitrwvvouu1j
	rg3i4+EhFWUXr9bnjYjVA4/7SgnNtpo289eQP3nLhG/efdQggbNGji5t7G4civYnRrq4Ov
	M00UzJZsCFXewtiqPE0DSn7oHGwqQ4U=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-q2EsCemEOS6idTd3SIcVUA-1; Tue, 20 Feb 2024 22:57:28 -0500
X-MC-Unique: q2EsCemEOS6idTd3SIcVUA-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-50e55470b49so222755e87.0
        for <ceph-devel@vger.kernel.org>; Tue, 20 Feb 2024 19:57:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708487846; x=1709092646;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lId361m3EYWlm2a2PjQKDj3n3/2VjM8NZ2B5VXcqrdg=;
        b=al0YSz+1VASLlslfB50xybKDBblZH+MWnEMIwJ0Iy3BSdTzHUxSNbKGtf3I/dMLpNG
         pqpEvIGU51J2VSHcIpLqcVDUgtpFgcFuLOSEWhwPrPaZgftDLaIbLD4d7Rm4/gnHK9Dj
         wNK8XWRzmC0QkwEiNfDED9tIFrCGfULoy+Tfe9WrmbY90c7GZ+js8ixGl72OCk4Udenu
         pF+9NAS0ogEC3NQaNRMYpv/YdBe3842L8Pv2i0e+5SbLvJRd8NqD+9cv7PpF2Vsw3wrF
         +6TEOit8izW4YRru7f5CPSa+5teJwPnCrFkKn4X75UJH5XFBvW9TGPv0Q7cXFO4xPUK7
         BK9A==
X-Gm-Message-State: AOJu0Yz/E4go0grJv4qHdx17B9wdzL91G16H0c+Fcd4Mp3oDnCqzQbuJ
	ILAxjw6Q7sSVNkAEKJ2duEoNv7/T+lD84uZiuAU9AjvbsCDa0bN+QH/kVROGBeKRDa4rfiFs98S
	R+/AiGaHBep5RinpU3/mN4hM8h4Bng33mT6/w9rV9HKt7ngcZTe3oWS1t1wJ71dLJ8ute7lXJGq
	XVXpiSW9TmB52L1xqq018+bZdL1nat3I/Yp1bFLuxDfw==
X-Received: by 2002:a05:6512:4013:b0:512:d01e:bdcb with SMTP id br19-20020a056512401300b00512d01ebdcbmr641504lfb.10.1708487846553;
        Tue, 20 Feb 2024 19:57:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF4kV2+tmI3Su55EAUuf7PXRMfZmXQM4bl/Dkl8arlmZIFn11WNK3DlJFN+aU1exX3tzn3YadZCl/0jOcMD/wg=
X-Received: by 2002:a05:6512:4013:b0:512:d01e:bdcb with SMTP id
 br19-20020a056512401300b00512d01ebdcbmr641493lfb.10.1708487846213; Tue, 20
 Feb 2024 19:57:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240221031052.68959-1-xiubli@redhat.com>
In-Reply-To: <20240221031052.68959-1-xiubli@redhat.com>
From: Venky Shankar <vshankar@redhat.com>
Date: Wed, 21 Feb 2024 09:26:49 +0530
Message-ID: <CACPzV1k-yOSEmpCrKRGzi_nV5CT69qwOxH8xA0e5vz+Yd3h-DQ@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: reverse MDSMap dencoding of max_xattr_size/bal_rank_mask
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, jlayton@kernel.org, 
	mchangir@redhat.com, Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 21, 2024 at 8:43=E2=80=AFAM <xiubli@redhat.com> wrote:
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
> +        */
> +       u64 m_max_xattr_size;
>         u32 m_max_mds;                  /* expected up:active mds number =
*/
>         u32 m_num_active_mds;           /* actual up:active mds number */
>         u32 possible_max_rank;          /* possible max rank index */
> --
> 2.43.0
>

Reviewed-by: Venky Shankar <vshankar@redhat.com>

--=20
Cheers,
Venky


