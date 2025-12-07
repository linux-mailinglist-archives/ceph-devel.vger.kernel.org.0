Return-Path: <ceph-devel+bounces-4165-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4388CCAB810
	for <lists+ceph-devel@lfdr.de>; Sun, 07 Dec 2025 18:04:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6AACE300091A
	for <lists+ceph-devel@lfdr.de>; Sun,  7 Dec 2025 17:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C9E41E0E14;
	Sun,  7 Dec 2025 17:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZZ20i9Hn"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBA11E4AB
	for <ceph-devel@vger.kernel.org>; Sun,  7 Dec 2025 17:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765127032; cv=none; b=G4XgfMgQtKFGLBmRdTQOjpPzXFAwk9fprh+2UyOC3IQ5YxRpfdf7DUgxsBLJRD41/IVoeZxUhtary+dXxffhl7UnOKSNag1Z5iBK4Ov6agjEFlbbrQn3KfdXQUUzo+RByfbTOxlHvdXRyy3yWyRwF0VWpfFiv8HlzolLoer9/3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765127032; c=relaxed/simple;
	bh=aQzEIku8JROiflhaigqe1aRWbUy/k3+NLNX2vfeNg9Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VKTzGIlCoMmVgAzPlJFpdboew13w9n+BGMDDpI1+knzVGbB8t6/mJ7wYNOTZ0Ng+rHG8ZiU6ofi6oJ+TNZVTkIG6woxgu0sBvPhtz3o1xNVvyB5HKL7yKZLHZdf71oy+TnV9BnKKZk3ru42wHARSxkWkGH/JRjBLx+c14zZIy2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZZ20i9Hn; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2984dfae043so37306815ad.0
        for <ceph-devel@vger.kernel.org>; Sun, 07 Dec 2025 09:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765127031; x=1765731831; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oAbPbCNzWQWt8AavbFn8WrJJj79RyGuVnTywYHA2ubU=;
        b=ZZ20i9Hnz3usATJaHw2YSxSk1DXl/eFvD/kgoNvOiLBVy/PfQh0YwZvoTQGvDBjJjI
         ChQXeElcxdsiWkC3HOBKb3B0BuAs/FIo1TxoVD3pod3pzunyBO0KYk4xfq8lETbbKbqF
         MBFYvK3tC8emcWHXehHZ9o1HQHaT5Ymrxa5wfTCuWqA9qSi9bTdLcVgHc+GhQag3KQmy
         /gSpz+amdvb6eRJA3r7UqvKkmv0smT/UlpcxoVHxM1sdpxc/pzeV9oYCFcJUXykf0EFD
         lPkuUkShImwNLdsBNSsmXkhuT4qH65JCBFhbET4UQejoVhkZ1WMkycNJMvmz15qx91BP
         X14A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765127031; x=1765731831;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oAbPbCNzWQWt8AavbFn8WrJJj79RyGuVnTywYHA2ubU=;
        b=EXhklroprhDdv6Wob0/noU/wzf99sfkWe5Rfv1x5OTOWIU8zkyD9GosxztR52SJsiW
         BYfZ5jHwUkhf9onbVjBeTSx0pOKQJdvjeuPXwW/gqcDFDVgoHLBwb7p0VDzanTX7VJcX
         /quRdIshNFiJxExBo2KXnmNGwfzQCapJsC3VzJbQCpuQWlEtOyJGX5RKJScDACdxyory
         kZ8FjEEyeJKxz/PA0mfq1eU+PIn9Kcqni0MuszPQ+JxJMOJqRbQQ6KPN7B00H7NwoIrP
         Drm6XgYufBH4mra6+sOAbVt1h4f7zm5PQm5FIMVoNyAPXsB5rt349fsx5UmtEfTXmw/u
         KUvg==
X-Forwarded-Encrypted: i=1; AJvYcCUe/SIG3GdgkgLnrIVuqayulwmt1ZaU3DWcSOY7KSG7A7EyD7WGA3oTBa1GI9i6i6mkmfVnAuoPcxRe@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5Dl++Djp4hpOgDbSB7ItLZ6RJLEHx7o+n/m8Sw9b2W78n66he
	e9c5G7VPvLydOmpaF1jl7wkN4Am/8sZQ5H7gcWxLqOoPTZFtDHYnNM4VEFDrrGG40moRg+1d9v5
	Oqj6AAtcMGGGL1/3EXcsOTFxaOn6fz0qRjrzs
X-Gm-Gg: ASbGncsUUb1LgkGcWsw8FdjogdwJ7+lRbyjjIIYkKFiL39jSvNFuSHbKSc/MZa7TR0P
	2sVVI0eZyC1OGRBDgQoIFilQam9fZIZbwZKVH/aA9WNiAOSt2IpyA0WlKubVYmoYwQf0NswgbQX
	+bbfnLbfQEEYXmWKfElIckqciO/cZi4OXNjPytV8LyK/S8h6iqBhWfnf+IKdfT30z6VNFqRSJZi
	4+ZgpSea9VIi8d/JgTW5h5Oa8d6a9kpZ792UXupYgCdnyhzozeKTf8zAGSRpwHn0P2VkaU=
X-Google-Smtp-Source: AGHT+IFXmSUSOxFWtes+XsJX1igQjezrc2rRItPqNnD7SuK+QiO1hFoZnlPML1sFe1vLDbxIys4B9Eb4/5sN+7iczGs=
X-Received: by 2002:a05:7022:4387:b0:119:e56b:91e6 with SMTP id
 a92af1059eb24-11e0329e52cmr3944312c88.23.1765127030704; Sun, 07 Dec 2025
 09:03:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251205065104.103210-1-ebiggers@kernel.org>
In-Reply-To: <20251205065104.103210-1-ebiggers@kernel.org>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Sun, 7 Dec 2025 18:03:39 +0100
X-Gm-Features: AQt7F2p601O81HYqf6W-Rr0kxT37MDUFRgfpaApkUB-ekArcQnJmAag3KA-uT0k
Message-ID: <CAOi1vP8rauWK_S+CH64jZ=+ksoZKCT29DiEkYRQK6xLpTJYHTA@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: stop selecting CRC32, CRYPTO, and CRYPTO_AES
To: Eric Biggers <ebiggers@kernel.org>
Cc: Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 5, 2025 at 7:53=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> None of the CEPH_FS code directly requires CRC32, CRYPTO, or CRYPTO_AES.
> These options do get selected indirectly anyway via CEPH_LIB, which does
> need them, but there is no need for CEPH_FS to select them too.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> v2: also remove CRC32
>
>  fs/ceph/Kconfig | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
> index 3e7def3d31c1..3d64a316ca31 100644
> --- a/fs/ceph/Kconfig
> +++ b/fs/ceph/Kconfig
> @@ -1,13 +1,10 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config CEPH_FS
>         tristate "Ceph distributed file system"
>         depends on INET
>         select CEPH_LIB
> -       select CRC32
> -       select CRYPTO_AES
> -       select CRYPTO
>         select NETFS_SUPPORT
>         select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
>         default n
>         help
>           Choose Y or M here to include support for mounting the
>
> base-commit: bc04acf4aeca588496124a6cf54bfce3db327039
> --
> 2.52.0
>

Applied.

Thanks,

                Ilya

