Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506C3250DC5
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Aug 2020 02:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgHYAn7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Aug 2020 20:43:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43868 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726090AbgHYAn7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 24 Aug 2020 20:43:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598316236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dixAX1xeGIhFs4MuUIqOFSnm6LBgPuyG/1UgrX4Sg70=;
        b=IhXqHZMMNIFf5ydLBRHwJUKQW0zqQsZuChubFn0sr5rg9E1nihVWnfQYJ6JzazCiV7CDKB
        mz1G+sGtlGCeDTkKqJcNhFng0QE0grvJDIj/6GsEQZyRkGUpsWAv5K1/JQTfFYrDVjY/7k
        Q3iErD45VZtddjZ6nFHezSPCq+nmujc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-LCDG5_uzN3-sx7XKtArZsw-1; Mon, 24 Aug 2020 20:43:51 -0400
X-MC-Unique: LCDG5_uzN3-sx7XKtArZsw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84A1D10ABDA5;
        Tue, 25 Aug 2020 00:43:50 +0000 (UTC)
Received: from [10.72.12.50] (ovpn-12-50.pek2.redhat.com [10.72.12.50])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DEF0348B8;
        Tue, 25 Aug 2020 00:43:48 +0000 (UTC)
Subject: Re: [PATCH v2] ceph: metrics for opened files, pinned caps and opened
 inodes
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20200824070135.2195228-1-xiubli@redhat.com>
 <5ae8eb55460be567ab3e8fb42ff93df30c05ac2a.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <e34df1d5-02b2-4cd5-61a2-aaf185b2cf46@redhat.com>
Date:   Tue, 25 Aug 2020 08:43:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <5ae8eb55460be567ab3e8fb42ff93df30c05ac2a.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/8/24 22:39, Jeff Layton wrote:
> On Mon, 2020-08-24 at 03:01 -0400, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> In client for each inode, it may have many opened files and may
>> have been pinned in more than one MDS servers. And some inodes
>> are idle, which have no any opened files.
>>
>> This patch will show these metrics in the debugfs, likes:
>>
>> item                               total
>> -----------------------------------------
>> opened files  / total inodes       14 / 5
>> pinned i_caps / total inodes       7  / 5
>> opened inodes / total inodes       3  / 5
>>
>> Will send these metrics to ceph, which will be used by the `fs top`,
>> later.
>>
>> URL: https://tracker.ceph.com/issues/47005
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> Changed in V2:
>> - Add number of inodes that have opened files.
>> - Remove the dir metrics and fold into files.
>>
>>
>>   fs/ceph/caps.c    | 27 +++++++++++++++++++++++++--
>>   fs/ceph/debugfs.c | 11 +++++++++++
>>   fs/ceph/file.c    |  5 +++--
>>   fs/ceph/inode.c   |  7 +++++++
>>   fs/ceph/metric.c  | 14 ++++++++++++++
>>   fs/ceph/metric.h  |  7 +++++++
>>   fs/ceph/super.h   |  1 +
>>   7 files changed, 68 insertions(+), 4 deletions(-)
>>
> This doesn't compile. See inline below...

Sorry,I forgot one patch, will post it again.

Thanks

BRs


>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index ad69c411afba..6916def40b3d 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -4283,13 +4283,23 @@ void __ceph_touch_fmode(struct ceph_inode_info *ci,
>>   
>>   void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
>>   {
>> -	int i;
>> +	struct ceph_mds_client *mdsc = ceph_ci_to_mdsc(ci);
>
> fs/ceph/caps.c:4287:33: error: implicit declaration of function ‘ceph_ci_to_mdsc’ [-Werror=implicit-function-declaration]
>
>
>>   	int bits = (fmode << 1) | 1;
>> +	int i;
>> +
>> +	if (count == 1)
>> +		atomic64_inc(&mdsc->metric.opened_files);
>> +
>>   	spin_lock(&ci->i_ceph_lock);
>>   	for (i = 0; i < CEPH_FILE_MODE_BITS; i++) {
>>   		if (bits & (1 << i))
>>   			ci->i_nr_by_mode[i] += count;
>>   	}
>> +
>> +	if (!ci->is_opened && fmode) {
>> +		ci->is_opened = true;
>> +		percpu_counter_inc(&mdsc->metric.opened_inodes);
>> +	}
>>   	spin_unlock(&ci->i_ceph_lock);
>>   }
>>   
>> @@ -4300,15 +4310,28 @@ void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
>>    */
>>   void ceph_put_fmode(struct ceph_inode_info *ci, int fmode, int count)
>>   {
>> -	int i;
>> +	struct ceph_mds_client *mdsc = ceph_ci_to_mdsc(ci);
>>   	int bits = (fmode << 1) | 1;
>> +	bool empty = true;
>> +	int i;
>> +
>> +	if (count == 1)
>> +		atomic64_dec(&mdsc->metric.opened_files);
>> +
>>   	spin_lock(&ci->i_ceph_lock);
>>   	for (i = 0; i < CEPH_FILE_MODE_BITS; i++) {
>>   		if (bits & (1 << i)) {
>>   			BUG_ON(ci->i_nr_by_mode[i] < count);
>>   			ci->i_nr_by_mode[i] -= count;
>> +			if (ci->i_nr_by_mode[i] && i) /* Skip the pin ref */
>> +				empty = false;
>>   		}
>>   	}
>> +
>> +	if (ci->is_opened && empty && fmode) {
>> +		ci->is_opened = false;
>> +		percpu_counter_dec(&mdsc->metric.opened_inodes);
>> +	}
>>   	spin_unlock(&ci->i_ceph_lock);
>>   }
>>   
>> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
>> index 97539b497e4c..9efd3982230d 100644
>> --- a/fs/ceph/debugfs.c
>> +++ b/fs/ceph/debugfs.c
>> @@ -148,6 +148,17 @@ static int metric_show(struct seq_file *s, void *p)
>>   	int nr_caps = 0;
>>   	s64 total, sum, avg, min, max, sq;
>>   
>> +	sum = percpu_counter_sum(&m->total_inodes);
>> +	seq_printf(s, "item                               total\n");
>> +	seq_printf(s, "------------------------------------------\n");
>> +	seq_printf(s, "%-35s%lld / %lld\n", "opened files  / total inodes",
>> +		   atomic64_read(&m->opened_files), sum);
>> +	seq_printf(s, "%-35s%lld / %lld\n", "pinned i_caps / total inodes",
>> +		   atomic64_read(&m->total_caps), sum);
>> +	seq_printf(s, "%-35s%lld / %lld\n", "opened inodes / total inodes",
>> +		   percpu_counter_sum(&m->opened_inodes), sum);
>> +
>> +	seq_printf(s, "\n");
>>   	seq_printf(s, "item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)\n");
>>   	seq_printf(s, "-----------------------------------------------------------------------------------\n");
>>   
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index c788cce7885b..6e2aed0f7f75 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -211,8 +211,9 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
>>   	BUG_ON(inode->i_fop->release != ceph_release);
>>   
>>   	if (isdir) {
>> -		struct ceph_dir_file_info *dfi =
>> -			kmem_cache_zalloc(ceph_dir_file_cachep, GFP_KERNEL);
>> +		struct ceph_dir_file_info *dfi;
>> +
>> +		dfi = kmem_cache_zalloc(ceph_dir_file_cachep, GFP_KERNEL);
>>   		if (!dfi)
>>   			return -ENOMEM;
>>   
>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>> index 39b1007903d9..1bedbe4737ec 100644
>> --- a/fs/ceph/inode.c
>> +++ b/fs/ceph/inode.c
>> @@ -426,6 +426,7 @@ static int ceph_fill_fragtree(struct inode *inode,
>>    */
>>   struct inode *ceph_alloc_inode(struct super_block *sb)
>>   {
>> +	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(sb);
> fs/ceph/inode.c:428:33: error: implicit declaration of function ‘ceph_sb_to_mdsc’; did you mean ‘ceph_sb_to_client’? [-Werror=implicit-function-declaration]
>
>
>>   	struct ceph_inode_info *ci;
>>   	int i;
>>   
>> @@ -485,6 +486,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
>>   	ci->i_last_rd = ci->i_last_wr = jiffies - 3600 * HZ;
>>   	for (i = 0; i < CEPH_FILE_MODE_BITS; i++)
>>   		ci->i_nr_by_mode[i] = 0;
>> +	ci->is_opened = false;
>>   
>>   	mutex_init(&ci->i_truncate_mutex);
>>   	ci->i_truncate_seq = 0;
>> @@ -525,6 +527,8 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
>>   
>>   	ci->i_meta_err = 0;
>>   
>> +	percpu_counter_inc(&mdsc->metric.total_inodes);
>> +
>>   	return &ci->vfs_inode;
>>   }
>>   
>> @@ -539,6 +543,7 @@ void ceph_free_inode(struct inode *inode)
>>   void ceph_evict_inode(struct inode *inode)
>>   {
>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>> +	struct ceph_mds_client *mdsc = ceph_inode_to_mdsc(inode);
>>   	struct ceph_inode_frag *frag;
>>   	struct rb_node *n;
>>   
>> @@ -592,6 +597,8 @@ void ceph_evict_inode(struct inode *inode)
>>   
>>   	ceph_put_string(rcu_dereference_raw(ci->i_layout.pool_ns));
>>   	ceph_put_string(rcu_dereference_raw(ci->i_cached_layout.pool_ns));
>> +
>> +	percpu_counter_dec(&mdsc->metric.total_inodes);
>>   }
>>   
>>   static inline blkcnt_t calc_inode_blocks(u64 size)
>> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
>> index 2466b261fba2..c7c6fe6a383b 100644
>> --- a/fs/ceph/metric.c
>> +++ b/fs/ceph/metric.c
>> @@ -192,11 +192,23 @@ int ceph_metric_init(struct ceph_client_metric *m)
>>   	m->total_metadatas = 0;
>>   	m->metadata_latency_sum = 0;
>>   
>> +	atomic64_set(&m->opened_files, 0);
>> +	ret = percpu_counter_init(&m->opened_inodes, 0, GFP_KERNEL);
>> +	if (ret)
>> +		goto err_opened_inodes;
>> +	ret = percpu_counter_init(&m->opened_inodes, 0, GFP_KERNEL);
>> +	if (ret)
>> +		goto err_total_inodes;
>> +
>>   	m->session = NULL;
>>   	INIT_DELAYED_WORK(&m->delayed_work, metric_delayed_work);
>>   
>>   	return 0;
>>   
>> +err_total_inodes:
>> +	percpu_counter_destroy(&m->opened_inodes);
>> +err_opened_inodes:
>> +	percpu_counter_destroy(&m->i_caps_mis);
>>   err_i_caps_mis:
>>   	percpu_counter_destroy(&m->i_caps_hit);
>>   err_i_caps_hit:
>> @@ -212,6 +224,8 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
>>   	if (!m)
>>   		return;
>>   
>> +	percpu_counter_destroy(&m->total_inodes);
>> +	percpu_counter_destroy(&m->opened_inodes);
>>   	percpu_counter_destroy(&m->i_caps_mis);
>>   	percpu_counter_destroy(&m->i_caps_hit);
>>   	percpu_counter_destroy(&m->d_lease_mis);
>> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
>> index 1d0959d669d7..710f3f1dceab 100644
>> --- a/fs/ceph/metric.h
>> +++ b/fs/ceph/metric.h
>> @@ -115,6 +115,13 @@ struct ceph_client_metric {
>>   	ktime_t metadata_latency_min;
>>   	ktime_t metadata_latency_max;
>>   
>> +	/* The total number of directories and files that are opened */
>> +	atomic64_t opened_files;
>> +
>> +	/* The total number of inodes that have opened files or directories */
>> +	struct percpu_counter opened_inodes;
>> +	struct percpu_counter total_inodes;
>> +
>>   	struct ceph_mds_session *session;
>>   	struct delayed_work delayed_work;  /* delayed work */
>>   };
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index 476d182c2ff0..852b755e2224 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -387,6 +387,7 @@ struct ceph_inode_info {
>>   	unsigned long i_last_rd;
>>   	unsigned long i_last_wr;
>>   	int i_nr_by_mode[CEPH_FILE_MODE_BITS];  /* open file counts */
>> +	bool is_opened; /* has opened files or directors */
>>   
>>   	struct mutex i_truncate_mutex;
>>   	u32 i_truncate_seq;        /* last truncate to smaller size */


