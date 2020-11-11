Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA4272AE525
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Nov 2020 01:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732090AbgKKAxo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 19:53:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38622 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727275AbgKKAxo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 19:53:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605056023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qWRL8ENOFyvy6Lf8wuTGgSYb9s86S7u1QSoJpRNckJg=;
        b=IyBoAkgOZ4ht6kCc0xXIMhqtQrQDFyp0XGkeu9rdZgJI10CNgdXgV303hZYkW6HCGGJt9+
        0/9rw7zbsZJ+27/nnFOQm9kLPIxFn/boqS2ijr0qHVKQNFTyqyKAnYpqMziCKjMSdMIb5Z
        dKwTlafk6T8/L2OgzhJfP5vRHQ4NLqI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-DpeUX4geMI-9xg1u7WUEVQ-1; Tue, 10 Nov 2020 19:53:40 -0500
X-MC-Unique: DpeUX4geMI-9xg1u7WUEVQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40A211074656;
        Wed, 11 Nov 2020 00:53:39 +0000 (UTC)
Received: from [10.72.12.102] (ovpn-12-102.pek2.redhat.com [10.72.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EFFF5B4A2;
        Wed, 11 Nov 2020 00:53:36 +0000 (UTC)
Subject: Re: [PATCH v3 2/2] ceph: add ceph.{clusterid/clientid} vxattrs
 suppport
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20201110141703.414211-1-xiubli@redhat.com>
 <20201110141703.414211-3-xiubli@redhat.com>
 <CAOi1vP-JQbVYdAFfebKWLXPpVSgXFq=5s2_4knWbV9_J9ubxKA@mail.gmail.com>
 <ca04bd7a8d3af6f4613a804f8b29c4c89a2562a7.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c92926ef-a524-c4e0-6e59-86e231aae981@redhat.com>
Date:   Wed, 11 Nov 2020 08:53:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <ca04bd7a8d3af6f4613a804f8b29c4c89a2562a7.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/11/11 0:26, Jeff Layton wrote:
> On Tue, 2020-11-10 at 16:59 +0100, Ilya Dryomov wrote:
>> On Tue, Nov 10, 2020 at 3:17 PM <xiubli@redhat.com> wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> These two vxattrs will only exist in local client side, with which
>>> we can easily know which mountpoint the file belongs to and also
>>> they can help locate the debugfs path quickly.
>>>
>>> URL: https://tracker.ceph.com/issues/48057
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>   fs/ceph/xattr.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>>>   1 file changed, 42 insertions(+)
>>>
>>> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
>>> index 0fd05d3d4399..4a41db46e191 100644
>>> --- a/fs/ceph/xattr.c
>>> +++ b/fs/ceph/xattr.c
>>> @@ -304,6 +304,23 @@ static ssize_t ceph_vxattrcb_snap_btime(struct ceph_inode_info *ci, char *val,
>>>                                  ci->i_snap_btime.tv_nsec);
>>>   }
>>>
>>> +static ssize_t ceph_vxattrcb_clusterid(struct ceph_inode_info *ci,
>>> +                                      char *val, size_t size)
>>> +{
>>> +       struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
>>> +
>>> +       return ceph_fmt_xattr(val, size, "%pU", &fsc->client->fsid);
>>> +}
>>> +
>>> +static ssize_t ceph_vxattrcb_clientid(struct ceph_inode_info *ci,
>>> +                                     char *val, size_t size)
>>> +{
>>> +       struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
>>> +
>>> +       return ceph_fmt_xattr(val, size, "client%lld",
>>> +                             ceph_client_gid(fsc->client));
>>> +}
>>> +
>>>   #define CEPH_XATTR_NAME(_type, _name)  XATTR_CEPH_PREFIX #_type "." #_name
>>>   #define CEPH_XATTR_NAME2(_type, _name, _name2) \
>>>          XATTR_CEPH_PREFIX #_type "." #_name "." #_name2
>>> @@ -407,6 +424,24 @@ static struct ceph_vxattr ceph_file_vxattrs[] = {
>>>          { .name = NULL, 0 }     /* Required table terminator */
>>>   };
>>>
>>> +static struct ceph_vxattr ceph_vxattrs[] = {
>>> +       {
>>> +               .name = "ceph.clusterid",
>> I think this should be "ceph.cluster_fsid"
>>
>>> +               .name_size = sizeof("ceph.clusterid"),
>>> +               .getxattr_cb = ceph_vxattrcb_clusterid,
>>> +               .exists_cb = NULL,
>>> +               .flags = VXATTR_FLAG_READONLY,
>>> +       },
>>> +       {
>>> +               .name = "ceph.clientid",
>> and this should be "ceph.client_id".  It's easier to read, consistent
>> with "ceph fsid" command and with existing rbd attributes:
>>
>>    static DEVICE_ATTR(client_id, 0444, rbd_client_id_show, NULL);
>>    static DEVICE_ATTR(cluster_fsid, 0444, rbd_cluster_fsid_show, NULL);
>>
> That sounds like a good idea. Xiubo, would you mind sending a v4?

Sure, I will post the V4 for fix them all.

Thanks.

BRs

Xiubo


> Thanks,


