Return-Path: <ceph-devel+bounces-1512-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 35CDA92CE32
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jul 2024 11:30:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF0231F241D5
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jul 2024 09:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B779A18EFF9;
	Wed, 10 Jul 2024 09:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bit.nl header.i=@bit.nl header.b="WoDY1OBd"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtpout119.bit.nl (smtpout119.bit.nl [87.251.44.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B2B59160
	for <ceph-devel@vger.kernel.org>; Wed, 10 Jul 2024 09:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=87.251.44.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720603802; cv=none; b=qLrKqodJ7mWMy3UD9wCufFgyuLaagsmIps5Od4pPww0VknjQvvy+34Feb62wlU0rPpW+EPMPE7NLEBKoBwkbPyxWCYq2vCUM0VoEyttNRsY6A6mQQDP4l/Mel/QlLwgW9lBmIz6107ts8nn4cc5g1kEhtBOG+EiY8VBs6HGTd4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720603802; c=relaxed/simple;
	bh=xfTIy3UoN2/9fi/Zmo2gonJhc54iXUxCGRvoRov0NzE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:Cc:
	 In-Reply-To:Content-Type; b=cGtqniRUIhg6hWw36P/iwPZIor70JBvlAdXRQudMohft3XsPLum2MziiabQbcOuh/EqrJw7XyuErONWgEACnZvvISZ46lms0x+UEnnJlEBJf+EVEKjtBJu6WHpJAXxxdxzAYNWS/EFcWdRSjeYOrN15v7jm6qRHjp8LSD6nE/go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bit.nl; spf=pass smtp.mailfrom=bit.nl; dkim=pass (2048-bit key) header.d=bit.nl header.i=@bit.nl header.b=WoDY1OBd; arc=none smtp.client-ip=87.251.44.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bit.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bit.nl
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bit.nl;
	s=bitsmtp01; h=Content-Transfer-Encoding:Content-Type:Cc:To:From:Subject:
	MIME-Version:Date:Message-ID:Sender;
	bh=SWz4IS2J07ygJmZl6Gwv11etAhvKhRWPYLPMYVfblQI=; b=WoDY1OBdWjVjU1lppgR+lvq52g
	yEd3F3aCnVUHP5ypGErlXSj594Y7fyDsRxnHgaG6sor/IPk3/yzMMQg0/DhsSCmJ82a5GdoJlOX2O
	0hjzedVDmJUPgajZAiLjnONuF3o0y5z55tWbzM4/Y0qkSArnucVKwBlR2w/5qNRRMDxNEM/slbQvU
	l/IeI3j/v1VucXBW4BiIqvGhHmvhB7gHKDMEq95cKaLE38+AiCJQi9KjlbwfxmGLFe4ocl8jxgEmi
	ThkDJiOqLZpXclAoIm00hPDKWtRU3uKYnLyd3R9lpaRGzsy13KY6xdjvpuYEg9MBwhRFpNTM1GJal
	2HU4pMZw==;
Received: from [192.168.253.10]
	by bit-smtp.dmz.bit.nl with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <stefan@bit.nl>)
	id 1sRSwQ-00CxAo-6Q;
	Wed, 10 Jul 2024 10:44:46 +0200
Message-ID: <7d4d605e-0c54-4ea1-9b41-348a21e27b66@bit.nl>
Date: Wed, 10 Jul 2024 10:44:45 +0200
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ceph-users] Re: [EXTERN] Urgent help with degraded filesystem
 needed
From: Stefan Kooman <stefan@bit.nl>
To: Dietmar Rieder <dietmar.rieder@i-med.ac.at>, ceph-users@ceph.io
References: <cebe0708-c457-4f29-b9d6-cbee77cac810@i-med.ac.at>
 <79c8a7cd-9267-410c-9688-d33a84fb46a2@i-med.ac.at>
 <2981444e-d719-44e2-9982-241c8a1c4e63@bit.nl>
Content-Language: en-US
Cc: John Zachary Dover <zac.dover@gmail.com>,
 Ceph Development <ceph-devel@vger.kernel.org>
Autocrypt: addr=stefan@bit.nl; keydata=
 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
 wkgjehU9KhEfrbCr0/pViEi/z7z9DY5k
In-Reply-To: <2981444e-d719-44e2-9982-241c8a1c4e63@bit.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 01-07-2024 10:34, Stefan Kooman wrote:

> 
> 
> Not that I know of. But changes in behavior of Ceph (daemons) and or 
> Ceph kernels would be good to know about indeed. I follow the 
> ceph-kernel mailing list to see what is going on with the development of 
> kernel CephFS. And there is a thread about reverting the PR that Enrico 
> linked to [1], here the last mail in that thread from Venky to Ilya [2]:


One more thing: The man page (mount.ceph) incorrectly states that 
"wsync" is the default [1], which it isn't anymore since 5.16 [2]. Not 
sure who is responsible for maintaining the man page, so CC'ing Zac and 
Ceph kernel developers. I would add information in the man page what 
options are default in what kernels (and to keep the man page up to date 
in the future).

Gr. Stefan

[1]: https://docs.ceph.com/en/latest/man/8/mount.ceph/
[2]: 
https://github.com/gregkh/linux/commit/f7a67b463fb83a4b9b11ceaa8ec4950b8fb7f902

