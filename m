Return-Path: <ceph-devel+bounces-1845-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D18B098835B
	for <lists+ceph-devel@lfdr.de>; Fri, 27 Sep 2024 13:31:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 708A2B22886
	for <lists+ceph-devel@lfdr.de>; Fri, 27 Sep 2024 11:31:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDE98187349;
	Fri, 27 Sep 2024 11:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IDFVmkk/"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0A2176AD8
	for <ceph-devel@vger.kernel.org>; Fri, 27 Sep 2024 11:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727436705; cv=none; b=QgSGPN1phnmrVSkolPCFEGcVSeEczknohe73WUe+93Fy2bDVfcO+ESFXWKd4ZZWH36KmAkmdbgcZUztqCB+WYNJmn8qd0okP+YX3rVS8uuUz2qYy5oML48ZERD7rXwWN+mPMAqL57OAlAzjnTBtVuQlaTBS6bHPszDeI73LJwh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727436705; c=relaxed/simple;
	bh=YDhBB++WY9IH1JhgG25ZpHtR8kFUAOQTXDEhpfWvS8Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gg6GLgCynYSUum0v4zseLRH1mYGP7ZX9VyXU3HXLR9XX3xCnLIKtmZEpYb85EN0lle26FUBXfUO6+7juQpBDrG0aGorPZoD5qPwPUrqovbcDUNUY8tyUpDqqKwYEVwvqz3uaj+4WwxaVDm4tjkFQ3Jv4ceJsjo9jUpasp2eZ6Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IDFVmkk/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727436702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jFcc+IBAU7MXkAN2KLkkTW/Krtoq5BAQf3N5Pt3PLzU=;
	b=IDFVmkk/znUpMqWtw24vl88in30ymUac8nqmw51Nc9IF7lZYRQtmO5FTx/uEIY3tCnnG/0
	t9D7KAOclm3sMUYDd051K4ioZv0D1OSgWY4c+YJ1pzE6kcsQ1//zE+JjV3oO+HRxOdPZa7
	2ekrnANPcMixAozLMtd2JiMC2LHA8aU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-Nu7OZA_wPc-N3a2Neljkcg-1; Fri, 27 Sep 2024 07:31:41 -0400
X-MC-Unique: Nu7OZA_wPc-N3a2Neljkcg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a8d2ecdf414so137823666b.2
        for <ceph-devel@vger.kernel.org>; Fri, 27 Sep 2024 04:31:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727436700; x=1728041500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jFcc+IBAU7MXkAN2KLkkTW/Krtoq5BAQf3N5Pt3PLzU=;
        b=By8BbgD1JK8MlndlX4/XIezxlbcG/iZoq1QD20RdlWltPkXLyUsXIwNVLIDwahAxVb
         Tox8O3CngH48reeLiWCJTh0/4HFkkMrApiEIAp7p0+mvZMw7wRhMFhCv88fPEg2+u7an
         paN4kg3DaioyBe7ayLKXV097cMV2stLad14QVeUhl9rmqTHJ4I0VC6prKlp6ZlxaR+HC
         HhZ5jt1m+TD9utgQY+fBwdTLTShkGN+yDS2GHMCffqjwx/SVQNJOdy68xkmZr3+WPgU3
         1UmU5ir4NwzVRvcZLwJwluk51T3Kp3SJb3gyuhCLlH8zUz4HnwZFmWYSVXFQZKbvXxJy
         VMEQ==
X-Gm-Message-State: AOJu0YxAiCNpuUMrA2YnBGo+WivIRqA9y3PhK0Kcd3aLVyYLyEyEZllq
	i/iEJ9atsKkpKKbsPtaiePa/3RLhfQI/ILGhVdlYiTVcoKhbnan1yS15DzEFOjFJMRpbhaau6g9
	cw35yHlHnfBY0c/z4Pi2olwOgbkGEBD9zGKwcasSVay1NjuEzBDrbrbgvWBZEMfbUwF92sz88W3
	jECJPsCIWoB/zc29H/HeqLBVHDq5yqnqQCZQ==
X-Received: by 2002:a17:907:60cc:b0:a86:7a84:abb7 with SMTP id a640c23a62f3a-a93c4915538mr302210366b.20.1727436700408;
        Fri, 27 Sep 2024 04:31:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH3muSExJo0l1UkovXWgpXdV77M69CRHCrPAKqXAunhhgHdjcK5L+BQamNGkveKQh5xbInY2BZaAKnqO4yPP6E=
X-Received: by 2002:a17:907:60cc:b0:a86:7a84:abb7 with SMTP id
 a640c23a62f3a-a93c4915538mr302207666b.20.1727436700004; Fri, 27 Sep 2024
 04:31:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240904222952.937201-1-xiubli@redhat.com>
In-Reply-To: <20240904222952.937201-1-xiubli@redhat.com>
From: Venky Shankar <vshankar@redhat.com>
Date: Fri, 27 Sep 2024 17:01:02 +0530
Message-ID: <CACPzV1nvL+5GcA0vPe-ird-VyiQb_PXbP8uLLG4bpzXrer9yyg@mail.gmail.com>
Subject: Re: [PATCH] ceph: remove the incorrect Fw reference check when
 dirtying pages
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, gfarnum@redhat.com, 
	pdonnell@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 5, 2024 at 4:00=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> When doing the direct-io reads it will also try to mark pages dirty,
> but for the read path it won't hold the Fw caps and there is case
> will it get the Fw reference.
>
> Fixes: 5dda377cf0a6 ("ceph: set i_head_snapc when getting CEPH_CAP_FILE_W=
R reference")
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/addr.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index c4744a02db75..0df4623785dd 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -95,7 +95,6 @@ static bool ceph_dirty_folio(struct address_space *mapp=
ing, struct folio *folio)
>
>         /* dirty the head */
>         spin_lock(&ci->i_ceph_lock);
> -       BUG_ON(ci->i_wr_ref =3D=3D 0); // caller should hold Fw reference
>         if (__ceph_have_pending_cap_snap(ci)) {
>                 struct ceph_cap_snap *capsnap =3D
>                                 list_last_entry(&ci->i_cap_snaps,
> --
> 2.45.1
>

Reviewed-by: Venky Shankar <vshankar@redhat.com>
Tested-by: Venky Shankar <vshankar@redhat.com>

--=20
Cheers,
Venky


