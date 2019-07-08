Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E689761DCE
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Jul 2019 13:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbfGHLfJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Jul 2019 07:35:09 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40719 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727591AbfGHLfJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 Jul 2019 07:35:09 -0400
Received: by mail-qt1-f193.google.com with SMTP id a15so17597487qtn.7
        for <ceph-devel@vger.kernel.org>; Mon, 08 Jul 2019 04:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BAMNbB22Zl9FdmVfo0qD594YJ3f9AjvSaRReLve6Uu0=;
        b=If25X1wIQuHwidVoXZnB0MIu11hTEGSrIhRPi2o5BAqQHqJA7MEowE+SWg3VaBdOEh
         PtiM0rc626maM51rUxMsMdRSV1A39yhO/KWBuFYclo1sVTokds8sxRdLIli7yUepPomI
         Mc1j9zo4U3IagzCRHAu9+IFHTwt8hIebE9uxPTfscWBWA/7HT/LqN+1pu+f8023euFLb
         alAobm3WeZuE1j5d/ODG6xWa6TkstPTVKpvy4u5B2qiOWDgCgjQHCs0ywix4BEBk/i0m
         eQJoZZo+onLCt+9m5df+vigKAUPZynn2PcSUnS6jyRurcKsJ187Kr/MDoxtQWYPy/6hU
         XPKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BAMNbB22Zl9FdmVfo0qD594YJ3f9AjvSaRReLve6Uu0=;
        b=rk/GBLSqgHGuWisrJdQ3tGoxaZZCDC+tTfe4yNjG6LzaI+XSWNhXky59Rk70I6mVF+
         Sxdk442Q6lFiK41IJp3Lq947CBVfuIWZh884fONjo5z1sF3cdbjJG4RZnLTXzrx+M4mE
         jP93CeEi6BG4IrwPZfrAUBjOkiPE+4P8x0viepyvkBdq3PGHKnrQEjx6xPCzfQb0Fcjn
         Xw3NCxoifftytMRShDB/nSfV4DJrCVa6ColEV3hiP3r6Lm0YFIoAHLXZ7DcvLCq+V6nP
         lnWkdLJUHnHaj//oJC0kmF9r847LFduzMgwhnNc2a2EV+N4tvT6nD8Xxx+bJ9Fl4gz6Y
         Awcg==
X-Gm-Message-State: APjAAAUpbFOE787zXYhZby05xgTBde3iHjmg3OrC3nC2xwKMh0DXVvix
        XBWNslRQ5giJIRaNzcghsN2Bp/eCu7Cj8DBaeRI=
X-Google-Smtp-Source: APXvYqyKXwmuKMWEBUAjgln4lggmYCBWehdPxeAMhOxq0FjwsNrMRogEMbdX2OaJeQVVIMbdJSl7W0dpqo/h9atEO4Q=
X-Received: by 2002:a0c:8705:: with SMTP id 5mr14241549qvh.32.1562585707840;
 Mon, 08 Jul 2019 04:35:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190703124442.6614-1-zyan@redhat.com> <4bd33f73c9f64e79c0364a22dfdd63db02b4e7ab.camel@redhat.com>
 <1f6359f5-7669-a60b-0a3b-5f74d203af67@redhat.com> <a51ccdea2d6cc43ae5dde5c0f150fc754d10158c.camel@redhat.com>
 <CAAM7YAmPrUvP=cnSG33utodvoveuaL5wJCBGrncXbrbEj8bCPg@mail.gmail.com>
 <ec097fd85e1890d904f1dd542b70649b917d4118.camel@redhat.com>
 <CAAM7YA=4=mC1kOVyWbuZ94xzJTb2M63f72MeyT1EdZxfTtRt+Q@mail.gmail.com>
 <f38b809b01839e3719acebaa3d5d3280eec71b81.camel@redhat.com>
 <CAAM7YAk8iEfWDg_ZvJNSkkMQr2ZFxMieZ_oUEZGYwteeH8GpOw@mail.gmail.com> <bd9569f6d4c91e3fdda1e86b10372150d0c606fa.camel@redhat.com>
In-Reply-To: <bd9569f6d4c91e3fdda1e86b10372150d0c606fa.camel@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Mon, 8 Jul 2019 19:34:56 +0800
Message-ID: <CAAM7YAkR5cjLQc4uS-Nsq7vchV76w7WwQqWXsxuJfnDeJswOrA@mail.gmail.com>
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

On Mon, Jul 8, 2019 at 6:59 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Mon, 2019-07-08 at 16:43 +0800, Yan, Zheng wrote:
> > On Fri, Jul 5, 2019 at 9:22 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > On Fri, 2019-07-05 at 19:26 +0800, Yan, Zheng wrote:
> > > > On Fri, Jul 5, 2019 at 6:16 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > On Fri, 2019-07-05 at 09:17 +0800, Yan, Zheng wrote:
> > > > > > On Thu, Jul 4, 2019 at 10:30 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > > > On Thu, 2019-07-04 at 09:30 +0800, Yan, Zheng wrote:
> > > > > > > > On 7/4/19 12:01 AM, Jeff Layton wrote:
> > > > > > > > > On Wed, 2019-07-03 at 20:44 +0800, Yan, Zheng wrote:
> > > > > > > > > > This series add support for auto reconnect after blacklisted.
> > > > > > > > > >
> > > > > > > > > > Auto reconnect is controlled by recover_session=<clean|no> mount option.
> > > > > > > > > > Clean mode is enabled by default. In this mode, client drops dirty date
> > > > > > > > > > and dirty metadata, All writable file handles are invalidated. Read-only
> > > > > > > > > > file handles continue to work and caches are dropped if necessary.
> > > > > > > > > > If an inode contains any lost file lock, read and write are not allowed.
> > > > > > > > > > until all lost file locks are released.
> > > > > > > > >
> > > > > > > > > Just giving this a quick glance:
> > > > > > > > >
> > > > > > > > > Based on the last email discussion about this, I thought that you were
> > > > > > > > > going to provide a mount option that someone could enable that would
> > > > > > > > > basically allow the client to "soldier on" in the face of being
> > > > > > > > > blacklisted and then unblacklisted, without needing to remount anything.
> > > > > > > > >
> > > > > > > > > This set seems to keep the force_reconnect option (patch #7) though, so
> > > > > > > > > I'm quite confused at this point. What exactly is the goal of here?
> > > > > > > > >
> > > > > > > >
> > > > > > > > because auto reconnect can be disabled, force_reconnect is the manual
> > > > > > > > way to fix blacklistd mount.
> > > > > > > >
> > > > > > >
> > > > > > > Why not instead allow remounting with a different recover_session= mode?
> > > > > > > Then you wouldn't need this option that's only valid during a remount.
> > > > > > > That seems like a more natural way to use a new mount option.
> > > > > > >
> > > > > >
> > > > > > you mean something like 'recover_session=now' for remount?
> > > > > >
> > > > > >
> > > > >
> > > > > No, I meant something like:
> > > > >
> > > > >     -o remount,recover_session=brute
> > > > >
> > > >
> > > > This is confusing. user may just want to change auto reconnect mode
> > > > for backlist event in the future, does not want to force reconnect.
> > > >
> > >
> > > Why do we need to allow the admin to manually force a reconnect? If you
> > > (hypothetically) change the mode to "brute" then it should do it on its
> > > own when it detects that it's in this situation, no?
> > >
> >
> > First, auto reconnect is limited to once every 30 seconds. Second,
> > client may fail to detect that itself is blacklisted. So I think we
> > still need a way to force client to reconnect
> >
>
> How does it detect that it has been blacklisted? Does it do that by
> looking at the OSD maps? I'd like to better understand how the client
> would recognize this automatically and why it might miss it.
>

By checking osd request reply and session reject message from mds.

> If we do end up needing some sort of control to forcibly reconnect, then
> it seems like we might be better off with something besides a mount
> option. sysfs control file maybe?
>

why

> > > > > IOW, allow the admin to just change the mount to use a different
> > > > > recover_session= mode once things are stuck.
> > > > >
> > > > > > > > > There's also nothing in the changelogs or comments about
> > > > > > > > > recover_session=brute, which seems like it ought to at least be
> > > > > > > > > mentioned.
> > > > > > > >
> > > > > > > > brute code is not enabled yet
> > > > > > >
> > > > > > > Got it -- I missed that that the mount option for it was commented out.
> > > > > > >
> > > > > > > Given that this is a user interface change, I think it'd be best to not
> > > > > > > merge merge this until it's complete. Otherwise we'll have to deal with
> > > > > > > intermediate kernel versions that don't implement some parts of the new
> > > > > > > interface. That's makes it more difficult for admins to use (and for us
> > > > > > > to document).
> > > > > > >
> > > > > > > > > At this point, I'm going to say NAK on this set until there is some
> > > > > > > > > accompanying documentation about how you intend for this be used and by
> > > > > > > > > whom. A patch for the mount.ceph(8) manpage would be a good place to
> > > > > > > > > start.
> > > > > > > > >
> > > > > > > > > > Yan, Zheng (9):
> > > > > > > > > >    libceph: add function that reset client's entity addr
> > > > > > > > > >    libceph: add function that clears osd client's abort_err
> > > > > > > > > >    ceph: allow closing session in restarting/reconnect state
> > > > > > > > > >    ceph: track and report error of async metadata operation
> > > > > > > > > >    ceph: pass filp to ceph_get_caps()
> > > > > > > > > >    ceph: return -EIO if read/write against filp that lost file locks
> > > > > > > > > >    ceph: add 'force_reconnect' option for remount
> > > > > > > > > >    ceph: invalidate all write mode filp after reconnect
> > > > > > > > > >    ceph: auto reconnect after blacklisted
> > > > > > > > > >
> > > > > > > > > >   fs/ceph/addr.c                  | 30 +++++++----
> > > > > > > > > >   fs/ceph/caps.c                  | 84 ++++++++++++++++++++----------
> > > > > > > > > >   fs/ceph/file.c                  | 50 ++++++++++--------
> > > > > > > > > >   fs/ceph/inode.c                 |  2 +
> > > > > > > > > >   fs/ceph/locks.c                 |  8 ++-
> > > > > > > > > >   fs/ceph/mds_client.c            | 92 ++++++++++++++++++++++++++-------
> > > > > > > > > >   fs/ceph/mds_client.h            |  6 +--
> > > > > > > > > >   fs/ceph/super.c                 | 91 ++++++++++++++++++++++++++++++--
> > > > > > > > > >   fs/ceph/super.h                 | 23 +++++++--
> > > > > > > > > >   include/linux/ceph/libceph.h    |  1 +
> > > > > > > > > >   include/linux/ceph/messenger.h  |  1 +
> > > > > > > > > >   include/linux/ceph/mon_client.h |  1 +
> > > > > > > > > >   include/linux/ceph/osd_client.h |  2 +
> > > > > > > > > >   net/ceph/ceph_common.c          | 38 +++++++++-----
> > > > > > > > > >   net/ceph/messenger.c            |  5 ++
> > > > > > > > > >   net/ceph/mon_client.c           |  7 +++
> > > > > > > > > >   net/ceph/osd_client.c           | 24 +++++++++
> > > > > > > > > >   17 files changed, 365 insertions(+), 100 deletions(-)
> > > > > > > > > >
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
