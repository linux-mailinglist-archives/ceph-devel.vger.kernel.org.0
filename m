Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C601A695F
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Apr 2020 18:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731230AbgDMQDy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Apr 2020 12:03:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731222AbgDMQDx (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 13 Apr 2020 12:03:53 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DFE22072D;
        Mon, 13 Apr 2020 16:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586793832;
        bh=0FwzYVrHucypAxBpFVB27ZvfmuzsmF6sOSaKl4kqd1s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cZQUck4x7C5netuO2+Dg7Xpe07Bn12rodHbArt73qOnqvVQXq67yrXbaUnmPKlXp3
         qwCSup7vmPFr7OD213xDnJLwxCkoDK9Pceds9XvF1GN5FYzE5KMU7cjlthje0EroG7
         AQOfwHufiNf/r8eg2wtVBPdLG0isWrnSFbhhF9A0=
Message-ID: <399b4545a43a5de98665c1185367b48934db1a2e.camel@kernel.org>
Subject: Re: [PATCH 1/2] ceph: have ceph_mdsc_free_path ignore ERR_PTR values
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sage Weil <sage@redhat.com>
Date:   Mon, 13 Apr 2020 12:03:51 -0400
In-Reply-To: <CAOi1vP_xUUUPQd=x9rg9KgEz85SHy-9Yurcmvt2iehfhi5ztNQ@mail.gmail.com>
References: <20200408142125.52908-1-jlayton@kernel.org>
         <20200408142125.52908-2-jlayton@kernel.org>
         <CAOi1vP99BbHFrrg+0HAbZrZV7DQ7EG7euTY6cbtdWajsdyN3jQ@mail.gmail.com>
         <ded1b71dcda70e3a249df21c294607dac6545694.camel@kernel.org>
         <CAOi1vP9mZTShECrVVohuj4p=Yr+rWvWnXNY03c85CuO4fGNSyQ@mail.gmail.com>
         <55c47d66b579fcf5749376c73d681d0273095f6d.camel@kernel.org>
         <CAOi1vP_xUUUPQd=x9rg9KgEz85SHy-9Yurcmvt2iehfhi5ztNQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-04-13 at 17:48 +0200, Ilya Dryomov wrote:
> On Mon, Apr 13, 2020 at 3:23 PM Jeff Layton <jlayton@kernel.org> wrote:
> > On Mon, 2020-04-13 at 14:35 +0200, Ilya Dryomov wrote:
> > > On Mon, Apr 13, 2020 at 1:15 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > On Mon, 2020-04-13 at 10:09 +0200, Ilya Dryomov wrote:
> > > > > On Wed, Apr 8, 2020 at 4:21 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > > > This makes the error handling simpler in some callers, and fixes a
> > > > > > couple of bugs in the new async dirops callback code.
> > > > > > 
> > > > > > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > > > ---
> > > > > >  fs/ceph/debugfs.c    | 4 ----
> > > > > >  fs/ceph/mds_client.c | 6 ++----
> > > > > >  fs/ceph/mds_client.h | 2 +-
> > > > > >  3 files changed, 3 insertions(+), 9 deletions(-)
> > > > > > 
> > > > > > diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> > > > > > index eebbce7c3b0c..3a198e40f100 100644
> > > > > > --- a/fs/ceph/debugfs.c
> > > > > > +++ b/fs/ceph/debugfs.c
> > > > > > @@ -83,8 +83,6 @@ static int mdsc_show(struct seq_file *s, void *p)
> > > > > >                 } else if (req->r_dentry) {
> > > > > >                         path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
> > > > > >                                                     &pathbase, 0);
> > > > > > -                       if (IS_ERR(path))
> > > > > > -                               path = NULL;
> > > > > >                         spin_lock(&req->r_dentry->d_lock);
> > > > > >                         seq_printf(s, " #%llx/%pd (%s)",
> > > > > 
> > > > > Hi Jeff,
> > > > > 
> > > > > This ends up attempting to print an IS_ERR pointer as %s.
> > > > > 
> > > > > >                                    ceph_ino(d_inode(req->r_dentry->d_parent)),
> > > > > > @@ -102,8 +100,6 @@ static int mdsc_show(struct seq_file *s, void *p)
> > > > > >                 if (req->r_old_dentry) {
> > > > > >                         path = ceph_mdsc_build_path(req->r_old_dentry, &pathlen,
> > > > > >                                                     &pathbase, 0);
> > > > > > -                       if (IS_ERR(path))
> > > > > > -                               path = NULL;
> > > > > >                         spin_lock(&req->r_old_dentry->d_lock);
> > > > > >                         seq_printf(s, " #%llx/%pd (%s)",
> > > > > 
> > > > > Ditto.
> > > > > 
> > > > > It looks like in newer kernels printf copes with this and outputs
> > > > > "(efault)".  But anything older than 5.2 will crash.
> > > > > 
> > > > > Further, the code looks weird because ceph_mdsc_build_path() doesn't
> > > > > return NULL, but path is tested for NULL in the call to seq_printf().
> > > > > 
> > > > > Why not just follow the same approach as existing mdsc_show()?  It
> > > > > makes it clear that the error is handled and where the NULL pointer
> > > > > comes from.  This kind of "don't handle errors and rely on everything
> > > > > else being able to bail" approach is very fragile and hard to audit.
> > > > > 
> > > > 
> > > > I don't see a problem with having a "free" routine ignore IS_ERR values
> > > > just like it does NULL values. How about I just trim off the other
> > > > deltas in this patch? Something like this?
> > > 
> > > I think it encourages fragile code.  Less so than functions that
> > > return pointer, NULL or IS_ERR pointer, but still.  You yourself
> > > almost fell into one of these traps while editing debugfs.c ;)
> > > 
> > 
> > We'll have to agree to disagree here. Having a free routine ignore
> > ERR_PTR values seems perfectly reasonable to me.
> > 
> > > That said, I won't stand in the way here.  If you trim off everything
> > > else, merge it together with the other patch so that it is introduced
> > > along with the two users.
> > > 
> > 
> > Do you mean that I should merge it with this?
> > 
> >     ceph: initialize base and pathlen variables in async dirops cb's
> > 
> > I'm not sure I see the point in that.
> 
> Yes, because ultimately this is all about those two pr_warn messages.
> path is built just to be printed, base and pathlen are a part of that.
> ceph_mdsc_free_path() didn't need to handle IS_ERR pointers before so
> it should be a single patch.
> 

Ok, done, and cleaned up the changelog. I won't bother re-posting since
it's a fairly trivial squashing of two patches.

-- 
Jeff Layton <jlayton@kernel.org>

