Return-Path: <ceph-devel+bounces-3341-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 409CBB16CC3
	for <lists+ceph-devel@lfdr.de>; Thu, 31 Jul 2025 09:31:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0141C3A713B
	for <lists+ceph-devel@lfdr.de>; Thu, 31 Jul 2025 07:30:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB41F29E0FF;
	Thu, 31 Jul 2025 07:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J+IkKnSE"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2B129DB77
	for <ceph-devel@vger.kernel.org>; Thu, 31 Jul 2025 07:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753947068; cv=none; b=Weu4Wc5wWMKq8hOC2CxQsHLSyal2+wYqSAJbr+r/0x5pgPa5TvAqOyDkLbCx4M+AJqfIK+Btpp8qdrnESwcgjqHmtgLEHl58uMBYORwXIJgr89Att69ZMtT1AG2ueyMY/NJNT7lYLdStCrgPPdjWt52jkKjjGujpOBisjmJc8Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753947068; c=relaxed/simple;
	bh=8JnscfoNZlOSW1qUXmJ2olTtH1A1S+cokm7plJKNKEY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fQ7R4GY+WSN+EYHC1SpISAC/yzjzjbupzn6ixDABU/MVKfzb0XCXk9y3kY5J7mFoO+A/4UZbJ6Nl5xzEP8hLcNPXk9gTs2eWSmX2ce7EQXybyFbjWpBVrisvWOZ1C5yhIMKKU8gzRRqkwetj3AFf+Qfz56HTbIKhwudggcljk3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J+IkKnSE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753947065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RfbWAg9p4xTBdky7exRWGNasdirgkwRfRGPwjUGYwSA=;
	b=J+IkKnSEUjlP8NGe7IC3p0SppkJPgI0MbyM6nh9q7WlUJsmrXACZb4b7OKbtSHQgt4XkXB
	tEs4VFKPyjxxo6h2eZNIvC/cA0SQ48tBBwEsLwPRNnYqzcSMPKR+f9WmJ24EGAz2fZhkG1
	c9ZL5kLApJ8bqogVPA5HCJ654KeQAZQ=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-xx9fq_hBNSCIDVr9joao8A-1; Thu, 31 Jul 2025 03:31:03 -0400
X-MC-Unique: xx9fq_hBNSCIDVr9joao8A-1
X-Mimecast-MFC-AGG-ID: xx9fq_hBNSCIDVr9joao8A_1753947063
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-539393fdacbso111128e0c.2
        for <ceph-devel@vger.kernel.org>; Thu, 31 Jul 2025 00:31:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753947063; x=1754551863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RfbWAg9p4xTBdky7exRWGNasdirgkwRfRGPwjUGYwSA=;
        b=u+7Ni27nAfp5px2OfvZguzGnaC7UpfbKNhIYzkuZVrYrQmlZs2B/5r6LDwEl5CjMUW
         5kA7w/NthE1fJaw67lVfMdQ4OP7x0u9nUbZqmd3u1k1AjZEH0stwGa/r4+OGN6GfD/e0
         S377hya742eJtlbuMN0wDaskfHlJ5xJZHLlIKIX44klG8lIAiXUNRwtpR87rmgj3K041
         bvGvSNfr+43wHUwJjSTAkzBoQuZQq76n9pnfVWpr9aNu63VlNZ/J10gkxi0uLhjBcUEl
         CigZBm/cOA+czdpQKKirgQNoz3hTKYwJKNI9p5XT94CzfWiomJW0Qe2d9Y990EbKC/pn
         DW0Q==
X-Gm-Message-State: AOJu0Yyf/RLDGc/1iXNrF5N8tjgible2zZPT/yfA5ngFSp4/pZTHkEcj
	EkykgRacrKx0gtIMjm12ffAaFJdeOw6zf5iI/PSuPHg+XY/WoYdiwuHt5VZXYkhcQwo2KVMWcJ3
	FoGGhvV+lxC8cpsBzoQgvq0oUt5EBOTWAf3eoo35XrRWKvPLTJDR2DgATLgq1EnCUrlVBs6MQyT
	tgDQtMDaQ4r1aheAxSQZd3UiSFdlufitr11FhNLcE+FtCS7gN7p3hlkmEp
X-Gm-Gg: ASbGnctf5kY3F+hgduRHQ5js8iuE2wd+CCvQr7PnNFk0pnVrwWkhi6bdr3nTBeBwS3l
	z97eOAb4VSa6DYxoOkPTESybU6wZ0wsvhh8DI0+gv4WPw0SE+HJTXJOvkfru51GVxmd/OUJWyXE
	Yb/bjhLzfHU10SA3wznq4WmHBXgM7RT0GsTMhJeQ==
X-Received: by 2002:a67:e011:0:10b0:4fb:f2ff:dd16 with SMTP id ada2fe7eead31-4fbf2ffe298mr1745206137.17.1753947062646;
        Thu, 31 Jul 2025 00:31:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGXSkwVI99FwoLi84iLKMYCeA3Q8vS/B6i1Lxa063a84F4H+syzQ8eyh4iwWs1hVLEUC3WgEthXRvxdTyjiucg=
X-Received: by 2002:a67:e011:0:10b0:4fb:f2ff:dd16 with SMTP id
 ada2fe7eead31-4fbf2ffe298mr1745204137.17.1753947062175; Thu, 31 Jul 2025
 00:31:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250730151900.1591177-1-amarkuze@redhat.com> <20250730151900.1591177-2-amarkuze@redhat.com>
 <012cf478bb6e118912b189dd4cfbdfa7d5249fd7.camel@ibm.com>
In-Reply-To: <012cf478bb6e118912b189dd4cfbdfa7d5249fd7.camel@ibm.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Thu, 31 Jul 2025 11:30:50 +0400
X-Gm-Features: Ac12FXwzpiuBrEG7_p1P8gWK3GeGH6v-mRK-DtFo1_6wiBIw_OktRR2xxVFrn2k
Message-ID: <CAO8a2SjJmWGM0HbR9LVzXcSmf3_WqyYB6YWMmj4Ut_ofoLM4XA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ceph: fix client race condition validating r_parent
 before applying state
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

No new parameters were added, a u64 ino value was changed to struct ceph_vi=
no.
I prefer not to mix functional changes with aesthetic ones, I can add
a separate patch, but it is unrelated to the bug fix here.

On Thu, Jul 31, 2025 at 2:10=E2=80=AFAM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Wed, 2025-07-30 at 15:18 +0000, Alex Markuze wrote:
> > Add validation to ensure the cached parent directory inode matches the
> > directory info in MDS replies. This prevents client-side race condition=
s
> > where concurrent operations (e.g. rename) cause r_parent to become stal=
e
> > between request initiation and reply processing, which could lead to
> > applying state changes to incorrect directory inodes.
> > ---
> >  fs/ceph/mds_client.c | 67 +++++++++++++++++++++++++++++++-------------
> >  1 file changed, 47 insertions(+), 20 deletions(-)
> >
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 8d9fc5e18b17..a164783fc1e1 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -2853,7 +2853,7 @@ char *ceph_mdsc_build_path(struct ceph_mds_client=
 *mdsc, struct dentry *dentry,
> >
> >  static int build_dentry_path(struct ceph_mds_client *mdsc, struct dent=
ry *dentry,
> >                            struct inode *dir, const char **ppath, int *=
ppathlen,
> > -                          u64 *pino, bool *pfreepath, bool parent_lock=
ed)
> > +                          struct ceph_vino *pvino, bool *pfreepath, bo=
ol parent_locked)
>
> We have too much arguments here. It looks like we need to introduce some
> structure.
>
> >  {
> >       char *path;
> >
> > @@ -2862,23 +2862,29 @@ static int build_dentry_path(struct ceph_mds_cl=
ient *mdsc, struct dentry *dentry
> >               dir =3D d_inode_rcu(dentry->d_parent);
> >       if (dir && parent_locked && ceph_snap(dir) =3D=3D CEPH_NOSNAP &&
> >           !IS_ENCRYPTED(dir)) {
> > -             *pino =3D ceph_ino(dir);
> > +             pvino->ino =3D ceph_ino(dir);
> > +             pvino->snap =3D ceph_snap(dir);
> >               rcu_read_unlock();
> >               *ppath =3D dentry->d_name.name;
> >               *ppathlen =3D dentry->d_name.len;
> >               return 0;
> >       }
> >       rcu_read_unlock();
> > -     path =3D ceph_mdsc_build_path(mdsc, dentry, ppathlen, pino, 1);
> > +     path =3D ceph_mdsc_build_path(mdsc, dentry, ppathlen, &pvino->ino=
, 1);
> >       if (IS_ERR(path))
> >               return PTR_ERR(path);
> >       *ppath =3D path;
> >       *pfreepath =3D true;
> > +     /* For paths built by ceph_mdsc_build_path, we need to get snap f=
rom dentry */
>
> I believe the multi-line comment could be good here.
>
> > +     if (dentry && d_inode(dentry))
>
> Could dentry be really NULL here?
>
> > +             pvino->snap =3D ceph_snap(d_inode(dentry));
> > +     else
> > +             pvino->snap =3D CEPH_NOSNAP;
> >       return 0;
> >  }
> >
> >  static int build_inode_path(struct inode *inode,
> > -                         const char **ppath, int *ppathlen, u64 *pino,
> > +                         const char **ppath, int *ppathlen, struct cep=
h_vino *pvino,
> >                           bool *pfreepath)
>
> We have too much arguments here too.
>
> >  {
> >       struct ceph_mds_client *mdsc =3D ceph_sb_to_mdsc(inode->i_sb);
> > @@ -2886,17 +2892,19 @@ static int build_inode_path(struct inode *inode=
,
> >       char *path;
> >
> >       if (ceph_snap(inode) =3D=3D CEPH_NOSNAP) {
> > -             *pino =3D ceph_ino(inode);
> > +             pvino->ino =3D ceph_ino(inode);
> > +             pvino->snap =3D ceph_snap(inode);
> >               *ppathlen =3D 0;
> >               return 0;
> >       }
> >       dentry =3D d_find_alias(inode);
> > -     path =3D ceph_mdsc_build_path(mdsc, dentry, ppathlen, pino, 1);
> > +     path =3D ceph_mdsc_build_path(mdsc, dentry, ppathlen, &pvino->ino=
, 1);
> >       dput(dentry);
> >       if (IS_ERR(path))
> >               return PTR_ERR(path);
> >       *ppath =3D path;
> >       *pfreepath =3D true;
> > +     pvino->snap =3D ceph_snap(inode);
> >       return 0;
> >  }
> >
> > @@ -2907,7 +2915,7 @@ static int build_inode_path(struct inode *inode,
> >  static int set_request_path_attr(struct ceph_mds_client *mdsc, struct =
inode *rinode,
> >                                struct dentry *rdentry, struct inode *rd=
iri,
> >                                const char *rpath, u64 rino, const char =
**ppath,
> > -                              int *pathlen, u64 *ino, bool *freepath,
> > +                              int *pathlen, struct ceph_vino *p_vino, =
bool *freepath,
> >                                bool parent_locked)
>
> Ditto. :)
>
> Thanks,
> Slava.
>
> >  {
> >       struct ceph_client *cl =3D mdsc->fsc->client;
> > @@ -2915,16 +2923,17 @@ static int set_request_path_attr(struct ceph_md=
s_client *mdsc, struct inode *rin
> >       int r =3D 0;
> >
> >       if (rinode) {
> > -             r =3D build_inode_path(rinode, ppath, pathlen, ino, freep=
ath);
> > +             r =3D build_inode_path(rinode, ppath, pathlen, p_vino, fr=
eepath);
> >               boutc(cl, " inode %p %llx.%llx\n", rinode, ceph_ino(rinod=
e),
> > -                   ceph_snap(rinode));
> > +             ceph_snap(rinode));
> >       } else if (rdentry) {
> > -             r =3D build_dentry_path(mdsc, rdentry, rdiri, ppath, path=
len, ino,
> > -                                     freepath, parent_locked);
> > +             r =3D build_dentry_path(mdsc, rdentry, rdiri, ppath, path=
len, p_vino,
> > +                                    freepath, parent_locked);
> >               CEPH_SAN_STRNCPY(result_str, sizeof(result_str), *ppath, =
*pathlen);
> > -             boutc(cl, " dentry %p %llx/%s\n", rdentry, *ino, result_s=
tr);
> > +             boutc(cl, " dentry %p %llx/%s\n", rdentry, p_vino->ino, r=
esult_str);
> >       } else if (rpath || rino) {
> > -             *ino =3D rino;
> > +             p_vino->ino =3D rino;
> > +             p_vino->snap =3D CEPH_NOSNAP;
> >               *ppath =3D rpath;
> >               *pathlen =3D rpath ? strlen(rpath) : 0;
> >               CEPH_SAN_STRNCPY(result_str, sizeof(result_str), rpath, *=
pathlen);
> > @@ -3007,7 +3016,7 @@ static struct ceph_msg *create_request_message(st=
ruct ceph_mds_session *session,
> >       struct ceph_mds_request_head_legacy *lhead;
> >       const char *path1 =3D NULL;
> >       const char *path2 =3D NULL;
> > -     u64 ino1 =3D 0, ino2 =3D 0;
> > +     struct ceph_vino vino1 =3D {0}, vino2 =3D {0};
> >       int pathlen1 =3D 0, pathlen2 =3D 0;
> >       bool freepath1 =3D false, freepath2 =3D false;
> >       struct dentry *old_dentry =3D NULL;
> > @@ -3019,17 +3028,35 @@ static struct ceph_msg *create_request_message(=
struct ceph_mds_session *session,
> >       u16 request_head_version =3D mds_supported_head_version(session);
> >       kuid_t caller_fsuid =3D req->r_cred->fsuid;
> >       kgid_t caller_fsgid =3D req->r_cred->fsgid;
> > +     bool parent_locked =3D test_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r=
_req_flags);
> >
> >       ret =3D set_request_path_attr(mdsc, req->r_inode, req->r_dentry,
> >                             req->r_parent, req->r_path1, req->r_ino1.in=
o,
> > -                           &path1, &pathlen1, &ino1, &freepath1,
> > -                           test_bit(CEPH_MDS_R_PARENT_LOCKED,
> > -                                     &req->r_req_flags));
> > +                           &path1, &pathlen1, &vino1, &freepath1,
> > +                           parent_locked);
> >       if (ret < 0) {
> >               msg =3D ERR_PTR(ret);
> >               goto out;
> >       }
> >
> > +     /*
> > +      * When the parent directory's i_rwsem is *not* locked, req->r_pa=
rent may
> > +      * have become stale (e.g. after a concurrent rename) between the=
 time the
> > +      * dentry was looked up and now.  If we detect that the stored r_=
parent
> > +      * does not match the inode number we just encoded for the reques=
t, switch
> > +      * to the correct inode so that the MDS receives a valid parent r=
eference.
> > +      */
> > +     if (!parent_locked &&
> > +         req->r_parent && vino1.ino && ceph_ino(req->r_parent) !=3D vi=
no1.ino) {
> > +             struct inode *correct_dir =3D ceph_get_inode(mdsc->fsc->s=
b, vino1, NULL);
> > +             if (!IS_ERR(correct_dir)) {
> > +                     WARN(1, "ceph: r_parent mismatch (had %llx wanted=
 %llx) - updating\n",
> > +                          ceph_ino(req->r_parent), vino1.ino);
> > +                     iput(req->r_parent);
> > +                     req->r_parent =3D correct_dir;
> > +             }
> > +     }
> > +
> >       /* If r_old_dentry is set, then assume that its parent is locked =
*/
> >       if (req->r_old_dentry &&
> >           !(req->r_old_dentry->d_flags & DCACHE_DISCONNECTED))
> > @@ -3037,7 +3064,7 @@ static struct ceph_msg *create_request_message(st=
ruct ceph_mds_session *session,
> >       ret =3D set_request_path_attr(mdsc, NULL, old_dentry,
> >                             req->r_old_dentry_dir,
> >                             req->r_path2, req->r_ino2.ino,
> > -                           &path2, &pathlen2, &ino2, &freepath2, true)=
;
> > +                           &path2, &pathlen2, &vino2, &freepath2, true=
);
> >       if (ret < 0) {
> >               msg =3D ERR_PTR(ret);
> >               goto out_free1;
> > @@ -3191,8 +3218,8 @@ static struct ceph_msg *create_request_message(st=
ruct ceph_mds_session *session,
> >       lhead->ino =3D cpu_to_le64(req->r_deleg_ino);
> >       lhead->args =3D req->r_args;
> >
> > -     ceph_encode_filepath(&p, end, ino1, path1);
> > -     ceph_encode_filepath(&p, end, ino2, path2);
> > +     ceph_encode_filepath(&p, end, vino1.ino, path1);
> > +     ceph_encode_filepath(&p, end, vino2.ino, path2);
> >
> >       /* make note of release offset, in case we need to replay */
> >       req->r_request_release_offset =3D p - msg->front.iov_base;


