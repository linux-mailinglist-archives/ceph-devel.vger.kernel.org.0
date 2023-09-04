Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB697914BE
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Sep 2023 11:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352667AbjIDJ3m (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 4 Sep 2023 05:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234386AbjIDJ3l (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 4 Sep 2023 05:29:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A985719B
        for <ceph-devel@vger.kernel.org>; Mon,  4 Sep 2023 02:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693819728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=34xqRQkSUifdwnv2JwZTZmrSUUzVFOdW1jLro54onWY=;
        b=cjGy9opQzpSZJITu31Z/buvOoL6qD7KfUgzUg8PGphyZEGbEaxbFRGIj+g61vq+maY1XFr
        PugV+NPjnc4uqC/L7SMyR7Da5SBemX/kGcPxNL+HaJZ4LjLf5/1cBgaWWu8fvYN6tBwRx7
        RAVgId6tUiuCPB2jFviIETCb2mksYLk=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-06l53hMaPDi5d826CpbPBw-1; Mon, 04 Sep 2023 05:28:45 -0400
X-MC-Unique: 06l53hMaPDi5d826CpbPBw-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9a5d86705e4so87762166b.1
        for <ceph-devel@vger.kernel.org>; Mon, 04 Sep 2023 02:28:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693819724; x=1694424524;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=34xqRQkSUifdwnv2JwZTZmrSUUzVFOdW1jLro54onWY=;
        b=hYKa396Aa41JinKOFZ7PFI9J7ZIyDOfG3NkPlfkBBsqagVaTHEpWU0frQWmRGxBAn+
         nGdCqJb59SLR5X8CeYTnxtO4x25rRa6nhippdRmvHA3cunjXyMtpu2BZQmJEQ2FtHIx1
         0bkp+X7pDMWk/Kj1hz3sw7RmOYQtmp/EQlLvgCYtvbvRbM6BBb+LadEM0MOGvlASy1T2
         iRQfhsR9xZwlfW8tQfZ+H8SweKdPgHm0KQzimC7qVYXWGjDnwITAHLoBC4fCQhY4DU0c
         r6v62lSGxy5GuFKrybZ3R5JwSIQWSXUTY26KS5brYeXumx2/ZSaeJMvHptAGwCA7cH9b
         WTdg==
X-Gm-Message-State: AOJu0YwcAEcFoCRLXRaXZJgMlA4Uz05ii5cRvaZDJYwESQzyAEuQzLSW
        WVQucegiwq4plvDg/2jAzmy5muW6aEX1NYs1MOHjPgqemTGtDosv+LwVlm7inMoYbHv8dY6ZiJV
        1fomg6eQ9ZBauToqoKTz6rTEF2DJFaoqcsDH0TQ==
X-Received: by 2002:a17:907:9619:b0:99d:decd:3dde with SMTP id gb25-20020a170907961900b0099ddecd3ddemr8828284ejc.18.1693819724276;
        Mon, 04 Sep 2023 02:28:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG2/eU33+t6UQhy2nUUqE8QPd9VQcYUZjwoR8eM1/lPSDp5gA5wakWf5QGLfnmHRCPo3tcDWZVvPBpjQ0V0Qe0=
X-Received: by 2002:a17:907:9619:b0:99d:decd:3dde with SMTP id
 gb25-20020a170907961900b0099ddecd3ddemr8828259ejc.18.1693819723835; Mon, 04
 Sep 2023 02:28:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230619071438.7000-1-xiubli@redhat.com> <20230619071438.7000-3-xiubli@redhat.com>
In-Reply-To: <20230619071438.7000-3-xiubli@redhat.com>
From:   Milind Changire <mchangir@redhat.com>
Date:   Mon, 4 Sep 2023 14:58:07 +0530
Message-ID: <CAED=hWAYLBKJ7wuVfvJ3qOibz0sf9VJV=QJrCDjL44XZnyUaWQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] ceph: pass the mdsc to several helpers
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Looks good to me.

Tested-by: Milind Changire <mchangir@redhat.com>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Milind Changire <mchangir@redhat.com>
Reviewed-by: Venky Shankar <vshankar@redhat.com>

On Mon, Jun 19, 2023 at 12:47=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> We will use the 'mdsc' to get the global_id in the following commits.
>
> URL: https://tracker.ceph.com/issues/61590
> Cc: Patrick Donnelly <pdonnell@redhat.com>
> Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c              | 15 +++++++++------
>  fs/ceph/debugfs.c           |  4 ++--
>  fs/ceph/dir.c               |  2 +-
>  fs/ceph/file.c              |  2 +-
>  fs/ceph/mds_client.c        | 37 +++++++++++++++++++++----------------
>  fs/ceph/mds_client.h        |  3 ++-
>  fs/ceph/mdsmap.c            |  3 ++-
>  fs/ceph/snap.c              |  8 +++++---
>  fs/ceph/super.h             |  3 ++-
>  include/linux/ceph/mdsmap.h |  5 ++++-
>  10 files changed, 49 insertions(+), 33 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 59ab5d905ac4..99e805144935 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1178,7 +1178,8 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool q=
ueue_release)
>         }
>  }
>
> -void ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
> +void ceph_remove_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
> +                    bool queue_release)
>  {
>         struct ceph_inode_info *ci =3D cap->ci;
>         struct ceph_fs_client *fsc;
> @@ -1341,6 +1342,8 @@ static void encode_cap_msg(struct ceph_msg *msg, st=
ruct cap_msg_args *arg)
>   */
>  void __ceph_remove_caps(struct ceph_inode_info *ci)
>  {
> +       struct inode *inode =3D &ci->netfs.inode;
> +       struct ceph_mds_client *mdsc =3D ceph_inode_to_client(inode)->mds=
c;
>         struct rb_node *p;
>
>         /* lock i_ceph_lock, because ceph_d_revalidate(..., LOOKUP_RCU)
> @@ -1350,7 +1353,7 @@ void __ceph_remove_caps(struct ceph_inode_info *ci)
>         while (p) {
>                 struct ceph_cap *cap =3D rb_entry(p, struct ceph_cap, ci_=
node);
>                 p =3D rb_next(p);
> -               ceph_remove_cap(cap, true);
> +               ceph_remove_cap(mdsc, cap, true);
>         }
>         spin_unlock(&ci->i_ceph_lock);
>  }
> @@ -3991,7 +3994,7 @@ static void handle_cap_export(struct inode *inode, =
struct ceph_mds_caps *ex,
>                 goto out_unlock;
>
>         if (target < 0) {
> -               ceph_remove_cap(cap, false);
> +               ceph_remove_cap(mdsc, cap, false);
>                 goto out_unlock;
>         }
>
> @@ -4026,7 +4029,7 @@ static void handle_cap_export(struct inode *inode, =
struct ceph_mds_caps *ex,
>                                 change_auth_cap_ses(ci, tcap->session);
>                         }
>                 }
> -               ceph_remove_cap(cap, false);
> +               ceph_remove_cap(mdsc, cap, false);
>                 goto out_unlock;
>         } else if (tsession) {
>                 /* add placeholder for the export tagert */
> @@ -4043,7 +4046,7 @@ static void handle_cap_export(struct inode *inode, =
struct ceph_mds_caps *ex,
>                         spin_unlock(&mdsc->cap_dirty_lock);
>                 }
>
> -               ceph_remove_cap(cap, false);
> +               ceph_remove_cap(mdsc, cap, false);
>                 goto out_unlock;
>         }
>
> @@ -4156,7 +4159,7 @@ static void handle_cap_import(struct ceph_mds_clien=
t *mdsc,
>                                         ocap->mseq, mds, le32_to_cpu(ph->=
seq),
>                                         le32_to_cpu(ph->mseq));
>                 }
> -               ceph_remove_cap(ocap, (ph->flags & CEPH_CAP_FLAG_RELEASE)=
);
> +               ceph_remove_cap(mdsc, ocap, (ph->flags & CEPH_CAP_FLAG_RE=
LEASE));
>         }
>
>         *old_issued =3D issued;
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 3904333fa6c3..2f1e7498cd74 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -81,7 +81,7 @@ static int mdsc_show(struct seq_file *s, void *p)
>                 if (req->r_inode) {
>                         seq_printf(s, " #%llx", ceph_ino(req->r_inode));
>                 } else if (req->r_dentry) {
> -                       path =3D ceph_mdsc_build_path(req->r_dentry, &pat=
hlen,
> +                       path =3D ceph_mdsc_build_path(mdsc, req->r_dentry=
, &pathlen,
>                                                     &pathbase, 0);
>                         if (IS_ERR(path))
>                                 path =3D NULL;
> @@ -100,7 +100,7 @@ static int mdsc_show(struct seq_file *s, void *p)
>                 }
>
>                 if (req->r_old_dentry) {
> -                       path =3D ceph_mdsc_build_path(req->r_old_dentry, =
&pathlen,
> +                       path =3D ceph_mdsc_build_path(mdsc, req->r_old_de=
ntry, &pathlen,
>                                                     &pathbase, 0);
>                         if (IS_ERR(path))
>                                 path =3D NULL;
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 1b46f2b998c3..5fbcd0d5e5ec 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -1219,7 +1219,7 @@ static void ceph_async_unlink_cb(struct ceph_mds_cl=
ient *mdsc,
>         if (result) {
>                 int pathlen =3D 0;
>                 u64 base =3D 0;
> -               char *path =3D ceph_mdsc_build_path(dentry, &pathlen,
> +               char *path =3D ceph_mdsc_build_path(mdsc, dentry, &pathle=
n,
>                                                   &base, 0);
>
>                 /* mark error on parent + clear complete */
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index e878a462c7c3..04bc4cc8ad9b 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -574,7 +574,7 @@ static void ceph_async_create_cb(struct ceph_mds_clie=
nt *mdsc,
>         if (result) {
>                 int pathlen =3D 0;
>                 u64 base =3D 0;
> -               char *path =3D ceph_mdsc_build_path(req->r_dentry, &pathl=
en,
> +               char *path =3D ceph_mdsc_build_path(mdsc, req->r_dentry, =
&pathlen,
>                                                   &base, 0);
>
>                 pr_warn("async create failure path=3D(%llx)%s result=3D%d=
!\n",
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 0a70a2438cb2..b9c7b6c60357 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2125,6 +2125,7 @@ static bool drop_negative_children(struct dentry *d=
entry)
>   */
>  static int trim_caps_cb(struct inode *inode, int mds, void *arg)
>  {
> +       struct ceph_mds_client *mdsc =3D ceph_sb_to_mdsc(inode->i_sb);
>         int *remaining =3D arg;
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
>         int used, wanted, oissued, mine;
> @@ -2172,7 +2173,7 @@ static int trim_caps_cb(struct inode *inode, int md=
s, void *arg)
>
>         if (oissued) {
>                 /* we aren't the only cap.. just remove us */
> -               ceph_remove_cap(cap, true);
> +               ceph_remove_cap(mdsc, cap, true);
>                 (*remaining)--;
>         } else {
>                 struct dentry *dentry;
> @@ -2633,7 +2634,8 @@ static u8 *get_fscrypt_altname(const struct ceph_md=
s_request *req, u32 *plen)
>   * Encode hidden .snap dirs as a double /, i.e.
>   *   foo/.snap/bar -> foo//bar
>   */
> -char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,=
 int for_wire)
> +char *ceph_mdsc_build_path(struct ceph_mds_client *mdsc, struct dentry *=
dentry,
> +                          int *plen, u64 *pbase, int for_wire)
>  {
>         struct dentry *cur;
>         struct inode *inode;
> @@ -2748,9 +2750,9 @@ char *ceph_mdsc_build_path(struct dentry *dentry, i=
nt *plen, u64 *pbase, int for
>         return path + pos;
>  }
>
> -static int build_dentry_path(struct dentry *dentry, struct inode *dir,
> -                            const char **ppath, int *ppathlen, u64 *pino=
,
> -                            bool *pfreepath, bool parent_locked)
> +static int build_dentry_path(struct ceph_mds_client *mdsc, struct dentry=
 *dentry,
> +                            struct inode *dir, const char **ppath, int *=
ppathlen,
> +                            u64 *pino, bool *pfreepath, bool parent_lock=
ed)
>  {
>         char *path;
>
> @@ -2765,7 +2767,7 @@ static int build_dentry_path(struct dentry *dentry,=
 struct inode *dir,
>                 return 0;
>         }
>         rcu_read_unlock();
> -       path =3D ceph_mdsc_build_path(dentry, ppathlen, pino, 1);
> +       path =3D ceph_mdsc_build_path(mdsc, dentry, ppathlen, pino, 1);
>         if (IS_ERR(path))
>                 return PTR_ERR(path);
>         *ppath =3D path;
> @@ -2777,6 +2779,7 @@ static int build_inode_path(struct inode *inode,
>                             const char **ppath, int *ppathlen, u64 *pino,
>                             bool *pfreepath)
>  {
> +       struct ceph_mds_client *mdsc =3D ceph_sb_to_mdsc(inode->i_sb);
>         struct dentry *dentry;
>         char *path;
>
> @@ -2786,7 +2789,7 @@ static int build_inode_path(struct inode *inode,
>                 return 0;
>         }
>         dentry =3D d_find_alias(inode);
> -       path =3D ceph_mdsc_build_path(dentry, ppathlen, pino, 1);
> +       path =3D ceph_mdsc_build_path(mdsc, dentry, ppathlen, pino, 1);
>         dput(dentry);
>         if (IS_ERR(path))
>                 return PTR_ERR(path);
> @@ -2799,10 +2802,11 @@ static int build_inode_path(struct inode *inode,
>   * request arguments may be specified via an inode *, a dentry *, or
>   * an explicit ino+path.
>   */
> -static int set_request_path_attr(struct inode *rinode, struct dentry *rd=
entry,
> -                                 struct inode *rdiri, const char *rpath,
> -                                 u64 rino, const char **ppath, int *path=
len,
> -                                 u64 *ino, bool *freepath, bool parent_l=
ocked)
> +static int set_request_path_attr(struct ceph_mds_client *mdsc, struct in=
ode *rinode,
> +                                struct dentry *rdentry, struct inode *rd=
iri,
> +                                const char *rpath, u64 rino, const char =
**ppath,
> +                                int *pathlen, u64 *ino, bool *freepath,
> +                                bool parent_locked)
>  {
>         int r =3D 0;
>
> @@ -2811,7 +2815,7 @@ static int set_request_path_attr(struct inode *rino=
de, struct dentry *rdentry,
>                 dout(" inode %p %llx.%llx\n", rinode, ceph_ino(rinode),
>                      ceph_snap(rinode));
>         } else if (rdentry) {
> -               r =3D build_dentry_path(rdentry, rdiri, ppath, pathlen, i=
no,
> +               r =3D build_dentry_path(mdsc, rdentry, rdiri, ppath, path=
len, ino,
>                                         freepath, parent_locked);
>                 dout(" dentry %p %llx/%.*s\n", rdentry, *ino, *pathlen,
>                      *ppath);
> @@ -2883,7 +2887,7 @@ static struct ceph_msg *create_request_message(stru=
ct ceph_mds_session *session,
>         int ret;
>         bool legacy =3D !(session->s_con.peer_features & CEPH_FEATURE_FS_=
BTIME);
>
> -       ret =3D set_request_path_attr(req->r_inode, req->r_dentry,
> +       ret =3D set_request_path_attr(mdsc, req->r_inode, req->r_dentry,
>                               req->r_parent, req->r_path1, req->r_ino1.in=
o,
>                               &path1, &pathlen1, &ino1, &freepath1,
>                               test_bit(CEPH_MDS_R_PARENT_LOCKED,
> @@ -2897,7 +2901,7 @@ static struct ceph_msg *create_request_message(stru=
ct ceph_mds_session *session,
>         if (req->r_old_dentry &&
>             !(req->r_old_dentry->d_flags & DCACHE_DISCONNECTED))
>                 old_dentry =3D req->r_old_dentry;
> -       ret =3D set_request_path_attr(NULL, old_dentry,
> +       ret =3D set_request_path_attr(mdsc, NULL, old_dentry,
>                               req->r_old_dentry_dir,
>                               req->r_path2, req->r_ino2.ino,
>                               &path2, &pathlen2, &ino2, &freepath2, true)=
;
> @@ -4288,6 +4292,7 @@ static struct dentry* d_find_primary(struct inode *=
inode)
>   */
>  static int reconnect_caps_cb(struct inode *inode, int mds, void *arg)
>  {
> +       struct ceph_mds_client *mdsc =3D ceph_sb_to_mdsc(inode->i_sb);
>         union {
>                 struct ceph_mds_cap_reconnect v2;
>                 struct ceph_mds_cap_reconnect_v1 v1;
> @@ -4305,7 +4310,7 @@ static int reconnect_caps_cb(struct inode *inode, i=
nt mds, void *arg)
>         dentry =3D d_find_primary(inode);
>         if (dentry) {
>                 /* set pathbase to parent dir when msg_version >=3D 2 */
> -               path =3D ceph_mdsc_build_path(dentry, &pathlen, &pathbase=
,
> +               path =3D ceph_mdsc_build_path(mdsc, dentry, &pathlen, &pa=
thbase,
>                                             recon_state->msg_version >=3D=
 2);
>                 dput(dentry);
>                 if (IS_ERR(path)) {
> @@ -5660,7 +5665,7 @@ void ceph_mdsc_handle_mdsmap(struct ceph_mds_client=
 *mdsc, struct ceph_msg *msg)
>                 return;
>         }
>
> -       newmap =3D ceph_mdsmap_decode(&p, end, ceph_msgr2(mdsc->fsc->clie=
nt));
> +       newmap =3D ceph_mdsmap_decode(mdsc, &p, end, ceph_msgr2(mdsc->fsc=
->client));
>         if (IS_ERR(newmap)) {
>                 err =3D PTR_ERR(newmap);
>                 goto bad_unlock;
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 351d92f7fc4f..20bcf8d5322e 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -578,7 +578,8 @@ static inline void ceph_mdsc_free_path(char *path, in=
t len)
>                 __putname(path - (PATH_MAX - 1 - len));
>  }
>
> -extern char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 =
*base,
> +extern char *ceph_mdsc_build_path(struct ceph_mds_client *mdsc,
> +                                 struct dentry *dentry, int *plen, u64 *=
base,
>                                   int stop_on_nosnap);
>
>  extern void __ceph_mdsc_drop_dentry_lease(struct dentry *dentry);
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index 7dac21ee6ce7..6cbec7aed5a0 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -114,7 +114,8 @@ static int __decode_and_drop_compat_set(void **p, voi=
d* end)
>   * Ignore any fields we don't care about (there are quite a few of
>   * them).
>   */
> -struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
> +struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_mds_client *mdsc, voi=
d **p,
> +                                      void *end, bool msgr2)
>  {
>         struct ceph_mdsmap *m;
>         const void *start =3D *p;
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index abd52f5b3b0a..5bd47829a005 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -451,7 +451,8 @@ static void rebuild_snap_realms(struct ceph_snap_real=
m *realm,
>                         continue;
>                 }
>
> -               last =3D build_snap_context(_realm, &realm_queue, dirty_r=
ealms);
> +               last =3D build_snap_context(mdsc, _realm, &realm_queue,
> +                                         dirty_realms);
>                 dout("%s %llx %p, %s\n", __func__, _realm->ino, _realm,
>                      last > 0 ? "is deferred" : !last ? "succeeded" : "fa=
iled");
>
> @@ -709,7 +710,8 @@ int __ceph_finish_cap_snap(struct ceph_inode_info *ci=
,
>   * Queue cap_snaps for snap writeback for this realm and its children.
>   * Called under snap_rwsem, so realm topology won't change.
>   */
> -static void queue_realm_cap_snaps(struct ceph_snap_realm *realm)
> +static void queue_realm_cap_snaps(struct ceph_mds_client *mdsc,
> +                                 struct ceph_snap_realm *realm)
>  {
>         struct ceph_inode_info *ci;
>         struct inode *lastinode =3D NULL;
> @@ -874,7 +876,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *md=
sc,
>                 realm =3D list_first_entry(&dirty_realms, struct ceph_sna=
p_realm,
>                                          dirty_item);
>                 list_del_init(&realm->dirty_item);
> -               queue_realm_cap_snaps(realm);
> +               queue_realm_cap_snaps(mdsc, realm);
>         }
>
>         if (realm_ret)
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 107a9d16a4e8..ab5c0c703eae 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1223,7 +1223,8 @@ extern void ceph_add_cap(struct inode *inode,
>                          unsigned cap, unsigned seq, u64 realmino, int fl=
ags,
>                          struct ceph_cap **new_cap);
>  extern void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release);
> -extern void ceph_remove_cap(struct ceph_cap *cap, bool queue_release);
> +extern void ceph_remove_cap(struct ceph_mds_client *mdsc, struct ceph_ca=
p *cap,
> +                           bool queue_release);
>  extern void __ceph_remove_caps(struct ceph_inode_info *ci);
>  extern void ceph_put_cap(struct ceph_mds_client *mdsc,
>                          struct ceph_cap *cap);
> diff --git a/include/linux/ceph/mdsmap.h b/include/linux/ceph/mdsmap.h
> index 4c3e0648dc27..89f1931f1ba6 100644
> --- a/include/linux/ceph/mdsmap.h
> +++ b/include/linux/ceph/mdsmap.h
> @@ -5,6 +5,8 @@
>  #include <linux/bug.h>
>  #include <linux/ceph/types.h>
>
> +struct ceph_mds_client;
> +
>  /*
>   * mds map - describe servers in the mds cluster.
>   *
> @@ -65,7 +67,8 @@ static inline bool ceph_mdsmap_is_laggy(struct ceph_mds=
map *m, int w)
>  }
>
>  extern int ceph_mdsmap_get_random_mds(struct ceph_mdsmap *m);
> -struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2);
> +struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_mds_client *mdsc, voi=
d **p,
> +                                      void *end, bool msgr2);
>  extern void ceph_mdsmap_destroy(struct ceph_mdsmap *m);
>  extern bool ceph_mdsmap_is_cluster_available(struct ceph_mdsmap *m);
>
> --
> 2.40.1
>


--=20
Milind

