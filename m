Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52E272646C
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jun 2023 17:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241471AbjFGP02 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jun 2023 11:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241452AbjFGP0J (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jun 2023 11:26:09 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C608926A6
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 08:25:37 -0700 (PDT)
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com [209.85.219.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 288E83F120
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 15:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686151503;
        bh=UzyjLDSH3L83BUY14PzO6igurevkkcTAFURgUF3tbLc=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=fkxgZqGqHW+pi559AF3RM4Xqo4MsornXTpBlfpZWzdOkVpji690KH2eNnHJKhWqXG
         6YMLQL4kY17Z964171EX+fLDe4qQ698rjANTla1OczbOaih3FzPh5KKKSGcT//Of9j
         QE5eR8NxSCRyqO5KzqOCzxi9Jn87IO+W2nytRWmHlG0y0b/YOCZuxvy9Q0MjzEpv1Z
         7iydsKfc8H77R8pDGekPYyxeGiwzFrofPw26xuu2OYOH5IZIt1j2r34q/88GUdOd+3
         uGPwe8o+/tEY7YOmn5F63g4TxKo+6I971SZIRWCjZv6TTGXsno/ucxV6F2qr2665r3
         4mFX7wOOfWpkQ==
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-babb79a17b8so8896401276.0
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jun 2023 08:25:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686151502; x=1688743502;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UzyjLDSH3L83BUY14PzO6igurevkkcTAFURgUF3tbLc=;
        b=NUzeXiZFz33SDZVfo2Lium7Y41O5vX+m8B9qdBNsfZap7j7qJ9JYPKAB+Y0FyGy1K8
         4PZ6kjC3hq1agN+6HWxTgbd58I8mRj59eKZFLnK34f9w1NtLJ+pr+BUnGBGWXRfXjHM+
         1Fo8eHCaXaB2fQAyNhjBYHHjr+r+IT51+mGqG4gHGdSdrOXr05k/jHPIlMa4ebD2StfA
         PglkCgVH87S/Rew6OZPQcHdcLGPvSB8a+4xMF6oRD/kzvWVd3eBFkKn3PGVkoe2dBO+a
         LuLvp/ij3Z7aCo12B4KI6MKhyC/7krGMw8CuKqNN/M7IntNjFOxY9ULF7eQCx2EdTHqN
         P5bQ==
X-Gm-Message-State: AC+VfDykd8q5jomOctduPixhWPzFh/OuaDOYE/I18n6EE4YCUBS/b3b4
        OmPkH6+D2COJqfIX4oZwNh6+CCIF97oraB3d1XW2vfdiaA+YfPIBcozcTJ8jB0tf3/FbAzVZ8Ps
        wkjOfLiKNw5cGkGBW35nWzYdwqtmaLfZCIabdvMPiWdDUrMEUb09PEWM=
X-Received: by 2002:a25:d490:0:b0:bb3:cc80:ac4a with SMTP id m138-20020a25d490000000b00bb3cc80ac4amr4129208ybf.42.1686151502106;
        Wed, 07 Jun 2023 08:25:02 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6IXvmlrtEA8JFTZYK+1pTV1djV0J8QwczyxESJ1HLlJOoHkSD4NIuDqcp3jr364rEsXU+wd6zZScC8KyQRz8w=
X-Received: by 2002:a25:d490:0:b0:bb3:cc80:ac4a with SMTP id
 m138-20020a25d490000000b00bb3cc80ac4amr4129185ybf.42.1686151501851; Wed, 07
 Jun 2023 08:25:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230524153316.476973-1-aleksandr.mikhalitsyn@canonical.com>
In-Reply-To: <20230524153316.476973-1-aleksandr.mikhalitsyn@canonical.com>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Wed, 7 Jun 2023 17:24:50 +0200
Message-ID: <CAEivzxejMtctdEF2BHMBM5fU-5-Ps7Qt25_yLBTzDayUVNoErg@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] ceph: support idmapped mounts
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
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

version 3 was sent
https://lore.kernel.org/lkml/20230607152038.469739-1-aleksandr.mikhalitsyn@=
canonical.com/

On Wed, May 24, 2023 at 5:33=E2=80=AFPM Alexander Mikhalitsyn
<aleksandr.mikhalitsyn@canonical.com> wrote:
>
> Dear friends,
>
> This patchset was originally developed by Christian Brauner but I'll cont=
inue
> to push it forward. Christian allowed me to do that :)
>
> This feature is already actively used/tested with LXD/LXC project.
>
> v2 is just a rebased version of the original series with some small field=
 naming change.
>
> Git tree (based on https://github.com/ceph/ceph-client.git master):
> https://github.com/mihalicyn/linux/tree/fs.idmapped.ceph.v2
>
> Original description from Christian:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> This patch series enables cephfs to support idmapped mounts, i.e. the
> ability to alter ownership information on a per-mount basis.
>
> Container managers such as LXD support sharaing data via cephfs between
> the host and unprivileged containers and between unprivileged containers.
> They may all use different idmappings. Idmapped mounts can be used to
> create mounts with the idmapping used for the container (or a different
> one specific to the use-case).
>
> There are in fact more use-cases such as remapping ownership for
> mountpoints on the host itself to grant or restrict access to different
> users or to make it possible to enforce that programs running as root
> will write with a non-zero {g,u}id to disk.
>
> The patch series is simple overall and few changes are needed to cephfs.
> There is one cephfs specific issue that I would like to discuss and
> solve which I explain in detail in:
>
> [PATCH 02/12] ceph: handle idmapped mounts in create_request_message()
>
> It has to do with how to handle mds serves which have id-based access
> restrictions configured. I would ask you to please take a look at the
> explanation in the aforementioned patch.
>
> The patch series passes the vfs and idmapped mount testsuite as part of
> xfstests. To run it you will need a config like:
>
> [ceph]
> export FSTYP=3Dceph
> export TEST_DIR=3D/mnt/test
> export TEST_DEV=3D10.103.182.10:6789:/
> export TEST_FS_MOUNT_OPTS=3D"-o name=3Dadmin,secret=3D$password
>
> and then simply call
>
> sudo ./check -g idmapped
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Alexander Mikhalitsyn (1):
>   fs: export mnt_idmap_get/mnt_idmap_put
>
> Christian Brauner (12):
>   ceph: stash idmapping in mdsc request
>   ceph: handle idmapped mounts in create_request_message()
>   ceph: allow idmapped mknod inode op
>   ceph: allow idmapped symlink inode op
>   ceph: allow idmapped mkdir inode op
>   ceph: allow idmapped rename inode op
>   ceph: allow idmapped getattr inode op
>   ceph: allow idmapped permission inode op
>   ceph: allow idmapped setattr inode op
>   ceph/acl: allow idmapped set_acl inode op
>   ceph/file: allow idmapped atomic_open inode op
>   ceph: allow idmapped mounts
>
>  fs/ceph/acl.c                 |  2 +-
>  fs/ceph/dir.c                 |  4 ++++
>  fs/ceph/file.c                | 10 ++++++++--
>  fs/ceph/inode.c               | 15 +++++++++++----
>  fs/ceph/mds_client.c          | 29 +++++++++++++++++++++++++----
>  fs/ceph/mds_client.h          |  1 +
>  fs/ceph/super.c               |  2 +-
>  fs/mnt_idmapping.c            |  2 ++
>  include/linux/mnt_idmapping.h |  3 +++
>  9 files changed, 56 insertions(+), 12 deletions(-)
>
> --
> 2.34.1
>
