Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B04F01164FD
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Dec 2019 03:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfLICNz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 8 Dec 2019 21:13:55 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:40566 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbfLICNz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 8 Dec 2019 21:13:55 -0500
Received: by mail-il1-f193.google.com with SMTP id b15so11336148ila.7;
        Sun, 08 Dec 2019 18:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=k15R5nnH7ejDpMt2qDC/YjWGHq/27T3NqR985G0b1io=;
        b=e0YvdE3pADvK2Ktnt0flJw9zLH2RNpK3dJowZUsSejzeefqwu7BqYYIeAY01iQt7cn
         Z9s/Gk0ybxsjTSfOItKoypebt/D1cSPOPwVd1PBfSvFvNPpUph4qoH1IcXYJyDaJhRTL
         j5FOw6lY1ggO3hL/aExyG+zCF6bG3Lu5ACeuK0YxQfJFk3r3dK473a4gLDcOacqGeiuU
         yqg3OHtgpPy7qZ/Rl9BVaHBCJZkqKBh5tZl5FLFoHHAc0J05ijxNFI3Oi5DNRUf7xvDc
         yAI4qM2ofJdINtkmivJhdalTyrdIO8v8rkoTQQ5/9xCv2gECnlcpbO/SOAnu+eRIHRO1
         d8zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=k15R5nnH7ejDpMt2qDC/YjWGHq/27T3NqR985G0b1io=;
        b=B8rVOxu+ng1LiM2Hk4C/QSePR+ZPxWb6lEMxQp5QBrMQ+LgUE4YMyBHSfuZnqUkI+z
         lz3KlzQUal15K8YlHIAEaisKGrF7O4w1qqzo7Tr7grSCnnQihlIOUNzWttkbwTL+nTS7
         nJcwhR4pt5AZyHKzbKjP20pJepiJ/7OTv+R6a0RyFDw7fqTNDjjIG+EdloCU1yFMicKy
         6bMIh4bhI4WUWWSUvXCvYzDEKEsm5qUf0v3X0sp7uj3lnwEGkdrcujw3APnXHHRqzxuD
         Th2q9uJ0P6MY7gjOK5SpHPA/vwI5TTa202fNE/WYMA0/35DNsuUaqQvsBiR95WZ6XjJg
         6a5g==
X-Gm-Message-State: APjAAAWvFzfnmKPM28BwFV3/dbrdyhGwIZRPRWUd5ZF8QqMx+r5ySxzH
        eZzS4wbjG4ww6P2lQKdEFEyclRoDU0nwSpkqaJ4=
X-Google-Smtp-Source: APXvYqxv5NywBnj4CHBu47U5qi0QCZ9tpg7hVXEx/R4Tuj/ZqbHkan08oiS9gCkMH9qRlDjKXXFtvT/03EDiC01wC4c=
X-Received: by 2002:a92:6a08:: with SMTP id f8mr24730721ilc.27.1575857634060;
 Sun, 08 Dec 2019 18:13:54 -0800 (PST)
MIME-Version: 1.0
References: <20191204031005.2638-1-gmayyyha@gmail.com> <20191204103629.GA22244@hermes.olymp>
 <CAB9OAC2vzPy=ELYzDRjBvA6m8T8AvwdJugS2NoCczwD1+Xb36Q@mail.gmail.com> <20191205102433.GA5758@hermes.olymp>
In-Reply-To: <20191205102433.GA5758@hermes.olymp>
From:   Yanhu Cao <gmayyyha@gmail.com>
Date:   Mon, 9 Dec 2019 10:13:41 +0800
Message-ID: <CAB9OAC3eH89pA4EORu93gE+r9LJ7CW_gBYr4dSn0u3K3+p7T8w@mail.gmail.com>
Subject: Re: [PATCH] ceph: check set quota operation support before syncing setxattr.
To:     Luis Henriques <lhenriques@suse.com>
Cc:     jlayton@kernel.org, sage@redhat.com, idryomov@gmail.com,
        ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Dec 5, 2019 at 6:24 PM Luis Henriques <lhenriques@suse.com> wrote:
>
> On Thu, Dec 05, 2019 at 10:42:46AM +0800, Yanhu Cao wrote:
> > On Wed, Dec 4, 2019 at 6:36 PM Luis Henriques <lhenriques@suse.com> wro=
te:
> > >
> > > On Wed, Dec 04, 2019 at 11:10:05AM +0800, Yanhu Cao wrote:
> > > > Environment
> > > > -----------
> > > > ceph version: 12.2.*
> > > > kernel version: 4.19+
> > > >
> > > > setfattr quota operation actually sends op to MDS, and settings
> > > > effective. but kclient outputs 'Operation not supported'. This may =
confuse
> > > > users' understandings.
> > >
> > > What exactly do you mean by "settings effective"?  There have been
> > > changes in the way CephFS quotas work in mimic and, if you're using a
> > > Luminous cluster (12.2.*) the kernel client effectively does *not*
> > > support quotas -- you'll be able to exceed the quotas you've tried to
> > > set because the client won't be checking the limits.  Thus, -EOPNOTSU=
PP
> > > seems appropriate for this scenario.
> > >
> > > I guess that the confusing part is that the xattr is actually set in
> > > that case, but the kernel client won't be able to use it to validate
> > > quotas in the filesystem tree because realms won't be created.
> > >
> > Yes. we use kcephfs+nfs for CentOS6.*, it does not support ceph-fuse(12=
.2.*).
> > The operating system of other applications is CentOS7.*, which uses
> > ceph-fuse and can get quota settings set by kclient.
>
> Ok, so if I understand correctly, you're setting quotas with the kernel
> client but actually using ceph-fuse on CentOS7 (I'm assuming a Luminous
> cluster).  This should work fine for the fuse-client, but please note
> that the kernel client will not respect quotas.
Yes. do with fuse-client now.

>
> Anyway, the ideal solution for this would be for the kernel to not set
> the xattr if the cluster doesn't support the new quotas format
> introduced in Mimic.  Unfortunately, the only way we have to find that
> out is to set the xattr and see if we get a snap_realm.
Therefore, I think that if kclient is incompatible with the ceph
version, logically, op should not be sent to MDS.

Thanks.
BRs

>
> Cheers,
> --
> Lu=C3=ADs
>
> >
> > Thanks.
> > BRs
> >
> > > Cheers,
> > > --
> > > Lu=C3=ADs
> > > >
> > > > If the kernel version and ceph version are not compatible, should c=
heck
> > > > quota operations are supported first, then do sync_setxattr.
> > > >
> > > > reference: https://docs.ceph.com/docs/master/cephfs/quota/
> > > >
> > > > Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> > > > ---
> > > >  fs/ceph/xattr.c | 6 ++++--
> > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> > > > index cb18ee637cb7..189aace75186 100644
> > > > --- a/fs/ceph/xattr.c
> > > > +++ b/fs/ceph/xattr.c
> > > > @@ -1132,8 +1132,8 @@ int __ceph_setxattr(struct inode *inode, cons=
t char *name,
> > > >                                   "during filling trace\n", inode);
> > > >               err =3D -EBUSY;
> > > >       } else {
> > > > -             err =3D ceph_sync_setxattr(inode, name, value, size, =
flags);
> > > > -             if (err >=3D 0 && check_realm) {
> > > > +             err =3D 0;
> > > > +             if (check_realm) {
> > > >                       /* check if snaprealm was created for quota i=
node */
> > > >                       spin_lock(&ci->i_ceph_lock);
> > > >                       if ((ci->i_max_files || ci->i_max_bytes) &&
> > > > @@ -1142,6 +1142,8 @@ int __ceph_setxattr(struct inode *inode, cons=
t char *name,
> > > >                               err =3D -EOPNOTSUPP;
> > > >                       spin_unlock(&ci->i_ceph_lock);
> > > >               }
> > > > +             if (err =3D=3D 0)
> > > > +                     err =3D ceph_sync_setxattr(inode, name, value=
, size, flags);
> > > >       }
> > > >  out:
> > > >       ceph_free_cap_flush(prealloc_cf);
> > > > --
> > > > 2.21.0 (Apple Git-122.2)
> > > >
