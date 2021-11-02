Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B4E442A9A
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Nov 2021 10:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhKBJqs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 2 Nov 2021 05:46:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28504 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229577AbhKBJqs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 2 Nov 2021 05:46:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635846253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MfnOtUOjhZOPD6wUHHqJcQqu2sZ6CHgdihAINZ7II5E=;
        b=VVbLTgDwYjXnEr0LSGPzrV3cBqNNAGUN3r5eppEAjxvmsbRZNgckWyTaYW75tqvsN23oUd
        ZzFPj98+505UIlOLuqTVv+s0sfKsdd9Vsr4aCvh3Rd6cEHGxiI1R8RhcAAlcFIX/osaWBe
        2g3PoJ40A15Z2qv3nlSsYUYK6B+Yx8Q=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-DwuORy-DOkKaSR1qE4_2-g-1; Tue, 02 Nov 2021 05:44:12 -0400
X-MC-Unique: DwuORy-DOkKaSR1qE4_2-g-1
Received: by mail-pl1-f200.google.com with SMTP id u22-20020a170902a61600b00141ab5dd25dso4357273plq.5
        for <ceph-devel@vger.kernel.org>; Tue, 02 Nov 2021 02:44:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=MfnOtUOjhZOPD6wUHHqJcQqu2sZ6CHgdihAINZ7II5E=;
        b=kreWJuNt4qOt1KI6TpJtE/8aUKYmgIyNoxLChEqwZIFfLifQy+e+WTBq0ZbCznWvEr
         u6s08RontI8+s7URt3zafPTxibA2wM4KMLxjdIGRS9SVTs4gaJ4O04Y8r9TY6YWWRM/f
         zrzJ7TltTAfKjORjEX0Nwk72p86eQGOxPgBtcgGPq5VKI6iCbYdFjsTqmQvowbmRagXa
         mwoo/xPXVnIg6X8slT+5UN9uVbjH26mq+3DAGVUsKazb3CV3paEaJ3XqGr4gkNoTbnML
         UW2BvF+NdGUACJ34LRtfOIwsztbUPnWYbFXAFkleZk84PO9iMA5uzwSJeEHIYqw9whkZ
         jEIQ==
X-Gm-Message-State: AOAM531t5pyVnz3nk7sf4y26EEkmO70aHD80T46iiae/aBKOC9XiZArI
        ZQuzmF3YXyfxh3l17hc5L2sXaiiRHCKje/n+6w+Wg3qP5nJswg58X2DHOqkIP/LlxGoZOW3skHF
        BFvs8XLRw9RcGcMvwYBW060iv2m8UXThx576Bv6ZTIaDyLwwofnwRCiBXEgWJvhpPn6TcJUA=
X-Received: by 2002:a17:90b:3850:: with SMTP id nl16mr5233498pjb.10.1635846250755;
        Tue, 02 Nov 2021 02:44:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxs026OMZVSGK1jMHT0GjiiMZ+AVn1Q7O3P2evswaVW5RjGBkVn6iEtKB+xC4qqPtfaB0BrvQ==
X-Received: by 2002:a17:90b:3850:: with SMTP id nl16mr5233459pjb.10.1635846250396;
        Tue, 02 Nov 2021 02:44:10 -0700 (PDT)
Received: from [10.72.12.190] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 142sm15331693pgh.22.2021.11.02.02.44.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 02:44:09 -0700 (PDT)
Subject: Re: [PATCH v4 0/4] ceph: size handling for the fscrypt
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211101020447.75872-1-xiubli@redhat.com>
 <5c5d98f06c0a70271b324d9f144f44f8dddd91e5.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <220cf4cd-8634-67ed-fe2e-c34f4e87934e@redhat.com>
Date:   Tue, 2 Nov 2021 17:44:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <5c5d98f06c0a70271b324d9f144f44f8dddd91e5.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/1/21 6:27 PM, Jeff Layton wrote:
> On Mon, 2021-11-01 at 10:04 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This patch series is based on the "fscrypt_size_handling" branch in
>> https://github.com/lxbsz/linux.git, which is based Jeff's
>> "ceph-fscrypt-content-experimental" branch in
>> https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git
>> and added two upstream commits, which should be merged already.
>>
>> These two upstream commits should be removed after Jeff rebase
>> his "ceph-fscrypt-content-experimental" branch to upstream code.
>>
> I don't think I was clear last time. I'd like for you to post the
> _entire_ stack of patches that is based on top of
> ceph-client/wip-fscrypt-fnames. wip-fscrypt-fnames is pretty stable at
> this point, so I think it's a reasonable place for you to base your
> work. That way you're not beginning with a revert.

Hi Jeff,

BTW, have test by disabling the CONFIG_FS_ENCRYPTION option for branch 
ceph-client/wip-fscrypt-fnames ?

I have tried it today but the kernel will crash always with the 
following script. I tried many times the terminal, which is running 'cat 
/proc/kmsg' will always be stuck without any call trace about it.

# mkdir dir && echo "123" > dir/testfile

By enabling the CONFIG_FS_ENCRYPTION, I haven't countered any issue yet.

I am still debugging on it.


BRs

--Xiubo


>
> Again, feel free to cherry-pick any of the patches in any of my other
> branches for your series, but I'd like to see a complete series of
> patches.
>
> Thanks,
> Jeff
>
>
>> ====
>>
>> This approach is based on the discussion from V1 and V2, which will
>> pass the encrypted last block contents to MDS along with the truncate
>> request.
>>
>> This will send the encrypted last block contents to MDS along with
>> the truncate request when truncating to a smaller size and at the
>> same time new size does not align to BLOCK SIZE.
>>
>> The MDS side patch is raised in PR
>> https://github.com/ceph/ceph/pull/43588, which is also based Jeff's
>> previous great work in PR https://github.com/ceph/ceph/pull/41284.
>>
>> The MDS will use the filer.write_trunc(), which could update and
>> truncate the file in one shot, instead of filer.truncate().
>>
>> This just assume kclient won't support the inline data feature, which
>> will be remove soon, more detail please see:
>> https://tracker.ceph.com/issues/52916
>>
>> Changed in V4:
>> - Retry the truncate request by 20 times before fail it with -EAGAIN.
>> - Remove the "fill_last_block" label and move the code to else branch.
>> - Remove the #3 patch, which has already been sent out separately, in
>>    V3 series.
>> - Improve some comments in the code.
>>
>>
>> Changed in V3:
>> - Fix possibly corrupting the file just before the MDS acquires the
>>    xlock for FILE lock, another client has updated it.
>> - Flush the pagecache buffer before reading the last block for the
>>    when filling the truncate request.
>> - Some other minore fixes.
>>
>> Xiubo Li (4):
>>    Revert "ceph: make client zero partial trailing block on truncate"
>>    ceph: add __ceph_get_caps helper support
>>    ceph: add __ceph_sync_read helper support
>>    ceph: add truncate size handling support for fscrypt
>>
>>   fs/ceph/caps.c              |  21 ++--
>>   fs/ceph/file.c              |  44 +++++---
>>   fs/ceph/inode.c             | 203 ++++++++++++++++++++++++++++++------
>>   fs/ceph/super.h             |   6 +-
>>   include/linux/ceph/crypto.h |  28 +++++
>>   5 files changed, 251 insertions(+), 51 deletions(-)
>>   create mode 100644 include/linux/ceph/crypto.h
>>

