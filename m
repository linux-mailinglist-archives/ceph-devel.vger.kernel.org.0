Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9CB61BD5
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Jul 2019 10:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbfGHIoE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Jul 2019 04:44:04 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35651 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727189AbfGHIoD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 Jul 2019 04:44:03 -0400
Received: by mail-qt1-f194.google.com with SMTP id d23so17273279qto.2
        for <ceph-devel@vger.kernel.org>; Mon, 08 Jul 2019 01:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s2r1Nq8gxmb2vAlafP/sTuqhF6066e1v8QMxd9X73ks=;
        b=Uh2XdG8dIW1+MxyJeR7Ojj/l3/ukBKX6+AiDP1D6PdECE813n1NYh3bIijDT8Sl+DJ
         C5/N3TSNuY053sthpGRLPdkR4SS00J2GuB7yKsNBdRLRKNMxAQjcgUiDdD6uvCC2jHfI
         JRQghs189TimZZzzukVpACUxkhmriKw2GTKdzTtznodRxEMv448+ywf5f/SnPN534+KR
         kwQGsvyf8aa6oqcewhW9Rs/XXMQqUmtfDTPLUR/R8qREtz2+brUa0kbSK4t9N4A+PtXL
         yOgzTMaMurkPBAq3KmUmohqsQsZ7BjM6JL6woav49FodHBcRru/2S5dKm7kjRQC/NU8s
         gEXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s2r1Nq8gxmb2vAlafP/sTuqhF6066e1v8QMxd9X73ks=;
        b=XS4+XdzVOdQpSE6SbtOtZPzBgeh71h2YxiywzHC5AmyxVFpdDl8YkbbUh915ZBcwid
         42C6WtBcE4cLAtm7NtaadqVAdGHaF0AjyPqAzY7GKKZI1wIzWAj80CBZLyE69qJnWb9r
         ltXm5pP7gXkBEG+DqNm6NSTVlh9TKJVAbnhs1OSF2nRCDNhYVEZHd8+OSPgu/XsJXOF+
         9ExbzhijXVBvUpxthC90PtqqPp0H7xtDuOBw8uzM81JhHY4jm8F0QllMixImSsDUfc65
         qoaEpuJgQtaZU/xHCWsjcj8QZGkMLTmGS5owY0ECwvZaGOOos8pPCfCsdjHnAhV5Tt0W
         iYZA==
X-Gm-Message-State: APjAAAWXPI21utZxfvDZ2kXo9Jl1sSmlPXFf6CF3N4kNZOnUXijvyTVi
        JHQiz8H0jaATqZkKZ9BSlPRX03oVs1oytBcmW+4=
X-Google-Smtp-Source: APXvYqyo6tZ4HXruQVbXqjKrYN6QLj0JiRqiRHShFJS11X616i5nRHrfTCAfCbiA31VlLPqODY+HSTK3ngMKm2k5M5Y=
X-Received: by 2002:ac8:3637:: with SMTP id m52mr13028038qtb.238.1562575442536;
 Mon, 08 Jul 2019 01:44:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190703124442.6614-1-zyan@redhat.com> <4bd33f73c9f64e79c0364a22dfdd63db02b4e7ab.camel@redhat.com>
 <1f6359f5-7669-a60b-0a3b-5f74d203af67@redhat.com> <a51ccdea2d6cc43ae5dde5c0f150fc754d10158c.camel@redhat.com>
 <CAAM7YAmPrUvP=cnSG33utodvoveuaL5wJCBGrncXbrbEj8bCPg@mail.gmail.com>
 <ec097fd85e1890d904f1dd542b70649b917d4118.camel@redhat.com>
 <CAAM7YA=4=mC1kOVyWbuZ94xzJTb2M63f72MeyT1EdZxfTtRt+Q@mail.gmail.com> <f38b809b01839e3719acebaa3d5d3280eec71b81.camel@redhat.com>
In-Reply-To: <f38b809b01839e3719acebaa3d5d3280eec71b81.camel@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Mon, 8 Jul 2019 16:43:50 +0800
Message-ID: <CAAM7YAk8iEfWDg_ZvJNSkkMQr2ZFxMieZ_oUEZGYwteeH8GpOw@mail.gmail.com>
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

On Fri, Jul 5, 2019 at 9:22 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Fri, 2019-07-05 at 19:26 +0800, Yan, Zheng wrote:
> > On Fri, Jul 5, 2019 at 6:16 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > On Fri, 2019-07-05 at 09:17 +0800, Yan, Zheng wrote:
> > > > On Thu, Jul 4, 2019 at 10:30 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > On Thu, 2019-07-04 at 09:30 +0800, Yan, Zheng wrote:
> > > > > > On 7/4/19 12:01 AM, Jeff Layton wrote:
> > > > > > > On Wed, 2019-07-03 at 20:44 +0800, Yan, Zheng wrote:
> > > > > > > > This series add support for auto reconnect after blacklisted.
> > > > > > > >
> > > > > > > > Auto reconnect is controlled by recover_session=<clean|no> mount option.
> > > > > > > > Clean mode is enabled by default. In this mode, client drops dirty date
> > > > > > > > and dirty metadata, All writable file handles are invalidated. Read-only
> > > > > > > > file handles continue to work and caches are dropped if necessary.
> > > > > > > > If an inode contains any lost file lock, read and write are not allowed.
> > > > > > > > until all lost file locks are released.
> > > > > > >
> > > > > > > Just giving this a quick glance:
> > > > > > >
> > > > > > > Based on the last email discussion about this, I thought that you were
> > > > > > > going to provide a mount option that someone could enable that would
> > > > > > > basically allow the client to "soldier on" in the face of being
> > > > > > > blacklisted and then unblacklisted, without needing to remount anything.
> > > > > > >
> > > > > > > This set seems to keep the force_reconnect option (patch #7) though, so
> > > > > > > I'm quite confused at this point. What exactly is the goal of here?
> > > > > > >
> > > > > >
> > > > > > because auto reconnect can be disabled, force_reconnect is the manual
> > > > > > way to fix blacklistd mount.
> > > > > >
> > > > >
> > > > > Why not instead allow remounting with a different recover_session= mode?
> > > > > Then you wouldn't need this option that's only valid during a remount.
> > > > > That seems like a more natural way to use a new mount option.
> > > > >
> > > >
> > > > you mean something like 'recover_session=now' for remount?
> > > >
> > > >
> > >
> > > No, I meant something like:
> > >
> > >     -o remount,recover_session=brute
> > >
> >
> > This is confusing. user may just want to change auto reconnect mode
> > for backlist event in the future, does not want to force reconnect.
> >
>
> Why do we need to allow the admin to manually force a reconnect? If you
> (hypothetically) change the mode to "brute" then it should do it on its
> own when it detects that it's in this situation, no?
>

First, auto reconnect is limited to once every 30 seconds. Second,
client may fail to detect that itself is blacklisted. So I think we
still need a way to force client to reconnect

> > > IOW, allow the admin to just change the mount to use a different
> > > recover_session= mode once things are stuck.
> > >
> > > > > > > There's also nothing in the changelogs or comments about
> > > > > > > recover_session=brute, which seems like it ought to at least be
> > > > > > > mentioned.
> > > > > >
> > > > > > brute code is not enabled yet
> > > > >
> > > > > Got it -- I missed that that the mount option for it was commented out.
> > > > >
> > > > > Given that this is a user interface change, I think it'd be best to not
> > > > > merge merge this until it's complete. Otherwise we'll have to deal with
> > > > > intermediate kernel versions that don't implement some parts of the new
> > > > > interface. That's makes it more difficult for admins to use (and for us
> > > > > to document).
> > > > >
> > > > > > > At this point, I'm going to say NAK on this set until there is some
> > > > > > > accompanying documentation about how you intend for this be used and by
> > > > > > > whom. A patch for the mount.ceph(8) manpage would be a good place to
> > > > > > > start.
> > > > > > >
> > > > > > > > Yan, Zheng (9):
> > > > > > > >    libceph: add function that reset client's entity addr
> > > > > > > >    libceph: add function that clears osd client's abort_err
> > > > > > > >    ceph: allow closing session in restarting/reconnect state
> > > > > > > >    ceph: track and report error of async metadata operation
> > > > > > > >    ceph: pass filp to ceph_get_caps()
> > > > > > > >    ceph: return -EIO if read/write against filp that lost file locks
> > > > > > > >    ceph: add 'force_reconnect' option for remount
> > > > > > > >    ceph: invalidate all write mode filp after reconnect
> > > > > > > >    ceph: auto reconnect after blacklisted
> > > > > > > >
> > > > > > > >   fs/ceph/addr.c                  | 30 +++++++----
> > > > > > > >   fs/ceph/caps.c                  | 84 ++++++++++++++++++++----------
> > > > > > > >   fs/ceph/file.c                  | 50 ++++++++++--------
> > > > > > > >   fs/ceph/inode.c                 |  2 +
> > > > > > > >   fs/ceph/locks.c                 |  8 ++-
> > > > > > > >   fs/ceph/mds_client.c            | 92 ++++++++++++++++++++++++++-------
> > > > > > > >   fs/ceph/mds_client.h            |  6 +--
> > > > > > > >   fs/ceph/super.c                 | 91 ++++++++++++++++++++++++++++++--
> > > > > > > >   fs/ceph/super.h                 | 23 +++++++--
> > > > > > > >   include/linux/ceph/libceph.h    |  1 +
> > > > > > > >   include/linux/ceph/messenger.h  |  1 +
> > > > > > > >   include/linux/ceph/mon_client.h |  1 +
> > > > > > > >   include/linux/ceph/osd_client.h |  2 +
> > > > > > > >   net/ceph/ceph_common.c          | 38 +++++++++-----
> > > > > > > >   net/ceph/messenger.c            |  5 ++
> > > > > > > >   net/ceph/mon_client.c           |  7 +++
> > > > > > > >   net/ceph/osd_client.c           | 24 +++++++++
> > > > > > > >   17 files changed, 365 insertions(+), 100 deletions(-)
> > > > > > > >
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
