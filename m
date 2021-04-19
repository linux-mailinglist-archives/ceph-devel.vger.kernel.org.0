Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019E93641D9
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Apr 2021 14:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239238AbhDSMk3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Apr 2021 08:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239141AbhDSMk2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 19 Apr 2021 08:40:28 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CB3C06174A
        for <ceph-devel@vger.kernel.org>; Mon, 19 Apr 2021 05:39:58 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id b17so28944679ilh.6
        for <ceph-devel@vger.kernel.org>; Mon, 19 Apr 2021 05:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=a+ILLiHTZPesJnUgACxh9t7V/s2DlPkGGoVAOuaIQAU=;
        b=p1EAE+HCEz5TKsRwearVnjDPS2j3oLjpKIw2LNWZoczNsBG9fYkEnhHr0dCEk72gOU
         tFnmPvuXTFZDFplTOzxuq57WpIieXdUOQL3o6E2toqYWux6KGDEtSl2qCL/4wEwHhqSF
         ZohFpQScIzYOACsG6WCJM0usjq1RN7KNAKHaFV3VtWLxo1lEDACKIL3oP8Az4avEY4xy
         yzQOLEDXMZU9eE0YIs6TQTiq/H8BQuIct/8KPyI6CjB3ETLEttLpzbMwYL+7wzQxGvRx
         FK3h6dZ7AircOWiUE8hb0P4Wob05KmLALubjgW7ji/jjKFVx54dfVO2zeR3A4wT1paV9
         KAWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=a+ILLiHTZPesJnUgACxh9t7V/s2DlPkGGoVAOuaIQAU=;
        b=ojr5Ggm/Ux/OvZRhq4t2ldAruur65mTM8SCsCmuEyiE8Ci45bPCd1dmaYqPJ9o64yB
         KcsuhUwEfH5anox+zBv1PsAno9iZ3JUESSwdd/jVQUxVRe8NImX4NaVR0Bzp2xncZmAB
         kwIjW1bFyGy9ssMtA3aHC7cejEkmcCLMqz76cRrjHpgHIpf40bqe+6aw/KTFnUjUYczQ
         GNVsXea35DF74/qUYZvWtlcpJC0fWqrluNieTtIVWB6+l1usIhY8Ow/ELZ2hXutdLOS8
         Y2JxiUzGrmDE1aJdkAlO6uA4y/eDxu+Xcs4WUdcp/u6SSRvefwMj8IABziwZ8/UlgGQt
         6loA==
X-Gm-Message-State: AOAM5332v/smeeZXX24ZdoE+N3W8nm7XVOY3ruOV/Id/cqiZ15Qhjxvp
        viyh6/5EVrGbBsYlSoVxaa8oDJRoYFnjWgSWqo7IR+QBhwSGdA==
X-Google-Smtp-Source: ABdhPJy/aRGdwjR0fcJuGO0lAMmBKn7qH/XwVahdr1JS/TLo0rsVZ+41fBpWtOdxELdBQydv935IhsBqmd3tQBM3xrA=
X-Received: by 2002:a92:da8a:: with SMTP id u10mr18017422iln.100.1618835997584;
 Mon, 19 Apr 2021 05:39:57 -0700 (PDT)
MIME-Version: 1.0
References: <47f0a04ce6664116a11cfdb5a458e252@nl.team.blue>
 <CAOi1vP-moRXtL4gKXQF8+NwbPgE11_LoxfSYqYBbJfYYQ7Sv_g@mail.gmail.com> <8eb12c996e404870803e9a7c77e508d6@nl.team.blue>
In-Reply-To: <8eb12c996e404870803e9a7c77e508d6@nl.team.blue>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 19 Apr 2021 14:40:00 +0200
Message-ID: <CAOi1vP-8i-rKEDd8Emq+MtxCjvK-6VG8KaXdzvQLW89174jUZA@mail.gmail.com>
Subject: Re: All RBD IO stuck after flapping OSD's
To:     Robin Geuze <robin.geuze@nl.team.blue>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Apr 15, 2021 at 2:21 PM Robin Geuze <robin.geuze@nl.team.blue> wrot=
e:
>
> Hey Ilya,
>
> We had to reboot the machine unfortunately, since we had customers unable=
 to work with their VM's. We did manage to make a dynamic debugging dump of=
 an earlier occurence, maybe that can help? I've attached it to this email.

No, I don't see anything to go on there.  Next time, enable logging for
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
exclusive-lock features with "rbd feature disable", and map back.  You
would lose the benefits of object map, but if it is affecting customer
workloads it is probably the best course of action until this thing is
root caused.

Thanks,

                Ilya

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
e, which means we cannot migrate our  VM's to another HV, since to make the=
 messages go away we have to reboot the server.
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
> I think the problem is that the object map isn't locked.  What
> probably happened is the kernel client lost its watch on the image
> and for some reason can't get it back.   The flapping has likely
> trigged some edge condition in the watch/notify code.
>
> To confirm:
>
> - paste the contents of /sys/bus/rbd/devices/14/client_addr
>
> - paste the contents of /sys/kernel/debug/ceph/<cluster id>.client<id>/os=
dc
>   for /dev/rbd14.  If you are using noshare, you will have multiple
>   client instances with the same cluster id.  The one you need can be
>   identified with /sys/bus/rbd/devices/14/client_id.
>
> - paste the output of "rbd status <rbd14 image>" (image name can be
>   identified from "rbd showmapped")
>
> I'm also curious who actually has the lock on the header object and the
> object map object.  Paste the output of
>
> $ ID=3D$(bin/rbd info --format=3Djson <rbd14 pool>/<rbd14 image> | jq -r =
.id)
> $ rados -p <rbd14 pool> lock info rbd_header.$ID rbd_lock | jq
> $ rados -p <rbd14 pool> lock info rbd_object_map.$ID rbd_lock | jq
>
> Thanks,
>
>                 Ilya
>
