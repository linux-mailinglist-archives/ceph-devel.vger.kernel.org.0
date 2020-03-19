Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5579C18BE95
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Mar 2020 18:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgCSRpF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Mar 2020 13:45:05 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:42007 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727769AbgCSRpE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 19 Mar 2020 13:45:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584639902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v6LjjVm08Hgb8XfOxPsRXnkc8KcF2EdcMsC//qHj4qQ=;
        b=WqXC1y0HJ/Jj/ZkNeigmWTU++WPq1VKuKMNqIsmLfnU/49ckeHDAq0MBmp/qloOIoWEUmj
        1+mmfYaYKaGyU9GiD9ycAxUcHBuxqBd736MWkuV7rWtI8NtQOeMlm/T/j6MXhAr5lfo9xl
        G5/WK5Y6BYDy6uk2HyOFgPKBPXNgDbc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-Wuictw97Ot-jjC1jCjdLoA-1; Thu, 19 Mar 2020 13:44:55 -0400
X-MC-Unique: Wuictw97Ot-jjC1jCjdLoA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBB7485EE71;
        Thu, 19 Mar 2020 17:44:54 +0000 (UTC)
Received: from [10.72.12.253] (ovpn-12-253.pek2.redhat.com [10.72.12.253])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 800135C1A4;
        Thu, 19 Mar 2020 17:44:46 +0000 (UTC)
Subject: Re: [PATCH v12 3/4] ceph: add read/write latency metric support
To:     Jeff Layton <jlayton@kernel.org>
Cc:     sage@redhat.com, idryomov@gmail.com, gfarnum@redhat.com,
        zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <1584626812-21323-1-git-send-email-xiubli@redhat.com>
 <1584626812-21323-4-git-send-email-xiubli@redhat.com>
 <4f5fb881060ac868c836190b848270331ae20c4b.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <53ad3efb-809f-cfc1-aec7-31684fbc72aa@redhat.com>
Date:   Fri, 20 Mar 2020 01:44:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <4f5fb881060ac868c836190b848270331ae20c4b.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/3/19 22:36, Jeff Layton wrote:
> On Thu, 2020-03-19 at 10:06 -0400, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Calculate the latency for OSD read requests. Add a new r_end_stamp
>> field to struct ceph_osd_request that will hold the time of that
>> the reply was received. Use that to calculate the RTT for each call,
>> and divide the sum of those by number of calls to get averate RTT.
>>
>> Keep a tally of RTT for OSD writes and number of calls to track averag=
e
>> latency of OSD writes.
>>
>> URL: https://tracker.ceph.com/issues/43215
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/addr.c                  |  18 +++++++
>>   fs/ceph/debugfs.c               |  60 +++++++++++++++++++++-
>>   fs/ceph/file.c                  |  26 ++++++++++
>>   fs/ceph/metric.c                | 110 ++++++++++++++++++++++++++++++=
++++++++++
>>   fs/ceph/metric.h                |  23 +++++++++
>>   include/linux/ceph/osd_client.h |   1 +
>>   net/ceph/osd_client.c           |   2 +
>>   7 files changed, 239 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index 6f4678d..f359619 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -216,6 +216,9 @@ static int ceph_sync_readpages(struct ceph_fs_clie=
nt *fsc,
>>   	if (!rc)
>>   		rc =3D ceph_osdc_wait_request(osdc, req);
>>  =20
>> +	ceph_update_read_latency(&fsc->mdsc->metric, req->r_start_stamp,
>> +				 req->r_end_stamp, rc);
>> +
>>   	ceph_osdc_put_request(req);
>>   	dout("readpages result %d\n", rc);
>>   	return rc;
>> @@ -299,6 +302,7 @@ static int ceph_readpage(struct file *filp, struct=
 page *page)
>>   static void finish_read(struct ceph_osd_request *req)
>>   {
>>   	struct inode *inode =3D req->r_inode;
>> +	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
>>   	struct ceph_osd_data *osd_data;
>>   	int rc =3D req->r_result <=3D 0 ? req->r_result : 0;
>>   	int bytes =3D req->r_result >=3D 0 ? req->r_result : 0;
>> @@ -336,6 +340,10 @@ static void finish_read(struct ceph_osd_request *=
req)
>>   		put_page(page);
>>   		bytes -=3D PAGE_SIZE;
>>   	}
>> +
>> +	ceph_update_read_latency(&fsc->mdsc->metric, req->r_start_stamp,
>> +				 req->r_end_stamp, rc);
>> +
>>   	kfree(osd_data->pages);
>>   }
>>  =20
>> @@ -643,6 +651,9 @@ static int ceph_sync_writepages(struct ceph_fs_cli=
ent *fsc,
>>   	if (!rc)
>>   		rc =3D ceph_osdc_wait_request(osdc, req);
>>  =20
>> +	ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_stamp,
>> +				  req->r_end_stamp, rc);
>> +
>>   	ceph_osdc_put_request(req);
>>   	if (rc =3D=3D 0)
>>   		rc =3D len;
>> @@ -794,6 +805,9 @@ static void writepages_finish(struct ceph_osd_requ=
est *req)
>>   		ceph_clear_error_write(ci);
>>   	}
>>  =20
>> +	ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_stamp,
>> +				  req->r_end_stamp, rc);
>> +
>>   	/*
>>   	 * We lost the cache cap, need to truncate the page before
>>   	 * it is unlocked, otherwise we'd truncate it later in the
>> @@ -1852,6 +1866,10 @@ int ceph_uninline_data(struct file *filp, struc=
t page *locked_page)
>>   	err =3D ceph_osdc_start_request(&fsc->client->osdc, req, false);
>>   	if (!err)
>>   		err =3D ceph_osdc_wait_request(&fsc->client->osdc, req);
>> +
>> +	ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_stamp,
>> +				  req->r_end_stamp, err);
>> +
>>   out_put:
>>   	ceph_osdc_put_request(req);
>>   	if (err =3D=3D -ECANCELED)
>> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
>> index 66b9622..de07fdb 100644
>> --- a/fs/ceph/debugfs.c
>> +++ b/fs/ceph/debugfs.c
>> @@ -7,6 +7,7 @@
>>   #include <linux/ctype.h>
>>   #include <linux/debugfs.h>
>>   #include <linux/seq_file.h>
>> +#include <linux/math64.h>
>>  =20
>>   #include <linux/ceph/libceph.h>
>>   #include <linux/ceph/mon_client.h>
>> @@ -124,13 +125,70 @@ static int mdsc_show(struct seq_file *s, void *p=
)
>>   	return 0;
>>   }
>>  =20
>> +static u64 get_avg(u64 *totalp, u64 *sump, spinlock_t *lockp, u64 *to=
tal)
>> +{
>> +	u64 t, sum, avg =3D 0;
>> +
>> +	spin_lock(lockp);
>> +	t =3D *totalp;
>> +	sum =3D *sump;
>> +	spin_unlock(lockp);
>> +
>> +	if (likely(t))
>> +		avg =3D DIV64_U64_ROUND_CLOSEST(sum, t);
>> +
>> +	*total =3D t;
>> +	return avg;
>> +}
>> +
>> +#define CEPH_METRIC_SHOW(name, total, avg, min, max, sq) {		\
>> +	u64 _total, _avg, _min, _max, _sq, _st, _re =3D 0;		\
>> +	_avg =3D jiffies_to_usecs(avg);					\
>> +	_min =3D jiffies_to_usecs(min =3D=3D S64_MAX ? 0 : min);		\
>> +	_max =3D jiffies_to_usecs(max);					\
>> +	_total =3D total - 1;						\
>> +	_sq =3D _total > 0 ? DIV64_U64_ROUND_CLOSEST(sq, _total) : 0;	\
>> +	_sq =3D jiffies_to_usecs(_sq);					\
>> +	_st =3D int_sqrt64(_sq);						\
>> +	if (_st > 0) {							\
>> +		_re =3D 5 * (_sq - (_st * _st));				\
>> +		_re =3D _re > 0 ? _re - 1 : 0;				\
>> +		_re =3D _st > 0 ? div64_s64(_re, _st) : 0;		\
>> +	}								\
>> +	seq_printf(s, "%-14s%-12llu%-16llu%-16llu%-16llu%llu.%llu\n",	\
>> +		   name, total, _avg, _min, _max, _st, _re);		\
>> +}
>> +
>>   static int metric_show(struct seq_file *s, void *p)
>>   {
>>   	struct ceph_fs_client *fsc =3D s->private;
>>   	struct ceph_mds_client *mdsc =3D fsc->mdsc;
>>   	struct ceph_client_metric *m =3D &mdsc->metric;
>>   	int i, nr_caps =3D 0;
>> -
>> +	u64 total, avg, min, max, sq;
>> +
>> +	seq_printf(s, "item          total       avg_lat(us)     min_lat(us)=
     max_lat(us)     stdev(us)\n");
>> +	seq_printf(s, "-----------------------------------------------------=
------------------------------\n");
>> +
>> +	avg =3D get_avg(&m->total_reads,
>> +		      &m->read_latency_sum,
>> +		      &m->read_latency_lock,
>> +		      &total);
>> +	min =3D atomic64_read(&m->read_latency_min);
>> +	max =3D atomic64_read(&m->read_latency_max);
>> +	sq =3D percpu_counter_sum(&m->read_latency_sq_sum);
>> +	CEPH_METRIC_SHOW("read", total, avg, min, max, sq);
>> +
>> +	avg =3D get_avg(&m->total_writes,
>> +		      &m->write_latency_sum,
>> +		      &m->write_latency_lock,
>> +		      &total);
>> +	min =3D atomic64_read(&m->write_latency_min);
>> +	max =3D atomic64_read(&m->write_latency_max);
>> +	sq =3D percpu_counter_sum(&m->write_latency_sq_sum);
>> +	CEPH_METRIC_SHOW("write", total, avg, min, max, sq);
>> +
>> +	seq_printf(s, "\n");
>>   	seq_printf(s, "item          total           miss            hit\n"=
);
>>   	seq_printf(s, "-------------------------------------------------\n"=
);
>>  =20
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 4a5ccbb..8e40022 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -906,6 +906,10 @@ static ssize_t ceph_sync_read(struct kiocb *iocb,=
 struct iov_iter *to,
>>   		ret =3D ceph_osdc_start_request(osdc, req, false);
>>   		if (!ret)
>>   			ret =3D ceph_osdc_wait_request(osdc, req);
>> +
>> +		ceph_update_read_latency(&fsc->mdsc->metric, req->r_start_stamp,
>> +					 req->r_end_stamp, ret);
>> +
>>   		ceph_osdc_put_request(req);
>>  =20
>>   		i_size =3D i_size_read(inode);
>> @@ -1044,6 +1048,8 @@ static void ceph_aio_complete_req(struct ceph_os=
d_request *req)
>>   	struct inode *inode =3D req->r_inode;
>>   	struct ceph_aio_request *aio_req =3D req->r_priv;
>>   	struct ceph_osd_data *osd_data =3D osd_req_op_extent_osd_data(req, =
0);
>> +	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
>> +	struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
>>  =20
>>   	BUG_ON(osd_data->type !=3D CEPH_OSD_DATA_TYPE_BVECS);
>>   	BUG_ON(!osd_data->num_bvecs);
>> @@ -1051,6 +1057,16 @@ static void ceph_aio_complete_req(struct ceph_o=
sd_request *req)
>>   	dout("ceph_aio_complete_req %p rc %d bytes %u\n",
>>   	     inode, rc, osd_data->bvec_pos.iter.bi_size);
>>  =20
>> +	/* r_start_stamp =3D=3D 0 means the request was not submitted */
>> +	if (req->r_start_stamp) {
>> +		if (aio_req->write)
>> +			ceph_update_write_latency(metric, req->r_start_stamp,
>> +						  req->r_end_stamp, rc);
>> +		else
>> +			ceph_update_read_latency(metric, req->r_start_stamp,
>> +						 req->r_end_stamp, rc);
>> +	}
>> +
>>   	if (rc =3D=3D -EOLDSNAPC) {
>>   		struct ceph_aio_work *aio_work;
>>   		BUG_ON(!aio_req->write);
>> @@ -1179,6 +1195,7 @@ static void ceph_aio_retry_work(struct work_stru=
ct *work)
>>   	struct inode *inode =3D file_inode(file);
>>   	struct ceph_inode_info *ci =3D ceph_inode(inode);
>>   	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
>> +	struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
>>   	struct ceph_vino vino;
>>   	struct ceph_osd_request *req;
>>   	struct bio_vec *bvecs;
>> @@ -1295,6 +1312,13 @@ static void ceph_aio_retry_work(struct work_str=
uct *work)
>>   		if (!ret)
>>   			ret =3D ceph_osdc_wait_request(&fsc->client->osdc, req);
>>  =20
>> +		if (write)
>> +			ceph_update_write_latency(metric, req->r_start_stamp,
>> +						  req->r_end_stamp, ret);
>> +		else
>> +			ceph_update_read_latency(metric, req->r_start_stamp,
>> +						 req->r_end_stamp, ret);
>> +
>>   		size =3D i_size_read(inode);
>>   		if (!write) {
>>   			if (ret =3D=3D -ENOENT)
>> @@ -1466,6 +1490,8 @@ static void ceph_aio_retry_work(struct work_stru=
ct *work)
>>   		if (!ret)
>>   			ret =3D ceph_osdc_wait_request(&fsc->client->osdc, req);
>>  =20
>> +		ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_stamp,
>> +					  req->r_end_stamp, ret);
>>   out:
>>   		ceph_osdc_put_request(req);
>>   		if (ret !=3D 0) {
>> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
>> index 2a4b739..6cb64fb 100644
>> --- a/fs/ceph/metric.c
>> +++ b/fs/ceph/metric.c
>> @@ -2,6 +2,7 @@
>>  =20
>>   #include <linux/types.h>
>>   #include <linux/percpu_counter.h>
>> +#include <linux/math64.h>
>>  =20
>>   #include "metric.h"
>>  =20
>> @@ -29,8 +30,32 @@ int ceph_metric_init(struct ceph_client_metric *m)
>>   	if (ret)
>>   		goto err_i_caps_mis;
>>  =20
>> +	ret =3D percpu_counter_init(&m->read_latency_sq_sum, 0, GFP_KERNEL);
>> +	if (ret)
>> +		goto err_read_latency_sq_sum;
>> +
>> +	atomic64_set(&m->read_latency_min, S64_MAX);
>> +	atomic64_set(&m->read_latency_max, 0);
>> +	spin_lock_init(&m->read_latency_lock);
>> +	m->total_reads =3D 0;
>> +	m->read_latency_sum =3D 0;
>> +
>> +	ret =3D percpu_counter_init(&m->write_latency_sq_sum, 0, GFP_KERNEL)=
;
>> +	if (ret)
>> +		goto err_write_latency_sq_sum;
>> +
>> +	atomic64_set(&m->write_latency_min, S64_MAX);
>> +	atomic64_set(&m->write_latency_max, 0);
>> +	spin_lock_init(&m->write_latency_lock);
>> +	m->total_writes =3D 0;
>> +	m->write_latency_sum =3D 0;
>> +
>>   	return 0;
>>  =20
>> +err_write_latency_sq_sum:
>> +	percpu_counter_destroy(&m->read_latency_sq_sum);
>> +err_read_latency_sq_sum:
>> +	percpu_counter_destroy(&m->i_caps_mis);
>>   err_i_caps_mis:
>>   	percpu_counter_destroy(&m->i_caps_hit);
>>   err_i_caps_hit:
>> @@ -46,8 +71,93 @@ void ceph_metric_destroy(struct ceph_client_metric =
*m)
>>   	if (!m)
>>   		return;
>>  =20
>> +	percpu_counter_destroy(&m->write_latency_sq_sum);
>> +	percpu_counter_destroy(&m->read_latency_sq_sum);
>>   	percpu_counter_destroy(&m->i_caps_mis);
>>   	percpu_counter_destroy(&m->i_caps_hit);
>>   	percpu_counter_destroy(&m->d_lease_mis);
>>   	percpu_counter_destroy(&m->d_lease_hit);
>>   }
>> +
>> +static inline void __update_min_latency(atomic64_t *min, unsigned lon=
g lat)
>> +{
>> +	u64 cur, old;
>> +
>> +	cur =3D atomic64_read(min);
>> +	do {
>> +		old =3D cur;
>> +		if (likely(lat >=3D old))
>> +			break;
>> +	} while (unlikely((cur =3D atomic64_cmpxchg(min, old, lat)) !=3D old=
));
>> +}
>> +
>> +static inline void __update_max_latency(atomic64_t *max, unsigned lon=
g lat)
>> +{
>> +	u64 cur, old;
>> +
>> +	cur =3D atomic64_read(max);
>> +	do {
>> +		old =3D cur;
>> +		if (likely(lat <=3D old))
>> +			break;
>> +	} while (unlikely((cur =3D atomic64_cmpxchg(max, old, lat)) !=3D old=
));
>> +}
>> +
>> +static inline void __update_avg_and_sq(u64 *totalp, u64 *lsump,
>> +				       struct percpu_counter *sq_sump,
>> +				       spinlock_t *lockp, unsigned long lat)
>> +{
>> +	u64 total, avg, sq, lsum;
>> +
>> +	spin_lock(lockp);
>> +	total =3D ++(*totalp);
>> +	*lsump +=3D lat;
>> +	lsum =3D *lsump;
>> +	spin_unlock(lockp);

For each read/write/metadata latency updating,=C2=A0 I am trying to just =
make=20
the critical code as small as possible here.


>> +
>> +	if (unlikely(total =3D=3D 1))
>> +		return;
>> +
>> +	/* the sq is (lat - old_avg) * (lat - new_avg) */
>> +	avg =3D DIV64_U64_ROUND_CLOSEST((lsum - lat), (total - 1));
>> +	sq =3D lat - avg;
>> +	avg =3D DIV64_U64_ROUND_CLOSEST(lsum, total);
>> +	sq =3D sq * (lat - avg);
>> +	percpu_counter_add(sq_sump, sq);

IMO, the percpu_counter could bring us benefit without locks, which will=20
do many div/muti many times and will take some longer time on computing=20
the sq.


>> +}
>> +
>> +void ceph_update_read_latency(struct ceph_client_metric *m,
>> +			      unsigned long r_start,
>> +			      unsigned long r_end,
>> +			      int rc)
>> +{
>> +	unsigned long lat =3D r_end - r_start;
>> +
>> +	if (unlikely(rc < 0 && rc !=3D -ENOENT && rc !=3D -ETIMEDOUT))
>> +		return;
>> +
>> +	__update_min_latency(&m->read_latency_min, lat);
>> +	__update_max_latency(&m->read_latency_max, lat);

And also here to update the min/max without locks, but this should be=20
okay to switch to u64 and under the locks.

Thought ?

If this makes sense, I will make the min/max to u64 type, and keep the=20
sq_sum as the percpu. Or I will make them all to u64.

Thanks.



>> +	__update_avg_and_sq(&m->total_reads, &m->read_latency_sum,
>> +			    &m->read_latency_sq_sum,
>> +			    &m->read_latency_lock,
>> +			    lat);
>> +}
>> +
>> +void ceph_update_write_latency(struct ceph_client_metric *m,
>> +			       unsigned long r_start,
>> +			       unsigned long r_end,
>> +			       int rc)
>> +{
>> +	unsigned long lat =3D r_end - r_start;
>> +
>> +	if (unlikely(rc && rc !=3D -ETIMEDOUT))
>> +		return;
>> +
>> +	__update_min_latency(&m->write_latency_min, lat);
>> +	__update_max_latency(&m->write_latency_max, lat);
>> +	__update_avg_and_sq(&m->total_writes, &m->write_latency_sum,
>> +			    &m->write_latency_sq_sum,
>> +			    &m->write_latency_lock,
>> +			    lat);
>> +}
>> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
>> index 098ee8a..c7eae56 100644
>> --- a/fs/ceph/metric.h
>> +++ b/fs/ceph/metric.h
>> @@ -13,6 +13,20 @@ struct ceph_client_metric {
>>  =20
>>   	struct percpu_counter i_caps_hit;
>>   	struct percpu_counter i_caps_mis;
>> +
>> +	struct percpu_counter read_latency_sq_sum;
>> +	atomic64_t read_latency_min;
>> +	atomic64_t read_latency_max;
> I'd make the above 3 values be regular values and make them all use the
> read_latency_lock. Given that you're taking a lock anyway, it's more
> efficient to just do all of the manipulation under a single spinlock
> rather than fooling with atomic or percpu values. These are all almost
> certainly going to be in the same cacheline anyway.
>
>> +	spinlock_t read_latency_lock;
>> +	u64 total_reads;
>> +	u64 read_latency_sum;
>> +
>> +	struct percpu_counter write_latency_sq_sum;
>> +	atomic64_t write_latency_min;
>> +	atomic64_t write_latency_max;
>> +	spinlock_t write_latency_lock;
>> +	u64 total_writes;
>> +	u64 write_latency_sum;
>>   };
>>  =20
>>   extern int ceph_metric_init(struct ceph_client_metric *m);
>> @@ -27,4 +41,13 @@ static inline void ceph_update_cap_mis(struct ceph_=
client_metric *m)
>>   {
>>   	percpu_counter_inc(&m->i_caps_mis);
>>   }
>> +
>> +extern void ceph_update_read_latency(struct ceph_client_metric *m,
>> +				     unsigned long r_start,
>> +				     unsigned long r_end,
>> +				     int rc);
>> +extern void ceph_update_write_latency(struct ceph_client_metric *m,
>> +				      unsigned long r_start,
>> +				      unsigned long r_end,
>> +				      int rc);
>>   #endif /* _FS_CEPH_MDS_METRIC_H */
>> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_=
client.h
>> index 9d9f745..02ff3a3 100644
>> --- a/include/linux/ceph/osd_client.h
>> +++ b/include/linux/ceph/osd_client.h
>> @@ -213,6 +213,7 @@ struct ceph_osd_request {
>>   	/* internal */
>>   	unsigned long r_stamp;                /* jiffies, send or check tim=
e */
>>   	unsigned long r_start_stamp;          /* jiffies */
>> +	unsigned long r_end_stamp;            /* jiffies */
>>   	int r_attempts;
>>   	u32 r_map_dne_bound;
>>  =20
>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>> index 998e26b..28e33e0 100644
>> --- a/net/ceph/osd_client.c
>> +++ b/net/ceph/osd_client.c
>> @@ -2389,6 +2389,8 @@ static void finish_request(struct ceph_osd_reque=
st *req)
>>   	WARN_ON(lookup_request_mc(&osdc->map_checks, req->r_tid));
>>   	dout("%s req %p tid %llu\n", __func__, req, req->r_tid);
>>  =20
>> +	req->r_end_stamp =3D jiffies;
>> +
>>   	if (req->r_osd)
>>   		unlink_request(req->r_osd, req);
>>   	atomic_dec(&osdc->num_requests);


