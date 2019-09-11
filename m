Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04508AF491
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2019 04:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfIKC6V (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Sep 2019 22:58:21 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43567 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfIKC6V (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Sep 2019 22:58:21 -0400
Received: by mail-qt1-f194.google.com with SMTP id l22so23395422qtp.10
        for <ceph-devel@vger.kernel.org>; Tue, 10 Sep 2019 19:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DeshPB3WrW48OwEjC4OwavUcTWiMc2mHnlICphuUMoA=;
        b=WzDItRVXg2w53FKA0HKE/o5+jHyCB+ZB05N27Fl1O2FN9lbl3kW85IAiBOH+6Ej460
         7ktYHVaN9j2+MrfgwjoGkP9Y+nbQcItnOenQlJpFMpb4NgCdb2l2wMx35kUehq2KZ37e
         IMk0ZUhCd/GPIhbbuD7AmzfSi8bVhDfXF844BD5xKMqFeFD6qjGTSATai2qPR4Ub1jFo
         cFSE/pFq/0KPkR41fL3y7yW0n2fCSEXTep+O4T1CdxVZHrdSFrqHbsc+d0XPa5eNWOJy
         VlizYYnLXllpwbOfbhz7AOVurOTedwP7UWaYzcVKs1+iFrcZsd25Nyj5zmj9Eh7r8C0j
         ZKGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DeshPB3WrW48OwEjC4OwavUcTWiMc2mHnlICphuUMoA=;
        b=h4LtY/M/mmSoYQq2sxdTLSYebA35hpV3AqCBkUz6Yjg21mgYcmtIFgJ/r/DB6Sp9Iw
         O01sEQB28ulN/ehkwiXiV4PoJ9zejQiZXnUVkAgq4Y5Arb5KvfephKEZBRYtCs/q3ChE
         RmScSszd77f0CG6axymXPJvB4rmjXjQ3kUpLCMabqitUPtU+BN4ZdMh8mB2Ie46QUTJQ
         205Yq722oEV9fyo4h5sXtChKCgOVhwxfkHzGAbYrfNCW7b6wUc00LB4rDeJxHnfuKoD9
         qSt2fLFaX1OICChWYSwSQUKwQtfInFY/enaQzWxX4SnwWB5WLuwuRtSAGYbbA8ArhdVW
         LsTg==
X-Gm-Message-State: APjAAAXhtfYfyQJf9g5TOjj3auY+tdNpL1X7hLqygnDuA+LDYPqyIfQ1
        9CxVsRsMDdgyloYCJqhwrprGN+y8pQ39tySv5pU=
X-Google-Smtp-Source: APXvYqw+shNspyHmO5dT4bJQvfNIK6OQcEmpMzvqhtKMXHwCb8GtnfJsFH3SFmFloj7mziLGZRlUllcYocF+85MdVZw=
X-Received: by 2002:ac8:7951:: with SMTP id r17mr32870012qtt.238.1568170700237;
 Tue, 10 Sep 2019 19:58:20 -0700 (PDT)
MIME-Version: 1.0
References: <1568082511-805-1-git-send-email-simon29rock@gmail.com>
In-Reply-To: <1568082511-805-1-git-send-email-simon29rock@gmail.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Wed, 11 Sep 2019 10:58:09 +0800
Message-ID: <CAAM7YAkzGWwqfRojzmQ1hX_hwF=xgKFHQ-Xfb66Tds0v3iLzSQ@mail.gmail.com>
Subject: Re: [PATCH] add mount opt, always_auth, to force to send req to auth mds
To:     simon gao <simon29rock@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Sep 11, 2019 at 2:46 AM simon gao <simon29rock@gmail.com> wrote:
>
> In larger clusters (hundreds of millions of files). We have to pin the
> directory on a fixed mds now. Some op of client use USE_ANY_MDS mode
> to access mds, which may result in requests being sent to noauth mds
> and then forwarded to authmds.
> the opt is used to reduce forward op.
> ---
>  fs/ceph/mds_client.c | 7 ++++++-
>  fs/ceph/super.c      | 7 +++++++
>  fs/ceph/super.h      | 1 +
>  3 files changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 920e9f0..aca4490 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -878,6 +878,7 @@ static struct inode *get_nonsnap_parent(struct dentry *dentry)
>  static int __choose_mds(struct ceph_mds_client *mdsc,
>                         struct ceph_mds_request *req)
>  {
> +       struct ceph_mount_options *ma = mdsc->fsc->mount_options;
>         struct inode *inode;
>         struct ceph_inode_info *ci;
>         struct ceph_cap *cap;
> @@ -900,7 +901,11 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>
>         if (mode == USE_RANDOM_MDS)
>                 goto random;
> -
> +       // force to send the req to auth mds
> +       if (ma->flags & CEPH_MOUNT_OPT_ALWAYS_AUTH && mode != USE_AUTH_MDS){

use ceph_test_mount_opt(). Otherwise, looks good to me

> +               dout("change mode %d => USE_AUTH_MDS", mode);
> +               mode = USE_AUTH_MDS;
> +       }
>         inode = NULL;
>         if (req->r_inode) {
>                 if (ceph_snap(req->r_inode) != CEPH_SNAPDIR) {
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index ab4868c..1e81ebc 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -169,6 +169,7 @@ enum {
>         Opt_noquotadf,
>         Opt_copyfrom,
>         Opt_nocopyfrom,
> +       Opt_always_auth,
>  };
>
>  static match_table_t fsopt_tokens = {
> @@ -210,6 +211,7 @@ enum {
>         {Opt_noquotadf, "noquotadf"},
>         {Opt_copyfrom, "copyfrom"},
>         {Opt_nocopyfrom, "nocopyfrom"},
> +       {Opt_always_auth, "always_auth"},
>         {-1, NULL}
>  };
>
> @@ -381,6 +383,9 @@ static int parse_fsopt_token(char *c, void *private)
>         case Opt_noacl:
>                 fsopt->sb_flags &= ~SB_POSIXACL;
>                 break;
> +       case Opt_always_auth:
> +               fsopt->flags |= CEPH_MOUNT_OPT_ALWAYS_AUTH;
> +               break;
>         default:
>                 BUG_ON(token);
>         }
> @@ -563,6 +568,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
>                 seq_puts(m, ",nopoolperm");
>         if (fsopt->flags & CEPH_MOUNT_OPT_NOQUOTADF)
>                 seq_puts(m, ",noquotadf");
> +       if (fsopt->flags & CEPH_MOUNT_OPT_ALWAYS_AUTH)
> +               seq_puts(m, ",always_auth");
>
>  #ifdef CONFIG_CEPH_FS_POSIX_ACL
>         if (fsopt->sb_flags & SB_POSIXACL)
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 6b9f1ee..65f6423 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -41,6 +41,7 @@
>  #define CEPH_MOUNT_OPT_MOUNTWAIT       (1<<12) /* mount waits if no mds is up */
>  #define CEPH_MOUNT_OPT_NOQUOTADF       (1<<13) /* no root dir quota in statfs */
>  #define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<14) /* don't use RADOS 'copy-from' op */
> +#define CEPH_MOUNT_OPT_ALWAYS_AUTH     (1<<15) /* send op to auth mds, not to replicative mds */
>
>  #define CEPH_MOUNT_OPT_DEFAULT                 \
>         (CEPH_MOUNT_OPT_DCACHE |                \
> --
> 1.8.3.1
>
