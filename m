Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBAFAFD3D
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2019 14:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbfIKM6n (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Sep 2019 08:58:43 -0400
Received: from mail-oi1-f177.google.com ([209.85.167.177]:42945 "EHLO
        mail-oi1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbfIKM6n (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 11 Sep 2019 08:58:43 -0400
Received: by mail-oi1-f177.google.com with SMTP id z6so8488375oix.9
        for <ceph-devel@vger.kernel.org>; Wed, 11 Sep 2019 05:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cK0kTuVYEZo8E4oQkxsgI5qdI3LXb7jBDH9oK7QAq2o=;
        b=a/C5Fhr3ObGNgJsdAUE+CSk40ke72x/QtHqjeSZ1WrojE5VtbN6B7d1u84SCqpInar
         tOwCfSc0Fz7P4YpXSGgV3EKh+zEBKH5hnyUbCcHgRUZvKh5kQQLb3xQLPB7Gv1aQrVHE
         RtYpv8Mo0GJRvGcIkzy0dx98YKl0QBC5lB3TGKLp81wQo4JrzQLbZUb0aS0G7p2XtFDf
         lEIkVQZAXPntTao+dwHBRN/rg2PkKKoOYb9C9rcO0A3FQEASIgL/EUHGT4e8Dz2iq25p
         aZ7Q96zOV9Unu14HMGx0M7RHwBaB4oXyPU7mEAOdNo/A1EAsN79FilpKaAQHRazTIZcQ
         EQ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cK0kTuVYEZo8E4oQkxsgI5qdI3LXb7jBDH9oK7QAq2o=;
        b=eicK3tXuspexJmsPA1Bfdxe9uZBaaW/KY+OcQ5w2wWNsZ3FxWb2G336Efl4gSVDc4L
         peqvXV1BAateGs/1j1zr50Y53fdaRnBG3Bw7/lHqm+3JSHxwv+R6YVTaP4ZZOIDZ7iOu
         Ticz+IvqB2kJlpH9+1WuQhe/Vc7GVJi5YFfYuUpTWdHruwNW26P0uJTWBS2GVLFQWxM7
         rg6Sk4yD+mYBVQ2K8q+WPXsBRKQK9rlhmDNeENH1YhoyNhYNJDnQzTnS4JpJF8nvSOOG
         Kcx0ILiIEISeW950ixGj3sPg8mVcjMLuhL48uznHZGDddfhpsEhgBOpznFwIBqMonTr2
         xyiw==
X-Gm-Message-State: APjAAAVpODy2KdqBdPwH7axpGbjkk4VXXtVWLbrLFVdZANqv7nHrOiT1
        bVnd8KT0NHmQuGdgw5zDXwldZRT6JsFP5vic4gU=
X-Google-Smtp-Source: APXvYqx1o3asYZts20enFzvFHiZ+bPGHJJqdMusgV9y9lFEMmiWIikyu7Mt7Auk9/PgdLGEIN07p23aNQaQpqcJZYBM=
X-Received: by 2002:aca:6744:: with SMTP id b4mr3696948oiy.95.1568206721986;
 Wed, 11 Sep 2019 05:58:41 -0700 (PDT)
MIME-Version: 1.0
References: <1568082511-805-1-git-send-email-simon29rock@gmail.com> <CAAM7YAkzGWwqfRojzmQ1hX_hwF=xgKFHQ-Xfb66Tds0v3iLzSQ@mail.gmail.com>
In-Reply-To: <CAAM7YAkzGWwqfRojzmQ1hX_hwF=xgKFHQ-Xfb66Tds0v3iLzSQ@mail.gmail.com>
From:   simon gao <simon29rock@gmail.com>
Date:   Wed, 11 Sep 2019 20:58:31 +0800
Message-ID: <CAGR3woW2f=xR5E3MJuR4ihnPXZDzKrh4FP_D41=3JMDNHtYYxQ@mail.gmail.com>
Subject: Re: [PATCH] add mount opt, always_auth, to force to send req to auth mds
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

changed it.
thanks

Yan, Zheng <ukernel@gmail.com> =E4=BA=8E2019=E5=B9=B49=E6=9C=8811=E6=97=A5=
=E5=91=A8=E4=B8=89 =E4=B8=8A=E5=8D=8810:58=E5=86=99=E9=81=93=EF=BC=9A
>
> On Wed, Sep 11, 2019 at 2:46 AM simon gao <simon29rock@gmail.com> wrote:
> >
> > In larger clusters (hundreds of millions of files). We have to pin the
> > directory on a fixed mds now. Some op of client use USE_ANY_MDS mode
> > to access mds, which may result in requests being sent to noauth mds
> > and then forwarded to authmds.
> > the opt is used to reduce forward op.
> > ---
> >  fs/ceph/mds_client.c | 7 ++++++-
> >  fs/ceph/super.c      | 7 +++++++
> >  fs/ceph/super.h      | 1 +
> >  3 files changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 920e9f0..aca4490 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -878,6 +878,7 @@ static struct inode *get_nonsnap_parent(struct dent=
ry *dentry)
> >  static int __choose_mds(struct ceph_mds_client *mdsc,
> >                         struct ceph_mds_request *req)
> >  {
> > +       struct ceph_mount_options *ma =3D mdsc->fsc->mount_options;
> >         struct inode *inode;
> >         struct ceph_inode_info *ci;
> >         struct ceph_cap *cap;
> > @@ -900,7 +901,11 @@ static int __choose_mds(struct ceph_mds_client *md=
sc,
> >
> >         if (mode =3D=3D USE_RANDOM_MDS)
> >                 goto random;
> > -
> > +       // force to send the req to auth mds
> > +       if (ma->flags & CEPH_MOUNT_OPT_ALWAYS_AUTH && mode !=3D USE_AUT=
H_MDS){
>
> use ceph_test_mount_opt(). Otherwise, looks good to me
>
> > +               dout("change mode %d =3D> USE_AUTH_MDS", mode);
> > +               mode =3D USE_AUTH_MDS;
> > +       }
> >         inode =3D NULL;
> >         if (req->r_inode) {
> >                 if (ceph_snap(req->r_inode) !=3D CEPH_SNAPDIR) {
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index ab4868c..1e81ebc 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -169,6 +169,7 @@ enum {
> >         Opt_noquotadf,
> >         Opt_copyfrom,
> >         Opt_nocopyfrom,
> > +       Opt_always_auth,
> >  };
> >
> >  static match_table_t fsopt_tokens =3D {
> > @@ -210,6 +211,7 @@ enum {
> >         {Opt_noquotadf, "noquotadf"},
> >         {Opt_copyfrom, "copyfrom"},
> >         {Opt_nocopyfrom, "nocopyfrom"},
> > +       {Opt_always_auth, "always_auth"},
> >         {-1, NULL}
> >  };
> >
> > @@ -381,6 +383,9 @@ static int parse_fsopt_token(char *c, void *private=
)
> >         case Opt_noacl:
> >                 fsopt->sb_flags &=3D ~SB_POSIXACL;
> >                 break;
> > +       case Opt_always_auth:
> > +               fsopt->flags |=3D CEPH_MOUNT_OPT_ALWAYS_AUTH;
> > +               break;
> >         default:
> >                 BUG_ON(token);
> >         }
> > @@ -563,6 +568,8 @@ static int ceph_show_options(struct seq_file *m, st=
ruct dentry *root)
> >                 seq_puts(m, ",nopoolperm");
> >         if (fsopt->flags & CEPH_MOUNT_OPT_NOQUOTADF)
> >                 seq_puts(m, ",noquotadf");
> > +       if (fsopt->flags & CEPH_MOUNT_OPT_ALWAYS_AUTH)
> > +               seq_puts(m, ",always_auth");
> >
> >  #ifdef CONFIG_CEPH_FS_POSIX_ACL
> >         if (fsopt->sb_flags & SB_POSIXACL)
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index 6b9f1ee..65f6423 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -41,6 +41,7 @@
> >  #define CEPH_MOUNT_OPT_MOUNTWAIT       (1<<12) /* mount waits if no md=
s is up */
> >  #define CEPH_MOUNT_OPT_NOQUOTADF       (1<<13) /* no root dir quota in=
 statfs */
> >  #define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<14) /* don't use RADOS 'cop=
y-from' op */
> > +#define CEPH_MOUNT_OPT_ALWAYS_AUTH     (1<<15) /* send op to auth mds,=
 not to replicative mds */
> >
> >  #define CEPH_MOUNT_OPT_DEFAULT                 \
> >         (CEPH_MOUNT_OPT_DCACHE |                \
> > --
> > 1.8.3.1
> >
