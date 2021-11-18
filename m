Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1454552CE
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Nov 2021 03:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235689AbhKRClr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 Nov 2021 21:41:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49244 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232147AbhKRClq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 21:41:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637203126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fmmN+oRdg61/ZEBm76Af5adB8qZ60Sf2P4EalFTJJlc=;
        b=fj8LL9CXs6oosggZrpDpE1s93Hl6GJy5SICysqGZ0cu/9nIoKmXGRSkrsuTn9eKLqo7zo5
        nz9gQUcplO6mv3oCHjuC0Bb/bKm1zJ5yzYCmzEAHII1kccJgIes4C52wFstPW1cRKeuEiG
        Gj12ZUZArY0cbOaQMsOPC/B70fjAbYw=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-Lqwg1BwSNiSdeUqMoCrTYQ-1; Wed, 17 Nov 2021 21:38:45 -0500
X-MC-Unique: Lqwg1BwSNiSdeUqMoCrTYQ-1
Received: by mail-pl1-f200.google.com with SMTP id y6-20020a17090322c600b001428ab3f888so2213374plg.8
        for <ceph-devel@vger.kernel.org>; Wed, 17 Nov 2021 18:38:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=fmmN+oRdg61/ZEBm76Af5adB8qZ60Sf2P4EalFTJJlc=;
        b=UY9lQl7SHEARgTrXe6T2iYlc5LG7a7XEFsE4H3M1zMwbAnI98HyDSxCbK8cHypijki
         lXOpC2NjKtTPxNzArDMzTZRZiVggqJ64VXPDz/fPEb/TovxHErWT7UW3GvOf1wyvYAm0
         kMRcoBhIhLO1NbSRXn7tnNbHlD99bVIabfG5+6vA/40bJRWtDNdqWoTryHrHDAJo8pv4
         WFsZz/LZwIsHSVSf1Fk1qokgfhVXd5lRXcARyBjlMaiTKF+RyKbmBzINKHzHKkQBzzS6
         eJulLN43wwdqaZaRa8Ag8WZPpSNNzF9+5Pz5CLJ1mwCZr+rGuXNhls+cyh5rZjNaLXud
         b3lQ==
X-Gm-Message-State: AOAM533MYVUwCfzyavdh6CjDx9u1hO6C1uI17pzaFvycrmAFKo6u90PJ
        6FK4TmK7KwWDViwyWhfafaLzAs8OUeXAdtNKgIdAdRmm7wna08morf07pfwSJu3iYGbfn8ADHpT
        fRZF8C3sOY75nGmps9Bc1lTVvl1L3n+qyXHUj4KWFbnHsQ0K2sPqWcCzfwXhbU1FzFLKx3Vo=
X-Received: by 2002:a17:90b:3850:: with SMTP id nl16mr5972968pjb.190.1637203124389;
        Wed, 17 Nov 2021 18:38:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzEQm/xnrWJ044q0vFC3IVdc9KQ23HZbRU3BQuB39qcIGlQRrlHFt38lqEHk1PkLCCVFHQNRw==
X-Received: by 2002:a17:90b:3850:: with SMTP id nl16mr5972915pjb.190.1637203123926;
        Wed, 17 Nov 2021 18:38:43 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h6sm1034824pfh.82.2021.11.17.18.38.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 18:38:43 -0800 (PST)
Subject: Re: [PATCH] ceph: do not truncate pagecache if truncate size doesn't
 change
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20211116092002.99439-1-xiubli@redhat.com>
 <d37b49e0048ba3cf6763b83c82ad2fd8f8f36663.camel@kernel.org>
 <672440f9-e812-e97f-1c85-0343d7e8359e@redhat.com>
 <07f04cd3e3aeedf0d37db4acf4c7e8916c85f2b2.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3eae0499-6ab3-4541-f26e-89b0f518ab46@redhat.com>
Date:   Thu, 18 Nov 2021 10:38:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <07f04cd3e3aeedf0d37db4acf4c7e8916c85f2b2.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/17/21 11:06 PM, Jeff Layton wrote:
> On Wed, 2021-11-17 at 09:21 +0800, Xiubo Li wrote:
>> On 11/17/21 4:06 AM, Jeff Layton wrote:
>>> On Tue, 2021-11-16 at 17:20 +0800, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> In case truncating a file to a smaller sizeA, the sizeA will be kept
>>>> in truncate_size. And if truncate the file to a bigger sizeB, the
>>>> MDS will only increase the truncate_seq, but still using the sizeA as
>>>> the truncate_size.
>>>>
>>> Do you mean "kept in ci->i_truncate_size" ?
>> Sorry for confusing. It mainly will be kept in the MDS side's
>> CInode->inode.truncate_size. And also will be propagated to all the
>> clients' ci->i_truncate_size member.
>>
>> The MDS will only change CInode->inode.truncate_size when truncating a
>> smaller size.
>>
>>
>>> If so, is this really the
>>> correct fix? I'll note this in the sources:
>>>
>>>           u32 i_truncate_seq;        /* last truncate to smaller size */
>>>           u64 i_truncate_size;       /*  and the size we last truncated down to */
>>>
>>> Maybe the MDS ought not bump the truncate_seq unless it was truncating
>>> to a smaller size? If not, then that comment seems wrong at least.
>> Yeah, the above comments are inconsistent with what the MDS is doing.
>>
>> Okay, I missed reading the code, I found in MDS that is introduced by
>> commit :
>>
>>        bf39d32d936 mds: bump truncate seq when fscrypt_file changes
>>
>> With the size handling feature support, I think this commit will make no
>> sense any more since we will calculate the 'truncating_smaller' by not
>> only comparing the new_size and old_size, which both are rounded up to
>> FSCRYPT BLOCK SIZE, will also check the 'req->get_data().length()' if
>> the new_size and old_size are the same.
>>
>>
>>>> So when filling the inode it will truncate the pagecache by using
>>>> truncate_sizeA again, which makes no sense and will trim the inocent
>>>> pages.
>>>>
>>> Is there a reproducer for this? It would be nice to put something in
>>> xfstests for it if so.
>> In xfstests' generic/075 has already testing this, but i didn't see any
>> issue it reproduce. I just found this strange logs when it's doing
>> something like:
>>
>> truncateA 0x10000 --> 0x2000
>>
>> truncateB 0x2000   --> 0x8000
>>
>> truncateC 0x8000   --> 0x6000
>>
>> For the truncateC, the log says:
>>
>> ceph:  truncate_size 0x2000 -> 0x6000
>>
>>
>> The problem is that the truncateB will also do the vmtruncate by using
>> the 0x2000 instead, the vmtruncate will not flush the dirty pages to the
>> OSD and will just discard them from the pagecaches. Then we may lost
>> some new updated data in case there has any write before the truncateB
>> in range [0x2000, 0x8000).
>>
>>
>> Thanks
>>
>> BRs
>>
>> -- Xiubo
>>
>>
> I tested this today and was still able to reproduce failures in
> generic/029 and generic/075 with test_dummy_encryption enabled.

Hi Jeff,

I tested these two cases many times again today and both worked well for me.

[root@lxbceph1 xfstests]# ./check generic/075
FSTYP         -- ceph
PLATFORM      -- Linux/x86_64 lxbceph1 5.15.0+
MKFS_OPTIONS  -- 10.72.7.17:40543:/testB
MOUNT_OPTIONS -- -o 
test_dummy_encryption,name=admin,secret=AQDS3IFhEtxvORAAxn1d4FVN2bRUsc/TZMpQvQ== 
-o context=system_u:object_r:root_t:s0 10.72.7.17:40543:/testB 
/mnt/kcephfs/testD

generic/075 106s ... 356s
Ran: generic/075
Passed all 1 tests

[root@lxbceph1 xfstests]# ./check generic/029
FSTYP         -- ceph
PLATFORM      -- Linux/x86_64 lxbceph1 5.15.0+
MKFS_OPTIONS  -- 10.72.7.17:40543:/testB
MOUNT_OPTIONS -- -o 
test_dummy_encryption,name=admin,secret=AQDS3IFhEtxvORAAxn1d4FVN2bRUsc/TZMpQvQ== 
-o context=system_u:object_r:root_t:s0 10.72.7.17:40543:/testB 
/mnt/kcephfs/testD

generic/029 4s ... 3s
Ran: generic/029
Passed all 1 tests


> On the cluster-side, I'm using a cephadm cluster built using an image
> based on your fsize_support branch, rebased onto master (the Oct 7 base
> you're using is not good for cephadm).

I have updated this branch last night by rebasing it onto the latest 
upstream master.

And at the same time I have removed the commit:

         bf39d32d936 mds: bump truncate seq when fscrypt_file changes

> On the client side, I'm using the ceph-client/wip-fscrypt-size branch,
> along with this patch on top.

This I am also using the same branch from ceph-client repo. Nothing 
changed in my side.

To be safe I just deleted my local branches and synced from ceph-client 
repo today and test them again, still the same and worked for me.


> Xiubo, could you push branches with the current state of client and
> server patches that you're using to test this? Maybe that will help
> explain why I can still reproduce these problems and you can't.

The following is my config for 'local.config' in xfstests:

[root@lxbceph1 ~]# cat /mnt/kcephfs/xfstests/local.config
export FSTYP=ceph
export TEST_DEV=10.72.7.17:40543:/testA
export SCRATCH_DEV=10.72.7.17:40543:/testB
export TEST_DIR=/mnt/kcephfs/testC
export SCRATCH_MNT=/mnt/kcephfs/testD
export CEPHFS_MOUNT_OPTIONS="-o 
test_dummy_encryption,name=admin,secret=AQDS3IFhEtxvORAAxn1d4FVN2bRUsc/TZMpQvQ=="


And I cloned the xfstests from:

# wget http://download.ceph.com/qa/xfstests.tar.gz


BTW, what's the failure for generic/075 ? Is it the same one as before ?

On my side, before it failed just after 3 'trunc' in "075.2.fsxlog":

2317 3728 mapread    0x330312 thru   0x33a6b1        (0xa3a0 bytes)
2318 3730 punch      from 0x5ffc53 to 0x608516, (0x88c3 bytes)
2319 3731 write      0x6e9465 thru   0x6f8c04        (0xf7a0 bytes)
2320 3732 mapread    0x49f516 thru   0x49f570        (0x5b bytes)
2321 3733 write      0x72847b thru   0x733f14        (0xba9a bytes)
2322 3736 punch      from 0x2a90a0 to 0x2aa68e, (0x15ee bytes)
2323 3739 write      0x644a24 thru   0x64aa30        (0x600d bytes)
2324 3740 trunc      from 0x7aa4b0 to 0x9dbef3
2325 3741 mapread    0x5aa6bd thru   0x5b7246        (0xcb8a bytes)
2326 3742 trunc      from 0x9dbef3 to 0x718ae4
2327 3743 write      0x3ac9b0 thru   0x3aeee0        (0x2531 bytes)
2328 3744 read       0x6e171c thru   0x6f0fd6        (0xf8bb bytes)
2329 3747 trunc      from 0x718ae4 to 0x627ddb
2330 3748 mapread    0xe4e2c thru    0xf0bd5 (0xbdaa bytes)
2331 3752 write      0x71def1 thru   0x71e152        (0x262 bytes)
2332 3753 mapwrite   0x9eb0d8 thru   0x9f4ef7        (0x9e20 bytes)
2333 3754 mapwrite   0x7db56d thru   0x7e1278        (0x5d0c bytes)
2334 3755 punch      from 0x9368cb to 0x9437fb, (0xcf30 bytes)
2335 3757 write      0x366827 thru   0x3699ff        (0x31d9 bytes)
2336 3761 mapwrite   0x529471 thru   0x52b085        (0x1c15 bytes)
2337 3762 trunc      from 0x9f4ef8 to 0x86bfab
2338 3764 write      0x9c85b9 thru   0x9d0bdc        (0x8624 bytes)
2339 3765 mapread    0x11b451 thru   0x11fec5        (0x4a75 bytes)
2340 3766 write      0x5938cb thru   0x59e0d0        (0xa806 bytes)
2341 3767 read       0xe3063 thru    0xe8ee7 (0x5e85 bytes)
2342 3768 punch      from 0x859f3f to 0x8698ec, (0xf9ad bytes)
2343 3771 punch      from 0x86d188 to 0x86eef3, (0x1d6b bytes)
2344 3773 write      0x9f43c9 thru   0x9fffff        (0xbc37 bytes)
2345 3774 trunc      from 0xa00000 to 0x26d4b9
2346 3777 trunc      from 0x26d4b9 to 0x9c695f
2347 3783 trunc      from 0x9c695f to 0x9129ed
2348 3784 mapread    0x448402 thru   0x45074d        (0x834c bytes)
2349 READ BAD DATA: offset = 0x448402, size = 0x834c, fname = 075.2
2350 OFFSET  GOOD    BAD     RANGE
2351 0x448402        0x0000  0x74ea  0x00000
2352 operation# (mod 256) for the bad data may be 116
2353 0x448403        0x0000  0xea74  0x00001
2354 operation# (mod 256) for the bad data may be 116


Thanks

-- Xiubo

>
> Thanks,
> Jeff
>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/inode.c | 5 +++--
>>>>    1 file changed, 3 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>>>> index 1b4ce453d397..b4f784684e64 100644
>>>> --- a/fs/ceph/inode.c
>>>> +++ b/fs/ceph/inode.c
>>>> @@ -738,10 +738,11 @@ int ceph_fill_file_size(struct inode *inode, int issued,
>>>>    			 * don't hold those caps, then we need to check whether
>>>>    			 * the file is either opened or mmaped
>>>>    			 */
>>>> -			if ((issued & (CEPH_CAP_FILE_CACHE|
>>>> +			if (ci->i_truncate_size != truncate_size &&
>>>> +			    ((issued & (CEPH_CAP_FILE_CACHE|
>>>>    				       CEPH_CAP_FILE_BUFFER)) ||
>>>>    			    mapping_mapped(inode->i_mapping) ||
>>>> -			    __ceph_is_file_opened(ci)) {
>>>> +			    __ceph_is_file_opened(ci))) {
>>>>    				ci->i_truncate_pending++;
>>>>    				queue_trunc = 1;
>>>>    			}
>

