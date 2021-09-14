Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5970E40AE45
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Sep 2021 14:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbhINMyX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Sep 2021 08:54:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48504 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232866AbhINMyW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 08:54:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631623984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+8B6PXrQvelMsjuyI57RkB1aKMo+bThm1IIFW0vOvyY=;
        b=Ok2uo7GC2qemY5Qod452GSff1YU+W5X49YaHC7tn1XudUqFDU4SkAaJmJ4Q+iCE8PGNbNY
        w9CGbZLTuvGiSR93XQSBYB/ka0Rg6xAwPB/2BRfevlXAJPDu2q8zV4KzYx+XG4b/F9NlPK
        KgCYbtTN4Psqq3bxBuyhNXIQ3XjbB0Q=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-fG6GznDFMZWo2BKOi4CQwg-1; Tue, 14 Sep 2021 08:53:03 -0400
X-MC-Unique: fG6GznDFMZWo2BKOi4CQwg-1
Received: by mail-pf1-f199.google.com with SMTP id 127-20020a621685000000b0043376b0ce1dso8204074pfw.22
        for <ceph-devel@vger.kernel.org>; Tue, 14 Sep 2021 05:53:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=+8B6PXrQvelMsjuyI57RkB1aKMo+bThm1IIFW0vOvyY=;
        b=h3AYW+R4t2uoBBMm711Uq+lfUhSgel7d5XMDkqMrdZyAyRhpmzyHHCycWBP6rGs07y
         5Hsq41cTKAPRw+h0HOa22dytjod5NmeU9YKbnGW3BtV6d3eUVOLAr2qT/TWmQfiPgCbP
         vO+haRtZv8ucL7VUzbAYzr4rsE04TwFXv7NjgJsELlcfiFvs6YIFBYyjP9xuSVq4gNdM
         /38nLWUMNcRKJPwuzqOmzXvI0QiPTTIP5JJ2z+O8+wEMdM8JYcvcIotu5eDt597crk8g
         cs8go3gR+MkF2YXl3KHyLOGwPjr80DC6ABOjPfYhhHRPqLIRCqlmRHyX8e7NXNGZmyjm
         iYLg==
X-Gm-Message-State: AOAM530SBLbaCYkMtNyGuAusyfkdGkCkVD5YytxVu8xqBeU9TLalWaKb
        xY5VoxQITla5a+wFBUsmdPrCPe95slFNivNzVre1jEapNTelGa3Co29ayEEm+ax6BQ6S54PCB88
        L3EK+L7XGBuPkLT8SiuNXlLiN1Fibkjdqwhq0JLtgu3ULkgt0MUj0SFNFH9bdy1j1mm79ARg=
X-Received: by 2002:a62:8041:0:b0:43b:6e29:9057 with SMTP id j62-20020a628041000000b0043b6e299057mr4675020pfd.39.1631623981785;
        Tue, 14 Sep 2021 05:53:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7f+KDb9ckl5BLwN5VeXKaFDLfsa2d8JvZ8/lN8/iyL2Xy6dp54KvLCP7OuUpzD5s4cmkqxg==
X-Received: by 2002:a62:8041:0:b0:43b:6e29:9057 with SMTP id j62-20020a628041000000b0043b6e299057mr4674984pfd.39.1631623981358;
        Tue, 14 Sep 2021 05:53:01 -0700 (PDT)
Received: from [10.72.12.89] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i1sm1766366pjs.31.2021.09.14.05.52.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 05:53:01 -0700 (PDT)
Subject: Re: [PATCH v2 2/4] ceph: track average/stdev r/w/m latency
To:     Venky Shankar <vshankar@redhat.com>, jlayton@redhat.com,
        pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org
References: <20210914084902.1618064-1-vshankar@redhat.com>
 <20210914084902.1618064-3-vshankar@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b9d1a0ea-147c-251b-1618-111d869687a0@redhat.com>
Date:   Tue, 14 Sep 2021 20:52:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210914084902.1618064-3-vshankar@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/14/21 4:49 PM, Venky Shankar wrote:
> The math involved in tracking average and standard deviation
> for r/w/m latencies looks incorrect. Fix that up. Also, change
> the variable name that tracks standard deviation (*_sq_sum) to
> *_stdev.
>
> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>   fs/ceph/debugfs.c | 14 +++++-----
>   fs/ceph/metric.c  | 70 ++++++++++++++++++++++-------------------------
>   fs/ceph/metric.h  |  9 ++++--
>   3 files changed, 45 insertions(+), 48 deletions(-)
>
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 38b78b45811f..3abfa7ae8220 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -152,7 +152,7 @@ static int metric_show(struct seq_file *s, void *p)
>   	struct ceph_mds_client *mdsc = fsc->mdsc;
>   	struct ceph_client_metric *m = &mdsc->metric;
>   	int nr_caps = 0;
> -	s64 total, sum, avg, min, max, sq;
> +	s64 total, sum, avg, min, max, stdev;
>   	u64 sum_sz, avg_sz, min_sz, max_sz;
>   
>   	sum = percpu_counter_sum(&m->total_inodes);
> @@ -175,9 +175,9 @@ static int metric_show(struct seq_file *s, void *p)
>   	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
>   	min = m->read_latency_min;
>   	max = m->read_latency_max;
> -	sq = m->read_latency_sq_sum;
> +	stdev = m->read_latency_stdev;
>   	spin_unlock(&m->read_metric_lock);
> -	CEPH_LAT_METRIC_SHOW("read", total, avg, min, max, sq);
> +	CEPH_LAT_METRIC_SHOW("read", total, avg, min, max, stdev);
>   
>   	spin_lock(&m->write_metric_lock);
>   	total = m->total_writes;
> @@ -185,9 +185,9 @@ static int metric_show(struct seq_file *s, void *p)
>   	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
>   	min = m->write_latency_min;
>   	max = m->write_latency_max;
> -	sq = m->write_latency_sq_sum;
> +	stdev = m->write_latency_stdev;
>   	spin_unlock(&m->write_metric_lock);
> -	CEPH_LAT_METRIC_SHOW("write", total, avg, min, max, sq);
> +	CEPH_LAT_METRIC_SHOW("write", total, avg, min, max, stdev);

Hi Venky,

Sorry I missed you V1 patch set.

Previously the "sq_sum" just counting the square sum and only when 
showing them in the debug file will it to compute the stdev in 
CEPH_LAT_METRIC_SHOW().

So with this patch I think you also need to fix the 
CEPH_LAT_METRIC_SHOW(), no need to compute it twice ?

Thanks.

>   
>   	spin_lock(&m->metadata_metric_lock);
>   	total = m->total_metadatas;
> @@ -195,9 +195,9 @@ static int metric_show(struct seq_file *s, void *p)
>   	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
>   	min = m->metadata_latency_min;
>   	max = m->metadata_latency_max;
> -	sq = m->metadata_latency_sq_sum;
> +	stdev = m->metadata_latency_stdev;
>   	spin_unlock(&m->metadata_metric_lock);
> -	CEPH_LAT_METRIC_SHOW("metadata", total, avg, min, max, sq);
> +	CEPH_LAT_METRIC_SHOW("metadata", total, avg, min, max, stdev);
>   
>   	seq_printf(s, "\n");
>   	seq_printf(s, "item          total       avg_sz(bytes)   min_sz(bytes)   max_sz(bytes)  total_sz(bytes)\n");
> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> index 226dc38e2909..6b774b1a88ce 100644
> --- a/fs/ceph/metric.c
> +++ b/fs/ceph/metric.c
> @@ -244,7 +244,8 @@ int ceph_metric_init(struct ceph_client_metric *m)
>   		goto err_i_caps_mis;
>   
>   	spin_lock_init(&m->read_metric_lock);
> -	m->read_latency_sq_sum = 0;
> +	m->read_latency_stdev = 0;
> +	m->avg_read_latency = 0;
>   	m->read_latency_min = KTIME_MAX;
>   	m->read_latency_max = 0;
>   	m->total_reads = 0;
> @@ -254,7 +255,8 @@ int ceph_metric_init(struct ceph_client_metric *m)
>   	m->read_size_sum = 0;
>   
>   	spin_lock_init(&m->write_metric_lock);
> -	m->write_latency_sq_sum = 0;
> +	m->write_latency_stdev = 0;
> +	m->avg_write_latency = 0;
>   	m->write_latency_min = KTIME_MAX;
>   	m->write_latency_max = 0;
>   	m->total_writes = 0;
> @@ -264,7 +266,8 @@ int ceph_metric_init(struct ceph_client_metric *m)
>   	m->write_size_sum = 0;
>   
>   	spin_lock_init(&m->metadata_metric_lock);
> -	m->metadata_latency_sq_sum = 0;
> +	m->metadata_latency_stdev = 0;
> +	m->avg_metadata_latency = 0;
>   	m->metadata_latency_min = KTIME_MAX;
>   	m->metadata_latency_max = 0;
>   	m->total_metadatas = 0;
> @@ -322,20 +325,26 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
>   		max = new;			\
>   }
>   
> -static inline void __update_stdev(ktime_t total, ktime_t lsum,
> -				  ktime_t *sq_sump, ktime_t lat)
> +static inline void __update_latency(ktime_t *ctotal, ktime_t *lsum,
> +				    ktime_t *lavg, ktime_t *min, ktime_t *max,
> +				    ktime_t *lstdev, ktime_t lat)
>   {
> -	ktime_t avg, sq;
> +	ktime_t total, avg, stdev;
>   
> -	if (unlikely(total == 1))
> -		return;
> +	total = ++(*ctotal);
> +	*lsum += lat;
> +
> +	METRIC_UPDATE_MIN_MAX(*min, *max, lat);
>   
> -	/* the sq is (lat - old_avg) * (lat - new_avg) */
> -	avg = DIV64_U64_ROUND_CLOSEST((lsum - lat), (total - 1));
> -	sq = lat - avg;
> -	avg = DIV64_U64_ROUND_CLOSEST(lsum, total);
> -	sq = sq * (lat - avg);
> -	*sq_sump += sq;
> +	if (unlikely(total == 1)) {
> +		*lavg = lat;
> +		*lstdev = 0;
> +	} else {
> +		avg = *lavg + div64_s64(lat - *lavg, total);
> +		stdev = *lstdev + (lat - *lavg)*(lat - avg);
> +		*lstdev = int_sqrt(div64_u64(stdev, total - 1));
> +		*lavg = avg;
> +	}
>   }
>   
>   void ceph_update_read_metrics(struct ceph_client_metric *m,
> @@ -343,23 +352,18 @@ void ceph_update_read_metrics(struct ceph_client_metric *m,
>   			      unsigned int size, int rc)
>   {
>   	ktime_t lat = ktime_sub(r_end, r_start);
> -	ktime_t total;
>   
>   	if (unlikely(rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT))
>   		return;
>   
>   	spin_lock(&m->read_metric_lock);
> -	total = ++m->total_reads;
>   	m->read_size_sum += size;
> -	m->read_latency_sum += lat;
>   	METRIC_UPDATE_MIN_MAX(m->read_size_min,
>   			      m->read_size_max,
>   			      size);
> -	METRIC_UPDATE_MIN_MAX(m->read_latency_min,
> -			      m->read_latency_max,
> -			      lat);
> -	__update_stdev(total, m->read_latency_sum,
> -		       &m->read_latency_sq_sum, lat);
> +	__update_latency(&m->total_reads, &m->read_latency_sum,
> +			 &m->avg_read_latency, &m->read_latency_min,
> +			 &m->read_latency_max, &m->read_latency_stdev, lat);
>   	spin_unlock(&m->read_metric_lock);
>   }
>   
> @@ -368,23 +372,18 @@ void ceph_update_write_metrics(struct ceph_client_metric *m,
>   			       unsigned int size, int rc)
>   {
>   	ktime_t lat = ktime_sub(r_end, r_start);
> -	ktime_t total;
>   
>   	if (unlikely(rc && rc != -ETIMEDOUT))
>   		return;
>   
>   	spin_lock(&m->write_metric_lock);
> -	total = ++m->total_writes;
>   	m->write_size_sum += size;
> -	m->write_latency_sum += lat;
>   	METRIC_UPDATE_MIN_MAX(m->write_size_min,
>   			      m->write_size_max,
>   			      size);
> -	METRIC_UPDATE_MIN_MAX(m->write_latency_min,
> -			      m->write_latency_max,
> -			      lat);
> -	__update_stdev(total, m->write_latency_sum,
> -		       &m->write_latency_sq_sum, lat);
> +	__update_latency(&m->total_writes, &m->write_latency_sum,
> +			 &m->avg_write_latency, &m->write_latency_min,
> +			 &m->write_latency_max, &m->write_latency_stdev, lat);
>   	spin_unlock(&m->write_metric_lock);
>   }
>   
> @@ -393,18 +392,13 @@ void ceph_update_metadata_metrics(struct ceph_client_metric *m,
>   				  int rc)
>   {
>   	ktime_t lat = ktime_sub(r_end, r_start);
> -	ktime_t total;
>   
>   	if (unlikely(rc && rc != -ENOENT))
>   		return;
>   
>   	spin_lock(&m->metadata_metric_lock);
> -	total = ++m->total_metadatas;
> -	m->metadata_latency_sum += lat;
> -	METRIC_UPDATE_MIN_MAX(m->metadata_latency_min,
> -			      m->metadata_latency_max,
> -			      lat);
> -	__update_stdev(total, m->metadata_latency_sum,
> -		       &m->metadata_latency_sq_sum, lat);
> +	__update_latency(&m->total_metadatas, &m->metadata_latency_sum,
> +			 &m->avg_metadata_latency, &m->metadata_latency_min,
> +			 &m->metadata_latency_max, &m->metadata_latency_stdev, lat);
>   	spin_unlock(&m->metadata_metric_lock);
>   }
> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
> index 103ed736f9d2..a5da21b8f8ed 100644
> --- a/fs/ceph/metric.h
> +++ b/fs/ceph/metric.h
> @@ -138,7 +138,8 @@ struct ceph_client_metric {
>   	u64 read_size_min;
>   	u64 read_size_max;
>   	ktime_t read_latency_sum;
> -	ktime_t read_latency_sq_sum;
> +	ktime_t avg_read_latency;
> +	ktime_t read_latency_stdev;
>   	ktime_t read_latency_min;
>   	ktime_t read_latency_max;
>   
> @@ -148,14 +149,16 @@ struct ceph_client_metric {
>   	u64 write_size_min;
>   	u64 write_size_max;
>   	ktime_t write_latency_sum;
> -	ktime_t write_latency_sq_sum;
> +	ktime_t avg_write_latency;
> +	ktime_t write_latency_stdev;
>   	ktime_t write_latency_min;
>   	ktime_t write_latency_max;
>   
>   	spinlock_t metadata_metric_lock;
>   	u64 total_metadatas;
>   	ktime_t metadata_latency_sum;
> -	ktime_t metadata_latency_sq_sum;
> +	ktime_t avg_metadata_latency;
> +	ktime_t metadata_latency_stdev;
>   	ktime_t metadata_latency_min;
>   	ktime_t metadata_latency_max;
>   

