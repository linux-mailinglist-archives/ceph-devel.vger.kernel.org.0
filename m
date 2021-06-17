Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E45D3AAFF5
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Jun 2021 11:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhFQJnL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Jun 2021 05:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbhFQJnK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Jun 2021 05:43:10 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57291C061574
        for <ceph-devel@vger.kernel.org>; Thu, 17 Jun 2021 02:41:03 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id f10so2419127iok.6
        for <ceph-devel@vger.kernel.org>; Thu, 17 Jun 2021 02:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yg7biX6jAJWRmaOloAzjlv3v/igwxz480Xagfl/md1c=;
        b=VWjnvC5k7IVwhCHg/BjIt6hYGipSOPAZ0zT3+yGVxM1Te73ajK3P2Dh5xqH/YxSv8S
         vh9xigXvafc+aAy2HdngDQRD4+0h4DuGEb0VU8fkmzNXL7yUKhoO4JjfRHDVw+4yF/SP
         Kp+o4HCyd+CEAfbD4tqA4cFLU+jOLOY1iToATuvZlMyC4cRe6vMaSpAB6KnRY+/uxI2P
         bgQwvV4ygOHrPFHXRj0XBogRyvcKpg2UriNnpyJZVZG36aHyWiIjLOZtw9C7JR3xtqf7
         eYBdaM0qxU5nOGK2kSue+20zUYbvE9WnRDBRs/vTDAh+uW922vqVL4o663yer8gQJ6Yf
         JHHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yg7biX6jAJWRmaOloAzjlv3v/igwxz480Xagfl/md1c=;
        b=RRdJ4AIN4EQC7cwPUJ5YhJqbQtcNl64c0hIccEbQF1bX0h1bZEMGjM1TjM3JcqfBni
         IOUUIfvYh2NcOsjQJhjuHJo5BMKDJ+gbXuiuMzr4VeFVdTdnK/9HQevEbQ1dMiOQI81l
         sZzSeNbyE2EcN1fzrZwCoww8a4MlA89+wSXQgthWbRVq+zeiomrs9hDM/Uyyi2hcaSV+
         6Pz8itbr9/AUU1m7I5SC7XaLe6BAGeoyf6x/GbKxKOQv6ZgnlY5Jo4Xhflr7F7caoN03
         3/qv4yAGrlRH4HjTZQ7PdsDhUwkRNmrVguP/tS3wgeBA2cOPM9uSuXntQXk6q0HfvgVi
         oN+Q==
X-Gm-Message-State: AOAM531n15h+UoYjDkBqG2LlYXylPqij57ItH5immoHGl2D0N/uwNre5
        s0MLXkA/9x/7cUKaszX8HSTYS0WR1tnlPLJDG6V1RFQEYDvHuw==
X-Google-Smtp-Source: ABdhPJzuk5fc7YeO8NEn7vBQmbTHK+dsNUGRU0IAsYZ2PC5PAmvdebFPUJ5tjG+DwjIIu9qJxy1ICxH5nlyR6ooFSg8=
X-Received: by 2002:a6b:8f83:: with SMTP id r125mr3035136iod.123.1623922862758;
 Thu, 17 Jun 2021 02:41:02 -0700 (PDT)
MIME-Version: 1.0
References: <47f0a04ce6664116a11cfdb5a458e252@nl.team.blue>
 <CAOi1vP-moRXtL4gKXQF8+NwbPgE11_LoxfSYqYBbJfYYQ7Sv_g@mail.gmail.com>
 <8eb12c996e404870803e9a7c77e508d6@nl.team.blue> <CAOi1vP-8i-rKEDd8Emq+MtxCjvK-6VG8KaXdzvQLW89174jUZA@mail.gmail.com>
 <666938090a8746a7ad8ae40ebf116e1c@nl.team.blue> <CAOi1vP8NHYEN-=J4A7mB1dSkaHHf8Gtha-xqPLboZUS5u442hA@mail.gmail.com>
 <21c4b9e08c4d48d6b477fc61d1fccba3@nl.team.blue>
In-Reply-To: <21c4b9e08c4d48d6b477fc61d1fccba3@nl.team.blue>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 17 Jun 2021 11:40:54 +0200
Message-ID: <CAOi1vP_fJm5UzSnOmQDKsVHmv-4vebNZTDk7vqLs=bvnf3fwjw@mail.gmail.com>
Subject: Re: All RBD IO stuck after flapping OSD's
To:     Robin Geuze <robin.geuze@nl.team.blue>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 17, 2021 at 10:42 AM Robin Geuze <robin.geuze@nl.team.blue> wro=
te:
>
> Hey Ilya,
>
> We triggered the issue at roughly 13:05, so the problem cannot have occur=
red before 13:00.
>
> We've also (in the wild, haven't reproduced that exact case yet) seen thi=
s occur without any stacktraces or stuck threads. The only "common" factor =
is that we see the watch errors, always at least twice within 1 or 2 minute=
s if its broken.

Ah, I guess I got confused by timestamps in stuck_kthreads.md.
I grepped for "pre object map update" errors that you reported
initially and didn't see any.

With any sort of networking issues, watch errors are expected.

I'll take a deeper look at syslog_stuck_krbd_shrinked.

Thanks,

                Ilya

>
> Regards,
>
> Robin Geuze
>
> From: Ilya Dryomov <idryomov@gmail.com>
> Sent: 17 June 2021 10:36:33
> To: Robin Geuze
> Cc: Ceph Development
> Subject: Re: All RBD IO stuck after flapping OSD's
>
> On Wed, Jun 16, 2021 at 1:56 PM Robin Geuze <robin.geuze@nl.team.blue> wr=
ote:
> >
> > Hey Ilya,
> >
> > Sorry for the long delay, but we've finally managed to somewhat reliabl=
y reproduce this issue and produced a bunch of debug data. Its really big, =
so you can find the files here: https://dionbosschieter.stackstorage.com/s/=
RhM3FHLD28EcVJJ2
> >
> > We also got some stack traces those are in there as well.
> >
> > The way we reproduce it is that on one of the two ceph machines in the =
cluster (its a test cluster) we toggle both the bond NIC ports down, sleep =
40 seconds, put them back up, wait another 15 seconds and then put them bac=
k down, wait another 40 seconds and   then put them back up.
> >
> > Exact command line I used on the ceph machine:
> > ip l set ens785f1 down; sleep 1 ip l set ens785f0 down; sleep 40; ip l =
set ens785f1 up; sleep 5; ip l set ens785f0 up; sleep 15; ip l set ens785f1=
 down; sleep 1 ip l set ens785f0 down; sleep 40; ip l set ens785f1 up; slee=
p 5; ip l set ens785f0 up
>
> Hi Robin,
>
> This looks very similar to https://tracker.ceph.com/issues/42757.
> I don't see the offending writer thread among stuck threads in
> stuck_kthreads.md though (and syslog_stuck_krbd_shrinked covers only
> a short 13-second period of time so it's not there either because the
> problem, at least the one I'm suspecting, would have occurred before
> 13:00:00).
>
> If you can reproduce reliably, try again without verbose logging but
> do capture all stack traces -- once the system locks up, let it stew
> for ten minutes and attach "blocked for more than X seconds" splats.
>
> Additionally, a "echo w >/proc/sysrq-trigger" dump would be good if
> SysRq is not disabled on your servers.
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
> > Sent: 19 April 2021 14:40:00
> > To: Robin Geuze
> > Cc: Ceph Development
> > Subject: Re: All RBD IO stuck after flapping OSD's
> >
> > On Thu, Apr 15, 2021 at 2:21 PM Robin Geuze <robin.geuze@nl.team.blue> =
wrote:
> > >
> > > Hey Ilya,
> > >
> > > We had to reboot the machine unfortunately, since we had customers un=
able to work with their VM's. We did manage to make a dynamic debugging dum=
p of an earlier occurence, maybe that can help? I've attached it to this em=
ail.
> >
> > No, I don't see anything to go on there.  Next time, enable logging for
> > both libceph and rbd modules and make sure that at least one instance o=
f
> > the error (i.e. "pre object map update failed: -16") makes it into the
> > attached log.
> >
> > >
> > > Those messages constantly occur, even after we kill the VM using the =
mount, I guess because there is pending IO which cannot be flushed.
> > >
> > > As for how its getting worse, if you try any management operations (e=
g unmap) on any of the RBD mounts that aren't affected, they hang and more =
often than not the IO for that one also stalls (not always though).
> >
> > One obvious workaround workaround is to unmap, disable object-map and
> > exclusive-lock features with "rbd feature disable", and map back.  You
> > would lose the benefits of object map, but if it is affecting customer
> > workloads it is probably the best course of action until this thing is
> > root caused.
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
> > > Sent: 14 April 2021 19:00:20
> > > To: Robin Geuze
> > > Cc: Ceph Development
> > > Subject: Re: All RBD IO stuck after flapping OSD's
> > >
> > > On Wed, Apr 14, 2021 at 4:56 PM Robin Geuze <robin.geuze@nl.team.blue=
> wrote:
> > > >
> > > > Hey,
> > > >
> > > > We've encountered a weird issue when using the kernel RBD module. I=
t starts with a bunch of OSD's flapping (in our case because of a network c=
ard issue which caused the LACP to constantly flap), which is logged in dme=
sg:
> > > >
> > > > Apr 14 05:45:02 hv1 kernel: [647677.112461] libceph: osd56 down
> > > > Apr 14 05:45:03 hv1 kernel: [647678.114962] libceph: osd54 down
> > > > Apr 14 05:45:05 hv1 kernel: [647680.127329] libceph: osd50 down
> > > > (...)
> > > >
> > > > After a while of that we start getting these errors being spammed i=
n dmesg:
> > > >
> > > > Apr 14 05:47:35 hv1 kernel: [647830.671263] rbd: rbd14: pre object =
map update failed: -16
> > > > Apr 14 05:47:35 hv1 kernel: [647830.671268] rbd: rbd14: write at ob=
jno 192 2564096~2048 result -16
> > > > Apr 14 05:47:35 hv1 kernel: [647830.671271] rbd: rbd14: write resul=
t -16
> > > >
> > > > (In this case for two different RBD mounts)
> > > >
> > > > At this point the IO for these two mounts is completely gone, and t=
he only reason we can still perform IO on the other RBD devices is because =
we use noshare. Unfortunately unmounting the other devices is no longer pos=
sible, which means we cannot migrate   our  VM's to another HV, since to ma=
ke the messages go away we have to reboot the server.
> > >
> > > Hi Robin,
> > >
> > > Do these messages appear even if no I/O is issued to /dev/rbd14 or on=
ly
> > > if you attempt to write?
> > >
> > > >
> > > > All of this wouldn't be such a big issue if it recovered once the c=
luster started behaving normally again, but it doesn't, it just keeps being=
 stuck, and the longer we wait with rebooting this the worse the issue get.
> > >
> > > Please explain how it's getting worse.
> > >
> > > I think the problem is that the object map isn't locked.  What
> > > probably happened is the kernel client lost its watch on the image
> > > and for some reason can't get it back.   The flapping has likely
> > > trigged some edge condition in the watch/notify code.
> > >
> > > To confirm:
> > >
> > > - paste the contents of /sys/bus/rbd/devices/14/client_addr
> > >
> > > - paste the contents of /sys/kernel/debug/ceph/<cluster id>.client<id=
>/osdc
> > >   for /dev/rbd14.  If you are using noshare, you will have multiple
> > >   client instances with the same cluster id.  The one you need can be
> > >   identified with /sys/bus/rbd/devices/14/client_id.
> > >
> > > - paste the output of "rbd status <rbd14 image>" (image name can be
> > >   identified from "rbd showmapped")
> > >
> > > I'm also curious who actually has the lock on the header object and t=
he
> > > object map object.  Paste the output of
> > >
> > > $ ID=3D$(bin/rbd info --format=3Djson <rbd14 pool>/<rbd14 image> | jq=
 -r .id)
> > > $ rados -p <rbd14 pool> lock info rbd_header.$ID rbd_lock | jq
> > > $ rados -p <rbd14 pool> lock info rbd_object_map.$ID rbd_lock | jq
> > >
> > > Thanks,
> > >
> > >                 Ilya
> > >
> >
>
