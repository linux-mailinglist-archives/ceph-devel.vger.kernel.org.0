Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FEA3BB678
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jul 2021 06:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhGEEmx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Jul 2021 00:42:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45708 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229447AbhGEEmx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Jul 2021 00:42:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625460016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WYBTMFwy5brhQxMw0htpd7rcVz0ukCq/m3j49xLMwxU=;
        b=icrkUgf/paqcsonmMm9nBdBojZFcEvE6VTLBmxekHlYs4AWNrar7IO3EcAk3+f2J3FOtyz
        AMEP+NoA9UGCzXKT99xxk72kJL9zXzVwlTTQ64uBEwHdpmkYz582//+/FsnO0SmHeR+5PO
        odYcBfmYpmQ+f+iLrchpHwk/3cCY74M=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-fvcrAXAoMJq6AFZqG6okBQ-1; Mon, 05 Jul 2021 00:40:15 -0400
X-MC-Unique: fvcrAXAoMJq6AFZqG6okBQ-1
Received: by mail-ed1-f71.google.com with SMTP id y17-20020a0564023591b02903951740fab5so8479896edc.23
        for <ceph-devel@vger.kernel.org>; Sun, 04 Jul 2021 21:40:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WYBTMFwy5brhQxMw0htpd7rcVz0ukCq/m3j49xLMwxU=;
        b=YSKVHYbWLTwbtCIH/zjdN1FZYmZLeLcGqLLDqtyWB91XNk/4pAb6qKWgEk0vmoIr1/
         vMPWQZY+8CMGWr/6/NnDLG3tA8Wecl4zHHDTaqVbJVO8NpP30w8Cw5vnK2Nu0HRmQgp+
         i9HOx6HjCZNBFHHm/0CQgqyEHSutYeUhQZO7DaIix3eGGarDV5aKREbxBzBzaIJsjRrN
         uOVMBcBM8V76OCMF8VAgPPZOVbkhEICmgoekd6CWdS2TfFuUsYMHmE9z+bagRb4sZhcf
         xla24sXj+0gDgSGl8YNHMhBBL+mJcgyunbnb6m1cBlVLPwHJHu6fWkyhwPvNLGd6VdEh
         hfyA==
X-Gm-Message-State: AOAM532yhyYGvjoKlt7bUvISMcYZDycWpyAi37U8qi46Ey9Oq+45Y+Kx
        6bpsLo+SHVM8Uozc2t9kzrd8EntdWCzdL97AydKzdqAQRDtkBK8FvNc0CwuHlFutWe7VgXBJJ0s
        eCq7g+4/ceeRDvUKbCk8mD3u1YyQ3oPy6CIjg/w==
X-Received: by 2002:a17:907:1c0d:: with SMTP id nc13mr2640432ejc.367.1625460014436;
        Sun, 04 Jul 2021 21:40:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPu/zLTqd9Q/5HovITPwCRmLWw53vnyucT1CrcJC55a3Iyu9syJ+RRQqf0XEnlLlBIrhDKG9NG2QUH8vCn144=
X-Received: by 2002:a17:907:1c0d:: with SMTP id nc13mr2640418ejc.367.1625460014279;
 Sun, 04 Jul 2021 21:40:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210702064821.148063-1-vshankar@redhat.com> <20210702064821.148063-5-vshankar@redhat.com>
 <CA+2bHPYBetaxkSBUbz-6aNTpbqMYGhHGcCv_ZTiT3GrNZWyLNg@mail.gmail.com>
In-Reply-To: <CA+2bHPYBetaxkSBUbz-6aNTpbqMYGhHGcCv_ZTiT3GrNZWyLNg@mail.gmail.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Mon, 5 Jul 2021 10:09:38 +0530
Message-ID: <CACPzV1ksLhOhu9AMpom4ytu-KpDZRaquOfu1YUHbsGgsCiw_9g@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] doc: document new CephFS mount device syntax
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Luis Henriques <lhenriques@suse.de>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jul 2, 2021 at 11:38 PM Patrick Donnelly <pdonnell@redhat.com> wrote:
>
> On Thu, Jul 1, 2021 at 11:48 PM Venky Shankar <vshankar@redhat.com> wrote:
> >
> > Signed-off-by: Venky Shankar <vshankar@redhat.com>
> > ---
> >  Documentation/filesystems/ceph.rst | 25 ++++++++++++++++++++++---
> >  1 file changed, 22 insertions(+), 3 deletions(-)
> >
> > diff --git a/Documentation/filesystems/ceph.rst b/Documentation/filesystems/ceph.rst
> > index 7d2ef4e27273..830ea8969d9d 100644
> > --- a/Documentation/filesystems/ceph.rst
> > +++ b/Documentation/filesystems/ceph.rst
> > @@ -82,7 +82,7 @@ Mount Syntax
> >
> >  The basic mount syntax is::
> >
> > - # mount -t ceph monip[:port][,monip2[:port]...]:/[subdir] mnt
> > + # mount -t ceph user@fsid.fs_name=/[subdir] mnt -o mon_addr=monip1[:port][/monip2[:port]]
>
> Somewhat unrelated question to this patchset: can you specify the mons
> in the ceph.conf format? i.e. with v2/v1 syntax?

The problem with that is the delimiter used is comma (",") which
restricts passing it through the mount option.

>
> >  You only need to specify a single monitor, as the client will get the
> >  full list when it connects.  (However, if the monitor you specify
> > @@ -90,16 +90,35 @@ happens to be down, the mount won't succeed.)  The port can be left
> >  off if the monitor is using the default.  So if the monitor is at
> >  1.2.3.4::
> >
> > - # mount -t ceph 1.2.3.4:/ /mnt/ceph
> > + # mount -t ceph cephuser@07fe3187-00d9-42a3-814b-72a4d5e7d5be.cephfs=/ /mnt/ceph -o mon_addr=1.2.3.4
> >
> >  is sufficient.  If /sbin/mount.ceph is installed, a hostname can be
> > -used instead of an IP address.
> > +used instead of an IP address and the cluster FSID can be left out
> > +(as the mount helper will fill it in by reading the ceph configuration
> > +file)::
> >
> > +  # mount -t ceph cephuser@cephfs=/ /mnt/ceph -o mon_addr=mon-addr
> >
> > +Multiple monitor addresses can be passed by separating each address with a slash (`/`)::
> > +
> > +  # mount -t ceph cephuser@cephfs=/ /mnt/ceph -o mon_addr=192.168.1.100/192.168.1.101
> > +
> > +When using the mount helper, monitor address can be read from ceph
> > +configuration file if available. Note that, the cluster FSID (passed as part
> > +of the device string) is validated by checking it with the FSID reported by
> > +the monitor.
> >
> >  Mount Options
> >  =============
> >
> > +  mon_addr=ip_address[:port][/ip_address[:port]]
> > +       Monitor address to the cluster. This is used to bootstrap the
> > +        connection to the cluster. Once connection is established, the
> > +        monitor addresses in the monitor map are followed.
> > +
> > +  fsid=cluster-id
> > +       FSID of the cluster
>
> Let's note it's the output of `ceph fsid`.
>
> >    ip=A.B.C.D[:N]
> >         Specify the IP and/or port the client should bind to locally.
> >         There is normally not much reason to do this.  If the IP is not
> > --
> > 2.27.0
> >
>
>
> --
> Patrick Donnelly, Ph.D.
> He / Him / His
> Principal Software Engineer
> Red Hat Sunnyvale, CA
> GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
>


-- 
Cheers,
Venky

