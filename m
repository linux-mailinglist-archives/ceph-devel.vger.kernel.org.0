Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7537D2C07
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Oct 2023 09:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjJWH6B (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Oct 2023 03:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjJWH6A (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 23 Oct 2023 03:58:00 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6141DA6
        for <ceph-devel@vger.kernel.org>; Mon, 23 Oct 2023 00:57:56 -0700 (PDT)
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com [209.85.128.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 698DB3F1D9
        for <ceph-devel@vger.kernel.org>; Mon, 23 Oct 2023 07:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1698047874;
        bh=u7GScWjArWDBsmslExt09yQ/w9U+lCmA3/2l6avmmBw=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=MjE2z6suaG8Ck5ZtMcWyQqzBg1ZKOq8eacg+5UXfqoJ0v6zlegZm4TiwkhrPS5ktr
         66pFaCuZO+mqTxxSUbKC15+/ZNAA9mHilUNf2TwRWsuWFAUvAZUdwirf1/OCD+8m53
         e90NxQJO8rJTpCtkOCqw7KNmEvP8Lv40AF91wP5/ZRtbzsqAzPYuOPRSFHUse6iWnf
         NLkc41Q76tsBOKWoonUw1EhkCtkkdINRpdkuZV8foVpaRRwWR1KuQMHaB8dkLVX23s
         vM657r7Qo/oOeYOdVHUfWCB0zX6flIhmRX83A9JzjHUCYHe10EXdP86tOj2/cC3pvY
         rGzpEhdvp3M4Q==
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-5a7b10c488cso38137207b3.2
        for <ceph-devel@vger.kernel.org>; Mon, 23 Oct 2023 00:57:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698047873; x=1698652673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u7GScWjArWDBsmslExt09yQ/w9U+lCmA3/2l6avmmBw=;
        b=PFMLqXiLSzsaH0Ah9cLAco3m/mYwLhrGeFI4RD4zfEmJNXjPy7nKYzOpltBb5biqfq
         NIgf5lIdP/13divxSEOimZ8zQcfpXJ8gGzTQYtDoSHQvdhbPHV5oxRIHukg1hkvqc1xD
         68PHbXPxZ/ko+Ep6aFtbEEZWHGkeTHxzLzHF2o5pWQrrmbqmcm4ClK9d2qIPuxilfM0C
         FgHxvmkorhfSssQULkJAbxr6a4WiNkvXvcvcBh0NZok8EcInQ1xaSoCxb8YPz+Z1ZXdj
         hb9JW5JS0P6NzmFiaRjhx9DGliCiWqCL44m7VWxlEOkjSJdqJN+cDY6Bkqv485XQDgLO
         d1cQ==
X-Gm-Message-State: AOJu0Yw1CDU7/SXWnBJSfyZflXuEjZPCzCIGBi1X6h2hDDMz+SelnL8C
        QjxY6qSpw5QMn4C4Yb7oFrPz0H28DtXtGzBSC7Me1GWw67Hg2s8c9GsPQw8TF0i/v7NQ3Kv94XC
        JWXHHok6Nl9OKA9imv4K7fJJ00sKEeA8ePE7w5TSx6KQJpH+d1om+1gY=
X-Received: by 2002:a81:a091:0:b0:5a7:d9ce:363c with SMTP id x139-20020a81a091000000b005a7d9ce363cmr7817499ywg.6.1698047873205;
        Mon, 23 Oct 2023 00:57:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHy+WSIuaqer8Tu4PIB5kMYpkbya8+N3WwyVpebn8chFwLsb/rKl1kccsuRoPtpYrp1bhd7Au/PM2ka8Xarfnc=
X-Received: by 2002:a81:a091:0:b0:5a7:d9ce:363c with SMTP id
 x139-20020a81a091000000b005a7d9ce363cmr7817492ywg.6.1698047872886; Mon, 23
 Oct 2023 00:57:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230807132626.182101-1-aleksandr.mikhalitsyn@canonical.com>
 <bcda164b-e4b7-1c16-2714-13e3c6514b47@redhat.com> <CAEivzxf-W1-q=BkG1UndFcX_AbzH-HtHX7p6j4iAwVbKnPn+sQ@mail.gmail.com>
 <772a6282-d690-b299-6cf4-c96dd20792fa@redhat.com>
In-Reply-To: <772a6282-d690-b299-6cf4-c96dd20792fa@redhat.com>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Mon, 23 Oct 2023 09:57:41 +0200
Message-ID: <CAEivzxf56EXhNToVZRNZ9HsS4NKYidXqE-89oT6L-XY=s0nPcQ@mail.gmail.com>
Subject: Re: [PATCH v10 00/12] ceph: support idmapped mounts
To:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Oct 19, 2023 at 7:42=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 10/17/23 17:20, Aleksandr Mikhalitsyn wrote:
> > On Tue, Aug 8, 2023 at 2:45=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wro=
te:
> >> LGTM.
> >>
> >> Reviewed-by: Xiubo Li <xiubli@redhat.com>
> >>
> >> I will queue this to the 'testing' branch and then we will run ceph qa
> >> tests.
> >>
> >> Thanks Alex.
> >>
> >> - Xiubo
> > Hi Xiubo,
> >
> > will this series be landed to 6.6?
> >
> > Userspace part was backported and merged to the Ceph Quincy release
> > (https://github.com/ceph/ceph/pull/53139)
> > And waiting to be tested and merged to the Ceph reef and pacific releas=
es.
> > But the kernel part is still in the testing branch.
>
> This changes have been in the 'testing' branch for more than two mounts
> and well test, till now we haven't seen any issue.
>
> IMO it should be ready.

Thanks, Xiubo!
It would be awesome to have this in v.6.6.

Kind regards,
Alex

>
> Ilya ?
>
> Thanks
>
> - Xiubo
>
>
> > Kind regards,
> > Alex
> >
> >> On 8/7/23 21:26, Alexander Mikhalitsyn wrote:
> >>> Dear friends,
> >>>
> >>> This patchset was originally developed by Christian Brauner but I'll =
continue
> >>> to push it forward. Christian allowed me to do that :)
> >>>
> >>> This feature is already actively used/tested with LXD/LXC project.
> >>>
> >>> Git tree (based on https://github.com/ceph/ceph-client.git testing):
> >>> v10: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v10
> >>> current: https://github.com/mihalicyn/linux/tree/fs.idmapped.ceph
> >>>
> >>> In the version 3 I've changed only two commits:
> >>> - fs: export mnt_idmap_get/mnt_idmap_put
> >>> - ceph: allow idmapped setattr inode op
> >>> and added a new one:
> >>> - ceph: pass idmap to __ceph_setattr
> >>>
> >>> In the version 4 I've reworked the ("ceph: stash idmapping in mdsc re=
quest")
> >>> commit. Now we take idmap refcounter just in place where req->r_mnt_i=
dmap
> >>> is filled. It's more safer approach and prevents possible refcounter =
underflow
> >>> on error paths where __register_request wasn't called but ceph_mdsc_r=
elease_request is
> >>> called.
> >>>
> >>> Changelog for version 5:
> >>> - a few commits were squashed into one (as suggested by Xiubo Li)
> >>> - started passing an idmapping everywhere (if possible), so a caller
> >>> UID/GID-s will be mapped almost everywhere (as suggested by Xiubo Li)
> >>>
> >>> Changelog for version 6:
> >>> - rebased on top of testing branch
> >>> - passed an idmapping in a few places (readdir, ceph_netfs_issue_op_i=
nline)
> >>>
> >>> Changelog for version 7:
> >>> - rebased on top of testing branch
> >>> - this thing now requires a new cephfs protocol extension CEPHFS_FEAT=
URE_HAS_OWNER_UIDGID
> >>> https://github.com/ceph/ceph/pull/52575
> >>>
> >>> Changelog for version 8:
> >>> - rebased on top of testing branch
> >>> - added enable_unsafe_idmap module parameter to make idmapped mounts
> >>> work with old MDS server versions
> >>> - properly handled case when old MDS used with new kernel client
> >>>
> >>> Changelog for version 9:
> >>> - added "struct_len" field in struct ceph_mds_request_head as request=
ed by Xiubo Li
> >>>
> >>> Changelog for version 10:
> >>> - fill struct_len field properly (use cpu_to_le32)
> >>> - add extra checks IS_CEPH_MDS_OP_NEWINODE(..) as requested by Xiubo =
to match
> >>>     userspace client behavior
> >>> - do not set req->r_mnt_idmap for MKSNAP operation
> >>> - atomic_open: set req->r_mnt_idmap only for CEPH_MDS_OP_CREATE as us=
erspace client does
> >>>
> >>> I can confirm that this version passes xfstests and
> >>> tested with old MDS (without CEPHFS_FEATURE_HAS_OWNER_UIDGID)
> >>> and with recent MDS version.
> >>>
> >>> Links to previous versions:
> >>> v1: https://lore.kernel.org/all/20220104140414.155198-1-brauner@kerne=
l.org/
> >>> v2: https://lore.kernel.org/lkml/20230524153316.476973-1-aleksandr.mi=
khalitsyn@canonical.com/
> >>> tree: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v2
> >>> v3: https://lore.kernel.org/lkml/20230607152038.469739-1-aleksandr.mi=
khalitsyn@canonical.com/#t
> >>> v4: https://lore.kernel.org/lkml/20230607180958.645115-1-aleksandr.mi=
khalitsyn@canonical.com/#t
> >>> tree: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v4
> >>> v5: https://lore.kernel.org/lkml/20230608154256.562906-1-aleksandr.mi=
khalitsyn@canonical.com/#t
> >>> tree: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v5
> >>> v6: https://lore.kernel.org/lkml/20230609093125.252186-1-aleksandr.mi=
khalitsyn@canonical.com/
> >>> tree: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v6
> >>> v7: https://lore.kernel.org/all/20230726141026.307690-1-aleksandr.mik=
halitsyn@canonical.com/
> >>> tree: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v7
> >>> v8: https://lore.kernel.org/all/20230803135955.230449-1-aleksandr.mik=
halitsyn@canonical.com/
> >>> tree: -
> >>> v9: https://lore.kernel.org/all/20230804084858.126104-1-aleksandr.mik=
halitsyn@canonical.com/
> >>> tree: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v9
> >>>
> >>> Kind regards,
> >>> Alex
> >>>
> >>> Original description from Christian:
> >>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>> This patch series enables cephfs to support idmapped mounts, i.e. the
> >>> ability to alter ownership information on a per-mount basis.
> >>>
> >>> Container managers such as LXD support sharaing data via cephfs betwe=
en
> >>> the host and unprivileged containers and between unprivileged contain=
ers.
> >>> They may all use different idmappings. Idmapped mounts can be used to
> >>> create mounts with the idmapping used for the container (or a differe=
nt
> >>> one specific to the use-case).
> >>>
> >>> There are in fact more use-cases such as remapping ownership for
> >>> mountpoints on the host itself to grant or restrict access to differe=
nt
> >>> users or to make it possible to enforce that programs running as root
> >>> will write with a non-zero {g,u}id to disk.
> >>>
> >>> The patch series is simple overall and few changes are needed to ceph=
fs.
> >>> There is one cephfs specific issue that I would like to discuss and
> >>> solve which I explain in detail in:
> >>>
> >>> [PATCH 02/12] ceph: handle idmapped mounts in create_request_message(=
)
> >>>
> >>> It has to do with how to handle mds serves which have id-based access
> >>> restrictions configured. I would ask you to please take a look at the
> >>> explanation in the aforementioned patch.
> >>>
> >>> The patch series passes the vfs and idmapped mount testsuite as part =
of
> >>> xfstests. To run it you will need a config like:
> >>>
> >>> [ceph]
> >>> export FSTYP=3Dceph
> >>> export TEST_DIR=3D/mnt/test
> >>> export TEST_DEV=3D10.103.182.10:6789:/
> >>> export TEST_FS_MOUNT_OPTS=3D"-o name=3Dadmin,secret=3D$password
> >>>
> >>> and then simply call
> >>>
> >>> sudo ./check -g idmapped
> >>>
> >>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>
> >>> Alexander Mikhalitsyn (3):
> >>>     fs: export mnt_idmap_get/mnt_idmap_put
> >>>     ceph: add enable_unsafe_idmap module parameter
> >>>     ceph: pass idmap to __ceph_setattr
> >>>
> >>> Christian Brauner (9):
> >>>     ceph: stash idmapping in mdsc request
> >>>     ceph: handle idmapped mounts in create_request_message()
> >>>     ceph: pass an idmapping to mknod/symlink/mkdir
> >>>     ceph: allow idmapped getattr inode op
> >>>     ceph: allow idmapped permission inode op
> >>>     ceph: allow idmapped setattr inode op
> >>>     ceph/acl: allow idmapped set_acl inode op
> >>>     ceph/file: allow idmapped atomic_open inode op
> >>>     ceph: allow idmapped mounts
> >>>
> >>>    fs/ceph/acl.c                 |  6 +--
> >>>    fs/ceph/crypto.c              |  2 +-
> >>>    fs/ceph/dir.c                 |  4 ++
> >>>    fs/ceph/file.c                | 11 ++++-
> >>>    fs/ceph/inode.c               | 29 +++++++------
> >>>    fs/ceph/mds_client.c          | 78 +++++++++++++++++++++++++++++++=
+---
> >>>    fs/ceph/mds_client.h          |  8 +++-
> >>>    fs/ceph/super.c               |  7 +++-
> >>>    fs/ceph/super.h               |  3 +-
> >>>    fs/mnt_idmapping.c            |  2 +
> >>>    include/linux/ceph/ceph_fs.h  | 10 ++++-
> >>>    include/linux/mnt_idmapping.h |  3 ++
> >>>    12 files changed, 136 insertions(+), 27 deletions(-)
> >>>
>
