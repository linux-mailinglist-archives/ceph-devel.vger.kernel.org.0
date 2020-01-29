Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 132F914C942
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Jan 2020 12:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgA2LHS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 Jan 2020 06:07:18 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:34052 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgA2LHS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 Jan 2020 06:07:18 -0500
Received: by mail-io1-f66.google.com with SMTP id z193so18112562iof.1
        for <ceph-devel@vger.kernel.org>; Wed, 29 Jan 2020 03:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DLxsEj07HyJ1GcQagcnxZmCQHIPdLPn6nz9/3JssnMA=;
        b=IGCzsu7JcdqqJLmu/L6JbvGApyJfrE3N8D9FQtvJlmfN2EU8gH0yjE8vYCrNL3Cfeu
         tuWAC1TfHXAUANlf6KvjaCg6rZnZVXTz/NHGj5IHrDTVd/Jf3GLITASuTucyiQU0DLKD
         /qximXlou6XuokCObeCtPJSNwQVttK6Yt/mU8nvQUmR2onTkjwpJZR7/ljbQ06qyW9Zl
         Jovg+Urpsy25CisPqPotY95rEP+NZZBevePnuRo55tLCZ4YJAP7q1XF9UQzMwEN4ZoD+
         E0tlBSh6qfuU+J9xY9Umlb+0lLyiU6DDAIgUalv4A9Fcz3QnPyOC3ofRvzn4uLxNkFHu
         duxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DLxsEj07HyJ1GcQagcnxZmCQHIPdLPn6nz9/3JssnMA=;
        b=bZ5zO6saLT9AsXqAxGLjEJSJn+mTBeHyP1b1VPVAm6TqxGf0wyYAb6bqLvUdbUDqkJ
         pa9XOdvyCj6rP4aHNoopHP0mj9Wkhb6PjvGI4n/f/M1gtlnUCPDgOaiiaavCcKKiRm3v
         +J27dBDZ/nXJ3QT6reZjsAU17GWwy2zTakr1G2KjdQFfqAa+LC1vwXOOQyqGcuD9PLaX
         vb8QO9O46Fu5nCubZHH/MOcE0IbxjRtCS5ao7a+VeKLiuQqT71PYYzDu5i/ZfKeyw8Vu
         6vuVJAU+1zPu58ItJ3+9Dn8DYIcCfYV7tbOQR9HdJdZntaGiKWszx0louNGJekjBv9m5
         gzBg==
X-Gm-Message-State: APjAAAW+wUamgu9dSTSP9VECYgRxFC8VlTh2F55PitpmkznPzKgAwpLm
        mDWDcdvlfGIN5qclfmSzQSNkZhFiCOzbz8h5BPkSeNwN2Bc=
X-Google-Smtp-Source: APXvYqx35nInV2wJVWfdOGpiT9UEo8QbFJ97O4ybVVGWaAGyZDZ6csgB0r1+ot6ePKhvnWXMN9bubAG7xEezY74oACA=
X-Received: by 2002:a5d:9707:: with SMTP id h7mr21602184iol.112.1580296037153;
 Wed, 29 Jan 2020 03:07:17 -0800 (PST)
MIME-Version: 1.0
References: <CAMym5ws4+-XstsJyvJmhzSHgvNYk8pbzOuY3cmT_ySwNDHkqCw@mail.gmail.com>
In-Reply-To: <CAMym5ws4+-XstsJyvJmhzSHgvNYk8pbzOuY3cmT_ySwNDHkqCw@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 29 Jan 2020 12:07:25 +0100
Message-ID: <CAOi1vP8XLFV8OVr4g7N_U3oo4yEVafn=7uMxnjX8NJ-VJHUsgQ@mail.gmail.com>
Subject: Re: Some tasks got to hang_task that would be due to RBD driver
To:     Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jan 29, 2020 at 8:25 AM Satoru Takeuchi
<satoru.takeuchi@gmail.com> wrote:
>
> Hi,
>
> In Rook(*1)/Ceph community, some users encountered hang_task in XFS and it
> would be caused by RBD driver.
>
> Although we've not reproduced this problem in the newest kernel, could anyone
> give us any hint about this problem, if possible?
>
> *1) An Ceph orchestration in Kubernetes
>
> - A question about this problem in linux-xfs ML
>   https://marc.info/?l=linux-xfs&m=158009629016068&w=2
>
> - The reply to the above-mentioned question from Dave Chinner.
>   https://marc.info/?l=linux-xfs&m=158018349207976&w=2
>
> I copied-and-pasted the discussion of above-mentioned mails here.
>
> my question:
> ```
> Under some workload in Ceph, many processes got to hang_task. We found
> that there are two kinds of processes.
>
> a) In very high CPU load
> b) Encountered hang_task in the XFS
>
> In addition,a user got the following two kernel traces.
>
> A (b) process's backtrace with `hung_task_panic=1`.
>
> ```
> [51717.039319] INFO: task kworker/2:1:5938 blocked for more than 120 seconds.
> [51717.039361]       Not tainted 4.15.0-72-generic #81-Ubuntu
> [51717.039388] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [51717.039426] kworker/2:1     D    0  5938      2 0x80000000
> [51717.039471] Workqueue: xfs-sync/rbd0 xfs_log_worker [xfs]
> [51717.039472] Call Trace:
> [51717.039478]  __schedule+0x24e/0x880
> [51717.039504]  ? xlog_sync+0x2d5/0x3c0 [xfs]
> [51717.039506]  schedule+0x2c/0x80
> [51717.039530]  _xfs_log_force_lsn+0x20e/0x350 [xfs]
> [51717.039533]  ? wake_up_q+0x80/0x80
> [51717.039556]  __xfs_trans_commit+0x20b/0x280 [xfs]
> [51717.039577]  xfs_trans_commit+0x10/0x20 [xfs]
> [51717.039600]  xfs_sync_sb+0x6d/0x80 [xfs]
> [51717.039623]  xfs_log_worker+0xe7/0x100 [xfs]
> [51717.039626]  process_one_work+0x1de/0x420
> [51717.039627]  worker_thread+0x32/0x410
> [51717.039628]  kthread+0x121/0x140
> [51717.039630]  ? process_one_work+0x420/0x420
> [51717.039631]  ? kthread_create_worker_on_cpu+0x70/0x70
> [51717.039633]  ret_from_fork+0x35/0x40
> ```
>
> A (b) process's backtrace that is got by `sudo cat /proc/<PID of a D
> process>/stack`
>
> ```
> [<0>] _xfs_log_force_lsn+0x20e/0x350 [xfs]
> [<0>] __xfs_trans_commit+0x20b/0x280 [xfs]
> [<0>] xfs_trans_commit+0x10/0x20 [xfs]
> [<0>] xfs_sync_sb+0x6d/0x80 [xfs]
> [<0>] xfs_log_sbcount+0x4b/0x60 [xfs]
> [<0>] xfs_unmountfs+0xe7/0x200 [xfs]
> [<0>] xfs_fs_put_super+0x3e/0xb0 [xfs]
> [<0>] generic_shutdown_super+0x72/0x120
> [<0>] kill_block_super+0x2c/0x80
> [<0>] deactivate_locked_super+0x48/0x80
> [<0>] deactivate_super+0x40/0x60
> [<0>] cleanup_mnt+0x3f/0x80
> [<0>] __cleanup_mnt+0x12/0x20
> [<0>] task_work_run+0x9d/0xc0
> [<0>] exit_to_usermode_loop+0xc0/0xd0
> [<0>] do_syscall_64+0x121/0x130
> [<0>] entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [<0>] 0xffffffffffffffff
> ```
>
> Here is the result of my investigation:
>
> - I couldn't find any commit that would be related to this problem,
> both in the upstream
>   master and master and XFS's for-next
> - I couldn't find any discussions that would be related to the
> above-mentioned backtrace
>   in linux-xfs ML
> - There would be a problem in the transaction commit of XFS. In both
> of two traces,
>   (b) processes hung in _xfs_log_force_lsn+0x20e/0x350 [xfs]. This
> code is one of
>   the following two xlog_wait().
>
>   https://github.com/torvalds/linux/blob/master/fs/xfs/xfs_log.c#L3366
>   https://github.com/torvalds/linux/blob/master/fs/xfs/xfs_log.c#L3387
>
>   These processes released CPU voluntarily in the following line.
>
>   https://github.com/torvalds/linux/blob/master/fs/xfs/xfs_log_priv.h#L549
>
>   These two processes should be woken by the other process after that.
>   However, unfortunately, it didn't happen.
>
> Test environment:
> - kernel: 4.15.0-<x>-generic
> - XFS # Anyone hasn't reported this problem with other filesystems yet.
>
> Related discussions:
> - Issue of Rook:
>   https://github.com/rook/rook/issues/3132
> - Issue of Ceph
>   https://tracker.ceph.com/issues/40068
> ```
>
> Dave's answer:
> ```
> > Under some workload in Ceph, many processes got to hang_task. We found
> > that there
> > are two kinds of processes.
> >
> > a) In very high CPU load
> > b) Encountered hang_task in the XFS
> >
> > In addition,a user got the following two kernel traces.
> >
> > A (b) process's backtrace with `hung_task_panic=1`.
> >
> > ```
> > [51717.039319] INFO: task kworker/2:1:5938 blocked for more than 120 seconds.
> > [51717.039361]       Not tainted 4.15.0-72-generic #81-Ubuntu
>
> Kinda old, and not an upstream LTS kernel, right?
>
> > [51717.039388] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > disables this message.
> > [51717.039426] kworker/2:1     D    0  5938      2 0x80000000
> > [51717.039471] Workqueue: xfs-sync/rbd0 xfs_log_worker [xfs]
>
> Filesystem is on a Ceph RBD device.
>
> > [51717.039472] Call Trace:
> > [51717.039478]  __schedule+0x24e/0x880
> > [51717.039504]  ? xlog_sync+0x2d5/0x3c0 [xfs]
> > [51717.039506]  schedule+0x2c/0x80
> > [51717.039530]  _xfs_log_force_lsn+0x20e/0x350 [xfs]
> > [51717.039533]  ? wake_up_q+0x80/0x80
> > [51717.039556]  __xfs_trans_commit+0x20b/0x280 [xfs]
> > [51717.039577]  xfs_trans_commit+0x10/0x20 [xfs]
> > [51717.039600]  xfs_sync_sb+0x6d/0x80 [xfs]
> > [51717.039623]  xfs_log_worker+0xe7/0x100 [xfs]
> > [51717.039626]  process_one_work+0x1de/0x420
> > [51717.039627]  worker_thread+0x32/0x410
> > [51717.039628]  kthread+0x121/0x140
> > [51717.039630]  ? process_one_work+0x420/0x420
> > [51717.039631]  ? kthread_create_worker_on_cpu+0x70/0x70
> > [51717.039633]  ret_from_fork+0x35/0x40
>
> That's waiting for log IO completion.
>
> > ```
> >
> > A (b) process's backtrace that is got by `sudo cat /proc/<PID of a D
> > process>/stack`
> >
> > ```
> > [<0>] _xfs_log_force_lsn+0x20e/0x350 [xfs]
> > [<0>] __xfs_trans_commit+0x20b/0x280 [xfs]
> > [<0>] xfs_trans_commit+0x10/0x20 [xfs]
> > [<0>] xfs_sync_sb+0x6d/0x80 [xfs]
> > [<0>] xfs_log_sbcount+0x4b/0x60 [xfs]
> > [<0>] xfs_unmountfs+0xe7/0x200 [xfs]
> > [<0>] xfs_fs_put_super+0x3e/0xb0 [xfs]
> > [<0>] generic_shutdown_super+0x72/0x120
> > [<0>] kill_block_super+0x2c/0x80
> > [<0>] deactivate_locked_super+0x48/0x80
> > [<0>] deactivate_super+0x40/0x60
> > [<0>] cleanup_mnt+0x3f/0x80
> > [<0>] __cleanup_mnt+0x12/0x20
> > [<0>] task_work_run+0x9d/0xc0
> > [<0>] exit_to_usermode_loop+0xc0/0xd0
> > [<0>] do_syscall_64+0x121/0x130
> > [<0>] entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> > [<0>] 0xffffffffffffffff
>
> ANd this is the last reference to the filesystem being dropped and
> it waiting for log IO completion.
>
> So, the filesytem has been unmounted, and it's waiting for journal
> IO on the device to complete.  I wonder if a wakeup was missed
> somewhere?
>
> Did the system stop/tear down /dev/rbd0 prematurely?

Hi Satoru,

I would ask the same question.  Typically this is seen when the network
is shut off before the filesystem on top of rbd is fully unmounted.

>
> > Related discussions:
> > - Issue of Rook:
> >   https://github.com/rook/rook/issues/3132
> > - Issue of Ceph
> >   https://tracker.ceph.com/issues/40068
>
> These point to Ceph RBDs failing to respond under high load and
> tasks hanging because they are waiting on IO. That's exactly the
> symptoms you are reporting here. That points to it being a Ceph RBD
> issue to me, especially the reports where rbd devices report no IO
> load but the ceph back end is at 100% disk utilisation doing
> -something-.

I skimmed through https://github.com/rook/rook/issues/3132 and this
particular stack trace came from someone who was upgrading their
cluster, draining node after node and saw a umount process get stuck.
This happens outside of k8s as well, but it is easier to hit with k8s
because of different volume plugins and sometimes multiple layers of
SDN involved.  One thing to do is to make sure that the filesystem on
top of rbd gets mounted with _netdev option.  It has no effect on the
kernel, but serves as a cue to systemd to order the unmount before
network teardown and some container engines had trouble propagating it
between their bind mounts in the past.  Of course, if you or k8s
somehow shut the network down before umount runs, _netdev won't help.

When dealing with suspected kernel issues, try to collect the entire
dmesg, not just a couple of stack traces.  In this case we would have
likely seen the kernel attempting to reconnect to the cluster over the
dead network because XFS has not finished unmounting:

  libceph: connect 10.19.115.5:6789 error -101
  libceph: mon1 10.19.115.5:6789 connect error


The rest of the issues in that ticket appear to have been resolved by
switching from XFS to ext4 on top of rbd.  This is crucial when mapping
rbd devices on the OSD nodes (i.e. co-locating the kernel client with
the OSDs) because XFS is a lot more aggressive about memory reclaim and
in doing that it is _much_ more likely to recurse back on itself, which
results in a deadlock.  This co-location + XFS deadlock is not specific
to rbd or ceph, here is someone who hit it with nbd:

  https://www.spinics.net/lists/linux-xfs/msg26261.html

There is no reliable way to prevent it in current kernels.  This is why
rook and ceph-csi default to ext4.

Thanks,

                Ilya
