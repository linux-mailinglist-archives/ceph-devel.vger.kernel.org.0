Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD25C3AF9C1
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Jun 2021 01:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhFUXv0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 21 Jun 2021 19:51:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231486AbhFUXv0 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 21 Jun 2021 19:51:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54F0260FF2;
        Mon, 21 Jun 2021 23:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624319351;
        bh=2deii/9G9YKYnTB9qWsvB4kBhJXa68gECpcH/L8ZiDM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qft1aP51KYdq+Strg5Egw/zINTi4IXfmeX7wvGUWNr+sK1wJlbq0V1p/b3tgpBKjo
         hSx98hclu/rDbrletjqKxgxsJ6xQmoKKWQtcUs4JzeU02/c2y+f1fXG44BkUMN4Mat
         qTu3PtCxN0VxIDh3gVPiD8gKZh2oJqlvi6kX3AsYGb2Bq9J10doHu62J42Y8dq2CJo
         borbq8XEszGbnETsIKYtW51uIxQA9k404ndy98uBu8kG+tBQg+ovIptOoY5ByVHrbJ
         tKeos8x3z0hHNt64E+eijt/6ItkNfKDvCGf/rEvZvjur5v6wR+PZrrt0UCCaxmonkL
         suYTGZKEiZeOw==
Message-ID: <b699ba59527b3d6e2afd415fb4fb846c462b4b12.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix error handling in ceph_atomic_open and
 ceph_lookup
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Date:   Mon, 21 Jun 2021 19:49:10 -0400
In-Reply-To: <CAOi1vP8vcs8da2+fUUuo25S0M0bdVKqp_qxDyTRaAAYDMnvJGA@mail.gmail.com>
References: <20210603123850.74421-1-jlayton@kernel.org>
         <CAOi1vP8vcs8da2+fUUuo25S0M0bdVKqp_qxDyTRaAAYDMnvJGA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-06-21 at 21:20 +0200, Ilya Dryomov wrote:
> On Thu, Jun 3, 2021 at 2:38 PM Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > Commit aa60cfc3f7ee broke the error handling in these functions such
> > that they don't handle non-ENOENT errors from ceph_mdsc_do_request
> > properly.
> > 
> > Move the checking of -ENOENT out of ceph_handle_snapdir and into the
> > callers, and if we get a different error, return it immediately.
> > 
> > Fixes: aa60cfc3f7ee ("ceph: don't use d_add in ceph_handle_snapdir")
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/dir.c   | 17 ++++++-----------
> >  fs/ceph/file.c  |  6 +++---
> >  fs/ceph/super.h |  2 +-
> >  3 files changed, 10 insertions(+), 15 deletions(-)
> > 
> > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > index 5624fae7a603..ac431246e0c9 100644
> > --- a/fs/ceph/dir.c
> > +++ b/fs/ceph/dir.c
> > @@ -668,14 +668,13 @@ static loff_t ceph_dir_llseek(struct file *file, loff_t offset, int whence)
> >   * Handle lookups for the hidden .snap directory.
> >   */
> >  struct dentry *ceph_handle_snapdir(struct ceph_mds_request *req,
> > -                                  struct dentry *dentry, int err)
> > +                                  struct dentry *dentry)
> >  {
> >         struct ceph_fs_client *fsc = ceph_sb_to_client(dentry->d_sb);
> >         struct inode *parent = d_inode(dentry->d_parent); /* we hold i_mutex */
> > 
> >         /* .snap dir? */
> > -       if (err == -ENOENT &&
> > -           ceph_snap(parent) == CEPH_NOSNAP &&
> > +       if (ceph_snap(parent) == CEPH_NOSNAP &&
> >             strcmp(dentry->d_name.name, fsc->mount_options->snapdir_name) == 0) {
> >                 struct dentry *res;
> >                 struct inode *inode = ceph_get_snapdir(parent);
> > @@ -742,7 +741,6 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
> >         struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
> >         struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
> >         struct ceph_mds_request *req;
> > -       struct dentry *res;
> >         int op;
> >         int mask;
> >         int err;
> > @@ -793,13 +791,10 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
> >         req->r_parent = dir;
> >         set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
> >         err = ceph_mdsc_do_request(mdsc, NULL, req);
> > -       res = ceph_handle_snapdir(req, dentry, err);
> > -       if (IS_ERR(res)) {
> > -               err = PTR_ERR(res);
> > -       } else {
> > -               dentry = res;
> > -               err = 0;
> > -       }
> > +       if (err == -ENOENT)
> > +               dentry = ceph_handle_snapdir(req, dentry);
> > +       if (IS_ERR(dentry))
> > +               err = PTR_ERR(dentry);
> >         dentry = ceph_finish_lookup(req, dentry, err);
> >         ceph_mdsc_put_request(req);  /* will dput(dentry) */
> >         dout("lookup result=%p\n", dentry);
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 7aa20d50a231..a01ad342a91d 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -739,14 +739,14 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
> >         err = ceph_mdsc_do_request(mdsc,
> >                                    (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
> >                                    req);
> > -       dentry = ceph_handle_snapdir(req, dentry, err);
> > +       if (err == -ENOENT)
> > +               dentry = ceph_handle_snapdir(req, dentry);
> >         if (IS_ERR(dentry)) {
> >                 err = PTR_ERR(dentry);
> >                 goto out_req;
> >         }
> 
> Hi Jeff,
> 
> This doesn't seem right to me.  Looking at 5.12, ENOENT from
> ceph_mdsc_do_request() could be resolved by ceph_handle_snapdir()
> meaning that ceph_handle_notrace_create() could be called and
> ceph_finish_lookup() could be passed err == 0.
> 
> With this patch err would remain ENOENT, resulting in skipping
> the potential ceph_handle_notrace_create() call and passing that
> ENOENT to ceph_finish_lookup().
> 

Well spotted! I have a v2 version that I'm running through xfstests now.
I'll send it along in a bit.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

