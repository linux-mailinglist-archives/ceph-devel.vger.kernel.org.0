Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B61434B6A
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Oct 2021 14:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhJTMpc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Oct 2021 08:45:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229998AbhJTMpb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 20 Oct 2021 08:45:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634733796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y0ulkHNIR7vag7X26uxZcyXRxCc5LujZpoJBl1Ni7OA=;
        b=WpzgRp+K+g4YjBHIF1KG3u81Xi8Em09vo3hAnRSYzAaMTnOqnNXpiZltc75IdKaYrPYFdy
        zfxk8Xkki6J3rgxdIUu4WLVAQLzC7jBojwQP5dAi9lq5k5ZYv30p8WgzbT58QxO/ak69jH
        b+oYCgKgnFQ2AmMThTo9HvXNpHOpViA=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-wzjfZdvjO3SUUnlxYyMx7Q-1; Wed, 20 Oct 2021 08:43:15 -0400
X-MC-Unique: wzjfZdvjO3SUUnlxYyMx7Q-1
Received: by mail-qt1-f200.google.com with SMTP id o22-20020ac85a56000000b002a7c1634c55so1953860qta.21
        for <ceph-devel@vger.kernel.org>; Wed, 20 Oct 2021 05:43:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=y0ulkHNIR7vag7X26uxZcyXRxCc5LujZpoJBl1Ni7OA=;
        b=akl5JoXtZbg3Ey479AohDG4ISCosrND+GuBR/A6aSX2Ay9+0Xsq7ezvHE8GyzJD2hy
         qmHk0paV2KitpNhGq8jruIF10zMmh8moeOU9ovf7cFSN4M0ZaN3uldN74xijZBu8tZUf
         nk2u1wOrOUKVEyX/qIQNfm5/+b9MPize/hKVcKtejN/hXTHvJo5trVyPBaLocatME2Z8
         OfnPGHKt4hnoWTQC4Xal8brnakUJpEpV8P46F0qBIfXr/I2DE4jlMPlrP2JiG+1xM0PT
         +ocDHprMqTjM26VgDNJcEMSUglJlr0SShOlP2jmEeDcNH8gFHWjQYos+KpSN+IqLM4HO
         tbSA==
X-Gm-Message-State: AOAM5339/jh5f+BXv/9He4WccYqfhLngVS6+xSGK0GNQkKOMIQpL8xQO
        I0SiqSFYOXnBQ8VJWLHh6tbQGo2ZVpAhGV2GItmhuKt1gSkcqKHHYvrhlc/dAZ4uhVqbKOz2lgQ
        q0+m2zPxps6MOJrv5MWJjXA==
X-Received: by 2002:ac8:1ca:: with SMTP id b10mr6363916qtg.327.1634733795112;
        Wed, 20 Oct 2021 05:43:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZIuJmK7K0U4qgGY2ECcORMOfUdzGsUcPkUR6L/jnLn6fmr/UZUGYypYZ5q3BxGu5vfSJrCg==
X-Received: by 2002:ac8:1ca:: with SMTP id b10mr6363894qtg.327.1634733794850;
        Wed, 20 Oct 2021 05:43:14 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id p11sm956825qtw.60.2021.10.20.05.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 05:43:14 -0700 (PDT)
Message-ID: <cad196d13a58dea238a53df9d979e0c8177b5d0c.camel@redhat.com>
Subject: Re: [PATCH v4 0/2] ceph: add debugfs entries signifying new mount
 syntax support
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Wed, 20 Oct 2021 08:43:13 -0400
In-Reply-To: <CACPzV1ng=JLW1qnPvRcXB1See6Ek6DGtic8o+Ewr2=19uJd2aw@mail.gmail.com>
References: <20211001050037.497199-1-vshankar@redhat.com>
         <CAOi1vP_ePRvs4fPRxXq2onbcxvCarXvE6O6vzc3de2W2=jV57Q@mail.gmail.com>
         <CACPzV1ng=JLW1qnPvRcXB1See6Ek6DGtic8o+Ewr2=19uJd2aw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-10-20 at 18:04 +0530, Venky Shankar wrote:
> On Tue, Oct 19, 2021 at 2:02 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> > 
> > On Fri, Oct 1, 2021 at 7:05 AM Venky Shankar <vshankar@redhat.com> wrote:
> > > 
> > > v4:
> > >   - use mount_syntax_v1,.. as file names
> > > 
> > > [This is based on top of new mount syntax series]
> > > 
> > > Patrick proposed the idea of having debugfs entries to signify if
> > > kernel supports the new (v2) mount syntax. The primary use of this
> > > information is to catch any bugs in the new syntax implementation.
> > > 
> > > This would be done as follows::
> > > 
> > > The userspace mount helper tries to mount using the new mount syntax
> > > and fallsback to using old syntax if the mount using new syntax fails.
> > > However, a bug in the new mount syntax implementation can silently
> > > result in the mount helper switching to old syntax.
> > > 
> > > So, the debugfs entries can be relied upon by the mount helper to
> > > check if the kernel supports the new mount syntax. Cases when the
> > > mount using the new syntax fails, but the kernel does support the
> > > new mount syntax, the mount helper could probably log before switching
> > > to the old syntax (or fail the mount altogether when run in test mode).
> > > 
> > > Debugfs entries are as follows::
> > > 
> > >     /sys/kernel/debug/ceph/
> > >     ....
> > >     ....
> > >     /sys/kernel/debug/ceph/meta
> > >     /sys/kernel/debug/ceph/meta/client_features
> > >     /sys/kernel/debug/ceph/meta/client_features/mount_syntax_v2
> > >     /sys/kernel/debug/ceph/meta/client_features/mount_syntax_v1
> > >     ....
> > >     ....
> > 
> > Hi Venky, Jeff,
> > 
> > If this is supposed to be used in the wild and not just in teuthology,
> > I would be wary of going with debugfs.  debugfs isn't always available
> > (it is actually compiled out in some configurations, it may or may not
> > be mounted, etc).  With the new mount syntax feature it is not a big
> > deal because the mount helper should do just fine without it but with
> > other features we may find ourselves in a situation where the mount
> > helper (or something else) just *has* to know whether the feature is
> > supported or not and falling back to "no" if debugfs is not available
> > is undesirable or too much work.
> > 
> > I don't have a great suggestion though.  When I needed to do this in
> > the past for RADOS feature bits, I went with a read-only kernel module
> > parameter [1].  They are exported via sysfs which is guaranteed to be
> > available.  Perhaps we should do the same for mount_syntax -- have it
> > be either 1 or 2, allowing it to be revved in the future?
> 
> I'm ok with exporting via sysfs (since it's guaranteed). My only ask
> here would be to have the mount support information present itself as
> files rather than file contents to avoid writing parsing stuff in
> userspace, which is ok, however, relying on stat() is nicer.
> 

You should be able to do that by just making a read-only parameter
called "mount_syntax_v2", and then you can test for it by doing
something like:

    # stat /sys/module/ceph/parameters/mount_syntax_v2

The contents of the file can be blank (or just return Y or something).

> > 
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d6a3408a77807037872892c2a2034180fcc08d12
> > 
> > Thanks,
> > 
> >                 Ilya
> > 
> 
> 

-- 
Jeff Layton <jlayton@redhat.com>

