Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6EA4424F8
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Nov 2021 02:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbhKBBFc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Nov 2021 21:05:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:24948 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229479AbhKBBFb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Nov 2021 21:05:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635814977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sLdeRQk4/UgsHiejhgemGcxe0q9pqBBxaFBuhU9wG4Q=;
        b=Eg7Q7jNERlZw1JA9PUA0KY6tpQXPu+0bTTJ7gtieIPFbQjr8RLZBubAf4nARYPqOu2IiY8
        0l8lWh/5mKUGHCIVQqT1oWm1MisX/hCKv1jff7gVLjO6+lfhZ+SuLx8YzXPxMfhn+wLsBv
        t49ZvrK39/HJfTU1ISEk3EJaXPF+9Vw=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-i8nThnEmPCGhN4Cg6UV3hg-1; Mon, 01 Nov 2021 21:02:56 -0400
X-MC-Unique: i8nThnEmPCGhN4Cg6UV3hg-1
Received: by mail-pl1-f197.google.com with SMTP id b23-20020a170902d89700b001415444f5a6so6828512plz.7
        for <ceph-devel@vger.kernel.org>; Mon, 01 Nov 2021 18:02:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=sLdeRQk4/UgsHiejhgemGcxe0q9pqBBxaFBuhU9wG4Q=;
        b=tLo3s1dz2nUlTSmSycgcjkKJHIRhUzGwraSsRXwNJROBnC34fmg72cei/s04rLVHC3
         YDolxFyIJMRY0F0nQT2FSIbue6Suki0CbqMqrB6XgA05Zkj9RN9wXhnVa5ZHtpq9tsZO
         5J5RoUCC7+87HwTYPAoAxdOvo7NQpleTtwpH5Q12Ymt2c/hN7vfyfbV0RJUb76EFzr0y
         QiXeHkETzjN+fWstn2eUP/j0+DnDbrNkKGj2KAz5aCix3QF69hR7Y81JyOl2QmvUEVN/
         BFlQG47dqkhXcKE8RbF9QFwjTi8vtDMKw3uQI0uPHKi7uWJ+z9+M5DP1Q6ya7IIrjcaM
         dONQ==
X-Gm-Message-State: AOAM5310tVED2WEnscLhoXP2b+mDfpzoXlKufURW43c909tuIA9UNfs1
        NLAsySvtP4oJKNvbXc8Vi41BOmd+RO073Kq/49H+QRuXz6qgW3V2QV4+UQ84O8f1eDNfBGcPQHE
        EUrQy3SpIe/rXrBqTHcoo/8llhu1GrnT+UIgKeSm+YqX9OrQtGOtIS8Qvthh7WioheeJo9XA=
X-Received: by 2002:a62:1a52:0:b0:481:10d:6b2f with SMTP id a79-20020a621a52000000b00481010d6b2fmr12476804pfa.84.1635814971867;
        Mon, 01 Nov 2021 18:02:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSKVgBMweRCJAXFYryow1JinUm/F8PFHC68iuqbDLdFwsyV0X8aJnw395C8wIzh4rbil1gMQ==
X-Received: by 2002:a62:1a52:0:b0:481:10d:6b2f with SMTP id a79-20020a621a52000000b00481010d6b2fmr12476169pfa.84.1635814964660;
        Mon, 01 Nov 2021 18:02:44 -0700 (PDT)
Received: from [10.72.12.190] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e14sm17470962pfv.192.2021.11.01.18.02.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 18:02:44 -0700 (PDT)
Subject: Re: [PATCH v4 0/4] ceph: size handling for the fscrypt
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211101020447.75872-1-xiubli@redhat.com>
 <5c5d98f06c0a70271b324d9f144f44f8dddd91e5.camel@kernel.org>
 <b4db9a2377711857118d1fbd5835b7b8d7c9019c.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <402e819c-2e80-a09f-2e92-988cc90ff9b8@redhat.com>
Date:   Tue, 2 Nov 2021 09:02:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <b4db9a2377711857118d1fbd5835b7b8d7c9019c.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/2/21 1:07 AM, Jeff Layton wrote:
> On Mon, 2021-11-01 at 06:27 -0400, Jeff Layton wrote:
>> On Mon, 2021-11-01 at 10:04 +0800, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> This patch series is based on the "fscrypt_size_handling" branch in
>>> https://github.com/lxbsz/linux.git, which is based Jeff's
>>> "ceph-fscrypt-content-experimental" branch in
>>> https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git
>>> and added two upstream commits, which should be merged already.
>>>
>>> These two upstream commits should be removed after Jeff rebase
>>> his "ceph-fscrypt-content-experimental" branch to upstream code.
>>>
>> I don't think I was clear last time. I'd like for you to post the
>> _entire_ stack of patches that is based on top of
>> ceph-client/wip-fscrypt-fnames. wip-fscrypt-fnames is pretty stable at
>> this point, so I think it's a reasonable place for you to base your
>> work. That way you're not beginning with a revert.
>>
>> Again, feel free to cherry-pick any of the patches in any of my other
>> branches for your series, but I'd like to see a complete series of
>> patches.
>>
>>
> To be even more clear:
>
> The main reason this patchset is not helpful is that the
> ceph-fscrypt-content-experimental branch in my tree has bitrotted in the
> face of other changes that have gone into the testing branch since it
> was cut. Also, that branch had several patches that added in actual
> encryption of the content, which we don't want to do at this point.
>
> For the work you're doing, what I'd like to see is a patchset based on
> top of the ceph-client/wip-fscrypt-fnames branch. That patchset should
> make it so what when encryption is enabled, the size handling for the
> inode is changed to use the new scheme we've added, but don't do any
> actual content encryption yet. Feel free to pick any of the patches in
> my trees that you need to do this, but it needs to be the whole series.
>
> What we need to be able to do in this phase is validate that the size
> handling is correct in both the encrypted and non-encrypted cases, but
> without encrypting the data. Once that piece is working, then we should
> be able to add in content encryption.

Okay, get it.

I will cleanup the code and respin it later.

BRs

-- Xiubo


>
>>> ====
>>>
>>> This approach is based on the discussion from V1 and V2, which will
>>> pass the encrypted last block contents to MDS along with the truncate
>>> request.
>>>
>>> This will send the encrypted last block contents to MDS along with
>>> the truncate request when truncating to a smaller size and at the
>>> same time new size does not align to BLOCK SIZE.
>>>
>>> The MDS side patch is raised in PR
>>> https://github.com/ceph/ceph/pull/43588, which is also based Jeff's
>>> previous great work in PR https://github.com/ceph/ceph/pull/41284.
>>>
>>> The MDS will use the filer.write_trunc(), which could update and
>>> truncate the file in one shot, instead of filer.truncate().
>>>
>>> This just assume kclient won't support the inline data feature, which
>>> will be remove soon, more detail please see:
>>> https://tracker.ceph.com/issues/52916
>>>
>>> Changed in V4:
>>> - Retry the truncate request by 20 times before fail it with -EAGAIN.
>>> - Remove the "fill_last_block" label and move the code to else branch.
>>> - Remove the #3 patch, which has already been sent out separately, in
>>>    V3 series.
>>> - Improve some comments in the code.
>>>
>>>
>>> Changed in V3:
>>> - Fix possibly corrupting the file just before the MDS acquires the
>>>    xlock for FILE lock, another client has updated it.
>>> - Flush the pagecache buffer before reading the last block for the
>>>    when filling the truncate request.
>>> - Some other minore fixes.
>>>
>>> Xiubo Li (4):
>>>    Revert "ceph: make client zero partial trailing block on truncate"
>>>    ceph: add __ceph_get_caps helper support
>>>    ceph: add __ceph_sync_read helper support
>>>    ceph: add truncate size handling support for fscrypt
>>>
>>>   fs/ceph/caps.c              |  21 ++--
>>>   fs/ceph/file.c              |  44 +++++---
>>>   fs/ceph/inode.c             | 203 ++++++++++++++++++++++++++++++------
>>>   fs/ceph/super.h             |   6 +-
>>>   include/linux/ceph/crypto.h |  28 +++++
>>>   5 files changed, 251 insertions(+), 51 deletions(-)
>>>   create mode 100644 include/linux/ceph/crypto.h
>>>

