Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1A64F8AA8
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Apr 2022 02:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbiDGXyJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Apr 2022 19:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbiDGXyG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Apr 2022 19:54:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 971FDB1E6
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 16:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649375523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aT+8Onnd/n07pHnEWWUWTn2vpI0YJYxs4oYEJhHP/Ac=;
        b=dRCRbhu+dcRnepMPrmuMdxab3uSz9CXNZd7t5a693bR6WE2UKMSrjUGcKUd6MPEJhVu1Sp
        22ShgPC6Ymbyf9PAWVMQR0Nub513Q/ZPobi8nQBGTUnWW8g2pgqPgFIwAN71vX3aRwz7fM
        uAs0zDg6CT7qW+lVm29Hxg5jRVXZdPA=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-428-lgPXz244Nk21Wv_a5Bpu1Q-1; Thu, 07 Apr 2022 19:52:02 -0400
X-MC-Unique: lgPXz244Nk21Wv_a5Bpu1Q-1
Received: by mail-pj1-f71.google.com with SMTP id ob7-20020a17090b390700b001c692ec6de4so6646437pjb.7
        for <ceph-devel@vger.kernel.org>; Thu, 07 Apr 2022 16:52:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=aT+8Onnd/n07pHnEWWUWTn2vpI0YJYxs4oYEJhHP/Ac=;
        b=ijog5OtRqqvjyJjmRMmQdGIp+vc0vme/RfChy5lBiUjhDQRrBNkqschAOr48QX2STZ
         0tfNezFyUFn3yiCY/c3ZoI72qu0HxSBiPbtcQm4CIX2RFIAQPl0HLjKL9r8D9jR7DdtO
         6HcLl/D89iexFHw+/DKtnx7KwQbhAGoMFjwF/Hru4/97YigEPhDzjSvLG91ZceUPv6uO
         dKZYceEgwXaQZxrSqtkq3Imvowvc8P9km7+do+wdYAZBhKczZs+/yt5uRZ8YgrhXRY7f
         M9iBfVkY+lz9/JBEd/Uigxu8H1Sev6QOqiXj1cdEIEKyn5C4I/xC//BVw+ug/m/iH+8k
         IbtA==
X-Gm-Message-State: AOAM532UalyzsomWuSkwcyqkaco5K48a3KRxl9w1V+pMaCgQh3PjHIIi
        LYAtFOmUNjS9d1T4fkl5dxcaBz3iSauQk/wzDzmWkswrr2LTpE66hkQTtfh4eLWoqsqvHEyT7X9
        CX6wXeHxRDp7C6xo8pb0lEQ==
X-Received: by 2002:a17:90b:1a87:b0:1c7:3d66:8cb with SMTP id ng7-20020a17090b1a8700b001c73d6608cbmr18726945pjb.142.1649375521353;
        Thu, 07 Apr 2022 16:52:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfKMgguqkFdrUbAYwtF3FRFFuvOLctyEkl2YPYCfxTGPFDI1PivMs0Y3AhBkjVOIT6pep6lg==
X-Received: by 2002:a17:90b:1a87:b0:1c7:3d66:8cb with SMTP id ng7-20020a17090b1a8700b001c73d6608cbmr18726925pjb.142.1649375521062;
        Thu, 07 Apr 2022 16:52:01 -0700 (PDT)
Received: from [10.72.12.194] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k6-20020a056a00134600b004faba67f9d4sm24513239pfu.197.2022.04.07.16.51.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 16:52:00 -0700 (PDT)
Subject: Re: [PATCH v4] ceph: invalidate pages when doing direct/sync writes
To:     Jeff Layton <jlayton@kernel.org>,
        =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220407151521.7968-1-lhenriques@suse.de>
 <385d353d-56d8-8f2a-b468-2aae048f59ef@redhat.com>
 <66740f5e59d52b600d5033a07b794b78dfaf3c18.camel@kernel.org>
 <822cca41-f700-3cba-e2c8-d1fbe5a934b1@redhat.com>
 <c211631e19e8ed9c57cdb65a540ca3a38180016a.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3cd264d0-bcb6-204b-7997-4f1d000c9dab@redhat.com>
Date:   Fri, 8 Apr 2022 07:51:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <c211631e19e8ed9c57cdb65a540ca3a38180016a.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/8/22 4:21 AM, Jeff Layton wrote:
> On Fri, 2022-04-08 at 03:24 +0800, Xiubo Li wrote:
>> On 4/8/22 3:16 AM, Jeff Layton wrote:
>>> On Fri, 2022-04-08 at 03:03 +0800, Xiubo Li wrote:
>>>> On 4/7/22 11:15 PM, Luís Henriques wrote:
>>>>> When doing a direct/sync write, we need to invalidate the page cache in
>>>>> the range being written to.  If we don't do this, the cache will include
>>>>> invalid data as we just did a write that avoided the page cache.
>>>>>
>>>>> Signed-off-by: Luís Henriques <lhenriques@suse.de>
>>>>> ---
>>>>>     fs/ceph/file.c | 19 ++++++++++++++-----
>>>>>     1 file changed, 14 insertions(+), 5 deletions(-)
>>>>>
>>>>> Changes since v3:
>>>>> - Dropped initial call to invalidate_inode_pages2_range()
>>>>> - Added extra comment to document invalidation
>>>>>
>>>>> Changes since v2:
>>>>> - Invalidation needs to be done after a write
>>>>>
>>>>> Changes since v1:
>>>>> - Replaced truncate_inode_pages_range() by invalidate_inode_pages2_range
>>>>> - Call fscache_invalidate with FSCACHE_INVAL_DIO_WRITE if we're doing DIO
>>>>>
>>>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>>>> index 5072570c2203..97f764b2fbdd 100644
>>>>> --- a/fs/ceph/file.c
>>>>> +++ b/fs/ceph/file.c
>>>>> @@ -1606,11 +1606,6 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
>>>>>     		return ret;
>>>>>     
>>>>>     	ceph_fscache_invalidate(inode, false);
>>>>> -	ret = invalidate_inode_pages2_range(inode->i_mapping,
>>>>> -					    pos >> PAGE_SHIFT,
>>>>> -					    (pos + count - 1) >> PAGE_SHIFT);
>>>>> -	if (ret < 0)
>>>>> -		dout("invalidate_inode_pages2_range returned %d\n", ret);
>>>>>     
>>>>>     	while ((len = iov_iter_count(from)) > 0) {
>>>>>     		size_t left;
>>>>> @@ -1938,6 +1933,20 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
>>>>>     			break;
>>>>>     		}
>>>>>     		ceph_clear_error_write(ci);
>>>>> +
>>>>> +		/*
>>>>> +		 * we need to invalidate the page cache here, otherwise the
>>>>> +		 * cache will include invalid data in direct/sync writes.
>>>>> +		 */
>>>>> +		ret = invalidate_inode_pages2_range(
>>>> IMO we'd better use truncate_inode_pages_range() after write. The above
>>>> means it's possibly will write the dirty pagecache back, which will
>>>> overwrite and corrupt the disk data just wrote.
>>>>
>>> I disagree. We call filemap_write_and_wait_range at the start of this,
>>> so any data that was dirty when we called write() will be written back
>>> before the sync write.
>>>
>>> If we truncate the range, then we'll potentially lose writes that came
>>> in after write was issued but before truncate_inode_pages_range. I think
>>> we'd rather let what we just wrote be clobbered in this situation than
>>> lose a write altogether.
>>>
>>> All of this is somewhat academic though. If you're mixing buffered and
>>> direct writes like this without some sort of locking, then you're just
>>> asking for trouble. The aim here is "sane behavior to the best of our
>>> ability", but we can't expect it to always be sane when people do insane
>>> things. ;)
>> Just in the case Luis hit. Before writing the new data the mapping
>> happen when reading the src in copy_from_usr(). So once the writing done
>> the pagecache is caching the stale contents.
>>
> Not just in that case.
>
> You could have 2 unrelated processes, one doing DIO writes and one doing
> mmap writes. You're likely to end up with a mess unless you're very
> careful with what you're doing, but there should be some expectation
> that it will work if you serialize things correctly and/or have them
> writing to their own areas of the file, etc.

For this case I checked the other use cases, they are seems will do:


filemap_invalidate_lock(inode->i_mapping);

write pagecache back;

invalidate the mapping and drop the pages;

do the IOs;

filemap_invalidate_unlock(inode->i_mapping);


The filemap_invalidate_lock could prevent the page fault to map them 
again during this.



> In any case, we'll never get perfect cache coherency, and I figure that
> until the write returns, what's in the pagecache ought to be considered
> valid.

Okay, I am okay with this.

As my understanding is that we should make sure that the pagecache is 
always valid during the sync write, or if the pagecache will be 
revalidated it should just block the other processes to read from the mmap.

-- Xiubo
>>>> Though it seems impossible that these pagecaches will be marked dirty,
>>>> but this call is misleading ?
>>>>
>>> Not impossible at all. You can open a file O_DIRECT and then mmap the fd
>>> for PROT_WRITE (or just open the file a second time and do it).
>>>
>>> We definitely recommend against mixing buffered and direct I/O, but
>>> nothing really prevents someone from doing it. If the user is properly
>>> using file locking, then there's really no reason it shouldn't work.
>>>
>>>>> +				inode->i_mapping,
>>>>> +				pos >> PAGE_SHIFT,
>>>>> +				(pos + len - 1) >> PAGE_SHIFT);
>>>>> +		if (ret < 0) {
>>>>> +			dout("invalidate_inode_pages2_range returned %d\n",
>>>>> +			     ret);
>>>>> +			ret = 0;
>>>>> +		}
>>>>>     		pos += len;
>>>>>     		written += len;
>>>>>     		dout("sync_write written %d\n", written);
>>>>>

