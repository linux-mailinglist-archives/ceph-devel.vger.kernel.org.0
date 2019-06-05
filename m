Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A28C036839
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2019 01:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfFEXnc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jun 2019 19:43:32 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:34831 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfFEXnb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Jun 2019 19:43:31 -0400
Received: by mail-yw1-f67.google.com with SMTP id k128so158888ywf.2
        for <ceph-devel@vger.kernel.org>; Wed, 05 Jun 2019 16:43:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Wu2E5c9F8oPCOKzT5eXQo+6AABZkcg6E04fTamlkTuU=;
        b=YjKJIUd73muWC6aho1pO/DGg/hV3UJ2vEdYJj2t3hieuacPbHTad+ONR02bAp6SkX4
         pjmBoHJDTqKjimCvwV/Tp7vjvDeIYRgC0tSvw8gzLXxt1UHtWs9VqIbQ6VJykuZz/hao
         lD1UzA1j4nDet79j+9K3RBb4rbcjleo3Wa3lHPVmcUy50mI3sLfya11fkJZIIj8ngYUW
         4aGANQcSMfmcd6sO+BXY9SeE5pTkv9g6gxQmqeJrMi8PTdCrSfQ0S73H2Jp2JyCPI4WD
         fwUJVvy3MzK/vNDlf6LVTGxNK91AalWRFi87D1JBfh2M2gQZYmVVisTZmnowImyse4em
         FJng==
X-Gm-Message-State: APjAAAU3x02dNF/sjim2aTkp6zAD60lFT2VwJa7RYHd4Y9uTwxJZbdFB
        S7bL+Y4Q5mnKIY8L9yDizZbYHQ==
X-Google-Smtp-Source: APXvYqya4ownnDdvPZKQjthfACAn3T8AdO8t4EyWL13UrSdDs180spqFe+ov5re7WVo0DsHrI5CZuA==
X-Received: by 2002:a0d:db11:: with SMTP id d17mr9901044ywe.416.1559778210693;
        Wed, 05 Jun 2019 16:43:30 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-32F.dyn6.twc.com. [2606:a000:1100:37d::32f])
        by smtp.gmail.com with ESMTPSA id u65sm72446ywa.39.2019.06.05.16.43.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 05 Jun 2019 16:43:29 -0700 (PDT)
Message-ID: <ae8a33a3bbc886b9bc8f198a1294ba64a950e6d0.camel@redhat.com>
Subject: Re: [PATCH 2/3] ceph: add method that forces client to reconnect
 using new entity addr
From:   Jeff Layton <jlayton@redhat.com>
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>, "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>,
        Luis Henriques <lhenriques@suse.com>
Date:   Wed, 05 Jun 2019 19:43:28 -0400
In-Reply-To: <CA+2bHPai8ZOBxPPVoWO8DUxQ89i=m5EZ-eXkz6Rk9nMO95mw4w@mail.gmail.com>
References: <20190531122802.12814-1-zyan@redhat.com>
         <20190531122802.12814-2-zyan@redhat.com>
         <CAOi1vP8O6VviiNKrozmwUOtVN+GtvA=-0fEOXcdbg8O+pu1PhQ@mail.gmail.com>
         <CAAM7YAmY-ky2E_9aPHNSNMmmTp9rC+Aw-eBMN_KP1suY_u+Wmg@mail.gmail.com>
         <CAJ4mKGZHm3TqwU8Q=rn1xQtePMhaJNvU4yHGj0jDqR_9oxz2fA@mail.gmail.com>
         <CAOi1vP8k88mFJgLYvD-zWBFgwV4vQ4DR0wBDzSDeDCDBaSLj_g@mail.gmail.com>
         <CAJ4mKGY+jhc926uSRJUtHgL174wtq_3dLO3_1ks=2kpNk9Pkaw@mail.gmail.com>
         <CA+2bHPboGYSY82Mh73qdSREZhzve72s4GgDVXqhdrdpW9YbC7Q@mail.gmail.com>
         <CAOi1vP_QNR9u78GhJzxeiUPkq6OT7FVBP3R2u3d02F=uNN1FDw@mail.gmail.com>
         <b742f7bf2ad6075468625120623b6c89c259ad0a.camel@redhat.com>
         <CA+2bHPa10b9HPDBsa=r3==Mk-_TQBfRK5CU=NGpbazTmC7OX9Q@mail.gmail.com>
         <16ad8a222b35aa7b21bcf4a63b38e871f41826cc.camel@redhat.com>
         <CA+2bHPai8ZOBxPPVoWO8DUxQ89i=m5EZ-eXkz6Rk9nMO95mw4w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-06-05 at 16:18 -0700, Patrick Donnelly wrote:
> Apologies for having this discussion in two threads...
> 
> On Wed, Jun 5, 2019 at 3:26 PM Jeff Layton <jlayton@redhat.com> wrote:
> > On Wed, 2019-06-05 at 14:57 -0700, Patrick Donnelly wrote:
> > > On Tue, Jun 4, 2019 at 3:51 AM Jeff Layton <jlayton@redhat.com> wrote:
> > > > On Tue, 2019-06-04 at 11:37 +0200, Ilya Dryomov wrote:
> > > > > On Mon, Jun 3, 2019 at 11:05 PM Patrick Donnelly <pdonnell@redhat.com> wrote:
> > > > > > On Mon, Jun 3, 2019 at 1:24 PM Gregory Farnum <gfarnum@redhat.com> wrote:
> > > > > > > On Mon, Jun 3, 2019 at 1:07 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> > > > > > > > Can we also discuss how useful is allowing to recover a mount after it
> > > > > > > > has been blacklisted?  After we fail everything with EIO and throw out
> > > > > > > > all dirty state, how many applications would continue working without
> > > > > > > > some kind of restart?  And if you are restarting your application, why
> > > > > > > > not get a new mount?
> > > > > > > > 
> > > > > > > > IOW what is the use case for introducing a new debugfs knob that isn't
> > > > > > > > that much different from umount+mount?
> > > > > > > 
> > > > > > > People don't like it when their filesystem refuses to umount, which is
> > > > > > > what happens when the kernel client can't reconnect to the MDS right
> > > > > > > now. I'm not sure there's a practical way to deal with that besides
> > > > > > > some kind of computer admin intervention.
> > > > > > 
> > > > > > Furthermore, there are often many applications using the mount (even
> > > > > > with containers) and it's not a sustainable position that any
> > > > > > network/client/cephfs hiccup requires a remount. Also, an application
> > > > > 
> > > > > Well, it's not just any hiccup.  It's one that lead to blacklisting...
> > > > > 
> > > > > > that fails because of EIO is easy to deal with a layer above but a
> > > > > > remount usually requires grump admin intervention.
> > > > > 
> > > > > I feel like I'm missing something here.  Would figuring out $ID,
> > > > > obtaining root and echoing to /sys/kernel/debug/$ID/control make the
> > > > > admin less grumpy, especially when containers are involved?
> > > > > 
> > > > > Doing the force_reconnect thing would retain the mount point, but how
> > > > > much use would it be?  Would using existing (i.e. pre-blacklist) file
> > > > > descriptors be allowed?  I assumed it wouldn't be (permanent EIO or
> > > > > something of that sort), so maybe that is the piece I'm missing...
> > > > > 
> > > > 
> > > > I agree with Ilya here. I don't see how applications can just pick up
> > > > where they left off after being blacklisted. Remounting in some fashion
> > > > is really the only recourse here.
> > > > 
> > > > To be clear, what happens to stateful objects (open files, byte-range
> > > > locks, etc.) in this scenario? Were you planning to just re-open files
> > > > and re-request locks that you held before being blacklisted? If so, that
> > > > sounds like a great way to cause some silent data corruption...
> > > 
> > > The plan is:
> > > 
> > > - files open for reading re-obtain caps and may continue to be used
> > > - files open for writing discard all dirty file blocks and return -EIO
> > > on further use (this could be configurable via a mount_option like
> > > with the ceph-fuse client)
> > > 
> > 
> > That sounds fairly reasonable.
> > 
> > > Not sure how best to handle locks and I'm open to suggestions. We
> > > could raise SIGLOST on those processes?
> > > 
> > 
> > Unfortunately, SIGLOST has never really been a thing on Linux. There was
> > an attempt by Anna Schumaker a few years ago to implement it for use
> > with NFS, but it never went in.
> 
> Is there another signal we could reasonably use?
> 

Not really. The problem is really that SIGLOST is not even defined. In
fact, if you look at the asm-generic/signal.h header:

#define SIGIO           29                                                      
#define SIGPOLL         SIGIO                                                   
/*                                                                              
#define SIGLOST         29                                                      
*/                                                                              

So, there it is, commented out, and it shares a value with SIGIO. We
could pick another value for it, of course, but then you'd have to get
it into userland headers too. All of that sounds like a giant PITA.

> > We ended up with this patch, IIRC:
> > 
> >     https://patchwork.kernel.org/patch/10108419/
> > 
> > "The current practice is to set NFS_LOCK_LOST so that read/write returns
> >  EIO when a lock is lost. So, change these comments to code when sets
> > NFS_LOCK_LOST."
> > 
> > Maybe we should aim for similar behavior in this situation. It's a
> > little tricker here since we don't really have an analogue to a lock
> > stateid in ceph, so we'd need to implement this in some other way.
> 
> So effectively blacklist the process so all I/O is blocked on the
> mount? Do I understand correctly?
> 

No. I think in practice what we'd want to do is "invalidate" any file
descriptions that were open before the blacklisting where locks were
lost. Attempts to do reads or writes against those fd's would get back
an error (EIO, most likely).

File descriptions that didn't have any lost locks could carry on working
as normal after reacquiring caps. We could also consider a module
parameter or something to allow reclaim of lost locks too (in violation
of continuity rules), like the recover_lost_locks parameter in nfs.ko.
-- 
Jeff Layton <jlayton@redhat.com>

