Return-Path: <ceph-devel+bounces-3565-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 543EDB4ABD3
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Sep 2025 13:28:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F8E23B7D03
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Sep 2025 11:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEB4E31E117;
	Tue,  9 Sep 2025 11:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fS08+RbH"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA0331E101;
	Tue,  9 Sep 2025 11:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757417299; cv=none; b=KMHVgoGso5PBlwk7nsn+6zlT5EhyztF0wpMZar9inrKfTsmkuavs9/6nlG/euVT2CDuUM4DBqCB0XujuVcwKuPisIobFpB+DVvTcNLfBwMtGNxfpxm6y7izbuHx24oBMCZNelXU8qm4vriuttdpgS2EItpBLxTuycbFzWY7sCaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757417299; c=relaxed/simple;
	bh=NkcoMXcp/rsBqEhVBnTXi4VMn3SOAZiUsivNdt5NTVw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SbOLapp4+3S3qqOdgTVW3/uy7el3DqHuTPI+mLtDB9v3vqx5cW5Tf1E4b3OQB78rKFShYBmHxgKYShOT1czoYGIHDI57Yzmzux8AxN96X1yEzlmkPgDHaRnscTZiaRs3mc/MiQ6FZZuJkcUg1MqynLWDt/QXjWaQIh4GMB5v3xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fS08+RbH; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2570bf6058aso23395635ad.0;
        Tue, 09 Sep 2025 04:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757417296; x=1758022096; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MKBowNiYyd4mCCO3VytXljo5TnEKYxL/OTwxTT+s4sY=;
        b=fS08+RbHQKrIv88XpWvoex409nZIxQYsPqhmChpuRyYp0CdBuKdyCzorq+XBGY2ipy
         YmqlJXrevkNEbSE6g1TXoy45Mxq5k7O+AVY3fl9dQUeKWXPdwJcEJoWopI89SGRR76ku
         RC0RtAfWFqBwPuFhGjsgd5sNCAor1LlaPXMtTL+EjFiN610Jf6dzdy/Rp49wVtFA23y/
         AQKKClYtSJ5RK/J34o2ZtVUTrD0GROyVIbDZp5fDc6ZH4vCEsfyTSsyYwq9HcWSYhnBG
         Suym5KrFL5BWFwPye4dNyUPGoCLLofh7OoUaF82X+2UNZNdEv+qk5YvEEk0nEK3q839v
         Qaww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757417296; x=1758022096;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MKBowNiYyd4mCCO3VytXljo5TnEKYxL/OTwxTT+s4sY=;
        b=pzNxpbw4tAAPiSLQVhqFTxRInkRS/YeAWoHwN+4MuMO7gippUMnTO2PWLo/X8l0sRV
         0ZUfJLYQWY6oitHNrH2HPDZt4JcJQMansswqYfyTzzfLFVw4psvFj91V4sZVAUcEng5+
         rQ5xq49FX8neFcY7n/U9g9CCbQeuAG8PEETrnh528m6NkxAO6WcNjOzO8OVOTtivg221
         jioDBrTFK4NTLoyexrFh1sATnuUybnYngpEJXCsrfmuNslw0MxvoZehD7c/sOWPnEKW1
         zSyMWS5XNj1ZoHDegQjufiOh+tQWWt6FDapU2vvWDckp7s5mF/cJ7DjMXNdpiM4Sl29J
         ykMg==
X-Forwarded-Encrypted: i=1; AJvYcCWZB8+5aPG/QnN9OIwGBgkq7dMlhwrWRlTuc2f2lR+nD2o118EOa3VLIEgvYU5M/TbAchYYujKbwDxkAe0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoKJ2X0lpVzsESWQjVPQEFdq804wTt3/7ZDY3h6xKmSovDJwaQ
	7TdhfCihFLr269hptfsUWr8yQYs7MLkN3+DNmhz0OJT04kleNjw/ZA9Aeum7i2AU7wLb27aQgi/
	hkwCBbIBWO7deo/sGT75hQueAWQwW+N2xUj0q
X-Gm-Gg: ASbGncuzul1v1RDNR/kEWDw5KdcKTEw+hS84sf02iiYLC7T0ttGFH0Jr2FXSlv9or8C
	8KCLNgtlrIH+k1OHV8nK3oqt2Yvf4FaPFebc8sZhoOgyDEM//Dwyea3EEY1gQOYOTTMTeJdbIAz
	l2GJdfzE9bYENhE4mRxK32OjnRHjcao9bGHfR61SBsvwwkX0iC0IwKwGmsgGfO4TyebPDwoxPnl
	Za4k7Y=
X-Google-Smtp-Source: AGHT+IEdgDyuozo7m9SpQ2EAkEIfDTbGGoRWnYiotpIaXyia2X3Ga0glRgqZ7t6tJ0e30zO4z5BiY4NSYzr4BdoKDvU=
X-Received: by 2002:a17:902:e801:b0:24b:1589:5046 with SMTP id
 d9443c01a7336-2516d52d41amr158030495ad.5.1757417296018; Tue, 09 Sep 2025
 04:28:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250904101234.1258643-1-amarkuze@redhat.com>
In-Reply-To: <20250904101234.1258643-1-amarkuze@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 9 Sep 2025 13:28:04 +0200
X-Gm-Features: Ac12FXyB_8sKtfQu_fFLf0mwWYf4WAlNdwO3mU-F_AR4vcWEI0ZzQYJhiK0QjFc
Message-ID: <CAOi1vP89DMp5Ka8zcSMJb9Vi6rN8U_Y-mogeNHNj0FYDhUTkgA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ceph/inode: drop extra reference from
 ceph_get_reply_dir() in ceph_fill_trace()
To: Alex Markuze <amarkuze@redhat.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Slava.Dubeyko@ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 4, 2025 at 12:12=E2=80=AFPM Alex Markuze <amarkuze@redhat.com> =
wrote:
>
> ceph_get_reply_dir() may return a different, referenced inode when r_pare=
nt is stale and the parent directory lock is not held.
> ceph_fill_trace() used that inode but failed to drop the reference when i=
t differed from req->r_parent, leaking an inode reference.
>
> Keep the directory inode in a local and iput() it at function end if it d=
oes not match req->r_parent.
>
> Signed-off-by: Alex Markuze <amarkuze@redhat.com>
> ---
>  fs/ceph/inode.c | 30 +++++++++++++++++++-----------
>  1 file changed, 19 insertions(+), 11 deletions(-)
>
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 470ee595ecf2..cffa2cd7b530 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1584,6 +1584,7 @@ int ceph_fill_trace(struct super_block *sb, struct =
ceph_mds_request *req)
>         struct ceph_vino tvino, dvino;
>         struct ceph_fs_client *fsc =3D ceph_sb_to_fs_client(sb);
>         struct ceph_client *cl =3D fsc->client;
> +       struct inode *parent_dir =3D NULL;
>         int err =3D 0;
>
>         doutc(cl, "%p is_dentry %d is_target %d\n", req,
> @@ -1601,9 +1602,13 @@ int ceph_fill_trace(struct super_block *sb, struct=
 ceph_mds_request *req)
>                  * r_parent may be stale, in cases when R_PARENT_LOCKED i=
s not set,
>                  * so we need to get the correct inode
>                  */
> -               struct inode *dir =3D ceph_get_reply_dir(sb, req->r_paren=
t, rinfo);
> -               if (dir) {
> -                       err =3D ceph_fill_inode(dir, NULL, &rinfo->diri,
> +               parent_dir =3D ceph_get_reply_dir(sb, req->r_parent, rinf=
o);
> +               if (unlikely(IS_ERR(parent_dir))) {
> +                       err =3D PTR_ERR(parent_dir);
> +                       goto done;
> +               }
> +               if (parent_dir) {
> +                       err =3D ceph_fill_inode(parent_dir, NULL, &rinfo-=
>diri,
>                                               rinfo->dirfrag, session, -1=
,
>                                               &req->r_caps_reservation);
>                         if (err < 0)
> @@ -1612,14 +1617,14 @@ int ceph_fill_trace(struct super_block *sb, struc=
t ceph_mds_request *req)
>                         WARN_ON_ONCE(1);
>                 }
>
> -               if (dir && req->r_op =3D=3D CEPH_MDS_OP_LOOKUPNAME &&
> +               if (parent_dir && req->r_op =3D=3D CEPH_MDS_OP_LOOKUPNAME=
 &&
>                     test_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags)=
 &&
>                     !test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags)) {
>                         bool is_nokey =3D false;
>                         struct qstr dname;
>                         struct dentry *dn, *parent;
>                         struct fscrypt_str oname =3D FSTR_INIT(NULL, 0);
> -                       struct ceph_fname fname =3D { .dir        =3D dir=
,
> +                       struct ceph_fname fname =3D { .dir        =3D par=
ent_dir,
>                                                     .name       =3D rinfo=
->dname,
>                                                     .ctext      =3D rinfo=
->altname,
>                                                     .name_len   =3D rinfo=
->dname_len,
> @@ -1628,10 +1633,10 @@ int ceph_fill_trace(struct super_block *sb, struc=
t ceph_mds_request *req)
>                         BUG_ON(!rinfo->head->is_target);
>                         BUG_ON(req->r_dentry);
>
> -                       parent =3D d_find_any_alias(dir);
> +                       parent =3D d_find_any_alias(parent_dir);
>                         BUG_ON(!parent);
>
> -                       err =3D ceph_fname_alloc_buffer(dir, &oname);
> +                       err =3D ceph_fname_alloc_buffer(parent_dir, &onam=
e);
>                         if (err < 0) {
>                                 dput(parent);
>                                 goto done;
> @@ -1640,7 +1645,7 @@ int ceph_fill_trace(struct super_block *sb, struct =
ceph_mds_request *req)
>                         err =3D ceph_fname_to_usr(&fname, NULL, &oname, &=
is_nokey);
>                         if (err < 0) {
>                                 dput(parent);
> -                               ceph_fname_free_buffer(dir, &oname);
> +                               ceph_fname_free_buffer(parent_dir, &oname=
);
>                                 goto done;
>                         }
>                         dname.name =3D oname.name;
> @@ -1659,7 +1664,7 @@ int ceph_fill_trace(struct super_block *sb, struct =
ceph_mds_request *req)
>                                       dname.len, dname.name, dn);
>                                 if (!dn) {
>                                         dput(parent);
> -                                       ceph_fname_free_buffer(dir, &onam=
e);
> +                                       ceph_fname_free_buffer(parent_dir=
, &oname);
>                                         err =3D -ENOMEM;
>                                         goto done;
>                                 }
> @@ -1674,12 +1679,12 @@ int ceph_fill_trace(struct super_block *sb, struc=
t ceph_mds_request *req)
>                                     ceph_snap(d_inode(dn)) !=3D tvino.sna=
p)) {
>                                 doutc(cl, " dn %p points to wrong inode %=
p\n",
>                                       dn, d_inode(dn));
> -                               ceph_dir_clear_ordered(dir);
> +                               ceph_dir_clear_ordered(parent_dir);
>                                 d_delete(dn);
>                                 dput(dn);
>                                 goto retry_lookup;
>                         }
> -                       ceph_fname_free_buffer(dir, &oname);
> +                       ceph_fname_free_buffer(parent_dir, &oname);
>
>                         req->r_dentry =3D dn;
>                         dput(parent);
> @@ -1869,6 +1874,9 @@ int ceph_fill_trace(struct super_block *sb, struct =
ceph_mds_request *req)
>                                             &dvino, ptvino);
>         }
>  done:
> +       /* Drop extra ref from ceph_get_reply_dir() if it returned a new =
inode */
> +       if (unlikely(!IS_ERR_OR_NULL(parent_dir) && parent_dir !=3D req->=
r_parent))
> +               iput(parent_dir);
>         doutc(cl, "done err=3D%d\n", err);
>         return err;
>  }
> --
> 2.34.1
>

Folded into "ceph: fix client race condition where r_parent becomes stale
before sending message" along with the following kerneldoc fixup

  * ceph_mdsc_build_path - build a path string to a given dentry
  * @dentry: dentry to which path should be built
- * @plen: returned length of string
- * @pbase: returned base inode number
+ * @path_info: output path, length, base ino+snap, and freepath ownership =
flag
  * @for_wire: is this path going to be sent to the MDS?
  *

and queued up for 6.17-rc6.

Thanks,

                Ilya

