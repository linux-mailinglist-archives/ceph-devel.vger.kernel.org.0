Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E39B67264DB
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jun 2023 17:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241418AbjFGPj7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jun 2023 11:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241446AbjFGPjr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jun 2023 11:39:47 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA75F83
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 08:39:45 -0700 (PDT)
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com [209.85.219.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 07B303F0F8
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 15:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686151699;
        bh=3vCORCdIt84ymcJq2QXtA1bADojH7gUQhxriR3OVIVk=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=fTV2O95ie4FBjyNmbrA0A5gMBRf+1kHR2RR1N0J0PrLbSLmm8yzYpoxv+c7OQlZLr
         yZheKLOYWvoER47AdIqKmsu8ZeNOP9d5pSVp6HRPYcgHuqLMWR5R4/T87O/+yA0gHB
         REbyTgCwmSTHxQvdaELksQ5SmIiXHOA1As0NGSghjrxJwJgGxS8Dyz6ikJCY4R20y1
         2XNP3HTRY+CgwGmkE6zeWeNN+Ntkq/ez8h3P4sQTnkYgD1psN+2ZfHKB1/Bxz0GJOX
         EoJh46czmKD1Dv5HZbUlVh8qYlIuyTwYkBL14NzAUGLQ86MIhuQWEezezjyW91qBnD
         6GhU8RcH+xRqQ==
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-ba88ec544ddso12419342276.1
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jun 2023 08:28:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686151697; x=1688743697;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3vCORCdIt84ymcJq2QXtA1bADojH7gUQhxriR3OVIVk=;
        b=BD/vdcPGwTL3uuebaG/hanhtcYFQBagWZKr4pLNfdt/RYRELO5nLErFMARSgUghCsu
         3n1GvG9UXX8xinF274vd9FLz2nbvdNiLJnl2YzXtq1Ts5ZMGOsrsZmdUv/bDuEdmSilm
         2A2FnV2x3CqiIkQI9xXmly3E5z88nlkgrG59f1ajFj7u1AMoaYLlENYcfAVz0keVQCXu
         fvMKHs6z+PBvVjYoQ5XYQyHE80sznsI6x+BeSM5gvsIGkIxv7iKwffystzl9iB0Yszq0
         Mof+Mdgv8Qc4hpNYcLSjJzsMT06osybacOAEs+48qsBGXXLDutX4D30F5Qsl9l4ws0qU
         De5w==
X-Gm-Message-State: AC+VfDwMFEoDy3Mvl5NIFNlJjrZIsI/cCtEK9jZ0u4JZpVlnDGG0Mtxy
        w1VWKbjHIsKBE263jBFHK712IcYRzGC4R85tSoHhWVa0z0+5y+d54Ix0CjuXCKQfddBw6HSeVEB
        V+q/zYoJVmvWupBsm0K52QdeE9DQMpOD2epC9iG8+6xa9lWnRFOOCyM8=
X-Received: by 2002:a25:be05:0:b0:ba7:3b95:2d31 with SMTP id h5-20020a25be05000000b00ba73b952d31mr7526049ybk.20.1686151697708;
        Wed, 07 Jun 2023 08:28:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4I89JSFT+RB4I/6veWq35DuZPfkd05FYRdCZ7GyPx6heVJ5+e8FvkoXQqkzKGLPITkKdKZEWk9q8wFyiL2g3c=
X-Received: by 2002:a25:be05:0:b0:ba7:3b95:2d31 with SMTP id
 h5-20020a25be05000000b00ba73b952d31mr7526037ybk.20.1686151697473; Wed, 07 Jun
 2023 08:28:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230524153316.476973-1-aleksandr.mikhalitsyn@canonical.com>
 <20230524153316.476973-11-aleksandr.mikhalitsyn@canonical.com>
 <b3b1b8dc-9903-c4ff-0a63-9a31a311ff0b@redhat.com> <CAEivzxfxug8kb7_SzJGvEZMcYwGM8uW25gKa_osFqUCpF_+Lhg@mail.gmail.com>
 <20230602-vorzeichen-praktikum-f17931692301@brauner>
In-Reply-To: <20230602-vorzeichen-praktikum-f17931692301@brauner>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Wed, 7 Jun 2023 17:28:06 +0200
Message-ID: <CAEivzxfEw3RVhz717MYin91gvv4LctzGWUkDH8GJN_PjWoLgCQ@mail.gmail.com>
Subject: Re: [PATCH v2 10/13] ceph: allow idmapped setattr inode op
To:     Christian Brauner <brauner@kernel.org>
Cc:     Xiubo Li <xiubli@redhat.com>, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jun 2, 2023 at 2:54=E2=80=AFPM Christian Brauner <brauner@kernel.or=
g> wrote:
>
> On Fri, Jun 02, 2023 at 02:45:30PM +0200, Aleksandr Mikhalitsyn wrote:
> > On Fri, Jun 2, 2023 at 3:30=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wro=
te:
> > >
> > >
> > > On 5/24/23 23:33, Alexander Mikhalitsyn wrote:
> > > > From: Christian Brauner <christian.brauner@ubuntu.com>
> > > >
> > > > Enable __ceph_setattr() to handle idmapped mounts. This is just a m=
atter
> > > > of passing down the mount's idmapping.
> > > >
> > > > Cc: Jeff Layton <jlayton@kernel.org>
> > > > Cc: Ilya Dryomov <idryomov@gmail.com>
> > > > Cc: ceph-devel@vger.kernel.org
> > > > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > > > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonic=
al.com>
> > > > ---
> > > >   fs/ceph/inode.c | 11 +++++++++--
> > > >   1 file changed, 9 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > > > index 37e1cbfc7c89..f1f934439be0 100644
> > > > --- a/fs/ceph/inode.c
> > > > +++ b/fs/ceph/inode.c
> > > > @@ -2050,6 +2050,13 @@ int __ceph_setattr(struct inode *inode, stru=
ct iattr *attr)
> > > >
> > > >       dout("setattr %p issued %s\n", inode, ceph_cap_string(issued)=
);
> > > >
> > > > +     /*
> > > > +      * The attr->ia_{g,u}id members contain the target {g,u}id we=
're
>
> This is now obsolete... In earlier imlementations attr->ia_{g,u}id was
> used and contained the filesystem wide value, not the idmapped mount
> value.
>
> However, this was misleading and we changed that in commit b27c82e12965
> ("attr: port attribute changes to new types") and introduced dedicated
> new types into struct iattr->ia_vfs{g,u}id. So the you need to use
> attr->ia_vfs{g,u}id as documented in include/linux/fs.h and you need to
> transform them into filesystem wide values and then to raw values you
> send over the wire.
>
> Alex should be able to figure this out though.

Hi Christian,

Reworked in v3:
https://lore.kernel.org/lkml/20230607152038.469739-12-aleksandr.mikhalitsyn=
@canonical.com/#t

The only thing is that I've forgotten to remove the comment, but I'll
do that in v4.

Kind regards,
Alex

>
> > > > +      * sending over the wire. The mount idmapping only matters wh=
en we
> > > > +      * create new filesystem objects based on the caller's mapped
> > > > +      * fs{g,u}id.
> > > > +      */
> > > > +     req->r_mnt_idmap =3D &nop_mnt_idmap;
> > >
> > > For example with an idmapping 1000:0 and in the /mnt/idmapped_ceph/.
> > >
> > > This means the "__ceph_setattr()" will always use UID 0 to set the
> > > caller_uid, right ? If it is then the client auth checking for the
> >
> > Yes, if you have a mapping like b:1000:0:1 (the last number is a
> > length of a mapping). It means even more,
> > the only user from which you can create something on the filesystem
> > will be UID =3D 0,
> > because all other UIDs/GIDs are not mapped and you'll instantly get
> > -EOVERFLOW from the kernel.
> >
> > > setattr requests in cephfs MDS will succeed, since the UID 0 is root.
> > > But if you use a different idmapping, such as 1000:2000, it will fail=
.
> >
> > If you have a mapping b:1000:2000:1 then the only valid UID/GID from
> > which you can create something
> > on an idmapped mount will be UID/GID =3D 2000:2000 (and this will be
> > mapped to 1000:1000 and sent over the wire,
> > because we performing an idmapping procedure for requests those are
> > creating inodes).
> > So, even root with UID =3D 0 will not be able to create a file on such =
a
> > mount and get -EOVERFLOW.
> >
> > >
> > > So here IMO we should set it to 'idmap' too ?
> >
> > Good question. I can't see any obvious issue with setting an actual
> > idmapping here.
> > It will be interesting to know Christian's opinion about this.
> >
> > Kind regards,
> > Alex
> >
> > >
> > > Thanks
> > >
> > > - Xiubo
> > >
> > > >       if (ia_valid & ATTR_UID) {
> > > >               dout("setattr %p uid %d -> %d\n", inode,
> > > >                    from_kuid(&init_user_ns, inode->i_uid),
> > > > @@ -2240,7 +2247,7 @@ int ceph_setattr(struct mnt_idmap *idmap, str=
uct dentry *dentry,
> > > >       if (ceph_inode_is_shutdown(inode))
> > > >               return -ESTALE;
> > > >
> > > > -     err =3D setattr_prepare(&nop_mnt_idmap, dentry, attr);
> > > > +     err =3D setattr_prepare(idmap, dentry, attr);
> > > >       if (err !=3D 0)
> > > >               return err;
> > > >
> > > > @@ -2255,7 +2262,7 @@ int ceph_setattr(struct mnt_idmap *idmap, str=
uct dentry *dentry,
> > > >       err =3D __ceph_setattr(inode, attr);
> > > >
> > > >       if (err >=3D 0 && (attr->ia_valid & ATTR_MODE))
> > > > -             err =3D posix_acl_chmod(&nop_mnt_idmap, dentry, attr-=
>ia_mode);
> > > > +             err =3D posix_acl_chmod(idmap, dentry, attr->ia_mode)=
;
> > > >
> > > >       return err;
> > > >   }
> > >
