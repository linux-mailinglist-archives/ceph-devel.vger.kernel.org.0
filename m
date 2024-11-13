Return-Path: <ceph-devel+bounces-2075-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 836249C7DAC
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Nov 2024 22:28:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB3BE283C91
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Nov 2024 21:28:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAF8F1FE0F1;
	Wed, 13 Nov 2024 21:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="mnrPNH4W"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-14.smtpout.orange.fr [80.12.242.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764381DEFC7;
	Wed, 13 Nov 2024 21:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731533327; cv=none; b=ENhBgOzmB8MxTZOw3pO0f6jyErxm77sZEWAhJuT+pLMC4eT8mJqxaEbMnCL535fyq4LfawronxXrPIvZZw+icDIvBg+ZjqSsANXoEJn/eYU5DC6qG0ulpAsUK1nAnAxaMgS3OtLaIPWNIjCAg4L9wL5h0hD9M4l9qmo3qfGBljE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731533327; c=relaxed/simple;
	bh=BNQyOZQOksUpmRz/+V07mmCaSzrktkHzTwgshUAhM3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=POoMQcA23fpmGvTt1uOdebovoIqNJ3pqLoeAonct4qmI4hB8Xw40Qj1Y0wamGqLB82opSjOiF++OETh9qF7Zy9Mc4nGLiQ03IQdOMYjPkNJ80cEG68G+4OuFAdvl7Iejv7IvWYAitwIxADTMTTNYqKHvrxqv4d8ZMdUSn48wf1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=mnrPNH4W; arc=none smtp.client-ip=80.12.242.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from [192.168.1.37] ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id BKuit0vNCTH7uBKujtRbcA; Wed, 13 Nov 2024 22:28:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1731533317;
	bh=ZcbUci+HdxjrO34+GhEq4ILFRsteVKa8rZeg4w9exyo=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=mnrPNH4Wc4NKmN71SPL0f1hTbzE1LS2rQxdd5JGvpx8p2TnsAjBjfZ+1o+1h2aIUw
	 rl/WLGCaErK1VQJI8Vqm5GblibefXunrRKSqhKXBxEniER3PdeGfd9Ac6sSNacBVCr
	 20J/ijqXvmRwf2QbKFxnZAeEHFCzGfoJ/xzmLH6YGHB5o0+HHnqSSPQ90hN4/fHBN5
	 JO8WdhGqZQ7c1kfHLuq/sJttg99TYy3Y5DvNmS1IQhlD8rNsPH3HWCU8PlEMWbiMDS
	 eDFOGJ8U20HC7Sx5AQWznj6ZO/NMAq8vFxwtJExUrpekJhkVUYCh7WwausDVgyTPsl
	 dGyyAcroEa09g==
X-ME-Helo: [192.168.1.37]
X-ME-Auth: bWFyaW9uLmphaWxsZXRAd2FuYWRvby5mcg==
X-ME-Date: Wed, 13 Nov 2024 22:28:37 +0100
X-ME-IP: 90.11.132.44
Message-ID: <e7cfb6b2-51a4-4c8e-9c43-20653bd1443f@wanadoo.fr>
Date: Wed, 13 Nov 2024 22:28:36 +0100
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
Content-Language: en-US, fr-FR
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <o6dz6grwkknan6er5lig6i37ocfekn6i3fljltptn7aol45sfl@n5amdhwr7wmt>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 13/11/2024 à 21:15, Abdul Rahim a écrit :
> On Tue, Nov 12, 2024 at 07:21:54AM +0100, Christophe JAILLET wrote:
>> Le 11/11/2024 ï¿½ 23:10, Abdul Rahim a ï¿½critï¿½:
>>> strcpy() is generally considered unsafe and use of strscpy() is
>>> recommended [1]
>>>
>>> this fixes checkpatch warning:
>>>       WARNING: Prefer strscpy over strcpy
>>>
>>> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strcpy [1]
>>> Signed-off-by: Abdul Rahim <abdul.rahim@myyahoo.com>
>>> ---
>>>    fs/ceph/export.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
>>> index 44451749c544..0e5b3c7b3756 100644
>>> --- a/fs/ceph/export.c
>>> +++ b/fs/ceph/export.c
>>> @@ -452,7 +452,7 @@ static int __get_snap_name(struct dentry *parent, char *name,
>>>    		goto out;
>>>    	if (ceph_snap(inode) == CEPH_SNAPDIR) {
>>>    		if (ceph_snap(dir) == CEPH_NOSNAP) {
>>> -			strcpy(name, fsc->mount_options->snapdir_name);
>>> +			strscpy(name, fsc->mount_options->snapdir_name);
>>
>> This does not compile because when the size of 'name' is not known at
>> compilation time, you need to use the 3-argument version of strscpy().
>>
>> Please always compile test your patches before sending them. Even, when the
>> change looks trivial.
>>
> 
> Sure.
> 
>> CJ
>>
>>>    			err = 0;
>>>    		}
>>>    		goto out;
>>
>>
> 
> Should it be: NAME_MAX+1 ?
> 
> See: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/exportfs.h?h=v6.12-rc7#n203
> 
> 

Looks like a good idea, maybe with a comment related to get_name() in 
the export_operations structure, so that we remind where this limit 
comes from?

CJ


