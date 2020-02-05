Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4262115396F
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Feb 2020 21:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgBEUPg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Feb 2020 15:15:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:48582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgBEUPg (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 5 Feb 2020 15:15:36 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64A4C20720;
        Wed,  5 Feb 2020 20:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580933735;
        bh=icxEkAvNlQWXQXJ+H42Xpc9QbEvgNa4juF4RcNJTuPA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HK3ft2e7SevP0j5BcY0F0Ykw2lhJst2ZC/u6IpoVpdb636PxueFuT99h1Auoj3V6+
         32d2Q0IiBFO5OHiMdSv90a1meTlR3RoYcmMpab3EqOJwXduwVck4wnJ5+fb1rRgu/k
         6bLyV9vZ1WRpn0GMyVUymfnKeo38xBzXDQxoqe5Y=
Message-ID: <e0bbe210d52c69458828f8245f1252434713f4a9.camel@kernel.org>
Subject: Re: [PATCH resend v5 05/11] ceph: add global read latency metric
 support
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 05 Feb 2020 15:15:33 -0500
In-Reply-To: <20200129082715.5285-6-xiubli@redhat.com>
References: <20200129082715.5285-1-xiubli@redhat.com>
         <20200129082715.5285-6-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-01-29 at 03:27 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> item          total       sum_lat(us)     avg_lat(us)
> -----------------------------------------------------
> read          73          3590000         49178082
> 
> URL: https://tracker.ceph.com/issues/43215
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/addr.c       |  8 ++++++++
>  fs/ceph/debugfs.c    | 11 +++++++++++
>  fs/ceph/file.c       | 15 +++++++++++++++
>  fs/ceph/mds_client.c | 29 +++++++++++++++++++++++------
>  fs/ceph/mds_client.h |  9 ++-------
>  fs/ceph/metric.h     | 30 ++++++++++++++++++++++++++++++
>  6 files changed, 89 insertions(+), 13 deletions(-)
>  create mode 100644 fs/ceph/metric.h
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 20e5ebfff389..0435a694370b 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -195,6 +195,7 @@ static int ceph_sync_readpages(struct ceph_fs_client *fsc,
>  			       int page_align)
>  {
>  	struct ceph_osd_client *osdc = &fsc->client->osdc;
> +	struct ceph_client_metric *metric = &fsc->mdsc->metric;

nit: I think you can drop this variable and just dereference the metric
field directly below where it's used. Ditto in other places where
"metric" is only used once in the function.

>  	struct ceph_osd_request *req;
>  	int rc = 0;
>  
> @@ -218,6 +219,8 @@ static int ceph_sync_readpages(struct ceph_fs_client *fsc,
>  	if (!rc)
>  		rc = ceph_osdc_wait_request(osdc, req);
>  
> +	ceph_update_read_latency(metric, req, rc);
> +
>  	ceph_osdc_put_request(req);
>  	dout("readpages result %d\n", rc);
>  	return rc;
> @@ -301,6 +304,8 @@ static int ceph_readpage(struct file *filp, struct page *page)
>  static void finish_read(struct ceph_osd_request *req)
>  {
>  	struct inode *inode = req->r_inode;
> +	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> +	struct ceph_client_metric *metric = &fsc->mdsc->metric;
>  	struct ceph_osd_data *osd_data;
>  	int rc = req->r_result <= 0 ? req->r_result : 0;
>  	int bytes = req->r_result >= 0 ? req->r_result : 0;
> @@ -338,6 +343,9 @@ static void finish_read(struct ceph_osd_request *req)
>  		put_page(page);
>  		bytes -= PAGE_SIZE;
>  	}
> +
> +	ceph_update_read_latency(metric, req, rc);
> +
>  	kfree(osd_data->pages);
>  }
>  
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index c132fdb40d53..f8a32fa335ae 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -128,8 +128,19 @@ static int metric_show(struct seq_file *s, void *p)
>  {
>  	struct ceph_fs_client *fsc = s->private;
>  	struct ceph_mds_client *mdsc = fsc->mdsc;
> +	s64 total, sum, avg = 0;
>  	int i;
>  
> +	seq_printf(s, "item          total       sum_lat(us)     avg_lat(us)\n");
> +	seq_printf(s, "-----------------------------------------------------\n");
> +
> +	total = percpu_counter_sum(&mdsc->metric.total_reads);
> +	sum = percpu_counter_sum(&mdsc->metric.read_latency_sum);
> +	avg = total ? sum / total : 0;
> +	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "read",
> +		   total, sum / NSEC_PER_USEC, avg / NSEC_PER_USEC);
> +
> +	seq_printf(s, "\n");
>  	seq_printf(s, "item          total           miss            hit\n");
>  	seq_printf(s, "-------------------------------------------------\n");
>  
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index c78dfbbb7b91..69288c39229b 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -588,6 +588,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>  	struct inode *inode = file_inode(file);
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> +	struct ceph_client_metric *metric = &fsc->mdsc->metric;
>  	struct ceph_osd_client *osdc = &fsc->client->osdc;
>  	ssize_t ret;
>  	u64 off = iocb->ki_pos;
> @@ -660,6 +661,9 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>  		ret = ceph_osdc_start_request(osdc, req, false);
>  		if (!ret)
>  			ret = ceph_osdc_wait_request(osdc, req);
> +
> +		ceph_update_read_latency(metric, req, ret);
> +
>  		ceph_osdc_put_request(req);
>  
>  		i_size = i_size_read(inode);
> @@ -798,13 +802,20 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
>  	struct inode *inode = req->r_inode;
>  	struct ceph_aio_request *aio_req = req->r_priv;
>  	struct ceph_osd_data *osd_data = osd_req_op_extent_osd_data(req, 0);
> +	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> +	struct ceph_client_metric *metric = &fsc->mdsc->metric;
>  
>  	BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_BVECS);
>  	BUG_ON(!osd_data->num_bvecs);
> +	BUG_ON(!aio_req);
>  
>  	dout("ceph_aio_complete_req %p rc %d bytes %u\n",
>  	     inode, rc, osd_data->bvec_pos.iter.bi_size);
>  
> +	/* r_start_stamp == 0 means the request was not submitted */
> +	if (req->r_start_stamp && !aio_req->write)
> +		ceph_update_read_latency(metric, req, rc);
> +
>  	if (rc == -EOLDSNAPC) {
>  		struct ceph_aio_work *aio_work;
>  		BUG_ON(!aio_req->write);
> @@ -933,6 +944,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
>  	struct inode *inode = file_inode(file);
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> +	struct ceph_client_metric *metric = &fsc->mdsc->metric;
>  	struct ceph_vino vino;
>  	struct ceph_osd_request *req;
>  	struct bio_vec *bvecs;
> @@ -1049,6 +1061,9 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
>  		if (!ret)
>  			ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
>  
> +		if (!write)
> +			ceph_update_read_latency(metric, req, ret);
> +
>  		size = i_size_read(inode);
>  		if (!write) {
>  			if (ret == -ENOENT)
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 141c1c03636c..101b51f9f05d 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4182,14 +4182,29 @@ static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
>  	atomic64_set(&metric->total_dentries, 0);
>  	ret = percpu_counter_init(&metric->d_lease_hit, 0, GFP_KERNEL);
>  	if (ret)
> -		return ret;
> +		return ret;;

drop this, please ^^^

>  	ret = percpu_counter_init(&metric->d_lease_mis, 0, GFP_KERNEL);
> -	if (ret) {
> -		percpu_counter_destroy(&metric->d_lease_hit);
> -		return ret;
> -	}
> +	if (ret)
> +		goto err_dlease_mis;
>  
> -	return 0;
> +	ret = percpu_counter_init(&metric->total_reads, 0, GFP_KERNEL);
> +	if (ret)
> +		goto err_total_reads;
> +
> +	ret = percpu_counter_init(&metric->read_latency_sum, 0, GFP_KERNEL);
> +	if (ret)
> +		goto err_read_latency_sum;
> +
> +	return ret;
> +
> +err_read_latency_sum:
> +	percpu_counter_destroy(&metric->total_reads);
> +err_total_reads:
> +	percpu_counter_destroy(&metric->d_lease_mis);
> +err_dlease_mis:
> +	percpu_counter_destroy(&metric->d_lease_hit);
> +
> +	return ret;
>  }
>  
>  int ceph_mdsc_init(struct ceph_fs_client *fsc)
> @@ -4529,6 +4544,8 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
>  
>  	ceph_mdsc_stop(mdsc);
>  
> +	percpu_counter_destroy(&mdsc->metric.read_latency_sum);
> +	percpu_counter_destroy(&mdsc->metric.total_reads);
>  	percpu_counter_destroy(&mdsc->metric.d_lease_mis);
>  	percpu_counter_destroy(&mdsc->metric.d_lease_hit);
>  
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index ba74ff74c59c..574d4e5a5de2 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -16,6 +16,8 @@
>  #include <linux/ceph/mdsmap.h>
>  #include <linux/ceph/auth.h>
>  
> +#include "metric.h"
> +
>  /* The first 8 bits are reserved for old ceph releases */
>  enum ceph_feature_type {
>  	CEPHFS_FEATURE_MIMIC = 8,
> @@ -361,13 +363,6 @@ struct cap_wait {
>  	int			want;
>  };
>  
> -/* This is the global metrics */
> -struct ceph_client_metric {
> -	atomic64_t		total_dentries;
> -	struct percpu_counter	d_lease_hit;
> -	struct percpu_counter	d_lease_mis;
> -};
> -
>  /*
>   * mds client state
>   */
> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
> new file mode 100644
> index 000000000000..2a7b8f3fe6a4
> --- /dev/null
> +++ b/fs/ceph/metric.h
> @@ -0,0 +1,30 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _FS_CEPH_MDS_METRIC_H
> +#define _FS_CEPH_MDS_METRIC_H
> +
> +#include <linux/ceph/osd_client.h>
> +
> +/* This is the global metrics */
> +struct ceph_client_metric {
> +	atomic64_t		total_dentries;
> +	struct percpu_counter	d_lease_hit;
> +	struct percpu_counter	d_lease_mis;
> +
> +	struct percpu_counter	total_reads;
> +	struct percpu_counter	read_latency_sum;
> +};
> +
> +static inline void ceph_update_read_latency(struct ceph_client_metric *m,
> +					    struct ceph_osd_request *req,
> +					    int rc)
> +{
> +	if (!m || !req)
> +		return;
> +
> +	if (rc >= 0 || rc == -ENOENT || rc == -ETIMEDOUT) {
> +		s64 latency = req->r_end_stamp - req->r_start_stamp;
> +		percpu_counter_inc(&m->total_reads);
> +		percpu_counter_add(&m->read_latency_sum, latency);
> +	}
> +}
> +#endif

-- 
Jeff Layton <jlayton@kernel.org>

