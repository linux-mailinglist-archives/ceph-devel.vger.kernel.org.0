Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF66636CB37
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Apr 2021 20:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238526AbhD0Sj1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Apr 2021 14:39:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236773AbhD0Sj0 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 14:39:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1CAE61029;
        Tue, 27 Apr 2021 18:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619548723;
        bh=gyiltulwvT9sAYisKAavDovMKnDyGFfPbaHbq9fqh0o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oLbGv6j4pK8oR2PacsBukwZ/cqGIcXfVl0ab0+nr00zqLtvfdOnZcD4QzKhIulbQq
         69G6Qzwdg5Qy12mSEJRhyIFJAIiWGl7dysZdUJ0rGoN4XCp8OvXT9Lz67g3lWYOVCC
         mfRbHCQHn7UMxZbVl7kxPfUlIGMEy3IdsNn0IMxau6VNVqEe8+LaPB4JZrqtTcXwkL
         sCBRDYostsBNM15qH3eGYi4lYGexAn40NStOFTe1awCz2feY01YuZerJBXiNv/w9cF
         jHwHRpfe4cCFVbBDiGHZxBmy3axMSulpTeLEm8Y6R7oqYGwB9ceiL2VyxEosxSpN2C
         YshqSjTXZ5olg==
Message-ID: <aff17365129ead70f109d96adcf24484d1b12c46.camel@kernel.org>
Subject: Re: [PATCH v2 1/2] ceph: update the __update_latency helper
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 27 Apr 2021 14:38:41 -0400
In-Reply-To: <20210325032826.1725667-2-xiubli@redhat.com>
References: <20210325032826.1725667-1-xiubli@redhat.com>
         <20210325032826.1725667-2-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-03-25 at 11:28 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Let the __update_latency() helper choose the correcsponding members
> according to the metric_type.
> 
> URL: https://tracker.ceph.com/issues/49913
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/metric.c | 73 ++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 52 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> index 28b6b42ad677..f3e68db08760 100644
> --- a/fs/ceph/metric.c
> +++ b/fs/ceph/metric.c
> @@ -285,19 +285,56 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
>  		ceph_put_mds_session(m->session);
>  }
>  
> -static inline void __update_latency(ktime_t *totalp, ktime_t *lsump,
> -				    ktime_t *min, ktime_t *max,
> -				    ktime_t *sq_sump, ktime_t lat)
> -{
> -	ktime_t total, avg, sq, lsum;
> -
> -	total = ++(*totalp);
> -	lsum = (*lsump += lat);
> +typedef enum {
> +	CEPH_METRIC_READ,
> +	CEPH_METRIC_WRITE,
> +	CEPH_METRIC_METADATA,
> +} metric_type;
> +
> +#define METRIC_UPDATE_MIN_MAX(min, max, new)	\
> +{						\
> +	if (unlikely(new < min))		\
> +		min = new;			\
> +	if (unlikely(new > max))		\
> +		max = new;			\
> +}
>  
> -	if (unlikely(lat < *min))
> -		*min = lat;
> -	if (unlikely(lat > *max))
> -		*max = lat;
> +static inline void __update_latency(struct ceph_client_metric *m,
> +				    metric_type type, ktime_t lat)
> +{
> +	ktime_t total, avg, sq, lsum, *sq_sump;
> +
> +	switch (type) {
> +	case CEPH_METRIC_READ:
> +		total = ++m->total_reads;
> +		m->read_latency_sum += lat;
> +		lsum = m->read_latency_sum;
> +		METRIC_UPDATE_MIN_MAX(m->read_latency_min,
> +				      m->read_latency_max,
> +				      lat);
> +		sq_sump = &m->read_latency_sq_sum;
> +		break;
> +	case CEPH_METRIC_WRITE:
> +		total = ++m->total_writes;
> +		m->write_latency_sum += lat;
> +		lsum = m->write_latency_sum;
> +		METRIC_UPDATE_MIN_MAX(m->write_latency_min,
> +				      m->write_latency_max,
> +				      lat);
> +		sq_sump = &m->write_latency_sq_sum;
> +		break;
> +	case CEPH_METRIC_METADATA:
> +		total = ++m->total_metadatas;
> +		m->metadata_latency_sum += lat;
> +		lsum = m->metadata_latency_sum;
> +		METRIC_UPDATE_MIN_MAX(m->metadata_latency_min,
> +				      m->metadata_latency_max,
> +				      lat);
> +		sq_sump = &m->metadata_latency_sq_sum;
> +		break;
> +	default:
> +		return;
> +	}
>  

I'm not a fan of the above function. __update_latency gets called with
each of those values only once.

It seems like it'd be better to just open-code the above sections in the
respective ceph_update_*_metrics functions, and then have a helper
function for the part of __update_latency below this point. With that,
you wouldn't need the enum either.


>  	if (unlikely(total == 1))
>  		return;
> @@ -320,9 +357,7 @@ void ceph_update_read_metrics(struct ceph_client_metric *m,
>  		return;
>  
>  	spin_lock(&m->read_metric_lock);
> -	__update_latency(&m->total_reads, &m->read_latency_sum,
> -			 &m->read_latency_min, &m->read_latency_max,
> -			 &m->read_latency_sq_sum, lat);
> +	__update_latency(m, CEPH_METRIC_READ, lat);
>  	spin_unlock(&m->read_metric_lock);
>  }
>  
> @@ -336,9 +371,7 @@ void ceph_update_write_metrics(struct ceph_client_metric *m,
>  		return;
>  
>  	spin_lock(&m->write_metric_lock);
> -	__update_latency(&m->total_writes, &m->write_latency_sum,
> -			 &m->write_latency_min, &m->write_latency_max,
> -			 &m->write_latency_sq_sum, lat);
> +	__update_latency(m, CEPH_METRIC_WRITE, lat);
>  	spin_unlock(&m->write_metric_lock);
>  }
>  
> @@ -352,8 +385,6 @@ void ceph_update_metadata_metrics(struct ceph_client_metric *m,
>  		return;
>  
>  	spin_lock(&m->metadata_metric_lock);
> -	__update_latency(&m->total_metadatas, &m->metadata_latency_sum,
> -			 &m->metadata_latency_min, &m->metadata_latency_max,
> -			 &m->metadata_latency_sq_sum, lat);
> +	__update_latency(m, CEPH_METRIC_METADATA, lat);
>  	spin_unlock(&m->metadata_metric_lock);
>  }

-- 
Jeff Layton <jlayton@kernel.org>

