Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 305BAAB09B
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2019 04:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731491AbfIFC0F (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Sep 2019 22:26:05 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:34120 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729053AbfIFC0F (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Sep 2019 22:26:05 -0400
Received: by mail-oi1-f193.google.com with SMTP id g128so3739438oib.1
        for <ceph-devel@vger.kernel.org>; Thu, 05 Sep 2019 19:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dN60YC55sH8H4XANb7MwRlBtpxGuivCnX3gfOgKyim8=;
        b=ariV1reMCFfBHeKRbMx20jxdQP6TVDYw9o9T5T+qDZrktWSuV4B2zgVEepb4390x3K
         icrFBazWlWPugRqnOUq6pUx51yGHrpMSyn1z/TWvfQNenSFQn1C3bxSeNybGb3L86W8D
         gILuTT0KiHp/hpnLuGUUUX79QAygccSJJPCg4sjXF2uElslRPpMgN5jWIm9wveqtgKSy
         FEePRKP7nKTzCpjXXiAVc1IixtSQhb8yUwARM5G6sQWWmrI+nRLxvZG8SL6UXHSnid2E
         npR5BAg2rNsy4X4baF3kMpCNgncvuR6m04o6mIs27RvjLWUauu5JzUc9ARI7iLXojMxH
         vErA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dN60YC55sH8H4XANb7MwRlBtpxGuivCnX3gfOgKyim8=;
        b=mFGaoevKCeVG8/C8HTCMd4jlQgkKLA0IniXA9z4P6NJL7xh9bt1tFsa3a0NdC3dAh3
         bRHtQtCv9BliB8yVFL+vde3OdcrURr0D+bNvUse8StNmcPdloTlWBcd6OY90Z2RbhZF0
         gzftxWOU3u9U1QttJ0tgrJ8jAd7HRpjs8kXBSEonLfebxwHYSTv9lOG3AdtAoWjnqB/R
         pX0xPDe3UcirGdB/0IlRvZefy728BRhc4inv6ymva9nWVULF0fjRsumpX5jNqg/siqvC
         uGfI3NDmyjuCZ54d0tstEyEAPvx4GGdipetWsHx/gnH86LZvvydflr90loh+2OpvoNXa
         EB1A==
X-Gm-Message-State: APjAAAVFk+++WL3eaoFvkI/ie2Z37XBqcT/pSN+Sfh3TyI6m+NxcfkvC
        3aW84AahUhopn6hiRGCkUPg+5MFQaP1TaP+yu28D2g==
X-Google-Smtp-Source: APXvYqzKF7YgR3ORj9BkHvoYcdQKjfiaLj/Q8pvbee18BuwWtCQPsI67QwRYjE3tt858BBLOiis3FusXLoh5jiwLRcg=
X-Received: by 2002:aca:6744:: with SMTP id b4mr4920802oiy.95.1567736765132;
 Thu, 05 Sep 2019 19:26:05 -0700 (PDT)
MIME-Version: 1.0
References: <1567687915-121426-1-git-send-email-simon29rock@gmail.com> <CAAM7YA=RC84igiJY8qRgBhkdcEwQkTaxokHz6XN2MeKt9kTRQg@mail.gmail.com>
In-Reply-To: <CAAM7YA=RC84igiJY8qRgBhkdcEwQkTaxokHz6XN2MeKt9kTRQg@mail.gmail.com>
From:   simon gao <simon29rock@gmail.com>
Date:   Fri, 6 Sep 2019 10:25:54 +0800
Message-ID: <CAGR3woX8aR-UhuYn4g6FQ85LFSOHd2aXXjYj3ZBTksSyE9OSCw@mail.gmail.com>
Subject: Re: [PATCH] modify the mode of req from USE_ANY_MDS to USE_AUTH_MDS
 to reduce the cache size of mds and forward op.
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

ok

Yan, Zheng <ukernel@gmail.com> =E4=BA=8E2019=E5=B9=B49=E6=9C=886=E6=97=A5=
=E5=91=A8=E4=BA=94 =E4=B8=8A=E5=8D=889:57=E5=86=99=E9=81=93=EF=BC=9A
>
> I think it's better to add a mount option (not enable by default) for
> this change
>
> On Fri, Sep 6, 2019 at 1:02 AM simon gao <simon29rock@gmail.com> wrote:
> >
> > ---
> >  fs/ceph/dir.c        | 4 ++--
> >  fs/ceph/export.c     | 8 ++++----
> >  fs/ceph/file.c       | 2 +-
> >  fs/ceph/inode.c      | 2 +-
> >  fs/ceph/mds_client.c | 1 +
> >  fs/ceph/super.c      | 2 +-
> >  6 files changed, 10 insertions(+), 9 deletions(-)
> >
> > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > index 4ca0b8f..a441b8d 100644
> > --- a/fs/ceph/dir.c
> > +++ b/fs/ceph/dir.c
> > @@ -771,7 +771,7 @@ static struct dentry *ceph_lookup(struct inode *dir=
, struct dentry *dentry,
> >
> >         op =3D ceph_snap(dir) =3D=3D CEPH_SNAPDIR ?
> >                 CEPH_MDS_OP_LOOKUPSNAP : CEPH_MDS_OP_LOOKUP;
> > -       req =3D ceph_mdsc_create_request(mdsc, op, USE_ANY_MDS);
> > +       req =3D ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
> >         if (IS_ERR(req))
> >                 return ERR_CAST(req);
> >         req->r_dentry =3D dget(dentry);
> > @@ -1600,7 +1600,7 @@ static int ceph_d_revalidate(struct dentry *dentr=
y, unsigned int flags)
> >
> >                 op =3D ceph_snap(dir) =3D=3D CEPH_SNAPDIR ?
> >                         CEPH_MDS_OP_LOOKUPSNAP : CEPH_MDS_OP_LOOKUP;
> > -               req =3D ceph_mdsc_create_request(mdsc, op, USE_ANY_MDS)=
;
> > +               req =3D ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS=
);
> >                 if (!IS_ERR(req)) {
> >                         req->r_dentry =3D dget(dentry);
> >                         req->r_num_caps =3D 2;
> > diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> > index 15ff1b0..a7d5174 100644
> > --- a/fs/ceph/export.c
> > +++ b/fs/ceph/export.c
> > @@ -135,7 +135,7 @@ static struct inode *__lookup_inode(struct super_bl=
ock *sb, u64 ino)
> >                 int mask;
> >
> >                 req =3D ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOK=
UPINO,
> > -                                              USE_ANY_MDS);
> > +                                              USE_AUTH_MDS);
> >                 if (IS_ERR(req))
> >                         return ERR_CAST(req);
> >
> > @@ -210,7 +210,7 @@ static struct dentry *__snapfh_to_dentry(struct sup=
er_block *sb,
> >                 return d_obtain_alias(inode);
> >
> >         req =3D ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPINO,
> > -                                      USE_ANY_MDS);
> > +                                      USE_AUTH_MDS);
> >         if (IS_ERR(req))
> >                 return ERR_CAST(req);
> >
> > @@ -294,7 +294,7 @@ static struct dentry *__get_parent(struct super_blo=
ck *sb,
> >         int err;
> >
> >         req =3D ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPPARENT=
,
> > -                                      USE_ANY_MDS);
> > +                                      USE_AUTH_MDS);
> >         if (IS_ERR(req))
> >                 return ERR_CAST(req);
> >
> > @@ -509,7 +509,7 @@ static int ceph_get_name(struct dentry *parent, cha=
r *name,
> >
> >         mdsc =3D ceph_inode_to_client(inode)->mdsc;
> >         req =3D ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPNAME,
> > -                                      USE_ANY_MDS);
> > +                                      USE_AUTH_MDS);
> >         if (IS_ERR(req))
> >                 return PTR_ERR(req);
> >
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 685a03c..79533f2 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -182,7 +182,7 @@ static void put_bvecs(struct bio_vec *bvecs, int nu=
m_bvecs, bool should_dirty)
> >         struct ceph_fs_client *fsc =3D ceph_sb_to_client(sb);
> >         struct ceph_mds_client *mdsc =3D fsc->mdsc;
> >         struct ceph_mds_request *req;
> > -       int want_auth =3D USE_ANY_MDS;
> > +       int want_auth =3D USE_AUTH_MDS;
> >         int op =3D (flags & O_CREAT) ? CEPH_MDS_OP_CREATE : CEPH_MDS_OP=
_OPEN;
> >
> >         if (flags & (O_WRONLY|O_RDWR|O_CREAT|O_TRUNC))
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index 18500ede..6c67548 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -2247,7 +2247,7 @@ int __ceph_do_getattr(struct inode *inode, struct=
 page *locked_page,
> >         if (!force && ceph_caps_issued_mask(ceph_inode(inode), mask, 1)=
)
> >                 return 0;
> >
> > -       mode =3D (mask & CEPH_STAT_RSTAT) ? USE_AUTH_MDS : USE_ANY_MDS;
> > +       mode =3D USE_AUTH_MDS;
> >         req =3D ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, mod=
e);
> >         if (IS_ERR(req))
> >                 return PTR_ERR(req);
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 920e9f0..acfb969 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -867,6 +867,7 @@ static struct inode *get_nonsnap_parent(struct dent=
ry *dentry)
> >         return inode;
> >  }
> >
> > +static struct inode *get_parent()
> >  /*
> >   * Choose mds to send request to next.  If there is a hint set in the
> >   * request (e.g., due to a prior forward hint from the mds), use that.
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index ab4868c..517e605 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -867,7 +867,7 @@ static struct dentry *open_root_dentry(struct ceph_=
fs_client *fsc,
> >
> >         /* open dir */
> >         dout("open_root_inode opening '%s'\n", path);
> > -       req =3D ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, USE=
_ANY_MDS);
> > +       req =3D ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, USE=
_AUTH_MDS);
> >         if (IS_ERR(req))
> >                 return ERR_CAST(req);
> >         req->r_path1 =3D kstrdup(path, GFP_NOFS);
> > --
> > 1.8.3.1
> >
