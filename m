Return-Path: <ceph-devel+bounces-265-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1664A80A2C1
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 12:58:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0C7D1F214CB
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 11:58:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E3351BDE7;
	Fri,  8 Dec 2023 11:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k2gBdVKG"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866FAC3
	for <ceph-devel@vger.kernel.org>; Fri,  8 Dec 2023 03:58:32 -0800 (PST)
Received: by mail-oo1-xc2b.google.com with SMTP id 006d021491bc7-58d956c8c38so973061eaf.2
        for <ceph-devel@vger.kernel.org>; Fri, 08 Dec 2023 03:58:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702036712; x=1702641512; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CKLkr7gCQljvUAwp2JrPq2RBsmAY/P5XnQWvr+dNJ+Q=;
        b=k2gBdVKGncpVnIhyyvnYiDJUwZpLs4rwS4EFREH8SfT3ISLSVNkngo5C8W4Ak8yc0t
         bUh+Wg1LcRIxx2V2e6zsN4/2R8lsXy/nu9OMz6+i/jWh/L/N8Ti+n7955u8romRstxyD
         Wabo7DbP8htZgkuDyRq7wYG7AUwEGE9FWl+NmnNbC/qGGBLrY8EvTC/fcoCHHLigosjJ
         E4vKB3D1lw7QZNQg3Jt2zmmhiABppo9btfzdvgRXcV4kKPbnSjpvbUEy9tQcDk3VNPWi
         J3OpnIxaMeQXYY8nfxPlLJVQQDL0PTzAFmUUQ8EdPk9recgC0pXMPL+WvGPa6kAXLGX2
         ZLug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702036712; x=1702641512;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CKLkr7gCQljvUAwp2JrPq2RBsmAY/P5XnQWvr+dNJ+Q=;
        b=u+Aygyx+pQ2H2PnNvxSsvjWQRmJrRbORQ2JtKw44qpFit772cmYQAk3Qx56rZNRW2p
         pKquTIobz/F974Hoo6RwZ1aFNJ73Nx2Cssxp4LVaI4xjpXgS+oP8fNZK/37tLgzH03Uu
         qqKDQL8aaTj/41/9u0CeC5rif2KpfzL4yFHPfF/YxBlMVy3yimLnfQmECiz11J7CFss1
         f+9qfajcIohU67Ujhz+MxB9tXFQFT9WBj5SOwtsegrABR0XFQ1+S0yomKWi4anNE9S+G
         ALzxW4AkrrBXKLdM7IEUP9p3YLClR0V50Li9snpnB72EVlGigSPfZgvjVHEO44hiwl2y
         zMEg==
X-Gm-Message-State: AOJu0Yyu3e/AYir2sXfBG5k6MlB9+PCHzOwsc3D71tXv8C0Jj2Qy4tRX
	REewpBICzocZNp3pN9ZgmW0wXOrN8Y+bXfk1Df2RithYkHY=
X-Google-Smtp-Source: AGHT+IHQykDrCgm0aYznKuaBJ0xBJqgVK1CJmY8wJtzBpALQlb+aouI9Hlfos7ZpTncBC9FRSm6ea1yEmmDIur98xgQ=
X-Received: by 2002:a05:6820:611:b0:58d:974b:5056 with SMTP id
 e17-20020a056820061100b0058d974b5056mr3828845oow.1.1702036711883; Fri, 08 Dec
 2023 03:58:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231208043305.91249-1-xiubli@redhat.com> <20231208043305.91249-3-xiubli@redhat.com>
In-Reply-To: <20231208043305.91249-3-xiubli@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Fri, 8 Dec 2023 12:58:19 +0100
Message-ID: <CAOi1vP-RT6zu6ed+-LVrCGZ+a=Yi1zakyqaLkHMcE=LVQkZiTQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] libceph: just wait for more data to be available on
 the socket
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 8, 2023 at 5:34=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> The messages from ceph maybe split into multiple socket packages
> and we just need to wait for all the data to be availiable on the
> sokcet.
>
> URL: https://tracker.ceph.com/issues/63586
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  net/ceph/messenger_v1.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
> index f9a50d7f0d20..aff81fef932f 100644
> --- a/net/ceph/messenger_v1.c
> +++ b/net/ceph/messenger_v1.c
> @@ -1160,15 +1160,17 @@ static int read_partial_message(struct ceph_conne=
ction *con)
>         /* header */
>         size =3D sizeof(con->v1.in_hdr);
>         end =3D size;
> -       ret =3D read_partial(con, end, size, &con->v1.in_hdr);
> -       if (ret <=3D 0)
> -               return ret;
> +       if (con->v1.in_base_pos < end) {
> +               ret =3D read_partial(con, end, size, &con->v1.in_hdr);
> +               if (ret <=3D 0)
> +                       return ret;
>
> -       crc =3D crc32c(0, &con->v1.in_hdr, offsetof(struct ceph_msg_heade=
r, crc));
> -       if (cpu_to_le32(crc) !=3D con->v1.in_hdr.crc) {
> -               pr_err("read_partial_message bad hdr crc %u !=3D expected=
 %u\n",
> -                      crc, con->v1.in_hdr.crc);
> -               return -EBADMSG;
> +               crc =3D crc32c(0, &con->v1.in_hdr, offsetof(struct ceph_m=
sg_header, crc));
> +               if (cpu_to_le32(crc) !=3D con->v1.in_hdr.crc) {
> +                       pr_err("read_partial_message bad hdr crc %u !=3D =
expected %u\n",
> +                              crc, con->v1.in_hdr.crc);
> +                       return -EBADMSG;
> +               }
>         }
>
>         front_len =3D le32_to_cpu(con->v1.in_hdr.front_len);
> --
> 2.43.0
>

Hi Xiubo,

This doesn't seem right to me.  read_partial() is supposed to be called
unconditionally.  On a short read (i.e. when it's unable to fill the
destination buffer -- in this case the header), it returns 0 and the
stack is supposed to unroll all the way up to ceph_con_workfn().

If the destination buffer is already filled, read_partial() does
nothing and returns 1.  Recomputing the header crc in case
read_partial_message() is called repeatedly shouldn't be an issue
because con->v1.in_hdr shouldn't be modified in the interim.  If it
gets modified, it's a bug.

It might help if you provide a step-by-step breakdown of the scenario
that you are trying to address in the commit message.

Thanks,

                Ilya

