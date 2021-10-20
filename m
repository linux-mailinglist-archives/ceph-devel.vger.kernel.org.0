Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4F5434B93
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Oct 2021 14:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhJTMxS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Oct 2021 08:53:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40036 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229702AbhJTMxR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 20 Oct 2021 08:53:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634734262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dlyrpO8r7aq0Nx/3hTRbTkSbRnKpEzHyrXnD+L2iHfg=;
        b=WKrQQm814OPJswIKxvN0e2+BJVpscRvK1GIlaK+jReDOQNwoGI63sghzfrVIeT7cwUT3lx
        dwOmF9YeoGFRfBLKuif8/X9dFCgBWs0/b8Zqd5QDfIu7rdy6kZKY/ZF1e6vO7ZK6CgdPQd
        VC5sQCiJw8gMlqXehtcwp69FyxX683M=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-MNif07IiPwGBdfuz1QsCvw-1; Wed, 20 Oct 2021 08:51:01 -0400
X-MC-Unique: MNif07IiPwGBdfuz1QsCvw-1
Received: by mail-ed1-f71.google.com with SMTP id v9-20020a50d849000000b003dcb31eabaaso3194442edj.13
        for <ceph-devel@vger.kernel.org>; Wed, 20 Oct 2021 05:51:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dlyrpO8r7aq0Nx/3hTRbTkSbRnKpEzHyrXnD+L2iHfg=;
        b=veXxu4jvyHJyVwACnpXNsje5FOf8tQlIDqMnFagWDvihNSX7pPYIFA68bIe0zjmEIB
         f3XgZiMX+SKDmGkhjxujnRiVuRHGrW0QgNb1sUAd0AMrPHBU5HmJOWxwjok/npS5pu8B
         Rf7VTPKKC4g9gFPYfXN3QYii4QEZK66VAZNI4BfzLePu/nMhtMRECafyn68zC9e1W7jC
         1O1i2UqHucvT1YjFoyeI6vkU08hycKrXDRA5u8jkoHX5BkCOvc6Lm5yzDMS8fkbFbXra
         qj2kaG6JqNte9Z95VnBo40CofiOzw/XQQpFDiI3OS7HEYQUzKZ63srEZqrZunNFkbjwY
         wBJw==
X-Gm-Message-State: AOAM531DC2oD5SNNfn/dQjGw7/NNITExm72pxzE85CZbwMMrbBAjQC6J
        KZUoN1BPSCXN6ARcL+3WZubysP3BYtqnu/mcL9yJjuTvQtx1947q634lBXkZjlDtaNKbLSLzFSN
        ySkHbI0rPzAShGDOvHWlSyURyzVOP3bjIYZRzpA==
X-Received: by 2002:a05:6402:5112:: with SMTP id m18mr61375814edd.101.1634734260063;
        Wed, 20 Oct 2021 05:51:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRbSa5I8RD7ADYC1d52YbGJCDyvm6mHFv0+RV6zIGpJLMpBbO0oJYpzdjVBZaqlfwQFwvKwENnWwqieTmOtXk=
X-Received: by 2002:a05:6402:5112:: with SMTP id m18mr61375790edd.101.1634734259826;
 Wed, 20 Oct 2021 05:50:59 -0700 (PDT)
MIME-Version: 1.0
References: <20211001050037.497199-1-vshankar@redhat.com> <CAOi1vP_ePRvs4fPRxXq2onbcxvCarXvE6O6vzc3de2W2=jV57Q@mail.gmail.com>
 <CACPzV1ng=JLW1qnPvRcXB1See6Ek6DGtic8o+Ewr2=19uJd2aw@mail.gmail.com> <cad196d13a58dea238a53df9d979e0c8177b5d0c.camel@redhat.com>
In-Reply-To: <cad196d13a58dea238a53df9d979e0c8177b5d0c.camel@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Wed, 20 Oct 2021 18:20:23 +0530
Message-ID: <CACPzV1kqaZUBhTBqzD9F5Kx9RC+X8K=07oYJu6Hz6kgXLDFSfw@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] ceph: add debugfs entries signifying new mount
 syntax support
To:     Jeff Layton <jlayton@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Oct 20, 2021 at 6:13 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Wed, 2021-10-20 at 18:04 +0530, Venky Shankar wrote:
> > On Tue, Oct 19, 2021 at 2:02 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> > >
> > > On Fri, Oct 1, 2021 at 7:05 AM Venky Shankar <vshankar@redhat.com> wrote:
> > > >
> > > > v4:
> > > >   - use mount_syntax_v1,.. as file names
> > > >
> > > > [This is based on top of new mount syntax series]
> > > >
> > > > Patrick proposed the idea of having debugfs entries to signify if
> > > > kernel supports the new (v2) mount syntax. The primary use of this
> > > > information is to catch any bugs in the new syntax implementation.
> > > >
> > > > This would be done as follows::
> > > >
> > > > The userspace mount helper tries to mount using the new mount syntax
> > > > and fallsback to using old syntax if the mount using new syntax fails.
> > > > However, a bug in the new mount syntax implementation can silently
> > > > result in the mount helper switching to old syntax.
> > > >
> > > > So, the debugfs entries can be relied upon by the mount helper to
> > > > check if the kernel supports the new mount syntax. Cases when the
> > > > mount using the new syntax fails, but the kernel does support the
> > > > new mount syntax, the mount helper could probably log before switching
> > > > to the old syntax (or fail the mount altogether when run in test mode).
> > > >
> > > > Debugfs entries are as follows::
> > > >
> > > >     /sys/kernel/debug/ceph/
> > > >     ....
> > > >     ....
> > > >     /sys/kernel/debug/ceph/meta
> > > >     /sys/kernel/debug/ceph/meta/client_features
> > > >     /sys/kernel/debug/ceph/meta/client_features/mount_syntax_v2
> > > >     /sys/kernel/debug/ceph/meta/client_features/mount_syntax_v1
> > > >     ....
> > > >     ....
> > >
> > > Hi Venky, Jeff,
> > >
> > > If this is supposed to be used in the wild and not just in teuthology,
> > > I would be wary of going with debugfs.  debugfs isn't always available
> > > (it is actually compiled out in some configurations, it may or may not
> > > be mounted, etc).  With the new mount syntax feature it is not a big
> > > deal because the mount helper should do just fine without it but with
> > > other features we may find ourselves in a situation where the mount
> > > helper (or something else) just *has* to know whether the feature is
> > > supported or not and falling back to "no" if debugfs is not available
> > > is undesirable or too much work.
> > >
> > > I don't have a great suggestion though.  When I needed to do this in
> > > the past for RADOS feature bits, I went with a read-only kernel module
> > > parameter [1].  They are exported via sysfs which is guaranteed to be
> > > available.  Perhaps we should do the same for mount_syntax -- have it
> > > be either 1 or 2, allowing it to be revved in the future?
> >
> > I'm ok with exporting via sysfs (since it's guaranteed). My only ask
> > here would be to have the mount support information present itself as
> > files rather than file contents to avoid writing parsing stuff in
> > userspace, which is ok, however, relying on stat() is nicer.
> >
>
> You should be able to do that by just making a read-only parameter
> called "mount_syntax_v2", and then you can test for it by doing
> something like:
>
>     # stat /sys/module/ceph/parameters/mount_syntax_v2
>
> The contents of the file can be blank (or just return Y or something).

Yep. That's fine.

So, we no longer have these entries in subdirectories
(meta/client_features/...) and those end up under parameters?

I do see subdirectories under other modules, so it's probably doable with sysfs.

>
> > >
> > > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d6a3408a77807037872892c2a2034180fcc08d12
> > >
> > > Thanks,
> > >
> > >                 Ilya
> > >
> >
> >
>
> --
> Jeff Layton <jlayton@redhat.com>
>


-- 
Cheers,
Venky

