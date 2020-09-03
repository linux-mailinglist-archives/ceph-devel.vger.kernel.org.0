Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C014925C269
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Sep 2020 16:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgICOYC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Sep 2020 10:24:02 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48612 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728896AbgICOVP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 3 Sep 2020 10:21:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599142872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YPC0vmrw/c7NFQjl7S2KULkVJorDJYG86GyJeXr5f8w=;
        b=VTDWD31mBOuin3CLxiHZJUbRAQ83HAuk27YFBOr9KoJL3+1SKxbRPazfxHwMiuDXsrPeWe
        neqPKlVsCYf2re4nzbj3fA6CwP/ru6C7uoQywMHwQamJz7C0/ziUwwUAa0DiBWefW4h7aV
        YBPXdYMfy2vQIDx3U7Unk8j/h6Qb+gY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-TAOeQJFbOaq6HoFy9KyRGQ-1; Thu, 03 Sep 2020 10:21:06 -0400
X-MC-Unique: TAOeQJFbOaq6HoFy9KyRGQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99810873081;
        Thu,  3 Sep 2020 14:21:05 +0000 (UTC)
Received: from [10.72.12.50] (ovpn-12-50.pek2.redhat.com [10.72.12.50])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6987710013D9;
        Thu,  3 Sep 2020 14:21:03 +0000 (UTC)
Subject: Re: [PATCH v5 2/2] ceph: metrics for opened files, pinned caps and
 opened inodes
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20200903130140.799392-1-xiubli@redhat.com>
 <20200903130140.799392-3-xiubli@redhat.com>
 <6f51c4caa59e4ec02b5676f8363563f1e02b3776.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <4418a0cd-aded-40b0-c044-0ef1a402a46b@redhat.com>
Date:   Thu, 3 Sep 2020 22:20:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <6f51c4caa59e4ec02b5676f8363563f1e02b3776.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/9/3 22:16, Jeff Layton wrote:
> On Thu, 2020-09-03 at 09:01 -0400, xiubli@redhat.com wrote:
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
>>   fs/ceph/caps.c    | 38 ++++++++++++++++++++++++++++++++++++--
>>   fs/ceph/debugfs.c | 11 +++++++++++
>>   fs/ceph/file.c    |  5 +++--
>>   fs/ceph/inode.c   |  6 ++++++
>>   fs/ceph/metric.c  | 14 ++++++++++++++
>>   fs/ceph/metric.h  |  7 +++++++
>>   6 files changed, 77 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 0120fcb3503e..f09461fe569b 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -4283,13 +4283,30 @@ void __ceph_touch_fmode(struct ceph_inode_info *ci,
>>   
>>   void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
>>   {
>> -	int i;
>> +	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(ci->vfs_inode.i_sb);
>>   	int bits = (fmode << 1) | 1;
>> +	bool is_opened = false;
>> +	int i;
>> +
>> +	if (count == 1)
>> +		atomic64_inc(&mdsc->metric.opened_files);
>> +
>>   	spin_lock(&ci->i_ceph_lock);
>>   	for (i = 0; i < CEPH_FILE_MODE_BITS; i++) {
>>   		if (bits & (1 << i))
>>   			ci->i_nr_by_mode[i] += count;
>> +
>> +		/*
>> +		 * If any of the mode ref is larger than 1,
>> +		 * that means it has been already opened by
>> +		 * others. Just skip checking the PIN ref.
>> +		 */
>> +		if (i && ci->i_nr_by_mode[i] > 1)
>> +			is_opened = true;
>>   	}
>> +
>> +	if (!is_opened)
>> +		percpu_counter_inc(&mdsc->metric.opened_inodes);
>>   	spin_unlock(&ci->i_ceph_lock);
>>   }
>>   
>> @@ -4300,15 +4317,32 @@ void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
>>    */
>>   void ceph_put_fmode(struct ceph_inode_info *ci, int fmode, int count)
>>   {
>> -	int i;
>> +	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(ci->vfs_inode.i_sb);
>>   	int bits = (fmode << 1) | 1;
>> +	bool is_closed = true;
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
>>   		}
>> +
>> +		/*
>> +		 * If any of the mode ref is not 0 after
>> +		 * decreased, that means it is still opened
>> +		 * by others. Just skip checking the PIN ref.
>> +		 */
>> +		if (i && ci->i_nr_by_mode[i])
>> +			is_closed = false;
>>   	}
>> +
>> +	if (is_closed)
>> +		percpu_counter_dec(&mdsc->metric.opened_inodes);
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
>> index 29ee5f2e394a..c63ddf7e054b 100644
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
> ^^^
> Unrelated delta here? I'll plan to drop this hunk if there are no
> objections.
>
Yeah, sure. This should be introduced in a previous version and there 
has some other changes would depend on it, but that changes was removed 
later and this was forgot.

Thanks Jeff.


>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>> index 9210cd1e859d..f2764159e05b 100644
>> --- a/fs/ceph/inode.c
>> +++ b/fs/ceph/inode.c
>> @@ -426,6 +426,7 @@ static int ceph_fill_fragtree(struct inode *inode,
>>    */
>>   struct inode *ceph_alloc_inode(struct super_block *sb)
>>   {
>> +	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(sb);
>>   	struct ceph_inode_info *ci;
>>   	int i;
>>   
>> @@ -525,12 +526,17 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
>>   
>>   	ci->i_meta_err = 0;
>>   
>> +	percpu_counter_inc(&mdsc->metric.total_inodes);
>> +
>>   	return &ci->vfs_inode;
>>   }
>>   
>>   void ceph_free_inode(struct inode *inode)
>>   {
>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>> +	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
>> +
>> +	percpu_counter_dec(&mdsc->metric.total_inodes);
>>   
>>   	kfree(ci->i_symlink);
>>   	kmem_cache_free(ceph_inode_cachep, ci);
>> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
>> index 2466b261fba2..fee4c4778313 100644
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
>> +	ret = percpu_counter_init(&m->total_inodes, 0, GFP_KERNEL);
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


