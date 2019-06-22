Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 404CE4F358
	for <lists+ceph-devel@lfdr.de>; Sat, 22 Jun 2019 05:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfFVDUf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 21 Jun 2019 23:20:35 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44627 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFVDUf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 21 Jun 2019 23:20:35 -0400
Received: by mail-qt1-f194.google.com with SMTP id x47so8984162qtk.11
        for <ceph-devel@vger.kernel.org>; Fri, 21 Jun 2019 20:20:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9nIh4jTy5FbFD3tXcijLGxWMYD0FJX8e5rB9xvP/zRc=;
        b=cmkNfreTzJggp5VHMo4629XdGXb1rtio8tl37laOcVbvjbu80pCQ3/IegHSiMOLUlg
         yh5JDi5criC8YCJZevV7PGbMur80baUHJ7sM3bkLOplBng1zWYc7lVHNiA61eja+o1pz
         YtMtBLjvKAmrGrR12OkU90oyJpiEGviOefcZZB8kcJFPq99NnwTzASiUCuyaDAFuVI99
         3nKZqd66hwtLlvFWVyxm3iFOGtWchd6z6FS93tNcqYpugRUvMaO5WZVa/W5Zoq/Aqnmu
         SmnV/KJ7vlhi13fxt/QK5rZQivycoHOty7Xfo83NvOQDFQ9DmR0U0r+JLM/WzCKpPbLh
         QJQw==
X-Gm-Message-State: APjAAAWrgTddj0xusHEy/ESlLrnN6SyvxtpMKGk5+K1SR9Q6YJ5hbD90
        0lCSJ91MlbQiQ3Yu6rZU4dbpP1m3gN/A6GhMyocGWA==
X-Google-Smtp-Source: APXvYqyO+m+xZ6AOZRUocbETycZU4XL2H9AQ7ods+H0NyIr+1pRUWl9N+6nSpsH+nImJPFQ/AuIv5nDCV71ip9MfWGg=
X-Received: by 2002:ac8:374d:: with SMTP id p13mr117038621qtb.389.1561173633718;
 Fri, 21 Jun 2019 20:20:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190617125529.6230-1-zyan@redhat.com> <20190617125529.6230-5-zyan@redhat.com>
 <86f838f18f0871d6c21ae7bfb97541f1de8d918f.camel@redhat.com>
 <3b0a4024-d47e-0a3f-48ca-0f1f657e9da9@redhat.com> <e220f9e72b736141c39da52eb7d8d00b97a2c040.camel@redhat.com>
 <CAAM7YAmaQ6eC_zcC7xFr9c6XMOsJvR=TFXZ__i_+jnxQf5MmtA@mail.gmail.com>
 <03262ecae2386444d50571484fbe21592d4d3f95.camel@redhat.com>
 <CA+2bHPa=iuu5P8jOCGxXz7iksHXNQsmioQ_DacrhC-UgY0oDEQ@mail.gmail.com> <CAAM7YAk+TpFpGeYUV4KkDAkNRdhb-yzfR=oLBnj93dgRm+KjNA@mail.gmail.com>
In-Reply-To: <CAAM7YAk+TpFpGeYUV4KkDAkNRdhb-yzfR=oLBnj93dgRm+KjNA@mail.gmail.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Fri, 21 Jun 2019 20:20:04 -0700
Message-ID: <CA+2bHPYvxd-310xt31Xq1fHddLEjBgm1F_KawU2hvU9Ji58YOw@mail.gmail.com>
Subject: Re: [PATCH 4/8] ceph: allow remounting aborted mount
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     Jeff Layton <jlayton@redhat.com>, "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 20, 2019 at 7:59 PM Yan, Zheng <ukernel@gmail.com> wrote:
>
> On Fri, Jun 21, 2019 at 1:11 AM Patrick Donnelly <pdonnell@redhat.com> wrote:
> >
> > On Thu, Jun 20, 2019 at 8:34 AM Jeff Layton <jlayton@redhat.com> wrote:
> > >
> > > On Wed, 2019-06-19 at 08:24 +0800, Yan, Zheng wrote:
> > > > On Tue, Jun 18, 2019 at 6:39 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > On Tue, 2019-06-18 at 14:25 +0800, Yan, Zheng wrote:
> > > > > > On 6/18/19 1:30 AM, Jeff Layton wrote:
> > > > > > > On Mon, 2019-06-17 at 20:55 +0800, Yan, Zheng wrote:
> > > > > > > > When remounting aborted mount, also reset client's entity addr.
> > > > > > > > 'umount -f /ceph; mount -o remount /ceph' can be used for recovering
> > > > > > > > from blacklist.
> > > > > > > >
> > > > > > >
> > > > > > > Why do I need to umount here? Once the filesystem is unmounted, then the
> > > > > > > '-o remount' becomes superfluous, no? In fact, I get an error back when
> > > > > > > I try to remount an unmounted filesystem:
> > > > > > >
> > > > > > >      $ sudo umount -f /mnt/cephfs ; sudo mount -o remount /mnt/cephfs
> > > > > > >      mount: /mnt/cephfs: mount point not mounted or bad option.
> > > > > > >
> > > > > > > My client isn't blacklisted above, so I guess you're counting on the
> > > > > > > umount returning without having actually unmounted the filesystem?
> > > > > > >
> > > > > > > I think this ought to not need a umount first. From a UI standpoint,
> > > > > > > just doing a "mount -o remount" ought to be sufficient to clear this.
> > > > > > >
> > > > > > This series is mainly for the case that mount point is not umountable.
> > > > > > If mount point is umountable, user should use 'umount -f /ceph; mount
> > > > > > /ceph'. This avoids all trouble of error handling.
> > > > > >
> > > > >
> > > > > ...
> > > > >
> > > > > > If just doing "mount -o remount", user will expect there is no
> > > > > > data/metadata get lost.  The 'mount -f' explicitly tell user this
> > > > > > operation may lose data/metadata.
> > > > > >
> > > > > >
> > > > >
> > > > > I don't think they'd expect that and even if they did, that's why we'd
> > > > > return errors on certain operations until they are cleared. But, I think
> > > > > all of this points out the main issue I have with this patchset, which
> > > > > is that it's not clear what problem this is solving.
> > > > >
> > > > > So: client gets blacklisted and we want to allow it to come back in some
> > > > > fashion. Do we expect applications that happened to be accessing that
> > > > > mount to be able to continue running, or will they need to be restarted?
> > > > > If they need to be restarted why not just expect the admin to kill them
> > > > > all off, unmount and remount and then start them back up again?
> > > > >
> > > >
> > > > The point is let users decide what to do. Some user values
> > > > availability over consistency. It's inconvenient to kill all
> > > > applications that use the mount, then do umount.
> > > >
> > > >
> > >
> > > I think I have a couple of issues with this patchset. Maybe you can
> > > convince me though:
> > >
> > > 1) The interface is really weird.
> > >
> > > You suggested that we needed to do:
> > >
> > >     # umount -f /mnt/foo ; mount -o remount /mnt/foo
> > >
> > > ...but what if I'm not really blacklisted? Didn't I just kill off all
> > > the calls in-flight with the umount -f? What if that umount actually
> > > succeeds? Then the subsequent remount call will fail.
> > >
> > > ISTM, that this interface (should we choose to accept it) should just
> > > be:
> > >
> > >     # mount -o remount /mnt/foo
> > >
> > > ...and if the client figures out that it has been blacklisted, then it
> > > does the right thing during the remount (whatever that right thing is).
> >
> > This looks reasonable to me. It's not clear to me (without poring over
> > the code which I lack time to do rigorously) why the umount should be
> > necessary at all.
> >
> > Furthermore, I don't like that this is requiring operator intervention
> > (i.e. remount) of any kind to recover the mount. If undesirable
> > consistency/cache coherency concerns are what's stopping us from
> > automatic recovery,
>
> if admin want clients to auto recover. why enabling blacklist on eviction
> at the first place.

Because the client may not even be aware that it's acting in a rogue
fashion, e.g. by writing to some file. The only correct action for the
MDS is to kill the session and blacklist the client from talking to
the OSDs.

Now, wanting the client to recover from this by re-establishing a
session with the MDS and cluster is a reasonable next step. But the
first step must be to blacklist the client because we have no idea
what it's doing or what kind of network partitions have occurred.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
