Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0746CF2FE
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Apr 2019 11:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfD3JdH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Apr 2019 05:33:07 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45229 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfD3JdH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 Apr 2019 05:33:07 -0400
Received: by mail-qk1-f193.google.com with SMTP id d5so7685789qko.12
        for <ceph-devel@vger.kernel.org>; Tue, 30 Apr 2019 02:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CZjO8U2Peyp7S4smjGjajZHeIHaX6ITfZcV4YYRUDLY=;
        b=Hy/RrRz7U91ZTMIDWcBDYi3xMtilQ2YPDReTUpCXjn9y6iGaGReoFFq6C/r5KyQi8m
         UKriIne2o5sZ71N03I1hhMoPi4zFNpvsjbX7rG8ahQrfzG7iNFSN7/4aWrl8P2BRPkI/
         f4qFNPW2G6FhrZHpEun2bXo8ahQjI2H3cXONIyf8EQeFfu1xdhmYxf4iHnciopO2bLII
         Xd0H0dyu01+SlhxV8epm/sZn5l7DLEKKOtzzFimRECdcg1zVMIBExuOrmnGIrGWvZUU8
         lpAwJsQfyuoXDvzh2B7/OFclAASTObiC3C7oNfPuJcFzavmhfnmFfMOtAm6jfAymvceZ
         aarw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CZjO8U2Peyp7S4smjGjajZHeIHaX6ITfZcV4YYRUDLY=;
        b=GAsVS6T1fFFr/zn4BfgWVUq/Sj0poa9Fxvq/KfPb4cDZ8kPgZtMpr2HbPBZQhTyXW4
         BORu4R1N5oY68AQkZ1qCek42RcaDpscNMCUL7MBugwkfl9AJ+5VAEXprHaBsnlsmwH3W
         R1nRvo4u6yH/18lUQgDix+QkY3zB/rZK+XytF4ilLwQgtdRNrfEI+sWYu0/k466KE8wg
         iTmbLZOMvWufRYBr+tYj9beT+lCST+55PVjsjG7A6cgCxjclNBJRfWbQSzl3Iy8/CN2M
         UIVaubwdAyS0OkWBr2ST8K6WrGPHwbV1ZyI/ZNd4ZdNmQT9qSty8PyAddJPaUDxW2j6P
         0VIg==
X-Gm-Message-State: APjAAAUhupcYUFx8+rNoJXTJ8vH4zjV977m780vvll3XGAfJyWHfv+ZK
        5AcLu+VVTj7kV4Mwq0OqLUBM32DPdRj+hDK6B3E=
X-Google-Smtp-Source: APXvYqymRd4ioVUyaStHRVcyy1PumRDU174+hquF9hvM2s50j0nJZwb+3NNrTzJyBNeabAsV19apUIU8uhM4vL9RQ0k=
X-Received: by 2002:a37:a689:: with SMTP id p131mr31415512qke.246.1556616785995;
 Tue, 30 Apr 2019 02:33:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190429192554.30833-1-jlayton@kernel.org> <20190429192554.30833-2-jlayton@kernel.org>
In-Reply-To: <20190429192554.30833-2-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 30 Apr 2019 17:32:54 +0800
Message-ID: <CAAM7YA=0NhFXXtmeqoBnMq0A0sZ+1xsOc-OvRHt7Ed=gVhdhFw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ceph: use __getname/__putname in ceph_mdsc_build_path
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Zheng Yan <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Apr 30, 2019 at 3:27 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> Al suggested we get rid of the kmalloc here and just use __getname
> and __putname to get a full PATH_MAX pathname buffer.
>
> Since we build the path in reverse, we continue to return a pointer
> to the beginning of the string and the length, and add a new helper
> to free the thing at the end.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/debugfs.c    |  4 +--
>  fs/ceph/mds_client.c | 58 ++++++++++++++++----------------------------
>  fs/ceph/mds_client.h |  6 +++++
>  3 files changed, 29 insertions(+), 39 deletions(-)
>
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 777f6ceb5259..b014fc7d4e3c 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -88,7 +88,7 @@ static int mdsc_show(struct seq_file *s, void *p)
>                                    req->r_dentry,
>                                    path ? path : "");
>                         spin_unlock(&req->r_dentry->d_lock);
> -                       kfree(path);
> +                       ceph_mdsc_free_path(path, pathlen);
>                 } else if (req->r_path1) {
>                         seq_printf(s, " #%llx/%s", req->r_ino1.ino,
>                                    req->r_path1);
> @@ -108,7 +108,7 @@ static int mdsc_show(struct seq_file *s, void *p)
>                                    req->r_old_dentry,
>                                    path ? path : "");
>                         spin_unlock(&req->r_old_dentry->d_lock);
> -                       kfree(path);
> +                       ceph_mdsc_free_path(path, pathlen);
>                 } else if (req->r_path2 && req->r_op != CEPH_MDS_OP_SYMLINK) {
>                         if (req->r_ino2.ino)
>                                 seq_printf(s, " #%llx/%s", req->r_ino2.ino,
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index e8245df09691..92372fc647c7 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2092,39 +2092,24 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
>  {
>         struct dentry *temp;
>         char *path;
> -       int len, pos;
> +       int pos;
>         unsigned seq;
>         u64 base;
>
>         if (!dentry)
>                 return ERR_PTR(-EINVAL);
>
> -retry:
> -       len = 0;
> -       seq = read_seqbegin(&rename_lock);
> -       rcu_read_lock();
> -       for (temp = dentry; !IS_ROOT(temp);) {
> -               struct inode *inode = d_inode(temp);
> -               if (inode && ceph_snap(inode) == CEPH_SNAPDIR)
> -                       len++;  /* slash only */
> -               else if (stop_on_nosnap && inode &&
> -                        ceph_snap(inode) == CEPH_NOSNAP)
> -                       break;
> -               else
> -                       len += 1 + temp->d_name.len;
> -               temp = temp->d_parent;
> -       }
> -       rcu_read_unlock();
> -       if (len)
> -               len--;  /* no leading '/' */
> -
> -       path = kmalloc(len+1, GFP_NOFS);
> +       path = __getname();
>         if (!path)
>                 return ERR_PTR(-ENOMEM);
> -       pos = len;
> -       path[pos] = 0;  /* trailing null */
> +retry:
> +       pos = PATH_MAX - 1;
> +       path[pos] = '\0';
> +
> +       seq = read_seqbegin(&rename_lock);
>         rcu_read_lock();
> -       for (temp = dentry; !IS_ROOT(temp) && pos != 0; ) {
> +       temp = dentry;
> +       for (;;) {
>                 struct inode *inode;
>
>                 spin_lock(&temp->d_lock);
> @@ -2142,32 +2127,31 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
>                                 spin_unlock(&temp->d_lock);
>                                 break;
>                         }
> -                       strncpy(path + pos, temp->d_name.name,
> -                               temp->d_name.len);
> +                       memcpy(path + pos, temp->d_name.name, temp->d_name.len);
>                 }
>                 spin_unlock(&temp->d_lock);
> -               if (pos)
> -                       path[--pos] = '/';
>                 temp = temp->d_parent;
> +               if (IS_ROOT(temp))
> +                       break;
> +               path[--pos] = '/';
>         }
>         base = ceph_ino(d_inode(temp));
>         rcu_read_unlock();
> -       if (pos != 0 || read_seqretry(&rename_lock, seq)) {
> +       if (pos < 0 || read_seqretry(&rename_lock, seq)) {
>                 pr_err("build_path did not end path lookup where "
> -                      "expected, namelen is %d, pos is %d\n", len, pos);
> +                      "expected, pos is %d\n", pos);
>                 /* presumably this is only possible if racing with a
>                    rename of one of the parent directories (we can not
>                    lock the dentries above us to prevent this, but
>                    retrying should be harmless) */
> -               kfree(path);
>                 goto retry;
>         }
>
>         *pbase = base;
> -       *plen = len;
> +       *plen = PATH_MAX - 1 - pos;
>         dout("build_path on %p %d built %llx '%.*s'\n",
> -            dentry, d_count(dentry), base, len, path);
> -       return path;
> +            dentry, d_count(dentry), base, *plen, path+pos);
> +       return path + pos;
>  }
>
>  static int build_dentry_path(struct dentry *dentry, struct inode *dir,
> @@ -2374,10 +2358,10 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
>
>  out_free2:
>         if (freepath2)
> -               kfree((char *)path2);
> +               ceph_mdsc_free_path((char *)path2, pathlen2);
>  out_free1:
>         if (freepath1)
> -               kfree((char *)path1);
> +               ceph_mdsc_free_path((char *)path1, pathlen1);
>  out:
>         return msg;
>  }
> @@ -3449,7 +3433,7 @@ static int encode_caps_cb(struct inode *inode, struct ceph_cap *cap,
>                 ceph_pagelist_encode_string(pagelist, path, pathlen);
>                 ceph_pagelist_append(pagelist, &rec, sizeof(rec.v1));
>  out_freepath:
> -               kfree(path);
> +               ceph_mdsc_free_path(path, pathlen);
>         }
>
>  out_err:
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 0d1f673a5689..ebcad5afc87b 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -492,6 +492,12 @@ extern int ceph_iterate_session_caps(struct ceph_mds_session *session,
>                                      void *arg);
>  extern void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc);
>
> +static inline void ceph_mdsc_free_path(char *path, int len)
> +{
> +       if (path)
> +               __putname(path - (PATH_MAX - 1 - len));
> +}
> +
>  extern char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *base,
>                                   int stop_on_nosnap);
>
> --

Reviewed-by: "Yan, Zheng" <zyan@redhat.com>

> 2.20.1
>
