Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B76A05BFC82
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Sep 2022 12:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiIUKlL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 21 Sep 2022 06:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiIUKlK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 21 Sep 2022 06:41:10 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BD710564
        for <ceph-devel@vger.kernel.org>; Wed, 21 Sep 2022 03:41:08 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id a41so8040880edf.4
        for <ceph-devel@vger.kernel.org>; Wed, 21 Sep 2022 03:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=CPvjsFxZGG0NfCpDWb+Qgpa0GLiEKq7z5imbzmNnTUQ=;
        b=gouTUe5NYp0gcZWcDZ2QwSnvUMDSxoi6/kX6VLHiK9pf1OQU8tY8vJpYazhGwrG1bi
         mp/Vul18vL/149TT63nRj/mxpW32CFiIFUFLBT1+CFT9SjiAdkq2s4SJIzkqivzh6dCJ
         RI221xiOdYCzsXbOXGHWK7/un/YBb2WBAxs3BYwmLwPBmh6phLNKU3vPBOO/lR4Hp/7A
         WIMG9F+4jGMB1qa0TUucU/Qccns4RDjCYJH5tn5vo1hZVgMhz6PZHmBXUzqDI2i/pnnj
         qlbtbYVd64F+o7KtZR1fqnWDpShwj9bb7WwK9L3C+zNZ/ulOZOFqk0K6SjE+r8Xoy/Rv
         HN2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=CPvjsFxZGG0NfCpDWb+Qgpa0GLiEKq7z5imbzmNnTUQ=;
        b=54a/3Y96mZOlEyKyG2ndFbi57p4VLVywRobTPG/74XHIjmclSHAPw0golbQcmvhBde
         8HyPUP/7mYQkS2whKmbOj/wT+eGmxICpplxk30vrwQ7n5OZZD9Gv4RvtkGLZNJkxC4aX
         STX6uysXC58QawszxduIFoIkWRpaxImOPV8Iw2b8e64YsAxjh2IKzpWDBo2Cyz1Gfs95
         ArzGNHS6pAQ8vAsjWsP/la3E/9tadotkPbHyuxyYQGyGKD3Ehn+Zgc01VW2Cl9JeybRB
         A1khTMc9NWtCgeqPLdzJM7L0a1Q6CtkR1fRXNsKzcuCE0swJ7gR/DmxbZufGpd+AtAGK
         Y/8g==
X-Gm-Message-State: ACrzQf1Gy4h2KFpz4D5AXAkuP3sPdB8rdOCXI+aLtMVk1y8kqDrdn7+i
        IusFzXJjYp9VIrxGE0Y4HihCq0CEjxCvXL1vGYuZqHu6rNw=
X-Google-Smtp-Source: AMsMyM6aNOE5xM5CXlZdY736zBateuvIKQ3L2o9qcMj2LKF3/3xiBbdUKF7b4ab/1DHtT+ss03o8J7oAkakE0eG8AGQ=
X-Received: by 2002:a05:6402:2789:b0:451:a578:74dd with SMTP id
 b9-20020a056402278900b00451a57874ddmr24394633ede.72.1663756866323; Wed, 21
 Sep 2022 03:41:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220913012043.GA568834@onthe.net.au> <CAOi1vP9FnHtg29X73EA0gwOpGcOXJmaujZ8p0JHc7qZ95V7QcQ@mail.gmail.com>
 <20220914034902.GA691415@onthe.net.au> <CAOi1vP8qmpEWVYS6EpYbMqP7PHTOLkzsqbNnN3g8Kzrz+9g_BA@mail.gmail.com>
 <20220915082920.GA881573@onthe.net.au> <20220919074321.GA1363634@onthe.net.au>
 <CAOi1vP-9hNc1A4wQ6WDFsNY=2R03inozfuWJcfaaCk5vZ2mqhg@mail.gmail.com> <20220921013629.GA1583272@onthe.net.au>
In-Reply-To: <20220921013629.GA1583272@onthe.net.au>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 21 Sep 2022 12:40:54 +0200
Message-ID: <CAOi1vP__Mj9Qyb=WsUxo7ja5koTS+0eavsnWH=X+DTest4spaQ@mail.gmail.com>
Subject: Re: rbd unmap fails with "Device or resource busy"
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Sep 21, 2022 at 3:36 AM Chris Dunlop <chris@onthe.net.au> wrote:
>
> Hi Ilya,
>
> On Mon, Sep 19, 2022 at 12:14:06PM +0200, Ilya Dryomov wrote:
> > On Mon, Sep 19, 2022 at 9:43 AM Chris Dunlop <chris@onthe.net.au> wrote:
> >>> On Tue, Sep 13, 2022 at 3:44 AM Chris Dunlop <chris@onthe.net.au> wrote:
> >>>> What can make a "rbd unmap" fail, assuming the device is not
> >>>> mounted and not (obviously) open by any other processes?
> >>
> >> E.g. maybe there's some way of using ebpf or similar to look at the
> >> 'rbd_dev->open_count' in the live kernel?
> >>
> >> And/or maybe there's some way, again using ebpf or similar, to record
> >> sufficient info (e.g. a stack trace?) from rbd_open() and
> >> rbd_release() to try to identify something that's opening the device
> >> and not releasing it?
> >
> > Attaching kprobes to rbd_open() and rbd_release() is probably the
> > fastest option.  I don't think you even need a stack trace, PID and
> > comm (process name) should do.  I would start with something like:
> >
> > # bpftrace -e 'kprobe:rbd_open { printf("open pid %d comm %s\n", pid,
> > comm) } kprobe:rbd_release { printf("release pid %d comm %s\n", pid,
> > comm) }'
> >
> > Fetching the actual rbd_dev->open_count value is more involved but
> > also doable.
>
> Excellent! Thanks!
>
> tl;dr there's something other than the open_count causing the unmap
> failures - or something's elevating and decrementing open_count without
> going through rbd_open and rbd_release. Or perhaps there's some situation
> whereby bpftrace "misses" recording calls to rbd_open and rbd_release.
>
> FYI, the production process is:
>
> - create snapshot of rbd
> - map
> - mount with ro,norecovery,nouuid (the original live fs is still mounted)
> - export via NFS
> - mount on Windows NFS client
> - process on Windows
> - remove Windows NFS mount
> - unexport from NFS
> - unmount
> - unmap
>
> (I haven't mentioned the NFS export previously because I thought the
> issue was replicable without it - but that might simply have been due to
> the 'pvs' issue which has been resolved.)
>
> I now have a script that mimics the above production sequence in a loop
> and left it running all night. Out of 288 iterations it had 13 instances
> where the unmap was failing for some time (i.e. in all cases it
> eventually succeeded, unlike the 51 rbd devices I can't seem to unmap at
> all without using --force). In the failing cases the unmap was retried
> at 1 second intervals. The shortest time taken to eventually umap was
> 521 seconds, the longest was 793 seconds.
>
> Note, in the below I'm using "successful" for the tests where the first
> unmap succeeded, and "failed" for the tests where the first unmap
> failed, although in all cases the unmap eventually succeeded.
>
> I ended up with a bpftrace script (see below) that logs the timestamp,
> open or release (O/R), pid, device name, open_count (at entry to the
> function), and process name.
>
> A successful iteration of that process mostly looks like this:
>
> Timestamp     O/R Pid    Device Count Process
> 18:21:18.235870 O 3269426 rbd29 0 mapper
> 18:21:20.088873 R 3269426 rbd29 1 mapper
> 18:21:20.089346 O 3269447 rbd29 0 systemd-udevd
> 18:21:20.105281 O 3269457 rbd29 1 blkid
> 18:21:31.858621 R 3269457 rbd29 2 blkid
> 18:21:31.861762 R 3269447 rbd29 1 systemd-udevd
> 18:21:31.882235 O 3269475 rbd29 0 mount
> 18:21:38.241808 R 3269475 rbd29 1 mount
> 18:21:38.242174 O 3269475 rbd29 0 mount
> 18:22:49.646608 O 2364320 rbd29 1 rpc.mountd
> 18:22:58.715634 R 2364320 rbd29 2 rpc.mountd
> 18:23:55.564512 R 3270060 rbd29 1 umount
>
> Or occasionally it looks like this, with "rpc.mountd" disappearing:
>
> 18:35:49.539224 O 3277664 rbd29 0 mapper
> 18:35:50.515777 R 3277664 rbd29 1 mapper
> 18:35:50.516224 O 3277685 rbd29 0 systemd-udevd
> 18:35:50.531978 O 3277694 rbd29 1 blkid
> 18:35:57.361799 R 3277694 rbd29 2 blkid
> 18:35:57.365263 R 3277685 rbd29 1 systemd-udevd
> 18:35:57.384316 O 3277713 rbd29 0 mount
> 18:36:01.234337 R 3277713 rbd29 1 mount
> 18:36:01.234849 O 3277713 rbd29 0 mount
> 18:37:21.304270 R 3289527 rbd29 1 umount
>
> Of the 288 iterations, only 20 didn't include the rpc.mountd lines.
>
> An unsuccessful iteration looks like this:
>
> 18:37:31.885408 O 3294108 rbd29 0 mapper
> 18:37:33.181607 R 3294108 rbd29 1 mapper
> 18:37:33.182086 O 3294175 rbd29 0 systemd-udevd
> 18:37:33.197982 O 3294691 rbd29 1 blkid
> 18:37:42.712870 R 3294691 rbd29 2 blkid
> 18:37:42.716296 R 3294175 rbd29 1 systemd-udevd
> 18:37:42.738469 O 3298073 rbd29 0 mount
> 18:37:49.339012 R 3298073 rbd29 1 mount
> 18:37:49.339352 O 3298073 rbd29 0 mount
> 18:38:51.390166 O 2364320 rbd29 1 rpc.mountd
> 18:39:00.989050 R 2364320 rbd29 2 rpc.mountd
> 18:53:56.054685 R 3313923 rbd29 1 init
>
> According to my script log, the first unmap attempt was at 18:39:42,
> i.e. 42 seconds after rpc.mountd released the device. At that point the
> the open_count was (or should have been?) 1 again allowing the unmap to
> succeed - but it didn't. The unmap was retried every second until it

Hi Chris,

For unmap to go through, open_count must be 0.  rpc.mountd at
18:39:00.989050 just decremented it from 2 to 1, it didn't release
the device.

> eventually succeeded at 18:53:56, the same time as the mysterious "init"
> process ran - but also note there is NO "umount" process in there so I
> don't know if the name of the process recorded by bfptrace is simply
> incorrect (but how would that happen??) or what else could be going on.

I would suggest adding the PID and the kernel stack trace at this
point.

>
> All 13 of the failed iterations recorded that weird "init" instead of
> "umount".

Yeah, that seems to be the culprit.

>
> 12 of the 13 failed iterations included rpc.mountd in the trace, but one
> didn't (i.e. it went direct from mount to init/umount, like the 2nd
> successful example above), i.e. around the same proportion as the
> successful iterations.
>
> So it seems there's something other than the open_count causing the unmap
> failures - or something's elevating and decrementing open_count without
> going through rbd_open and rbd_release. Or perhaps there's some situation
> whereby bpftrace "misses" recording calls to rbd_open and rbd_release.
>
>
> The bpftrace script looks like this:
> --------------------------------------------------------------------
> //
> // bunches of defines and structure definitions extracted from
> // drivers/block/rbd.c elided here...
> //

It would be good to attach the entire script, just in case someone runs
into a similar issue in the future and tries to debug the same way.

Thanks,

                Ilya
