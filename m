Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76BB62AD1E3
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 09:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729653AbgKJIyw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 03:54:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46446 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729314AbgKJIyw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 03:54:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604998490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+NWbjsrRTEbqiprz4xM85DqiUZOUe/t1bV5fZJ1mIsw=;
        b=II9tv1tUAQ9FR8++1zZ+s9hzfAx6bbMhrzHWkcEde8urovuhmg8Ywk1LcIiHE8NMPKKyiz
        dDx+iaGzDgIgAPa94+RvuL7KZUHwjniHiIBmfM8PV4gAT8dhDPxC51qfQGFncn/uC5RaoJ
        nfLBbVMdKJW/qp2AwE74X29qY99BMNw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-PGRapw_uM16wI8D_xVxD0w-1; Tue, 10 Nov 2020 03:54:46 -0500
X-MC-Unique: PGRapw_uM16wI8D_xVxD0w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22ED8809DD4;
        Tue, 10 Nov 2020 08:54:45 +0000 (UTC)
Received: from [10.72.12.62] (ovpn-12-62.pek2.redhat.com [10.72.12.62])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 27C416EF77;
        Tue, 10 Nov 2020 08:54:42 +0000 (UTC)
Subject: Re: [PATCH 2/2] ceph: add CEPH_IOC_GET_FS_CLIENT_IDS ioctl cmd
 support
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20201105023703.735882-1-xiubli@redhat.com>
 <20201105023703.735882-3-xiubli@redhat.com>
 <CAOi1vP_kVqsmktmWxoEKOD8JAnGrKM5R+cxToncMb8kgRftCYg@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <0d5459ed-1251-ae14-9d3f-f0cdd0782913@redhat.com>
Date:   Tue, 10 Nov 2020 16:54:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP_kVqsmktmWxoEKOD8JAnGrKM5R+cxToncMb8kgRftCYg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/11/10 16:05, Ilya Dryomov wrote:
> On Thu, Nov 5, 2020 at 3:37 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This ioctl will return the dedicated fs and client IDs back to
>> userspace. With this we can easily know which mountpoint the file
>> blongs to and also they can help locate the debugfs path quickly.
> belongs
Will fix it.
>
>> URL: https://tracker.ceph.com/issues/48124
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/ioctl.c | 22 ++++++++++++++++++++++
>>   fs/ceph/ioctl.h | 15 +++++++++++++++
>>   2 files changed, 37 insertions(+)
>>
>> diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
>> index 6e061bf62ad4..2498a1df132e 100644
>> --- a/fs/ceph/ioctl.c
>> +++ b/fs/ceph/ioctl.c
>> @@ -268,6 +268,25 @@ static long ceph_ioctl_syncio(struct file *file)
>>          return 0;
>>   }
>>
>> +static long ceph_ioctl_get_client_id(struct file *file, void __user *arg)
>> +{
>> +       struct inode *inode = file_inode(file);
>> +       struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
>> +       struct fs_client_ids ids;
>> +       char fsid[40];
>> +
>> +       snprintf(fsid, sizeof(fsid), "%pU", &fsc->client->fsid);
>> +       memcpy(ids.fsid, fsid, sizeof(fsid));
>> +
>> +       ids.global_id = fsc->client->monc.auth->global_id;
> Why is fsid returned in text and global_id in binary?  I get that the
> initial use case is constructing "<fsid>.client<global_id>" string, but
> it's probably better to stick to binary.

Checked the ceph_debugfs_client_init() and rbd.c, they are both 
returning in text like this:

snprintf(name, sizeof(name), "%pU.client%lld", &client->fsid, 
client->monc.auth->global_id);

So let's make it the same with the rbd.c.


> Use ceph_client_gid() for getting global_id.
>
>> +
>> +       /* send result back to user */
>> +       if (copy_to_user(arg, &ids, sizeof(ids)))
>> +               return -EFAULT;
>> +
>> +       return 0;
>> +}
>> +
>>   long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>>   {
>>          dout("ioctl file %p cmd %u arg %lu\n", file, cmd, arg);
>> @@ -289,6 +308,9 @@ long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>>
>>          case CEPH_IOC_SYNCIO:
>>                  return ceph_ioctl_syncio(file);
>> +
>> +       case CEPH_IOC_GET_FS_CLIENT_IDS:
>> +               return ceph_ioctl_get_client_id(file, (void __user *)arg);
>>          }
>>
>>          return -ENOTTY;
>> diff --git a/fs/ceph/ioctl.h b/fs/ceph/ioctl.h
>> index 51f7f1d39a94..59c7479e77b2 100644
>> --- a/fs/ceph/ioctl.h
>> +++ b/fs/ceph/ioctl.h
>> @@ -98,4 +98,19 @@ struct ceph_ioctl_dataloc {
>>    */
>>   #define CEPH_IOC_SYNCIO _IO(CEPH_IOCTL_MAGIC, 5)
>>
>> +/*
>> + * CEPH_IOC_GET_FS_CLIENT_IDS - get the fs and client ids
>> + *
>> + * This ioctl will return the dedicated fs and client IDs back to
> The "fsid" you are capturing is really a cluster id, which may be home
> to multiple CephFS filesystems.  Referring to it as a "dedicated fs ID"
> is misleading.

Yeah, it is, will fix it.

Thanks.

>
> Thanks,
>
>                  Ilya
>

