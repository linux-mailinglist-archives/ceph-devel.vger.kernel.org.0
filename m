Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2601260D7
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Dec 2019 12:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfLSLbk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Dec 2019 06:31:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39863 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726692AbfLSLbj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 19 Dec 2019 06:31:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576755098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W2F4Q1wOzIm66PjAN3V2KgNHutkB4B7mNkevrbfY/hw=;
        b=Wjg8QN8KdYo/aYVUZR6MQoWQgwWQc+v9mKLeqEM686kH5QPIt/xiR7lwDA3MYII5qfSy2v
        RZcQIRk6F0XQ87daSzQHOIto/vhD0hHE3YUUBwuQlcrb9OIanV/q079uxkhcbkjl0hwClO
        GlSsIaVsZMGtjoxOxgdCH8sbEjYsskU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-mkUvNhFwP5GXAX8hta9Izw-1; Thu, 19 Dec 2019 06:31:31 -0500
X-MC-Unique: mkUvNhFwP5GXAX8hta9Izw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B5EB9113C;
        Thu, 19 Dec 2019 11:31:30 +0000 (UTC)
Received: from [10.72.12.95] (ovpn-12-95.pek2.redhat.com [10.72.12.95])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2011660BBA;
        Thu, 19 Dec 2019 11:31:25 +0000 (UTC)
Subject: Re: [PATCH] ceph: cleanup the dir debug log and xattr_version
To:     Jeff Layton <jlayton@kernel.org>
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20191219021518.60891-1-xiubli@redhat.com>
 <1b99ad456e4db43a1f27471adb5238211fec956e.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <84f2fb3f-3c34-e87c-9c7e-53174848c931@redhat.com>
Date:   Thu, 19 Dec 2019 19:31:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <1b99ad456e4db43a1f27471adb5238211fec956e.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/12/19 19:10, Jeff Layton wrote:
> On Wed, 2019-12-18 at 21:15 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> In the debug logs about the di->offset or ctx->pos it is in hex
>> format, but some others are using the dec format. It is a little
>> hard to read.
>>
>> For the xattr version, it is u64 type, using a shorter type may
>> truncate it.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/dir.c   | 4 ++--
>>   fs/ceph/xattr.c | 2 +-
>>   2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>> index 5c97bdbb0772..8d14a2867e7c 100644
>> --- a/fs/ceph/dir.c
>> +++ b/fs/ceph/dir.c
>> @@ -1192,7 +1192,7 @@ void __ceph_dentry_dir_lease_touch(struct ceph_dentry_info *di)
>>   	struct dentry *dn = di->dentry;
>>   	struct ceph_mds_client *mdsc;
>>   
>> -	dout("dentry_dir_lease_touch %p %p '%pd' (offset %lld)\n",
>> +	dout("dentry_dir_lease_touch %p %p '%pd' (offset %llx)\n",
>>   	     di, dn, dn, di->offset);
> If you're printing hex values, it's generally a good idea to prefix them
> with "0x" so that it's clear that they are in hex.

Yeah, make sense.

Thanks.


>
>>   
>>   	if (!list_empty(&di->lease_list)) {
>> @@ -1577,7 +1577,7 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
>>   
>>   	mdsc = ceph_sb_to_client(dir->i_sb)->mdsc;
>>   
>> -	dout("d_revalidate %p '%pd' inode %p offset %lld\n", dentry,
>> +	dout("d_revalidate %p '%pd' inode %p offset %llx\n", dentry,
>>   	     dentry, inode, ceph_dentry(dentry)->offset);
>>   
>>   	/* always trust cached snapped dentries, snapdir dentry */
>> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
>> index 6e5e145d51d1..c8609dfd6b37 100644
>> --- a/fs/ceph/xattr.c
>> +++ b/fs/ceph/xattr.c
>> @@ -655,7 +655,7 @@ static int __build_xattrs(struct inode *inode)
>>   	u32 len;
>>   	const char *name, *val;
>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>> -	int xattr_version;
>> +	u64 xattr_version;
>>   	struct ceph_inode_xattr **xattrs = NULL;
>>   	int err = 0;
>>   	int i;
> Merged, but I went ahead and added the "0x" prefixes on these values.
>
> Thanks,


