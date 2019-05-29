Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B88022DEDD
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2019 15:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbfE2Nu4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 May 2019 09:50:56 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38165 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfE2Nu4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 May 2019 09:50:56 -0400
Received: by mail-qt1-f195.google.com with SMTP id l3so2626752qtj.5
        for <ceph-devel@vger.kernel.org>; Wed, 29 May 2019 06:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rGBl45OwzBqCLT3aIRIcehbuCz5RxUZpaAC3carP/jA=;
        b=XY2SHbYgiDg7tvK1OjvAqfPoZEzgvnb+jBJOHScqY+3jJ0Zgi1tHAWEOhghqBMuRwD
         2fP3lPbfNp3MBQ/6epUG1jVgpll1XdXz+wWkm+CmtpypxUClCDsmnEdLrNqzaKeJwxns
         S5oW4aIZ1C6Q3DF8O8rxYk+fDn27s2HVkuawQXdaj6rvyVZFDgCiqu7EDALres69DS5Y
         jf2JpIBqqJnUqdyAO78mKpW4ct6pNErHx7s9d2Zv/6+aSFUV38SasXDvH5D6PDKwm7IU
         i3dIneBSTZMO8aNtW+Wa7Q5SWVj54LhZjF8Am+FVYH7pqowMtCEeMldJ37UivBSpl+De
         J68Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rGBl45OwzBqCLT3aIRIcehbuCz5RxUZpaAC3carP/jA=;
        b=FKiMffvvwkvSFT7+e2YHTvSKtknJvt++MdL8MHuZX61A5w3g/qZSqOk1AgfFz3Fo9o
         oq5Ck2+PounVMfAfjOincTklWN5f318HuQn3yeD/1o7m7XzcP//h8oYPVMPXk9rjlNrd
         sIElvdsQkBnZMW7b1dfpbjZ12F1qniOUAO2waOnP9Vey09yKWIJDLa0ATnZyS0A58iNh
         Gh+AmF0B2eXv/ktGavrRy4mEUzFCglbTbECsz5GAl4yoJc6r694GaJamHo7rubmUno5M
         O6GmW3rpBpkRMu8+Unenwa4yVJofcAzXDAaywX9bmocDJcJqDAYgP5hr5IqfiNe/UOjZ
         +fqA==
X-Gm-Message-State: APjAAAW94e6037uvRscSxrABMyf+sfv+6owpGY6yyDOFawb+daB7T1XQ
        mF66qnFrtxEIilbsWibmPidr7DWIX2jMjQ57r8vbCBsBPLY=
X-Google-Smtp-Source: APXvYqwPY9siErKnfpq5oiGPe1L9huGy6OAgFLwjAdIfitCAcLvGT77Gg3rvxLTdhVHqmUKLC0h2T55qE3eiOcx9ZVw=
X-Received: by 2002:a0c:9542:: with SMTP id m2mr85188114qvm.108.1559137854693;
 Wed, 29 May 2019 06:50:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190523081345.20410-1-zyan@redhat.com> <20190523081345.20410-4-zyan@redhat.com>
 <98860d8ffeb81da0d31fa3fc375fc354904d4279.camel@redhat.com>
In-Reply-To: <98860d8ffeb81da0d31fa3fc375fc354904d4279.camel@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Wed, 29 May 2019 21:50:43 +0800
Message-ID: <CAAM7YA=StMxNUxaGjufOhPGLXP-FPXudsVY3d-==WLvXVELbQA@mail.gmail.com>
Subject: Re: [PATCH 4/8] ceph: close race between d_name_cmp() and update_dentry_lease()
To:     Jeff Layton <jlayton@redhat.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>, idryomov@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, May 28, 2019 at 9:53 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Thu, 2019-05-23 at 16:13 +0800, Yan, Zheng wrote:
> > d_name_cmp() and update_dentry_lease() lock and unlock dentry->d_lock
> > respectively. Dentry may get renamed between them. The fix is moving
> > the dentry name compare into update_dentry_lease().
> >
> > This patch introduce two version of update_dentry_lease(). One version
> > is for the case that parent inode is locked. It does not need to check
> > parent/target inode and dentry name. Another version is for the case
> > that parent inode is not locked. It checks arent/target inode and dentry
> > name after locking dentry->d_lock.
> >
> > Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> > ---
> >  fs/ceph/inode.c | 164 ++++++++++++++++++++++++++----------------------
> >  1 file changed, 88 insertions(+), 76 deletions(-)
> >
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index 8cfece240ffe..e47a25495be5 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -1031,59 +1031,38 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
> >  }
> >
> >  /*
> > - * caller should hold session s_mutex.
> > + * caller should hold session s_mutex and dentry->d_lock.
> >   */
> > -static void update_dentry_lease(struct dentry *dentry,
> > -                             struct ceph_mds_reply_lease *lease,
> > -                             struct ceph_mds_session *session,
> > -                             unsigned long from_time,
> > -                             struct ceph_vino *tgt_vino,
> > -                             struct ceph_vino *dir_vino)
> > +static void __update_dentry_lease(struct inode *dir, struct dentry *dentry,
> > +                               struct ceph_mds_reply_lease *lease,
> > +                               struct ceph_mds_session *session,
> > +                               unsigned long from_time,
> > +                               struct ceph_mds_session **old_lease_session)
> >  {
> >       struct ceph_dentry_info *di = ceph_dentry(dentry);
> >       long unsigned duration = le32_to_cpu(lease->duration_ms);
> >       long unsigned ttl = from_time + (duration * HZ) / 1000;
> >       long unsigned half_ttl = from_time + (duration * HZ / 2) / 1000;
> > -     struct inode *dir;
> > -     struct ceph_mds_session *old_lease_session = NULL;
> > -
> > -     /*
> > -      * Make sure dentry's inode matches tgt_vino. NULL tgt_vino means that
> > -      * we expect a negative dentry.
> > -      */
> > -     if (!tgt_vino && d_really_is_positive(dentry))
> > -             return;
> > -
> > -     if (tgt_vino && (d_really_is_negative(dentry) ||
> > -                     !ceph_ino_compare(d_inode(dentry), tgt_vino)))
> > -             return;
> >
> > -     spin_lock(&dentry->d_lock);
> >       dout("update_dentry_lease %p duration %lu ms ttl %lu\n",
> >            dentry, duration, ttl);
> >
> > -     dir = d_inode(dentry->d_parent);
> > -
> > -     /* make sure parent matches dir_vino */
> > -     if (!ceph_ino_compare(dir, dir_vino))
> > -             goto out_unlock;
> > -
> >       /* only track leases on regular dentries */
> >       if (ceph_snap(dir) != CEPH_NOSNAP)
> > -             goto out_unlock;
> > +             return;
> >
> >       di->lease_shared_gen = atomic_read(&ceph_inode(dir)->i_shared_gen);
> >       if (duration == 0) {
> >               __ceph_dentry_dir_lease_touch(di);
> > -             goto out_unlock;
> > +             return;
> >       }
> >
> >       if (di->lease_gen == session->s_cap_gen &&
> >           time_before(ttl, di->time))
> > -             goto out_unlock;  /* we already have a newer lease. */
> > +             return;  /* we already have a newer lease. */
> >
> >       if (di->lease_session && di->lease_session != session) {
> > -             old_lease_session = di->lease_session;
> > +             *old_lease_session = di->lease_session;
> >               di->lease_session = NULL;
> >       }
> >
> > @@ -1096,6 +1075,62 @@ static void update_dentry_lease(struct dentry *dentry,
> >       di->time = ttl;
> >
> >       __ceph_dentry_lease_touch(di);
> > +}
> > +
> > +static inline void update_dentry_lease(struct inode *dir, struct dentry *dentry,
> > +                                     struct ceph_mds_reply_lease *lease,
> > +                                     struct ceph_mds_session *session,
> > +                                     unsigned long from_time)
> > +{
> > +     struct ceph_mds_session *old_lease_session = NULL;
> > +     spin_lock(&dentry->d_lock);
> > +     __update_dentry_lease(dir, dentry, lease, session, from_time,
> > +                           &old_lease_session);
> > +     spin_unlock(&dentry->d_lock);
> > +     if (old_lease_session)
> > +             ceph_put_mds_session(old_lease_session);
> > +}
> > +
> > +/*
> > + * update dentry lease without having parent inode locked
> > + */
> > +static void update_dentry_lease_careful(struct dentry *dentry,
> > +                                     struct ceph_mds_reply_lease *lease,
> > +                                     struct ceph_mds_session *session,
> > +                                     unsigned long from_time,
> > +                                     char *dname, u32 dname_len,
> > +                                     struct ceph_vino *pdvino,
> > +                                     struct ceph_vino *ptvino)
> > +
>
> This argument list is huge. I wonder if we'd be better off passing in a
> pointer to "req" instead and getting some of the fields from that. For
> instance, session, from_time, etc...
>

If we pass 'req' to update_dentry_lease_careful(), we need to
re-define some local variables already exist in ceph_fill_trace().  It
requires more code.

Regards
Yan, Zheng

> > +{
> > +     struct inode *dir;
> > +     struct ceph_mds_session *old_lease_session = NULL;
> > +
> > +     spin_lock(&dentry->d_lock);
> > +     /* make sure dentry's name matches target */
> > +     if (dentry->d_name.len != dname_len ||
> > +         memcmp(dentry->d_name.name, dname, dname_len))
> > +             goto out_unlock;
> > +
> > +     dir = d_inode(dentry->d_parent);
> > +     /* make sure parent matches dvino */
> > +     if (!ceph_ino_compare(dir, pdvino))
> > +             goto out_unlock;
> > +
> > +     /* make sure dentry's inode matches target. NULL ptvino means that
> > +      * we expect a negative dentry */
> > +     if (ptvino) {
> > +             if (d_really_is_negative(dentry))
> > +                     goto out_unlock;
> > +             if (!ceph_ino_compare(d_inode(dentry), ptvino))
> > +                     goto out_unlock;
> > +     } else {
> > +             if (d_really_is_positive(dentry))
> > +                     goto out_unlock;
> > +     }
> > +
> > +     __update_dentry_lease(dir, dentry, lease, session,
> > +                           from_time, &old_lease_session);
> >  out_unlock:
> >       spin_unlock(&dentry->d_lock);
> >       if (old_lease_session)
> > @@ -1160,19 +1195,6 @@ static int splice_dentry(struct dentry **pdn, struct inode *in)
> >       return 0;
> >  }
> >
> > -static int d_name_cmp(struct dentry *dentry, const char *name, size_t len)
> > -{
> > -     int ret;
> > -
> > -     /* take d_lock to ensure dentry->d_name stability */
> > -     spin_lock(&dentry->d_lock);
> > -     ret = dentry->d_name.len - len;
> > -     if (!ret)
> > -             ret = memcmp(dentry->d_name.name, name, len);
> > -     spin_unlock(&dentry->d_lock);
> > -     return ret;
> > -}
> > -
> >  /*
> >   * Incorporate results into the local cache.  This is either just
> >   * one inode, or a directory, dentry, and possibly linked-to inode (e.g.,
> > @@ -1375,10 +1397,9 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
> >                       } else if (have_lease) {
> >                               if (d_unhashed(dn))
> >                                       d_add(dn, NULL);
> > -                             update_dentry_lease(dn, rinfo->dlease,
> > -                                                 session,
> > -                                                 req->r_request_started,
> > -                                                 NULL, &dvino);
> > +                             update_dentry_lease(dir, dn,
> > +                                                 rinfo->dlease, session,
> > +                                                 req->r_request_started);
> >                       }
> >                       goto done;
> >               }
> > @@ -1400,11 +1421,9 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
> >               }
> >
> >               if (have_lease) {
> > -                     tvino.ino = le64_to_cpu(rinfo->targeti.in->ino);
> > -                     tvino.snap = le64_to_cpu(rinfo->targeti.in->snapid);
> > -                     update_dentry_lease(dn, rinfo->dlease, session,
> > -                                         req->r_request_started,
> > -                                         &tvino, &dvino);
> > +                     update_dentry_lease(dir, dn,
> > +                                         rinfo->dlease, session,
> > +                                         req->r_request_started);
> >               }
> >               dout(" final dn %p\n", dn);
> >       } else if ((req->r_op == CEPH_MDS_OP_LOOKUPSNAP ||
> > @@ -1422,27 +1441,20 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
> >               err = splice_dentry(&req->r_dentry, in);
> >               if (err < 0)
> >                       goto done;
> > -     } else if (rinfo->head->is_dentry &&
> > -                !d_name_cmp(req->r_dentry, rinfo->dname, rinfo->dname_len)) {
> > +     } else if (rinfo->head->is_dentry && req->r_dentry) {
> > +             /* parent inode is not locked, be carefull */
> >               struct ceph_vino *ptvino = NULL;
> > -
> > -             if ((le32_to_cpu(rinfo->diri.in->cap.caps) & CEPH_CAP_FILE_SHARED) ||
> > -                 le32_to_cpu(rinfo->dlease->duration_ms)) {
> > -                     dvino.ino = le64_to_cpu(rinfo->diri.in->ino);
> > -                     dvino.snap = le64_to_cpu(rinfo->diri.in->snapid);
> > -
> > -                     if (rinfo->head->is_target) {
> > -                             tvino.ino = le64_to_cpu(rinfo->targeti.in->ino);
> > -                             tvino.snap = le64_to_cpu(rinfo->targeti.in->snapid);
> > -                             ptvino = &tvino;
> > -                     }
> > -
> > -                     update_dentry_lease(req->r_dentry, rinfo->dlease,
> > -                             session, req->r_request_started, ptvino,
> > -                             &dvino);
> > -             } else {
> > -                     dout("%s: no dentry lease or dir cap\n", __func__);
> > +             dvino.ino = le64_to_cpu(rinfo->diri.in->ino);
> > +             dvino.snap = le64_to_cpu(rinfo->diri.in->snapid);
> > +             if (rinfo->head->is_target) {
> > +                     tvino.ino = le64_to_cpu(rinfo->targeti.in->ino);
> > +                     tvino.snap = le64_to_cpu(rinfo->targeti.in->snapid);
> > +                     ptvino = &tvino;
> >               }
> > +             update_dentry_lease_careful(req->r_dentry, rinfo->dlease,
> > +                                         session, req->r_request_started,
> > +                                         rinfo->dname, rinfo->dname_len,
> > +                                         &dvino, ptvino);
> >       }
> >  done:
> >       dout("fill_trace done err=%d\n", err);
> > @@ -1604,7 +1616,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
> >       /* FIXME: release caps/leases if error occurs */
> >       for (i = 0; i < rinfo->dir_nr; i++) {
> >               struct ceph_mds_reply_dir_entry *rde = rinfo->dir_entries + i;
> > -             struct ceph_vino tvino, dvino;
> > +             struct ceph_vino tvino;
> >
> >               dname.name = rde->name;
> >               dname.len = rde->name_len;
> > @@ -1705,9 +1717,9 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
> >
> >               ceph_dentry(dn)->offset = rde->offset;
> >
> > -             dvino = ceph_vino(d_inode(parent));
> > -             update_dentry_lease(dn, rde->lease, req->r_session,
> > -                                 req->r_request_started, &tvino, &dvino);
> > +             update_dentry_lease(d_inode(parent), dn,
> > +                                 rde->lease, req->r_session,
> > +                                 req->r_request_started);
> >
> >               if (err == 0 && skipped == 0 && cache_ctl.index >= 0) {
> >                       ret = fill_readdir_cache(d_inode(parent), dn,
>
> That said...
>
> Reviewed-by: Jeff Layton <jlayton@redhat.com>
>
