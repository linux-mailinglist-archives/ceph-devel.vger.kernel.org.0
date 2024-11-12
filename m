Return-Path: <ceph-devel+bounces-2071-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EA5D9C4EBE
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Nov 2024 07:22:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8943287DF4
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Nov 2024 06:22:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21687209F2D;
	Tue, 12 Nov 2024 06:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="G5utOPbN"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-26.smtpout.orange.fr [80.12.242.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC8819EED4;
	Tue, 12 Nov 2024 06:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731392520; cv=none; b=SVExE+r1fTy+ruFCUEkiMKzOCte7ZoS/6Z7ro5QcLkO2cllMuWa2WWn2LO5zZpPVxph4dvLWhnYApvwVlKnbiQB8mcYq2ImuxxboXiaIlgdSaqQQfrNAzCL4MnpGG9QhZ5lcq/Nd+RJiG2veB3U6zzjQRgjOrTFMTRC44fLGexI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731392520; c=relaxed/simple;
	bh=r2QCV0892MPtZWYZl539dJKThx3xuUvps7cOqsg/zi4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cv4oE9xHl0KHYak9baMTJkptZGqEg6UYbvjMz1BmQzL+fsOTLFm1xnc+dHwIYMZb10hHblqdgvORZ+O332iFXNJVqp5DvQZyFDz8Q44espqBJnkbINkRazZRa3MAnuBDL+Olc3mFJyNbQPriZjh/cpiA/IWyYSQND9D3ivUjzdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=G5utOPbN; arc=none smtp.client-ip=80.12.242.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from [192.168.1.37] ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id AkHitiEQVSqkGAkHjt2eYJ; Tue, 12 Nov 2024 07:21:55 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1731392515;
	bh=1uiG7k/zawHrJQJxDGDleKSXD1C3nsDmTYzQhxgWjX4=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=G5utOPbNY/SBfuwz1mH8ZkOzAMXnnfsUz8/+uYi+2hl4d0yvwSmP7qucjW2ST8iQ8
	 2u37G7F0lRfdndEHQ5l3+lQODynQc+934DAuv94quLiiad3yiwX3cUf8oKNit+B547
	 R/1oODiK7N/MKmiZvfMsR3AYq6b4khuiX+K1PM0o/Z6vLcHM5yg7qxBFV/qGn4KmJk
	 P5nPweircKOyXDVAEeY/UCBYXDWt0t1JPrJBdBF5Uz4yQSuHrfBSLrNHrQpNlZSQOy
	 Xln74cz8vGA792HcosMI2eUhR/IHHQPrvj/yqjn4zAiOwvTDkBD5JZ5cbzZQfuehFR
	 rbd8f6LwiAgJw==
X-ME-Helo: [192.168.1.37]
X-ME-Auth: bWFyaW9uLmphaWxsZXRAd2FuYWRvby5mcg==
X-ME-Date: Tue, 12 Nov 2024 07:21:55 +0100
X-ME-IP: 90.11.132.44
Message-ID: <8fef8eab-cd82-4e05-ad9b-1bb8b5fe974b@wanadoo.fr>
Date: Tue, 12 Nov 2024 07:21:54 +0100
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Use strscpy() instead of strcpy()
To: Abdul Rahim <abdul.rahim@myyahoo.com>, xiubli@redhat.com,
 idryomov@gmail.com
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241111221037.92853-1-abdul.rahim.ref@myyahoo.com>
 <20241111221037.92853-1-abdul.rahim@myyahoo.com>
Content-Language: en-US, fr-FR
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20241111221037.92853-1-abdul.rahim@myyahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 11/11/2024 à 23:10, Abdul Rahim a écrit :
> strcpy() is generally considered unsafe and use of strscpy() is
> recommended [1]
> 
> this fixes checkpatch warning:
>      WARNING: Prefer strscpy over strcpy
> 
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strcpy [1]
> Signed-off-by: Abdul Rahim <abdul.rahim@myyahoo.com>
> ---
>   fs/ceph/export.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index 44451749c544..0e5b3c7b3756 100644
> --- a/fs/ceph/export.c
> +++ b/fs/ceph/export.c
> @@ -452,7 +452,7 @@ static int __get_snap_name(struct dentry *parent, char *name,
>   		goto out;
>   	if (ceph_snap(inode) == CEPH_SNAPDIR) {
>   		if (ceph_snap(dir) == CEPH_NOSNAP) {
> -			strcpy(name, fsc->mount_options->snapdir_name);
> +			strscpy(name, fsc->mount_options->snapdir_name);

This does not compile because when the size of 'name' is not known at 
compilation time, you need to use the 3-argument version of strscpy().

Please always compile test your patches before sending them. Even, when 
the change looks trivial.

CJ

>   			err = 0;
>   		}
>   		goto out;


