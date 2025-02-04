Return-Path: <ceph-devel+bounces-2632-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8803A27CA0
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Feb 2025 21:16:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31E9B16479A
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Feb 2025 20:16:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8BB1217645;
	Tue,  4 Feb 2025 20:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BJnihFuD"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD8120CCE5;
	Tue,  4 Feb 2025 20:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738700188; cv=none; b=uGJ7HzbnsP9Z3oza309TOC9ILeBvHZAnP0JGRKDHOq9YD+A3tg4du8ktjkylps7GRztGgoFfVaud5rnaeeiSzo2ckFkCCYd0qdbmS2o0FCEYSxpUhj/tu9B3Hll3bdfVCRXBzoSsvgbBHlmL69x6KACG9PF39JsI6CVloF9E8fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738700188; c=relaxed/simple;
	bh=6wdnt7/tCB7Z+FEpJBvdjTgNT/tgL4QV69RxqpyEVhw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QFFzOJH7R70yqSO8++U1HE8v4T/20DKHdCXSL1Oo3m2GRunVkzZBkk+qzi5xzjxBrJBvEx6nAEZrLXFeiZD/5bUyOwkW7alY9viWf3pDIlB/rnsoWzzkrHMSg6Uu2Z+hmy90mORyvyLbucEbXwrNbnq6wVaimRGX0TCNfZjkw0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BJnihFuD; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-21619108a6bso102004765ad.3;
        Tue, 04 Feb 2025 12:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738700186; x=1739304986; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KR/DuzPu4L6UmQMWZ9c+c7Q6VILPpItJGIL+ba1HmaQ=;
        b=BJnihFuDJJORzwsj+PJa0Xv1wlYj6M31koYdlnbWmpMYDgepEo4lY1ed3nGUfyPm19
         rXL3p75yLEcd6U0MeJpUJk1l5gKfJ9sJqzV37CsM3lFYTlydSQv/PHtGTnqwY94RMRMv
         x+g2/N+Rb1/Lgv+x7B/MGNTByobc1tNUgROTHAOvJpIBdX0D5NCGGPD4yxXbRc8ptQuC
         YP7U5yJVr7w0mE9M0P68zY7U0YHSKBnBrlARm0l9gDzQeIcN7LH7lqkk23npnrF2AcI3
         71ArxO6tdtg4ENKu0jwkV7yXagFjKErqqgsuGa7cUpY/kD8WheaDeLGeIP13OY5Nz4vI
         UGxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738700186; x=1739304986;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KR/DuzPu4L6UmQMWZ9c+c7Q6VILPpItJGIL+ba1HmaQ=;
        b=BXIfsbXEr0S6nLFinxiZEGfjq0ny1DSN8ACbQBNcKA/fezjmr48PpyoTUGk3AQ/JaW
         mMzk5nYo3sDfm/kOSDeo3VB2JlIUwJRvKyoaaNE/8KpvZZxFKHqwbpT/ud8sWKmG2BAS
         os1g+4VpWU5g3f1Z9T+ibnD7teHq9lMUnlHR/X9unbWoHZQPgQQAaXznXTBsCBaeJ4/9
         NJWAY0YgL3CbMrd3k2TB2QWIb5p/voKHuW5+TW7ptD90NT6RVJHF+0o+ASO8z5/t7XMz
         F7pWJDEyIxxNSx3dUKmFhkvx5UNOs9VmyuDF1kWbYpbvd0CxA781cFHXqv71fivDziqv
         i0CA==
X-Forwarded-Encrypted: i=1; AJvYcCUov4hzFw+xGSDMELOaOeM24dSCYkeUYAekFSFL6gMB/EbPCFU2QHj7CfXv2NbJDMftZQCB+4TE6EGbfErr@vger.kernel.org, AJvYcCWFg4i6SjZGNdfhW+qEpKVAIBGcGdx87DFDZ3JuoKmuJKok8RRJVHsrF3z8N07rkE56Nvi4gDgLozlcb0Y=@vger.kernel.org, AJvYcCXVdNvc3Br4fk+SdTQdtiXyKXFmuf4vbWvfNXMEIwfqvg0vsxwghLoFx9THesXH0+VcvF03qRDYWzdm@vger.kernel.org
X-Gm-Message-State: AOJu0Yx15+jM1Bg2i0H9fVcO+HIp9niyFs2XwsI10wA+kC/hoZFwI8x5
	mQDHI+wyqAD11hzDPARoMfA020TFnCgiZK9jI9X/bDs9YtdQQAstRk10ibFdCg6yBA/s+rBhiVI
	HAcob7ULOJG5DZYEGhtNAwFNhF04=
X-Gm-Gg: ASbGnctVDOZXrKftXE5+gwPtfU9H4osGPurhxnFeB7cf8BL0ez2dVXgMNnw7ziGlfPY
	mba4K5GwfYvFBRbXBmIAPjxZRmt8W9UbWzW88y+m14ytw1vHFpLeleolfZGR42k6RSWAlztvz
X-Google-Smtp-Source: AGHT+IGMRCnWUgk4azvsM8AKV6n66tF8jJ5hJc5CJaJ9hjxGDmkew2CZ3MuiAN64LXIAW7Ct2k1pbf+SLC7mYsM4D9w=
X-Received: by 2002:a17:902:e54c:b0:215:a04a:89d5 with SMTP id
 d9443c01a7336-21f17df58famr2631635ad.2.1738700185995; Tue, 04 Feb 2025
 12:16:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250203-converge-secs-to-jiffies-part-two-v2-0-d7058a01fd0e@linux.microsoft.com>
 <20250203-converge-secs-to-jiffies-part-two-v2-3-d7058a01fd0e@linux.microsoft.com>
In-Reply-To: <20250203-converge-secs-to-jiffies-part-two-v2-3-d7058a01fd0e@linux.microsoft.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 4 Feb 2025 21:16:13 +0100
X-Gm-Features: AWEUYZltcKp5HWPVuFiXXXLg5FCvpTOIVUsJwjijbmOSBWMbuaFjZjJQs9hspCs
Message-ID: <CAOi1vP9P7c37aGWOXCojBM+eQZ8eQLpHPQK_t2sO=SR53EboKA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] libceph: convert timeouts to secs_to_jiffies()
To: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <Julia.Lawall@inria.fr>, 
	Nicolas Palix <nicolas.palix@imag.fr>, Dongsheng Yang <dongsheng.yang@easystack.cn>, 
	Jens Axboe <axboe@kernel.dk>, Xiubo Li <xiubli@redhat.com>, cocci@inria.fr, 
	linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 4, 2025 at 12:50=E2=80=AFAM Easwar Hariharan
<eahariha@linux.microsoft.com> wrote:
>
> Commit b35108a51cf7 ("jiffies: Define secs_to_jiffies()") introduced
> secs_to_jiffies().  As the value here is a multiple of 1000, use
> secs_to_jiffies() instead of msecs_to_jiffies to avoid the multiplication=
.
>
> This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci wit=
h
> the following Coccinelle rules:
>
> @depends on patch@ expression E; @@
>
> -msecs_to_jiffies(E * 1000)
> +secs_to_jiffies(E)
>
> @depends on patch@ expression E; @@
>
> -msecs_to_jiffies(E * MSEC_PER_SEC)
> +secs_to_jiffies(E)
>
> While here, remove the no-longer necessary checks for range since there's
> no multiplication involved.
>
> Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
> ---
>  include/linux/ceph/libceph.h | 12 ++++++------
>  net/ceph/ceph_common.c       | 18 ++++++------------
>  net/ceph/osd_client.c        |  3 +--
>  3 files changed, 13 insertions(+), 20 deletions(-)
>
> diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> index 733e7f93db66a7a29a4a8eba97e9ebf2c49da1f9..5f57128ef0c7d018341c15cc5=
9288aa47edec646 100644
> --- a/include/linux/ceph/libceph.h
> +++ b/include/linux/ceph/libceph.h
> @@ -72,15 +72,15 @@ struct ceph_options {
>  /*
>   * defaults
>   */
> -#define CEPH_MOUNT_TIMEOUT_DEFAULT     msecs_to_jiffies(60 * 1000)
> -#define CEPH_OSD_KEEPALIVE_DEFAULT     msecs_to_jiffies(5 * 1000)
> -#define CEPH_OSD_IDLE_TTL_DEFAULT      msecs_to_jiffies(60 * 1000)
> +#define CEPH_MOUNT_TIMEOUT_DEFAULT     secs_to_jiffies(60)
> +#define CEPH_OSD_KEEPALIVE_DEFAULT     secs_to_jiffies(5)
> +#define CEPH_OSD_IDLE_TTL_DEFAULT      secs_to_jiffies(60)
>  #define CEPH_OSD_REQUEST_TIMEOUT_DEFAULT 0  /* no timeout */
>  #define CEPH_READ_FROM_REPLICA_DEFAULT 0  /* read from primary */
>
> -#define CEPH_MONC_HUNT_INTERVAL                msecs_to_jiffies(3 * 1000=
)
> -#define CEPH_MONC_PING_INTERVAL                msecs_to_jiffies(10 * 100=
0)
> -#define CEPH_MONC_PING_TIMEOUT         msecs_to_jiffies(30 * 1000)
> +#define CEPH_MONC_HUNT_INTERVAL                secs_to_jiffies(3)
> +#define CEPH_MONC_PING_INTERVAL                secs_to_jiffies(10)
> +#define CEPH_MONC_PING_TIMEOUT         secs_to_jiffies(30)
>  #define CEPH_MONC_HUNT_BACKOFF         2
>  #define CEPH_MONC_HUNT_MAX_MULT                10
>
> diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> index 4c6441536d55b6323f4b9d93b5d4837cd4ec880c..c2a2c3bcc4e91a628c99bd1ce=
f1211d54389efa2 100644
> --- a/net/ceph/ceph_common.c
> +++ b/net/ceph/ceph_common.c
> @@ -527,29 +527,23 @@ int ceph_parse_param(struct fs_parameter *param, st=
ruct ceph_options *opt,
>
>         case Opt_osdkeepalivetimeout:
>                 /* 0 isn't well defined right now, reject it */
> -               if (result.uint_32 < 1 || result.uint_32 > INT_MAX / 1000=
)
> +               if (result.uint_32 < 1)
>                         goto out_of_range;
> -               opt->osd_keepalive_timeout =3D
> -                   msecs_to_jiffies(result.uint_32 * 1000);
> +               opt->osd_keepalive_timeout =3D secs_to_jiffies(result.uin=
t_32);
>                 break;
>         case Opt_osd_idle_ttl:
>                 /* 0 isn't well defined right now, reject it */
> -               if (result.uint_32 < 1 || result.uint_32 > INT_MAX / 1000=
)
> +               if (result.uint_32 < 1)
>                         goto out_of_range;
> -               opt->osd_idle_ttl =3D msecs_to_jiffies(result.uint_32 * 1=
000);
> +               opt->osd_idle_ttl =3D secs_to_jiffies(result.uint_32);
>                 break;
>         case Opt_mount_timeout:
>                 /* 0 is "wait forever" (i.e. infinite timeout) */
> -               if (result.uint_32 > INT_MAX / 1000)
> -                       goto out_of_range;
> -               opt->mount_timeout =3D msecs_to_jiffies(result.uint_32 * =
1000);
> +               opt->mount_timeout =3D secs_to_jiffies(result.uint_32);
>                 break;
>         case Opt_osd_request_timeout:
>                 /* 0 is "wait forever" (i.e. infinite timeout) */
> -               if (result.uint_32 > INT_MAX / 1000)
> -                       goto out_of_range;
> -               opt->osd_request_timeout =3D
> -                   msecs_to_jiffies(result.uint_32 * 1000);
> +               opt->osd_request_timeout =3D secs_to_jiffies(result.uint_=
32);
>                 break;
>
>         case Opt_share:
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index b24afec241382b60d775dd12a6561fa23a7eca45..ba61a48b4388c2eceb5b7a299=
906e7f90191dd5d 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -4989,8 +4989,7 @@ int ceph_osdc_notify(struct ceph_osd_client *osdc,
>         linger_submit(lreq);
>         ret =3D linger_reg_commit_wait(lreq);
>         if (!ret)
> -               ret =3D linger_notify_finish_wait(lreq,
> -                                msecs_to_jiffies(2 * timeout * MSEC_PER_=
SEC));
> +               ret =3D linger_notify_finish_wait(lreq, secs_to_jiffies(2=
 * timeout));
>         else
>                 dout("lreq %p failed to initiate notify %d\n", lreq, ret)=
;
>
>
> --
> 2.43.0
>

Acked-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya

