Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68A49140128
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Jan 2020 01:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733281AbgAQAzq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Jan 2020 19:55:46 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54972 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726892AbgAQAzp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 19:55:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579222543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wwwsiNzNu7QpUTjN9Owtq+eJfaGF6Mmw45yzBds4G7M=;
        b=Ti0sJF9UsgEAUL+ywBxwQfvqSE6wj8ZKK2/15YFWXDerJqmZPiABinDq3YgCb6NLitEvAz
        zfiovzqZsnJkP/vvpwxrRuk2CXDy0AdoowHDzZRQze1ColgxKrhK3295EdeW2PlKKPZNPx
        HabdHUY13mQZP7wAG7592swgGeO+ibg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-3C9SEp-SN_SNt6VnuC1VvA-1; Thu, 16 Jan 2020 19:55:41 -0500
X-MC-Unique: 3C9SEp-SN_SNt6VnuC1VvA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45EB718A6EC0;
        Fri, 17 Jan 2020 00:55:40 +0000 (UTC)
Received: from [10.72.12.49] (ovpn-12-49.pek2.redhat.com [10.72.12.49])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DBA81C947;
        Fri, 17 Jan 2020 00:55:35 +0000 (UTC)
Subject: Re: [PATCH v3 4/8] ceph: add global write latency metric support
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20200115034444.14304-1-xiubli@redhat.com>
 <20200115034444.14304-5-xiubli@redhat.com>
 <18a2177615ab26ff546601a1a5baae1798608bdd.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <fdf2cb36-1774-1d70-1d37-a167f908e35e@redhat.com>
Date:   Fri, 17 Jan 2020 08:55:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <18a2177615ab26ff546601a1a5baae1798608bdd.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/1/16 22:14, Jeff Layton wrote:
> On Tue, 2020-01-14 at 22:44 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> item          total       sum_lat(us)     avg_lat(us)
>> -----------------------------------------------------
>> write         222         5287750000      23818693
>>
>> URL: https://tracker.ceph.com/issues/43215
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/addr.c                  | 23 +++++++++++++++++++++--
>>   fs/ceph/debugfs.c               |  8 ++++++++
>>   fs/ceph/file.c                  |  9 +++++++++
>>   fs/ceph/mds_client.c            | 20 ++++++++++++++++++++
>>   fs/ceph/mds_client.h            |  6 ++++++
>>   include/linux/ceph/osd_client.h |  3 ++-
>>   net/ceph/osd_client.c           |  9 ++++++++-
>>   7 files changed, 74 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index 2a32f731f92a..b667ddaa6623 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -598,12 +598,15 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>>   	loff_t page_off = page_offset(page);
>>   	int err, len = PAGE_SIZE;
>>   	struct ceph_writeback_ctl ceph_wbc;
>> +	struct ceph_client_metric *metric;
>> +	s64 latency;
>>   
>>   	dout("writepage %p idx %lu\n", page, page->index);
>>   
>>   	inode = page->mapping->host;
>>   	ci = ceph_inode(inode);
>>   	fsc = ceph_inode_to_client(inode);
>> +	metric = &fsc->mdsc->metric;
>>   
>>   	/* verify this is a writeable snap context */
>>   	snapc = page_snap_context(page);
>> @@ -645,7 +648,11 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>>   				   &ci->i_layout, snapc, page_off, len,
>>   				   ceph_wbc.truncate_seq,
>>   				   ceph_wbc.truncate_size,
>> -				   &inode->i_mtime, &page, 1);
>> +				   &inode->i_mtime, &page, 1,
>> +				   &latency);
>> +	if (latency)
>> +		ceph_mdsc_update_write_latency(metric, latency);
>> +
>>   	if (err < 0) {
>>   		struct writeback_control tmp_wbc;
>>   		if (!wbc)
>> @@ -707,6 +714,8 @@ static void writepages_finish(struct ceph_osd_request *req)
>>   {
>>   	struct inode *inode = req->r_inode;
>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>> +	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>> +	struct ceph_client_metric *metric = &fsc->mdsc->metric;
>>   	struct ceph_osd_data *osd_data;
>>   	struct page *page;
>>   	int num_pages, total_pages = 0;
>> @@ -714,7 +723,6 @@ static void writepages_finish(struct ceph_osd_request *req)
>>   	int rc = req->r_result;
>>   	struct ceph_snap_context *snapc = req->r_snapc;
>>   	struct address_space *mapping = inode->i_mapping;
>> -	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>>   	bool remove_page;
>>   
>>   	dout("writepages_finish %p rc %d\n", inode, rc);
>> @@ -783,6 +791,11 @@ static void writepages_finish(struct ceph_osd_request *req)
>>   			     ceph_sb_to_client(inode->i_sb)->wb_pagevec_pool);
>>   	else
>>   		kfree(osd_data->pages);
>> +
>> +	if (!rc) {
>> +		s64 latency = jiffies - req->r_start_stamp;
>> +		ceph_mdsc_update_write_latency(metric, latency);
>> +	}
>>   	ceph_osdc_put_request(req);
>>   }
>>   
>> @@ -1675,6 +1688,7 @@ int ceph_uninline_data(struct file *filp, struct page *locked_page)
>>   	struct inode *inode = file_inode(filp);
>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>>   	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>> +	struct ceph_client_metric *metric = &fsc->mdsc->metric;
>>   	struct ceph_osd_request *req;
>>   	struct page *page = NULL;
>>   	u64 len, inline_version;
>> @@ -1786,6 +1800,11 @@ int ceph_uninline_data(struct file *filp, struct page *locked_page)
>>   	err = ceph_osdc_start_request(&fsc->client->osdc, req, false);
>>   	if (!err)
>>   		err = ceph_osdc_wait_request(&fsc->client->osdc, req);
>> +
>> +	if (!err || err == -ETIMEDOUT) {
>> +		s64 latency = jiffies - req->r_start_stamp;
>> +		ceph_mdsc_update_write_latency(metric, latency);
>> +	}
>>   out_put:
>>   	ceph_osdc_put_request(req);
>>   	if (err == -ECANCELED)
>> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
>> index 8200bf025ccd..3fdb15af0a83 100644
>> --- a/fs/ceph/debugfs.c
>> +++ b/fs/ceph/debugfs.c
>> @@ -142,6 +142,14 @@ static int metric_show(struct seq_file *s, void *p)
>>   	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "read",
>>   		   total, sum / NSEC_PER_USEC, avg / NSEC_PER_USEC);
>>   
>> +	spin_lock(&mdsc->metric.write_lock);
>> +	total = atomic64_read(&mdsc->metric.total_writes),
>> +	sum = timespec64_to_ns(&mdsc->metric.write_latency_sum);
>> +	spin_unlock(&mdsc->metric.write_lock);
>> +	avg = total ? sum / total : 0;
>> +	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "write",
>> +		   total, sum / NSEC_PER_USEC, avg / NSEC_PER_USEC);
>> +
>
>>   	seq_printf(s, "\n");
>>   	seq_printf(s, "item          total           miss            hit\n");
>>   	seq_printf(s, "-------------------------------------------------\n");
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 797d4d224223..70530ac798ac 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -822,6 +822,8 @@ static void ceph_aio_complete_req(struct ceph_osd_request *req)
>>   			op = &req->r_ops[i];
>>   			if (op->op == CEPH_OSD_OP_READ)
>>   				ceph_mdsc_update_read_latency(metric, latency);
>> +			else if (op->op == CEPH_OSD_OP_WRITE && rc != -ENOENT)
>> +				ceph_mdsc_update_write_latency(metric, latency);
>>   		}
>>   	}
>>   
>> @@ -1075,6 +1077,8 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
>>   
>>   			if (!write)
>>   				ceph_mdsc_update_read_latency(metric, latency);
>> +			else if (write && ret != -ENOENT)
>> +				ceph_mdsc_update_write_latency(metric, latency);
>>   		}
>>   
>>   		size = i_size_read(inode);
>> @@ -1163,6 +1167,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
>>   	struct inode *inode = file_inode(file);
>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>>   	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>> +	struct ceph_client_metric *metric = &fsc->mdsc->metric;
>>   	struct ceph_vino vino;
>>   	struct ceph_osd_request *req;
>>   	struct page **pages;
>> @@ -1248,6 +1253,10 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
>>   		if (!ret)
>>   			ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
>>   
>> +		if (!ret || ret == -ETIMEDOUT) {
>> +			s64 latency = jiffies - req->r_start_stamp;
>> +			ceph_mdsc_update_write_latency(metric, latency);
>> +		}
>>   out:
>>   		ceph_osdc_put_request(req);
>>   		if (ret != 0) {
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index dc2cda55a5a5..2569f9303c0c 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -4112,6 +4112,22 @@ void ceph_mdsc_update_read_latency(struct ceph_client_metric *m,
>>   	spin_unlock(&m->read_lock);
>>   }
>>   
>> +void ceph_mdsc_update_write_latency(struct ceph_client_metric *m,
>> +				    s64 latency)
>> +{
>> +	struct timespec64 ts;
>> +
>> +	if (!m)
>> +		return;
>> +
>> +	jiffies_to_timespec64(latency, &ts);
>> +
>> +	spin_lock(&m->write_lock);
>> +	atomic64_inc(&m->total_writes);
>> +	m->write_latency_sum = timespec64_add(m->write_latency_sum, ts);
>> +	spin_unlock(&m->write_lock);
>> +}
>> +
>>   /*
>>    * delayed work -- periodically trim expired leases, renew caps with mds
>>    */
>> @@ -4212,6 +4228,10 @@ static int ceph_mdsc_metric_init(struct ceph_client_metric *metric)
>>   	memset(&metric->read_latency_sum, 0, sizeof(struct timespec64));
>>   	atomic64_set(&metric->total_reads, 0);
>>   
>> +	spin_lock_init(&metric->write_lock);
>> +	memset(&metric->write_latency_sum, 0, sizeof(struct timespec64));
>> +	atomic64_set(&metric->total_writes, 0);
>> +
>>   	return 0;
>>   }
>>   
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index fee25b999c7c..0120357e7549 100644
>> --- a/fs/ceph/mds_client.h
>> +++ b/fs/ceph/mds_client.h
>> @@ -370,6 +370,10 @@ struct ceph_client_metric {
>>   	spinlock_t              read_lock;
>>   	atomic64_t		total_reads;
>>   	struct timespec64	read_latency_sum;
>> +
>> +	spinlock_t              write_lock;
>> +	atomic64_t		total_writes;
>> +	struct timespec64	write_latency_sum;
> Would percpu counters be better here? I mean it's not a _super_ high
> performance codepath, but it's nice when stats gathering has very little
> overhead. It'd take up a bit more space, but it's not that much, and
> there'd be no serialization between CPUs operating on different inodes.

Yeah, in the first version of this I was also thinking the same ting and 
was using the percpu counters.

I switched them to spin lock just in case that when calculating or 
sending them to MDS if only the "write_latency_sum" is updated without 
the "total_writes" get updated in time, it will not be very precise.

If this doesn't matter I will switch it back to use the percpu counters.

>
> To be clear, the latency you're measuring is request time to the OSD?

Yeah, it is.

The read/write are both about request latency to OSD and the metadata is 
to MDS.

>
>>   };
>>   
>>   /*
>> @@ -556,4 +560,6 @@ extern int ceph_trim_caps(struct ceph_mds_client *mdsc,
>>   
>>   extern void ceph_mdsc_update_read_latency(struct ceph_client_metric *m,
>>   					  s64 latency);
>> +extern void ceph_mdsc_update_write_latency(struct ceph_client_metric *m,
>> +					   s64 latency);
>>   #endif
>> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
>> index 43e4240d88e7..e73439d18f28 100644
>> --- a/include/linux/ceph/osd_client.h
>> +++ b/include/linux/ceph/osd_client.h
>> @@ -524,7 +524,8 @@ extern int ceph_osdc_writepages(struct ceph_osd_client *osdc,
>>   				u64 off, u64 len,
>>   				u32 truncate_seq, u64 truncate_size,
>>   				struct timespec64 *mtime,
>> -				struct page **pages, int nr_pages);
>> +				struct page **pages, int nr_pages,
>> +				s64 *latency);
>>   
>>   int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
>>   			u64 src_snapid, u64 src_version,
>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>> index 62eb758f2474..9f6833ab733c 100644
>> --- a/net/ceph/osd_client.c
>> +++ b/net/ceph/osd_client.c
>> @@ -5285,12 +5285,16 @@ int ceph_osdc_writepages(struct ceph_osd_client *osdc, struct ceph_vino vino,
>>   			 u64 off, u64 len,
>>   			 u32 truncate_seq, u64 truncate_size,
>>   			 struct timespec64 *mtime,
>> -			 struct page **pages, int num_pages)
>> +			 struct page **pages, int num_pages,
>> +			 s64 *latency)
>>   {
>>   	struct ceph_osd_request *req;
>>   	int rc = 0;
>>   	int page_align = off & ~PAGE_MASK;
>>   
>> +	if (latency)
>> +		*latency = 0;
>> +
>>   	req = ceph_osdc_new_request(osdc, layout, vino, off, &len, 0, 1,
>>   				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE,
>>   				    snapc, truncate_seq, truncate_size,
>> @@ -5308,6 +5312,9 @@ int ceph_osdc_writepages(struct ceph_osd_client *osdc, struct ceph_vino vino,
>>   	if (!rc)
>>   		rc = ceph_osdc_wait_request(osdc, req);
>>   
>> +	if (latency && (!rc || rc == -ETIMEDOUT))
>> +		*latency = jiffies - req->r_start_stamp;
>> +
> Are you concerned at all with scheduling delays? Note that you're doing
> the latency calculation here which occurs in the task that is woken by
> __complete_request. That won't necessarily wake up immediately on a busy
> machine, so this measurement will include that delay as well.

Yeah, I will be better we should only consider the latency for requests 
to OSD.


>
> I wonder if we ought to add a r_end_stamp field to the req instead, and
> grab jiffies in (e.g.) __complete_request. Then you could just fetch
> that out and do the math.

This sounds a good idea.


>
>>   	ceph_osdc_put_request(req);
>>   	if (rc == 0)
>>   		rc = len;
> Ditto here on my earlier comment in the earlier email. Let's just turn
> this into a ceph_osdc_writepages_start function and open-code the wait
> and latency calculation in writepage_nounlock().

Sure, will fix it.



