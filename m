Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF06018A933
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Mar 2020 00:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgCRX2p (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Mar 2020 19:28:45 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:35847 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726663AbgCRX2p (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 19:28:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584574124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oziX8rh1zR6ju31rdBew3HOA5v9rYmL3Nc+J4fJDP1U=;
        b=SQBAENC5QhmpcQ9VOBpGiWLsuy/MP0B4zFWHtfofdElXqWFtodNQfOM5BiLrw/K0y20C5G
        pwOXjPmvpFtKlkZhD5CTHM9oWPoj12XjVLG/HvqGCVs0s1f0A0GWb6OIyMVeMziYftwVG6
        eXpCQwmHfUlOFb+JOIR/kiW6kbTKpag=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-k4Eq5K0yPvWVyXUaIQ2PZw-1; Wed, 18 Mar 2020 19:28:41 -0400
X-MC-Unique: k4Eq5K0yPvWVyXUaIQ2PZw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3FF2184D26B;
        Wed, 18 Mar 2020 23:28:40 +0000 (UTC)
Received: from [10.72.12.253] (ovpn-12-253.pek2.redhat.com [10.72.12.253])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E67010002A5;
        Wed, 18 Mar 2020 23:28:33 +0000 (UTC)
Subject: Re: [PATCH v10 0/6] ceph: add perf metrics support
To:     Jeff Layton <jlayton@kernel.org>
Cc:     sage@redhat.com, idryomov@gmail.com, gfarnum@redhat.com,
        zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <1584540356-5885-1-git-send-email-xiubli@redhat.com>
 <ea5551cf7c7e18b5baf6ec990ae1eddedc62ddce.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c74eee4c-110e-9402-bc18-8aec48cb9abb@redhat.com>
Date:   Thu, 19 Mar 2020 07:28:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <ea5551cf7c7e18b5baf6ec990ae1eddedc62ddce.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/3/19 0:01, Jeff Layton wrote:
> On Wed, 2020-03-18 at 10:05 -0400, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Changed in V10:
>> - rebase to the latest testing branch
>> - merge all the metric related patches into one
>> - [1/6] move metric helpers into a new file metric.c
>> - [2/6] move metric helpers into metric.c
>> - [3/6] merge the read/write patches into a signal patch and move metric helpers to metric.c
>> - [4/6] move metric helpers to metric.c
>> - [5/6] min/max latency support
>> - [6/6] standard deviation support
>>
>> Changed in V9:
>> - add an r_ended field to the mds request struct and use that to calculate the metric
>> - fix some commit comments
>>
>> # cat /sys/kernel/debug/ceph/9a972bfc-68cb-4d52-a610-7cd9a9adbbdd.client52904/metrics
>> item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)
>> -----------------------------------------------------------------------------------
>> read          798         32000           4000            196000          560.3
>> write         2394        588000          28000           4812000         36673.9
>> metadata      7           116000          2000            707000          8282.8
>>
>> item          total           miss            hit
>> -------------------------------------------------
>> d_lease       2               0               0
>> caps          2               14              546500
>>
>>
>>
> The code all looks reasonable to me.
>
> Ilya mentioned refactoring the set to add the infrastructure up front
> first. I too think that would be nice, especially since this will
> probably end up being backported to various distros and that would make
> that task simpler.
>
> It might also be nice to merge the add in the min/max/stddev support at
> the same time you add each latency metric too, rather than adding them
> after the fact.
>
>> Xiubo Li (6):
>>    ceph: add dentry lease metric support
>>    ceph: add caps perf metric for each session
>>    ceph: add read/write latency metric support
> Can you fold the min/max/stddev changes for read/write into the above
> patch? I think that would be cleaner, rather than bolting it on after
> the fact.

Sure, will do it.

Thanks.

BRs


>
>>    ceph: add metadata perf metric support
> Same here. That should just leave us with a 4 patch series, I think.
>   
>>    ceph: add min/max latency support for read/write/metadata metrics
>>    ceph: add standard deviation support for read/write/metadata perf
>>      metric
>>
>>   fs/ceph/Makefile                |   2 +-
>>   fs/ceph/acl.c                   |   2 +-
>>   fs/ceph/addr.c                  |  18 ++++
>>   fs/ceph/caps.c                  |  19 ++++
>>   fs/ceph/debugfs.c               | 116 +++++++++++++++++++++++-
>>   fs/ceph/dir.c                   |  17 +++-
>>   fs/ceph/file.c                  |  26 ++++++
>>   fs/ceph/inode.c                 |   4 +-
>>   fs/ceph/mds_client.c            |  21 ++++-
>>   fs/ceph/mds_client.h            |   7 +-
>>   fs/ceph/metric.c                | 193 ++++++++++++++++++++++++++++++++++++++++
>>   fs/ceph/metric.h                |  64 +++++++++++++
>>   fs/ceph/super.h                 |   9 +-
>>   fs/ceph/xattr.c                 |   4 +-
>>   include/linux/ceph/osd_client.h |   1 +
>>   net/ceph/osd_client.c           |   2 +
>>   16 files changed, 487 insertions(+), 18 deletions(-)
>>   create mode 100644 fs/ceph/metric.c
>>   create mode 100644 fs/ceph/metric.h
>>
>
>
> Thanks,


