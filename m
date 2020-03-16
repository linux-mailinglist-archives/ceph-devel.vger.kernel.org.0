Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDA3187118
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Mar 2020 18:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731625AbgCPRZx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 Mar 2020 13:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731136AbgCPRZx (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 16 Mar 2020 13:25:53 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FFC020409;
        Mon, 16 Mar 2020 17:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584379551;
        bh=pmqrxwLq1eF/yABUKu90S6Xu5vsXqUiI3H/1Ll+Qq78=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FLLbkrBusVq5JSEgSWlLdel1O6r+X9hH0bYyImGUe3rru/CwoKIOXsGNZtONMhnVt
         Qam33uWXYq0pfhSKvFnR+1JJJDF9D1xt1wUHeYR1kjnEpn1gWzlgdXQ4Em0X++Vuo6
         oVUqtPCIlU4RmSpCQOinUI7lSyxpdmFcYMzrzcbg=
Message-ID: <d3a9d0d4b074d4b36e5488af6d5e9ecd58ac8d46.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: add min/max latency support for
 read/write/metadata metrics
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, gfarnum@redhat.com,
        zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 16 Mar 2020 13:25:50 -0400
In-Reply-To: <1584373971-21654-1-git-send-email-xiubli@redhat.com>
References: <1584373971-21654-1-git-send-email-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-03-16 at 11:52 -0400, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> These will be very useful help diagnose problems.
> 
> URL: https://tracker.ceph.com/issues/44533
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> Changed in V2:
> - switch spin lock to cmpxchg
> 
>  fs/ceph/debugfs.c    | 26 ++++++++++++++++----
>  fs/ceph/mds_client.c |  9 +++++++
>  fs/ceph/metric.h     | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 98 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 60f3e307..bcf7215 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -130,27 +130,43 @@ static int metric_show(struct seq_file *s, void *p)
>  	struct ceph_mds_client *mdsc = fsc->mdsc;
>  	int i, nr_caps = 0;
>  	s64 total, sum, avg = 0;
> +	unsigned long min, max;
>  
> -	seq_printf(s, "item          total       sum_lat(us)     avg_lat(us)\n");
> -	seq_printf(s, "-----------------------------------------------------\n");
> +	seq_printf(s, "item          total       sum_lat(us)     avg_lat(us)     min_lat(us)     max_lat(us)\n");
> +	seq_printf(s, "-------------------------------------------------------------------------------------\n");
>  
>  	total = percpu_counter_sum(&mdsc->metric.total_reads);
>  	sum = percpu_counter_sum(&mdsc->metric.read_latency_sum);
>  	sum = jiffies_to_usecs(sum);
>  	avg = total ? sum / total : 0;
> -	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "read", total, sum, avg);
> +	min = atomic_long_read(&mdsc->metric.read_latency_min);
> +	min = jiffies_to_usecs(min == ULONG_MAX ? 0 : min);
> +	max = atomic_long_read(&mdsc->metric.read_latency_max);
> +	max = jiffies_to_usecs(max);
> +	seq_printf(s, "%-14s%-12lld%-16lld%-16lld%-16ld%ld\n", "read",
> +		   total, sum, avg, min, max);
>  
>  	total = percpu_counter_sum(&mdsc->metric.total_writes);
>  	sum = percpu_counter_sum(&mdsc->metric.write_latency_sum);
>  	sum = jiffies_to_usecs(sum);
>  	avg = total ? sum / total : 0;
> -	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "write", total, sum, avg);
> +	min = atomic_long_read(&mdsc->metric.write_latency_min);
> +	min = jiffies_to_usecs(min == ULONG_MAX ? 0 : min);
> +	max = atomic_long_read(&mdsc->metric.write_latency_max);
> +	max = jiffies_to_usecs(max);
> +	seq_printf(s, "%-14s%-12lld%-16lld%-16lld%-16ld%ld\n", "write",
> +		   total, sum, avg, min, max);
>  
>  	total = percpu_counter_sum(&mdsc->metric.total_metadatas);
>  	sum = percpu_counter_sum(&mdsc->metric.metadata_latency_sum);
>  	sum = jiffies_to_usecs(sum);
>  	avg = total ? sum / total : 0;
> -	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "metadata", total, sum, avg);
> +	min = atomic_long_read(&mdsc->metric.metadata_latency_min);
> +	min = jiffies_to_usecs(min == ULONG_MAX ? 0 : min);
> +	max = atomic_long_read(&mdsc->metric.metadata_latency_max);
> +	max = jiffies_to_usecs(max);
> +	seq_printf(s, "%-14s%-12lld%-16lld%-16lld%-16ld%ld\n", "metadata",
> +		   total, sum, avg, min, max);
>  
>  	seq_printf(s, "\n");
>  	seq_printf(s, "item          total           miss            hit\n");
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 5c03ed3..7844aa6 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4358,6 +4358,9 @@ static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
>  	if (ret)
>  		goto err_read_latency_sum;
>  
> +	atomic_long_set(&metric->read_latency_min, ULONG_MAX);
> +	atomic_long_set(&metric->read_latency_max, 0);
> +
>  	ret = percpu_counter_init(&metric->total_writes, 0, GFP_KERNEL);
>  	if (ret)
>  		goto err_total_writes;
> @@ -4366,6 +4369,9 @@ static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
>  	if (ret)
>  		goto err_write_latency_sum;
>  
> +	atomic_long_set(&metric->write_latency_min, ULONG_MAX);
> +	atomic_long_set(&metric->write_latency_max, 0);
> +
>  	ret = percpu_counter_init(&metric->total_metadatas, 0, GFP_KERNEL);
>  	if (ret)
>  		goto err_total_metadatas;
> @@ -4374,6 +4380,9 @@ static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
>  	if (ret)
>  		goto err_metadata_latency_sum;
>  
> +	atomic_long_set(&metric->metadata_latency_min, ULONG_MAX);
> +	atomic_long_set(&metric->metadata_latency_max, 0);
> +
>  	return 0;
>  
>  err_metadata_latency_sum:
> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
> index faba142..a399201 100644
> --- a/fs/ceph/metric.h
> +++ b/fs/ceph/metric.h
> @@ -2,6 +2,10 @@
>  #ifndef _FS_CEPH_MDS_METRIC_H
>  #define _FS_CEPH_MDS_METRIC_H
>  
> +#include <linux/atomic.h>
> +#include <linux/percpu.h>
> +#include <linux/spinlock.h>
> +
>  /* This is the global metrics */
>  struct ceph_client_metric {
>  	atomic64_t            total_dentries;
> @@ -13,12 +17,18 @@ struct ceph_client_metric {
>  
>  	struct percpu_counter total_reads;
>  	struct percpu_counter read_latency_sum;
> +	atomic_long_t read_latency_min;
> +	atomic_long_t read_latency_max;
>  
>  	struct percpu_counter total_writes;
>  	struct percpu_counter write_latency_sum;
> +	atomic_long_t write_latency_min;
> +	atomic_long_t write_latency_max;
>  
>  	struct percpu_counter total_metadatas;
>  	struct percpu_counter metadata_latency_sum;
> +	atomic_long_t metadata_latency_min;
> +	atomic_long_t metadata_latency_max;
>  };
>  
>  static inline void ceph_update_cap_hit(struct ceph_client_metric *m)
> @@ -36,11 +46,30 @@ static inline void ceph_update_read_latency(struct ceph_client_metric *m,
>  					    unsigned long r_end,
>  					    int rc)
>  {
> +	unsigned long lat = r_end - r_start;
> +	unsigned long cur, old;
> +
>  	if (rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT)
>  		return;
>  
>  	percpu_counter_inc(&m->total_reads);
> -	percpu_counter_add(&m->read_latency_sum, r_end - r_start);
> +	percpu_counter_add(&m->read_latency_sum, lat);
> +
> +	cur = atomic_long_read(&m->read_latency_min);
> +	do {
> +		old = cur;
> +		if (likely(lat > old))
> +			break;
> +		cur = atomic_long_cmpxchg(&m->read_latency_min, old, lat);
> +	} while (cur != old);
> +
> +	cur = atomic_long_read(&m->read_latency_max);
> +	do {
> +		old = cur;
> +		if (likely(lat < old))

This should probably be (lat <= old). After all, there's no need to do
the cmpxchg if nothing would change anyway.

All these loops look pretty similar too. Maybe you could add a pair of
helper functions for this (one for min and one for max) ?

> +			break;
> +		cur = atomic_long_cmpxchg(&m->read_latency_max, old, lat);
> +	} while (cur != old);
>  }
>  
>  static inline void ceph_update_write_latency(struct ceph_client_metric *m,
> @@ -48,11 +77,30 @@ static inline void ceph_update_write_latency(struct ceph_client_metric *m,
>  					     unsigned long r_end,
>  					     int rc)
>  {
> +	unsigned long lat = r_end - r_start;
> +	unsigned long cur, old;
> +
>  	if (rc && rc != -ETIMEDOUT)
>  		return;
>  
>  	percpu_counter_inc(&m->total_writes);
>  	percpu_counter_add(&m->write_latency_sum, r_end - r_start);
> +
> +	cur = atomic_long_read(&m->write_latency_min);
> +	do {
> +		old = cur;
> +		if (likely(lat > old))
> +			break;
> +		cur = atomic_long_cmpxchg(&m->write_latency_min, old, lat);
> +	} while (cur != old);
> +
> +	cur = atomic_long_read(&m->write_latency_max);
> +	do {
> +		old = cur;
> +		if (likely(lat < old))
> +			break;
> +		cur = atomic_long_cmpxchg(&m->write_latency_max, old, lat);
> +	} while (cur != old);
>  }
>  
>  static inline void ceph_update_metadata_latency(struct ceph_client_metric *m,
> @@ -60,10 +108,29 @@ static inline void ceph_update_metadata_latency(struct ceph_client_metric *m,
>  						unsigned long r_end,
>  						int rc)
>  {
> +	unsigned long lat = r_end - r_start;
> +	unsigned long cur, old;
> +
>  	if (rc && rc != -ENOENT)
>  		return;
>  
>  	percpu_counter_inc(&m->total_metadatas);
>  	percpu_counter_add(&m->metadata_latency_sum, r_end - r_start);
> +
> +	cur = atomic_long_read(&m->metadata_latency_min);
> +	do {
> +		old = cur;
> +		if (likely(lat > old))
> +			break;
> +		cur = atomic_long_cmpxchg(&m->metadata_latency_min, old, lat);
> +	} while (cur != old);
> +
> +	cur = atomic_long_read(&m->metadata_latency_max);
> +	do {
> +		old = cur;
> +		if (likely(lat < old))
> +			break;
> +		cur = atomic_long_cmpxchg(&m->metadata_latency_max, old, lat);
> +	} while (cur != old);
>  }
>  #endif /* _FS_CEPH_MDS_METRIC_H */

-- 
Jeff Layton <jlayton@kernel.org>

