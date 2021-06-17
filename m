Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3783AAF01
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Jun 2021 10:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhFQIpE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Jun 2021 04:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbhFQIpD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Jun 2021 04:45:03 -0400
Received: from outbound3.mail.transip.nl (outbound3.mail.transip.nl [IPv6:2a01:7c8:7c9:ca11:136:144:136:12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B52C061574
        for <ceph-devel@vger.kernel.org>; Thu, 17 Jun 2021 01:42:55 -0700 (PDT)
Received: from submission5.mail.transip.nl (unknown [10.103.8.156])
        by outbound3.mail.transip.nl (Postfix) with ESMTP id 4G5Fth4SNBzprR5;
        Thu, 17 Jun 2021 10:42:52 +0200 (CEST)
Received: from exchange.transipgroup.nl (unknown [81.4.116.210])
        by submission5.mail.transip.nl (Postfix) with ESMTPSA id 4G5Ftg28dpz7tDb;
        Thu, 17 Jun 2021 10:42:51 +0200 (CEST)
Received: from VM16171.groupdir.nl (10.131.120.71) by VM16171.groupdir.nl
 (10.131.120.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.15; Thu, 17 Jun
 2021 10:42:49 +0200
Received: from VM16171.groupdir.nl ([81.4.116.210]) by VM16171.groupdir.nl
 ([81.4.116.210]) with mapi id 15.02.0792.015; Thu, 17 Jun 2021 10:42:49 +0200
From:   Robin Geuze <robin.geuze@nl.team.blue>
To:     Ilya Dryomov <idryomov@gmail.com>
CC:     Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: All RBD IO stuck after flapping OSD's
Thread-Topic: All RBD IO stuck after flapping OSD's
Thread-Index: AQHXMQs7yqmta0olA0ygBmx0d4s7EKq0G68AgAFka/SABi6BAIBbPDuXgAE5TYCAACJLAg==
Date:   Thu, 17 Jun 2021 08:42:49 +0000
Message-ID: <21c4b9e08c4d48d6b477fc61d1fccba3@nl.team.blue>
References: <47f0a04ce6664116a11cfdb5a458e252@nl.team.blue>
 <CAOi1vP-moRXtL4gKXQF8+NwbPgE11_LoxfSYqYBbJfYYQ7Sv_g@mail.gmail.com>
 <8eb12c996e404870803e9a7c77e508d6@nl.team.blue>
 <CAOi1vP-8i-rKEDd8Emq+MtxCjvK-6VG8KaXdzvQLW89174jUZA@mail.gmail.com>
 <666938090a8746a7ad8ae40ebf116e1c@nl.team.blue>,<CAOi1vP8NHYEN-=J4A7mB1dSkaHHf8Gtha-xqPLboZUS5u442hA@mail.gmail.com>
In-Reply-To: <CAOi1vP8NHYEN-=J4A7mB1dSkaHHf8Gtha-xqPLboZUS5u442hA@mail.gmail.com>
Accept-Language: en-GB, nl-NL, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [81.4.116.242]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Scanned-By: ClueGetter at submission5.mail.transip.nl
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=transip-a; d=nl.team.blue; t=1623919371; h=from:subject:to:cc:
 references:in-reply-to:date:mime-version:content-type;
 bh=5CY9J9rL56JBG8ngwdshD9tI7DtFrQ50LUi+ALEFiCQ=;
 b=hM68SeulBmOcSKAcqbSLtM0DANPCfayoG2+PEkviPDpyagvCJRjchemZAWB2B0T2OrRiq4
 p8gTyD8bTX48s1Jx9wi8tEJE+tTw7R1MfP8uLkLb/AJY7DEb5nGSG5NH8yZHK/YorlrV7H
 ZE5IWueG3lgBoTwe874lY8Reca9p7ClIQpMPvd4iX6U3OV2M4Eh+FuwBwe1BjG8y5R0NOt
 UO+XV0LgUHSggNpKgJzK0r+DuVl9i1+ZIb+NaRjREmAV+3bP56QYIS8vQwbezBobQH4xxF
 S+/KNVr75PXNo0jPLM4S/RabiOKbzxNIC4khn6LeY0U116M7bDapCF2f5wVljg==
X-Report-Abuse-To: abuse@transip.nl
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hey Ilya,

We triggered the issue at roughly 13:05, so the problem cannot have occurre=
d before 13:00.

We've also (in the wild, haven't reproduced that exact case yet) seen this =
occur without any stacktraces or stuck threads. The only "common" factor is=
 that we see the watch errors, always at least twice within 1 or 2 minutes =
if its broken.

Regards,

Robin Geuze
 =20
From: Ilya Dryomov <idryomov@gmail.com>
Sent: 17 June 2021 10:36:33
To: Robin Geuze
Cc: Ceph Development
Subject: Re: All RBD IO stuck after flapping OSD's
=A0  =20
On Wed, Jun 16, 2021 at 1:56 PM Robin Geuze <robin.geuze@nl.team.blue> wrot=
e:
>
> Hey Ilya,
>
> Sorry for the long delay, but we've finally managed to somewhat reliably =
reproduce this issue and produced a bunch of debug data. Its really big, so=
 you can find the files here: https://dionbosschieter.stackstorage.com/s/Rh=
M3FHLD28EcVJJ2
>
> We also got some stack traces those are in there as well.
>
> The way we reproduce it is that on one of the two ceph machines in the cl=
uster (its a test cluster) we toggle both the bond NIC ports down, sleep 40=
 seconds, put them back up, wait another 15 seconds and then put them back =
down, wait another 40 seconds and=A0  then put them back up.
>
> Exact command line I used on the ceph machine:
> ip l set ens785f1 down; sleep 1 ip l set ens785f0 down; sleep 40; ip l se=
t ens785f1 up; sleep 5; ip l set ens785f0 up; sleep 15; ip l set ens785f1 d=
own; sleep 1 ip l set ens785f0 down; sleep 40; ip l set ens785f1 up; sleep =
5; ip l set ens785f0 up

Hi Robin,

This looks very similar to https://tracker.ceph.com/issues/42757.
I don't see the offending writer thread among stuck threads in
stuck_kthreads.md though (and syslog_stuck_krbd_shrinked covers only
a short 13-second period of time so it's not there either because the
problem, at least the one I'm suspecting, would have occurred before
13:00:00).

If you can reproduce reliably, try again without verbose logging but
do capture all stack traces -- once the system locks up, let it stew
for ten minutes and attach "blocked for more than X seconds" splats.

Additionally, a "echo w >/proc/sysrq-trigger" dump would be good if
SysRq is not disabled on your servers.

Thanks,

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Ilya

>
> Regards,
>
> Robin Geuze
>
> From: Ilya Dryomov <idryomov@gmail.com>
> Sent: 19 April 2021 14:40:00
> To: Robin Geuze
> Cc: Ceph Development
> Subject: Re: All RBD IO stuck after flapping OSD's
>
> On Thu, Apr 15, 2021 at 2:21 PM Robin Geuze <robin.geuze@nl.team.blue> wr=
ote:
> >
> > Hey Ilya,
> >
> > We had to reboot the machine unfortunately, since we had customers unab=
le to work with their VM's. We did manage to make a dynamic debugging dump =
of an earlier occurence, maybe that can help? I've attached it to this emai=
l.
>
> No, I don't see anything to go on there.=A0 Next time, enable logging for
> both libceph and rbd modules and make sure that at least one instance of
> the error (i.e. "pre object map update failed: -16") makes it into the
> attached log.
>
> >
> > Those messages constantly occur, even after we kill the VM using the mo=
unt, I guess because there is pending IO which cannot be flushed.
> >
> > As for how its getting worse, if you try any management operations (eg =
unmap) on any of the RBD mounts that aren't affected, they hang and more of=
ten than not the IO for that one also stalls (not always though).
>
> One obvious workaround workaround is to unmap, disable object-map and
> exclusive-lock features with "rbd feature disable", and map back.=A0 You
> would lose the benefits of object map, but if it is affecting customer
> workloads it is probably the best course of action until this thing is
> root caused.
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
> > Sent: 14 April 2021 19:00:20
> > To: Robin Geuze
> > Cc: Ceph Development
> > Subject: Re: All RBD IO stuck after flapping OSD's
> >
> > On Wed, Apr 14, 2021 at 4:56 PM Robin Geuze <robin.geuze@nl.team.blue> =
wrote:
> > >
> > > Hey,
> > >
> > > We've encountered a weird issue when using the kernel RBD module. It =
starts with a bunch of OSD's flapping (in our case because of a network car=
d issue which caused the LACP to constantly flap), which is logged in dmesg=
:
> > >
> > > Apr 14 05:45:02 hv1 kernel: [647677.112461] libceph: osd56 down
> > > Apr 14 05:45:03 hv1 kernel: [647678.114962] libceph: osd54 down
> > > Apr 14 05:45:05 hv1 kernel: [647680.127329] libceph: osd50 down
> > > (...)
> > >
> > > After a while of that we start getting these errors being spammed in =
dmesg:
> > >
> > > Apr 14 05:47:35 hv1 kernel: [647830.671263] rbd: rbd14: pre object ma=
p update failed: -16
> > > Apr 14 05:47:35 hv1 kernel: [647830.671268] rbd: rbd14: write at objn=
o 192 2564096~2048 result -16
> > > Apr 14 05:47:35 hv1 kernel: [647830.671271] rbd: rbd14: write result =
-16
> > >
> > > (In this case for two different RBD mounts)
> > >
> > > At this point the IO for these two mounts is completely gone, and the=
 only reason we can still perform IO on the other RBD devices is because we=
 use noshare. Unfortunately unmounting the other devices is no longer possi=
ble, which means we cannot migrate=A0  our=A0 VM's to another HV, since to =
make the messages go away we have to reboot the server.
> >
> > Hi Robin,
> >
> > Do these messages appear even if no I/O is issued to /dev/rbd14 or only
> > if you attempt to write?
> >
> > >
> > > All of this wouldn't be such a big issue if it recovered once the clu=
ster started behaving normally again, but it doesn't, it just keeps being s=
tuck, and the longer we wait with rebooting this the worse the issue get.
> >
> > Please explain how it's getting worse.
> >
> > I think the problem is that the object map isn't locked.=A0 What
> > probably happened is the kernel client lost its watch on the image
> > and for some reason can't get it back.=A0=A0 The flapping has likely
> > trigged some edge condition in the watch/notify code.
> >
> > To confirm:
> >
> > - paste the contents of /sys/bus/rbd/devices/14/client_addr
> >
> > - paste the contents of /sys/kernel/debug/ceph/<cluster id>.client<id>/=
osdc
> >=A0=A0 for /dev/rbd14.=A0 If you are using noshare, you will have multip=
le
> >=A0=A0 client instances with the same cluster id.=A0 The one you need ca=
n be
> >=A0=A0 identified with /sys/bus/rbd/devices/14/client_id.
> >
> > - paste the output of "rbd status <rbd14 image>" (image name can be
> >=A0=A0 identified from "rbd showmapped")
> >
> > I'm also curious who actually has the lock on the header object and the
> > object map object.=A0 Paste the output of
> >
> > $ ID=3D$(bin/rbd info --format=3Djson <rbd14 pool>/<rbd14 image> | jq -=
r .id)
> > $ rados -p <rbd14 pool> lock info rbd_header.$ID rbd_lock | jq
> > $ rados -p <rbd14 pool> lock info rbd_object_map.$ID rbd_lock | jq
> >
> > Thanks,
> >
> >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Ilya
> >
>
    =
