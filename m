Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46E40113A0B
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2019 03:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbfLECnA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Dec 2019 21:43:00 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:41663 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728548AbfLECm7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Dec 2019 21:42:59 -0500
Received: by mail-io1-f68.google.com with SMTP id z26so1966955iot.8;
        Wed, 04 Dec 2019 18:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vSYXq7k3D7T0dUleEUNaJBpJRJeTNo0CbEMieQSFYHs=;
        b=OAlH3TSVK/Ihtm0+HajQjItGYfwrIRCBBjFV/Jq4zFcQ4UILqZZ9O01MdQdPHTO94K
         RXkSag1msFqS9qcpaCFw3tFi8LKwaRNbNzcCcP+txvSJTZUIZghbvmRKh0QCArK+6vjo
         aQfdJj+3mDALDsspWeWTX26ZUmvxuU06vQbRezXjJ6wTuQPy7Qvurfu+7xtgTI7lGVhV
         U5Ub0HJE67O8y9USyAtE2JrAxkf32WGOozmWkSLWsxOo+WiGUShQGn6xUrJFLTYafiZB
         4Tt6Oiex20c6VWI9iZ5naBG3HddAx4DcJhCfwi37RXUs8pevPteod4qqWp9uuSipjM1D
         jsqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vSYXq7k3D7T0dUleEUNaJBpJRJeTNo0CbEMieQSFYHs=;
        b=dLylXVxn4mN+luOoEI69tsr9RqnmoshavUU772P17YU0i+2P7Ep8xcAk7EPhE04a9L
         Ziw4J9/YbNHG3V2+/KtCuxRMT/5Ge0KZlsoYSpVgv6Q6xpCAXm86VpQ5vMmXv0fy8bnc
         TRYLFTVebyX4+Qbqe+Ti5l5PHF6RhjLEpx4JIAgb4rDgxgrs8z43s7lVKFSBU1uG1oDz
         ImlZgp7j80KkIh+gXDDE4zIawlt7sux/OxqEAQddejr8+o2y39SWB05aUC8eWD3XH5nJ
         VVBb8b8ttiMMbus6ShE8KKaDj8oJmfFXg6jcMEt7AeKoZbkqvFRVoa5GDCaiXH1U6ggO
         IOvQ==
X-Gm-Message-State: APjAAAVkmi8IrVf/R+T+hu0zx3ztgr0/htm/Vf6yCH/pIRf6MFjrjL6D
        b3zM4zi2VZHr7El1TTov77DOwXfn7Luuzy/vRbw=
X-Google-Smtp-Source: APXvYqxjxJswzFYlrl9uW8u0CkKp94IvIZ2n+WI2Ew/dZQblDPXe5IPsqoDnmP6u7zEKBzaYLc2rUWnp2z1NuLM6VvA=
X-Received: by 2002:a6b:ab07:: with SMTP id u7mr4543829ioe.27.1575513778857;
 Wed, 04 Dec 2019 18:42:58 -0800 (PST)
MIME-Version: 1.0
References: <20191204031005.2638-1-gmayyyha@gmail.com> <20191204103629.GA22244@hermes.olymp>
In-Reply-To: <20191204103629.GA22244@hermes.olymp>
From:   Yanhu Cao <gmayyyha@gmail.com>
Date:   Thu, 5 Dec 2019 10:42:46 +0800
Message-ID: <CAB9OAC2vzPy=ELYzDRjBvA6m8T8AvwdJugS2NoCczwD1+Xb36Q@mail.gmail.com>
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

On Wed, Dec 4, 2019 at 6:36 PM Luis Henriques <lhenriques@suse.com> wrote:
>
> On Wed, Dec 04, 2019 at 11:10:05AM +0800, Yanhu Cao wrote:
> > Environment
> > -----------
> > ceph version: 12.2.*
> > kernel version: 4.19+
> >
> > setfattr quota operation actually sends op to MDS, and settings
> > effective. but kclient outputs 'Operation not supported'. This may conf=
use
> > users' understandings.
>
> What exactly do you mean by "settings effective"?  There have been
> changes in the way CephFS quotas work in mimic and, if you're using a
> Luminous cluster (12.2.*) the kernel client effectively does *not*
> support quotas -- you'll be able to exceed the quotas you've tried to
> set because the client won't be checking the limits.  Thus, -EOPNOTSUPP
> seems appropriate for this scenario.
>
> I guess that the confusing part is that the xattr is actually set in
> that case, but the kernel client won't be able to use it to validate
> quotas in the filesystem tree because realms won't be created.
>
Yes. we use kcephfs+nfs for CentOS6.*, it does not support ceph-fuse(12.2.*=
).
The operating system of other applications is CentOS7.*, which uses
ceph-fuse and can get quota settings set by kclient.

Thanks.
BRs

> Cheers,
> --
> Lu=C3=ADs
> >
> > If the kernel version and ceph version are not compatible, should check
> > quota operations are supported first, then do sync_setxattr.
> >
> > reference: https://docs.ceph.com/docs/master/cephfs/quota/
> >
> > Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> > ---
> >  fs/ceph/xattr.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> > index cb18ee637cb7..189aace75186 100644
> > --- a/fs/ceph/xattr.c
> > +++ b/fs/ceph/xattr.c
> > @@ -1132,8 +1132,8 @@ int __ceph_setxattr(struct inode *inode, const ch=
ar *name,
> >                                   "during filling trace\n", inode);
> >               err =3D -EBUSY;
> >       } else {
> > -             err =3D ceph_sync_setxattr(inode, name, value, size, flag=
s);
> > -             if (err >=3D 0 && check_realm) {
> > +             err =3D 0;
> > +             if (check_realm) {
> >                       /* check if snaprealm was created for quota inode=
 */
> >                       spin_lock(&ci->i_ceph_lock);
> >                       if ((ci->i_max_files || ci->i_max_bytes) &&
> > @@ -1142,6 +1142,8 @@ int __ceph_setxattr(struct inode *inode, const ch=
ar *name,
> >                               err =3D -EOPNOTSUPP;
> >                       spin_unlock(&ci->i_ceph_lock);
> >               }
> > +             if (err =3D=3D 0)
> > +                     err =3D ceph_sync_setxattr(inode, name, value, si=
ze, flags);
> >       }
> >  out:
> >       ceph_free_cap_flush(prealloc_cf);
> > --
> > 2.21.0 (Apple Git-122.2)
> >
