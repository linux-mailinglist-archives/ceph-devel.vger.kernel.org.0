Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC8172DD4C
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 11:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbjFMJIJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 05:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241328AbjFMJHo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 05:07:44 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A94D1A5
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 02:07:43 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-9745baf7c13so777278366b.1
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 02:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686647262; x=1689239262;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FyABjBwPkpj8DHWFyGJzKQwcJFyfeDPVWLJtzBuwlMo=;
        b=HH96DBC+2mYP1QakDiKtVU+xNhd3HoWs5Bw5/S3kW066xDqwt07GXsNumEwRPCfGU1
         1bLFamhHjrmg8dSk+6lnwLlwp43BI6g2DiNxBg5QvhX1DqI9tvizJLQIKxAd8Por0GiL
         mSwH4U7kq/vj9aEuSN010grl6uC84ilzQSzigrizsiwwy1f0wqnW2GKd9TK5XcEYVrP+
         OGh2jYrmB4Cgc941X78VG2zj6LR3RCDe3EB+iiqiCBnS6TAEbS6R0N2jIZ2eNlCJf6GV
         ZyjfU4ExJc1UWVRUlXEwlU5xfOQQt3Y3LK9WvTGYBdvnj++rUeQvtdATBhRvMVzb2Ybc
         7/Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686647262; x=1689239262;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FyABjBwPkpj8DHWFyGJzKQwcJFyfeDPVWLJtzBuwlMo=;
        b=E0oupA+4O1deTMEmz5zJnMox1W1L3nGJqblpQTN8KjpSZD1FIlmI8PzbTlJVRyW//k
         FqCpNDmmPbh2C+Q0McjBEbtaOPNPCL5I4xyoD82k+aDuaDcBf+LwVXhN5pDc821fPUoe
         zZn1aoT4oQ/rU6/oxNViqxRLhGgazmsaUIHVdEgSWU9fkycWXl5Ab7HP4wWtNscQgyLH
         7gZRfQ6OW+iG3OMMNqXg0ys1r+HI2JlxythfW6/lNlbg5TLV8R4lZ9crnlItj/QQZOGn
         zzQjKFvaCLyrBwFS12jeNIHYfK8NaEcyzPyTqQjLXtVW5rE/gifYbjQyr67k0PGtMFfB
         zMgw==
X-Gm-Message-State: AC+VfDxXQQOZ5P+o2De72EgVfaeEwpWUwvA8YbdbmO6vfnYSQf+lGu6d
        NANQZZ9sSDH3LkNVUMg/T/ab7zItoTgfCE1c973r/9wjcq0=
X-Google-Smtp-Source: ACHHUZ62L3AT9QeA9IegJSG6EEb1yQ1CTWp3HNdOfjuqAyyaL146tWx7Ys1GGL/y/QkJ5/QsTkHz3Z4gTn8QJPd/SL0=
X-Received: by 2002:a17:907:2d8f:b0:959:5407:3e65 with SMTP id
 gt15-20020a1709072d8f00b0095954073e65mr14351453ejc.55.1686647261688; Tue, 13
 Jun 2023 02:07:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230612114359.220895-1-xiubli@redhat.com> <20230612114359.220895-7-xiubli@redhat.com>
In-Reply-To: <20230612114359.220895-7-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 13 Jun 2023 11:07:27 +0200
Message-ID: <CAOi1vP-ffbAqdRWi5pNButrdmxJzzRyNZOTTixhEtaSSUTC4qA@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] ceph: print the client global_id in all the debug logs
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, khiremat@redhat.com, mchangir@redhat.com,
        pdonnell@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 12, 2023 at 1:46=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> Multiple cephfs mounts on a host is increasingly common so disambiguating
> messages like this is necessary and will make it easier to debug
> issues.
>
> URL: https://tracker.ceph.com/issues/61590
> Cc: Patrick Donnelly <pdonnell@redhat.com>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/acl.c        |   6 +-
>  fs/ceph/addr.c       | 300 ++++++++++--------
>  fs/ceph/caps.c       | 709 ++++++++++++++++++++++++-------------------
>  fs/ceph/crypto.c     |  45 ++-
>  fs/ceph/debugfs.c    |   4 +-
>  fs/ceph/dir.c        | 222 +++++++++-----
>  fs/ceph/export.c     |  39 ++-
>  fs/ceph/file.c       | 268 +++++++++-------
>  fs/ceph/inode.c      | 528 ++++++++++++++++++--------------
>  fs/ceph/ioctl.c      |  10 +-
>  fs/ceph/locks.c      |  62 ++--
>  fs/ceph/mds_client.c | 616 +++++++++++++++++++++----------------
>  fs/ceph/mdsmap.c     |  25 +-
>  fs/ceph/metric.c     |   5 +-
>  fs/ceph/quota.c      |  31 +-
>  fs/ceph/snap.c       | 186 +++++++-----
>  fs/ceph/super.c      |  64 ++--
>  fs/ceph/xattr.c      |  97 +++---
>  18 files changed, 1887 insertions(+), 1330 deletions(-)
>
> diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
> index 8a56f979c7cb..970acd07908d 100644
> --- a/fs/ceph/acl.c
> +++ b/fs/ceph/acl.c
> @@ -15,6 +15,7 @@
>  #include <linux/slab.h>
>
>  #include "super.h"
> +#include "mds_client.h"
>
>  static inline void ceph_set_cached_acl(struct inode *inode,
>                                         int type, struct posix_acl *acl)
> @@ -31,6 +32,7 @@ static inline void ceph_set_cached_acl(struct inode *in=
ode,
>
>  struct posix_acl *ceph_get_acl(struct inode *inode, int type, bool rcu)
>  {
> +       struct ceph_client *cl =3D ceph_inode_to_client(inode);
>         int size;
>         unsigned int retry_cnt =3D 0;
>         const char *name;
> @@ -72,8 +74,8 @@ struct posix_acl *ceph_get_acl(struct inode *inode, int=
 type, bool rcu)
>         } else if (size =3D=3D -ENODATA || size =3D=3D 0) {
>                 acl =3D NULL;
>         } else {
> -               pr_err_ratelimited("get acl %llx.%llx failed, err=3D%d\n"=
,
> -                                  ceph_vinop(inode), size);
> +               pr_err_ratelimited_client(cl, "%s %llx.%llx failed, err=
=3D%d\n",
> +                                         __func__, ceph_vinop(inode), si=
ze);
>                 acl =3D ERR_PTR(-EIO);
>         }
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index e62318b3e13d..c772639dc0cb 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -79,18 +79,18 @@ static inline struct ceph_snap_context *page_snap_con=
text(struct page *page)
>   */
>  static bool ceph_dirty_folio(struct address_space *mapping, struct folio=
 *folio)
>  {
> -       struct inode *inode;
> +       struct inode *inode =3D mapping->host;
> +       struct ceph_client *cl =3D ceph_inode_to_client(inode);
>         struct ceph_inode_info *ci;
>         struct ceph_snap_context *snapc;
>
>         if (folio_test_dirty(folio)) {
> -               dout("%p dirty_folio %p idx %lu -- already dirty\n",
> -                    mapping->host, folio, folio->index);
> +               dout_client(cl, "%s %llx.%llx %p idx %lu -- already dirty=
\n",
> +                           __func__, ceph_vinop(inode), folio, folio->in=
dex);

While having context information attached to each dout is nice, it
certainly comes at a price of a lot of churn and automated backport
disruption.  I wonder how much value doing this for douts as opposed
to just pr_* messages actually brings?

A regular user never sees douts as enabling them without extra care
tends to be useless -- journald can't cope with the volume and quickly
starts discarding them.  From the developer side, many douts already
include at least one (hashed) pointer value which is usually sufficient
to disambiguate, even if it's more cumbersome than a grep on context
information.

Thanks,

                Ilya
