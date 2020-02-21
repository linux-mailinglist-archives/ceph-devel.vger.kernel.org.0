Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9F04167D18
	for <lists+ceph-devel@lfdr.de>; Fri, 21 Feb 2020 13:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgBUMGr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 21 Feb 2020 07:06:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:50978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727781AbgBUMGr (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 07:06:47 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E1FB207FD;
        Fri, 21 Feb 2020 12:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582286806;
        bh=EuSLImp7aVCdnfmt8QO5+oQWRXImjTVSYUrsmNmd0Ok=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=j66vl16IAm7JqTnCV//u5CRTmHhFjbkb2hL/H/KSOG7Fx3CHZLgN9rzRNRBmjahf0
         q3tGlrv8l567O2zi/0jxfzzG/eoOE1+2qb32uDmm4H3uNIELIYm6HbQo2NBfyEh0R5
         +9XwdIV9g/7SWq+7wRYDM65djLyEUz1qrhth3rZM=
Message-ID: <58e5e49c9543a9a97acaa82349d6bf230b6accba.camel@kernel.org>
Subject: Re: [PATCH 3/4] ceph: simplify calling of ceph_get_fmode()
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Date:   Fri, 21 Feb 2020 07:06:44 -0500
In-Reply-To: <CAAM7YAm+D_H+mqRJfCrAp+AbiX6Zf+tqWrRQOE8qKbPaaJ25Ow@mail.gmail.com>
References: <20200220122630.63170-1-zyan@redhat.com>
         <20200220122630.63170-3-zyan@redhat.com>
         <f849591457dd4c8ab4af42011fc49ca1960fb75e.camel@kernel.org>
         <CAAM7YAm+D_H+mqRJfCrAp+AbiX6Zf+tqWrRQOE8qKbPaaJ25Ow@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-02-21 at 10:34 +0800, Yan, Zheng wrote:
> On Fri, Feb 21, 2020 at 3:15 AM Jeff Layton <jlayton@kernel.org> wrote:
> > On Thu, 2020-02-20 at 20:26 +0800, Yan, Zheng wrote:
> > > Call ceph_get_fmode() when initializing file. Because fill_inode()
> > > already calls ceph_touch_fmode() for open file request. It affects
> > 
> > You mean __ceph_touch_fmode()
> > 
> > > __ceph_caps_file_wanted() for 'caps_wanted_delay_min' seconds, enough
> > > for ceph_get_fmode() to get called by ceph_init_file_info().
> > > 
> > 
> > I don't understand this changelog. Are you saying there is a potential
> > race of some sort, but that you don't think it's something we can hit in
> > practice?
> > 
> 
> threads run handle_reply() and open request initiator are different.
> there is a small window between waking up request initiator and
> request initiator calls ceph_get_fmode(). someone else may call
> ceph_check_caps() in the window and wrongly release wanted caps. This
> is the reason old code calls _ceph_get_fmode() in fill_inode().
> 
> 

Ok. So how are you addressing this race in this series? Is it just that
we now hold on to caps for a minimal amount of time, and we just assume
that ceph_get_fmode will be called before they can expire?

> > > Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> > > ---
> > >  fs/ceph/caps.c  | 26 +++-----------------------
> > >  fs/ceph/file.c  | 21 +++++----------------
> > >  fs/ceph/inode.c |  8 +-------
> > >  fs/ceph/super.h |  3 +--
> > >  4 files changed, 10 insertions(+), 48 deletions(-)
> > > 
> > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > index ccdc47bd7cf0..2f4ff7e9508e 100644
> > > --- a/fs/ceph/caps.c
> > > +++ b/fs/ceph/caps.c
> > > @@ -606,7 +606,7 @@ static void __check_cap_issue(struct ceph_inode_info *ci, struct ceph_cap *cap,
> > >   */
> > >  void ceph_add_cap(struct inode *inode,
> > >                 struct ceph_mds_session *session, u64 cap_id,
> > > -               int fmode, unsigned issued, unsigned wanted,
> > > +               unsigned issued, unsigned wanted,
> > >                 unsigned seq, unsigned mseq, u64 realmino, int flags,
> > >                 struct ceph_cap **new_cap)
> > >  {
> > > @@ -622,13 +622,6 @@ void ceph_add_cap(struct inode *inode,
> > >       dout("add_cap %p mds%d cap %llx %s seq %d\n", inode,
> > >            session->s_mds, cap_id, ceph_cap_string(issued), seq);
> > > 
> > > -     /*
> > > -      * If we are opening the file, include file mode wanted bits
> > > -      * in wanted.
> > > -      */
> > > -     if (fmode >= 0)
> > > -             wanted |= ceph_caps_for_mode(fmode);
> > > -
> > >       spin_lock(&session->s_gen_ttl_lock);
> > >       gen = session->s_cap_gen;
> > >       spin_unlock(&session->s_gen_ttl_lock);
> > > @@ -753,9 +746,6 @@ void ceph_add_cap(struct inode *inode,
> > >       cap->issue_seq = seq;
> > >       cap->mseq = mseq;
> > >       cap->cap_gen = gen;
> > > -
> > > -     if (fmode >= 0)
> > > -             __ceph_get_fmode(ci, fmode);
> > >  }
> > > 
> > >  /*
> > > @@ -3726,7 +3716,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
> > >               /* add placeholder for the export tagert */
> > >               int flag = (cap == ci->i_auth_cap) ? CEPH_CAP_FLAG_AUTH : 0;
> > >               tcap = new_cap;
> > > -             ceph_add_cap(inode, tsession, t_cap_id, -1, issued, 0,
> > > +             ceph_add_cap(inode, tsession, t_cap_id, issued, 0,
> > >                            t_seq - 1, t_mseq, (u64)-1, flag, &new_cap);
> > > 
> > >               if (!list_empty(&ci->i_cap_flush_list) &&
> > > @@ -3831,7 +3821,7 @@ static void handle_cap_import(struct ceph_mds_client *mdsc,
> > >       __ceph_caps_issued(ci, &issued);
> > >       issued |= __ceph_caps_dirty(ci);
> > > 
> > > -     ceph_add_cap(inode, session, cap_id, -1, caps, wanted, seq, mseq,
> > > +     ceph_add_cap(inode, session, cap_id, caps, wanted, seq, mseq,
> > >                    realmino, CEPH_CAP_FLAG_AUTH, &new_cap);
> > > 
> > >       ocap = peer >= 0 ? __get_cap_for_mds(ci, peer) : NULL;
> > > @@ -4186,16 +4176,6 @@ void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
> > >       spin_unlock(&ci->i_ceph_lock);
> > >  }
> > > 
> > > -void __ceph_get_fmode(struct ceph_inode_info *ci, int fmode)
> > > -{
> > > -     int i;
> > > -     int bits = (fmode << 1) | 1;
> > > -     for (i = 0; i < CEPH_FILE_MODE_BITS; i++) {
> > > -             if (bits & (1 << i))
> > > -                     ci->i_file_by_mode[i].nr++;
> > > -     }
> > > -}
> > > -
> > >  /*
> > >   * Drop open file reference.  If we were the last open file,
> > >   * we may need to release capabilities to the MDS (or schedule
> > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > index f28f420bad23..60a2dfa02ba2 100644
> > > --- a/fs/ceph/file.c
> > > +++ b/fs/ceph/file.c
> > > @@ -212,10 +212,8 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
> > >       if (isdir) {
> > >               struct ceph_dir_file_info *dfi =
> > >                       kmem_cache_zalloc(ceph_dir_file_cachep, GFP_KERNEL);
> > > -             if (!dfi) {
> > > -                     ceph_put_fmode(ci, fmode, 1); /* clean up */
> > > +             if (!dfi)
> > >                       return -ENOMEM;
> > > -             }
> > > 
> > >               file->private_data = dfi;
> > >               fi = &dfi->file_info;
> > > @@ -223,15 +221,15 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
> > >               dfi->readdir_cache_idx = -1;
> > >       } else {
> > >               fi = kmem_cache_zalloc(ceph_file_cachep, GFP_KERNEL);
> > > -             if (!fi) {
> > > -                     ceph_put_fmode(ci, fmode, 1); /* clean up */
> > > +             if (!fi)
> > >                       return -ENOMEM;
> > > -             }
> > > 
> > >               file->private_data = fi;
> > >       }
> > > 
> > > +     ceph_get_fmode(ci, fmode, 1);
> > >       fi->fmode = fmode;
> > > +
> > >       spin_lock_init(&fi->rw_contexts_lock);
> > >       INIT_LIST_HEAD(&fi->rw_contexts);
> > >       fi->meta_err = errseq_sample(&ci->i_meta_err);
> > > @@ -263,7 +261,6 @@ static int ceph_init_file(struct inode *inode, struct file *file, int fmode)
> > >       case S_IFLNK:
> > >               dout("init_file %p %p 0%o (symlink)\n", inode, file,
> > >                    inode->i_mode);
> > > -             ceph_put_fmode(ceph_inode(inode), fmode, 1); /* clean up */
> > >               break;
> > > 
> > >       default:
> > > @@ -273,7 +270,6 @@ static int ceph_init_file(struct inode *inode, struct file *file, int fmode)
> > >                * we need to drop the open ref now, since we don't
> > >                * have .release set to ceph_release.
> > >                */
> > > -             ceph_put_fmode(ceph_inode(inode), fmode, 1); /* clean up */
> > >               BUG_ON(inode->i_fop->release == ceph_release);
> > > 
> > >               /* call the proper open fop */
> > > @@ -327,7 +323,6 @@ int ceph_renew_caps(struct inode *inode, int fmode)
> > >       req->r_inode = inode;
> > >       ihold(inode);
> > >       req->r_num_caps = 1;
> > > -     req->r_fmode = -1;
> > > 
> > >       err = ceph_mdsc_do_request(mdsc, NULL, req);
> > >       ceph_mdsc_put_request(req);
> > > @@ -373,9 +368,6 @@ int ceph_open(struct inode *inode, struct file *file)
> > > 
> > >       /* trivially open snapdir */
> > >       if (ceph_snap(inode) == CEPH_SNAPDIR) {
> > > -             spin_lock(&ci->i_ceph_lock);
> > > -             __ceph_get_fmode(ci, fmode);
> > > -             spin_unlock(&ci->i_ceph_lock);
> > >               return ceph_init_file(inode, file, fmode);
> > >       }
> > > 
> > > @@ -393,7 +385,7 @@ int ceph_open(struct inode *inode, struct file *file)
> > >               dout("open %p fmode %d want %s issued %s using existing\n",
> > >                    inode, fmode, ceph_cap_string(wanted),
> > >                    ceph_cap_string(issued));
> > > -             __ceph_get_fmode(ci, fmode);
> > > +             __ceph_touch_fmode(ci, mdsc, fmode);
> > >               spin_unlock(&ci->i_ceph_lock);
> > > 
> > >               /* adjust wanted? */
> > > @@ -405,7 +397,6 @@ int ceph_open(struct inode *inode, struct file *file)
> > >               return ceph_init_file(inode, file, fmode);
> > >       } else if (ceph_snap(inode) != CEPH_NOSNAP &&
> > >                  (ci->i_snap_caps & wanted) == wanted) {
> > > -             __ceph_get_fmode(ci, fmode);
> > >               __ceph_touch_fmode(ci, mdsc, fmode);
> > >               spin_unlock(&ci->i_ceph_lock);
> > >               return ceph_init_file(inode, file, fmode);
> > > @@ -526,8 +517,6 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
> > >               err = finish_open(file, dentry, ceph_open);
> > >       }
> > >  out_req:
> > > -     if (!req->r_err && req->r_target_inode)
> > > -             ceph_put_fmode(ceph_inode(req->r_target_inode), req->r_fmode, 1);
> > >       ceph_mdsc_put_request(req);
> > >  out_ctx:
> > >       ceph_release_acl_sec_ctx(&as_ctx);
> > > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > > index b279bd8e168e..bb73b0c8c4d9 100644
> > > --- a/fs/ceph/inode.c
> > > +++ b/fs/ceph/inode.c
> > > @@ -969,7 +969,7 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
> > >               if (ceph_snap(inode) == CEPH_NOSNAP) {
> > >                       ceph_add_cap(inode, session,
> > >                                    le64_to_cpu(info->cap.cap_id),
> > > -                                  cap_fmode, info_caps,
> > > +                                  info_caps,
> > >                                    le32_to_cpu(info->cap.wanted),
> > >                                    le32_to_cpu(info->cap.seq),
> > >                                    le32_to_cpu(info->cap.mseq),
> > > @@ -994,13 +994,7 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
> > >                       dout(" %p got snap_caps %s\n", inode,
> > >                            ceph_cap_string(info_caps));
> > >                       ci->i_snap_caps |= info_caps;
> > > -                     if (cap_fmode >= 0)
> > > -                             __ceph_get_fmode(ci, cap_fmode);
> > >               }
> > > -     } else if (cap_fmode >= 0) {
> > > -             pr_warn("mds issued no caps on %llx.%llx\n",
> > > -                        ceph_vinop(inode));
> > > -             __ceph_get_fmode(ci, cap_fmode);
> > >       }
> > > 
> > >       if (iinfo->inline_version > 0 &&
> > > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > > index 029823643b8b..1ea76466efcb 100644
> > > --- a/fs/ceph/super.h
> > > +++ b/fs/ceph/super.h
> > > @@ -1038,7 +1038,7 @@ extern struct ceph_cap *ceph_get_cap(struct ceph_mds_client *mdsc,
> > >                                    struct ceph_cap_reservation *ctx);
> > >  extern void ceph_add_cap(struct inode *inode,
> > >                        struct ceph_mds_session *session, u64 cap_id,
> > > -                      int fmode, unsigned issued, unsigned wanted,
> > > +                      unsigned issued, unsigned wanted,
> > >                        unsigned cap, unsigned seq, u64 realmino, int flags,
> > >                        struct ceph_cap **new_cap);
> > >  extern void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release);
> > > @@ -1080,7 +1080,6 @@ extern int ceph_try_get_caps(struct inode *inode,
> > >                            int need, int want, bool nonblock, int *got);
> > > 
> > >  /* for counting open files by mode */
> > > -extern void __ceph_get_fmode(struct ceph_inode_info *ci, int mode);
> > >  extern void ceph_get_fmode(struct ceph_inode_info *ci, int mode, int count);
> > >  extern void ceph_put_fmode(struct ceph_inode_info *ci, int mode, int count);
> > >  extern void __ceph_touch_fmode(struct ceph_inode_info *ci,
> > 
> > --
> > Jeff Layton <jlayton@kernel.org>
> > 

-- 
Jeff Layton <jlayton@kernel.org>

