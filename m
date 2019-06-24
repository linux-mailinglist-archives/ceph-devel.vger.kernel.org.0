Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABAEC5002B
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Jun 2019 05:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfFXDVS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 23 Jun 2019 23:21:18 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45301 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfFXDVS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 23 Jun 2019 23:21:18 -0400
Received: by mail-qt1-f196.google.com with SMTP id j19so12998439qtr.12
        for <ceph-devel@vger.kernel.org>; Sun, 23 Jun 2019 20:21:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=INSsJfM4+v5Gc2QnhCEwMKvukbUbez7Z0bGKDye8q9w=;
        b=brG/lxdZSNiC1pHR9afNWJjw1h0rcIEhg0MntMcq1fiRFpdcVMW1rCNcgJGfJtBAnh
         PIWRTtPJEvS43ghOs3IbEIEfXgaODPnFmbYMdQAJ4v5Zwu81otUe9fQQZGgm+0sHFKbm
         8fxRC1Riq3U4Mqo3PTZxpKa8pJfqFm6tuMrQhHTBTZ5ODpQvs1ga6wyXNk9ehsJDe0lG
         9D4m4wm+r+JnLEt6kj0svbn2J+aIsLbkf85X1+SG0l7sSvNnDiHePCIbZf3V/42dcQ8I
         eaDaZ/ruZOewyccRxh/I4e8tY328tBhIR9JdNtxpQs4w/JVyZUP54mzV4ny3qpj+MSrO
         C24Q==
X-Gm-Message-State: APjAAAV1ndU7xX/mxXc+5iwfHe7ke384H//cJq0JuECIsUWT9UyoGETw
        YicRitevrxg5bxJZAQ9ivAXyWdDyPCvlOv7get8Gkw==
X-Google-Smtp-Source: APXvYqxuMg+69HucYdj79YrQ3SR17t4gsHpgaxUiAdmQekKEXRbz+dz9EfcvEeEEOCNHkiflQVIIVA6NE9bG9/KrJ9Q=
X-Received: by 2002:ac8:374d:: with SMTP id p13mr124289838qtb.389.1561346477231;
 Sun, 23 Jun 2019 20:21:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190617125529.6230-1-zyan@redhat.com> <20190617125529.6230-5-zyan@redhat.com>
 <86f838f18f0871d6c21ae7bfb97541f1de8d918f.camel@redhat.com>
 <3b0a4024-d47e-0a3f-48ca-0f1f657e9da9@redhat.com> <e220f9e72b736141c39da52eb7d8d00b97a2c040.camel@redhat.com>
 <CAAM7YAmaQ6eC_zcC7xFr9c6XMOsJvR=TFXZ__i_+jnxQf5MmtA@mail.gmail.com>
 <03262ecae2386444d50571484fbe21592d4d3f95.camel@redhat.com>
 <d45fef05-5b6c-5919-fa0f-98e900c7f05b@redhat.com> <2cc051f6e86201ddd524b2bf6f3b04ddb89c9d36.camel@redhat.com>
 <15e9508d-903b-ae32-7c6d-11b23d20e19d@redhat.com>
In-Reply-To: <15e9508d-903b-ae32-7c6d-11b23d20e19d@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Sun, 23 Jun 2019 20:20:51 -0700
Message-ID: <CA+2bHPZh153dstOHPucamuPRS8nd37LjKm6uUf5n4B+T_ckVXA@mail.gmail.com>
Subject: Re: [PATCH 4/8] ceph: allow remounting aborted mount
To:     "Yan, Zheng" <zyan@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, Jun 23, 2019 at 6:50 PM Yan, Zheng <zyan@redhat.com> wrote:
>
> On 6/22/19 12:48 AM, Jeff Layton wrote:
> > On Fri, 2019-06-21 at 16:10 +0800, Yan, Zheng wrote:
> >> On 6/20/19 11:33 PM, Jeff Layton wrote:
> >>> On Wed, 2019-06-19 at 08:24 +0800, Yan, Zheng wrote:
> >>>> On Tue, Jun 18, 2019 at 6:39 PM Jeff Layton <jlayton@redhat.com> wrote:
> >>>>> On Tue, 2019-06-18 at 14:25 +0800, Yan, Zheng wrote:
> >>>>>> On 6/18/19 1:30 AM, Jeff Layton wrote:
> >>>>>>> On Mon, 2019-06-17 at 20:55 +0800, Yan, Zheng wrote:
> >>>>>>>> When remounting aborted mount, also reset client's entity addr.
> >>>>>>>> 'umount -f /ceph; mount -o remount /ceph' can be used for recovering
> >>>>>>>> from blacklist.
> >>>>>>>>
> >>>>>>>
> >>>>>>> Why do I need to umount here? Once the filesystem is unmounted, then the
> >>>>>>> '-o remount' becomes superfluous, no? In fact, I get an error back when
> >>>>>>> I try to remount an unmounted filesystem:
> >>>>>>>
> >>>>>>>        $ sudo umount -f /mnt/cephfs ; sudo mount -o remount /mnt/cephfs
> >>>>>>>        mount: /mnt/cephfs: mount point not mounted or bad option.
> >>>>>>>
> >>>>>>> My client isn't blacklisted above, so I guess you're counting on the
> >>>>>>> umount returning without having actually unmounted the filesystem?
> >>>>>>>
> >>>>>>> I think this ought to not need a umount first. From a UI standpoint,
> >>>>>>> just doing a "mount -o remount" ought to be sufficient to clear this.
> >>>>>>>
> >>>>>> This series is mainly for the case that mount point is not umountable.
> >>>>>> If mount point is umountable, user should use 'umount -f /ceph; mount
> >>>>>> /ceph'. This avoids all trouble of error handling.
> >>>>>>
> >>>>>
> >>>>> ...
> >>>>>
> >>>>>> If just doing "mount -o remount", user will expect there is no
> >>>>>> data/metadata get lost.  The 'mount -f' explicitly tell user this
> >>>>>> operation may lose data/metadata.
> >>>>>>
> >>>>>>
> >>>>>
> >>>>> I don't think they'd expect that and even if they did, that's why we'd
> >>>>> return errors on certain operations until they are cleared. But, I think
> >>>>> all of this points out the main issue I have with this patchset, which
> >>>>> is that it's not clear what problem this is solving.
> >>>>>
> >>>>> So: client gets blacklisted and we want to allow it to come back in some
> >>>>> fashion. Do we expect applications that happened to be accessing that
> >>>>> mount to be able to continue running, or will they need to be restarted?
> >>>>> If they need to be restarted why not just expect the admin to kill them
> >>>>> all off, unmount and remount and then start them back up again?
> >>>>>
> >>>>
> >>>> The point is let users decide what to do. Some user values
> >>>> availability over consistency. It's inconvenient to kill all
> >>>> applications that use the mount, then do umount.
> >>>>
> >>>>
> >>>
> >>> I think I have a couple of issues with this patchset. Maybe you can
> >>> convince me though:
> >>>
> >>> 1) The interface is really weird.
> >>>
> >>> You suggested that we needed to do:
> >>>
> >>>       # umount -f /mnt/foo ; mount -o remount /mnt/foo
> >>>
> >>> ...but what if I'm not really blacklisted? Didn't I just kill off all
> >>> the calls in-flight with the umount -f? What if that umount actually
> >>> succeeds? Then the subsequent remount call will fail.
> >>>
> >>> ISTM, that this interface (should we choose to accept it) should just
> >>> be:
> >>>
> >>>       # mount -o remount /mnt/foo
> >>>
> >>
> >> I have patch that does
> >>
> >> mount -o remount,force_reconnect /mnt/ceph
> >>
> >>
> >
> > That seems clearer.
> >
> >>> ...and if the client figures out that it has been blacklisted, then it
> >>> does the right thing during the remount (whatever that right thing is).
> >>>
> >>> 2) It's not clear to me who we expect to use this.
> >>>
> >>> Are you targeting applications that do not use file locking? Any that do
> >>> use file locking will probably need some special handling, but those
> >>> that don't might be able to get by unscathed as long as they can deal
> >>> with -EIO on fsync by replaying writes since the last fsync.
> >>>
> >>
> >> Several users said they availability over consistency. For example:
> >> ImageNet training, cephfs is used for storing image files.
> >>
> >>
> >
> > Which sounds reasonable on its face...but why bother with remounting at
> > that point? Why not just have the client reattempt connections until it
> > succeeds (or you forcibly unmount).
> >
> > For that matter, why not just redirty the pages after the writes fail in
> > that case instead of forcing those users to rewrite their data? If they
> > don't care about consistency that much, then that would seem to be a
> > nicer way to deal with this.
> >
>
> I'm not clear about this either

As I've said elsewhere: **how** the client recovers from the lost
session and blacklist event is configurable. There should be a range
of mount options which control the behavior: such as a _hypothetical_
"recover_session=<mode>", where mode may be:

- "brute": re-acquire capabilities and flush all dirty data. All open
file handles continue to work normally. Dangerous and definitely not
the default. (How should file locks be handled?)

- "clean": re-acquire read capabilities and drop dirty write buffers.
Writable file handles return -EIO. Locks are lost and the lock owners
are sent SIGIO, si_code=SI_LOST, si_fd=lockedfd (default is
termination!). Read-only handles continue to work and caches are
dropped if necessary. This should probably be the default.

- "fresh": like "clean" but read-only handles also return -EIO. Not
sure if this one is useful but not difficult to add.

No "-o remount" mount commands necessary.

Now, these details are open for change. I'm just trying to suggest a
way forward. I'm not well versed in how difficult this proposal is to
implement in the kernel. There are probably details or challenges I'm
not considering. I recommend that before Zheng writes new code that he
and Jeff work out what the right semantics and configurations should
be and make a proposal to ceph-devel/dev@ceph.io for user feedback.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
