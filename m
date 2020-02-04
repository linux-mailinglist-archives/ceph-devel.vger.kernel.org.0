Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 713FC151C7C
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Feb 2020 15:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgBDOos (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Feb 2020 09:44:48 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28028 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727258AbgBDOos (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Feb 2020 09:44:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580827487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5iBRdaRwtlHH+CZ9Hlcb+/z9vB5odBYEMeQsXJxyp8U=;
        b=Eazje9BoNPGG5WseKuZB0SOf14VTFCZwY8rd5cK6cyMgJZOJOGvKRJlfjpSrelM6QEPGm+
        68OcxrkZFHGurESG+cNtfPl+dU5czekvM6ibErM3Da0+yy1OPVpU0xHPe2PXFVsnQ9zAK4
        Vw7oSiJFqNMzOh1a3iZR/XeqmqmsCh8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-ShKffo_ZOYOxCZ6WDByEpA-1; Tue, 04 Feb 2020 09:44:45 -0500
X-MC-Unique: ShKffo_ZOYOxCZ6WDByEpA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64D2C800D55;
        Tue,  4 Feb 2020 14:44:44 +0000 (UTC)
Received: from [10.72.12.34] (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1105A85799;
        Tue,  4 Feb 2020 14:44:36 +0000 (UTC)
Subject: Re: [RFC PATCH v2] ceph: do not execute direct write in parallel if
 O_APPEND is specified
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, hch@infradead.org,
        ceph-devel@vger.kernel.org
References: <20200204022825.26538-1-xiubli@redhat.com>
 <fd6b6bf9247cbdc1be03637196d54feacce0d72c.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <915bbfd1-2e63-48c6-e43a-2af76c29aad1@redhat.com>
Date:   Tue, 4 Feb 2020 22:44:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <fd6b6bf9247cbdc1be03637196d54feacce0d72c.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/4 22:35, Jeff Layton wrote:
> On Mon, 2020-02-03 at 21:28 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> In O_APPEND & O_DIRECT mode, the data from different writers will
>> be possiblly overlapping each other with shared lock.
>>
>> For example, both Writer1 and Writer2 are in O_APPEND and O_DIRECT
>> mode:
>>
>>            Writer1                         Writer2
>>
>>       shared_lock()                   shared_lock()
>>       getattr(CAP_SIZE)               getattr(CAP_SIZE)
>>       iocb->ki_pos = EOF              iocb->ki_pos = EOF
>>       write(data1)
>>                                       write(data2)
>>       shared_unlock()                 shared_unlock()
>>
>> The data2 will overlap the data1 from the same file offset, the
>> old EOF.
>>
>> Switch to exclusive lock instead when O_APPEND is specified.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> Changed in V2:
>> - fix the commit comment
>> - add more detail in the commit comment
>> - s/direct_lock/shared_lock/g
>>
>>   fs/ceph/file.c | 17 +++++++++++------
>>   1 file changed, 11 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index ac7fe8b8081c..e3e67ef215dd 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -1475,6 +1475,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
>>   	struct ceph_cap_flush *prealloc_cf;
>>   	ssize_t count, written = 0;
>>   	int err, want, got;
>> +	bool shared_lock = false;
>>   	loff_t pos;
>>   	loff_t limit = max(i_size_read(inode), fsc->max_file_size);
>>   
>> @@ -1485,8 +1486,11 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
>>   	if (!prealloc_cf)
>>   		return -ENOMEM;
>>   
>> +	if ((iocb->ki_flags & (IOCB_DIRECT | IOCB_APPEND)) == IOCB_DIRECT)
>> +		shared_lock = true;
>> +
>>   retry_snap:
>> -	if (iocb->ki_flags & IOCB_DIRECT)
>> +	if (shared_lock)
>>   		ceph_start_io_direct(inode);
>>   	else
>>   		ceph_start_io_write(inode);
>> @@ -1576,14 +1580,15 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
>>   
>>   		/* we might need to revert back to that point */
>>   		data = *from;
>> -		if (iocb->ki_flags & IOCB_DIRECT) {
>> +		if (iocb->ki_flags & IOCB_DIRECT)
>>   			written = ceph_direct_read_write(iocb, &data, snapc,
>>   							 &prealloc_cf);
>> -			ceph_end_io_direct(inode);
>> -		} else {
>> +		else
>>   			written = ceph_sync_write(iocb, &data, pos, snapc);
>> +		if (shared_lock)
>> +			ceph_end_io_direct(inode);
>> +		else
>>   			ceph_end_io_write(inode);
>> -		}
>>   		if (written > 0)
>>   			iov_iter_advance(from, written);
>>   		ceph_put_snap_context(snapc);
>> @@ -1634,7 +1639,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
>>   
>>   	goto out_unlocked;
>>   out:
>> -	if (iocb->ki_flags & IOCB_DIRECT)
>> +	if (shared_lock)
>>   		ceph_end_io_direct(inode);
>>   	else
>>   		ceph_end_io_write(inode);
> Ok, I think this looks reasonable, but I actually preferred the
> "direct_lock" name you had before. I'm going to do some testing today
> and will probably merge this (with s/shared_lock/direct_lock/) if it
> tests out ok.

Okay :-) Thanks.

>

