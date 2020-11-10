Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B96C2AD668
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 13:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731179AbgKJMfA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 07:35:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29908 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726721AbgKJMfA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 07:35:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605011699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X94nUcByhskhvzyahLOxiBrR7L1brdxFcuhkx3eoMAA=;
        b=IV57dPam7ArH9Nn9mTOxsUm3Xm7STBDMSL1WVyuzf6tY+O3dv6gbfEj/SOEPy6kkGVpqIN
        A9LTiXUiz1KUIGgSfjv2ZfFDVk3cZUVPR5GSMtBQvleKpQSBiH7u4y1lFEbUL7ZWZWChTt
        mqQRGuH7dJAEXRYiodVyScYY7TAmRIQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-BhwEweAIP6mCU5RpN-cSuw-1; Tue, 10 Nov 2020 07:34:57 -0500
X-MC-Unique: BhwEweAIP6mCU5RpN-cSuw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5DF38049E5;
        Tue, 10 Nov 2020 12:34:55 +0000 (UTC)
Received: from [10.72.12.102] (ovpn-12-102.pek2.redhat.com [10.72.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 05BA96EF79;
        Tue, 10 Nov 2020 12:34:53 +0000 (UTC)
Subject: Re: [PATCH v2 2/2] ceph: add CEPH_IOC_GET_CLUSTER_AND_CLIENT_IDS
 ioctl cmd support
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20201110105755.340315-1-xiubli@redhat.com>
 <20201110105755.340315-3-xiubli@redhat.com>
 <4e7ca1cec2ad6bc78423fc77ac9295c8740a8601.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f462e0a2-63bf-6ddd-06d7-975e66246938@redhat.com>
Date:   Tue, 10 Nov 2020 20:34:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <4e7ca1cec2ad6bc78423fc77ac9295c8740a8601.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/11/10 20:24, Jeff Layton wrote:
> On Tue, 2020-11-10 at 18:57 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This ioctl will return the cluster and client ids back to userspace.
>> With this we can easily know which mountpoint the file belongs to and
>> also they can help locate the debugfs path quickly.
>>
>> URL: https://tracker.ceph.com/issues/48124
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/ioctl.c | 23 +++++++++++++++++++++++
>>   fs/ceph/ioctl.h | 15 +++++++++++++++
>>   2 files changed, 38 insertions(+)
>>
> I know I opened this bug and suggested an ioctl for this, but I think
> that this may be better presented as new vxattrs. Driving ioctls from
> scripts is difficult (in particular). An xattr is easier for them to
> deal with. Maybe:
>
>      ceph.clusterid
>      ceph.clientid

Yeah, it is. I was trying to call the ioctl in python which is a little 
complicated than the vxattrs method.

The vxattrs one sounds a best approach for me, let's try this one.

Thanks

BRs


> ...or you could even make one that gives you the same format as the
> dirnames in /sys/kernel/debug/ceph.
>
>> diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
>> index 6e061bf62ad4..a4b69c1026ce 100644
>> --- a/fs/ceph/ioctl.c
>> +++ b/fs/ceph/ioctl.c
>> @@ -268,6 +268,27 @@ static long ceph_ioctl_syncio(struct file *file)
>>   	return 0;
>>   }
>>   
>> +/*
>> + * Return the cluster and client ids
>> + */
>> +static long ceph_ioctl_get_fs_ids(struct file *file, void __user *arg)
>> +{
>> +	struct inode *inode = file_inode(file);
>> +	struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
>> +	struct cluster_client_ids ids;
>> +
>> +	snprintf(ids.cluster_id, sizeof(ids.cluster_id), "%pU",
>> +		 &fsc->client->fsid);
>> +	snprintf(ids.client_id, sizeof(ids.client_id), "client%lld",
>> +		 ceph_client_gid(fsc->client));
>> +
>> +	/* send result back to user */
>> +	if (copy_to_user(arg, &ids, sizeof(ids)))
>> +		return -EFAULT;
>> +
>> +	return 0;
>> +}
>> +
>>   long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>>   {
>>   	dout("ioctl file %p cmd %u arg %lu\n", file, cmd, arg);
>> @@ -289,6 +310,8 @@ long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>>   
>>
>>
>>
>>   	case CEPH_IOC_SYNCIO:
>>   		return ceph_ioctl_syncio(file);
>> +	case CEPH_IOC_GET_CLUSTER_AND_CLIENT_IDS:
>> +		return ceph_ioctl_get_fs_ids(file, (void __user *)arg);
>>   	}
>>   
>>
>>
>>
>>   	return -ENOTTY;
>> diff --git a/fs/ceph/ioctl.h b/fs/ceph/ioctl.h
>> index 51f7f1d39a94..9879d58854fb 100644
>> --- a/fs/ceph/ioctl.h
>> +++ b/fs/ceph/ioctl.h
>> @@ -98,4 +98,19 @@ struct ceph_ioctl_dataloc {
>>    */
>>   #define CEPH_IOC_SYNCIO _IO(CEPH_IOCTL_MAGIC, 5)
>>   
>>
>>
>>
>> +/*
>> + * CEPH_IOC_GET_CLUSTER_AND_CLIENT_IDS - get the cluster and client ids
>> + *
>> + * This ioctl will return the cluster and client ids back to user space.
>> + * With this we can easily know which mountpoint the file belongs to and
>> + * also they can help locate the debugfs path quickly.
>> + */
>> +
>> +struct cluster_client_ids {
>> +	char cluster_id[40];
>> +	char client_id[24];
>> +};
>> +#define CEPH_IOC_GET_CLUSTER_AND_CLIENT_IDS _IOR(CEPH_IOCTL_MAGIC, 6, \
>> +					struct cluster_client_ids)
>> +
>>   #endif


