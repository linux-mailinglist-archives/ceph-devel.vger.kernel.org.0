Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59514AC191
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2019 22:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392091AbfIFUpx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 Sep 2019 16:45:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36740 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392054AbfIFUpx (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 6 Sep 2019 16:45:53 -0400
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AB8832A09D2
        for <ceph-devel@vger.kernel.org>; Fri,  6 Sep 2019 20:45:52 +0000 (UTC)
Received: by mail-qk1-f198.google.com with SMTP id y67so7987426qkc.14
        for <ceph-devel@vger.kernel.org>; Fri, 06 Sep 2019 13:45:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rha+To/PWj0mvHoR4Y4/4WBezrMzNZd4TdCQM0GyJKw=;
        b=M1P5UyQ6dQQ3kTTOcbIeS+xyJzE+x+ZUN0+94mRsnCxAFhe0a/am4MlhztXc7bhpuj
         tK4OFUwOVotDiIaUpXRiM8H/CeqLwlNYmfYntgxgdkbXXXhbVZg4fEOKYFB6ffw5ESDc
         Wj3i38GeM0O772+O9iNgMScMJridM801MNlyRC7/cjqnrvggmY1zJRdcNoZBMi/tILIk
         KgoiUqAw25WIZbuNiivjN4qSGn/ArwOUWBQULvhs6+x9L3nhajc001zdfeUN7T/yV+7P
         9hVDBiEbQatmNK5H1W9yPesD4TmVtETfzZcy141zfpcsW1cj89APkbYd9AuW+hBEcwgT
         SY4A==
X-Gm-Message-State: APjAAAXsCSfwCf4UQ/N2hg2YZX1sbtrwcOaVwKIC5uo3CaifXNTITDwc
        GTHCnIFjFlu5gcq20Wn3Oh+o/jKFKKDcl4fPAc2iP71PB/73akIwIv1CZsf9jB6spTmKrw2VeTy
        /18b1hW88gbdGIyszIssSQHsc3eoFI5r8J/6YAg==
X-Received: by 2002:a37:8ac7:: with SMTP id m190mr10289038qkd.385.1567802751433;
        Fri, 06 Sep 2019 13:45:51 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwrFvxZ/+BPzS2NZ8N40KGXVWGWSFdfXKIDYoi9IncJHh3IsJvXsyJROZipaBxAHisZjkQM55Eoeq0B0RFog9Y=
X-Received: by 2002:a37:8ac7:: with SMTP id m190mr10288988qkd.385.1567802750803;
 Fri, 06 Sep 2019 13:45:50 -0700 (PDT)
MIME-Version: 1.0
References: <1567687915-121426-1-git-send-email-simon29rock@gmail.com> <82144ffcc3f52a9b4cc923884d8aa3d096b76599.camel@kernel.org>
In-Reply-To: <82144ffcc3f52a9b4cc923884d8aa3d096b76599.camel@kernel.org>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Fri, 6 Sep 2019 13:45:39 -0700
Message-ID: <CAJ4mKGYS_yF+49VfxbLErE5WJEbNCyNZ5i-FvG6=i6dTrrKTUg@mail.gmail.com>
Subject: Re: [PATCH] modify the mode of req from USE_ANY_MDS to USE_AUTH_MDS
 to reduce the cache size of mds and forward op.
To:     Jeff Layton <jlayton@kernel.org>
Cc:     simon gao <simon29rock@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Sep 5, 2019 at 11:46 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Thu, 2019-09-05 at 08:51 -0400, simon gao wrote:
>
> I think this deserves a much better description than just the subject
> line above. This change may be obvious to others but it's not clear to
> me why this will have the effect you suggest, and what downsides it may
> have.
>
> Can you flesh out the patch description and resend?

Yeah this seems wrong to me in general. I don't remember exactly how
it's implemented client-side but generally speaking we want to allow
use of the replicated metadata on slave MDSes so that we eg spread the
load around on subtree boundaries, and don't have to split up request
streams across multiple MDSes when we're doing stuff like working in a
private subdirectory but occasionally need to look at stuff on the
parent.
In general if the client knows which MDS is auth for a dentry/inode I
don't think they'll send requests elsewhere without a good reason for
it.
-Greg

>
> Thanks,
>
> > ---
> >  fs/ceph/dir.c        | 4 ++--
> >  fs/ceph/export.c     | 8 ++++----
> >  fs/ceph/file.c       | 2 +-
> >  fs/ceph/inode.c      | 2 +-
> >  fs/ceph/mds_client.c | 1 +
> >  fs/ceph/super.c      | 2 +-
> >  6 files changed, 10 insertions(+), 9 deletions(-)
> >
> > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > index 4ca0b8f..a441b8d 100644
> > --- a/fs/ceph/dir.c
> > +++ b/fs/ceph/dir.c
> > @@ -771,7 +771,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
> >
> >       op = ceph_snap(dir) == CEPH_SNAPDIR ?
> >               CEPH_MDS_OP_LOOKUPSNAP : CEPH_MDS_OP_LOOKUP;
> > -     req = ceph_mdsc_create_request(mdsc, op, USE_ANY_MDS);
> > +     req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
> >       if (IS_ERR(req))
> >               return ERR_CAST(req);
> >       req->r_dentry = dget(dentry);
> > @@ -1600,7 +1600,7 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
> >
> >               op = ceph_snap(dir) == CEPH_SNAPDIR ?
> >                       CEPH_MDS_OP_LOOKUPSNAP : CEPH_MDS_OP_LOOKUP;
> > -             req = ceph_mdsc_create_request(mdsc, op, USE_ANY_MDS);
> > +             req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
> >               if (!IS_ERR(req)) {
> >                       req->r_dentry = dget(dentry);
> >                       req->r_num_caps = 2;
> > diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> > index 15ff1b0..a7d5174 100644
> > --- a/fs/ceph/export.c
> > +++ b/fs/ceph/export.c
> > @@ -135,7 +135,7 @@ static struct inode *__lookup_inode(struct super_block *sb, u64 ino)
> >               int mask;
> >
> >               req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPINO,
> > -                                            USE_ANY_MDS);
> > +                                            USE_AUTH_MDS);
> >               if (IS_ERR(req))
> >                       return ERR_CAST(req);
> >
> > @@ -210,7 +210,7 @@ static struct dentry *__snapfh_to_dentry(struct super_block *sb,
> >               return d_obtain_alias(inode);
> >
> >       req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPINO,
> > -                                    USE_ANY_MDS);
> > +                                    USE_AUTH_MDS);
> >       if (IS_ERR(req))
> >               return ERR_CAST(req);
> >
> > @@ -294,7 +294,7 @@ static struct dentry *__get_parent(struct super_block *sb,
> >       int err;
> >
> >       req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPPARENT,
> > -                                    USE_ANY_MDS);
> > +                                    USE_AUTH_MDS);
> >       if (IS_ERR(req))
> >               return ERR_CAST(req);
> >
> > @@ -509,7 +509,7 @@ static int ceph_get_name(struct dentry *parent, char *name,
> >
> >       mdsc = ceph_inode_to_client(inode)->mdsc;
> >       req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPNAME,
> > -                                    USE_ANY_MDS);
> > +                                    USE_AUTH_MDS);
> >       if (IS_ERR(req))
> >               return PTR_ERR(req);
> >
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 685a03c..79533f2 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -182,7 +182,7 @@ static void put_bvecs(struct bio_vec *bvecs, int num_bvecs, bool should_dirty)
> >       struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
> >       struct ceph_mds_client *mdsc = fsc->mdsc;
> >       struct ceph_mds_request *req;
> > -     int want_auth = USE_ANY_MDS;
> > +     int want_auth = USE_AUTH_MDS;
> >       int op = (flags & O_CREAT) ? CEPH_MDS_OP_CREATE : CEPH_MDS_OP_OPEN;
> >
> >       if (flags & (O_WRONLY|O_RDWR|O_CREAT|O_TRUNC))
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index 18500ede..6c67548 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -2247,7 +2247,7 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
> >       if (!force && ceph_caps_issued_mask(ceph_inode(inode), mask, 1))
> >               return 0;
> >
> > -     mode = (mask & CEPH_STAT_RSTAT) ? USE_AUTH_MDS : USE_ANY_MDS;
> > +     mode = USE_AUTH_MDS;
> >       req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, mode);
> >       if (IS_ERR(req))
> >               return PTR_ERR(req);
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 920e9f0..acfb969 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -867,6 +867,7 @@ static struct inode *get_nonsnap_parent(struct dentry *dentry)
> >       return inode;
> >  }
> >
> > +static struct inode *get_parent()
> >  /*
> >   * Choose mds to send request to next.  If there is a hint set in the
> >   * request (e.g., due to a prior forward hint from the mds), use that.
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index ab4868c..517e605 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -867,7 +867,7 @@ static struct dentry *open_root_dentry(struct ceph_fs_client *fsc,
> >
> >       /* open dir */
> >       dout("open_root_inode opening '%s'\n", path);
> > -     req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, USE_ANY_MDS);
> > +     req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, USE_AUTH_MDS);
> >       if (IS_ERR(req))
> >               return ERR_CAST(req);
> >       req->r_path1 = kstrdup(path, GFP_NOFS);
>
>
> --
> Jeff Layton <jlayton@kernel.org>
>
