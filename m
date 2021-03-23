Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4DA345E3F
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Mar 2021 13:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhCWMfN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 23 Mar 2021 08:35:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230450AbhCWMel (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 23 Mar 2021 08:34:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3A8161585;
        Tue, 23 Mar 2021 12:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616502881;
        bh=nti3w5m3Vs0YRnMjIzrm2k/ZsgssRKJSzSoVFlXcY7E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=heABrQ9iAaGtA4X6TcE/oB5RbskI5bwWwg5lITvrJ2DqUku2I1rhlRMavIaYNAbdC
         mknF55O0NlMTcxZmIaxyEyDong+A49QplHesFT27UEhywGJzemskyz3ZjJ9DMwXaTL
         Tu57N1jpGK/z9FPs2FT58c5ekQpWbVI71kjOzG4Dg+dwxqqB+CERt0htpOE5+v7eHQ
         EepUOtoKgS0wYXxAPQfNzYaFYe9iDFxXpO35gjZKZiammGAxSc09u8UkSJXKgIMQ1+
         SqEPb1vxCn64FztQrA3hN50AVSWSDdhYNoV0sltSNY+1EnqX6WVTnSYsu8JnVmHcO6
         sapM4apPSpMHg==
Message-ID: <c836da61eaba7650538cdfe2b37c8c0214d1312a.camel@kernel.org>
Subject: Re: [PATCH 2/4] ceph: update the __update_latency helper
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 23 Mar 2021 08:34:39 -0400
In-Reply-To: <20210322122852.322927-3-xiubli@redhat.com>
References: <20210322122852.322927-1-xiubli@redhat.com>
         <20210322122852.322927-3-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-03-22 at 20:28 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Let the __update_latency() helper choose the correcsponding members
> according to the metric_type.
> 
> URL: https://tracker.ceph.com/issues/49913
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/metric.c | 58 +++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 42 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> index 75d309f2fb0c..d5560ff99a9d 100644
> --- a/fs/ceph/metric.c
> +++ b/fs/ceph/metric.c
> @@ -249,19 +249,51 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
>  		ceph_put_mds_session(m->session);
>  }
>  
> 
> 
> 
> 
> 
> 
> 
> -static inline void __update_latency(ktime_t *totalp, ktime_t *lsump,
> -				    ktime_t *min, ktime_t *max,
> -				    ktime_t *sq_sump, ktime_t lat)
> +typedef enum {
> +	CEPH_METRIC_READ,
> +	CEPH_METRIC_WRITE,
> +	CEPH_METRIC_METADATA,
> +} metric_type;
> +
> +static inline void __update_latency(struct ceph_client_metric *m,
> +				    metric_type type, ktime_t lat)
>  {
> +	ktime_t *totalp, *minp, *maxp, *lsump, *sq_sump;
>  	ktime_t total, avg, sq, lsum;
>  
> 
> 
> 
> 
> 
> 
> 
> +	switch (type) {
> +	case CEPH_METRIC_READ:
> +		totalp = &m->total_reads;
> +		lsump = &m->read_latency_sum;
> +		minp = &m->read_latency_min;
> +		maxp = &m->read_latency_max;
> +		sq_sump = &m->read_latency_sq_sum;
> +		break;
> +	case CEPH_METRIC_WRITE:
> +		totalp = &m->total_writes;
> +		lsump = &m->write_latency_sum;
> +		minp = &m->write_latency_min;
> +		maxp = &m->write_latency_max;
> +		sq_sump = &m->write_latency_sq_sum;
> +		break;
> +	case CEPH_METRIC_METADATA:
> +		totalp = &m->total_metadatas;
> +		lsump = &m->metadata_latency_sum;
> +		minp = &m->metadata_latency_min;
> +		maxp = &m->metadata_latency_max;
> +		sq_sump = &m->metadata_latency_sq_sum;
> +		break;
> +	default:
> +		return;
> +	}
> +
>  	total = ++(*totalp);

Why are you adding one to *totalp above? Is that to avoid it being 0? 

>  	lsum = (*lsump += lat);
>  
> 

^^^
Instead of doing all of the above with pointers, why not just add to
total and lsum directly inside the switch statement? This seems like a
lot of pointless indirection.

> 
> 
> 
> 
> 
> -	if (unlikely(lat < *min))
> -		*min = lat;
> -	if (unlikely(lat > *max))
> -		*max = lat;
> +	if (unlikely(lat < *minp))
> +		*minp = lat;
> +	if (unlikely(lat > *maxp))
> +		*maxp = lat;
>  
> 
> 
> 
>  	if (unlikely(total == 1))
>  		return;
> @@ -284,9 +316,7 @@ void ceph_update_read_metrics(struct ceph_client_metric *m,
>  		return;
>  
> 
> 
> 
>  	spin_lock(&m->read_metric_lock);
> -	__update_latency(&m->total_reads, &m->read_latency_sum,
> -			 &m->read_latency_min, &m->read_latency_max,
> -			 &m->read_latency_sq_sum, lat);
> +	__update_latency(m, CEPH_METRIC_READ, lat);
>  	spin_unlock(&m->read_metric_lock);
>  }
>  
> 
> 
> 
> @@ -300,9 +330,7 @@ void ceph_update_write_metrics(struct ceph_client_metric *m,
>  		return;
>  
> 
> 
> 
>  	spin_lock(&m->write_metric_lock);
> -	__update_latency(&m->total_writes, &m->write_latency_sum,
> -			 &m->write_latency_min, &m->write_latency_max,
> -			 &m->write_latency_sq_sum, lat);
> +	__update_latency(m, CEPH_METRIC_WRITE, lat);
>  	spin_unlock(&m->write_metric_lock);
>  }
>  
> 
> 
> 
> @@ -316,8 +344,6 @@ void ceph_update_metadata_metrics(struct ceph_client_metric *m,
>  		return;
>  
> 
> 
> 
>  	spin_lock(&m->metadata_metric_lock);
> -	__update_latency(&m->total_metadatas, &m->metadata_latency_sum,
> -			 &m->metadata_latency_min, &m->metadata_latency_max,
> -			 &m->metadata_latency_sq_sum, lat);
> +	__update_latency(m, CEPH_METRIC_METADATA, lat);
>  	spin_unlock(&m->metadata_metric_lock);
>  }

-- 
Jeff Layton <jlayton@kernel.org>

