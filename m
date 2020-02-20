Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6AE6165EE1
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Feb 2020 14:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgBTNd5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Feb 2020 08:33:57 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:37628 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728102AbgBTNd4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 20 Feb 2020 08:33:56 -0500
Received: by mail-qv1-f67.google.com with SMTP id s6so1868622qvq.4
        for <ceph-devel@vger.kernel.org>; Thu, 20 Feb 2020 05:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Tji+V291W6KOtC1P2xSyuZBzeip3UZ0L42IGfEQoRo=;
        b=GUj3K5PWDzNEtulD7J8KKddSxunDFAoh+4P+cxXQjjQRDZF8Tb7XPEwNc5Y7018KkU
         X3kJWjPRDCIOpfhzWk2dzA4xqhaSv6Jr6NIItMhPQRvWTKfqtkfCwUJ3B2YnGcQnYMFF
         E1/+qzK6dPaKvulx4RrdnKKNv0CAaV55vwxK0P2nflQFS19T8fJHSTsCAeXWtbo+BF1I
         nnGMWL4wn22cLuMOyjmnyxsR5IqlGXhMF6PPoDMDkg4MMxhdkBJtx8CfcJslEb1JbQYw
         b42oCNrMo57m6rEf8Nla+wpSvetswrQFC9ITLu5BEqVosHsJC/4YmOV0ILU8vI13GAVY
         6nyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Tji+V291W6KOtC1P2xSyuZBzeip3UZ0L42IGfEQoRo=;
        b=nweDLUWwryBc9InW5Fw7GgBl8TtmIk5nao8XY27IMiH6ddAmqNPb9cajJQt5ElAWK0
         BcylOvxmCMuilRgBsMGMFyJTZcsrUjKVhVSHxk+BXyz0g94E1PdWdEzQEomqg5OWtD8x
         7llbZJ1XxM4Chisy1Pnda0gkcG/kiRjSD8TyoGrVEdI22lZQuWQibbawcwhrlTYZ6sXa
         oTpdRbirUT+pEaHam8kmhoWGEz5+0ekQ0OrsJX2JPgq5uhA8F1gKRTORgb9ey6DHhK0L
         8AHMVhRQFYSu/YUO2UkzI0Jd8d6ubAfqwocKODVdVjG83UQZ1bs/nGKFs4u2zGqB+oo/
         fvPA==
X-Gm-Message-State: APjAAAUus4mES+U/iHrnmy3GBEIihKzT8/VzO6cogkTE+m+9mZrE+YtW
        bv1kPkKMB+SQEh8cvR2WgkRpDhlxlEVQ8JY9mh0=
X-Google-Smtp-Source: APXvYqzVBQmIHHtkoWyER9rYVrYWC/OAkIzzeQYme/LSz5APecjXWAA6iwzPMzqMh0ombtA7A70fvPEQ00cYuBI1XUQ=
X-Received: by 2002:ad4:5663:: with SMTP id bm3mr9729222qvb.110.1582205635015;
 Thu, 20 Feb 2020 05:33:55 -0800 (PST)
MIME-Version: 1.0
References: <20200219132526.17590-1-jlayton@kernel.org> <20200219132526.17590-4-jlayton@kernel.org>
 <CAAM7YAn-bXrOHGrF4O0WY4hB7ZUj7_uCT=qy3NphbNbw15F6hA@mail.gmail.com> <89ba8857af29c0e877d22e2188f86142f316454a.camel@kernel.org>
In-Reply-To: <89ba8857af29c0e877d22e2188f86142f316454a.camel@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 20 Feb 2020 21:33:43 +0800
Message-ID: <CAAM7YAk0B5ANUT+B8sK1ddgFxBcinVXjiF9KpAdfU5chKWDX1g@mail.gmail.com>
Subject: Re: [PATCH v5 03/12] ceph: add infrastructure for waiting for async
 create to complete
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Zheng Yan <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Xiubo Li <xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Feb 20, 2020 at 9:01 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Thu, 2020-02-20 at 11:32 +0800, Yan, Zheng wrote:
> > On Wed, Feb 19, 2020 at 9:27 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > When we issue an async create, we must ensure that any later on-the-wire
> > > requests involving it wait for the create reply.
> > >
> > > Expand i_ceph_flags to be an unsigned long, and add a new bit that
> > > MDS requests can wait on. If the bit is set in the inode when sending
> > > caps, then don't send it and just return that it has been delayed.
> > >
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/caps.c       | 13 ++++++++++++-
> > >  fs/ceph/dir.c        |  2 +-
> > >  fs/ceph/mds_client.c | 20 +++++++++++++++++++-
> > >  fs/ceph/mds_client.h |  7 +++++++
> > >  fs/ceph/super.h      |  4 +++-
> > >  5 files changed, 42 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > index d05717397c2a..85e13aa359d2 100644
> > > --- a/fs/ceph/caps.c
> > > +++ b/fs/ceph/caps.c
> > > @@ -511,7 +511,7 @@ static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
> > >                                 struct ceph_inode_info *ci,
> > >                                 bool set_timeout)
> > >  {
> > > -       dout("__cap_delay_requeue %p flags %d at %lu\n", &ci->vfs_inode,
> > > +       dout("__cap_delay_requeue %p flags 0x%lx at %lu\n", &ci->vfs_inode,
> > >              ci->i_ceph_flags, ci->i_hold_caps_max);
> > >         if (!mdsc->stopping) {
> > >                 spin_lock(&mdsc->cap_delay_lock);
> > > @@ -1294,6 +1294,13 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
> > >         int delayed = 0;
> > >         int ret;
> > >
> > > +       /* Don't send anything if it's still being created. Return delayed */
> > > +       if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
> > > +               spin_unlock(&ci->i_ceph_lock);
> > > +               dout("%s async create in flight for %p\n", __func__, inode);
> > > +               return 1;
> > > +       }
> > > +
> >
> > Maybe it's better to check this in ceph_check_caps().  Other callers
> > of __send_cap() shouldn't encounter async creating inode
> >
>
> I've been looking, but what actually guarantees that?
>
> Only ceph_check_caps calls it for UPDATE, but the other two callers call
> it for FLUSH. I don't see what prevents the kernel from (e.g.) calling
> write_inode before the create reply comes in, particularly if we just
> create and then close the file.
>

I missed write_inode case. but make __send_cap() skip sending message
can cause problem. For example, if we skip a message that flush dirty
caps. call ceph_check_caps() again may not re-do the flush.

> As a side note, I still struggle with the fact thatthere seems to be no
> coherent overall description of the cap protocol. What distinguishes a
> FLUSH from an UPDATE, for instance? The MDS code and comments seem to
> treat them somewhat interchangeably.
>

UPDATE is super set of FLUSH, UPDATE can always replace FLUSH.

>
> > >         held = cap->issued | cap->implemented;
> > >         revoking = cap->implemented & ~cap->issued;
> > >         retain &= ~revoking;
> > > @@ -2250,6 +2257,10 @@ int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
> > >         if (datasync)
> > >                 goto out;
> > >
> > > +       ret = ceph_wait_on_async_create(inode);
> > > +       if (ret)
> > > +               goto out;
> > > +
> > >         dirty = try_flush_caps(inode, &flush_tid);
> > >         dout("fsync dirty caps are %s\n", ceph_cap_string(dirty));
> > >
> > > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > > index a87274935a09..5b83bda57056 100644
> > > --- a/fs/ceph/dir.c
> > > +++ b/fs/ceph/dir.c
> > > @@ -752,7 +752,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
> > >                 struct ceph_dentry_info *di = ceph_dentry(dentry);
> > >
> > >                 spin_lock(&ci->i_ceph_lock);
> > > -               dout(" dir %p flags are %d\n", dir, ci->i_ceph_flags);
> > > +               dout(" dir %p flags are 0x%lx\n", dir, ci->i_ceph_flags);
> > >                 if (strncmp(dentry->d_name.name,
> > >                             fsc->mount_options->snapdir_name,
> > >                             dentry->d_name.len) &&
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index 94d18e643a3d..38eb9dd5062b 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -2730,7 +2730,7 @@ static void kick_requests(struct ceph_mds_client *mdsc, int mds)
> > >  int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
> > >                               struct ceph_mds_request *req)
> > >  {
> > > -       int err;
> > > +       int err = 0;
> > >
> > >         /* take CAP_PIN refs for r_inode, r_parent, r_old_dentry */
> > >         if (req->r_inode)
> > > @@ -2743,6 +2743,24 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
> > >                 ceph_get_cap_refs(ceph_inode(req->r_old_dentry_dir),
> > >                                   CEPH_CAP_PIN);
> > >
> > > +       if (req->r_inode) {
> > > +               err = ceph_wait_on_async_create(req->r_inode);
> > > +               if (err) {
> > > +                       dout("%s: wait for async create returned: %d\n",
> > > +                            __func__, err);
> > > +                       return err;
> > > +               }
> > > +       }
> > > +
> > > +       if (!err && req->r_old_inode) {
> > > +               err = ceph_wait_on_async_create(req->r_old_inode);
> > > +               if (err) {
> > > +                       dout("%s: wait for async create returned: %d\n",
> > > +                            __func__, err);
> > > +                       return err;
> > > +               }
> > > +       }
> > > +
> > >         dout("submit_request on %p for inode %p\n", req, dir);
> > >         mutex_lock(&mdsc->mutex);
> > >         __register_request(mdsc, req, dir);
> > > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > > index 95ac00e59e66..8043f2b439b1 100644
> > > --- a/fs/ceph/mds_client.h
> > > +++ b/fs/ceph/mds_client.h
> > > @@ -538,4 +538,11 @@ extern void ceph_mdsc_open_export_target_sessions(struct ceph_mds_client *mdsc,
> > >  extern int ceph_trim_caps(struct ceph_mds_client *mdsc,
> > >                           struct ceph_mds_session *session,
> > >                           int max_caps);
> > > +static inline int ceph_wait_on_async_create(struct inode *inode)
> > > +{
> > > +       struct ceph_inode_info *ci = ceph_inode(inode);
> > > +
> > > +       return wait_on_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT,
> > > +                          TASK_INTERRUPTIBLE);
> > > +}
> > >  #endif
> > > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > > index 3430d7ffe8f7..bfb03adb4a08 100644
> > > --- a/fs/ceph/super.h
> > > +++ b/fs/ceph/super.h
> > > @@ -316,7 +316,7 @@ struct ceph_inode_info {
> > >         u64 i_inline_version;
> > >         u32 i_time_warp_seq;
> > >
> > > -       unsigned i_ceph_flags;
> > > +       unsigned long i_ceph_flags;
> > >         atomic64_t i_release_count;
> > >         atomic64_t i_ordered_count;
> > >         atomic64_t i_complete_seq[2];
> > > @@ -524,6 +524,8 @@ static inline struct inode *ceph_find_inode(struct super_block *sb,
> > >  #define CEPH_I_ERROR_WRITE     (1 << 10) /* have seen write errors */
> > >  #define CEPH_I_ERROR_FILELOCK  (1 << 11) /* have seen file lock errors */
> > >  #define CEPH_I_ODIRECT         (1 << 12) /* inode in direct I/O mode */
> > > +#define CEPH_ASYNC_CREATE_BIT  (13)      /* async create in flight for this */
> > > +#define CEPH_I_ASYNC_CREATE    (1 << CEPH_ASYNC_CREATE_BIT)
> > >
> > >  /*
> > >   * Masks of ceph inode work.
> > > --
> > > 2.24.1
> > >
>
> --
> Jeff Layton <jlayton@kernel.org>
>
