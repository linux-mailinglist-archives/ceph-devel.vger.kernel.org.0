Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFFC2161BA
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jul 2020 00:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgGFW4F (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jul 2020 18:56:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36844 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726280AbgGFW4F (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Jul 2020 18:56:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594076163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Piot0nYhj5t5GZrLKTk5nixvg33t6O+51w3azuwHCGI=;
        b=HAJSKPgR7fo/90ruBZV14+tq1Dv6rb8F/DhMElVGdCYiTWz9sTfqyUXxve4+qqgnRnnKP5
        3f5viiOdt/ehJixeEK2olH+8qbqkCyu+TMThDedk1oq5TTVjjMREPqaLX07n76N5SIus3R
        ZdIIyPQyV0aWaunMjzJeeKThDk/cMtw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-5w8WBLm7OwqkOwKmf3c56w-1; Mon, 06 Jul 2020 18:55:59 -0400
X-MC-Unique: 5w8WBLm7OwqkOwKmf3c56w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65EA9461;
        Mon,  6 Jul 2020 22:55:57 +0000 (UTC)
Received: from [10.72.12.116] (ovpn-12-116.pek2.redhat.com [10.72.12.116])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 995457B41E;
        Mon,  6 Jul 2020 22:55:52 +0000 (UTC)
Subject: Re: [PATCH] ceph: do not access the kiocb after aio reqeusts
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20200706125135.23511-1-xiubli@redhat.com>
 <ae2bc42cc3434f62ea99f1df32729360a27e487c.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <012e8448-bd4f-26f8-b9e2-690c80b6f01d@redhat.com>
Date:   Tue, 7 Jul 2020 06:55:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <ae2bc42cc3434f62ea99f1df32729360a27e487c.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/7/7 0:17, Jeff Layton wrote:
> On Mon, 2020-07-06 at 08:51 -0400, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> In aio case, if the completion comes very fast just before the
>> ceph_read_iter() returns to fs/aio.c, the kiocb will be freed in
>> the completion callback, then if ceph_read_iter() access again
>> we will potentially hit the use-after-free bug.
>>
>> URL: https://tracker.ceph.com/issues/45649
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/file.c | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 160644ddaeed..704bae794054 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -1538,6 +1538,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
>>   	struct inode *inode = file_inode(filp);
>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>>   	struct page *pinned_page = NULL;
>> +	bool direct_lock = false;
> Looks good. I made a slight change to this patch and had it initialize
> this variable to iocb->ki_flags & IOCB_DIRECT, and then use that rather
> than setting direct_lock in the true case. Merged into testing.

Okay, looks good to me.

Thanks Jeff.


> Thanks!
>
>>   	ssize_t ret;
>>   	int want, got = 0;
>>   	int retry_op = 0, read = 0;
>> @@ -1546,10 +1547,12 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
>>   	dout("aio_read %p %llx.%llx %llu~%u trying to get caps on %p\n",
>>   	     inode, ceph_vinop(inode), iocb->ki_pos, (unsigned)len, inode);
>>   
>> -	if (iocb->ki_flags & IOCB_DIRECT)
>> +	if (iocb->ki_flags & IOCB_DIRECT) {
>>   		ceph_start_io_direct(inode);
>> -	else
>> +		direct_lock = true;
>> +	} else {
>>   		ceph_start_io_read(inode);
>> +	}
>>   
>>   	if (fi->fmode & CEPH_FILE_MODE_LAZY)
>>   		want = CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_LAZYIO;
>> @@ -1603,7 +1606,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
>>   	}
>>   	ceph_put_cap_refs(ci, got);
>>   
>> -	if (iocb->ki_flags & IOCB_DIRECT)
>> +	if (direct_lock)
>>   		ceph_end_io_direct(inode);
>>   	else
>>   		ceph_end_io_read(inode);


