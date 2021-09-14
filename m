Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9111440AF7A
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Sep 2021 15:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbhINNrZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Sep 2021 09:47:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55584 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232079AbhINNrY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:47:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631627166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T0gabLA0Nn1gqnq5e2n0SWYb0u/bvLRRMVZwVJ4T0x4=;
        b=LfadNkgaoOKVxVBjFkuofNju/AWvyYaJCQ0CkrkzHoRMmViK1S2ysh1BzRLBToViDunalm
        5kj15EpCaUBAZmyRrnQohWhEq6DoXC8iLdLLDWSrjrXtoEumjtZUJK78vIvEFBYdphNUu3
        ADk+1VUsvfMS7OhSsyZoCR4vBU4C4ic=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-JXWgCvbZNv-2GGRcRCr9Iw-1; Tue, 14 Sep 2021 09:46:03 -0400
X-MC-Unique: JXWgCvbZNv-2GGRcRCr9Iw-1
Received: by mail-pl1-f198.google.com with SMTP id f9-20020a1709028609b0290128bcba6be7so4564584plo.18
        for <ceph-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:46:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=T0gabLA0Nn1gqnq5e2n0SWYb0u/bvLRRMVZwVJ4T0x4=;
        b=KZkGqJVDvLiNsHzUHybdWnu4XCAA+kY8ECJ5C3iOrzJ6vyoYycOZPRc6aTkLXlHq0l
         th+HLcg8fYc5p5ICA7SRFDacAFG04nRqYETd4ecskZ+kD5oWeksNV2/Qgc5c2vxmNaIC
         A6tvqyg9beT8zmnSQyBqdCZ5LfXAKh/CqxEoR66Ku+B3XbGJ/uniWta319BMpDp0jb7A
         eYbTkzJ+AiOi8Qx4TBMDU6BCb1PT3xn1Pv7FZPDYcYBZEyjjJoPFIxHh8pb9YOlKwMK0
         MhxbptMysNLQAlFIINHHpX3lhDUp9TqFGCkcuy8/vYr8nLXodjcaCwCVkMDDJgwzF22f
         y4YA==
X-Gm-Message-State: AOAM530TF4na5+pftXqZVwXHymyjfZCdJ3BWWDeUUUrjvspLDIzn+y7F
        mCxOV9FyZhjG7opiWyMceXO0zlqgd8N7HbH46SzwSh2wnmFoT6RMLKsjTzWf0qpwU0q/n6LZZsD
        n9Xg0bGIv4OQOrX47+TW7mgHTczq0T6cp+5aB9eoyefjCHLUmroXuI0D8R0oMUuYfM5wPtog=
X-Received: by 2002:a63:fe41:: with SMTP id x1mr15711865pgj.272.1631627162352;
        Tue, 14 Sep 2021 06:46:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxiHMeDfSYnPfQJ/VLjuFtWP5U4PlodudkWLnGg94Yr30SGLW0O0LSslAdK6HEEeg7+V5K+rA==
X-Received: by 2002:a63:fe41:: with SMTP id x1mr15711829pgj.272.1631627161756;
        Tue, 14 Sep 2021 06:46:01 -0700 (PDT)
Received: from [10.72.12.89] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n66sm2674716pfn.142.2021.09.14.06.45.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 06:46:01 -0700 (PDT)
Subject: Re: [PATCH v2 2/4] ceph: track average/stdev r/w/m latency
To:     Venky Shankar <vshankar@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <20210914084902.1618064-1-vshankar@redhat.com>
 <20210914084902.1618064-3-vshankar@redhat.com>
 <15cd06ae-fe96-c376-854d-738d4a2e70bf@redhat.com>
 <CACPzV1=A4CYvvrkBM1KKMrzYHJFyrMshQ_Qg9F=tXGQdfERK7g@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <537fc647-249b-d4e8-2139-90cda31b634c@redhat.com>
Date:   Tue, 14 Sep 2021 21:45:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CACPzV1=A4CYvvrkBM1KKMrzYHJFyrMshQ_Qg9F=tXGQdfERK7g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/14/21 9:30 PM, Venky Shankar wrote:
> On Tue, Sep 14, 2021 at 6:39 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 9/14/21 4:49 PM, Venky Shankar wrote:
>>> The math involved in tracking average and standard deviation
>>> for r/w/m latencies looks incorrect. Fix that up. Also, change
>>> the variable name that tracks standard deviation (*_sq_sum) to
>>> *_stdev.
>>>
>>> Signed-off-by: Venky Shankar <vshankar@redhat.com>
>>> ---
>>>    fs/ceph/debugfs.c | 14 +++++-----
>>>    fs/ceph/metric.c  | 70 ++++++++++++++++++++++-------------------------
>>>    fs/ceph/metric.h  |  9 ++++--
>>>    3 files changed, 45 insertions(+), 48 deletions(-)
>>>
>>> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
>>> index 38b78b45811f..3abfa7ae8220 100644
>>> --- a/fs/ceph/debugfs.c
>>> +++ b/fs/ceph/debugfs.c
>>> @@ -152,7 +152,7 @@ static int metric_show(struct seq_file *s, void *p)
>>>        struct ceph_mds_client *mdsc = fsc->mdsc;
>>>        struct ceph_client_metric *m = &mdsc->metric;
>>>        int nr_caps = 0;
>>> -     s64 total, sum, avg, min, max, sq;
>>> +     s64 total, sum, avg, min, max, stdev;
>>>        u64 sum_sz, avg_sz, min_sz, max_sz;
>>>
>>>        sum = percpu_counter_sum(&m->total_inodes);
>>> @@ -175,9 +175,9 @@ static int metric_show(struct seq_file *s, void *p)
>>>        avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
>>>        min = m->read_latency_min;
>>>        max = m->read_latency_max;
>>> -     sq = m->read_latency_sq_sum;
>>> +     stdev = m->read_latency_stdev;
>>>        spin_unlock(&m->read_metric_lock);
>>> -     CEPH_LAT_METRIC_SHOW("read", total, avg, min, max, sq);
>>> +     CEPH_LAT_METRIC_SHOW("read", total, avg, min, max, stdev);
>>>
>>>        spin_lock(&m->write_metric_lock);
>>>        total = m->total_writes;
>>> @@ -185,9 +185,9 @@ static int metric_show(struct seq_file *s, void *p)
>>>        avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
>>>        min = m->write_latency_min;
>>>        max = m->write_latency_max;
>>> -     sq = m->write_latency_sq_sum;
>>> +     stdev = m->write_latency_stdev;
>>>        spin_unlock(&m->write_metric_lock);
>>> -     CEPH_LAT_METRIC_SHOW("write", total, avg, min, max, sq);
>>> +     CEPH_LAT_METRIC_SHOW("write", total, avg, min, max, stdev);
>>>
>>>        spin_lock(&m->metadata_metric_lock);
>>>        total = m->total_metadatas;
>>> @@ -195,9 +195,9 @@ static int metric_show(struct seq_file *s, void *p)
>>>        avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
>>>        min = m->metadata_latency_min;
>>>        max = m->metadata_latency_max;
>>> -     sq = m->metadata_latency_sq_sum;
>>> +     stdev = m->metadata_latency_stdev;
>>>        spin_unlock(&m->metadata_metric_lock);
>>> -     CEPH_LAT_METRIC_SHOW("metadata", total, avg, min, max, sq);
>>> +     CEPH_LAT_METRIC_SHOW("metadata", total, avg, min, max, stdev);
>>>
>>>        seq_printf(s, "\n");
>>>        seq_printf(s, "item          total       avg_sz(bytes)   min_sz(bytes)   max_sz(bytes)  total_sz(bytes)\n");
>>> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
>>> index 226dc38e2909..6b774b1a88ce 100644
>>> --- a/fs/ceph/metric.c
>>> +++ b/fs/ceph/metric.c
>>> @@ -244,7 +244,8 @@ int ceph_metric_init(struct ceph_client_metric *m)
>>>                goto err_i_caps_mis;
>>>
>>>        spin_lock_init(&m->read_metric_lock);
>>> -     m->read_latency_sq_sum = 0;
>>> +     m->read_latency_stdev = 0;
>>> +     m->avg_read_latency = 0;
>>>        m->read_latency_min = KTIME_MAX;
>>>        m->read_latency_max = 0;
>>>        m->total_reads = 0;
>>> @@ -254,7 +255,8 @@ int ceph_metric_init(struct ceph_client_metric *m)
>>>        m->read_size_sum = 0;
>>>
>>>        spin_lock_init(&m->write_metric_lock);
>>> -     m->write_latency_sq_sum = 0;
>>> +     m->write_latency_stdev = 0;
>>> +     m->avg_write_latency = 0;
>>>        m->write_latency_min = KTIME_MAX;
>>>        m->write_latency_max = 0;
>>>        m->total_writes = 0;
>>> @@ -264,7 +266,8 @@ int ceph_metric_init(struct ceph_client_metric *m)
>>>        m->write_size_sum = 0;
>>>
>>>        spin_lock_init(&m->metadata_metric_lock);
>>> -     m->metadata_latency_sq_sum = 0;
>>> +     m->metadata_latency_stdev = 0;
>>> +     m->avg_metadata_latency = 0;
>>>        m->metadata_latency_min = KTIME_MAX;
>>>        m->metadata_latency_max = 0;
>>>        m->total_metadatas = 0;
>>> @@ -322,20 +325,26 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
>>>                max = new;                      \
>>>    }
>>>
>>> -static inline void __update_stdev(ktime_t total, ktime_t lsum,
>>> -                               ktime_t *sq_sump, ktime_t lat)
>>> +static inline void __update_latency(ktime_t *ctotal, ktime_t *lsum,
>>> +                                 ktime_t *lavg, ktime_t *min, ktime_t *max,
>>> +                                 ktime_t *lstdev, ktime_t lat)
>>>    {
>>> -     ktime_t avg, sq;
>>> +     ktime_t total, avg, stdev;
>>>
>>> -     if (unlikely(total == 1))
>>> -             return;
>>> +     total = ++(*ctotal);
>>> +     *lsum += lat;
>>> +
>>> +     METRIC_UPDATE_MIN_MAX(*min, *max, lat);
>>>
>>> -     /* the sq is (lat - old_avg) * (lat - new_avg) */
>>> -     avg = DIV64_U64_ROUND_CLOSEST((lsum - lat), (total - 1));
>>> -     sq = lat - avg;
>>> -     avg = DIV64_U64_ROUND_CLOSEST(lsum, total);
>>> -     sq = sq * (lat - avg);
>>> -     *sq_sump += sq;
>>> +     if (unlikely(total == 1)) {
>>> +             *lavg = lat;
>>> +             *lstdev = 0;
>>> +     } else {
>>> +             avg = *lavg + div64_s64(lat - *lavg, total);
>>> +             stdev = *lstdev + (lat - *lavg)*(lat - avg);
>>> +             *lstdev = int_sqrt(div64_u64(stdev, total - 1));
>>> +             *lavg = avg;
>>> +     }
>> IMO, this is incorrect, the math formula please see:
>>
>> https://www.investopedia.com/ask/answers/042415/what-difference-between-standard-error-means-and-standard-deviation.asp
>>
>> The most accurate result should be:
>>
>> stdev = int_sqrt(sum((X(n) - avg)^2, (X(n-1) - avg)^2, ..., (X(1) -
>> avg)^2) / (n - 1)).
>>
>> While you are computing it:
>>
>> stdev_n = int_sqrt(stdev_(n-1) + (X(n-1) - avg)^2)
> Hmm. The int_sqrt() is probably not needed at this point and can be
> done when sending the metric. That would avoid some cycles.
>
> Also, the way avg is calculated not totally incorrect, however, I
> would like to keep it similar to how its done is libcephfs.

In user space this is very easy to do, but not in kernel space, 
especially there has no float computing.

Currently the kclient is doing the avg computing by:

avg(n) = (avg(n-1) + latency(n)) / (n), IMO this should be closer to the 
real avg(n) = sum(latency(n), latency(n-1), ..., latency(1)) / n.

Because it's hard to record all the latency values, this is also many 
other user space tools doing to count the avg.


>> Though current stdev computing method is not exactly the same the math
>> formula does, but it's closer to it, because the kernel couldn't record
>> all the latency value and do it whenever needed, which will occupy a
>> large amount of memories and cpu resources.
> The approach is to calculate the running variance, I.e., compute the
> variance as  data (latency) arrive one at a time.
>
>>
>>>    }
>>>
>>>    void ceph_update_read_metrics(struct ceph_client_metric *m,
>>> @@ -343,23 +352,18 @@ void ceph_update_read_metrics(struct ceph_client_metric *m,
>>>                              unsigned int size, int rc)
>>>    {
>>>        ktime_t lat = ktime_sub(r_end, r_start);
>>> -     ktime_t total;
>>>
>>>        if (unlikely(rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT))
>>>                return;
>>>
>>>        spin_lock(&m->read_metric_lock);
>>> -     total = ++m->total_reads;
>>>        m->read_size_sum += size;
>>> -     m->read_latency_sum += lat;
>>>        METRIC_UPDATE_MIN_MAX(m->read_size_min,
>>>                              m->read_size_max,
>>>                              size);
>>> -     METRIC_UPDATE_MIN_MAX(m->read_latency_min,
>>> -                           m->read_latency_max,
>>> -                           lat);
>>> -     __update_stdev(total, m->read_latency_sum,
>>> -                    &m->read_latency_sq_sum, lat);
>>> +     __update_latency(&m->total_reads, &m->read_latency_sum,
>>> +                      &m->avg_read_latency, &m->read_latency_min,
>>> +                      &m->read_latency_max, &m->read_latency_stdev, lat);
>>>        spin_unlock(&m->read_metric_lock);
>>>    }
>>>
>>> @@ -368,23 +372,18 @@ void ceph_update_write_metrics(struct ceph_client_metric *m,
>>>                               unsigned int size, int rc)
>>>    {
>>>        ktime_t lat = ktime_sub(r_end, r_start);
>>> -     ktime_t total;
>>>
>>>        if (unlikely(rc && rc != -ETIMEDOUT))
>>>                return;
>>>
>>>        spin_lock(&m->write_metric_lock);
>>> -     total = ++m->total_writes;
>>>        m->write_size_sum += size;
>>> -     m->write_latency_sum += lat;
>>>        METRIC_UPDATE_MIN_MAX(m->write_size_min,
>>>                              m->write_size_max,
>>>                              size);
>>> -     METRIC_UPDATE_MIN_MAX(m->write_latency_min,
>>> -                           m->write_latency_max,
>>> -                           lat);
>>> -     __update_stdev(total, m->write_latency_sum,
>>> -                    &m->write_latency_sq_sum, lat);
>>> +     __update_latency(&m->total_writes, &m->write_latency_sum,
>>> +                      &m->avg_write_latency, &m->write_latency_min,
>>> +                      &m->write_latency_max, &m->write_latency_stdev, lat);
>>>        spin_unlock(&m->write_metric_lock);
>>>    }
>>>
>>> @@ -393,18 +392,13 @@ void ceph_update_metadata_metrics(struct ceph_client_metric *m,
>>>                                  int rc)
>>>    {
>>>        ktime_t lat = ktime_sub(r_end, r_start);
>>> -     ktime_t total;
>>>
>>>        if (unlikely(rc && rc != -ENOENT))
>>>                return;
>>>
>>>        spin_lock(&m->metadata_metric_lock);
>>> -     total = ++m->total_metadatas;
>>> -     m->metadata_latency_sum += lat;
>>> -     METRIC_UPDATE_MIN_MAX(m->metadata_latency_min,
>>> -                           m->metadata_latency_max,
>>> -                           lat);
>>> -     __update_stdev(total, m->metadata_latency_sum,
>>> -                    &m->metadata_latency_sq_sum, lat);
>>> +     __update_latency(&m->total_metadatas, &m->metadata_latency_sum,
>>> +                      &m->avg_metadata_latency, &m->metadata_latency_min,
>>> +                      &m->metadata_latency_max, &m->metadata_latency_stdev, lat);
>>>        spin_unlock(&m->metadata_metric_lock);
>>>    }
>>> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
>>> index 103ed736f9d2..a5da21b8f8ed 100644
>>> --- a/fs/ceph/metric.h
>>> +++ b/fs/ceph/metric.h
>>> @@ -138,7 +138,8 @@ struct ceph_client_metric {
>>>        u64 read_size_min;
>>>        u64 read_size_max;
>>>        ktime_t read_latency_sum;
>>> -     ktime_t read_latency_sq_sum;
>>> +     ktime_t avg_read_latency;
>>> +     ktime_t read_latency_stdev;
>>>        ktime_t read_latency_min;
>>>        ktime_t read_latency_max;
>>>
>>> @@ -148,14 +149,16 @@ struct ceph_client_metric {
>>>        u64 write_size_min;
>>>        u64 write_size_max;
>>>        ktime_t write_latency_sum;
>>> -     ktime_t write_latency_sq_sum;
>>> +     ktime_t avg_write_latency;
>>> +     ktime_t write_latency_stdev;
>>>        ktime_t write_latency_min;
>>>        ktime_t write_latency_max;
>>>
>>>        spinlock_t metadata_metric_lock;
>>>        u64 total_metadatas;
>>>        ktime_t metadata_latency_sum;
>>> -     ktime_t metadata_latency_sq_sum;
>>> +     ktime_t avg_metadata_latency;
>>> +     ktime_t metadata_latency_stdev;
>>>        ktime_t metadata_latency_min;
>>>        ktime_t metadata_latency_max;
>>>
>

