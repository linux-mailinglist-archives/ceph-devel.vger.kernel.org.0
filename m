Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9268D61DFC
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Jul 2019 13:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729484AbfGHL4A (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Jul 2019 07:56:00 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33061 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbfGHL4A (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 Jul 2019 07:56:00 -0400
Received: by mail-qk1-f195.google.com with SMTP id r6so13033954qkc.0
        for <ceph-devel@vger.kernel.org>; Mon, 08 Jul 2019 04:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yx0fFW9YV8Nf9MI2E+L1nedn3amfwRLnnEkJbIGX49w=;
        b=G4mU94JGZ3EfxnFD5p7vdzzXIag2vo1jV6UaL+vrbvD4MNDqzatfOPHcP3nB6sKsxS
         ORCj4O55qNQX3WwMqLVfrPkbqNJHi4H3NMnjNhULQndnjVKOYIZ2yW6uP/G9V5s/I29L
         kwAWZyaGHfslesUPIYrf/xFVW0cp7RGQtwDxMUUbJMYwNdn+cdtHeMr1GzvWc/E26A+b
         EITgAuyURQZ99UvVXsxzP+4jJhfxTb8cWqCkeTubCDoEXm+AnU0RYn+/1QKN2Rtv/Myz
         tAdn3eaFEnkcT4udIxWXj4v/2uCYqixuDHnF/X6t51LVEIu4vMSVX5h4D4y/dX+ZweGF
         DA4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yx0fFW9YV8Nf9MI2E+L1nedn3amfwRLnnEkJbIGX49w=;
        b=NfneQ8gGvfxgtem/OXoio1FKXeswmLlY8m7lXh/zWjkn6ewDBgCqhdWwqriMiUViDB
         VjUxcnny2FH8wKJUn2TN4DVEeienH6YNM7Sh6lNU+RmUCGav/d/iV1VdxOW84FPk0FbE
         43Vm4ue53QZXHuw1xCuV5AjLpCC9AnPw3cJ7biqHv0k85QDLuIOoF9+z6occDdeb3xcQ
         jSjAtzmWowX2Md5OZteX5q0XG4g8K6qiO9E3MmIfGcCUv4qzoT3FuYyEW4FYOHovigIn
         h2dAtGDxAjcmcBIe/p6Zg+5o8pGvXOmn0SMIFfLMFYWXz8JruwBN90uUxWjQtAqiIQo/
         DwxA==
X-Gm-Message-State: APjAAAWcf0YQ3Bh910ph9iGwt1/VcfTSdNk6jjtLUqma1/R41D/mWOFQ
        ss7PKOEQntcBciGHWjGjxYOy3ClJv4QSmMQdHXY=
X-Google-Smtp-Source: APXvYqzrNpaaxkm76nJBBzTkelLPcRm/2tH3N2v2Jtkga69V6JrvF5G+eCn7CtlM5pg+gjE8ORLc8DPC4MnX0QH3LQw=
X-Received: by 2002:a37:76c5:: with SMTP id r188mr13709198qkc.394.1562586958684;
 Mon, 08 Jul 2019 04:55:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190703124442.6614-1-zyan@redhat.com> <4bd33f73c9f64e79c0364a22dfdd63db02b4e7ab.camel@redhat.com>
 <1f6359f5-7669-a60b-0a3b-5f74d203af67@redhat.com> <a51ccdea2d6cc43ae5dde5c0f150fc754d10158c.camel@redhat.com>
 <CAAM7YAmPrUvP=cnSG33utodvoveuaL5wJCBGrncXbrbEj8bCPg@mail.gmail.com>
 <ec097fd85e1890d904f1dd542b70649b917d4118.camel@redhat.com>
 <CAAM7YA=4=mC1kOVyWbuZ94xzJTb2M63f72MeyT1EdZxfTtRt+Q@mail.gmail.com>
 <f38b809b01839e3719acebaa3d5d3280eec71b81.camel@redhat.com>
 <CAAM7YAk8iEfWDg_ZvJNSkkMQr2ZFxMieZ_oUEZGYwteeH8GpOw@mail.gmail.com>
 <bd9569f6d4c91e3fdda1e86b10372150d0c606fa.camel@redhat.com>
 <CAAM7YAkR5cjLQc4uS-Nsq7vchV76w7WwQqWXsxuJfnDeJswOrA@mail.gmail.com> <f9aba1c6bb58f6cd4d9bce8012be78dadfb5d7bb.camel@redhat.com>
In-Reply-To: <f9aba1c6bb58f6cd4d9bce8012be78dadfb5d7bb.camel@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Mon, 8 Jul 2019 19:55:47 +0800
Message-ID: <CAAM7YAn2tNxwyk1+p9kJppNb8RC4UER3B+BLfD1HBeAMVFDF1g@mail.gmail.com>
Subject: Re: [PATCH 0/9] ceph: auto reconnect after blacklisted
To:     Jeff Layton <jlayton@redhat.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jul 8, 2019 at 7:43 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Mon, 2019-07-08 at 19:34 +0800, Yan, Zheng wrote:
> > On Mon, Jul 8, 2019 at 6:59 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > On Mon, 2019-07-08 at 16:43 +0800, Yan, Zheng wrote:
> > > > On Fri, Jul 5, 2019 at 9:22 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > On Fri, 2019-07-05 at 19:26 +0800, Yan, Zheng wrote:
> > > > > > On Fri, Jul 5, 2019 at 6:16 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > > > On Fri, 2019-07-05 at 09:17 +0800, Yan, Zheng wrote:
> > > > > > > > On Thu, Jul 4, 2019 at 10:30 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > > > > > On Thu, 2019-07-04 at 09:30 +0800, Yan, Zheng wrote:
> > > > > > > > > > On 7/4/19 12:01 AM, Jeff Layton wrote:
> > > > > > > > > > > On Wed, 2019-07-03 at 20:44 +0800, Yan, Zheng wrote:
> > > > > > > > > > > > This series add support for auto reconnect after blacklisted.
> > > > > > > > > > > >
> > > > > > > > > > > > Auto reconnect is controlled by recover_session=<clean|no> mount option.
> > > > > > > > > > > > Clean mode is enabled by default. In this mode, client drops dirty date
> > > > > > > > > > > > and dirty metadata, All writable file handles are invalidated. Read-only
> > > > > > > > > > > > file handles continue to work and caches are dropped if necessary.
> > > > > > > > > > > > If an inode contains any lost file lock, read and write are not allowed.
> > > > > > > > > > > > until all lost file locks are released.
> > > > > > > > > > >
> > > > > > > > > > > Just giving this a quick glance:
> > > > > > > > > > >
> > > > > > > > > > > Based on the last email discussion about this, I thought that you were
> > > > > > > > > > > going to provide a mount option that someone could enable that would
> > > > > > > > > > > basically allow the client to "soldier on" in the face of being
> > > > > > > > > > > blacklisted and then unblacklisted, without needing to remount anything.
> > > > > > > > > > >
> > > > > > > > > > > This set seems to keep the force_reconnect option (patch #7) though, so
> > > > > > > > > > > I'm quite confused at this point. What exactly is the goal of here?
> > > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > because auto reconnect can be disabled, force_reconnect is the manual
> > > > > > > > > > way to fix blacklistd mount.
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > Why not instead allow remounting with a different recover_session= mode?
> > > > > > > > > Then you wouldn't need this option that's only valid during a remount.
> > > > > > > > > That seems like a more natural way to use a new mount option.
> > > > > > > > >
> > > > > > > >
> > > > > > > > you mean something like 'recover_session=now' for remount?
> > > > > > > >
> > > > > > > >
> > > > > > >
> > > > > > > No, I meant something like:
> > > > > > >
> > > > > > >     -o remount,recover_session=brute
> > > > > > >
> > > > > >
> > > > > > This is confusing. user may just want to change auto reconnect mode
> > > > > > for backlist event in the future, does not want to force reconnect.
> > > > > >
> > > > >
> > > > > Why do we need to allow the admin to manually force a reconnect? If you
> > > > > (hypothetically) change the mode to "brute" then it should do it on its
> > > > > own when it detects that it's in this situation, no?
> > > > >
> > > >
> > > > First, auto reconnect is limited to once every 30 seconds. Second,
> > > > client may fail to detect that itself is blacklisted. So I think we
> > > > still need a way to force client to reconnect
> > > >
> > >
> > > How does it detect that it has been blacklisted? Does it do that by
> > > looking at the OSD maps? I'd like to better understand how the client
> > > would recognize this automatically and why it might miss it.
> > >
> >
> > By checking osd request reply and session reject message from mds.
> >
>
> Ok, so is the issue is that the client may become blacklisted and
> unblacklisted before it sends anything to either server?
>

No. The issue is that old version mds does not send session reject
message or no 'error_str=blacklisted' in session reject message.

> > > If we do end up needing some sort of control to forcibly reconnect, then
> > > it seems like we might be better off with something besides a mount
> > > option. sysfs control file maybe?
> > >
> >
> > why
> >
>
> Because mount options are generally there to control the behavior of the
> filesystem at mount time, and not to cue a mount to do some one-shot
> activity. That sort of thing is usually done via other mechanisms
> (sysfs, ioctl, etc.).
>
> > > > > > > IOW, allow the admin to just change the mount to use a different
> > > > > > > recover_session= mode once things are stuck.
> > > > > > >
> > > > > > > > > > > There's also nothing in the changelogs or comments about
> > > > > > > > > > > recover_session=brute, which seems like it ought to at least be
> > > > > > > > > > > mentioned.
> > > > > > > > > >
> > > > > > > > > > brute code is not enabled yet
> > > > > > > > >
> > > > > > > > > Got it -- I missed that that the mount option for it was commented out.
> > > > > > > > >
> > > > > > > > > Given that this is a user interface change, I think it'd be best to not
> > > > > > > > > merge merge this until it's complete. Otherwise we'll have to deal with
> > > > > > > > > intermediate kernel versions that don't implement some parts of the new
> > > > > > > > > interface. That's makes it more difficult for admins to use (and for us
> > > > > > > > > to document).
> > > > > > > > >
> > > > > > > > > > > At this point, I'm going to say NAK on this set until there is some
> > > > > > > > > > > accompanying documentation about how you intend for this be used and by
> > > > > > > > > > > whom. A patch for the mount.ceph(8) manpage would be a good place to
> > > > > > > > > > > start.
> > > > > > > > > > >
> > > > > > > > > > > > Yan, Zheng (9):
> > > > > > > > > > > >    libceph: add function that reset client's entity addr
> > > > > > > > > > > >    libceph: add function that clears osd client's abort_err
> > > > > > > > > > > >    ceph: allow closing session in restarting/reconnect state
> > > > > > > > > > > >    ceph: track and report error of async metadata operation
> > > > > > > > > > > >    ceph: pass filp to ceph_get_caps()
> > > > > > > > > > > >    ceph: return -EIO if read/write against filp that lost file locks
> > > > > > > > > > > >    ceph: add 'force_reconnect' option for remount
> > > > > > > > > > > >    ceph: invalidate all write mode filp after reconnect
> > > > > > > > > > > >    ceph: auto reconnect after blacklisted
> > > > > > > > > > > >
> > > > > > > > > > > >   fs/ceph/addr.c                  | 30 +++++++----
> > > > > > > > > > > >   fs/ceph/caps.c                  | 84 ++++++++++++++++++++----------
> > > > > > > > > > > >   fs/ceph/file.c                  | 50 ++++++++++--------
> > > > > > > > > > > >   fs/ceph/inode.c                 |  2 +
> > > > > > > > > > > >   fs/ceph/locks.c                 |  8 ++-
> > > > > > > > > > > >   fs/ceph/mds_client.c            | 92 ++++++++++++++++++++++++++-------
> > > > > > > > > > > >   fs/ceph/mds_client.h            |  6 +--
> > > > > > > > > > > >   fs/ceph/super.c                 | 91 ++++++++++++++++++++++++++++++--
> > > > > > > > > > > >   fs/ceph/super.h                 | 23 +++++++--
> > > > > > > > > > > >   include/linux/ceph/libceph.h    |  1 +
> > > > > > > > > > > >   include/linux/ceph/messenger.h  |  1 +
> > > > > > > > > > > >   include/linux/ceph/mon_client.h |  1 +
> > > > > > > > > > > >   include/linux/ceph/osd_client.h |  2 +
> > > > > > > > > > > >   net/ceph/ceph_common.c          | 38 +++++++++-----
> > > > > > > > > > > >   net/ceph/messenger.c            |  5 ++
> > > > > > > > > > > >   net/ceph/mon_client.c           |  7 +++
> > > > > > > > > > > >   net/ceph/osd_client.c           | 24 +++++++++
> > > > > > > > > > > >   17 files changed, 365 insertions(+), 100 deletions(-)
> > > > > > > > > > > >
> > > > > > > > >
> > > > > > > > > --
> > > > > > > > > Jeff Layton <jlayton@redhat.com>
> > > > > > > > >
> > > > > > >
> > > > > > > --
> > > > > > > Jeff Layton <jlayton@redhat.com>
> > > > > > >
> > > > >
> > > > > --
> > > > > Jeff Layton <jlayton@redhat.com>
> > > > >
> > >
> > > --
> > > Jeff Layton <jlayton@redhat.com>
> > >
>
> --
> Jeff Layton <jlayton@redhat.com>
>
