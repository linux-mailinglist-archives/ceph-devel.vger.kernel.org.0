Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCE736FD9
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2019 11:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbfFFJbC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 Jun 2019 05:31:02 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37542 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727509AbfFFJbC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 6 Jun 2019 05:31:02 -0400
Received: by mail-ed1-f66.google.com with SMTP id w13so2368900eds.4
        for <ceph-devel@vger.kernel.org>; Thu, 06 Jun 2019 02:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vanderster.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TPG7QjnVxTCc7NZY4zx16QffWAfFbJ8R1rM688DUi5E=;
        b=MxnJ5nf9Rkcwwlmf/iW3vXAoqhJAMj64/OxxF9qkRzvCSGW4ckZtVCmgqCXeOne3ig
         lRo3P5XVgH1hDefoioQ9elwS8Pxl5tD4ictMOmQ/IZv+AbiBhnI/mtDCjqYxnE9sMOzX
         EzjWCBaZPulRhxpV1kG+6mP0W/zm7bBf2KaBI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TPG7QjnVxTCc7NZY4zx16QffWAfFbJ8R1rM688DUi5E=;
        b=izBrafMYApe1Z22iI0BYjf2ciMJxwlBQGEukv+TsCYLK0V/56SF1HZ+obsgHG0ugFu
         Jjy72ucZcnnz+SmETG4ol3H6V8sEqGnKr+F33j7FZN5kIM3f3bQ3d+Mt/4dN89ez9Wgl
         Y6SQIEL9/c+Ol/hp9aRqhgCbpTdMAAa8y+AWPZ+AUT2oNt2KhObAg7SO99sHzpYurYr0
         X7dyLeCEgpCt6WJgtEgAEziHr/1EXLVcqHn87wmfEqd8XNc3yUoSWircApafuCRVCx7s
         h3qt+rNEU3DmlibFaWCRgdKXqEEfthhzTIGWFKQkw8GznuU5IXYO26rHccNKG+CafgcJ
         FMeA==
X-Gm-Message-State: APjAAAVBgTahRBHKaD1127kzZXEbkx1YnTDG9edoDNa+aSX81tQ5mouh
        urPhX9eYZSqJruoE+2pLGU3hMI1Uhx4=
X-Google-Smtp-Source: APXvYqzeLQ7MJYSLf0Orts9iMcluqt+Ay/yJ9ZJjDkIQEsnMzRXdnZAu696zpOm/JuAFi5oQdt0SNQ==
X-Received: by 2002:a17:906:5048:: with SMTP id e8mr40161423ejk.91.1559813460168;
        Thu, 06 Jun 2019 02:31:00 -0700 (PDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id d12sm318120edi.46.2019.06.06.02.30.58
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 02:30:59 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id p11so1637382wre.7
        for <ceph-devel@vger.kernel.org>; Thu, 06 Jun 2019 02:30:58 -0700 (PDT)
X-Received: by 2002:adf:e705:: with SMTP id c5mr15446561wrm.270.1559813458003;
 Thu, 06 Jun 2019 02:30:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190531122802.12814-1-zyan@redhat.com> <20190531122802.12814-2-zyan@redhat.com>
 <CAOi1vP8O6VviiNKrozmwUOtVN+GtvA=-0fEOXcdbg8O+pu1PhQ@mail.gmail.com>
 <CAAM7YAmY-ky2E_9aPHNSNMmmTp9rC+Aw-eBMN_KP1suY_u+Wmg@mail.gmail.com>
 <CAJ4mKGZHm3TqwU8Q=rn1xQtePMhaJNvU4yHGj0jDqR_9oxz2fA@mail.gmail.com>
 <CAOi1vP8k88mFJgLYvD-zWBFgwV4vQ4DR0wBDzSDeDCDBaSLj_g@mail.gmail.com>
 <CAJ4mKGY+jhc926uSRJUtHgL174wtq_3dLO3_1ks=2kpNk9Pkaw@mail.gmail.com>
 <CAOi1vP88A7G_7ScstLSNwe-tUZcBUxhK=W5Qdix2tgPEOB9i8g@mail.gmail.com> <CAAM7YAmF4_9ajORX3ENmRGEgQO6Y-H4XNUu67U+bss+D-rt7PA@mail.gmail.com>
In-Reply-To: <CAAM7YAmF4_9ajORX3ENmRGEgQO6Y-H4XNUu67U+bss+D-rt7PA@mail.gmail.com>
From:   Dan van der Ster <dan@vanderster.com>
Date:   Thu, 6 Jun 2019 11:30:22 +0200
X-Gmail-Original-Message-ID: <CABZ+qq=9cvge5Z-8J6UDZt+zsYu+Zdr1Qw0qbLEpDgD5On2vcw@mail.gmail.com>
Message-ID: <CABZ+qq=9cvge5Z-8J6UDZt+zsYu+Zdr1Qw0qbLEpDgD5On2vcw@mail.gmail.com>
Subject: Re: [PATCH 2/3] ceph: add method that forces client to reconnect
 using new entity addr
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Luis Henriques <lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 4, 2019 at 4:10 AM Yan, Zheng <ukernel@gmail.com> wrote:
>
> On Tue, Jun 4, 2019 at 5:18 AM Ilya Dryomov <idryomov@gmail.com> wrote:
> >
> > On Mon, Jun 3, 2019 at 10:23 PM Gregory Farnum <gfarnum@redhat.com> wrote:
> > >
> > > On Mon, Jun 3, 2019 at 1:07 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> > > > Can we also discuss how useful is allowing to recover a mount after it
> > > > has been blacklisted?  After we fail everything with EIO and throw out
> > > > all dirty state, how many applications would continue working without
> > > > some kind of restart?  And if you are restarting your application, why
> > > > not get a new mount?
> > > >
> > > > IOW what is the use case for introducing a new debugfs knob that isn't
> > > > that much different from umount+mount?
> > >
> > > People don't like it when their filesystem refuses to umount, which is
> > > what happens when the kernel client can't reconnect to the MDS right
> > > now. I'm not sure there's a practical way to deal with that besides
> > > some kind of computer admin intervention. (Even if you umount -l, that
> > > by design doesn't reply to syscalls and let the applications exit.)
> >
> > Well, that is what I'm saying: if an admin intervention is required
> > anyway, then why not make it be umount+mount?  That is certainly more
> > intuitive than an obscure write-only file in debugfs...
> >
>
> I think  'umount -f' + 'mount -o remount' is better than the debugfs file

A small bit of user input: for some of the places we'd like to use
CephFS we value availability over consistency.
For example, in a large batch processing farm, it is really
inconvenient (and expensive in lost CPU-hours) if an operator needs to
repair thousands of mounts when cephfs breaks (e.g. an mds crash or
whatever). It is preferential to let the apps crash, drop caches,
fh's, whatever else is necessary, and create a new session to the
cluster with the same mount. In this use-case, it doesn't matter if
the files were inconsistent, because a higher-level job scheduler will
retry the job from scratch somewhere else with new output files.
It would be nice if there was a mount option to allow users to choose
this mode (-o soft, for example). Without a mount option, we're forced
to run ugly cron jobs which look for hung mounts and do the necessary.

My 2c,

dan


>
>
> > We have umount -f, which is there for tearing down a mount that is
> > unresponsive.  It should be able to deal with a blacklisted mount, if
> > it can't it's probably a bug.
> >
> > Thanks,
> >
> >                 Ilya
