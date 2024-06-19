Return-Path: <ceph-devel+bounces-1467-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B30A90EB44
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Jun 2024 14:38:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDEBB281604
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Jun 2024 12:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09B3C14388C;
	Wed, 19 Jun 2024 12:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xbx2zA9R"
X-Original-To: ceph-devel@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F00D143886
	for <ceph-devel@vger.kernel.org>; Wed, 19 Jun 2024 12:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718800665; cv=none; b=gEPIhiAAsTKiQehF6Q15LL4Vrly4Qnc6pflXqRQo//46PzNfUEI37S2khy0URxiQnXMoW6XMkQIyCkEueiY9Lh/aTC/+gRWqdQgp/+vNGPv01TjCMIE4mOQP9FGKIdyrFMsJgWF5eyv7e6U9TU2tSV8LwziGwjK46WPxQDTzZlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718800665; c=relaxed/simple;
	bh=X/YuWhy8ZCiva4HH7kwsbih6s3I5dFv/hxkqCDbV9xU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=UCe+8wDtknGPX8Awqum2Wia5At0d1GD1cvN/rKSKm8ITyCMLFFRzMlRXqlvLt3CTPNKkqWyj1r0f/JR4+rwZrdytUeKi/34bDK7K/mo0F6sjd6dubirodV1vhBp/7jdoim8yizp+g+xoJMCdiyCGxaO7cUJjJKqVPSPpRUHdHRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xbx2zA9R; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: dmantipov@yandex.ru
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718800661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3QU1sN6oHAaF6pyT96bfeBcxmz88cVmUKtYHXxR3C/o=;
	b=xbx2zA9RY2VgqI2e20Cg9YYM8p5PD3A72wjwjSdj5kGh/6z0E/zy64gAXLikjw5o8Ev9SS
	YYrVT6h87V9FpfgEEplnMYOSmsnbqcN7+mb0qiUH50xtfmu9uIKTJDr9jDEWZwuJiJc6k7
	xShU+fcniqNCNiqvQon7+COgr5SqdtA=
X-Envelope-To: xiubli@redhat.com
X-Envelope-To: ceph-devel@vger.kernel.org
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Luis Henriques <luis.henriques@linux.dev>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Xiubo Li <xiubli@redhat.com>,  ceph-devel@vger.kernel.org
Subject: Re: [PATCH] ceph: avoid call to strlen() in ceph_mds_auth_match()
In-Reply-To: <20240618143640.169194-1-dmantipov@yandex.ru> (Dmitry Antipov's
	message of "Tue, 18 Jun 2024 17:36:40 +0300")
References: <20240618143640.169194-1-dmantipov@yandex.ru>
Date: Wed, 19 Jun 2024 13:37:34 +0100
Message-ID: <87bk3xglbl.fsf@brahms.olymp>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Tue 18 Jun 2024 05:36:40 PM +03, Dmitry Antipov wrote;

> Since 'snprintf()' returns the number of characters emitted,
> an extra call to 'strlen()' in 'ceph_mds_auth_match()' may
> be dropped. Compile tested only.
>
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>  fs/ceph/mds_client.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index c2157f6e0c69..7224283046a7 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -5665,9 +5665,9 @@ static int ceph_mds_auth_match(struct ceph_mds_clie=
nt *mdsc,
>  				if (!_tpath)
>  					return -ENOMEM;
>  				/* remove the leading '/' */
> -				snprintf(_tpath, n, "%s/%s", spath + 1, tpath);
> +				tlen =3D snprintf(_tpath, n, "%s/%s",
> +						spath + 1, tpath);
>  				free_tpath =3D true;
> -				tlen =3D strlen(_tpath);
>  			}

Unless I'm missing something, this patch is incorrect.  snprintf() may not
return the actual string length *if* the output is truncated.  For
example:

	snprintf(str, 5, "%s", "0123456789");

snprintf() will return 10, while strlen(str) will return 4.

Cheers,
--=20
Lu=C3=ADs

