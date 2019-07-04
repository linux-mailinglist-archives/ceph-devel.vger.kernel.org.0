Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 430245FA0B
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Jul 2019 16:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfGDO0o (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 Jul 2019 10:26:44 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:41113 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727495AbfGDO0o (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 Jul 2019 10:26:44 -0400
Received: by mail-yw1-f68.google.com with SMTP id i138so701940ywg.8
        for <ceph-devel@vger.kernel.org>; Thu, 04 Jul 2019 07:26:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=uz/8xE1futFD8WQ+NYbuIh3ZyeXbgQecGPvI/O4kpZw=;
        b=UjduBvOCeIWCx/v8vip/U9AoC1sLiMqc0D2U7pwvH+T6WD0aNjmegyLbD1VhyXy3/c
         Zjtl9tD8w3uBeGcDhieeA/O9brZ03OrzTlqU36EjkVcQmLBGHa5MarurxBI9qq8R9tgC
         3dhVcJx7byaVoPRd1WSnoB1YLe2wHDBm7kNIjU44KHxD3HD3B/8crQ2mhZDtlKXvjw3U
         9DnbKzb1SeUMpS19dMe4YHnPK/zIRavhZRBVt4HcCXWHfYzMQtgOfGDVC5t1FFf4/dKQ
         cJ+iSO2UeicWpervS7YqDnTPbgT5n70e1Eat3QxYGu5PeSdEM7l9BUDUHd/Yce8GBf5G
         BRxA==
X-Gm-Message-State: APjAAAXAJWd0kzFAW/4aFG4GSb60YuDHnri22l9FQYVcnlNZzSmkQOpd
        EaJ3eB/inqUXdwKoGdD086AZzg==
X-Google-Smtp-Source: APXvYqyW+l4wj31JOqYu6B2b4sLwdw0WkF0wcQyDXmwrW5tBT0QiQMc8LVOG64Lj/h2dn3+pWDQwkQ==
X-Received: by 2002:a81:9291:: with SMTP id j139mr25778072ywg.168.1562250403574;
        Thu, 04 Jul 2019 07:26:43 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-62B.dyn6.twc.com. [2606:a000:1100:37d::62b])
        by smtp.gmail.com with ESMTPSA id x199sm2555284ywd.99.2019.07.04.07.26.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 07:26:42 -0700 (PDT)
Message-ID: <a51ccdea2d6cc43ae5dde5c0f150fc754d10158c.camel@redhat.com>
Subject: Re: [PATCH 0/9] ceph: auto reconnect after blacklisted
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
Date:   Thu, 04 Jul 2019 10:26:41 -0400
In-Reply-To: <1f6359f5-7669-a60b-0a3b-5f74d203af67@redhat.com>
References: <20190703124442.6614-1-zyan@redhat.com>
         <4bd33f73c9f64e79c0364a22dfdd63db02b4e7ab.camel@redhat.com>
         <1f6359f5-7669-a60b-0a3b-5f74d203af67@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-07-04 at 09:30 +0800, Yan, Zheng wrote:
> On 7/4/19 12:01 AM, Jeff Layton wrote:
> > On Wed, 2019-07-03 at 20:44 +0800, Yan, Zheng wrote:
> > > This series add support for auto reconnect after blacklisted.
> > > 
> > > Auto reconnect is controlled by recover_session=<clean|no> mount option.
> > > Clean mode is enabled by default. In this mode, client drops dirty date
> > > and dirty metadata, All writable file handles are invalidated. Read-only
> > > file handles continue to work and caches are dropped if necessary.
> > > If an inode contains any lost file lock, read and write are not allowed.
> > > until all lost file locks are released.
> > 
> > Just giving this a quick glance:
> > 
> > Based on the last email discussion about this, I thought that you were
> > going to provide a mount option that someone could enable that would
> > basically allow the client to "soldier on" in the face of being
> > blacklisted and then unblacklisted, without needing to remount anything.
> > 
> > This set seems to keep the force_reconnect option (patch #7) though, so
> > I'm quite confused at this point. What exactly is the goal of here?
> > 
> 
> because auto reconnect can be disabled, force_reconnect is the manual 
> way to fix blacklistd mount.
> 

Why not instead allow remounting with a different recover_session= mode?
Then you wouldn't need this option that's only valid during a remount.
That seems like a more natural way to use a new mount option.

> > There's also nothing in the changelogs or comments about
> > recover_session=brute, which seems like it ought to at least be
> > mentioned.
> 
> brute code is not enabled yet

Got it -- I missed that that the mount option for it was commented out.

Given that this is a user interface change, I think it'd be best to not
merge merge this until it's complete. Otherwise we'll have to deal with
intermediate kernel versions that don't implement some parts of the new
interface. That's makes it more difficult for admins to use (and for us
to document).

> > At this point, I'm going to say NAK on this set until there is some
> > accompanying documentation about how you intend for this be used and by
> > whom. A patch for the mount.ceph(8) manpage would be a good place to
> > start.
> > 
> > > Yan, Zheng (9):
> > >    libceph: add function that reset client's entity addr
> > >    libceph: add function that clears osd client's abort_err
> > >    ceph: allow closing session in restarting/reconnect state
> > >    ceph: track and report error of async metadata operation
> > >    ceph: pass filp to ceph_get_caps()
> > >    ceph: return -EIO if read/write against filp that lost file locks
> > >    ceph: add 'force_reconnect' option for remount
> > >    ceph: invalidate all write mode filp after reconnect
> > >    ceph: auto reconnect after blacklisted
> > > 
> > >   fs/ceph/addr.c                  | 30 +++++++----
> > >   fs/ceph/caps.c                  | 84 ++++++++++++++++++++----------
> > >   fs/ceph/file.c                  | 50 ++++++++++--------
> > >   fs/ceph/inode.c                 |  2 +
> > >   fs/ceph/locks.c                 |  8 ++-
> > >   fs/ceph/mds_client.c            | 92 ++++++++++++++++++++++++++-------
> > >   fs/ceph/mds_client.h            |  6 +--
> > >   fs/ceph/super.c                 | 91 ++++++++++++++++++++++++++++++--
> > >   fs/ceph/super.h                 | 23 +++++++--
> > >   include/linux/ceph/libceph.h    |  1 +
> > >   include/linux/ceph/messenger.h  |  1 +
> > >   include/linux/ceph/mon_client.h |  1 +
> > >   include/linux/ceph/osd_client.h |  2 +
> > >   net/ceph/ceph_common.c          | 38 +++++++++-----
> > >   net/ceph/messenger.c            |  5 ++
> > >   net/ceph/mon_client.c           |  7 +++
> > >   net/ceph/osd_client.c           | 24 +++++++++
> > >   17 files changed, 365 insertions(+), 100 deletions(-)
> > > 

-- 
Jeff Layton <jlayton@redhat.com>

