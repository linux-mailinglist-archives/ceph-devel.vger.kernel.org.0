Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F19B1FBDBE
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jun 2020 20:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgFPSOR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Jun 2020 14:14:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25404 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727083AbgFPSOQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 16 Jun 2020 14:14:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592331254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VC6wbkld+su5WWAX57lxfu6mOzKQLI7Vf4VljvP2zXA=;
        b=YP7E3QwWLaVH7IZwjJx4NPO1Lg2RAn6XvuI/QWzBoC4xbOzBLKRpxSlgGd1j6HwQOyZEUv
        zaNPriv9qfpXg4xYFfZjKyCe1z5aWq4qU4oq01mhI7a2Au5tusi1ZsZmTSHsnA2G3kmYgT
        WL9mqEtwLhQQAyQ6ol1rV7KFTE3Q+aQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-euLJsUx_PNSmxDILaJdSdg-1; Tue, 16 Jun 2020 14:14:07 -0400
X-MC-Unique: euLJsUx_PNSmxDILaJdSdg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01C0480F5DA;
        Tue, 16 Jun 2020 18:14:06 +0000 (UTC)
Received: from [10.72.13.235] (ovpn-13-235.pek2.redhat.com [10.72.13.235])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D45315D9D3;
        Tue, 16 Jun 2020 18:14:03 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
Subject: Re: [PATCH 1/2] ceph: periodically send perf metrics to ceph
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <1592311950-17623-1-git-send-email-xiubli@redhat.com>
 <1592311950-17623-2-git-send-email-xiubli@redhat.com>
 <dc4ad07be7a3c6764e751e0a41ba5d818594b84f.camel@kernel.org>
Message-ID: <c115e073-187c-977b-3950-50ab9a2531c7@redhat.com>
Date:   Wed, 17 Jun 2020 02:14:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <dc4ad07be7a3c6764e751e0a41ba5d818594b84f.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/6/16 21:40, Jeff Layton wrote:
> On Tue, 2020-06-16 at 08:52 -0400,xiubli@redhat.com  wrote:
>> From: Xiubo Li<xiubli@redhat.com>
>>
>> This will send the caps/read/write/metadata metrics to any available
>> MDS only once per second as default, which will be the same as the
>> userland client, or every metric_send_interval seconds, which is a
>> module parameter.
>>
>> URL:https://tracker.ceph.com/issues/43215
>> Signed-off-by: Xiubo Li<xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c         |  46 +++++++++------
>>   fs/ceph/mds_client.h         |   4 ++
>>   fs/ceph/metric.c             | 133 +++++++++++++++++++++++++++++++++++++++++++
>>   fs/ceph/metric.h             |  78 +++++++++++++++++++++++++
>>   fs/ceph/super.c              |  29 ++++++++++
>>   include/linux/ceph/ceph_fs.h |   1 +
>>   6 files changed, 274 insertions(+), 17 deletions(-)
>>
> Long patch! Might not hurt to break out some of the cleanups into
> separate patches, but they're fairly straighforward so I won't require
> it.

Sure, I will split the patch into small ones if possible.


> [...]
>
>>   /* This is the global metrics */
>>   struct ceph_client_metric {
>>   	atomic64_t            total_dentries;
>> @@ -35,8 +100,21 @@ struct ceph_client_metric {
>>   	ktime_t metadata_latency_sq_sum;
>>   	ktime_t metadata_latency_min;
>>   	ktime_t metadata_latency_max;
>> +
>> +	struct delayed_work delayed_work;  /* delayed work */
>>   };
>>   
>> +static inline void metric_schedule_delayed(struct ceph_client_metric *m)
>> +{
>> +	/* per second as default */
>> +	unsigned int hz = round_jiffies_relative(HZ * metric_send_interval);
>> +
>> +	if (!metric_send_interval)
>> +		return;
>> +
>> +	schedule_delayed_work(&m->delayed_work, hz);
>> +}
>> +
> Should this also be gated on a MDS feature bit or anything? What happens
> if we're running against a really old MDS that doesn't support these
> stats? Does it just drop them on the floor? Should we disable sending
> them in that case?

Tested without metric code in the ceph and when ceph saw a unknown type 
message, it will close the socket connection directly.


>>   extern int ceph_metric_init(struct ceph_client_metric *m);
>>   extern void ceph_metric_destroy(struct ceph_client_metric *m);
>>   
>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> index c9784eb1..66a940c 100644
>> --- a/fs/ceph/super.c
>> +++ b/fs/ceph/super.c
>> @@ -1282,6 +1282,35 @@ static void __exit exit_ceph(void)
>>   	destroy_caches();
>>   }
>>   
>> +static int param_set_metric_interval(const char *val, const struct kernel_param *kp)
>> +{
>> +	int ret;
>> +	unsigned int interval;
>> +
>> +	ret = kstrtouint(val, 0, &interval);
>> +	if (ret < 0) {
>> +		pr_err("Failed to parse metric interval '%s'\n", val);
>> +		return ret;
>> +	}
>> +
>> +	if (interval > 5 || interval < 1) {
>> +		pr_err("Invalid metric interval %u\n", interval);
>> +		return -EINVAL;
>> +	}
>> +
>> +	metric_send_interval = interval;
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
>> +MODULE_PARM_DESC(metric_send_interval, "Interval (in seconds) of sending perf metric to ceph cluster, valid values are 1~5 (default: 1)");
>> +
> Aren't valid values 0-5, with 0 disabling this feature? That's
> what metric_schedule_delayed() seems to indicate...

What value should it be as default ? 0 to disable it or 1 ?

Maybe in future we should let the ceph side send a notification/request 
to all the clients if it wants to collect the metrics and then we could 
enable it here, and defautly just disable it.


>>   module_init(init_ceph);
>>   module_exit(exit_ceph);
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


