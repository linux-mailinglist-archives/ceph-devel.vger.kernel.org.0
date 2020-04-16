Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA271AB960
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Apr 2020 09:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437969AbgDPHIm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Apr 2020 03:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2437060AbgDPHIi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 16 Apr 2020 03:08:38 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9CCC061A0C
        for <ceph-devel@vger.kernel.org>; Thu, 16 Apr 2020 00:08:38 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id e4so5941931ils.4
        for <ceph-devel@vger.kernel.org>; Thu, 16 Apr 2020 00:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lMvJCaPdI3SbrUc7n94R8THccfAH3dojEbCwnpOwdwg=;
        b=fm2IlqwS7fCjN57QxTVptD6Pg5y8es796A8nt+/oScFYbH79nP7bAHn4299wSxT4We
         t3D4AVoXuXPIHc/2+DE49LHB85Hj/dt0yMIedMrF4MXfeqRcESWS1LubsBsCjEy3WBOk
         ZRqhSStCeLolK9/rqqQkxrk4VOzwJfCWNcsYzSDIXZHsn6CUgzDnyN4O+l8qIs29cpwp
         uS+NNSrvvZa4yozWYSLNgNWgEiQ/d3RYWRxfB1A2vl7g96Ka2jpl+pgRKmGW8cmQuTBL
         QVXN252bcjb2zFnZ4l8M55nvXmReDIaZ9cXwc3Vt22k/EoJq5zMyoqt8B0ikrlq/+fJa
         phRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lMvJCaPdI3SbrUc7n94R8THccfAH3dojEbCwnpOwdwg=;
        b=LD+5AlkA+sbADShH/BVys/OcrLZon2EoJo1fODTfKOyMH0dn3QLPODOKUvw9KsyHSm
         5XtqxmQVxFU6+O/01uVs7JXPti4phEyfu2VTvv9d6S56iFSFqYAYTiqiVuvQLPN/m3qi
         zoGsh+xeYCLTq01xyKrPLq8WWDKlvK30IjDomeEb88JKRIOLKHolYiL7bBja9xoHKHmY
         f/N5D+48Ws5a/Zr0wZQpJ9NvomdYI/eVldgWuKz7wvkh7lE317dSqSA0bFt2BMF6vL+y
         dR+BnbrQMyJUJfBt8+WqBBLpKpA8N0Xz07rrTwG48tuZ/1p7xGmtg+XPQ8U4LLwwH2E0
         HJ1g==
X-Gm-Message-State: AGi0PubzagTLYi1hB37ueO6XY3aiamHknLCRERricKPshTMMdyT505IM
        w0y8ChYbQVxl174e8YGp2c5qyNw0SkQDKWF+qCIg0p7TfNw=
X-Google-Smtp-Source: APiQypI7QKEdy53TH2Ds0MHDBBwnv1zws7Jnhv3hMnWpHEFiFWfliQbqR8SfqFw/fVzkcVLGxL4EIqbLh8i0HZPkAFU=
X-Received: by 2002:a92:520a:: with SMTP id g10mr8963069ilb.282.1587020917810;
 Thu, 16 Apr 2020 00:08:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200415133929.234033-1-jlayton@kernel.org>
In-Reply-To: <20200415133929.234033-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 16 Apr 2020 09:08:33 +0200
Message-ID: <CAOi1vP8Nrac=+gaN75EoOo8dbjubJ-aG-M9ZniKtz+CKA7kysw@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix potential bad pointer deref in async dirops cb's
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Apr 16, 2020 at 2:04 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> The new async dirops callback routines can pass ERR_PTR values to
> ceph_mdsc_free_path, which could cause an oops.
>
> Given that ceph_mdsc_build_path returns ERR_PTR values, it makes sense
> to just have ceph_mdsc_free_path ignore them. Also, clean up the error
> handling a bit in mdsc_show, and ensure that the pr_warn messages look
> sane even if ceph_mdsc_build_path fails.
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/debugfs.c    | 8 ++------
>  fs/ceph/dir.c        | 4 ++--
>  fs/ceph/file.c       | 4 ++--
>  fs/ceph/mds_client.h | 2 +-
>  4 files changed, 7 insertions(+), 11 deletions(-)
>
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index eebbce7c3b0c..3baec3a896ee 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -83,13 +83,11 @@ static int mdsc_show(struct seq_file *s, void *p)
>                 } else if (req->r_dentry) {
>                         path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
>                                                     &pathbase, 0);
> -                       if (IS_ERR(path))
> -                               path = NULL;
>                         spin_lock(&req->r_dentry->d_lock);
>                         seq_printf(s, " #%llx/%pd (%s)",
>                                    ceph_ino(d_inode(req->r_dentry->d_parent)),
>                                    req->r_dentry,
> -                                  path ? path : "");
> +                                  IS_ERR(path) ? "" : path);
>                         spin_unlock(&req->r_dentry->d_lock);
>                         ceph_mdsc_free_path(path, pathlen);
>                 } else if (req->r_path1) {
> @@ -102,14 +100,12 @@ static int mdsc_show(struct seq_file *s, void *p)
>                 if (req->r_old_dentry) {
>                         path = ceph_mdsc_build_path(req->r_old_dentry, &pathlen,
>                                                     &pathbase, 0);
> -                       if (IS_ERR(path))
> -                               path = NULL;
>                         spin_lock(&req->r_old_dentry->d_lock);
>                         seq_printf(s, " #%llx/%pd (%s)",
>                                    req->r_old_dentry_dir ?
>                                    ceph_ino(req->r_old_dentry_dir) : 0,
>                                    req->r_old_dentry,
> -                                  path ? path : "");
> +                                  IS_ERR(path) ? "" : path);
>                         spin_unlock(&req->r_old_dentry->d_lock);
>                         ceph_mdsc_free_path(path, pathlen);
>                 } else if (req->r_path2 && req->r_op != CEPH_MDS_OP_SYMLINK) {
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 9d02d4feb693..39f5311404b0 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -1057,8 +1057,8 @@ static void ceph_async_unlink_cb(struct ceph_mds_client *mdsc,
>
>         /* If op failed, mark everyone involved for errors */
>         if (result) {
> -               int pathlen;
> -               u64 base;
> +               int pathlen = 0;
> +               u64 base = 0;
>                 char *path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
>                                                   &base, 0);
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 3a1bd13de84f..160644ddaeed 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -529,8 +529,8 @@ static void ceph_async_create_cb(struct ceph_mds_client *mdsc,
>
>         if (result) {
>                 struct dentry *dentry = req->r_dentry;
> -               int pathlen;
> -               u64 base;
> +               int pathlen = 0;
> +               u64 base = 0;
>                 char *path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
>                                                   &base, 0);
>
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 1b40f30e0a8e..43111e408fa2 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -531,7 +531,7 @@ extern void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc);
>
>  static inline void ceph_mdsc_free_path(char *path, int len)
>  {
> -       if (path)
> +       if (!IS_ERR_OR_NULL(path))
>                 __putname(path - (PATH_MAX - 1 - len));
>  }

Hi Jeff,

Following our discussion, I staged v1 (i.e. no debugfs.c changes) in
commit 2a575f138d003fff0f4930b5cfae4a1c46343b8f on Monday.  I see you
force pushed testing, so perhaps you missed that.

Please be careful when force pushing.

Thanks,

                Ilya
