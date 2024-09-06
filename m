Return-Path: <ceph-devel+bounces-1795-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 60BF496F26D
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2024 13:09:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C6B31C23EDE
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2024 11:09:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8615B1C9EB9;
	Fri,  6 Sep 2024 11:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DM/626sh"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA91A158866
	for <ceph-devel@vger.kernel.org>; Fri,  6 Sep 2024 11:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725620986; cv=none; b=GfThMV7oMJbWwgfjs9YXfbt7/Fy+jDLosj2CXioSb2kE/+iPUoJqriOH7oT+pXEPbidMl3zLgLNPd0AWhtPbNHUsgV5n3n/24N3cpZtE1WtqBRJX31mZUYtqsYSEoB6WSyu3Gbu7QDkMVq9xUVUDr+cmClnaYJmEfqUNh186tx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725620986; c=relaxed/simple;
	bh=Usa+xeryk/kCno/gay7xkzlhyEYNjyOplnylfEzdJWs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WF5rWAUjScQS9hSmWkpdU1RYfHK3nOyp5At+mLHn0Rs5Myw07DoTfguGaJPugvoHq3uQ35GdU3PNuRopbt3lti9M5SnIlBJSwrcM67DjY3YkjxM3EzO/P5hY6UITVWpnHK3umJMbU4WylNcvQy6QerKdi29NXEhbcWRXQYyH0Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DM/626sh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725620984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5lyE9fqrgEMZ+2heBiLKo8myouuHThPfR4uCDSQ64CE=;
	b=DM/626shZ01jf1gU0o5831211qcVMvjDY3/ShFNW4gLvyRJoHG4hXZWpWk/Zbz8WLz8miR
	pD0MHbplI0zXgGieFmd+5rgg0/sK+XtRClnsLIYzVKAx0Tg5ywJmoZxwDuTJx7bhoxXB0p
	R8njiN1rtF5tLuCpjIguwnmXXWQIye8=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-wNNCN0UkMDmzic-WeHgaZg-1; Fri, 06 Sep 2024 07:09:42 -0400
X-MC-Unique: wNNCN0UkMDmzic-WeHgaZg-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3df1e4129fdso2412116b6e.3
        for <ceph-devel@vger.kernel.org>; Fri, 06 Sep 2024 04:09:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725620982; x=1726225782;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5lyE9fqrgEMZ+2heBiLKo8myouuHThPfR4uCDSQ64CE=;
        b=fdoM9F9UanQWD3qJNd+A8yuF49tPxfnKWmhai4lJvVcS8tqYrebMR6W517cBhYSv9j
         R893rqOHHgVFpg/z+DIy22ghJYR1CQtC5+wsibznsXeWRpCz659ufoorcPflfV0p9upe
         V0RJaaqVa+LBZE1UQLq9U7BMFz6Z89oxOV3i5kOxgeNPW3DS3XF/tBAMMJ+m7Wquk+mD
         87vyhd4jPbKTwk+EkVIzkKuEevyj6pnPguAgFIN6yWZkgahmK7QGBUu6ad5urIkSoII/
         IBxVZK1j3DL0W1YyQ22V1egyO1JSotHS4rP8HMNecrUGvpOerZYIuWrNyMCEM9+t19NQ
         ZNkg==
X-Forwarded-Encrypted: i=1; AJvYcCWsK/8Wcl9Qn8YJvtz6sAD+0o6xDz6XW0mirYUFrpF28DBbyWtQEasTsAoEW57UQGIc+2/HUpSgXLHf@vger.kernel.org
X-Gm-Message-State: AOJu0Yzl1d7Vbs4d8rBlq2AtFxdyTvwPVxWt1bNkohizI8T7eeYB3rfE
	FNSdSXmPIXa3WU9pYT8O6SJXd6LaxQAHYOgTm/dud0wb8s/SjVwR++TbanY+y8F4IVuXpjDBK6T
	225CyNGthUvsmE652Zgf+YACd9IjJgZZ39XToexjrZZug1CmaLWN20TfQVCY=
X-Received: by 2002:a05:6808:2214:b0:3d5:64d6:9f1e with SMTP id 5614622812f47-3e02a0249admr2571015b6e.36.1725620982022;
        Fri, 06 Sep 2024 04:09:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE1yR7XNXwmmNFoz6dlGTf6VjHpVNiJOBP1k2/Z6Rbnc/lLnAZu24E/xgHVXfe+wTzmbtACuw==
X-Received: by 2002:a05:6808:2214:b0:3d5:64d6:9f1e with SMTP id 5614622812f47-3e02a0249admr2570992b6e.36.1725620981701;
        Fri, 06 Sep 2024 04:09:41 -0700 (PDT)
Received: from [10.72.116.139] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7d4fbd859ffsm4775069a12.16.2024.09.06.04.09.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2024 04:09:41 -0700 (PDT)
Message-ID: <5335cdb5-7735-463e-907b-617774d6f01a@redhat.com>
Date: Fri, 6 Sep 2024 19:09:36 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION]: cephfs: file corruption when reading content via
 in-kernel ceph client
To: Christian Ebner <c.ebner@proxmox.com>, David Howells
 <dhowells@redhat.com>, Jeff Layton <jlayton@kernel.org>,
 Ilya Dryomov <idryomov@gmail.com>
Cc: regressions@lists.linux.dev, ceph-devel@vger.kernel.org,
 stable@vger.kernel.org
References: <85bef384-4aef-4294-b604-83508e2fc350@proxmox.com>
 <0e60c3b8-f9af-489a-ba6f-968cb12b55dd@redhat.com>
 <1679397305.24654.1725606946541@webmail.proxmox.com>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <1679397305.24654.1725606946541@webmail.proxmox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 9/6/24 15:15, Christian Ebner wrote:
>> On 06.09.2024 03:01 CEST Xiubo Li <xiubli@redhat.com> wrote:
>>
>>   
>> Hi Christian,
>>
>> Thanks for reporting this.
>>
>> Let me have a look and how to fix this.
>>
>> - Xiubo
>>
> Thanks for looking into it, please do not hesitate to contact me if I can be of help regarding debugging or testing a possible fix.

Sure, thanks in advance.

I will work on this next week or later because I am occupied by some 
other stuff recently.

- Xiubo


> Regards,
> Christian Ebner
>


