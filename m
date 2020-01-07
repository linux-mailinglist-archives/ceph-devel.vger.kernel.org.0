Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16D3A13294E
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jan 2020 15:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbgAGOuW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jan 2020 09:50:22 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39807 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727968AbgAGOuW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jan 2020 09:50:22 -0500
Received: by mail-qt1-f195.google.com with SMTP id e5so45475822qtm.6
        for <ceph-devel@vger.kernel.org>; Tue, 07 Jan 2020 06:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1duz07KwoQsRR98j+zJOipLCwDu2+qFZE9iWX0uAqUs=;
        b=Xlt1r4RujtwTTUjQkPGc7LSx0f12xQvkN7g3addSajjh+No+Btbl0zKZt95H83I+fs
         6uBaZiBto2dum2fYPi/v+woDIp6Jr4syngLJhQ/KMNGdyP1njPNL3fY/M7qgdm+MzDMD
         657J3zZyWOixJ139nqMZeskUhqmSmaAQ8uysCrG5EU3nRMCZlSnmDMl+BSR37HtAGCaS
         VtqkWO6wFjsKvs1/bUI7PkBFGRdGw8AyxTTdQjiIJbbJtFbOCsAX04ydW/VpAjPrFPbz
         VBjX+9ZGK2RysJTloKm2g+/sPrFIM3OkBjao4rI6KH8XkKrvuzc6De9GQsmPQVog3Tor
         H7Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1duz07KwoQsRR98j+zJOipLCwDu2+qFZE9iWX0uAqUs=;
        b=E0wDGv1UnO6kuKDssJQ5qjjqwGkOq0Rkc459Vn4gOO48opdlbrDuHnlPB0yHUzb4Vr
         65TgGyliTRPHl7NdhEzOOGXKiqiWj5j2UUwfqO8oZVTO+CnQBLhDJQSfjscsx/giSz5+
         n6OE735KcOkGDD/8ecRnsQpmM0u9aR5CD7LPYSpnCTBf5xvgNHSqVaVNEwPNzlXQSQss
         h5wq2C8q4o9+I8Z0hrBJmOtdFluG0DSGLCsEMr2Eh0cqxN7qh1UN7myXv+Zu+959YwGq
         zUUe8jcACwAGeD6svL9GYHQuoJV4HYoZme/d9+FDYjmj2XAC3DN6itXyn4yBR0wzUVUp
         D+qw==
X-Gm-Message-State: APjAAAVOwrM/B2BY/0C1+ZFWWQ4YDZlc4mHMWXNXjPei1qhOk5iamON1
        4CBgRpx8aZfaz1NG/noEAlXtnrru3QRAPo3vWe5zB9n5FfE=
X-Google-Smtp-Source: APXvYqwEBjlnQvIRcNoo71bm3crd4LTgXxrgsRR7+IVu6I2gJMgvFVkdfVkn6lNHtY84bQQ0vKJKSLw4ec6vHYLn92k=
X-Received: by 2002:ac8:6d33:: with SMTP id r19mr78739381qtu.296.1578408620769;
 Tue, 07 Jan 2020 06:50:20 -0800 (PST)
MIME-Version: 1.0
References: <20190801202605.18172-1-jlayton@kernel.org> <20190801202605.18172-6-jlayton@kernel.org>
In-Reply-To: <20190801202605.18172-6-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 7 Jan 2020 22:50:09 +0800
Message-ID: <CAAM7YAkKd4_QEPs_2jROYL8Terx7WJU1wV_no4jnaCcyYaV4Tg@mail.gmail.com>
Subject: Re: [PATCH 5/9] ceph: wait for async dir ops to complete before doing
 synchronous dir ops
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Aug 2, 2019 at 4:26 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> Ensure that we wait on replies from any pending directory operations
> involving children before we allow synchronous operations involving
> that directory to proceed.
>

This patch is not needed because mds does the job.  For current
implementation, we need to make inode operations (getattr/setattr/...)
wait until getting reply for async create.


> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/dir.c   | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
>  fs/ceph/file.c  |  4 ++++
>  fs/ceph/super.h |  1 +
>  3 files changed, 51 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index aab29f48c62d..35797ff895e7 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -1036,6 +1036,38 @@ static int ceph_link(struct dentry *old_dentry, struct inode *dir,
>         return err;
>  }
>
> +int ceph_async_dirop_request_wait(struct inode *inode)
> +{
> +       struct ceph_inode_info *ci = ceph_inode(inode);
> +       struct ceph_mds_request *cur, *req;
> +       int ret = 0;
> +
> +       /* Only applicable for directories */
> +       if (!inode || !S_ISDIR(inode->i_mode))
> +               return 0;
> +retry:
> +       spin_lock(&ci->i_unsafe_lock);
> +       req = NULL;
> +       list_for_each_entry(cur, &ci->i_unsafe_dirops, r_unsafe_dir_item) {
> +               if (!test_bit(CEPH_MDS_R_GOT_UNSAFE, &cur->r_req_flags) &&
> +                   !test_bit(CEPH_MDS_R_GOT_SAFE, &cur->r_req_flags)) {
> +                       req = cur;
> +                       ceph_mdsc_get_request(req);
> +                       break;
> +               }
> +       }
> +       spin_unlock(&ci->i_unsafe_lock);
> +       if (req) {
> +               dout("%s %lx wait on tid %llu\n", __func__, inode->i_ino,
> +                    req->r_tid);
> +               ret = wait_for_completion_killable(&req->r_completion);
> +               ceph_mdsc_put_request(req);
> +               if (!ret)
> +                       goto retry;
> +       }
> +       return ret;
> +}
> +
>  /*
>   * rmdir and unlink are differ only by the metadata op code
>   */
> @@ -1059,6 +1091,12 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
>                         CEPH_MDS_OP_RMDIR : CEPH_MDS_OP_UNLINK;
>         } else
>                 goto out;
> +
> +       /* Wait for any requests involving children to get a reply */
> +       err = ceph_async_dirop_request_wait(inode);
> +       if (err)
> +               goto out;
> +
>         req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
>         if (IS_ERR(req)) {
>                 err = PTR_ERR(req);
> @@ -1105,8 +1143,14 @@ static int ceph_rename(struct inode *old_dir, struct dentry *old_dentry,
>             (!ceph_quota_is_same_realm(old_dir, new_dir)))
>                 return -EXDEV;
>
> -       dout("rename dir %p dentry %p to dir %p dentry %p\n",
> -            old_dir, old_dentry, new_dir, new_dentry);
> +       err = ceph_async_dirop_request_wait(d_inode(old_dentry));
> +       if (err)
> +               return err;
> +
> +       err = ceph_async_dirop_request_wait(d_inode(new_dentry));
> +       if (err)
> +               return err;
> +
>         req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
>         if (IS_ERR(req))
>                 return PTR_ERR(req);
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 3c0b5247818f..75bce889305c 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -449,6 +449,10 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>              dir, dentry, dentry,
>              d_unhashed(dentry) ? "unhashed" : "hashed", flags, mode);
>
> +       err = ceph_async_dirop_request_wait(dir);
> +       if (err)
> +               return err;
> +
>         if (dentry->d_name.len > NAME_MAX)
>                 return -ENAMETOOLONG;
>
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index a9aa3e358226..77ed6c5900be 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1113,6 +1113,7 @@ extern int ceph_handle_snapdir(struct ceph_mds_request *req,
>                                struct dentry *dentry, int err);
>  extern struct dentry *ceph_finish_lookup(struct ceph_mds_request *req,
>                                          struct dentry *dentry, int err);
> +extern int ceph_async_dirop_request_wait(struct inode *inode);
>
>  extern void __ceph_dentry_lease_touch(struct ceph_dentry_info *di);
>  extern void __ceph_dentry_dir_lease_touch(struct ceph_dentry_info *di);
> --
> 2.21.0
>
