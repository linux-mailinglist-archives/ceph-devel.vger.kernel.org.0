Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1EAAE429
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Sep 2019 09:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729701AbfIJHAK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Sep 2019 03:00:10 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34526 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729270AbfIJHAJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Sep 2019 03:00:09 -0400
Received: by mail-qk1-f195.google.com with SMTP id q203so15935433qke.1
        for <ceph-devel@vger.kernel.org>; Tue, 10 Sep 2019 00:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IVwpwI5KOiKm3fEXo10QCrP3ndVPh+UuvjARB0mp4iE=;
        b=ZZLZxdaI7wqFgk+Ghxg+hwF/oZnUmvv9ssM1+YMQ6WaRH7wWNX5tsuDyhIseIwlFRY
         7rkorajL0nv3m+3IQP2hdVZChwh4gHdDBSnHyI4zAOiZLgkePJzM1aAZNPjvu/kZLbne
         SU/xusgDQwtCbnRdm8jMLCS2YWfYL/IaNil+CGMYB+lL4vox2CLHXECWLAq50XTA3enN
         ZWrvUR2qnwiBGqgBAKfKkgwHfaI4ekI3q+1nj20fw06t8ZNc93+fneaVH0i/xzGKKOFt
         PCw8yk5j1WZbWGpODZ3HiF+8EUkKyINd7rDvaP/QjdYiRx45nwSIueJ6K6MkyGpPv9E9
         MJSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IVwpwI5KOiKm3fEXo10QCrP3ndVPh+UuvjARB0mp4iE=;
        b=Yi1zS011jY8+nMR0bfFeGtYgECo8ZqbCWULaOgeRiXB0ZNjEoAS1blXjUzaoVTuo9p
         86ctkKrDgd1qZJJrGEEAjWLjlqF6Uh8NBlztmnGXSLskmI8tH+2sVBavzeO2drm/TWQ+
         +b+ROK1i+KEzysqCNbOkaxJPiXsxZE3CUD89LqnxWZOwgHrrZgDC8+JnOQlugiaxJWxj
         ifHunozdN+QM+aMz3n7mv+emaD06LKnDO/eN1MFq98iMLuv5FmuqMJtKf3Os8nQTdUQ7
         V1tVHmn/xwOkztTdKjA81qR6l/0b6RBMx6xJFz2jzwEijUjOPS8sjMRfQQUFbxYcwqCl
         wHqA==
X-Gm-Message-State: APjAAAWysPKyzYAWkQzLYU9Nkiiqso7DC/wbhIu+TGxzoCFeikRbNSJz
        ZxNnEG/rjO44KblZ+2zPoxv6JUnyMaBS65o09jk=
X-Google-Smtp-Source: APXvYqwRG+BygwKovNbvtbdsdLREuSDAukTREIpfzWu77Gif1RObs3f3VcZG4e1CpXc7Zity8vII/1sk6coYtKOhTvw=
X-Received: by 2002:a37:a858:: with SMTP id r85mr13272607qke.394.1568098808516;
 Tue, 10 Sep 2019 00:00:08 -0700 (PDT)
MIME-Version: 1.0
References: <1567687915-121426-1-git-send-email-simon29rock@gmail.com>
 <82144ffcc3f52a9b4cc923884d8aa3d096b76599.camel@kernel.org> <CAJ4mKGYS_yF+49VfxbLErE5WJEbNCyNZ5i-FvG6=i6dTrrKTUg@mail.gmail.com>
In-Reply-To: <CAJ4mKGYS_yF+49VfxbLErE5WJEbNCyNZ5i-FvG6=i6dTrrKTUg@mail.gmail.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 10 Sep 2019 14:59:57 +0800
Message-ID: <CAAM7YAnyK3yA-ZMCgQCPWBqFKB0+7StwsWPjj6bve=UTppk3iA@mail.gmail.com>
Subject: Re: [PATCH] modify the mode of req from USE_ANY_MDS to USE_AUTH_MDS
 to reduce the cache size of mds and forward op.
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        simon gao <simon29rock@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, Sep 8, 2019 at 9:32 AM Gregory Farnum <gfarnum@redhat.com> wrote:
>
> On Thu, Sep 5, 2019 at 11:46 AM Jeff Layton <jlayton@kernel.org> wrote:
> >
> > On Thu, 2019-09-05 at 08:51 -0400, simon gao wrote:
> >
> > I think this deserves a much better description than just the subject
> > line above. This change may be obvious to others but it's not clear to
> > me why this will have the effect you suggest, and what downsides it may
> > have.
> >
> > Can you flesh out the patch description and resend?
>
> Yeah this seems wrong to me in general. I don't remember exactly how
> it's implemented client-side but generally speaking we want to allow
> use of the replicated metadata on slave MDSes so that we eg spread the
> load around on subtree boundaries, and don't have to split up request
> streams across multiple MDSes when we're doing stuff like working in a
> private subdirectory but occasionally need to look at stuff on the
> parent.
> In general if the client knows which MDS is auth for a dentry/inode I
> don't think they'll send requests elsewhere without a good reason for
> it.


The problem is when client sends request to a wrong mds. the wrong mds
'discovers' corresponding metadata instead of forwarding the request.
If dir.pin is used to pin subtree to different mds and each mds
already has large cache, 'discover' is inefficient because it cache
same metadata at multiple places.


> -Greg
>
> >
> > Thanks,
> >
> > > ---
> > >  fs/ceph/dir.c        | 4 ++--
> > >  fs/ceph/export.c     | 8 ++++----
> > >  fs/ceph/file.c       | 2 +-
> > >  fs/ceph/inode.c      | 2 +-
> > >  fs/ceph/mds_client.c | 1 +
> > >  fs/ceph/super.c      | 2 +-
> > >  6 files changed, 10 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > > index 4ca0b8f..a441b8d 100644
> > > --- a/fs/ceph/dir.c
> > > +++ b/fs/ceph/dir.c
> > > @@ -771,7 +771,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
> > >
> > >       op = ceph_snap(dir) == CEPH_SNAPDIR ?
> > >               CEPH_MDS_OP_LOOKUPSNAP : CEPH_MDS_OP_LOOKUP;
> > > -     req = ceph_mdsc_create_request(mdsc, op, USE_ANY_MDS);
> > > +     req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
> > >       if (IS_ERR(req))
> > >               return ERR_CAST(req);
> > >       req->r_dentry = dget(dentry);
> > > @@ -1600,7 +1600,7 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
> > >
> > >               op = ceph_snap(dir) == CEPH_SNAPDIR ?
> > >                       CEPH_MDS_OP_LOOKUPSNAP : CEPH_MDS_OP_LOOKUP;
> > > -             req = ceph_mdsc_create_request(mdsc, op, USE_ANY_MDS);
> > > +             req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
> > >               if (!IS_ERR(req)) {
> > >                       req->r_dentry = dget(dentry);
> > >                       req->r_num_caps = 2;
> > > diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> > > index 15ff1b0..a7d5174 100644
> > > --- a/fs/ceph/export.c
> > > +++ b/fs/ceph/export.c
> > > @@ -135,7 +135,7 @@ static struct inode *__lookup_inode(struct super_block *sb, u64 ino)
> > >               int mask;
> > >
> > >               req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPINO,
> > > -                                            USE_ANY_MDS);
> > > +                                            USE_AUTH_MDS);
> > >               if (IS_ERR(req))
> > >                       return ERR_CAST(req);
> > >
> > > @@ -210,7 +210,7 @@ static struct dentry *__snapfh_to_dentry(struct super_block *sb,
> > >               return d_obtain_alias(inode);
> > >
> > >       req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPINO,
> > > -                                    USE_ANY_MDS);
> > > +                                    USE_AUTH_MDS);
> > >       if (IS_ERR(req))
> > >               return ERR_CAST(req);
> > >
> > > @@ -294,7 +294,7 @@ static struct dentry *__get_parent(struct super_block *sb,
> > >       int err;
> > >
> > >       req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPPARENT,
> > > -                                    USE_ANY_MDS);
> > > +                                    USE_AUTH_MDS);
> > >       if (IS_ERR(req))
> > >               return ERR_CAST(req);
> > >
> > > @@ -509,7 +509,7 @@ static int ceph_get_name(struct dentry *parent, char *name,
> > >
> > >       mdsc = ceph_inode_to_client(inode)->mdsc;
> > >       req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPNAME,
> > > -                                    USE_ANY_MDS);
> > > +                                    USE_AUTH_MDS);
> > >       if (IS_ERR(req))
> > >               return PTR_ERR(req);
> > >
> > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > index 685a03c..79533f2 100644
> > > --- a/fs/ceph/file.c
> > > +++ b/fs/ceph/file.c
> > > @@ -182,7 +182,7 @@ static void put_bvecs(struct bio_vec *bvecs, int num_bvecs, bool should_dirty)
> > >       struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
> > >       struct ceph_mds_client *mdsc = fsc->mdsc;
> > >       struct ceph_mds_request *req;
> > > -     int want_auth = USE_ANY_MDS;
> > > +     int want_auth = USE_AUTH_MDS;
> > >       int op = (flags & O_CREAT) ? CEPH_MDS_OP_CREATE : CEPH_MDS_OP_OPEN;
> > >
> > >       if (flags & (O_WRONLY|O_RDWR|O_CREAT|O_TRUNC))
> > > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > > index 18500ede..6c67548 100644
> > > --- a/fs/ceph/inode.c
> > > +++ b/fs/ceph/inode.c
> > > @@ -2247,7 +2247,7 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
> > >       if (!force && ceph_caps_issued_mask(ceph_inode(inode), mask, 1))
> > >               return 0;
> > >
> > > -     mode = (mask & CEPH_STAT_RSTAT) ? USE_AUTH_MDS : USE_ANY_MDS;
> > > +     mode = USE_AUTH_MDS;
> > >       req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, mode);
> > >       if (IS_ERR(req))
> > >               return PTR_ERR(req);
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index 920e9f0..acfb969 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -867,6 +867,7 @@ static struct inode *get_nonsnap_parent(struct dentry *dentry)
> > >       return inode;
> > >  }
> > >
> > > +static struct inode *get_parent()
> > >  /*
> > >   * Choose mds to send request to next.  If there is a hint set in the
> > >   * request (e.g., due to a prior forward hint from the mds), use that.
> > > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > > index ab4868c..517e605 100644
> > > --- a/fs/ceph/super.c
> > > +++ b/fs/ceph/super.c
> > > @@ -867,7 +867,7 @@ static struct dentry *open_root_dentry(struct ceph_fs_client *fsc,
> > >
> > >       /* open dir */
> > >       dout("open_root_inode opening '%s'\n", path);
> > > -     req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, USE_ANY_MDS);
> > > +     req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, USE_AUTH_MDS);
> > >       if (IS_ERR(req))
> > >               return ERR_CAST(req);
> > >       req->r_path1 = kstrdup(path, GFP_NOFS);
> >
> >
> > --
> > Jeff Layton <jlayton@kernel.org>
> >
