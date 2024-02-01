Return-Path: <ceph-devel+bounces-789-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E94FD844F48
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Feb 2024 04:00:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5754290F17
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Feb 2024 03:00:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1D613A8E9;
	Thu,  1 Feb 2024 02:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DgK4am8m"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05BC1773E
	for <ceph-devel@vger.kernel.org>; Thu,  1 Feb 2024 02:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706756390; cv=none; b=qjBq8jrGIfeydkVgOsbY0jc6OZN6M0L2aso5KqN02Wdh3jBMckIWIi+kAfcOFQBYsgBt/joM4QAL6JxZRpccksWg3gtePBjSCzYAGvKhAOtOUm9t83H9VFWq9NSK3LHysuyJ1UEqbi0OvJwNyfKf3k2sBMW+SdYXsO2bQaJgnqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706756390; c=relaxed/simple;
	bh=5gKmwqTiX//bw8dcuurwVdti6uUWSqDtZl+dcrFZ1I4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mK+ABUMQNOaXhB6c/LBkk63sUgTaXvVhKszWOFXLZewauzH3EZL7xlVJbz5vFj60OUdnbtykOCflhd+QsNg1QNOmtm8Fo2AeLVFMzLPoIrp5hv0sG2nsWQp7kcsSwZ124keyAEC4l4lBIGK1dALr+qOHK8aZq2r8YKgdU7xZ4nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DgK4am8m; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706756385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0K09n4KM4GfA4ieYr3u7htlPmiCBvQiYCmB4ilutQSI=;
	b=DgK4am8mTUzEk8Vc6/H2+gOv3PnHnp/ZMibBPRsijbr77Qx/VIO357IvmbrUDVIpvBx0aZ
	/xHwXlltFZAsmvg/QoSjz+Ca/lk+kzssjupit05cJQS0CaTpijLB8MMg6/bu8m2L139TD3
	oI5G9AMTspJsodPJ+pH0vDrNQF/q6GQ=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-440-WPdi9fBRNcy4XFIYUI-9Ow-1; Wed, 31 Jan 2024 21:59:42 -0500
X-MC-Unique: WPdi9fBRNcy4XFIYUI-9Ow-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-296168be11cso145946a91.1
        for <ceph-devel@vger.kernel.org>; Wed, 31 Jan 2024 18:59:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706756381; x=1707361181;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0K09n4KM4GfA4ieYr3u7htlPmiCBvQiYCmB4ilutQSI=;
        b=u5Y4AVM6GKtuH93mgbe9+w5bDh7OPZRdXJJQzjQBLAzmjmFPcV4RACx1zjNxzB78f3
         mjnhRmfGNgcPwU+evSTBGtiwYy3SLqC8so8RmvsNHlE7TnN699SQ9QP39L3QugUjuCy8
         Vwt2UZjrdRnztQMzo20ON7PvBJSQinSzK26OLYRjs/HC/YJuBzJwwCJboCkH1tcUkCBw
         n+i9vlENEpZ6ZVf2BImrKJ7K6TN8fbwgQtLSG0U7lhHPVcyHSC0ntwPLG338DNEsklNP
         Cxkwmp1ezd4YEGqrmmUkiFk2EaEkYHw+cC9MeJTBXzKQRMpc/XHx1ziDRS/Cj6mBvlcE
         P5yQ==
X-Gm-Message-State: AOJu0Yy+KUli82hH5/xziL1pjiVLQeo9xrYBri96kFUBl9iSymqUfhyr
	UmxCWhnZNK5Uv/vi4x32GQ9lQKRqsSrE79sdC4sMA8JlKkxrWc0LRuAidyX3D7Vms83vEj9TWuX
	aK2NQYXNcZlfHr07OVB8uDeh70qBJYiojtWd56EiELHRVRO+PccsCFhSc/P4=
X-Received: by 2002:a17:90a:ce18:b0:294:7038:777d with SMTP id f24-20020a17090ace1800b002947038777dmr3901980pju.13.1706756381072;
        Wed, 31 Jan 2024 18:59:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF0ZQ2E5GxhjYagXcM2WpAQ5CV3eNZ5+T0wmWcpW9bT04Oir0NC6ttw5pobxxz+SLpJhTJo0Q==
X-Received: by 2002:a17:90a:ce18:b0:294:7038:777d with SMTP id f24-20020a17090ace1800b002947038777dmr3901969pju.13.1706756380799;
        Wed, 31 Jan 2024 18:59:40 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVsjvS8L1o8MG8eurFUAa7zDMjUJgz7DPAVdr13C1+E7gDNRiJUiMRYodfSCKOiaKxZOxE2VZtzSnPzmXvRWCQ2VUGoeu++Ovg8wbdO/9vvgRQDc1tkd1CYI6sYttHd/336382BGsRYwjCIaCII8i/GcCsvSKaYKPXw+HLH869NJx6RTmpLkDQt3Ktfjim/OnmkAOQsbDk8KFRYy43G5MrZgajVitt3fqRzTC5hn2s21grwSOR/vz9yaZzHilnZPEn3XTIDswmDHsA4MVUpdQG81c8CH3jOjJ5KzL7RBg==
Received: from [10.72.113.26] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id v6-20020a17090a088600b00295be790dfesm2225567pjc.17.2024.01.31.18.59.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jan 2024 18:59:40 -0800 (PST)
Message-ID: <2fccdb02-3b66-40b9-a0d7-a79fe7c5580a@redhat.com>
Date: Thu, 1 Feb 2024 10:59:35 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fscrypt: to make sure the inode->i_blkbits is
 correctly set
Content-Language: en-US
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-fscrypt@vger.kernel.org, tytso@mit.edu, jaegeuk@kernel.org,
 linux-kernel@vger.kernel.org, idryomov@gmail.com,
 ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com,
 mchangir@redhat.com
References: <20240201003525.1788594-1-xiubli@redhat.com>
 <20240201024828.GA1526@sol.localdomain>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20240201024828.GA1526@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/1/24 10:48, Eric Biggers wrote:
> On Thu, Feb 01, 2024 at 08:35:25AM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The inode->i_blkbits should be already set before calling
>> fscrypt_get_encryption_info() and it will use this to setup the
>> ci_data_unit_bits later.
>>
>> URL: https://tracker.ceph.com/issues/64035
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> Thanks, applied.  I adjusted the commit message to make it clear what the patch
> actually does:
>
> commit 5befc19caec93f0088595b4d28baf10658c27a0f
> Author: Xiubo Li <xiubli@redhat.com>
> Date:   Thu Feb 1 08:35:25 2024 +0800
>
>      fscrypt: explicitly require that inode->i_blkbits be set
>
>      Document that fscrypt_prepare_new_inode() requires inode->i_blkbits to
>      be set, and make it WARN if it's not.  This would have made the CephFS
>      bug https://tracker.ceph.com/issues/64035 a bit easier to debug.
>
>      Signed-off-by: Xiubo Li <xiubli@redhat.com>
>      Link: https://lore.kernel.org/r/20240201003525.1788594-1-xiubli@redhat.com
>      Signed-off-by: Eric Biggers <ebiggers@google.com>
>
Ack, thanks Eric.

- Xiubo



