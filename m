Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F640241CFE
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Aug 2020 17:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbgHKPNM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 11 Aug 2020 11:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728907AbgHKPNI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 11 Aug 2020 11:13:08 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5CDC06174A
        for <ceph-devel@vger.kernel.org>; Tue, 11 Aug 2020 08:13:08 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id l13so6095401qvt.10
        for <ceph-devel@vger.kernel.org>; Tue, 11 Aug 2020 08:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+WowTH5yNx6MNaR5B21KZgWQPr/j7Aa+1RuCYhlMUVg=;
        b=MK2STPcNVRdWbdO2sm0O/NbDPBVsGyRuMA3f9NTlS09KvGEp3CqjYZ4gp9TPRUzGRR
         0b0p1b0uO+MSNpB0QduQkxHchD+sOA17jJ2ar6QN+P63gHOeHQj/Dx+Rnc/ORJaG0tiO
         t4ejhbGHwpIs6/+l0KSq0/XvXT93zxBX4An1VrKQkl0Sk26IB64mVxdI+mq7vFPfsQ1e
         x11FbPmobMtjG2+5PKQGQ2X/wZHXcBzH/46Qt1tacolsPaa9ok7003IHf8HKSaqlFfvN
         hd+0grlXSkLZs+l1dCoNiVnPsJY7gb4exKUqRW/i6thVnFQM0hmVjgmKB3JbN6c1T5mk
         nExg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+WowTH5yNx6MNaR5B21KZgWQPr/j7Aa+1RuCYhlMUVg=;
        b=gnNKvZGBZ4XBGTn3J47yna7zPdEZ/hZHsVONwvByFJTVfo8t99JeExo4DyFGvR5YuS
         D+0aMI56RVDDcGZXdwM8brmNjNW6MaULOVIJj8ZO2e9WnpzNqgy+V0ruLnGx4ePUPndv
         ETDOijbChMt1DKUKvPexDJVdt0uOcdhNA6lV2fVH7RRWUnSStwMxm8YvFzF8hgP9HEzG
         tMlX6Dk5P5Pk43++eGu99A04Ug2++PBw725Y3MIFi83NT0EwUSlPBtyR/g9u/cpyrmBM
         h6u82uPtO3DD8dIECppp2fXEFWosgPVxSQcUThDVwlxV/PQHkb7hMXjgIev/vGLWnNwL
         BOKg==
X-Gm-Message-State: AOAM532ma1xdEWy+eKQ6gzqz0eVyZytIk3vXG+6xD3jJtJLcrOEGmQY3
        4I2JhAKHwkKlfRKEP3L062NN59TCSgCleVSWKoU=
X-Google-Smtp-Source: ABdhPJxv3r24fswbhhnEDvwhNWsu54d0n4Zc1wuZB50FXgDBTypvH3q+lxkxRas9XA0lCeusNi7+bHcQlEXxx3lvi68=
X-Received: by 2002:ad4:5812:: with SMTP id dd18mr1779655qvb.23.1597158787296;
 Tue, 11 Aug 2020 08:13:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200811072303.24322-1-zyan@redhat.com> <403878ffc7403157096472bd1bc59b87c378c2a8.camel@kernel.org>
In-Reply-To: <403878ffc7403157096472bd1bc59b87c378c2a8.camel@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 11 Aug 2020 23:12:55 +0800
Message-ID: <CAAM7YA=8VJ12o9xrNwHdJH3tozfdvsS3xkTJi7S6ZX2xkcDNqw@mail.gmail.com>
Subject: Re: [PATCH] ceph: encode inodes' parent/d_name in cap reconnect message
To:     Jeff Layton <jlayton@kernel.org>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Aug 11, 2020 at 7:31 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Tue, 2020-08-11 at 15:23 +0800, Yan, Zheng wrote:
> > Since nautilus, MDS tracks dirfrags whose child inodes have caps in open
> > file table. When MDS recovers, it prefetches all of these dirfrags. This
> > avoids using backtrace to load inodes. But dirfrags prefetch may load
> > lots of useless inodes into cache, and make MDS run out of memory.
> >
> > Recent MDS adds an option that disables dirfrags prefetch. When dirfrags
> > prefetch is disabled. Recovering MDS only prefetches corresponding dir
> > inodes. Including inodes' parent/d_name in cap reconnect message can
> > help MDS to load inodes into its cache.
> >
> > Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> > ---
> >  fs/ceph/mds_client.c | 89 ++++++++++++++++++++++++++++++--------------
> >  1 file changed, 61 insertions(+), 28 deletions(-)
> >
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 9a09d12569bd..4eaed12b4b4c 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -3553,6 +3553,39 @@ static int send_reconnect_partial(struct ceph_reconnect_state *recon_state)
> >       return err;
> >  }
> >
> > +static struct dentry* d_find_primary(struct inode *inode)
> > +{
> > +     struct dentry *alias, *dn = NULL;
> > +
> > +     if (hlist_empty(&inode->i_dentry))
> > +             return NULL;
> > +
> > +     spin_lock(&inode->i_lock);
> > +     if (hlist_empty(&inode->i_dentry))
> > +             goto out_unlock;
> > +
> > +     if (S_ISDIR(inode->i_mode)) {
> > +             alias = hlist_entry(inode->i_dentry.first, struct dentry, d_u.d_alias);
> > +             if (!IS_ROOT(alias))
> > +                     dn = dget(alias);
> > +             goto out_unlock;
> > +     }
> > +
> > +     hlist_for_each_entry(alias, &inode->i_dentry, d_u.d_alias) {
> > +             spin_lock(&alias->d_lock);
> > +             if (!d_unhashed(alias) &&
> > +                 (ceph_dentry(alias)->flags & CEPH_DENTRY_PRIMARY_LINK)) {
> > +                     dn = dget_dlock(alias);
> > +             }
> > +             spin_unlock(&alias->d_lock);
> > +             if (dn)
> > +                     break;
> > +     }
> > +out_unlock:
> > +     spin_unlock(&inode->i_lock);
> > +     return dn;
> > +}
> > +
> >  /*
> >   * Encode information about a cap for a reconnect with the MDS.
> >   */
> > @@ -3566,13 +3599,32 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
> >       struct ceph_inode_info *ci = cap->ci;
> >       struct ceph_reconnect_state *recon_state = arg;
> >       struct ceph_pagelist *pagelist = recon_state->pagelist;
> > -     int err;
> > +     struct dentry *dentry;
> > +     char *path;
> > +     int pathlen, err;
> > +     u64 pathbase;
> >       u64 snap_follows;
> >
> >       dout(" adding %p ino %llx.%llx cap %p %lld %s\n",
> >            inode, ceph_vinop(inode), cap, cap->cap_id,
> >            ceph_cap_string(cap->issued));
> >
> > +     dentry = d_find_primary(inode);
> > +     if (dentry) {
> > +             /* set pathbase to parent dir when msg_version >= 2 */
> > +             path = ceph_mdsc_build_path(dentry, &pathlen, &pathbase,
> > +                                         recon_state->msg_version >= 2);
>
> One question:
>
> Do we really need to build a full path back to the root for the
> msg_version == 1 case? I notice that the v1 message has a field for the
> pathbase, which would seem to make the full path unnecessary. Is there
> some quirk in older MDS versions that requires a full path for this?
>

emperor and older mds require this. I guess no one uses mds that old.
So  it's OK to always build relative path.

Regards
Yan, Zheng

>
> > +             dput(dentry);
> > +             if (IS_ERR(path)) {
> > +                     err = PTR_ERR(path);
> > +                     goto out_err;
> > +             }
> > +     } else {
> > +             path = NULL;
> > +             pathlen = 0;
> > +             pathbase = 0;
> > +     }
> > +
> >       spin_lock(&ci->i_ceph_lock);
> >       cap->seq = 0;        /* reset cap seq */
> >       cap->issue_seq = 0;  /* and issue_seq */
> > @@ -3593,7 +3645,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
> >               rec.v2.wanted = cpu_to_le32(__ceph_caps_wanted(ci));
> >               rec.v2.issued = cpu_to_le32(cap->issued);
> >               rec.v2.snaprealm = cpu_to_le64(ci->i_snap_realm->ino);
> > -             rec.v2.pathbase = 0;
> > +             rec.v2.pathbase = cpu_to_le64(pathbase);
> >               rec.v2.flock_len = (__force __le32)
> >                       ((ci->i_ceph_flags & CEPH_I_ERROR_FILELOCK) ? 0 : 1);
> >       } else {
> > @@ -3604,7 +3656,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
> >               ceph_encode_timespec64(&rec.v1.mtime, &inode->i_mtime);
> >               ceph_encode_timespec64(&rec.v1.atime, &inode->i_atime);
> >               rec.v1.snaprealm = cpu_to_le64(ci->i_snap_realm->ino);
> > -             rec.v1.pathbase = 0;
> > +             rec.v1.pathbase = cpu_to_le64(pathbase);
> >       }
> >
> >       if (list_empty(&ci->i_cap_snaps)) {
> > @@ -3666,7 +3718,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
> >                           sizeof(struct ceph_filelock);
> >               rec.v2.flock_len = cpu_to_le32(struct_len);
> >
> > -             struct_len += sizeof(u32) + sizeof(rec.v2);
> > +             struct_len += sizeof(u32) + pathlen + sizeof(rec.v2);
> >
> >               if (struct_v >= 2)
> >                       struct_len += sizeof(u64); /* snap_follows */
> > @@ -3690,7 +3742,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
> >                       ceph_pagelist_encode_8(pagelist, 1);
> >                       ceph_pagelist_encode_32(pagelist, struct_len);
> >               }
> > -             ceph_pagelist_encode_string(pagelist, NULL, 0);
> > +             ceph_pagelist_encode_string(pagelist, path, pathlen);
> >               ceph_pagelist_append(pagelist, &rec, sizeof(rec.v2));
> >               ceph_locks_to_pagelist(flocks, pagelist,
> >                                      num_fcntl_locks, num_flock_locks);
> > @@ -3699,39 +3751,20 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
> >  out_freeflocks:
> >               kfree(flocks);
> >       } else {
> > -             u64 pathbase = 0;
> > -             int pathlen = 0;
> > -             char *path = NULL;
> > -             struct dentry *dentry;
> > -
> > -             dentry = d_find_alias(inode);
> > -             if (dentry) {
> > -                     path = ceph_mdsc_build_path(dentry,
> > -                                             &pathlen, &pathbase, 0);
> > -                     dput(dentry);
> > -                     if (IS_ERR(path)) {
> > -                             err = PTR_ERR(path);
> > -                             goto out_err;
> > -                     }
> > -                     rec.v1.pathbase = cpu_to_le64(pathbase);
> > -             }
> > -
> >               err = ceph_pagelist_reserve(pagelist,
> >                                           sizeof(u64) + sizeof(u32) +
> >                                           pathlen + sizeof(rec.v1));
> > -             if (err) {
> > -                     goto out_freepath;
> > -             }
> > +             if (err)
> > +                     goto out_err;
> >
> >               ceph_pagelist_encode_64(pagelist, ceph_ino(inode));
> >               ceph_pagelist_encode_string(pagelist, path, pathlen);
> >               ceph_pagelist_append(pagelist, &rec, sizeof(rec.v1));
> > -out_freepath:
> > -             ceph_mdsc_free_path(path, pathlen);
> >       }
> >
> >  out_err:
> > -     if (err >= 0)
> > +     ceph_mdsc_free_path(path, pathlen);
> > +     if (!err)
> >               recon_state->nr_caps++;
> >       return err;
> >  }
>
> --
> Jeff Layton <jlayton@kernel.org>
>
