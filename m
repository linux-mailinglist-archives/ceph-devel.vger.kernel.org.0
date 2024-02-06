Return-Path: <ceph-devel+bounces-832-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B797484B12A
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Feb 2024 10:26:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77EEA285693
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Feb 2024 09:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29C8774E2A;
	Tue,  6 Feb 2024 09:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WiuHuBnV"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EDD7C089
	for <ceph-devel@vger.kernel.org>; Tue,  6 Feb 2024 09:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707211562; cv=none; b=ZNaU1v/jI0RxWNYuorN0T7UMK9eQkTJI1gTB3XKlqKgUC+BJaXVVv3/mSfLnS4uzjL3TweyBou/Bax2owutd4R7PA9hcBa9M/QRpzOu4LBzkgGqNq3LWht5ZIzu7hRQtSsroIo3aqGAXUNY95WPhIiIiJbTpmqXJ/n2G1dfzGaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707211562; c=relaxed/simple;
	bh=9uMY6P78LwwcvH4sE0s/NPBifzqOtKJCV9DG4plHcoQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jY607Snj1P7a6A39HaoRwcKzw5kIFrarIf8MDt5ONcVtd0gONgGrRlr6wvDYDNBxt4o9BYZMydT1QaBugU3OGza7rnGexOAxltQppkjzOZe5avDgIJdo5+QIeiOEWJZB8Er2bPZyeMZEL6aq5Rm0AbLEQ1hRiVwKJkBmF9dyy+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WiuHuBnV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707211560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SzDXzRmLqYC0aEDfGTRLSdyelNjMpbJog7SVe3Y1jHw=;
	b=WiuHuBnVervQfWv0dZ+onRqpyhv5nM4Mcb7emKIh6GYTNyJlCggmTqCVFv7rYrumhYeZYL
	hmd3ufrStJathKvyPMPcM24nQgFHYGRqxuCei/W5oP174p3bgW0RZizxAwTacOJdYi79Dp
	aTUzJSzFYSIbBQGyGmqUbvj6YGI/d90=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-C57GYng3NfGV4juVJlSvvQ-1; Tue, 06 Feb 2024 04:25:58 -0500
X-MC-Unique: C57GYng3NfGV4juVJlSvvQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a2f71c83b7eso332890666b.1
        for <ceph-devel@vger.kernel.org>; Tue, 06 Feb 2024 01:25:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707211557; x=1707816357;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SzDXzRmLqYC0aEDfGTRLSdyelNjMpbJog7SVe3Y1jHw=;
        b=rrZVgjsjUvdM2KwPF/Upy4AcpBAyE5GeQxIISTIk734zbTpKN7UXY/5UQ2QjqHXWG4
         EJ8nuKI9hddhe7Kg+CjAaiMEAHWwPhBSEzv62Vn3SYKRuiuZKB6GmA8Sg/9m15jZ7nkY
         ePiBuOssOmfkE7xRpygp54L867cDAPZAgYG9TDVq9kfv/T2Gix9SdGNGui2kV3ceJP84
         HZXNBv10hd92AfOojBNXLJFTcK+n/ZoTWUkcl0xr0yJDaNKpQtTxUVsaUgoI1anP45/s
         9pH5J0K4hwZn7yt+Hby4pTtrCcGKgnVkFMScFslETL78FREgrAVUbNc7C2uq6JoMZ3L5
         RsyA==
X-Gm-Message-State: AOJu0YwE0ivhpg7dHhSQBacUC4ybwvG2fK6gXfIJ5Y3EFo2ibPZ2YP+b
	1+DElhPdg7eKopV4CCbgyJuzzUuKz+g+5NymrMUn8atvPagn0OqYz2bwE2hWJpXJXDl/B7k9AoA
	n3Qka0fZ/v6WizK/K189j35MupCpgNVU2xFpvW7KG9XIixfbDeqV/Hvbqy3B0x7jcxrXfCA1MW8
	W7RhdGc8TqI4n22PorrGcl01zxmhwaOo6OKw==
X-Received: by 2002:a17:906:710b:b0:a37:f127:8c0d with SMTP id x11-20020a170906710b00b00a37f1278c0dmr1376728ejj.64.1707211557538;
        Tue, 06 Feb 2024 01:25:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEmo+uCFh4BqM1hHxJTakpeQuz1hljQNzCjvscZdxi0Ik/Ks7itpEdO7nGveLnaAvJlxffPJR11XFBLQYJ0Yig=
X-Received: by 2002:a17:906:710b:b0:a37:f127:8c0d with SMTP id
 x11-20020a170906710b00b00a37f1278c0dmr1376717ejj.64.1707211557167; Tue, 06
 Feb 2024 01:25:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231117081509.723731-1-xiubli@redhat.com> <20231117081509.723731-3-xiubli@redhat.com>
In-Reply-To: <20231117081509.723731-3-xiubli@redhat.com>
From: Venky Shankar <vshankar@redhat.com>
Date: Tue, 6 Feb 2024 14:55:20 +0530
Message-ID: <CACPzV1mu8Fn_x5dV3vTOktcpw+mYgV4cG-1n3ecnUw9rBqj3fQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ceph: update the oldest_client_tid via the renew caps
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, jlayton@kernel.org, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 17, 2023 at 1:47=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> Update the oldest_client_tid via the session renew caps msg to
> make sure that the MDSs won't pile up the completed request list
> in a very large size.
>
> URL: https://tracker.ceph.com/issues/63364
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 24 +++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index fdfea11d9568..7bdee08ec2eb 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1579,6 +1579,9 @@ create_session_full_msg(struct ceph_mds_client *mds=
c, int op, u64 seq)
>                 size =3D METRIC_BYTES(count);
>         extra_bytes +=3D 2 + 4 + 4 + size;
>
> +       /* flags, mds auth caps and oldest_client_tid */
> +       extra_bytes +=3D 4 + 4 + 8;
> +
>         /* Allocate the message */
>         msg =3D ceph_msg_new(CEPH_MSG_CLIENT_SESSION, sizeof(*h) + extra_=
bytes,
>                            GFP_NOFS, false);
> @@ -1597,9 +1600,9 @@ create_session_full_msg(struct ceph_mds_client *mds=
c, int op, u64 seq)
>          * Serialize client metadata into waiting buffer space, using
>          * the format that userspace expects for map<string, string>
>          *
> -        * ClientSession messages with metadata are v4
> +        * ClientSession messages with metadata are v7
>          */
> -       msg->hdr.version =3D cpu_to_le16(4);
> +       msg->hdr.version =3D cpu_to_le16(7);
>         msg->hdr.compat_version =3D cpu_to_le16(1);
>
>         /* The write pointer, following the session_head structure */
> @@ -1635,6 +1638,15 @@ create_session_full_msg(struct ceph_mds_client *md=
sc, int op, u64 seq)
>                 return ERR_PTR(ret);
>         }
>
> +       /* version =3D=3D 5, flags */
> +       ceph_encode_32(&p, 0);
> +
> +       /* version =3D=3D 6, mds auth caps */
> +       ceph_encode_32(&p, 0);
> +
> +       /* version =3D=3D 7, oldest_client_tid */
> +       ceph_encode_64(&p, mdsc->oldest_tid);
> +
>         msg->front.iov_len =3D p - msg->front.iov_base;
>         msg->hdr.front_len =3D cpu_to_le32(msg->front.iov_len);
>
> @@ -2030,10 +2042,12 @@ static int send_renew_caps(struct ceph_mds_client=
 *mdsc,
>
>         doutc(cl, "to mds%d (%s)\n", session->s_mds,
>               ceph_mds_state_name(state));
> -       msg =3D ceph_create_session_msg(CEPH_SESSION_REQUEST_RENEWCAPS,
> +
> +       /* send connect message */
> +       msg =3D create_session_full_msg(mdsc, CEPH_SESSION_REQUEST_RENEWC=
APS,
>                                       ++session->s_renew_seq);
> -       if (!msg)
> -               return -ENOMEM;
> +       if (IS_ERR(msg))
> +               return PTR_ERR(msg);
>         ceph_con_send(&session->s_con, msg);
>         return 0;
>  }
> --
> 2.41.0
>

Reviewed-by: Venky Shankar <vshankar@redhat.com>
Tested-by: Venky Shankar <vshankar@redhat.com>


--=20
Cheers,
Venky


