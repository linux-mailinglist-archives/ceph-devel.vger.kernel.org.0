Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50AD5457A50
	for <lists+ceph-devel@lfdr.de>; Sat, 20 Nov 2021 01:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbhKTBBS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 19 Nov 2021 20:01:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:35564 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229523AbhKTBBQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 19 Nov 2021 20:01:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637369893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7XLI8ic9h4XY+D09LAygdJgfK29OXx8FtIoURkKrxvw=;
        b=GR5Gh9TYfWTW3YJoh6G+HcPiyJfAjvDonQKnpGsx/HxF8YyjJ37ZBXqN5O59db0uN5qO69
        Bq0vq0iQ01v0bzqrCPGjQFEMjA/DT01NTIuLc/i5fo9pFiINSi45LKCdZS1tO4EfRGyryd
        PPIW4pPWXBTiJMTUtsCyoSLCwK9T/1c=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-6o74cSMfMQiTLiu60KlxcQ-1; Fri, 19 Nov 2021 19:58:12 -0500
X-MC-Unique: 6o74cSMfMQiTLiu60KlxcQ-1
Received: by mail-pl1-f198.google.com with SMTP id s16-20020a170902ea1000b00142728c2ccaso5420466plg.23
        for <ceph-devel@vger.kernel.org>; Fri, 19 Nov 2021 16:58:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=7XLI8ic9h4XY+D09LAygdJgfK29OXx8FtIoURkKrxvw=;
        b=wp4dE84XrVBWFALj1hArF3TuWiuFZT27VSspGaPAtckgSfaxx9kIh4RDzZM8DQU9NH
         tjqr0X5vHbwu8U1cr7aoC2q1dMSgHoWAYHxSSZiQDzIJzCPU9zyDCfulm1N45c4V3GWS
         VyXLa9g5Pcp8bRJzRIRhEQIyfm+KlY2PhFfmLQukuqxXVj36wYCBy1ixX0wqIMyqaxAc
         DMlP20KXKL9sao4QwNfEzDfyMjvx3auGGcM0AEXpgP7LWWQ/pgMW9+5v2HC365W/SfGD
         tuGCKiYqdHJdnQ3LYwOm8fiLvp4HBPutBhHWV56sqoH5JOQvyhzIzsgx9Is0l8l55yFr
         YuGA==
X-Gm-Message-State: AOAM533EZZ6zCZsBQkFS7dFu8YOG6NgsDBJyAwF0RDukP+bipno+YDkw
        UjChjjR7U3zTnlrelVxe5LBaQgHR7EqX+xDPzz0HJJNzrCwmWkaTnvRl88c0qGpn+Od+yCcXRf2
        ax8uYZqz/IxbT67s8D5hxaFZg/l5BbL4hpyZvUlcLhdw87On5zKHYW0QsVAewB6ATEMKlNZE=
X-Received: by 2002:a63:5813:: with SMTP id m19mr20094226pgb.441.1637369890160;
        Fri, 19 Nov 2021 16:58:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw7AUcOx0UrbujTF3FiUpxp20vkK6sdSWqPmgDVaizgPw6H0LkclGe5xmdSicfrwfF66NkS8Q==
X-Received: by 2002:a63:5813:: with SMTP id m19mr20094181pgb.441.1637369889505;
        Fri, 19 Nov 2021 16:58:09 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c2sm770391pfv.112.2021.11.19.16.58.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 16:58:08 -0800 (PST)
Subject: Re: [PATCH] ceph: do not truncate pagecache if truncate size doesn't
 change
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20211116092002.99439-1-xiubli@redhat.com>
 <09babbaf077a76ace4793f2e6ae6127d2e7d6411.camel@kernel.org>
 <1a6b7a20-ba30-0b57-3927-2b61ad64be28@redhat.com>
 <119f590bf2c576fff3ecf44295c7e7bbfcfeb3d8.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <fe9ce707-3118-a388-bbd4-50d80e957a89@redhat.com>
Date:   Sat, 20 Nov 2021 08:58:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <119f590bf2c576fff3ecf44295c7e7bbfcfeb3d8.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/19/21 7:59 PM, Jeff Layton wrote:
> On Fri, 2021-11-19 at 12:29 +0800, Xiubo Li wrote:
>> On 11/19/21 2:13 AM, Jeff Layton wrote:
>>> On Tue, 2021-11-16 at 17:20 +0800, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> In case truncating a file to a smaller sizeA, the sizeA will be kept
>>>> in truncate_size. And if truncate the file to a bigger sizeB, the
>>>> MDS will only increase the truncate_seq, but still using the sizeA as
>>>> the truncate_size.
>>>>
>>>> So when filling the inode it will truncate the pagecache by using
>>>> truncate_sizeA again, which makes no sense and will trim the inocent
>>>> pages.
>>>>
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
>>> Starting a new thread since this one is getting cluttered. I did a
>>> kernel build today with the wip-fscrypt-size branch with this patch on
>>> top and installed it on my client.
>>>
>>> I also rebuilt my cluster machine to use a container image based on your
>>> current fsize_support branch (commit 34eafd9db1ae). That host runs 3 VMs
>>> that each act as cephadm hosts. Each is assigned a physical ssd. I
>>> create two filesystems named "test" and "scratch", both with max_mds set
>>> to 3. Under each of those, I create a directory /client1 and set each up
>>> to use ceph.dir.pin.random at 0.1.
>>>
>>> I saw 2 test failures and then it hung on generic/444:
>>>
>>> generic/029 10s ... - output mismatch (see /home/jlayton/git/xfstests-dev/results//generic/029.out.bad)
>>>       --- tests/generic/029.out	2020-11-09 14:47:52.488429897 -0500
>>>       +++ /home/jlayton/git/xfstests-dev/results//generic/029.out.bad	2021-11-18 11:04:18.494800609 -0500
>>>       @@ -49,17 +49,3 @@
>>>        00001400  00                                                |.|
>>>        00001401
>>>        ==== Post-Remount ==
>>>       -00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58  |XXXXXXXXXXXXXXXX|
>>>       -*
>>>       -00000200  58 57 57 57 57 57 57 57  57 57 57 57 57 57 57 57  |XWWWWWWWWWWWWWWW|
>>>       -00000210  57 57 57 57 57 57 57 57  57 57 57 57 57 57 57 57  |WWWWWWWWWWWWWWWW|
>>>       ...
>>>       (Run 'diff -u /home/jlayton/git/xfstests-dev/tests/generic/029.out /home/jlayton/git/xfstests-dev/results//generic/029.out.bad'  to see the entire diff)
>>>
>>> generic/112 75s ... [failed, exit status 1]- output mismatch (see /home/jlayton/git/xfstests-dev/results//generic/112.out.bad)
>>>       --- tests/generic/112.out	2020-11-09 14:47:52.694435287 -0500
>>>       +++ /home/jlayton/git/xfstests-dev/results//generic/112.out.bad	2021-11-18 11:24:03.519631823 -0500
>>>       @@ -4,15 +4,4 @@
>>>        -----------------------------------------------
>>>        fsx.0 : -A -d -N numops -S 0
>>>        -----------------------------------------------
>>>       -
>>>       ------------------------------------------------
>>>       -fsx.1 : -A -d -N numops -S 0 -x
>>>       ------------------------------------------------
>>>       ...
>>>       (Run 'diff -u /home/jlayton/git/xfstests-dev/tests/generic/112.out /home/jlayton/git/xfstests-dev/results//generic/112.out.bad'  to see the entire diff)
>> Locally I am using the vstart_runner to setup the cluster with only one
>> filesystem, and couldn't reproduce any issue you mentioned this time.
>>
>>   From the "112.2.full" you attached, I can see that the mapread will
>> read the file range of [0x686907, 0x693eb9), which should be zero but
>> it's not:
>>
>> 3540 trunc    from 0x789289 to 0xd8b1
>> 3542 write    0x8571af thru    0x85e2af    (0x7101 bytes)
>> 3543 trunc    from 0x85e2b0 to 0x7dc986
>> 3550 read    0x3b37bd thru    0x3b50a8    (0x18ec bytes)
>> 3551 mapread    0x686907 thru    0x693eb9    (0xd5b3 bytes)
>> READ BAD DATA: offset = 0x686907, size = 0xd5b3, fname = 112.2
>> OFFSET    GOOD    BAD    RANGE
>> 0x686907    0x0000    0x198f    0x00000
>> operation# (mod 256) for the bad data may be 143
>> 0x686908    0x0000    0x8fec    0x00001
>> operation# (mod 256) for the bad data may be 143
>>
>> In theory that range should be truncated and zeroed in the first "trunc"
>> from 0x789289 to 0xd8b1 above. From the failure logs, it is the same
>> issue with before in generic/057 test case. But locally I couldn't
>> reproduce it after I fixing the bug in ceph fsize_support branch.
>>
>> BTW, could you reproduce this every time ? Or just occasionally ?
>>
>>
> I don't see the tests fail every time. 029 fails about 50% of the time
> though. The fsx tests don't seem to fail quite so often. It seems to be
> hard to reproduce these when running a single test in a loop, but when I
> run the "quick" group of tests, I usually get at least one failure.
>
> FWIW, my usual xfstests run is:
>
>      sudo ./check -g quick -E ./ceph.exclude
>
> ...with ceph.exclude having:
>
> ceph/001
> generic/003
> generic/531
> generic/538
>
> Most of the excluded tests actually work, but take a really long time on
> ceph. generic/003 always fails though (atime handling).

Okay.

Before when I ran with the ceph.exlude it would fail since there hasn't 
enough disk space. Let me try it again.


>>> I attached a tarball with the relevant output from the above two tests.
>>>
>>> The hang is also interesting, though it may be unrelated to size
>>> handling. It's just a touch command, and it's hung doing this:
>>>
>>> [jlayton@client1 xfstests-dev]$ sudo !!
>>> sudo cat /proc/100726/stack
>>> [<0>] ceph_mdsc_do_request+0x169/0x270 [ceph]
>>> [<0>] ceph_atomic_open+0x3eb/0x10f0 [ceph]
>>> [<0>] lookup_open.isra.0+0x59c/0x8f0
>>> [<0>] path_openat+0x4d2/0x10f0
>>> [<0>] do_filp_open+0x131/0x230
>>> [<0>] do_sys_openat2+0xe4/0x250
>>> [<0>] __x64_sys_openat+0xbd/0x110
>>> [<0>] do_syscall_64+0x3b/0x90
>>> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>
>>> This was in dmesg:
>>>
>>> [ 5338.083673] run fstests generic/444 at 2021-11-18 12:07:44
>>> [ 5405.607913] ceph: mds1 caps stale
>>> [ 5642.657735] ceph: mds1 hung
>>> [ 5644.964139] libceph: mds2 (2)192.168.1.81:6804 socket closed (con state OPEN)
>>> [ 5644.977876] libceph: mds0 (2)192.168.1.81:6814 socket closed (con state OPEN)
>>> [ 5645.159578] libceph: mds0 (2)192.168.1.81:6814 session reset
>>> [ 5645.168000] ceph: mds0 closed our session
>>> [ 5645.175634] ceph: mds0 reconnect start
>>> [ 5645.196569] ceph: mds0 reconnect denied
>>> [ 5648.295458] libceph: mds2 (2)192.168.1.81:6804 session reset
>>> [ 5648.303578] ceph: mds2 closed our session
>>> [ 5648.311251] ceph: mds2 reconnect start
>>> [ 5648.330261] ceph: mds2 reconnect denied
>>>
>>> The logs on mds1 show this:
>>>
>>> Nov 18 11:52:56 cephadm2 ceph-mds[2928]: mds.test.cephadm2.kfuenm Updating MDS map to version 106 from mon.1
>>> Nov 18 11:53:42 cephadm2 ceph-mds[2928]: mds.test.cephadm2.kfuenm Updating MDS map to version 107 from mon.1
>>> Nov 18 11:56:48 cephadm2 ceph-mds[2928]: mds.test.cephadm2.kfuenm asok_command: client ls {prefix=client ls} (starting...)
>>> Nov 18 11:57:38 cephadm2 ceph-mds[2928]: mds.test.cephadm2.kfuenm asok_command: client ls {prefix=client ls} (starting...)
>>> Nov 18 11:58:23 cephadm2 ceph-mds[2928]: mds.test.cephadm2.kfuenm asok_command: client ls {prefix=client ls} (starting...)
>>> Nov 18 12:00:08 cephadm2 ceph-mds[2928]: mds.test.cephadm2.kfuenm asok_command: client ls {prefix=client ls} (starting...)
>>> Nov 18 12:01:58 cephadm2 ceph-mds[2928]: mds.test.cephadm2.kfuenm asok_command: client ls {prefix=client ls} (starting...)
>>> Nov 18 12:03:28 cephadm2 ceph-mds[2928]: mds.test.cephadm2.kfuenm asok_command: client ls {prefix=client ls} (starting...)
>>> Nov 18 12:03:43 cephadm2 ceph-mds[2928]: mds.test.cephadm2.kfuenm asok_command: client ls {prefix=client ls} (starting...)
>>> Nov 18 12:05:16 cephadm2 ceph-mds[2928]: mds.test.cephadm2.kfuenm Updating MDS map to version 108 from mon.1
>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x2000000107f err -116/0
>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000085 err -116/0
>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000088 err -116/0
>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x2000000008b err -116/0
>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x2000000008e err -116/0
>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x2000000008e err -116/0
>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x2000000008f err -116/0
>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x2000000008f err -116/0
>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000090 err -116/0
>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000090 err -116/0
>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000091 err -116/0
>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000092 err -116/0
>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000092 err -116/0
>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000093 err -116/0
>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000094 err -116/0
>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000094 err -116/0
>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000095 err -116/0
>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000096 err -116/0
>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000096 err -116/0
>>> Nov 18 12:05:34 cephadm2 ceph-mds[2928]: mds.1.cache  failed to open ino 0x20000000097 err -116/0
>>>
>>> -116 is -ESTALE.
>>>
>>> That repeats for a while and eventually the client is evicted.
>>>
>>> I'm not sure what to make of this hang, but I've seen it happen twice
>>> now. I'll see if it's reliably reproducible in a bit.
>>>
>>> As a side note, we probably do need to ensure that we not continue to
>>> wait on MDS ops on blacklisted sessions. If we get blacklisted, then we
>>> should wake up any waiters and fail any reqs that are in flight. I'll
>>> open a tracker for that soon.
>> Test this many times too:
>>
>> [root@lxbceph1 xfstests]# ./check generic/444
>> FSTYP         -- ceph
>> PLATFORM      -- Linux/x86_64 lxbceph1 5.15.0+
>> MKFS_OPTIONS  -- 10.72.47.117:40742:/testB
>> MOUNT_OPTIONS -- -o
>> test_dummy_encryption,name=admin,nowsync,copyfrom,rasize=4096 -o
>> context=system_u:object_r:root_t:s0 10.72.47.117:40742:/testB /mnt/kcephfs.B
>>
>> generic/444 2s ... 1s
>> Ran: generic/444
>> Passed all 1 tests
>>
>> [root@lxbceph1 xfstests]#
>>
>>
>> I am using almost the same mount options except the "ms_mode=crc". And
>> using the vstart_runner to setup the cluster and only one default
>> filesystem "a".
>>
> The msgr version probably doesn't matter much, but you never know.
>
>> The following is my kernel patches I am using:
>>
>> $ git log --oneline
>>
>> 33adb35fb859 (HEAD -> fscrypt_size_handling4) ceph: do not truncate
>> pagecache if truncate size doesn't change
>> 42cb4762205a (origin/wip-fscrypt-size, lxb-testing13) ceph: add truncate
>> size handling support for fscrypt
>> 428fe6185c09 ceph: add object version support for sync read
>> b0e5dcc4ad03 ceph: add __ceph_sync_read helper support
>> c316473f6c57 ceph: add __ceph_get_caps helper support
>> 50709509eef9 ceph: handle fscrypt fields in cap messages from MDS
>> 071d5fc5b21e ceph: get file size from fscrypt_file when present in inode
>> traces
>> 48c6a21c000c ceph: fscrypt_file field handling in MClientRequest messages
>> f101a36542a7 ceph: size handling for encrypted inodes in cap updates
>> 67f017e4edf9 libceph: add CEPH_OSD_OP_ASSERT_VER support
>> 98d487ede749 (origin/wip-fscrypt-fnames) ceph: don't allow changing
>> layout on encrypted files/directories
>> ...
>>
>>
> The kernel branch you're using is old. I rebased it earlier in the week
> so that it sits on top of v5.16-rc1. There are fscrypt changes in there
> that this set needed to be adapted for.

Okay, I will update it.


>
>> For ceph:
>>
>> $ git log --oneline
>>
>> 34eafd9db1a (HEAD -> jf_fscrypt2, lxb/fsize_support) mds: add truncate
>> size handling support for fscrypt
>> 4f9c1add5ff mds: don't allow changing layout on encrypted files/directories
>> 993189035ab mds: encode fscrypt_auth and fscrypt_file in appropriate mds
>> locks
>> 573c5bb1143 test: add fscrypt attribute testcases
>> 6e60ab066d9 client: add support for fscrypt_auth and fscrypt_file fields
>> be447f7911d mds: allow setattr to change fscrypt_auth/file
>> 40bb9bb5a26 mds: populate fscrypt_auth/_file on inode creation
>> b2838a2def2 client: send fscrypt_auth and fscrypt_file in MClientRequest
>> 6ae96259947 mds: add fscrypt_auth and fscrypt_file fields to MClientCaps
>> fd8f004f7a9 mds: encode fscrypt_auth and fscrypt_file in InodeStat
>> c8abd5f34bd mds: add fscrypt opaque field to inode_t encoding
>> 13619a8b96a mds: convert fscrypt flag to two opaque fields
>> 0471f922a9b common: add encode and decode routines for opaque vectors of
>> bytes
>> 4035ba419de (origin/master, origin/HEAD) Merge pull request #42906 from
>> sebastian-philipp/rm-ceph-orch-osd-i
>> ...
>>
>>
> I am using the same ceph branch as you are.
>
>> Not sure why my tests are different with yours ?
>>
> It could be all sorts of reasons. I have 3 MDS's per fs and I suspect
> vstart_runner only gives you 1. I have (consumer-grade) SSDs assigned to
> each OSD too. I'm also using random pinning, so that could be a factor
> as well.

I am also using 3 MDSs, the command is:

   $ MDS=3 OSD=3 MON=3 MGR=1 ../src/vstart.sh -n -X -G --msgr1

The '--msgr2' is not work well for me before so I keep using the msgr1 
instead.

And I'm also using the same random pinning as you mentioned in last mail.

BRs

--Xiubo


>

