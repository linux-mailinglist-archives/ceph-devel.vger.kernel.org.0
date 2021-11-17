Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D53453DA8
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Nov 2021 02:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbhKQBYz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Nov 2021 20:24:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:38809 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232617AbhKQBYl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 16 Nov 2021 20:24:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637112102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8xpqTyb9SiiAIJHeX75Mda7p8QHclYKEUfNwAx5eGkM=;
        b=adXf5UDM/H7zUoU0nEUNRTPxHh9WyTVN8jy8SYJGchMO8nfgveqACqHJfnHoXGHOv3NP1X
        MunoEX4gZEFMtXeczTfIOysneb3Pi/kfJgxhWxlniAQWqrseRKVUd9o5VFreN6EvddZqkR
        yveo2XkQgH19TUKahEifxgFcud873eg=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-4ZRSggguM_CNJdPTxc1y6g-1; Tue, 16 Nov 2021 20:21:41 -0500
X-MC-Unique: 4ZRSggguM_CNJdPTxc1y6g-1
Received: by mail-pj1-f71.google.com with SMTP id hg9-20020a17090b300900b001a6aa0b7d8cso464298pjb.2
        for <ceph-devel@vger.kernel.org>; Tue, 16 Nov 2021 17:21:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=8xpqTyb9SiiAIJHeX75Mda7p8QHclYKEUfNwAx5eGkM=;
        b=0eAwiO2bDWZ7NjGtrinkvpUMsmKNYhAhXaoIweDyYMuY6WH6WlnFswle2UoOjcPDtv
         GaS1KMzKlb3C5SEvxb/0bD8fHkwVLeye2J4t0/ZaEqQZPli8OZZhvBn5jg2ES9b5unbB
         GGprTGjKABaQICZs8X66EEMi0PM4RaRNrNSxxV8PeD9uKVoTHP7yaGdtuUNhM/n/kjLG
         vF0vSbDNNdo5ZNwxy2avUpANBHbP+B26SQCMNH9qnv/aZ5b0rtgG0U9cFIcCwe4RDVHR
         FodAwCvjMewc0Lk1kW2cHWPCOoCoxjnq0GkOA+WnxixFSBXYmYmVT3kzKLQK9zNgCH9c
         z33A==
X-Gm-Message-State: AOAM533X0XU9MapfnNstxz3h7VSw5ByKcHcz39dOM+cPcQiw8GdQsmUm
        jzGC+buFjbR+enN4GvRdxbg5J5GZe2D6PlJkc02W94I/ah6/SXTd/emicPeDO/+CACxwcXgIS8+
        x7GsfJmgWgth5xEdSlf8mkKGJ8WLdNXMqtBcBGZz57myoI8hG/juY1GQ4UxxPyqVgfYtGB3c=
X-Received: by 2002:a05:6a00:2351:b0:47b:d092:d2e4 with SMTP id j17-20020a056a00235100b0047bd092d2e4mr43687267pfj.76.1637112100077;
        Tue, 16 Nov 2021 17:21:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzzOHK9zk+njiOGN0lWuUtKjWXFiv+LdL2gedXNg+EeBKqeZxw7erZxM2L61Ww9DpKbbf2bhg==
X-Received: by 2002:a05:6a00:2351:b0:47b:d092:d2e4 with SMTP id j17-20020a056a00235100b0047bd092d2e4mr43687232pfj.76.1637112099732;
        Tue, 16 Nov 2021 17:21:39 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r8sm15580926pgp.30.2021.11.16.17.21.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 17:21:38 -0800 (PST)
Subject: Re: [PATCH] ceph: do not truncate pagecache if truncate size doesn't
 change
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20211116092002.99439-1-xiubli@redhat.com>
 <d37b49e0048ba3cf6763b83c82ad2fd8f8f36663.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <672440f9-e812-e97f-1c85-0343d7e8359e@redhat.com>
Date:   Wed, 17 Nov 2021 09:21:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <d37b49e0048ba3cf6763b83c82ad2fd8f8f36663.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/17/21 4:06 AM, Jeff Layton wrote:
> On Tue, 2021-11-16 at 17:20 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> In case truncating a file to a smaller sizeA, the sizeA will be kept
>> in truncate_size. And if truncate the file to a bigger sizeB, the
>> MDS will only increase the truncate_seq, but still using the sizeA as
>> the truncate_size.
>>
> Do you mean "kept in ci->i_truncate_size" ?

Sorry for confusing. It mainly will be kept in the MDS side's 
CInode->inode.truncate_size. And also will be propagated to all the 
clients' ci->i_truncate_size member.

The MDS will only change CInode->inode.truncate_size when truncating a 
smaller size.


> If so, is this really the
> correct fix? I'll note this in the sources:
>
>          u32 i_truncate_seq;        /* last truncate to smaller size */
>          u64 i_truncate_size;       /*  and the size we last truncated down to */
>
> Maybe the MDS ought not bump the truncate_seq unless it was truncating
> to a smaller size? If not, then that comment seems wrong at least.

Yeah, the above comments are inconsistent with what the MDS is doing.

Okay, I missed reading the code, I found in MDS that is introduced by 
commit :

      bf39d32d936 mds: bump truncate seq when fscrypt_file changes

With the size handling feature support, I think this commit will make no 
sense any more since we will calculate the 'truncating_smaller' by not 
only comparing the new_size and old_size, which both are rounded up to 
FSCRYPT BLOCK SIZE, will also check the 'req->get_data().length()' if 
the new_size and old_size are the same.


>
>> So when filling the inode it will truncate the pagecache by using
>> truncate_sizeA again, which makes no sense and will trim the inocent
>> pages.
>>
> Is there a reproducer for this? It would be nice to put something in
> xfstests for it if so.

In xfstests' generic/075 has already testing this, but i didn't see any 
issue it reproduce. I just found this strange logs when it's doing 
something like:

truncateA 0x10000 --> 0x2000

truncateB 0x2000   --> 0x8000

truncateC 0x8000   --> 0x6000

For the truncateC, the log says:

ceph:  truncate_size 0x2000 -> 0x6000


The problem is that the truncateB will also do the vmtruncate by using 
the 0x2000 instead, the vmtruncate will not flush the dirty pages to the 
OSD and will just discard them from the pagecaches. Then we may lost 
some new updated data in case there has any write before the truncateB 
in range [0x2000, 0x8000).


Thanks

BRs

-- Xiubo



>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/inode.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>> index 1b4ce453d397..b4f784684e64 100644
>> --- a/fs/ceph/inode.c
>> +++ b/fs/ceph/inode.c
>> @@ -738,10 +738,11 @@ int ceph_fill_file_size(struct inode *inode, int issued,
>>   			 * don't hold those caps, then we need to check whether
>>   			 * the file is either opened or mmaped
>>   			 */
>> -			if ((issued & (CEPH_CAP_FILE_CACHE|
>> +			if (ci->i_truncate_size != truncate_size &&
>> +			    ((issued & (CEPH_CAP_FILE_CACHE|
>>   				       CEPH_CAP_FILE_BUFFER)) ||
>>   			    mapping_mapped(inode->i_mapping) ||
>> -			    __ceph_is_file_opened(ci)) {
>> +			    __ceph_is_file_opened(ci))) {
>>   				ci->i_truncate_pending++;
>>   				queue_trunc = 1;
>>   			}

