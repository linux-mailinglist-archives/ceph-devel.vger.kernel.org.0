Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4863B7B23
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Jun 2021 02:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhF3Azd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 20:55:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59952 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229564AbhF3Azb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 20:55:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625014382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y17cHTp+EVT277DlnB/cdCTyFKQZ6PDxntlqz9s0QxE=;
        b=iiyCPreOMiQ2GaIApjSlgU+FUZQ1N26pgqwoSrGAVyL1TgThlZrS9L0GERNaQeJjQANuo7
        kMmar0rfET4DxVLtTudPfARSn+rI9noeb7yUB8Ebuq2hQqdvOTAW0tcOHjOSCi4aP+l1ur
        xFHDsaYphsWrUPs6mfIOfr/i+uE5E68=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-3CPCL8SBMSyAW_h-h1SDFQ-1; Tue, 29 Jun 2021 20:53:01 -0400
X-MC-Unique: 3CPCL8SBMSyAW_h-h1SDFQ-1
Received: by mail-pg1-f197.google.com with SMTP id y1-20020a655b410000b02902235977d00cso329661pgr.21
        for <ceph-devel@vger.kernel.org>; Tue, 29 Jun 2021 17:53:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Y17cHTp+EVT277DlnB/cdCTyFKQZ6PDxntlqz9s0QxE=;
        b=i3qEO14k2FlnmX0YPiSZLg+YQapPIZs7G8SV1bYQjEtx6Mg7+YhWb4Zmn9hBXtTPa+
         ffNJjKNQJfkIHM7z1yYpwaec8DEauFUU5A20khq7k/JgaVv/MZbyCs1TKx6arq66B5KY
         7qM460b2C0CuJjBZPFG8KBSiUy6nYymO3W1/+PbX3ua0QiV4NJ9nXfuzXLpJJA+p9vp6
         E7GLdUCrphnIlfpAPja4JhhgkX5APn044paMlefdAMNjvTTcooZTeESXi4ZKGbUEKKQB
         KqjayA7pTJDEEJiaz50D9iqnDGPSZRuqz5iA2qCBFU6uSUAFvxvz6hjaXveOVvgq8mF1
         0u6w==
X-Gm-Message-State: AOAM533im72pyZRnh+tfF68TM4ORFj/hQdZ3+rLaHHJpK0MQC8HzliSS
        pnrsz5J4mr/OJjl4RAoh9ZJ4dqnhsyueNcv/sKGUmxSi3+ABya1c0EAS2QMbbZ+dIJhwnG1daQW
        bAYDQCu2UKxxXilljW/mjN2FKnBLUbF2qbpVktc10Eexy2vEkjJzneg+bTrY6iABFkC/kJ4c=
X-Received: by 2002:aa7:8b07:0:b029:2f7:d38e:ff1 with SMTP id f7-20020aa78b070000b02902f7d38e0ff1mr33082285pfd.72.1625014380087;
        Tue, 29 Jun 2021 17:53:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLouf25Hp7sJb3yfL2IAg2umMrxcw/a9+u5zBIoCLqm43IEiwR7n4UVnuw0fWI07zW39UNPw==
X-Received: by 2002:aa7:8b07:0:b029:2f7:d38e:ff1 with SMTP id f7-20020aa78b070000b02902f7d38e0ff1mr33082256pfd.72.1625014379699;
        Tue, 29 Jun 2021 17:52:59 -0700 (PDT)
Received: from [10.72.12.103] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d207sm13821199pfd.118.2021.06.29.17.52.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 17:52:59 -0700 (PDT)
Subject: Re: [PATCH 5/5] ceph: fix ceph feature bits
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210629044241.30359-1-xiubli@redhat.com>
 <20210629044241.30359-6-xiubli@redhat.com>
 <d98d4f50cdad747313e6d9a8a42691962fdcd0ae.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d91f6786-24fd-e3a9-4fe8-d55821382940@redhat.com>
Date:   Wed, 30 Jun 2021 08:52:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <d98d4f50cdad747313e6d9a8a42691962fdcd0ae.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/29/21 11:38 PM, Jeff Layton wrote:
> On Tue, 2021-06-29 at 12:42 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.h | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index 79d5b8ed62bf..b18eded84ede 100644
>> --- a/fs/ceph/mds_client.h
>> +++ b/fs/ceph/mds_client.h
>> @@ -27,7 +27,9 @@ enum ceph_feature_type {
>>   	CEPHFS_FEATURE_RECLAIM_CLIENT,
>>   	CEPHFS_FEATURE_LAZY_CAP_WANTED,
>>   	CEPHFS_FEATURE_MULTI_RECONNECT,
>> +	CEPHFS_FEATURE_NAUTILUS,
>>   	CEPHFS_FEATURE_DELEG_INO,
>> +	CEPHFS_FEATURE_OCTOPUS,
>>   	CEPHFS_FEATURE_METRIC_COLLECT,
>>   
>>   	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
>> @@ -43,7 +45,9 @@ enum ceph_feature_type {
>>   	CEPHFS_FEATURE_REPLY_ENCODING,		\
>>   	CEPHFS_FEATURE_LAZY_CAP_WANTED,		\
>>   	CEPHFS_FEATURE_MULTI_RECONNECT,		\
>> +	CEPHFS_FEATURE_NAUTILUS,		\
>>   	CEPHFS_FEATURE_DELEG_INO,		\
>> +	CEPHFS_FEATURE_OCTOPUS,			\
>>   	CEPHFS_FEATURE_METRIC_COLLECT,		\
>>   						\
>>   	CEPHFS_FEATURE_MAX,			\
> Do we need this? I thought we had decided to deprecate the whole concept
> of release-based feature flags.

This was inconsistent with the MDS side, that means if the MDS only 
support CEPHFS_FEATURE_DELEG_INO at most in lower version of ceph 
cluster, then the kclients will try to send the metric messages to 
MDSes, which could crash the MDS daemons.

For the ceph version feature flags they are redundant since we can check 
this from the con's, since pacific the MDS code stopped updating it. I 
assume we should deprecate it since Pacific ?



