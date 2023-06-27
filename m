Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF9B73FD03
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Jun 2023 15:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjF0NmJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Jun 2023 09:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjF0NmI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 27 Jun 2023 09:42:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5AD2962
        for <ceph-devel@vger.kernel.org>; Tue, 27 Jun 2023 06:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687873286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lmDKzToSsEaeKbdPQlWOC+TnDvuELQh9yzClzLHfw1E=;
        b=Ad2cG1fW9eku4WU7QlWHd6rXVpCjtnrk8RzuQ5bq75Vt4CwI1eODd+xonETIcfk1YrTLTG
        4zgFInlzfAUm9V/p2oOikChyEGay/vCA6+e/dWsO38V/Wz4nZE/G1kh2ilVyugypWgDyNm
        A1OaOrpoqr1LwZVoj7td4KxzBpSUEeQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-R5pbdvpaNF6j84NDzgG8mQ-1; Tue, 27 Jun 2023 09:41:25 -0400
X-MC-Unique: R5pbdvpaNF6j84NDzgG8mQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-94a341efd9aso270920266b.0
        for <ceph-devel@vger.kernel.org>; Tue, 27 Jun 2023 06:41:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687873284; x=1690465284;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lmDKzToSsEaeKbdPQlWOC+TnDvuELQh9yzClzLHfw1E=;
        b=gYUqgcXjdZmiyXWdF1TCv8XR2BrXkzQiOT2S55z8JwOPJLAl60TurPIESTvCMytFh5
         EMMZIBD8wI85AkPGF0NBk4zWpNV099RvzOwsBZzVYQzcWCgVA1qnRx/ajJDmBxESym4A
         YpYOFfEeeC/05g7tJhU3+Wx+Z/aP78WGjVcekHFkEBQ6EeP7qKGsl42Xr9HOz/y/lvPt
         3rGsRBR6e0TbqSfvi4ehPIyhiW/Kk+FtA7bo0bDEG5vgVN1WfEvbqgn2o8jppR8tiFFk
         kPzXYVwi0oEQribmLqUBnQPV2z1gDm+VISsM+RCQCUe6thu6BKGl4meRo88WqUqBXE2a
         rYsA==
X-Gm-Message-State: AC+VfDztC7nE83XljGSvdkTLXCc3U/dW18i4P/T+I/pNBlVWw59S8Y0q
        j+FGDEkcFybWUG7vLppw6uNAfBT125k6zoOWG2gUDwfrKtsUNcM87PTWZxgzEV4hEMc2RkmdnN3
        v46iJP4QvrD6BbiZF972XcpnASbu1NZlCBFPqiN+X2fh5qQ==
X-Received: by 2002:a17:906:51d9:b0:98d:7818:e51b with SMTP id v25-20020a17090651d900b0098d7818e51bmr12159416ejk.27.1687873283989;
        Tue, 27 Jun 2023 06:41:23 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6hXOQlOuL0lmKvoV4ZYh6ghUIS3oK9AveVFgn0Pr5HaEaSXPv6Ciw+IRx1Hitngytj+PCKyc5DgkafJ9rbEYo=
X-Received: by 2002:a17:906:51d9:b0:98d:7818:e51b with SMTP id
 v25-20020a17090651d900b0098d7818e51bmr12159402ejk.27.1687873283711; Tue, 27
 Jun 2023 06:41:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230606033850.1069497-1-xiubli@redhat.com>
In-Reply-To: <20230606033850.1069497-1-xiubli@redhat.com>
From:   Milind Changire <mchangir@redhat.com>
Date:   Tue, 27 Jun 2023 19:10:47 +0530
Message-ID: <CAED=hWDXoM45sp4OqBDH-7cOFJzBDRt0v9T5k8EYYHtEYKJGfg@mail.gmail.com>
Subject: Re: [PATCH] ceph: voluntarily drop Xx caps for requests those touch
 parent mtime
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Looks good to me.

Reviewed-by: Milind Changire <mchangir@redhat.com>

On Tue, Jun 6, 2023 at 9:11=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> For write requests the parent's mtime will be updated correspondingly.
> And if the 'Xx' caps is issued and when releasing other caps together
> with the write requests the MDS Locker will try to eval the xattr lock,
> which need to change the locker state excl --> sync and need to do Xx
> caps revocation.
>
> Just voluntarily dropping CEPH_CAP_XATTR_EXCL caps to avoid a cap
> revoke message, which could cause the mtime will be overwrote by stale
> one.
>
> URL: https://tracker.ceph.com/issues/61584
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/dir.c  | 14 +++++++-------
>  fs/ceph/file.c |  2 +-
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 09bbd0ffbf4f..1b46f2b998c3 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -925,7 +925,7 @@ static int ceph_mknod(struct mnt_idmap *idmap, struct=
 inode *dir,
>         set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
>         req->r_args.mknod.mode =3D cpu_to_le32(mode);
>         req->r_args.mknod.rdev =3D cpu_to_le32(rdev);
> -       req->r_dentry_drop =3D CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
> +       req->r_dentry_drop =3D CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL =
| CEPH_CAP_XATTR_EXCL;
>         req->r_dentry_unless =3D CEPH_CAP_FILE_EXCL;
>
>         ceph_as_ctx_to_req(req, &as_ctx);
> @@ -1037,7 +1037,7 @@ static int ceph_symlink(struct mnt_idmap *idmap, st=
ruct inode *dir,
>         set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
>         req->r_dentry =3D dget(dentry);
>         req->r_num_caps =3D 2;
> -       req->r_dentry_drop =3D CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
> +       req->r_dentry_drop =3D CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL =
| CEPH_CAP_XATTR_EXCL;
>         req->r_dentry_unless =3D CEPH_CAP_FILE_EXCL;
>
>         ceph_as_ctx_to_req(req, &as_ctx);
> @@ -1112,7 +1112,7 @@ static int ceph_mkdir(struct mnt_idmap *idmap, stru=
ct inode *dir,
>         ihold(dir);
>         set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
>         req->r_args.mkdir.mode =3D cpu_to_le32(mode);
> -       req->r_dentry_drop =3D CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
> +       req->r_dentry_drop =3D CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL =
| CEPH_CAP_XATTR_EXCL;
>         req->r_dentry_unless =3D CEPH_CAP_FILE_EXCL;
>
>         ceph_as_ctx_to_req(req, &as_ctx);
> @@ -1173,7 +1173,7 @@ static int ceph_link(struct dentry *old_dentry, str=
uct inode *dir,
>         req->r_parent =3D dir;
>         ihold(dir);
>         set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
> -       req->r_dentry_drop =3D CEPH_CAP_FILE_SHARED;
> +       req->r_dentry_drop =3D CEPH_CAP_FILE_SHARED | CEPH_CAP_XATTR_EXCL=
;
>         req->r_dentry_unless =3D CEPH_CAP_FILE_EXCL;
>         /* release LINK_SHARED on source inode (mds will lock it) */
>         req->r_old_inode_drop =3D CEPH_CAP_LINK_SHARED | CEPH_CAP_LINK_EX=
CL;
> @@ -1312,7 +1312,7 @@ static int ceph_unlink(struct inode *dir, struct de=
ntry *dentry)
>         req->r_num_caps =3D 2;
>         req->r_parent =3D dir;
>         ihold(dir);
> -       req->r_dentry_drop =3D CEPH_CAP_FILE_SHARED;
> +       req->r_dentry_drop =3D CEPH_CAP_FILE_SHARED | CEPH_CAP_XATTR_EXCL=
;
>         req->r_dentry_unless =3D CEPH_CAP_FILE_EXCL;
>         req->r_inode_drop =3D ceph_drop_caps_for_unlink(inode);
>
> @@ -1418,9 +1418,9 @@ static int ceph_rename(struct mnt_idmap *idmap, str=
uct inode *old_dir,
>         req->r_parent =3D new_dir;
>         ihold(new_dir);
>         set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
> -       req->r_old_dentry_drop =3D CEPH_CAP_FILE_SHARED;
> +       req->r_old_dentry_drop =3D CEPH_CAP_FILE_SHARED | CEPH_CAP_XATTR_=
EXCL;
>         req->r_old_dentry_unless =3D CEPH_CAP_FILE_EXCL;
> -       req->r_dentry_drop =3D CEPH_CAP_FILE_SHARED;
> +       req->r_dentry_drop =3D CEPH_CAP_FILE_SHARED | CEPH_CAP_XATTR_EXCL=
;
>         req->r_dentry_unless =3D CEPH_CAP_FILE_EXCL;
>         /* release LINK_RDCACHE on source inode (mds will lock it) */
>         req->r_old_inode_drop =3D CEPH_CAP_LINK_SHARED | CEPH_CAP_LINK_EX=
CL;
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 9e74ed673f93..e878a462c7c3 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -799,7 +799,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry=
 *dentry,
>         if (flags & O_CREAT) {
>                 struct ceph_file_layout lo;
>
> -               req->r_dentry_drop =3D CEPH_CAP_FILE_SHARED | CEPH_CAP_AU=
TH_EXCL;
> +               req->r_dentry_drop =3D CEPH_CAP_FILE_SHARED | CEPH_CAP_AU=
TH_EXCL | CEPH_CAP_XATTR_EXCL;
>                 req->r_dentry_unless =3D CEPH_CAP_FILE_EXCL;
>
>                 ceph_as_ctx_to_req(req, &as_ctx);
> --
> 2.40.1
>


--=20
Milind

