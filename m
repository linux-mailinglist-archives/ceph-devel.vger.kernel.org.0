Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884372AD77A
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 14:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730617AbgKJNZ6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 08:25:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32305 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729832AbgKJNZ6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 08:25:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605014756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GOs20H6csqrqRosZ9ShXuzf+ch8mDeKa6F+qtvnsGEQ=;
        b=IxRJJ7IGw/IEMPka8LodRIALxd2cT5BHcRAVh5Xyh0SBwlwoWy+GxSNzkaJE2coQzKDHsQ
        4dEra/BrR+GfimS4y5PGQFj7lnQeanUcKZCiOFaHGvZKZKjq4rRwK6R3h4iwefiCrFON4h
        r3bb8RX6caU0ElOlxBuIVs+GmETgSMU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-K9OuefHGOM2oY6TBMRIo7A-1; Tue, 10 Nov 2020 08:25:53 -0500
X-MC-Unique: K9OuefHGOM2oY6TBMRIo7A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0723B802B72;
        Tue, 10 Nov 2020 13:25:51 +0000 (UTC)
Received: from [10.72.12.102] (ovpn-12-102.pek2.redhat.com [10.72.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 15E135C1D0;
        Tue, 10 Nov 2020 13:25:48 +0000 (UTC)
Subject: Re: [PATCH v2 2/2] ceph: add CEPH_IOC_GET_CLUSTER_AND_CLIENT_IDS
 ioctl cmd support
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20201110105755.340315-1-xiubli@redhat.com>
 <20201110105755.340315-3-xiubli@redhat.com>
 <4e7ca1cec2ad6bc78423fc77ac9295c8740a8601.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <8ed29213-aac8-7395-9331-fa7ce1d53280@redhat.com>
Date:   Tue, 10 Nov 2020 21:25:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <4e7ca1cec2ad6bc78423fc77ac9295c8740a8601.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

How about :

[root@lxbceph1 kcephfs]# getfattr -n ceph.local.clusterid file
# file: file
ceph.local.clusterid="6ff21dc9-36b0-45a9-bec2-75aeaf0414cf"

[root@lxbceph1 kcephfs]# getfattr -n ceph.local.clientid file
# file: file
ceph.local.clientid="client4360"

??



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


