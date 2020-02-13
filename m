Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3675F15BE58
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2020 13:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbgBMMWR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Feb 2020 07:22:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:38812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727059AbgBMMWQ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 13 Feb 2020 07:22:16 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79173217F4;
        Thu, 13 Feb 2020 12:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581596536;
        bh=XkLfAFy1S8pl/nim1GCrTDXLWyqkCIaJFRRS64GoUsc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=q74tBT2eT3gh70s+/9Vyo8zjhTMMhxSlkJ5Pjha++arOClpWs1hHZBdeX348tb6tA
         VzYoWwH0S/GzBIbVjqAG5Mcv1lXu2zwvluZPISVtcu6eNjr2GMryFNsE6lZPWy+6nA
         kI4M2B7c6mfTuX5R17iozhmtt6VWLUozuYm4bjYU=
Message-ID: <f4faa94a4c94b40972f045aab01d4ef5b1f01141.camel@kernel.org>
Subject: Re: [PATCH v4 6/9] ceph: add infrastructure for waiting for async
 create to complete
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, idridryomov@gmail.com,
        Sage Weil <sage@redhat.com>, Zheng Yan <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 13 Feb 2020 07:22:14 -0500
In-Reply-To: <CAAM7YA=_L_yu86V4MtwRFy_swfoWTwBzCk_O2wH5nTati2hBcQ@mail.gmail.com>
References: <20200212172729.260752-1-jlayton@kernel.org>
         <20200212172729.260752-7-jlayton@kernel.org>
         <CAAM7YA=_L_yu86V4MtwRFy_swfoWTwBzCk_O2wH5nTati2hBcQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-02-13 at 20:15 +0800, Yan, Zheng wrote:
> On Thu, Feb 13, 2020 at 1:30 AM Jeff Layton <jlayton@kernel.org> wrote:
> > When we issue an async create, we must ensure that any later on-the-wire
> > requests involving it wait for the create reply.
> > 
> > Expand i_ceph_flags to be an unsigned long, and add a new bit that
> > MDS requests can wait on. If the bit is set in the inode when sending
> > caps, then don't send it and just return that it has been delayed.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/caps.c       | 13 ++++++++++++-
> >  fs/ceph/dir.c        |  2 +-
> >  fs/ceph/mds_client.c | 18 ++++++++++++++++++
> >  fs/ceph/mds_client.h |  8 ++++++++
> >  fs/ceph/super.h      |  4 +++-
> >  5 files changed, 42 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index c983990acb75..869e2102e827 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -511,7 +511,7 @@ static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
> >                                 struct ceph_inode_info *ci,
> >                                 bool set_timeout)
> >  {
> > -       dout("__cap_delay_requeue %p flags %d at %lu\n", &ci->vfs_inode,
> > +       dout("__cap_delay_requeue %p flags 0x%lx at %lu\n", &ci->vfs_inode,
> >              ci->i_ceph_flags, ci->i_hold_caps_max);
> >         if (!mdsc->stopping) {
> >                 spin_lock(&mdsc->cap_delay_lock);
> > @@ -1298,6 +1298,13 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
> >         int delayed = 0;
> >         int ret;
> > 
> > +       /* Don't send anything if it's still being created. Return delayed */
> > +       if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
> > +               spin_unlock(&ci->i_ceph_lock);
> > +               dout("%s async create in flight for %p\n", __func__, inode);
> > +               return 1;
> > +       }
> > +
> >         held = cap->issued | cap->implemented;
> >         revoking = cap->implemented & ~cap->issued;
> >         retain &= ~revoking;
> > @@ -2257,6 +2264,10 @@ int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
> >         if (datasync)
> >                 goto out;
> > 
> > +       ret = ceph_wait_on_async_create(inode);
> > +       if (ret)
> > +               goto out;
> > +
> 
> fsync on directory does not consider async create/unlink?
> 

No, it does. A little lower than this hunk, we have this call:

    err = unsafe_request_wait(inode);

...which waits on all of the i_unsafe_dirops requests.


> >         dirty = try_flush_caps(inode, &flush_tid);
> >         dout("fsync dirty caps are %s\n", ceph_cap_string(dirty));
> > 
> > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > index 46314ccf48c5..4e695f2a9347 100644
> > --- a/fs/ceph/dir.c
> > +++ b/fs/ceph/dir.c
> > @@ -752,7 +752,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
> >                 struct ceph_dentry_info *di = ceph_dentry(dentry);
> > 
> >                 spin_lock(&ci->i_ceph_lock);
> > -               dout(" dir %p flags are %d\n", dir, ci->i_ceph_flags);
> > +               dout(" dir %p flags are 0x%lx\n", dir, ci->i_ceph_flags);
> >                 if (strncmp(dentry->d_name.name,
> >                             fsc->mount_options->snapdir_name,
> >                             dentry->d_name.len) &&
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 91c5f999da7d..314dd0f6f5a9 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -2829,6 +2829,24 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
> >                 ceph_get_cap_refs(ceph_inode(req->r_old_dentry_dir),
> >                                   CEPH_CAP_PIN);
> > 
> > +       if (req->r_inode) {
> > +               err = ceph_wait_on_async_create(req->r_inode);
> > +               if (err) {
> > +                       dout("%s: wait for async create returned: %d\n",
> > +                            __func__, err);
> > +                       return err;
> > +               }
> > +       }
> > +
> > +       if (req->r_old_inode) {
> > +               err = ceph_wait_on_async_create(req->r_old_inode);
> > +               if (err) {
> > +                       dout("%s: wait for async create returned: %d\n",
> > +                            __func__, err);
> > +                       return err;
> > +               }
> > +       }
> > +
> >         dout("submit_request on %p for inode %p\n", req, dir);
> >         mutex_lock(&mdsc->mutex);
> >         __register_request(mdsc, req, dir);
> > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > index 31f68897bc87..acad9adca0af 100644
> > --- a/fs/ceph/mds_client.h
> > +++ b/fs/ceph/mds_client.h
> > @@ -543,4 +543,12 @@ extern int ceph_trim_caps(struct ceph_mds_client *mdsc,
> >                           int max_caps);
> > 
> >  extern u64 ceph_get_deleg_ino(struct ceph_mds_session *session);
> > +
> > +static inline int ceph_wait_on_async_create(struct inode *inode)
> > +{
> > +       struct ceph_inode_info *ci = ceph_inode(inode);
> > +
> > +       return wait_on_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT,
> > +                          TASK_INTERRUPTIBLE);
> > +}
> >  #endif
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index ea68eef977ef..47fb6e022339 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -319,7 +319,7 @@ struct ceph_inode_info {
> >         u64 i_inline_version;
> >         u32 i_time_warp_seq;
> > 
> > -       unsigned i_ceph_flags;
> > +       unsigned long i_ceph_flags;
> >         atomic64_t i_release_count;
> >         atomic64_t i_ordered_count;
> >         atomic64_t i_complete_seq[2];
> > @@ -527,6 +527,8 @@ static inline struct inode *ceph_find_inode(struct super_block *sb,
> >  #define CEPH_I_ERROR_WRITE     (1 << 10) /* have seen write errors */
> >  #define CEPH_I_ERROR_FILELOCK  (1 << 11) /* have seen file lock errors */
> >  #define CEPH_I_ODIRECT         (1 << 12) /* inode in direct I/O mode */
> > +#define CEPH_ASYNC_CREATE_BIT  (13)      /* async create in flight for this */
> > +#define CEPH_I_ASYNC_CREATE    (1 << CEPH_ASYNC_CREATE_BIT)
> > 
> >  /*
> >   * Masks of ceph inode work.
> > --
> > 2.24.1
> > 

-- 
Jeff Layton <jlayton@kernel.org>

