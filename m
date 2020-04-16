Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79D21AC0DA
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Apr 2020 14:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635164AbgDPMOV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Apr 2020 08:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2635002AbgDPMOQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 16 Apr 2020 08:14:16 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04B0C061A0C
        for <ceph-devel@vger.kernel.org>; Thu, 16 Apr 2020 05:14:16 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id u11so5197862iow.4
        for <ceph-devel@vger.kernel.org>; Thu, 16 Apr 2020 05:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XCY8c85ZGODhFsz1WGifkpWcdo01ZMssQ4Ck6rK4AJo=;
        b=oDffP10gZ/uTrf9YcxmYqD3th2NqYjy7DoL8G3IgYlsN3YhmN2pN+zUvqDoAtdZWeU
         OELVadw/BHcSWgB1VZZzljSRL+OpQcc3siSx+1UPqpOvVsll2tuR+tqAJx6Ov3UQWQbB
         makAsYGN6trzpGBgBp7yD5ipp2Rr3+j85GlkxMkvSrQveaLPv9zLd0DHnYiiZ43EqfUA
         B9e0vLNRNGGXJAU+jvoVzkTOhAgysuBd33jK386LCrOq6teF/RRyy30fv5A3GqoHGQ87
         5Ue2Xkez2+qWPYEXLSWj4A0fED6N/BYGR7DagxsVa1NXs3XZQ/anS0J/wefhmfZa8lyV
         /5ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XCY8c85ZGODhFsz1WGifkpWcdo01ZMssQ4Ck6rK4AJo=;
        b=An41G2tJRDgLQf7yHtQWXMA7Qv5eQDVt+pg1Ey6/VOdxfT7639PX8XA8I55cGXPEYU
         wAH7vm3Ig0fhgw1Mx+1jJ6FaopUPIqFfeNJn/JaW4Dx/7dlOKAUzRt2PHZy3895G6s+R
         dAH3pGTpUsaYiGTGxcc6KbFc0Ty5AmJSOdQmJ8iSMMK0Nh21Fzks7kDGtvvefu7rNQ9O
         qZjxBAhwiAS+v2b6oJQDJTtkQUD15cWQK/IiT3pFMRGql2ZAVcsGyNn6xRC46zwsmfii
         QzaZjYLduJuK+/3sLrb58c6zNVCuDrcq/3ytH/2UCSkoZMlxBXy5BrhnQAtJKf9CIbDK
         wo5Q==
X-Gm-Message-State: AGi0PuaI76dsaF0hajMjufNLhljqGoFQtYUDWI8dD9ID3Eirprb7fpKg
        UOzbVYZN4R5+/aoTRPWD15BA4iDWYsc0GXoppBA=
X-Google-Smtp-Source: APiQypJ58cpb7GyWm7Wf27IaCGbSzVkC1fl6b/ZWDjeAfypvgJeOP81THiVmf8O/LnCtw0D09WxlXk1i4BiNGy1lx64=
X-Received: by 2002:a5e:a607:: with SMTP id q7mr3313724ioi.109.1587039256164;
 Thu, 16 Apr 2020 05:14:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200415133929.234033-1-jlayton@kernel.org> <CAOi1vP8Nrac=+gaN75EoOo8dbjubJ-aG-M9ZniKtz+CKA7kysw@mail.gmail.com>
 <3edec7a3bb64ea6e90144a259f43ee1f04f0e71a.camel@kernel.org>
In-Reply-To: <3edec7a3bb64ea6e90144a259f43ee1f04f0e71a.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 16 Apr 2020 14:14:11 +0200
Message-ID: <CAOi1vP_E59KWf=bf3z-G-nEzzu7ZiU+ZCvz-cARWp2h5jRgz-A@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix potential bad pointer deref in async dirops cb's
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Apr 16, 2020 at 12:50 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Thu, 2020-04-16 at 09:08 +0200, Ilya Dryomov wrote:
> > On Thu, Apr 16, 2020 at 2:04 AM Jeff Layton <jlayton@kernel.org> wrote:
> > > The new async dirops callback routines can pass ERR_PTR values to
> > > ceph_mdsc_free_path, which could cause an oops.
> > >
> > > Given that ceph_mdsc_build_path returns ERR_PTR values, it makes sense
> > > to just have ceph_mdsc_free_path ignore them. Also, clean up the error
> > > handling a bit in mdsc_show, and ensure that the pr_warn messages look
> > > sane even if ceph_mdsc_build_path fails.
> > >
> > > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/debugfs.c    | 8 ++------
> > >  fs/ceph/dir.c        | 4 ++--
> > >  fs/ceph/file.c       | 4 ++--
> > >  fs/ceph/mds_client.h | 2 +-
> > >  4 files changed, 7 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> > > index eebbce7c3b0c..3baec3a896ee 100644
> > > --- a/fs/ceph/debugfs.c
> > > +++ b/fs/ceph/debugfs.c
> > > @@ -83,13 +83,11 @@ static int mdsc_show(struct seq_file *s, void *p)
> > >                 } else if (req->r_dentry) {
> > >                         path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
> > >                                                     &pathbase, 0);
> > > -                       if (IS_ERR(path))
> > > -                               path = NULL;
> > >                         spin_lock(&req->r_dentry->d_lock);
> > >                         seq_printf(s, " #%llx/%pd (%s)",
> > >                                    ceph_ino(d_inode(req->r_dentry->d_parent)),
> > >                                    req->r_dentry,
> > > -                                  path ? path : "");
> > > +                                  IS_ERR(path) ? "" : path);
> > >                         spin_unlock(&req->r_dentry->d_lock);
> > >                         ceph_mdsc_free_path(path, pathlen);
> > >                 } else if (req->r_path1) {
> > > @@ -102,14 +100,12 @@ static int mdsc_show(struct seq_file *s, void *p)
> > >                 if (req->r_old_dentry) {
> > >                         path = ceph_mdsc_build_path(req->r_old_dentry, &pathlen,
> > >                                                     &pathbase, 0);
> > > -                       if (IS_ERR(path))
> > > -                               path = NULL;
> > >                         spin_lock(&req->r_old_dentry->d_lock);
> > >                         seq_printf(s, " #%llx/%pd (%s)",
> > >                                    req->r_old_dentry_dir ?
> > >                                    ceph_ino(req->r_old_dentry_dir) : 0,
> > >                                    req->r_old_dentry,
> > > -                                  path ? path : "");
> > > +                                  IS_ERR(path) ? "" : path);
> > >                         spin_unlock(&req->r_old_dentry->d_lock);
> > >                         ceph_mdsc_free_path(path, pathlen);
> > >                 } else if (req->r_path2 && req->r_op != CEPH_MDS_OP_SYMLINK) {
> > > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > > index 9d02d4feb693..39f5311404b0 100644
> > > --- a/fs/ceph/dir.c
> > > +++ b/fs/ceph/dir.c
> > > @@ -1057,8 +1057,8 @@ static void ceph_async_unlink_cb(struct ceph_mds_client *mdsc,
> > >
> > >         /* If op failed, mark everyone involved for errors */
> > >         if (result) {
> > > -               int pathlen;
> > > -               u64 base;
> > > +               int pathlen = 0;
> > > +               u64 base = 0;
> > >                 char *path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
> > >                                                   &base, 0);
> > >
> > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > index 3a1bd13de84f..160644ddaeed 100644
> > > --- a/fs/ceph/file.c
> > > +++ b/fs/ceph/file.c
> > > @@ -529,8 +529,8 @@ static void ceph_async_create_cb(struct ceph_mds_client *mdsc,
> > >
> > >         if (result) {
> > >                 struct dentry *dentry = req->r_dentry;
> > > -               int pathlen;
> > > -               u64 base;
> > > +               int pathlen = 0;
> > > +               u64 base = 0;
> > >                 char *path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
> > >                                                   &base, 0);
> > >
> > > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > > index 1b40f30e0a8e..43111e408fa2 100644
> > > --- a/fs/ceph/mds_client.h
> > > +++ b/fs/ceph/mds_client.h
> > > @@ -531,7 +531,7 @@ extern void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc);
> > >
> > >  static inline void ceph_mdsc_free_path(char *path, int len)
> > >  {
> > > -       if (path)
> > > +       if (!IS_ERR_OR_NULL(path))
> > >                 __putname(path - (PATH_MAX - 1 - len));
> > >  }
> >
> > Hi Jeff,
> >
> > Following our discussion, I staged v1 (i.e. no debugfs.c changes) in
> > commit 2a575f138d003fff0f4930b5cfae4a1c46343b8f on Monday.  I see you
> > force pushed testing, so perhaps you missed that.
> >
> > Please be careful when force pushing.
>
> My bad. It should be fixed now.
>
> This is one of the reasons I'm not a fan of sharing a git tree like we
> are. It's like all the "fun" of the bad, old CVS days. Part of the
> problem is that I don't get any clear notification when you move patches
> from testing into master.

Sorry, I should have replied in the thread.  I didn't because
we agreed on pushing this fix for -rc2 and you said you wouldn't
bother reposting, so I thought you were done with it.

>
> Perhaps we should just make you maintainer for cephfs as well, which
> would keep it to one person merging patches?

I don't see a problem with sharing testing.  Just don't force
push by default.  Try a regular push first and examine the history
if it fails.  I never rebase without a good reason, so it should
be fairly clear -- usually either a master update or a rebase to a
late -rc).  If you ever force push, use --force-with-lease.

Ultimately, though, it's just a testing branch.  If one of us screws
it, it can always be reset.

Thanks,

                Ilya
