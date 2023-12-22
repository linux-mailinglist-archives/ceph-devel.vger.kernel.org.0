Return-Path: <ceph-devel+bounces-432-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FC5181CB44
	for <lists+ceph-devel@lfdr.de>; Fri, 22 Dec 2023 15:24:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8D482B22A35
	for <lists+ceph-devel@lfdr.de>; Fri, 22 Dec 2023 14:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 387D81CF94;
	Fri, 22 Dec 2023 14:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fm47u5fN"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993411C28C;
	Fri, 22 Dec 2023 14:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-59451ae06c2so82015eaf.0;
        Fri, 22 Dec 2023 06:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703255044; x=1703859844; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8c4WNZaijmXKRlLKX7pGpzvJMEyW9eqKDX/0mcKSiOc=;
        b=Fm47u5fN3kETrQw3CQ1FPJ30hK64w/2m7NvVksOQA05aSB64YDL9731NFDMgUf691f
         nzyWEooSvRpqdCQArBD61rg1Q7Nrtg9aH0XD8h/6X6p84Yy7BrxEXIyB3ef2gOp006Fr
         gIhD5moaWJ6ArBR8zjRcpYf3AzkrZQ392t221Xo0hdna7a30qYVhBxX417gwI3tcBpg1
         DPpzwDrXUyFJhcWmqifABQ+YYoME0fwjia3LRI6yWllMdAXJtK2ryaGLk69EVdhQHOvd
         rB1zg58RBbRmIg89UJPLwN8EaJI0ZVL6MMl6+Jz2DvfrO+sa5no81eWOyeeAJJErcjg9
         yUlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703255044; x=1703859844;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8c4WNZaijmXKRlLKX7pGpzvJMEyW9eqKDX/0mcKSiOc=;
        b=l2Ob1AYFcnlpn/hHIcMS/ai16Op9Q+FPvE282eoD1/0kWljKhhgwwXnzGZvRZLghlx
         JLCCnasWMLdEsdGe+I3P2Mvy6bl2AH1IDvdkNB4Z6bHljgqDqanyhxKIaTJ2dzIY9SdI
         d9fTNPyZbtXl0OIVeGdTuLEFrFc09Q5EUxT6G9xuksF+/ZgplElroCU9722kzBEbWiUA
         4ltmP63z0Lf8tIg1iHgr5Cn027uu5xFMx3i+BAbpYW7078zatAMIEYCdRvFd6WbmjA66
         m3HWSQE1ubYp/ZlrX3kIOmvat4KkhlW5xWYvX/amg2XK1NP0rt8CTclKrnuaBtZboPM8
         pT2A==
X-Gm-Message-State: AOJu0Yy764L8jptVHl+HfANdVfjuXZYvpK7UaqwhGuW26bZ6539TlGRM
	synIzL2d+is9hw0qMk1tpR+ZNeawneMEPN4VkucTOKmQq8A=
X-Google-Smtp-Source: AGHT+IEmqFpr/BUReg0EvSg0e2Xig/tGMZW4bwrLVZSvf72XejZHbDjwoagPCaBJO2sXox3hGKEofjbaxKyhCNGCa14=
X-Received: by 2002:a05:6820:627:b0:594:1143:6903 with SMTP id
 e39-20020a056820062700b0059411436903mr1182628oow.13.1703255044413; Fri, 22
 Dec 2023 06:24:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231221133928.49824-1-dmantipov@yandex.ru>
In-Reply-To: <20231221133928.49824-1-dmantipov@yandex.ru>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Fri, 22 Dec 2023 15:23:52 +0100
Message-ID: <CAOi1vP9wHBG_g7mxZ4NoM5Y6b_xW-fRF6iUcvC_W3UcF3FbESA@mail.gmail.com>
Subject: Re: [PATCH] rbd: use check_sub_overflow() to limit the number of snapshots
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Dongsheng Yang <dongsheng.yang@easystack.cn>, ceph-devel@vger.kernel.org, 
	linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 21, 2023 at 2:40=E2=80=AFPM Dmitry Antipov <dmantipov@yandex.ru=
> wrote:
>
> When compiling with clang-18 and W=3D1, I've noticed the following
> warning:
>
> drivers/block/rbd.c:6093:17: warning: result of comparison of constant
> 2305843009213693948 with expression of type 'u32' (aka 'unsigned int')
> is always false [-Wtautological-constant-out-of-range-compare]
>  6093 |         if (snap_count > (SIZE_MAX - sizeof (struct ceph_snap_con=
text))
>       |             ~~~~~~~~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~
>  6094 |                                  / sizeof (u64)) {
>       |                                  ~~~~~~~~~~~~~~
>
> Since the plain check with '>' makes sense only if U32_MAX =3D=3D SIZE_MA=
X
> which is not true for the 64-bit kernel, prefer 'check_sub_overflow()'
> in 'rbd_dev_v2_snap_context()' and 'rbd_dev_ondisk_valid()' as well.
>
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>  drivers/block/rbd.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index a999b698b131..ef8e6fbc9a79 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -933,7 +933,7 @@ static bool rbd_image_format_valid(u32 image_format)
>
>  static bool rbd_dev_ondisk_valid(struct rbd_image_header_ondisk *ondisk)
>  {
> -       size_t size;
> +       size_t size, result;
>         u32 snap_count;
>
>         /* The header has to start with the magic rbd header text */
> @@ -956,7 +956,7 @@ static bool rbd_dev_ondisk_valid(struct rbd_image_hea=
der_ondisk *ondisk)
>          */
>         snap_count =3D le32_to_cpu(ondisk->snap_count);
>         size =3D SIZE_MAX - sizeof (struct ceph_snap_context);
> -       if (snap_count > size / sizeof (__le64))
> +       if (check_sub_overflow(size / sizeof(__le64), snap_count, &result=
))

Hi Dmitry,

There is a limit on the number of snapshots:

#define RBD_MAX_SNAP_COUNT      510     /* allows max snapc to fit in 4KB *=
/

It's not direct, but it's a hard limit, at least in the current
implementation.  Let's just replace these with direct comparisons for
RBD_MAX_SNAP_COUNT.

Thanks,

                Ilya

