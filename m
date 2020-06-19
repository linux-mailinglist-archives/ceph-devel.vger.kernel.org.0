Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFA31FFF56
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Jun 2020 02:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbgFSAiD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 18 Jun 2020 20:38:03 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34437 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725912AbgFSAiC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 18 Jun 2020 20:38:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592527081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3vWv4vTEt/EGvAmDLNnjqiG67fZuVeWRt/eokd1Uhq0=;
        b=E2Qhm1bn0J2xuBSOI4xDAJpXvJCCI2lCgLFgzJ6Ew2lmk7Ql8gKRFPO95UBOXpVmb0nVM3
        3Y3fgxayitkSis3XvimUYmuCpBDJQcc5YtQ/pR0SHFDFDEeFJ1NTzThAcJ9RHqPWkpmcS5
        uf8dE0NDAeS02SyjCyJu+gms9+QI4tk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-ftVKtOZWPtuUvWvlinScjA-1; Thu, 18 Jun 2020 20:37:55 -0400
X-MC-Unique: ftVKtOZWPtuUvWvlinScjA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F8BD1800D4A;
        Fri, 19 Jun 2020 00:37:54 +0000 (UTC)
Received: from [10.72.13.235] (ovpn-13-235.pek2.redhat.com [10.72.13.235])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 547E11C4;
        Fri, 19 Jun 2020 00:37:52 +0000 (UTC)
Subject: Re: [PATCH v2 2/5] ceph: periodically send perf metrics to ceph
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <1592481599-7851-1-git-send-email-xiubli@redhat.com>
 <1592481599-7851-3-git-send-email-xiubli@redhat.com>
 <0b035117f68e00be64569021e10e202371589205.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f15a5885-3a9b-f308-bb5f-585f14e8ad19@redhat.com>
Date:   Fri, 19 Jun 2020 08:37:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <0b035117f68e00be64569021e10e202371589205.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/6/18 22:42, Jeff Layton wrote:
> On Thu, 2020-06-18 at 07:59 -0400, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This will send the caps/read/write/metadata metrics to any available
>> MDS only once per second as default, which will be the same as the
>> userland client, or every metric_send_interval seconds, which is a
>> module parameter.
>>
>> URL: https://tracker.ceph.com/issues/43215
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c         |   3 +
>>   fs/ceph/metric.c             | 134 +++++++++++++++++++++++++++++++++++++++++++
>>   fs/ceph/metric.h             |  78 +++++++++++++++++++++++++
>>   fs/ceph/super.c              |  49 ++++++++++++++++
>>   fs/ceph/super.h              |   2 +
>>   include/linux/ceph/ceph_fs.h |   1 +
>>   6 files changed, 267 insertions(+)
>>
>>
> I think 3/5 needs to moved ahead of this one or folded into it, as we'll
> have a temporary regression otherwise.
>
>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> index c9784eb1..5f409dd 100644
>> --- a/fs/ceph/super.c
>> +++ b/fs/ceph/super.c
>> @@ -27,6 +27,9 @@
>>   #include <linux/ceph/auth.h>
>>   #include <linux/ceph/debugfs.h>
>>   
>> +static DEFINE_MUTEX(ceph_fsc_lock);
>> +static LIST_HEAD(ceph_fsc_list);
>> +
>>   /*
>>    * Ceph superblock operations
>>    *
>> @@ -691,6 +694,10 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
>>   	if (!fsc->wb_pagevec_pool)
>>   		goto fail_cap_wq;
>>   
>> +	mutex_lock(&ceph_fsc_lock);
>> +	list_add_tail(&fsc->list, &ceph_fsc_list);
>> +	mutex_unlock(&ceph_fsc_lock);
>> +
>>   	return fsc;
>>   
>>   fail_cap_wq:
>> @@ -717,6 +724,10 @@ static void destroy_fs_client(struct ceph_fs_client *fsc)
>>   {
>>   	dout("destroy_fs_client %p\n", fsc);
>>   
>> +	mutex_lock(&ceph_fsc_lock);
>> +	list_del(&fsc->list);
>> +	mutex_unlock(&ceph_fsc_lock);
>> +
>>   	ceph_mdsc_destroy(fsc);
>>   	destroy_workqueue(fsc->inode_wq);
>>   	destroy_workqueue(fsc->cap_wq);
>> @@ -1282,6 +1293,44 @@ static void __exit exit_ceph(void)
>>   	destroy_caches();
>>   }
>>   
>> +static int param_set_metric_interval(const char *val, const struct kernel_param *kp)
>> +{
>> +	struct ceph_fs_client *fsc;
>> +	unsigned int interval;
>> +	int ret;
>> +
>> +	ret = kstrtouint(val, 0, &interval);
>> +	if (ret < 0) {
>> +		pr_err("Failed to parse metric interval '%s'\n", val);
>> +		return ret;
>> +	}
>> +
>> +	if (interval > 5) {
>> +		pr_err("Invalid metric interval %u\n", interval);
>> +		return -EINVAL;
>> +	}
>> +
> Why do we want to reject an interval larger than 5s? Is that problematic
> for some reason?

IMO, a larger interval doesn't make much sense, to limit the interval 
value in 5s to make sure that the ceph side could show the client real 
metrics in time. Is this okay ? Or should we use a larger limit ?


> In any case, it would be good to replace this with a
> #defined constant that describes what that value represents.

Sure, I will add one macro in next version.

Thanks,

>> +	metric_send_interval = interval;
>> +
>> +	// wake up all the mds clients
>> +	mutex_lock(&ceph_fsc_lock);
>> +	list_for_each_entry(fsc, &ceph_fsc_list, list) {
>> +		metric_schedule_delayed(&fsc->mdsc->metric);
>> +	}
>> +	mutex_unlock(&ceph_fsc_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct kernel_param_ops param_ops_metric_interval = {
>> +	.set = param_set_metric_interval,
>> +	.get = param_get_uint,
>> +};
>> +
>> +unsigned int metric_send_interval = 1;
>> +module_param_cb(metric_send_interval, &param_ops_metric_interval, &metric_send_interval, 0644);
>> +MODULE_PARM_DESC(metric_send_interval, "Interval (in seconds) of sending perf metric to ceph cluster, valid values are 0~5, 0 means disabled (default: 1)");
>> +
>>   module_init(init_ceph);
>>   module_exit(exit_ceph);
>>   
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index 5a6cdd3..05edc9a 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -101,6 +101,8 @@ struct ceph_mount_options {
>>   struct ceph_fs_client {
>>   	struct super_block *sb;
>>   
>> +	struct list_head list;
>> +
>>   	struct ceph_mount_options *mount_options;
>>   	struct ceph_client *client;
>>   
>> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
>> index ebf5ba6..455e9b9 100644
>> --- a/include/linux/ceph/ceph_fs.h
>> +++ b/include/linux/ceph/ceph_fs.h
>> @@ -130,6 +130,7 @@ struct ceph_dir_layout {
>>   #define CEPH_MSG_CLIENT_REQUEST         24
>>   #define CEPH_MSG_CLIENT_REQUEST_FORWARD 25
>>   #define CEPH_MSG_CLIENT_REPLY           26
>> +#define CEPH_MSG_CLIENT_METRICS         29
>>   #define CEPH_MSG_CLIENT_CAPS            0x310
>>   #define CEPH_MSG_CLIENT_LEASE           0x311
>>   #define CEPH_MSG_CLIENT_SNAP            0x312
> Thanks,


