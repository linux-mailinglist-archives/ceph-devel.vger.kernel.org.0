Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19BF9434B3E
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Oct 2021 14:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhJTMg4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Oct 2021 08:36:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47341 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229702AbhJTMg4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 20 Oct 2021 08:36:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634733281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NKn8f7c6oN2MAiC42XWUG+icJhKQGupG04QYOzT3HLw=;
        b=Pis04efp+JuMN5CsrHZlaQvmt/XrsSS6pKdDJRjjhfzE9xOZ2BFLYvzGkhcOoSJi0avCcP
        AwuUp5oXGNriVCPEqcom42LhBLP2ta9f5bwtHkC3ultHFn+hZ9oXBkDbdl8xjeTEq6MOsl
        dX8Lo8yJlVE8d3HrVW/W0dgsovf3P3E=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-ZhgXfORgPeqPN3Zb8oGQ8A-1; Wed, 20 Oct 2021 08:34:40 -0400
X-MC-Unique: ZhgXfORgPeqPN3Zb8oGQ8A-1
Received: by mail-ed1-f69.google.com with SMTP id t18-20020a056402021200b003db9e6b0e57so20851169edv.10
        for <ceph-devel@vger.kernel.org>; Wed, 20 Oct 2021 05:34:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NKn8f7c6oN2MAiC42XWUG+icJhKQGupG04QYOzT3HLw=;
        b=xmHSUSxpqHW9V8CTpfGNLfqpEGjYsmwJPMFnDN2RgbcDL8DBy2IpuPOnpu4EPNhDM9
         IivG8anFR2K3+pu+24tSM9MzuM/v41lOg9CJygBDWOokRx6DgCg8ySz4395m+nSl0oyG
         OCjGCrZKqWbZ5h2p7jfGjmld9MWIpWx7l+tiWze/MY3X0gq1XI1+RMsZcaLYc1XuA6tM
         7CHXK4FPjqNkRB4BjbKCuFgtu+tePScuxmR2A+fLRD6wCh1DFactkk8MGcFlkDVPy0RL
         WOUrUEB55sJqlZQD9RkYv7i7ewQMh3Dvvo0clhoRO3fTmcWpqFJKvoQ6lWctX1Vh2ff+
         V+tA==
X-Gm-Message-State: AOAM533lkHP+FYkt+VSw7P2qAVUXJ96en6q2vMkd3hKdTzOa5jCl2nf0
        aDyUi0yFGfhOQSJLfT8ApmhfTPZ4bjWzm61Z70I+0o5zNrzWmGG88DwlJvVjKNjVf6p38B6rS2P
        LdIumSTz+yfotVhcaz8bz2Buv+Bm59VFl4Ih+Mw==
X-Received: by 2002:a05:6402:14cc:: with SMTP id f12mr63339834edx.242.1634733279347;
        Wed, 20 Oct 2021 05:34:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUlZ3gocL/qLrZl0stNr8yrqqBat+MGfNG5lBaawdijqnMJldxKWF4pbmjwYkdHBjoIH68ndYE6jYgcvCzZIs=
X-Received: by 2002:a05:6402:14cc:: with SMTP id f12mr63339798edx.242.1634733279130;
 Wed, 20 Oct 2021 05:34:39 -0700 (PDT)
MIME-Version: 1.0
References: <20211001050037.497199-1-vshankar@redhat.com> <CAOi1vP_ePRvs4fPRxXq2onbcxvCarXvE6O6vzc3de2W2=jV57Q@mail.gmail.com>
In-Reply-To: <CAOi1vP_ePRvs4fPRxXq2onbcxvCarXvE6O6vzc3de2W2=jV57Q@mail.gmail.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Wed, 20 Oct 2021 18:04:02 +0530
Message-ID: <CACPzV1ng=JLW1qnPvRcXB1See6Ek6DGtic8o+Ewr2=19uJd2aw@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] ceph: add debugfs entries signifying new mount
 syntax support
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Oct 19, 2021 at 2:02 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Fri, Oct 1, 2021 at 7:05 AM Venky Shankar <vshankar@redhat.com> wrote:
> >
> > v4:
> >   - use mount_syntax_v1,.. as file names
> >
> > [This is based on top of new mount syntax series]
> >
> > Patrick proposed the idea of having debugfs entries to signify if
> > kernel supports the new (v2) mount syntax. The primary use of this
> > information is to catch any bugs in the new syntax implementation.
> >
> > This would be done as follows::
> >
> > The userspace mount helper tries to mount using the new mount syntax
> > and fallsback to using old syntax if the mount using new syntax fails.
> > However, a bug in the new mount syntax implementation can silently
> > result in the mount helper switching to old syntax.
> >
> > So, the debugfs entries can be relied upon by the mount helper to
> > check if the kernel supports the new mount syntax. Cases when the
> > mount using the new syntax fails, but the kernel does support the
> > new mount syntax, the mount helper could probably log before switching
> > to the old syntax (or fail the mount altogether when run in test mode).
> >
> > Debugfs entries are as follows::
> >
> >     /sys/kernel/debug/ceph/
> >     ....
> >     ....
> >     /sys/kernel/debug/ceph/meta
> >     /sys/kernel/debug/ceph/meta/client_features
> >     /sys/kernel/debug/ceph/meta/client_features/mount_syntax_v2
> >     /sys/kernel/debug/ceph/meta/client_features/mount_syntax_v1
> >     ....
> >     ....
>
> Hi Venky, Jeff,
>
> If this is supposed to be used in the wild and not just in teuthology,
> I would be wary of going with debugfs.  debugfs isn't always available
> (it is actually compiled out in some configurations, it may or may not
> be mounted, etc).  With the new mount syntax feature it is not a big
> deal because the mount helper should do just fine without it but with
> other features we may find ourselves in a situation where the mount
> helper (or something else) just *has* to know whether the feature is
> supported or not and falling back to "no" if debugfs is not available
> is undesirable or too much work.
>
> I don't have a great suggestion though.  When I needed to do this in
> the past for RADOS feature bits, I went with a read-only kernel module
> parameter [1].  They are exported via sysfs which is guaranteed to be
> available.  Perhaps we should do the same for mount_syntax -- have it
> be either 1 or 2, allowing it to be revved in the future?

I'm ok with exporting via sysfs (since it's guaranteed). My only ask
here would be to have the mount support information present itself as
files rather than file contents to avoid writing parsing stuff in
userspace, which is ok, however, relying on stat() is nicer.

>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d6a3408a77807037872892c2a2034180fcc08d12
>
> Thanks,
>
>                 Ilya
>


-- 
Cheers,
Venky

