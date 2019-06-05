Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9517E367D1
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2019 01:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfFEXTF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jun 2019 19:19:05 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42942 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbfFEXTF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Jun 2019 19:19:05 -0400
Received: by mail-qt1-f196.google.com with SMTP id s15so551154qtk.9
        for <ceph-devel@vger.kernel.org>; Wed, 05 Jun 2019 16:19:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q4KAt1xhGPBkFyoEDGE6c40LPdTqIr1N6BkGyI4oSSM=;
        b=pQN8bQ807bVyZSxNc75VhrOA/rQ+0VP+BGe0OV+vFAFg9KTg1FIASEcTkCZ2t9/dS7
         Qg3C1qMuKPC4VrkonPxK362k2SlOwDw4B2YxSbYEzrM68OQ8qLGsa75WgWtO2p2aOH9B
         N02XgkedZs7G2JJSW9BnU4+GJRI2MRmzSBBeNUUZsr1BQ2rzEeT/M6Dw5CRPVWH0FFFU
         27/tFyPBhWkNiKGgvLYhzJhfcJpDiunRIMd1VvSNAnz3CBRU+6xyRYn6u58h3aKy95lQ
         TyMp3o/lTbwohPhDZd6awS/QIoaDAD9HxYiOvg8MV6H6rkDrOpUY0n2EZUm7aM+MHrfS
         0WjA==
X-Gm-Message-State: APjAAAUlci43PJiBmXjRXi7E+XAqbsC+V9JM05+75o9rQMdXG3DsqG95
        PbKu7T0C+PV9BXki3+ZLPXI3A+cRKYcqEeXrLCRelg==
X-Google-Smtp-Source: APXvYqzE3ZNTNkimaNc1s/NypcXReAeL0IzB+pe5xBvsgEHtVmMfSBccqB8txloauYv03kUKUVKqh5IssNi2FrT6n/s=
X-Received: by 2002:ac8:3932:: with SMTP id s47mr37734277qtb.264.1559776743305;
 Wed, 05 Jun 2019 16:19:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190531122802.12814-1-zyan@redhat.com> <20190531122802.12814-2-zyan@redhat.com>
 <CAOi1vP8O6VviiNKrozmwUOtVN+GtvA=-0fEOXcdbg8O+pu1PhQ@mail.gmail.com>
 <CAAM7YAmY-ky2E_9aPHNSNMmmTp9rC+Aw-eBMN_KP1suY_u+Wmg@mail.gmail.com>
 <CAJ4mKGZHm3TqwU8Q=rn1xQtePMhaJNvU4yHGj0jDqR_9oxz2fA@mail.gmail.com>
 <CAOi1vP8k88mFJgLYvD-zWBFgwV4vQ4DR0wBDzSDeDCDBaSLj_g@mail.gmail.com>
 <CAJ4mKGY+jhc926uSRJUtHgL174wtq_3dLO3_1ks=2kpNk9Pkaw@mail.gmail.com>
 <CA+2bHPboGYSY82Mh73qdSREZhzve72s4GgDVXqhdrdpW9YbC7Q@mail.gmail.com>
 <CAOi1vP_QNR9u78GhJzxeiUPkq6OT7FVBP3R2u3d02F=uNN1FDw@mail.gmail.com>
 <b742f7bf2ad6075468625120623b6c89c259ad0a.camel@redhat.com>
 <CA+2bHPa10b9HPDBsa=r3==Mk-_TQBfRK5CU=NGpbazTmC7OX9Q@mail.gmail.com> <16ad8a222b35aa7b21bcf4a63b38e871f41826cc.camel@redhat.com>
In-Reply-To: <16ad8a222b35aa7b21bcf4a63b38e871f41826cc.camel@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Wed, 5 Jun 2019 16:18:37 -0700
Message-ID: <CA+2bHPai8ZOBxPPVoWO8DUxQ89i=m5EZ-eXkz6Rk9nMO95mw4w@mail.gmail.com>
Subject: Re: [PATCH 2/3] ceph: add method that forces client to reconnect
 using new entity addr
To:     Jeff Layton <jlayton@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>, "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>,
        Luis Henriques <lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Apologies for having this discussion in two threads...

On Wed, Jun 5, 2019 at 3:26 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Wed, 2019-06-05 at 14:57 -0700, Patrick Donnelly wrote:
> > On Tue, Jun 4, 2019 at 3:51 AM Jeff Layton <jlayton@redhat.com> wrote:
> > > On Tue, 2019-06-04 at 11:37 +0200, Ilya Dryomov wrote:
> > > > On Mon, Jun 3, 2019 at 11:05 PM Patrick Donnelly <pdonnell@redhat.com> wrote:
> > > > > On Mon, Jun 3, 2019 at 1:24 PM Gregory Farnum <gfarnum@redhat.com> wrote:
> > > > > > On Mon, Jun 3, 2019 at 1:07 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> > > > > > > Can we also discuss how useful is allowing to recover a mount after it
> > > > > > > has been blacklisted?  After we fail everything with EIO and throw out
> > > > > > > all dirty state, how many applications would continue working without
> > > > > > > some kind of restart?  And if you are restarting your application, why
> > > > > > > not get a new mount?
> > > > > > >
> > > > > > > IOW what is the use case for introducing a new debugfs knob that isn't
> > > > > > > that much different from umount+mount?
> > > > > >
> > > > > > People don't like it when their filesystem refuses to umount, which is
> > > > > > what happens when the kernel client can't reconnect to the MDS right
> > > > > > now. I'm not sure there's a practical way to deal with that besides
> > > > > > some kind of computer admin intervention.
> > > > >
> > > > > Furthermore, there are often many applications using the mount (even
> > > > > with containers) and it's not a sustainable position that any
> > > > > network/client/cephfs hiccup requires a remount. Also, an application
> > > >
> > > > Well, it's not just any hiccup.  It's one that lead to blacklisting...
> > > >
> > > > > that fails because of EIO is easy to deal with a layer above but a
> > > > > remount usually requires grump admin intervention.
> > > >
> > > > I feel like I'm missing something here.  Would figuring out $ID,
> > > > obtaining root and echoing to /sys/kernel/debug/$ID/control make the
> > > > admin less grumpy, especially when containers are involved?
> > > >
> > > > Doing the force_reconnect thing would retain the mount point, but how
> > > > much use would it be?  Would using existing (i.e. pre-blacklist) file
> > > > descriptors be allowed?  I assumed it wouldn't be (permanent EIO or
> > > > something of that sort), so maybe that is the piece I'm missing...
> > > >
> > >
> > > I agree with Ilya here. I don't see how applications can just pick up
> > > where they left off after being blacklisted. Remounting in some fashion
> > > is really the only recourse here.
> > >
> > > To be clear, what happens to stateful objects (open files, byte-range
> > > locks, etc.) in this scenario? Were you planning to just re-open files
> > > and re-request locks that you held before being blacklisted? If so, that
> > > sounds like a great way to cause some silent data corruption...
> >
> > The plan is:
> >
> > - files open for reading re-obtain caps and may continue to be used
> > - files open for writing discard all dirty file blocks and return -EIO
> > on further use (this could be configurable via a mount_option like
> > with the ceph-fuse client)
> >
>
> That sounds fairly reasonable.
>
> > Not sure how best to handle locks and I'm open to suggestions. We
> > could raise SIGLOST on those processes?
> >
>
> Unfortunately, SIGLOST has never really been a thing on Linux. There was
> an attempt by Anna Schumaker a few years ago to implement it for use
> with NFS, but it never went in.

Is there another signal we could reasonably use?

> We ended up with this patch, IIRC:
>
>     https://patchwork.kernel.org/patch/10108419/
>
> "The current practice is to set NFS_LOCK_LOST so that read/write returns
>  EIO when a lock is lost. So, change these comments to code when sets
> NFS_LOCK_LOST."
>
> Maybe we should aim for similar behavior in this situation. It's a
> little tricker here since we don't really have an analogue to a lock
> stateid in ceph, so we'd need to implement this in some other way.

So effectively blacklist the process so all I/O is blocked on the
mount? Do I understand correctly?

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
