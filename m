Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1B61AC15F
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Apr 2020 14:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635801AbgDPMfR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Apr 2020 08:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2635784AbgDPMfA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 16 Apr 2020 08:35:00 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64207217D8;
        Thu, 16 Apr 2020 12:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587040499;
        bh=IsnY/HCMmHz6uYV0Fgvg3eNRHrEtzm9ddp24WshxQS8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=O2VFMakJ5Jy0GC+0v/Gl1cAM9hBhyF/ecdC6MFyAs8KsTyxsfRMWeJjguisf8PFID
         FVfwA0KKFvshWvm1ss4H+rIzWfi4vzIeOWb6eHRpOAZ8hBb68uFvsOWDzOospNi9Cn
         z07Z88SCwE3Hup5+UYmnuhkx26rrKRRN49UO85f0=
Message-ID: <1a63be231a1739e208c071d71b9647f4ad72750f.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: fix potential bad pointer deref in async
 dirops cb's
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date:   Thu, 16 Apr 2020 08:34:58 -0400
In-Reply-To: <CAOi1vP_E59KWf=bf3z-G-nEzzu7ZiU+ZCvz-cARWp2h5jRgz-A@mail.gmail.com>
References: <20200415133929.234033-1-jlayton@kernel.org>
         <CAOi1vP8Nrac=+gaN75EoOo8dbjubJ-aG-M9ZniKtz+CKA7kysw@mail.gmail.com>
         <3edec7a3bb64ea6e90144a259f43ee1f04f0e71a.camel@kernel.org>
         <CAOi1vP_E59KWf=bf3z-G-nEzzu7ZiU+ZCvz-cARWp2h5jRgz-A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-04-16 at 14:14 +0200, Ilya Dryomov wrote:
> On Thu, Apr 16, 2020 at 12:50 PM Jeff Layton <jlayton@kernel.org> wrote:
> > On Thu, 2020-04-16 at 09:08 +0200, Ilya Dryomov wrote:
> > > On Thu, Apr 16, 2020 at 2:04 AM Jeff Layton <jlayton@kernel.org> wrote:
> > > > The new async dirops callback routines can pass ERR_PTR values to
> > > > ceph_mdsc_free_path, which could cause an oops.
> > > > 
> > > > Given that ceph_mdsc_build_path returns ERR_PTR values, it makes sense
> > > > to just have ceph_mdsc_free_path ignore them. Also, clean up the error
> > > > handling a bit in mdsc_show, and ensure that the pr_warn messages look
> > > > sane even if ceph_mdsc_build_path fails.
> > > > 
> > > > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >  fs/ceph/debugfs.c    | 8 ++------
> > > >  fs/ceph/dir.c        | 4 ++--
> > > >  fs/ceph/file.c       | 4 ++--
> > > >  fs/ceph/mds_client.h | 2 +-
> > > >  4 files changed, 7 insertions(+), 11 deletions(-)
> > > > 
> > > > diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> > > > index eebbce7c3b0c..3baec3a896ee 100644
> > > > --- a/fs/ceph/debugfs.c
> > > > +++ b/fs/ceph/debugfs.c
> > > > @@ -83,13 +83,11 @@ static int mdsc_show(struct seq_file *s, void *p)
> > > >                 } else if (req->r_dentry) {
> > > >                         path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
> > > >                                                     &pathbase, 0);
> > > > -                       if (IS_ERR(path))
> > > > -                               path = NULL;
> > > >                         spin_lock(&req->r_dentry->d_lock);
> > > >                         seq_printf(s, " #%llx/%pd (%s)",
> > > >                                    ceph_ino(d_inode(req->r_dentry->d_parent)),
> > > >                                    req->r_dentry,
> > > > -                                  path ? path : "");
> > > > +                                  IS_ERR(path) ? "" : path);
> > > >                         spin_unlock(&req->r_dentry->d_lock);
> > > >                         ceph_mdsc_free_path(path, pathlen);
> > > >                 } else if (req->r_path1) {
> > > > @@ -102,14 +100,12 @@ static int mdsc_show(struct seq_file *s, void *p)
> > > >                 if (req->r_old_dentry) {
> > > >                         path = ceph_mdsc_build_path(req->r_old_dentry, &pathlen,
> > > >                                                     &pathbase, 0);
> > > > -                       if (IS_ERR(path))
> > > > -                               path = NULL;
> > > >                         spin_lock(&req->r_old_dentry->d_lock);
> > > >                         seq_printf(s, " #%llx/%pd (%s)",
> > > >                                    req->r_old_dentry_dir ?
> > > >                                    ceph_ino(req->r_old_dentry_dir) : 0,
> > > >                                    req->r_old_dentry,
> > > > -                                  path ? path : "");
> > > > +                                  IS_ERR(path) ? "" : path);
> > > >                         spin_unlock(&req->r_old_dentry->d_lock);
> > > >                         ceph_mdsc_free_path(path, pathlen);
> > > >                 } else if (req->r_path2 && req->r_op != CEPH_MDS_OP_SYMLINK) {
> > > > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > > > index 9d02d4feb693..39f5311404b0 100644
> > > > --- a/fs/ceph/dir.c
> > > > +++ b/fs/ceph/dir.c
> > > > @@ -1057,8 +1057,8 @@ static void ceph_async_unlink_cb(struct ceph_mds_client *mdsc,
> > > > 
> > > >         /* If op failed, mark everyone involved for errors */
> > > >         if (result) {
> > > > -               int pathlen;
> > > > -               u64 base;
> > > > +               int pathlen = 0;
> > > > +               u64 base = 0;
> > > >                 char *path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
> > > >                                                   &base, 0);
> > > > 
> > > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > > index 3a1bd13de84f..160644ddaeed 100644
> > > > --- a/fs/ceph/file.c
> > > > +++ b/fs/ceph/file.c
> > > > @@ -529,8 +529,8 @@ static void ceph_async_create_cb(struct ceph_mds_client *mdsc,
> > > > 
> > > >         if (result) {
> > > >                 struct dentry *dentry = req->r_dentry;
> > > > -               int pathlen;
> > > > -               u64 base;
> > > > +               int pathlen = 0;
> > > > +               u64 base = 0;
> > > >                 char *path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
> > > >                                                   &base, 0);
> > > > 
> > > > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > > > index 1b40f30e0a8e..43111e408fa2 100644
> > > > --- a/fs/ceph/mds_client.h
> > > > +++ b/fs/ceph/mds_client.h
> > > > @@ -531,7 +531,7 @@ extern void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc);
> > > > 
> > > >  static inline void ceph_mdsc_free_path(char *path, int len)
> > > >  {
> > > > -       if (path)
> > > > +       if (!IS_ERR_OR_NULL(path))
> > > >                 __putname(path - (PATH_MAX - 1 - len));
> > > >  }
> > > 
> > > Hi Jeff,
> > > 
> > > Following our discussion, I staged v1 (i.e. no debugfs.c changes) in
> > > commit 2a575f138d003fff0f4930b5cfae4a1c46343b8f on Monday.  I see you
> > > force pushed testing, so perhaps you missed that.
> > > 
> > > Please be careful when force pushing.
> > 
> > My bad. It should be fixed now.
> > 
> > This is one of the reasons I'm not a fan of sharing a git tree like we
> > are. It's like all the "fun" of the bad, old CVS days. Part of the
> > problem is that I don't get any clear notification when you move patches
> > from testing into master.
> 
> Sorry, I should have replied in the thread.  I didn't because
> we agreed on pushing this fix for -rc2 and you said you wouldn't
> bother reposting, so I thought you were done with it.
>
> > Perhaps we should just make you maintainer for cephfs as well, which
> > would keep it to one person merging patches?
> 
> I don't see a problem with sharing testing.  Just don't force
> push by default.  Try a regular push first and examine the history
> if it fails.  I never rebase without a good reason, so it should
> be fairly clear -- usually either a master update or a rebase to a
> late -rc).  If you ever force push, use --force-with-lease.
> 
> Ultimately, though, it's just a testing branch.  If one of us screws
> it, it can always be reset.
> 

I generally use --force-with-lease when I do have to force push but I
must have done a bare --force push accidentally. Sorry about that!

-- 
Jeff Layton <jlayton@kernel.org>

