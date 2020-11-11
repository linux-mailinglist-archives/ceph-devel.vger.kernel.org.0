Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EB42AE53D
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Nov 2020 02:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732344AbgKKBCg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 20:02:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47373 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732086AbgKKBCg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 20:02:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605056555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BkAu1JDDPT6pLYP1FdRQc+vUlH8M99sImQW/sHUvqac=;
        b=GTpaMDPuT94LcJnYTYC3kVirEdOH9sLqLjG+Xx6JP0q/I+Bc7qHp0Kowz5/SMpxY2Oeuty
        jJZxt+pD8gaLXsdgsXbfsB4kbrhUUy1DXosQja4/3IOxBTzxoUe3kQsGK/rYwTQQrraaXK
        zuTIDOjakKrWQpXOaGjzl8o3ppmqAwU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-kH_0m8YzNcavijy-A54Chw-1; Tue, 10 Nov 2020 20:02:31 -0500
X-MC-Unique: kH_0m8YzNcavijy-A54Chw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40A7C5720A;
        Wed, 11 Nov 2020 01:02:30 +0000 (UTC)
Received: from [10.72.12.102] (ovpn-12-102.pek2.redhat.com [10.72.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6BB066198C;
        Wed, 11 Nov 2020 01:02:28 +0000 (UTC)
Subject: Re: [PATCH v3 2/2] ceph: add ceph.{clusterid/clientid} vxattrs
 suppport
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20201110141703.414211-1-xiubli@redhat.com>
 <20201110141703.414211-3-xiubli@redhat.com>
 <CAOi1vP-JQbVYdAFfebKWLXPpVSgXFq=5s2_4knWbV9_J9ubxKA@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f9ee0044-1624-80b9-70ae-92870af7f5ca@redhat.com>
Date:   Wed, 11 Nov 2020 09:02:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP-JQbVYdAFfebKWLXPpVSgXFq=5s2_4knWbV9_J9ubxKA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/11/10 23:59, Ilya Dryomov wrote:
> On Tue, Nov 10, 2020 at 3:17 PM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> These two vxattrs will only exist in local client side, with which
>> we can easily know which mountpoint the file belongs to and also
>> they can help locate the debugfs path quickly.
>>
>> URL: https://tracker.ceph.com/issues/48057
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/xattr.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 42 insertions(+)
>>
>> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
>> index 0fd05d3d4399..4a41db46e191 100644
>> --- a/fs/ceph/xattr.c
>> +++ b/fs/ceph/xattr.c
>> @@ -304,6 +304,23 @@ static ssize_t ceph_vxattrcb_snap_btime(struct ceph_inode_info *ci, char *val,
>>                                  ci->i_snap_btime.tv_nsec);
>>   }
>>
>> +static ssize_t ceph_vxattrcb_clusterid(struct ceph_inode_info *ci,
>> +                                      char *val, size_t size)
>> +{
>> +       struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
>> +
>> +       return ceph_fmt_xattr(val, size, "%pU", &fsc->client->fsid);
>> +}
>> +
>> +static ssize_t ceph_vxattrcb_clientid(struct ceph_inode_info *ci,
>> +                                     char *val, size_t size)
>> +{
>> +       struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
>> +
>> +       return ceph_fmt_xattr(val, size, "client%lld",
>> +                             ceph_client_gid(fsc->client));
>> +}
>> +
>>   #define CEPH_XATTR_NAME(_type, _name)  XATTR_CEPH_PREFIX #_type "." #_name
>>   #define CEPH_XATTR_NAME2(_type, _name, _name2) \
>>          XATTR_CEPH_PREFIX #_type "." #_name "." #_name2
>> @@ -407,6 +424,24 @@ static struct ceph_vxattr ceph_file_vxattrs[] = {
>>          { .name = NULL, 0 }     /* Required table terminator */
>>   };
>>
>> +static struct ceph_vxattr ceph_vxattrs[] = {
>> +       {
>> +               .name = "ceph.clusterid",
> I think this should be "ceph.cluster_fsid"
>
>> +               .name_size = sizeof("ceph.clusterid"),
>> +               .getxattr_cb = ceph_vxattrcb_clusterid,
>> +               .exists_cb = NULL,
>> +               .flags = VXATTR_FLAG_READONLY,
>> +       },
>> +       {
>> +               .name = "ceph.clientid",
> and this should be "ceph.client_id".  It's easier to read, consistent
> with "ceph fsid" command and with existing rbd attributes:
>
>    static DEVICE_ATTR(client_id, 0444, rbd_client_id_show, NULL);
>    static DEVICE_ATTR(cluster_fsid, 0444, rbd_cluster_fsid_show, NULL);

Yeah, sounds nice.

Will fix them all.

Thanks.


> Thanks,
>
>                  Ilya
>

