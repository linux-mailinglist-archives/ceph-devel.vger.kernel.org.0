Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACAB343E11C
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Oct 2021 14:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhJ1MoW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Oct 2021 08:44:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229998AbhJ1MoV (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 08:44:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18E906044F;
        Thu, 28 Oct 2021 12:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635424914;
        bh=j+3Hl5Yncodys7QW1W4Pgo8VytZXtM4jxxadKiJ7/44=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=A84Jtr7b+AKSV+CERftvAJif9dX18wknU+LK0u3Q7j9hq/TFzjb/X2Z6thdfuU9OW
         Ci5R4ToI8Y4rbXgAlOkv1CgNKwHw/2WoxznzTf4srViB/JrU0Z+TaN1Vgw4YMIA+Jk
         4gMiHm0auRD451326YSI57ijpIo9gitg3UOYA0wwmiirygAtxIZHfNLjK7Bzlv+sK/
         YBdDmH1Zweke6kb4kV65IE7XaBsJDnY1/rbiFhSkMMWZNO1WLfzP2Jy6FQYm8i45Zn
         HDmkIvdPcFm00WtqXXj3D73Xdu5Daq7IrOcOBYnPJ8rpBbfusQmAuwHXaqJRKxWvey
         66AnKzpippmNA==
Message-ID: <06ef4f08edebf8b0a1a8660adfc46597d0d028b7.camel@kernel.org>
Subject: Re: [RFC PATCH v3] ceph: ceph: add remote object copies to fs
 client metrics
From:   Jeff Layton <jlayton@kernel.org>
To:     =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 28 Oct 2021 08:41:52 -0400
In-Reply-To: <20211028114826.27192-1-lhenriques@suse.de>
References: <20211028114826.27192-1-lhenriques@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-10-28 at 12:48 +0100, Luís Henriques wrote:
> This patch adds latency and size metrics for remote object copies
> operations ("copyfrom").  For now, these metrics will be available on the
> client only, they won't be sent to the MDS.
> 
> Cc: Patrick Donnelly <pdonnell@redhat.com>
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
> This patch is still an RFC because it is... ugly.  Although it now
> provides nice values (latency and size) using the metrics infrastructure,
> it actually needs to extend the ceph_osdc_copy_from() function to add 2
> extra args!  That's because we need to get the timestamps stored in
> ceph_osd_request, which is handled within that function.
> 
> The alternative is to ignore those timestamps and collect new ones in
> ceph_do_objects_copy():
> 
> 	start_req = ktime_get();
> 	ceph_osdc_copy_from(...);
> 	end_req = ktime_get();
> 
> These would be more coarse-grained, of course.  Any other suggestions?
> 

Not really. It is definitely ugly, I'll grant you that though...

The cleaner method might be to just inline ceph_osdc_copy_from in
ceph_do_objects_copy so that you deal with the req in there.

> Cheers,
> --
> Luís
> 
>  fs/ceph/debugfs.c               | 19 ++++++++++++++++++
>  fs/ceph/file.c                  |  7 ++++++-
>  fs/ceph/metric.c                | 35 +++++++++++++++++++++++++++++++++
>  fs/ceph/metric.h                | 14 +++++++++++++
>  include/linux/ceph/osd_client.h |  3 ++-
>  net/ceph/osd_client.c           |  8 ++++++--
>  6 files changed, 82 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 55426514491b..b657170d6bc3 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -203,6 +203,16 @@ static int metrics_latency_show(struct seq_file *s, void *p)
>  	spin_unlock(&m->metadata_metric_lock);
>  	CEPH_LAT_METRIC_SHOW("metadata", total, avg, min, max, sq);
>  
> +	spin_lock(&m->copyfrom_metric_lock);
> +	total = m->total_copyfrom;
> +	sum = m->copyfrom_latency_sum;
> +	avg = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
> +	min = m->copyfrom_latency_min;
> +	max = m->copyfrom_latency_max;
> +	sq = m->copyfrom_latency_sq_sum;
> +	spin_unlock(&m->copyfrom_metric_lock);
> +	CEPH_LAT_METRIC_SHOW("copyfrom", total, avg, min, max, sq);
> +
>  	return 0;
>  }
>  
> @@ -234,6 +244,15 @@ static int metrics_size_show(struct seq_file *s, void *p)
>  	spin_unlock(&m->write_metric_lock);
>  	CEPH_SZ_METRIC_SHOW("write", total, avg_sz, min_sz, max_sz, sum_sz);
>  
> +	spin_lock(&m->copyfrom_metric_lock);
> +	total = m->total_copyfrom;
> +	sum_sz = m->copyfrom_size_sum;
> +	avg_sz = total > 0 ? DIV64_U64_ROUND_CLOSEST(sum_sz, total) : 0;
> +	min_sz = m->copyfrom_size_min;
> +	max_sz = m->copyfrom_size_max;
> +	spin_unlock(&m->copyfrom_metric_lock);
> +	CEPH_SZ_METRIC_SHOW("copyfrom", total, avg_sz, min_sz, max_sz, sum_sz);
> +
>  	return 0;
>  }
>  
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index e61018d9764e..d1139bbcd58d 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -2208,6 +2208,7 @@ static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off
>  	struct ceph_object_locator src_oloc, dst_oloc;
>  	struct ceph_object_id src_oid, dst_oid;
>  	size_t bytes = 0;
> +	ktime_t start_req, end_req;
>  	u64 src_objnum, src_objoff, dst_objnum, dst_objoff;
>  	u32 src_objlen, dst_objlen;
>  	u32 object_size = src_ci->i_layout.object_size;
> @@ -2242,7 +2243,11 @@ static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off
>  					  CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
>  					  dst_ci->i_truncate_seq,
>  					  dst_ci->i_truncate_size,
> -					  CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
> +					  CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ,
> +					  &start_req, &end_req);
> +		ceph_update_copyfrom_metrics(&fsc->mdsc->metric,
> +					     start_req, end_req,
> +					     object_size, ret);
>  		if (ret) {
>  			if (ret == -EOPNOTSUPP) {
>  				fsc->have_copy_from2 = false;
> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> index 04d5df29bbbf..94e7f8fd34d6 100644
> --- a/fs/ceph/metric.c
> +++ b/fs/ceph/metric.c
> @@ -270,6 +270,16 @@ int ceph_metric_init(struct ceph_client_metric *m)
>  	m->total_metadatas = 0;
>  	m->metadata_latency_sum = 0;
>  
> +	spin_lock_init(&m->copyfrom_metric_lock);
> +	m->copyfrom_latency_sq_sum = 0;
> +	m->copyfrom_latency_min = KTIME_MAX;
> +	m->copyfrom_latency_max = 0;
> +	m->total_copyfrom = 0;
> +	m->copyfrom_latency_sum = 0;
> +	m->copyfrom_size_min = U64_MAX;
> +	m->copyfrom_size_max = 0;
> +	m->copyfrom_size_sum = 0;
> +
>  	atomic64_set(&m->opened_files, 0);
>  	ret = percpu_counter_init(&m->opened_inodes, 0, GFP_KERNEL);
>  	if (ret)
> @@ -408,3 +418,28 @@ void ceph_update_metadata_metrics(struct ceph_client_metric *m,
>  		       &m->metadata_latency_sq_sum, lat);
>  	spin_unlock(&m->metadata_metric_lock);
>  }
> +
> +void ceph_update_copyfrom_metrics(struct ceph_client_metric *m,
> +				  ktime_t r_start, ktime_t r_end,
> +				  unsigned int size, int rc)
> +{
> +	ktime_t lat = ktime_sub(r_end, r_start);
> +	ktime_t total;
> +
> +	if (unlikely(rc && rc != -ETIMEDOUT))
> +		return;
> +
> +	spin_lock(&m->copyfrom_metric_lock);
> +	total = ++m->total_copyfrom;
> +	m->copyfrom_size_sum += size;
> +	m->copyfrom_latency_sum += lat;
> +	METRIC_UPDATE_MIN_MAX(m->copyfrom_size_min,
> +			      m->copyfrom_size_max,
> +			      size);
> +	METRIC_UPDATE_MIN_MAX(m->copyfrom_latency_min,
> +			      m->copyfrom_latency_max,
> +			      lat);
> +	__update_stdev(total, m->copyfrom_latency_sum,
> +		       &m->copyfrom_latency_sq_sum, lat);
> +	spin_unlock(&m->copyfrom_metric_lock);
> +}
> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
> index 0133955a3c6a..c95517c7c77b 100644
> --- a/fs/ceph/metric.h
> +++ b/fs/ceph/metric.h
> @@ -162,6 +162,16 @@ struct ceph_client_metric {
>  	ktime_t metadata_latency_min;
>  	ktime_t metadata_latency_max;
>  
> +	spinlock_t copyfrom_metric_lock;
> +	u64 total_copyfrom;
> +	u64 copyfrom_size_sum;
> +	u64 copyfrom_size_min;
> +	u64 copyfrom_size_max;
> +	ktime_t copyfrom_latency_sum;
> +	ktime_t copyfrom_latency_sq_sum;
> +	ktime_t copyfrom_latency_min;
> +	ktime_t copyfrom_latency_max;
> +

Not a comment about your patch, specifically, but we have a lot of
copy/pasted code to deal with different parts of ceph_client_metric.

It might be nice to eventually turn each of the read/write/copy metric
blocks in this struct into an array, and collapse a lot of the other
helper functions together.

If you feel like doing that cleanup, I'd be happy to review. Otherwise,
I'll plan to look at it in the near future.

>  	/* The total number of directories and files that are opened */
>  	atomic64_t opened_files;
>  
> @@ -204,4 +214,8 @@ extern void ceph_update_write_metrics(struct ceph_client_metric *m,
>  extern void ceph_update_metadata_metrics(struct ceph_client_metric *m,
>  				         ktime_t r_start, ktime_t r_end,
>  					 int rc);
> +extern void ceph_update_copyfrom_metrics(struct ceph_client_metric *m,
> +					 ktime_t r_start, ktime_t r_end,
> +					 unsigned int size, int rc);
> +
>  #endif /* _FS_CEPH_MDS_METRIC_H */
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index 83fa08a06507..d282c7531a3f 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -524,7 +524,8 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
>  			struct ceph_object_locator *dst_oloc,
>  			u32 dst_fadvise_flags,
>  			u32 truncate_seq, u64 truncate_size,
> -			u8 copy_from_flags);
> +			u8 copy_from_flags,
> +			ktime_t *start_req, ktime_t *end_req);
>  
>  /* watch/notify */
>  struct ceph_osd_linger_request *
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index ff8624a7c964..74ffe6240b07 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5356,7 +5356,8 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
>  			struct ceph_object_locator *dst_oloc,
>  			u32 dst_fadvise_flags,
>  			u32 truncate_seq, u64 truncate_size,
> -			u8 copy_from_flags)
> +			u8 copy_from_flags,
> +			ktime_t *start_req, ktime_t *end_req)
>  {
>  	struct ceph_osd_request *req;
>  	int ret;
> @@ -5364,6 +5365,8 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
>  	req = ceph_osdc_alloc_request(osdc, NULL, 1, false, GFP_KERNEL);
>  	if (!req)
>  		return -ENOMEM;
> +	*start_req = 0;
> +	*end_req = 0;
>  
>  	req->r_flags = CEPH_OSD_FLAG_WRITE;
>  
> @@ -5383,7 +5386,8 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
>  
>  	ceph_osdc_start_request(osdc, req, false);
>  	ret = ceph_osdc_wait_request(osdc, req);
> -
> +	*start_req = req->r_start_latency;
> +	*end_req = req->r_end_latency;
>  out:
>  	ceph_osdc_put_request(req);
>  	return ret;

-- 
Jeff Layton <jlayton@kernel.org>

