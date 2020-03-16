Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A627186DAE
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Mar 2020 15:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731617AbgCPOpx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 Mar 2020 10:45:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54784 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731608AbgCPOpx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 16 Mar 2020 10:45:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584369952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lREgHkq2EYfy4v0f1NNzB3DjTcgPRb5FTi+LO0AoPEA=;
        b=PbFA4nBM40DTUYENf80ffCDN0Rg6AVVMwEAksSERhBIUWo6YNj3I6u2SJYWq4uoT6Z7Uf9
        PJyNZFhaV7AMZEmMIXQM2xVom54Qffnl55vAtY4lIeq0Gv92/TFRwxSXnFMl9pOOs6pXej
        s9JlDLpSZKua6T0NviWT8bmog7WmBSc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-4FhFXZmlOsW9rM9BnghjwQ-1; Mon, 16 Mar 2020 10:45:48 -0400
X-MC-Unique: 4FhFXZmlOsW9rM9BnghjwQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10129800D54;
        Mon, 16 Mar 2020 14:45:47 +0000 (UTC)
Received: from [10.72.12.126] (ovpn-12-126.pek2.redhat.com [10.72.12.126])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 43BEC92F8E;
        Mon, 16 Mar 2020 14:45:41 +0000 (UTC)
Subject: Re: [PATCH] ceph: add min/max latency support for read/write/metadata
 metrics
To:     Jeff Layton <jlayton@kernel.org>
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        gfarnum@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <1583807817-5571-1-git-send-email-xiubli@redhat.com>
 <b5ec20ab1fc00315603c462124501d919cecacc8.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <381ac866-630e-cd4b-7320-5993e6b5003a@redhat.com>
Date:   Mon, 16 Mar 2020 22:45:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <b5ec20ab1fc00315603c462124501d919cecacc8.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/3/16 22:21, Jeff Layton wrote:
> On Mon, 2020-03-09 at 22:36 -0400, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> These will be very useful help diagnose problems.
>>
>> URL: https://tracker.ceph.com/issues/44533
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> The output will be like:
>>
>> # cat /sys/kernel/debug/ceph/19e31430-fc65-4aa1-99cf-2c8eaaafd451.client4347/metrics
>> item          total       sum_lat(us)     avg_lat(us)     min_lat(us)     max_lat(us)
>> -------------------------------------------------------------------------------------
>> read          27          297000          11000           2000            27000
>> write         16          3860000         241250          175000          263000
>> metadata      3           30000           10000           2000            16000
>>
>> item          total           miss            hit
>> -------------------------------------------------
>> d_lease       2               0               1
>> caps          2               0               3078
>>
>>
>>
>>   fs/ceph/debugfs.c    | 27 ++++++++++++++++++++------
>>   fs/ceph/mds_client.c | 12 ++++++++++++
>>   fs/ceph/metric.h     | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>>   3 files changed, 86 insertions(+), 7 deletions(-)
>>
>>
>> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
>> index faba142..9f0d050 100644
>> --- a/fs/ceph/metric.h
>> +++ b/fs/ceph/metric.h
>> @@ -2,6 +2,10 @@
>>   #ifndef _FS_CEPH_MDS_METRIC_H
>>   #define _FS_CEPH_MDS_METRIC_H
>>   
>> +#include <linux/atomic.h>
>> +#include <linux/percpu.h>
>> +#include <linux/spinlock.h>
>> +
>>   /* This is the global metrics */
>>   struct ceph_client_metric {
>>   	atomic64_t            total_dentries;
>> @@ -13,12 +17,21 @@ struct ceph_client_metric {
>>   
>>   	struct percpu_counter total_reads;
>>   	struct percpu_counter read_latency_sum;
>> +	spinlock_t read_latency_lock;
>> +	atomic64_t read_latency_min;
>> +	atomic64_t read_latency_max;
>>   
>>   	struct percpu_counter total_writes;
>>   	struct percpu_counter write_latency_sum;
>> +	spinlock_t write_latency_lock;
>> +	atomic64_t write_latency_min;
>> +	atomic64_t write_latency_max;
>>   
>>   	struct percpu_counter total_metadatas;
>>   	struct percpu_counter metadata_latency_sum;
>> +	spinlock_t metadata_latency_lock;
>> +	atomic64_t metadata_latency_min;
>> +	atomic64_t metadata_latency_max;
>>   };
>>   
>>   static inline void ceph_update_cap_hit(struct ceph_client_metric *m)
>> @@ -36,11 +49,24 @@ static inline void ceph_update_read_latency(struct ceph_client_metric *m,
>>   					    unsigned long r_end,
>>   					    int rc)
>>   {
>> +	unsigned long lat = r_end - r_start;
>> +
>>   	if (rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT)
>>   		return;
>>   
>>   	percpu_counter_inc(&m->total_reads);
>> -	percpu_counter_add(&m->read_latency_sum, r_end - r_start);
>> +	percpu_counter_add(&m->read_latency_sum, lat);
>> +
>> +	if (lat >= atomic64_read(&m->read_latency_min) &&
>> +	    lat <= atomic64_read(&m->read_latency_max))
>> +		return;
>> +
>> +	spin_lock(&m->read_latency_lock);
>> +	if (lat < atomic64_read(&m->read_latency_min))
>> +		atomic64_set(&m->read_latency_min, lat);
>> +	if (lat > atomic64_read(&m->read_latency_max))
>> +		atomic64_set(&m->read_latency_max, lat);
>> +	spin_unlock(&m->read_latency_lock);
>>   }
>>   
> Looks reasonable overall. I do sort of wonder if we really need
> spinlocks for these though. Might it be more efficient to use cmpxchg
> instead? i.e.:
>
> cur = atomic64_read(&m->read_latency_min);
> do {
> 	old = cur;
> 	if (likely(lat >= old))
> 		break;
> } while ((cur = atomic_long_cmpxchg(&m->read_latency_min, old, lat)) != old);

IMO the above case should be more efficient here.

Let me post the V2 to fix it.

BRs


> ...another idea might be to use a seqlock and non-atomic vars.
>
> Mostly this shouldn't matter much though as we'll almost always be
> hitting the non-locking fastpath. I'll plan to merge this as-is unless
> you want to rework it.


