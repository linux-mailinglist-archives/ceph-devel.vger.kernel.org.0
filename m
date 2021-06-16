Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9A53A99E2
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Jun 2021 14:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhFPMGV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Jun 2021 08:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbhFPMGV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Jun 2021 08:06:21 -0400
X-Greylist: delayed 481 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Jun 2021 05:04:15 PDT
Received: from outbound1.mail.transip.nl (outbound1.mail.transip.nl [IPv6:2a01:7c8:7c8::72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30812C061574
        for <ceph-devel@vger.kernel.org>; Wed, 16 Jun 2021 05:04:15 -0700 (PDT)
Received: from submission8.mail.transip.nl (unknown [10.103.8.159])
        by outbound1.mail.transip.nl (Postfix) with ESMTP id 4G4kDF2JKpzRhmt;
        Wed, 16 Jun 2021 13:56:13 +0200 (CEST)
Received: from exchange.transipgroup.nl (unknown [81.4.116.210])
        by submission8.mail.transip.nl (Postfix) with ESMTPSA id 4G4kDB32sBz2ZNs6;
        Wed, 16 Jun 2021 13:56:05 +0200 (CEST)
Received: from VM16171.groupdir.nl (10.131.120.71) by VM16171.groupdir.nl
 (10.131.120.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.15; Wed, 16 Jun
 2021 13:56:01 +0200
Received: from VM16171.groupdir.nl ([81.4.116.210]) by VM16171.groupdir.nl
 ([81.4.116.210]) with mapi id 15.02.0792.015; Wed, 16 Jun 2021 13:56:01 +0200
From:   Robin Geuze <robin.geuze@nl.team.blue>
To:     Ilya Dryomov <idryomov@gmail.com>
CC:     Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: All RBD IO stuck after flapping OSD's
Thread-Topic: All RBD IO stuck after flapping OSD's
Thread-Index: AQHXMQs7yqmta0olA0ygBmx0d4s7EKq0G68AgAFka/SABi6BAIBbPDuX
Date:   Wed, 16 Jun 2021 11:56:01 +0000
Message-ID: <666938090a8746a7ad8ae40ebf116e1c@nl.team.blue>
References: <47f0a04ce6664116a11cfdb5a458e252@nl.team.blue>
 <CAOi1vP-moRXtL4gKXQF8+NwbPgE11_LoxfSYqYBbJfYYQ7Sv_g@mail.gmail.com>
 <8eb12c996e404870803e9a7c77e508d6@nl.team.blue>,<CAOi1vP-8i-rKEDd8Emq+MtxCjvK-6VG8KaXdzvQLW89174jUZA@mail.gmail.com>
In-Reply-To: <CAOi1vP-8i-rKEDd8Emq+MtxCjvK-6VG8KaXdzvQLW89174jUZA@mail.gmail.com>
Accept-Language: en-GB, nl-NL, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [81.4.116.242]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Scanned-By: ClueGetter at submission8.mail.transip.nl
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=transip-a; d=nl.team.blue; t=1623844573; h=from:subject:to:cc:
 references:in-reply-to:date:mime-version:content-type;
 bh=g9FPaz2n9SuSLKEBjHz6tZ+ccq8+wZfzCk+dozsgTkE=;
 b=vT7xiRv7VfMP1TYn/L6B9gfRozIBdUxyLlxD3IVKZ0LeKGu/RHU4of+eeVROnN18z022sE
 R9I2pK15Orn0TNPDkYAKyLTH4cwgpLvJOMFdi7GqNxjIjhdek4e7+l7sq0NT5xeFYlNb/b
 niqme5/4N6I+X4cLQZycVo3gKLpPKyQOh+C5Q6MtRazEIBWToVFrvIuYizULi+qdtJveLL
 nQJNeDfJx6iDK0wiR0+oWiEezWVya+JMLEtjMwCSv6/oxWSpnzvMsfCV+n3244U9h13XDr
 K6q5TFalIwyEwWUAJQKzzt2p8It+Wa2BATzdO7pb2qYf0/01PgLlQoBl9M0X3g==
X-Report-Abuse-To: abuse@transip.nl
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hey Ilya,

Sorry for the long delay, but we've finally managed to somewhat reliably re=
produce this issue and produced a bunch of debug data. Its really big, so y=
ou can find the files here:=A0https://dionbosschieter.stackstorage.com/s/Rh=
M3FHLD28EcVJJ2

We also got some stack traces those are in there as well.

The way we reproduce it is that on one of the two ceph=A0machines in the cl=
uster (its a test cluster)=A0we toggle both the bond NIC ports down, sleep =
40 seconds, put them back up, wait another 15 seconds and then put them bac=
k down, wait another 40 seconds and  then put them back up.

Exact command line I used on the ceph machine:
ip l set ens785f1 down; sleep 1 ip l set ens785f0 down; sleep 40; ip l set =
ens785f1 up; sleep 5; ip l set ens785f0 up; sleep 15; ip l set ens785f1 dow=
n; sleep 1 ip l set ens785f0 down; sleep 40; ip l set ens785f1 up; sleep 5;=
 ip l set ens785f0 up

Regards,

Robin Geuze=20
 =20
From: Ilya Dryomov <idryomov@gmail.com>
Sent: 19 April 2021 14:40:00
To: Robin Geuze
Cc: Ceph Development
Subject: Re: All RBD IO stuck after flapping OSD's
=A0  =20
On Thu, Apr 15, 2021 at 2:21 PM Robin Geuze <robin.geuze@nl.team.blue> wrot=
e:
>
> Hey Ilya,
>
> We had to reboot the machine unfortunately, since we had customers unable=
 to work with their VM's. We did manage to make a dynamic debugging dump of=
 an earlier occurence, maybe that can help? I've attached it to this email.

No, I don't see anything to go on there.=A0 Next time, enable logging for
both libceph and rbd modules and make sure that at least one instance of
the error (i.e. "pre object map update failed: -16") makes it into the
attached log.

>
> Those messages constantly occur, even after we kill the VM using the moun=
t, I guess because there is pending IO which cannot be flushed.
>
> As for how its getting worse, if you try any management operations (eg un=
map) on any of the RBD mounts that aren't affected, they hang and more ofte=
n than not the IO for that one also stalls (not always though).

One obvious workaround workaround is to unmap, disable object-map and
exclusive-lock features with "rbd feature disable", and map back.=A0 You
would lose the benefits of object map, but if it is affecting customer
workloads it is probably the best course of action until this thing is
root caused.

Thanks,

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Ilya

>
> Regards,
>
> Robin Geuze
>
> From: Ilya Dryomov <idryomov@gmail.com>
> Sent: 14 April 2021 19:00:20
> To: Robin Geuze
> Cc: Ceph Development
> Subject: Re: All RBD IO stuck after flapping OSD's
>
> On Wed, Apr 14, 2021 at 4:56 PM Robin Geuze <robin.geuze@nl.team.blue> wr=
ote:
> >
> > Hey,
> >
> > We've encountered a weird issue when using the kernel RBD module. It st=
arts with a bunch of OSD's flapping (in our case because of a network card =
issue which caused the LACP to constantly flap), which is logged in dmesg:
> >
> > Apr 14 05:45:02 hv1 kernel: [647677.112461] libceph: osd56 down
> > Apr 14 05:45:03 hv1 kernel: [647678.114962] libceph: osd54 down
> > Apr 14 05:45:05 hv1 kernel: [647680.127329] libceph: osd50 down
> > (...)
> >
> > After a while of that we start getting these errors being spammed in dm=
esg:
> >
> > Apr 14 05:47:35 hv1 kernel: [647830.671263] rbd: rbd14: pre object map =
update failed: -16
> > Apr 14 05:47:35 hv1 kernel: [647830.671268] rbd: rbd14: write at objno =
192 2564096~2048 result -16
> > Apr 14 05:47:35 hv1 kernel: [647830.671271] rbd: rbd14: write result -1=
6
> >
> > (In this case for two different RBD mounts)
> >
> > At this point the IO for these two mounts is completely gone, and the o=
nly reason we can still perform IO on the other RBD devices is because we u=
se noshare. Unfortunately unmounting the other devices is no longer possibl=
e, which means we cannot migrate  our=A0 VM's to another HV, since to make =
the messages go away we have to reboot the server.
>
> Hi Robin,
>
> Do these messages appear even if no I/O is issued to /dev/rbd14 or only
> if you attempt to write?
>
> >
> > All of this wouldn't be such a big issue if it recovered once the clust=
er started behaving normally again, but it doesn't, it just keeps being stu=
ck, and the longer we wait with rebooting this the worse the issue get.
>
> Please explain how it's getting worse.
>
> I think the problem is that the object map isn't locked.=A0 What
> probably happened is the kernel client lost its watch on the image
> and for some reason can't get it back.=A0=A0 The flapping has likely
> trigged some edge condition in the watch/notify code.
>
> To confirm:
>
> - paste the contents of /sys/bus/rbd/devices/14/client_addr
>
> - paste the contents of /sys/kernel/debug/ceph/<cluster id>.client<id>/os=
dc
>=A0=A0 for /dev/rbd14.=A0 If you are using noshare, you will have multiple
>=A0=A0 client instances with the same cluster id.=A0 The one you need can =
be
>=A0=A0 identified with /sys/bus/rbd/devices/14/client_id.
>
> - paste the output of "rbd status <rbd14 image>" (image name can be
>=A0=A0 identified from "rbd showmapped")
>
> I'm also curious who actually has the lock on the header object and the
> object map object.=A0 Paste the output of
>
> $ ID=3D$(bin/rbd info --format=3Djson <rbd14 pool>/<rbd14 image> | jq -r =
.id)
> $ rados -p <rbd14 pool> lock info rbd_header.$ID rbd_lock | jq
> $ rados -p <rbd14 pool> lock info rbd_object_map.$ID rbd_lock | jq
>
> Thanks,
>
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Ilya
>
    =
