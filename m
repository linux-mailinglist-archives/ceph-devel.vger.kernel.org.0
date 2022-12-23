Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7181654D31
	for <lists+ceph-devel@lfdr.de>; Fri, 23 Dec 2022 09:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236034AbiLWIGv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 23 Dec 2022 03:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235979AbiLWIGp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 23 Dec 2022 03:06:45 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4840B27912
        for <ceph-devel@vger.kernel.org>; Fri, 23 Dec 2022 00:06:43 -0800 (PST)
Received: from [192.168.0.185] (ip5f5aeccd.dynamic.kabel-deutschland.de [95.90.236.205])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 3D32361CCD7B0;
        Fri, 23 Dec 2022 09:06:41 +0100 (CET)
Message-ID: <ef6bb3f4-528b-17e9-4f4c-8b5bcb5936f2@molgen.mpg.de>
Date:   Fri, 23 Dec 2022 09:06:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: PROBLEM: CephFS write performance drops by 90%
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Marco Roose <marco.roose@mpinat.mpg.de>,
        Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
References: <fc2786c0caa7454486ba318a334c97a3@mpinat.mpg.de>
 <CAOi1vP-J_Qu28q4KFOZVXmX1uBNBfOsMZGFuYCEkny+AAoWesQ@mail.gmail.com>
 <4c039a76-b638-98b7-1104-e81857df8bcd@redhat.com>
 <9b714315c8934da38449eb2ce5b85cfc@mpinat.mpg.de>
 <70e8a12c-d94e-7784-c842-cbdd87ff438e@redhat.com>
 <62582bb6b2124f1a9dd111f29049b25b@mpinat.mpg.de>
 <a6091b92-c216-e525-0bc7-5515225f6dc8@molgen.mpg.de>
 <a212e2465caf4c7da3aa1fe0e094831f@mpinat.mpg.de>
 <CAOi1vP-g2no3i91SshzcWb8XY6aup4h_GcO6Le=caM8-XmXGnQ@mail.gmail.com>
 <f3e2a67f41bb49bc8e131ce2f0bf5816@mpinat.mpg.de>
 <CAOi1vP8G2UgBXvNVv4hjaMcAsjSDC-KBeRpXYhsdTaYcnF0c2Q@mail.gmail.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <CAOi1vP8G2UgBXvNVv4hjaMcAsjSDC-KBeRpXYhsdTaYcnF0c2Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Dear Ilya,


Am 22.12.22 um 16:25 schrieb Ilya Dryomov:
> On Thu, Dec 22, 2022 at 3:41 PM Roose, Marco <marco.roose@mpinat.mpg.de> wrote:

>> thanks for providing the revert. Using that commit all is fine:
>>
>> ~# uname -a
>> Linux S1020-CephTest 6.1.0+ #1 SMP PREEMPT_DYNAMIC Thu Dec 22 14:30:22 CET
>> 2022 x86_64 x86_64 x86_64 GNU/Linux
>>
>> ~# rsync -ah --progress /root/test-file_1000MB /mnt/ceph/test-file_1000MB
>> sending incremental file list
>> test-file_1000MB
>>            1.00G 100%   90.53MB/s    0:00:10 (xfr#1, to-chk=0/1)
>>
>> I attach some ceph reports taking before, during and after an rsync on a bad
>> kernel (5.6.0) for debugging.
> 
> I see two CephFS data pools and one of them is nearfull:
> 
>      "pool": 10,
>      "pool_name": "cephfs_data",
>      "create_time": "2020-11-22T08:19:53.701636+0100",
>      "flags": 1,
>      "flags_names": "hashpspool",
> 
>      "pool": 11,
>      "pool_name": "cephfs_data_ec",
>      "create_time": "2020-11-22T08:22:01.779715+0100",
>      "flags": 2053,
>      "flags_names": "hashpspool,ec_overwrites,nearfull",
> 
> How is this CephFS filesystem is configured?  If you end up writing to
> cephfs_data_ec pool there, the slowness is expected.  nearfull makes
> the client revert to synchronous writes so that it can properly return
> ENOSPC error when nearfull develops into full.  That is the whole point
> of the commit that you landed upon when bisecting so of course
> reverting it helps:
> 
> -   if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_NEARFULL))
> +   if ((map_flags & CEPH_OSDMAP_NEARFULL) ||
> +       (pool_flags & CEPH_POOL_FLAG_NEARFULL))
>              iocb->ki_flags |= IOCB_DSYNC;

Well, that effect is not documented in the commit message, and for the 
user it’s a regression, that the existing (for the user working) 
configuration performs worse after updating the Linux kernel. That 
violates Linux’ no-regression policy, and at least needs to be better 
documented and explained.


Kind regards,

Paul
