Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1BE8153CFD
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Feb 2020 03:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbgBFCgg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Feb 2020 21:36:36 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47849 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727307AbgBFCgg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Feb 2020 21:36:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580956594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zv9Komp4+GnbEfF5SoZhcmhx/6w3AP0lsmoXFiyTKUk=;
        b=Zxvm8Af3BIRWi6Cmlno30QoYBXzkH4+2KxsP8XdtRzKfEfK9vP4PVtzq51Pa/XrmeBzZAB
        /vIs32NCyAwUbfKuLkdIpeErOve++KwVHsC95AdVKPXr9e3ayVM5ymStxkqS4gxkT/0cpd
        6f5SyUQMge5PohXT4BldRIB9OPyS0Lk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-5sxgW2BfN2mnPg7j0i5lLw-1; Wed, 05 Feb 2020 21:36:30 -0500
X-MC-Unique: 5sxgW2BfN2mnPg7j0i5lLw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47135801A03;
        Thu,  6 Feb 2020 02:36:29 +0000 (UTC)
Received: from [10.72.12.34] (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E7E565C1B0;
        Thu,  6 Feb 2020 02:36:22 +0000 (UTC)
Subject: Re: [PATCH resend v5 08/11] ceph: periodically send perf metrics to
 MDS
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20200129082715.5285-1-xiubli@redhat.com>
 <20200129082715.5285-9-xiubli@redhat.com>
 <57de3eb2f2009aec0ba086bb9d95a2936a7d1d9f.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d4b8f9a5-b2f7-ec71-c8fe-528ec24d8695@redhat.com>
Date:   Thu, 6 Feb 2020 10:36:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <57de3eb2f2009aec0ba086bb9d95a2936a7d1d9f.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/6 5:43, Jeff Layton wrote:
> On Wed, 2020-01-29 at 03:27 -0500, xiubli@redhat.com wrote:
[...]
>>  =20
>> +/*
>> + * metrics debugfs
>> + */
>> +static int sending_metrics_set(void *data, u64 val)
>> +{
>> +	struct ceph_fs_client *fsc =3D (struct ceph_fs_client *)data;
>> +	struct ceph_mds_client *mdsc =3D fsc->mdsc;
>> +
>> +	if (val > 1) {
>> +		pr_err("Invalid sending metrics set value %llu\n", val);
>> +		return -EINVAL;
>> +	}
>> +
>> +	mutex_lock(&mdsc->mutex);
>> +	mdsc->sending_metrics =3D (unsigned int)val;
> Shouldn't that be a bool cast? Do we even need a cast there?
Will switch sending_metrics to bool type instead.
>> +	mutex_unlock(&mdsc->mutex);
>> +
>> +	return 0;
>> +}
>> +
>> +static int sending_metrics_get(void *data, u64 *val)
>> +{
>> +	struct ceph_fs_client *fsc =3D (struct ceph_fs_client *)data;
>> +	struct ceph_mds_client *mdsc =3D fsc->mdsc;
>> +
>> +	mutex_lock(&mdsc->mutex);
>> +	*val =3D (u64)mdsc->sending_metrics;
>> +	mutex_unlock(&mdsc->mutex);
>> +
>> +	return 0;
>> +}
>> +DEFINE_SIMPLE_ATTRIBUTE(sending_metrics_fops, sending_metrics_get,
>> +			sending_metrics_set, "%llu\n");
>> +
> I'd like to hear more about how we expect users to use this facility.
> This debugfs file doesn't seem consistent with the rest of the UI, and =
I
> imagine if the box reboots you'd have to (manually) re-enable it after
> mount, right? Maybe this should be a mount option instead?

A mount option means we must do the unmounting to disable it.

I was thinking with the debugfs file we can do the debug or tuning even=20
in the product setups at any time, usually this should be disabled since=20
it will send it per second.

Or we could merge the "sending_metric" to "metrics" UI, just writing=20
"enable"/"disable" to enable/disable sending the metrics to ceph, and=20
just like the "reset" does to clean the metrics.

Then the "/sys/kernel/debug/ceph/XXX.clientYYY/metrics" could be=20
writable with:

"reset"=C2=A0 --> to clean and reset the metrics counters

"enable" --> enable sending metrics to ceph cluster

"disable" --> disable sending metrics to ceph cluster

Will this be better ?


[...]
>   /*
>    * delayed work -- periodically trim expired leases, renew caps with =
mds
>    */
> +#define CEPH_WORK_DELAY_DEF 5
>   static void schedule_delayed(struct ceph_mds_client *mdsc)
>   {
> -	int delay =3D 5;
> -	unsigned hz =3D round_jiffies_relative(HZ * delay);
> +	unsigned int hz;
> +	int delay =3D CEPH_WORK_DELAY_DEF;
> +
> +	mutex_lock(&mdsc->mutex);
> +	if (mdsc->sending_metrics)
> +		delay =3D 1;
> +	mutex_unlock(&mdsc->mutex);
> +
> The mdsc->mutex is dropped in the callers a little before this is
> called, so this is a little too mutex-thrashy. I think you'd be better
> off changing this function to be called with the mutex still held.

Will fix it.


[...]
>> +/* metric caps header */
>> +struct ceph_metric_cap {
>> +	__le32 type;     /* ceph metric type */
>> +
>> +	__u8  ver;
>> +	__u8  campat;
> I think you meant "compat" here.

Will fix it.


[...]
>> +/* metric metadata latency header */
>> +struct ceph_metric_metadata_latency {
>> +	__le32 type;     /* ceph metric type */
>> +
>> +	__u8  ver;
>> +	__u8  campat;
>> +
>> +	__le32 data_len; /* length of sizeof(sec + nsec) */
>> +	__le32 sec;
>> +	__le32 nsec;
>> +} __attribute__ ((packed));
>> +
>> +struct ceph_metric_head {
>> +	__le32 num;	/* the number of metrics will be sent */
> "the number of metrics that will be sent"

Will fix it.

Thanks,

>> +} __attribute__ ((packed));
>> +
>>   /* This is the global metrics */
>>   struct ceph_client_metric {
>>   	atomic64_t		total_dentries;
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index 3f4829222528..a91431e9bdf7 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -128,6 +128,7 @@ struct ceph_fs_client {
>>   	struct dentry *debugfs_congestion_kb;
>>   	struct dentry *debugfs_bdi;
>>   	struct dentry *debugfs_mdsc, *debugfs_mdsmap;
>> +	struct dentry *debugfs_sending_metrics;
>>   	struct dentry *debugfs_metric;
>>   	struct dentry *debugfs_mds_sessions;
>>   #endif
>> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs=
.h
>> index a099f60feb7b..6028d3e865e4 100644
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


