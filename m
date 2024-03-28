Return-Path: <ceph-devel+bounces-1042-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 722D7890DDA
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Mar 2024 23:53:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AFF11C22F0B
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Mar 2024 22:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5039A51C43;
	Thu, 28 Mar 2024 22:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GjvVCqp+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7A2208CA
	for <ceph-devel@vger.kernel.org>; Thu, 28 Mar 2024 22:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711666431; cv=none; b=Fj4Y7VQT1JqKA3cy/QHkfFAIi6MNO0fYtNK9KLMHfJpcCZj3TLqaI3a96eBvifktK+3D/IG/NQACM3Lmyg0Df90klHuy/Xh41hDAniesuX9vZG+s1TDTZjUsiG6gjzhXIpe9eMXyPNLZA2foVys9rrwLkaRoY3OpEGNVarcS9rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711666431; c=relaxed/simple;
	bh=m2sHr69UQ23/+yNNagVCVSd+tL9gNcumuplvgXMM3eE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hTFag5MzTXrx3Z3juj6KBCgaNHvDouFmu3KSBKdPSWjvZkXtNUtx8hvNnrJ4p64pDoqrLTqTXffISDPq9Mcw5U8n0JS1r2D+oBEHesuUDi9FKloR39/9Qxh42e5X4mqybxXKDgJoboLaimWlboXLz1xE2KsO0Dfi5YaiaTfjGMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GjvVCqp+; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-55a179f5fa1so1834836a12.0
        for <ceph-devel@vger.kernel.org>; Thu, 28 Mar 2024 15:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711666428; x=1712271228; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TEbIDW7kbPaE87dBPORDU/rsnpNPLPoHlh1VVnWn9NA=;
        b=GjvVCqp+UrkJj/Q1BkHxcMX1d1B0WrYzJZU4b12Im5rjUMSk/I1e59Gl2QrWEdObM3
         WVc/EDOfGYTRdrVD47dbkVYM7MuIf37jur8eZgPmL+8hG7PgTYwfXzifmBWzk8lveWAu
         pL0hI0UrIrSW/nh8lmgfAbsXzygVZWxD4TtHdgZcC4pdTnUigPdjglq+uAMNxGA2jvri
         K6tZOk2oF/XSN3H5BV90vwHs0JQbplddepfes2CCS4QTGh07WMaBJrLApLTdwTjGhLPZ
         EGKKa3bVP2Cb8BAMFjmMMbQTMCoCKjcFvd0keKtBzIICixLNsRrR6gCAEJa8cbc6+Mid
         zDzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711666428; x=1712271228;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TEbIDW7kbPaE87dBPORDU/rsnpNPLPoHlh1VVnWn9NA=;
        b=KjpeiGRlMaZPgI/lYogJw7WvjHrMnNUFFYzVpupv1mFlGZLQqYFEtMd4yr859FkMwC
         iHQVTu1TBhOYH/UYH7IWON4UPU3NQHsMwgRMwODgUNPQPGWMo6JqnirKcsrML1+r2mYW
         RhcJfapFwPpdLpxMOHgPV15Vw0+iYigQ6KxwnvpOz9+lRdubYBQS+7ccV1nRRV5Tyjr3
         GygZoDaquCAr8I7tOKK/nPmDU0tQ8y2xkdxr2e5/hnErp5YRtx9XnZo+B9je990use5u
         t1GPS62QpTz/9qelr/1a1DfFvsG5IfnKBr0iGXu2LKd8NZd2jPWT8fdIWD0NWunBwEX4
         YqTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBjaxx3JIWuoxjLwan3DpdR05ZvjX8rRwCkEhgFDaA3Zblr8KMZQqbrVU0i9k5I4p1ASmGZBJhuknqQRpGTkG2Cri7Zdui9KuC2g==
X-Gm-Message-State: AOJu0Yyb0oY6aVfCZJqLywjbv4S+UaviyxYavK0nYVTC2n9FMGl/zVsl
	4ho/AQmQ4SfiLFpKvrFHPTYzVFDo75co+1cFvtqxacYSmpJ+PC5ogafawQ8ffc6xmmrrHpdCHzl
	T/ykEDFYNs4DDLEzIEgJuDV/sq4d14dJhkzcV
X-Google-Smtp-Source: AGHT+IHSOF7Jz1HlwWi9ZnZS4sDGFwM0sUVO6wKPz80s3bzKUakcomIa558eS7Mlmg+NfUj6hjAXDu38td4y54TNQ6s=
X-Received: by 2002:a05:6402:254a:b0:56b:e089:56ed with SMTP id
 l10-20020a056402254a00b0056be08956edmr540944edb.39.1711666427673; Thu, 28 Mar
 2024 15:53:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240328143051.1069575-1-arnd@kernel.org> <20240328143051.1069575-3-arnd@kernel.org>
In-Reply-To: <20240328143051.1069575-3-arnd@kernel.org>
From: Justin Stitt <justinstitt@google.com>
Date: Thu, 28 Mar 2024 15:53:35 -0700
Message-ID: <CAFhGd8rCzhqK18KLtLVLWyWHtQzJsHCkkkQQyLbmw83K6ExKkw@mail.gmail.com>
Subject: Re: [PATCH 2/9] libceph: avoid clang out-of-range warning
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-kernel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>, 
	Ilya Dryomov <idryomov@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Nathan Chancellor <nathan@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Jeff Layton <jlayton@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Milind Changire <mchangir@redhat.com>, Patrick Donnelly <pdonnell@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, ceph-devel@vger.kernel.org, netdev@vger.kernel.org, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 28, 2024 at 7:31=E2=80=AFAM Arnd Bergmann <arnd@kernel.org> wro=
te:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> clang-14 points out that on 64-bit architectures, a u32
> is never larger than constant based on SIZE_MAX:
>
> net/ceph/osdmap.c:1425:10: error: result of comparison of constant 461168=
6018427387891 with expression of type 'u32' (aka 'unsigned int') is always =
false [-Werror,-Wtautological-constant-out-of-range-compare]
>         if (len > (SIZE_MAX - sizeof(*pg)) / sizeof(u32))
>             ~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> net/ceph/osdmap.c:1608:10: error: result of comparison of constant 230584=
3009213693945 with expression of type 'u32' (aka 'unsigned int') is always =
false [-Werror,-Wtautological-constant-out-of-range-compare]
>         if (len > (SIZE_MAX - sizeof(*pg)) / (2 * sizeof(u32)))
>             ~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> The code is correct anyway, so just shut up that warning.

OK.

>
> Fixes: 6f428df47dae ("libceph: pg_upmap[_items] infrastructure")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Justin Stitt <justinstitt@google.com>

> ---
>  fs/ceph/snap.c    | 2 +-
>  net/ceph/osdmap.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index c65f2b202b2b..521507ea8260 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -374,7 +374,7 @@ static int build_snap_context(struct ceph_mds_client =
*mdsc,
>
>         /* alloc new snap context */
>         err =3D -ENOMEM;
> -       if (num > (SIZE_MAX - sizeof(*snapc)) / sizeof(u64))
> +       if ((size_t)num > (SIZE_MAX - sizeof(*snapc)) / sizeof(u64))
>                 goto fail;
>         snapc =3D ceph_create_snap_context(num, GFP_NOFS);
>         if (!snapc)
> diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
> index 295098873861..8e7cb2fde6f1 100644
> --- a/net/ceph/osdmap.c
> +++ b/net/ceph/osdmap.c
> @@ -1438,7 +1438,7 @@ static struct ceph_pg_mapping *__decode_pg_temp(voi=
d **p, void *end,
>         ceph_decode_32_safe(p, end, len, e_inval);
>         if (len =3D=3D 0 && incremental)
>                 return NULL;    /* new_pg_temp: [] to remove */
> -       if (len > (SIZE_MAX - sizeof(*pg)) / sizeof(u32))
> +       if ((size_t)len > (SIZE_MAX - sizeof(*pg)) / sizeof(u32))
>                 return ERR_PTR(-EINVAL);
>
>         ceph_decode_need(p, end, len * sizeof(u32), e_inval);
> @@ -1621,7 +1621,7 @@ static struct ceph_pg_mapping *__decode_pg_upmap_it=
ems(void **p, void *end,
>         u32 len, i;
>
>         ceph_decode_32_safe(p, end, len, e_inval);
> -       if (len > (SIZE_MAX - sizeof(*pg)) / (2 * sizeof(u32)))
> +       if ((size_t)len > (SIZE_MAX - sizeof(*pg)) / (2 * sizeof(u32)))
>                 return ERR_PTR(-EINVAL);
>
>         ceph_decode_need(p, end, 2 * len * sizeof(u32), e_inval);
> --
> 2.39.2
>

