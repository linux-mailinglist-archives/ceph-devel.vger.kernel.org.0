Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F2820F56C
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jun 2020 15:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgF3NJu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Jun 2020 09:09:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39220 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725963AbgF3NJt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 Jun 2020 09:09:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593522588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=djjEuBNDM4WhPGflfGeB9SMBFyYaigc8UHD5rS6MiS4=;
        b=Kc3L41tHzkHAXTvmUFb2bbNS279r0wd7tZOZvVZL9R+rIDOmIgYovmhss8JLFEbvoZNRWK
        O8qFL9Culd+2aqK+d2ifCui689gURJq5KNIWOZOpYMagKN/+PQJf3UZ8niDriiJzWyzHWo
        6n6xucbN9BgBidvWQrwewdGVsfDlSK4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-Q9foaf_3Ori7Uy7xuLuhuA-1; Tue, 30 Jun 2020 09:09:39 -0400
X-MC-Unique: Q9foaf_3Ori7Uy7xuLuhuA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9BF4BFD8;
        Tue, 30 Jun 2020 13:09:27 +0000 (UTC)
Received: from [10.72.13.235] (ovpn-13-235.pek2.redhat.com [10.72.13.235])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B419A1024866;
        Tue, 30 Jun 2020 13:09:25 +0000 (UTC)
Subject: Re: [PATCH v5 0/5] ceph: periodically send perf metrics to ceph
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <1593503539-1209-1-git-send-email-xiubli@redhat.com>
 <ace7fb8b8caf88dd9dcdb9341fa6d3f396a42222.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <1f86621e-206d-8e8a-79b6-eb64447c9480@redhat.com>
Date:   Tue, 30 Jun 2020 21:09:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <ace7fb8b8caf88dd9dcdb9341fa6d3f396a42222.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/6/30 21:02, Jeff Layton wrote:
> On Tue, 2020-06-30 at 03:52 -0400, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This series is based the previous patches of the metrics in kceph[1]
>> and mds daemons record and forward client side metrics to manager[2][3].
>>
>> This will send the caps/read/write/metadata metrics to any available
>> MDS only once per second, which will be the same as the userland client.
>> We could disable it via the disable_send_metrics module parameter.
>>
>> In mdsc->metric we have two new members:
>> 'metric.mds': save the available and valid MDS rank number to send the
>>                metrics to.
>> 'metric.mds_cnt: how many MDSs support the metric collection feature.
>>
>> Only when '!disable_send_metric && metric.mds_cnt > 0' will the workqueue
>> job keep alive.
>>
>>
>> And will also send the metric flags to MDS, currently it supports the
>> cap, read latency, write latency and metadata latency.
>>
>> Also have pushed this series to github [4].
>>
>> [1] https://patchwork.kernel.org/project/ceph-devel/list/?series=238907 [Merged]
>> [2] https://github.com/ceph/ceph/pull/26004 [Merged]
>> [3] https://github.com/ceph/ceph/pull/35608 [Merged]
>> [4] https://github.com/lxbsz/ceph-client/commits/perf_metric5
>>
>> Changes in V5:
>> - rename enable_send_metrics --> disable_send_metrics
>> - switch back to a single workqueue job.
>> - 'list' --> 'metric_wakeup'
>>
>> Changes in V4:
>> - WARN_ON --> WARN_ON_ONCE
>> - do not send metrics when no mds suppor the metric collection.
>> - add global total_caps in mdsc->metric
>> - add the delayed work for each session and choose one to send the metrics to get rid of the mdsc->mutex lock
>>
>> Changed in V3:
>> - fold "check the METRIC_COLLECT feature before sending metrics" into previous one
>> - use `enable_send_metrics` on/off switch instead
>>
>> Changed in V2:
>> - split the patches into small ones as possible.
>> - check the METRIC_COLLECT feature before sending metrics
>> - switch to WARN_ON and bubble up errnos to the callers
>>
>>
>>
>>
>> Xiubo Li (5):
>>    ceph: add check_session_state helper and make it global
>>    ceph: add global total_caps to count the mdsc's total caps number
>>    ceph: periodically send perf metrics to ceph
>>    ceph: switch to WARN_ON_ONCE and bubble up errnos to the callers
>>    ceph: send client provided metric flags in client metadata
>>
>>   fs/ceph/caps.c               |   2 +
>>   fs/ceph/debugfs.c            |  14 +---
>>   fs/ceph/mds_client.c         | 166 ++++++++++++++++++++++++++++++++++---------
>>   fs/ceph/mds_client.h         |   7 +-
>>   fs/ceph/metric.c             | 158 ++++++++++++++++++++++++++++++++++++++++
>>   fs/ceph/metric.h             |  96 +++++++++++++++++++++++++
>>   fs/ceph/super.c              |  42 +++++++++++
>>   fs/ceph/super.h              |   2 +
>>   include/linux/ceph/ceph_fs.h |   1 +
>>   9 files changed, 442 insertions(+), 46 deletions(-)
>>
> Hi Xiubo,
>
> I'm going to go ahead and merge patches 1,2 and 4 out of this series.
> They look like they should stand just fine on their own, and we can
> focus on the last two stats patches in the series that way.
>
> Let me know if you'd rather I not.

Sure, go ahead.

Thanks Jeff.


>
> Thanks,


