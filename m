Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF07F72EE45
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 23:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbjFMVuq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 17:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbjFMVup (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 17:50:45 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1331BC7
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 14:50:43 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-51878dca79fso1748485a12.1
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 14:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686693042; x=1689285042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u5i7JCFGQun0/12ejakcS8GlLVaxXCCYoVZwbm7luZ4=;
        b=q0z12KmxHYF0RXuB9+SSheJHIR1gbPdFkzAv0NQd3s+4K7vBO5B+DdCRTqwUxugpEu
         Y2gH2m7j3xYCtdTie446PMgs4oRqX7deiAXT1wUoZe1TYgcSsgTNJupCB4gx6wiH+AFG
         3c7GOby4U4Hmu2qz2YPK9Bdi0qzKGMdGtKPstjSGl+uk1mH5J7KTo1bYREMKfflPAuPg
         mWeqSSE2UO6dnRypuxGbeYUGqTCeglzaBRGbI28hc603ciiuRwf0+6V7f4bYUr24tLDz
         92iqPJNVL9rA0JAKFxteDBbHSWni5vJ614fIpseTkQxs2eHxdin1rbuoKxBTgp+63vPc
         nzzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686693042; x=1689285042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u5i7JCFGQun0/12ejakcS8GlLVaxXCCYoVZwbm7luZ4=;
        b=VBTMiuXdnsfMgMuzXPszi6j3pLofgXjCQFq5yTCFOfD8xw2MtZkaLRwRrh4wFd08iC
         5O30S9i0Ih1fDZD4fg0EudClhfj6d/1MgT+Xfo9IldCE9vSKTZwRr0/ERuzdzwUWVr+L
         qhb46UbyL61XloCb/pr9mhpuD74ZD45nO1/serzwaw+8Q0P9+2D+aHFnhUrDQe1BLs5g
         pMqx60WY4uKbfXN4BShAMTfH7bPBN7UJaTK9NZyTy85zI/Nw1qfr/QMvfTOu7TTxzRDu
         KKt5modbBIXDlGxp8XMQwiQYyorlpNxz6tMgp+fRAC4NiX6SvedMU8vZN7gn0rV0m1mq
         /Zqg==
X-Gm-Message-State: AC+VfDw0Ng9fzncinUjCFhxB3J2uo3putv1r4tpEm0g8ULhe8UFeWq7j
        lG0ekP9V5Bu51lQTvGkm3Mz/0O8DvT52n2iafN7KicE7qrg=
X-Google-Smtp-Source: ACHHUZ7ykS+NV65IIP/yw+Tc6fuLYbTQUGj1tl4BXnKu6FT6nqdq0jPzrjPslSlAKa8kqy2ClxBDBaSKkdJEGtg7Z5I=
X-Received: by 2002:a17:907:6d9e:b0:97e:a917:e6a5 with SMTP id
 sb30-20020a1709076d9e00b0097ea917e6a5mr11193124ejc.19.1686693042063; Tue, 13
 Jun 2023 14:50:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230612114359.220895-1-xiubli@redhat.com> <20230612114359.220895-7-xiubli@redhat.com>
 <CAOi1vP-ffbAqdRWi5pNButrdmxJzzRyNZOTTixhEtaSSUTC4qA@mail.gmail.com> <de1a2706-5e9a-678f-4c9a-1f1856fb7b4e@redhat.com>
In-Reply-To: <de1a2706-5e9a-678f-4c9a-1f1856fb7b4e@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 13 Jun 2023 23:50:30 +0200
Message-ID: <CAOi1vP-xoNH7+oo1Rv8i5RGcyhrR8VEM2OBs9hDf-sxTgYhaeQ@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] ceph: print the client global_id in all the debug logs
To:     Xiubo Li <xiubli@redhat.com>
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

On Tue, Jun 13, 2023 at 11:51=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote=
:
>
>
> On 6/13/23 17:07, Ilya Dryomov wrote:
> > On Mon, Jun 12, 2023 at 1:46=E2=80=AFPM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> Multiple cephfs mounts on a host is increasingly common so disambiguat=
ing
> >> messages like this is necessary and will make it easier to debug
> >> issues.
> >>
> >> URL: https://tracker.ceph.com/issues/61590
> >> Cc: Patrick Donnelly <pdonnell@redhat.com>
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>   fs/ceph/acl.c        |   6 +-
> >>   fs/ceph/addr.c       | 300 ++++++++++--------
> >>   fs/ceph/caps.c       | 709 ++++++++++++++++++++++++-----------------=
--
> >>   fs/ceph/crypto.c     |  45 ++-
> >>   fs/ceph/debugfs.c    |   4 +-
> >>   fs/ceph/dir.c        | 222 +++++++++-----
> >>   fs/ceph/export.c     |  39 ++-
> >>   fs/ceph/file.c       | 268 +++++++++-------
> >>   fs/ceph/inode.c      | 528 ++++++++++++++++++--------------
> >>   fs/ceph/ioctl.c      |  10 +-
> >>   fs/ceph/locks.c      |  62 ++--
> >>   fs/ceph/mds_client.c | 616 +++++++++++++++++++++----------------
> >>   fs/ceph/mdsmap.c     |  25 +-
> >>   fs/ceph/metric.c     |   5 +-
> >>   fs/ceph/quota.c      |  31 +-
> >>   fs/ceph/snap.c       | 186 +++++++-----
> >>   fs/ceph/super.c      |  64 ++--
> >>   fs/ceph/xattr.c      |  97 +++---
> >>   18 files changed, 1887 insertions(+), 1330 deletions(-)
> >>
> >> diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
> >> index 8a56f979c7cb..970acd07908d 100644
> >> --- a/fs/ceph/acl.c
> >> +++ b/fs/ceph/acl.c
> >> @@ -15,6 +15,7 @@
> >>   #include <linux/slab.h>
> >>
> >>   #include "super.h"
> >> +#include "mds_client.h"
> >>
> >>   static inline void ceph_set_cached_acl(struct inode *inode,
> >>                                          int type, struct posix_acl *a=
cl)
> >> @@ -31,6 +32,7 @@ static inline void ceph_set_cached_acl(struct inode =
*inode,
> >>
> >>   struct posix_acl *ceph_get_acl(struct inode *inode, int type, bool r=
cu)
> >>   {
> >> +       struct ceph_client *cl =3D ceph_inode_to_client(inode);
> >>          int size;
> >>          unsigned int retry_cnt =3D 0;
> >>          const char *name;
> >> @@ -72,8 +74,8 @@ struct posix_acl *ceph_get_acl(struct inode *inode, =
int type, bool rcu)
> >>          } else if (size =3D=3D -ENODATA || size =3D=3D 0) {
> >>                  acl =3D NULL;
> >>          } else {
> >> -               pr_err_ratelimited("get acl %llx.%llx failed, err=3D%d=
\n",
> >> -                                  ceph_vinop(inode), size);
> >> +               pr_err_ratelimited_client(cl, "%s %llx.%llx failed, er=
r=3D%d\n",
> >> +                                         __func__, ceph_vinop(inode),=
 size);
> >>                  acl =3D ERR_PTR(-EIO);
> >>          }
> >>
> >> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> >> index e62318b3e13d..c772639dc0cb 100644
> >> --- a/fs/ceph/addr.c
> >> +++ b/fs/ceph/addr.c
> >> @@ -79,18 +79,18 @@ static inline struct ceph_snap_context *page_snap_=
context(struct page *page)
> >>    */
> >>   static bool ceph_dirty_folio(struct address_space *mapping, struct f=
olio *folio)
> >>   {
> >> -       struct inode *inode;
> >> +       struct inode *inode =3D mapping->host;
> >> +       struct ceph_client *cl =3D ceph_inode_to_client(inode);
> >>          struct ceph_inode_info *ci;
> >>          struct ceph_snap_context *snapc;
> >>
> >>          if (folio_test_dirty(folio)) {
> >> -               dout("%p dirty_folio %p idx %lu -- already dirty\n",
> >> -                    mapping->host, folio, folio->index);
> >> +               dout_client(cl, "%s %llx.%llx %p idx %lu -- already di=
rty\n",
> >> +                           __func__, ceph_vinop(inode), folio, folio-=
>index);
> > While having context information attached to each dout is nice, it
> > certainly comes at a price of a lot of churn and automated backport
> > disruption.
>
> Yeah, certainly this will break automated backporting. But this should
> be okay, I can generate the backport patches for each stable release for
> this patch series, so after this it will make the automated backporting
> work.
>
> >   I wonder how much value doing this for douts as opposed
> > to just pr_* messages actually brings?
>
> I think the 'dout()' was introduced by printing more context info, which
> includes module/function names and line#, when the
> CONFIG_CEPH_LIB_PRETTYDEBUG is enabled.

dout() is just a wrapper around pr_debug().  It doesn't have anything
to do with CONFIG_CEPH_LIB_PRETTYDEBUG per se which adds file names and
line numbers.  IIRC dout() by itself just adds a space at the front to
make debugging spew stand out.

>
> Maybe we can remove CONFIG_CEPH_LIB_PRETTYDEBUG now, since the pr_* will
> print the module name and also the caller for dout() and pr_* will print
> the function name mostly ?

To the best of my knowledge, CONFIG_CEPH_LIB_PRETTYDEBUG has always
been disabled by default and it's not enabled by any distribution in
their kernels.  I don't think anyone out there would miss it, but then
it's not hurting either -- it's less than 20 lines of code with all
ifdef-ery included.

Thanks,

                Ilya
