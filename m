Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2F7114E58A
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Jan 2020 23:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgA3Wb7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Jan 2020 17:31:59 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46151 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgA3Wb7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 Jan 2020 17:31:59 -0500
Received: by mail-lj1-f194.google.com with SMTP id x14so5064822ljd.13
        for <ceph-devel@vger.kernel.org>; Thu, 30 Jan 2020 14:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AXA71eBnHuwx3jCn2bfaup+MLwgCaYC7S9Tuz6eDNqM=;
        b=CFxb1bNJaCKQwyLWa9glpTeoj46NC32vDJrB8OhSnI62Mq9EipzVfvsyakxZzNTDri
         G3nv5g6Nw6CU//ZOwC0kYFPhB/OtvNwsA/W2yy3dUDdYmMiKQl+sMvVQn+VBiY9w8/v9
         eYDF5PpGiyYoD+2RHXDtTgt6CYcsjuWuJBeOCvphuhOuFl5qqNcG3piCTWWi43B0uLiF
         ywzZv1GblEEBVCAhDEGRS0A/ZoCjk3IYPEXNH0yFpfis1W6xFDZsyH2ABQ0FODSQ554t
         c9bcEPJxNgVXBIoYjYEAmJZLedYalsR/avi5QoLJ/nVNZ16FNtu0Muo4Rdpyxp5novFF
         GkAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AXA71eBnHuwx3jCn2bfaup+MLwgCaYC7S9Tuz6eDNqM=;
        b=M3bsDlVqFX6w0uQ9I6ddlKmNgYF+KlJ0NK9Ro2vxPoWvYmASVpeBOeNeOQwCScAqyT
         ZYunxUigSv8Kkr5Y7zzFddqBq6ytZd8KcwiUF2uetiLT/FnKbPH4yYNhice1/WCqOK+8
         tU1z4TLym91B0U72mWjCDQv9lLe1rPw3jTgaqfsscusQZfdqDTfMO+5n/e7uPN+zsvEo
         itjvNSlkoKfeq5yeqdG8brBff+KNIBUJQyah59LIQlOTNSTBt+INzQmShG67xACfkWaG
         6FJXK7Wom5ELk7TLTZ2SRAJcNmsJyBsXj2Dsr/5tHwj4jltDaVP5tcUcg1IDqaXbn3mC
         V7VA==
X-Gm-Message-State: APjAAAWFVOgxQ38xAciYZEcWUOKlqXMCHvnInz/Ls3ewgFxu1/ZQNCTb
        XPV8Vv0J/YdEyOj1YMIGUBm0JG6GtH1IVnfiVnI=
X-Google-Smtp-Source: APXvYqycFxbLqhNt1qwV1PEdm1bt4P1w/aydUq/HVNVXYJmBr6lnw/uwNJ1BrU/osxUrtZvND4rGuwTJU2A0sULGykE=
X-Received: by 2002:a2e:580c:: with SMTP id m12mr4234919ljb.150.1580423516047;
 Thu, 30 Jan 2020 14:31:56 -0800 (PST)
MIME-Version: 1.0
References: <CAMym5ws4+-XstsJyvJmhzSHgvNYk8pbzOuY3cmT_ySwNDHkqCw@mail.gmail.com>
 <CAOi1vP8XLFV8OVr4g7N_U3oo4yEVafn=7uMxnjX8NJ-VJHUsgQ@mail.gmail.com> <CAOi1vP_ONM2iyyxi1wJrvOyGPanW=bC1BiGENGKGTc4EtBGnfw@mail.gmail.com>
In-Reply-To: <CAOi1vP_ONM2iyyxi1wJrvOyGPanW=bC1BiGENGKGTc4EtBGnfw@mail.gmail.com>
From:   Satoru Takeuchi <satoru.takeuchi@gmail.com>
Date:   Fri, 31 Jan 2020 07:31:43 +0900
Message-ID: <CAMym5wsSpscy5rA=sqo-a4DSBsYn1RAR2hnJ4jRq+S4fPxhB7Q@mail.gmail.com>
Subject: Re: Some tasks got to hang_task that would be due to RBD driver
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi  Ilya,

> This patch has just merged for 5.6 kernel.  Once it's out and ceph
> daemons are updated to make use of PR_SET_IO_FLUSHER, XFS should become
> usable in co-located setups.
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D8d19f1c8e1937baf74e1962aae9f90fa3aeab463

Thank you very much for letting me know the detailed explanation!
I'll tell Rook/Ceph guys this information.

Regards,
Satoru

2020=E5=B9=B41=E6=9C=8830=E6=97=A5(=E6=9C=A8) 23:54 Ilya Dryomov <idryomov@=
gmail.com>:
>
> On Wed, Jan 29, 2020 at 12:07 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> >
> > On Wed, Jan 29, 2020 at 8:25 AM Satoru Takeuchi
> > <satoru.takeuchi@gmail.com> wrote:
> > >
> > > Hi,
> > >
> > > In Rook(*1)/Ceph community, some users encountered hang_task in XFS a=
nd it
> > > would be caused by RBD driver.
> > >
> > > Although we've not reproduced this problem in the newest kernel, coul=
d anyone
> > > give us any hint about this problem, if possible?
> > >
> > > *1) An Ceph orchestration in Kubernetes
> > >
> > > - A question about this problem in linux-xfs ML
> > >   https://marc.info/?l=3Dlinux-xfs&m=3D158009629016068&w=3D2
> > >
> > > - The reply to the above-mentioned question from Dave Chinner.
> > >   https://marc.info/?l=3Dlinux-xfs&m=3D158018349207976&w=3D2
> > >
> > > I copied-and-pasted the discussion of above-mentioned mails here.
> > >
> > > my question:
> > > ```
> > > Under some workload in Ceph, many processes got to hang_task. We foun=
d
> > > that there are two kinds of processes.
> > >
> > > a) In very high CPU load
> > > b) Encountered hang_task in the XFS
> > >
> > > In addition,a user got the following two kernel traces.
> > >
> > > A (b) process's backtrace with `hung_task_panic=3D1`.
> > >
> > > ```
> > > [51717.039319] INFO: task kworker/2:1:5938 blocked for more than 120 =
seconds.
> > > [51717.039361]       Not tainted 4.15.0-72-generic #81-Ubuntu
> > > [51717.039388] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > > disables this message.
> > > [51717.039426] kworker/2:1     D    0  5938      2 0x80000000
> > > [51717.039471] Workqueue: xfs-sync/rbd0 xfs_log_worker [xfs]
> > > [51717.039472] Call Trace:
> > > [51717.039478]  __schedule+0x24e/0x880
> > > [51717.039504]  ? xlog_sync+0x2d5/0x3c0 [xfs]
> > > [51717.039506]  schedule+0x2c/0x80
> > > [51717.039530]  _xfs_log_force_lsn+0x20e/0x350 [xfs]
> > > [51717.039533]  ? wake_up_q+0x80/0x80
> > > [51717.039556]  __xfs_trans_commit+0x20b/0x280 [xfs]
> > > [51717.039577]  xfs_trans_commit+0x10/0x20 [xfs]
> > > [51717.039600]  xfs_sync_sb+0x6d/0x80 [xfs]
> > > [51717.039623]  xfs_log_worker+0xe7/0x100 [xfs]
> > > [51717.039626]  process_one_work+0x1de/0x420
> > > [51717.039627]  worker_thread+0x32/0x410
> > > [51717.039628]  kthread+0x121/0x140
> > > [51717.039630]  ? process_one_work+0x420/0x420
> > > [51717.039631]  ? kthread_create_worker_on_cpu+0x70/0x70
> > > [51717.039633]  ret_from_fork+0x35/0x40
> > > ```
> > >
> > > A (b) process's backtrace that is got by `sudo cat /proc/<PID of a D
> > > process>/stack`
> > >
> > > ```
> > > [<0>] _xfs_log_force_lsn+0x20e/0x350 [xfs]
> > > [<0>] __xfs_trans_commit+0x20b/0x280 [xfs]
> > > [<0>] xfs_trans_commit+0x10/0x20 [xfs]
> > > [<0>] xfs_sync_sb+0x6d/0x80 [xfs]
> > > [<0>] xfs_log_sbcount+0x4b/0x60 [xfs]
> > > [<0>] xfs_unmountfs+0xe7/0x200 [xfs]
> > > [<0>] xfs_fs_put_super+0x3e/0xb0 [xfs]
> > > [<0>] generic_shutdown_super+0x72/0x120
> > > [<0>] kill_block_super+0x2c/0x80
> > > [<0>] deactivate_locked_super+0x48/0x80
> > > [<0>] deactivate_super+0x40/0x60
> > > [<0>] cleanup_mnt+0x3f/0x80
> > > [<0>] __cleanup_mnt+0x12/0x20
> > > [<0>] task_work_run+0x9d/0xc0
> > > [<0>] exit_to_usermode_loop+0xc0/0xd0
> > > [<0>] do_syscall_64+0x121/0x130
> > > [<0>] entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> > > [<0>] 0xffffffffffffffff
> > > ```
> > >
> > > Here is the result of my investigation:
> > >
> > > - I couldn't find any commit that would be related to this problem,
> > > both in the upstream
> > >   master and master and XFS's for-next
> > > - I couldn't find any discussions that would be related to the
> > > above-mentioned backtrace
> > >   in linux-xfs ML
> > > - There would be a problem in the transaction commit of XFS. In both
> > > of two traces,
> > >   (b) processes hung in _xfs_log_force_lsn+0x20e/0x350 [xfs]. This
> > > code is one of
> > >   the following two xlog_wait().
> > >
> > >   https://github.com/torvalds/linux/blob/master/fs/xfs/xfs_log.c#L336=
6
> > >   https://github.com/torvalds/linux/blob/master/fs/xfs/xfs_log.c#L338=
7
> > >
> > >   These processes released CPU voluntarily in the following line.
> > >
> > >   https://github.com/torvalds/linux/blob/master/fs/xfs/xfs_log_priv.h=
#L549
> > >
> > >   These two processes should be woken by the other process after that=
.
> > >   However, unfortunately, it didn't happen.
> > >
> > > Test environment:
> > > - kernel: 4.15.0-<x>-generic
> > > - XFS # Anyone hasn't reported this problem with other filesystems ye=
t.
> > >
> > > Related discussions:
> > > - Issue of Rook:
> > >   https://github.com/rook/rook/issues/3132
> > > - Issue of Ceph
> > >   https://tracker.ceph.com/issues/40068
> > > ```
> > >
> > > Dave's answer:
> > > ```
> > > > Under some workload in Ceph, many processes got to hang_task. We fo=
und
> > > > that there
> > > > are two kinds of processes.
> > > >
> > > > a) In very high CPU load
> > > > b) Encountered hang_task in the XFS
> > > >
> > > > In addition,a user got the following two kernel traces.
> > > >
> > > > A (b) process's backtrace with `hung_task_panic=3D1`.
> > > >
> > > > ```
> > > > [51717.039319] INFO: task kworker/2:1:5938 blocked for more than 12=
0 seconds.
> > > > [51717.039361]       Not tainted 4.15.0-72-generic #81-Ubuntu
> > >
> > > Kinda old, and not an upstream LTS kernel, right?
> > >
> > > > [51717.039388] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > > > disables this message.
> > > > [51717.039426] kworker/2:1     D    0  5938      2 0x80000000
> > > > [51717.039471] Workqueue: xfs-sync/rbd0 xfs_log_worker [xfs]
> > >
> > > Filesystem is on a Ceph RBD device.
> > >
> > > > [51717.039472] Call Trace:
> > > > [51717.039478]  __schedule+0x24e/0x880
> > > > [51717.039504]  ? xlog_sync+0x2d5/0x3c0 [xfs]
> > > > [51717.039506]  schedule+0x2c/0x80
> > > > [51717.039530]  _xfs_log_force_lsn+0x20e/0x350 [xfs]
> > > > [51717.039533]  ? wake_up_q+0x80/0x80
> > > > [51717.039556]  __xfs_trans_commit+0x20b/0x280 [xfs]
> > > > [51717.039577]  xfs_trans_commit+0x10/0x20 [xfs]
> > > > [51717.039600]  xfs_sync_sb+0x6d/0x80 [xfs]
> > > > [51717.039623]  xfs_log_worker+0xe7/0x100 [xfs]
> > > > [51717.039626]  process_one_work+0x1de/0x420
> > > > [51717.039627]  worker_thread+0x32/0x410
> > > > [51717.039628]  kthread+0x121/0x140
> > > > [51717.039630]  ? process_one_work+0x420/0x420
> > > > [51717.039631]  ? kthread_create_worker_on_cpu+0x70/0x70
> > > > [51717.039633]  ret_from_fork+0x35/0x40
> > >
> > > That's waiting for log IO completion.
> > >
> > > > ```
> > > >
> > > > A (b) process's backtrace that is got by `sudo cat /proc/<PID of a =
D
> > > > process>/stack`
> > > >
> > > > ```
> > > > [<0>] _xfs_log_force_lsn+0x20e/0x350 [xfs]
> > > > [<0>] __xfs_trans_commit+0x20b/0x280 [xfs]
> > > > [<0>] xfs_trans_commit+0x10/0x20 [xfs]
> > > > [<0>] xfs_sync_sb+0x6d/0x80 [xfs]
> > > > [<0>] xfs_log_sbcount+0x4b/0x60 [xfs]
> > > > [<0>] xfs_unmountfs+0xe7/0x200 [xfs]
> > > > [<0>] xfs_fs_put_super+0x3e/0xb0 [xfs]
> > > > [<0>] generic_shutdown_super+0x72/0x120
> > > > [<0>] kill_block_super+0x2c/0x80
> > > > [<0>] deactivate_locked_super+0x48/0x80
> > > > [<0>] deactivate_super+0x40/0x60
> > > > [<0>] cleanup_mnt+0x3f/0x80
> > > > [<0>] __cleanup_mnt+0x12/0x20
> > > > [<0>] task_work_run+0x9d/0xc0
> > > > [<0>] exit_to_usermode_loop+0xc0/0xd0
> > > > [<0>] do_syscall_64+0x121/0x130
> > > > [<0>] entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> > > > [<0>] 0xffffffffffffffff
> > >
> > > ANd this is the last reference to the filesystem being dropped and
> > > it waiting for log IO completion.
> > >
> > > So, the filesytem has been unmounted, and it's waiting for journal
> > > IO on the device to complete.  I wonder if a wakeup was missed
> > > somewhere?
> > >
> > > Did the system stop/tear down /dev/rbd0 prematurely?
> >
> > Hi Satoru,
> >
> > I would ask the same question.  Typically this is seen when the network
> > is shut off before the filesystem on top of rbd is fully unmounted.
> >
> > >
> > > > Related discussions:
> > > > - Issue of Rook:
> > > >   https://github.com/rook/rook/issues/3132
> > > > - Issue of Ceph
> > > >   https://tracker.ceph.com/issues/40068
> > >
> > > These point to Ceph RBDs failing to respond under high load and
> > > tasks hanging because they are waiting on IO. That's exactly the
> > > symptoms you are reporting here. That points to it being a Ceph RBD
> > > issue to me, especially the reports where rbd devices report no IO
> > > load but the ceph back end is at 100% disk utilisation doing
> > > -something-.
> >
> > I skimmed through https://github.com/rook/rook/issues/3132 and this
> > particular stack trace came from someone who was upgrading their
> > cluster, draining node after node and saw a umount process get stuck.
> > This happens outside of k8s as well, but it is easier to hit with k8s
> > because of different volume plugins and sometimes multiple layers of
> > SDN involved.  One thing to do is to make sure that the filesystem on
> > top of rbd gets mounted with _netdev option.  It has no effect on the
> > kernel, but serves as a cue to systemd to order the unmount before
> > network teardown and some container engines had trouble propagating it
> > between their bind mounts in the past.  Of course, if you or k8s
> > somehow shut the network down before umount runs, _netdev won't help.
> >
> > When dealing with suspected kernel issues, try to collect the entire
> > dmesg, not just a couple of stack traces.  In this case we would have
> > likely seen the kernel attempting to reconnect to the cluster over the
> > dead network because XFS has not finished unmounting:
> >
> >   libceph: connect 10.19.115.5:6789 error -101
> >   libceph: mon1 10.19.115.5:6789 connect error
> >
> >
> > The rest of the issues in that ticket appear to have been resolved by
> > switching from XFS to ext4 on top of rbd.  This is crucial when mapping
> > rbd devices on the OSD nodes (i.e. co-locating the kernel client with
> > the OSDs) because XFS is a lot more aggressive about memory reclaim and
> > in doing that it is _much_ more likely to recurse back on itself, which
> > results in a deadlock.  This co-location + XFS deadlock is not specific
> > to rbd or ceph, here is someone who hit it with nbd:
> >
> >   https://www.spinics.net/lists/linux-xfs/msg26261.html
> >
> > There is no reliable way to prevent it in current kernels.  This is why
> > rook and ceph-csi default to ext4.
>
> This patch has just merged for 5.6 kernel.  Once it's out and ceph
> daemons are updated to make use of PR_SET_IO_FLUSHER, XFS should become
> usable in co-located setups.
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D8d19f1c8e1937baf74e1962aae9f90fa3aeab463
>
> Thanks,
>
>                 Ilya
