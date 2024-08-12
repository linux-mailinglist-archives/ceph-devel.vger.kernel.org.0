Return-Path: <ceph-devel+bounces-1658-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50ABB94F1FB
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Aug 2024 17:46:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 833341C21130
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Aug 2024 15:46:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE6FE1862BE;
	Mon, 12 Aug 2024 15:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I634mkqA"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EFE8121B;
	Mon, 12 Aug 2024 15:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723477576; cv=none; b=I/rqBXFil67Sa7OhsgsdebJ7W2ORij3SYYhuXOD5bDpbb4SMTZzj1oz6WMvsNo2muNW/ClEH6Jpvz65Ogw6AbZSGUUVzoE9zfhp9ZOQyiH4jRIhu0+DAD7YVl6fsQwPPEF4lBrqXXfMFdYXE9aGKCK1pt7SNkeHxzO04v0S9qAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723477576; c=relaxed/simple;
	bh=DwYE6Bmx7uhFD7kcz285rszG6J9msUkHy2Ihq5kfFB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SAxb3AsEv+vlMrkAxapn2ai/1BGAXwLuVXkRVY5obzmlw9w7SrTG0jI7W5xCSIpj5GzQkV42wwaVA4SShlUHuN8wk0oOS9XQpb74Ncxotl5d5XHteba1Pn2QQX7NH9HUjARaIMmP/EqQsvKKyRAKYHfvcCIU15qI6Cg79scPplo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I634mkqA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3636CC32782;
	Mon, 12 Aug 2024 15:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723477576;
	bh=DwYE6Bmx7uhFD7kcz285rszG6J9msUkHy2Ihq5kfFB4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I634mkqAbuwa0uiIMCJMDwieeIecfWaaTruG9/IhjuQeadcEWFyDmKOEopbqYVDXs
	 Ph3X0NgZ1Qpr5oCNlCWH96Px8VkHeXF8NCDAHhPDrVFsUc3m++kAr35wX6h12QmABs
	 rYijPaPntWcYvvZSdZ2YLy+8QNwNAosL29KKiBMULxUTHkvskuM+kz3D+gCXi73YtH
	 yJQFAjxZOZteycYIlguXCDFOOcT6vYC3SUMU/xbiT8jXNVLpwxekFNEtKZrDfjU7h5
	 eXszQDNZbwlop9hKrsXPiuis/5lkMwUblnEUrqOZ3PXYekXLukBzGJrbjznMSktm/B
	 A5Ruul+AlSjJQ==
Date: Mon, 12 Aug 2024 16:46:10 +0100
From: Simon Horman <horms@kernel.org>
To: Abhinav Jain <jain.abhinav177@gmail.com>
Cc: idryomov@gmail.com, xiubli@redhat.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	ceph-devel@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
	javier.carrasco.cruz@gmail.com
Subject: Re: [PATCH net v2] libceph: Make the arguments const as per the TODO
Message-ID: <20240812154610.GC21855@kernel.org>
References: <20240811205509.1089027-1-jain.abhinav177@gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240811205509.1089027-1-jain.abhinav177@gmail.com>

On Mon, Aug 12, 2024 at 02:25:09AM +0530, Abhinav Jain wrote:
> net/ceph/crypto.c:
> Modify arguments to const in ceph_crypto_key_decode().
> Modify ceph_key_preparse() and ceph_crypto_key_unarmor()
> in accordance with the changes.
> 
> net/ceph/crypto.h:
> Add changes in the prototype of ceph_crypto_key_decode().
> 
> net/ceph/auth_x.c:
> Modify the arguments to function ceph_crypto_key_decode()
> being called in the function process_one_ticket().

Hi,

I think that the subject and patch description need to be reworked.
We can see easily enough from the code what is being done.
But why?

> 
> v1:
> lore.kernel.org/all/20240811193645.1082042-1-jain.abhinav177@gmail.com
> 
> Changes since v1:
>  - Incorrect changes made in v1 fixed.
>  - Found the other files where the change needed to be made.
> 
> Signed-off-by: Abhinav Jain <jain.abhinav177@gmail.com>

Please take some time before posting the next revision of this patch.

Please do run checkpatch.pl --strict --codespell
and, within reason, correct the issues it flags.

Please make sure that allmodconfig builds compile.
At least on x86_64.

...

> diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c

...

> @@ -123,7 +124,7 @@ int ceph_crypto_key_unarmor(struct ceph_crypto_key *key, const char *inkey)
>  	}
>  
>  	p = buf;
> -	ret = ceph_crypto_key_decode(key, &p, p + blen);
> +	ret = ceph_crypto_key_decode(key, &p, (const void *)((const char *)p + blen));

It is usually not necessary to implicitly cast a pointer to (void *).
Also, while it mat address a compiler warning, it's not claear to me how
this is related to the const change that is the subject of this patch.

>  	kfree(buf);
>  	if (ret)
>  		return ret;

...

> @@ -311,9 +312,9 @@ static int ceph_key_preparse(struct key_preparsed_payload *prep)
>  	if (!ckey)
>  		goto err;
>  
> -	/* TODO ceph_crypto_key_decode should really take const input */
> -	p = (void *)prep->data;
> -	ret = ceph_crypto_key_decode(ckey, &p, (char*)prep->data+datalen);
> +	p = prep->data;
> +	ret = ceph_crypto_key_decode(ckey, &p, \
> +			(const void *)((const char *)prep->data + datalen));

I don't think you need the cast to void * here either.

>  	if (ret < 0)
>  		goto err_ckey;
>  

...

