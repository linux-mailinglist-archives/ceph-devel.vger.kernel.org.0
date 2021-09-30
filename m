Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAB541DAEE
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Sep 2021 15:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351272AbhI3NY3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Sep 2021 09:24:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41361 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351164AbhI3NY3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 30 Sep 2021 09:24:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633008166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Soj0SKEuG9VKvsrziIsz2fFaau/Pvoxwk3q46naCCpc=;
        b=CiyYfJOKGQqF1YfFpGkOxKohkiAi8cgdJAN4urZMBEF/u9bqtIR1jzNpBiPKpjg8EBGWO4
        qgS5QM3SXvaXlWVCLVBH2SstbPzbwX+8Py3PppWSxWougqk5zJ6H/uFJVMxBPRLjHYEWBJ
        qMk3/FLUr0Plnf+KmE34t2aw4vvZ7sw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-uR1rblMlPnCVxzQGpyqKuA-1; Thu, 30 Sep 2021 09:22:44 -0400
X-MC-Unique: uR1rblMlPnCVxzQGpyqKuA-1
Received: by mail-ed1-f69.google.com with SMTP id y15-20020a50ce0f000000b003dab997cf7dso2712969edi.9
        for <ceph-devel@vger.kernel.org>; Thu, 30 Sep 2021 06:22:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Soj0SKEuG9VKvsrziIsz2fFaau/Pvoxwk3q46naCCpc=;
        b=UbCGr4dQPLqzVqeyiVwXQoFc+QzYDIIslsdz5ctvlTmIYDJ9WLAXQmrx/A+cCIo/SW
         c8skftp5IfpzXmiJ38JebkhE75qJEPUnv1/lK7GnSJLnH7C84shUdotvbOynDSzMet1/
         2VqgDfTPbv5yC3FmIsgTsDsjOV0qo1s8d+EopSSBSMLVh3fn1alh6YSBW7CToVLC/wTB
         bD2GSzH0tPiR3EUbkR6EqPfzwClq0tVTvP2zauQQdbRo4JvXCB9PRw6R6BoTkBMX63Wx
         X2U9BOn4QV8Vb+xZfLS2d5UPYoLI2uSwLzJk7ML4qU2b+roZt+QvBW9kqKA6q4A68obK
         uMLg==
X-Gm-Message-State: AOAM5304VHrIXEhCQiXUuxOCASjG08Q8Y7iDGXvlqijdk1+URJygfvR+
        LZg3+J6WsNzGlVp6pnU1zEwPcl6ra89CGJoQgqnK5LY/nSYtTD8kg9xz46dOyUnKdwUJdraAw0D
        vs9C6r9dSFO6CQi8oOCABB+KLRRfe5yO/lFKnlw==
X-Received: by 2002:a17:906:6011:: with SMTP id o17mr6453390ejj.157.1633008163637;
        Thu, 30 Sep 2021 06:22:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzxJm5CRcjUCXGAhuZCRMvJl2Y2DSCJ4EYP/6GQ/Wss7s2jWWeoWy5h4WSfwwQoaXMKiesQH6I8ApAjOveSTU=
X-Received: by 2002:a17:906:6011:: with SMTP id o17mr6453364ejj.157.1633008163422;
 Thu, 30 Sep 2021 06:22:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210928060633.349231-1-vshankar@redhat.com> <54238e8d192057c5ea9dc393d9974d7bdf09bf40.camel@redhat.com>
In-Reply-To: <54238e8d192057c5ea9dc393d9974d7bdf09bf40.camel@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Thu, 30 Sep 2021 18:52:06 +0530
Message-ID: <CACPzV1=4fPeJhWkazv+_=0FyKY4Ou=QJ19kRvymkGp5a1taeHQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] ceph: add debugfs entries signifying new mount
 syntax support
To:     Jeff Layton <jlayton@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Sep 30, 2021 at 4:58 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Tue, 2021-09-28 at 11:36 +0530, Venky Shankar wrote:
> > v3:
> >  - create mount syntax debugfs entries under /<>/ceph/meta/client_features directory
> >  - mount syntax debugfs file names are v1, v2,... (were v1_mount_sytnax,... earlier)
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
> >     /sys/kernel/debug/ceph/meta/client_features/v2
> >     /sys/kernel/debug/ceph/meta/client_features/v1
> >     ....
> >     ....
> >
>
> The patches look fine, technically, so I think we're down to the
> bikeshedding here.
>
> My minor gripe is that "v1" and "v2" are not really client features.
> Perhaps we should call these "mount_format_v1" or maybe
> "mount_syntax_v1" ? I could forsee is advertising other features in this
> dir in the future, and at that point "v1" and "v2" are somewhat
> ambiguous for names.
>
> Make sense?

Doh! I changed this from "v1_mount_syntax" to just "v1" ;P

Let's call it mount_syntax_v1,..

>
>
> > Venky Shankar (2):
> >   libceph: export ceph_debugfs_dir for use in ceph.ko
> >   ceph: add debugfs entries for mount syntax support
> >
> >  fs/ceph/debugfs.c            | 41 ++++++++++++++++++++++++++++++++++++
> >  fs/ceph/super.c              |  3 +++
> >  fs/ceph/super.h              |  2 ++
> >  include/linux/ceph/debugfs.h |  2 ++
> >  net/ceph/debugfs.c           |  3 ++-
> >  5 files changed, 50 insertions(+), 1 deletion(-)
> >
>
> --
> Jeff Layton <jlayton@redhat.com>
>


-- 
Cheers,
Venky

