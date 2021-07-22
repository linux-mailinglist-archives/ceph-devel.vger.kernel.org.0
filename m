Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6C53D24E4
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Jul 2021 15:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhGVNMs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 22 Jul 2021 09:12:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44913 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231925AbhGVNMr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 22 Jul 2021 09:12:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626962002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YpT53Dw5OZOoF7y8Hy9E2tAfVBOT4JnAt8RvQ8I9OPI=;
        b=A0QhZsdB6trCwy/KHM9O7bQlv73kSpYz53BY1MY+oQVxa1zkLr9bxcnHqLpy70jSVQ/1CW
        or8BFtAdf5wKUlJ+OrqZdxf4NHlR4Hzr3Q/Pldit5rh7tKVpDgRtrZbUYWMBGWfKzJokeH
        5JXs75l7pgS5F/LJr0F4SQ1FdSjVlmU=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-EotP7DMINOilCQB8ShH0QQ-1; Thu, 22 Jul 2021 09:53:21 -0400
X-MC-Unique: EotP7DMINOilCQB8ShH0QQ-1
Received: by mail-pj1-f69.google.com with SMTP id pf18-20020a17090b1d92b0290176233dff9dso4515312pjb.4
        for <ceph-devel@vger.kernel.org>; Thu, 22 Jul 2021 06:53:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=YpT53Dw5OZOoF7y8Hy9E2tAfVBOT4JnAt8RvQ8I9OPI=;
        b=X/nRiU0Il+h+Pv/ETkmf6JZ/aSO9dlBFa0O9i1G69av6uhWUm9KZDgGxwcJPwKAzna
         /FEYWneLjOKJa9pLgMoW3W3Ang9cBvJkOhvPhVD3cwkU30fC8VcEjkFobQZ9gwcG9vOh
         HQfX09t3M2vJpKWhGzoMmh0JUfkHpgvw5woHMH7QmGV81tvoSs/VFlsZpGcfpE87XUjN
         WyBFcKcU/qq1XnJzrLJeK8j1G9E5mEZHeAcTf98a94xibgXaK39wdiZQcC82alRILMT1
         VuMB/uxPBJPPIh+C4H23khDV/PVRRzCchjO9C9+Ye6jnZkgmbAUFbG7gcDv4FKYncVvr
         f5nA==
X-Gm-Message-State: AOAM530rskJ2UakkHI3nJIk161US9MH96kb1kwvDCgmKgH3IJwHXoQA3
        aW7Hm0xGKbDc9lLmuRpwXVHFWKqinrGWbJ7CBOXWggllR3vqMLSJ9D0Z5ZEb0njU5v67Sxv9Cvp
        yp3V0Rh5ed5Ss+OucvclZRZfy81N5yffyqjX4TU/Y9mo39yh7cI+nyWC8Fi25ldze+S3YyyY=
X-Received: by 2002:a63:770c:: with SMTP id s12mr65825pgc.339.1626962000005;
        Thu, 22 Jul 2021 06:53:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxw20sar1iM9x/R3/Ztf6fGY7a46AUA3mn4kDJeSKOpqqxDnqh8rYPY089oB+b56nb7Ma8Dog==
X-Received: by 2002:a63:770c:: with SMTP id s12mr65798pgc.339.1626961999701;
        Thu, 22 Jul 2021 06:53:19 -0700 (PDT)
Received: from [10.72.12.71] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l1sm5714223pjq.1.2021.07.22.06.53.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 06:53:19 -0700 (PDT)
Subject: Re: [PATCH RFC] ceph: flush the delayed caps in time
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210721082720.110202-1-xiubli@redhat.com>
 <a2ab96c71ac875bd98efef4f7cb4590fbfae3b82.camel@kernel.org>
 <072b68bd-cb8d-b6a6-cca5-4ca20cfcde99@redhat.com>
 <55730c8c12a60453a8bdb1fc9f9dda0c43f01695.camel@kernel.org>
 <e4312917-5bd2-99f8-fb8d-d022ec2daedd@redhat.com>
 <719c82e05d9d2e426a4c11f60f9f32a6da4ed3d6.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <ad933948-46b4-64e3-bec8-2fc1f69f79d7@redhat.com>
Date:   Thu, 22 Jul 2021 21:53:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <719c82e05d9d2e426a4c11f60f9f32a6da4ed3d6.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/22/21 7:42 PM, Jeff Layton wrote:
> On Thu, 2021-07-22 at 17:36 +0800, Xiubo Li wrote:
>> On 7/21/21 8:57 PM, Jeff Layton wrote:
>>> On Wed, 2021-07-21 at 19:54 +0800, Xiubo Li wrote:
>>>> On 7/21/21 7:23 PM, Jeff Layton wrote:
>>>>> On Wed, 2021-07-21 at 16:27 +0800, xiubli@redhat.com wrote:
>>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>>
>>>>>> The delayed_work will be executed per 5 seconds, during this time
>>>>>> the cap_delay_list may accumulate thounsands of caps need to flush,
>>>>>> this will make the MDS's dispatch queue be full and need a very long
>>>>>> time to handle them. And if there has some other operations, likes
>>>>>> a rmdir request, it will be add in the tail of dispath queue and
>>>>>> need to wait for several or tens of seconds.
>>>>>>
>>>>>> In client side we shouldn't queue to many of the cap requests and
>>>>>> flush them if there has more than 100 items.
>>>>>>
>>>>> Why 100? My inclination is to say NAK on this.
>>>> This just from my test that around 100 client_caps requests queued will
>>>> work fine in most cases, which won't take too long to handle. Some times
>>>> the client will send thousands of requests in a short time, that will be
>>>> a problem.
>>> What may be a better approach is to figure out why we're holding on to
>>> so many caps and trying to flush them all at once. Maybe if we were to
>>> more aggressively flush sooner, we'd not end up with such a backlog?
>>    881912 Jul 22 10:36:14 lxbceph1 kernel: ceph:  00000000f7ee4ccf mode
>> 040755 uid.gid 0.0
>>    881913 Jul 22 10:36:14 lxbceph1 kernel: ceph:  size 0 -> 0
>>    881914 Jul 22 10:36:14 lxbceph1 kernel: ceph:  truncate_seq 0 -> 1
>>    881915 Jul 22 10:36:14 lxbceph1 kernel: ceph:  truncate_size 0 ->
>> 18446744073709551615
>>    881916 Jul 22 10:36:14 lxbceph1 kernel: ceph:  add_cap
>> 00000000f7ee4ccf mds0 cap 152d pAsxLsXsxFsx seq 1
>>    881917 Jul 22 10:36:14 lxbceph1 kernel: ceph:  lookup_snap_realm 1
>> 0000000095ff27ff
>>    881918 Jul 22 10:36:14 lxbceph1 kernel: ceph:  get_realm
>> 0000000095ff27ff 5421 -> 5422
>>    881919 Jul 22 10:36:14 lxbceph1 kernel: ceph:  __ceph_caps_issued
>> 00000000f7ee4ccf cap 000000003c8bc134 issued -
>>    881920 Jul 22 10:36:14 lxbceph1 kernel: ceph:   marking
>> 00000000f7ee4ccf NOT complete
>>    881921 Jul 22 10:36:14 lxbceph1 kernel: ceph:   issued pAsxLsXsxFsx,
>> mds wanted -, actual -, queueing
>>    881922 Jul 22 10:36:14 lxbceph1 kernel: ceph:  __cap_set_timeouts
>> 00000000f7ee4ccf min 5036 max 60036
>>    881923 Jul 22 10:36:14 lxbceph1 kernel: ceph: __cap_delay_requeue
>> 00000000f7ee4ccf flags 0 at 4294896928
>>    881924 Jul 22 10:36:14 lxbceph1 kernel: ceph:  add_cap inode
>> 00000000f7ee4ccf (1000000152a.fffffffffffffffe) cap 000000003c8bc134
>> pAsxLsXsxFsx now pAsxLsXsxFsx seq 1 mds0
>>    881925 Jul 22 10:36:14 lxbceph1 kernel: ceph:   marking
>> 00000000f7ee4ccf complete (empty)
>>    881926 Jul 22 10:36:14 lxbceph1 kernel: ceph:  dn 0000000079fd7e04
>> attached to 00000000f7ee4ccf ino 1000000152a.fffffffffffffffe
>>    881927 Jul 22 10:36:14 lxbceph1 kernel: ceph: update_dentry_lease
>> 0000000079fd7e04 duration 30000 ms ttl 4294866888
>>    881928 Jul 22 10:36:14 lxbceph1 kernel: ceph:  dentry_lru_touch
>> 000000006fddf4b0 0000000079fd7e04 'removalC.test01806' (offset 0)
>>
>>
>>   From the kernel logs, some of these delayed caps are from previous
>> thousands of 'mkdir' requests, after the mkdir requests get replied and
>> when creating new caps, since the MDS has issued extra caps that they
>> don't want, then these caps are added to the delay queue, and in 5
>> seconds the delay list could accumulate up to several thousands of caps.
>>
>> And most of them come from stale dentries.
>>
>> So 5 seconds later when the delayed_queue is fired, all this client_caps
>> requests are queued in the MDS dispatch queue.
>>
>> The following commit could improve the performance very much:
>>
>> commit 37c4efc1ddf98ba8b234d116d863a9464445901e
>> Author: Yan, Zheng <zyan@redhat.com>
>> Date:   Thu Jan 31 16:55:51 2019 +0800
>>
>>       ceph: periodically trim stale dentries
>>
>>       Previous commit make VFS delete stale dentry when last reference is
>>       dropped. Lease also can become invalid when corresponding dentry has
>>       no reference. This patch make cephfs periodically scan lease list,
>>       delete corresponding dentry if lease is invalid.
>>
>>       There are two types of lease, dentry lease and dir lease. dentry lease
>>       has life time and applies to singe dentry. Dentry lease is added to
>> tail
>>       of a list when it's updated, leases at front of the list will expire
>>       first. Dir lease is CEPH_CAP_FILE_SHARED on directory inode, it applies
>>       to all dentries in the directory. Dentries have dir leases are added to
>>       another list. Dentries in the list are periodically checked in a round
>>       robin manner.
>>
>> With this commit, it will take 3~4 minutes to finish my test:
>>
>> real    3m33.998s
>> user    0m0.644s
>> sys    0m2.341s
>> [1]   Done                    ( cd /mnt/kcephfs.$i && time strace -Tv -o
>> ~/removal${i}.log -- rm -rf removal$i* )
>> real    3m34.028s
>> user    0m0.620s
>> sys    0m2.342s
>> [2]-  Done                    ( cd /mnt/kcephfs.$i && time strace -Tv -o
>> ~/removal${i}.log -- rm -rf removal$i* )
>> real    3m34.049s
>> user    0m0.638s
>> sys    0m2.315s
>> [3]+  Done                    ( cd /mnt/kcephfs.$i && time strace -Tv -o
>> ~/removal${i}.log -- rm -rf removal$i* )
>>
>> Without this it will take more than 12 minutes for above 3 'rm' threads.
>>
> That commit was already merged a couple of years ago. Does this mean you
> think the client behavior can't be improved further?

No, I think we can.

The customer is mainly using the downstream kernel which doesn't include 
it yet.

I have patched it and with this it can save a lot of time for my test. 
In theory and in rare case from my test that the delayed_work() still 
could send a large number of cap requests in a short time. It's very 
hard for me to reproduce with this fixing together with the Finisher's 
fix in https://github.com/ceph/ceph/pull/42394.

I checked that downstream code, there has some buggy codes which could 
impact the perf, but in the following numerous downstream patches they 
have been removed or fixed by coincidence when fixing other issues. In 
the upstream kernel I didn't find any new issue yet.

Thanks.








