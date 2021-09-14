Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB4540B00F
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Sep 2021 15:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbhINOAG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Sep 2021 10:00:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57799 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232989AbhINOAF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 10:00:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631627927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Be2kry/XFbNjTx0i1Ud1Y8XgTxeHWzoQiz15iDs9mTQ=;
        b=h/dEy0YWfKoR4kPNtYFw3ptLZNJ8QB22jjJ8NZvu5y+ARCIAdlohG0Cod5W7WRod3Y3S0G
        47vIiEBbXw0SfY69sjD15ZH7jUPdGMjUeacqYowERQPhVYiBvUUDBno5j8MYEqn7OBooYd
        pWqQzump9o1VgaHH/ustyI8+O55yZ2U=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-cTpsMvMZMzSH2BMGBzw2Iw-1; Tue, 14 Sep 2021 09:58:46 -0400
X-MC-Unique: cTpsMvMZMzSH2BMGBzw2Iw-1
Received: by mail-pf1-f197.google.com with SMTP id f23-20020aa782d7000000b003eb2baced8bso8318936pfn.3
        for <ceph-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:58:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Be2kry/XFbNjTx0i1Ud1Y8XgTxeHWzoQiz15iDs9mTQ=;
        b=MbkNyM2Te2b/CMAXZpRdTEBAQHNjR9VqaDU4SfkqHJZWPL/NScii2B6Fu/0jDoqK2G
         tUI1k31bGkyds6Wyml7MDj1pP2TeXcJS55pydtZnfvJONu6gedyBDH29mMRXmNp+OJWZ
         nAz3a5Nhee615TbFyOLJAKgibjmcrL+1DWqxnI/42F4Ow9UJUsiDJbzMaSjOSPfm28Dh
         LK2ledkVyLENrC1+Xqf6xMGtAU2yCSbvtoq38jrlekGqJGVQ+QOzG3MpIwiD7Sf0uq3X
         VukxLmL4MJOETXe7gKn37eWV4PXMLmUFzhbyhf0AXz0jxc1IuU77REdTGkAo69Kd5hCl
         FD9A==
X-Gm-Message-State: AOAM533ekZkNb4J1UqE8HinmiF7t2eAO04V9JHZ0d20s+UKypN4reWpa
        U+omqQwPvoc7w9ymGHkEnlTLDUqDIkongnUNdnYAiT8t5D5/N/P5ok4YipPsOvt2NZ+S7/89O0a
        AIlMG9ZkrMKWP0SxlLPous1JjtLCIapAqgFV5mppmMMLU4flZ3F8Qq82/YtOfPXtKwsG7y3U=
X-Received: by 2002:a17:902:820f:b0:13b:9372:a18e with SMTP id x15-20020a170902820f00b0013b9372a18emr9728353pln.13.1631627924783;
        Tue, 14 Sep 2021 06:58:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyg6z8ZxvYzrMMGudrTQSwglUZRSPy5McbTRYRKbV9bqBj8ux8pC6lfFEvGJbXC1vUl3G6g6g==
X-Received: by 2002:a17:902:820f:b0:13b:9372:a18e with SMTP id x15-20020a170902820f00b0013b9372a18emr9728328pln.13.1631627924272;
        Tue, 14 Sep 2021 06:58:44 -0700 (PDT)
Received: from [10.72.12.89] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o14sm10903321pfh.84.2021.09.14.06.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 06:58:43 -0700 (PDT)
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
 <CACPzV1mKmmFttb8X05ePa5WyQN-EFWoH-n9XfEwY5fraush8+A@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d9c74fa8-5e0e-d884-a347-6a0ae3d061fb@redhat.com>
Date:   Tue, 14 Sep 2021 21:58:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CACPzV1mKmmFttb8X05ePa5WyQN-EFWoH-n9XfEwY5fraush8+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/14/21 9:53 PM, Venky Shankar wrote:
> On Tue, Sep 14, 2021 at 7:16 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 9/14/21 9:30 PM, Venky Shankar wrote:
>>> On Tue, Sep 14, 2021 at 6:39 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>> On 9/14/21 4:49 PM, Venky Shankar wrote:
>>>>> The math involved in tracking average and standard deviation
>>>>> for r/w/m latencies looks incorrect. Fix that up. Also, change
>>>>> the variable name that tracks standard deviation (*_sq_sum) to
>>>>> *_stdev.
>>>>>
>>>>> Signed-off-by: Venky Shankar <vshankar@redhat.com>
>>>>> ---
>>>>>     fs/ceph/debugfs.c | 14 +++++-----
>>>>>     fs/ceph/metric.c  | 70 ++++++++++++++++++++++-------------------------
>>>>>     fs/ceph/metric.h  |  9 ++++--
>>>>>     3 files changed, 45 insertions(+), 48 deletions(-)
>>>>>
>>>>> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
>>>>> index 38b78b45811f..3abfa7ae8220 100644
>>>>> --- a/fs/ceph/debugfs.c
>>>>> +++ b/fs/ceph/debugfs.c
>>>>> @@ -152,7 +152,7 @@ static int metric_show(struct seq_file *s, void *p)
>>>>>         struct ceph_mds_client *mdsc = fsc->mdsc;
>>>>>         struct ceph_client_metric *m = &mdsc->metric;
>>>>>         int nr_caps = 0;
>>>>> -     s64 total, sum, avg, min, max, sq;
>>>>> +     s64 total, sum, avg, min, max, stdev;
>>>>>         u64 sum_sz, avg_sz, min_sz, max_sz;
>>>>>
>>>>>         sum = percpu_counter_sum(&m->total_inodes);
>>>>> @@ -175,9 +175,9 @@ static int metric_show(struct seq_file *s, void *p)
>>>>>         avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
>>>>>         min = m->read_latency_min;
>>>>>         max = m->read_latency_max;
>>>>> -     sq = m->read_latency_sq_sum;
>>>>> +     stdev = m->read_latency_stdev;
>>>>>         spin_unlock(&m->read_metric_lock);
>>>>> -     CEPH_LAT_METRIC_SHOW("read", total, avg, min, max, sq);
>>>>> +     CEPH_LAT_METRIC_SHOW("read", total, avg, min, max, stdev);
>>>>>
>>>>>         spin_lock(&m->write_metric_lock);
>>>>>         total = m->total_writes;
>>>>> @@ -185,9 +185,9 @@ static int metric_show(struct seq_file *s, void *p)
>>>>>         avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
>>>>>         min = m->write_latency_min;
>>>>>         max = m->write_latency_max;
>>>>> -     sq = m->write_latency_sq_sum;
>>>>> +     stdev = m->write_latency_stdev;
>>>>>         spin_unlock(&m->write_metric_lock);
>>>>> -     CEPH_LAT_METRIC_SHOW("write", total, avg, min, max, sq);
>>>>> +     CEPH_LAT_METRIC_SHOW("write", total, avg, min, max, stdev);
>>>>>
>>>>>         spin_lock(&m->metadata_metric_lock);
>>>>>         total = m->total_metadatas;
>>>>> @@ -195,9 +195,9 @@ static int metric_show(struct seq_file *s, void *p)
>>>>>         avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
>>>>>         min = m->metadata_latency_min;
>>>>>         max = m->metadata_latency_max;
>>>>> -     sq = m->metadata_latency_sq_sum;
>>>>> +     stdev = m->metadata_latency_stdev;
>>>>>         spin_unlock(&m->metadata_metric_lock);
>>>>> -     CEPH_LAT_METRIC_SHOW("metadata", total, avg, min, max, sq);
>>>>> +     CEPH_LAT_METRIC_SHOW("metadata", total, avg, min, max, stdev);
>>>>>
>>>>>         seq_printf(s, "\n");
>>>>>         seq_printf(s, "item          total       avg_sz(bytes)   min_sz(bytes)   max_sz(bytes)  total_sz(bytes)\n");
>>>>> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
>>>>> index 226dc38e2909..6b774b1a88ce 100644
>>>>> --- a/fs/ceph/metric.c
>>>>> +++ b/fs/ceph/metric.c
>>>>> @@ -244,7 +244,8 @@ int ceph_metric_init(struct ceph_client_metric *m)
>>>>>                 goto err_i_caps_mis;
>>>>>
>>>>>         spin_lock_init(&m->read_metric_lock);
>>>>> -     m->read_latency_sq_sum = 0;
>>>>> +     m->read_latency_stdev = 0;
>>>>> +     m->avg_read_latency = 0;
>>>>>         m->read_latency_min = KTIME_MAX;
>>>>>         m->read_latency_max = 0;
>>>>>         m->total_reads = 0;
>>>>> @@ -254,7 +255,8 @@ int ceph_metric_init(struct ceph_client_metric *m)
>>>>>         m->read_size_sum = 0;
>>>>>
>>>>>         spin_lock_init(&m->write_metric_lock);
>>>>> -     m->write_latency_sq_sum = 0;
>>>>> +     m->write_latency_stdev = 0;
>>>>> +     m->avg_write_latency = 0;
>>>>>         m->write_latency_min = KTIME_MAX;
>>>>>         m->write_latency_max = 0;
>>>>>         m->total_writes = 0;
>>>>> @@ -264,7 +266,8 @@ int ceph_metric_init(struct ceph_client_metric *m)
>>>>>         m->write_size_sum = 0;
>>>>>
>>>>>         spin_lock_init(&m->metadata_metric_lock);
>>>>> -     m->metadata_latency_sq_sum = 0;
>>>>> +     m->metadata_latency_stdev = 0;
>>>>> +     m->avg_metadata_latency = 0;
>>>>>         m->metadata_latency_min = KTIME_MAX;
>>>>>         m->metadata_latency_max = 0;
>>>>>         m->total_metadatas = 0;
>>>>> @@ -322,20 +325,26 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
>>>>>                 max = new;                      \
>>>>>     }
>>>>>
>>>>> -static inline void __update_stdev(ktime_t total, ktime_t lsum,
>>>>> -                               ktime_t *sq_sump, ktime_t lat)
>>>>> +static inline void __update_latency(ktime_t *ctotal, ktime_t *lsum,
>>>>> +                                 ktime_t *lavg, ktime_t *min, ktime_t *max,
>>>>> +                                 ktime_t *lstdev, ktime_t lat)
>>>>>     {
>>>>> -     ktime_t avg, sq;
>>>>> +     ktime_t total, avg, stdev;
>>>>>
>>>>> -     if (unlikely(total == 1))
>>>>> -             return;
>>>>> +     total = ++(*ctotal);
>>>>> +     *lsum += lat;
>>>>> +
>>>>> +     METRIC_UPDATE_MIN_MAX(*min, *max, lat);
>>>>>
>>>>> -     /* the sq is (lat - old_avg) * (lat - new_avg) */
>>>>> -     avg = DIV64_U64_ROUND_CLOSEST((lsum - lat), (total - 1));
>>>>> -     sq = lat - avg;
>>>>> -     avg = DIV64_U64_ROUND_CLOSEST(lsum, total);
>>>>> -     sq = sq * (lat - avg);
>>>>> -     *sq_sump += sq;
>>>>> +     if (unlikely(total == 1)) {
>>>>> +             *lavg = lat;
>>>>> +             *lstdev = 0;
>>>>> +     } else {
>>>>> +             avg = *lavg + div64_s64(lat - *lavg, total);
>>>>> +             stdev = *lstdev + (lat - *lavg)*(lat - avg);
>>>>> +             *lstdev = int_sqrt(div64_u64(stdev, total - 1));
>>>>> +             *lavg = avg;
>>>>> +     }
>>>> IMO, this is incorrect, the math formula please see:
>>>>
>>>> https://www.investopedia.com/ask/answers/042415/what-difference-between-standard-error-means-and-standard-deviation.asp
>>>>
>>>> The most accurate result should be:
>>>>
>>>> stdev = int_sqrt(sum((X(n) - avg)^2, (X(n-1) - avg)^2, ..., (X(1) -
>>>> avg)^2) / (n - 1)).
>>>>
>>>> While you are computing it:
>>>>
>>>> stdev_n = int_sqrt(stdev_(n-1) + (X(n-1) - avg)^2)
>>> Hmm. The int_sqrt() is probably not needed at this point and can be
>>> done when sending the metric. That would avoid some cycles.
>>>
>>> Also, the way avg is calculated not totally incorrect, however, I
>>> would like to keep it similar to how its done is libcephfs.
>> In user space this is very easy to do, but not in kernel space,
>> especially there has no float computing.
>>
>> Currently the kclient is doing the avg computing by:
>>
>> avg(n) = (avg(n-1) + latency(n)) / (n), IMO this should be closer to the
>> real avg(n) = sum(latency(n), latency(n-1), ..., latency(1)) / n.
> That's how is done in libcephfs too.

Okay.

>
>> Because it's hard to record all the latency values, this is also many
>> other user space tools doing to count the avg.
>>
>>
>>>> Though current stdev computing method is not exactly the same the math
>>>> formula does, but it's closer to it, because the kernel couldn't record
>>>> all the latency value and do it whenever needed, which will occupy a
>>>> large amount of memories and cpu resources.
>>> The approach is to calculate the running variance, I.e., compute the
>>> variance as  data (latency) arrive one at a time.
>>>
>>>>>     }
>>>>>
>>>>>     void ceph_update_read_metrics(struct ceph_client_metric *m,
>>>>> @@ -343,23 +352,18 @@ void ceph_update_read_metrics(struct ceph_client_metric *m,
>>>>>                               unsigned int size, int rc)
>>>>>     {
>>>>>         ktime_t lat = ktime_sub(r_end, r_start);
>>>>> -     ktime_t total;
>>>>>
>>>>>         if (unlikely(rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT))
>>>>>                 return;
>>>>>
>>>>>         spin_lock(&m->read_metric_lock);
>>>>> -     total = ++m->total_reads;
>>>>>         m->read_size_sum += size;
>>>>> -     m->read_latency_sum += lat;
>>>>>         METRIC_UPDATE_MIN_MAX(m->read_size_min,
>>>>>                               m->read_size_max,
>>>>>                               size);
>>>>> -     METRIC_UPDATE_MIN_MAX(m->read_latency_min,
>>>>> -                           m->read_latency_max,
>>>>> -                           lat);
>>>>> -     __update_stdev(total, m->read_latency_sum,
>>>>> -                    &m->read_latency_sq_sum, lat);
>>>>> +     __update_latency(&m->total_reads, &m->read_latency_sum,
>>>>> +                      &m->avg_read_latency, &m->read_latency_min,
>>>>> +                      &m->read_latency_max, &m->read_latency_stdev, lat);
>>>>>         spin_unlock(&m->read_metric_lock);
>>>>>     }
>>>>>
>>>>> @@ -368,23 +372,18 @@ void ceph_update_write_metrics(struct ceph_client_metric *m,
>>>>>                                unsigned int size, int rc)
>>>>>     {
>>>>>         ktime_t lat = ktime_sub(r_end, r_start);
>>>>> -     ktime_t total;
>>>>>
>>>>>         if (unlikely(rc && rc != -ETIMEDOUT))
>>>>>                 return;
>>>>>
>>>>>         spin_lock(&m->write_metric_lock);
>>>>> -     total = ++m->total_writes;
>>>>>         m->write_size_sum += size;
>>>>> -     m->write_latency_sum += lat;
>>>>>         METRIC_UPDATE_MIN_MAX(m->write_size_min,
>>>>>                               m->write_size_max,
>>>>>                               size);
>>>>> -     METRIC_UPDATE_MIN_MAX(m->write_latency_min,
>>>>> -                           m->write_latency_max,
>>>>> -                           lat);
>>>>> -     __update_stdev(total, m->write_latency_sum,
>>>>> -                    &m->write_latency_sq_sum, lat);
>>>>> +     __update_latency(&m->total_writes, &m->write_latency_sum,
>>>>> +                      &m->avg_write_latency, &m->write_latency_min,
>>>>> +                      &m->write_latency_max, &m->write_latency_stdev, lat);
>>>>>         spin_unlock(&m->write_metric_lock);
>>>>>     }
>>>>>
>>>>> @@ -393,18 +392,13 @@ void ceph_update_metadata_metrics(struct ceph_client_metric *m,
>>>>>                                   int rc)
>>>>>     {
>>>>>         ktime_t lat = ktime_sub(r_end, r_start);
>>>>> -     ktime_t total;
>>>>>
>>>>>         if (unlikely(rc && rc != -ENOENT))
>>>>>                 return;
>>>>>
>>>>>         spin_lock(&m->metadata_metric_lock);
>>>>> -     total = ++m->total_metadatas;
>>>>> -     m->metadata_latency_sum += lat;
>>>>> -     METRIC_UPDATE_MIN_MAX(m->metadata_latency_min,
>>>>> -                           m->metadata_latency_max,
>>>>> -                           lat);
>>>>> -     __update_stdev(total, m->metadata_latency_sum,
>>>>> -                    &m->metadata_latency_sq_sum, lat);
>>>>> +     __update_latency(&m->total_metadatas, &m->metadata_latency_sum,
>>>>> +                      &m->avg_metadata_latency, &m->metadata_latency_min,
>>>>> +                      &m->metadata_latency_max, &m->metadata_latency_stdev, lat);
>>>>>         spin_unlock(&m->metadata_metric_lock);
>>>>>     }
>>>>> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
>>>>> index 103ed736f9d2..a5da21b8f8ed 100644
>>>>> --- a/fs/ceph/metric.h
>>>>> +++ b/fs/ceph/metric.h
>>>>> @@ -138,7 +138,8 @@ struct ceph_client_metric {
>>>>>         u64 read_size_min;
>>>>>         u64 read_size_max;
>>>>>         ktime_t read_latency_sum;
>>>>> -     ktime_t read_latency_sq_sum;
>>>>> +     ktime_t avg_read_latency;
>>>>> +     ktime_t read_latency_stdev;
>>>>>         ktime_t read_latency_min;
>>>>>         ktime_t read_latency_max;
>>>>>
>>>>> @@ -148,14 +149,16 @@ struct ceph_client_metric {
>>>>>         u64 write_size_min;
>>>>>         u64 write_size_max;
>>>>>         ktime_t write_latency_sum;
>>>>> -     ktime_t write_latency_sq_sum;
>>>>> +     ktime_t avg_write_latency;
>>>>> +     ktime_t write_latency_stdev;
>>>>>         ktime_t write_latency_min;
>>>>>         ktime_t write_latency_max;
>>>>>
>>>>>         spinlock_t metadata_metric_lock;
>>>>>         u64 total_metadatas;
>>>>>         ktime_t metadata_latency_sum;
>>>>> -     ktime_t metadata_latency_sq_sum;
>>>>> +     ktime_t avg_metadata_latency;
>>>>> +     ktime_t metadata_latency_stdev;
>>>>>         ktime_t metadata_latency_min;
>>>>>         ktime_t metadata_latency_max;
>>>>>
>

