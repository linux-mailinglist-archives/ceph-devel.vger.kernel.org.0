Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2173B03DA
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Jun 2021 14:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhFVML5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 22 Jun 2021 08:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbhFVMLu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 22 Jun 2021 08:11:50 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6AAC061574
        for <ceph-devel@vger.kernel.org>; Tue, 22 Jun 2021 05:09:33 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id k5so4595732ilv.8
        for <ceph-devel@vger.kernel.org>; Tue, 22 Jun 2021 05:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=43kdMMaLaZ3B1g3w3MTjpgZ9hw3dTeIKBmVGnKO/rpc=;
        b=ETaPwSRbDq+E/WkN1parX1zQbUULsekC/82qkm3uXxeh8kZdEI9rc/oB0K1OzZxDb6
         2D72e5YqHVQ+AT+UOBy20fPLVZQUhac0V0EvuYeLzhnWY5RXfaTgD7GxqaCNsPWxWm7I
         JDb4VlzS6Gnt5y7yCe6vVsFAN2WA9SrbWzn3CDJtg3yZlBRb/FLgQ6SnKQCNNTe7ZBMh
         3wG22CqWAmeaquCcBp7Wln0Chfjx3XUvoX6i30zCwu5cHxW0QGE9u5q9Xj49zR7Ef3p8
         J5xvqoK4eOXRm5+OxUH7GF+S3/zfFsjF4n4eeynYAn4JuJa5ziJmHWXqC1zpWLqPxFTX
         VD0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=43kdMMaLaZ3B1g3w3MTjpgZ9hw3dTeIKBmVGnKO/rpc=;
        b=Uxax/12OVKRGZM4uzT+/RjFr+Hz9BLsYWfZ+GFrbrqXgOgtc/ubFZsUF/wWZEwYUbm
         b7oKzt7DzGRgiUKUUBHjOW3ji/kng0Y2QcrvY7iNlOyVJzHHsGHDceVlbi3/Od/JVrWk
         698vteieskO2v29wXr46bnBdPQtITFIfz8D/1SK4pgKgP3wJ/0w2MJvqGsDfa4p1pePz
         njRTzkz2yM12s1I9GHuCAkbTMndPQC83Vsp4U5RAt7lZgMiTwUC8u3EApJP/kDjBxnNy
         GmIwnoNyg43xnOyf/2aQdoV37dnJ1GCezr1Tohi5+vqL2dueVebatS0IBdHDrxJRz0Tj
         IaaA==
X-Gm-Message-State: AOAM531/v4zw+GmVH/LqQWVSYnHjbHFHxplznDmxUolWEToxQunS2A4H
        w5A2EK3ntPnl6R7VvoVLjB2l9oNB2shtymsGo5b/EZogShRcow==
X-Google-Smtp-Source: ABdhPJxgNfjMEY829Q1bXqAOo8wjbQQgZYT4qfp6nOcRUgP80SCwHfQSz0YJziSo6pgoQV8oKheLc2hcDcjUjYQSWeQ=
X-Received: by 2002:a92:cbd0:: with SMTP id s16mr2434262ilq.19.1624363773353;
 Tue, 22 Jun 2021 05:09:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210603123850.74421-1-jlayton@kernel.org> <20210621235722.304689-1-jlayton@kernel.org>
In-Reply-To: <20210621235722.304689-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 22 Jun 2021 14:09:19 +0200
Message-ID: <CAOi1vP_VHP9sg=EzKSBf99n8q-y8zNZ9ZLPDJt-yvJr8SeZq7g@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix error handling in ceph_atomic_open and ceph_lookup
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 22, 2021 at 1:57 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> Commit aa60cfc3f7ee broke the error handling in these functions such
> that they don't handle non-ENOENT errors from ceph_mdsc_do_request
> properly.
>
> Move the checking of -ENOENT out of ceph_handle_snapdir and into the
> callers, and if we get a different error, return it immediately.
>
> Fixes: aa60cfc3f7ee ("ceph: don't use d_add in ceph_handle_snapdir")
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/dir.c   | 22 ++++++++++++----------
>  fs/ceph/file.c  | 14 ++++++++------
>  fs/ceph/super.h |  2 +-
>  3 files changed, 21 insertions(+), 17 deletions(-)
>
> This one fixes the bug that Ilya spotted in ceph_atomic_open. Also,
> there is no need to test IS_ERR(dentry) unless we called
> ceph_handle_snapdir. Finally, it's probably best not to pass
> ceph_finish_lookup an ERR_PTR as a dentry. Reinstate the res pointer and
> only reset the dentry pointer if it's valid.
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 5624fae7a603..e78da771ec96 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -668,14 +668,13 @@ static loff_t ceph_dir_llseek(struct file *file, loff_t offset, int whence)
>   * Handle lookups for the hidden .snap directory.
>   */
>  struct dentry *ceph_handle_snapdir(struct ceph_mds_request *req,
> -                                  struct dentry *dentry, int err)
> +                                  struct dentry *dentry)
>  {
>         struct ceph_fs_client *fsc = ceph_sb_to_client(dentry->d_sb);
>         struct inode *parent = d_inode(dentry->d_parent); /* we hold i_mutex */
>
>         /* .snap dir? */
> -       if (err == -ENOENT &&
> -           ceph_snap(parent) == CEPH_NOSNAP &&
> +       if (ceph_snap(parent) == CEPH_NOSNAP &&
>             strcmp(dentry->d_name.name, fsc->mount_options->snapdir_name) == 0) {
>                 struct dentry *res;
>                 struct inode *inode = ceph_get_snapdir(parent);
> @@ -742,7 +741,6 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
>         struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
>         struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
>         struct ceph_mds_request *req;
> -       struct dentry *res;
>         int op;
>         int mask;
>         int err;
> @@ -793,12 +791,16 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
>         req->r_parent = dir;
>         set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
>         err = ceph_mdsc_do_request(mdsc, NULL, req);
> -       res = ceph_handle_snapdir(req, dentry, err);
> -       if (IS_ERR(res)) {
> -               err = PTR_ERR(res);
> -       } else {
> -               dentry = res;
> -               err = 0;
> +       if (err == -ENOENT) {
> +               struct dentry *res;
> +
> +               res  = ceph_handle_snapdir(req, dentry);

Stray space here, fixed in the branch.

> +               if (IS_ERR(res)) {
> +                       err = PTR_ERR(res);
> +               } else {
> +                       dentry = res;
> +                       err = 0;
> +               }
>         }
>         dentry = ceph_finish_lookup(req, dentry, err);
>         ceph_mdsc_put_request(req);  /* will dput(dentry) */
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 7aa20d50a231..7c08f864694f 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -739,14 +739,16 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>         err = ceph_mdsc_do_request(mdsc,
>                                    (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
>                                    req);
> -       dentry = ceph_handle_snapdir(req, dentry, err);
> -       if (IS_ERR(dentry)) {
> -               err = PTR_ERR(dentry);
> -               goto out_req;
> +       if (err == -ENOENT) {
> +               dentry = ceph_handle_snapdir(req, dentry);
> +               if (IS_ERR(dentry)) {
> +                       err = PTR_ERR(dentry);
> +                       goto out_req;
> +               }
> +               err = 0;
>         }
> -       err = 0;
>
> -       if ((flags & O_CREAT) && !req->r_reply_info.head->is_dentry)
> +       if (!err && (flags & O_CREAT) && !req->r_reply_info.head->is_dentry)
>                 err = ceph_handle_notrace_create(dir, dentry);
>
>         if (d_in_lookup(dentry)) {

I must admit that I don't understand the code that follows.  For
example, if ceph_handle_notrace_create() returns ENOENT, is it supposed
to be resolved by ceph_finish_lookup()?  Because if it gets resolved,
err is not reset and we still jump to out_req, possibly leaving some
dentry references behind.  It appears to be an older bug though.

This fix for dealing with ceph_mdsc_do_request() errors seems correct,
but I really think this code needs massaging to disentangle handling of
special cases from actual errors.

Reviewed-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya
