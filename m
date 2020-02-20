Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06D52165CCC
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Feb 2020 12:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbgBTLbA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Feb 2020 06:31:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:54250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726882AbgBTLa7 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 20 Feb 2020 06:30:59 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11F4C2071E;
        Thu, 20 Feb 2020 11:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582198258;
        bh=JeT935qfgV90jWNB9g5iqtBsRAkoX3POmvWGCOSHOFQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AkK7PObyTingOTAlSRtcFw+r+LuWWF/a3QyszaNA6gVITs2W0hqrI+N3i9L9I/fJk
         xr6L06YaMAnGvqqCHG4hg9hLzjtsmMS7tHjjBXWlUqsAaR1b8XefpJJf5SHQk1/I7k
         qXVJUz36zicn9CTDKK1qW61Dy2H24lF2PF+JBWBE=
Message-ID: <63625267b3fddcadc112034695c6f1656abc36e3.camel@kernel.org>
Subject: Re: [PATCH v5 05/12] ceph: cap tracking for async directory
 operations
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Zheng Yan <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Xiubo Li <xiubli@redhat.com>
Date:   Thu, 20 Feb 2020 06:30:56 -0500
In-Reply-To: <CAAM7YAk-cjnPqH0UhBRvzvZdk4JTXwuVzxBD8ObunQqVxm2NuQ@mail.gmail.com>
References: <20200219132526.17590-1-jlayton@kernel.org>
         <20200219132526.17590-6-jlayton@kernel.org>
         <CAAM7YAk-cjnPqH0UhBRvzvZdk4JTXwuVzxBD8ObunQqVxm2NuQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-02-20 at 14:42 +0800, Yan, Zheng wrote:
> On Wed, Feb 19, 2020 at 9:27 PM Jeff Layton <jlayton@kernel.org> wrote:
> > Track and correctly handle directory caps for asynchronous operations.
> > Add aliases for Frc caps that we now designate at Dcu caps (when dealing
> > with directories).
> > 
> > Unlike file caps, we don't reclaim these when the session goes away, and
> > instead preemptively release them. In-flight async dirops are instead
> > handled during reconnect phase. The client needs to re-do a synchronous
> > operation in order to re-get directory caps.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/caps.c               | 29 ++++++++++++++++++++---------
> >  fs/ceph/mds_client.c         | 31 ++++++++++++++++++++++++++-----
> >  fs/ceph/mds_client.h         |  6 +++++-
> >  include/linux/ceph/ceph_fs.h |  6 ++++++
> >  4 files changed, 57 insertions(+), 15 deletions(-)
> > 
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index 295837215a3a..d6c5ee33f30f 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -992,7 +992,11 @@ int __ceph_caps_file_wanted(struct ceph_inode_info *ci)
> >  int __ceph_caps_wanted(struct ceph_inode_info *ci)
> >  {
> >         int w = __ceph_caps_file_wanted(ci) | __ceph_caps_used(ci);
> > -       if (!S_ISDIR(ci->vfs_inode.i_mode)) {
> > +       if (S_ISDIR(ci->vfs_inode.i_mode)) {
> > +               /* we want EXCL if holding caps of dir ops */
> > +               if (w & CEPH_CAP_ANY_DIR_OPS)
> > +                       w |= CEPH_CAP_FILE_EXCL;
> > +       } else {
> >                 /* we want EXCL if dirty data */
> >                 if (w & CEPH_CAP_FILE_BUFFER)
> >                         w |= CEPH_CAP_FILE_EXCL;
> > @@ -1890,10 +1894,13 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
> >                          * revoking the shared cap on every create/unlink
> >                          * operation.
> >                          */
> > -                       if (IS_RDONLY(inode))
> > +                       if (IS_RDONLY(inode)) {
> >                                 want = CEPH_CAP_ANY_SHARED;
> > -                       else
> > -                               want = CEPH_CAP_ANY_SHARED | CEPH_CAP_FILE_EXCL;
> > +                       } else {
> > +                               want = CEPH_CAP_ANY_SHARED |
> > +                                      CEPH_CAP_FILE_EXCL |
> > +                                      CEPH_CAP_ANY_DIR_OPS;
> > +                       }
> >                         retain |= want;
> >                 } else {
> > 
> > @@ -2750,13 +2757,17 @@ int ceph_try_get_caps(struct inode *inode, int need, int want,
> >         int ret;
> > 
> >         BUG_ON(need & ~CEPH_CAP_FILE_RD);
> > -       BUG_ON(want & ~(CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO|CEPH_CAP_FILE_SHARED));
> > -       ret = ceph_pool_perm_check(inode, need);
> > -       if (ret < 0)
> > -               return ret;
> > +       if (need) {
> > +               ret = ceph_pool_perm_check(inode, need);
> > +               if (ret < 0)
> > +                       return ret;
> > +       }
> > 
> > +       BUG_ON(want & ~(CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_LAZYIO |
> > +                       CEPH_CAP_FILE_SHARED | CEPH_CAP_FILE_EXCL |
> > +                       CEPH_CAP_ANY_DIR_OPS));
> >         ret = try_get_cap_refs(inode, need, want, 0,
> > -                              (nonblock ? NON_BLOCKING : 0), got);
> > +                              nonblock ? NON_BLOCKING : 0, got);
> >         return ret == -EAGAIN ? 0 : ret;
> >  }
> > 
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 38eb9dd5062b..ef3dd6fe2f4d 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -699,6 +699,7 @@ void ceph_mdsc_release_request(struct kref *kref)
> >         struct ceph_mds_request *req = container_of(kref,
> >                                                     struct ceph_mds_request,
> >                                                     r_kref);
> > +       ceph_mdsc_release_dir_caps(req);
> 
> I think we can do this in complete_request()
> 

That's what I was doing originally, but doing it there complicates the
error handling in the case where we end up tearing down the request
before it's ever submitted for transmission. It's also weird, as
ceph_mdsc_release_request is where other resources for the request are
released.

It's safe to call it more than once though, so I suppose we could do it
in complete_request and here.

> >         destroy_reply_info(&req->r_reply_info);
> >         if (req->r_request)
> >                 ceph_msg_put(req->r_request);
> > @@ -3280,6 +3281,17 @@ static void handle_session(struct ceph_mds_session *session,
> >         return;
> >  }
> > 
> > +void ceph_mdsc_release_dir_caps(struct ceph_mds_request *req)
> > +{
> > +       int dcaps;
> > +
> > +       dcaps = xchg(&req->r_dir_caps, 0);
> > +       if (dcaps) {
> > +               dout("releasing r_dir_caps=%s\n", ceph_cap_string(dcaps));
> > +               ceph_put_cap_refs(ceph_inode(req->r_parent), dcaps);
> > +       }
> > +}
> > +
> >  /*
> >   * called under session->mutex.
> >   */
> > @@ -3307,9 +3319,14 @@ static void replay_unsafe_requests(struct ceph_mds_client *mdsc,
> >                         continue;
> >                 if (req->r_attempts == 0)
> >                         continue; /* only old requests */
> > -               if (req->r_session &&
> > -                   req->r_session->s_mds == session->s_mds)
> > -                       __send_request(mdsc, session, req, true);
> > +               if (!req->r_session)
> > +                       continue;
> > +               if (req->r_session->s_mds != session->s_mds)
> > +                       continue;
> > +
> > +               ceph_mdsc_release_dir_caps(req);
> > +
> > +               __send_request(mdsc, session, req, true);
> >         }
> >         mutex_unlock(&mdsc->mutex);
> >  }
> > @@ -3393,7 +3410,7 @@ static int send_reconnect_partial(struct ceph_reconnect_state *recon_state)
> >  /*
> >   * Encode information about a cap for a reconnect with the MDS.
> >   */
> > -static int encode_caps_cb(struct inode *inode, struct ceph_cap *cap,
> > +static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
> >                           void *arg)
> >  {
> >         union {
> > @@ -3416,6 +3433,10 @@ static int encode_caps_cb(struct inode *inode, struct ceph_cap *cap,
> >         cap->mseq = 0;       /* and migrate_seq */
> >         cap->cap_gen = cap->session->s_cap_gen;
> > 
> > +       /* These are lost when the session goes away */
> > +       if (S_ISDIR(inode->i_mode))
> > +               cap->issued &= ~CEPH_CAP_ANY_DIR_OPS;
> > +
> >         if (recon_state->msg_version >= 2) {
> >                 rec.v2.cap_id = cpu_to_le64(cap->cap_id);
> >                 rec.v2.wanted = cpu_to_le32(__ceph_caps_wanted(ci));
> > @@ -3712,7 +3733,7 @@ static void send_mds_reconnect(struct ceph_mds_client *mdsc,
> >                 recon_state.msg_version = 2;
> >         }
> >         /* trsaverse this session's caps */
> > -       err = ceph_iterate_session_caps(session, encode_caps_cb, &recon_state);
> > +       err = ceph_iterate_session_caps(session, reconnect_caps_cb, &recon_state);
> > 
> >         spin_lock(&session->s_cap_lock);
> >         session->s_cap_reconnect = 0;
> > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > index 8043f2b439b1..f10d342ea585 100644
> > --- a/fs/ceph/mds_client.h
> > +++ b/fs/ceph/mds_client.h
> > @@ -284,8 +284,11 @@ struct ceph_mds_request {
> >         struct ceph_msg  *r_request;  /* original request */
> >         struct ceph_msg  *r_reply;
> >         struct ceph_mds_reply_info_parsed r_reply_info;
> > -       struct page *r_locked_page;
> >         int r_err;
> > +
> > +
> > +       struct page *r_locked_page;
> > +       int r_dir_caps;
> >         int r_num_caps;
> >         u32               r_readdir_offset;
> > 
> > @@ -489,6 +492,7 @@ extern int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc,
> >  extern int ceph_mdsc_do_request(struct ceph_mds_client *mdsc,
> >                                 struct inode *dir,
> >                                 struct ceph_mds_request *req);
> > +extern void ceph_mdsc_release_dir_caps(struct ceph_mds_request *req);
> >  static inline void ceph_mdsc_get_request(struct ceph_mds_request *req)
> >  {
> >         kref_get(&req->r_kref);
> > diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> > index 94cc4b047987..91d09cf37649 100644
> > --- a/include/linux/ceph/ceph_fs.h
> > +++ b/include/linux/ceph/ceph_fs.h
> > @@ -663,6 +663,12 @@ int ceph_flags_to_mode(int flags);
> >  #define CEPH_CAP_LOCKS (CEPH_LOCK_IFILE | CEPH_LOCK_IAUTH | CEPH_LOCK_ILINK | \
> >                         CEPH_LOCK_IXATTR)
> > 
> > +/* cap masks async dir operations */
> > +#define CEPH_CAP_DIR_CREATE    CEPH_CAP_FILE_CACHE
> > +#define CEPH_CAP_DIR_UNLINK    CEPH_CAP_FILE_RD
> > +#define CEPH_CAP_ANY_DIR_OPS   (CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_RD | \
> > +                                CEPH_CAP_FILE_WREXTEND | CEPH_CAP_FILE_LAZYIO)
> > +
> >  int ceph_caps_for_mode(int mode);
> > 
> >  enum {
> > --
> > 2.24.1
> > 

-- 
Jeff Layton <jlayton@kernel.org>

