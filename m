Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6FB13DCA5
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Jan 2020 14:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgAPNzJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Jan 2020 08:55:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:54226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgAPNzJ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 08:55:09 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 687BE2075B;
        Thu, 16 Jan 2020 13:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579182908;
        bh=5eh4wAT5/n3YBBTWleXFC7UKkdGo0LwJd8PR4bU1eIE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Pn2JII59FkjV+4UfQ5qgDYB4gbcWaBWa3xEy5m8xUKn+IxPMkggE8KetUyVJKduk7
         FyuG3TEfzw8+fkAi5Ekinife44qdurvMBGUDtjeL+oLgFLVHfFi89RxeiHCDKxteZH
         7mO0iYKpWmq0CSqYdocypLgISFYBansNtYlNfQpk=
Message-ID: <73649a52f6c0b297d7a6d2ae5356b208369c16e4.camel@kernel.org>
Subject: Re: [PATCH v4 3/8] ceph: add global read latency metric support
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 16 Jan 2020 08:55:06 -0500
In-Reply-To: <20200116103830.13591-4-xiubli@redhat.com>
References: <20200116103830.13591-1-xiubli@redhat.com>
         <20200116103830.13591-4-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-01-16 at 05:38 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> item          total       sum_lat(us)     avg_lat(us)
> -----------------------------------------------------
> read          73          3590000         49178082
> 
> URL: https://tracker.ceph.com/issues/43215
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/addr.c                  | 15 ++++++++++++++-
>  fs/ceph/debugfs.c               | 13 +++++++++++++
>  fs/ceph/file.c                  | 25 +++++++++++++++++++++++++
>  fs/ceph/mds_client.c            | 25 ++++++++++++++++++++++++-
>  fs/ceph/mds_client.h            |  7 +++++++
>  include/linux/ceph/osd_client.h |  2 +-
>  net/ceph/osd_client.c           |  9 ++++++++-
>  7 files changed, 92 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 29d4513eff8c..479ecd0a6e9d 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -190,6 +190,8 @@ static int ceph_do_readpage(struct file *filp, struct page *page)
>  	struct inode *inode = file_inode(filp);
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> +	struct ceph_client_metric *metric = &fsc->mdsc->metric;
> +	s64 latency;
>  	int err = 0;
>  	u64 off = page_offset(page);
>  	u64 len = PAGE_SIZE;
> @@ -221,7 +223,7 @@ static int ceph_do_readpage(struct file *filp, struct page *page)
>  	err = ceph_osdc_readpages(&fsc->client->osdc, ceph_vino(inode),
>  				  &ci->i_layout, off, &len,
>  				  ci->i_truncate_seq, ci->i_truncate_size,
> -				  &page, 1, 0);
> +				  &page, 1, 0, &latency);
>  	if (err == -ENOENT)
>  		err = 0;
>  	if (err < 0) {
> @@ -241,6 +243,9 @@ static int ceph_do_readpage(struct file *filp, struct page *page)
>  	ceph_readpage_to_fscache(inode, page);
>  
>  out:
> +	if (latency)
> +		ceph_mdsc_update_read_latency(metric, latency);
> +
>  	return err < 0 ? err : 0;
>  }
>  
> @@ -260,6 +265,8 @@ static int ceph_readpage(struct file *filp, struct page *page)
>  static void finish_read(struct ceph_osd_request *req)
>  {
>  	struct inode *inode = req->r_inode;
> +	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> +	struct ceph_client_metric *metric = &fsc->mdsc->metric;
>  	struct ceph_osd_data *osd_data;
>  	int rc = req->r_result <= 0 ? req->r_result : 0;
>  	int bytes = req->r_result >= 0 ? req->r_result : 0;
> @@ -297,6 +304,12 @@ static void finish_read(struct ceph_osd_request *req)
>  		put_page(page);
>  		bytes -= PAGE_SIZE;
>  	}
> +
> +	if (rc >= 0 || rc == -ENOENT) {
> +		s64 latency = jiffies - req->r_start_stamp;
> +		ceph_mdsc_update_read_latency(metric, latency);
> +	}
> +
>  	kfree(osd_data->pages);
>  }
>  
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index c132fdb40d53..8200bf025ccd 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -128,8 +128,21 @@ static int metric_show(struct seq_file *s, void *p)
>  {
>  	struct ceph_fs_client *fsc = s->private;
>  	struct ceph_mds_client *mdsc = fsc->mdsc;
> +	s64 total, sum, avg = 0;
>  	int i;
>  
> +	seq_printf(s, "item          total       sum_lat(us)     avg_lat(us)\n");
> +	seq_printf(s, "-----------------------------------------------------\n");
> +
> +	spin_lock(&mdsc->metric.read_lock);
> +	total = atomic64_read(&mdsc->metric.total_reads),
> +	sum = timespec64_to_ns(&mdsc->metric.read_latency_sum);
> +	spin_unlock(&mdsc->metric.read_lock);
> +	avg = total ? sum / total : 0;
> +	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "read",
> +		   total, sum / NSEC_PER_USEC, avg / NSEC_PER_USEC);
> +
> +	seq_printf(s, "\n");
>  	seq_printf(s, "item          total           miss            hit\n");
>  	seq_printf(s, "-------------------------------------------------\n");
>  
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index c78dfbbb7b91..f479b699db14 100644
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
> @@ -660,6 +661,11 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>  		ret = ceph_osdc_start_request(osdc, req, false);
>  		if (!ret)
>  			ret = ceph_osdc_wait_request(osdc, req);
> +
> +		if (ret >= 0 || ret == -ENOENT || ret == -ETIMEDOUT) {
> +			s64 latency = jiffies - req->r_start_stamp;
> +			ceph_mdsc_update_read_latency(metric, latency);
> +		}
>  		ceph_osdc_put_request(req);
>  
>  		i_size = i_size_read(inode);
> @@ -798,13 +804,24 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
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
> +	if (req->r_start_stamp && (rc >= 0 || rc == -ENOENT)) {
> +		s64 latency = jiffies - req->r_start_stamp;
> +
> +		if (!aio_req->write)
> +			ceph_mdsc_update_read_latency(metric, latency);
> +	}
> +
>  	if (rc == -EOLDSNAPC) {
>  		struct ceph_aio_work *aio_work;
>  		BUG_ON(!aio_req->write);
> @@ -933,6 +950,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
>  	struct inode *inode = file_inode(file);
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> +	struct ceph_client_metric *metric = &fsc->mdsc->metric;
>  	struct ceph_vino vino;
>  	struct ceph_osd_request *req;
>  	struct bio_vec *bvecs;
> @@ -1049,6 +1067,13 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
>  		if (!ret)
>  			ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
>  
> +		if ((ret >= 0 || ret == -ENOENT || ret == -ETIMEDOUT)) {
> +			s64 latency = jiffies - req->r_start_stamp;
> +
> +			if (!write)
> +				ceph_mdsc_update_read_latency(metric, latency);
> +		}
> +
>  		size = i_size_read(inode);
>  		if (!write) {
>  			if (ret == -ENOENT)
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 141c1c03636c..dc2cda55a5a5 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4093,6 +4093,25 @@ static void maybe_recover_session(struct ceph_mds_client *mdsc)
>  	ceph_force_reconnect(fsc->sb);
>  }
>  
> +/*
> + * metric helpers
> + */
> +void ceph_mdsc_update_read_latency(struct ceph_client_metric *m,
> +				   s64 latency)
> +{
> +	struct timespec64 ts;
> +
> +	if (!m)
> +		return;
> +
> +	jiffies_to_timespec64(latency, &ts);
> +
> +	spin_lock(&m->read_lock);
> +	atomic64_inc(&m->total_reads);
> +	m->read_latency_sum = timespec64_add(m->read_latency_sum, ts);
> +	spin_unlock(&m->read_lock);
> +}
> +
>  /*
>   * delayed work -- periodically trim expired leases, renew caps with mds
>   */
> @@ -4182,13 +4201,17 @@ static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
>  	atomic64_set(&metric->total_dentries, 0);
>  	ret = percpu_counter_init(&metric->d_lease_hit, 0, GFP_KERNEL);
>  	if (ret)
> -		return ret;
> +		return ret;;
>  	ret = percpu_counter_init(&metric->d_lease_mis, 0, GFP_KERNEL);
>  	if (ret) {
>  		percpu_counter_destroy(&metric->d_lease_hit);
>  		return ret;
>  	}
>  
> +	spin_lock_init(&metric->read_lock);
> +	memset(&metric->read_latency_sum, 0, sizeof(struct timespec64));
> +	atomic64_set(&metric->total_reads, 0);
> +
>  	return 0;
>  }
>  
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index ba74ff74c59c..cdc59037ef14 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -366,6 +366,10 @@ struct ceph_client_metric {
>  	atomic64_t		total_dentries;
>  	struct percpu_counter	d_lease_hit;
>  	struct percpu_counter	d_lease_mis;
> +
> +	spinlock_t              read_lock;
> +	atomic64_t		total_reads;
> +	struct timespec64	read_latency_sum;
>  };
>  
>  /*
> @@ -549,4 +553,7 @@ extern void ceph_mdsc_open_export_target_sessions(struct ceph_mds_client *mdsc,
>  extern int ceph_trim_caps(struct ceph_mds_client *mdsc,
>  			  struct ceph_mds_session *session,
>  			  int max_caps);
> +
> +extern void ceph_mdsc_update_read_latency(struct ceph_client_metric *m,
> +					  s64 latency);
>  #endif
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index 5a62dbd3f4c2..43e4240d88e7 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -515,7 +515,7 @@ extern int ceph_osdc_readpages(struct ceph_osd_client *osdc,
>  			       u64 off, u64 *plen,
>  			       u32 truncate_seq, u64 truncate_size,
>  			       struct page **pages, int nr_pages,
> -			       int page_align);
> +			       int page_align, s64 *latency);
>  
>  extern int ceph_osdc_writepages(struct ceph_osd_client *osdc,
>  				struct ceph_vino vino,
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index b68b376d8c2f..62eb758f2474 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5238,11 +5238,15 @@ int ceph_osdc_readpages(struct ceph_osd_client *osdc,
>  			struct ceph_vino vino, struct ceph_file_layout *layout,
>  			u64 off, u64 *plen,
>  			u32 truncate_seq, u64 truncate_size,
> -			struct page **pages, int num_pages, int page_align)
> +			struct page **pages, int num_pages, int page_align,
> +			s64 *latency)
>  {
>  	struct ceph_osd_request *req;
>  	int rc = 0;
>  
> +	if (latency)
> +		*latency = 0;
> +
>  	dout("readpages on ino %llx.%llx on %llu~%llu\n", vino.ino,
>  	     vino.snap, off, *plen);
>  	req = ceph_osdc_new_request(osdc, layout, vino, off, plen, 0, 1,
> @@ -5263,6 +5267,9 @@ int ceph_osdc_readpages(struct ceph_osd_client *osdc,
>  	if (!rc)
>  		rc = ceph_osdc_wait_request(osdc, req);
>  
> +	if (latency && (rc >= 0 || rc == -ENOENT || rc == -ETIMEDOUT))
> +		*latency = jiffies - req->r_start_stamp;
> +
>  	ceph_osdc_put_request(req);
>  	dout("readpages result %d\n", rc);
>  	return rc;

This function is only called from ceph_do_readpage().

I think it'd be better to just turn ceph_osdc_readpages into
ceph_osdc_readpages_submit, make it not wait on the req and have it
return a pointer to the req with a reference held.

Then the caller could then handle the waiting and do the latency
calculation afterward and we wouldn't need to add a new pointer argument
here and push these details into libcephfs.
-- 
Jeff Layton <jlayton@kernel.org>

