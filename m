Return-Path: <ceph-devel+bounces-3808-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DFC56BC8BCC
	for <lists+ceph-devel@lfdr.de>; Thu, 09 Oct 2025 13:19:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DDF1A4F5BAD
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Oct 2025 11:18:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EF4D2E092E;
	Thu,  9 Oct 2025 11:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KoSNf3xl"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E5B2E0410
	for <ceph-devel@vger.kernel.org>; Thu,  9 Oct 2025 11:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760008710; cv=none; b=k6unkCe8xpsae6vRispIJdeopibpvYNLmCC9PqfFdMyD+5tMmCXAXH5Vp2K89J4CW+2YwG/+ULEm0s7waxB+UQ4GqjUS8SU0S7IuPemw2k637HomXIiZlhKD0vNsSp2PgLicfqrZju8Y89bGwWiQR6NS+yAa4yj/GO20F+ERwwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760008710; c=relaxed/simple;
	bh=KhiBEQ1gBj6N/wX9SxoVMA19u0YnGN1VD1SS7ME84vw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f2yuUreLFa8eGZg0+8bIkIEkSwuu/Wn0S69b8YRCIzjt70jvEgQnrZfCCMhtb2A3zUDoVBPcB6+PGXfd2ZBJSeEkyrsJg6WaXtqf4/zaFwIxABoR06y4lQfBeb+2os9TeOpBxEe9qJvlETNKAo88l2CBxYRdQYycdrbWt+ek+7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KoSNf3xl; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b632a6b9effso518462a12.1
        for <ceph-devel@vger.kernel.org>; Thu, 09 Oct 2025 04:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760008708; x=1760613508; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iqfRaZoQUI4dNFSPZo9GyySQC2vIhVGnsV8QxQuw7pA=;
        b=KoSNf3xlHwsIU5mJeeMtTH9JboKnK6HUHzBfNkobUe3mc7l1xBIH9Jtwy2FzEsX1nO
         qEc8xiErlOlepn2KH/f9s5ZDj07EPe99iJO02EgEJkH/L17PPlVWisyKfcf8YkVirI6H
         nRiYamT7UtnlqNqPb3DgyJ/hs+KHqVtiDCQ+TQ7cpM8WaVrbTXcqwCvfSrRXPx0V+E/G
         NBHbUk0Pp/g+HdmeuFt0BvfwggqLI9ZatLuEJjl6b9OB8xIChbhNDLfl8SPTXE4dfhtN
         oJgmwGHh/s+JxCxAPOOBCUERPtBISGEGk24RvR3GEmoayO+y9SewuITwGDcwGbA/2oHe
         YjMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760008708; x=1760613508;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iqfRaZoQUI4dNFSPZo9GyySQC2vIhVGnsV8QxQuw7pA=;
        b=rYd+Q1d1w0q4nrj6N760YWPdBXI8Tu2/UxIzrl1tYnoWHIDnN4x6HxU7WEuwJNG2pP
         G3p32KjFwIawHn+pIMoNNMXiTIoP0Ip4t7AS/QIhFZsOPtYL0w38Nu5zr0S57Q+k+nIc
         QgwxR7IMYnb93knJ5aS4rAUOtUtudBu9/9AJnj4ZXI0fRWZ53mCCIfYCihHZK3sqxGJa
         48C5JaW7QsHLcWpawsrUN7Tv3Miz2Fycu1Ww29YceNcqH1i9T1nf9lVQEuL2m6ZQh3g5
         Ri8YOk/t8f/az0wSuBO7m1poo2IleNgRnV3Nj6E/6gJsZqXdo60kMOWhobznLT4lZRHY
         DTNA==
X-Forwarded-Encrypted: i=1; AJvYcCV6n8htRZ9ML9XQ2B3CqIYG5sVqPYDTIDhrwhUa96aSPzlTFXkCcVpWhRZVkSTjKfp0JeBX9I6lKr57@vger.kernel.org
X-Gm-Message-State: AOJu0YxeQ8iqOg+A/pRAw1/PrL+6lTmchoxsTvrZi4HHSUqHe/DEfEQM
	9YL6qzTwM8PCuhFIpQG2XBjikbrRaWOP87R2vZKTee/yrhpPjEeYLWcOr6wgrRpdUeTJmDJlqa8
	Wa/Lis/BqDE0792bEBnJ+MUKIkw9J+gc=
X-Gm-Gg: ASbGncso59LWzAw8J1HVP9J7dCoNThVZKuhPDjV1/sZYQOiDzCV3OVej3JM54LB1OnV
	ZZFssP86dA9YVtGzTstujoyWzMMAPuCfcjBkZ0smhXnKs4chWLEU8Vw5pnmjexjH/R2y1Cvhkbn
	6xx7eotyrzpXoHr8B1Ra1JfmkZz1qVIyQEZLGF+8vxUc0Ff6nHlQe79NF93yzT9EfEHBH0ZWy8J
	1y2zeKV9EqMkcs6whkUwrBd8B77kxw=
X-Google-Smtp-Source: AGHT+IGcTXsPBhZTmdsjcj1YrtEGdE4o7S5DX96nyjsPy2BgZaV1B0w17FZSDPhHO/AfhGjc60kGCKFbyKvnjNaAjuQ=
X-Received: by 2002:a17:902:e94e:b0:270:4aa8:2dcc with SMTP id
 d9443c01a7336-2902737c5e9mr93104295ad.19.1760008707755; Thu, 09 Oct 2025
 04:18:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250806094855.268799-1-max.kellermann@ionos.com> <20250806094855.268799-4-max.kellermann@ionos.com>
In-Reply-To: <20250806094855.268799-4-max.kellermann@ionos.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 9 Oct 2025 13:18:15 +0200
X-Gm-Features: AS18NWAi8TGwpk5qdmtF-1FkOPvzEwGccMEEtDCCNUrhBLZHkJ86tq0vDug7F0g
Message-ID: <CAOi1vP_m5ovLLxpzyexq0vhVV8JPXAYcbzUqrQmn7jZkdhfmNA@mail.gmail.com>
Subject: Re: [PATCH 3/3] net/ceph/messenger: add empty check to ceph_con_get_out_msg()
To: Max Kellermann <max.kellermann@ionos.com>
Cc: xiubli@redhat.com, amarkuze@redhat.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 6, 2025 at 11:49=E2=80=AFAM Max Kellermann <max.kellermann@iono=
s.com> wrote:
>
> This moves the list_empty() checks from the two callers (v1 and v2)
> into the base messenger.c library.  Now the v1/v2 specializations do
> not need to know about con->out_queue; that implementation detail is
> now hidden behind the ceph_con_get_out_msg() function.
>
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>  net/ceph/messenger.c    |  4 +++-
>  net/ceph/messenger_v1.c | 15 ++++++++++-----
>  net/ceph/messenger_v2.c |  4 ++--
>  3 files changed, 15 insertions(+), 8 deletions(-)
>
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index 424fb2769b71..8886c38a55d2 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -2113,7 +2113,9 @@ struct ceph_msg *ceph_con_get_out_msg(struct ceph_c=
onnection *con)
>  {
>         struct ceph_msg *msg;
>
> -       BUG_ON(list_empty(&con->out_queue));
> +       if (list_empty(&con->out_queue))
> +               return NULL;
> +
>         msg =3D list_first_entry(&con->out_queue, struct ceph_msg, list_h=
ead);
>         WARN_ON(msg->con !=3D con);
>
> diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
> index 516f2eeb122a..5eb6cfdbc494 100644
> --- a/net/ceph/messenger_v1.c
> +++ b/net/ceph/messenger_v1.c
> @@ -189,12 +189,18 @@ static void prepare_write_message_footer(struct cep=
h_connection *con, struct cep
>
>  /*
>   * Prepare headers for the next outgoing message.
> + *
> + * @return false if there are no outgoing messages
>   */
> -static void prepare_write_message(struct ceph_connection *con)
> +static bool prepare_write_message(struct ceph_connection *con)
>  {
>         struct ceph_msg *m;
>         u32 crc;
>
> +       m =3D ceph_con_get_out_msg(con);
> +       if (m =3D=3D NULL)
> +               return false;
> +
>         con_out_kvec_reset(con);
>         con->v1.out_msg_done =3D false;
>
> @@ -208,8 +214,6 @@ static void prepare_write_message(struct ceph_connect=
ion *con)
>                         &con->v1.out_temp_ack);
>         }
>
> -       m =3D ceph_con_get_out_msg(con);
> -
>         dout("prepare_write_message %p seq %lld type %d len %d+%d+%zd\n",
>              m, con->out_seq, le16_to_cpu(m->hdr.type),
>              le32_to_cpu(m->hdr.front_len), le32_to_cpu(m->hdr.middle_len=
),
> @@ -256,6 +260,8 @@ static void prepare_write_message(struct ceph_connect=
ion *con)
>         }
>
>         ceph_con_flag_set(con, CEPH_CON_F_WRITE_PENDING);
> +
> +       return true;
>  }
>
>  /*
> @@ -1543,8 +1549,7 @@ int ceph_con_v1_try_write(struct ceph_connection *c=
on)
>                         goto more;
>                 }
>                 /* is anything else pending? */
> -               if (!list_empty(&con->out_queue)) {
> -                       prepare_write_message(con);
> +               if (prepare_write_message(con)) {

Hi Max,

I made a change to net/ceph/messenger_v1.c hunks of this patch to
follow what is done for msgr2 where ceph_con_get_out_msg() is called
outside of the prepare helper and the new message is passed in.
prepare_write_message() doesn't need to return a bool anymore.

Let me know if you see something wrong there:

https://github.com/ceph/ceph-client/commit/6140f1d43ba9425dc55b12bdfd8877b0=
c5118d9a

Thanks,

                Ilya

