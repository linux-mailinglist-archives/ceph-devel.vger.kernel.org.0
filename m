Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC1545BF2FB
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Sep 2022 03:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiIUBgg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 20 Sep 2022 21:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiIUBge (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 20 Sep 2022 21:36:34 -0400
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3848F4D279
        for <ceph-devel@vger.kernel.org>; Tue, 20 Sep 2022 18:36:33 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 7D6BC613C9;
        Wed, 21 Sep 2022 11:36:30 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id bRV4g2jaioYr; Wed, 21 Sep 2022 11:36:30 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 1E5906125D;
        Wed, 21 Sep 2022 11:36:30 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 008476803CA; Wed, 21 Sep 2022 11:36:29 +1000 (AEST)
Date:   Wed, 21 Sep 2022 11:36:29 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org
Subject: Re: rbd unmap fails with "Device or resource busy"
Message-ID: <20220921013629.GA1583272@onthe.net.au>
References: <20220913012043.GA568834@onthe.net.au>
 <CAOi1vP9FnHtg29X73EA0gwOpGcOXJmaujZ8p0JHc7qZ95V7QcQ@mail.gmail.com>
 <20220914034902.GA691415@onthe.net.au>
 <CAOi1vP8qmpEWVYS6EpYbMqP7PHTOLkzsqbNnN3g8Kzrz+9g_BA@mail.gmail.com>
 <20220915082920.GA881573@onthe.net.au>
 <20220919074321.GA1363634@onthe.net.au>
 <CAOi1vP-9hNc1A4wQ6WDFsNY=2R03inozfuWJcfaaCk5vZ2mqhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAOi1vP-9hNc1A4wQ6WDFsNY=2R03inozfuWJcfaaCk5vZ2mqhg@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Ilya,

On Mon, Sep 19, 2022 at 12:14:06PM +0200, Ilya Dryomov wrote:
> On Mon, Sep 19, 2022 at 9:43 AM Chris Dunlop <chris@onthe.net.au> wrote:
>>> On Tue, Sep 13, 2022 at 3:44 AM Chris Dunlop <chris@onthe.net.au> wrote:
>>>> What can make a "rbd unmap" fail, assuming the device is not 
>>>> mounted and not (obviously) open by any other processes?
>>
>> E.g. maybe there's some way of using ebpf or similar to look at the 
>> 'rbd_dev->open_count' in the live kernel?
>>
>> And/or maybe there's some way, again using ebpf or similar, to record 
>> sufficient info (e.g. a stack trace?) from rbd_open() and 
>> rbd_release() to try to identify something that's opening the device 
>> and not releasing it?
>
> Attaching kprobes to rbd_open() and rbd_release() is probably the 
> fastest option.  I don't think you even need a stack trace, PID and 
> comm (process name) should do.  I would start with something like:
>
> # bpftrace -e 'kprobe:rbd_open { printf("open pid %d comm %s\n", pid, 
> comm) } kprobe:rbd_release { printf("release pid %d comm %s\n", pid, 
> comm) }'
>
> Fetching the actual rbd_dev->open_count value is more involved but 
> also doable.

Excellent! Thanks!

tl;dr there's something other than the open_count causing the unmap 
failures - or something's elevating and decrementing open_count without 
going through rbd_open and rbd_release. Or perhaps there's some situation 
whereby bpftrace "misses" recording calls to rbd_open and rbd_release.

FYI, the production process is:

- create snapshot of rbd
- map
- mount with ro,norecovery,nouuid (the original live fs is still mounted)
- export via NFS
- mount on Windows NFS client
- process on Windows
- remove Windows NFS mount
- unexport from NFS
- unmount
- unmap

(I haven't mentioned the NFS export previously because I thought the 
issue was replicable without it - but that might simply have been due to 
the 'pvs' issue which has been resolved.)

I now have a script that mimics the above production sequence in a loop 
and left it running all night. Out of 288 iterations it had 13 instances 
where the unmap was failing for some time (i.e. in all cases it 
eventually succeeded, unlike the 51 rbd devices I can't seem to unmap at 
all without using --force). In the failing cases the unmap was retried 
at 1 second intervals. The shortest time taken to eventually umap was 
521 seconds, the longest was 793 seconds.

Note, in the below I'm using "successful" for the tests where the first 
unmap succeeded, and "failed" for the tests where the first unmap 
failed, although in all cases the unmap eventually succeeded.

I ended up with a bpftrace script (see below) that logs the timestamp, 
open or release (O/R), pid, device name, open_count (at entry to the 
function), and process name.

A successful iteration of that process mostly looks like this:

Timestamp     O/R Pid    Device Count Process
18:21:18.235870 O 3269426 rbd29 0 mapper
18:21:20.088873 R 3269426 rbd29 1 mapper
18:21:20.089346 O 3269447 rbd29 0 systemd-udevd
18:21:20.105281 O 3269457 rbd29 1 blkid
18:21:31.858621 R 3269457 rbd29 2 blkid
18:21:31.861762 R 3269447 rbd29 1 systemd-udevd
18:21:31.882235 O 3269475 rbd29 0 mount
18:21:38.241808 R 3269475 rbd29 1 mount
18:21:38.242174 O 3269475 rbd29 0 mount
18:22:49.646608 O 2364320 rbd29 1 rpc.mountd
18:22:58.715634 R 2364320 rbd29 2 rpc.mountd
18:23:55.564512 R 3270060 rbd29 1 umount

Or occasionally it looks like this, with "rpc.mountd" disappearing:

18:35:49.539224 O 3277664 rbd29 0 mapper
18:35:50.515777 R 3277664 rbd29 1 mapper
18:35:50.516224 O 3277685 rbd29 0 systemd-udevd
18:35:50.531978 O 3277694 rbd29 1 blkid
18:35:57.361799 R 3277694 rbd29 2 blkid
18:35:57.365263 R 3277685 rbd29 1 systemd-udevd
18:35:57.384316 O 3277713 rbd29 0 mount
18:36:01.234337 R 3277713 rbd29 1 mount
18:36:01.234849 O 3277713 rbd29 0 mount
18:37:21.304270 R 3289527 rbd29 1 umount

Of the 288 iterations, only 20 didn't include the rpc.mountd lines.

An unsuccessful iteration looks like this:

18:37:31.885408 O 3294108 rbd29 0 mapper
18:37:33.181607 R 3294108 rbd29 1 mapper
18:37:33.182086 O 3294175 rbd29 0 systemd-udevd
18:37:33.197982 O 3294691 rbd29 1 blkid
18:37:42.712870 R 3294691 rbd29 2 blkid
18:37:42.716296 R 3294175 rbd29 1 systemd-udevd
18:37:42.738469 O 3298073 rbd29 0 mount
18:37:49.339012 R 3298073 rbd29 1 mount
18:37:49.339352 O 3298073 rbd29 0 mount
18:38:51.390166 O 2364320 rbd29 1 rpc.mountd
18:39:00.989050 R 2364320 rbd29 2 rpc.mountd
18:53:56.054685 R 3313923 rbd29 1 init

According to my script log, the first unmap attempt was at 18:39:42, 
i.e. 42 seconds after rpc.mountd released the device. At that point the 
the open_count was (or should have been?) 1 again allowing the unmap to 
succeed - but it didn't. The unmap was retried every second until it 
eventually succeeded at 18:53:56, the same time as the mysterious "init" 
process ran - but also note there is NO "umount" process in there so I 
don't know if the name of the process recorded by bfptrace is simply 
incorrect (but how would that happen??) or what else could be going on.

All 13 of the failed iterations recorded that weird "init" instead of 
"umount".

12 of the 13 failed iterations included rpc.mountd in the trace, but one 
didn't (i.e. it went direct from mount to init/umount, like the 2nd 
successful example above), i.e. around the same proportion as the 
successful iterations.

So it seems there's something other than the open_count causing the unmap 
failures - or something's elevating and decrementing open_count without 
going through rbd_open and rbd_release. Or perhaps there's some situation 
whereby bpftrace "misses" recording calls to rbd_open and rbd_release.


The bpftrace script looks like this:
--------------------------------------------------------------------
//
// bunches of defines and structure definitions extracted from 
// drivers/block/rbd.c elided here...
//
kprobe:rbd_open {
   $bdev = (struct block_device *)arg0;
   $rbd_dev = (struct rbd_device *)($bdev->bd_disk->private_data);

   printf("%s O %d %s %lu %s\n",
     strftime("%T.%f", nsecs), pid, $rbd_dev->name,
     $rbd_dev->open_count, comm
   );
}
kprobe:rbd_release {
   $disk = (struct gendisk *)arg0;
   $rbd_dev = (struct rbd_device *)($disk->private_data);

   printf("%s R %d %s %lu %s\n",
     strftime("%T.%f", nsecs), pid, $rbd_dev->name,
     $rbd_dev->open_count, comm
   );
}
--------------------------------------------------------------------


Cheers,

Chris
