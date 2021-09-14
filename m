Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897C440AF9D
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Sep 2021 15:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbhINNx3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Sep 2021 09:53:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34785 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232420AbhINNx2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:53:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631627530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OLinPNxMCqoupKziFTg4vT4jzZ0M/h2QV3SwVEfhmCE=;
        b=FMWFq5UKE4+FCi8LjwgMGXHZUH2HVj5KYYG02ehN8J/zwq3Ph2qfrbnrYvwW17oQZPCcq5
        Jnvw9d0Rc9+CgLEy1hzRK19872fdUVqhpheRp4ELwZibl4EXGtJu1gADAbYvzqsY2731B+
        zhOEkM6fDsbNTjftdpxgZjArHnRwIt8=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-Ai6vhUsRN9ekEUBwE7F39A-1; Tue, 14 Sep 2021 09:52:09 -0400
X-MC-Unique: Ai6vhUsRN9ekEUBwE7F39A-1
Received: by mail-pl1-f199.google.com with SMTP id m5-20020a170902bb8500b0013a2b785187so4588426pls.11
        for <ceph-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:52:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=OLinPNxMCqoupKziFTg4vT4jzZ0M/h2QV3SwVEfhmCE=;
        b=3f0shqd5d7Ct9P33qlpINFuDod1kZatcYSGHxlpKwKi3t3IVJZQgU6s3xyB7Cks3du
         1V6z7q0a9IFb6kYUENAznURRaiTAyKoOY1bkaePnkxZ/qn15uWU6rWpcR3h/oIu6cc72
         Q7NT62qNuS5F2U0RVxouBEmTMh1ovezoag9tmazsW6ZnAFjL63/TNUIk3D+UCJ3LaCsL
         lI+lcLg6p5icrmFEhPc69y8YJ/V1GWG8Bu06r8+vjkjGvY3Fb1TOG8rAtLZjBben+uQ/
         ygREignIG2EicuxSJMt3KN+rZPO3O1zVDomqAjiJ+32kpanwIdrsikLChQwHRaeaXNGm
         VzKQ==
X-Gm-Message-State: AOAM533+9vMY+w/Dcsw8eCX3fa81lywUSDtrgds4+UuBOIdbe+WA3mHx
        1XEvvvPzF11KwriU5fCIepZ+LsjDTBGVFM08UUAfiVAkSrnoWRo6JvJ347bebR3zpZsiZNYN/pW
        d3U0hHl0YT4o/Jg/jVW2uFkmmlUhlXOcHmX7Lu9dwMKblpPwtvKZDeTBjZFGb84HZmZIIVWE=
X-Received: by 2002:a17:90b:3909:: with SMTP id ob9mr2217779pjb.75.1631627528239;
        Tue, 14 Sep 2021 06:52:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKoBdJJyOz3aJj07f9ReHNBVMPkWW0MnktwAi8picUarmHemTheBv8GCHSF8PpC7PTB2wlTA==
X-Received: by 2002:a17:90b:3909:: with SMTP id ob9mr2217731pjb.75.1631627527751;
        Tue, 14 Sep 2021 06:52:07 -0700 (PDT)
Received: from [10.72.12.89] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id fr17sm1859203pjb.17.2021.09.14.06.52.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 06:52:07 -0700 (PDT)
Subject: Re: [PATCH v2 2/4] ceph: track average/stdev r/w/m latency
From:   Xiubo Li <xiubli@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <20210914084902.1618064-1-vshankar@redhat.com>
 <20210914084902.1618064-3-vshankar@redhat.com>
 <15cd06ae-fe96-c376-854d-738d4a2e70bf@redhat.com>
 <CACPzV1=A4CYvvrkBM1KKMrzYHJFyrMshQ_Qg9F=tXGQdfERK7g@mail.gmail.com>
 <537fc647-249b-d4e8-2139-90cda31b634c@redhat.com>
Message-ID: <02fe4258-a0c5-0d79-7331-b61a7266b5fd@redhat.com>
Date:   Tue, 14 Sep 2021 21:52:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <537fc647-249b-d4e8-2139-90cda31b634c@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/14/21 9:45 PM, Xiubo Li wrote:
>
> On 9/14/21 9:30 PM, Venky Shankar wrote:
>> On Tue, Sep 14, 2021 at 6:39 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>
>>> On 9/14/21 4:49 PM, Venky Shankar wrote:
[...]
> In user space this is very easy to do, but not in kernel space, 
> especially there has no float computing.
>
As I remembered this is main reason why I was planing to send the raw 
metrics to MDS and let the MDS do the computing.

So if possible why not just send the raw data to MDS and let the MDS to 
do the stdev computing ?


> Currently the kclient is doing the avg computing by:
>
> avg(n) = (avg(n-1) + latency(n)) / (n), IMO this should be closer to 
> the real avg(n) = sum(latency(n), latency(n-1), ..., latency(1)) / n.
>
> Because it's hard to record all the latency values, this is also many 
> other user space tools doing to count the avg.
>
>
>>> Though current stdev computing method is not exactly the same the math
>>> formula does, but it's closer to it, because the kernel couldn't record
>>> all the latency value and do it whenever needed, which will occupy a
>>> large amount of memories and cpu resources.
>> The approach is to calculate the running variance, I.e., compute the
>> variance as  data (latency) arrive one at a time.
>>
>>>
>>>>    }
>>>>
>>>>    void ceph_update_read_metrics(struct ceph_client_metric *m,
>>>> @@ -343,23 +352,18 @@ void ceph_update_read_metrics(struct 
>>>> ceph_client_metric *m,
>>>>                              unsigned int size, int rc)
>>>>    {
>>>>        ktime_t lat = ktime_sub(r_end, r_start);
>>>> -     ktime_t total;
>>>>
>>>>        if (unlikely(rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT))
>>>>                return;
>>>>
>>>>        spin_lock(&m->read_metric_lock);
>>>> -     total = ++m->total_reads;
>>>>        m->read_size_sum += size;
>>>> -     m->read_latency_sum += lat;
>>>>        METRIC_UPDATE_MIN_MAX(m->read_size_min,
>>>>                              m->read_size_max,
>>>>                              size);
>>>> -     METRIC_UPDATE_MIN_MAX(m->read_latency_min,
>>>> -                           m->read_latency_max,
>>>> -                           lat);
>>>> -     __update_stdev(total, m->read_latency_sum,
>>>> -                    &m->read_latency_sq_sum, lat);
>>>> +     __update_latency(&m->total_reads, &m->read_latency_sum,
>>>> +                      &m->avg_read_latency, &m->read_latency_min,
>>>> +                      &m->read_latency_max, 
>>>> &m->read_latency_stdev, lat);
>>>>        spin_unlock(&m->read_metric_lock);
>>>>    }
>>>>
>>>> @@ -368,23 +372,18 @@ void ceph_update_write_metrics(struct 
>>>> ceph_client_metric *m,
>>>>                               unsigned int size, int rc)
>>>>    {
>>>>        ktime_t lat = ktime_sub(r_end, r_start);
>>>> -     ktime_t total;
>>>>
>>>>        if (unlikely(rc && rc != -ETIMEDOUT))
>>>>                return;
>>>>
>>>>        spin_lock(&m->write_metric_lock);
>>>> -     total = ++m->total_writes;
>>>>        m->write_size_sum += size;
>>>> -     m->write_latency_sum += lat;
>>>>        METRIC_UPDATE_MIN_MAX(m->write_size_min,
>>>>                              m->write_size_max,
>>>>                              size);
>>>> -     METRIC_UPDATE_MIN_MAX(m->write_latency_min,
>>>> -                           m->write_latency_max,
>>>> -                           lat);
>>>> -     __update_stdev(total, m->write_latency_sum,
>>>> -                    &m->write_latency_sq_sum, lat);
>>>> +     __update_latency(&m->total_writes, &m->write_latency_sum,
>>>> +                      &m->avg_write_latency, &m->write_latency_min,
>>>> +                      &m->write_latency_max, 
>>>> &m->write_latency_stdev, lat);
>>>>        spin_unlock(&m->write_metric_lock);
>>>>    }
>>>>
>>>> @@ -393,18 +392,13 @@ void ceph_update_metadata_metrics(struct 
>>>> ceph_client_metric *m,
>>>>                                  int rc)
>>>>    {
>>>>        ktime_t lat = ktime_sub(r_end, r_start);
>>>> -     ktime_t total;
>>>>
>>>>        if (unlikely(rc && rc != -ENOENT))
>>>>                return;
>>>>
>>>>        spin_lock(&m->metadata_metric_lock);
>>>> -     total = ++m->total_metadatas;
>>>> -     m->metadata_latency_sum += lat;
>>>> -     METRIC_UPDATE_MIN_MAX(m->metadata_latency_min,
>>>> -                           m->metadata_latency_max,
>>>> -                           lat);
>>>> -     __update_stdev(total, m->metadata_latency_sum,
>>>> -                    &m->metadata_latency_sq_sum, lat);
>>>> +     __update_latency(&m->total_metadatas, &m->metadata_latency_sum,
>>>> +                      &m->avg_metadata_latency, 
>>>> &m->metadata_latency_min,
>>>> +                      &m->metadata_latency_max, 
>>>> &m->metadata_latency_stdev, lat);
>>>>        spin_unlock(&m->metadata_metric_lock);
>>>>    }
>>>> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
>>>> index 103ed736f9d2..a5da21b8f8ed 100644
>>>> --- a/fs/ceph/metric.h
>>>> +++ b/fs/ceph/metric.h
>>>> @@ -138,7 +138,8 @@ struct ceph_client_metric {
>>>>        u64 read_size_min;
>>>>        u64 read_size_max;
>>>>        ktime_t read_latency_sum;
>>>> -     ktime_t read_latency_sq_sum;
>>>> +     ktime_t avg_read_latency;
>>>> +     ktime_t read_latency_stdev;
>>>>        ktime_t read_latency_min;
>>>>        ktime_t read_latency_max;
>>>>
>>>> @@ -148,14 +149,16 @@ struct ceph_client_metric {
>>>>        u64 write_size_min;
>>>>        u64 write_size_max;
>>>>        ktime_t write_latency_sum;
>>>> -     ktime_t write_latency_sq_sum;
>>>> +     ktime_t avg_write_latency;
>>>> +     ktime_t write_latency_stdev;
>>>>        ktime_t write_latency_min;
>>>>        ktime_t write_latency_max;
>>>>
>>>>        spinlock_t metadata_metric_lock;
>>>>        u64 total_metadatas;
>>>>        ktime_t metadata_latency_sum;
>>>> -     ktime_t metadata_latency_sq_sum;
>>>> +     ktime_t avg_metadata_latency;
>>>> +     ktime_t metadata_latency_stdev;
>>>>        ktime_t metadata_latency_min;
>>>>        ktime_t metadata_latency_max;
>>>>
>>

