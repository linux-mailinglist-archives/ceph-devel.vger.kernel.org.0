Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF41D5E779C
	for <lists+ceph-devel@lfdr.de>; Fri, 23 Sep 2022 11:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbiIWJsN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 23 Sep 2022 05:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbiIWJr0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 23 Sep 2022 05:47:26 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A821190C7B
        for <ceph-devel@vger.kernel.org>; Fri, 23 Sep 2022 02:47:25 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id z13so7557079ejp.6
        for <ceph-devel@vger.kernel.org>; Fri, 23 Sep 2022 02:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=4SYtxr2yqwtKNqwZ5BFbQ9i4HBSSLjphKVAKIdVYbv0=;
        b=nheJ0WYg9SScD0+UdCEpLruUPkAakGwAW4YqqWLM0YUBTaUdQNkJ9DpNfoOF5YOqqE
         kxKou1SSEaiLIId7qVmBTX9LcXNuZh/9oS3o/ekKry0AD/3FotQ9d4as79OxHWo3vC0J
         OlQ8tIWAxqmXtbstBmA2u5ANbb9PJ9ws4OS52jwS0/b1/pUL1jv47k/vLWYOo05UfQXe
         ml7TyBmfuCnihieEnxiS1Sczs4kHo/79sCZV5Q739+2GY1mk689yUDyDUP3MdU4yUcI6
         cs++YQFAIZAyc2rAg+6kqgtt6T13XQVnlG8+nmmqgedm554lopkMA1DeFQR6vfuzvA0p
         uvYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=4SYtxr2yqwtKNqwZ5BFbQ9i4HBSSLjphKVAKIdVYbv0=;
        b=LrXUPl9XLDfNj0fB1ep1dMksAxbwg5R1NMFNMzEiMUw9jbFQb+ia99sNXwa8uKABcA
         VqVdniUFVCsGOChAtZ8VLH6v+8bbsR+ndxWcCyBr1OytUDeW0tCxIZ602WRJk6HKVPkG
         lE40zXUfWtGyqYn+lLsGybFOlWvoZwuPwPeQw8dFCqqB32PCt9wRXnsT6ABmFdpgsCpM
         DXb3jl7HYncZVBAocv+7pQSKPU5HviaKq7mfR4QteP9/hwhWFbf6ODjvLyOYcyqmJQT+
         fm7Oct/qBz0sfCYYd1O5yBD8XDnH1XNmGGqBW6mAWb2XZ4zHT6lgMCQG2QD+pCqZv01O
         R5Qg==
X-Gm-Message-State: ACrzQf2uw/+xz763HVHXjc+W6MgedNHlBSSgOj/UAnUSgLAWsIviM0go
        hFvwQrukChZSwXLHCmV0jXEne/wqLZA+Q//xrZkSjPPhrAQ=
X-Google-Smtp-Source: AMsMyM5BLFzZ/27D1dzmh2PA8rn8Hhfb0UMDigkimtRX6FnKhYDcnME2fIW9ipAgcB+aT+C5XCWha/V5o/7DFIC5bV4=
X-Received: by 2002:a17:907:c03:b0:781:fd5a:c093 with SMTP id
 ga3-20020a1709070c0300b00781fd5ac093mr6313352ejc.89.1663926443873; Fri, 23
 Sep 2022 02:47:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220913012043.GA568834@onthe.net.au> <CAOi1vP9FnHtg29X73EA0gwOpGcOXJmaujZ8p0JHc7qZ95V7QcQ@mail.gmail.com>
 <20220914034902.GA691415@onthe.net.au> <CAOi1vP8qmpEWVYS6EpYbMqP7PHTOLkzsqbNnN3g8Kzrz+9g_BA@mail.gmail.com>
 <20220915082920.GA881573@onthe.net.au> <20220919074321.GA1363634@onthe.net.au>
 <CAOi1vP-9hNc1A4wQ6WDFsNY=2R03inozfuWJcfaaCk5vZ2mqhg@mail.gmail.com>
 <20220921013629.GA1583272@onthe.net.au> <CAOi1vP__Mj9Qyb=WsUxo7ja5koTS+0eavsnWH=X+DTest4spaQ@mail.gmail.com>
 <20220923035826.GA1830185@onthe.net.au>
In-Reply-To: <20220923035826.GA1830185@onthe.net.au>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 23 Sep 2022 11:47:11 +0200
Message-ID: <CAOi1vP8Zfix48tM1ifAgQo1xK+HGC1Sh8mh+Bc=a7Bbv1QENxA@mail.gmail.com>
Subject: Re: rbd unmap fails with "Device or resource busy"
To:     Chris Dunlop <chris@onthe.net.au>, Adam King <adking@redhat.com>,
        Guillaume Abrioux <gabrioux@redhat.com>
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

On Fri, Sep 23, 2022 at 5:58 AM Chris Dunlop <chris@onthe.net.au> wrote:
>
> Hi Ilya,
>
> On Wed, Sep 21, 2022 at 12:40:54PM +0200, Ilya Dryomov wrote:
> > On Wed, Sep 21, 2022 at 3:36 AM Chris Dunlop <chris@onthe.net.au> wrote:
> >> On Tue, Sep 13, 2022 at 3:44 AM Chris Dunlop <chris@onthe.net.au> wrote:
> >>> What can make a "rbd unmap" fail, assuming the device is not
> >>> mounted and not (obviously) open by any other processes?
>
> OK, I'm confident I now understand the cause of this problem. The
> particular machine where I'm mounting the rbd snapshots is also running
> some containerised ceph services. The ceph containers are
> (bind-)mounting the entire host filesystem hierarchy on startup, and if
> a ceph container happens to start up whilst a rbd device is mounted, the
> container also has the rbd mounted, preventing the host from unmapping
> the device even after the host has unmounted it. (More below.)
>
> This brings up a couple of issues...
>
> Why is the ceph container getting access to the entire host filesystem
> in the first place?
>
> Even if I mount an rbd device with the "unbindable" mount option, which
> is specifically supposed to prevent bind mounts to that filesystem, the
> ceph containers still get the mount - how / why??
>
> If the ceph containers really do need access to the entire host
> filesystem, perhaps it would be better to do a "slave" mount, so if/when
> the hosts unmounts a filesystem it's also unmounted in the container[s].
> (Of course this also means any filesystems newly mounted in the host
> would also appear in the containers - but that happens anyway if the
> container is newly started).
>
> >> An unsuccessful iteration looks like this:
> >>
> >> 18:37:31.885408 O 3294108 rbd29 0 mapper
> >> 18:37:33.181607 R 3294108 rbd29 1 mapper
> >> 18:37:33.182086 O 3294175 rbd29 0 systemd-udevd
> >> 18:37:33.197982 O 3294691 rbd29 1 blkid
> >> 18:37:42.712870 R 3294691 rbd29 2 blkid
> >> 18:37:42.716296 R 3294175 rbd29 1 systemd-udevd
> >> 18:37:42.738469 O 3298073 rbd29 0 mount
> >> 18:37:49.339012 R 3298073 rbd29 1 mount
> >> 18:37:49.339352 O 3298073 rbd29 0 mount
> >> 18:38:51.390166 O 2364320 rbd29 1 rpc.mountd
> >> 18:39:00.989050 R 2364320 rbd29 2 rpc.mountd
> >> 18:53:56.054685 R 3313923 rbd29 1 init
> >>
> >> According to my script log, the first unmap attempt was at 18:39:42,
> >> i.e. 42 seconds after rpc.mountd released the device. At that point the
> >> the open_count was (or should have been?) 1 again allowing the unmap to
> >> succeed - but it didn't. The unmap was retried every second until it
> >
> > For unmap to go through, open_count must be 0.  rpc.mountd at
> > 18:39:00.989050 just decremented it from 2 to 1, it didn't release
> > the device.
>
> Yes - but my poorly made point was that, per the normal test iteration,
> some time shortly after rpc.mountd decremented open_count to 1, an
> "umount" command was run successfully (the test would have aborted if
> the umount didn't succeed) - but the "umount" didn't show up in the
> bpftrace output. Immediately after the umount a "rbd unmap" was run,
> which failed with "busy" - i.e. the open_count was still incremented.
>
> >> eventually succeeded at 18:53:56, the same time as the mysterious
> >> "init" process ran - but also note there is NO "umount" process in
> >> there so I don't know if the name of the process recorded by bfptrace
> >> is simply incorrect (but how would that happen??) or what else could
> >> be going on.
>
> Using "ps" once the unmap starts failing, then cross checking against
> the process id recorded for the mysterious "init" in the bpftrace
> output, reveals the full command line for the "init" is:
>
> /dev/init -- /usr/sbin/ceph-volume inventory --format=json-pretty --filter-for-batch
>
> I.e. it's the 'init' process of a ceph-volume container that eventually
> releases the open_count.
>
> After doing a lot of learning about ceph and containers (podman in this
> case) and namespaces etc. etc., the problem is now known...
>
> Ceph containers are started with '-v "/:/rootfs"' which bind mounts the
> entire host's filesystem hierarchy into the container. Specifically, if
> the host has mounted filesystems, they're also mounted within the
> container when it starts up. So, if a ceph container starts up whilst
> there is a filesystem mounted from an rbd mapped device, the container
> also has that mount - and it retains the mount even if the filesystem is
> unmounted in the host. So the rbd device can't be unmapped in the host
> until the filesystem is released by the container, either via an explicit
> umount within the container, or a umount from the host targetting the
> container namespace, or the container exits.
>
> This explains the mysterious 51 rbd devices that I haven't been able to
> unmap for a week: they're all mounted within long-running ceph containers
> that happened to start up whilst those 51 devices were all mounted
> somewhere.  I've now been able to unmap those devices after unmounting the
> filesystems within those containers using:
>
> umount --namespace "${pid_of_container}" "${fs}"
>
>
> ------------------------------------------------------------
> An example demonstrating the problem
> ------------------------------------------------------------
> #
> # Mount a snapshot, with "unbindable"
> #
> host# {
>    rbd=pool/name@snap
>    dev=$(rbd device map "${rbd}")
>    declare -p dev
>    mount -oro,norecovery,nouuid,unbindable "${dev}" "/mnt"
>    echo --
>    grep "${dev}" /proc/self/mountinfo
>    echo --
>    ls /mnt
>    echo --
> }
> declare -- dev="/dev/rbd30"
> --
> 1463 22 252:480 / /mnt ro unbindable - xfs /dev/rbd30 ro,nouuid,norecovery
> --
> file1 file2 file3
>
> #
> # The mount is still visible if we start a ceph container
> #
> host# cephadm shell
> root@host:/# ls /mnt
> file1 file2 file3
>
> #
> # The device is not unmappable from the host...
> #
> host# umount /mnt
> host# rbd device unmap "${dev}"
> rbd: sysfs write failed
> rbd: unmap failed: (16) Device or resource busy
>
> #
> # ...until we umount the filesystem within the container
> #
> #
> host# lsns -t mnt
>          NS TYPE NPROCS     PID USER             COMMAND
> 4026533050 mnt       2 3105356 root             /dev/init -- bash
> host# umount --namespace 3105356 /mnt
> host# rbd device unmap "${dev}"
>    ## success
> ------------------------------------------------------------

Hi Chris,

Thanks for the great analysis!  I think ceph-volume container does
it because of [1].  I'm not sure about "cephadm shell".  There is also
node-exporter container that needs access to the host for gathering
metrics.

I'm adding Adam (cephadm maintainer) and Guillaume (ceph-volume
maintainer) as this is something that clearly wasn't intended.

[1] https://tracker.ceph.com/issues/52926

                Ilya

>
>
> >> The bpftrace script looks like this:
> >
> > It would be good to attach the entire script, just in case someone runs
> > into a similar issue in the future and tries to debug the same way.
>
> Attached.
>
> Cheers,
>
> Chris
