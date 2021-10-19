Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70CDC43311B
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Oct 2021 10:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234727AbhJSIeh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Oct 2021 04:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234558AbhJSIeg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 Oct 2021 04:34:36 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898B3C06161C
        for <ceph-devel@vger.kernel.org>; Tue, 19 Oct 2021 01:32:24 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id e10so11077875uab.3
        for <ceph-devel@vger.kernel.org>; Tue, 19 Oct 2021 01:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NqTZBpdsqFVZPcRKtCj3pgMjoqlIfaYy9D7h6XZWz7Q=;
        b=P75oAlWQzhsZVFRwLdvExytfdq4rdDXTM4LFYQSzn5O1pUytr65jpsfQi9+ba2e6pa
         gMZobClEmn0aHEs+OL/a+mzIDvsrwHaY3JcIjgv1ufwixHVbFcGfX+xQrXLw0mK0hpvr
         iJpH1h/2VE/mYaWmRy4pRpjMnGn777eG7nFJ1R5MTMilANQwH6S7/r1O3cHCJaUVcjtu
         /Tpv+bsD0dzGQC9oaKG9caeAc00nqrcDGW92ou8fCHFFog5et9yomVNhu8AIZFrIpA+Z
         yMwc2uBhas8DmE+7jOO8k8aq5WaKTCtHXoV/qbBtFhvBh1Q4tnCiiKQx1Q2vTIRuGJOP
         2FDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NqTZBpdsqFVZPcRKtCj3pgMjoqlIfaYy9D7h6XZWz7Q=;
        b=HINv0Wmcn4DAnsYrcSqE6/SxXDPmLD5xu2HnJPvdHHKkN+jO0m5X0pbK15Dci2+lYI
         r8mRpNDec3RbIic5VKOyzGGcD7BZTbCEpBVkty37Opqy75LP4QriQ7tBNb9UgA6JqsU0
         qkkzxVuUEnv2kkc8Aaz1IX4M2DYUAakBnbydXdGgjQBdnZ10ehk9vMpqo/E7U4i86WbC
         +Po1tc92Wrx1pi4kqtvlSuO7eUySfoWHgjhe6ofuWepSb/caJRXj93biRtnzkynZZ4NJ
         X8BSh/MNsUOWxHqjitvGW3aLIrJC3xxTLmHEN0AYanSK4unn3EVF7iI/13nEjcChdB9n
         n3Uw==
X-Gm-Message-State: AOAM533TpKWsh5kLB+9clR5zIgcjde4OeUpRBmr8xS37KNv1N5VsG9Kw
        VSgT5zZFQ4ULXjSxN0y+Ey+1gixWOfF5gd/JYHI=
X-Google-Smtp-Source: ABdhPJzGIQQ+GQ8PpYrPuQo8F8oZWtgRXqcEaz4sdWEsHdvdUQNfeo+2tNAQkOJeqJQFzL7eh90N+pZ3VJgL7WH6WdQ=
X-Received: by 2002:a67:e159:: with SMTP id o25mr33504260vsl.44.1634632343360;
 Tue, 19 Oct 2021 01:32:23 -0700 (PDT)
MIME-Version: 1.0
References: <20211001050037.497199-1-vshankar@redhat.com>
In-Reply-To: <20211001050037.497199-1-vshankar@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 19 Oct 2021 10:31:51 +0200
Message-ID: <CAOi1vP_ePRvs4fPRxXq2onbcxvCarXvE6O6vzc3de2W2=jV57Q@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] ceph: add debugfs entries signifying new mount
 syntax support
To:     Venky Shankar <vshankar@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Oct 1, 2021 at 7:05 AM Venky Shankar <vshankar@redhat.com> wrote:
>
> v4:
>   - use mount_syntax_v1,.. as file names
>
> [This is based on top of new mount syntax series]
>
> Patrick proposed the idea of having debugfs entries to signify if
> kernel supports the new (v2) mount syntax. The primary use of this
> information is to catch any bugs in the new syntax implementation.
>
> This would be done as follows::
>
> The userspace mount helper tries to mount using the new mount syntax
> and fallsback to using old syntax if the mount using new syntax fails.
> However, a bug in the new mount syntax implementation can silently
> result in the mount helper switching to old syntax.
>
> So, the debugfs entries can be relied upon by the mount helper to
> check if the kernel supports the new mount syntax. Cases when the
> mount using the new syntax fails, but the kernel does support the
> new mount syntax, the mount helper could probably log before switching
> to the old syntax (or fail the mount altogether when run in test mode).
>
> Debugfs entries are as follows::
>
>     /sys/kernel/debug/ceph/
>     ....
>     ....
>     /sys/kernel/debug/ceph/meta
>     /sys/kernel/debug/ceph/meta/client_features
>     /sys/kernel/debug/ceph/meta/client_features/mount_syntax_v2
>     /sys/kernel/debug/ceph/meta/client_features/mount_syntax_v1
>     ....
>     ....

Hi Venky, Jeff,

If this is supposed to be used in the wild and not just in teuthology,
I would be wary of going with debugfs.  debugfs isn't always available
(it is actually compiled out in some configurations, it may or may not
be mounted, etc).  With the new mount syntax feature it is not a big
deal because the mount helper should do just fine without it but with
other features we may find ourselves in a situation where the mount
helper (or something else) just *has* to know whether the feature is
supported or not and falling back to "no" if debugfs is not available
is undesirable or too much work.

I don't have a great suggestion though.  When I needed to do this in
the past for RADOS feature bits, I went with a read-only kernel module
parameter [1].  They are exported via sysfs which is guaranteed to be
available.  Perhaps we should do the same for mount_syntax -- have it
be either 1 or 2, allowing it to be revved in the future?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d6a3408a77807037872892c2a2034180fcc08d12

Thanks,

                Ilya
