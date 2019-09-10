Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C314AE2C1
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Sep 2019 06:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732840AbfIJEIH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Sep 2019 00:08:07 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:44768 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732573AbfIJEIH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Sep 2019 00:08:07 -0400
Received: by mail-ot1-f68.google.com with SMTP id 21so16197784otj.11
        for <ceph-devel@vger.kernel.org>; Mon, 09 Sep 2019 21:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oSpDIgHMC56mGSv9HUy3UpTR9jy/ZawyNy4jf5kIIT4=;
        b=qq+kZt2rilJ7m+zvxea9du/0OF4uK1QBnKakWAuRwfvXXeG69GbEovYrkdWFPtlhY2
         xtbNoMpufMQ2eUUlC0cDmD0zdjKQJVBKEzQ/N1aZDMIlLdl8q90gtjAqZMwi6RNqmqCt
         dNZFEMMM4ZIUm1c6l5CtmbH6i0utRMSv/57rZJvJPJ2YYjnxYUZxoNiqxL887Io5rZy8
         nqZrIkOu7ddv9iF753VDobTFyDehLFQCC66N2ZSniNe9Tf+A6UNkwQP318SN8NG/8tbo
         K86LiqAzPg8R8QO/TqWZv1UXyprg/jO0tT3bARRx11ISHB94WBl9ao5hjyR+poHIYgd0
         hykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oSpDIgHMC56mGSv9HUy3UpTR9jy/ZawyNy4jf5kIIT4=;
        b=syCWoizHJwTxVhBh26TZ7SyHoS1WJSd9u4b/79I0GNrFa05qZH/fFeoapd3i/BhAIU
         YH+p2X7o/h4DAO2Jl7c6B9NEwxqlLGiu9dQBzHw95KBHcQg1zhcyzqTw/75CFfdQzLSr
         QBWqCH6f3QE+OccocgFGJeNGTWgMHWpYiguCwvFEdU2Zs57oh9wfnArDCHy0Zkvy+2rt
         Dts/1+xT8xi4u/K80ONWC6/Bl/OgXvzosCVI6qA9Q6ILMD6cG7E/NbeVRaGa+ZQ3vFwM
         YMOiODH/amH/v9YnnqVOig3QtGFBLb6yjnrQZnJe43TzGptJTvWGvIhFYj/zKmZ8XpvP
         QO+Q==
X-Gm-Message-State: APjAAAUTsQVcRSxbIGOxZFucbbEuHNpxLjHpKVEUN5EAal8NRfbjr/IN
        0eWFwvAC0p7z00G57DfcflE21Hv/+0LsIkrQI2Q=
X-Google-Smtp-Source: APXvYqxHz5ZQcPu/Q5AghAR7gNb2HNt6GHDHNgD4aUoiPUHA2d41uXSzYfOJz6VjgUb6jlsBe7wgpf5fUGyL2ZmjJ64=
X-Received: by 2002:a9d:200c:: with SMTP id n12mr24172070ota.334.1568088485945;
 Mon, 09 Sep 2019 21:08:05 -0700 (PDT)
MIME-Version: 1.0
References: <1567687915-121426-1-git-send-email-simon29rock@gmail.com>
 <82144ffcc3f52a9b4cc923884d8aa3d096b76599.camel@kernel.org> <CAJ4mKGYS_yF+49VfxbLErE5WJEbNCyNZ5i-FvG6=i6dTrrKTUg@mail.gmail.com>
In-Reply-To: <CAJ4mKGYS_yF+49VfxbLErE5WJEbNCyNZ5i-FvG6=i6dTrrKTUg@mail.gmail.com>
From:   simon gao <simon29rock@gmail.com>
Date:   Tue, 10 Sep 2019 12:07:54 +0800
Message-ID: <CAGR3woX-K3zOVe7xsrJUhLe=T2=SWXTR3idBb2w6b=8JJiHwqw@mail.gmail.com>
Subject: Re: [PATCH] modify the mode of req from USE_ANY_MDS to USE_AUTH_MDS
 to reduce the cache size of mds and forward op.
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

sorry. Jeff Layton.
I have repush a patch and elaborate on this issue -- [PATCH] ceph: add
mount opt, always_auth

thanks for you reply.

Gregory Farnum <gfarnum@redhat.com> =E4=BA=8E2019=E5=B9=B49=E6=9C=887=E6=97=
=A5=E5=91=A8=E5=85=AD =E4=B8=8A=E5=8D=884:45=E5=86=99=E9=81=93=EF=BC=9A



>
> On Thu, Sep 5, 2019 at 11:46 AM Jeff Layton <jlayton@kernel.org> wrote:
> >
> > On Thu, 2019-09-05 at 08:51 -0400, simon gao wrote:
> >
> > I think this deserves a much better description than just the subject
> > line above. This change may be obvious to others but it's not clear to
> > me why this will have the effect you suggest, and what downsides it may
> > have.
> >
> > Can you flesh out the patch description and resend?
>
> Yeah this seems wrong to me in general. I don't remember exactly how
> it's implemented client-side but generally speaking we want to allow
> use of the replicated metadata on slave MDSes so that we eg spread the
> load around on subtree boundaries, and don't have to split up request
> streams across multiple MDSes when we're doing stuff like working in a
> private subdirectory but occasionally need to look at stuff on the
> parent.
> In general if the client knows which MDS is auth for a dentry/inode I
> don't think they'll send requests elsewhere without a good reason for
> it.
> -Greg
>
> >
> > Thanks,
> >
> > > ---
> > >  fs/ceph/dir.c        | 4 ++--
> > >  fs/ceph/export.c     | 8 ++++----
> > >  fs/ceph/file.c       | 2 +-
> > >  fs/ceph/inode.c      | 2 +-
> > >  fs/ceph/mds_client.c | 1 +
> > >  fs/ceph/super.c      | 2 +-
> > >  6 files changed, 10 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > > index 4ca0b8f..a441b8d 100644
> > > --- a/fs/ceph/dir.c
> > > +++ b/fs/ceph/dir.c
> > > @@ -771,7 +771,7 @@ static struct dentry *ceph_lookup(struct inode *d=
ir, struct dentry *dentry,
> > >
> > >       op =3D ceph_snap(dir) =3D=3D CEPH_SNAPDIR ?
> > >               CEPH_MDS_OP_LOOKUPSNAP : CEPH_MDS_OP_LOOKUP;
> > > -     req =3D ceph_mdsc_create_request(mdsc, op, USE_ANY_MDS);
> > > +     req =3D ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
> > >       if (IS_ERR(req))
> > >               return ERR_CAST(req);
> > >       req->r_dentry =3D dget(dentry);
> > > @@ -1600,7 +1600,7 @@ static int ceph_d_revalidate(struct dentry *den=
try, unsigned int flags)
> > >
> > >               op =3D ceph_snap(dir) =3D=3D CEPH_SNAPDIR ?
> > >                       CEPH_MDS_OP_LOOKUPSNAP : CEPH_MDS_OP_LOOKUP;
> > > -             req =3D ceph_mdsc_create_request(mdsc, op, USE_ANY_MDS)=
;
> > > +             req =3D ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS=
);
> > >               if (!IS_ERR(req)) {
> > >                       req->r_dentry =3D dget(dentry);
> > >                       req->r_num_caps =3D 2;
> > > diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> > > index 15ff1b0..a7d5174 100644
> > > --- a/fs/ceph/export.c
> > > +++ b/fs/ceph/export.c
> > > @@ -135,7 +135,7 @@ static struct inode *__lookup_inode(struct super_=
block *sb, u64 ino)
> > >               int mask;
> > >
> > >               req =3D ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOK=
UPINO,
> > > -                                            USE_ANY_MDS);
> > > +                                            USE_AUTH_MDS);
> > >               if (IS_ERR(req))
> > >                       return ERR_CAST(req);
> > >
> > > @@ -210,7 +210,7 @@ static struct dentry *__snapfh_to_dentry(struct s=
uper_block *sb,
> > >               return d_obtain_alias(inode);
> > >
> > >       req =3D ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPINO,
> > > -                                    USE_ANY_MDS);
> > > +                                    USE_AUTH_MDS);
> > >       if (IS_ERR(req))
> > >               return ERR_CAST(req);
> > >
> > > @@ -294,7 +294,7 @@ static struct dentry *__get_parent(struct super_b=
lock *sb,
> > >       int err;
> > >
> > >       req =3D ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPPARENT=
,
> > > -                                    USE_ANY_MDS);
> > > +                                    USE_AUTH_MDS);
> > >       if (IS_ERR(req))
> > >               return ERR_CAST(req);
> > >
> > > @@ -509,7 +509,7 @@ static int ceph_get_name(struct dentry *parent, c=
har *name,
> > >
> > >       mdsc =3D ceph_inode_to_client(inode)->mdsc;
> > >       req =3D ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPNAME,
> > > -                                    USE_ANY_MDS);
> > > +                                    USE_AUTH_MDS);
> > >       if (IS_ERR(req))
> > >               return PTR_ERR(req);
> > >
> > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > index 685a03c..79533f2 100644
> > > --- a/fs/ceph/file.c
> > > +++ b/fs/ceph/file.c
> > > @@ -182,7 +182,7 @@ static void put_bvecs(struct bio_vec *bvecs, int =
num_bvecs, bool should_dirty)
> > >       struct ceph_fs_client *fsc =3D ceph_sb_to_client(sb);
> > >       struct ceph_mds_client *mdsc =3D fsc->mdsc;
> > >       struct ceph_mds_request *req;
> > > -     int want_auth =3D USE_ANY_MDS;
> > > +     int want_auth =3D USE_AUTH_MDS;
> > >       int op =3D (flags & O_CREAT) ? CEPH_MDS_OP_CREATE : CEPH_MDS_OP=
_OPEN;
> > >
> > >       if (flags & (O_WRONLY|O_RDWR|O_CREAT|O_TRUNC))
> > > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > > index 18500ede..6c67548 100644
> > > --- a/fs/ceph/inode.c
> > > +++ b/fs/ceph/inode.c
> > > @@ -2247,7 +2247,7 @@ int __ceph_do_getattr(struct inode *inode, stru=
ct page *locked_page,
> > >       if (!force && ceph_caps_issued_mask(ceph_inode(inode), mask, 1)=
)
> > >               return 0;
> > >
> > > -     mode =3D (mask & CEPH_STAT_RSTAT) ? USE_AUTH_MDS : USE_ANY_MDS;
> > > +     mode =3D USE_AUTH_MDS;
> > >       req =3D ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, mod=
e);
> > >       if (IS_ERR(req))
> > >               return PTR_ERR(req);
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index 920e9f0..acfb969 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -867,6 +867,7 @@ static struct inode *get_nonsnap_parent(struct de=
ntry *dentry)
> > >       return inode;
> > >  }
> > >
> > > +static struct inode *get_parent()
> > >  /*
> > >   * Choose mds to send request to next.  If there is a hint set in th=
e
> > >   * request (e.g., due to a prior forward hint from the mds), use tha=
t.
> > > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > > index ab4868c..517e605 100644
> > > --- a/fs/ceph/super.c
> > > +++ b/fs/ceph/super.c
> > > @@ -867,7 +867,7 @@ static struct dentry *open_root_dentry(struct cep=
h_fs_client *fsc,
> > >
> > >       /* open dir */
> > >       dout("open_root_inode opening '%s'\n", path);
> > > -     req =3D ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, USE=
_ANY_MDS);
> > > +     req =3D ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, USE=
_AUTH_MDS);
> > >       if (IS_ERR(req))
> > >               return ERR_CAST(req);
> > >       req->r_path1 =3D kstrdup(path, GFP_NOFS);
> >
> >
> > --
> > Jeff Layton <jlayton@kernel.org>
> >
