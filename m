Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB59C36D03F
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Apr 2021 03:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbhD1BY2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Apr 2021 21:24:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24874 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230425AbhD1BY1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 21:24:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619573023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a4R/T8iXOjJYaTnfBTfIGsWt5xTtn4AbU8SVk+ysrRQ=;
        b=gs8INvV/b4RzdVikKU6OPwhRJWJV/XgmYg2/q57Ty8eS64fWYqmUFf24MHod9qTK+wqE5P
        aB7aOT89LFdfzdaxp4Yqr07zVqhH2pED3+pYjIh0lUAFP8/9Q+wwUZ2xtVXKnZFZ3SlIJY
        QHfPGCmxep0oGjXPScpz0pY5a8OfFws=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-9HLKCzbbOEasKJZi9__JLw-1; Tue, 27 Apr 2021 21:23:39 -0400
X-MC-Unique: 9HLKCzbbOEasKJZi9__JLw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5E90803624;
        Wed, 28 Apr 2021 01:23:38 +0000 (UTC)
Received: from [10.72.13.181] (ovpn-13-181.pek2.redhat.com [10.72.13.181])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EF3F769FD0;
        Wed, 28 Apr 2021 01:23:36 +0000 (UTC)
Subject: Re: [PATCH v2 1/2] ceph: update the __update_latency helper
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210325032826.1725667-1-xiubli@redhat.com>
 <20210325032826.1725667-2-xiubli@redhat.com>
 <aff17365129ead70f109d96adcf24484d1b12c46.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <4a9ff977-4cae-e129-82fb-393b993f1c82@redhat.com>
Date:   Wed, 28 Apr 2021 09:23:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <aff17365129ead70f109d96adcf24484d1b12c46.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2021/4/28 2:38, Jeff Layton wrote:
> On Thu, 2021-03-25 at 11:28 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Let the __update_latency() helper choose the correcsponding members
>> according to the metric_type.
>>
>> URL: https://tracker.ceph.com/issues/49913
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/metric.c | 73 ++++++++++++++++++++++++++++++++++--------------
>>   1 file changed, 52 insertions(+), 21 deletions(-)
>>
>> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
>> index 28b6b42ad677..f3e68db08760 100644
>> --- a/fs/ceph/metric.c
>> +++ b/fs/ceph/metric.c
>> @@ -285,19 +285,56 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
>>   		ceph_put_mds_session(m->session);
>>   }
>>   
>> -static inline void __update_latency(ktime_t *totalp, ktime_t *lsump,
>> -				    ktime_t *min, ktime_t *max,
>> -				    ktime_t *sq_sump, ktime_t lat)
>> -{
>> -	ktime_t total, avg, sq, lsum;
>> -
>> -	total = ++(*totalp);
>> -	lsum = (*lsump += lat);
>> +typedef enum {
>> +	CEPH_METRIC_READ,
>> +	CEPH_METRIC_WRITE,
>> +	CEPH_METRIC_METADATA,
>> +} metric_type;
>> +
>> +#define METRIC_UPDATE_MIN_MAX(min, max, new)	\
>> +{						\
>> +	if (unlikely(new < min))		\
>> +		min = new;			\
>> +	if (unlikely(new > max))		\
>> +		max = new;			\
>> +}
>>   
>> -	if (unlikely(lat < *min))
>> -		*min = lat;
>> -	if (unlikely(lat > *max))
>> -		*max = lat;
>> +static inline void __update_latency(struct ceph_client_metric *m,
>> +				    metric_type type, ktime_t lat)
>> +{
>> +	ktime_t total, avg, sq, lsum, *sq_sump;
>> +
>> +	switch (type) {
>> +	case CEPH_METRIC_READ:
>> +		total = ++m->total_reads;
>> +		m->read_latency_sum += lat;
>> +		lsum = m->read_latency_sum;
>> +		METRIC_UPDATE_MIN_MAX(m->read_latency_min,
>> +				      m->read_latency_max,
>> +				      lat);
>> +		sq_sump = &m->read_latency_sq_sum;
>> +		break;
>> +	case CEPH_METRIC_WRITE:
>> +		total = ++m->total_writes;
>> +		m->write_latency_sum += lat;
>> +		lsum = m->write_latency_sum;
>> +		METRIC_UPDATE_MIN_MAX(m->write_latency_min,
>> +				      m->write_latency_max,
>> +				      lat);
>> +		sq_sump = &m->write_latency_sq_sum;
>> +		break;
>> +	case CEPH_METRIC_METADATA:
>> +		total = ++m->total_metadatas;
>> +		m->metadata_latency_sum += lat;
>> +		lsum = m->metadata_latency_sum;
>> +		METRIC_UPDATE_MIN_MAX(m->metadata_latency_min,
>> +				      m->metadata_latency_max,
>> +				      lat);
>> +		sq_sump = &m->metadata_latency_sq_sum;
>> +		break;
>> +	default:
>> +		return;
>> +	}
>>   
> I'm not a fan of the above function. __update_latency gets called with
> each of those values only once.
>
> It seems like it'd be better to just open-code the above sections in the
> respective ceph_update_*_metrics functions, and then have a helper
> function for the part of __update_latency below this point. With that,
> you wouldn't need the enum either.

Sounds good to me, will fix it.


>
>>   	if (unlikely(total == 1))
>>   		return;
>> @@ -320,9 +357,7 @@ void ceph_update_read_metrics(struct ceph_client_metric *m,
>>   		return;
>>   
>>   	spin_lock(&m->read_metric_lock);
>> -	__update_latency(&m->total_reads, &m->read_latency_sum,
>> -			 &m->read_latency_min, &m->read_latency_max,
>> -			 &m->read_latency_sq_sum, lat);
>> +	__update_latency(m, CEPH_METRIC_READ, lat);
>>   	spin_unlock(&m->read_metric_lock);
>>   }
>>   
>> @@ -336,9 +371,7 @@ void ceph_update_write_metrics(struct ceph_client_metric *m,
>>   		return;
>>   
>>   	spin_lock(&m->write_metric_lock);
>> -	__update_latency(&m->total_writes, &m->write_latency_sum,
>> -			 &m->write_latency_min, &m->write_latency_max,
>> -			 &m->write_latency_sq_sum, lat);
>> +	__update_latency(m, CEPH_METRIC_WRITE, lat);
>>   	spin_unlock(&m->write_metric_lock);
>>   }
>>   
>> @@ -352,8 +385,6 @@ void ceph_update_metadata_metrics(struct ceph_client_metric *m,
>>   		return;
>>   
>>   	spin_lock(&m->metadata_metric_lock);
>> -	__update_latency(&m->total_metadatas, &m->metadata_latency_sum,
>> -			 &m->metadata_latency_min, &m->metadata_latency_max,
>> -			 &m->metadata_latency_sq_sum, lat);
>> +	__update_latency(m, CEPH_METRIC_METADATA, lat);
>>   	spin_unlock(&m->metadata_metric_lock);
>>   }


