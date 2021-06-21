Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7123AF600
	for <lists+ceph-devel@lfdr.de>; Mon, 21 Jun 2021 21:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhFUTWl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 21 Jun 2021 15:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbhFUTWj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 21 Jun 2021 15:22:39 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC52C061760
        for <ceph-devel@vger.kernel.org>; Mon, 21 Jun 2021 12:20:22 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id l64so17154604ioa.7
        for <ceph-devel@vger.kernel.org>; Mon, 21 Jun 2021 12:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hKBYYkfyNxLV2B0xL6nzRRXcevfdErZwURFtbqm0W7M=;
        b=YXPHmZ9BuHOrIdeTVXaM6wHGfAzIufRqq1Cm1Xtg6qau5Ka0NkaANqf6NzBap+nPwq
         URPEdp3dTTS35yB3m/maC/qIE51vlMpGkF9F0oT+0Budx1hc/f7i0QWS5WX9/0OdSWfE
         8RRfEba5LBSAcgIac23B0Z3p6uAtSij1gCzH4F2BmqA/YIBgaE4hPqm5kB7bIFtrbfAQ
         jFv0txx95vlCgoZKTO0agv60fsM5K3d5S2hNMpne5kk5X4KOeV2bej8g0r6y337YjjGk
         ybiS7/d+eSmoU06HhzGZx/tmzhHXJZc/0rdb7zW3nZx9/6l085wD2oLkGwFFTEps7EQU
         6Hqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hKBYYkfyNxLV2B0xL6nzRRXcevfdErZwURFtbqm0W7M=;
        b=O+ffgm3/hIzp3Ew4SIK8kFFM9O1R4fhJ3wVo86PsPl1g/GBRqJE60Q1OY273Pug7RT
         nsXUIINAWoXxqMZHDfPHZI+TUlHN89EGuWGM3wlLMGR1fk1cCkCafEXLU6wMu7bltUFm
         QgmHJorg6lk2wCOqfCzz2EbKMWyfFwZV2FH4VjWx+T85W2qjnX03ayygNz/9XFiQkOjQ
         JB46nsDMoBZfPVuhE9uaZ0oe0eCMpE7DLwSywgO0EqbybII/dvTyVw6Opt6vCLbCCPZ1
         j7RsnrIRd6t/15P3KmKiQXmsn1kZGo+Lq9voNxN0e0jZQXkJln//VqWQBBGqDQ5ro2Zh
         nlWQ==
X-Gm-Message-State: AOAM530qb43lm65tt/Of1Ir0TXrdlHbZWJhrKdP5POIvN7Qz7Kd0Qzt+
        AP/507xcO3msX5HXTQvdpZ2Ip2ix97Cf8uNDOKrt5PgUz9OLOQ==
X-Google-Smtp-Source: ABdhPJz0jRzoOg9yKip8D3i23o9lCJZ3/8r2PExDL97vyo5qYPQz5O1LKeAcdUrffMcRv9ZLiJ8UUFGGlCcYWAP6QKk=
X-Received: by 2002:a05:6602:1234:: with SMTP id z20mr21561078iot.167.1624303221780;
 Mon, 21 Jun 2021 12:20:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210603123850.74421-1-jlayton@kernel.org>
In-Reply-To: <20210603123850.74421-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 21 Jun 2021 21:20:09 +0200
Message-ID: <CAOi1vP8vcs8da2+fUUuo25S0M0bdVKqp_qxDyTRaAAYDMnvJGA@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix error handling in ceph_atomic_open and ceph_lookup
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 3, 2021 at 2:38 PM Jeff Layton <jlayton@kernel.org> wrote:
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
>  fs/ceph/dir.c   | 17 ++++++-----------
>  fs/ceph/file.c  |  6 +++---
>  fs/ceph/super.h |  2 +-
>  3 files changed, 10 insertions(+), 15 deletions(-)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 5624fae7a603..ac431246e0c9 100644
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
> @@ -793,13 +791,10 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
>         req->r_parent = dir;
>         set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
>         err = ceph_mdsc_do_request(mdsc, NULL, req);
> -       res = ceph_handle_snapdir(req, dentry, err);
> -       if (IS_ERR(res)) {
> -               err = PTR_ERR(res);
> -       } else {
> -               dentry = res;
> -               err = 0;
> -       }
> +       if (err == -ENOENT)
> +               dentry = ceph_handle_snapdir(req, dentry);
> +       if (IS_ERR(dentry))
> +               err = PTR_ERR(dentry);
>         dentry = ceph_finish_lookup(req, dentry, err);
>         ceph_mdsc_put_request(req);  /* will dput(dentry) */
>         dout("lookup result=%p\n", dentry);
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 7aa20d50a231..a01ad342a91d 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -739,14 +739,14 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>         err = ceph_mdsc_do_request(mdsc,
>                                    (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
>                                    req);
> -       dentry = ceph_handle_snapdir(req, dentry, err);
> +       if (err == -ENOENT)
> +               dentry = ceph_handle_snapdir(req, dentry);
>         if (IS_ERR(dentry)) {
>                 err = PTR_ERR(dentry);
>                 goto out_req;
>         }

Hi Jeff,

This doesn't seem right to me.  Looking at 5.12, ENOENT from
ceph_mdsc_do_request() could be resolved by ceph_handle_snapdir()
meaning that ceph_handle_notrace_create() could be called and
ceph_finish_lookup() could be passed err == 0.

With this patch err would remain ENOENT, resulting in skipping
the potential ceph_handle_notrace_create() call and passing that
ENOENT to ceph_finish_lookup().

Thanks,

                Ilya
