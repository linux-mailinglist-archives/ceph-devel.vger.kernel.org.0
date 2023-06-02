Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAF1B720256
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Jun 2023 14:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235505AbjFBMps (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Jun 2023 08:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234838AbjFBMpq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 2 Jun 2023 08:45:46 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BE218C
        for <ceph-devel@vger.kernel.org>; Fri,  2 Jun 2023 05:45:44 -0700 (PDT)
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com [209.85.219.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 02A913F452
        for <ceph-devel@vger.kernel.org>; Fri,  2 Jun 2023 12:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1685709943;
        bh=SHjOS/J061yQJTzZU+cxSPwgYSjIwGvtX1NuAJnfTCg=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=IYvdjFBEEJkMOmoQPRliKkcFRsD6HDRfkwAaFwRGc1F20tl4Og4qNPiqdZSTBLzua
         /LsrmwZP49Usem72w7BHkQe498is5LwFt3Bd5eFyoftln1+gZqEvmaLef3OdbaoNVs
         lthc9UjQ44NMBmgbMzR3yKKTke85/zElloB5wMbKckgBlo/xBdrWPf7GY81F9loRrD
         0p4otQ/q2Xk97xcseEVONHlMKN0ABkBmbD+HvOBCD5OmPZQrMcTxqUX2UF4MmeKiRJ
         pPUq7S2WLKzrFl1Zaa4SeM/RdDrQEVwJ/AQJPRksZtYtqsgNyaLtDTDb5xKbv4bavg
         WoK3i4XpCLOVg==
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-babb5e91ab4so2986945276.0
        for <ceph-devel@vger.kernel.org>; Fri, 02 Jun 2023 05:45:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685709942; x=1688301942;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SHjOS/J061yQJTzZU+cxSPwgYSjIwGvtX1NuAJnfTCg=;
        b=GemdtqRJCsM7pUxl9GWOPEiM+rK7xqQzNxh4p+nXhEWUrbz+SVhMKW/LCO9att0DEf
         XohyorisUDkII6OxiIaIUT1kKE/3gne09ttJn6x++JbBKqA1g55pQDdNp43+ZgU/0cLp
         G4u1Ku6KKCyKGu4b2mNa+T8CyQqSC8l4vxY69/sgDrlcrhzyfxrCUP0aEvUSzGKjr9Ug
         GVi6yKPO+sTDKpLvwLqMZGXuUr/ajtgT7u7/tyTosI04Rx+MNAwCO028gTMaA6oRcOTl
         6wecGXm6sZRujqP9oHIKrYpnvP5XOJK81hoRIIgHnlh+tt/yqE7nwf2ds/iGQtz7dTLQ
         kbmA==
X-Gm-Message-State: AC+VfDy4VgVuUx0dpSa29iL3hBkJ0LPBdPobLaK1qrw3mWf0y5E6lDUj
        8x/4Hs7HgNpbuwm47lk8+I/u9XQKy44Fj9nYo9hVH4DBjyOV0FyNelmiuQOlWPC6qUYdWQbUTRu
        T8kKrRSSNscO2cPvIo6fByAEb5BNUZl9ZIfWUKaNOyXZtoPHkiZNmUS1wEZztxP0=
X-Received: by 2002:a25:d86:0:b0:ba8:66fb:dd84 with SMTP id 128-20020a250d86000000b00ba866fbdd84mr2876024ybn.20.1685709941830;
        Fri, 02 Jun 2023 05:45:41 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4Z2aK7/igryc1eEq7RaqbasDJvZE9BEB9aO4U6m56bLaF2OezxmktZBcW3d2LxjwGRYwgcHVGORYgpmunmLnc=
X-Received: by 2002:a25:d86:0:b0:ba8:66fb:dd84 with SMTP id
 128-20020a250d86000000b00ba866fbdd84mr2876008ybn.20.1685709941578; Fri, 02
 Jun 2023 05:45:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230524153316.476973-1-aleksandr.mikhalitsyn@canonical.com>
 <20230524153316.476973-11-aleksandr.mikhalitsyn@canonical.com> <b3b1b8dc-9903-c4ff-0a63-9a31a311ff0b@redhat.com>
In-Reply-To: <b3b1b8dc-9903-c4ff-0a63-9a31a311ff0b@redhat.com>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Fri, 2 Jun 2023 14:45:30 +0200
Message-ID: <CAEivzxfxug8kb7_SzJGvEZMcYwGM8uW25gKa_osFqUCpF_+Lhg@mail.gmail.com>
Subject: Re: [PATCH v2 10/13] ceph: allow idmapped setattr inode op
To:     Xiubo Li <xiubli@redhat.com>
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jun 2, 2023 at 3:30=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 5/24/23 23:33, Alexander Mikhalitsyn wrote:
> > From: Christian Brauner <christian.brauner@ubuntu.com>
> >
> > Enable __ceph_setattr() to handle idmapped mounts. This is just a matte=
r
> > of passing down the mount's idmapping.
> >
> > Cc: Jeff Layton <jlayton@kernel.org>
> > Cc: Ilya Dryomov <idryomov@gmail.com>
> > Cc: ceph-devel@vger.kernel.org
> > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.c=
om>
> > ---
> >   fs/ceph/inode.c | 11 +++++++++--
> >   1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index 37e1cbfc7c89..f1f934439be0 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -2050,6 +2050,13 @@ int __ceph_setattr(struct inode *inode, struct i=
attr *attr)
> >
> >       dout("setattr %p issued %s\n", inode, ceph_cap_string(issued));
> >
> > +     /*
> > +      * The attr->ia_{g,u}id members contain the target {g,u}id we're
> > +      * sending over the wire. The mount idmapping only matters when w=
e
> > +      * create new filesystem objects based on the caller's mapped
> > +      * fs{g,u}id.
> > +      */
> > +     req->r_mnt_idmap =3D &nop_mnt_idmap;
>
> For example with an idmapping 1000:0 and in the /mnt/idmapped_ceph/.
>
> This means the "__ceph_setattr()" will always use UID 0 to set the
> caller_uid, right ? If it is then the client auth checking for the

Yes, if you have a mapping like b:1000:0:1 (the last number is a
length of a mapping). It means even more,
the only user from which you can create something on the filesystem
will be UID =3D 0,
because all other UIDs/GIDs are not mapped and you'll instantly get
-EOVERFLOW from the kernel.

> setattr requests in cephfs MDS will succeed, since the UID 0 is root.
> But if you use a different idmapping, such as 1000:2000, it will fail.

If you have a mapping b:1000:2000:1 then the only valid UID/GID from
which you can create something
on an idmapped mount will be UID/GID =3D 2000:2000 (and this will be
mapped to 1000:1000 and sent over the wire,
because we performing an idmapping procedure for requests those are
creating inodes).
So, even root with UID =3D 0 will not be able to create a file on such a
mount and get -EOVERFLOW.

>
> So here IMO we should set it to 'idmap' too ?

Good question. I can't see any obvious issue with setting an actual
idmapping here.
It will be interesting to know Christian's opinion about this.

Kind regards,
Alex

>
> Thanks
>
> - Xiubo
>
> >       if (ia_valid & ATTR_UID) {
> >               dout("setattr %p uid %d -> %d\n", inode,
> >                    from_kuid(&init_user_ns, inode->i_uid),
> > @@ -2240,7 +2247,7 @@ int ceph_setattr(struct mnt_idmap *idmap, struct =
dentry *dentry,
> >       if (ceph_inode_is_shutdown(inode))
> >               return -ESTALE;
> >
> > -     err =3D setattr_prepare(&nop_mnt_idmap, dentry, attr);
> > +     err =3D setattr_prepare(idmap, dentry, attr);
> >       if (err !=3D 0)
> >               return err;
> >
> > @@ -2255,7 +2262,7 @@ int ceph_setattr(struct mnt_idmap *idmap, struct =
dentry *dentry,
> >       err =3D __ceph_setattr(inode, attr);
> >
> >       if (err >=3D 0 && (attr->ia_valid & ATTR_MODE))
> > -             err =3D posix_acl_chmod(&nop_mnt_idmap, dentry, attr->ia_=
mode);
> > +             err =3D posix_acl_chmod(idmap, dentry, attr->ia_mode);
> >
> >       return err;
> >   }
>
