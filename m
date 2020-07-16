Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A760222C84
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Jul 2020 22:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbgGPUMD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Jul 2020 16:12:03 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30566 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728907AbgGPUMD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 16:12:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594930321;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r7AAC5oWeR5WzjGWea/TPx0iC5Sl0To7nylLVV9/lj4=;
        b=XMdhoAHpsXRRPcEMSSDLfrK08+SQKxj1ibqcBP8NGte4nFEnhMeZBl6Jpz3FGcLWXR5N4O
        Hhy/poSSQXhvR4VJVk5Kx7uCfCuuqEfjn6cLEBDvrfNe2e/9lg0rNn6Uf+JAdA5wKKXgOn
        C3Depm7Z8I/8NthD0zG8yRwWbZS1Knc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-lCotb0y1M7iXWJjUL4dhvQ-1; Thu, 16 Jul 2020 16:11:59 -0400
X-MC-Unique: lCotb0y1M7iXWJjUL4dhvQ-1
Received: by mail-wm1-f72.google.com with SMTP id z74so5347471wmc.4
        for <ceph-devel@vger.kernel.org>; Thu, 16 Jul 2020 13:11:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=r7AAC5oWeR5WzjGWea/TPx0iC5Sl0To7nylLVV9/lj4=;
        b=NLITGP5yUJAHyZFDD20RuqiceOsufRXhUC9VkETK+wyWJVD7eLayeb13gyK1qDYXD7
         +GC9QLrRbmBRna0p0IN+Af3kPvSOfjEsBBJohoDWo0fAT5cjJqz6RN5lvDiclz5HxXtn
         ZtGImEFZw+tUevi7nAo6bgvTc5Gq/DI2eUTq0Gq/jYh2eZoZch5d6EMRn4ffwRO0Pasl
         f231aHiGPOXDZk/5yIbYdSUWgoW90kHZBXw+LQVzmTyhwXc6CgTXpsYOioUyeadWgnHE
         XRNwlAYvzddchtS8UHeO73z2TY6pH5ZGwp8ubHWlPYRW1cgT3iyElGdRmjSWXHQ5rnu1
         v/Lw==
X-Gm-Message-State: AOAM533HnFNBB/M0M4sTbtOnmH4JBmyNayfgzqi5fqaXoq13esgES4Yd
        ZjqB3irrp8mE4vleRJrzZLcW9YBxClYANyNGTL1KWBJKVTAFziijKu9VJVoausi7YZKROxEJBIQ
        JsjXuA1hZSntMLa/V+WkOt1sPZCYA1K1PjOc4xA==
X-Received: by 2002:adf:f18c:: with SMTP id h12mr6278673wro.375.1594930318300;
        Thu, 16 Jul 2020 13:11:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvI25wBjnqu/z8ENHozbiJJjj/ihTE0NXNnGIXUzAXAkGqIL/Y+dyGYa2aW6agUWVh8So/+4ucNQVx7cmY4II=
X-Received: by 2002:adf:f18c:: with SMTP id h12mr6278654wro.375.1594930317970;
 Thu, 16 Jul 2020 13:11:57 -0700 (PDT)
MIME-Version: 1.0
References: <CA+xD70OJhkhH=+5W7M8NM54VPh42FmbD3O0yqKe1p-+=yd9zXQ@mail.gmail.com>
 <CAOi1vP-hmzEkkUWGOwxksQn8ny1HzgNURtnf1D33KQq4-49xgQ@mail.gmail.com>
 <CA+xD70Neac2hpzu-Tg7s+1NCDegwzKs-zdTk8DYTWZPjNaexaA@mail.gmail.com>
 <CAOi1vP9yz7hLuSRWnDtj3wdKZD1qTiF+84_o5F91bw3wZam=0g@mail.gmail.com> <CA+xD70MyfKgn5m3=JvgFfg+Ww=T8eJ2b9bogdbS4ogYAifNCTw@mail.gmail.com>
In-Reply-To: <CA+xD70MyfKgn5m3=JvgFfg+Ww=T8eJ2b9bogdbS4ogYAifNCTw@mail.gmail.com>
Reply-To: dillaman@redhat.com
From:   Jason Dillaman <jdillama@redhat.com>
Date:   Thu, 16 Jul 2020 16:11:45 -0400
Message-ID: <CA+aFP1Am-dQCrd-itiZo5CKEJK44PQzgZR2YuEKkLqU5v_XW=w@mail.gmail.com>
Subject: Re: multiple BLK-MQ queues for Ceph's RADOS Block Device (RBD) and CephFS
To:     Bobby <italienisch1987@gmail.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>, dev <dev@ceph.io>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jul 16, 2020 at 3:19 PM Bobby <italienisch1987@gmail.com> wrote:
>
> Hi,
>
> I completely agree to what you said regarding Ceph client. This is exactl=
y my understanding of a Ceph client.
>
> And regarding blk-mq, I meant for a block device. A multi-queue implement=
ation of a block device.

krbd is a blk-mq implementation of a block device. So is the nbd block
device driver -- which can be combined w/ rbd-nbd (or any other NBD
server) to utilize librbd in user-space.

> On Wednesday, July 15, 2020, Ilya Dryomov <idryomov@gmail.com> wrote:
> > On Wed, Jul 15, 2020 at 12:47 AM Bobby <italienisch1987@gmail.com> wrot=
e:
> >>
> >>
> >>
> >> Hi Ilya,
> >>
> >> Thanks for the reply. It's basically both i.e. I have a specific proje=
ct currently and also I am looking to make ceph-fuse faster.
> >>
> >> But for now, let me ask specifically the project based question. In th=
e project I have to write a blk-mq kernel driver for the Ceph client machin=
e. The Ceph client machine will transfer the data to HBA or lets say any em=
bedded device.
> >
> > What is a "Ceph client machine"?
> >
> > A Ceph client (or more specifically a RADOS client) speaks RADOS
> > protocol and transfers data to OSD daemons.  It can't transfer data
> > directly to a physical device because something has to take care of
> > replication, ensure consistency and self healing, etc.  This is the
> > job of the OSD.
> >
> >>
> >> My hope is that there can be an alternative and that alternative is to=
 not implement a blk-mq kernel driver and instead do the stuff in userspace=
. I am trying to avoid writing a blk-mq kernel driver and yet achieve the m=
ulti-queue implementation through userspace. Is it possible?
> >>
> >> Also AFAIK, the Ceph=E2=80=99s block storage implementation uses a cli=
ent module and this client module has two implementations librbd (user-spac=
e) and krbd (kernel module). I have not gone deep into these client modules=
. but can librbd help me with this?
> >
> > I guess I don't understand the goal of your project.  A multi-queue
> > implementation of what exactly?  A Ceph block device, a Ceph filesystem
> > or something else entirely?  It would help if you were more specific
> > because "a multi-queue driver for Ceph" is really vague.
> >
> > Thanks,
> >
> >                 Ilya
> > _______________________________________________
> Dev mailing list -- dev@ceph.io
> To unsubscribe send an email to dev-leave@ceph.io



--=20
Jason

