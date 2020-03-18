Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9F618998F
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Mar 2020 11:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbgCRKgP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Mar 2020 06:36:15 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:26854 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726486AbgCRKgO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 06:36:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584527774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sedKzVJTNAn+j3Ob1NUQSwjlbfJWRd/i7mjKMyeLS+A=;
        b=R2qLOl6gPQGH7F+e7jPSH2I8OjDj63YudH0GGGGVAByv85gGbZ+M6mdmVE95j1Gzawsw+F
        Qikm2vtH6wsE4mivETEX86RUgDO2N8U1s1Ta0Boq5n/ks9BBtLj4MPCr10Nb+XUXz/0k/Z
        gI+3BZpeFgGhtgm7JuG/9VW00Ks/Zcg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-F74lvQeMPPeXkfmIAwzfew-1; Wed, 18 Mar 2020 06:36:10 -0400
X-MC-Unique: F74lvQeMPPeXkfmIAwzfew-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5683F1005509;
        Wed, 18 Mar 2020 10:36:09 +0000 (UTC)
Received: from [10.72.12.253] (ovpn-12-253.pek2.redhat.com [10.72.12.253])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 431CC94956;
        Wed, 18 Mar 2020 10:36:03 +0000 (UTC)
Subject: Re: [PATCH v4 0/4] ceph: add min/max/stdev latency support
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <1584510355-6936-1-git-send-email-xiubli@redhat.com>
 <CAOi1vP_gj6TuJHjKdyWCf47ukKgszJE30-BnrvxjD7cu5VnV0Q@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c980a7e9-95fd-97db-e851-7f83c35d6d96@redhat.com>
Date:   Wed, 18 Mar 2020 18:36:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP_gj6TuJHjKdyWCf47ukKgszJE30-BnrvxjD7cu5VnV0Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/3/18 17:11, Ilya Dryomov wrote:
> On Wed, Mar 18, 2020 at 6:46 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Changed in V4:
>> - fix the 32-bit arches div errors by using DIV64_U64_ROUND_CLOSEST instead. [1/4]
>> - rebase and combine the stdev patch series [3/4][4/4]
>> - remove the sum latency showing, which makes no sense for debugging, if it
>>    is really needed in some case then just do (avg * total) in userland. [4/4]
>> - switch {read/write/metadata}_latency_sum to atomic type since it will be
>>    readed very time when updating the latencies to calculate the stdev. [4/4]
>>
>> Changed in V2:
>> - switch spin lock to cmpxchg [1/4]
>>
>> Changed in V3:
>> - add the __update_min/max_latency helpers [1/4]
>>
>>
>>
>> # cat /sys/kernel/debug/ceph/0f923fe5-00e6-4866-bf01-2027cb75e94b.client4150/metrics
>> item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)
>> -----------------------------------------------------------------------------------
>> read          2312        9000            1000            100000          607.4
>> write         21777       925000          2000            44551000        29700.3
>> metadata      6           4179000         1000            21414000        19590.8
>>
>> item          total           miss            hit
>> -------------------------------------------------
>> d_lease       2               0               11
>> caps          2               14              398418
>>
>>
>>
>> Xiubo Li (4):
>>    ceph: switch to DIV64_U64_ROUND_CLOSEST to support 32-bit arches
>>    ceph: add min/max latency support for read/write/metadata metrics
>>    ceph: move the metric helpers into one separate file
>>    ceph: add standard deviation support for read/write/metadata perf
>>      metric
>>
>>   fs/ceph/Makefile     |   2 +-
>>   fs/ceph/debugfs.c    |  89 ++++++++++++++++++------
>>   fs/ceph/mds_client.c |  83 +---------------------
>>   fs/ceph/metric.c     | 190 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>   fs/ceph/metric.h     |  79 +++++++++++----------
>>   5 files changed, 297 insertions(+), 146 deletions(-)
>>   create mode 100644 fs/ceph/metric.c
> Hi Xiubo,
>
> I think these additions need to be merged with your previous series,
> so that the history is clean.  Ideally the whole thing would start with
> a single patch adding all of the metrics infrastructure to metric.[ch],
> followed by patches introducing new metrics and ceph_update_*() calls.
>
> Related metrics and ceph_update_*() calls should be added together.
> No point in splitting read and write OSD latency in two patches as they
> touch the same functions in addr.c and file.c.

Hi Ilya,

Yeah, it makes sense and I will merge all the related patch series about 
the metric and post it again.

Thanks

BRs

> Thanks,
>
>                  Ilya
>

