Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F8840AEF5
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Sep 2021 15:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbhINNdZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Sep 2021 09:33:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40184 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233055AbhINNdY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:33:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631626326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SaF6q11yn8/2GhUJis5ubrPIrY5M6ULsqpmqnwNc8+Q=;
        b=h0ZT0V+RsWevH13of/52sl7LdBlGCDNuaA1Mub4VJ0Vct9V3tMTh5RDrGTswb3WD75h9ed
        LG6Vi0+bb92BKPLF9SM/Neg2sB2jCtNeQlTreiKOBCN6rm4Zg7q1X/qvywAqE+mbsDEIiT
        CKp7iYSA/wm/eUmlhiG4r9bPMByRC0w=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-M7Qn-6AWMMaeUbihsMvKEQ-1; Tue, 14 Sep 2021 09:32:05 -0400
X-MC-Unique: M7Qn-6AWMMaeUbihsMvKEQ-1
Received: by mail-qt1-f197.google.com with SMTP id l22-20020a05622a175600b0029d63a970f6so59738935qtk.23
        for <ceph-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:32:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=SaF6q11yn8/2GhUJis5ubrPIrY5M6ULsqpmqnwNc8+Q=;
        b=b9FLyCLfp8GRb9q29il/o9h15oI4M/gUFeD1MwTNt5DMhE0yqMxRQw6I83xLIY0VTa
         q+JieRCkDBN5juNrMgy+qU8RA87rjiJGD/ix2Ahawj4XoD/wUzx7gmzxrOpCvGcN+8II
         bXyOGGtSYX6vroyKLyk+mMfvbfpkp/nHqkqrBj7bQ4jNIUjql56ow2Db/+Rt6LdjbPep
         /xVS5wO2qzagJ5+9Jz3lM+g1rKxF6iqAXhaXEhx7deY4CU5tda7oOfSCuHG8TtVNKIdU
         2mOEGL+NxeUYda0zO70fLvxKyRrQ3eT6pgx1sYmE3I33xTPtTrCdO/bQC0yR/gm+pRkS
         OohQ==
X-Gm-Message-State: AOAM53047JaA9URHbA0TQbcXjOpt7sVjlhImktcyfNqLsYLiTa+H6Flv
        8BYJUmffZkLUiWKNEck+7Nv9pHVCqhGPWLsUqbjZiOMfru2XeTBu++/o22nMPKJp7PtXkOcWa/3
        zI3JCbT56S4tIvPCiwIPy6g==
X-Received: by 2002:a0c:80e5:: with SMTP id 92mr5372440qvb.39.1631626325176;
        Tue, 14 Sep 2021 06:32:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyX7L5alZD8+Ioj3oDUJCzfxCymtW2vWapzYAw8q8jgLqXe+wFKH5cGdWhuCYW0KKlxE2qL4w==
X-Received: by 2002:a0c:80e5:: with SMTP id 92mr5372404qvb.39.1631626324838;
        Tue, 14 Sep 2021 06:32:04 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id s28sm7149808qkm.43.2021.09.14.06.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:32:04 -0700 (PDT)
Message-ID: <292bfd1d27401722e3a45161c4a30c3614a39a0d.camel@redhat.com>
Subject: Re: [PATCH v2 2/4] ceph: track average/stdev r/w/m latency
From:   Jeff Layton <jlayton@redhat.com>
To:     Xiubo Li <xiubli@redhat.com>, Venky Shankar <vshankar@redhat.com>,
        pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org
Date:   Tue, 14 Sep 2021 09:32:03 -0400
In-Reply-To: <7b7a93ad-4a45-4187-5220-709fee38b4ea@redhat.com>
References: <20210914084902.1618064-1-vshankar@redhat.com>
         <20210914084902.1618064-3-vshankar@redhat.com>
         <7b7a93ad-4a45-4187-5220-709fee38b4ea@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-09-14 at 21:13 +0800, Xiubo Li wrote:
> On 9/14/21 4:49 PM, Venky Shankar wrote:
> > The math involved in tracking average and standard deviation
> > for r/w/m latencies looks incorrect. Fix that up. Also, change
> > the variable name that tracks standard deviation (*_sq_sum) to
> > *_stdev.
> > 
> > Signed-off-by: Venky Shankar <vshankar@redhat.com>
> > ---
> >   fs/ceph/debugfs.c | 14 +++++-----
> >   fs/ceph/metric.c  | 70 ++++++++++++++++++++++-------------------------
> >   fs/ceph/metric.h  |  9 ++++--
> >   3 files changed, 45 insertions(+), 48 deletions(-)
> > 
> > diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> > index 38b78b45811f..3abfa7ae8220 100644
> > --- a/fs/ceph/debugfs.c
> > +++ b/fs/ceph/debugfs.c
> > @@ -152,7 +152,7 @@ static int metric_show(struct seq_file *s, void *p)
> >   	struct ceph_mds_client *mdsc = fsc->mdsc;
> >   	struct ceph_client_metric *m = &mdsc->metric;
> >   	int nr_caps = 0;
> > -	s64 total, sum, avg, min, max, sq;
> > +	s64 total, sum, avg, min, max, stdev;
> >   	u64 sum_sz, avg_sz, min_sz, max_sz;
> >   
> >   	sum = percpu_counter_sum(&m->total_inodes);
> > @@ -175,9 +175,9 @@ static int metric_show(struct seq_file *s, void *p)
> >   	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
> >   	min = m->read_latency_min;
> >   	max = m->read_latency_max;
> > -	sq = m->read_latency_sq_sum;
> > +	stdev = m->read_latency_stdev;
> >   	spin_unlock(&m->read_metric_lock);
> > -	CEPH_LAT_METRIC_SHOW("read", total, avg, min, max, sq);
> > +	CEPH_LAT_METRIC_SHOW("read", total, avg, min, max, stdev);
> >   
> >   	spin_lock(&m->write_metric_lock);
> >   	total = m->total_writes;
> > @@ -185,9 +185,9 @@ static int metric_show(struct seq_file *s, void *p)
> >   	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
> >   	min = m->write_latency_min;
> >   	max = m->write_latency_max;
> > -	sq = m->write_latency_sq_sum;
> > +	stdev = m->write_latency_stdev;
> >   	spin_unlock(&m->write_metric_lock);
> > -	CEPH_LAT_METRIC_SHOW("write", total, avg, min, max, sq);
> > +	CEPH_LAT_METRIC_SHOW("write", total, avg, min, max, stdev);
> >   
> >   	spin_lock(&m->metadata_metric_lock);
> >   	total = m->total_metadatas;
> > @@ -195,9 +195,9 @@ static int metric_show(struct seq_file *s, void *p)
> >   	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
> >   	min = m->metadata_latency_min;
> >   	max = m->metadata_latency_max;
> > -	sq = m->metadata_latency_sq_sum;
> > +	stdev = m->metadata_latency_stdev;
> >   	spin_unlock(&m->metadata_metric_lock);
> > -	CEPH_LAT_METRIC_SHOW("metadata", total, avg, min, max, sq);
> > +	CEPH_LAT_METRIC_SHOW("metadata", total, avg, min, max, stdev);
> >   
> >   	seq_printf(s, "\n");
> >   	seq_printf(s, "item          total       avg_sz(bytes)   min_sz(bytes)   max_sz(bytes)  total_sz(bytes)\n");
> > diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> > index 226dc38e2909..6b774b1a88ce 100644
> > --- a/fs/ceph/metric.c
> > +++ b/fs/ceph/metric.c
> > @@ -244,7 +244,8 @@ int ceph_metric_init(struct ceph_client_metric *m)
> >   		goto err_i_caps_mis;
> >   
> >   	spin_lock_init(&m->read_metric_lock);
> > -	m->read_latency_sq_sum = 0;
> > +	m->read_latency_stdev = 0;
> > +	m->avg_read_latency = 0;
> >   	m->read_latency_min = KTIME_MAX;
> >   	m->read_latency_max = 0;
> >   	m->total_reads = 0;
> > @@ -254,7 +255,8 @@ int ceph_metric_init(struct ceph_client_metric *m)
> >   	m->read_size_sum = 0;
> >   
> >   	spin_lock_init(&m->write_metric_lock);
> > -	m->write_latency_sq_sum = 0;
> > +	m->write_latency_stdev = 0;
> > +	m->avg_write_latency = 0;
> >   	m->write_latency_min = KTIME_MAX;
> >   	m->write_latency_max = 0;
> >   	m->total_writes = 0;
> > @@ -264,7 +266,8 @@ int ceph_metric_init(struct ceph_client_metric *m)
> >   	m->write_size_sum = 0;
> >   
> >   	spin_lock_init(&m->metadata_metric_lock);
> > -	m->metadata_latency_sq_sum = 0;
> > +	m->metadata_latency_stdev = 0;
> > +	m->avg_metadata_latency = 0;
> >   	m->metadata_latency_min = KTIME_MAX;
> >   	m->metadata_latency_max = 0;
> >   	m->total_metadatas = 0;
> > @@ -322,20 +325,26 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
> >   		max = new;			\
> >   }
> >   
> > -static inline void __update_stdev(ktime_t total, ktime_t lsum,
> > -				  ktime_t *sq_sump, ktime_t lat)
> > +static inline void __update_latency(ktime_t *ctotal, ktime_t *lsum,
> > +				    ktime_t *lavg, ktime_t *min, ktime_t *max,
> > +				    ktime_t *lstdev, ktime_t lat)
> >   {
> > -	ktime_t avg, sq;
> > +	ktime_t total, avg, stdev;
> >   
> > -	if (unlikely(total == 1))
> > -		return;
> > +	total = ++(*ctotal);
> > +	*lsum += lat;
> > +
> > +	METRIC_UPDATE_MIN_MAX(*min, *max, lat);
> >   
> > -	/* the sq is (lat - old_avg) * (lat - new_avg) */
> > -	avg = DIV64_U64_ROUND_CLOSEST((lsum - lat), (total - 1));
> > -	sq = lat - avg;
> > -	avg = DIV64_U64_ROUND_CLOSEST(lsum, total);
> > -	sq = sq * (lat - avg);
> > -	*sq_sump += sq;
> > +	if (unlikely(total == 1)) {
> > +		*lavg = lat;
> > +		*lstdev = 0;
> > +	} else {
> > +		avg = *lavg + div64_s64(lat - *lavg, total);
> > +		stdev = *lstdev + (lat - *lavg)*(lat - avg);
> > +		*lstdev = int_sqrt(div64_u64(stdev, total - 1));
> 
> In kernel space, won't it a little heavy to run the in_sqrt() every time 
> when updating the latency ?
> 
> @Jeff, any idea ?
> 
> 

Yeah, I agree...

int_sqrt() doesn't look _too_ awful -- it's mostly shifts and adds. You
can see the code for it in lib/math/int_sqrt.c. This probably ought to
be using int_sqrt64() too since the argument is a 64-bit value.

Still, keeping the amount of work low for each new update is really
better if you can. It would be best to defer as much computation as
possible to when this info is being queried. In many cases, this info
will never be consulted, so we really want to keep its overhead low.

> > +		*lavg = avg;
> > +	}
> >   }
> >   
> >   void ceph_update_read_metrics(struct ceph_client_metric *m,
> > @@ -343,23 +352,18 @@ void ceph_update_read_metrics(struct ceph_client_metric *m,
> >   			      unsigned int size, int rc)
> >   {
> >   	ktime_t lat = ktime_sub(r_end, r_start);
> > -	ktime_t total;
> >   
> >   	if (unlikely(rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT))
> >   		return;
> >   
> >   	spin_lock(&m->read_metric_lock);
> > -	total = ++m->total_reads;
> >   	m->read_size_sum += size;
> > -	m->read_latency_sum += lat;
> >   	METRIC_UPDATE_MIN_MAX(m->read_size_min,
> >   			      m->read_size_max,
> >   			      size);
> > -	METRIC_UPDATE_MIN_MAX(m->read_latency_min,
> > -			      m->read_latency_max,
> > -			      lat);
> > -	__update_stdev(total, m->read_latency_sum,
> > -		       &m->read_latency_sq_sum, lat);
> > +	__update_latency(&m->total_reads, &m->read_latency_sum,
> > +			 &m->avg_read_latency, &m->read_latency_min,
> > +			 &m->read_latency_max, &m->read_latency_stdev, lat);
> >   	spin_unlock(&m->read_metric_lock);
> >   }
> >   
> > @@ -368,23 +372,18 @@ void ceph_update_write_metrics(struct ceph_client_metric *m,
> >   			       unsigned int size, int rc)
> >   {
> >   	ktime_t lat = ktime_sub(r_end, r_start);
> > -	ktime_t total;
> >   
> >   	if (unlikely(rc && rc != -ETIMEDOUT))
> >   		return;
> >   
> >   	spin_lock(&m->write_metric_lock);
> > -	total = ++m->total_writes;
> >   	m->write_size_sum += size;
> > -	m->write_latency_sum += lat;
> >   	METRIC_UPDATE_MIN_MAX(m->write_size_min,
> >   			      m->write_size_max,
> >   			      size);
> > -	METRIC_UPDATE_MIN_MAX(m->write_latency_min,
> > -			      m->write_latency_max,
> > -			      lat);
> > -	__update_stdev(total, m->write_latency_sum,
> > -		       &m->write_latency_sq_sum, lat);
> > +	__update_latency(&m->total_writes, &m->write_latency_sum,
> > +			 &m->avg_write_latency, &m->write_latency_min,
> > +			 &m->write_latency_max, &m->write_latency_stdev, lat);
> >   	spin_unlock(&m->write_metric_lock);
> >   }
> >   
> > @@ -393,18 +392,13 @@ void ceph_update_metadata_metrics(struct ceph_client_metric *m,
> >   				  int rc)
> >   {
> >   	ktime_t lat = ktime_sub(r_end, r_start);
> > -	ktime_t total;
> >   
> >   	if (unlikely(rc && rc != -ENOENT))
> >   		return;
> >   
> >   	spin_lock(&m->metadata_metric_lock);
> > -	total = ++m->total_metadatas;
> > -	m->metadata_latency_sum += lat;
> > -	METRIC_UPDATE_MIN_MAX(m->metadata_latency_min,
> > -			      m->metadata_latency_max,
> > -			      lat);
> > -	__update_stdev(total, m->metadata_latency_sum,
> > -		       &m->metadata_latency_sq_sum, lat);
> > +	__update_latency(&m->total_metadatas, &m->metadata_latency_sum,
> > +			 &m->avg_metadata_latency, &m->metadata_latency_min,
> > +			 &m->metadata_latency_max, &m->metadata_latency_stdev, lat);
> >   	spin_unlock(&m->metadata_metric_lock);
> >   }
> > diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
> > index 103ed736f9d2..a5da21b8f8ed 100644
> > --- a/fs/ceph/metric.h
> > +++ b/fs/ceph/metric.h
> > @@ -138,7 +138,8 @@ struct ceph_client_metric {
> >   	u64 read_size_min;
> >   	u64 read_size_max;
> >   	ktime_t read_latency_sum;
> > -	ktime_t read_latency_sq_sum;
> > +	ktime_t avg_read_latency;
> > +	ktime_t read_latency_stdev;
> >   	ktime_t read_latency_min;
> >   	ktime_t read_latency_max;
> >   
> > @@ -148,14 +149,16 @@ struct ceph_client_metric {
> >   	u64 write_size_min;
> >   	u64 write_size_max;
> >   	ktime_t write_latency_sum;
> > -	ktime_t write_latency_sq_sum;
> > +	ktime_t avg_write_latency;
> > +	ktime_t write_latency_stdev;
> >   	ktime_t write_latency_min;
> >   	ktime_t write_latency_max;
> >   
> >   	spinlock_t metadata_metric_lock;
> >   	u64 total_metadatas;
> >   	ktime_t metadata_latency_sum;
> > -	ktime_t metadata_latency_sq_sum;
> > +	ktime_t avg_metadata_latency;
> > +	ktime_t metadata_latency_stdev;
> >   	ktime_t metadata_latency_min;
> >   	ktime_t metadata_latency_max;
> >   
> 

-- 
Jeff Layton <jlayton@redhat.com>

