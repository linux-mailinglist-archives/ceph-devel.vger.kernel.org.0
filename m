Return-Path: <ceph-devel+bounces-108-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F390C7EEA40
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Nov 2023 01:16:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2ECFE1C20B1D
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Nov 2023 00:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DB63641;
	Fri, 17 Nov 2023 00:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fnVoZpyl"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E087011D
	for <ceph-devel@vger.kernel.org>; Thu, 16 Nov 2023 16:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700180166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6apKVHCejDBwt4J+kzqGjH7pHyP8+WMv9AObeB4sOHA=;
	b=fnVoZpyliPxEQmIqoR4g2OmOCBU6Ujmqcgd9dVeZ7frp4jBzXDE7ZcAZLStRkM5tZ6ssqe
	2a8FAPhrKDoxOfnUjZa8mmH2SkCe2+g+eu1UkBA8RzzTqa0sBgXBu2jNIRsdg1igE1kvhl
	DyjiUEhzVWZAxB7LHb2vxpjprKUGFNI=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-B-ypKAF0Pr-2dZ4b18mo4Q-1; Thu, 16 Nov 2023 19:16:04 -0500
X-MC-Unique: B-ypKAF0Pr-2dZ4b18mo4Q-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-6c415e09b2cso1702698b3a.2
        for <ceph-devel@vger.kernel.org>; Thu, 16 Nov 2023 16:16:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700180162; x=1700784962;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6apKVHCejDBwt4J+kzqGjH7pHyP8+WMv9AObeB4sOHA=;
        b=oYOtJtE0eO+aYrqHV0HIqtE6Es58IcupXlvGfbcNa8krfZ1S5tH40Jsr6C4iH9vQro
         G9i65kfmw8YSAxtfzjIvBZcH29Y2K7WWOwmDBJh//BzFe4om+ytJZP78qXxyj/PPtu7T
         yd0AqdSg3+aAln77/HBolczJibovZP3FpFmD9I1/cB5eUYOfI4k/NFISBIoJowVmAL1q
         JhQ6YcLUF6j7CRJY8469olTsEuBLifjbz8JnT8FygtJHMK5Ztk5cDGnTwCRcowB/7aKn
         ozAG5qCWa/K8bGeVAuzyOSHysWmWpjsSeIiijJIWLQrnQ7cMDIVCoSzOoUNPLlZBwW7n
         BV9Q==
X-Gm-Message-State: AOJu0YxuFTxJcTuP0hX5DkJ/R5qPrHMSSkw/cPPBh9N+kaZ4NVJqhvM0
	HPNQS0ps/M8DQUaa8QdyVBok4mYs/kVAAiTfgAfqrfw9jVQNu3aqTPvvwJZL49IyJ46C0EokJm2
	1AzcNIQtqFJvDGL2q56pDJQ==
X-Received: by 2002:a05:6a21:19a:b0:187:c662:9b7e with SMTP id le26-20020a056a21019a00b00187c6629b7emr3196673pzb.25.1700180162456;
        Thu, 16 Nov 2023 16:16:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHuu6yhl6PYfi2c3RpfXd9jLV6jHijWwt0Ez8Q6tompMv+QEx+QBeAuEm9mvgzA+/SAxy8OVA==
X-Received: by 2002:a05:6a21:19a:b0:187:c662:9b7e with SMTP id le26-20020a056a21019a00b00187c6629b7emr3196660pzb.25.1700180162171;
        Thu, 16 Nov 2023 16:16:02 -0800 (PST)
Received: from [10.72.112.63] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 23-20020a17090a005700b0027d05817fcdsm333546pjb.0.2023.11.16.16.15.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Nov 2023 16:16:01 -0800 (PST)
Message-ID: <3a5ed688-898c-7620-e06e-ab2ff2cfdca2@redhat.com>
Date: Fri, 17 Nov 2023 08:15:57 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [deadlock or dead code] ceph_encode_dentry_release() misuse of
 dget()
Content-Language: en-US
To: Jeff Layton <jlayton@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org
References: <20231116081919.GZ1957730@ZenIV>
 <44265305e099888191aa7482743f0fa7900e8336.camel@kernel.org>
 <20231116162814.GA1957730@ZenIV>
 <e96818f94a6ba3a040004b2cadd569fc2f224554.camel@kernel.org>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <e96818f94a6ba3a040004b2cadd569fc2f224554.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/17/23 00:50, Jeff Layton wrote:
> On Thu, 2023-11-16 at 16:28 +0000, Al Viro wrote:
>> On Thu, Nov 16, 2023 at 07:50:03AM -0500, Jeff Layton wrote:
>>
>>>> Am I missing something subtle here?  Looks like that dget() is never
>>>> reached...
>>> No, I think you're correct. That looks like dead code to me too.
>>> Probably we can just remove that "if (!dir)" condition altogether.
>>>
>>> Did you want to send a patch, or would you rather Xiubo or I do it?
>> Up to you...  AFAICS, it had been dead code since ca6c8ae0f793 "ceph: pass
>> parent inode info to ceph_encode_dentry_release if we have it".  In other
>> words, that "if we have it" had already been true at that point.  Prior
>> to that commit dget() in there had been unconditional (and really a deadlock
>> fodder); making it conditional had made it actually unreachable and that
>> fixed the actual bug.
> That makes sense.
>
> Xiubo, would you mind spinning up a patch for this? You're probably in
> the best position to make sure it gets tested these days.

Hi Jeff, Al

Sure, I will fix this. Thanks very much.

- Xiubo


> Thanks!


