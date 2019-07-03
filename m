Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F01965ECBD
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 21:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfGCTZl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 15:25:41 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41064 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfGCTZl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Jul 2019 15:25:41 -0400
Received: by mail-qt1-f195.google.com with SMTP id d17so3843566qtj.8
        for <ceph-devel@vger.kernel.org>; Wed, 03 Jul 2019 12:25:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=MICtZ6ic7Wpuw9cnplExhnuomlJuHSVGy++/0Wgkmi0=;
        b=pFHp6gzCNQkMk3e9TzwH3exGauqZOmNkxAfnb8AdYDW3frYeRF3dkiFVxFjW4v8zt3
         eQe9320WVmgVd7zUKj7+Lr7Fy9hX+chB43A2zzFRgk1gkGBqQCWWrxzRfGk7FbawTxkl
         /J/XiXG5nvg4LtoPWVF58YxDGXV2se7zo5u3GRsJK2TlpzGLcDy9u1AMVibiH3+bY4Ov
         WpcMbsqJR4hqYqCGPAwWMLCsMXUYA8mJyM29QGbbxs157LxIuS7FVgLzl5kxhCNrGMT2
         Xay5NUptLPcV4mdu51ycdST/ffUmFf67s6BeSwnxWqu0JgZUaxS4H3GhONb7gEPGtvUo
         4K+A==
X-Gm-Message-State: APjAAAUYLCl+kFUWevvijHOxE1bTFms94kiSfkZ0Wth2XmbJf59GF+jk
        J54SwfUkw8PtJZjNBatS6SuoVQ==
X-Google-Smtp-Source: APXvYqwf9vVaRxtnE24+8QUi6jkHfiS6Lr9NQhAxj8YnD0Qz9YXWyl/qDH6E5N2BEz6Jls29fPRaDQ==
X-Received: by 2002:a0d:e6ca:: with SMTP id p193mr24001749ywe.173.1562181940052;
        Wed, 03 Jul 2019 12:25:40 -0700 (PDT)
Received: from cpe-2606-A000-1100-37D-0-0-0-E37.dyn6.twc.com (cpe-2606-A000-1100-37D-0-0-0-E37.dyn6.twc.com. [2606:a000:1100:37d::e37])
        by smtp.gmail.com with ESMTPSA id 197sm915010ywb.56.2019.07.03.12.25.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 12:25:39 -0700 (PDT)
Message-ID: <852fbfe9f0ee613b041ecfdd9c895bb9ae92ac3f.camel@redhat.com>
Subject: Re: [PATCH 0/9] ceph: auto reconnect after blacklisted
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, Patrick Donnelly <pdonnell@redhat.com>
Date:   Wed, 03 Jul 2019 15:25:36 -0400
In-Reply-To: <4bd33f73c9f64e79c0364a22dfdd63db02b4e7ab.camel@redhat.com>
References: <20190703124442.6614-1-zyan@redhat.com>
         <4bd33f73c9f64e79c0364a22dfdd63db02b4e7ab.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-07-03 at 12:01 -0400, Jeff Layton wrote:
> On Wed, 2019-07-03 at 20:44 +0800, Yan, Zheng wrote:
> > This series add support for auto reconnect after blacklisted.
> > 
> > Auto reconnect is controlled by recover_session=<clean|no> mount option.
> > Clean mode is enabled by default. In this mode, client drops dirty date
> > and dirty metadata, All writable file handles are invalidated. Read-only
> > file handles continue to work and caches are dropped if necessary.
> > If an inode contains any lost file lock, read and write are not allowed.
> > until all lost file locks are released.
> 
> Just giving this a quick glance:
> 
> Based on the last email discussion about this, I thought that you were
> going to provide a mount option that someone could enable that would
> basically allow the client to "soldier on" in the face of being
> blacklisted and then unblacklisted, without needing to remount anything.
> 
> This set seems to keep the force_reconnect option (patch #7) though, so
> I'm quite confused at this point. What exactly is the goal of here?
> 

s/of here/of this/

> There's also nothing in the changelogs or comments about
> recover_session=brute, which seems like it ought to at least be
> mentioned.
> 
> At this point, I'm going to say NAK on this set until there is some
> accompanying documentation about how you intend for this be used and by
> whom. A patch for the mount.ceph(8) manpage would be a good place to
> start.
> 

So to be clear, I'd suggest (at a minimum):

* writing an RFC patch for the mount.ceph manpage that explains what
these options are and the expected behavior when they are used. In fact,
I'd start with this before you do any more work on the code. We need to
agree on the user-facing interface before anything else.

* consider dropping the force_reconnect option. It seems like this
shouldn't be needed if you've mounted with recover_session=brute. If you
do decide to keep it, then this also needs to be clearly documented, or
someone will attempt to use this to unwedge their client at some point
without fully understanding the ramifications.

* the cover letter should have a clear explanation of what this patchset
is intended to do, and why you're adding it. Yes, I know we've discussed
this on the list before, but in 5 years when someone new is revisiting
the behavior and we've all moved on to do other things and paged this
out of our brains, we want them to be able to find that rationale, and
the associated discussion around it by searching the mailing list
archives.

* I'll also note that this is going to cause a behavior change. Clients
that have been blacklisted and then unblacklisted are going to see
different behavior if they're running on a kernel with this set. That
may be expected and what we want, but it should be clearly stated in the
changelog of the patch that makes this change. The manpage should
probably have a nice detailed section on all of this as well, so that we
can explain the expected behavior on various kernel versions.


> > Yan, Zheng (9):
> >   libceph: add function that reset client's entity addr
> >   libceph: add function that clears osd client's abort_err
> >   ceph: allow closing session in restarting/reconnect state
> >   ceph: track and report error of async metadata operation
> >   ceph: pass filp to ceph_get_caps()
> >   ceph: return -EIO if read/write against filp that lost file locks
> >   ceph: add 'force_reconnect' option for remount
> >   ceph: invalidate all write mode filp after reconnect
> >   ceph: auto reconnect after blacklisted
> > 
> >  fs/ceph/addr.c                  | 30 +++++++----
> >  fs/ceph/caps.c                  | 84 ++++++++++++++++++++----------
> >  fs/ceph/file.c                  | 50 ++++++++++--------
> >  fs/ceph/inode.c                 |  2 +
> >  fs/ceph/locks.c                 |  8 ++-
> >  fs/ceph/mds_client.c            | 92 ++++++++++++++++++++++++++-------
> >  fs/ceph/mds_client.h            |  6 +--
> >  fs/ceph/super.c                 | 91 ++++++++++++++++++++++++++++++--
> >  fs/ceph/super.h                 | 23 +++++++--
> >  include/linux/ceph/libceph.h    |  1 +
> >  include/linux/ceph/messenger.h  |  1 +
> >  include/linux/ceph/mon_client.h |  1 +
> >  include/linux/ceph/osd_client.h |  2 +
> >  net/ceph/ceph_common.c          | 38 +++++++++-----
> >  net/ceph/messenger.c            |  5 ++
> >  net/ceph/mon_client.c           |  7 +++
> >  net/ceph/osd_client.c           | 24 +++++++++
> >  17 files changed, 365 insertions(+), 100 deletions(-)
> > 

-- 
Jeff Layton <jlayton@redhat.com>

