Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5128F4F8804
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Apr 2022 21:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiDGT0Y (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Apr 2022 15:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiDGT0W (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Apr 2022 15:26:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BEF8727855E
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 12:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649359457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6LrB8QqVmVJTM7qslCgqB5+zhESRJMYjHgGxDIr52us=;
        b=fquI3Ac8Q4rEwBWSjDMgVMcxosg0Xc2IVPbxHOWmN5kXJqGaKEkRxSF6VFfCkmbRTIHOKp
        LT+bCfzuWtefu3zXCXwE6cyXHUBIF68881GZCMvm+RErCn39hw+APAYdWU8VrNH1emF3wy
        OlBXrYA9b9yc7VyJ0bse6GknQo+5i6M=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-329-eV5DFhM3PqqEfxo9JAdsPA-1; Thu, 07 Apr 2022 15:24:16 -0400
X-MC-Unique: eV5DFhM3PqqEfxo9JAdsPA-1
Received: by mail-pg1-f198.google.com with SMTP id r11-20020a63440b000000b0038068f34b0cso3581738pga.0
        for <ceph-devel@vger.kernel.org>; Thu, 07 Apr 2022 12:24:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6LrB8QqVmVJTM7qslCgqB5+zhESRJMYjHgGxDIr52us=;
        b=bAOGcm9mBztkTP58ZEMtcQ7j9AlVDdiWh68qn8f00scgXFpkbuHXbFW6/t4mzaGl0/
         dt4NGjLT9XxTG85m2uc2GeMLFOtF3CxWxkB3ZodpOsVmQNCTuIDfPvBEqOENAq6kycfK
         BgmY/5nxvUGV2Kjn11mSwRuIt1N3SIvjLwizH/V1M1qJ84gSYd+KAz+NJTW/hdKQxS6G
         v5RmP7s5vCPwbNEZilukc/ELMu5RQHIMqYKhzj95wppBr6oJ0Ie86QpxlmAhlPwUlLGv
         ieuLeXT67YB43paew/qZP4/3sLIVolJW/DFZiHjiYkVs3cKTluGnrG+UWTIDaie3JLr2
         53Hg==
X-Gm-Message-State: AOAM533jRYtrtoy8XrYkKbFesnh4OhVqmMP8wQsX9b6QdTZK9m2Zktv/
        /xP8RAY0ecwrIHeoi2YpY/bqCeTnU6U5uif8j5zbdf07cEmByih1wr7GjWcQofn/rGdfw7WrOsD
        7lfLhI+XxGBLv5U3btnkcMA==
X-Received: by 2002:a17:90a:3486:b0:1ca:c6a0:3f8f with SMTP id p6-20020a17090a348600b001cac6a03f8fmr17792378pjb.6.1649359455552;
        Thu, 07 Apr 2022 12:24:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzXfOIQCLes9V+sedmT5KaDrgM82Q6nvvXMBr06hrbCj4z9Gt2yRFvFxYCrb4qQkEMnO98GA==
X-Received: by 2002:a17:90a:3486:b0:1ca:c6a0:3f8f with SMTP id p6-20020a17090a348600b001cac6a03f8fmr17792357pjb.6.1649359455282;
        Thu, 07 Apr 2022 12:24:15 -0700 (PDT)
Received: from [10.72.12.194] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j7-20020a056a00130700b004b9f7cd94a4sm23440672pfu.56.2022.04.07.12.24.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 12:24:14 -0700 (PDT)
Subject: Re: [PATCH v4] ceph: invalidate pages when doing direct/sync writes
To:     Jeff Layton <jlayton@kernel.org>,
        =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220407151521.7968-1-lhenriques@suse.de>
 <385d353d-56d8-8f2a-b468-2aae048f59ef@redhat.com>
 <66740f5e59d52b600d5033a07b794b78dfaf3c18.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <822cca41-f700-3cba-e2c8-d1fbe5a934b1@redhat.com>
Date:   Fri, 8 Apr 2022 03:24:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <66740f5e59d52b600d5033a07b794b78dfaf3c18.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/8/22 3:16 AM, Jeff Layton wrote:
> On Fri, 2022-04-08 at 03:03 +0800, Xiubo Li wrote:
>> On 4/7/22 11:15 PM, Luís Henriques wrote:
>>> When doing a direct/sync write, we need to invalidate the page cache in
>>> the range being written to.  If we don't do this, the cache will include
>>> invalid data as we just did a write that avoided the page cache.
>>>
>>> Signed-off-by: Luís Henriques <lhenriques@suse.de>
>>> ---
>>>    fs/ceph/file.c | 19 ++++++++++++++-----
>>>    1 file changed, 14 insertions(+), 5 deletions(-)
>>>
>>> Changes since v3:
>>> - Dropped initial call to invalidate_inode_pages2_range()
>>> - Added extra comment to document invalidation
>>>
>>> Changes since v2:
>>> - Invalidation needs to be done after a write
>>>
>>> Changes since v1:
>>> - Replaced truncate_inode_pages_range() by invalidate_inode_pages2_range
>>> - Call fscache_invalidate with FSCACHE_INVAL_DIO_WRITE if we're doing DIO
>>>
>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>> index 5072570c2203..97f764b2fbdd 100644
>>> --- a/fs/ceph/file.c
>>> +++ b/fs/ceph/file.c
>>> @@ -1606,11 +1606,6 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
>>>    		return ret;
>>>    
>>>    	ceph_fscache_invalidate(inode, false);
>>> -	ret = invalidate_inode_pages2_range(inode->i_mapping,
>>> -					    pos >> PAGE_SHIFT,
>>> -					    (pos + count - 1) >> PAGE_SHIFT);
>>> -	if (ret < 0)
>>> -		dout("invalidate_inode_pages2_range returned %d\n", ret);
>>>    
>>>    	while ((len = iov_iter_count(from)) > 0) {
>>>    		size_t left;
>>> @@ -1938,6 +1933,20 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
>>>    			break;
>>>    		}
>>>    		ceph_clear_error_write(ci);
>>> +
>>> +		/*
>>> +		 * we need to invalidate the page cache here, otherwise the
>>> +		 * cache will include invalid data in direct/sync writes.
>>> +		 */
>>> +		ret = invalidate_inode_pages2_range(
>> IMO we'd better use truncate_inode_pages_range() after write. The above
>> means it's possibly will write the dirty pagecache back, which will
>> overwrite and corrupt the disk data just wrote.
>>
> I disagree. We call filemap_write_and_wait_range at the start of this,
> so any data that was dirty when we called write() will be written back
> before the sync write.
>
> If we truncate the range, then we'll potentially lose writes that came
> in after write was issued but before truncate_inode_pages_range. I think
> we'd rather let what we just wrote be clobbered in this situation than
> lose a write altogether.
>
> All of this is somewhat academic though. If you're mixing buffered and
> direct writes like this without some sort of locking, then you're just
> asking for trouble. The aim here is "sane behavior to the best of our
> ability", but we can't expect it to always be sane when people do insane
> things. ;)

Just in the case Luis hit. Before writing the new data the mapping 
happen when reading the src in copy_from_usr(). So once the writing done 
the pagecache is caching the stale contents.

-- Xiubo

>> Though it seems impossible that these pagecaches will be marked dirty,
>> but this call is misleading ?
>>
> Not impossible at all. You can open a file O_DIRECT and then mmap the fd
> for PROT_WRITE (or just open the file a second time and do it).
>
> We definitely recommend against mixing buffered and direct I/O, but
> nothing really prevents someone from doing it. If the user is properly
> using file locking, then there's really no reason it shouldn't work.
>
>>> +				inode->i_mapping,
>>> +				pos >> PAGE_SHIFT,
>>> +				(pos + len - 1) >> PAGE_SHIFT);
>>> +		if (ret < 0) {
>>> +			dout("invalidate_inode_pages2_range returned %d\n",
>>> +			     ret);
>>> +			ret = 0;
>>> +		}
>>>    		pos += len;
>>>    		written += len;
>>>    		dout("sync_write written %d\n", written);
>>>

