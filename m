Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7453F0472
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Aug 2021 15:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236298AbhHRNSW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Aug 2021 09:18:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36727 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233634AbhHRNSU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 09:18:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629292665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8gTANewHxno+A5Iqacs1Yp+dTkLSZkAyL3VVdrNXMIo=;
        b=a8M67i7QNubxbf58D3VUIv7chPHx+99h9KXhA9HxWPPj1M4B7P2kdrLsXDbM8uSuh1ZTyu
        vW52IFjXtXORJe0eBydi83+h3yqCFGAz5Hq7CXV9i+BH4taJMt6bxcv1N2Wz7ymSnJMzRc
        Ri2ElXXNmFnseTlJNF0bBSNXjefJg3M=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-PIYo4thoPTGA0HVU0_xJXQ-1; Wed, 18 Aug 2021 09:17:43 -0400
X-MC-Unique: PIYo4thoPTGA0HVU0_xJXQ-1
Received: by mail-ed1-f71.google.com with SMTP id e3-20020a50ec830000b02903be5be2fc73so1002618edr.16
        for <ceph-devel@vger.kernel.org>; Wed, 18 Aug 2021 06:17:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8gTANewHxno+A5Iqacs1Yp+dTkLSZkAyL3VVdrNXMIo=;
        b=b6kdOM3qCUCRFd+RO/uPmjqStRNOU94zQenzpevT+OhXwrq5PieY5ae7vZ98wq5SyN
         snYFXBR/EduIq2Ns1z94wPQgfN/YO1Uf6Ij3iwSViSL9izoSiST1/BpojQzmhA9/F0xA
         vYHc0v1JYlYZrzB/STuLWZpDNDkkKYRiHZkdhoVQgZemhV5wzuzv5IEQrdRHrKdS7J2Y
         9NDmOjKEwTm82x8FsXbd5OyBV8ucRauFpVHZtsUsACLeEZ5YM8ZAsCnoUfOf8CAaqeLB
         i16gSRngMULDIa5p3OoKi2x4VrJJSdSE/6TkdjXTqpZd8X3rbGVGljbqwTpaOGAJrh9i
         ThFQ==
X-Gm-Message-State: AOAM532pJwn8d/L4NPCSTmuozQocMY24eIpg02enQd/Zfp9HSaR8Sq5B
        WThnYpybOWb/vT+nHGp14jIJT3r+xOXGWt6ZfqfZESOU/WwSUPWScHzT63njhsSniaQk/3Ew6FP
        66uMzdlQoIiXdLzc3ofzS80HN8XjOu/uxu5Swmg==
X-Received: by 2002:a17:906:3a98:: with SMTP id y24mr9667076ejd.198.1629292662434;
        Wed, 18 Aug 2021 06:17:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyE7bSSrMcgUAhi/peL7e7J+Tl+udnzTJa8Thj+DLvTV2/Ieuotu1loT4P0ibJaC7p5i+LeVX3EGNtCbOzxmeY=
X-Received: by 2002:a17:906:3a98:: with SMTP id y24mr9667058ejd.198.1629292662276;
 Wed, 18 Aug 2021 06:17:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210818060134.208546-1-vshankar@redhat.com> <68e7fb33b9ed652847a95af49f38654780fdbe20.camel@redhat.com>
In-Reply-To: <68e7fb33b9ed652847a95af49f38654780fdbe20.camel@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Wed, 18 Aug 2021 18:47:05 +0530
Message-ID: <CACPzV1niGaDtZfmVi8C4uQex1UhSkyc7GGEj0Q6Ln1qRufRGdg@mail.gmail.com>
Subject: Re: [RFC 0/2] ceph: add debugfs entries signifying new mount syntax support
To:     Jeff Layton <jlayton@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 18, 2021 at 6:39 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Wed, 2021-08-18 at 11:31 +0530, Venky Shankar wrote:
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
>
> Is this a known bug you're talking about or are you just speculating
> about the potential for bugs there?

Potential bugs.

>
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
> >     /sys/kernel/debug/ceph/dev_support
> >     /sys/kernel/debug/ceph/dev_support/v2
> >     ....
> >     ....
> >
> > Note that there is no entry signifying v1 mount syntax. That's because
> > the kernel still supports mounting with old syntax and older kernels do
> > not have debug entries for the same.
> >
> > Venky Shankar (2):
> >   ceph: add helpers to create/cleanup debugfs sub-directories under
> >     "ceph" directory
> >   ceph: add debugfs entries for v2 (new) mount syntax support
> >
> >  fs/ceph/debugfs.c            | 28 ++++++++++++++++++++++++++++
> >  fs/ceph/super.c              |  3 +++
> >  fs/ceph/super.h              |  2 ++
> >  include/linux/ceph/debugfs.h |  3 +++
> >  net/ceph/debugfs.c           | 26 ++++++++++++++++++++++++--
> >  5 files changed, 60 insertions(+), 2 deletions(-)
> >
>
> I'm not a huge fan of this approach overall as it requires that you have
> access to debugfs, and that's not guaranteed to be available everywhere.
> If you want to add this for debugging purposes, that's fine, but I don't
> think you want the mount helper to rely on this infrastructure.

Right. The use-case here is probably to rely on it during teuthology
tests where the mount fails (and the tests) when using the new syntax
but the kernel has v2 syntax support.

I recall the discussion on having some sort of `--no-fallback` option
to not fall-back to old syntax, but since we have the debugfs entries,
we may as well rely on those (at least for testing).

>
> --
> Jeff Layton <jlayton@redhat.com>
>


-- 
Cheers,
Venky

