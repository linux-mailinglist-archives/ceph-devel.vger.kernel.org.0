Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7830BAB074
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2019 03:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404292AbfIFB5f (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Sep 2019 21:57:35 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36252 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730991AbfIFB5e (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Sep 2019 21:57:34 -0400
Received: by mail-qk1-f196.google.com with SMTP id s18so4233815qkj.3
        for <ceph-devel@vger.kernel.org>; Thu, 05 Sep 2019 18:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3LSEYVnquwrDyIg80STd3+kuV9a6LDX6tJlOngS8a3o=;
        b=FdE9QIVaFQGoru2RleUDf5PPP6zDtat44gvALQoCZevgOMb8+qraRfAer1h/Ddmtyp
         88FKlXwZRSPyRpgoigf8GWWj1BNUpqgxqBfYX8WthtQW2I5MMlm4CyJCPM9zarOmTUHW
         I4w8v411oCaQtl8Jo6fTefsCKEcPhb6m98tuBgFbqozlMPk4sBobSDnLSC1SsF2UcKcR
         BORWkUdjByzLckJVeRGVx5n/wnROkjy2QQUiR0VyG3175bADB+67sRAFV4bVaOyHpZIu
         vAUs8cNNEeLigNiiJvo95ndhG8YTXStXW4w0MgKdoFTWb0JRDcB0ffRiA05Df2y4UUdD
         rAQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3LSEYVnquwrDyIg80STd3+kuV9a6LDX6tJlOngS8a3o=;
        b=ommmRLntuL+JrsCNB8ff1zk5sVZOFoSsZ5SBddGvkSC7spR0rYUeP8EZLsUEb4H6p7
         GrOzXDtPCUb9Zu6Hl7xYINjSEPcNwHdqR7EjEastkChqgyxT4G20z64L0NvzzAnw0wTN
         UYarDQRY/zo8bdn3tcvn4c3YqG/+4HDpQ4NU5l4V8h9WCFbjxSL0EOzs5X9/Lj+x/up/
         Xf25Vq1n95pwfhNBLSWVocY0xDITzwb5WCaFts8iQ8Oq1cYjkPNEwTL48f+IDhLSxhGg
         OUnQhFqKCV9Y0o0aPAnLBIRgV7T2RlhIhgpt+z3THJfPqeZxoGWb3o6zsns0ClWCSf+7
         tpsg==
X-Gm-Message-State: APjAAAXeI6lerXYkJRWeTbL6hXJ2D3qhySiGWzditVvZpR0z1ismgfZt
        AzMgCM19LYrWEs/gwj5aaB2PbQK0ulGQ6pLzafI=
X-Google-Smtp-Source: APXvYqwNqYyoSB34kFqcvwkA6+v7Gu2Az7W00Zknh34R3uGQsx7J2Jpz+CyrfWPBCdqy2MvXOyu0dm4A09ahQNKe6OU=
X-Received: by 2002:a37:486:: with SMTP id 128mr6406331qke.141.1567735053406;
 Thu, 05 Sep 2019 18:57:33 -0700 (PDT)
MIME-Version: 1.0
References: <1567687915-121426-1-git-send-email-simon29rock@gmail.com>
In-Reply-To: <1567687915-121426-1-git-send-email-simon29rock@gmail.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Fri, 6 Sep 2019 09:57:22 +0800
Message-ID: <CAAM7YA=RC84igiJY8qRgBhkdcEwQkTaxokHz6XN2MeKt9kTRQg@mail.gmail.com>
Subject: Re: [PATCH] modify the mode of req from USE_ANY_MDS to USE_AUTH_MDS
 to reduce the cache size of mds and forward op.
To:     simon gao <simon29rock@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I think it's better to add a mount option (not enable by default) for
this change

On Fri, Sep 6, 2019 at 1:02 AM simon gao <simon29rock@gmail.com> wrote:
>
> ---
>  fs/ceph/dir.c        | 4 ++--
>  fs/ceph/export.c     | 8 ++++----
>  fs/ceph/file.c       | 2 +-
>  fs/ceph/inode.c      | 2 +-
>  fs/ceph/mds_client.c | 1 +
>  fs/ceph/super.c      | 2 +-
>  6 files changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 4ca0b8f..a441b8d 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -771,7 +771,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
>
>         op = ceph_snap(dir) == CEPH_SNAPDIR ?
>                 CEPH_MDS_OP_LOOKUPSNAP : CEPH_MDS_OP_LOOKUP;
> -       req = ceph_mdsc_create_request(mdsc, op, USE_ANY_MDS);
> +       req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
>         if (IS_ERR(req))
>                 return ERR_CAST(req);
>         req->r_dentry = dget(dentry);
> @@ -1600,7 +1600,7 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
>
>                 op = ceph_snap(dir) == CEPH_SNAPDIR ?
>                         CEPH_MDS_OP_LOOKUPSNAP : CEPH_MDS_OP_LOOKUP;
> -               req = ceph_mdsc_create_request(mdsc, op, USE_ANY_MDS);
> +               req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
>                 if (!IS_ERR(req)) {
>                         req->r_dentry = dget(dentry);
>                         req->r_num_caps = 2;
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index 15ff1b0..a7d5174 100644
> --- a/fs/ceph/export.c
> +++ b/fs/ceph/export.c
> @@ -135,7 +135,7 @@ static struct inode *__lookup_inode(struct super_block *sb, u64 ino)
>                 int mask;
>
>                 req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPINO,
> -                                              USE_ANY_MDS);
> +                                              USE_AUTH_MDS);
>                 if (IS_ERR(req))
>                         return ERR_CAST(req);
>
> @@ -210,7 +210,7 @@ static struct dentry *__snapfh_to_dentry(struct super_block *sb,
>                 return d_obtain_alias(inode);
>
>         req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPINO,
> -                                      USE_ANY_MDS);
> +                                      USE_AUTH_MDS);
>         if (IS_ERR(req))
>                 return ERR_CAST(req);
>
> @@ -294,7 +294,7 @@ static struct dentry *__get_parent(struct super_block *sb,
>         int err;
>
>         req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPPARENT,
> -                                      USE_ANY_MDS);
> +                                      USE_AUTH_MDS);
>         if (IS_ERR(req))
>                 return ERR_CAST(req);
>
> @@ -509,7 +509,7 @@ static int ceph_get_name(struct dentry *parent, char *name,
>
>         mdsc = ceph_inode_to_client(inode)->mdsc;
>         req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPNAME,
> -                                      USE_ANY_MDS);
> +                                      USE_AUTH_MDS);
>         if (IS_ERR(req))
>                 return PTR_ERR(req);
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 685a03c..79533f2 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -182,7 +182,7 @@ static void put_bvecs(struct bio_vec *bvecs, int num_bvecs, bool should_dirty)
>         struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
>         struct ceph_mds_client *mdsc = fsc->mdsc;
>         struct ceph_mds_request *req;
> -       int want_auth = USE_ANY_MDS;
> +       int want_auth = USE_AUTH_MDS;
>         int op = (flags & O_CREAT) ? CEPH_MDS_OP_CREATE : CEPH_MDS_OP_OPEN;
>
>         if (flags & (O_WRONLY|O_RDWR|O_CREAT|O_TRUNC))
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 18500ede..6c67548 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2247,7 +2247,7 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
>         if (!force && ceph_caps_issued_mask(ceph_inode(inode), mask, 1))
>                 return 0;
>
> -       mode = (mask & CEPH_STAT_RSTAT) ? USE_AUTH_MDS : USE_ANY_MDS;
> +       mode = USE_AUTH_MDS;
>         req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, mode);
>         if (IS_ERR(req))
>                 return PTR_ERR(req);
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 920e9f0..acfb969 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -867,6 +867,7 @@ static struct inode *get_nonsnap_parent(struct dentry *dentry)
>         return inode;
>  }
>
> +static struct inode *get_parent()
>  /*
>   * Choose mds to send request to next.  If there is a hint set in the
>   * request (e.g., due to a prior forward hint from the mds), use that.
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index ab4868c..517e605 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -867,7 +867,7 @@ static struct dentry *open_root_dentry(struct ceph_fs_client *fsc,
>
>         /* open dir */
>         dout("open_root_inode opening '%s'\n", path);
> -       req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, USE_ANY_MDS);
> +       req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, USE_AUTH_MDS);
>         if (IS_ERR(req))
>                 return ERR_CAST(req);
>         req->r_path1 = kstrdup(path, GFP_NOFS);
> --
> 1.8.3.1
>
