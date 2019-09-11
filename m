Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71A57B019D
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2019 18:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729193AbfIKQ0F (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Sep 2019 12:26:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728822AbfIKQ0F (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Sep 2019 12:26:05 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFFD62085B;
        Wed, 11 Sep 2019 16:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568219164;
        bh=FQZ9zp4VcNy9igYxjg69xusAL5zwoKpise22saHhwMc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=0f1ecwyZhQPm3Nishzw/L5/0ywN6uO3Ntwiirl1jp6WLJ5sFN2/QjVLTzFM/K1PeW
         4dHMm36JA3WZ04jl0uoTc478gTo780uZ5ouc6qKQLqFux3Hr8INHDiyBpxCkNxJ2lb
         mEx9uBGXnVfwgB6OwJLRBnXZUD+6sS4qudHDMpJY=
Message-ID: <8cf5777cb8d0b8e4f8d123d36105a8bc46374b52.camel@kernel.org>
Subject: Re: [PATCH] modify the mode of req from USE_ANY_MDS to USE_AUTH_MDS
 to reduce the cache size of mds and forward op.
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>,
        Gregory Farnum <gfarnum@redhat.com>
Cc:     simon gao <simon29rock@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Date:   Wed, 11 Sep 2019 12:26:02 -0400
In-Reply-To: <CAAM7YAnyK3yA-ZMCgQCPWBqFKB0+7StwsWPjj6bve=UTppk3iA@mail.gmail.com>
References: <1567687915-121426-1-git-send-email-simon29rock@gmail.com>
         <82144ffcc3f52a9b4cc923884d8aa3d096b76599.camel@kernel.org>
         <CAJ4mKGYS_yF+49VfxbLErE5WJEbNCyNZ5i-FvG6=i6dTrrKTUg@mail.gmail.com>
         <CAAM7YAnyK3yA-ZMCgQCPWBqFKB0+7StwsWPjj6bve=UTppk3iA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-09-10 at 14:59 +0800, Yan, Zheng wrote:
> On Sun, Sep 8, 2019 at 9:32 AM Gregory Farnum <gfarnum@redhat.com> wrote:
> > On Thu, Sep 5, 2019 at 11:46 AM Jeff Layton <jlayton@kernel.org> wrote:
> > > On Thu, 2019-09-05 at 08:51 -0400, simon gao wrote:
> > > 
> > > I think this deserves a much better description than just the subject
> > > line above. This change may be obvious to others but it's not clear to
> > > me why this will have the effect you suggest, and what downsides it may
> > > have.
> > > 
> > > Can you flesh out the patch description and resend?
> > 
> > Yeah this seems wrong to me in general. I don't remember exactly how
> > it's implemented client-side but generally speaking we want to allow
> > use of the replicated metadata on slave MDSes so that we eg spread the
> > load around on subtree boundaries, and don't have to split up request
> > streams across multiple MDSes when we're doing stuff like working in a
> > private subdirectory but occasionally need to look at stuff on the
> > parent.
> > In general if the client knows which MDS is auth for a dentry/inode I
> > don't think they'll send requests elsewhere without a good reason for
> > it.
> 
> The problem is when client sends request to a wrong mds. the wrong mds
> 'discovers' corresponding metadata instead of forwarding the request.
> If dir.pin is used to pin subtree to different mds and each mds
> already has large cache, 'discover' is inefficient because it cache
> same metadata at multiple places.
> 

In an ideal world, what should happen in this case? Should we be
changing MDS policy to forward the request in this situation?

This mount option seems like it's exposing something that is really an
internal implementation detail to the admin. That might be justified,
but I'm unclear on why we don't expect more saner behavior from the MDS
on this?

> 
> > -Greg
> > 
> > > Thanks,
> > > 
> > > > ---
> > > >  fs/ceph/dir.c        | 4 ++--
> > > >  fs/ceph/export.c     | 8 ++++----
> > > >  fs/ceph/file.c       | 2 +-
> > > >  fs/ceph/inode.c      | 2 +-
> > > >  fs/ceph/mds_client.c | 1 +
> > > >  fs/ceph/super.c      | 2 +-
> > > >  6 files changed, 10 insertions(+), 9 deletions(-)
> > > > 
> > > > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > > > index 4ca0b8f..a441b8d 100644
> > > > --- a/fs/ceph/dir.c
> > > > +++ b/fs/ceph/dir.c
> > > > @@ -771,7 +771,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
> > > > 
> > > >       op = ceph_snap(dir) == CEPH_SNAPDIR ?
> > > >               CEPH_MDS_OP_LOOKUPSNAP : CEPH_MDS_OP_LOOKUP;
> > > > -     req = ceph_mdsc_create_request(mdsc, op, USE_ANY_MDS);
> > > > +     req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
> > > >       if (IS_ERR(req))
> > > >               return ERR_CAST(req);
> > > >       req->r_dentry = dget(dentry);
> > > > @@ -1600,7 +1600,7 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
> > > > 
> > > >               op = ceph_snap(dir) == CEPH_SNAPDIR ?
> > > >                       CEPH_MDS_OP_LOOKUPSNAP : CEPH_MDS_OP_LOOKUP;
> > > > -             req = ceph_mdsc_create_request(mdsc, op, USE_ANY_MDS);
> > > > +             req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
> > > >               if (!IS_ERR(req)) {
> > > >                       req->r_dentry = dget(dentry);
> > > >                       req->r_num_caps = 2;
> > > > diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> > > > index 15ff1b0..a7d5174 100644
> > > > --- a/fs/ceph/export.c
> > > > +++ b/fs/ceph/export.c
> > > > @@ -135,7 +135,7 @@ static struct inode *__lookup_inode(struct super_block *sb, u64 ino)
> > > >               int mask;
> > > > 
> > > >               req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPINO,
> > > > -                                            USE_ANY_MDS);
> > > > +                                            USE_AUTH_MDS);
> > > >               if (IS_ERR(req))
> > > >                       return ERR_CAST(req);
> > > > 
> > > > @@ -210,7 +210,7 @@ static struct dentry *__snapfh_to_dentry(struct super_block *sb,
> > > >               return d_obtain_alias(inode);
> > > > 
> > > >       req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPINO,
> > > > -                                    USE_ANY_MDS);
> > > > +                                    USE_AUTH_MDS);
> > > >       if (IS_ERR(req))
> > > >               return ERR_CAST(req);
> > > > 
> > > > @@ -294,7 +294,7 @@ static struct dentry *__get_parent(struct super_block *sb,
> > > >       int err;
> > > > 
> > > >       req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPPARENT,
> > > > -                                    USE_ANY_MDS);
> > > > +                                    USE_AUTH_MDS);
> > > >       if (IS_ERR(req))
> > > >               return ERR_CAST(req);
> > > > 
> > > > @@ -509,7 +509,7 @@ static int ceph_get_name(struct dentry *parent, char *name,
> > > > 
> > > >       mdsc = ceph_inode_to_client(inode)->mdsc;
> > > >       req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPNAME,
> > > > -                                    USE_ANY_MDS);
> > > > +                                    USE_AUTH_MDS);
> > > >       if (IS_ERR(req))
> > > >               return PTR_ERR(req);
> > > > 
> > > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > > index 685a03c..79533f2 100644
> > > > --- a/fs/ceph/file.c
> > > > +++ b/fs/ceph/file.c
> > > > @@ -182,7 +182,7 @@ static void put_bvecs(struct bio_vec *bvecs, int num_bvecs, bool should_dirty)
> > > >       struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
> > > >       struct ceph_mds_client *mdsc = fsc->mdsc;
> > > >       struct ceph_mds_request *req;
> > > > -     int want_auth = USE_ANY_MDS;
> > > > +     int want_auth = USE_AUTH_MDS;
> > > >       int op = (flags & O_CREAT) ? CEPH_MDS_OP_CREATE : CEPH_MDS_OP_OPEN;
> > > > 
> > > >       if (flags & (O_WRONLY|O_RDWR|O_CREAT|O_TRUNC))
> > > > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > > > index 18500ede..6c67548 100644
> > > > --- a/fs/ceph/inode.c
> > > > +++ b/fs/ceph/inode.c
> > > > @@ -2247,7 +2247,7 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
> > > >       if (!force && ceph_caps_issued_mask(ceph_inode(inode), mask, 1))
> > > >               return 0;
> > > > 
> > > > -     mode = (mask & CEPH_STAT_RSTAT) ? USE_AUTH_MDS : USE_ANY_MDS;
> > > > +     mode = USE_AUTH_MDS;
> > > >       req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, mode);
> > > >       if (IS_ERR(req))
> > > >               return PTR_ERR(req);
> > > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > > index 920e9f0..acfb969 100644
> > > > --- a/fs/ceph/mds_client.c
> > > > +++ b/fs/ceph/mds_client.c
> > > > @@ -867,6 +867,7 @@ static struct inode *get_nonsnap_parent(struct dentry *dentry)
> > > >       return inode;
> > > >  }
> > > > 
> > > > +static struct inode *get_parent()
> > > >  /*
> > > >   * Choose mds to send request to next.  If there is a hint set in the
> > > >   * request (e.g., due to a prior forward hint from the mds), use that.
> > > > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > > > index ab4868c..517e605 100644
> > > > --- a/fs/ceph/super.c
> > > > +++ b/fs/ceph/super.c
> > > > @@ -867,7 +867,7 @@ static struct dentry *open_root_dentry(struct ceph_fs_client *fsc,
> > > > 
> > > >       /* open dir */
> > > >       dout("open_root_inode opening '%s'\n", path);
> > > > -     req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, USE_ANY_MDS);
> > > > +     req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, USE_AUTH_MDS);
> > > >       if (IS_ERR(req))
> > > >               return ERR_CAST(req);
> > > >       req->r_path1 = kstrdup(path, GFP_NOFS);
> > > 
> > > --
> > > Jeff Layton <jlayton@kernel.org>
> > > 

-- 
Jeff Layton <jlayton@kernel.org>

