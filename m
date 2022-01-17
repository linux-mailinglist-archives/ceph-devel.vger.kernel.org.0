Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB17490378
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jan 2022 09:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237915AbiAQILA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jan 2022 03:11:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29162 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230177AbiAQILA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 03:11:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642407059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yPlLzRIsu/0e6kTVkhTLSOUbSeSuB/VL2UYxsvj3Pto=;
        b=H+BL+cYA3aPmVETmvWzB1/o9sIm92xihBwSuf1LPBBPi1KF+9YFwG7PR3aqK9iB248tqZB
        8gUgwSaAqEQBeWijcAKN4IHqgyDvktFLnocGhccuEk4K37k3YIPaxvHJydKsssfcrDSPg3
        d9mBMdJ6zicf0N20N8B+OPpuGFHHIfM=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-282-9NruXvJPMnWa5WcZyJdlow-1; Mon, 17 Jan 2022 03:10:58 -0500
X-MC-Unique: 9NruXvJPMnWa5WcZyJdlow-1
Received: by mail-pf1-f200.google.com with SMTP id w6-20020aa78586000000b004bef48e4ae3so5816023pfn.17
        for <ceph-devel@vger.kernel.org>; Mon, 17 Jan 2022 00:10:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=yPlLzRIsu/0e6kTVkhTLSOUbSeSuB/VL2UYxsvj3Pto=;
        b=CKpwu5U331icRQ9TgwY2fIyOnlJbz+pxBkkQfYxOSt7Zo3Sp2x8VtfRaGa07wK9tA9
         nPOm4hPFqxXAurg63AYys/kpojW9fD84GngZOP1KDsxeBMK0ku3JlRf6p2WA7YInCiiR
         wmICC4vYBWxiL297E5JzhFLt8op6OOzuACp54k45Kul+Tmj96J+SoPOYjnCpAJiMlKgf
         CtWGupnFLld5I8tcXliyn19JvnYxlH5hP+pobqBGSDdUGLgrchaISddoQIEC7MwxK6gd
         jlKFzcwNfdxdy32GxtnwyB/3rJyLK5AHqUfFLr+mQMjS4fx9GY9UX4O4nL5zH7pogQ2M
         E8ag==
X-Gm-Message-State: AOAM533j4onEE5hRF1k61lkvBM8qr3w/CdTshN6M/c11N15zfyCxw8C/
        tX96Bpaz2sW979zZWfkeRw4EZZbwSDUXD+0Q4o622UqT84Jy4wsUIrhzIWOmomrzjmnLnIkjk3g
        tbv29Im01ugByPWYQAQ/2FQ==
X-Received: by 2002:a63:8c19:: with SMTP id m25mr18180079pgd.492.1642407056846;
        Mon, 17 Jan 2022 00:10:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJynDkJmVZEmbqeyrtQni/tLxa0bWJ5DTok1z+iPFgRf5Bha3QmxE+wbq/GSQwBcVWb/3+0LUA==
X-Received: by 2002:a63:8c19:: with SMTP id m25mr18180066pgd.492.1642407056538;
        Mon, 17 Jan 2022 00:10:56 -0800 (PST)
Received: from [10.72.12.81] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j18sm11104358pgi.78.2022.01.17.00.10.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 00:10:55 -0800 (PST)
Subject: Re: [PATCH v3 1/1] ceph: add getvxattr op
To:     Milind Changire <milindchangire@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Milind Changire <mchangir@redhat.com>
References: <20220117035946.22442-1-mchangir@redhat.com>
 <20220117035946.22442-2-mchangir@redhat.com>
 <c6263a9a-e761-85f6-8c61-aaa706730639@redhat.com>
 <CANmksPQCypsqFF7iacSkfbsSsWzy4-PsDc42in9Jq1QiFbEY+A@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <bf6c6d11-96e1-48e4-845b-7a8587c7c687@redhat.com>
Date:   Mon, 17 Jan 2022 16:10:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CANmksPQCypsqFF7iacSkfbsSsWzy4-PsDc42in9Jq1QiFbEY+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 1/17/22 3:36 PM, Milind Changire wrote:
> On Mon, Jan 17, 2022 at 12:49 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 1/17/22 11:59 AM, Milind Changire wrote:
>>> Problem:
>>> Directory vxattrs like ceph.dir.pin* and ceph.dir.layout* may not be
>>> propagated to the client as frequently to keep them updated. This
>>> creates vxattr availability problems.
>>>
>>> Solution:
>>> Adds new getvxattr op to fetch ceph.dir.pin*, ceph.dir.layout* and
>>> ceph.file.layout* vxattrs.
>>> If the entire layout for a dir or a file is being set, then it is
>>> expected that the layout be set in standard JSON format. Individual
>>> field value retrieval is not wrapped in JSON. The JSON format also
>>> applies while setting the vxattr if the entire layout is being set in
>>> one go.
>>> As a temporary measure, setting a vxattr can also be done in the old
>>> format. The old format will be deprecated in the future.
>>>
>>> URL: https://tracker.ceph.com/issues/51062
>>> Signed-off-by: Milind Changire <mchangir@redhat.com>
>>> ---
>>>    fs/ceph/inode.c              | 51 ++++++++++++++++++++++++++++++++++++
>>>    fs/ceph/mds_client.c         | 27 ++++++++++++++++++-
>>>    fs/ceph/mds_client.h         | 12 ++++++++-
>>>    fs/ceph/strings.c            |  1 +
>>>    fs/ceph/super.h              |  1 +
>>>    fs/ceph/xattr.c              | 34 ++++++++++++++++++++++++
>>>    include/linux/ceph/ceph_fs.h |  1 +
>>>    7 files changed, 125 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>>> index e3322fcb2e8d..b63746a7a0e0 100644
>>> --- a/fs/ceph/inode.c
>>> +++ b/fs/ceph/inode.c
>>> @@ -2291,6 +2291,57 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
>>>        return err;
>>>    }
>>>
>>> +int ceph_do_getvxattr(struct inode *inode, const char *name, void *value,
>>> +                   size_t size)
>>> +{
>>> +     struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
>>> +     struct ceph_mds_client *mdsc = fsc->mdsc;
>>> +     struct ceph_mds_request *req;
>>> +     int mode = USE_AUTH_MDS;
>>> +     int err;
>>> +     char *xattr_value;
>>> +     size_t xattr_value_len;
>>> +
>>> +     req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETVXATTR, mode);
>>> +     if (IS_ERR(req)) {
>>> +             err = -ENOMEM;
>>> +             goto out;
>>> +     }
>>> +
>>> +     req->r_path2 = kstrdup(name, GFP_NOFS);
>>> +     if (!req->r_path2) {
>>> +             err = -ENOMEM;
>>> +             goto put;
>>> +     }
>>> +
>>> +     ihold(inode);
>>> +     req->r_inode = inode;
>>> +     err = ceph_mdsc_do_request(mdsc, NULL, req);
>>> +     if (err < 0)
>>> +             goto put;
>>> +
>>> +     xattr_value = req->r_reply_info.xattr_info.xattr_value;
>>> +     xattr_value_len = req->r_reply_info.xattr_info.xattr_value_len;
>>> +
>>> +     dout("do_getvxattr xattr_value_len:%u, size:%u\n", xattr_value_len, size);
> Need some help here.
> The kernel CI reported the following warnings:
> 1. for i386 build that size_t is unsigned int
> 2. for riscv build that size_t is unsigned long int
>
> So the above (dout) statement gets a warning either way if I change the expected
> arguments to be either %u or %lu.
>
You can use the %zu, more detail please see 
https://www.kernel.org/doc/Documentation/printk-formats.txt.



>>> +
>>> +     err = xattr_value_len;
>>> +     if (size == 0)
>>> +             goto put;
>>> +
>>> +     if (xattr_value_len > size) {
>>> +             err = -ERANGE;
>>> +             goto put;
>>> +     }
>>> +
[...]
>>> +                     return false;
>>> +     }
>>> +     return true;
>>> +}
>>> +
>>>    ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>>>                      size_t size)
>>>    {
>>> @@ -927,6 +951,16 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>>>        int req_mask;
>>>        ssize_t err;
>>>
>>> +     if (!strncmp(name, XATTR_CEPH_PREFIX, XATTR_CEPH_PREFIX_LEN) &&
>>> +         ceph_cluster_has_feature(inode, CEPHFS_FEATURE_GETVXATTR)) {
>>> +             err = ceph_do_getvxattr(inode, name, value, size);
>>> +             /* if cluster doesn't support xattr, we try to service it
>>> +              * locally
>>> +              */
>>> +             if (err >= 0)
>>> +                     return err;
>>> +     }
>>> +
>> If the 'Fa' or 'Fr' caps is issued to kclient, could we get this vxattr
>> locally instead of getting it from MDS every time ?
> The new mechanism is meant to supersede the old one.
> 1. The new layout output format is JSON
> 2. The new mechanism also recursively resolves the layout to the
> closest ancestor
> 3. The new mechanism deals with ceph vxattrs exclusively at the server end
>     (currently getvxattr handles only a limited subset of all the vxattrs)
> 4. There's no way to fetch ceph.dir.pin* vxattrs locally
> (see https://github.com/ceph/ceph/pull/42001 for userspace work)
>
Okay.


>>
>>
>>>        /* let's see if a virtual xattr was requested */
>>>        vxattr = ceph_match_vxattr(inode, name);
>>>        if (vxattr) {
>>> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
>>> index 7ad6c3d0db7d..66db21ac5f0c 100644
>>> --- a/include/linux/ceph/ceph_fs.h
>>> +++ b/include/linux/ceph/ceph_fs.h
>>> @@ -328,6 +328,7 @@ enum {
>>>        CEPH_MDS_OP_LOOKUPPARENT = 0x00103,
>>>        CEPH_MDS_OP_LOOKUPINO  = 0x00104,
>>>        CEPH_MDS_OP_LOOKUPNAME = 0x00105,
>>> +     CEPH_MDS_OP_GETVXATTR  = 0x00106,
>>>
>>>        CEPH_MDS_OP_SETXATTR   = 0x01105,
>>>        CEPH_MDS_OP_RMXATTR    = 0x01106,

