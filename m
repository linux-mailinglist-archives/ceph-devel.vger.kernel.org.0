Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA81972841C
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jun 2023 17:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235583AbjFHPsy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Jun 2023 11:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236841AbjFHPsx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Jun 2023 11:48:53 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADFE30F1
        for <ceph-devel@vger.kernel.org>; Thu,  8 Jun 2023 08:48:17 -0700 (PDT)
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 00FDD3F14A
        for <ceph-devel@vger.kernel.org>; Thu,  8 Jun 2023 15:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686239199;
        bh=RyaR97gkxxeix1gmKAnfIKIlV/8H2Db9pN/XXiJh8ZU=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=glplArN921jSFT04tNvKnx27M4Y8QW0Z4kGKvFO+pyGqdS/rF6Be2Ylnh8Opxsi6+
         dZwagji0o3Qop+OaFAHHWeZSSRsEZO1V1HMN5cfH4/3ZIMEW6soT49SRPK/ry6UsYI
         yJ5g8MbTiIUrWuW41aS1VG9oeQ4TZGLvn4gXr+UH6kHNJjEqIgZdy7sHkMFT1MH2fh
         Xaufy1hF9d3ci8lSAiB3Say/t+OzhhSbHrY+IkmHapVPPAPTyE3cZg2Ujef+xO70DP
         3zm2vc1FempXozJLUWcyJ3BUWppV2QdRJ6EcqldlQTqphBUBqq3FRjN0oNbJwhAvst
         uu1ZybC6Ws0Wg==
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-557d435c07cso712500eaf.0
        for <ceph-devel@vger.kernel.org>; Thu, 08 Jun 2023 08:46:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686239198; x=1688831198;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RyaR97gkxxeix1gmKAnfIKIlV/8H2Db9pN/XXiJh8ZU=;
        b=BlZmv3/XR64LIGhkWWRqT+wPBXoSEuPvYcQ2SEkohZdN5BZkHlvIyZN0Hyyfvi1jrj
         p+G9gHUsVpiqrJBdUjMWZQRD1hi8NMsQGy5SG4cdmPYui5jieHemqpamJOion2GkAXD1
         aca0j40YxzRmeFSuJ7Fbi2puJXI/Vq1zRrPwwzK9H/b9u+PkWG57iywoozeqLPfyPEcw
         t3O6IS5j0GYAUTZiF8IvtTc5tvqgd3pFprvGG5SOp2oBYpRXSDzYt/a3YGkxsViAmEKw
         BaTSYyO3q+cqY0ESHh2CDcTTKtvqbrW2yf29c/4RrOPDTrJOyCMyn3BwZnmQlGzydoDj
         JVtQ==
X-Gm-Message-State: AC+VfDzC9H6KPQY4GepCMEi4PGspMgai4gdCCMtNdAtpopQXh+QkjfVC
        494DlL3hBXn1RJbGyBhUa8wTR22CH0/gGY/7OJtKRYg/V7mp3wKBnSfUH/NEE/Y6KJWr68Y9oIV
        rz8hiGa92+2PgakkI1en2lQSCKENfKHgpLIBWRW/Wqirc0gqqWReEqgA=
X-Received: by 2002:a05:6358:e95:b0:129:cb51:7efe with SMTP id 21-20020a0563580e9500b00129cb517efemr6593619rwg.14.1686239197793;
        Thu, 08 Jun 2023 08:46:37 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5GrdwVlP788/m18FCJp3Hn8m8zO6nyX5cRUmH7sqvVSfU1RnwCMmPWmJgyf7zsTIVIlJdT0E9ti0o+vkF1GsE=
X-Received: by 2002:a05:6358:e95:b0:129:cb51:7efe with SMTP id
 21-20020a0563580e9500b00129cb517efemr6593615rwg.14.1686239197471; Thu, 08 Jun
 2023 08:46:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230607180958.645115-1-aleksandr.mikhalitsyn@canonical.com>
 <20230607180958.645115-12-aleksandr.mikhalitsyn@canonical.com> <f1e81edf-595b-3f7c-3f00-2c96718fbb69@redhat.com>
In-Reply-To: <f1e81edf-595b-3f7c-3f00-2c96718fbb69@redhat.com>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Thu, 8 Jun 2023 17:46:26 +0200
Message-ID: <CAEivzxeH1rBezS=+gMaEg4_2A9jweLgW7CCc7paaa=MRhh3VXQ@mail.gmail.com>
Subject: Re: [PATCH v4 11/14] ceph: allow idmapped setattr inode op
To:     Xiubo Li <xiubli@redhat.com>
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 8, 2023 at 4:50=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 6/8/23 02:09, Alexander Mikhalitsyn wrote:
> > From: Christian Brauner <christian.brauner@ubuntu.com>
> >
> > Enable __ceph_setattr() to handle idmapped mounts. This is just a matte=
r
> > of passing down the mount's idmapping.
> >
> > Cc: Xiubo Li <xiubli@redhat.com>
> > Cc: Jeff Layton <jlayton@kernel.org>
> > Cc: Ilya Dryomov <idryomov@gmail.com>
> > Cc: ceph-devel@vger.kernel.org
> > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > [ adapted to b27c82e12965 ("attr: port attribute changes to new types")=
 ]
> > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.c=
om>
> > ---
> > v4:
> >       - introduced fsuid/fsgid local variables
> > v3:
> >       - reworked as Christian suggested here:
> >       https://lore.kernel.org/lkml/20230602-vorzeichen-praktikum-f17931=
692301@brauner/
> > ---
> >   fs/ceph/inode.c | 20 ++++++++++++--------
> >   1 file changed, 12 insertions(+), 8 deletions(-)
> >
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index bcd9b506ec3b..ca438d1353b2 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -2052,31 +2052,35 @@ int __ceph_setattr(struct mnt_idmap *idmap, str=
uct inode *inode,
> >       dout("setattr %p issued %s\n", inode, ceph_cap_string(issued));
> >
> >       if (ia_valid & ATTR_UID) {
> > +             kuid_t fsuid =3D from_vfsuid(idmap, i_user_ns(inode), att=
r->ia_vfsuid);
> > +
> >               dout("setattr %p uid %d -> %d\n", inode,
> >                    from_kuid(&init_user_ns, inode->i_uid),
> >                    from_kuid(&init_user_ns, attr->ia_uid));
> >               if (issued & CEPH_CAP_AUTH_EXCL) {
> > -                     inode->i_uid =3D attr->ia_uid;
> > +                     inode->i_uid =3D fsuid;
> >                       dirtied |=3D CEPH_CAP_AUTH_EXCL;
> >               } else if ((issued & CEPH_CAP_AUTH_SHARED) =3D=3D 0 ||
> > -                        !uid_eq(attr->ia_uid, inode->i_uid)) {
> > +                        !uid_eq(fsuid, inode->i_uid)) {
> >                       req->r_args.setattr.uid =3D cpu_to_le32(
> > -                             from_kuid(&init_user_ns, attr->ia_uid));
> > +                             from_kuid(&init_user_ns, fsuid));
> >                       mask |=3D CEPH_SETATTR_UID;
> >                       release |=3D CEPH_CAP_AUTH_SHARED;
> >               }
> >       }
> >       if (ia_valid & ATTR_GID) {
> > +             kgid_t fsgid =3D from_vfsgid(idmap, i_user_ns(inode), att=
r->ia_vfsgid);
> > +
> >               dout("setattr %p gid %d -> %d\n", inode,
> >                    from_kgid(&init_user_ns, inode->i_gid),
> >                    from_kgid(&init_user_ns, attr->ia_gid));
> >               if (issued & CEPH_CAP_AUTH_EXCL) {
> > -                     inode->i_gid =3D attr->ia_gid;
> > +                     inode->i_gid =3D fsgid;
> >                       dirtied |=3D CEPH_CAP_AUTH_EXCL;
> >               } else if ((issued & CEPH_CAP_AUTH_SHARED) =3D=3D 0 ||
> > -                        !gid_eq(attr->ia_gid, inode->i_gid)) {
> > +                        !gid_eq(fsgid, inode->i_gid)) {
> >                       req->r_args.setattr.gid =3D cpu_to_le32(
> > -                             from_kgid(&init_user_ns, attr->ia_gid));
> > +                             from_kgid(&init_user_ns, fsgid));
> >                       mask |=3D CEPH_SETATTR_GID;
> >                       release |=3D CEPH_CAP_AUTH_SHARED;
> >               }
> > @@ -2241,7 +2245,7 @@ int ceph_setattr(struct mnt_idmap *idmap, struct =
dentry *dentry,
> >       if (ceph_inode_is_shutdown(inode))
> >               return -ESTALE;
> >
> > -     err =3D setattr_prepare(&nop_mnt_idmap, dentry, attr);
> > +     err =3D setattr_prepare(idmap, dentry, attr);
> >       if (err !=3D 0)
> >               return err;
> >
> > @@ -2256,7 +2260,7 @@ int ceph_setattr(struct mnt_idmap *idmap, struct =
dentry *dentry,
> >       err =3D __ceph_setattr(idmap, inode, attr);
> >
> >       if (err >=3D 0 && (attr->ia_valid & ATTR_MODE))
> > -             err =3D posix_acl_chmod(&nop_mnt_idmap, dentry, attr->ia_=
mode);
> > +             err =3D posix_acl_chmod(idmap, dentry, attr->ia_mode);
> >
> >       return err;
> >   }

Hi Xiubo,

>
> You should also do 'req->r_mnt_idmap =3D idmap;' for sync setattr request=
.
>
> the setattr will just cache the change locally in client side if the 'x'
> caps are issued and returns directly or will set a sync setattr reqeust.

Have done in v5:
("ceph: pass idmap to __ceph_setattr")
https://lore.kernel.org/lkml/20230608154256.562906-8-aleksandr.mikhalitsyn@=
canonical.com/

Kind regards,
Alex

>
> Thanks
>
> - Xiubo
>
