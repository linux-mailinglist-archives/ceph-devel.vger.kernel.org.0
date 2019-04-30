Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3860F2F4
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Apr 2019 11:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfD3Jcc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Apr 2019 05:32:32 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39133 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfD3Jcc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 Apr 2019 05:32:32 -0400
Received: by mail-qt1-f195.google.com with SMTP id h16so9613096qtk.6
        for <ceph-devel@vger.kernel.org>; Tue, 30 Apr 2019 02:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Le8x00RjY7zCKQZpTsbwDmICYgMHEj2sM7yE/oktTlE=;
        b=OKlyBZNkxIiIFfqVEiCI/E1r38G33eouzGSZC01Z/cIMx7fHcLu6zJbzntY/400lzv
         EgV5857lYcS9QK1qziSAQZndVepmgbWn0JGBm/nQzChQDyxug8ZLAB32hFb4gI/BIK0T
         rsnQx9oKqcOo27NV2tDFiMVOzhSjBFYs28dWrad88NSmLYh5HD2XAvtuwFBfz/EzpsFI
         /6nnUdanqqQnjCWhK4TNk2GRkFJCEsSY5iy3Yixb5ogtsgnVWTiLUT9otl2ZLuKkVVJJ
         dRabrj1thDwZNbE5rHD4VmMTdRzbqktk4lzRcBjWRUMiSwufctW89uMJikWkBo9BAlbO
         7aCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Le8x00RjY7zCKQZpTsbwDmICYgMHEj2sM7yE/oktTlE=;
        b=F6b0vNShJe/MFYxAdXSxRH48cEtx5IIC0lkxq/TfVQIRQwnRJsfgg8v3B+8v/1uK1/
         dWerq6GivfwPbT1VNkcPDjqRcPuAN69sn/wdNW3mzlc3TmnWtrCgrDQiir47wQmwHg9H
         zkoO4mCtO4oItqn9TSVuofpw9p2Gvu6zz7euBIochrzpXLvDHJrbSV6mpim8N9MfTo+x
         H4YcuBCCzzLIURvNaB32VXiETdrJV+sk30diUHoFa1dG/pCRi7hYmZQLYfLC3vPixJ2R
         RCsUUdkOSpxLt/1eh+tE4SmXkpO/9LUibESWmiQVwRFJaTn+2HOZW+JhxKA1AF6jejCB
         rEqA==
X-Gm-Message-State: APjAAAVthvYeTjJMmzLb34ax0AIQLMus0F4o1Bz90DoMEQiEj4NdG5Fb
        JpBxvb0rJ0a5FPWXL8QgraprL8X+18aSHq+3M1k=
X-Google-Smtp-Source: APXvYqygCVqoXsDeo1KhdmgbSXUggK9Vmfe3DPVT62Sg1pNrtTFKau7oELH5WPTqk7fO8mKVtnpli8FLyQrLZlAXoJ0=
X-Received: by 2002:aed:2571:: with SMTP id w46mr36045206qtc.222.1556616751029;
 Tue, 30 Apr 2019 02:32:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190429192554.30833-1-jlayton@kernel.org>
In-Reply-To: <20190429192554.30833-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 30 Apr 2019 17:32:19 +0800
Message-ID: <CAAM7YA=C2iw80ZFs3KDrdG0+T7QcZWepuFZjTKCbsz6LZKa=2g@mail.gmail.com>
Subject: Re: [PATCH 1/2] ceph: use ceph_mdsc_build_path instead of clone_dentry_name
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
> While it may be slightly more efficient, it's probably not worthwhile to
> optimize for the case that clone_dentry_name handles. We can get the
> same result by just calling ceph_mdsc_build_path when the parent isn't
> locked, with less code duplication.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/mds_client.c | 41 +++--------------------------------------
>  1 file changed, 3 insertions(+), 38 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 74cb3078ea63..e8245df09691 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2170,55 +2170,20 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
>         return path;
>  }
>
> -/* Duplicate the dentry->d_name.name safely */
> -static int clone_dentry_name(struct dentry *dentry, const char **ppath,
> -                            int *ppathlen)
> -{
> -       u32 len;
> -       char *name;
> -retry:
> -       len = READ_ONCE(dentry->d_name.len);
> -       name = kmalloc(len + 1, GFP_NOFS);
> -       if (!name)
> -               return -ENOMEM;
> -
> -       spin_lock(&dentry->d_lock);
> -       if (dentry->d_name.len != len) {
> -               spin_unlock(&dentry->d_lock);
> -               kfree(name);
> -               goto retry;
> -       }
> -       memcpy(name, dentry->d_name.name, len);
> -       spin_unlock(&dentry->d_lock);
> -
> -       name[len] = '\0';
> -       *ppath = name;
> -       *ppathlen = len;
> -       return 0;
> -}
> -
>  static int build_dentry_path(struct dentry *dentry, struct inode *dir,
>                              const char **ppath, int *ppathlen, u64 *pino,
>                              bool *pfreepath, bool parent_locked)
>  {
> -       int ret;
>         char *path;
>
>         rcu_read_lock();
>         if (!dir)
>                 dir = d_inode_rcu(dentry->d_parent);
> -       if (dir && ceph_snap(dir) == CEPH_NOSNAP) {
> +       if (dir && parent_locked && ceph_snap(dir) == CEPH_NOSNAP) {
>                 *pino = ceph_ino(dir);
>                 rcu_read_unlock();
> -               if (parent_locked) {
> -                       *ppath = dentry->d_name.name;
> -                       *ppathlen = dentry->d_name.len;
> -               } else {
> -                       ret = clone_dentry_name(dentry, ppath, ppathlen);
> -                       if (ret)
> -                               return ret;
> -                       *pfreepath = true;
> -               }
> +               *ppath = dentry->d_name.name;
> +               *ppathlen = dentry->d_name.len;
>                 return 0;
>         }
>         rcu_read_unlock();


Reviewed-by: "Yan, Zheng" <zyan@redhat.com>

> --
> 2.20.1
>
