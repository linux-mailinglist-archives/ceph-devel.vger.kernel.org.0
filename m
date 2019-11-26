Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2BB71099A3
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Nov 2019 08:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfKZHlk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Nov 2019 02:41:40 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35062 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfKZHlj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 26 Nov 2019 02:41:39 -0500
Received: by mail-qt1-f194.google.com with SMTP id n4so20429853qte.2
        for <ceph-devel@vger.kernel.org>; Mon, 25 Nov 2019 23:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KxHNgfy/39KbRoDR/h/DDVFutEiDFlLU+wvr17btFv0=;
        b=cZ6LIns5kG/IMXcHXeT2rq04gUZ1cWZwNtY5DWtURqDlZbpHs+gWGxRKN3/oeIc/ds
         CVyqG2ZStNOu+Q5GV0/HlrMbRYj7LoipK9QNoQNxuvDQo9wLSeUvv+iR33zw2LQUwrlN
         awgv2Nu3ZaKkfQ71F+54HT8J2/adxHdKqZebWjYNZrvR/v37nAFKdUE0DX1v2ox3WOvH
         mBXZJb2EEIE9XchGfl8DJc/frryt0hOuKWB/TcIbbbsXDc+E5jy/8TBRNUdElWsw7c8P
         4O130ue44a7BJX51t04drzbkAB67b280aVUZsQU0Pn7gOHtkeNaHXPYybKL47JKfmGlA
         UD1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KxHNgfy/39KbRoDR/h/DDVFutEiDFlLU+wvr17btFv0=;
        b=ar6hav9arzoegP47N/SwQonWZXdgfYQsCsq4pjTA7icDiDNlS2fMT68E0aHHX08P41
         DZGOfZFRi9F4dnn/BFGug+gm6kme5aLA3SJwBzuEPV/6oqFMylTUoqqtLW4yupXkD6+4
         FbPAbuFQljXVd4koBMIy2fqPyw2mtJoj8dpWzvLlEnsSE/TuhrDrJBAo0aMWZ9Lo5o6O
         boCREnKUN83nWnaI3t38bfewImXNb8Y2eCYExENfpd8tDpu39Mk8rAFwlvMTXvoJEhQD
         it2YrH6e2TauLbmPzloMn/tZ7RKj/0xQ2N2LBcUciVq9OygQGggJcUhP87VIVfqMlbTi
         R8XA==
X-Gm-Message-State: APjAAAXTg5SGatPCnBjH+dyshnBKe0UJ6OpeMf0bdagk+D8A5Nv8ZLtH
        rY0A+KBjhL12VTr5PDp9OHqB74eyvcpI91L8BgERITiYBDG8nw==
X-Google-Smtp-Source: APXvYqxgZzuo8yI6/mhgiXLa4fCpfU4RKtbVJepF6p/sEphxGa8mN4NpT/HfSXn7UhfuXEUh1fNm1/lgKGEDIvCdEn0=
X-Received: by 2002:ac8:7612:: with SMTP id t18mr21757608qtq.143.1574754098372;
 Mon, 25 Nov 2019 23:41:38 -0800 (PST)
MIME-Version: 1.0
References: <20191125151732.139754-1-jlayton@kernel.org>
In-Reply-To: <20191125151732.139754-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 26 Nov 2019 15:41:27 +0800
Message-ID: <CAAM7YAk5Q+Ak++kbEpwvqi=K3j1TJevOH090adXNC9Tzvk5qXg@mail.gmail.com>
Subject: Re: [PATCH] ceph: show tasks waiting on caps in debugfs caps file
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Nov 25, 2019 at 11:21 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Display the tgid of the waiting task, plus inode number, and the
> caps we need and want.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c       | 17 +++++++++++++++++
>  fs/ceph/debugfs.c    | 13 +++++++++++++
>  fs/ceph/mds_client.c |  1 +
>  fs/ceph/mds_client.h |  9 +++++++++
>  4 files changed, 40 insertions(+)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index f5a38910a82b..271d8283d263 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2764,7 +2764,19 @@ int ceph_get_caps(struct file *filp, int need, int want,
>                 if (ret == -EAGAIN)
>                         continue;
>                 if (!ret) {
> +                       struct ceph_mds_client *mdsc = fsc->mdsc;
> +                       struct cap_wait cw;
>                         DEFINE_WAIT_FUNC(wait, woken_wake_function);
> +
> +                       cw.ino = inode->i_ino;
> +                       cw.tgid = current->tgid;
> +                       cw.need = need;
> +                       cw.want = want;
> +
> +                       spin_lock(&mdsc->caps_list_lock);
> +                       list_add(&cw.list, &mdsc->cap_wait_list);
> +                       spin_unlock(&mdsc->caps_list_lock);
> +
>                         add_wait_queue(&ci->i_cap_wq, &wait);
>
>                         flags |= NON_BLOCKING;
> @@ -2778,6 +2790,11 @@ int ceph_get_caps(struct file *filp, int need, int want,
>                         }
>
>                         remove_wait_queue(&ci->i_cap_wq, &wait);
> +
> +                       spin_lock(&mdsc->caps_list_lock);
> +                       list_del(&cw.list);
> +                       spin_unlock(&mdsc->caps_list_lock);
> +
>                         if (ret == -EAGAIN)
>                                 continue;
>                 }
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index facb387c2735..c281f32b54f7 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -139,6 +139,7 @@ static int caps_show(struct seq_file *s, void *p)
>         struct ceph_fs_client *fsc = s->private;
>         struct ceph_mds_client *mdsc = fsc->mdsc;
>         int total, avail, used, reserved, min, i;
> +       struct cap_wait *cw;
>
>         ceph_reservation_status(fsc, &total, &avail, &used, &reserved, &min);
>         seq_printf(s, "total\t\t%d\n"
> @@ -166,6 +167,18 @@ static int caps_show(struct seq_file *s, void *p)
>         }
>         mutex_unlock(&mdsc->mutex);
>
> +       seq_printf(s, "\n\nWaiters:\n--------\n");
> +       seq_printf(s, "tgid         ino                need             want\n");
> +       seq_printf(s, "-----------------------------------------------------\n");
> +
> +       spin_lock(&mdsc->caps_list_lock);
> +       list_for_each_entry(cw, &mdsc->cap_wait_list, list) {
> +               seq_printf(s, "%-13d0x%-17lx%-17s%-17s\n", cw->tgid, cw->ino,
> +                               ceph_cap_string(cw->need),
> +                               ceph_cap_string(cw->want));
> +       }
> +       spin_unlock(&mdsc->caps_list_lock);
> +
>         return 0;
>  }
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 890f7f613390..40f9a640481d 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4169,6 +4169,7 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
>         INIT_DELAYED_WORK(&mdsc->delayed_work, delayed_work);
>         mdsc->last_renew_caps = jiffies;
>         INIT_LIST_HEAD(&mdsc->cap_delay_list);
> +       INIT_LIST_HEAD(&mdsc->cap_wait_list);
>         spin_lock_init(&mdsc->cap_delay_lock);
>         INIT_LIST_HEAD(&mdsc->snap_flush_list);
>         spin_lock_init(&mdsc->snap_flush_lock);
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 5cd131b41d84..14c7e8c49970 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -340,6 +340,14 @@ struct ceph_quotarealm_inode {
>         struct inode *inode;
>  };
>
> +struct cap_wait {
> +       struct list_head        list;
> +       unsigned long           ino;
> +       pid_t                   tgid;
> +       int                     need;
> +       int                     want;
> +};
> +
>  /*
>   * mds client state
>   */
> @@ -416,6 +424,7 @@ struct ceph_mds_client {
>         spinlock_t      caps_list_lock;
>         struct          list_head caps_list; /* unused (reserved or
>                                                 unreserved) */
> +       struct          list_head cap_wait_list;
>         int             caps_total_count;    /* total caps allocated */
>         int             caps_use_count;      /* in use */
>         int             caps_use_max;        /* max used caps */
> --
> 2.23.0
>

Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
