Return-Path: <ceph-devel+bounces-2260-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE4349E5B78
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2024 17:31:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83565163141
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2024 16:31:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 202D521D5B4;
	Thu,  5 Dec 2024 16:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NMxGkMgE"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5775015B980
	for <ceph-devel@vger.kernel.org>; Thu,  5 Dec 2024 16:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733416262; cv=none; b=OchxUloMd/eoTcipRc0GqXpKTkUojexpv3JiMZt0277PCIKsfPOB7kHJ/wNJXtRguYQfViVcU4t+F0uoELmnnvNT8KjU+ahR5w7QFmw4RzatS1EKf0xbQq0Zhl3g19ItD6lDvbIuAbm+FYo5ldRp9TyMw8CJUMIb6RH0gjJkcIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733416262; c=relaxed/simple;
	bh=hG4asEEnz87Q9QSfkohZl5iGcIqBAo677zQLpe5jZdI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eCdhQ++CVzSudvSakCFJy0org+9bIdFYOTyaoOjXkgdc1egIkHMOen+6C81ka1iAgbIW3aVUmfv+zyKGbxgAitUhp99YoLTl8TIKXN+Fdm+vhgvN9AMi24n9hTfQetKeLsjFWw+qHVmcw6dlhjF1hNZzfO9f2sGntUI2cu05+oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NMxGkMgE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733416259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uZDDsZtHXJGYVGhruhoC9cWjiVOcL7T2FVpAbVAAILg=;
	b=NMxGkMgESl5cBNGX0eBscFv0xhD518RmgIrQkXZ0oAepKNUG03/wI0s57ZccqKbPsKnslQ
	QMx0Xave1rfigmh6Rdby+lkCG9FK6ugKNQuRxPWHkH+9C9bYsLfyC3CHRWmmdJYE9R1onM
	UrtFT89i0l+W/TjRYEk5UG+Wmtywcc4=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-FiRhL4YkNlGMBcyNsZwYIA-1; Thu, 05 Dec 2024 11:30:58 -0500
X-MC-Unique: FiRhL4YkNlGMBcyNsZwYIA-1
X-Mimecast-MFC-AGG-ID: FiRhL4YkNlGMBcyNsZwYIA
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-53e152ba53eso803485e87.0
        for <ceph-devel@vger.kernel.org>; Thu, 05 Dec 2024 08:30:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733416256; x=1734021056;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uZDDsZtHXJGYVGhruhoC9cWjiVOcL7T2FVpAbVAAILg=;
        b=iI8tIS/UEA6puxfOoTiJu5jDK2CCNaUKZtYqjvaQBz3iZqkeo9oKULeUP3x4rPvfVU
         avPVVj9KCQ53uw2apa92b4u0DN+DGiS375ApzEcyqULPhBKf2YV1vRU4XHHIaaC03kJq
         zpEhzUe/XFmJIVWKifIFRxYX/CEJTAsAmiFNGKESour82lH2TFOxoP99DMdFgOpQOkTC
         YGylqYGa6n6hDXWwYa6Hc2dKO7RLuNUQjeAE8l69b4tkBHwmAhZDBa5YUWNFVR9UqwgC
         et5g1AH/PBoe0XzK0LfV/eDh85PLpZ13u0YBq6v7SmMVV9jRqTHYC5XzxeaLa3Hm1sls
         bB2g==
X-Forwarded-Encrypted: i=1; AJvYcCVV7OBCZUoGaDjc2TuZcuQ9mvf3jbmBlFoltMrmGBNQx0f5cMn+lBdVxC6vcibDozg2yBMDqqXuyc61@vger.kernel.org
X-Gm-Message-State: AOJu0YyBE58aBUQjaNXchcNTr3nuEnzasux405Z1RhA3LiLfzkIJd0FS
	zgK3pwlvKN7Wlx3OGPBHHmMqmJQFfB3YSA1l6hsgo6Yr3ycBISUz9jEUm+Iy6edtKn3XM3wBpUo
	4iHXcGAWaiEQOkMyLmm6nbKJzB1nppQFYr3xAFH6MPALZRqWpNULFglniENRziWIE8WLObIWaRs
	g8e7cTsrNvSDmj7pAcFE/G7wbdAGrfhnMcFg==
X-Gm-Gg: ASbGnctXd/6FsLRCKNEU5/xb4c5ILviD1MCObLJFgFJk2bF8cKdB5n9bFnanCELw8Ct
	MA9EYjHiSFgfsVETo/u52xwgxUrzzFz3AFB/pzEQ76Mj2fl70
X-Received: by 2002:a05:6512:3e1f:b0:53d:ed77:37c1 with SMTP id 2adb3069b0e04-53e12a20717mr6729839e87.43.1733416256512;
        Thu, 05 Dec 2024 08:30:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFgMd6PL+rgVfvFv9AGhR5OqbNp6njB71ewbVTz9WRoSrISoqHQip6WAnnlTdT75/bdbul6qE9mnUw2af/7coo=
X-Received: by 2002:a05:6512:3e1f:b0:53d:ed77:37c1 with SMTP id
 2adb3069b0e04-53e12a20717mr6729822e87.43.1733416256140; Thu, 05 Dec 2024
 08:30:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOi1vP8PRbO3853M-MgMZfPOR+9TS1CrW5AGVP0s06u_=Xq3bg@mail.gmail.com>
 <20241205154951.4163232-1-max.kellermann@ionos.com>
In-Reply-To: <20241205154951.4163232-1-max.kellermann@ionos.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Thu, 5 Dec 2024 18:30:44 +0200
Message-ID: <CAO8a2Si+7uFkOCf4JxCSkLtJR=_nQOYPAZ_WkWES97ifhyHvBQ@mail.gmail.com>
Subject: Re: [PATCH v2] fs/ceph/file: fix memory leaks in __ceph_sync_read()
To: Max Kellermann <max.kellermann@ionos.com>
Cc: xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good.
This sequence has not been tested independently, but it should be fine.

On Thu, Dec 5, 2024 at 5:49=E2=80=AFPM Max Kellermann <max.kellermann@ionos=
.com> wrote:
>
> In two `break` statements, the call to ceph_release_page_vector() was
> missing, leaking the allocation from ceph_alloc_page_vector().
>
> Instead of adding the missing ceph_release_page_vector() calls, the
> Ceph maintainers preferred to transfer page ownership to the
> `ceph_osd_request` by passing `own_pages=3Dtrue` to
> osd_req_op_extent_osd_data_pages().  This requires postponing the
> ceph_osdc_put_request() call until after the block that accesses the
> `pages`.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>  fs/ceph/file.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 4b8d59ebda00..ce342a5d4b8b 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1127,7 +1127,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_=
t *ki_pos,
>
>                 osd_req_op_extent_osd_data_pages(req, 0, pages, read_len,
>                                                  offset_in_page(read_off)=
,
> -                                                false, false);
> +                                                false, true);
>
>                 op =3D &req->r_ops[0];
>                 if (sparse) {
> @@ -1186,8 +1186,6 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_=
t *ki_pos,
>                         ret =3D min_t(ssize_t, fret, len);
>                 }
>
> -               ceph_osdc_put_request(req);
> -
>                 /* Short read but not EOF? Zero out the remainder. */
>                 if (ret >=3D 0 && ret < len && (off + ret < i_size)) {
>                         int zlen =3D min(len - ret, i_size - off - ret);
> @@ -1221,7 +1219,8 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_=
t *ki_pos,
>                                 break;
>                         }
>                 }
> -               ceph_release_page_vector(pages, num_pages);
> +
> +               ceph_osdc_put_request(req);
>
>                 if (ret < 0) {
>                         if (ret =3D=3D -EBLOCKLISTED)
> --
> 2.45.2
>


