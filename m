Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9959160686
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Jul 2019 15:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbfGENWi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 5 Jul 2019 09:22:38 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:46544 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbfGENWi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 5 Jul 2019 09:22:38 -0400
Received: by mail-yb1-f195.google.com with SMTP id a5so1549224ybo.13
        for <ceph-devel@vger.kernel.org>; Fri, 05 Jul 2019 06:22:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=IZea0VtDCUVc80s1ojm4N4Nw3vAtmppCqSBmnPE0beI=;
        b=XLXelQmcu6RPauRzxwEob5IsL9G1ydLssj/zi8OHgqOMFf9Y8XFRj6Q4GbCbNc6ec4
         NBwPIkWtBrN1QsBCwkJGjec27RWKTTFAUootzpy3pNaI14UJ5tqpgughwwAixxWB+7Fd
         uBTyGjP/jqgxyWJKPh5Y6ZScAKyH9Bp6Y6qRO1VrejzkJXqbd9RiS41GKeGC7B48/THJ
         g9dR+HXQMy4zYzC8hKXwCRu9LoPl3Iu7KqnN3dxI9Hm5swUhonw5DAeiY8eCruUFCyIq
         k0NEcroIiYbu3ok6Wr3x7LQFW4dkPlYrwD/BnPVMWsoVhAxw0WRLpofzLG+utmWmMxAc
         vR9A==
X-Gm-Message-State: APjAAAUMH51heB59W5hjKIhL9SWs4jhJPH8oxBMLcOzRmiU1j6RoWMgo
        PDfJuSr3965E901HmxaaA0Sp7A==
X-Google-Smtp-Source: APXvYqyqApG+zVQ2mFtH2srzDoBWCzC+rLExluZ6V+yYSIbiDb5LKp1g7FMkIBAsLphrscqwIzkRLQ==
X-Received: by 2002:a25:be82:: with SMTP id i2mr1977795ybk.198.1562332957018;
        Fri, 05 Jul 2019 06:22:37 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-62B.dyn6.twc.com. [2606:a000:1100:37d::62b])
        by smtp.gmail.com with ESMTPSA id w188sm3813270ywc.93.2019.07.05.06.22.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 06:22:36 -0700 (PDT)
Message-ID: <f38b809b01839e3719acebaa3d5d3280eec71b81.camel@redhat.com>
Subject: Re: [PATCH 0/9] ceph: auto reconnect after blacklisted
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Date:   Fri, 05 Jul 2019 09:22:35 -0400
In-Reply-To: <CAAM7YA=4=mC1kOVyWbuZ94xzJTb2M63f72MeyT1EdZxfTtRt+Q@mail.gmail.com>
References: <20190703124442.6614-1-zyan@redhat.com>
         <4bd33f73c9f64e79c0364a22dfdd63db02b4e7ab.camel@redhat.com>
         <1f6359f5-7669-a60b-0a3b-5f74d203af67@redhat.com>
         <a51ccdea2d6cc43ae5dde5c0f150fc754d10158c.camel@redhat.com>
         <CAAM7YAmPrUvP=cnSG33utodvoveuaL5wJCBGrncXbrbEj8bCPg@mail.gmail.com>
         <ec097fd85e1890d904f1dd542b70649b917d4118.camel@redhat.com>
         <CAAM7YA=4=mC1kOVyWbuZ94xzJTb2M63f72MeyT1EdZxfTtRt+Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2019-07-05 at 19:26 +0800, Yan, Zheng wrote:
> On Fri, Jul 5, 2019 at 6:16 PM Jeff Layton <jlayton@redhat.com> wrote:
> > On Fri, 2019-07-05 at 09:17 +0800, Yan, Zheng wrote:
> > > On Thu, Jul 4, 2019 at 10:30 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > On Thu, 2019-07-04 at 09:30 +0800, Yan, Zheng wrote:
> > > > > On 7/4/19 12:01 AM, Jeff Layton wrote:
> > > > > > On Wed, 2019-07-03 at 20:44 +0800, Yan, Zheng wrote:
> > > > > > > This series add support for auto reconnect after blacklisted.
> > > > > > > 
> > > > > > > Auto reconnect is controlled by recover_session=<clean|no> mount option.
> > > > > > > Clean mode is enabled by default. In this mode, client drops dirty date
> > > > > > > and dirty metadata, All writable file handles are invalidated. Read-only
> > > > > > > file handles continue to work and caches are dropped if necessary.
> > > > > > > If an inode contains any lost file lock, read and write are not allowed.
> > > > > > > until all lost file locks are released.
> > > > > > 
> > > > > > Just giving this a quick glance:
> > > > > > 
> > > > > > Based on the last email discussion about this, I thought that you were
> > > > > > going to provide a mount option that someone could enable that would
> > > > > > basically allow the client to "soldier on" in the face of being
> > > > > > blacklisted and then unblacklisted, without needing to remount anything.
> > > > > > 
> > > > > > This set seems to keep the force_reconnect option (patch #7) though, so
> > > > > > I'm quite confused at this point. What exactly is the goal of here?
> > > > > > 
> > > > > 
> > > > > because auto reconnect can be disabled, force_reconnect is the manual
> > > > > way to fix blacklistd mount.
> > > > > 
> > > > 
> > > > Why not instead allow remounting with a different recover_session= mode?
> > > > Then you wouldn't need this option that's only valid during a remount.
> > > > That seems like a more natural way to use a new mount option.
> > > > 
> > > 
> > > you mean something like 'recover_session=now' for remount?
> > > 
> > > 
> > 
> > No, I meant something like:
> > 
> >     -o remount,recover_session=brute
> > 
> 
> This is confusing. user may just want to change auto reconnect mode
> for backlist event in the future, does not want to force reconnect.
> 

Why do we need to allow the admin to manually force a reconnect? If you
(hypothetically) change the mode to "brute" then it should do it on its
own when it detects that it's in this situation, no?

> > IOW, allow the admin to just change the mount to use a different
> > recover_session= mode once things are stuck.
> > 
> > > > > > There's also nothing in the changelogs or comments about
> > > > > > recover_session=brute, which seems like it ought to at least be
> > > > > > mentioned.
> > > > > 
> > > > > brute code is not enabled yet
> > > > 
> > > > Got it -- I missed that that the mount option for it was commented out.
> > > > 
> > > > Given that this is a user interface change, I think it'd be best to not
> > > > merge merge this until it's complete. Otherwise we'll have to deal with
> > > > intermediate kernel versions that don't implement some parts of the new
> > > > interface. That's makes it more difficult for admins to use (and for us
> > > > to document).
> > > > 
> > > > > > At this point, I'm going to say NAK on this set until there is some
> > > > > > accompanying documentation about how you intend for this be used and by
> > > > > > whom. A patch for the mount.ceph(8) manpage would be a good place to
> > > > > > start.
> > > > > > 
> > > > > > > Yan, Zheng (9):
> > > > > > >    libceph: add function that reset client's entity addr
> > > > > > >    libceph: add function that clears osd client's abort_err
> > > > > > >    ceph: allow closing session in restarting/reconnect state
> > > > > > >    ceph: track and report error of async metadata operation
> > > > > > >    ceph: pass filp to ceph_get_caps()
> > > > > > >    ceph: return -EIO if read/write against filp that lost file locks
> > > > > > >    ceph: add 'force_reconnect' option for remount
> > > > > > >    ceph: invalidate all write mode filp after reconnect
> > > > > > >    ceph: auto reconnect after blacklisted
> > > > > > > 
> > > > > > >   fs/ceph/addr.c                  | 30 +++++++----
> > > > > > >   fs/ceph/caps.c                  | 84 ++++++++++++++++++++----------
> > > > > > >   fs/ceph/file.c                  | 50 ++++++++++--------
> > > > > > >   fs/ceph/inode.c                 |  2 +
> > > > > > >   fs/ceph/locks.c                 |  8 ++-
> > > > > > >   fs/ceph/mds_client.c            | 92 ++++++++++++++++++++++++++-------
> > > > > > >   fs/ceph/mds_client.h            |  6 +--
> > > > > > >   fs/ceph/super.c                 | 91 ++++++++++++++++++++++++++++++--
> > > > > > >   fs/ceph/super.h                 | 23 +++++++--
> > > > > > >   include/linux/ceph/libceph.h    |  1 +
> > > > > > >   include/linux/ceph/messenger.h  |  1 +
> > > > > > >   include/linux/ceph/mon_client.h |  1 +
> > > > > > >   include/linux/ceph/osd_client.h |  2 +
> > > > > > >   net/ceph/ceph_common.c          | 38 +++++++++-----
> > > > > > >   net/ceph/messenger.c            |  5 ++
> > > > > > >   net/ceph/mon_client.c           |  7 +++
> > > > > > >   net/ceph/osd_client.c           | 24 +++++++++
> > > > > > >   17 files changed, 365 insertions(+), 100 deletions(-)
> > > > > > > 
> > > > 
> > > > --
> > > > Jeff Layton <jlayton@redhat.com>
> > > > 
> > 
> > --
> > Jeff Layton <jlayton@redhat.com>
> > 

-- 
Jeff Layton <jlayton@redhat.com>

