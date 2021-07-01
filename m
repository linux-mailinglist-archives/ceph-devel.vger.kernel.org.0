Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E363B8CAB
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Jul 2021 05:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbhGADhz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Jun 2021 23:37:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30816 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229622AbhGADhy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 23:37:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625110524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Pnh5lzttKOwORyKAMVtJiVX6k61qy2T0qhsSw5H4PI=;
        b=GlUAWoW/kzHACAaQtCha18OIyPZBwdbUJ6iz5Vc3TVWlicGztOkphx9EzBIozyPOOuG78E
        LhhcK6845ADL1Xi6PO9Gpc2iJ/eX8FYc3TMtdooKhW66fLxzAfBRFDr4ezK8GU6KlXKEY1
        Nh0yE84SwrhVYhNsKxgEJmDyYKYtGz4=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-ltyfcX3IOEefyBkyQuTNXg-1; Wed, 30 Jun 2021 23:35:22 -0400
X-MC-Unique: ltyfcX3IOEefyBkyQuTNXg-1
Received: by mail-pl1-f198.google.com with SMTP id d1-20020a1709027281b0290112c70b86f1so2037788pll.12
        for <ceph-devel@vger.kernel.org>; Wed, 30 Jun 2021 20:35:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/Pnh5lzttKOwORyKAMVtJiVX6k61qy2T0qhsSw5H4PI=;
        b=W+OUWZEfxyMydMrgL+mFuWpA9xuBkMqQcjzJlxFdkEIundmnMf+2qTQfs/D1L8PbEj
         W1dzpWqyWR+gYZCNEf1RcCPHhzZvoXDJZxARzlRsZLb82rNa62Vx7upjXdICslOJA0Iu
         O/ME5dBSCcuPSbxs6Li+p1pHLpEnukpefi0M4k6TdqhpCttSrcqEwxEL9IsoQePCPLB+
         CwJvS7xDVB0sS0t2SuHmVUt6nLrdoh4Hb7Y5b5a+znktEGfaJf2zey8vQEkAVNzylCsj
         6MDBefGuEOvu3E9g9rpDnRI+LQ7SljG+l3ZXFTcUmxaMk2SxEWDksKfW4ExNtTVjnAd1
         qxzg==
X-Gm-Message-State: AOAM5330stxxxAY5e81xT7/yaAf+NZpN5dK5XZ4JuLGu9/kWMrrQEi5Y
        O/U7NqhpPYkU8o4yw9Wnhb9/6fJKmzw3BEg64Ys+P0II15WT377s/8tCVn7s+1K2gBy/wd+aByc
        ho/GwuhBI40u9cHG7+P4NEsRJiUlYiqfBgTsR8wRtDWA9mvrxSzlZ3ab9YvfPGoR/HKZxkCw=
X-Received: by 2002:a17:902:7c05:b029:11c:1e7d:c633 with SMTP id x5-20020a1709027c05b029011c1e7dc633mr34931979pll.48.1625110521768;
        Wed, 30 Jun 2021 20:35:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5BDKw6Aa5MGBZAAAZvOglKQJQAy+ectPYNYx7/DvxNeX0UMk6uNjQYiIneKJvUKBychvg7g==
X-Received: by 2002:a17:902:7c05:b029:11c:1e7d:c633 with SMTP id x5-20020a1709027c05b029011c1e7dc633mr34931959pll.48.1625110521410;
        Wed, 30 Jun 2021 20:35:21 -0700 (PDT)
Received: from [10.72.12.103] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e29sm11673406pfm.0.2021.06.30.20.35.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 20:35:20 -0700 (PDT)
Subject: Re: [PATCH 5/5] ceph: fix ceph feature bits
To:     Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20210629044241.30359-1-xiubli@redhat.com>
 <20210629044241.30359-6-xiubli@redhat.com>
 <d98d4f50cdad747313e6d9a8a42691962fdcd0ae.camel@kernel.org>
 <d91f6786-24fd-e3a9-4fe8-d55821382940@redhat.com>
 <7d4b7f733b07efff86caa69e290104e5855ba074.camel@kernel.org>
 <CAOi1vP_CR96Nw6J-JTiL7z_zaAXCeYp-hvoqAYb80Av4P1Jhqg@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <daa76448-8406-12c8-a95c-da3153a939a4@redhat.com>
Date:   Thu, 1 Jul 2021 11:35:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP_CR96Nw6J-JTiL7z_zaAXCeYp-hvoqAYb80Av4P1Jhqg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/30/21 8:52 PM, Ilya Dryomov wrote:
> On Wed, Jun 30, 2021 at 2:05 PM Jeff Layton <jlayton@kernel.org> wrote:
>> On Wed, 2021-06-30 at 08:52 +0800, Xiubo Li wrote:
>>> On 6/29/21 11:38 PM, Jeff Layton wrote:
>>>> On Tue, 2021-06-29 at 12:42 +0800, xiubli@redhat.com wrote:
>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>
>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>> ---
>>>>>    fs/ceph/mds_client.h | 4 ++++
>>>>>    1 file changed, 4 insertions(+)
>>>>>
>>>>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>>>>> index 79d5b8ed62bf..b18eded84ede 100644
>>>>> --- a/fs/ceph/mds_client.h
>>>>> +++ b/fs/ceph/mds_client.h
>>>>> @@ -27,7 +27,9 @@ enum ceph_feature_type {
>>>>>            CEPHFS_FEATURE_RECLAIM_CLIENT,
>>>>>            CEPHFS_FEATURE_LAZY_CAP_WANTED,
>>>>>            CEPHFS_FEATURE_MULTI_RECONNECT,
>>>>> + CEPHFS_FEATURE_NAUTILUS,
>>>>>            CEPHFS_FEATURE_DELEG_INO,
>>>>> + CEPHFS_FEATURE_OCTOPUS,
>>>>>            CEPHFS_FEATURE_METRIC_COLLECT,
>>>>>
>>>>>            CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
>>>>> @@ -43,7 +45,9 @@ enum ceph_feature_type {
>>>>>            CEPHFS_FEATURE_REPLY_ENCODING,          \
>>>>>            CEPHFS_FEATURE_LAZY_CAP_WANTED,         \
>>>>>            CEPHFS_FEATURE_MULTI_RECONNECT,         \
>>>>> + CEPHFS_FEATURE_NAUTILUS,                \
>>>>>            CEPHFS_FEATURE_DELEG_INO,               \
>>>>> + CEPHFS_FEATURE_OCTOPUS,                 \
>>>>>            CEPHFS_FEATURE_METRIC_COLLECT,          \
>>>>>                                                    \
>>>>>            CEPHFS_FEATURE_MAX,                     \
>>>> Do we need this? I thought we had decided to deprecate the whole concept
>>>> of release-based feature flags.
>>> This was inconsistent with the MDS side, that means if the MDS only
>>> support CEPHFS_FEATURE_DELEG_INO at most in lower version of ceph
>>> cluster, then the kclients will try to send the metric messages to
>>> MDSes, which could crash the MDS daemons.
>>>
>>> For the ceph version feature flags they are redundant since we can check
>>> this from the con's, since pacific the MDS code stopped updating it. I
>>> assume we should deprecate it since Pacific ?
>>>
>> I believe so. Basically the version-based features aren't terribly
>> useful. Mostly we want to check feature flags for specific features
>> themselves. Since there are no other occurrences of
>> CEPHFS_FEATURE_NAUTILUS or CEPHFS_FEATURE_OCTOPUS symbols, it's probably
>> best not to define them at all.
> Not only that but this patch as is would break CEPHFS_FEATURE_DELEG_INO
> and CEPHFS_FEATURE_METRIC_COLLECT checks in the kernel because their bit
> numbers would change...

Sorry, please ignore this patch.

In the mds side:
#define CEPHFS_FEATURE_MULTI_RECONNECT  12
#define CEPHFS_FEATURE_NAUTILUS                 12
#define CEPHFS_FEATURE_DELEG_INO 13
#define CEPHFS_FEATURE_OCTOPUS                  13
#define CEPHFS_FEATURE_METRIC_COLLECT     14
#define CEPHFS_FEATURE_ALTERNATE_NAME     15
#define CEPHFS_FEATURE_MAX                          15

So, this fixing makes no sense any more.

BRs


> Thanks,
>
>                  Ilya
>

