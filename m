Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F5E3BDD23
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jul 2021 20:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhGFS2c (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jul 2021 14:28:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22973 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229954AbhGFS2c (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jul 2021 14:28:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625595952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z2hpY0ZJRaHVM+rKfM+yxR8ZBPQlwnweiodbLgHCttc=;
        b=ffA3+Wcnm/8LwsavglIxiLyjeWJVDXJB1h0HqIwACFOo7QY1ia5cNSQ5IhizBd9+W6w+5J
        Ruub3cr/zynUahaWnjrSziENeu+TVgIqoR9rytccG8lsy7kE5G+oIZNuInHvq/ljN4qv40
        921s4b6R17JQFT/4MGkEj9xXuHlt8NE=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-MWbwhDjTNdecGKlsxDu-uQ-1; Tue, 06 Jul 2021 14:25:51 -0400
X-MC-Unique: MWbwhDjTNdecGKlsxDu-uQ-1
Received: by mail-qk1-f199.google.com with SMTP id 72-20020a37084b0000b02903b4fb87a336so6779982qki.23
        for <ceph-devel@vger.kernel.org>; Tue, 06 Jul 2021 11:25:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Z2hpY0ZJRaHVM+rKfM+yxR8ZBPQlwnweiodbLgHCttc=;
        b=oaiCFOi+l/46x6o4zKxTg22iYCxbcsbZRiSnnH4JJlObDyq9OPIxiPH0IOe8bC7PMF
         szskOTIBXLs29uESLXORhxztBH+UUaQFWSAvqyivyoj46WUcyivjQa1JCx6tNvCwPzSz
         CjNGCR3jWu1baDrt//BKZQjmW+5u9dMPscqBl/tgJOur4Ed9bYwAQrasmdQx5UdDuTQY
         G4ii6wcG6rN27ejTMahuHwengM2EY+I5xWwk/+Uvf6F8ue4PotcW+p+8XxNifmERTmx/
         oigd48EgTMhLcI1xBtXYgsgvBz8Z0kZTLU+oZZVDDd/IRkKfQD97gZp+b8LPnz02cwbH
         lhQQ==
X-Gm-Message-State: AOAM530DuGB+WIkX8eGEY3XGjM0+9GAajwB9KkMgKmUvSqhOs0jB+WW0
        iKdoZQNzRAw7jjB3iKrW6eSgvxv1fDKcv8LISoATNL8D+lnTqm/r3Jm4tauzFZgV1Np9akxqqRy
        kbxruyllGuh+88IRV9CQGWw==
X-Received: by 2002:a05:620a:e09:: with SMTP id y9mr20911556qkm.359.1625595951242;
        Tue, 06 Jul 2021 11:25:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzgn7HzrjfEItDA3fmZjPL0LL066yBzXg+A6lEvnbIvdDLpUSoZbObYi2o6JV7Z+2bI5EfmqA==
X-Received: by 2002:a05:620a:e09:: with SMTP id y9mr20911538qkm.359.1625595951099;
        Tue, 06 Jul 2021 11:25:51 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id 67sm3523820qtf.83.2021.07.06.11.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 11:25:50 -0700 (PDT)
Message-ID: <a931fecb17ca6947a40249764e6e0b3b319d77cf.camel@redhat.com>
Subject: Re: [PATCH v2 4/4] doc: document new CephFS mount device syntax
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Luis Henriques <lhenriques@suse.de>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Tue, 06 Jul 2021 14:25:49 -0400
In-Reply-To: <CACPzV1ksLhOhu9AMpom4ytu-KpDZRaquOfu1YUHbsGgsCiw_9g@mail.gmail.com>
References: <20210702064821.148063-1-vshankar@redhat.com>
         <20210702064821.148063-5-vshankar@redhat.com>
         <CA+2bHPYBetaxkSBUbz-6aNTpbqMYGhHGcCv_ZTiT3GrNZWyLNg@mail.gmail.com>
         <CACPzV1ksLhOhu9AMpom4ytu-KpDZRaquOfu1YUHbsGgsCiw_9g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-07-05 at 10:09 +0530, Venky Shankar wrote:
> On Fri, Jul 2, 2021 at 11:38 PM Patrick Donnelly <pdonnell@redhat.com> wrote:
> > 
> > On Thu, Jul 1, 2021 at 11:48 PM Venky Shankar <vshankar@redhat.com> wrote:
> > > 
> > > Signed-off-by: Venky Shankar <vshankar@redhat.com>
> > > ---
> > >  Documentation/filesystems/ceph.rst | 25 ++++++++++++++++++++++---
> > >  1 file changed, 22 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/Documentation/filesystems/ceph.rst b/Documentation/filesystems/ceph.rst
> > > index 7d2ef4e27273..830ea8969d9d 100644
> > > --- a/Documentation/filesystems/ceph.rst
> > > +++ b/Documentation/filesystems/ceph.rst
> > > @@ -82,7 +82,7 @@ Mount Syntax
> > > 
> > >  The basic mount syntax is::
> > > 
> > > - # mount -t ceph monip[:port][,monip2[:port]...]:/[subdir] mnt
> > > + # mount -t ceph user@fsid.fs_name=/[subdir] mnt -o mon_addr=monip1[:port][/monip2[:port]]
> > 
> > Somewhat unrelated question to this patchset: can you specify the mons
> > in the ceph.conf format? i.e. with v2/v1 syntax?
> 
> The problem with that is the delimiter used is comma (",") which
> restricts passing it through the mount option.
> > 

Yeah. I don't see an alternative here. You'd have to escape the comma
somehow. You'd also have to build an in-kernel parser for that format.

Doing this would be a project in and of itself, and it doesn't seem
valuable. mount.ceph is mostly what's going to populate this anyway and
for that we don't really care.

> > >  You only need to specify a single monitor, as the client will get the
> > >  full list when it connects.  (However, if the monitor you specify
> > > @@ -90,16 +90,35 @@ happens to be down, the mount won't succeed.)  The port can be left
> > >  off if the monitor is using the default.  So if the monitor is at
> > >  1.2.3.4::
> > > 
> > > - # mount -t ceph 1.2.3.4:/ /mnt/ceph
> > > + # mount -t ceph cephuser@07fe3187-00d9-42a3-814b-72a4d5e7d5be.cephfs=/ /mnt/ceph -o mon_addr=1.2.3.4
> > > 
> > >  is sufficient.  If /sbin/mount.ceph is installed, a hostname can be
> > > -used instead of an IP address.
> > > +used instead of an IP address and the cluster FSID can be left out
> > > +(as the mount helper will fill it in by reading the ceph configuration
> > > +file)::
> > > 
> > > +  # mount -t ceph cephuser@cephfs=/ /mnt/ceph -o mon_addr=mon-addr
> > > 
> > > +Multiple monitor addresses can be passed by separating each address with a slash (`/`)::
> > > +
> > > +  # mount -t ceph cephuser@cephfs=/ /mnt/ceph -o mon_addr=192.168.1.100/192.168.1.101
> > > +
> > > +When using the mount helper, monitor address can be read from ceph
> > > +configuration file if available. Note that, the cluster FSID (passed as part
> > > +of the device string) is validated by checking it with the FSID reported by
> > > +the monitor.
> > > 
> > >  Mount Options
> > >  =============
> > > 
> > > +  mon_addr=ip_address[:port][/ip_address[:port]]
> > > +       Monitor address to the cluster. This is used to bootstrap the
> > > +        connection to the cluster. Once connection is established, the
> > > +        monitor addresses in the monitor map are followed.
> > > +
> > > +  fsid=cluster-id
> > > +       FSID of the cluster
> > 
> > Let's note it's the output of `ceph fsid`.
> > 
> > >    ip=A.B.C.D[:N]
> > >         Specify the IP and/or port the client should bind to locally.
> > >         There is normally not much reason to do this.  If the IP is not
> > > --
> > > 2.27.0
> > > 
> > 
> > 
> > --
> > Patrick Donnelly, Ph.D.
> > He / Him / His
> > Principal Software Engineer
> > Red Hat Sunnyvale, CA
> > GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
> > 
> 
> 

-- 
Jeff Layton <jlayton@redhat.com>

