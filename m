Return-Path: <ceph-devel+bounces-1557-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ED7093BC04
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2024 07:23:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A25E2B23959
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2024 05:23:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B82451BF50;
	Thu, 25 Jul 2024 05:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IF3E75J3"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E3D125B9
	for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2024 05:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721885021; cv=none; b=QsYRdOPryP3nqcR6exFw1IZOXUF6FSZtANyIZjNr/FZIBQ03bh3NCXvAA4tNJXKM6HqpM/GaNFj2Hl+yzrEdHkSogFcgda0IS+1d9rV2ljKmTNJG/l4uia6Fiwve65lRk65tC85x0nmmxB4nkYH2tm9SNdyiMNfkTyVe0n2N6Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721885021; c=relaxed/simple;
	bh=/EbjmR/w31QRhJAkNj286wW6Qc4nhHAF7q0yY/c5rHU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ay7xQwvNFFIpjndABIJv37AF+HwfEuW2gxrpy0PfjklTgGeAh/FB036urtY/WmWhEvAkVRandNO92wji2Sy8wnZbC7cUQ7uFIYr28KKcX8wnuZNq6vU0iNaVdhjnVBIx42SU+HQuIisTItnnKO6de6OfmDwYLkjuCBSBrACGxFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IF3E75J3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721885017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S8nTatH8z1/aU946XGADnP6gxqY2qA8UeLMAaueov18=;
	b=IF3E75J3UB/iUrEdDe88Trd+UhmVCYQ0fVyOe5oZQL//Z/FlzURz1OQkHDgHd6aP58zH8R
	5TrA3zNGhP02xbKGkYvGOw8czAGPx+tpkktZCgbiO9ut+Baa0snoCGWzgfPWszebcE6USc
	KyGB2HhE47h5yoBvvmau1C6aV113aDk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-CYeKbOopOjadhW3dyvnExg-1; Thu, 25 Jul 2024 01:23:34 -0400
X-MC-Unique: CYeKbOopOjadhW3dyvnExg-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5a534faa028so552845a12.0
        for <ceph-devel@vger.kernel.org>; Wed, 24 Jul 2024 22:23:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721885013; x=1722489813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S8nTatH8z1/aU946XGADnP6gxqY2qA8UeLMAaueov18=;
        b=qBjwbya9CIO/2wEKakKDOiAJqEK82xg1rOB/nm9lJD6F/2784vn2znEkGucbMpQZz/
         qsZlbmENTQ/1Kg2AdI8/xqZGx/3PVus1lrvePZkmky4AmxTjZtsVIsZYRiEcqSBpPW1e
         emGgS8UgOUzYYT0f6+HLGLR6sR18LS2EOo55IZGarF+k7a2E/i+HIqSY1CZAia+PW64m
         /xV6Kn8ENXfecDiVg1MRM0QL3xAjX5lb19EK18EWsGfo/mzNPfI4OlVy4VRZcBdVkfip
         EC+PnZwZTYaJ5f/QUGBGZjXXeOgJTZzt6+JtJ3zipdIoTVE6DjYLfOc9dviEG2aDlNCq
         nAMw==
X-Gm-Message-State: AOJu0YwswnToCirSmA2+DaD8n97ClHiAM7oiePbrTt2KdtUN+r21SUqH
	T2Jh1e9qzwOEae19oa1FPzeorRzpNBsZven/EEqovLOa7doBBME+H1GjOLCu7tNHuxja46cDd+X
	n6mSl7cXzI+DUp1ZfVM1937lMVKEfNKrwVKEp/7rJMZUKLjXiXTkumsFU3yt+BH6Wvqw+kABmJC
	6AMvbydZY95/A9jGhOGi4liVYTESRP/t4CHg==
X-Received: by 2002:a17:907:2da0:b0:a7a:929f:c0cf with SMTP id a640c23a62f3a-a7ac5173f38mr115329066b.21.1721885013193;
        Wed, 24 Jul 2024 22:23:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpTuLrGo9i8wUiDWFqawh8WD5l/o0Pw1vfXvmYZtmA/tqsHo8VXBaxI6UvkF5cLC9GxseDX8GAUmzYVqZu8XU=
X-Received: by 2002:a17:907:2da0:b0:a7a:929f:c0cf with SMTP id
 a640c23a62f3a-a7ac5173f38mr115327866b.21.1721885012837; Wed, 24 Jul 2024
 22:23:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240514070856.194701-1-xiubli@redhat.com>
In-Reply-To: <20240514070856.194701-1-xiubli@redhat.com>
From: Venky Shankar <vshankar@redhat.com>
Date: Thu, 25 Jul 2024 10:52:56 +0530
Message-ID: <CACPzV1nHXN6Bh-8i6VyMnmMX5-26D0ra1nfD=Ly_sAYa1_M_OA@mail.gmail.com>
Subject: Re: [PATCH] ceph: stop reconnecting to MDS after connection being closed
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Xiubo,

On Tue, May 14, 2024 at 12:39=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> The reconnect feature never been supported by MDS in mds non-RECONNECT
> state. This reconnect requests will incorrectly close the just reopened
> sessions when the MDS kills them during the "mds_session_blocklist_on_evi=
ct"
> option is disabled.
>
> Remove it for now.
>
> Fixes: 7e70f0ed9f3e ("ceph: attempt mds reconnect if mds closes our sessi=
on")
> URL: https://tracker.ceph.com/issues/65647
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index f5b25d178118..97a126c54578 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -6241,9 +6241,6 @@ static void mds_peer_reset(struct ceph_connection *=
con)
>
>         pr_warn_client(mdsc->fsc->client, "mds%d closed our session\n",
>                        s->s_mds);
> -       if (READ_ONCE(mdsc->fsc->mount_state) !=3D CEPH_MOUNT_FENCE_IO &&
> -           ceph_mdsmap_get_state(mdsc->mdsmap, s->s_mds) >=3D CEPH_MDS_S=
TATE_RECONNECT)
> -               send_mds_reconnect(mdsc, s);
>  }
>
>  static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *m=
sg)
> --
> 2.44.0
>

I don't see this change in the testing branch so that the fix can be
verified with

        https://github.com/ceph/ceph/pull/57458

--=20
Cheers,
Venky


