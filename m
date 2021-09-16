Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70A340E326
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Sep 2021 19:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243861AbhIPQpd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Sep 2021 12:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343587AbhIPQme (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 16 Sep 2021 12:42:34 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE080C0613BE
        for <ceph-devel@vger.kernel.org>; Thu, 16 Sep 2021 09:14:30 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id h9so7154645ile.6
        for <ceph-devel@vger.kernel.org>; Thu, 16 Sep 2021 09:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9V03uGI7EjrBgLt/qVGardb/p6bXcbYffSxYgFXryGE=;
        b=dY7gcDbB6hybL4cGUPcWeC0Ee6hJHt4BDTHbHwltpoi8ZgVVSrCYde8KkFHR5aWNkr
         sCgVbP/ZrUUmkKw+YEQVq2oVEpnFit6cov0g4qb2JTecXOpmH1soT7aUh7mVkdZ+xI0K
         HTo0yBbIMbSGrjeijqyhXxkAUBB7vYxkT7Pr8HcC33WAoZdd86Ky1ZFi2OGW7YGdYCXy
         US+YYz9Zju9OGTQQiX5t7NY4fueum0gSvWuKWFYHvU9ZBX8+iYJYAFnHPuGCreM/qfSd
         8kbvs/n4rwP/QlsrK5MhiawWRbtPFAy5hheIK317rndVc2oLjKHugXgWX/wX5BOg3teF
         gnpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9V03uGI7EjrBgLt/qVGardb/p6bXcbYffSxYgFXryGE=;
        b=JgeV4QD7sKioSzFsCc9h458Yc5n6iAn6bfvSlFwX9IUAXZigXS5z5HaJWzHqrddmTv
         v3JwdM2LUDp0QmCCaPjVwBmAL+qE2SB1znZS2q257V9OaEn7Dq3zpJGk221adm5JkLjZ
         3EgKNepTgo8zA1VbcMfZmdDroNq7IBH+s1MbG7uoA9F+zfVuRGIaKepLK1iNRA1IypIg
         2z6CviS4a0RiyTRy718tthHdiZ8mMJ+J9VYZd9ldfwxcJLEEYSatoUI8Iovn+BK/g0SP
         +BabngfXhcW2wDpDBb8epPylCeI83xEPVL3q6uIWJecLQXOrvtyWIxDWMeXZYEmGJGkV
         e/0g==
X-Gm-Message-State: AOAM531sGESoAOj6CA+YSh5tMoN2M0XRawLu2e415Mrky2V/qnO6WDiE
        xSBwVSVjieDKHEw3OBG7+FM=
X-Google-Smtp-Source: ABdhPJzSRhZH2Ny8yhag+LgXdfpb18DQJAKfNJXsInzkNhjMapWFFyEpcbiSVsZruZgs+w7LPrrJPw==
X-Received: by 2002:a05:6e02:4a4:: with SMTP id e4mr4570647ils.232.1631808870228;
        Thu, 16 Sep 2021 09:14:30 -0700 (PDT)
Received: from [192.168.50.212] (c-73-94-106-141.hsd1.mn.comcast.net. [73.94.106.141])
        by smtp.gmail.com with ESMTPSA id b3sm2076153ilm.20.2021.09.16.09.14.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 09:14:29 -0700 (PDT)
Subject: Re: CephFS optimizated for machine learning workload
To:     "Yan, Zheng" <ukernel@gmail.com>, Mark Nelson <mnelson@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        "ceph-users@ceph.io" <ceph-users@ceph.io>,
        "dev@ceph.io" <dev@ceph.io>
References: <CAAM7YAkJxr8+g=kbtk8uU4BV4TAqriQ-_FqWfzJWzbpHkx+oLw@mail.gmail.com>
 <95d4b624-2114-832f-ed80-f7f0e7d35a3c@redhat.com>
 <CAAM7YAm9DLgu0mCD=tFkQkDfmcm9bkdV7Dp_V8g_UZz19TPCXA@mail.gmail.com>
From:   Mark Nelson <mark.a.nelson@gmail.com>
Message-ID: <3bf21091-19bd-121c-05e1-9ce3ee7c7009@gmail.com>
Date:   Thu, 16 Sep 2021 11:14:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAAM7YAm9DLgu0mCD=tFkQkDfmcm9bkdV7Dp_V8g_UZz19TPCXA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 9/15/21 11:05 PM, Yan, Zheng wrote:
> On Wed, Sep 15, 2021 at 8:36 PM Mark Nelson <mnelson@redhat.com> wrote:
>>
>> Hi Zheng,
>>
>>
>> This looks great!  Have you noticed any slow performance during
>> directory splitting?  One of the things I was playing around with last
>> year was pre-fragmenting directories based on a user supplied hint that
>> the directory would be big (falling back to normal behavior if it grows
>> beyond the hint size).  That way you can create the dirfrags upfront and
>> do the migration before they ever have any associated files.  Do you
>> think that might be worth trying again given your PRs below?
>>
> 
> These PRs do not change directory splitting logic. It's unlikely they
> will improve performance number of mdtest hard test.  But these PRs
> remove overhead of journaling  subtreemap and distribute metadata more
> evenly.  They should improve performance number of mdtest easy test.
> So I think it's worth a retest.
> 
> Yan, Zheng


I was mostly thinking about:

[3] https://github.com/ceph/ceph/pull/43125

Shouldn't this allow workloads like mdtest hard where you have many 
clients performing file writes/reads/deletes inside a single directory 
(that is split into dirfrags randomly distributed across MDSes) to 
parallelize some of the work? (minus whatever needs to be synchronized 
on the authoritative mds)

We discussed some of this in the performance standup today.  From what 
I've seen the real meat of the problem still rests in the distributed 
cache, locking, and cap revocation, but it seems like anything we can do 
to reduce the overhead of dirfrag migration is a win.

Mark




> 
>>
>> Mark
>>
>>
>> On 9/15/21 2:21 AM, Yan, Zheng wrote:
>>> Following PRs are optimization we (Kuaishou) made for machine learning
>>> workloads (randomly read billions of small files) .
>>>
>>> [1] https://github.com/ceph/ceph/pull/39315
>>> [2] https://github.com/ceph/ceph/pull/43126
>>> [3] https://github.com/ceph/ceph/pull/43125
>>>
>>> The first PR adds an option that disables dirfrag prefetch. When files
>>> are accessed randomly, dirfrag prefetch adds lots of useless files to
>>> cache and causes cache thrash. Performance of MDS can be dropped below
>>> 100 RPS. When dirfrag prefetch is disabled, MDS sends a getomapval
>>> request to rados for cache missed lookup.  Single mds can handle about
>>> 6k cache missed lookup requests per second (all ssd metadata pool).
>>>
>>> The second PR optimizes MDS performance for a large number of clients
>>> and a large number of read-only opened files. It also can greatly
>>> reduce mds recovery time for read-mostly wordload.
>>>
>>> The third PR makes MDS cluster randomly distribute all dirfrags.  MDS
>>> uses consistent hash to calculate target rank for each dirfrag.
>>> Compared to dynamic balancer and subtree pin, metadata can be
>>> distributed among MDSs more evenly. Besides, MDS only migrates single
>>> dirfrag (instead of big subtree) for load balancing. So MDS has
>>> shorter pause when doing metadata migration.  The drawbacks of this
>>> change are:  stat(2) directory can be slow; rename(2) file to
>>> different directory can be slow. The reason is, with random dirfrag
>>> distribution, these operations likely involve multiple MDS.
>>>
>>> Above three PRs are all merged into an integration branch
>>> https://github.com/ukernel/ceph/tree/wip-mds-integration.
>>>
>>> We (Kuaishou) have run these codes for months, 16 active MDS cluster
>>> serve billions of small files. In file random read test, single MDS
>>> can handle about 6k ops,  performance increases linearly with the
>>> number of active MDS.  In file creation test (mpirun -np 160 -host
>>> xxx:160 mdtest -F -L -w 4096 -z 2 -b 10 -I 200 -u -d ...), 16 active
>>> MDS can serve over 100k file creation per second.
>>>
>>> Yan, Zheng
>>>
>>
