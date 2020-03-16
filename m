Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D467F186CF1
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Mar 2020 15:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731437AbgCPOVn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 Mar 2020 10:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731144AbgCPOVm (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 16 Mar 2020 10:21:42 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD9E3206E2;
        Mon, 16 Mar 2020 14:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584368501;
        bh=Ini9LY1U5sb7ucYDLJP9ZkdTnSFqrJ12J1RUqCI2W/8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=1BjAsDmGkGflGiAlbJmEK+uyQNHZAp7ke8GWITRqaDmj4zNEemaDMl4AJQy0hJK7V
         UyyV8EKJT2mmzIsBPOpUBkMeMNJQpiBVNqNT3NgHzyB+z5SIO8ptncX/uDICiEeFa8
         3LBiThC15bazMF3E2PJlzSsFe05BIywpkWEmefWc=
Message-ID: <b5ec20ab1fc00315603c462124501d919cecacc8.camel@kernel.org>
Subject: Re: [PATCH] ceph: add min/max latency support for
 read/write/metadata metrics
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        gfarnum@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 16 Mar 2020 10:21:39 -0400
In-Reply-To: <1583807817-5571-1-git-send-email-xiubli@redhat.com>
References: <1583807817-5571-1-git-send-email-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-03-09 at 22:36 -0400, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> These will be very useful help diagnose problems.
> 
> URL: https://tracker.ceph.com/issues/44533
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> The output will be like:
> 
> # cat /sys/kernel/debug/ceph/19e31430-fc65-4aa1-99cf-2c8eaaafd451.client4347/metrics 
> item          total       sum_lat(us)     avg_lat(us)     min_lat(us)     max_lat(us)
> -------------------------------------------------------------------------------------
> read          27          297000          11000           2000            27000
> write         16          3860000         241250          175000          263000
> metadata      3           30000           10000           2000            16000
> 
> item          total           miss            hit
> -------------------------------------------------
> d_lease       2               0               1
> caps          2               0               3078
> 
> 
> 
>  fs/ceph/debugfs.c    | 27 ++++++++++++++++++++------
>  fs/ceph/mds_client.c | 12 ++++++++++++
>  fs/ceph/metric.h     | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 86 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
> index faba142..9f0d050 100644
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
> @@ -13,12 +17,21 @@ struct ceph_client_metric {
>  
>  	struct percpu_counter total_reads;
>  	struct percpu_counter read_latency_sum;
> +	spinlock_t read_latency_lock;
> +	atomic64_t read_latency_min;
> +	atomic64_t read_latency_max;
>  
>  	struct percpu_counter total_writes;
>  	struct percpu_counter write_latency_sum;
> +	spinlock_t write_latency_lock;
> +	atomic64_t write_latency_min;
> +	atomic64_t write_latency_max;
>  
>  	struct percpu_counter total_metadatas;
>  	struct percpu_counter metadata_latency_sum;
> +	spinlock_t metadata_latency_lock;
> +	atomic64_t metadata_latency_min;
> +	atomic64_t metadata_latency_max;
>  };
>  
>  static inline void ceph_update_cap_hit(struct ceph_client_metric *m)
> @@ -36,11 +49,24 @@ static inline void ceph_update_read_latency(struct ceph_client_metric *m,
>  					    unsigned long r_end,
>  					    int rc)
>  {
> +	unsigned long lat = r_end - r_start;
> +
>  	if (rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT)
>  		return;
>  
>  	percpu_counter_inc(&m->total_reads);
> -	percpu_counter_add(&m->read_latency_sum, r_end - r_start);
> +	percpu_counter_add(&m->read_latency_sum, lat);
> +
> +	if (lat >= atomic64_read(&m->read_latency_min) &&
> +	    lat <= atomic64_read(&m->read_latency_max))
> +		return;
> +
> +	spin_lock(&m->read_latency_lock);
> +	if (lat < atomic64_read(&m->read_latency_min))
> +		atomic64_set(&m->read_latency_min, lat);
> +	if (lat > atomic64_read(&m->read_latency_max))
> +		atomic64_set(&m->read_latency_max, lat);
> +	spin_unlock(&m->read_latency_lock);
>  }
>  

Looks reasonable overall. I do sort of wonder if we really need
spinlocks for these though. Might it be more efficient to use cmpxchg
instead? i.e.:

cur = atomic64_read(&m->read_latency_min);
do {
	old = cur;
	if (likely(lat >= old))
		break;
} while ((cur = atomic_long_cmpxchg(&m->read_latency_min, old, lat)) != old);

...another idea might be to use a seqlock and non-atomic vars.

Mostly this shouldn't matter much though as we'll almost always be
hitting the non-locking fastpath. I'll plan to merge this as-is unless
you want to rework it.
-- 
Jeff Layton <jlayton@kernel.org>

