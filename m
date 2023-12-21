Return-Path: <ceph-devel+bounces-382-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 01D2681AC0C
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Dec 2023 02:16:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25EE41C22ED0
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Dec 2023 01:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CECBF4685;
	Thu, 21 Dec 2023 01:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OsgpU0yv"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD1B441A
	for <ceph-devel@vger.kernel.org>; Thu, 21 Dec 2023 01:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703121397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LPUgNg6sIG/w3dPgMZGJ2RTTtfGOJE1Cs+qzLnT13Io=;
	b=OsgpU0yvQhut1dTO7MSr1/ogxyEthP9Ek2d8H/q6pfC/Q+cPPad7DbB4IeKwOP3P8QF1SW
	aErjgSa18gioSK+l47u+smgPIFZ4NxSokB0br8h6ORTtmro/qNgyaq7m0pXBzi5Dtuu6hl
	VloCDL1EOQY4XBm1fdcRdBhijkWw7GM=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-4RLrXM9sOXSOKgpY3pfidg-1; Wed, 20 Dec 2023 20:16:36 -0500
X-MC-Unique: 4RLrXM9sOXSOKgpY3pfidg-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5c668dc7f7bso238615a12.3
        for <ceph-devel@vger.kernel.org>; Wed, 20 Dec 2023 17:16:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703121394; x=1703726194;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LPUgNg6sIG/w3dPgMZGJ2RTTtfGOJE1Cs+qzLnT13Io=;
        b=xH+wxGoG/xedo5jMath64mKLpEi2ZzrLVV+eTbLmhtFCaezCCSSC6TkyNaL0M2QwUc
         1qHe0MVR0rDMfgasXc9Zdt3x8smkz/CQlVMIMczfP7DzdK249GrHX4vTpk663GMI+RDD
         +Ki9vz8xFQ0SfyyyIgUXg75zph2cdk9dQXadLQxlszUOwRMWvuFNedoOENJSDO8j4u37
         FBfOi6YgtgwvVuoAhjyGEG15Exw4j5ekmXR4a9pSXbfopV4PbmfTADCXK6UXsQtqp5l5
         tz/olaALcy1ivTfvmmwUr+L3XZa4SoWPcZVrYtwDgd7AhC2t85OEbIMo72CGBVacu6VH
         wxYw==
X-Gm-Message-State: AOJu0YxD8lSnPRy3E0AJ4nRd6u9Vqavo0KqNBI5bKHaRfdIgVrkkPXBy
	/XZmQRnKk8iKlA1qlXe2q1+64MTYzG8pZ0OIOMB1jkl+2GtmlMjH206JPw9jkA5w9GeWr3b/K79
	SwGx4ZucWrfgN+FnlrTt/WBq1mHIPieug
X-Received: by 2002:a17:902:a3c7:b0:1d3:9d96:d18 with SMTP id q7-20020a170902a3c700b001d39d960d18mr7911270plb.12.1703121394707;
        Wed, 20 Dec 2023 17:16:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHtnSIWKOQL7I+65Ho8w7hpF7c38Drl5aBJo8e64rVV5xVP833cdtegaYZvJQt72d/ffRBMOA==
X-Received: by 2002:a17:902:a3c7:b0:1d3:9d96:d18 with SMTP id q7-20020a170902a3c700b001d39d960d18mr7911263plb.12.1703121394464;
        Wed, 20 Dec 2023 17:16:34 -0800 (PST)
Received: from [10.72.112.86] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id b6-20020a170902d50600b001d060c61da5sm338685plg.134.2023.12.20.17.16.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Dec 2023 17:16:34 -0800 (PST)
Message-ID: <915a4f0e-0b85-46e5-ab4a-9a9d1774deac@redhat.com>
Date: Thu, 21 Dec 2023 09:16:32 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/22] get rid of passing callbacks to ceph
 __dentry_leases_walk()
Content-Language: en-US
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org
References: <20231220051348.GY1674809@ZenIV> <20231220052925.GP1674809@ZenIV>
 <446cf570-4d3d-4bdb-978c-a61d801a8c32@redhat.com>
 <20231221011201.GY1674809@ZenIV>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20231221011201.GY1674809@ZenIV>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 12/21/23 09:12, Al Viro wrote:
> On Thu, Dec 21, 2023 at 08:45:18AM +0800, Xiubo Li wrote:
>> Al,
>>
>> I think these two ceph patches won't be dependent by your following
>> patches,  right ?
>>
>> If so we can apply them to ceph-client tree and run more tests.
> All of them are mutually independent, and if you are willing to take
> them through your tree - all the better.
>
Sure, I will apply them into the ceph-client repo. And will run the 
tests for them.

Thanks Al.

- Xiubo


