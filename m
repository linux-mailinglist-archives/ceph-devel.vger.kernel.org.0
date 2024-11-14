Return-Path: <ceph-devel+bounces-2079-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 005509C9380
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2024 21:53:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E4DC1F21833
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2024 20:53:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 968EE1AAE30;
	Thu, 14 Nov 2024 20:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="AYTzbS7j"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-21.smtpout.orange.fr [80.12.242.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D6318DF89;
	Thu, 14 Nov 2024 20:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731617633; cv=none; b=bjF6Jr9/dNlP+urT/8n/bIXh5Dtako6z+Bs8SoULXIBHVw+bEPjy5BYwQKvHYcuvXz6L/7zttF/7R14oi8paewTAZh68qtkC6d1qKL6848utaEb7lls7Lyc3cwkjs1cadGHiaqZBAqWH8Dwczc/2v0d0sUEWcTkOHfH6z+i+sgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731617633; c=relaxed/simple;
	bh=yIev9+eLK+sa2JzXMTMbQbJapfdl56jEVK7mJi83GZo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jzEdnz4fhaQShymjW7HWvTHiKFu3vAB8vbxCQea2BfRXZwNpnPNNLo/VqrLRa+Fln8l72W8aKazBj2qjuh2CFZ7YpvKviQK1tBbjhrI2I1uxdyPWmFgb5UbBCl8tkRh939/OBB7Tr6GJCmI8hQdUFMe+I34mLCob1sg5Lb/eDSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=AYTzbS7j; arc=none smtp.client-ip=80.12.242.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from [192.168.1.37] ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id BgqYtkBtLgtkHBgqYteFma; Thu, 14 Nov 2024 21:53:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1731617627;
	bh=WV2W+8UBHguE4UcWph7FErk54zqeaAz0yLvQjc7Da0Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=AYTzbS7j8pq9LMK2JycxF5DHxrolWbXbETpjMN+Cus+zaSvpg5Y2QPrQis8ajylTe
	 +9+wJMcDiL6Wq22OsQ49r4ATL2ZGNVDCjfDp+up/6u4IZwQAjapDbnSd+/LwX+2uMv
	 K3jcwHRrgA8Z/kb3CZx3u9UN6595ECNvols4WIefRahtKd/CxD0NtVdqBXHGWIeVyV
	 FnCIFmydBywBz1ebEVfH3aU4RA69qpMceJrfsSxdfnY1Wk6KB86phluTtkfOOj2NHr
	 hsdjL+S+8wpTurGvMbUHwuMKEkbdCkr9i0nBTqCvdPcKU6/J3qqMDADo95JJfEAU89
	 xEXxzppESU//g==
X-ME-Helo: [192.168.1.37]
X-ME-Auth: bWFyaW9uLmphaWxsZXRAd2FuYWRvby5mcg==
X-ME-Date: Thu, 14 Nov 2024 21:53:47 +0100
X-ME-IP: 90.11.132.44
Message-ID: <62b1d5d1-a648-461f-8002-8373e600ef31@wanadoo.fr>
Date: Thu, 14 Nov 2024 21:53:46 +0100
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Use strscpy() instead of strcpy()
To: Abdul Rahim <abdul.rahim@myyahoo.com>
Cc: xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20241111221037.92853-1-abdul.rahim.ref@myyahoo.com>
 <20241111221037.92853-1-abdul.rahim@myyahoo.com>
 <8fef8eab-cd82-4e05-ad9b-1bb8b5fe974b@wanadoo.fr>
 <o6dz6grwkknan6er5lig6i37ocfekn6i3fljltptn7aol45sfl@n5amdhwr7wmt>
 <e7cfb6b2-51a4-4c8e-9c43-20653bd1443f@wanadoo.fr>
 <bigyu3u3rawsy5c5oxpe7xpmq24jhuxdrnklplaqjs2san7jxh@k3k2ypxcdspk>
Content-Language: en-US, fr-FR
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <bigyu3u3rawsy5c5oxpe7xpmq24jhuxdrnklplaqjs2san7jxh@k3k2ypxcdspk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 14/11/2024 à 10:14, Abdul Rahim a écrit :
> On Wed, Nov 13, 2024 at 10:28:36PM +0100, Christophe JAILLET wrote:

...

> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index 0e5b3c7b3756..48265c879fcf 100644
> --- a/fs/ceph/export.c
> +++ b/fs/ceph/export.c
> @@ -452,7 +452,12 @@ static int __get_snap_name(struct dentry *parent, char *name,
>   		goto out;
>   	if (ceph_snap(inode) == CEPH_SNAPDIR) {
>   		if (ceph_snap(dir) == CEPH_NOSNAP) {
> -			strcpy(name, fsc->mount_options->snapdir_name);
> +			/*
> +			 * get_name assumes that name is pointing to a
> +			 * NAME_MAX+1 sized buffer
> +			 */

It is a matter of taste, and I'm not the maintainer, but my personal 
feeling would go for something like:

/* .get_name() from struct export_operations assumes that its 'name' 
parameter is pointing to a NAME_MAX+1 sized buffer */

CJ

> +			strscpy(name, fsc->mount_options->snapdir_name,
> +					NAME_MAX+1);
>   			err = 0;
>   		}
>   		goto out;
> 
> 
> Looks good?
> 
> 


