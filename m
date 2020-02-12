Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91ADA15ABA3
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Feb 2020 16:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbgBLPBy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Feb 2020 10:01:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32175 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727231AbgBLPBy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Feb 2020 10:01:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581519711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g4hooXrtQf2G/RLhG1ZiSpBSbtk4wtHYEH4EZ0R4hZ0=;
        b=Ud1eOszNS7yEUpenU5M9f1zdjedIDzsOpIWOLiHo1zInrDcjIK7IZAgUXVu+EHQDwqz/QC
        2YB/GukaWD/krX8KIpqSiGNDSmhxqXpRQ+i1mVLsI0iLwFGVA+U/mqHCRw7thuLxH2pUqB
        EJm4Y6RQ4cu0TPsCLJI1n4XtbwQ0tt8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-1IdcxPNOOFuwU18Y-rmvTA-1; Wed, 12 Feb 2020 10:01:49 -0500
X-MC-Unique: 1IdcxPNOOFuwU18Y-rmvTA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA419801E67;
        Wed, 12 Feb 2020 15:01:48 +0000 (UTC)
Received: from [10.72.12.209] (ovpn-12-209.pek2.redhat.com [10.72.12.209])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F75189F3E;
        Wed, 12 Feb 2020 15:01:42 +0000 (UTC)
Subject: Re: [PATCH] ceph: fs add reconfiguring superblock parameters support
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20200212085454.35665-1-xiubli@redhat.com>
 <c2571e75d3fe3f37ea77c5b1acaa5e3dcc45cb2b.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <8fa89139-4774-65f7-fc48-e1ef368beb6e@redhat.com>
Date:   Wed, 12 Feb 2020 23:01:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <c2571e75d3fe3f37ea77c5b1acaa5e3dcc45cb2b.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/12 20:01, Jeff Layton wrote:
> On Wed, 2020-02-12 at 03:54 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This will enable the remount and reconfiguring superblock params
>> for the fs. Currently some mount options are not allowed to be
>> reconfigured.
>>
>> It will working like:
>> $ mount.ceph :/ /mnt/cephfs -o remount,mount_timeout=100
>>
>> URL:https://tracker.ceph.com/issues/44071
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   block/bfq-cgroup.c           |   1 +
>>   drivers/block/rbd.c          |   2 +-
>>   fs/ceph/caps.c               |   2 +
>>   fs/ceph/mds_client.c         |   5 +-
>>   fs/ceph/super.c              | 126 +++++++++++++++++++++++++++++------
>>   fs/ceph/super.h              |   2 +
>>   include/linux/ceph/libceph.h |   4 +-
>>   net/ceph/ceph_common.c       |  83 ++++++++++++++++++++---
>>   8 files changed, 192 insertions(+), 33 deletions(-)
>>
>> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
>> index e1419edde2ec..b3d42200182e 100644
>> --- a/block/bfq-cgroup.c
>> +++ b/block/bfq-cgroup.c
>> @@ -12,6 +12,7 @@
>>   #include <linux/ioprio.h>
>>   #include <linux/sbitmap.h>
>>   #include <linux/delay.h>
>> +#include <linux/rbtree.h>
>>   
>>   #include "bfq-iosched.h"
>>   
>> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
>> index 4e494d5600cc..470de27cf809 100644
>> --- a/drivers/block/rbd.c
>> +++ b/drivers/block/rbd.c
>> @@ -6573,7 +6573,7 @@ static int rbd_add_parse_args(const char *buf,
>>   	*(snap_name + len) = '\0';
>>   	pctx.spec->snap_name = snap_name;
>>   
>> -	pctx.copts = ceph_alloc_options();
>> +	pctx.copts = ceph_alloc_options(NULL);
>>   	if (!pctx.copts)
>>   		goto out_mem;
>>   
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index b4f122eb74bb..020f83186f94 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -491,10 +491,12 @@ static void __cap_set_timeouts(struct ceph_mds_client *mdsc,
>>   {
>>   	struct ceph_mount_options *opt = mdsc->fsc->mount_options;
>>   
>> +	spin_lock(&opt->ceph_opt_lock);
>>   	ci->i_hold_caps_min = round_jiffies(jiffies +
>>   					    opt->caps_wanted_delay_min * HZ);
>>   	ci->i_hold_caps_max = round_jiffies(jiffies +
>>   					    opt->caps_wanted_delay_max * HZ);
>> +	spin_unlock(&opt->ceph_opt_lock);
>>   	dout("__cap_set_timeouts %p min %lu max %lu\n", &ci->vfs_inode,
>>   	     ci->i_hold_caps_min - jiffies, ci->i_hold_caps_max - jiffies);
>>   }
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 376e7cf1685f..451c3727cd0b 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -2099,6 +2099,7 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
>>   	struct ceph_inode_info *ci = ceph_inode(dir);
>>   	struct ceph_mds_reply_info_parsed *rinfo = &req->r_reply_info;
>>   	struct ceph_mount_options *opt = req->r_mdsc->fsc->mount_options;
>> +	unsigned int max_readdir = opt->max_readdir;
>>   	size_t size = sizeof(struct ceph_mds_reply_dir_entry);
>>   	unsigned int num_entries;
>>   	int order;
>> @@ -2107,7 +2108,7 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
>>   	num_entries = ci->i_files + ci->i_subdirs;
>>   	spin_unlock(&ci->i_ceph_lock);
>>   	num_entries = max(num_entries, 1U);
>> -	num_entries = min(num_entries, opt->max_readdir);
>> +	num_entries = min(num_entries, max_readdir);
>>   
>>   	order = get_order(size * num_entries);
>>   	while (order >= 0) {
>> @@ -2122,7 +2123,7 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
>>   		return -ENOMEM;
>>   
>>   	num_entries = (PAGE_SIZE << order) / size;
>> -	num_entries = min(num_entries, opt->max_readdir);
>> +	num_entries = min(num_entries, max_readdir);
>>   
>>   	rinfo->dir_buf_size = PAGE_SIZE << order;
>>   	req->r_num_caps = num_entries + 1;
>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> index 9a21054059f2..8df506dd9039 100644
>> --- a/fs/ceph/super.c
>> +++ b/fs/ceph/super.c
>> @@ -1175,7 +1175,57 @@ static void ceph_free_fc(struct fs_context *fc)
>>   
>>   static int ceph_reconfigure_fc(struct fs_context *fc)
>>   {
>> -	sync_filesystem(fc->root->d_sb);
>> +	struct super_block *sb = fc->root->d_sb;
>> +	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
>> +	struct ceph_mount_options *fsopt = fsc->mount_options;
>> +	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
>> +	struct ceph_mount_options *new_fsopt = pctx->opts;
>> +	int ret;
>> +
>> +	sync_filesystem(sb);
>> +
>> +	ret = ceph_reconfigure_copts(fc, pctx->copts, fsc->client->options);
>> +	if (ret)
>> +		return ret;
>> +
>> +	if (new_fsopt->snapdir_name != fsopt->snapdir_name)
>> +		return invalf(fc, "ceph: reconfiguration of snapdir_name not allowed");
>> +
>> +	if (new_fsopt->mds_namespace != fsopt->mds_namespace)
>> +		return invalf(fc, "ceph: reconfiguration of mds_namespace not allowed");
>> +
>> +	if (new_fsopt->wsize != fsopt->wsize)
>> +		return invalf(fc, "ceph: reconfiguration of wsize not allowed");
>> +	if (new_fsopt->rsize != fsopt->rsize)
>> +		return invalf(fc, "ceph: reconfiguration of rsize not allowed");
>> +	if (new_fsopt->rasize != fsopt->rasize)
>> +		return invalf(fc, "ceph: reconfiguration of rasize not allowed");
>> +
> Odd. I would think the wsize, rsize and rasize are things you _could_
> reconfigure at remount time.

There has some race for the wsize,


>
> In any case, I agree with Ilya. Not everything can be changed on a
> remount. It'd be best to identify some small subset of mount options
> that you do need to allow to be changed, and ensure we can do that.

Yeah, I have disabled some already which may be racing when changing 
them in remount.

Will disable the low level ones and some others in next version.


>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index 2acb09980432..ad44b98f3c3b 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -95,6 +95,8 @@ struct ceph_mount_options {
>>   	char *mds_namespace;  /* default NULL */
>>   	char *server_path;    /* default  "/" */
>>   	char *fscache_uniq;   /* default NULL */
>> +
>> +	spinlock_t ceph_opt_lock;
> I'm not sure we really need an extra lock around these fields,
> particularly if you're intending to only allow a few different things to
> be changed at remount.

This will only protect the "fsopt->caps_wanted_delay_min" and 
"fsopt->caps_wanted_delay_min", just in case we are changing them both 
which may be racing with __cap_set_timeouts().

For example:

The old range is [40, 60] and if the new range is [10, 30], we may hit 
the [i_hold_caps_min, i_hold_caps_max] are set as [40, 30].

Thanks,

BRs


