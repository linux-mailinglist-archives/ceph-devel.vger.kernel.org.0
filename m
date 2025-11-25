Return-Path: <ceph-devel+bounces-4110-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 92A4EC84506
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Nov 2025 10:55:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4056C34D00A
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Nov 2025 09:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B07492ECD34;
	Tue, 25 Nov 2025 09:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="kIlaniXI"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1622C11D0;
	Tue, 25 Nov 2025 09:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764064540; cv=none; b=OLq00xld+BrsQwnBuxnGT0YRpLtTjx9vfJmbly43z1Ym/bLUvSLVYzYebkl+HXAVacxri5vhpNt/G+joajC8pKeFyTupgY0KNp9W3jGJVZrV7I4PvdlNgUIpmtYdhbT4Y6TdvzgRU3elzdR35AlEg7sSAfUviPJtu+b0I7eUWUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764064540; c=relaxed/simple;
	bh=Dwcca4dnHFctZkmvR6GMwS56c8m05S1Y/8RyxtVVm0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iGtqH72AbR3BflvNxbFP+vFYFNnMPSYST/UJ3Xz18ZnF0cQzJInJ1PkCrbZVSslDlo8l/UYkHwStyw6ncAbOgwrkiiSwu5R/zyztz8nwAjgILTbBNbVdZf3oX3sTpgKdvCHsDutJPSDgixXrwrIiDemlQ/JwoKqs5mnq/2DhlhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=runbox.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=kIlaniXI; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=runbox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight@runbox.com>)
	id 1vNpll-005uV0-Vu; Tue, 25 Nov 2025 10:55:34 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
	References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date;
	bh=JNK+Nit6qW7snTRE3aPUTZIzBp+Trk2B0GCjSq1nxR0=; b=kIlaniXIEULWKng+YNCjyG39FB
	RPuogoQbi/pmgusKLrxau6PhBPWms2UrqXN+ewkthoLzKXbRlW6vNK8rwgLuQGpjvJDOT3ZwsYgPG
	C4/urF1jr0lepp1pHa4fk4Q33/t2jnYqz8Usvx69iIaApbYNPRxiEwZxMzahOopLslRBYIZcns9Gp
	/NcueZk89Zl/CTU39w6fXu29AupdbnbuPAsPtpgCiaEYuq6g21cBZFR77N7TSt4cCwtnrM/8Sc9Oz
	BFpH2en6YoMWT1AdzvCCwypghYPCkXSuMh0Cf+y5siSq+z7oQtIMazTox+CXti0AU5RohQlJ6VjM0
	rdTHp2Ag==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight@runbox.com>)
	id 1vNpll-0005FE-A3; Tue, 25 Nov 2025 10:55:33 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vNplX-00AW4O-BL; Tue, 25 Nov 2025 10:55:19 +0100
Date: Tue, 25 Nov 2025 09:55:16 +0000
From: david laight <david.laight@runbox.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, Xiubo Li <xiubli@redhat.com>, Ilya Dryomov
 <idryomov@gmail.com>, Nathan Chancellor <nathan@kernel.org>, Nick
 Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling
 <morbo@google.com>, Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH v1 1/1] ceph: Amend checking to fix `make W=1` build
 breakage
Message-ID: <20251125095516.40a3d57c@pumpkin>
In-Reply-To: <20251110144404.369928-1-andriy.shevchenko@linux.intel.com>
References: <20251110144404.369928-1-andriy.shevchenko@linux.intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 10 Nov 2025 15:44:04 +0100
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> In a few cases the code compares 32-bit value to a SIZE_MAX derived
> constant which is much higher than that value on 64-bit platforms,
> Clang, in particular, is not happy about this
> 
> fs/ceph/snap.c:377:10: error: result of comparison of constant 2305843009213693948 with expression of type 'u32' (aka 'unsigned int') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
>   377 |         if (num > (SIZE_MAX - sizeof(*snapc)) / sizeof(u64))
>       |             ~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Fix this by casting to size_t. Note, that possible replacement of SIZE_MAX
> by U32_MAX may lead to the behaviour changes on the corner cases.

Did you really read the code?
The test itself needs moving into ceph_create_snap_context().
Possibly by using kmalloc_array() to do the multiply.

But in any case are large values sane at all?
Allocating very large kernel memory blocks isn't a good idea at all.

In fact this does a kmalloc(... GFP_NOFS) which is pretty likely to
fail for even moderate sized requests. I bet it fails 64k (order 4?)
on a regular basis.

Perhaps all three value that get added to make 'num' need 'sanity limits'
that mean a large allocation just can't happen.

	David

> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  fs/ceph/snap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index c65f2b202b2b..521507ea8260 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -374,7 +374,7 @@ static int build_snap_context(struct ceph_mds_client *mdsc,
>  
>  	/* alloc new snap context */
>  	err = -ENOMEM;
> -	if (num > (SIZE_MAX - sizeof(*snapc)) / sizeof(u64))
> +	if ((size_t)num > (SIZE_MAX - sizeof(*snapc)) / sizeof(u64))
>  		goto fail;
>  	snapc = ceph_create_snap_context(num, GFP_NOFS);
>  	if (!snapc)


