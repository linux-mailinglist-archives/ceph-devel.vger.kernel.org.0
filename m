Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462BD403896
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Sep 2021 13:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbhIHLRc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Sep 2021 07:17:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45628 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232630AbhIHLR3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Sep 2021 07:17:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631099781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=odxQhSKVx65kh/assoEMCEyTBbMigyCWI5weMQLoULY=;
        b=fqHiJBxMj+iBz2nbUS8Edvqz/PPTHA02yRdaK0/b3iOmkPkDLfdnN/kzRXAphf4DMETFEl
        WWhoZRXuCpIZkyErZGvWStZXCMruPnJSwPwgrItQa7FD5/cI+5nWgfK/v1Mpo/LNDZ16Pd
        RmyTDLxY3At8JKkG4SRE/EMoLzJtH4Y=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-wNUioIRUO4a0q6FNclWV4Q-1; Wed, 08 Sep 2021 07:16:20 -0400
X-MC-Unique: wNUioIRUO4a0q6FNclWV4Q-1
Received: by mail-pl1-f197.google.com with SMTP id o6-20020a170902bcc600b00138a9a5bc42so777859pls.17
        for <ceph-devel@vger.kernel.org>; Wed, 08 Sep 2021 04:16:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=odxQhSKVx65kh/assoEMCEyTBbMigyCWI5weMQLoULY=;
        b=vyAS6O3THz1novzjBaT3uiOzFPBb0GfHxqFTPSegbs6zjHXcNliQ1W3AjFkVE9XQjC
         Tt0dJVBV19AUlmIt8hua/uRkwzQaiBM7zEshDBx80/5WI5gpeiDz3koim2WA0lJeEeAs
         luXRhMivIG+AxTGMj3myQi5xJrUb0H1mToc8bSYmJqrULZ6cHYA6XtJ9AFirxVSPKOO9
         4HWJe7MnCLksjBTHj/oJV1ZkcbmdJHclVdbt+kQvg8vr30BpY6ZWJyAcRm6yYD2D1ZFW
         hq8vwpDLs0+4rOLGVeyWBPiyDPHiuOJ0YTReKuxrJ1IW9FKP9CB8yq0OPE6YCqGahbta
         6zaA==
X-Gm-Message-State: AOAM531JGYXURZ8fJdf2kookWIuOIT4P6sQBmvenUu/3XRkwxwXD1DPT
        140VrxEzaRR0Y0Fg+H4fZmXnc28xADezqp+7vOD3HyfnweR0J525Ks1fePijflE1lBkz9FAgdd1
        suN6zy6eQQ2NKQ5aiRBOpI2qNZdOjBfsCh6gE6B06OprTK/BJqDMd5x47XFzKvBCeltcPGGA=
X-Received: by 2002:a63:4917:: with SMTP id w23mr3167791pga.344.1631099778551;
        Wed, 08 Sep 2021 04:16:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyyRsWKSpwD5OiFsACqDqstlPdEFuVG0y+cXGuFoIKTSdF/p3omVlqjHupRBq/1ZPFgzAlLig==
X-Received: by 2002:a63:4917:: with SMTP id w23mr3167751pga.344.1631099778071;
        Wed, 08 Sep 2021 04:16:18 -0700 (PDT)
Received: from [10.72.12.125] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mv1sm1938145pjb.29.2021.09.08.04.16.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 04:16:17 -0700 (PDT)
Subject: Re: [PATCH RFC 0/2] ceph: size handling for the fscrypt
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20210903081510.982827-1-xiubli@redhat.com>
 <02f2f77423ec1e6e5b23b452716b21c36a5b67da.camel@kernel.org>
 <71db1836-4f1e-1c3d-077a-018bff32f60d@redhat.com>
 <68728d2700e98382aabdf298ac0ae7fad6615a2e.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <e815c6da-9660-a149-f2ff-bcb480d1bb6f@redhat.com>
Date:   Wed, 8 Sep 2021 19:16:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <68728d2700e98382aabdf298ac0ae7fad6615a2e.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/8/21 4:58 AM, Jeff Layton wrote:
> On Tue, 2021-09-07 at 21:19 +0800, Xiubo Li wrote:
>> On 9/7/21 8:35 PM, Jeff Layton wrote:
>>> On Fri, 2021-09-03 at 16:15 +0800, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> This patch series is based Jeff's ceph-fscrypt-size-experimental
>>>> branch in https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git.
>>>>
>>>> This is just a draft patch and need to rebase or recode after Jeff
>>>> finished his huge patch set.
>>>>
>>>> Post the patch out for advices and ideas. Thanks.
>>>>
>>> I'll take a look. Going forward though, it'd probably be best for you to
>>> just take over development of the entire ceph-fscrypt-size series
>>> instead of trying to develop on top of my branch.
>>>
>>> That branch is _very_ rough anyway. Just clone the branch into your tree
>>> and then you can drop or change patches in it as you see fit.
>> Sure.
>>
>>
>>>> ====
>>>>
>>>> This approach will not do the rmw immediately after the file is
>>>> truncated. If the truncate size is aligned to the BLOCK SIZE, so
>>>> there no need to do the rmw and only in unaligned case will the
>>>> rmw is needed.
>>>>
>>>> And the 'fscrypt_file' field will be cleared after the rmw is done.
>>>> If the 'fscrypt_file' is none zero that means after the kclient
>>>> reading that block to local buffer or pagecache it needs to do the
>>>> zeroing of that block in range of [fscrypt_file, round_up(fscrypt_file,
>>>> BLOCK SIZE)).
>>>>
>>>> Once any kclient has dirty that block and write it back to ceph, the
>>>> 'fscrypt_file' field will be cleared and set to 0. More detail please
>>>> see the commit comments in the second patch.
>>>>
>>> That sounds odd. How do you know where the file ends once you zero out
>>> fscrypt_file?
>>>
>>> /me goes to look at the patches...
>> The code in the ceph_fill_inode() is not handling well for multiple
>> ftruncates case, need to be fixed.
>>
> Ok. It'd probably be best to do that fix first in a separate patch and
> do the fscrypt work on top.
>
> FWIW, I'd really like to see the existing truncate code simplified (or
> at least, better documented). I'm very leery of adding yet more fields
> to the inode to handle truncate/size. So far, we have all of this:
>
>          struct mutex i_truncate_mutex;
>          u32 i_truncate_seq;        /* last truncate to smaller size */
>          u64 i_truncate_size;       /*  and the size we last truncated down to */
>          int i_truncate_pending;    /*  still need to call vmtruncate */
>
>          u64 i_max_size;            /* max file size authorized by mds */
>          u64 i_reported_size; /* (max_)size reported to or requested of mds */
>          u64 i_wanted_max_size;     /* offset we'd like to write too */
>          u64 i_requested_max_size;  /* max_size we've requested */
>
> Your patchset adds yet another new field with its own logic. I think we
> need to aim to simplify this code rather than just piling more logic on
> top.

Yeah, makes sense.


>
>> Maybe we need to change the 'fscrypt_file' field's logic and make it
>> opaqueness for MDS, then the MDS will use it to do the truncate instead
>> as I mentioned in the previous reply in your patch set.
>>
>> Then we can do the defer rmw in any kclient when necessary as this patch
>> does.
>>
> I think you can't defer the rmw unless you have Fb caps. In that case,
> you'd probably want to just truncate it in the pagecache, dirty the last
> page in the inode, and issue the truncate to the MDS.

> In the case where you don't have Fb caps, then I think you don't want to
> defer anything, as you can't guarantee another client won't get in there
> to read the object. On a truncate, you'll want to issue the truncate to
> the MDS and do the RMW on the last page. I'm not sure what order you'd
> want to do that in though. Maybe you can issue them simultaneously?

I am not sure I correctly understand this. If my understanding is correct:

If one kclient will ftruncate a file, the fscrypt_file will be recorded 
in the metadata. So after that this kclient could just release the Fwb 
caps if it has. And later for any kclient it should first get the 
fscrypt_file, so when:

A), reading, it should be granted the Fr caps, then we it always zero 
that specified block, which the contents needs to be truncated, just 
after the readed data dencrypted by using the fscrypt_file.

B), writing, if kclient wants to write data back to a file, it should 
always do the read-modify-write, right ? It will read the data to the 
local page buffers first by zeroing that specified block. Since it can 
buffer the data it should already have been granted the Fb caps. If that 
specified block will be updated, then it should update that whole block 
contents, and that whole block has already been truncated and modified. 
Then we can reset the fscrypt_file value in MDS, and at the same time we 
need to hold the Fx too. That means if encryption is enabled, when 
writing it should always get the Fx caps.

If one kclient have held the Fb caps, will MDS allow any other kclient 
to hold the Fr caps ?


For the Fb cap did I miss something ?



>>>> There also need on small work in Jeff's MDS PR in cap flushing code
>>>> to clear the 'fscrypt_file'.
>>>>
>>>>
>>>> Xiubo Li (2):
>>>>     Revert "ceph: make client zero partial trailing block on truncate"
>>>>     ceph: truncate the file contents when needed when file scrypted
>>>>
>>>>    fs/ceph/addr.c  | 19 ++++++++++++++-
>>>>    fs/ceph/caps.c  | 24 ++++++++++++++++++
>>>>    fs/ceph/file.c  | 65 ++++++++++++++++++++++++++++++++++++++++++++++---
>>>>    fs/ceph/inode.c | 48 +++++++++++++++++++-----------------
>>>>    fs/ceph/super.h | 13 +++++++---
>>>>    5 files changed, 138 insertions(+), 31 deletions(-)
>>>>

