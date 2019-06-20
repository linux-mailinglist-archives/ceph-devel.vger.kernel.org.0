Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6304D416
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2019 18:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfFTQqk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Jun 2019 12:46:40 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40446 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfFTQqk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 20 Jun 2019 12:46:40 -0400
Received: by mail-qk1-f194.google.com with SMTP id c70so2373075qkg.7
        for <ceph-devel@vger.kernel.org>; Thu, 20 Jun 2019 09:46:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vqt27knP2KU7CWDx2cAB4oVamTj0tx+rODj7D6bSBgc=;
        b=LHA+ZkjURVqC4CqDAIJX6zJa2ucwq3yzYqnBD6/DIsR2AN6We+nN2So3OHiUCeq6dI
         /vGAw6Gdvx9q+loAyJ9/x4ZIL2vsh1HPIpv4MY82WgniYrcxptBHB76iLL6Mz10jLuQA
         +PBmS8LEwY5Fsi46DdiJfmYYtNpXFWvemG/JhYPHNexFfGkUSF3DMEAFfxpDFbTZNweC
         acH+k7idxNOKKT8XdM9CameKjvZESQyLmVR5mch3fihew4cqPl7LJhz0aXgEAoCco9G9
         KAc8eE4sLu66jdLNtbPcPs/t5Ufh/17c523Z1SCydg9JSTGytlK0sKA5hNF63PdQgLDM
         EEmA==
X-Gm-Message-State: APjAAAVwws4ikeGrlhDZc8aKc5tbJlcUZqS6yFc97Rgkaq+AUQPq5DdM
        NbiscU9EnVwlLWJJuYFAb5yKD0jqfQBUCwUyWra+YQ==
X-Google-Smtp-Source: APXvYqwCnj/e9sQWjeS87loxZhTS78cf8uyErQTQqwPyrEJg3XFjQf1/a0k/flgbJY3odE9ZT+iUR90AXqhjvaHO6ts=
X-Received: by 2002:a05:620a:142:: with SMTP id e2mr7372729qkn.191.1561049198371;
 Thu, 20 Jun 2019 09:46:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190617125529.6230-1-zyan@redhat.com> <20190617125529.6230-5-zyan@redhat.com>
 <86f838f18f0871d6c21ae7bfb97541f1de8d918f.camel@redhat.com>
 <3b0a4024-d47e-0a3f-48ca-0f1f657e9da9@redhat.com> <e220f9e72b736141c39da52eb7d8d00b97a2c040.camel@redhat.com>
 <CAAM7YAmaQ6eC_zcC7xFr9c6XMOsJvR=TFXZ__i_+jnxQf5MmtA@mail.gmail.com> <03262ecae2386444d50571484fbe21592d4d3f95.camel@redhat.com>
In-Reply-To: <03262ecae2386444d50571484fbe21592d4d3f95.camel@redhat.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Thu, 20 Jun 2019 09:45:39 -0700
Message-ID: <CAJ4mKGYFx=-jPXbFWyXSwihZox4n4J-sFfSHkETK5RBjiS5N0g@mail.gmail.com>
Subject: Re: [PATCH 4/8] ceph: allow remounting aborted mount
To:     Jeff Layton <jlayton@redhat.com>
Cc:     "Yan, Zheng" <ukernel@gmail.com>, "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 20, 2019 at 8:34 AM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Wed, 2019-06-19 at 08:24 +0800, Yan, Zheng wrote:
> > On Tue, Jun 18, 2019 at 6:39 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > On Tue, 2019-06-18 at 14:25 +0800, Yan, Zheng wrote:
> > > > On 6/18/19 1:30 AM, Jeff Layton wrote:
> > > > > On Mon, 2019-06-17 at 20:55 +0800, Yan, Zheng wrote:
> > > > > > When remounting aborted mount, also reset client's entity addr.
> > > > > > 'umount -f /ceph; mount -o remount /ceph' can be used for recovering
> > > > > > from blacklist.
> > > > > >
> > > > >
> > > > > Why do I need to umount here? Once the filesystem is unmounted, then the
> > > > > '-o remount' becomes superfluous, no? In fact, I get an error back when
> > > > > I try to remount an unmounted filesystem:
> > > > >
> > > > >      $ sudo umount -f /mnt/cephfs ; sudo mount -o remount /mnt/cephfs
> > > > >      mount: /mnt/cephfs: mount point not mounted or bad option.
> > > > >
> > > > > My client isn't blacklisted above, so I guess you're counting on the
> > > > > umount returning without having actually unmounted the filesystem?
> > > > >
> > > > > I think this ought to not need a umount first. From a UI standpoint,
> > > > > just doing a "mount -o remount" ought to be sufficient to clear this.
> > > > >
> > > > This series is mainly for the case that mount point is not umountable.
> > > > If mount point is umountable, user should use 'umount -f /ceph; mount
> > > > /ceph'. This avoids all trouble of error handling.
> > > >
> > >
> > > ...
> > >
> > > > If just doing "mount -o remount", user will expect there is no
> > > > data/metadata get lost.  The 'mount -f' explicitly tell user this
> > > > operation may lose data/metadata.
> > > >
> > > >
> > >
> > > I don't think they'd expect that and even if they did, that's why we'd
> > > return errors on certain operations until they are cleared. But, I think
> > > all of this points out the main issue I have with this patchset, which
> > > is that it's not clear what problem this is solving.
> > >
> > > So: client gets blacklisted and we want to allow it to come back in some
> > > fashion. Do we expect applications that happened to be accessing that
> > > mount to be able to continue running, or will they need to be restarted?
> > > If they need to be restarted why not just expect the admin to kill them
> > > all off, unmount and remount and then start them back up again?
> > >
> >
> > The point is let users decide what to do. Some user values
> > availability over consistency. It's inconvenient to kill all
> > applications that use the mount, then do umount.
> >
> >
>
> I think I have a couple of issues with this patchset. Maybe you can
> convince me though:
>
> 1) The interface is really weird.
>
> You suggested that we needed to do:
>
>     # umount -f /mnt/foo ; mount -o remount /mnt/foo
>
> ...but what if I'm not really blacklisted? Didn't I just kill off all
> the calls in-flight with the umount -f? What if that umount actually
> succeeds? Then the subsequent remount call will fail.
>
> ISTM, that this interface (should we choose to accept it) should just
> be:
>
>     # mount -o remount /mnt/foo
>
> ...and if the client figures out that it has been blacklisted, then it
> does the right thing during the remount (whatever that right thing is).
>
> 2) It's not clear to me who we expect to use this.
>
> Are you targeting applications that do not use file locking? Any that do
> use file locking will probably need some special handling, but those
> that don't might be able to get by unscathed as long as they can deal
> with -EIO on fsync by replaying writes since the last fsync.
>
> The catch here is that not many applications do that. Most just fall
> over once fsync hits an error. That is a bit of a chicken and egg
> problem though, so that's not necessarily an argument against doing
> this.

It seems like a lot of users/admins are okay with their applications
falling over and getting restarted by the init system, but requiring
them to manually reboot a system is a bridge too far (especially if
the reboot hangs due to dirty data they can't force a flush on). So
doing *something* in response that they can trigger easily or that we
do automatically would be nice.

But I also agree with you that the something needs to be carefully
designed to maintain the consistency semantics we promise elsewhere
and be understandable to users, and these recent patch series make me
nervous in that regard so far...
-Greg
