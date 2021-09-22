Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416274148A0
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Sep 2021 14:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235608AbhIVMSw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Sep 2021 08:18:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38792 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234294AbhIVMSv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 22 Sep 2021 08:18:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632313041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+tEYjdsUwkc639sfPSL4PFEsef3mNZphtD9dPRZH08s=;
        b=bZ3Oo1GGCTCmX+mV6BP5RAtU36WkBKqtA4Z/KcJTWynoICR0oeG8jIOOFX4XLWs4nupoLh
        TBTygk+TYpMbMFUqEOkJywvxUHC5CCH6wWW/cbLcNXh71RmCu/eKvGeD3nBQ4xXp55X+t6
        mcSCYkjt1sg+Uv/LDfKrnMIVMnEMSGE=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-aeUSo--tOO2hONrPb3SSZw-1; Wed, 22 Sep 2021 08:17:20 -0400
X-MC-Unique: aeUSo--tOO2hONrPb3SSZw-1
Received: by mail-qt1-f200.google.com with SMTP id 62-20020aed2044000000b002a6aa209efaso8145106qta.18
        for <ceph-devel@vger.kernel.org>; Wed, 22 Sep 2021 05:17:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=+tEYjdsUwkc639sfPSL4PFEsef3mNZphtD9dPRZH08s=;
        b=EtE0Fi3JAwRdafKZR2H7PDFZTcQQjW0/x0r95Dzf7DbnwZrLA0L2qwStUMFCVRDc/l
         sndefw/qE6Hapf/Bv/agrACEaldoTFc3TW/h/fb7dGL53AFj1qT/kfZO+fsppcPhR4Fu
         1PrSU+aerrTR7vVkHx/9ARumufIoiUo7UV4wkdmAr3h1s2iA2Ud6H5qaQJORs/6r8sgK
         iCJaCYftHs1IQ7NkOhN4iuhqn9K8qNKocR844rIaN+jU3ANZPRJe3RvFA5i6KREVwl5i
         uk54SVM9OiZ8rDByd9lq5UHwLsPagWgsfLHMz/4Y43Io1dfJ2Xlk9KroEE70fF932F6+
         lDjw==
X-Gm-Message-State: AOAM5305yGWfuZWny/zvaGD7b0v0t6fbzTKTfr09kI/1Zkbppm356ypM
        Q8UHI6E1324mNHK5ISCs0omwlwl3r+GY4IOJfgUtuD7/SJhstoivEBoq4jvyY55GQfl1nmMQiXt
        3y0bdR8+CzssIVSmna39eCw==
X-Received: by 2002:a37:6541:: with SMTP id z62mr32302931qkb.396.1632313039822;
        Wed, 22 Sep 2021 05:17:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJymthGjp015N0ZLxpEIXOoBSVp9ps3ZDnVQFEAeIN5IYTIJPaIEtU0rzzvVLevbjZkKsZn1Ww==
X-Received: by 2002:a37:6541:: with SMTP id z62mr32302911qkb.396.1632313039564;
        Wed, 22 Sep 2021 05:17:19 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id bi10sm1487770qkb.36.2021.09.22.05.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 05:17:19 -0700 (PDT)
Message-ID: <495168ef5d8e3b18f85048a2d61e988ba44a6228.camel@redhat.com>
Subject: Re: [PATCH v3 2/4] ceph: track average/stdev r/w/m latency
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, pdonnell@redhat.com,
        xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org
Date:   Wed, 22 Sep 2021 08:17:18 -0400
In-Reply-To: <20210921130750.31820-3-vshankar@redhat.com>
References: <20210921130750.31820-1-vshankar@redhat.com>
         <20210921130750.31820-3-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-09-21 at 18:37 +0530, Venky Shankar wrote:
> Update the math involved to closely mimic how its done in
> user land. This does not make a lot of difference to the
> execution speed.
> 
> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>  fs/ceph/metric.c | 63 +++++++++++++++++++++---------------------------
>  fs/ceph/metric.h |  3 +++
>  2 files changed, 31 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> index 226dc38e2909..ca758bff69ca 100644
> --- a/fs/ceph/metric.c
> +++ b/fs/ceph/metric.c
> @@ -245,6 +245,7 @@ int ceph_metric_init(struct ceph_client_metric *m)
>  
>  	spin_lock_init(&m->read_metric_lock);
>  	m->read_latency_sq_sum = 0;
> +	m->avg_read_latency = 0;
>  	m->read_latency_min = KTIME_MAX;
>  	m->read_latency_max = 0;
>  	m->total_reads = 0;
> @@ -255,6 +256,7 @@ int ceph_metric_init(struct ceph_client_metric *m)
>  
>  	spin_lock_init(&m->write_metric_lock);
>  	m->write_latency_sq_sum = 0;
> +	m->avg_write_latency = 0;
>  	m->write_latency_min = KTIME_MAX;
>  	m->write_latency_max = 0;
>  	m->total_writes = 0;
> @@ -265,6 +267,7 @@ int ceph_metric_init(struct ceph_client_metric *m)
>  
>  	spin_lock_init(&m->metadata_metric_lock);
>  	m->metadata_latency_sq_sum = 0;
> +	m->avg_metadata_latency = 0;
>  	m->metadata_latency_min = KTIME_MAX;
>  	m->metadata_latency_max = 0;
>  	m->total_metadatas = 0;
> @@ -322,20 +325,25 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
>  		max = new;			\
>  }
>  
> -static inline void __update_stdev(ktime_t total, ktime_t lsum,
> -				  ktime_t *sq_sump, ktime_t lat)
> +static inline void __update_latency(ktime_t *ctotal, ktime_t *lsum,
> +				    ktime_t *lavg, ktime_t *min, ktime_t *max,
> +				    ktime_t *sum_sq, ktime_t lat)
>  {
> -	ktime_t avg, sq;
> +	ktime_t total, avg;
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
> +		*sum_sq = 0;
> +	} else {
> +		avg = *lavg + div64_s64(lat - *lavg, total);
> +		*sum_sq += (lat - *lavg)*(lat - avg);
> +		*lavg = avg;
> +	}
>  }
>  
>  void ceph_update_read_metrics(struct ceph_client_metric *m,
> @@ -343,23 +351,18 @@ void ceph_update_read_metrics(struct ceph_client_metric *m,
>  			      unsigned int size, int rc)
>  {
>  	ktime_t lat = ktime_sub(r_end, r_start);
> -	ktime_t total;
>  
>  	if (unlikely(rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT))
>  		return;
>  
>  	spin_lock(&m->read_metric_lock);
> -	total = ++m->total_reads;
>  	m->read_size_sum += size;
> -	m->read_latency_sum += lat;
>  	METRIC_UPDATE_MIN_MAX(m->read_size_min,
>  			      m->read_size_max,
>  			      size);
> -	METRIC_UPDATE_MIN_MAX(m->read_latency_min,
> -			      m->read_latency_max,
> -			      lat);
> -	__update_stdev(total, m->read_latency_sum,
> -		       &m->read_latency_sq_sum, lat);
> +	__update_latency(&m->total_reads, &m->read_latency_sum,
> +			 &m->avg_read_latency, &m->read_latency_min,
> +			 &m->read_latency_max, &m->read_latency_sq_sum, lat);

Do we really need to calculate the std deviation on every update? We
have to figure that in most cases, this stuff will be collected but only
seldom viewed.

ISTM that we ought to collect just the bare minimum of info on each
update, and save the more expensive calculations for the tool presenting
this info.

>  	spin_unlock(&m->read_metric_lock);
>  }
>  
> @@ -368,23 +371,18 @@ void ceph_update_write_metrics(struct ceph_client_metric *m,
>  			       unsigned int size, int rc)
>  {
>  	ktime_t lat = ktime_sub(r_end, r_start);
> -	ktime_t total;
>  
>  	if (unlikely(rc && rc != -ETIMEDOUT))
>  		return;
>  
>  	spin_lock(&m->write_metric_lock);
> -	total = ++m->total_writes;
>  	m->write_size_sum += size;
> -	m->write_latency_sum += lat;
>  	METRIC_UPDATE_MIN_MAX(m->write_size_min,
>  			      m->write_size_max,
>  			      size);
> -	METRIC_UPDATE_MIN_MAX(m->write_latency_min,
> -			      m->write_latency_max,
> -			      lat);
> -	__update_stdev(total, m->write_latency_sum,
> -		       &m->write_latency_sq_sum, lat);
> +	__update_latency(&m->total_writes, &m->write_latency_sum,
> +			 &m->avg_write_latency, &m->write_latency_min,
> +			 &m->write_latency_max, &m->write_latency_sq_sum, lat);
>  	spin_unlock(&m->write_metric_lock);
>  }
>  
> @@ -393,18 +391,13 @@ void ceph_update_metadata_metrics(struct ceph_client_metric *m,
>  				  int rc)
>  {
>  	ktime_t lat = ktime_sub(r_end, r_start);
> -	ktime_t total;
>  
>  	if (unlikely(rc && rc != -ENOENT))
>  		return;
>  
>  	spin_lock(&m->metadata_metric_lock);
> -	total = ++m->total_metadatas;
> -	m->metadata_latency_sum += lat;
> -	METRIC_UPDATE_MIN_MAX(m->metadata_latency_min,
> -			      m->metadata_latency_max,
> -			      lat);
> -	__update_stdev(total, m->metadata_latency_sum,
> -		       &m->metadata_latency_sq_sum, lat);
> +	__update_latency(&m->total_metadatas, &m->metadata_latency_sum,
> +			 &m->avg_metadata_latency, &m->metadata_latency_min,
> +			 &m->metadata_latency_max, &m->metadata_latency_sq_sum, lat);
>  	spin_unlock(&m->metadata_metric_lock);
>  }
> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
> index 103ed736f9d2..0af02e212033 100644
> --- a/fs/ceph/metric.h
> +++ b/fs/ceph/metric.h
> @@ -138,6 +138,7 @@ struct ceph_client_metric {
>  	u64 read_size_min;
>  	u64 read_size_max;
>  	ktime_t read_latency_sum;
> +	ktime_t avg_read_latency;
>  	ktime_t read_latency_sq_sum;
>  	ktime_t read_latency_min;
>  	ktime_t read_latency_max;
> @@ -148,6 +149,7 @@ struct ceph_client_metric {
>  	u64 write_size_min;
>  	u64 write_size_max;
>  	ktime_t write_latency_sum;
> +	ktime_t avg_write_latency;
>  	ktime_t write_latency_sq_sum;
>  	ktime_t write_latency_min;
>  	ktime_t write_latency_max;
> @@ -155,6 +157,7 @@ struct ceph_client_metric {
>  	spinlock_t metadata_metric_lock;
>  	u64 total_metadatas;
>  	ktime_t metadata_latency_sum;
> +	ktime_t avg_metadata_latency;
>  	ktime_t metadata_latency_sq_sum;
>  	ktime_t metadata_latency_min;
>  	ktime_t metadata_latency_max;

-- 
Jeff Layton <jlayton@redhat.com>

