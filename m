Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082DF3B0445
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Jun 2021 14:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhFVM0Z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 22 Jun 2021 08:26:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231404AbhFVM0Y (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 22 Jun 2021 08:26:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E237961353;
        Tue, 22 Jun 2021 12:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624364649;
        bh=oneXQObMwAf4wFpfwDsj76N7x/37zxoY2XuNStd0kVs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nsd4TLeNTGGFYGsYWgQINse+M+MEnx1Bc3RkJUSTCmA1GfxZouPIV1CnkeFUFM1Cg
         h6Y99IiCDWvrvTXwyDqihEqx7Id94IZIF1Xz4RYwUayl/uZlO70KTd7y22YowDf8wF
         HfqG7K7S7Z1SW9GmSeXHv32Rx7EJBbclVQzdlbhEnduCE4RLsrAGzUvujTnzGqTs/i
         f+rHXiMzXVfDw6x1BJGiYqtCfW72X1L0DvRNE6WiVyQkEIxMbNd7hBQXOwGpF3Ne9/
         GxKlQporK9yOl785+bRA867HxNB93nbBbc2kNCkLxClseJnPs0BwpiEEp8dAquVGgv
         jfqqbHXDorofg==
Message-ID: <26f0d8edf8f2173a56e4a1345f2e4224658721d3.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: fix error handling in ceph_atomic_open and
 ceph_lookup
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Date:   Tue, 22 Jun 2021 08:24:07 -0400
In-Reply-To: <CAOi1vP_VHP9sg=EzKSBf99n8q-y8zNZ9ZLPDJt-yvJr8SeZq7g@mail.gmail.com>
References: <20210603123850.74421-1-jlayton@kernel.org>
         <20210621235722.304689-1-jlayton@kernel.org>
         <CAOi1vP_VHP9sg=EzKSBf99n8q-y8zNZ9ZLPDJt-yvJr8SeZq7g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-06-22 at 14:09 +0200, Ilya Dryomov wrote:
> On Tue, Jun 22, 2021 at 1:57 AM Jeff Layton <jlayton@kernel.org> wrote:
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
> >  fs/ceph/dir.c   | 22 ++++++++++++----------
> >  fs/ceph/file.c  | 14 ++++++++------
> >  fs/ceph/super.h |  2 +-
> >  3 files changed, 21 insertions(+), 17 deletions(-)
> > 
> > This one fixes the bug that Ilya spotted in ceph_atomic_open. Also,
> > there is no need to test IS_ERR(dentry) unless we called
> > ceph_handle_snapdir. Finally, it's probably best not to pass
> > ceph_finish_lookup an ERR_PTR as a dentry. Reinstate the res pointer and
> > only reset the dentry pointer if it's valid.
> > 
> > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > index 5624fae7a603..e78da771ec96 100644
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
> > @@ -793,12 +791,16 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
> >         req->r_parent = dir;
> >         set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
> >         err = ceph_mdsc_do_request(mdsc, NULL, req);
> > -       res = ceph_handle_snapdir(req, dentry, err);
> > -       if (IS_ERR(res)) {
> > -               err = PTR_ERR(res);
> > -       } else {
> > -               dentry = res;
> > -               err = 0;
> > +       if (err == -ENOENT) {
> > +               struct dentry *res;
> > +
> > +               res  = ceph_handle_snapdir(req, dentry);
> 
> Stray space here, fixed in the branch.
> 

Thanks!

> > +               if (IS_ERR(res)) {
> > +                       err = PTR_ERR(res);
> > +               } else {
> > +                       dentry = res;
> > +                       err = 0;
> > +               }
> >         }
> >         dentry = ceph_finish_lookup(req, dentry, err);
> >         ceph_mdsc_put_request(req);  /* will dput(dentry) */
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 7aa20d50a231..7c08f864694f 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -739,14 +739,16 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
> >         err = ceph_mdsc_do_request(mdsc,
> >                                    (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
> >                                    req);
> > -       dentry = ceph_handle_snapdir(req, dentry, err);
> > -       if (IS_ERR(dentry)) {
> > -               err = PTR_ERR(dentry);
> > -               goto out_req;
> > +       if (err == -ENOENT) {
> > +               dentry = ceph_handle_snapdir(req, dentry);
> > +               if (IS_ERR(dentry)) {
> > +                       err = PTR_ERR(dentry);
> > +                       goto out_req;
> > +               }
> > +               err = 0;
> >         }
> > -       err = 0;
> > 
> > -       if ((flags & O_CREAT) && !req->r_reply_info.head->is_dentry)
> > +       if (!err && (flags & O_CREAT) && !req->r_reply_info.head->is_dentry)
> >                 err = ceph_handle_notrace_create(dir, dentry);
> > 
> >         if (d_in_lookup(dentry)) {
> 
> I must admit that I don't understand the code that follows.  For
> example, if ceph_handle_notrace_create() returns ENOENT, is it supposed
> to be resolved by ceph_finish_lookup()?  Because if it gets resolved,
> err is not reset and we still jump to out_req, possibly leaving some
> dentry references behind.  It appears to be an older bug though.
> 

Yes. A lot of this code is unclear.

> This fix for dealing with ceph_mdsc_do_request() errors seems correct,
> but I really think this code needs massaging to disentangle handling of
> special cases from actual errors.
> 
> Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
> 

Thanks and I agree. This code really is a giant hairball. I really hate
the way it weaves "err" through several functions and lets them deal
with it. That alone makes this so very difficult to follow.

I intend to follow up with some more cleanup in this area, but I haven't
had the time to spend on it yet. In the meantime, if anyone else wants
to submit patches to do this cleanup, I'm happy to review them...
-- 
Jeff Layton <jlayton@kernel.org>

