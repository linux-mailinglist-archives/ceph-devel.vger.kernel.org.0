Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3667316120D
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Feb 2020 13:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbgBQMby (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Feb 2020 07:31:54 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31921 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729308AbgBQMby (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Feb 2020 07:31:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581942713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s/KpJMdkY05QVTtlDgaiy+q/qvBkHN9DvBq/NgbXHdo=;
        b=gpy0WuK/AtiDod8pUnr1eA9Zfl+8pl+qNiyCJIShscRz/dNgNvzMAK1TIkmZs0pvdtyZUw
        AMflPp2XI81dSJqnMRNnYUA3viHtffzDyEPOz94qgJ00MAg46KXpfTgsaPSgkay+GAUPQ7
        L8HAvs2mwiDylVt7MRZfwrmFW2s5Q9k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-3xQYNccrMk2z-dZwv9ybkA-1; Mon, 17 Feb 2020 07:31:51 -0500
X-MC-Unique: 3xQYNccrMk2z-dZwv9ybkA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B083101FC66;
        Mon, 17 Feb 2020 12:31:50 +0000 (UTC)
Received: from [10.72.12.166] (ovpn-12-166.pek2.redhat.com [10.72.12.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C1F0B2CC39;
        Mon, 17 Feb 2020 12:31:45 +0000 (UTC)
Subject: Re: [PATCH] ceph: fix dout logs for null pointers
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20200217112806.30738-1-xiubli@redhat.com>
 <a619e7b18c81e927fdd0b08509d1ca9d4299cdf9.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <1e9c4a94-68be-89fe-0a9e-f165f2858d72@redhat.com>
Date:   Mon, 17 Feb 2020 20:31:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <a619e7b18c81e927fdd0b08509d1ca9d4299cdf9.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/17 20:25, Jeff Layton wrote:
> On Mon, 2020-02-17 at 06:28 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> For example, if dentry and inode is NULL, the log will be:
>> ceph:  lookup result=000000007a1ca695
>> ceph:  submit_request on 0000000041d5070e for inode 000000007a1ca695
>>
>> The will be confusing without checking the corresponding code carefully.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/dir.c        | 2 +-
>>   fs/ceph/mds_client.c | 6 +++++-
>>   2 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>> index ffeaff5bf211..245a262ec198 100644
>> --- a/fs/ceph/dir.c
>> +++ b/fs/ceph/dir.c
>> @@ -798,7 +798,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
>>   	err = ceph_handle_snapdir(req, dentry, err);
>>   	dentry = ceph_finish_lookup(req, dentry, err);
>>   	ceph_mdsc_put_request(req);  /* will dput(dentry) */
>> -	dout("lookup result=%p\n", dentry);
>> +	dout("lookup result=%d\n", err);
>>   	return dentry;
>>   }
>>   
> The existing error handling in this function is really hard to follow
> (the way that "err" is passed to subsequent functions). It really took
> me a minute to figure out whether this change would make sense for all
> the cases. I think it does, but it might be nice to do a larger
> reorganization of this code if you're interested in improving it.

yeah, sure I will do it later.

Thanks.


>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index b6aa357f7c61..e34f159d262b 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -2772,7 +2772,11 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
>>   		ceph_get_cap_refs(ceph_inode(req->r_old_dentry_dir),
>>   				  CEPH_CAP_PIN);
>>   
>> -	dout("submit_request on %p for inode %p\n", req, dir);
>> +	if (dir)
>> +		dout("submit_request on %p for inode %p\n", req, dir);
>> +	else
>> +		dout("submit_request on %p\n", req);
>> +
>>   	mutex_lock(&mdsc->mutex);
>>   	__register_request(mdsc, req, dir);
>>   	__do_request(mdsc, req);
>
> I'll merge into testing later today.


