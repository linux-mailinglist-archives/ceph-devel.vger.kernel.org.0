Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABBA459978
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Nov 2021 02:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhKWBD6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 22 Nov 2021 20:03:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:35354 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229628AbhKWBD5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 20:03:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637629246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rD/TtP1WM+VB4Ndek5A6aMITwTX/TAxZCY47eWNJjGg=;
        b=brVJUDIcuIn535RKFM5VQYUGpUwMEgjaci4frsFl9DkKlL9FjjIRSzRa9+y7rIYQcZz2W3
        ewpqRLzLjlLhtRpdIRW3foz353Kud8lfCozHn0RXn+JJObixzg4j3WTMKtM2Wx5Yq7cdxH
        OyVYbqxU59CIS1gniBfnihegTln0Vck=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-fRdEnTKcPuKnzAtjetBEsg-1; Mon, 22 Nov 2021 20:00:45 -0500
X-MC-Unique: fRdEnTKcPuKnzAtjetBEsg-1
Received: by mail-pf1-f197.google.com with SMTP id s22-20020a056a0008d600b00480fea2e96cso10792257pfu.7
        for <ceph-devel@vger.kernel.org>; Mon, 22 Nov 2021 17:00:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=rD/TtP1WM+VB4Ndek5A6aMITwTX/TAxZCY47eWNJjGg=;
        b=FUVlU1dLcOmfweylSBTLbRa0twKXM7c3S+awkkUjd3KhfeiM3RWGMdFjWfr2VYZ+kM
         o4a/NkWJPMVGzKx+0Lj1chlRc2NdrMocUMgQ4ihQnQyrIQxGu9kBs4eE3yDTyn0kTkop
         1qaVLzjL9HABZKOJeJsXlR0lkgeglcFXa73YM9VEkSZn6GeBk0uDYa4rc8Q09IgVnOav
         to8POoKWGHITGq8P+g62rYJiUidu/fCjgHoRzN0lWAD0BS3OMtwp8PhCsCr0JES4l9DQ
         QPGqft1s75LB918nNZMZ2JOUrNGuzLy9ihkNalBEREC3ZuQ1E0+RXYcttsZ5XjBSqLsz
         D7cg==
X-Gm-Message-State: AOAM531raC/EehnMK/xjyYIl1ZYPStqHb3twBx34LIdGy7oYt3O5By1u
        rfQZ+MsVLsjKc14WG2PA7TJc86X3hm1HmyVNSKIo2TAa65efcANoJ8LMp3oPEvF2T1Gw/egm1yc
        AUU4xRgY2g7sH+r5Lvk0k/ydgNn6ifRKItRKebwZWpeMUBheCMYmPORQ+OOqKsPYBxsSTdV4=
X-Received: by 2002:aa7:87c5:0:b0:4a0:25d0:d88c with SMTP id i5-20020aa787c5000000b004a025d0d88cmr1531177pfo.43.1637629242981;
        Mon, 22 Nov 2021 17:00:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyjVLRYEg0OOQ1mDYtdYRf1OePp591Y1pbSUnEIUaD6OuU1dbM832Rv839zA7hKUzcSUx42MA==
X-Received: by 2002:aa7:87c5:0:b0:4a0:25d0:d88c with SMTP id i5-20020aa787c5000000b004a025d0d88cmr1531098pfo.43.1637629242298;
        Mon, 22 Nov 2021 17:00:42 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id fs21sm154696pjb.1.2021.11.22.17.00.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 17:00:39 -0800 (PST)
Subject: Re: [PATCH] ceph: do not truncate pagecache if truncate size doesn't
 change
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20211116092002.99439-1-xiubli@redhat.com>
 <09babbaf077a76ace4793f2e6ae6127d2e7d6411.camel@kernel.org>
 <1a6b7a20-ba30-0b57-3927-2b61ad64be28@redhat.com>
 <119f590bf2c576fff3ecf44295c7e7bbfcfeb3d8.camel@kernel.org>
 <fe9ce707-3118-a388-bbd4-50d80e957a89@redhat.com>
 <1fedf47381473c01c58cc7ea56e81e176ac7bd73.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <bfd6b13b-efdc-6362-de9d-92a243f5b166@redhat.com>
Date:   Tue, 23 Nov 2021 09:00:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1fedf47381473c01c58cc7ea56e81e176ac7bd73.camel@kernel.org>
Content-Type: multipart/mixed;
 boundary="------------1E6900A695B65FDA201744B9"
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------1E6900A695B65FDA201744B9
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit


On 11/23/21 3:10 AM, Jeff Layton wrote:
> On Sat, 2021-11-20 at 08:58 +0800, Xiubo Li wrote:
>> On 11/19/21 7:59 PM, Jeff Layton wrote:
>>> On Fri, 2021-11-19 at 12:29 +0800, Xiubo Li wrote:
>>>> On 11/19/21 2:13 AM, Jeff Layton wrote:
>>>>> On Tue, 2021-11-16 at 17:20 +0800, xiubli@redhat.com wrote:
>>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>>
>>>>>> In case truncating a file to a smaller sizeA, the sizeA will be kept
>>>>>> in truncate_size. And if truncate the file to a bigger sizeB, the
>>>>>> MDS will only increase the truncate_seq, but still using the sizeA as
>>>>>> the truncate_size.
>>>>>>
>>>>>> So when filling the inode it will truncate the pagecache by using
>>>>>> truncate_sizeA again, which makes no sense and will trim the inocent
>>>>>> pages.
>>>>>>
>>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>>> ---
>>>>>>     fs/ceph/inode.c | 5 +++--
>>>>>>     1 file changed, 3 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>>>>>> index 1b4ce453d397..b4f784684e64 100644
>>>>>> --- a/fs/ceph/inode.c
>>>>>> +++ b/fs/ceph/inode.c
>>>>>> @@ -738,10 +738,11 @@ int ceph_fill_file_size(struct inode *inode, int issued,
>>>>>>     			 * don't hold those caps, then we need to check whether
>>>>>>     			 * the file is either opened or mmaped
>>>>>>     			 */
>>>>>> -			if ((issued & (CEPH_CAP_FILE_CACHE|
>>>>>> +			if (ci->i_truncate_size != truncate_size &&
>>>>>> +			    ((issued & (CEPH_CAP_FILE_CACHE|
>>>>>>     				       CEPH_CAP_FILE_BUFFER)) ||
>>>>>>     			    mapping_mapped(inode->i_mapping) ||
>>>>>> -			    __ceph_is_file_opened(ci)) {
>>>>>> +			    __ceph_is_file_opened(ci))) {
>>>>>>     				ci->i_truncate_pending++;
>>>>>>     				queue_trunc = 1;
>>>>>>     			}
>>>>> Starting a new thread since this one is getting cluttered. I did a
>>>>> kernel build today with the wip-fscrypt-size branch with this patch on
>>>>> top and installed it on my client.
>>>>>
>>>>> I also rebuilt my cluster machine to use a container image based on your
>>>>> current fsize_support branch (commit 34eafd9db1ae). That host runs 3 VMs
>>>>> that each act as cephadm hosts. Each is assigned a physical ssd. I
>>>>> create two filesystems named "test" and "scratch", both with max_mds set
>>>>> to 3. Under each of those, I create a directory /client1 and set each up
>>>>> to use ceph.dir.pin.random at 0.1.
>>>>>
>>>>> I saw 2 test failures and then it hung on generic/444:
>>>>>
>>>>> generic/029 10s ... - output mismatch (see /home/jlayton/git/xfstests-dev/results//generic/029.out.bad)
>>>>>        --- tests/generic/029.out	2020-11-09 14:47:52.488429897 -0500
>>>>>        +++ /home/jlayton/git/xfstests-dev/results//generic/029.out.bad	2021-11-18 11:04:18.494800609 -0500
>>>>>        @@ -49,17 +49,3 @@
>>>>>         00001400  00                                                |.|
>>>>>         00001401
>>>>>         ==== Post-Remount ==
>>>>>        -00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58  |XXXXXXXXXXXXXXXX|
>>>>>        -*
>>>>>        -00000200  58 57 57 57 57 57 57 57  57 57 57 57 57 57 57 57  |XWWWWWWWWWWWWWWW|
>>>>>        -00000210  57 57 57 57 57 57 57 57  57 57 57 57 57 57 57 57  |WWWWWWWWWWWWWWWW|
>>>>>        ...
>>>>>        (Run 'diff -u /home/jlayton/git/xfstests-dev/tests/generic/029.out /home/jlayton/git/xfstests-dev/results//generic/029.out.bad'  to see the entire diff)
>>>>>
>>>>> generic/112 75s ... [failed, exit status 1]- output mismatch (see /home/jlayton/git/xfstests-dev/results//generic/112.out.bad)
>>>>>        --- tests/generic/112.out	2020-11-09 14:47:52.694435287 -0500
>>>>>        +++ /home/jlayton/git/xfstests-dev/results//generic/112.out.bad	2021-11-18 11:24:03.519631823 -0500
>>>>>        @@ -4,15 +4,4 @@
>>>>>         -----------------------------------------------
>>>>>         fsx.0 : -A -d -N numops -S 0
>>>>>         -----------------------------------------------
>>>>>        -
>>>>>        ------------------------------------------------
>>>>>        -fsx.1 : -A -d -N numops -S 0 -x
>>>>>        ------------------------------------------------
>>>>>        ...
>>>>>        (Run 'diff -u /home/jlayton/git/xfstests-dev/tests/generic/112.out /home/jlayton/git/xfstests-dev/results//generic/112.out.bad'  to see the entire diff)
>>>> Locally I am using the vstart_runner to setup the cluster with only one
>>>> filesystem, and couldn't reproduce any issue you mentioned this time.
>>>>
>>>>    From the "112.2.full" you attached, I can see that the mapread will
>>>> read the file range of [0x686907, 0x693eb9), which should be zero but
>>>> it's not:
>>>>
>>>> 3540 trunc    from 0x789289 to 0xd8b1
>>>> 3542 write    0x8571af thru    0x85e2af    (0x7101 bytes)
>>>> 3543 trunc    from 0x85e2b0 to 0x7dc986
>>>> 3550 read    0x3b37bd thru    0x3b50a8    (0x18ec bytes)
>>>> 3551 mapread    0x686907 thru    0x693eb9    (0xd5b3 bytes)
>>>> READ BAD DATA: offset = 0x686907, size = 0xd5b3, fname = 112.2
>>>> OFFSET    GOOD    BAD    RANGE
>>>> 0x686907    0x0000    0x198f    0x00000
>>>> operation# (mod 256) for the bad data may be 143
>>>> 0x686908    0x0000    0x8fec    0x00001
>>>> operation# (mod 256) for the bad data may be 143
>>>>
>>>> In theory that range should be truncated and zeroed in the first "trunc"
>>>> from 0x789289 to 0xd8b1 above. From the failure logs, it is the same
>>>> issue with before in generic/057 test case. But locally I couldn't
>>>> reproduce it after I fixing the bug in ceph fsize_support branch.
>>>>
>>>> BTW, could you reproduce this every time ? Or just occasionally ?
>>>>
>>>>
>>> I don't see the tests fail every time. 029 fails about 50% of the time
>>> though. The fsx tests don't seem to fail quite so often. It seems to be
>>> hard to reproduce these when running a single test in a loop, but when I
>>> run the "quick" group of tests, I usually get at least one failure.
>>>
>>> FWIW, my usual xfstests run is:
>>>
>>>       sudo ./check -g quick -E ./ceph.exclude
>>>
>>> ...with ceph.exclude having:
>>>
>>> ceph/001
>>> generic/003
>>> generic/531
>>> generic/538
>>>
>>> Most of the excluded tests actually work, but take a really long time on
>>> ceph. generic/003 always fails though (atime handling).
>> Okay.
>>
>> Before when I ran with the ceph.exlude it would fail since there hasn't
>> enough disk space. Let me try it again.
>>
>>
>>>>> I attached a tarball with the relevant output from the above two tests.
>>>>>
>>>>> The hang is also interesting, though it may be unrelated to size
>>>>> handling. It's just a touch command, and it's hung doing this:
>>>>>
>>>>> [jlayton@client1 xfstests-dev]$ sudo !!
>>>>> sudo cat /proc/100726/stack
>>>>> [<0>] ceph_mdsc_do_request+0x169/0x270 [ceph]
>>>>> [<0>] ceph_atomic_open+0x3eb/0x10f0 [ceph]
>>>>> [<0>] lookup_open.isra.0+0x59c/0x8f0
>>>>> [<0>] path_openat+0x4d2/0x10f0
>>>>> [<0>] do_filp_open+0x131/0x230
>>>>> [<0>] do_sys_openat2+0xe4/0x250
>>>>> [<0>] __x64_sys_openat+0xbd/0x110
>>>>> [<0>] do_syscall_64+0x3b/0x90
>>>>> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>>>
>>>>> This was in dmesg:
>>>>>
>>>>> [ 5338.083673] run fstests generic/444 at 2021-11-18 12:07:44
>>>>> [ 5405.607913] ceph: mds1 caps stale
>>>>> [ 5642.657735] ceph: mds1 hung
>>>>> [ 5644.964139] libceph: mds2 (2)192.168.1.81:6804 socket closed (con state OPEN)
>>>>> [ 5644.977876] libceph: mds0 (2)192.168.1.81:6814 socket closed (con state OPEN)
>>>>> [ 5645.159578] libceph: mds0 (2)192.168.1.81:6814 session reset
>>>>> [ 5645.168000] ceph: mds0 closed our session
>>>>> [ 5645.175634] ceph: mds0 reconnect start
>>>>> [ 5645.196569] ceph: mds0 reconnect denied
>>>>> [ 5648.295458] libceph: mds2 (2)192.168.1.81:6804 session reset
>>>>> [ 5648.303578] ceph: mds2 closed our session
>>>>> [ 5648.311251] ceph: mds2 reconnect start
>>>>> [ 5648.330261] ceph: mds2 reconnect denied
>>>>>
>>>>> The logs on mds1 show this:
>>>>>
>>>>> Nov 18 11:52:56 cephadm2 ceph-mds[2928]: mds.test.cephadm2.kfuenm Updating MDS map to version 106 from mon.1
>>>>> Nov 18 11:53:42 cephadm2 ceph-mds[2928]: mds.test.cephadm2.kfuenm Updating MDS map to version 107 from mon.1
>>>>> Nov 18 11:56:48 cephadm2 ceph-mds[2928]: mds.test.cephadm2.kfuenm asok_command: client ls {prefix=client ls} (starting...)
>>>>> Nov 18 11:57:38 cephadm2 ceph-mds[2928]: mds.test.cephadm2.kfuenm asok_command: client ls {prefix=client ls} (starting...)
>>>>> Nov 18 11:58:23 cephadm2 ceph-mds[2928]: mds.test.cephadm2.kfuenm asok_command: client ls {prefix=client ls} (starting...)
>>>>> Nov 18 12:00:08 cephadm2 ceph-mds[2928]: mds.test.cephadm2.kfuenm asok_command: client ls {prefix=client ls} (starting...)
>>>>> Nov 18 12:01:58 cephadm2 ceph-mds[2928]: mds.test.cephadm2.kfuenm asok_command: client ls {prefix=client ls} (starting...)
>>>>> Nov 18 12:03:28 cephadm2 ceph-mds[2928]: mds.test.cephadm2.kfuenm asok_command: client ls {prefix=client ls} (starting...)
>>>>> Nov 18 12:03:43 cephadm2 ceph-mds[2928]: mds.test.cephadm2.kfuenm asok_command: client ls {prefix=client ls} (starting...)
>>>>> Nov 18 12:05:16 cephadm2 ceph-mds[2928]: mds.test.cephadm2.kfuenm Updating MDS map to version 108 from mon.1
>>>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x2000000107f err -116/0
>>>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000085 err -116/0
>>>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000088 err -116/0
>>>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x2000000008b err -116/0
>>>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x2000000008e err -116/0
>>>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x2000000008e err -116/0
>>>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x2000000008f err -116/0
>>>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x2000000008f err -116/0
>>>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000090 err -116/0
>>>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000090 err -116/0
>>>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000091 err -116/0
>>>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000092 err -116/0
>>>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000092 err -116/0
>>>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000093 err -116/0
>>>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000094 err -116/0
>>>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000094 err -116/0
>>>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000095 err -116/0
>>>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000096 err -116/0
>>>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000096 err -116/0
>>>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000097 err -116/0
>>>>>
>>>>> -116 is -ESTALE.
>>>>>
>>>>> That repeats for a while and eventually the client is evicted.
>>>>>
>>>>> I'm not sure what to make of this hang, but I've seen it happen twice
>>>>> now. I'll see if it's reliably reproducible in a bit.
>>>>>
>>>>> As a side note, we probably do need to ensure that we not continue to
>>>>> wait on MDS ops on blacklisted sessions. If we get blacklisted, then we
>>>>> should wake up any waiters and fail any reqs that are in flight. I'll
>>>>> open a tracker for that soon.
>>>> Test this many times too:
>>>>
>>>> [root@lxbceph1 xfstests]# ./check generic/444
>>>> FSTYP         -- ceph
>>>> PLATFORM      -- Linux/x86_64 lxbceph1 5.15.0+
>>>> MKFS_OPTIONS  -- 10.72.47.117:40742:/testB
>>>> MOUNT_OPTIONS -- -o
>>>> test_dummy_encryption,name=admin,nowsync,copyfrom,rasize=4096 -o
>>>> context=system_u:object_r:root_t:s0 10.72.47.117:40742:/testB /mnt/kcephfs.B
>>>>
>>>> generic/444 2s ... 1s
>>>> Ran: generic/444
>>>> Passed all 1 tests
>>>>
>>>> [root@lxbceph1 xfstests]#
>>>>
>>>>
>>>> I am using almost the same mount options except the "ms_mode=crc". And
>>>> using the vstart_runner to setup the cluster and only one default
>>>> filesystem "a".
>>>>
>>> The msgr version probably doesn't matter much, but you never know.
>>>
>>>> The following is my kernel patches I am using:
>>>>
>>>> $ git log --oneline
>>>>
>>>> 33adb35fb859 (HEAD -> fscrypt_size_handling4) ceph: do not truncate
>>>> pagecache if truncate size doesn't change
>>>> 42cb4762205a (origin/wip-fscrypt-size, lxb-testing13) ceph: add truncate
>>>> size handling support for fscrypt
>>>> 428fe6185c09 ceph: add object version support for sync read
>>>> b0e5dcc4ad03 ceph: add __ceph_sync_read helper support
>>>> c316473f6c57 ceph: add __ceph_get_caps helper support
>>>> 50709509eef9 ceph: handle fscrypt fields in cap messages from MDS
>>>> 071d5fc5b21e ceph: get file size from fscrypt_file when present in inode
>>>> traces
>>>> 48c6a21c000c ceph: fscrypt_file field handling in MClientRequest messages
>>>> f101a36542a7 ceph: size handling for encrypted inodes in cap updates
>>>> 67f017e4edf9 libceph: add CEPH_OSD_OP_ASSERT_VER support
>>>> 98d487ede749 (origin/wip-fscrypt-fnames) ceph: don't allow changing
>>>> layout on encrypted files/directories
>>>> ...
>>>>
>>>>
>>> The kernel branch you're using is old. I rebased it earlier in the week
>>> so that it sits on top of v5.16-rc1. There are fscrypt changes in there
>>> that this set needed to be adapted for.
>> Okay, I will update it.
>>
>>
>>>> For ceph:
>>>>
>>>> $ git log --oneline
>>>>
>>>> 34eafd9db1a (HEAD -> jf_fscrypt2, lxb/fsize_support) mds: add truncate
>>>> size handling support for fscrypt
>>>> 4f9c1add5ff mds: don't allow changing layout on encrypted files/directories
>>>> 993189035ab mds: encode fscrypt_auth and fscrypt_file in appropriate mds
>>>> locks
>>>> 573c5bb1143 test: add fscrypt attribute testcases
>>>> 6e60ab066d9 client: add support for fscrypt_auth and fscrypt_file fields
>>>> be447f7911d mds: allow setattr to change fscrypt_auth/file
>>>> 40bb9bb5a26 mds: populate fscrypt_auth/_file on inode creation
>>>> b2838a2def2 client: send fscrypt_auth and fscrypt_file in MClientRequest
>>>> 6ae96259947 mds: add fscrypt_auth and fscrypt_file fields to MClientCaps
>>>> fd8f004f7a9 mds: encode fscrypt_auth and fscrypt_file in InodeStat
>>>> c8abd5f34bd mds: add fscrypt opaque field to inode_t encoding
>>>> 13619a8b96a mds: convert fscrypt flag to two opaque fields
>>>> 0471f922a9b common: add encode and decode routines for opaque vectors of
>>>> bytes
>>>> 4035ba419de (origin/master, origin/HEAD) Merge pull request #42906 from
>>>> sebastian-philipp/rm-ceph-orch-osd-i
>>>> ...
>>>>
>>>>
>>> I am using the same ceph branch as you are.
>>>
>>>> Not sure why my tests are different with yours ?
>>>>
>>> It could be all sorts of reasons. I have 3 MDS's per fs and I suspect
>>> vstart_runner only gives you 1. I have (consumer-grade) SSDs assigned to
>>> each OSD too. I'm also using random pinning, so that could be a factor
>>> as well.
>> I am also using 3 MDSs, the command is:
>>
>>     $ MDS=3 OSD=3 MON=3 MGR=1 ../src/vstart.sh -n -X -G --msgr1
>>
>> The '--msgr2' is not work well for me before so I keep using the msgr1
>> instead.
>>
>> And I'm also using the same random pinning as you mentioned in last mail.
>>
>> BRs
>>
>> --Xiubo
>>
>>
> One thing I'm finding today is that this patch reliably makes
> generic/445 hang at umount time with -o test_dummy_encryption
> enabled...which is a bit strange as the test doesn't actually run:
>
>      [jlayton@client1 xfstests-dev]$ sudo ./tests/generic/445
>      QA output created by 445
>      445 not run: xfs_io falloc  failed (old kernel/wrong fs?)
>      [jlayton@client1 xfstests-dev]$ sudo umount /mnt/test
>
> ...and the umount hangs waiting for writeback to complete. When I back
> this patch out, the problem goes away. Are you able to reproduce this?
>
> There are no mds or osd calls in flight, and no caps (according to
> debugfs). This is using -o test_dummy_encryption to force encryption.

I have hit a same issue without the "test_dummy_encryption", and it got 
stuck but I didn't see any call to ceph. But not the 445, I couldn't 
remember which one, I thought it was something wrong with my OS, I just 
rebooted my VM.

# ps -aux | grep generic

root      564385  0.0  0.0  11804  4700 pts/1    S+   09:41 0:00 
/bin/bash ./tests/generic/318

# cat /proc/564385/stack

[<0>] do_wait+0x2cc/0x4e0
[<0>] kernel_wait4+0xec/0x1b0
[<0>] __do_sys_wait4+0xe0/0xf0
[<0>] do_syscall_64+0x37/0x80
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae

I ran the ceph.exlude tests for two days, I just saw this one time.

I have attached the test results, does it the same with yours ? There 
have many test cases didn't run.

There have 4 failures and for the generic/020 it will be reproducable by 
30%. All the other 3 failures are every time, but they all seems not 
relevant to fscrypt.


> I narrowed it down to the call to _require_seek_data_hole. That calls
> the seek_sanity_test binary and after that point, umounting the fs
> hangs. I've not yet been successful at reproducing this while running
> the binary by hand, so there may be some other preliminary ops that are
> a factor too.
>
> In any case, this looks like a regression, so I'm going to drop this
> patch for now. I'll keep poking at the problem too however.

--------------1E6900A695B65FDA201744B9
Content-Type: text/plain; charset=UTF-8;
 name="ceph.exlude.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="ceph.exlude.txt"

[root@lxbceph1 xfstests]# ./check -g quick -E ./ceph.exclude
FSTYP         -- ceph
PLATFORM      -- Linux/x86_64 lxbceph1 5.16.0-rc1+
MKFS_OPTIONS  -- 10.72.47.117:40292:/testB
MOUNT_OPTIONS -- -o test_dummy_encryption,name=3Dadmin,nowsync,copyfrom,r=
asize=3D4096 -o context=3Dsystem_u:object_r:root_t:s0 10.72.47.117:40292:=
/testB /mnt/kcephfs.B

generic/001 33s ... 34s
generic/002 3s ... 3s
generic/003       [expunged]
generic/004	 [not run] xfs_io flink failed (old kernel/wrong fs?)
generic/005 2s ... 2s
generic/006 19s ... 21s
generic/007 72s ... 70s
generic/008	 [not run] xfs_io fzero failed (old kernel/wrong fs?)
generic/009	 [not run] xfs_io fzero failed (old kernel/wrong fs?)
generic/011 64s ... 38s
generic/012	 [not run] xfs_io falloc failed (old kernel/wrong fs?)
generic/013 63s ... 47s
generic/014 1387s ... 349s
generic/015	 [not run] Filesystem ceph not supported in _scratch_mkfs_siz=
ed
generic/016	 [not run] xfs_io falloc failed (old kernel/wrong fs?)
generic/018	 [not run] defragmentation not supported for fstype "ceph"
generic/020 29s ... - output mismatch (see /data/xfstests/results//generi=
c/020.out.bad)
    --- tests/generic/020.out	2021-11-04 10:18:48.546469180 +0800
    +++ /data/xfstests/results//generic/020.out.bad	2021-11-20 15:40:15.3=
80436848 +0800
    @@ -47,9 +47,13 @@
     user.snrub=3D"fish2\012"
    =20
     *** really long value
    -0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    -*
    -ATTRSIZE
    +attr_set: No space left on device
    ...
    (Run 'diff -u tests/generic/020.out /data/xfstests/results//generic/0=
20.out.bad'  to see the entire diff)
generic/021	 [not run] xfs_io falloc failed (old kernel/wrong fs?)
generic/022	 [not run] xfs_io falloc failed (old kernel/wrong fs?)
generic/023 6s ... 5s
generic/024	 [not run] fs doesn't support RENAME_NOREPLACE
generic/025	 [not run] fs doesn't support RENAME_EXCHANGE
generic/026	 [not run] ceph does not define maximum ACL count
generic/028 6s ... 6s
generic/029 5s ... 8s
generic/030 6s ... 12s
generic/031	 [not run] xfs_io fcollapse failed (old kernel/wrong fs?)
generic/032	 [not run] xfs_io falloc failed (old kernel/wrong fs?)
generic/033	 [not run] xfs_io fzero failed (old kernel/wrong fs?)
generic/034	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/035 2s ... 2s
generic/037 29s ... 30s
generic/039	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/040	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/041	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/050	 [not run] ceph does not support shutdown
generic/052	 [not run] ceph does not support shutdown
generic/053 4s ... 3s
generic/056	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/057	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/058	 [not run] xfs_io falloc failed (old kernel/wrong fs?)
generic/059	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/060	 [not run] xfs_io falloc failed (old kernel/wrong fs?)
generic/061	 [not run] xfs_io falloc failed (old kernel/wrong fs?)
generic/062	 - output mismatch (see /data/xfstests/results//generic/062.o=
ut.bad)
    --- tests/generic/062.out	2021-11-04 10:18:46.469286484 +0800
    +++ /data/xfstests/results//generic/062.out.bad	2021-11-20 15:42:13.1=
67728318 +0800
    @@ -13,7 +13,7 @@
    =20
     *** set/get one initially empty attribute
     # file: SCRATCH_MNT/reg
    -user.name
    +user.name=3D""
    =20
     *** overwrite empty, set several new attributes
    ...
    (Run 'diff -u tests/generic/062.out /data/xfstests/results//generic/0=
62.out.bad'  to see the entire diff)
generic/063	 [not run] xfs_io falloc failed (old kernel/wrong fs?)
generic/064	 [not run] xfs_io fiemap failed (old kernel/wrong fs?)
generic/065	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/066	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/067	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/069 106s ... 108s
generic/070 18s ... 63s
generic/071	 [not run] xfs_io falloc failed (old kernel/wrong fs?)
generic/073	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/075 99s ... 66s
generic/076	 [not run] require 10.72.47.117:40292:/testB to be local devi=
ce
generic/078	 [not run] fs doesn't support RENAME_WHITEOUT
generic/079	 [not run] file system doesn't support chattr +ia
generic/080 4s ... 4s
generic/081	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/082	 [not run] disk quotas not supported by this filesystem type:=
 ceph
generic/084 7s ... 7s
generic/086	 [not run] xfs_io falloc failed (old kernel/wrong fs?)
generic/087 1s ... 2s
generic/088 1s ... 1s
generic/090	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/091 402s ... 303s
generic/092	 [not run] xfs_io falloc failed (old kernel/wrong fs?)
generic/094	 [not run] xfs_io fiemap failed (old kernel/wrong fs?)
generic/096	 [not run] xfs_io fzero failed (old kernel/wrong fs?)
generic/097 3s ... 3s
generic/098 3s ... 2s
generic/099 5s ... 5s
generic/101	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/103	 [not run] xfs_io falloc failed (old kernel/wrong fs?)
generic/104	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/105 2s ... 2s
generic/106	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/107	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/108	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/110	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/111	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/112 65s ... 70s
generic/113 27s ... 30s
generic/114	 [not run] device block size: 4096 greater than 512
generic/115	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/116	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/117 20s ... 17s
generic/118	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/119	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/120 19s ... 19s
generic/121	 [not run] Dedupe not supported by test filesystem type: ceph=

generic/122	 [not run] Dedupe not supported by test filesystem type: ceph=

generic/123	 [not run] fsgqa user not defined.
generic/124 14s ... 10s
generic/126 3s ... 2s
generic/128	 [not run] fsgqa user not defined.
generic/129 477s ... 565s
generic/130 28s ... 29s
generic/131 2s ... 3s
generic/134	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/135 3s ... 2s
generic/136	 [not run] Dedupe not supported by test filesystem type: ceph=

generic/138	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/139	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/140	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/141 2s ... 2s
generic/142	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/143	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/144	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/145	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/146	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/147	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/148	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/149	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/150	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/151	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/152	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/153	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/154	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/155	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/156	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/157	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/158	 [not run] Dedupe not supported by test filesystem type: ceph=

generic/159	 [not run] lsattr not supported by test filesystem type: ceph=

generic/160	 [not run] lsattr not supported by test filesystem type: ceph=

generic/161	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/162	 [not run] Dedupe not supported by test filesystem type: ceph=

generic/163	 [not run] Dedupe not supported by test filesystem type: ceph=

generic/169 3s ... 3s
generic/171	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/172	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/173	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/174	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/177	 [not run] xfs_io fiemap failed (old kernel/wrong fs?)
generic/178	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/179	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/180	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/181	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/182	 [not run] Dedupe not supported by test filesystem type: ceph=

generic/183	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/184 1s ... 1s
generic/185	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/188	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/189	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/190	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/191	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/193	 [not run] fsgqa user not defined.
generic/194	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/195	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/196	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/197	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/198 4s ... 7s
generic/199	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/200	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/201	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/202	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/203	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/205	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/206	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/207 3s ... 3s
generic/210 1s ... 1s
generic/211 3s ... 4s
generic/212 2s ... 1s
generic/213	 [not run] xfs_io falloc failed (old kernel/wrong fs?)
generic/214	 [not run] xfs_io falloc failed (old kernel/wrong fs?)
generic/215 4s ... 4s
generic/216	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/217	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/218	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/219	 [not run] disk quotas not supported by this filesystem type:=
 ceph
generic/220	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/221 3s ... 3s
generic/222	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/223	 [not run] xfs_io falloc failed (old kernel/wrong fs?)
generic/225	 [not run] xfs_io fiemap failed (old kernel/wrong fs?)
generic/227	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/228	 [not run] xfs_io falloc failed (old kernel/wrong fs?)
generic/229	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/230	 [not run] disk quotas not supported by this filesystem type:=
 ceph
generic/235	 [not run] disk quotas not supported by this filesystem type:=
 ceph
generic/236 2s ... 2s
generic/237 2s ... 1s
generic/238	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/240 4s ... 3s
generic/244	 [not run] disk quotas not supported by this filesystem type:=
 ceph
generic/245 2s ... 1s
generic/246 2s ... 2s
generic/247 41s ... 43s
generic/248 1s ... 1s
generic/249 2s ... 2s
generic/250	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/252	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/253	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/254	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/255	 [not run] xfs_io falloc failed (old kernel/wrong fs?)
generic/256	 [not run] fsgqa user not defined.
generic/257 3s ... 4s
generic/258	 [failed, exit status 1] - output mismatch (see /data/xfstest=
s/results//generic/258.out.bad)
    --- tests/generic/258.out	2021-11-04 10:18:47.807404176 +0800
    +++ /data/xfstests/results//generic/258.out.bad	2021-11-20 16:09:19.0=
27866760 +0800
    @@ -1,5 +1,6 @@
     QA output created by 258
     Creating file with timestamp of Jan 1, 1960
     Testing for negative seconds since epoch
    -Remounting to flush cache
    -Testing for negative seconds since epoch
    +Timestamp wrapped: 0
    +Timestamp wrapped
    ...
    (Run 'diff -u tests/generic/258.out /data/xfstests/results//generic/2=
58.out.bad'  to see the entire diff)
generic/259	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/260	 [not run] FITRIM not supported on /mnt/kcephfs.B
generic/261	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/262	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/263 135s ... 192s
generic/264	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/265	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/266	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/267	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/268	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/271	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/272	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/276	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/277	 [not run] file system doesn't support chattr +A
generic/278	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/279	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/281	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/282	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/283	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/284	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/286 35s ... 48s
generic/287	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/288	 [not run] FITRIM not supported on /mnt/kcephfs.B
generic/289	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/290	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/291	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/292	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/293	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/294 2s ... 2s
generic/295	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/296	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/301	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/302	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/303	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/304	 [not run] Dedupe not supported by test filesystem type: ceph=

generic/305	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/306 3s ... 3s
generic/307 3s ... 4s
generic/308 1s ... 1s
generic/309 2s ... 2s
generic/312	 [not run] xfs_io falloc failed (old kernel/wrong fs?)
generic/313 5s ... 5s
generic/314	 [not run] fsgqa user not defined.
generic/315	 [not run] xfs_io falloc failed (old kernel/wrong fs?)
generic/316	 [not run] xfs_io fiemap failed (old kernel/wrong fs?)
generic/317	 [not run] fsgqa user not defined.
generic/318 3s ... 2s
generic/319 2s ... 2s
generic/321	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/322	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/324	 [not run] defragmentation not supported for fstype "ceph"
generic/325	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/326	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/327	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/328	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/329	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/330	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/331	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/332	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/335	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/336	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/337 2s ... 1s
generic/338	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/341	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/342	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/343	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/346 18s ... 19s
generic/347	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/348	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/353	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/355	 [not run] fsgqa user not defined.
generic/356	 [not run] swapfiles are not supported
generic/357	 [not run] swapfiles are not supported
generic/358	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/359	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/360 1s ... 1s
generic/361	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/362	 [not run] this test requires richacl support on $SCRATCH_DEV=

generic/363	 [not run] this test requires richacl support on $SCRATCH_DEV=

generic/364	 [not run] this test requires richacl support on $SCRATCH_DEV=

generic/365	 [not run] this test requires richacl support on $SCRATCH_DEV=

generic/366	 [not run] this test requires richacl support on $SCRATCH_DEV=

generic/367	 [not run] this test requires richacl support on $SCRATCH_DEV=

generic/368	 [not run] this test requires richacl support on $SCRATCH_DEV=

generic/369	 [not run] this test requires richacl support on $SCRATCH_DEV=

generic/370	 [not run] this test requires richacl support on $SCRATCH_DEV=

generic/371	 [not run] xfs_io falloc failed (old kernel/wrong fs?)
generic/372	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/373	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/374	 [not run] Dedupe not supported by test filesystem type: ceph=

generic/375 2s ... 2s
generic/376	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/377 2s ... 1s
generic/378	 [not run] fsgqa user not defined.
generic/379	 [not run] disk quotas not supported by this filesystem type:=
 ceph
generic/380	 [not run] disk quotas not supported by this filesystem type:=
 ceph
generic/381	 [not run] disk quotas not supported by this filesystem type:=
 ceph
generic/382	 [not run] disk quotas not supported by this filesystem type:=
 ceph
generic/383	 [not run] disk quotas not supported by this filesystem type:=
 ceph
generic/384	 [not run] disk quotas not supported by this filesystem type:=
 ceph
generic/385	 [not run] disk quotas not supported by this filesystem type:=
 ceph
generic/386	 [not run] disk quotas not supported by this filesystem type:=
 ceph
generic/389	 [not run] xfs_io flink failed (old kernel/wrong fs?)
generic/391	 [not run] xfs_io falloc failed (old kernel/wrong fs?)
generic/392	 [not run] ceph does not support shutdown
generic/393 4s ... 3s
generic/394 1s ... 2s
generic/395	 [not run] mount option "test_dummy_encryption" not allowed i=
n this test
generic/396	 [not run] mount option "test_dummy_encryption" not allowed i=
n this test
generic/397	 [not run] mount option "test_dummy_encryption" not allowed i=
n this test
generic/398	 [not run] mount option "test_dummy_encryption" not allowed i=
n this test
generic/400	 [not run] disk quotas not supported by this filesystem type:=
 ceph
generic/401 2s ... 2s
generic/402	 [not run] no kernel support for y2038 sysfs switch
generic/403 3s ... 5s
generic/404	 [not run] xfs_io finsert failed (old kernel/wrong fs?)
generic/406 7s ... 10s
generic/407	 [not run] Reflink not supported by test filesystem type: cep=
h
generic/408	 [not run] Dedupe not supported by test filesystem type: ceph=

generic/409	 [not run] require 10.72.47.117:40292:/testB to be local devi=
ce
generic/410	 [not run] require 10.72.47.117:40292:/testB to be local devi=
ce
generic/411	 [not run] require 10.72.47.117:40292:/testB to be local devi=
ce
generic/412 2s ... 2s
generic/413	 [not run] 10.72.47.117:40292:/testB ceph does not support -o=
 dax
generic/414	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/417	 [not run] ceph does not support shutdown
generic/419	 [not run] mount option "test_dummy_encryption" not allowed i=
n this test
generic/420 1s ... 2s
generic/421	 [not run] mount option "test_dummy_encryption" not allowed i=
n this test
generic/422	 [not run] xfs_io falloc failed (old kernel/wrong fs?)
generic/423	 - output mismatch (see /data/xfstests/results//generic/423.o=
ut.bad)
    --- tests/generic/423.out	2021-11-04 10:18:48.980507355 +0800
    +++ /data/xfstests/results//generic/423.out.bad	2021-11-20 16:18:38.8=
23832866 +0800
    @@ -9,3 +9,6 @@
     Test statx on a symlink
     Test statx on an AF_UNIX socket
     Test a hard link to a file
    +[!] attr 'stx_mask' differs from ref file, 1fff !=3D 18e0
    +Failed
    +stat_test failed
    ...
    (Run 'diff -u tests/generic/423.out /data/xfstests/results//generic/4=
23.out.bad'  to see the entire diff)
generic/424	 [not run] file system doesn't support any of /usr/bin/chattr=
 +a/+c/+d/+i
generic/425	 [not run] xfs_io fiemap failed (old kernel/wrong fs?)
generic/426 62s ... 54s
generic/427	 [not run] Filesystem ceph not supported in _scratch_mkfs_siz=
ed
generic/428 1s ... 2s
generic/430 2s ... 2s
generic/431 2s ... 2s
generic/432 1s ... 2s
generic/433 2s ... 2s
generic/434 2s ... 1s
generic/436 3s ... 2s
generic/437 3s ... 2s
generic/439 2s ... 2s
generic/440	 [not run] mount option "test_dummy_encryption" not allowed i=
n this test
generic/441	 [not run] require 10.72.47.117:40292:/testB to be valid bloc=
k disk
generic/443 1s ... 2s
generic/444 1s ... 2s
generic/445 2s ... 3s
generic/446 74s ... 74s
generic/447	 [not run] Reflink not supported by scratch filesystem type: =
ceph
generic/448 2s ... 2s
generic/449	 [not run] Filesystem ceph not supported in _scratch_mkfs_siz=
ed
shared/001	 [not run] not suitable for this filesystem type: ceph
shared/002	 [not run] not suitable for this filesystem type: ceph
shared/003	 [not run] not suitable for this filesystem type: ceph
shared/004	 [not run] not suitable for this filesystem type: ceph
shared/032	 [not run] not suitable for this filesystem type: ceph
shared/289	 [not run] not suitable for this filesystem type: ceph
Ran: generic/001 generic/002 generic/005 generic/006 generic/007 generic/=
011 generic/013 generic/014 generic/020 generic/023 generic/028 generic/0=
29 generic/030 generic/035 generic/037 generic/053 generic/062 generic/06=
9 generic/070 generic/075 generic/080 generic/084 generic/087 generic/088=
 generic/091 generic/097 generic/098 generic/099 generic/105 generic/112 =
generic/113 generic/117 generic/120 generic/124 generic/126 generic/129 g=
eneric/130 generic/131 generic/135 generic/141 generic/169 generic/184 ge=
neric/198 generic/207 generic/210 generic/211 generic/212 generic/215 gen=
eric/221 generic/236 generic/237 generic/240 generic/245 generic/246 gene=
ric/247 generic/248 generic/249 generic/257 generic/258 generic/263 gener=
ic/286 generic/294 generic/306 generic/307 generic/308 generic/309 generi=
c/313 generic/318 generic/319 generic/337 generic/346 generic/360 generic=
/375 generic/377 generic/393 generic/394 generic/401 generic/403 generic/=
406 generic/412 generic/420 generic/423 generic/426 generic/428 generic/4=
30 generic/431 generic/432 generic/433 generic/434 generic/436 generic/43=
7 generic/439 generic/443 generic/444 generic/445 generic/446 generic/448=

Not run: generic/004 generic/008 generic/009 generic/012 generic/015 gene=
ric/016 generic/018 generic/021 generic/022 generic/024 generic/025 gener=
ic/026 generic/031 generic/032 generic/033 generic/034 generic/039 generi=
c/040 generic/041 generic/050 generic/052 generic/056 generic/057 generic=
/058 generic/059 generic/060 generic/061 generic/063 generic/064 generic/=
065 generic/066 generic/067 generic/071 generic/073 generic/076 generic/0=
78 generic/079 generic/081 generic/082 generic/086 generic/090 generic/09=
2 generic/094 generic/096 generic/101 generic/103 generic/104 generic/106=
 generic/107 generic/108 generic/110 generic/111 generic/114 generic/115 =
generic/116 generic/118 generic/119 generic/121 generic/122 generic/123 g=
eneric/128 generic/134 generic/136 generic/138 generic/139 generic/140 ge=
neric/142 generic/143 generic/144 generic/145 generic/146 generic/147 gen=
eric/148 generic/149 generic/150 generic/151 generic/152 generic/153 gene=
ric/154 generic/155 generic/156 generic/157 generic/158 generic/159 gener=
ic/160 generic/161 generic/162 generic/163 generic/171 generic/172 generi=
c/173 generic/174 generic/177 generic/178 generic/179 generic/180 generic=
/181 generic/182 generic/183 generic/185 generic/188 generic/189 generic/=
190 generic/191 generic/193 generic/194 generic/195 generic/196 generic/1=
97 generic/199 generic/200 generic/201 generic/202 generic/203 generic/20=
5 generic/206 generic/213 generic/214 generic/216 generic/217 generic/218=
 generic/219 generic/220 generic/222 generic/223 generic/225 generic/227 =
generic/228 generic/229 generic/230 generic/235 generic/238 generic/244 g=
eneric/250 generic/252 generic/253 generic/254 generic/255 generic/256 ge=
neric/259 generic/260 generic/261 generic/262 generic/264 generic/265 gen=
eric/266 generic/267 generic/268 generic/271 generic/272 generic/276 gene=
ric/277 generic/278 generic/279 generic/281 generic/282 generic/283 gener=
ic/284 generic/287 generic/288 generic/289 generic/290 generic/291 generi=
c/292 generic/293 generic/295 generic/296 generic/301 generic/302 generic=
/303 generic/304 generic/305 generic/312 generic/314 generic/315 generic/=
316 generic/317 generic/321 generic/322 generic/324 generic/325 generic/3=
26 generic/327 generic/328 generic/329 generic/330 generic/331 generic/33=
2 generic/335 generic/336 generic/338 generic/341 generic/342 generic/343=
 generic/347 generic/348 generic/353 generic/355 generic/356 generic/357 =
generic/358 generic/359 generic/361 generic/362 generic/363 generic/364 g=
eneric/365 generic/366 generic/367 generic/368 generic/369 generic/370 ge=
neric/371 generic/372 generic/373 generic/374 generic/376 generic/378 gen=
eric/379 generic/380 generic/381 generic/382 generic/383 generic/384 gene=
ric/385 generic/386 generic/389 generic/391 generic/392 generic/395 gener=
ic/396 generic/397 generic/398 generic/400 generic/402 generic/404 generi=
c/407 generic/408 generic/409 generic/410 generic/411 generic/413 generic=
/414 generic/417 generic/419 generic/421 generic/422 generic/424 generic/=
425 generic/427 generic/440 generic/441 generic/447 generic/449 shared/00=
1 shared/002 shared/003 shared/004 shared/032 shared/289
Failures: generic/020 generic/062 generic/258 generic/423
Failed 4 of 97 tests



--------------1E6900A695B65FDA201744B9--

