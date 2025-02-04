Return-Path: <ceph-devel+bounces-2631-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 67460A27C9B
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Feb 2025 21:16:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27E761886775
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Feb 2025 20:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9688217645;
	Tue,  4 Feb 2025 20:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f2Al9XE6"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C573204589;
	Tue,  4 Feb 2025 20:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738700159; cv=none; b=ugn+O9QZMpucRoULPueldHvp+1aHp0diBvSoeaJwrbLtmlZhh+7+SO+ULdjs5Ay7z7vhukaVYrHyyS9rvKQSmBr7Ioo6gUrKRHRh6iXP41zsfG5bjXTXlI2mtdlX9XcQlwwp5z7tDT7RCMgP0BbYfqYXSEVb9SzmB+rotvP7nj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738700159; c=relaxed/simple;
	bh=hcpGyDqUv/eSlKfr3GPwEttx+UOda14QMrCSTb26h48=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fyuj/jRl3l88I72y1kBW8JNWHUddNZOhOWg/gpDfRt8VOkKmNtWj+C/7nVdR4c++uuIen6kcLxvjCMlbaK6zA9QZEYkSA6OVSRodsmDkgkN9xLfjnHinf8Yihzhf4J+ve6SFBInCX7AIHlYsx/0wpvNSBHXPSCzKWMD1oocSq7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f2Al9XE6; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2f9d17ac130so1102364a91.3;
        Tue, 04 Feb 2025 12:15:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738700157; x=1739304957; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HDo14UWXJJhikq+DLyV4VOaNI1GvjMImjjxkh0rzydg=;
        b=f2Al9XE65iFejgX1zoaw3D08ZHyGN+XhU5YW1YzF8s9NNAz1DUpCN5NG0natGLpngH
         wJ+R08gBP2oOSuouyGyj/CB76Soze5pXGfDIlr4x2whHJy27V2CoZLGodXuVhhT4Ccsa
         o5l/NA5/ZDR5R0jWVGrKOo28KNvKEmzUSbmCFwtISi5sBJFm39hkqsF4vc2IPveD28os
         kMeIDdddTvAJeqHPMK9CYoR8EzsQTW14qbA+0Ke+NkPlahsQXHfR7JMTg6OnH1DN80AW
         WjNgY4nW/fkimFS6h9goYcMSn3QGWToN/eKRWdzPqgVn1jOhFNpBoI0UBfQ2e+gGEhsu
         2Wug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738700157; x=1739304957;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HDo14UWXJJhikq+DLyV4VOaNI1GvjMImjjxkh0rzydg=;
        b=ni9Gwm+oCTiWOiWONpYWc0Rh2wTX5YE+SKDSvmZuu/qO9rg+GIcfVIOCTjue+NuOUb
         bwTMHtdYQxdds/8K8nocVLtRxPkdJfL3SwevO93Zfw2THKM0zIUeuxnKaYboqCS8Ra6A
         SK78Iw8zgLZJGoP51pBqmjyrdTczT7k6o6jbolsNo/XRs8q2qzGnoub617/4AxCUK/LM
         gUHGjvjXyAQ/WH+X2DZFV2FcmjJhrl1SoASKvCwBREmPJrOxieV+IheOWrOfkpPORPjV
         Fx28/9+xlBDtRGjHoIc8X/UVsNh4hyOgCMb/k6lbUzvNo3UyiFMnx4ajI/H4AfZn4kNs
         7y0w==
X-Forwarded-Encrypted: i=1; AJvYcCWpxiaBivGTfPA4QvVrXgK3lhWp2qiu95g/1uwfX/20ylg9OeiPBajX+eWKRwWP8buqElIK6H2FBorS3Zg=@vger.kernel.org, AJvYcCX297pxyVlxtWJQ9YbIWOL+ETgcpwTPsrRwlp/qY6gSA8VMn8HoxqymsKcAhMFOeZ+j0t6Dc+tUEAXf409Q@vger.kernel.org, AJvYcCX5LN3pDtgEdCL6vIGVOKsjmWzoq4WxOb4I4GAmT0JTHUCEcXIhFgjdcVuDKfVJEYjybfVKrMX30GGd@vger.kernel.org
X-Gm-Message-State: AOJu0YzF4IhyxH5WiJEKmA0TiwtTdhDHgo8mIYez0IRLZlQ+Yj9I9DUZ
	2CXWRcWPyUI1JQ8BmL58aFFH6AxNZRv9KDL9ZKBmmmgs/FGP7GUj1xYZTpIFAt6utc8YvU28gwV
	kq6zNilHwjSDzws3kp2D814oZTqQ=
X-Gm-Gg: ASbGncv0rXc7ZUSzrWk6mCpOxRiPPAKWAEpWKmxknPP7OZ5UhsZcZva7ljU66iD2+oI
	tKVtYmdMyu0iIii1K/2SUzT2iFmqBSUf1mOT/NOhAewVUfW6eT4iuIGmY5qouEON0J2cQbQ80
X-Google-Smtp-Source: AGHT+IFpUn4ty+hTBTAscWBy/P6n51/jgfEImKVtStudLd6LSKIl/9ac2I1XNzbeRalZoB0WUHUyHWRLIpYi1FKnBlE=
X-Received: by 2002:a17:90b:5289:b0:2ee:8008:b583 with SMTP id
 98e67ed59e1d1-2f9e0792e11mr153173a91.16.1738700156925; Tue, 04 Feb 2025
 12:15:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250203-converge-secs-to-jiffies-part-two-v2-0-d7058a01fd0e@linux.microsoft.com>
 <20250203-converge-secs-to-jiffies-part-two-v2-2-d7058a01fd0e@linux.microsoft.com>
In-Reply-To: <20250203-converge-secs-to-jiffies-part-two-v2-2-d7058a01fd0e@linux.microsoft.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 4 Feb 2025 21:15:45 +0100
X-Gm-Features: AWEUYZmez9Mpz0-SYRI0bR38UXb1Ekbuss658D4anHnBb41KwIIcd5IfJG1eviU
Message-ID: <CAOi1vP8djn-cpTMv+qVO4-cK9GD7vousoNEg8hOQ2fTU5t+NOg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] rbd: convert timeouts to secs_to_jiffies()
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
> While here, remove the no-longer necessary check for range since there's
> no multiplication involved.
>
> Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
> ---
>  drivers/block/rbd.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index faafd7ff43d6ef53110ab3663cc7ac322214cc8c..41207133e21e9203192adf3b9=
2390818e8fa5a58 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -108,7 +108,7 @@ static int atomic_dec_return_safe(atomic_t *v)
>  #define RBD_OBJ_PREFIX_LEN_MAX 64
>
>  #define RBD_NOTIFY_TIMEOUT     5       /* seconds */
> -#define RBD_RETRY_DELAY                msecs_to_jiffies(1000)
> +#define RBD_RETRY_DELAY                secs_to_jiffies(1)
>
>  /* Feature bits */
>
> @@ -4162,7 +4162,7 @@ static void rbd_acquire_lock(struct work_struct *wo=
rk)
>                 dout("%s rbd_dev %p requeuing lock_dwork\n", __func__,
>                      rbd_dev);
>                 mod_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork,
> -                   msecs_to_jiffies(2 * RBD_NOTIFY_TIMEOUT * MSEC_PER_SE=
C));
> +                   secs_to_jiffies(2 * RBD_NOTIFY_TIMEOUT));
>         }
>  }
>
> @@ -6283,9 +6283,7 @@ static int rbd_parse_param(struct fs_parameter *par=
am,
>                 break;
>         case Opt_lock_timeout:
>                 /* 0 is "wait forever" (i.e. infinite timeout) */
> -               if (result.uint_32 > INT_MAX / 1000)
> -                       goto out_of_range;
> -               opt->lock_timeout =3D msecs_to_jiffies(result.uint_32 * 1=
000);
> +               opt->lock_timeout =3D secs_to_jiffies(result.uint_32);
>                 break;
>         case Opt_pool_ns:
>                 kfree(pctx->spec->pool_ns);
>
> --
> 2.43.0
>

Acked-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya

