Return-Path: <ceph-devel+bounces-3558-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 06DB6B48C48
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Sep 2025 13:34:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFA333BA5A1
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Sep 2025 11:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A606D22FDE8;
	Mon,  8 Sep 2025 11:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sq3mAC2B"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE862264B6;
	Mon,  8 Sep 2025 11:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757331283; cv=none; b=oSfHW+iwDe3iQ55QDW1NMYcv86Te4bJLWJeDcjpayjWMfz5UvqxPZtX0cbMrNXmPjYJdCcN5o6fBDPmwsLoxXB1Po0SDlIWvtZDuGbzCdIFspBCw4wEmDRVhRGfXHPZWAPOVQYjBNuLeSe5Xx/3WVvwJQuID0b6D84kRJgHXx8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757331283; c=relaxed/simple;
	bh=bae2yJAoJUZwsQhZu3ctgAz3xSbW3IZQfKgVOG3WOlw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o1cbgnW9CaiQ27ZwaDC/YNFLnSQBQZuIePtmoAYdjV2Exve0XM11IwI28+c/nOarGiBnBubIRPwWKTgYzBzqx8UapmysmfOumHHutwFqmo40cFidTJGYOTVYKEWfy25QG2YV781uUAJguG5Zxv3cjypryF30IapfmU6icIOkqE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sq3mAC2B; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-32b02d88d80so3760652a91.0;
        Mon, 08 Sep 2025 04:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757331281; x=1757936081; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3O7b+Ie3WcS7enJKSh15gQjXu22HlM6cl/P5ojxOGO0=;
        b=Sq3mAC2Bplt0amBBcCqHQHU+QwrBNa/H8PlW+ITfFJXx2XD4CKC7e+97HmHhLVyfnW
         xHLSDLTo7YkC8H7df0CBz552T2z7UlsYoxP+fDc1wJYjU2ImSOzE7om1OFq4r0Hkvn4h
         EP/lvn8lR2TjQvaesmtGbd33xyEFwxxktsMgrSYVUX6tOJr8hq2xeaZO0kaf79x6G67Z
         tTtdINm5xd98/cFb5IJslFsZithJNv5ATAlMcg/tMGT74VLaXYA5Z/3yJ/HNVmjJ/GOm
         PkMT0D5YEZjPfiQrZaDFvKT2Y0wAsXxkpwZdVB/6vsvIe4AUy3c4tV0+e6zJEc7P5ATb
         00Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757331281; x=1757936081;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3O7b+Ie3WcS7enJKSh15gQjXu22HlM6cl/P5ojxOGO0=;
        b=SbuMgXmO1/WigpiF68c3zdCxCkuBFaLg40wH3DMoS8NOo/AGYeelK7iR4TaXbRVRZI
         l8B5fsqlWCg8ptDlzLk+0CDh9o6GM5Y30FlieiFRX2KYNQjGxlqb8xLEoWRWEDaa4lVp
         bZmZhjUniY4AQA0I7+9rpp/zrWSlBqB159jjOC45SA6P8kvkFUOKoLdqVEX9Sh21ObjF
         cUTOcfetT7Q2CHZV8jj/NYFMwUxLz9nHQJaCtUrhvIFgqutU4D96K/dY9pFwUIFyBm2s
         GvTAZbIJ9xtMfDkMbBE+/v0AnvCL15EfGlN1K/t62W0EmD58LKZ4YrTX/InXSCcIxkKu
         uLZg==
X-Forwarded-Encrypted: i=1; AJvYcCWiM30jMKH+S5OYwMmyeGfethrmB/GH/ITnxmApqOI04NAAJ/uG6hzFX4Dplpx3D9lYg2A1hCs+umYEK8pw@vger.kernel.org, AJvYcCX8eJj2rvuMA/sYTGidD1DX7Y/BcCitU0yhdjmujAdvIse/AUBZSlMm04cjY15v2jCDbHIj1bY9pMub@vger.kernel.org
X-Gm-Message-State: AOJu0YwbDi/NFcpqt8DIpzMHjtokGNjv8xUl3IcAM3UWUkaoVW/tYwPq
	AI9rhA68M5hrxwsqtFy8F0+kpcBVnCfPK9sXTBJ4TFpi3w7HMbZLYBNIPJ7yKJ/Jf456x902z2q
	GnP8JLhq9dEK4Yjd1wUmnZjCKLdEOt3o=
X-Gm-Gg: ASbGncu+lnG2ammAq3vPHf+wYG3n/ZaBGkgl+JYWtAcBpD/jz6xlSF9tCS8YkYNgyF/
	eBXgwwUmnHyYpxIslaSp0xtopaAfiZI6IJEpcsZqcsWGcIODhRYS/DBvG+fJEbmkR9OgFjxJpKf
	nm3lX5gsIkur/zz1IsRxqTK7rG6Ps6nhA37Mf6ap0gH2U0iIbfrgNEVaisUsz966lStqPriyXmL
	gjqhJ8=
X-Google-Smtp-Source: AGHT+IHuqROHuHzkq/zNKzDa1o0e+HI0tH5uNT+rQa4dNc/8Oxkhd9CjR59CyUgdjkWyuywaadjRVuYgIO45+plmQDI=
X-Received: by 2002:a17:90b:5284:b0:329:cb75:feec with SMTP id
 98e67ed59e1d1-32d43ef579fmr11654345a91.7.1757331281046; Mon, 08 Sep 2025
 04:34:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250904101234.1258643-1-amarkuze@redhat.com> <ecdf72c0856f79142af5d951c7cb479cba6c8fb3.camel@ibm.com>
In-Reply-To: <ecdf72c0856f79142af5d951c7cb479cba6c8fb3.camel@ibm.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 8 Sep 2025 13:34:28 +0200
X-Gm-Features: Ac12FXyYlAF3vtXQ6PXqcXmF9IeVgmr_oI1Z3uB7L6vfR3zFDRa6JEeE3a1-C64
Message-ID: <CAOi1vP-jYSiFuTrA7qO0=Cy4qL24q8RpeV2Fk7K+4POfOGvHaQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ceph/inode: drop extra reference from
 ceph_get_reply_dir() in ceph_fill_trace()
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Alex Markuze <amarkuze@redhat.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 4, 2025 at 8:32=E2=80=AFPM Viacheslav Dubeyko <Slava.Dubeyko@ib=
m.com> wrote:
>
> On Thu, 2025-09-04 at 10:12 +0000, Alex Markuze wrote:
> > ceph_get_reply_dir() may return a different, referenced inode when r_pa=
rent is stale and the parent directory lock is not held.
> > ceph_fill_trace() used that inode but failed to drop the reference when=
 it differed from req->r_parent, leaking an inode reference.
> >
> > Keep the directory inode in a local and iput() it at function end if it=
 does not match req->r_parent.
>
> I assume that you mean "in a local variable"?
>
> >
> > Signed-off-by: Alex Markuze <amarkuze@redhat.com>
> > ---
> >  fs/ceph/inode.c | 30 +++++++++++++++++++-----------
> >  1 file changed, 19 insertions(+), 11 deletions(-)
> >
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index 470ee595ecf2..cffa2cd7b530 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -1584,6 +1584,7 @@ int ceph_fill_trace(struct super_block *sb, struc=
t ceph_mds_request *req)
> >       struct ceph_vino tvino, dvino;
> >       struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(sb);
> >       struct ceph_client *cl =3D fsc->client;
> > +     struct inode *parent_dir =3D NULL;
> >       int err =3D 0;
> >
> >       doutc(cl, "%p is_dentry %d is_target %d\n", req,
> > @@ -1601,9 +1602,13 @@ int ceph_fill_trace(struct super_block *sb, stru=
ct ceph_mds_request *req)
> >                * r_parent may be stale, in cases when R_PARENT_LOCKED i=
s not set,
> >                * so we need to get the correct inode
> >                */
> > -             struct inode *dir =3D ceph_get_reply_dir(sb, req->r_paren=
t, rinfo);
> > -             if (dir) {
> > -                     err =3D ceph_fill_inode(dir, NULL, &rinfo->diri,
> > +             parent_dir =3D ceph_get_reply_dir(sb, req->r_parent, rinf=
o);
> > +             if (unlikely(IS_ERR(parent_dir))) {
> > +                     err =3D PTR_ERR(parent_dir);
> > +                     goto done;
> > +             }
> > +             if (parent_dir) {
> > +                     err =3D ceph_fill_inode(parent_dir, NULL, &rinfo-=
>diri,
> >                                             rinfo->dirfrag, session, -1=
,
> >                                             &req->r_caps_reservation);
> >                       if (err < 0)
> > @@ -1612,14 +1617,14 @@ int ceph_fill_trace(struct super_block *sb, str=
uct ceph_mds_request *req)
> >                       WARN_ON_ONCE(1);
> >               }
> >
> > -             if (dir && req->r_op =3D=3D CEPH_MDS_OP_LOOKUPNAME &&
> > +             if (parent_dir && req->r_op =3D=3D CEPH_MDS_OP_LOOKUPNAME=
 &&
> >                   test_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags)=
 &&
> >                   !test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags)) {
> >                       bool is_nokey =3D false;
> >                       struct qstr dname;
> >                       struct dentry *dn, *parent;
> >                       struct fscrypt_str oname =3D FSTR_INIT(NULL, 0);
> > -                     struct ceph_fname fname =3D { .dir        =3D dir=
,
> > +                     struct ceph_fname fname =3D { .dir        =3D par=
ent_dir,
> >                                                   .name       =3D rinfo=
->dname,
> >                                                   .ctext      =3D rinfo=
->altname,
> >                                                   .name_len   =3D rinfo=
->dname_len,
> > @@ -1628,10 +1633,10 @@ int ceph_fill_trace(struct super_block *sb, str=
uct ceph_mds_request *req)
> >                       BUG_ON(!rinfo->head->is_target);
> >                       BUG_ON(req->r_dentry);
> >
> > -                     parent =3D d_find_any_alias(dir);
> > +                     parent =3D d_find_any_alias(parent_dir);
> >                       BUG_ON(!parent);
> >
> > -                     err =3D ceph_fname_alloc_buffer(dir, &oname);
> > +                     err =3D ceph_fname_alloc_buffer(parent_dir, &onam=
e);
> >                       if (err < 0) {
> >                               dput(parent);
> >                               goto done;
> > @@ -1640,7 +1645,7 @@ int ceph_fill_trace(struct super_block *sb, struc=
t ceph_mds_request *req)
> >                       err =3D ceph_fname_to_usr(&fname, NULL, &oname, &=
is_nokey);
> >                       if (err < 0) {
> >                               dput(parent);
> > -                             ceph_fname_free_buffer(dir, &oname);
> > +                             ceph_fname_free_buffer(parent_dir, &oname=
);
> >                               goto done;
> >                       }
> >                       dname.name =3D oname.name;
> > @@ -1659,7 +1664,7 @@ int ceph_fill_trace(struct super_block *sb, struc=
t ceph_mds_request *req)
> >                                     dname.len, dname.name, dn);
> >                               if (!dn) {
> >                                       dput(parent);
> > -                                     ceph_fname_free_buffer(dir, &onam=
e);
> > +                                     ceph_fname_free_buffer(parent_dir=
, &oname);
> >                                       err =3D -ENOMEM;
> >                                       goto done;
> >                               }
> > @@ -1674,12 +1679,12 @@ int ceph_fill_trace(struct super_block *sb, str=
uct ceph_mds_request *req)
> >                                   ceph_snap(d_inode(dn)) !=3D tvino.sna=
p)) {
> >                               doutc(cl, " dn %p points to wrong inode %=
p\n",
> >                                     dn, d_inode(dn));
> > -                             ceph_dir_clear_ordered(dir);
> > +                             ceph_dir_clear_ordered(parent_dir);
> >                               d_delete(dn);
> >                               dput(dn);
> >                               goto retry_lookup;
> >                       }
> > -                     ceph_fname_free_buffer(dir, &oname);
> > +                     ceph_fname_free_buffer(parent_dir, &oname);
> >
> >                       req->r_dentry =3D dn;
> >                       dput(parent);
> > @@ -1869,6 +1874,9 @@ int ceph_fill_trace(struct super_block *sb, struc=
t ceph_mds_request *req)
> >                                           &dvino, ptvino);
> >       }
> >  done:
> > +     /* Drop extra ref from ceph_get_reply_dir() if it returned a new =
inode */
> > +     if (unlikely(!IS_ERR_OR_NULL(parent_dir) && parent_dir !=3D req->=
r_parent))
>
> The '&&' implies to check both conditions. However, if we have parent_dir=
 equal
> to NULL or some error code, then it doesn't make sense to check the secon=
d
> condition. I don't  think that it could introduce some issue here. But,
> potentially, it could be the reason of rarely triggered and non-trivial i=
ssue.
> What do you think? Do I have point here?

Hi Slava,

&& indeed implies checking both conditions, but the second condition is
checked only of the first one is true (short-circuit evaluation).  In
the case that parent_dir is NULL or IS_ERR pointer, req->r_parent check
wouldn't be performed.

So far I'm failing to see the potential for some rarely triggered issue
here: parent_dir is fed to iput() only if a) the pointer is valid in the
first place and b) the pointer represents an extra reference.  If the
pointer is invalid, iput() is guaranteed to not be called.

>
> What if we can do like this:
>
> parent_dir =3D parent_dir !=3D req->r_parent ? parent_dir : NULL;
> if (parent_dir)
>     iput(parent_dir);

With a single "done" label and jumping to it on ceph_get_reply_dir()
failures, this could result in iput() getting called on an invalid
pointer.  While iput() can handle a NULL pointer, it would choke on
any IS_ERR pointer.

Thanks,

                Ilya

