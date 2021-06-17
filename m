Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A1B3AB1FE
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Jun 2021 13:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbhFQLLx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Jun 2021 07:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbhFQLLx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Jun 2021 07:11:53 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A528DC061574
        for <ceph-devel@vger.kernel.org>; Thu, 17 Jun 2021 04:09:45 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id k16so2651073ios.10
        for <ceph-devel@vger.kernel.org>; Thu, 17 Jun 2021 04:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QGVQzeUS2Zv7bZ8i9uBdev9UdMVnTUfvxCHrxPfN1+4=;
        b=ECxLWFTV0/OUSbfYWYi736kfjvkEqQ/fipQGLEw71/YHBqECfUl7ekQQvYFyteQfJa
         MKm6RtoLOr1KgJDW7wGo63DTLSiiVa0LjwbTXYqGWXUMCCTPnJKeQvQleThpjDzBgeTn
         tiZPKXPfcDZtdh+3FpWpcY2keIHGhLX2iSzsmrrIJz4+L90SopE7XP2/Sq9Y33sX7LJB
         ODXseOX+E9RM99rQJ9kvwMOh8Omb+jHo4kMl2CngUJT4bCQWvXeU+spmFnbJtCdCs6bC
         sd5IiFqMsYGCC6hYgThDgvyn5K4Ndzkk7ZO72TsnZ5Fge4qB8R/EW4HFfnLc9iWVi56X
         4YFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QGVQzeUS2Zv7bZ8i9uBdev9UdMVnTUfvxCHrxPfN1+4=;
        b=hw/ipqC/nRFXMCDpnCNrn/KArHY1Codr7QCO1VmDVRq1XU9hU+vTC7Cyc+vnuAxbob
         adIznb6X9bVHJNx4nQZpdvOpzn+adlW8Is9ZkItO0V/lVuV6ogrpqoqefjfSICHWNeBE
         M+KL3eWlWJSCtjvtG1bhonI/RFuN4nXyFudpCqpYgiY9+k+liP+Z0gwPWrcWxBE5bcsN
         eqrFJunNHnGGiyNzLBEyxQRnqdc2358t0wGK4apuimC+kMfqB+I3kFN5DSNAdCVocW9W
         HN6xgdF5ZoAgFfz+xZG1cCuW8JZKGiIXu3aj0P2rnikLBWYf8hlTqe+8LQ8Rr8Cr7cCo
         quAQ==
X-Gm-Message-State: AOAM5321hOhtfrx7bHsi0e5vXTli11Zmotog3nujKV8LkICPzVHdbVcO
        plultTwEzId+6NgKUr7evBaPlCpH7FP/VkEjxi65QpewiuraQQ==
X-Google-Smtp-Source: ABdhPJy/EmPSHBBL0hO6fAgU7mFCMtY1ZAio02Hwr8v6jOytxJSV42suLaNPTWYcMyOVpCsuvhdeI9/rM1tFXyHrYcI=
X-Received: by 2002:a6b:8f83:: with SMTP id r125mr3318157iod.123.1623928185064;
 Thu, 17 Jun 2021 04:09:45 -0700 (PDT)
MIME-Version: 1.0
References: <47f0a04ce6664116a11cfdb5a458e252@nl.team.blue>
 <CAOi1vP-moRXtL4gKXQF8+NwbPgE11_LoxfSYqYBbJfYYQ7Sv_g@mail.gmail.com>
 <8eb12c996e404870803e9a7c77e508d6@nl.team.blue> <CAOi1vP-8i-rKEDd8Emq+MtxCjvK-6VG8KaXdzvQLW89174jUZA@mail.gmail.com>
 <666938090a8746a7ad8ae40ebf116e1c@nl.team.blue> <CAOi1vP8NHYEN-=J4A7mB1dSkaHHf8Gtha-xqPLboZUS5u442hA@mail.gmail.com>
 <21c4b9e08c4d48d6b477fc61d1fccba3@nl.team.blue> <CAOi1vP_fJm5UzSnOmQDKsVHmv-4vebNZTDk7vqLs=bvnf3fwjw@mail.gmail.com>
 <a13af12ab314437bbbffcb23b0513722@nl.team.blue>
In-Reply-To: <a13af12ab314437bbbffcb23b0513722@nl.team.blue>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 17 Jun 2021 13:09:36 +0200
Message-ID: <CAOi1vP8kiGNaNPw=by=TVfJEV1_X-BNYZuVpO_Kxx5xtf40_6w@mail.gmail.com>
Subject: Re: All RBD IO stuck after flapping OSD's
To:     Robin Geuze <robin.geuze@nl.team.blue>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 17, 2021 at 12:17 PM Robin Geuze <robin.geuze@nl.team.blue> wro=
te:
>
> Hey Ilya,
>
> We've added some extra debug info to the fileshare from before, including=
 the sysrq-trigger output.

Yup, seems to be exactly https://tracker.ceph.com/issues/42757.
Here are the relevant tasks listed in the same order as in the
ticket (you have two tasks in ceph_con_workfn() instead of one):

kworker/5:1     D    0 161820      2 0x80004000
Workqueue: ceph-msgr ceph_con_workfn [libceph]
Call Trace:
 __schedule+0x2e3/0x740
 schedule+0x42/0xb0
 rwsem_down_read_slowpath+0x16c/0x4a0
 down_read+0x85/0xa0
 rbd_img_handle_request+0x40/0x1a0 [rbd]
 ? __rbd_obj_handle_request+0x61/0x2f0 [rbd]
 rbd_obj_handle_request+0x34/0x40 [rbd]
 rbd_osd_req_callback+0x44/0x80 [rbd]
 __complete_request+0x28/0x80 [libceph]
 handle_reply+0x2b6/0x460 [libceph]
 ? ceph_crypt+0x1d/0x30 [libceph]
 ? calc_signature+0xdf/0x100 [libceph]
 ? ceph_x_check_message_signature+0x5e/0xd0 [libceph]
 dispatch+0x34/0xb0 [libceph]
 ? dispatch+0x34/0xb0 [libceph]
 try_read+0x566/0x8c0 [libceph]
 ceph_con_workfn+0x130/0x620 [libceph]
 ? __queue_delayed_work+0x8a/0x90
 process_one_work+0x1eb/0x3b0
 worker_thread+0x4d/0x400
 kthread+0x104/0x140
 ? process_one_work+0x3b0/0x3b0
 ? kthread_park+0x90/0x90
 ret_from_fork+0x35/0x40
kworker/26:1    D    0 226056      2 0x80004000
Workqueue: ceph-msgr ceph_con_workfn [libceph]
Call Trace:
 __schedule+0x2e3/0x740
 schedule+0x42/0xb0
 rwsem_down_read_slowpath+0x16c/0x4a0
 down_read+0x85/0xa0
 rbd_img_handle_request+0x40/0x1a0 [rbd]
 ? __rbd_obj_handle_request+0x61/0x2f0 [rbd]
 rbd_obj_handle_request+0x34/0x40 [rbd]
 rbd_osd_req_callback+0x44/0x80 [rbd]
 __complete_request+0x28/0x80 [libceph]
 handle_reply+0x2b6/0x460 [libceph]
 ? ceph_crypt+0x1d/0x30 [libceph]
 ? calc_signature+0xdf/0x100 [libceph]
 ? ceph_x_check_message_signature+0x5e/0xd0 [libceph]
 dispatch+0x34/0xb0 [libceph]
 ? dispatch+0x34/0xb0 [libceph]
 try_read+0x566/0x8c0 [libceph]
 ? __switch_to_asm+0x40/0x70
 ? __switch_to_asm+0x34/0x70
 ? __switch_to_asm+0x40/0x70
 ? __switch_to+0x7f/0x470
 ? __switch_to_asm+0x40/0x70
 ? __switch_to_asm+0x34/0x70
 ceph_con_workfn+0x130/0x620 [libceph]
 process_one_work+0x1eb/0x3b0
 worker_thread+0x4d/0x400
 kthread+0x104/0x140
 ? process_one_work+0x3b0/0x3b0
 ? kthread_park+0x90/0x90
 ret_from_fork+0x35/0x40

kworker/u112:2  D    0 277829      2 0x80004000
Workqueue: rbd3-tasks rbd_reregister_watch [rbd]
Call Trace:
 __schedule+0x2e3/0x740
 schedule+0x42/0xb0
 schedule_timeout+0x10e/0x160
 ? wait_for_completion_interruptible+0xb8/0x160
 wait_for_completion+0xb1/0x120
 ? wake_up_q+0x70/0x70
 rbd_quiesce_lock+0xa1/0xe0 [rbd]
 rbd_reregister_watch+0x109/0x1b0 [rbd]
 process_one_work+0x1eb/0x3b0
 worker_thread+0x4d/0x400
 kthread+0x104/0x140
 ? process_one_work+0x3b0/0x3b0
 ? kthread_park+0x90/0x90
 ret_from_fork+0x35/0x40

kworker/u112:3  D    0 284466      2 0x80004000
Workqueue: ceph-watch-notify do_watch_error [libceph]
Call Trace:
 __schedule+0x2e3/0x740
 ? wake_up_klogd.part.0+0x34/0x40
 ? sched_clock+0x9/0x10
 schedule+0x42/0xb0
 rwsem_down_write_slowpath+0x244/0x4d0
 down_write+0x41/0x50
 rbd_watch_errcb+0x2a/0x92 [rbd]
 do_watch_error+0x41/0xc0 [libceph]
 process_one_work+0x1eb/0x3b0
 worker_thread+0x4d/0x400
 kthread+0x104/0x140
 ? process_one_work+0x3b0/0x3b0
 ? kthread_park+0x90/0x90
 ret_from_fork+0x35/0x40

Not your original issue but closely related since it revolves around
exclusive-lock (which object-map depends on) and watches.

Would you be able to install a custom kernel on this node to test the
fix once I have it?

Thanks,

                Ilya

>
> Regards,
>
> Robin Geuze
>
> From: Ilya Dryomov <idryomov@gmail.com>
> Sent: 17 June 2021 11:40:54
> To: Robin Geuze
> Cc: Ceph Development
> Subject: Re: All RBD IO stuck after flapping OSD's
>
> On Thu, Jun 17, 2021 at 10:42 AM Robin Geuze <robin.geuze@nl.team.blue> w=
rote:
> >
> > Hey Ilya,
> >
> > We triggered the issue at roughly 13:05, so the problem cannot have occ=
urred before 13:00.
> >
> > We've also (in the wild, haven't reproduced that exact case yet) seen t=
his occur without any stacktraces or stuck threads. The only "common" facto=
r is that we see the watch errors, always at least twice within 1 or 2 minu=
tes if its broken.
>
> Ah, I guess I got confused by timestamps in stuck_kthreads.md.
> I grepped for "pre object map update" errors that you reported
> initially and didn't see any.
>
> With any sort of networking issues, watch errors are expected.
>
> I'll take a deeper look at syslog_stuck_krbd_shrinked.
>
> Thanks,
>
>                 Ilya
>
> >
> > Regards,
> >
> > Robin Geuze
> >
> > From: Ilya Dryomov <idryomov@gmail.com>
> > Sent: 17 June 2021 10:36:33
> > To: Robin Geuze
> > Cc: Ceph Development
> > Subject: Re: All RBD IO stuck after flapping OSD's
> >
> > On Wed, Jun 16, 2021 at 1:56 PM Robin Geuze <robin.geuze@nl.team.blue> =
wrote:
> > >
> > > Hey Ilya,
> > >
> > > Sorry for the long delay, but we've finally managed to somewhat relia=
bly reproduce this issue and produced a bunch of debug data. Its really big=
, so you can find the files here: https://dionbosschieter.stackstorage.com/=
s/RhM3FHLD28EcVJJ2
> > >
> > > We also got some stack traces those are in there as well.
> > >
> > > The way we reproduce it is that on one of the two ceph machines in th=
e cluster (its a test cluster) we toggle both the bond NIC ports down, slee=
p 40 seconds, put them back up, wait another 15 seconds and then put them b=
ack down, wait another 40 seconds  and   then put them back up.
> > >
> > > Exact command line I used on the ceph machine:
> > > ip l set ens785f1 down; sleep 1 ip l set ens785f0 down; sleep 40; ip =
l set ens785f1 up; sleep 5; ip l set ens785f0 up; sleep 15; ip l set ens785=
f1 down; sleep 1 ip l set ens785f0 down; sleep 40; ip l set ens785f1 up; sl=
eep 5; ip l set ens785f0 up
> >
> > Hi Robin,
> >
> > This looks very similar to https://tracker.ceph.com/issues/42757.
> > I don't see the offending writer thread among stuck threads in
> > stuck_kthreads.md though (and syslog_stuck_krbd_shrinked covers only
> > a short 13-second period of time so it's not there either because the
> > problem, at least the one I'm suspecting, would have occurred before
> > 13:00:00).
> >
> > If you can reproduce reliably, try again without verbose logging but
> > do capture all stack traces -- once the system locks up, let it stew
> > for ten minutes and attach "blocked for more than X seconds" splats.
> >
> > Additionally, a "echo w >/proc/sysrq-trigger" dump would be good if
> > SysRq is not disabled on your servers.
> >
> > Thanks,
> >
> >                 Ilya
> >
> > >
> > > Regards,
> > >
> > > Robin Geuze
> > >
> > > From: Ilya Dryomov <idryomov@gmail.com>
> > > Sent: 19 April 2021 14:40:00
> > > To: Robin Geuze
> > > Cc: Ceph Development
> > > Subject: Re: All RBD IO stuck after flapping OSD's
> > >
> > > On Thu, Apr 15, 2021 at 2:21 PM Robin Geuze <robin.geuze@nl.team.blue=
> wrote:
> > > >
> > > > Hey Ilya,
> > > >
> > > > We had to reboot the machine unfortunately, since we had customers =
unable to work with their VM's. We did manage to make a dynamic debugging d=
ump of an earlier occurence, maybe that can help? I've attached it to this =
email.
> > >
> > > No, I don't see anything to go on there.  Next time, enable logging f=
or
> > > both libceph and rbd modules and make sure that at least one instance=
 of
> > > the error (i.e. "pre object map update failed: -16") makes it into th=
e
> > > attached log.
> > >
> > > >
> > > > Those messages constantly occur, even after we kill the VM using th=
e mount, I guess because there is pending IO which cannot be flushed.
> > > >
> > > > As for how its getting worse, if you try any management operations =
(eg unmap) on any of the RBD mounts that aren't affected, they hang and mor=
e often than not the IO for that one also stalls (not always though).
> > >
> > > One obvious workaround workaround is to unmap, disable object-map and
> > > exclusive-lock features with "rbd feature disable", and map back.  Yo=
u
> > > would lose the benefits of object map, but if it is affecting custome=
r
> > > workloads it is probably the best course of action until this thing i=
s
> > > root caused.
> > >
> > > Thanks,
> > >
> > >                 Ilya
> > >
> > > >
> > > > Regards,
> > > >
> > > > Robin Geuze
> > > >
> > > > From: Ilya Dryomov <idryomov@gmail.com>
> > > > Sent: 14 April 2021 19:00:20
> > > > To: Robin Geuze
> > > > Cc: Ceph Development
> > > > Subject: Re: All RBD IO stuck after flapping OSD's
> > > >
> > > > On Wed, Apr 14, 2021 at 4:56 PM Robin Geuze <robin.geuze@nl.team.bl=
ue> wrote:
> > > > >
> > > > > Hey,
> > > > >
> > > > > We've encountered a weird issue when using the kernel RBD module.=
 It starts with a bunch of OSD's flapping (in our case because of a network=
 card issue which caused the LACP to constantly flap), which is logged in d=
mesg:
> > > > >
> > > > > Apr 14 05:45:02 hv1 kernel: [647677.112461] libceph: osd56 down
> > > > > Apr 14 05:45:03 hv1 kernel: [647678.114962] libceph: osd54 down
> > > > > Apr 14 05:45:05 hv1 kernel: [647680.127329] libceph: osd50 down
> > > > > (...)
> > > > >
> > > > > After a while of that we start getting these errors being spammed=
 in dmesg:
> > > > >
> > > > > Apr 14 05:47:35 hv1 kernel: [647830.671263] rbd: rbd14: pre objec=
t map update failed: -16
> > > > > Apr 14 05:47:35 hv1 kernel: [647830.671268] rbd: rbd14: write at =
objno 192 2564096~2048 result -16
> > > > > Apr 14 05:47:35 hv1 kernel: [647830.671271] rbd: rbd14: write res=
ult -16
> > > > >
> > > > > (In this case for two different RBD mounts)
> > > > >
> > > > > At this point the IO for these two mounts is completely gone, and=
 the only reason we can still perform IO on the other RBD devices is becaus=
e we use noshare. Unfortunately unmounting the other devices is no longer p=
ossible, which means we cannot migrate    our  VM's to another HV, since to=
 make the messages go away we have to reboot the server.
> > > >
> > > > Hi Robin,
> > > >
> > > > Do these messages appear even if no I/O is issued to /dev/rbd14 or =
only
> > > > if you attempt to write?
> > > >
> > > > >
> > > > > All of this wouldn't be such a big issue if it recovered once the=
 cluster started behaving normally again, but it doesn't, it just keeps bei=
ng stuck, and the longer we wait with rebooting this the worse the issue ge=
t.
> > > >
> > > > Please explain how it's getting worse.
> > > >
> > > > I think the problem is that the object map isn't locked.  What
> > > > probably happened is the kernel client lost its watch on the image
> > > > and for some reason can't get it back.   The flapping has likely
> > > > trigged some edge condition in the watch/notify code.
> > > >
> > > > To confirm:
> > > >
> > > > - paste the contents of /sys/bus/rbd/devices/14/client_addr
> > > >
> > > > - paste the contents of /sys/kernel/debug/ceph/<cluster id>.client<=
id>/osdc
> > > >   for /dev/rbd14.  If you are using noshare, you will have multiple
> > > >   client instances with the same cluster id.  The one you need can =
be
> > > >   identified with /sys/bus/rbd/devices/14/client_id.
> > > >
> > > > - paste the output of "rbd status <rbd14 image>" (image name can be
> > > >   identified from "rbd showmapped")
> > > >
> > > > I'm also curious who actually has the lock on the header object and=
 the
> > > > object map object.  Paste the output of
> > > >
> > > > $ ID=3D$(bin/rbd info --format=3Djson <rbd14 pool>/<rbd14 image> | =
jq -r .id)
> > > > $ rados -p <rbd14 pool> lock info rbd_header.$ID rbd_lock | jq
> > > > $ rados -p <rbd14 pool> lock info rbd_object_map.$ID rbd_lock | jq
> > > >
> > > > Thanks,
> > > >
> > > >                 Ilya
> > > >
> > >
> >
>
