Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC985FF48
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Jul 2019 03:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfGEBSD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 Jul 2019 21:18:03 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35152 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbfGEBSD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 Jul 2019 21:18:03 -0400
Received: by mail-qt1-f195.google.com with SMTP id d23so9688267qto.2
        for <ceph-devel@vger.kernel.org>; Thu, 04 Jul 2019 18:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PPC35FYySUaooGYDMmbPCWnxHOndSx3eCuqrE/ZXFsk=;
        b=l3Zf3mYDG+0T15XU1X6472hTtGQ+WD6YWM4QW65LA7Cw5zxLIkd4TX8eAmwLyoGOQA
         pSpNW2uKR/7VyrCPqBOoHtQT5dPCDPwgyPOzCQcPlCMy7ebQj8/XWtvaLhK38g5UL0Cx
         25Bp9MoCKBOPEloctLaHhXK1Gh24NXp06CADR+G29myzKol92vyf7z1JNq56h6tcHt+X
         hv03D1c38F0yuLUZCq3GytTAzInqyR8A4HXzaS2fh8ZzyCEfHzwalYEpH8ob66Ptg9Cp
         H2tPINP/RFqXgpCQKYrzBSG0mTS99cfSvIALnQyMOKYZsXD5mrSw1Dmv7xrPdY67veMa
         Uvwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PPC35FYySUaooGYDMmbPCWnxHOndSx3eCuqrE/ZXFsk=;
        b=iHEMQQgTPQqQDJC8XPPgv/XgGtOiuRTp26FEyH/rgXcEvkwxZ5aKMRRi3EK0Bxdxsy
         YkJp9eZSQBl8nUx1RxLaPfu7JnJMeaG017cPJ0N8gLQxtJ0UXcPRa8HwgE00J2RaU/9z
         qWIU6ixSMrryD6U17ZwqSWjXcG5ZUptMxaUS9nsPsmMRGwBm4vVl2VCmDxdpU2mSj+sX
         lu74ZGb8M3dhZCOdU1dfVJ+l31zFl+vy4jGjtcj0OYDrEoRZaCR85Xi6j/VkeqAb1i+O
         N2L0+kBdxDX2bVxqheHp/cyIN8rDBOvDq8RTJ+0lYI5OeY7YsOmV55wB7B2bz/asjy2d
         WW9A==
X-Gm-Message-State: APjAAAUuCiUAVJ50VD4geW0q9qendtD8RhCoX7zoyGQXSj0+tQ0Oi2FG
        UQsIQn8PLvAEc+HrRhkdMj6FMMcnZV+BnEiU7Hy8ZvwDpH0q6w==
X-Google-Smtp-Source: APXvYqxTp3x1JtUjl8gstldeC8uBs+a9EodrSrSJgT2cgzjrfQVAyIOnpP2B1yKCoCmJGsYdeA1N09XZhEiOnxwuBig=
X-Received: by 2002:a0c:9916:: with SMTP id h22mr967697qvd.95.1562289482031;
 Thu, 04 Jul 2019 18:18:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190703124442.6614-1-zyan@redhat.com> <4bd33f73c9f64e79c0364a22dfdd63db02b4e7ab.camel@redhat.com>
 <1f6359f5-7669-a60b-0a3b-5f74d203af67@redhat.com> <a51ccdea2d6cc43ae5dde5c0f150fc754d10158c.camel@redhat.com>
In-Reply-To: <a51ccdea2d6cc43ae5dde5c0f150fc754d10158c.camel@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Fri, 5 Jul 2019 09:17:50 +0800
Message-ID: <CAAM7YAmPrUvP=cnSG33utodvoveuaL5wJCBGrncXbrbEj8bCPg@mail.gmail.com>
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

On Thu, Jul 4, 2019 at 10:30 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Thu, 2019-07-04 at 09:30 +0800, Yan, Zheng wrote:
> > On 7/4/19 12:01 AM, Jeff Layton wrote:
> > > On Wed, 2019-07-03 at 20:44 +0800, Yan, Zheng wrote:
> > > > This series add support for auto reconnect after blacklisted.
> > > >
> > > > Auto reconnect is controlled by recover_session=<clean|no> mount option.
> > > > Clean mode is enabled by default. In this mode, client drops dirty date
> > > > and dirty metadata, All writable file handles are invalidated. Read-only
> > > > file handles continue to work and caches are dropped if necessary.
> > > > If an inode contains any lost file lock, read and write are not allowed.
> > > > until all lost file locks are released.
> > >
> > > Just giving this a quick glance:
> > >
> > > Based on the last email discussion about this, I thought that you were
> > > going to provide a mount option that someone could enable that would
> > > basically allow the client to "soldier on" in the face of being
> > > blacklisted and then unblacklisted, without needing to remount anything.
> > >
> > > This set seems to keep the force_reconnect option (patch #7) though, so
> > > I'm quite confused at this point. What exactly is the goal of here?
> > >
> >
> > because auto reconnect can be disabled, force_reconnect is the manual
> > way to fix blacklistd mount.
> >
>
> Why not instead allow remounting with a different recover_session= mode?
> Then you wouldn't need this option that's only valid during a remount.
> That seems like a more natural way to use a new mount option.
>

you mean something like 'recover_session=now' for remount?


> > > There's also nothing in the changelogs or comments about
> > > recover_session=brute, which seems like it ought to at least be
> > > mentioned.
> >
> > brute code is not enabled yet
>
> Got it -- I missed that that the mount option for it was commented out.
>
> Given that this is a user interface change, I think it'd be best to not
> merge merge this until it's complete. Otherwise we'll have to deal with
> intermediate kernel versions that don't implement some parts of the new
> interface. That's makes it more difficult for admins to use (and for us
> to document).
>
> > > At this point, I'm going to say NAK on this set until there is some
> > > accompanying documentation about how you intend for this be used and by
> > > whom. A patch for the mount.ceph(8) manpage would be a good place to
> > > start.
> > >
> > > > Yan, Zheng (9):
> > > >    libceph: add function that reset client's entity addr
> > > >    libceph: add function that clears osd client's abort_err
> > > >    ceph: allow closing session in restarting/reconnect state
> > > >    ceph: track and report error of async metadata operation
> > > >    ceph: pass filp to ceph_get_caps()
> > > >    ceph: return -EIO if read/write against filp that lost file locks
> > > >    ceph: add 'force_reconnect' option for remount
> > > >    ceph: invalidate all write mode filp after reconnect
> > > >    ceph: auto reconnect after blacklisted
> > > >
> > > >   fs/ceph/addr.c                  | 30 +++++++----
> > > >   fs/ceph/caps.c                  | 84 ++++++++++++++++++++----------
> > > >   fs/ceph/file.c                  | 50 ++++++++++--------
> > > >   fs/ceph/inode.c                 |  2 +
> > > >   fs/ceph/locks.c                 |  8 ++-
> > > >   fs/ceph/mds_client.c            | 92 ++++++++++++++++++++++++++-------
> > > >   fs/ceph/mds_client.h            |  6 +--
> > > >   fs/ceph/super.c                 | 91 ++++++++++++++++++++++++++++++--
> > > >   fs/ceph/super.h                 | 23 +++++++--
> > > >   include/linux/ceph/libceph.h    |  1 +
> > > >   include/linux/ceph/messenger.h  |  1 +
> > > >   include/linux/ceph/mon_client.h |  1 +
> > > >   include/linux/ceph/osd_client.h |  2 +
> > > >   net/ceph/ceph_common.c          | 38 +++++++++-----
> > > >   net/ceph/messenger.c            |  5 ++
> > > >   net/ceph/mon_client.c           |  7 +++
> > > >   net/ceph/osd_client.c           | 24 +++++++++
> > > >   17 files changed, 365 insertions(+), 100 deletions(-)
> > > >
>
> --
> Jeff Layton <jlayton@redhat.com>
>
