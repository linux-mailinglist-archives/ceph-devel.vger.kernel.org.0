Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D871619F254
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Apr 2020 11:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgDFJSx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Apr 2020 05:18:53 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45224 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbgDFJSw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Apr 2020 05:18:52 -0400
Received: by mail-lj1-f196.google.com with SMTP id t17so13821290ljc.12
        for <ceph-devel@vger.kernel.org>; Mon, 06 Apr 2020 02:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wdsPgThDCeJ3TshVLZAU6kDc5MHE3P4+i88hFO1CJYY=;
        b=erAr+gw+hzwhLVDRBtwY1veZ/JBJ9zhZzDyYe8TPLWBRtT5f61T9RdWxewYnEIYaKR
         DZ0FkTS2U9GHwlzBqPCz9NxtKVOqMXwMuOFx50y1cKUFtIBQrn82nNA7uAa5OKTv4cQe
         ATVjebHXXMOPV2vWSFWWFLo7+vuoxHLfDHTWepRN2oL3Lhzj+bKGA0FFLj5e6zBNM0Lz
         IWxCLGMJzcnuZtPLz+bAL4czFAAIoBHBWnNICSbzkL7aNslrEwekDIbUh3j1/qpYMIqs
         t5zQWm0ic/Jj5KIM6nGRTkRNFofGnxF1Ccn0WEj6XwmH8oVgI0MVKseQHv2OmhbhQzZ6
         d0kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wdsPgThDCeJ3TshVLZAU6kDc5MHE3P4+i88hFO1CJYY=;
        b=rFP51S86cDOXPUJwRseLwYFtzPrI3WmK7HkaNnzWx2o4LnlnBuZzwm+KRu1YR0ATYU
         FrIpU9NlvF7gbQKXMGxl4EHf68Y29/xUCR0n8F5wCnFqUOGI/lteFJHjZL+ESEMw6E54
         5yFYDXC1N4L8NEKrvXv8EXVRKcFAaEPr+32vzAXymm/nJhiTWCDmOr50XDuyICg4jnCv
         kkoBkFtC4KW6FjmCNV4VxPDVKSXUY/DDtz77huvLIMhm9i+Mz+jBzWqDfM67Az3EH0Sc
         gw/MuaKpxHg+/2NhSwh9Edo70M6xkYoNq5l1uzZwshDe30X46IFbX0UWIHiY3bLxH/Bu
         7/Uw==
X-Gm-Message-State: AGi0Puaew81Z3LEe5QlFb8YAWD1HiyMeN000+/Wa9PTtSFYT85ixozQ8
        iU+UWQyGbjxAQP1fD0tOegkAUoHbnrJBMt2UKCc=
X-Google-Smtp-Source: APiQypKgFtjbwsnkVms3dx6M/RiBYpdNt7Kqyl+YJMASOOi+0cjs2dMU0/fqvfr6hA+UKj06zf9DIeWG3xthim/G/uw=
X-Received: by 2002:a2e:3c08:: with SMTP id j8mr11933908lja.243.1586164729590;
 Mon, 06 Apr 2020 02:18:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAED-sidS3jt5f0nTvLp6_xL+sgk0FFJGaX-X7cCDav-8nwj4TA@mail.gmail.com>
 <CAAM7YAmTxAeiemB4YZzD02i8fu99FGSFwpc7zLuzT1xUO6Cn=Q@mail.gmail.com> <CAED-sie1P_HTZkaffnPJwHGX-ZnBTrYKps=_N4gH8C1+Oa6ydw@mail.gmail.com>
In-Reply-To: <CAED-sie1P_HTZkaffnPJwHGX-ZnBTrYKps=_N4gH8C1+Oa6ydw@mail.gmail.com>
From:   Jesper Krogh <jesper.krogh@gmail.com>
Date:   Mon, 6 Apr 2020 11:18:38 +0200
Message-ID: <CAED-sidV64ufDVBFn8yHZAGe0L7ejReXBFMj+qYMd+i3nP4g1g@mail.gmail.com>
Subject: Re: 5.4.20 - high load - lots of incoming data - small data read.
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

And it looks like I can reproduce this pattern - and when it has been
stuck for "sufficient" amount of time - then it gets blacklisted by
the MDS/OSD and (a related) issue is that I cannot get the mountpoint
back without a reboot on the kernel-client side.

On Mon, Apr 6, 2020 at 11:09 AM Jesper Krogh <jesper.krogh@gmail.com> wrote:
>
> home-directory style - median is about 3KB - but varies greatly.
>
> I also get this:
> [41204.865818] INFO: task kworker/u16:102:21903 blocked for more than
> 120 seconds.
> [41204.865955]       Not tainted 5.4.30 #5
> [41204.866006] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [41204.866056] kworker/u16:102 D    0 21903      2 0x80004000
> [41204.866119] Workqueue: ceph-inode ceph_inode_work [ceph]
> [41204.866120] Call Trace:
> [41204.866156]  __schedule+0x45f/0x710
> [41204.866162]  ? xas_store+0x391/0x5f0
> [41204.866164]  schedule+0x3e/0xa0
> [41204.866166]  io_schedule+0x16/0x40
> [41204.866180]  __lock_page+0x12a/0x1d0
> [41204.866182]  ? file_fdatawait_range+0x30/0x30
> [41204.866187]  truncate_inode_pages_range+0x52c/0x980
> [41204.866191]  ? syscall_return_via_sysret+0x12/0x7f
> [41204.866197]  ? drop_inode_snap_realm+0x98/0xa0 [ceph]
> [41204.866207]  ? fsnotify_grab_connector+0x4d/0x90
> [41204.866209]  truncate_inode_pages_final+0x4c/0x60
> [41204.866214]  ceph_evict_inode+0x2d/0x210 [ceph]
> [41204.866219]  evict+0xca/0x1a0
> [41204.866221]  iput+0x1ba/0x210
> [41204.866225]  ceph_inode_work+0x40/0x270 [ceph]
> [41204.866232]  process_one_work+0x167/0x400
> [41204.866233]  worker_thread+0x4d/0x460
> [41204.866236]  kthread+0x105/0x140
> [41204.866237]  ? rescuer_thread+0x370/0x370
> [41204.866239]  ? kthread_destroy_worker+0x50/0x50
> [41204.866240]  ret_from_fork+0x35/0x40
>
> On Mon, Apr 6, 2020 at 10:53 AM Yan, Zheng <ukernel@gmail.com> wrote:
> >
> > On Mon, Apr 6, 2020 at 4:06 PM Jesper Krogh <jesper.krogh@gmail.com> wrote:
> > >
> > > This is a CephFS client - its only purpose is to run the "filedaemon" of bacula
> > > and transport data to the tape-library from CephFS - below 2 threads is
> > > essentially doing something equivalent to
> > >
> > > find /cephfs/ -type f | xargs cat | nc server
> > >
> > > 2 threads only, load exploding and the "net read vs net write" has
> > > more than 100x difference.
> > >
> > > Can anyone explain this as "normal" behaviour?
> > > Server is a  VM with 16 "vCPU" and 16GB memory running libvirt/qemu
> > >
> > > jk@wombat:~$ w
> > >  07:50:33 up 11:25,  1 user,  load average: 206.43, 76.23, 50.58
> > > USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
> > > jk       pts/0    10.194.133.42    06:54    0.00s  0.05s  0.00s w
> > > jk@wombat:~$ dstat -ar
> > > --total-cpu-usage-- -dsk/total- -net/total- ---paging-- ---system-- --io/total-
> > > usr sys idl wai stl| read  writ| recv  send|  in   out | int   csw | read  writ
> > >   0   0  98   1   0|  14k   34k|   0     0 |   3B   27B| 481   294 |0.55  0.73
> > >   1   1   0  98   0|   0     0 |  60M  220k|   0     0 |6402  6182 |   0     0
> > >   0   1   0  98   0|   0     0 |  69M  255k|   0     0 |7305  4339 |   0     0
> > >   1   2   0  98   0|   0     0 |  76M  282k|   0     0 |7914  4886 |   0     0
> > >   1   1   0  99   0|   0     0 |  70M  260k|   0     0 |7293  4444 |   0     0
> > >   1   1   0  98   0|   0     0 |  80M  278k|   0     0 |8018  4931 |   0     0
> > >   0   1   0  98   0|   0     0 |  60M  221k|   0     0 |6435  5951 |   0     0
> > >   0   1   0  99   0|   0     0 |  59M  211k|   0     0 |6163  3584 |   0     0
> > >   0   1   0  98   0|   0     0 |  64M  323k|   0     0 |6653  3881 |   0     0
> > >   1   0   0  99   0|   0     0 |  61M  243k|   0     0 |6822  4401 |   0     0
> > >   0   1   0  99   0|   0     0 |  55M  205k|   0     0 |5975  3518 |   0     0
> > >   1   1   0  98   0|   0     0 |  68M  242k|   0     0 |7094  6544 |   0     0
> > >   0   1   0  99   0|   0     0 |  58M  230k|   0     0 |6639  4178 |   0     0
> > >   1   2   0  98   0|   0     0 |  61M  243k|   0     0 |7117  4477 |   0     0
> > >   0   1   0  99   0|   0     0 |  61M  228k|   0     0 |6500  4078 |   0     0
> > >   0   1   0  99   0|   0     0 |  65M  234k|   0     0 |6595  3914 |   0     0
> > >   0   1   0  98   0|   0     0 |  64M  219k|   0     0 |6507  5755 |   0     0
> > >   1   1   0  99   0|   0     0 |  64M  233k|   0     0 |6869  4153 |   0     0
> > >   1   2   0  98   0|   0     0 |  63M  232k|   0     0 |6632  3907 |
> > > 0     0 ^C
> > > jk@wombat:~$ w
> > >  07:50:56 up 11:25,  1 user,  load average: 221.35, 88.07, 55.02
> > > USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
> > > jk       pts/0    10.194.133.42    06:54    0.00s  0.05s  0.00s w
> > > jk@wombat:~$
> > >
> > > Thanks.
> >
> > how small these files are?
