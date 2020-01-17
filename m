Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B81E6140D2C
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Jan 2020 16:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728946AbgAQPBC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 17 Jan 2020 10:01:02 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:44775 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728898AbgAQPBA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 17 Jan 2020 10:01:00 -0500
Received: by mail-io1-f66.google.com with SMTP id b10so26266423iof.11
        for <ceph-devel@vger.kernel.org>; Fri, 17 Jan 2020 07:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8NngNXFpUrsavC6akUwABPW2Vz3lgVD68IB+07uArrc=;
        b=SKNkZLhXFoojizAWKH4/F5+J+NEsHdCIHaN49X6X17NNOtL6YNX7QQOETGOqMc8kpp
         8kD0E7R3PeIsz6JTP2oFchmudNytviUov7uoipNpVv+vA6Zrfwd3IAfLq7nOP3lLI1Np
         AX4kS+RdCrd6KfafpLW0AK5r7sHP6M1+v6NrMk9U5fOU/YVx1hZ3tcw/U/9LqpT3pn2N
         psrXQpRmwb4immDfmrGg/tvjvrWCBKHySJreR8ZBW8W+0hmO4KfTdgSRSNa7WSD1SnTQ
         T7BQ5H6uqVHYb8ryxDn0KCQWr3aI6OJDc+UCygOdvnPziHZa1Tp7K6hG3Ks1Rfn2uoEI
         yfmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8NngNXFpUrsavC6akUwABPW2Vz3lgVD68IB+07uArrc=;
        b=s1aQLvDq9FxF6owUqyTymhULa5niynLhBOGsQnhJpWXCQxbBWyyrOrwXyk2G4UzMyo
         5BJZ4stbjLo+WSTJvjLf4PVjS5bZMErZaOunjQj9ZNyAxSzYsdOvym2k1L7Ap40M5ahY
         gdTn0i7zQq5oDMS25U9SQD2cXK14t76pvL5rntmru/B35VSKgB3ayVEX6Ymj76580pMl
         xYWSe03ELNfEAejp3lv+ZoxXRRNhsNRqsMPaV92yrdB5jg1Zz6UhvosBgZNbZ05q2FVo
         c9xK5JFY3spM3R1djCvfS5UPQ8cDyyxbDIt/RYTYYdvCtVoLJpuQlxIAW80lPvDdFmS5
         spug==
X-Gm-Message-State: APjAAAUbFQ5vYIUFNeJAAlod22Q9bcnRSKmNTXOaJCTJnbhGDnBrocfh
        pps9yJG0STWyw1paFffjYpPYoBP5QhgFLhefBaw=
X-Google-Smtp-Source: APXvYqzq4Q00NRM++UisXG434SufzJjdLcSIrbTXE1yfftN86nkXWOEmVnxBBUEJlJz3APR4BwoeSsrImpWB4eR4PGI=
X-Received: by 2002:a6b:4e0b:: with SMTP id c11mr3320432iob.143.1579273259519;
 Fri, 17 Jan 2020 07:00:59 -0800 (PST)
MIME-Version: 1.0
References: <20200115205912.38688-1-jlayton@kernel.org> <20200115205912.38688-8-jlayton@kernel.org>
In-Reply-To: <20200115205912.38688-8-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 17 Jan 2020 16:00:57 +0100
Message-ID: <CAOi1vP9BgADrLJtsJj-MvxUexSeexfUVXtm3S2xL5nfvBkAs7A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 07/10] ceph: add infrastructure for waiting for
 async create to complete
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Xiubo Li <xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jan 15, 2020 at 9:59 PM Jeff Layton <jlayton@kernel.org> wrote:
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
>  fs/ceph/caps.c       |  9 ++++++++-
>  fs/ceph/dir.c        |  2 +-
>  fs/ceph/mds_client.c | 12 +++++++++++-
>  fs/ceph/super.h      |  4 +++-
>  4 files changed, 23 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index c983990acb75..9d1a3d6831f7 100644
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
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 0d97c2962314..b2bcd01ab4e9 100644
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
> index f06496bb5705..e49ca0533df1 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2806,14 +2806,24 @@ static void kick_requests(struct ceph_mds_client *mdsc, int mds)
>         }
>  }
>
> +static int ceph_wait_on_async_create(struct inode *inode)
> +{
> +       struct ceph_inode_info *ci = ceph_inode(inode);
> +
> +       return wait_on_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT,
> +                          TASK_INTERRUPTIBLE);
> +}
> +
>  int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
>                               struct ceph_mds_request *req)
>  {
>         int err;
>
>         /* take CAP_PIN refs for r_inode, r_parent, r_old_dentry */
> -       if (req->r_inode)
> +       if (req->r_inode) {
> +               ceph_wait_on_async_create(req->r_inode);

This is waiting interruptibly, but ignoring the distinction between
CEPH_ASYNC_CREATE_BIT getting cleared and a signal.  Do we care?  If
not, it deserves a comment (or should ceph_wait_on_async_create() be
void?).

Thanks,

                Ilya
