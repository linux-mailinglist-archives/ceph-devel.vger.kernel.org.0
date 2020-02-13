Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 990FA15BE4F
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2020 13:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbgBMMPk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Feb 2020 07:15:40 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36434 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbgBMMPk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 13 Feb 2020 07:15:40 -0500
Received: by mail-qt1-f193.google.com with SMTP id t13so4193337qto.3
        for <ceph-devel@vger.kernel.org>; Thu, 13 Feb 2020 04:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aPsQHSo7ks0omO1O+pQhw3QwsCscqh2LoyFgkQudzwA=;
        b=so2PtoWwlWjl7LAW2Wlho+RveuHwEbUL65sRL+Ch1Fk+e4rF6SYcCQTwzhVfloV7BT
         i566GT7FW0DqS4ideXSNc5QHL/qX8qDJeosHvRTlxglHywgnFR+y3BKCzyMMS98YB2/k
         WxJnX843jEdBpvdbhuue+D1HeNiU+bls5VVtmNxlFnbyqnY01nM5tKwMZd/DczDohQIg
         4MdCfPTK54Ij3IZv/JoYWm4bBIHcCuhKkdfa/kXuTTSmTga8m/F2f8l4e5FkW8f3YSlk
         9Ot1rxjLZ4oLS+dQxfl1kk4a5FM4i8w3KcmS74N23kKfcjZti8O0qg5zO6ZU+8UYeoj3
         uCuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aPsQHSo7ks0omO1O+pQhw3QwsCscqh2LoyFgkQudzwA=;
        b=tDVkIleDv54xeBARk3Y5vtmKnO64Cwq/CxLw3/ORjBgCNiNLzNOmRv5c4guYLlUIKf
         yh8AWM4JQ6CQeA5LEWQD+eAAdIGAEEeuKM1dHiq5g3+LlnV9aWTUYSIjukLE20QCqvlz
         jFPlsS3PnDynpzFu/UxcHOn93d+pTlvZXrYc60TK3Egteh1AZxtLSj0WR5Fd6DAQ/kek
         Nu+I2rsf7o8GVpsVVZMNROBL2Q1Rq9RZM3V8eOunCN97YagbgrS2+nP0VEl14JejqeuO
         frwUomIx5ClH94DW6/h5s/vThQvjBTxTkjoRAVIdJGTobtgckCB5tUELdVWwD/6AAk41
         j4MA==
X-Gm-Message-State: APjAAAWYm4ZXfkAQ+KJoMjuxbvTsjypwMJRv+/iZ4SvxL/hYc56jvX7U
        ZBxZ6dxoiLB+RDAr0LfqCW6N8qRX0ds8x4hPma0=
X-Google-Smtp-Source: APXvYqxS+7iJkrwNaFCfnCbTB0F2tZMgM9RnXSEQdoy0DqUaczaz5ANocN+8dkSmS6m4gG6vtyZffl6SnaY+ogtPedg=
X-Received: by 2002:ac8:602:: with SMTP id d2mr11539179qth.245.1581596139311;
 Thu, 13 Feb 2020 04:15:39 -0800 (PST)
MIME-Version: 1.0
References: <20200212172729.260752-1-jlayton@kernel.org> <20200212172729.260752-7-jlayton@kernel.org>
In-Reply-To: <20200212172729.260752-7-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 13 Feb 2020 20:15:27 +0800
Message-ID: <CAAM7YA=_L_yu86V4MtwRFy_swfoWTwBzCk_O2wH5nTati2hBcQ@mail.gmail.com>
Subject: Re: [PATCH v4 6/9] ceph: add infrastructure for waiting for async
 create to complete
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, idridryomov@gmail.com,
        Sage Weil <sage@redhat.com>, Zheng Yan <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Feb 13, 2020 at 1:30 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> When we issue an async create, we must ensure that any later on-the-wire
> requests involving it wait for the create reply.
>
> Expand i_ceph_flags to be an unsigned long, and add a new bit that
> MDS requests can wait on. If the bit is set in the inode when sending
> caps, then don't send it and just return that it has been delayed.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c       | 13 ++++++++++++-
>  fs/ceph/dir.c        |  2 +-
>  fs/ceph/mds_client.c | 18 ++++++++++++++++++
>  fs/ceph/mds_client.h |  8 ++++++++
>  fs/ceph/super.h      |  4 +++-
>  5 files changed, 42 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index c983990acb75..869e2102e827 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -511,7 +511,7 @@ static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
>                                 struct ceph_inode_info *ci,
>                                 bool set_timeout)
>  {
> -       dout("__cap_delay_requeue %p flags %d at %lu\n", &ci->vfs_inode,
> +       dout("__cap_delay_requeue %p flags 0x%lx at %lu\n", &ci->vfs_inode,
>              ci->i_ceph_flags, ci->i_hold_caps_max);
>         if (!mdsc->stopping) {
>                 spin_lock(&mdsc->cap_delay_lock);
> @@ -1298,6 +1298,13 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
>         int delayed = 0;
>         int ret;
>
> +       /* Don't send anything if it's still being created. Return delayed */
> +       if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
> +               spin_unlock(&ci->i_ceph_lock);
> +               dout("%s async create in flight for %p\n", __func__, inode);
> +               return 1;
> +       }
> +
>         held = cap->issued | cap->implemented;
>         revoking = cap->implemented & ~cap->issued;
>         retain &= ~revoking;
> @@ -2257,6 +2264,10 @@ int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>         if (datasync)
>                 goto out;
>
> +       ret = ceph_wait_on_async_create(inode);
> +       if (ret)
> +               goto out;
> +

fsync on directory does not consider async create/unlink?

>         dirty = try_flush_caps(inode, &flush_tid);
>         dout("fsync dirty caps are %s\n", ceph_cap_string(dirty));
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 46314ccf48c5..4e695f2a9347 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -752,7 +752,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
>                 struct ceph_dentry_info *di = ceph_dentry(dentry);
>
>                 spin_lock(&ci->i_ceph_lock);
> -               dout(" dir %p flags are %d\n", dir, ci->i_ceph_flags);
> +               dout(" dir %p flags are 0x%lx\n", dir, ci->i_ceph_flags);
>                 if (strncmp(dentry->d_name.name,
>                             fsc->mount_options->snapdir_name,
>                             dentry->d_name.len) &&
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 91c5f999da7d..314dd0f6f5a9 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2829,6 +2829,24 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
>                 ceph_get_cap_refs(ceph_inode(req->r_old_dentry_dir),
>                                   CEPH_CAP_PIN);
>
> +       if (req->r_inode) {
> +               err = ceph_wait_on_async_create(req->r_inode);
> +               if (err) {
> +                       dout("%s: wait for async create returned: %d\n",
> +                            __func__, err);
> +                       return err;
> +               }
> +       }
> +
> +       if (req->r_old_inode) {
> +               err = ceph_wait_on_async_create(req->r_old_inode);
> +               if (err) {
> +                       dout("%s: wait for async create returned: %d\n",
> +                            __func__, err);
> +                       return err;
> +               }
> +       }
> +
>         dout("submit_request on %p for inode %p\n", req, dir);
>         mutex_lock(&mdsc->mutex);
>         __register_request(mdsc, req, dir);
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 31f68897bc87..acad9adca0af 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -543,4 +543,12 @@ extern int ceph_trim_caps(struct ceph_mds_client *mdsc,
>                           int max_caps);
>
>  extern u64 ceph_get_deleg_ino(struct ceph_mds_session *session);
> +
> +static inline int ceph_wait_on_async_create(struct inode *inode)
> +{
> +       struct ceph_inode_info *ci = ceph_inode(inode);
> +
> +       return wait_on_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT,
> +                          TASK_INTERRUPTIBLE);
> +}
>  #endif
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index ea68eef977ef..47fb6e022339 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -319,7 +319,7 @@ struct ceph_inode_info {
>         u64 i_inline_version;
>         u32 i_time_warp_seq;
>
> -       unsigned i_ceph_flags;
> +       unsigned long i_ceph_flags;
>         atomic64_t i_release_count;
>         atomic64_t i_ordered_count;
>         atomic64_t i_complete_seq[2];
> @@ -527,6 +527,8 @@ static inline struct inode *ceph_find_inode(struct super_block *sb,
>  #define CEPH_I_ERROR_WRITE     (1 << 10) /* have seen write errors */
>  #define CEPH_I_ERROR_FILELOCK  (1 << 11) /* have seen file lock errors */
>  #define CEPH_I_ODIRECT         (1 << 12) /* inode in direct I/O mode */
> +#define CEPH_ASYNC_CREATE_BIT  (13)      /* async create in flight for this */
> +#define CEPH_I_ASYNC_CREATE    (1 << CEPH_ASYNC_CREATE_BIT)
>
>  /*
>   * Masks of ceph inode work.
> --
> 2.24.1
>
