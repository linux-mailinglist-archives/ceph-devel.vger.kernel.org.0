Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFBD414C1C
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Sep 2021 16:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236250AbhIVOgG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Sep 2021 10:36:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31237 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236220AbhIVOgG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 22 Sep 2021 10:36:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632321276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aWIlRDzNeDxnDSYC7o4NdYcXiqxJT+7o/tKUU+ceUOI=;
        b=aB10gmpFWX3RP9w33q36E5v5dzh+zxV39B6SHWQ1JtLfCkCCb/Y6ITuoLsdds9c5uCTQRb
        BbM3RJ2cafv+v+MO7+8yFy2GZAdMF4Lj3LY50hdCKI6lp8l+fHUhonpZy7R4TresU9bVMP
        dXRM2plmfMOUfjFQHE3SaSUMEsDs7xM=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-P5OrGVvvOFq-2hVmoq4DaA-1; Wed, 22 Sep 2021 10:34:35 -0400
X-MC-Unique: P5OrGVvvOFq-2hVmoq4DaA-1
Received: by mail-pg1-f197.google.com with SMTP id z19-20020a631913000000b00252ede336caso1817473pgl.4
        for <ceph-devel@vger.kernel.org>; Wed, 22 Sep 2021 07:34:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=aWIlRDzNeDxnDSYC7o4NdYcXiqxJT+7o/tKUU+ceUOI=;
        b=i5B1pZC3yEPmPNFVXJjr9ihIqCDk8ULaSBM23oYX0KYzOLDCX8/sU1sgSZmKAe/O3m
         A/e+wwMw3baQJ8T2p3lwD5VqF6qPuFygV+Ku83Df/v6MOmv1SeKVuqOawdQC3zkIU3Fd
         /BmwQU7CfK+l5UnXiN1lICcVsJdMyYA+XzmlX6ZKYjqsYGAbb8KfwcTBIGpvifBAQPmV
         oH1nadqvB45auVgdiJ0r8B8nXgzFwGrPZ3gC6/29RY9gbvlrEOxCFcr0zOd698yKOfUR
         lPe9jBRQ8l+O7ph7Yroa2eQDkIyOjpxu0w6Ud/Wk/egsOJCalqcygAduMK3Afas1wIX0
         0koQ==
X-Gm-Message-State: AOAM5338CPAE5vG37XNUiIbjSWR8dCIAQ4CEDWBnsGiBVkfsGtqe2Co0
        4T0bFd34V/pWpjQfd+S8npwM5lahtwpNYOh2M+QdQxFBERSBst8rN5G6DJF6dOSQMiKko7InG86
        HEk7UpPdnSpVOj+8iefQ8xVqInWeWom/RSxAaYhSta5Ki5+UDa+9JyWV+MscygRU4bl7VoZM=
X-Received: by 2002:a63:4b53:: with SMTP id k19mr32497841pgl.3.1632321273458;
        Wed, 22 Sep 2021 07:34:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcN9xlcdT6xvcJd9WxZngJ0YVZkiyKxyHfbzK3gXQIhq/pQ5nHjHkYXAhit/R9zgjBccxkTQ==
X-Received: by 2002:a63:4b53:: with SMTP id k19mr32497804pgl.3.1632321273066;
        Wed, 22 Sep 2021 07:34:33 -0700 (PDT)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s10sm5852855pjn.38.2021.09.22.07.34.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 07:34:32 -0700 (PDT)
Subject: Re: [PATCH v3 2/4] ceph: track average/stdev r/w/m latency
To:     Venky Shankar <vshankar@redhat.com>,
        Jeff Layton <jlayton@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <20210921130750.31820-1-vshankar@redhat.com>
 <20210921130750.31820-3-vshankar@redhat.com>
 <495168ef5d8e3b18f85048a2d61e988ba44a6228.camel@redhat.com>
 <CACPzV1mA45ByOwdcBQXH0ugq50wzTMuK=WXiP--UG5_mam2ztw@mail.gmail.com>
 <CACPzV1=avKH1TA7EJMRe_ivXxzMWn4ZaVMQVb3Nf6ZbdBa10-A@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <ba1d57df-f977-4319-a857-c629ea47a818@redhat.com>
Date:   Wed, 22 Sep 2021 22:34:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CACPzV1=avKH1TA7EJMRe_ivXxzMWn4ZaVMQVb3Nf6ZbdBa10-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/22/21 9:44 PM, Venky Shankar wrote:
> On Wed, Sep 22, 2021 at 6:03 PM Venky Shankar <vshankar@redhat.com> wrote:
>> On Wed, Sep 22, 2021 at 5:47 PM Jeff Layton <jlayton@redhat.com> wrote:
>>> On Tue, 2021-09-21 at 18:37 +0530, Venky Shankar wrote:
>>>> Update the math involved to closely mimic how its done in
>>>> user land. This does not make a lot of difference to the
>>>> execution speed.
>>>>
>>>> Signed-off-by: Venky Shankar <vshankar@redhat.com>
>>>> ---
>>>>   fs/ceph/metric.c | 63 +++++++++++++++++++++---------------------------
>>>>   fs/ceph/metric.h |  3 +++
>>>>   2 files changed, 31 insertions(+), 35 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
>>>> index 226dc38e2909..ca758bff69ca 100644
>>>> --- a/fs/ceph/metric.c
>>>> +++ b/fs/ceph/metric.c
>>>> @@ -245,6 +245,7 @@ int ceph_metric_init(struct ceph_client_metric *m)
>>>>
>>>>        spin_lock_init(&m->read_metric_lock);
>>>>        m->read_latency_sq_sum = 0;
>>>> +     m->avg_read_latency = 0;
>>>>        m->read_latency_min = KTIME_MAX;
>>>>        m->read_latency_max = 0;
>>>>        m->total_reads = 0;
>>>> @@ -255,6 +256,7 @@ int ceph_metric_init(struct ceph_client_metric *m)
>>>>
>>>>        spin_lock_init(&m->write_metric_lock);
>>>>        m->write_latency_sq_sum = 0;
>>>> +     m->avg_write_latency = 0;
>>>>        m->write_latency_min = KTIME_MAX;
>>>>        m->write_latency_max = 0;
>>>>        m->total_writes = 0;
>>>> @@ -265,6 +267,7 @@ int ceph_metric_init(struct ceph_client_metric *m)
>>>>
>>>>        spin_lock_init(&m->metadata_metric_lock);
>>>>        m->metadata_latency_sq_sum = 0;
>>>> +     m->avg_metadata_latency = 0;
>>>>        m->metadata_latency_min = KTIME_MAX;
>>>>        m->metadata_latency_max = 0;
>>>>        m->total_metadatas = 0;
>>>> @@ -322,20 +325,25 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
>>>>                max = new;                      \
>>>>   }
>>>>
>>>> -static inline void __update_stdev(ktime_t total, ktime_t lsum,
>>>> -                               ktime_t *sq_sump, ktime_t lat)
>>>> +static inline void __update_latency(ktime_t *ctotal, ktime_t *lsum,
>>>> +                                 ktime_t *lavg, ktime_t *min, ktime_t *max,
>>>> +                                 ktime_t *sum_sq, ktime_t lat)
>>>>   {
>>>> -     ktime_t avg, sq;
>>>> +     ktime_t total, avg;
>>>>
>>>> -     if (unlikely(total == 1))
>>>> -             return;
>>>> +     total = ++(*ctotal);
>>>> +     *lsum += lat;
>>>> +
>>>> +     METRIC_UPDATE_MIN_MAX(*min, *max, lat);
>>>>
>>>> -     /* the sq is (lat - old_avg) * (lat - new_avg) */
>>>> -     avg = DIV64_U64_ROUND_CLOSEST((lsum - lat), (total - 1));
>>>> -     sq = lat - avg;
>>>> -     avg = DIV64_U64_ROUND_CLOSEST(lsum, total);
>>>> -     sq = sq * (lat - avg);
>>>> -     *sq_sump += sq;
>>>> +     if (unlikely(total == 1)) {
>>>> +             *lavg = lat;
>>>> +             *sum_sq = 0;
>>>> +     } else {
>>>> +             avg = *lavg + div64_s64(lat - *lavg, total);
>>>> +             *sum_sq += (lat - *lavg)*(lat - avg);
>>>> +             *lavg = avg;
>>>> +     }
>>>>   }
>>>>
>>>>   void ceph_update_read_metrics(struct ceph_client_metric *m,
>>>> @@ -343,23 +351,18 @@ void ceph_update_read_metrics(struct ceph_client_metric *m,
>>>>                              unsigned int size, int rc)
>>>>   {
>>>>        ktime_t lat = ktime_sub(r_end, r_start);
>>>> -     ktime_t total;
>>>>
>>>>        if (unlikely(rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT))
>>>>                return;
>>>>
>>>>        spin_lock(&m->read_metric_lock);
>>>> -     total = ++m->total_reads;
>>>>        m->read_size_sum += size;
>>>> -     m->read_latency_sum += lat;
>>>>        METRIC_UPDATE_MIN_MAX(m->read_size_min,
>>>>                              m->read_size_max,
>>>>                              size);
>>>> -     METRIC_UPDATE_MIN_MAX(m->read_latency_min,
>>>> -                           m->read_latency_max,
>>>> -                           lat);
>>>> -     __update_stdev(total, m->read_latency_sum,
>>>> -                    &m->read_latency_sq_sum, lat);
>>>> +     __update_latency(&m->total_reads, &m->read_latency_sum,
>>>> +                      &m->avg_read_latency, &m->read_latency_min,
>>>> +                      &m->read_latency_max, &m->read_latency_sq_sum, lat);
>>> Do we really need to calculate the std deviation on every update? We
>>> have to figure that in most cases, this stuff will be collected but only
>>> seldom viewed.
>>>
>>> ISTM that we ought to collect just the bare minimum of info on each
>>> update, and save the more expensive calculations for the tool presenting
>>> this info.
>> Yeh, that's probably the plan we want going forward when introducing
>> new metrics.
>>
>> FWIW, we could start doing it with this itself. It's just that the
>> user land PRs are approved and those do the way it is done here.
>>
>> I'm ok with moving math crunching to the tool and it should not be a
>> major change to this patchset.
> So, I kind of recall why we did it this way -- metrics exchange
> between MDS and ceph-mgr is restricted to std::pair<uint64_t,
> uint64_t>.

Before I pushed one patch to improve this and switched it to a list or 
something else, but revert it dues to some reason.


> That would probably need to be expanded to carry variable
> sized objects. I remember seeing a PR that does something like that.
> Need to dig it up...
>
> The other way would be to exchange the necessary information needed
> for the calculation as a separate types but that's not really clean
> and results in unnecessary bloating.
>
>>>>        spin_unlock(&m->read_metric_lock);
>>>>   }
>>>>
>>>> @@ -368,23 +371,18 @@ void ceph_update_write_metrics(struct ceph_client_metric *m,
>>>>                               unsigned int size, int rc)
>>>>   {
>>>>        ktime_t lat = ktime_sub(r_end, r_start);
>>>> -     ktime_t total;
>>>>
>>>>        if (unlikely(rc && rc != -ETIMEDOUT))
>>>>                return;
>>>>
>>>>        spin_lock(&m->write_metric_lock);
>>>> -     total = ++m->total_writes;
>>>>        m->write_size_sum += size;
>>>> -     m->write_latency_sum += lat;
>>>>        METRIC_UPDATE_MIN_MAX(m->write_size_min,
>>>>                              m->write_size_max,
>>>>                              size);
>>>> -     METRIC_UPDATE_MIN_MAX(m->write_latency_min,
>>>> -                           m->write_latency_max,
>>>> -                           lat);
>>>> -     __update_stdev(total, m->write_latency_sum,
>>>> -                    &m->write_latency_sq_sum, lat);
>>>> +     __update_latency(&m->total_writes, &m->write_latency_sum,
>>>> +                      &m->avg_write_latency, &m->write_latency_min,
>>>> +                      &m->write_latency_max, &m->write_latency_sq_sum, lat);
>>>>        spin_unlock(&m->write_metric_lock);
>>>>   }
>>>>
>>>> @@ -393,18 +391,13 @@ void ceph_update_metadata_metrics(struct ceph_client_metric *m,
>>>>                                  int rc)
>>>>   {
>>>>        ktime_t lat = ktime_sub(r_end, r_start);
>>>> -     ktime_t total;
>>>>
>>>>        if (unlikely(rc && rc != -ENOENT))
>>>>                return;
>>>>
>>>>        spin_lock(&m->metadata_metric_lock);
>>>> -     total = ++m->total_metadatas;
>>>> -     m->metadata_latency_sum += lat;
>>>> -     METRIC_UPDATE_MIN_MAX(m->metadata_latency_min,
>>>> -                           m->metadata_latency_max,
>>>> -                           lat);
>>>> -     __update_stdev(total, m->metadata_latency_sum,
>>>> -                    &m->metadata_latency_sq_sum, lat);
>>>> +     __update_latency(&m->total_metadatas, &m->metadata_latency_sum,
>>>> +                      &m->avg_metadata_latency, &m->metadata_latency_min,
>>>> +                      &m->metadata_latency_max, &m->metadata_latency_sq_sum, lat);
>>>>        spin_unlock(&m->metadata_metric_lock);
>>>>   }
>>>> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
>>>> index 103ed736f9d2..0af02e212033 100644
>>>> --- a/fs/ceph/metric.h
>>>> +++ b/fs/ceph/metric.h
>>>> @@ -138,6 +138,7 @@ struct ceph_client_metric {
>>>>        u64 read_size_min;
>>>>        u64 read_size_max;
>>>>        ktime_t read_latency_sum;
>>>> +     ktime_t avg_read_latency;
>>>>        ktime_t read_latency_sq_sum;
>>>>        ktime_t read_latency_min;
>>>>        ktime_t read_latency_max;
>>>> @@ -148,6 +149,7 @@ struct ceph_client_metric {
>>>>        u64 write_size_min;
>>>>        u64 write_size_max;
>>>>        ktime_t write_latency_sum;
>>>> +     ktime_t avg_write_latency;
>>>>        ktime_t write_latency_sq_sum;
>>>>        ktime_t write_latency_min;
>>>>        ktime_t write_latency_max;
>>>> @@ -155,6 +157,7 @@ struct ceph_client_metric {
>>>>        spinlock_t metadata_metric_lock;
>>>>        u64 total_metadatas;
>>>>        ktime_t metadata_latency_sum;
>>>> +     ktime_t avg_metadata_latency;
>>>>        ktime_t metadata_latency_sq_sum;
>>>>        ktime_t metadata_latency_min;
>>>>        ktime_t metadata_latency_max;
>>> --
>>> Jeff Layton <jlayton@redhat.com>
>>>
>>
>> --
>> Cheers,
>> Venky
>
>

