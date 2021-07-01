Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BECCF3B8BA0
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Jul 2021 03:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238317AbhGABKb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Jun 2021 21:10:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25683 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238272AbhGABKb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 21:10:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625101681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GhDq4W3xBYwLCUrRP/e7VdBX2omO45apxjZQs3CPmaI=;
        b=iQGAOtDo8QcYeEB/PxCbGq2qa2SKPucFF5bsNf5imq94eXb97g9coDyZ5HMLvpvALOJYg+
        FTfXMnYQdAWA0taHPW1fJedlVDaqqyzJ7HITUG5aHGmnOQ7hJirOxzqUplKAWhztT9+4eB
        7y5s6IFp8Zm1mRoSj93m/B3ke7y1Y6U=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-G8is-BNKOwSfFJf-XSiLRQ-1; Wed, 30 Jun 2021 21:08:00 -0400
X-MC-Unique: G8is-BNKOwSfFJf-XSiLRQ-1
Received: by mail-pg1-f198.google.com with SMTP id k14-20020a63d84e0000b029022216b0ebf2so2898702pgj.15
        for <ceph-devel@vger.kernel.org>; Wed, 30 Jun 2021 18:07:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=GhDq4W3xBYwLCUrRP/e7VdBX2omO45apxjZQs3CPmaI=;
        b=Eyk723x4kM+oisYTdtmFowl8PybSxFqVzxeu8kQADS+VBZklTIyNYpRxixMnGDmuDG
         MvVTijvFDqEw+vGptWjTcjws4hHDA1eOT6AduAxmjUDzFkIiH6X+gN2fAK2cmcKdw4nX
         f+rkjWK5uX4SRpuV4FTjl4nNYMJeCAZ0/h2B/pdor7DqKXFb/t7Bla+gmDQ4ihix23pI
         ekyoCqjRECGCjCucxx8NkyMVCKLzLhc5m/H2Owi402xJC60+zBPmUdxj0EMBu6M0rQ9B
         jWVy0UBxVUnmFNqvlst6XfqGEMHMSCJi/+ZA/AfMZPQAJy10iuQ8PcEXZS/4COjeW4l6
         LLqQ==
X-Gm-Message-State: AOAM531QPcJY8arWo9uqTPfbtmUWVsHKBeHfqwDnKr74t9e3W3CZYSX+
        Q6CMezY0SSSKX8vn66HPjhUqJTp80TA0QaIA/x6sB79rH81hdqxF6secTS9x/+TUcXSUKNCVclR
        pQ61NbJc/duJTPXW/LFCl3OHrJteTCzQqTeUn9kYI3qdj1rIqsOPsk6Y/AksmgCON1UrGRmU=
X-Received: by 2002:a17:90a:9511:: with SMTP id t17mr43004822pjo.108.1625101678830;
        Wed, 30 Jun 2021 18:07:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwc3Dd5COE8ku2jWbSrU57Nxqn2oH3+PV6lT2brGv+ILvKmDlnEugiyyHGcRUkeOkDyg5h8hw==
X-Received: by 2002:a17:90a:9511:: with SMTP id t17mr43004782pjo.108.1625101678410;
        Wed, 30 Jun 2021 18:07:58 -0700 (PDT)
Received: from [10.72.12.103] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y13sm23420341pgp.16.2021.06.30.18.07.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 18:07:57 -0700 (PDT)
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
Message-ID: <55faeb01-3ba6-9c11-cfdc-36e134ac6bb0@redhat.com>
Date:   Thu, 1 Jul 2021 09:07:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP_CR96Nw6J-JTiL7z_zaAXCeYp-hvoqAYb80Av4P1Jhqg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
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

Without add this two symbols, we could just correct the number of them, 
make sense ?


> Not only that but this patch as is would break CEPHFS_FEATURE_DELEG_INO
> and CEPHFS_FEATURE_METRIC_COLLECT checks in the kernel because their bit
> numbers would change...

Yeah, the problem is that the numbers of them was incorrect, which was 
introducing crash bugs.

Thanks

Xiubo

> Thanks,
>
>                  Ilya
>

