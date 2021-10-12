Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8924042ABDB
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Oct 2021 20:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbhJLS1j (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 12 Oct 2021 14:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232281AbhJLS1i (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 12 Oct 2021 14:27:38 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29B1C061570
        for <ceph-devel@vger.kernel.org>; Tue, 12 Oct 2021 11:25:36 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id h19so409085uax.5
        for <ceph-devel@vger.kernel.org>; Tue, 12 Oct 2021 11:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lPA9NNeLsEJPfEqmHxArKC9DXxXrXBL0QllzqmtawBQ=;
        b=MUCV6OKhXRuqROCgquoAoW9zCeN2okIGs9SudXUlVzMUjXjcmrqInRMmGUrd7WcWdq
         tchxKyT3pbUGyag4svaYTSuC+sqzvg6o1V6PzspB9c+cws1JDHAUYSfNz6PSneC2mEUp
         FcT/h8ONdwnHcxyDLR/MhzAckase3cKvGr8Wlx4jKIVNc+AgEto3ewyfMdrFLVoAb/Jj
         eWAylkV5bcZWe8sfDHFHXAIt+rEa/PZVcOD7wTL8udthTgWo/EEFCQviAoj/HFbPyJ39
         idL1ohYrU2UujjdH2ox6xC5e+UDtkWlPfPLUvkT9x0RwWsFNWDkqy+RmUnhQl4B91R4r
         K91g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lPA9NNeLsEJPfEqmHxArKC9DXxXrXBL0QllzqmtawBQ=;
        b=8DJ3jFp0iarCMexcUt5zcVwrJKxILbvAxAdrkwdf6ORkXO/zSz4eb5C5DcGHd4GnHo
         wAXq69vmJJ8VvK11rXp4uYNVk9ACbgE0uWXDH59X6dx9Q9dVpKLoyCO7ERyoQPjEDBTP
         zr3jIfNYbKHBdUf0rcSdTEY1qKN9Hh6AYQB/X5Y72LjnFg99j8Bu6d4scc/bZ/rBjZRH
         Q2v604ShdRqaDwlRzRXGAB3paLamtGN0gsN6QxJYwMtJ+dVab/wIF102210Zyr9btEXR
         8vBeA5AS0cZ3YhOGi6KQ0J01qCt3OYWXglFvkw7K9Nochrrh0yigvqDajKmrM2NnRVRt
         cwzQ==
X-Gm-Message-State: AOAM533iTRO2xE21BRXQYbhilHwLK7BnmOTmUlxB7sVXcXnUVMdUrBzb
        qnOXPotTHn3x5BPcCTUgLPRDMnXOJT3awhSDlw8=
X-Google-Smtp-Source: ABdhPJxyH0Eh1nDOGScPAVO+2PPvE4QmIA67vZvaWxHGCYSzc9e2d3zVXZLLZRBDVPPxtgRCRp4qqYyXiUREyYNNSQ8=
X-Received: by 2002:a05:6102:824:: with SMTP id k4mr4417328vsb.45.1634063135968;
 Tue, 12 Oct 2021 11:25:35 -0700 (PDT)
MIME-Version: 1.0
References: <20211007185907.122326-1-jlayton@kernel.org>
In-Reply-To: <20211007185907.122326-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 12 Oct 2021 20:25:03 +0200
Message-ID: <CAOi1vP-eN1_WXALV-Swuvpz-8XXRztrBA26mYbPuuWwm0Y0f1w@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix handling of "meta" errors on ceph
To:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Oct 7, 2021 at 8:59 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Currently, we check the wb_err too early for directories, before all of
> the unsafe child requests have been waited on. In order to fix that we
> need to check the mapping->wb_err later nearer to the end of ceph_fsync.
>
> We also have an overly-complex method for tracking errors after
> blocklisting. The errors recorded in cleanup_session_requests go to a
> completely separate field in the inode, but we end up reporting them the
> same way we would for any other error (in fsync).
>
> There's no real benefit to tracking these errors in two different
> places, since the only reporting mechanism for them is in fsync, and
> we'd need to advance them both every time.
>
> Given that, we can just remove i_meta_err, and convert the places that
> used it to instead just use mapping->wb_err instead. That also fixes
> the original problem by ensuring that we do a check_and_advance of the
> wb_err at the end of the fsync op.
>
> URL: https://tracker.ceph.com/issues/52864
> Reported-by: Patrick Donnelly <pdonnell@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c       | 14 ++++----------
>  fs/ceph/file.c       |  1 -
>  fs/ceph/inode.c      |  2 --
>  fs/ceph/mds_client.c | 15 ++++-----------
>  fs/ceph/super.h      |  3 ---
>  5 files changed, 8 insertions(+), 27 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index cdeb5b2d7920..21268d2c6e56 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2331,7 +2331,6 @@ static int unsafe_request_wait(struct inode *inode)
>
>  int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>  {
> -       struct ceph_file_info *fi = file->private_data;
>         struct inode *inode = file->f_mapping->host;
>         struct ceph_inode_info *ci = ceph_inode(inode);
>         u64 flush_tid;
> @@ -2366,14 +2365,9 @@ int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>         if (err < 0)
>                 ret = err;
>
> -       if (errseq_check(&ci->i_meta_err, READ_ONCE(fi->meta_err))) {
> -               spin_lock(&file->f_lock);
> -               err = errseq_check_and_advance(&ci->i_meta_err,
> -                                              &fi->meta_err);
> -               spin_unlock(&file->f_lock);
> -               if (err < 0)
> -                       ret = err;
> -       }
> +       err = file_check_and_advance_wb_err(file);
> +       if (err < 0)
> +               ret = err;
>  out:
>         dout("fsync %p%s result=%d\n", inode, datasync ? " datasync" : "", ret);
>         return ret;
> @@ -4663,7 +4657,7 @@ int ceph_purge_inode_cap(struct inode *inode, struct ceph_cap *cap, bool *invali
>                 spin_unlock(&mdsc->cap_dirty_lock);
>
>                 if (dirty_dropped) {
> -                       errseq_set(&ci->i_meta_err, -EIO);
> +                       mapping_set_error(inode->i_mapping, -EIO);
>
>                         if (ci->i_wrbuffer_ref_head == 0 &&
>                             ci->i_wr_ref == 0 &&
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index d20785285d26..91173d3aa161 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -233,7 +233,6 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
>
>         spin_lock_init(&fi->rw_contexts_lock);
>         INIT_LIST_HEAD(&fi->rw_contexts);
> -       fi->meta_err = errseq_sample(&ci->i_meta_err);
>         fi->filp_gen = READ_ONCE(ceph_inode_to_client(inode)->filp_gen);
>
>         return 0;
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 23b5a0867e3a..00c73242c4bf 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -542,8 +542,6 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
>
>         ceph_fscache_inode_init(ci);
>
> -       ci->i_meta_err = 0;
> -
>         return &ci->vfs_inode;
>  }
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 279462482416..598425ccd020 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1493,7 +1493,6 @@ static void cleanup_session_requests(struct ceph_mds_client *mdsc,
>  {
>         struct ceph_mds_request *req;
>         struct rb_node *p;
> -       struct ceph_inode_info *ci;
>
>         dout("cleanup_session_requests mds%d\n", session->s_mds);
>         mutex_lock(&mdsc->mutex);
> @@ -1502,16 +1501,10 @@ static void cleanup_session_requests(struct ceph_mds_client *mdsc,
>                                        struct ceph_mds_request, r_unsafe_item);
>                 pr_warn_ratelimited(" dropping unsafe request %llu\n",
>                                     req->r_tid);
> -               if (req->r_target_inode) {
> -                       /* dropping unsafe change of inode's attributes */
> -                       ci = ceph_inode(req->r_target_inode);
> -                       errseq_set(&ci->i_meta_err, -EIO);
> -               }
> -               if (req->r_unsafe_dir) {
> -                       /* dropping unsafe directory operation */
> -                       ci = ceph_inode(req->r_unsafe_dir);
> -                       errseq_set(&ci->i_meta_err, -EIO);
> -               }
> +               if (req->r_target_inode)
> +                       mapping_set_error(req->r_target_inode->i_mapping, -EIO);
> +               if (req->r_unsafe_dir)
> +                       mapping_set_error(req->r_unsafe_dir->i_mapping, -EIO);
>                 __unregister_request(mdsc, req);
>         }
>         /* zero r_attempts, so kick_requests() will re-send requests */
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 8aa39bab2d72..d730e508159f 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -435,8 +435,6 @@ struct ceph_inode_info {
>  #ifdef CONFIG_CEPH_FSCACHE
>         struct fscache_cookie *fscache;
>  #endif
> -       errseq_t i_meta_err;
> -
>         struct inode vfs_inode; /* at end */
>  };
>
> @@ -781,7 +779,6 @@ struct ceph_file_info {
>         spinlock_t rw_contexts_lock;
>         struct list_head rw_contexts;
>
> -       errseq_t meta_err;
>         u32 filp_gen;
>         atomic_t num_locks;
>  };
> --
> 2.31.1
>

Hi Xiubo,

Could you please review this one?

Thanks,

                Ilya
