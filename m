Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9B5513351E
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jan 2020 22:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbgAGVnd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jan 2020 16:43:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:42182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727150AbgAGVnd (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 7 Jan 2020 16:43:33 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EF5C20692;
        Tue,  7 Jan 2020 21:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578433411;
        bh=nuuhvAtaB+3YyIZOfITQ2PPN7qYLIPEFcvpt8wfWW3U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=wr9BMg84dTSsDYf/OrP8mjVmtovUqxyIrGRuqRnllIsagrjdTYdYClxHiqUvoUvkw
         KT1ENZ1452MTb7VQxnVDlPUy1RVlfcS53AAUBr4aZcuq0P64V8oYw4HBBHNfjJ00W1
         JdYryQfhiciYdHnZQEm61+tObJluhxiHVzsSPxt0=
Message-ID: <e8c7d2e75c531faee1fc830b73a822569e314638.camel@kernel.org>
Subject: Re: [PATCH 5/9] ceph: wait for async dir ops to complete before
 doing synchronous dir ops
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Date:   Tue, 07 Jan 2020 16:43:30 -0500
In-Reply-To: <CAAM7YAkg3XM14Y3B9jOgjEV6_kVkQL7tkBmWhnN=6vbUW=U8cw@mail.gmail.com>
References: <20190801202605.18172-1-jlayton@kernel.org>
         <20190801202605.18172-6-jlayton@kernel.org>
         <CAAM7YAkKd4_QEPs_2jROYL8Terx7WJU1wV_no4jnaCcyYaV4Tg@mail.gmail.com>
         <CAAM7YAkg3XM14Y3B9jOgjEV6_kVkQL7tkBmWhnN=6vbUW=U8cw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-01-07 at 23:45 +0800, Yan, Zheng wrote:
> On Tue, Jan 7, 2020 at 10:50 PM Yan, Zheng <ukernel@gmail.com> wrote:
> > On Fri, Aug 2, 2019 at 4:26 AM Jeff Layton <jlayton@kernel.org> wrote:
> > > Ensure that we wait on replies from any pending directory operations
> > > involving children before we allow synchronous operations involving
> > > that directory to proceed.
> > > 
> > 
> > This patch is not needed because mds does the job.  For current
> > implementation, we need to make inode operations (getattr/setattr/...)
> > wait until getting reply for async create.
> > 
> 
> I think about this again. Maybe it's better to do all these waits in MDS
> 

This patch isn't in the latest set (sent yesterday).

FWIW, the current async dirops patchset I'm playing with is here:

https://github.com/ceph/ceph-client/commits/wip-async-dirops

It's still a bit rough in places, but it seems to be working fairly well
now. I hope to have some good numbers to share in the near future.

> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/dir.c   | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
> > >  fs/ceph/file.c  |  4 ++++
> > >  fs/ceph/super.h |  1 +
> > >  3 files changed, 51 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > > index aab29f48c62d..35797ff895e7 100644
> > > --- a/fs/ceph/dir.c
> > > +++ b/fs/ceph/dir.c
> > > @@ -1036,6 +1036,38 @@ static int ceph_link(struct dentry *old_dentry, struct inode *dir,
> > >         return err;
> > >  }
> > > 
> > > +int ceph_async_dirop_request_wait(struct inode *inode)
> > > +{
> > > +       struct ceph_inode_info *ci = ceph_inode(inode);
> > > +       struct ceph_mds_request *cur, *req;
> > > +       int ret = 0;
> > > +
> > > +       /* Only applicable for directories */
> > > +       if (!inode || !S_ISDIR(inode->i_mode))
> > > +               return 0;
> > > +retry:
> > > +       spin_lock(&ci->i_unsafe_lock);
> > > +       req = NULL;
> > > +       list_for_each_entry(cur, &ci->i_unsafe_dirops, r_unsafe_dir_item) {
> > > +               if (!test_bit(CEPH_MDS_R_GOT_UNSAFE, &cur->r_req_flags) &&
> > > +                   !test_bit(CEPH_MDS_R_GOT_SAFE, &cur->r_req_flags)) {
> > > +                       req = cur;
> > > +                       ceph_mdsc_get_request(req);
> > > +                       break;
> > > +               }
> > > +       }
> > > +       spin_unlock(&ci->i_unsafe_lock);
> > > +       if (req) {
> > > +               dout("%s %lx wait on tid %llu\n", __func__, inode->i_ino,
> > > +                    req->r_tid);
> > > +               ret = wait_for_completion_killable(&req->r_completion);
> > > +               ceph_mdsc_put_request(req);
> > > +               if (!ret)
> > > +                       goto retry;
> > > +       }
> > > +       return ret;
> > > +}
> > > +
> > >  /*
> > >   * rmdir and unlink are differ only by the metadata op code
> > >   */
> > > @@ -1059,6 +1091,12 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
> > >                         CEPH_MDS_OP_RMDIR : CEPH_MDS_OP_UNLINK;
> > >         } else
> > >                 goto out;
> > > +
> > > +       /* Wait for any requests involving children to get a reply */
> > > +       err = ceph_async_dirop_request_wait(inode);
> > > +       if (err)
> > > +               goto out;
> > > +
> > >         req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
> > >         if (IS_ERR(req)) {
> > >                 err = PTR_ERR(req);
> > > @@ -1105,8 +1143,14 @@ static int ceph_rename(struct inode *old_dir, struct dentry *old_dentry,
> > >             (!ceph_quota_is_same_realm(old_dir, new_dir)))
> > >                 return -EXDEV;
> > > 
> > > -       dout("rename dir %p dentry %p to dir %p dentry %p\n",
> > > -            old_dir, old_dentry, new_dir, new_dentry);
> > > +       err = ceph_async_dirop_request_wait(d_inode(old_dentry));
> > > +       if (err)
> > > +               return err;
> > > +
> > > +       err = ceph_async_dirop_request_wait(d_inode(new_dentry));
> > > +       if (err)
> > > +               return err;
> > > +
> > >         req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
> > >         if (IS_ERR(req))
> > >                 return PTR_ERR(req);
> > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > index 3c0b5247818f..75bce889305c 100644
> > > --- a/fs/ceph/file.c
> > > +++ b/fs/ceph/file.c
> > > @@ -449,6 +449,10 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
> > >              dir, dentry, dentry,
> > >              d_unhashed(dentry) ? "unhashed" : "hashed", flags, mode);
> > > 
> > > +       err = ceph_async_dirop_request_wait(dir);
> > > +       if (err)
> > > +               return err;
> > > +
> > >         if (dentry->d_name.len > NAME_MAX)
> > >                 return -ENAMETOOLONG;
> > > 
> > > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > > index a9aa3e358226..77ed6c5900be 100644
> > > --- a/fs/ceph/super.h
> > > +++ b/fs/ceph/super.h
> > > @@ -1113,6 +1113,7 @@ extern int ceph_handle_snapdir(struct ceph_mds_request *req,
> > >                                struct dentry *dentry, int err);
> > >  extern struct dentry *ceph_finish_lookup(struct ceph_mds_request *req,
> > >                                          struct dentry *dentry, int err);
> > > +extern int ceph_async_dirop_request_wait(struct inode *inode);
> > > 
> > >  extern void __ceph_dentry_lease_touch(struct ceph_dentry_info *di);
> > >  extern void __ceph_dentry_dir_lease_touch(struct ceph_dentry_info *di);
> > > --
> > > 2.21.0
> > > 

-- 
Jeff Layton <jlayton@kernel.org>

