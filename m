Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD43540B049
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Sep 2021 16:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbhINOLm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Sep 2021 10:11:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26550 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233349AbhINOLl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 10:11:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631628624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BuO5FDL06dJf/e1XrgfOuqFWl8AwEqpu/OyvUZnrumQ=;
        b=R1mYvPwwlU+K431xRLYZQoE0xyvNVKFS8uhYwcNXddMWc1Q7yJ0utJXCbNdcW4Z4tbiKTx
        qbLCabVHcGQaXeo+4W2nibMOXp8d4MQ7DTjIvWYDxerswSzKk/VlahHg7yq/eeVU6x80AJ
        h0uKGASwf6Zut1gvXnnYnS6vZRUyLKc=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-fpydAHFWPCigdOLhw4TcoA-1; Tue, 14 Sep 2021 10:10:23 -0400
X-MC-Unique: fpydAHFWPCigdOLhw4TcoA-1
Received: by mail-pf1-f198.google.com with SMTP id m26-20020a62a21a000000b0041361973ba7so8324877pff.15
        for <ceph-devel@vger.kernel.org>; Tue, 14 Sep 2021 07:10:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=BuO5FDL06dJf/e1XrgfOuqFWl8AwEqpu/OyvUZnrumQ=;
        b=TRefYYH73k8/Pw6f42KwBWZRpom6+OWBes1jBKFc+jM6uv9V3PcHT90xLUjSzXpZd+
         9zH3xeEHgmVqWqh7DaNP/EBjuKWmPS8uoTP5IsVcwOBeeFxATaL15qJ0JaNcSTi4AusF
         kWidF9mqPQoMiTmgp4G05n2KY8oktEbrU2IaWpsim8iV0OE9PBp+kqY9hAdT0gV0zwUX
         c5rSCu3nNSwXsj0V9XQJ7pldtN0nsXfOU19WQPqFkgzeLLgiIX1pekCk00eaSw5wtpBk
         FYbchQAOuDarcOEdkOtm+aupxOPU1CXbn1c4LwNrBE1zxDTN86+Vj7/RDNUkxeETHIYU
         HTTA==
X-Gm-Message-State: AOAM53042q3zYChEgKyzscDmNFBOADo/vatjDQp8+Y78oUn7efe+x9Oz
        PTlCYab8kg4XgHsmf/q2naKWu/WpAcGXGKAR5y+eqm6FtRgFgvApsCJ6zmC2ldjVADYZrN9grp7
        /oWlDcVrjTGlCVBeuDSipf4VyEJz8Ybj4tnmyS8VbNQv+YfHBV7cNpLtWva56QMFVgmI2liM=
X-Received: by 2002:a05:6a00:234f:b0:3eb:3ffd:6da2 with SMTP id j15-20020a056a00234f00b003eb3ffd6da2mr4992754pfj.15.1631628622029;
        Tue, 14 Sep 2021 07:10:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzb0WH2CuIH1l3MZK0em/8U5A5twhMro2z7fSFwqlaLiaW+nXZfSjDNje04F0FLwnFx/YY9Gw==
X-Received: by 2002:a05:6a00:234f:b0:3eb:3ffd:6da2 with SMTP id j15-20020a056a00234f00b003eb3ffd6da2mr4992700pfj.15.1631628621360;
        Tue, 14 Sep 2021 07:10:21 -0700 (PDT)
Received: from [10.72.12.89] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o14sm11768435pgl.85.2021.09.14.07.10.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 07:10:20 -0700 (PDT)
Subject: Re: [PATCH v2 2/4] ceph: track average/stdev r/w/m latency
To:     Venky Shankar <vshankar@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <20210914084902.1618064-1-vshankar@redhat.com>
 <20210914084902.1618064-3-vshankar@redhat.com>
 <15cd06ae-fe96-c376-854d-738d4a2e70bf@redhat.com>
 <CACPzV1=A4CYvvrkBM1KKMrzYHJFyrMshQ_Qg9F=tXGQdfERK7g@mail.gmail.com>
 <537fc647-249b-d4e8-2139-90cda31b634c@redhat.com>
 <02fe4258-a0c5-0d79-7331-b61a7266b5fd@redhat.com>
 <CACPzV1kYU7fknFmiTqns1iHFEOiKhGYCbcjeCq5wdsb7JT81_A@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <ae906a4e-f626-d2ce-d357-e3a48365ee81@redhat.com>
Date:   Tue, 14 Sep 2021 22:10:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CACPzV1kYU7fknFmiTqns1iHFEOiKhGYCbcjeCq5wdsb7JT81_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/14/21 10:00 PM, Venky Shankar wrote:
> On Tue, Sep 14, 2021 at 7:22 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 9/14/21 9:45 PM, Xiubo Li wrote:
>>> On 9/14/21 9:30 PM, Venky Shankar wrote:
>>>> On Tue, Sep 14, 2021 at 6:39 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>>> On 9/14/21 4:49 PM, Venky Shankar wrote:
>> [...]
>>> In user space this is very easy to do, but not in kernel space,
>>> especially there has no float computing.
>>>
>> As I remembered this is main reason why I was planing to send the raw
>> metrics to MDS and let the MDS do the computing.
>>
>> So if possible why not just send the raw data to MDS and let the MDS to
>> do the stdev computing ?
> Since metrics are sent each second (I suppose) and there can be N
> operations done within that second, what raw data (say for avg/stdev
> calculation) would the client send to the MDS?

Yeah.

For example, just send the "sq_sum" and the total numbers to MDS, these 
should be enough to compute the stdev. And in MDS or cephfs-top tool can 
just do it by int_sqrt(sq_sum / total).

I am okay with both and it's up to you, but the stdev could be more 
accurate in userspace with float computing.


>
>>
>>> Currently the kclient is doing the avg computing by:
>>>
>>> avg(n) = (avg(n-1) + latency(n)) / (n), IMO this should be closer to
>>> the real avg(n) = sum(latency(n), latency(n-1), ..., latency(1)) / n.
>>>
>>> Because it's hard to record all the latency values, this is also many
>>> other user space tools doing to count the avg.
>>>
>>>
>>>>> Though current stdev computing method is not exactly the same the math
>>>>> formula does, but it's closer to it, because the kernel couldn't record
>>>>> all the latency value and do it whenever needed, which will occupy a
>>>>> large amount of memories and cpu resources.
>>>> The approach is to calculate the running variance, I.e., compute the
>>>> variance as  data (latency) arrive one at a time.
>>>>
>>>>>>     }
>>>>>>
>>>>>>     void ceph_update_read_metrics(struct ceph_client_metric *m,
>>>>>> @@ -343,23 +352,18 @@ void ceph_update_read_metrics(struct
>>>>>> ceph_client_metric *m,
>>>>>>                               unsigned int size, int rc)
>>>>>>     {
>>>>>>         ktime_t lat = ktime_sub(r_end, r_start);
>>>>>> -     ktime_t total;
>>>>>>
>>>>>>         if (unlikely(rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT))
>>>>>>                 return;
>>>>>>
>>>>>>         spin_lock(&m->read_metric_lock);
>>>>>> -     total = ++m->total_reads;
>>>>>>         m->read_size_sum += size;
>>>>>> -     m->read_latency_sum += lat;
>>>>>>         METRIC_UPDATE_MIN_MAX(m->read_size_min,
>>>>>>                               m->read_size_max,
>>>>>>                               size);
>>>>>> -     METRIC_UPDATE_MIN_MAX(m->read_latency_min,
>>>>>> -                           m->read_latency_max,
>>>>>> -                           lat);
>>>>>> -     __update_stdev(total, m->read_latency_sum,
>>>>>> -                    &m->read_latency_sq_sum, lat);
>>>>>> +     __update_latency(&m->total_reads, &m->read_latency_sum,
>>>>>> +                      &m->avg_read_latency, &m->read_latency_min,
>>>>>> +                      &m->read_latency_max,
>>>>>> &m->read_latency_stdev, lat);
>>>>>>         spin_unlock(&m->read_metric_lock);
>>>>>>     }
>>>>>>
>>>>>> @@ -368,23 +372,18 @@ void ceph_update_write_metrics(struct
>>>>>> ceph_client_metric *m,
>>>>>>                                unsigned int size, int rc)
>>>>>>     {
>>>>>>         ktime_t lat = ktime_sub(r_end, r_start);
>>>>>> -     ktime_t total;
>>>>>>
>>>>>>         if (unlikely(rc && rc != -ETIMEDOUT))
>>>>>>                 return;
>>>>>>
>>>>>>         spin_lock(&m->write_metric_lock);
>>>>>> -     total = ++m->total_writes;
>>>>>>         m->write_size_sum += size;
>>>>>> -     m->write_latency_sum += lat;
>>>>>>         METRIC_UPDATE_MIN_MAX(m->write_size_min,
>>>>>>                               m->write_size_max,
>>>>>>                               size);
>>>>>> -     METRIC_UPDATE_MIN_MAX(m->write_latency_min,
>>>>>> -                           m->write_latency_max,
>>>>>> -                           lat);
>>>>>> -     __update_stdev(total, m->write_latency_sum,
>>>>>> -                    &m->write_latency_sq_sum, lat);
>>>>>> +     __update_latency(&m->total_writes, &m->write_latency_sum,
>>>>>> +                      &m->avg_write_latency, &m->write_latency_min,
>>>>>> +                      &m->write_latency_max,
>>>>>> &m->write_latency_stdev, lat);
>>>>>>         spin_unlock(&m->write_metric_lock);
>>>>>>     }
>>>>>>
>>>>>> @@ -393,18 +392,13 @@ void ceph_update_metadata_metrics(struct
>>>>>> ceph_client_metric *m,
>>>>>>                                   int rc)
>>>>>>     {
>>>>>>         ktime_t lat = ktime_sub(r_end, r_start);
>>>>>> -     ktime_t total;
>>>>>>
>>>>>>         if (unlikely(rc && rc != -ENOENT))
>>>>>>                 return;
>>>>>>
>>>>>>         spin_lock(&m->metadata_metric_lock);
>>>>>> -     total = ++m->total_metadatas;
>>>>>> -     m->metadata_latency_sum += lat;
>>>>>> -     METRIC_UPDATE_MIN_MAX(m->metadata_latency_min,
>>>>>> -                           m->metadata_latency_max,
>>>>>> -                           lat);
>>>>>> -     __update_stdev(total, m->metadata_latency_sum,
>>>>>> -                    &m->metadata_latency_sq_sum, lat);
>>>>>> +     __update_latency(&m->total_metadatas, &m->metadata_latency_sum,
>>>>>> +                      &m->avg_metadata_latency,
>>>>>> &m->metadata_latency_min,
>>>>>> +                      &m->metadata_latency_max,
>>>>>> &m->metadata_latency_stdev, lat);
>>>>>>         spin_unlock(&m->metadata_metric_lock);
>>>>>>     }
>>>>>> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
>>>>>> index 103ed736f9d2..a5da21b8f8ed 100644
>>>>>> --- a/fs/ceph/metric.h
>>>>>> +++ b/fs/ceph/metric.h
>>>>>> @@ -138,7 +138,8 @@ struct ceph_client_metric {
>>>>>>         u64 read_size_min;
>>>>>>         u64 read_size_max;
>>>>>>         ktime_t read_latency_sum;
>>>>>> -     ktime_t read_latency_sq_sum;
>>>>>> +     ktime_t avg_read_latency;
>>>>>> +     ktime_t read_latency_stdev;
>>>>>>         ktime_t read_latency_min;
>>>>>>         ktime_t read_latency_max;
>>>>>>
>>>>>> @@ -148,14 +149,16 @@ struct ceph_client_metric {
>>>>>>         u64 write_size_min;
>>>>>>         u64 write_size_max;
>>>>>>         ktime_t write_latency_sum;
>>>>>> -     ktime_t write_latency_sq_sum;
>>>>>> +     ktime_t avg_write_latency;
>>>>>> +     ktime_t write_latency_stdev;
>>>>>>         ktime_t write_latency_min;
>>>>>>         ktime_t write_latency_max;
>>>>>>
>>>>>>         spinlock_t metadata_metric_lock;
>>>>>>         u64 total_metadatas;
>>>>>>         ktime_t metadata_latency_sum;
>>>>>> -     ktime_t metadata_latency_sq_sum;
>>>>>> +     ktime_t avg_metadata_latency;
>>>>>> +     ktime_t metadata_latency_stdev;
>>>>>>         ktime_t metadata_latency_min;
>>>>>>         ktime_t metadata_latency_max;
>>>>>>
>

