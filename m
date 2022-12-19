Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1266505DB
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Dec 2022 01:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiLSARF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 18 Dec 2022 19:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiLSARD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 18 Dec 2022 19:17:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A229B634A
        for <ceph-devel@vger.kernel.org>; Sun, 18 Dec 2022 16:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671408977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IEf1/5xkB5aHQrret3i4p05F9uZ5PYJsiB2oMs3o/9w=;
        b=EJa/IPx8mJKrUdf3PNKUGMcsz06qxHZ75CNCAcmMqQYvt1N8lXyKLzShP3TmHM7bcpNYom
        D0eJJPGOxGoAkNpNyICvKa+g46LfzHkjdj/dnJxFD27Rl7uAjMKBR4wNi9gq9h12G8je7f
        i/eA7x9eW1Hy9n5IhSNThiy90Jg9MvU=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-122-H7ZC1ze5P7mZ-yHG--LqCg-1; Sun, 18 Dec 2022 19:16:16 -0500
X-MC-Unique: H7ZC1ze5P7mZ-yHG--LqCg-1
Received: by mail-pj1-f70.google.com with SMTP id mn20-20020a17090b189400b0021941492f66so8745889pjb.0
        for <ceph-devel@vger.kernel.org>; Sun, 18 Dec 2022 16:16:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IEf1/5xkB5aHQrret3i4p05F9uZ5PYJsiB2oMs3o/9w=;
        b=4+fU68qaQcYSmDPRDH4W57Hg5RhqpVzGZjN2M1zfeGH7uonux/LmbqOx3KxaJFaU+f
         AcHDHXI5ZrHkFSXn1sMHKWM1KsGdrzXrpR91edHP8U6YZwlwYds273S9paS/BJq5W39f
         I0JsJah+uYnXupZR/cKJNXXGU9akBG4077l71R4sgLitOv/TgEql1pgkrGylfaeH1YqX
         rrmsJ1e1S3zS5qWTefbpV0g/eLGcBLYgLiOs95n5iMXqlGty3NgwNWaL2xHbOcoiQUlk
         cv7SG+Gg7XWd8cpxBWnubjDzGV+PaX6cxW5f7vXtLXkJEUBkkaaADKn5fmgMe7gZE6o5
         mvVQ==
X-Gm-Message-State: ANoB5pkfSwJcbDC5KEqXHoFXQPMR7kre3fRRJVB66oMAcW6tUdVL/c9O
        PhCmIDvubb1+jSIpoa8aGxwt2NvLVn5tTUi0N51SVLpYjl2aUbl2m6Q6Rp+MD37QOMExTuIIL8g
        acmrBDwbI2p1VoCBUmlWoFrZCDRx/llmHUe1h7ZOAsWLSG6wRHjP1aapKLyMuEOiqFIviz7o=
X-Received: by 2002:a05:6a21:1589:b0:a3:5a61:20ef with SMTP id nr9-20020a056a21158900b000a35a6120efmr41411400pzb.61.1671408974865;
        Sun, 18 Dec 2022 16:16:14 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6j2muMEoyJK4rCFV4LGmcwq0LZFdSBF/qeq08+/VVwjT07ybYBDeDe1NZEk9KoIdudndXHkg==
X-Received: by 2002:a05:6a21:1589:b0:a3:5a61:20ef with SMTP id nr9-20020a056a21158900b000a35a6120efmr41411368pzb.61.1671408974352;
        Sun, 18 Dec 2022 16:16:14 -0800 (PST)
Received: from [10.72.12.85] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902650700b00186b549cdc2sm5592693plk.157.2022.12.18.16.16.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Dec 2022 16:16:13 -0800 (PST)
Subject: Re: PROBLEM: CephFS write performance drops by 90%
To:     "Roose, Marco" <marco.roose@mpinat.mpg.de>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
References: <fc2786c0caa7454486ba318a334c97a3@mpinat.mpg.de>
 <CAOi1vP-J_Qu28q4KFOZVXmX1uBNBfOsMZGFuYCEkny+AAoWesQ@mail.gmail.com>
 <4c039a76-b638-98b7-1104-e81857df8bcd@redhat.com>
 <9b714315c8934da38449eb2ce5b85cfc@mpinat.mpg.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <70e8a12c-d94e-7784-c842-cbdd87ff438e@redhat.com>
Date:   Mon, 19 Dec 2022 08:16:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <9b714315c8934da38449eb2ce5b85cfc@mpinat.mpg.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 16/12/2022 19:37, Roose, Marco wrote:
> Hi Ilya and Xiubo,
> thanks for looking onto this. I try to answer you questions:
>
> ==============================
>> What is the workload / test case?
> I'm using a ~ 2G large test file which I rsync from local storage to the
> ceph mount. I'm using rsync for convinience as the --progress coammand line
> switch gives a good immidiate indicator if teh problem exists.
>
>
> good Kernel (e.g. 5.6.0 RC7)
>
> root@S1020-CephTest:~# uname -a
> Linux S1020-CephTest 5.6.0-050600rc7-generic #202003230230 SMP Mon Mar 23
> 02:33:08 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
> root@S1020-CephTest:~# ls tatort.mp4
> tatort.mp4
> root@S1020-CephTest:~# ls -la tatort.mp4
> -rw-rw-r-- 1 nanoadmin nanoadmin 2106772019 Dec  7 11:25 tatort.mp4
> root@S1020-CephTest:~# rsync -avh --progress tatort.mp4 /mnt/ceph/tatort.mp4
> sending incremental file list
> tatort.mp4
>            2.11G 100%  138.10MB/s    0:00:14 (xfr#1, to-chk=0/1)
>
> sent 2.11G bytes  received 35 bytes  135.95M bytes/sec
> total size is 2.11G  speedup is 1.00
>
> bad Kernel (e.g. 5.6.0 FINAL)
>
> root@S1020-CephTest:~# uname -a
> Linux S1020-CephTest 5.6.0-050600-generic #202003292333 SMP Sun Mar 29
> 23:35:58 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
> root@S1020-CephTest:~# rsync -avh --progress tatort.mp4 /mnt/ceph/tatort.mp4
> sending incremental file list
> tatort.mp4
>           21.59M   1%    2.49MB/s    0:13:38
>
> (see attached screen shot from netdata abour the difference in iowait for
> both test cases)
>
>
> As Xiubo supposed I tested with the very last RC kernel, too. Same problem:
>
> Latest 6.1. RC kernel
> root@S1020-CephTest:~# uname -a
> Linux S1020-CephTest 6.1.0-060100rc5-generic #202211132230 SMP
> PREEMPT_DYNAMIC Sun Nov 13 22:36:10 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
> root@S1020-CephTest:~# rsync -avh --progress tatort.mp4 /mnt/ceph/tatort.mp4
> sending incremental file list
> tatort.mp4
>           60.13M   2%    3.22MB/s    0:10:20
>
> (attached a netdata screenshot for that, too).
>
> ==================================================
>
>> Can you describe how you performed bisection?  Can you share the
>> reproducer you used for bisection?
> Took a commit from 5.4 which I had confirmed to be bad in earlier tests.
> Than took tag 5.4.25 which I confirmed to be good as first "good"
>
> # git bisect log
> git bisect start
> # bad: [61bbc823a17abb3798568cfb11ff38fc22317442] clk: ti: am43xx: Fix clock
> parent for RTC clock
> git bisect bad 61bbc823a17abb3798568cfb11ff38fc22317442
> # good: [18fe53f6dfbc5ad4ff2164bff841b56d61b22720] Linux 5.4.25
> git bisect good 18fe53f6dfbc5ad4ff2164bff841b56d61b22720
> # good: [59e4624e664c9e83c04abae9b710cd60cb908a82] ALSA: seq: oss: Fix
> running status after receiving sysex
> git bisect good 59e4624e664c9e83c04abae9b710cd60cb908a82
> # good: [8dab286ab527dc3fa68e9705b0805f4d6ce10add] fsl/fman: detect FMan
> erratum A050385
> git bisect good 8dab286ab527dc3fa68e9705b0805f4d6ce10add
> # bad: [160c2ffa701692e60c7034271b4c06b843b7249f] xfrm: add the missing
> verify_sec_ctx_len check in xfrm_add_acquire
> git bisect bad 160c2ffa701692e60c7034271b4c06b843b7249f
> # bad: [174da11b6474200e2e43509ce2d34e62ecea9f4b] ARM: dts: omap5: Add
> bus_dma_limit for L3 bus
> git bisect bad 174da11b6474200e2e43509ce2d34e62ecea9f4b
> # good: [65047f7538ba5c0edcf4b4768d942970bb6d4cbc] iwlwifi: mvm: fix
> non-ACPI function
> git bisect good 65047f7538ba5c0edcf4b4768d942970bb6d4cbc
> # good: [10d5de234df4a4567a8da18de04111f7e931fd70] RDMA/core: Fix missing
> error check on dev_set_name()
> git bisect good 10d5de234df4a4567a8da18de04111f7e931fd70
> # good: [44960e1c39d807cd0023dc7036ee37f105617ebe] RDMA/mad: Do not crash if
> the rdma device does not have a umad interface
> git bisect good 44960e1c39d807cd0023dc7036ee37f105617ebe
> # bad: [7cdaa5cd79abe15935393b4504eaf008361aa517] ceph: fix memory leak in
> ceph_cleanup_snapid_map()
> git bisect bad 7cdaa5cd79abe15935393b4504eaf008361aa517
> # bad: [ed24820d1b0cbe8154c04189a44e363230ed647e] ceph: check
> POOL_FLAG_FULL/NEARFULL in addition to OSDMAP_FULL/NEARFULL
> git bisect bad ed24820d1b0cbe8154c04189a44e363230ed647e
> # first bad commit: [ed24820d1b0cbe8154c04189a44e363230ed647e] ceph: check
> POOL_FLAG_FULL/NEARFULL in addition to OSDMAP_FULL/NEARFULL

Since you are here, could you try to revert this commit and have a try ?

Let's see whether is this commit causing it. I will take a look later 
this week.

Thanks

- Xiubo

>
>> Can you confirm the result by manually checking out the previous commit
>> and verifying that it's "good"?
> root@S1020-CephTest:~/src/linux# git checkout -b ceph_check_last_good
> 44960e1c39d807cd0023dc7036ee37f105617ebe
> Checking out files: 100% (68968/68968), done.
> Switched to a new branch 'ceph_check_last_good'
>
> root@S1020-CephTest:~/src/linux# make clean
> ...
> root@S1020-CephTest:~/src/linux# cp -a /boot/config-5.4.25-050425-generic
> .config
> root@S1020-CephTest:~/src/linux# make olddefconfig
> ...
> root@S1020-CephTest:~/src/linux# make bindeb-pkg -j"$(nproc)"
> ...
> dpkg-deb: building package 'linux-headers-5.4.28+' in
> '../linux-headers-5.4.28+_5.4.28+-10_amd64.deb'.
> dpkg-deb: building package 'linux-libc-dev' in
> '../linux-libc-dev_5.4.28+-10_amd64.deb'.
> dpkg-deb: building package 'linux-image-5.4.28+' in
> '../linux-image-5.4.28+_5.4.28+-10_amd64.deb'.
> dpkg-deb: building package 'linux-image-5.4.28+-dbg' in
> '../linux-image-5.4.28+-dbg_5.4.28+-10_amd64.deb'.
>   dpkg-genbuildinfo --build=binary
>   dpkg-genchanges --build=binary >../linux-5.4.28+_5.4.28+-10_amd64.changes
> dpkg-genchanges: info: binary-only upload (no source code included)
>   dpkg-source --after-build linux
> dpkg-buildpackage: info: binary-only upload (no source included)
> root@S1020-CephTest:~/src/linux# cd ..
> root@S1020-CephTest:~/src# ls
> linux
>   linux-5.4.28+_5.4.28+-10_amd64.changes
> linux-image-5.4.28+_5.4.28+-10_amd64.deb
> linux-libc-dev_5.4.28+-10_amd64.deb
> linux-5.4.28+_5.4.28+-10_amd64.buildinfo
> linux-headers-5.4.28+_5.4.28+-10_amd64.deb
> linux-image-5.4.28+-dbg_5.4.28+-10_amd64.deb
> root@S1020-CephTest:~/src# dpkg -i linux-image-5.4.28+*
> ...
> root@S1020-CephTest:~/src# reboot
> ....
> root@S1020-CephTest:~# uname -a
> Linux S1020-CephTest 5.4.28+ #10 SMP Fri Dec 16 09:20:11 CET 2022 x86_64
> x86_64 x86_64 GNU/Linux
> root@S1020-CephTest:~# rsync -avh --progress tatort.mp4 /mnt/ceph/tatort.mp4
> sending incremental file list
> tatort.mp4
>            2.11G 100%  135.15MB/s    0:00:14 (xfr#1, to-chk=0/1)
>
> sent 2.11G bytes  received 35 bytes  135.95M bytes/sec
> total size is 2.11G  speedup is 1.00
>
> As you can see the problem does not exist here.
>
> Thanks again!
> Marco
> ________________________________________
> From: Xiubo Li <xiubli@redhat.com>
> Sent: Friday, December 16, 2022 3:20:46 AM
> To: Ilya Dryomov; Roose, Marco
> Cc: Ceph Development
> Subject: Re: PROBLEM: CephFS write performance drops by 90%
>   
> Hi Roose,
>
> I think this should be similar with
> https://tracker.ceph.com/issues/57898, but it's from 5.15 instead.
>
> Days ago just after Ilya rebased to the 6.1 without changing anything in
> ceph code the xfstest tests were much faster.
>
> I just checked the difference about the 5.4 and 5.4.45 and couldn't know
> what has happened exactly. So please share your test case about this.
>
> - Xiubo
>
> On 15/12/2022 23:32, Ilya Dryomov wrote:
>> On Thu, Dec 15, 2022 at 3:22 PM Roose, Marco <marco.roose@mpinat.mpg.de>
> wrote:
>>> Dear Ilya,
>>> I'm using Ubuntu and a CephFS mount. I had a more than 90% write
> performance decrease after changing the kernels main version ( <10MB/s vs.
> 100-140 MB/s). The problem seems to exist in Kernel major versions starting
> at v5.4. Ubuntu mainline version v5.4.25 is fine, v5.4.45 (which is next
> available) is "bad".
>> Hi Marco,
>>
>> What is the workload?
>>
>>> After a git bisect with the "original" 5.4 kernels I get the following
> result:
>> Can you describe how you performed bisection?  Can you share the
>> reproducer you used for bisection?
>>
>>> ed24820d1b0cbe8154c04189a44e363230ed647e is the first bad commit
>>> commit ed24820d1b0cbe8154c04189a44e363230ed647e
>>> Author: Ilya Dryomov <idryomov@gmail.com>
>>> Date:   Mon Mar 9 12:03:14 2020 +0100
>>>
>>>        ceph: check POOL_FLAG_FULL/NEARFULL in addition to
> OSDMAP_FULL/NEARFULL
>>>        commit 7614209736fbc4927584d4387faade4f31444fce upstream.
>>>
>>>        CEPH_OSDMAP_FULL/NEARFULL aren't set since mimic, so we need to
> consult
>>>        per-pool flags as well.  Unfortunately the backwards compatibility
> here
>>>        is lacking:
>>>
>>>        - the change that deprecated OSDMAP_FULL/NEARFULL went into mimic,
> but
>>>          was guarded by require_osd_release >= RELEASE_LUMINOUS
>>>        - it was subsequently backported to luminous in v12.2.2, but that
> makes
>>>          no difference to clients that only check OSDMAP_FULL/NEARFULL
> because
>>>          require_osd_release is not client-facing -- it is for OSDs
>>>
>>>        Since all kernels are affected, the best we can do here is just
> start
>>>        checking both map flags and pool flags and send that to stable.
>>>
>>>        These checks are best effort, so take osdc->lock and look up pool
> flags
>>>        just once.  Remove the FIXME, since filesystem quotas are checked
> above
>>>        and RADOS quotas are reflected in POOL_FLAG_FULL: when the pool
> reaches
>>>        its quota, both POOL_FLAG_FULL and POOL_FLAG_FULL_QUOTA are set.
>> The only suspicious thing I see in this commit is osdc->lock semaphore
>> which is taken for read for a short period of time in ceph_write_iter().
>> It's possible that that started interfering with other code paths that
>> take that semaphore for write and read-write lock fairness algorithm is
>> biting...
>>
>> Can you confirm the result by manually checking out the previous commit
>> and verifying that it's "good"?
>>
>>        commit 44960e1c39d807cd0023dc7036ee37f105617ebe
>>        RDMA/mad: Do not crash if the rdma device does not have a umad
> interface
>>            (commit 5bdfa854013ce4193de0d097931fd841382c76a7 upstream)
>>
>> Thanks,
>>
>>                    Ilya
>>

