Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070E1345F42
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Mar 2021 14:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhCWNPD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 23 Mar 2021 09:15:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60754 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231744AbhCWNOv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 23 Mar 2021 09:14:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616505290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a7gX+0oW6nwGhCARTk/YWbgbXZhLRu4GL2iGucqs3QI=;
        b=SQSbDHn5JPg1+1EJNl9rAhbZqAQcwzE2dj1Z+OqowZBtXSDRCwCqSo15bvKZw57WetGLdd
        oCMDFpGEeZcU0K0/n0II7lCBQ4NrjhMMsQS8gbCKX8cA7j5vZAK/+tfuLhtW+5TDSta7Zs
        4ka4vzMt/N1JSKYvvnR3iNqvtAunrZU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-E1tkRRW0MdWhvkgR-MVCPg-1; Tue, 23 Mar 2021 09:14:48 -0400
X-MC-Unique: E1tkRRW0MdWhvkgR-MVCPg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01B4218C8C00;
        Tue, 23 Mar 2021 13:14:47 +0000 (UTC)
Received: from [10.72.12.53] (ovpn-12-53.pek2.redhat.com [10.72.12.53])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 207FD10074FD;
        Tue, 23 Mar 2021 13:14:44 +0000 (UTC)
Subject: Re: [PATCH 2/4] ceph: update the __update_latency helper
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210322122852.322927-1-xiubli@redhat.com>
 <20210322122852.322927-3-xiubli@redhat.com>
 <c836da61eaba7650538cdfe2b37c8c0214d1312a.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3eaf5c43-8c81-b116-b500-7fdfb3e3153f@redhat.com>
Date:   Tue, 23 Mar 2021 21:14:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <c836da61eaba7650538cdfe2b37c8c0214d1312a.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2021/3/23 20:34, Jeff Layton wrote:
> On Mon, 2021-03-22 at 20:28 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Let the __update_latency() helper choose the correcsponding members
>> according to the metric_type.
>>
>> URL: https://tracker.ceph.com/issues/49913
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/metric.c | 58 +++++++++++++++++++++++++++++++++++-------------
>>   1 file changed, 42 insertions(+), 16 deletions(-)
>>
>> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
>> index 75d309f2fb0c..d5560ff99a9d 100644
>> --- a/fs/ceph/metric.c
>> +++ b/fs/ceph/metric.c
>> @@ -249,19 +249,51 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
>>   		ceph_put_mds_session(m->session);
>>   }
>>   
>>
>>
>>
>>
>>
>>
>>
>> -static inline void __update_latency(ktime_t *totalp, ktime_t *lsump,
>> -				    ktime_t *min, ktime_t *max,
>> -				    ktime_t *sq_sump, ktime_t lat)
>> +typedef enum {
>> +	CEPH_METRIC_READ,
>> +	CEPH_METRIC_WRITE,
>> +	CEPH_METRIC_METADATA,
>> +} metric_type;
>> +
>> +static inline void __update_latency(struct ceph_client_metric *m,
>> +				    metric_type type, ktime_t lat)
>>   {
>> +	ktime_t *totalp, *minp, *maxp, *lsump, *sq_sump;
>>   	ktime_t total, avg, sq, lsum;
>>   
>>
>>
>>
>>
>>
>>
>>
>> +	switch (type) {
>> +	case CEPH_METRIC_READ:
>> +		totalp = &m->total_reads;
>> +		lsump = &m->read_latency_sum;
>> +		minp = &m->read_latency_min;
>> +		maxp = &m->read_latency_max;
>> +		sq_sump = &m->read_latency_sq_sum;
>> +		break;
>> +	case CEPH_METRIC_WRITE:
>> +		totalp = &m->total_writes;
>> +		lsump = &m->write_latency_sum;
>> +		minp = &m->write_latency_min;
>> +		maxp = &m->write_latency_max;
>> +		sq_sump = &m->write_latency_sq_sum;
>> +		break;
>> +	case CEPH_METRIC_METADATA:
>> +		totalp = &m->total_metadatas;
>> +		lsump = &m->metadata_latency_sum;
>> +		minp = &m->metadata_latency_min;
>> +		maxp = &m->metadata_latency_max;
>> +		sq_sump = &m->metadata_latency_sq_sum;
>> +		break;
>> +	default:
>> +		return;
>> +	}
>> +
>>   	total = ++(*totalp);
> Why are you adding one to *totalp above? Is that to avoid it being 0?

No, in the old code we will count the 
total_reads/total_writes/total_metadatas for each call of the 
ceph_update_{read/write/metadata}_latency() helpers. And the same here.


>>   	lsum = (*lsump += lat);
>>   
>>
> ^^^
> Instead of doing all of the above with pointers, why not just add to
> total and lsum directly inside the switch statement? This seems like a
> lot of pointless indirection.

Okay, sounds good, will change it.


>>
>>
>>
>>
>> -	if (unlikely(lat < *min))
>> -		*min = lat;
>> -	if (unlikely(lat > *max))
>> -		*max = lat;
>> +	if (unlikely(lat < *minp))
>> +		*minp = lat;
>> +	if (unlikely(lat > *maxp))
>> +		*maxp = lat;
>>   
>>
>>
>>
>>   	if (unlikely(total == 1))
>>   		return;
>> @@ -284,9 +316,7 @@ void ceph_update_read_metrics(struct ceph_client_metric *m,
>>   		return;
>>   
>>
>>
>>
>>   	spin_lock(&m->read_metric_lock);
>> -	__update_latency(&m->total_reads, &m->read_latency_sum,
>> -			 &m->read_latency_min, &m->read_latency_max,
>> -			 &m->read_latency_sq_sum, lat);
>> +	__update_latency(m, CEPH_METRIC_READ, lat);
>>   	spin_unlock(&m->read_metric_lock);
>>   }
>>   
>>
>>
>>
>> @@ -300,9 +330,7 @@ void ceph_update_write_metrics(struct ceph_client_metric *m,
>>   		return;
>>   
>>
>>
>>
>>   	spin_lock(&m->write_metric_lock);
>> -	__update_latency(&m->total_writes, &m->write_latency_sum,
>> -			 &m->write_latency_min, &m->write_latency_max,
>> -			 &m->write_latency_sq_sum, lat);
>> +	__update_latency(m, CEPH_METRIC_WRITE, lat);
>>   	spin_unlock(&m->write_metric_lock);
>>   }
>>   
>>
>>
>>
>> @@ -316,8 +344,6 @@ void ceph_update_metadata_metrics(struct ceph_client_metric *m,
>>   		return;
>>   
>>
>>
>>
>>   	spin_lock(&m->metadata_metric_lock);
>> -	__update_latency(&m->total_metadatas, &m->metadata_latency_sum,
>> -			 &m->metadata_latency_min, &m->metadata_latency_max,
>> -			 &m->metadata_latency_sq_sum, lat);
>> +	__update_latency(m, CEPH_METRIC_METADATA, lat);
>>   	spin_unlock(&m->metadata_metric_lock);
>>   }


