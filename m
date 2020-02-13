Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3A415BE5B
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2020 13:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbgBMMWn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Feb 2020 07:22:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:38958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727059AbgBMMWn (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 13 Feb 2020 07:22:43 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1F7E217F4;
        Thu, 13 Feb 2020 12:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581596562;
        bh=uPWRS5PvRmQR4819f4V8iTqnZ5B1uvSHg7HXZd5QqzI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lkCs/TEoXBlfrVCzWwFPMXmlV1EClzkp38u/kEZOwzv1wmIIE4s47aX9aulgqLw8y
         jWHiRiIjJkeVBxEMD7tlI+2jmzU/+DRV9vikwLH6518gOGcBRkIj1zAEauNsDZhoLO
         AOQswoiyQ50lVKAdQCSO5HrmN69PCK1gzlPCpFw4=
Message-ID: <b085ae59e39e3d856678d4f590a6a0b58f86671f.camel@kernel.org>
Subject: Re: [PATCH v4 2/9] ceph: perform asynchronous unlink if we have
 sufficient caps
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, idridryomov@gmail.com,
        Sage Weil <sage@redhat.com>, Zheng Yan <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 13 Feb 2020 07:22:40 -0500
In-Reply-To: <CAAM7YA=W6xJg4fh71aQ0vBXn62+V_8RXS2zsUgychVV9RpUaVw@mail.gmail.com>
References: <20200212172729.260752-1-jlayton@kernel.org>
         <20200212172729.260752-3-jlayton@kernel.org>
         <CAAM7YA=W6xJg4fh71aQ0vBXn62+V_8RXS2zsUgychVV9RpUaVw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-02-13 at 20:06 +0800, Yan, Zheng wrote:
> On Thu, Feb 13, 2020 at 1:29 AM Jeff Layton <jlayton@kernel.org> wrote:
> > The MDS is getting a new lock-caching facility that will allow it
> > to cache the necessary locks to allow asynchronous directory operations.
> > Since the CEPH_CAP_FILE_* caps are currently unused on directories,
> > we can repurpose those bits for this purpose.
> > 
> > When performing an unlink, if we have Fx on the parent directory,
> > and CEPH_CAP_DIR_UNLINK (aka Fr), and we know that the dentry being
> > removed is the primary link, then then we can fire off an unlink
> > request immediately and don't need to wait on reply before returning.
> > 
> > In that situation, just fix up the dcache and link count and return
> > immediately after issuing the call to the MDS. This does mean that we
> > need to hold an extra reference to the inode being unlinked, and extra
> > references to the caps to avoid races. Those references are put and
> > error handling is done in the r_callback routine.
> > 
> > If the operation ends up failing, then set a writeback error on the
> > directory inode, and the inode itself that can be fetched later by
> > an fsync on the dir.
> > 
> > The behavior of dir caps is slightly different from caps on normal
> > files. Because these are just considered an optimization, if the
> > session is reconnected, we will not automatically reclaim them. They
> > are instead considered lost until we do another synchronous op in the
> > parent directory.
> > 
> > Async dirops are enabled via the "nowsync" mount option, which is
> > patterned after the xfs "wsync" mount option. For now, the default
> > is "wsync", but eventually we may flip that.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
> > ---
> >  fs/ceph/caps.c               | 35 +++++++++----
> >  fs/ceph/dir.c                | 99 ++++++++++++++++++++++++++++++++++--
> >  fs/ceph/inode.c              |  8 ++-
> >  fs/ceph/mds_client.c         |  8 ++-
> >  fs/ceph/super.c              | 20 ++++++++
> >  fs/ceph/super.h              |  6 ++-
> >  include/linux/ceph/ceph_fs.h |  9 ++++
> >  7 files changed, 166 insertions(+), 19 deletions(-)
> > 
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index d05717397c2a..7fc87b693ba4 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -992,7 +992,11 @@ int __ceph_caps_file_wanted(struct ceph_inode_info *ci)
> >  int __ceph_caps_wanted(struct ceph_inode_info *ci)
> >  {
> >         int w = __ceph_caps_file_wanted(ci) | __ceph_caps_used(ci);
> > -       if (!S_ISDIR(ci->vfs_inode.i_mode)) {
> > +       if (S_ISDIR(ci->vfs_inode.i_mode)) {
> > +               /* we want EXCL if holding caps of dir ops */
> > +               if (w & CEPH_CAP_ANY_DIR_OPS)
> > +                       w |= CEPH_CAP_FILE_EXCL;
> > +       } else {
> >                 /* we want EXCL if dirty data */
> >                 if (w & CEPH_CAP_FILE_BUFFER)
> >                         w |= CEPH_CAP_FILE_EXCL;
> > @@ -1883,10 +1887,13 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
> >                          * revoking the shared cap on every create/unlink
> >                          * operation.
> >                          */
> > -                       if (IS_RDONLY(inode))
> > +                       if (IS_RDONLY(inode)) {
> >                                 want = CEPH_CAP_ANY_SHARED;
> > -                       else
> > -                               want = CEPH_CAP_ANY_SHARED | CEPH_CAP_FILE_EXCL;
> > +                       } else {
> > +                               want = CEPH_CAP_ANY_SHARED |
> > +                                      CEPH_CAP_FILE_EXCL |
> > +                                      CEPH_CAP_ANY_DIR_OPS;
> > +                       }
> >                         retain |= want;
> >                 } else {
> > 
> > @@ -2649,7 +2656,10 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
> >                                 }
> >                                 snap_rwsem_locked = true;
> >                         }
> > -                       *got = need | (have & want);
> > +                       if ((have & want) == want)
> > +                               *got = need | want;
> > +                       else
> > +                               *got = need;
> >                         if (S_ISREG(inode->i_mode) &&
> >                             (need & CEPH_CAP_FILE_RD) &&
> >                             !(*got & CEPH_CAP_FILE_CACHE))
> > @@ -2739,13 +2749,16 @@ int ceph_try_get_caps(struct inode *inode, int need, int want,
> >         int ret;
> > 
> >         BUG_ON(need & ~CEPH_CAP_FILE_RD);
> > -       BUG_ON(want & ~(CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO|CEPH_CAP_FILE_SHARED));
> > -       ret = ceph_pool_perm_check(inode, need);
> > -       if (ret < 0)
> > -               return ret;
> > +       if (need) {
> > +               ret = ceph_pool_perm_check(inode, need);
> > +               if (ret < 0)
> > +                       return ret;
> > +       }
> > 
> > -       ret = try_get_cap_refs(inode, need, want, 0,
> > -                              (nonblock ? NON_BLOCKING : 0), got);
> > +       BUG_ON(want & ~(CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_LAZYIO |
> > +                       CEPH_CAP_FILE_SHARED | CEPH_CAP_FILE_EXCL |
> > +                       CEPH_CAP_ANY_DIR_OPS));
> > +       ret = try_get_cap_refs(inode, need, want, 0, nonblock, got);
> 
> should keep (nonblock ? NON_BLOCKING : 0)
> 

Good catch. Fixed in my tree.

-- 
Jeff Layton <jlayton@kernel.org>

