Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246473B6E34
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 08:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbhF2GVn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 02:21:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22865 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231952AbhF2GVl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 02:21:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624947553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XD9rJbVAKIxlsVO/vLFa62WOb0NXcpJLn/62E20krKc=;
        b=MLhxPYOPF4U7WX0DrqLIpICrVSBoWiwrV0gJGrpyp9s8IiFZT3+a7OEicA+5SpGbbc18ST
        GOjCphY8PjlfzwOsHOqU2u+LqQN+xdaTFw+nGX/xnkpK5b20ONf5IaqVuzK96bJmK7Bh51
        BsEhuNf+fQf6z3aGe9I+9O8K0dHny94=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-IfnUhZ36NCqBeljTJO-ZIQ-1; Tue, 29 Jun 2021 02:19:10 -0400
X-MC-Unique: IfnUhZ36NCqBeljTJO-ZIQ-1
Received: by mail-ej1-f69.google.com with SMTP id j26-20020a170906411ab02904774cb499f8so5265660ejk.6
        for <ceph-devel@vger.kernel.org>; Mon, 28 Jun 2021 23:19:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XD9rJbVAKIxlsVO/vLFa62WOb0NXcpJLn/62E20krKc=;
        b=pDSwLs2+9PBq1MPAsMDUg4fu3+zLvJZD/Egom5/BdyRtR4HHWYsSrUAPhbteHBzZYb
         CVVvp6A/qJbL64Yg2MHnfQBLtN5waf1eswWECkKhHTl77kQGaacNa543Aprs2TipnfIP
         YjF6hRbzYBENAXEzCQ75NpjJLJWyxLJ0vfbrGA2QpEiBP/psdtQFN8dssi5bcI+0CM+X
         nLXB2nHrEW/gYOoli7xneaGpdw54enUUtF3+DpYhexcEtTUj40Ss/igL8VHZUk/VPD5W
         oTmLp09vR5Rupbfcll+aqD9hdaVYxctkAA42STIV6iZ3PsGCTyUnYqwPTLq3sEQB2SUg
         +/3g==
X-Gm-Message-State: AOAM530sJMlXzMh/N2o4N4LrkjZCtyTANv8/iu4G30R9lCoXJ+OwxmeL
        ZtyMwSKwtwly6nc9K3xroffl0GKRo39WezAR5zqpoCZ2vvztSkQgRWY+4+metjRu0Z/Tjjgs7lb
        DvTKdVxm1Nn1EE/3Pd7/IEVM0dOxTZyx8Qebx1A==
X-Received: by 2002:a17:906:3489:: with SMTP id g9mr27551359ejb.282.1624947549302;
        Mon, 28 Jun 2021 23:19:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyHg8OITqTpDf3JRJ7pY1pnZYhEQw0NPztKdLfbCs7/dVaGyLeyOm4vzTJhB91Lt1fEC1lJQtFcm79LrYBUzrA=
X-Received: by 2002:a17:906:3489:: with SMTP id g9mr27551345ejb.282.1624947549152;
 Mon, 28 Jun 2021 23:19:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210628075545.702106-1-vshankar@redhat.com> <20210628075545.702106-5-vshankar@redhat.com>
 <efacd6bfc864c5a29291e8ab24f82e0a6bd9022e.camel@redhat.com>
In-Reply-To: <efacd6bfc864c5a29291e8ab24f82e0a6bd9022e.camel@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Tue, 29 Jun 2021 11:48:33 +0530
Message-ID: <CACPzV1==tkzJYfE1GjRrBzp5Tcoo_Trx3PRuXvhcJqJFFtrADw@mail.gmail.com>
Subject: Re: [PATCH 4/4] doc: document new CephFS mount device syntax
To:     Jeff Layton <jlayton@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 28, 2021 at 8:57 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Mon, 2021-06-28 at 13:25 +0530, Venky Shankar wrote:
> > Signed-off-by: Venky Shankar <vshankar@redhat.com>
> > ---
> >  Documentation/filesystems/ceph.rst | 23 ++++++++++++++++++++---
> >  1 file changed, 20 insertions(+), 3 deletions(-)
> >
> > diff --git a/Documentation/filesystems/ceph.rst b/Documentation/filesystems/ceph.rst
> > index 7d2ef4e27273..e46f9091b851 100644
> > --- a/Documentation/filesystems/ceph.rst
> > +++ b/Documentation/filesystems/ceph.rst
> > @@ -82,7 +82,7 @@ Mount Syntax
> >
> >  The basic mount syntax is::
> >
> > - # mount -t ceph monip[:port][,monip2[:port]...]:/[subdir] mnt
> > + # mount -t ceph user@fsid.fs_name=/[subdir] mnt -o mon_host=monip1[:port][/monip2[:port]]
> >
>
> The actual code lists the option as "mon_addr".

Good catch. The mount helper uses `mon_host`, however, the option
passed to the kernel is `mon_addr`.

>
> >  You only need to specify a single monitor, as the client will get the
> >  full list when it connects.  (However, if the monitor you specify
> > @@ -90,16 +90,33 @@ happens to be down, the mount won't succeed.)  The port can be left
> >  off if the monitor is using the default.  So if the monitor is at
> >  1.2.3.4::
> >
> > - # mount -t ceph 1.2.3.4:/ /mnt/ceph
> > + # mount -t ceph cephuser@07fe3187-00d9-42a3-814b-72a4d5e7d5be.cephfs=/ /mnt/ceph -o mon_host=1.2.3.4
> >
> >  is sufficient.  If /sbin/mount.ceph is installed, a hostname can be
> > -used instead of an IP address.
> > +used instead of an IP address and the cluster FSID can be left out
> > +(as the mount helper will fill it in by reading the ceph configuration
> > +file)::
> >
> > +  # mount -t ceph cephuser@cephfs=/ /mnt/ceph -o mon_host=mon-addr
> >
> > +Multiple monitor addresses can be passed by separating each address with a slash (`/`)::
> > +
> > +  # mount -t ceph cephuser@cephfs=/ /mnt/ceph -o mon_host=192.168.1.100/192.168.1.101
> > +
> > +When using the mount helper, monitor address can be read from ceph
> > +configuration file if available. Note that, the cluster FSID (passed as part
> > +of the device string) is validated by checking it with the FSID reported by
> > +the monitor.
> >
> >  Mount Options
> >  =============
> >
> > +  mon_host=ip_address[:port][/ip_address[:port]]
> > +     Monitor address to the cluster
> > +
>
> Might want to mention that "mon_addr" is just used to bootstrap the
> connection to the cluster, and that it'll follow the monmap after that
> point.

ACK

>
> > +  fsid=cluster-id
> > +     FSID of the cluster
> > +
> >    ip=A.B.C.D[:N]
> >       Specify the IP and/or port the client should bind to locally.
> >       There is normally not much reason to do this.  If the IP is not
>
> --
> Jeff Layton <jlayton@redhat.com>
>


-- 
Cheers,
Venky

