Return-Path: <ceph-devel+bounces-1859-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 454F598ABA9
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Sep 2024 20:09:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE0E5283834
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Sep 2024 18:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26338198E77;
	Mon, 30 Sep 2024 18:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kl2aoY1Q"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C72F192D7F;
	Mon, 30 Sep 2024 18:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727719760; cv=none; b=cAr28Hq05NcETnPhWYQPh6cG9hh9mS+gVuVJipGY8OFF1s9Az74C2d4Pt1Z9mZJ2i0YORupBUlOOViVfIM4WnMNS83di/posllsydUr26FrGn7r+NRpvkHLOAyP29Na+3hel+iR5Q6cPK+7AMqSOsOXWh6qepG9BhAkptjadxrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727719760; c=relaxed/simple;
	bh=iDVMlPhvSyC8aDz+QP9lfgkSrj0TyoQwJsbyx9OLZG0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PaqCAC1qBl8OzMHejS3IdhOcVUPOSSFOiUAKMXQK3gZXOSC1PS310Wyqv+J7Tbw64sqkzn/PvAXZlAB6pHZ3B6qtsjJjKwxHzSxd0IjvDkyVDNSl5EJbDpwApYhf1uTLMdHIK+P9b0TItbX8CuONxd3fLak5P5oQCnoTNm9LtGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kl2aoY1Q; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3e03a5ed4d7so2444570b6e.1;
        Mon, 30 Sep 2024 11:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727719758; x=1728324558; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1xn/A8bwzO7MBrq+CmhDCgTc2Fwd90kZtHzG93XkpEA=;
        b=kl2aoY1Q5gqrRCZfeOpWBc1nOj4XPiph+/5+/z+xP+8ag2W/GYf0xd5Kw3KRtvJxCL
         C9Tbsx0Qgc897ycZPogd34fau1nx98lHzQWd7WyIB708b5I72UyP7WAVBZWtRFnkB3rK
         PWeH0Xb0vFlu/kOpDYpa1pGY4qEhtYggON1Wz2p9kIB+8Rag29O+kAPpOSAg8uWuaGWr
         Wu/Thy6+SJzBrtqUY/yM+fRct9SqepoSCvHIM7Qa95IMSRq75kKhqFbe25IVUnfl/BDQ
         qkshyQaRxxpDaE1/kqQBFWWDLnBa5Puja0UYigDz0B9IsMqt4NdLfhGJusmaf11WAIae
         xBrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727719758; x=1728324558;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1xn/A8bwzO7MBrq+CmhDCgTc2Fwd90kZtHzG93XkpEA=;
        b=BPvPHIz9XuLIeWXiKRiczQWDjOZi1ABKKTEOf9ns/+pOU/hg/ccO7Yd7TwSz89XJx9
         duZhAFjMCX52EKBWFn0ip19uoNG4+BpmRjIj9oQQmjxOoBd2STir5qdFMI7aJkcX8yzI
         IIBvniznqbxq8Y1ow2HPJXrQ6rh8xyuMRbyWAszgNdJEb7NXocVazFBEN/4evW009UP0
         LnUXket3yEqagdn6GiODmvJ0MZUWWlR+zk5m7CXsQ+Cr+E83TlVWJInEpvXL/JgAR+oP
         xWEo58FJ7tmcB0v7bIMxrjqwksA3JZnkneAc3LQqouEq9QWzdKSOaJNhBJ99EY5zsGv0
         H5ug==
X-Forwarded-Encrypted: i=1; AJvYcCUNfMrU4skXX8O2HAK8QQuoJnaijike8SpCNFlStZVO1NuCgQ/kX5epV1yofXLCgHDIClWZyeXavpaM@vger.kernel.org, AJvYcCVXjKojHodKjHUUqtdKNoja3yqliY6qPe+UQNPHZWta9ouP+1snnzMze/59y/sx6e/jgumD+sOkhx/FZ/Pf@vger.kernel.org
X-Gm-Message-State: AOJu0Ywncf1v9hsX1DM8MQpjvbLgx5PSIGXCjXqYCB+4XXi5pmn2JBQK
	V88jWK6QK4/nl3ffgcjK9klbakrSxxxLdoD9FbPJypgvqYcOv05Bj0pTHVnpN8lAh8c6DCV1p3V
	qpp2sMKEj8pMXfdJUDwitHPV+L/I=
X-Google-Smtp-Source: AGHT+IFK+sgS7rJjHT4JmP4KrvFnACsWw4V1/xwvMVkBRq6nQAEM2hOEAGp7ta7mwf+TKwuP5NCyZaOR07eNe/KBZ/Y=
X-Received: by 2002:a05:6870:5b88:b0:261:1f7d:cf6e with SMTP id
 586e51a60fabf-28710c45c43mr7339001fac.41.1727719758592; Mon, 30 Sep 2024
 11:09:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240912153924.78724-1-thorsten.blum@toblux.com>
In-Reply-To: <20240912153924.78724-1-thorsten.blum@toblux.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 30 Sep 2024 20:09:06 +0200
Message-ID: <CAOi1vP_1jRDmkQBH4BaxicTyYXtTJVjLXQb9T_XCmvUm7qTf0A@mail.gmail.com>
Subject: Re: [PATCH] ceph: Use struct_size() helper
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: xiubli@redhat.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 12, 2024 at 5:39=E2=80=AFPM Thorsten Blum <thorsten.blum@toblux=
.com> wrote:
>
> Use struct_size() to calculate the number of bytes to be allocated.
>
> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
> ---
>  fs/ceph/addr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index c4744a02db75..ab494f250d80 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -2133,7 +2133,7 @@ static int __ceph_pool_perm_get(struct ceph_inode_i=
nfo *ci,
>         }
>
>         pool_ns_len =3D pool_ns ? pool_ns->len : 0;
> -       perm =3D kmalloc(sizeof(*perm) + pool_ns_len + 1, GFP_NOFS);
> +       perm =3D kmalloc(struct_size(perm, pool_ns, pool_ns_len + 1), GFP=
_NOFS);
>         if (!perm) {
>                 err =3D -ENOMEM;
>                 goto out_unlock;
> --
> 2.46.0
>

Applied.

Thanks,

                Ilya

