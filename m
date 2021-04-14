Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C73435F960
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Apr 2021 19:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345437AbhDNRAm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 14 Apr 2021 13:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbhDNRAm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 14 Apr 2021 13:00:42 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA3FC061574
        for <ceph-devel@vger.kernel.org>; Wed, 14 Apr 2021 10:00:20 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id v13so1688773ilj.8
        for <ceph-devel@vger.kernel.org>; Wed, 14 Apr 2021 10:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=f2gKkNgMyA9YBJyIxJ+fwJLbXg5/FwGSkOwffY5GqAY=;
        b=QNDzchS4zjgUiTd/ZHiiKx1NH/7j8HPOs3RO389Wx0IMOC+GkjqDxQNE/a3afnnFu5
         vqiXfgkJgi9D+XhdU327Tb7HKSPG1RY/NxGxpDS8VTsRhUxV/Y0GIjBWXL6kjkJ6AJf5
         VKYjEzRynXpRJbjEHWid5z2KnNG6xO4Q0GwPh+2boLSfjh7Pweg0bf38x2t9joUwXfnm
         dwzZvXcSlrjgPF81P/kzOyvWguUUgPNTD5ufKIZcN1UZQxwx4+wnszVJ0w2Xzd72OxAj
         tMipSCYEJnHDuweUcWKdObivluMlkyhOdVb81ObgzPvASEwXiu9GS5zbffcau2XtOW4F
         cxZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=f2gKkNgMyA9YBJyIxJ+fwJLbXg5/FwGSkOwffY5GqAY=;
        b=IOUCT1vpV12QfhRTwJoxmNDmgq47uyzt+BnEVw9UL9bMJgZj+rquqpc15USi74uJgM
         dqVMxxdBsZ0o9c9P9e274Ur3zzsR7Z70j2pV0g/aGOP7DdrhziwFkHus4QRobCfBwUxM
         y828ayp/M3JjjK9DTKnJsoxKAVgf2FV1dbxlogLzqhPcT5F4uJLPgIHEhog7GX7neXRO
         430duM1dmkylrahkl6hIm5a0sZh+4Z18j2Z184wYnWGm2zHkKqJE9GjVREt0DZHqQ6fi
         eGxrPgxGDOoUF0b9OYwbkKz5x4z8504QuyHlMX2E9uUxHhFfEsqqvHCVIfu40Gti+Rfa
         vyZw==
X-Gm-Message-State: AOAM530OxUb4MiRfXS1zjSrtZ85IoriRn7ebpteln6Yz3xAKghvuzPFO
        3nmeEUu+X5lpQj2HXZJlhcgNGNvBILHRyryRr0Ie2rj//dg2Vw==
X-Google-Smtp-Source: ABdhPJx4M9rHN0coZZ/9YMH94dRUzNKrV04FKLR+ke+55kGg6dboP73n2YyJ4ZrUgvjE7fEBjMAbX4xpmEDfh/XMntI=
X-Received: by 2002:a05:6e02:c74:: with SMTP id f20mr32627926ilj.281.1618419619978;
 Wed, 14 Apr 2021 10:00:19 -0700 (PDT)
MIME-Version: 1.0
References: <47f0a04ce6664116a11cfdb5a458e252@nl.team.blue>
In-Reply-To: <47f0a04ce6664116a11cfdb5a458e252@nl.team.blue>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 14 Apr 2021 19:00:20 +0200
Message-ID: <CAOi1vP-moRXtL4gKXQF8+NwbPgE11_LoxfSYqYBbJfYYQ7Sv_g@mail.gmail.com>
Subject: Re: All RBD IO stuck after flapping OSD's
To:     Robin Geuze <robin.geuze@nl.team.blue>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Apr 14, 2021 at 4:56 PM Robin Geuze <robin.geuze@nl.team.blue> wrot=
e:
>
> Hey,
>
> We've encountered a weird issue when using the kernel RBD module. It star=
ts with a bunch of OSD's flapping (in our case because of a network card is=
sue which caused the LACP to constantly flap), which is logged in dmesg:
>
> Apr 14 05:45:02 hv1 kernel: [647677.112461] libceph: osd56 down
> Apr 14 05:45:03 hv1 kernel: [647678.114962] libceph: osd54 down
> Apr 14 05:45:05 hv1 kernel: [647680.127329] libceph: osd50 down
> (...)
>
> After a while of that we start getting these errors being spammed in dmes=
g:
>
> Apr 14 05:47:35 hv1 kernel: [647830.671263] rbd: rbd14: pre object map up=
date failed: -16
> Apr 14 05:47:35 hv1 kernel: [647830.671268] rbd: rbd14: write at objno 19=
2 2564096~2048 result -16
> Apr 14 05:47:35 hv1 kernel: [647830.671271] rbd: rbd14: write result -16
>
> (In this case for two different RBD mounts)
>
> At this point the IO for these two mounts is completely gone, and the onl=
y reason we can still perform IO on the other RBD devices is because we use=
 noshare. Unfortunately unmounting the other devices is no longer possible,=
 which means we cannot migrate our VM's to another HV, since to make the me=
ssages go away we have to reboot the server.

Hi Robin,

Do these messages appear even if no I/O is issued to /dev/rbd14 or only
if you attempt to write?

>
> All of this wouldn't be such a big issue if it recovered once the cluster=
 started behaving normally again, but it doesn't, it just keeps being stuck=
, and the longer we wait with rebooting this the worse the issue get.

Please explain how it's getting worse.

I think the problem is that the object map isn't locked.  What
probably happened is the kernel client lost its watch on the image
and for some reason can't get it back.   The flapping has likely
trigged some edge condition in the watch/notify code.

To confirm:

- paste the contents of /sys/bus/rbd/devices/14/client_addr

- paste the contents of /sys/kernel/debug/ceph/<cluster id>.client<id>/osdc
  for /dev/rbd14.  If you are using noshare, you will have multiple
  client instances with the same cluster id.  The one you need can be
  identified with /sys/bus/rbd/devices/14/client_id.

- paste the output of "rbd status <rbd14 image>" (image name can be
  identified from "rbd showmapped")

I'm also curious who actually has the lock on the header object and the
object map object.  Paste the output of

$ ID=3D$(bin/rbd info --format=3Djson <rbd14 pool>/<rbd14 image> | jq -r .i=
d)
$ rados -p <rbd14 pool> lock info rbd_header.$ID rbd_lock | jq
$ rados -p <rbd14 pool> lock info rbd_object_map.$ID rbd_lock | jq

Thanks,

                Ilya
