Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C51F918BF78
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Mar 2020 19:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbgCSSgX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Mar 2020 14:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgCSSgX (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 19 Mar 2020 14:36:23 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6F0020787;
        Thu, 19 Mar 2020 18:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584642982;
        bh=7IIe5BczYAQ4UXWfpODMYuMG4JM0MfL+ah/qxbJA178=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AK/H26HW4oermEF9JMt5bsqRThXL9yfhb61herMlbSC6aoXAX+YQhKOHdB8UV9hLU
         Ee69YfdlFc9Wa2kkqMJqqYDYZs4/ZiOpfO8sW1JzClu+hFgjBBbE19MHhLo1YsdxmR
         8yHng/iTF8NQYu6u6Nal+U4GnSI49I8aHBig6kn8=
Message-ID: <d42fce6e2e16efd3e4d882ab56708bcd5be3ec20.camel@kernel.org>
Subject: Re: [PATCH v12 3/4] ceph: add read/write latency metric support
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     sage@redhat.com, idryomov@gmail.com, gfarnum@redhat.com,
        zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 19 Mar 2020 14:36:20 -0400
In-Reply-To: <53ad3efb-809f-cfc1-aec7-31684fbc72aa@redhat.com>
References: <1584626812-21323-1-git-send-email-xiubli@redhat.com>
         <1584626812-21323-4-git-send-email-xiubli@redhat.com>
         <4f5fb881060ac868c836190b848270331ae20c4b.camel@kernel.org>
         <53ad3efb-809f-cfc1-aec7-31684fbc72aa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-03-20 at 01:44 +0800, Xiubo Li wrote:
> On 2020/3/19 22:36, Jeff Layton wrote:
> > On Thu, 2020-03-19 at 10:06 -0400, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > Calculate the latency for OSD read requests. Add a new r_end_stamp
> > > field to struct ceph_osd_request that will hold the time of that
> > > the reply was received. Use that to calculate the RTT for each call,
> > > and divide the sum of those by number of calls to get averate RTT.
> > > 
> > > Keep a tally of RTT for OSD writes and number of calls to track average
> > > latency of OSD writes.
> > > 
> > > URL: https://tracker.ceph.com/issues/43215
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >   fs/ceph/addr.c                  |  18 +++++++
> > >   fs/ceph/debugfs.c               |  60 +++++++++++++++++++++-
> > >   fs/ceph/file.c                  |  26 ++++++++++
> > >   fs/ceph/metric.c                | 110 ++++++++++++++++++++++++++++++++++++++++
> > >   fs/ceph/metric.h                |  23 +++++++++
> > >   include/linux/ceph/osd_client.h |   1 +
> > >   net/ceph/osd_client.c           |   2 +
> > >   7 files changed, 239 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > > index 6f4678d..f359619 100644
> > > --- a/fs/ceph/addr.c
> > > +++ b/fs/ceph/addr.c
> > > @@ -216,6 +216,9 @@ static int ceph_sync_readpages(struct ceph_fs_client *fsc,
> > >   	if (!rc)
> > >   		rc = ceph_osdc_wait_request(osdc, req);
> > >   
> > > +	ceph_update_read_latency(&fsc->mdsc->metric, req->r_start_stamp,
> > > +				 req->r_end_stamp, rc);
> > > +
> > >   	ceph_osdc_put_request(req);
> > >   	dout("readpages result %d\n", rc);
> > >   	return rc;
> > > @@ -299,6 +302,7 @@ static int ceph_readpage(struct file *filp, struct page *page)
> > >   static void finish_read(struct ceph_osd_request *req)
> > >   {
> > >   	struct inode *inode = req->r_inode;
> > > +	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> > >   	struct ceph_osd_data *osd_data;
> > >   	int rc = req->r_result <= 0 ? req->r_result : 0;
> > >   	int bytes = req->r_result >= 0 ? req->r_result : 0;
> > > @@ -336,6 +340,10 @@ static void finish_read(struct ceph_osd_request *req)
> > >   		put_page(page);
> > >   		bytes -= PAGE_SIZE;
> > >   	}
> > > +
> > > +	ceph_update_read_latency(&fsc->mdsc->metric, req->r_start_stamp,
> > > +				 req->r_end_stamp, rc);
> > > +
> > >   	kfree(osd_data->pages);
> > >   }
> > >   
> > > @@ -643,6 +651,9 @@ static int ceph_sync_writepages(struct ceph_fs_client *fsc,
> > >   	if (!rc)
> > >   		rc = ceph_osdc_wait_request(osdc, req);
> > >   
> > > +	ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_stamp,
> > > +				  req->r_end_stamp, rc);
> > > +
> > >   	ceph_osdc_put_request(req);
> > >   	if (rc == 0)
> > >   		rc = len;
> > > @@ -794,6 +805,9 @@ static void writepages_finish(struct ceph_osd_request *req)
> > >   		ceph_clear_error_write(ci);
> > >   	}
> > >   
> > > +	ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_stamp,
> > > +				  req->r_end_stamp, rc);
> > > +
> > >   	/*
> > >   	 * We lost the cache cap, need to truncate the page before
> > >   	 * it is unlocked, otherwise we'd truncate it later in the
> > > @@ -1852,6 +1866,10 @@ int ceph_uninline_data(struct file *filp, struct page *locked_page)
> > >   	err = ceph_osdc_start_request(&fsc->client->osdc, req, false);
> > >   	if (!err)
> > >   		err = ceph_osdc_wait_request(&fsc->client->osdc, req);
> > > +
> > > +	ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_stamp,
> > > +				  req->r_end_stamp, err);
> > > +
> > >   out_put:
> > >   	ceph_osdc_put_request(req);
> > >   	if (err == -ECANCELED)
> > > diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> > > index 66b9622..de07fdb 100644
> > > --- a/fs/ceph/debugfs.c
> > > +++ b/fs/ceph/debugfs.c
> > > @@ -7,6 +7,7 @@
> > >   #include <linux/ctype.h>
> > >   #include <linux/debugfs.h>
> > >   #include <linux/seq_file.h>
> > > +#include <linux/math64.h>
> > >   
> > >   #include <linux/ceph/libceph.h>
> > >   #include <linux/ceph/mon_client.h>
> > > @@ -124,13 +125,70 @@ static int mdsc_show(struct seq_file *s, void *p)
> > >   	return 0;
> > >   }
> > >   
> > > +static u64 get_avg(u64 *totalp, u64 *sump, spinlock_t *lockp, u64 *total)
> > > +{
> > > +	u64 t, sum, avg = 0;
> > > +
> > > +	spin_lock(lockp);
> > > +	t = *totalp;
> > > +	sum = *sump;
> > > +	spin_unlock(lockp);
> > > +
> > > +	if (likely(t))
> > > +		avg = DIV64_U64_ROUND_CLOSEST(sum, t);
> > > +
> > > +	*total = t;
> > > +	return avg;
> > > +}
> > > +
> > > +#define CEPH_METRIC_SHOW(name, total, avg, min, max, sq) {		\
> > > +	u64 _total, _avg, _min, _max, _sq, _st, _re = 0;		\
> > > +	_avg = jiffies_to_usecs(avg);					\
> > > +	_min = jiffies_to_usecs(min == S64_MAX ? 0 : min);		\
> > > +	_max = jiffies_to_usecs(max);					\
> > > +	_total = total - 1;						\
> > > +	_sq = _total > 0 ? DIV64_U64_ROUND_CLOSEST(sq, _total) : 0;	\
> > > +	_sq = jiffies_to_usecs(_sq);					\
> > > +	_st = int_sqrt64(_sq);						\
> > > +	if (_st > 0) {							\
> > > +		_re = 5 * (_sq - (_st * _st));				\
> > > +		_re = _re > 0 ? _re - 1 : 0;				\
> > > +		_re = _st > 0 ? div64_s64(_re, _st) : 0;		\
> > > +	}								\
> > > +	seq_printf(s, "%-14s%-12llu%-16llu%-16llu%-16llu%llu.%llu\n",	\
> > > +		   name, total, _avg, _min, _max, _st, _re);		\
> > > +}
> > > +
> > >   static int metric_show(struct seq_file *s, void *p)
> > >   {
> > >   	struct ceph_fs_client *fsc = s->private;
> > >   	struct ceph_mds_client *mdsc = fsc->mdsc;
> > >   	struct ceph_client_metric *m = &mdsc->metric;
> > >   	int i, nr_caps = 0;
> > > -
> > > +	u64 total, avg, min, max, sq;
> > > +
> > > +	seq_printf(s, "item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)\n");
> > > +	seq_printf(s, "-----------------------------------------------------------------------------------\n");
> > > +
> > > +	avg = get_avg(&m->total_reads,
> > > +		      &m->read_latency_sum,
> > > +		      &m->read_latency_lock,
> > > +		      &total);
> > > +	min = atomic64_read(&m->read_latency_min);
> > > +	max = atomic64_read(&m->read_latency_max);
> > > +	sq = percpu_counter_sum(&m->read_latency_sq_sum);
> > > +	CEPH_METRIC_SHOW("read", total, avg, min, max, sq);
> > > +
> > > +	avg = get_avg(&m->total_writes,
> > > +		      &m->write_latency_sum,
> > > +		      &m->write_latency_lock,
> > > +		      &total);
> > > +	min = atomic64_read(&m->write_latency_min);
> > > +	max = atomic64_read(&m->write_latency_max);
> > > +	sq = percpu_counter_sum(&m->write_latency_sq_sum);
> > > +	CEPH_METRIC_SHOW("write", total, avg, min, max, sq);
> > > +
> > > +	seq_printf(s, "\n");
> > >   	seq_printf(s, "item          total           miss            hit\n");
> > >   	seq_printf(s, "-------------------------------------------------\n");
> > >   
> > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > index 4a5ccbb..8e40022 100644
> > > --- a/fs/ceph/file.c
> > > +++ b/fs/ceph/file.c
> > > @@ -906,6 +906,10 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
> > >   		ret = ceph_osdc_start_request(osdc, req, false);
> > >   		if (!ret)
> > >   			ret = ceph_osdc_wait_request(osdc, req);
> > > +
> > > +		ceph_update_read_latency(&fsc->mdsc->metric, req->r_start_stamp,
> > > +					 req->r_end_stamp, ret);
> > > +
> > >   		ceph_osdc_put_request(req);
> > >   
> > >   		i_size = i_size_read(inode);
> > > @@ -1044,6 +1048,8 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
> > >   	struct inode *inode = req->r_inode;
> > >   	struct ceph_aio_request *aio_req = req->r_priv;
> > >   	struct ceph_osd_data *osd_data = osd_req_op_extent_osd_data(req, 0);
> > > +	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> > > +	struct ceph_client_metric *metric = &fsc->mdsc->metric;
> > >   
> > >   	BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_BVECS);
> > >   	BUG_ON(!osd_data->num_bvecs);
> > > @@ -1051,6 +1057,16 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
> > >   	dout("ceph_aio_complete_req %p rc %d bytes %u\n",
> > >   	     inode, rc, osd_data->bvec_pos.iter.bi_size);
> > >   
> > > +	/* r_start_stamp == 0 means the request was not submitted */
> > > +	if (req->r_start_stamp) {
> > > +		if (aio_req->write)
> > > +			ceph_update_write_latency(metric, req->r_start_stamp,
> > > +						  req->r_end_stamp, rc);
> > > +		else
> > > +			ceph_update_read_latency(metric, req->r_start_stamp,
> > > +						 req->r_end_stamp, rc);
> > > +	}
> > > +
> > >   	if (rc == -EOLDSNAPC) {
> > >   		struct ceph_aio_work *aio_work;
> > >   		BUG_ON(!aio_req->write);
> > > @@ -1179,6 +1195,7 @@ static void ceph_aio_retry_work(struct work_struct *work)
> > >   	struct inode *inode = file_inode(file);
> > >   	struct ceph_inode_info *ci = ceph_inode(inode);
> > >   	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> > > +	struct ceph_client_metric *metric = &fsc->mdsc->metric;
> > >   	struct ceph_vino vino;
> > >   	struct ceph_osd_request *req;
> > >   	struct bio_vec *bvecs;
> > > @@ -1295,6 +1312,13 @@ static void ceph_aio_retry_work(struct work_struct *work)
> > >   		if (!ret)
> > >   			ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
> > >   
> > > +		if (write)
> > > +			ceph_update_write_latency(metric, req->r_start_stamp,
> > > +						  req->r_end_stamp, ret);
> > > +		else
> > > +			ceph_update_read_latency(metric, req->r_start_stamp,
> > > +						 req->r_end_stamp, ret);
> > > +
> > >   		size = i_size_read(inode);
> > >   		if (!write) {
> > >   			if (ret == -ENOENT)
> > > @@ -1466,6 +1490,8 @@ static void ceph_aio_retry_work(struct work_struct *work)
> > >   		if (!ret)
> > >   			ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
> > >   
> > > +		ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_stamp,
> > > +					  req->r_end_stamp, ret);
> > >   out:
> > >   		ceph_osdc_put_request(req);
> > >   		if (ret != 0) {
> > > diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> > > index 2a4b739..6cb64fb 100644
> > > --- a/fs/ceph/metric.c
> > > +++ b/fs/ceph/metric.c
> > > @@ -2,6 +2,7 @@
> > >   
> > >   #include <linux/types.h>
> > >   #include <linux/percpu_counter.h>
> > > +#include <linux/math64.h>
> > >   
> > >   #include "metric.h"
> > >   
> > > @@ -29,8 +30,32 @@ int ceph_metric_init(struct ceph_client_metric *m)
> > >   	if (ret)
> > >   		goto err_i_caps_mis;
> > >   
> > > +	ret = percpu_counter_init(&m->read_latency_sq_sum, 0, GFP_KERNEL);
> > > +	if (ret)
> > > +		goto err_read_latency_sq_sum;
> > > +
> > > +	atomic64_set(&m->read_latency_min, S64_MAX);
> > > +	atomic64_set(&m->read_latency_max, 0);
> > > +	spin_lock_init(&m->read_latency_lock);
> > > +	m->total_reads = 0;
> > > +	m->read_latency_sum = 0;
> > > +
> > > +	ret = percpu_counter_init(&m->write_latency_sq_sum, 0, GFP_KERNEL);
> > > +	if (ret)
> > > +		goto err_write_latency_sq_sum;
> > > +
> > > +	atomic64_set(&m->write_latency_min, S64_MAX);
> > > +	atomic64_set(&m->write_latency_max, 0);
> > > +	spin_lock_init(&m->write_latency_lock);
> > > +	m->total_writes = 0;
> > > +	m->write_latency_sum = 0;
> > > +
> > >   	return 0;
> > >   
> > > +err_write_latency_sq_sum:
> > > +	percpu_counter_destroy(&m->read_latency_sq_sum);
> > > +err_read_latency_sq_sum:
> > > +	percpu_counter_destroy(&m->i_caps_mis);
> > >   err_i_caps_mis:
> > >   	percpu_counter_destroy(&m->i_caps_hit);
> > >   err_i_caps_hit:
> > > @@ -46,8 +71,93 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
> > >   	if (!m)
> > >   		return;
> > >   
> > > +	percpu_counter_destroy(&m->write_latency_sq_sum);
> > > +	percpu_counter_destroy(&m->read_latency_sq_sum);
> > >   	percpu_counter_destroy(&m->i_caps_mis);
> > >   	percpu_counter_destroy(&m->i_caps_hit);
> > >   	percpu_counter_destroy(&m->d_lease_mis);
> > >   	percpu_counter_destroy(&m->d_lease_hit);
> > >   }
> > > +
> > > +static inline void __update_min_latency(atomic64_t *min, unsigned long lat)
> > > +{
> > > +	u64 cur, old;
> > > +
> > > +	cur = atomic64_read(min);
> > > +	do {
> > > +		old = cur;
> > > +		if (likely(lat >= old))
> > > +			break;
> > > +	} while (unlikely((cur = atomic64_cmpxchg(min, old, lat)) != old));
> > > +}
> > > +
> > > +static inline void __update_max_latency(atomic64_t *max, unsigned long lat)
> > > +{
> > > +	u64 cur, old;
> > > +
> > > +	cur = atomic64_read(max);
> > > +	do {
> > > +		old = cur;
> > > +		if (likely(lat <= old))
> > > +			break;
> > > +	} while (unlikely((cur = atomic64_cmpxchg(max, old, lat)) != old));
> > > +}
> > > +
> > > +static inline void __update_avg_and_sq(u64 *totalp, u64 *lsump,
> > > +				       struct percpu_counter *sq_sump,
> > > +				       spinlock_t *lockp, unsigned long lat)
> > > +{
> > > +	u64 total, avg, sq, lsum;
> > > +
> > > +	spin_lock(lockp);
> > > +	total = ++(*totalp);
> > > +	*lsump += lat;
> > > +	lsum = *lsump;
> > > +	spin_unlock(lockp);
> 
> For each read/write/metadata latency updating,  I am trying to just make 
> the critical code as small as possible here.
> 
> 

A few extra arithmetic operations won't make a big difference here. All
of the data being accessed will (probably) be on the same cacheline too,
so it's almost certainly going to cost next to nothing anyway. There might be some benefit to using a percpu value, but it's hard to imagine it making a difference at the frequency we'll be updating this.


> > > +
> > > +	if (unlikely(total == 1))
> > > +		return;
> > > +
> > > +	/* the sq is (lat - old_avg) * (lat - new_avg) */
> > > +	avg = DIV64_U64_ROUND_CLOSEST((lsum - lat), (total - 1));
> > > +	sq = lat - avg;
> > > +	avg = DIV64_U64_ROUND_CLOSEST(lsum, total);
> > > +	sq = sq * (lat - avg);
> > > +	percpu_counter_add(sq_sump, sq);
> 
> IMO, the percpu_counter could bring us benefit without locks, which will 
> do many div/muti many times and will take some longer time on computing 
> the sq.
> 

It's really unlikely to make much difference. These operations are still
pretty fast on modern CPUs, and we're only doing one update per I/O.


> 
> > > +}
> > > +
> > > +void ceph_update_read_latency(struct ceph_client_metric *m,
> > > +			      unsigned long r_start,
> > > +			      unsigned long r_end,
> > > +			      int rc)
> > > +{
> > > +	unsigned long lat = r_end - r_start;
> > > +
> > > +	if (unlikely(rc < 0 && rc != -ENOENT && rc != -ETIMEDOUT))
> > > +		return;
> > > +
> > > +	__update_min_latency(&m->read_latency_min, lat);
> > > +	__update_max_latency(&m->read_latency_max, lat);
> 
> And also here to update the min/max without locks, but this should be 
> okay to switch to u64 and under the locks.
> 
> Thought ?
> 

The thing is that volatile variable accesses (atomic64_t's) are not
without cost. This may perform _worse_ in a contended situation as two
CPUs might be ping-ponging the same cacheline back and forth as they
each update the different fields in the same struct.

> If this makes sense, I will make the min/max to u64 type, and keep the 
> sq_sum as the percpu. Or I will make them all to u64.
> 

I'd just make them all u64s that are protected by the spinlock. You are
going to have to take the spinlock anyway, and you're updating memory
that should be very close together (and hence in the same cachelines).

Lock mitigation strategies in general don't really help if you have to
take a lock every time anyway. Any performance hit from having to do an
extra bit of math and a store under spinlock will probably not be
measurable.

-- 
Jeff Layton <jlayton@kernel.org>

