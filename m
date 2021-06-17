Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342BC3AB20F
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Jun 2021 13:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbhFQLOo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Jun 2021 07:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbhFQLOg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Jun 2021 07:14:36 -0400
Received: from outbound2.mail.transip.nl (outbound2.mail.transip.nl [IPv6:2a01:7c8:7c8::73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC50C061574
        for <ceph-devel@vger.kernel.org>; Thu, 17 Jun 2021 04:12:27 -0700 (PDT)
Received: from submission14.mail.transip.nl (unknown [10.103.8.165])
        by outbound2.mail.transip.nl (Postfix) with ESMTP id 4G5KCF53vKzYcng;
        Thu, 17 Jun 2021 13:12:25 +0200 (CEST)
Received: from exchange.transipgroup.nl (unknown [81.4.116.210])
        by submission14.mail.transip.nl (Postfix) with ESMTPSA id 4G5KCF2jr5z2SSMp;
        Thu, 17 Jun 2021 13:12:25 +0200 (CEST)
Received: from VM16171.groupdir.nl (10.131.120.71) by VM16171.groupdir.nl
 (10.131.120.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.15; Thu, 17 Jun
 2021 13:12:24 +0200
Received: from VM16171.groupdir.nl ([81.4.116.210]) by VM16171.groupdir.nl
 ([81.4.116.210]) with mapi id 15.02.0792.015; Thu, 17 Jun 2021 13:12:24 +0200
From:   Robin Geuze <robin.geuze@nl.team.blue>
To:     Ilya Dryomov <idryomov@gmail.com>
CC:     Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: All RBD IO stuck after flapping OSD's
Thread-Topic: All RBD IO stuck after flapping OSD's
Thread-Index: AQHXMQs7yqmta0olA0ygBmx0d4s7EKq0G68AgAFka/SABi6BAIBbPDuXgAE5TYCAACJLAv//77AAgAArXHP//+1sAIAAIdhQ
Date:   Thu, 17 Jun 2021 11:12:23 +0000
Message-ID: <391efdae70644b71844fe6fa3dceea13@nl.team.blue>
References: <47f0a04ce6664116a11cfdb5a458e252@nl.team.blue>
 <CAOi1vP-moRXtL4gKXQF8+NwbPgE11_LoxfSYqYBbJfYYQ7Sv_g@mail.gmail.com>
 <8eb12c996e404870803e9a7c77e508d6@nl.team.blue>
 <CAOi1vP-8i-rKEDd8Emq+MtxCjvK-6VG8KaXdzvQLW89174jUZA@mail.gmail.com>
 <666938090a8746a7ad8ae40ebf116e1c@nl.team.blue>
 <CAOi1vP8NHYEN-=J4A7mB1dSkaHHf8Gtha-xqPLboZUS5u442hA@mail.gmail.com>
 <21c4b9e08c4d48d6b477fc61d1fccba3@nl.team.blue>
 <CAOi1vP_fJm5UzSnOmQDKsVHmv-4vebNZTDk7vqLs=bvnf3fwjw@mail.gmail.com>
 <a13af12ab314437bbbffcb23b0513722@nl.team.blue>,<CAOi1vP8kiGNaNPw=by=TVfJEV1_X-BNYZuVpO_Kxx5xtf40_6w@mail.gmail.com>
In-Reply-To: <CAOi1vP8kiGNaNPw=by=TVfJEV1_X-BNYZuVpO_Kxx5xtf40_6w@mail.gmail.com>
Accept-Language: en-GB, nl-NL, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [81.4.116.242]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Scanned-By: ClueGetter at submission14.mail.transip.nl
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=transip-a; d=nl.team.blue; t=1623928345; h=from:subject:to:cc:
 references:in-reply-to:date:mime-version:content-type;
 bh=djvrpv9BhKprZyZPvLGuQcRlsAnG9We4XwTVxvqHTUs=;
 b=mGTO7fP3zIkoXDxTM0sCA9fA4Jzyo77bTWXgIhq1tKWnZ+iNenrET5qqlEPEhSz74beKME
 gGRsFHSlkSxDXgu9VskthnpOe/rZu/cyOGE3AaLrXODQYiCopuueQvy7pMHEbbXl6Tawir
 7eLvvz3y++asW5ux98T+/pcCvAUF3yfkBqgNCnsZwnQFAPYAFeYu8ZcuEwlFkiQwlznUZL
 A6ws+XiRZOxc6u8/TNuBb1N2HNt1VVfjswCMSkYanWBZPfa5MXQaLTUTZrBbbtVtrdHlOe
 UAFOXn8yRW83D4TsUE29ErOxnjRYmYy05vLSW5QgkrzhKCBMecoZQPiawcWZsA==
X-Report-Abuse-To: abuse@transip.nl
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hey Ilya,

Yes we can install a custom kernel, or we can apply a patch to the current =
5.4 kernel if you prefer (we have a build street for the ubuntu kernel set =
up, so its not a lot of effort).

Regards,

Robin Geuze

From: Ilya Dryomov <idryomov@gmail.com>
Sent: 17 June 2021 13:09
To: Robin Geuze
Cc: Ceph Development
Subject: Re: All RBD IO stuck after flapping OSD's
=A0  =20
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

kworker/5:1=A0=A0=A0=A0 D=A0=A0=A0 0 161820=A0=A0=A0=A0=A0 2 0x80004000
Workqueue: ceph-msgr ceph_con_workfn [libceph]
Call Trace:
=A0__schedule+0x2e3/0x740
=A0schedule+0x42/0xb0
=A0rwsem_down_read_slowpath+0x16c/0x4a0
=A0down_read+0x85/0xa0
=A0rbd_img_handle_request+0x40/0x1a0 [rbd]
=A0? __rbd_obj_handle_request+0x61/0x2f0 [rbd]
=A0rbd_obj_handle_request+0x34/0x40 [rbd]
=A0rbd_osd_req_callback+0x44/0x80 [rbd]
=A0__complete_request+0x28/0x80 [libceph]
=A0handle_reply+0x2b6/0x460 [libceph]
=A0? ceph_crypt+0x1d/0x30 [libceph]
=A0? calc_signature+0xdf/0x100 [libceph]
=A0? ceph_x_check_message_signature+0x5e/0xd0 [libceph]
=A0dispatch+0x34/0xb0 [libceph]
=A0? dispatch+0x34/0xb0 [libceph]
=A0try_read+0x566/0x8c0 [libceph]
=A0ceph_con_workfn+0x130/0x620 [libceph]
=A0? __queue_delayed_work+0x8a/0x90
=A0process_one_work+0x1eb/0x3b0
=A0worker_thread+0x4d/0x400
=A0kthread+0x104/0x140
=A0? process_one_work+0x3b0/0x3b0
=A0? kthread_park+0x90/0x90
=A0ret_from_fork+0x35/0x40
kworker/26:1=A0=A0=A0 D=A0=A0=A0 0 226056=A0=A0=A0=A0=A0 2 0x80004000
Workqueue: ceph-msgr ceph_con_workfn [libceph]
Call Trace:
=A0__schedule+0x2e3/0x740
=A0schedule+0x42/0xb0
=A0rwsem_down_read_slowpath+0x16c/0x4a0
=A0down_read+0x85/0xa0
=A0rbd_img_handle_request+0x40/0x1a0 [rbd]
=A0? __rbd_obj_handle_request+0x61/0x2f0 [rbd]
=A0rbd_obj_handle_request+0x34/0x40 [rbd]
=A0rbd_osd_req_callback+0x44/0x80 [rbd]
=A0__complete_request+0x28/0x80 [libceph]
=A0handle_reply+0x2b6/0x460 [libceph]
=A0? ceph_crypt+0x1d/0x30 [libceph]
=A0? calc_signature+0xdf/0x100 [libceph]
=A0? ceph_x_check_message_signature+0x5e/0xd0 [libceph]
=A0dispatch+0x34/0xb0 [libceph]
=A0? dispatch+0x34/0xb0 [libceph]
=A0try_read+0x566/0x8c0 [libceph]
=A0? __switch_to_asm+0x40/0x70
=A0? __switch_to_asm+0x34/0x70
=A0? __switch_to_asm+0x40/0x70
=A0? __switch_to+0x7f/0x470
=A0? __switch_to_asm+0x40/0x70
=A0? __switch_to_asm+0x34/0x70
=A0ceph_con_workfn+0x130/0x620 [libceph]
=A0process_one_work+0x1eb/0x3b0
=A0worker_thread+0x4d/0x400
=A0kthread+0x104/0x140
=A0? process_one_work+0x3b0/0x3b0
=A0? kthread_park+0x90/0x90
=A0ret_from_fork+0x35/0x40

kworker/u112:2=A0 D=A0=A0=A0 0 277829=A0=A0=A0=A0=A0 2 0x80004000
Workqueue: rbd3-tasks rbd_reregister_watch [rbd]
Call Trace:
=A0__schedule+0x2e3/0x740
=A0schedule+0x42/0xb0
=A0schedule_timeout+0x10e/0x160
=A0? wait_for_completion_interruptible+0xb8/0x160
=A0wait_for_completion+0xb1/0x120
=A0? wake_up_q+0x70/0x70
=A0rbd_quiesce_lock+0xa1/0xe0 [rbd]
=A0rbd_reregister_watch+0x109/0x1b0 [rbd]
=A0process_one_work+0x1eb/0x3b0
=A0worker_thread+0x4d/0x400
=A0kthread+0x104/0x140
=A0? process_one_work+0x3b0/0x3b0
=A0? kthread_park+0x90/0x90
=A0ret_from_fork+0x35/0x40

kworker/u112:3=A0 D=A0=A0=A0 0 284466=A0=A0=A0=A0=A0 2 0x80004000
Workqueue: ceph-watch-notify do_watch_error [libceph]
Call Trace:
=A0__schedule+0x2e3/0x740
=A0? wake_up_klogd.part.0+0x34/0x40
=A0? sched_clock+0x9/0x10
=A0schedule+0x42/0xb0
=A0rwsem_down_write_slowpath+0x244/0x4d0
=A0down_write+0x41/0x50
=A0rbd_watch_errcb+0x2a/0x92 [rbd]
=A0do_watch_error+0x41/0xc0 [libceph]
=A0process_one_work+0x1eb/0x3b0
=A0worker_thread+0x4d/0x400
=A0kthread+0x104/0x140
=A0? process_one_work+0x3b0/0x3b0
=A0? kthread_park+0x90/0x90
=A0ret_from_fork+0x35/0x40

Not your original issue but closely related since it revolves around
exclusive-lock (which object-map depends on) and watches.

Would you be able to install a custom kernel on this node to test the
fix once I have it?

Thanks,

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Ilya

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
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Ilya
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
ack down, wait another 40 seconds=A0  and=A0=A0 then put them back up.
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
> >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Ilya
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
> > > No, I don't see anything to go on there.=A0 Next time, enable logging=
 for
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
> > > exclusive-lock features with "rbd feature disable", and map back.=A0 =
You
> > > would lose the benefits of object map, but if it is affecting custome=
r
> > > workloads it is probably the best course of action until this thing i=
s
> > > root caused.
> > >
> > > Thanks,
> > >
> > >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Ilya
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
ossible, which means we cannot migrate=A0=A0=A0  our=A0 VM's to another HV,=
 since to make the messages go away we have to reboot the server.
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
> > > > I think the problem is that the object map isn't locked.=A0 What
> > > > probably happened is the kernel client lost its watch on the image
> > > > and for some reason can't get it back.=A0=A0 The flapping has likel=
y
> > > > trigged some edge condition in the watch/notify code.
> > > >
> > > > To confirm:
> > > >
> > > > - paste the contents of /sys/bus/rbd/devices/14/client_addr
> > > >
> > > > - paste the contents of /sys/kernel/debug/ceph/<cluster id>.client<=
id>/osdc
> > > >=A0=A0 for /dev/rbd14.=A0 If you are using noshare, you will have mu=
ltiple
> > > >=A0=A0 client instances with the same cluster id.=A0 The one you nee=
d can be
> > > >=A0=A0 identified with /sys/bus/rbd/devices/14/client_id.
> > > >
> > > > - paste the output of "rbd status <rbd14 image>" (image name can be
> > > >=A0=A0 identified from "rbd showmapped")
> > > >
> > > > I'm also curious who actually has the lock on the header object and=
 the
> > > > object map object.=A0 Paste the output of
> > > >
> > > > $ ID=3D$(bin/rbd info --format=3Djson <rbd14 pool>/<rbd14 image> | =
jq -r .id)
> > > > $ rados -p <rbd14 pool> lock info rbd_header.$ID rbd_lock | jq
> > > > $ rados -p <rbd14 pool> lock info rbd_object_map.$ID rbd_lock | jq
> > > >
> > > > Thanks,
> > > >
> > > >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Ilya
> > > >
> > >
> >
>
    =
