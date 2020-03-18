Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D685C1899E4
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Mar 2020 11:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbgCRKui (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Mar 2020 06:50:38 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:59043 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727113AbgCRKui (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 06:50:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584528637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ipmOfwVHdgs35Kt0ccERC8VSTxtHL/a0KeAL3/uPvHk=;
        b=XT/7w+nMOhEq5jt5YfO3OT6Vudv6V285utiuIZeiycrz0l+D7r+Bi3nM98fufCFKE8XkQh
        BngW+mqfg0tq8XKkYfzvmf8CwJC7qWfxWHjLKEaRlXeJPozuc4CLeboFHj5iJDjsHtdIp4
        vQtjBgY2UyCAbt2JwkUUO8kCqEsRSRM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-3z0kWP3UN-CvrZve_YBp3A-1; Wed, 18 Mar 2020 06:50:33 -0400
X-MC-Unique: 3z0kWP3UN-CvrZve_YBp3A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B30A4107ACC9;
        Wed, 18 Mar 2020 10:50:32 +0000 (UTC)
Received: from [10.72.12.253] (ovpn-12-253.pek2.redhat.com [10.72.12.253])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A40D17E301;
        Wed, 18 Mar 2020 10:50:27 +0000 (UTC)
Subject: Re: [PATCH v4 0/4] ceph: add min/max/stdev latency support
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     Sage Weil <sage@redhat.com>, Gregory Farnum <gfarnum@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <1584510355-6936-1-git-send-email-xiubli@redhat.com>
 <CAOi1vP_gj6TuJHjKdyWCf47ukKgszJE30-BnrvxjD7cu5VnV0Q@mail.gmail.com>
 <c980a7e9-95fd-97db-e851-7f83c35d6d96@redhat.com>
 <bc219cca2ad17b85b02b67b515e36d608e3229a1.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <4f95390a-72d8-9cee-bc92-a0aa8fabb8e8@redhat.com>
Date:   Wed, 18 Mar 2020 18:50:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <bc219cca2ad17b85b02b67b515e36d608e3229a1.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/3/18 18:43, Jeff Layton wrote:
> On Wed, 2020-03-18 at 18:36 +0800, Xiubo Li wrote:
>> On 2020/3/18 17:11, Ilya Dryomov wrote:
>>> On Wed, Mar 18, 2020 at 6:46 AM <xiubli@redhat.com> wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> Changed in V4:
>>>> - fix the 32-bit arches div errors by using DIV64_U64_ROUND_CLOSEST instead. [1/4]
>>>> - rebase and combine the stdev patch series [3/4][4/4]
>>>> - remove the sum latency showing, which makes no sense for debugging, if it
>>>>     is really needed in some case then just do (avg * total) in userland. [4/4]
>>>> - switch {read/write/metadata}_latency_sum to atomic type since it will be
>>>>     readed very time when updating the latencies to calculate the stdev. [4/4]
>>>>
>>>> Changed in V2:
>>>> - switch spin lock to cmpxchg [1/4]
>>>>
>>>> Changed in V3:
>>>> - add the __update_min/max_latency helpers [1/4]
>>>>
>>>>
>>>>
>>>> # cat /sys/kernel/debug/ceph/0f923fe5-00e6-4866-bf01-2027cb75e94b.client4150/metrics
>>>> item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)
>>>> -----------------------------------------------------------------------------------
>>>> read          2312        9000            1000            100000          607.4
>>>> write         21777       925000          2000            44551000        29700.3
>>>> metadata      6           4179000         1000            21414000        19590.8
>>>>
>>>> item          total           miss            hit
>>>> -------------------------------------------------
>>>> d_lease       2               0               11
>>>> caps          2               14              398418
>>>>
>>>>
>>>>
>>>> Xiubo Li (4):
>>>>     ceph: switch to DIV64_U64_ROUND_CLOSEST to support 32-bit arches
>>>>     ceph: add min/max latency support for read/write/metadata metrics
>>>>     ceph: move the metric helpers into one separate file
>>>>     ceph: add standard deviation support for read/write/metadata perf
>>>>       metric
>>>>
>>>>    fs/ceph/Makefile     |   2 +-
>>>>    fs/ceph/debugfs.c    |  89 ++++++++++++++++++------
>>>>    fs/ceph/mds_client.c |  83 +---------------------
>>>>    fs/ceph/metric.c     | 190 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>    fs/ceph/metric.h     |  79 +++++++++++----------
>>>>    5 files changed, 297 insertions(+), 146 deletions(-)
>>>>    create mode 100644 fs/ceph/metric.c
>>> Hi Xiubo,
>>>
>>> I think these additions need to be merged with your previous series,
>>> so that the history is clean.  Ideally the whole thing would start with
>>> a single patch adding all of the metrics infrastructure to metric.[ch],
>>> followed by patches introducing new metrics and ceph_update_*() calls.
>>>
>>> Related metrics and ceph_update_*() calls should be added together.
>>> No point in splitting read and write OSD latency in two patches as they
>>> touch the same functions in addr.c and file.c.
>> Hi Ilya,
>>
>> Yeah, it makes sense and I will merge all the related patch series about
>> the metric and post it again.
>>
> Sounds good. I've gone ahead and dropped all of the metrics patches from
> the "testing" branch for now. Please resend the whole series and I'll
> re-merge them.

Sure, thanks Jeff.

BRs


> Thanks,


