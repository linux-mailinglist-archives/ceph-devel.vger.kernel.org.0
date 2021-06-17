Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2923AAEE5
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Jun 2021 10:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbhFQIit (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Jun 2021 04:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhFQIit (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Jun 2021 04:38:49 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057A6C061574
        for <ceph-devel@vger.kernel.org>; Thu, 17 Jun 2021 01:36:42 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id i12so4666148ila.13
        for <ceph-devel@vger.kernel.org>; Thu, 17 Jun 2021 01:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jBxmHva0H2fmV14ONEemeoIT24LA9Dynq9IGpe13UVc=;
        b=ScVyppBq9zVd1kn/iopn7FKTGLDc9nleqX56/T0BBWHq/2RqNY5U+mKUY2FtXDGIH7
         Fg/9dEt//2rgKrtdB9T3DbCoJbOKcHRyj+9EblavGnLBCSQTZhvgDbM35pTIkVddkrJc
         Mwl3+B1Xdy4Ghk6MoBdPg8IZRkonKM0Gk+8ykjUVGPKPdUHDpC1IUcCbBQZned2C4wgX
         uJUH3LRZWa76DIjqXU4nOBy/3a4HBxHyJEAhr7Rp3+WrV/CopMyUUmXYXID4uRVly3RF
         JthTJwFN0p+lSRw/BIdeivZnoVJm+GwZUBPhLjmQgrC41k6dLYfLGfY6GMHgzDekemAQ
         kEsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jBxmHva0H2fmV14ONEemeoIT24LA9Dynq9IGpe13UVc=;
        b=QNyVvsIlCaXk3e+u9D22DKmUB+GAs1wR0776CjgiIsWKZlWjpS7cmJAUC3hE9jE4gh
         zB4bkfDoxJl8ho4V4gqK0gK0Ixd4hqEg2uqIhrVyJBOSgiaB6eU0V6U0F8+qj/cKoFAj
         2/WB1gNUSSyZZCMiR4H4lDwnpsK+g3ba0O2DFnPveKMj2ynVs158iOugjVgdzF4ftdlO
         ZUVdBsPl25ucxJGDKuQDQgYh07KV4T8dqUu2fgVQ3LWlGDWe+HZki5JzsWx5N+cTkWWa
         IBlErJcewJUeNWPcKRdmUnhkstM2KV2aozkLjKfhEt0fjEnOWdW1RpzYLudeWkOCA6gl
         H1Kw==
X-Gm-Message-State: AOAM533HkRM1rpng4vw5buTDyM4/z448GbsW2N9rLzNHRb/K+lWEyEEJ
        xDEnos2fusNqx/wtbUXNM2e8Ab+vgaOOpiEE8wthGoowLEjVjQ==
X-Google-Smtp-Source: ABdhPJxzyVOiJPx13GuGC1qCx8oiTzVDAEIcmMZhf4EqG0ueiJPXOaXxqSoWlpZI3gXtCrrBTw19+KtEPzm+1yE2I3c=
X-Received: by 2002:a05:6e02:d51:: with SMTP id h17mr2670005ilj.177.1623919001449;
 Thu, 17 Jun 2021 01:36:41 -0700 (PDT)
MIME-Version: 1.0
References: <47f0a04ce6664116a11cfdb5a458e252@nl.team.blue>
 <CAOi1vP-moRXtL4gKXQF8+NwbPgE11_LoxfSYqYBbJfYYQ7Sv_g@mail.gmail.com>
 <8eb12c996e404870803e9a7c77e508d6@nl.team.blue> <CAOi1vP-8i-rKEDd8Emq+MtxCjvK-6VG8KaXdzvQLW89174jUZA@mail.gmail.com>
 <666938090a8746a7ad8ae40ebf116e1c@nl.team.blue>
In-Reply-To: <666938090a8746a7ad8ae40ebf116e1c@nl.team.blue>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 17 Jun 2021 10:36:33 +0200
Message-ID: <CAOi1vP8NHYEN-=J4A7mB1dSkaHHf8Gtha-xqPLboZUS5u442hA@mail.gmail.com>
Subject: Re: All RBD IO stuck after flapping OSD's
To:     Robin Geuze <robin.geuze@nl.team.blue>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

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
down, wait another 40 seconds and  then put them back up.
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

                Ilya

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
> No, I don't see anything to go on there.  Next time, enable logging for
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
> exclusive-lock features with "rbd feature disable", and map back.  You
> would lose the benefits of object map, but if it is affecting customer
> workloads it is probably the best course of action until this thing is
> root caused.
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
ble, which means we cannot migrate  our  VM's to another HV, since to make =
the messages go away we have to reboot the server.
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
> > I think the problem is that the object map isn't locked.  What
> > probably happened is the kernel client lost its watch on the image
> > and for some reason can't get it back.   The flapping has likely
> > trigged some edge condition in the watch/notify code.
> >
> > To confirm:
> >
> > - paste the contents of /sys/bus/rbd/devices/14/client_addr
> >
> > - paste the contents of /sys/kernel/debug/ceph/<cluster id>.client<id>/=
osdc
> >   for /dev/rbd14.  If you are using noshare, you will have multiple
> >   client instances with the same cluster id.  The one you need can be
> >   identified with /sys/bus/rbd/devices/14/client_id.
> >
> > - paste the output of "rbd status <rbd14 image>" (image name can be
> >   identified from "rbd showmapped")
> >
> > I'm also curious who actually has the lock on the header object and the
> > object map object.  Paste the output of
> >
> > $ ID=3D$(bin/rbd info --format=3Djson <rbd14 pool>/<rbd14 image> | jq -=
r .id)
> > $ rados -p <rbd14 pool> lock info rbd_header.$ID rbd_lock | jq
> > $ rados -p <rbd14 pool> lock info rbd_object_map.$ID rbd_lock | jq
> >
> > Thanks,
> >
> >                 Ilya
> >
>
