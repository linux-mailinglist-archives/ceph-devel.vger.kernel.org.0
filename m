Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7D2267F68
	for <lists+ceph-devel@lfdr.de>; Sun, 13 Sep 2020 14:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgIMMAq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 13 Sep 2020 08:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgIMMAp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 13 Sep 2020 08:00:45 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246B8C061573
        for <ceph-devel@vger.kernel.org>; Sun, 13 Sep 2020 05:00:42 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id j2so15729075ioj.7
        for <ceph-devel@vger.kernel.org>; Sun, 13 Sep 2020 05:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/RJFisIhIKxOIfA07vM7ZRGdjJjBzAzIwjsqDLSpcQU=;
        b=So5bHBap5mvnf/5TrjxWkN3irCJtG5/YxVFsQxCRW9Aj+UI6peEmoqHUuNX6R92drw
         s3PeUslkTH9xLW+fMtTE/JkfgFhbgWz6o1t8nUO2K4cL4s4jarselojMMjlVJBMFuMqA
         HJfYOfB/OkjPJIZHZAfpVDbfwmCxv35Zqc4ggYV5VzEQXvPnVHxidDHfoTGOGKEgvHQd
         o0eAQnwW93BODKxMvp2iQJO2/Q8gn0htnKwqIOTLBX/g5mXNxOYvbsBsblms3uRx+cVB
         52GKMHXDVoUB7cOqPftcFMlFwT2tvSS7sRkeezPb7HXldJVVJD6w6kNmAv8jdqBD218L
         1KZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/RJFisIhIKxOIfA07vM7ZRGdjJjBzAzIwjsqDLSpcQU=;
        b=cgiKYFttbG0iLxvPleoov800HqP/8Su75ZaMeBprlomWABvrgL3J9y0uQbqLVMUsyQ
         b1z5TslLvs3wcpc+E9tc4A3iyDjNfxDsFhTx8aFFJSgC+PUqGxEDh1zWfdtTO7AR6Wkc
         Qh+zUIULfQeSddhMuBUd/sBWpqQdSjLeLYdwcw7pYif5Qya7CJ3PclTTab2SfXo0+Qwk
         U53Gfgr1hYLq9vy4zpFza32jO3L/Lj38Pb3dV9qc4v2ykYX1uTfz9zm2aqYmNYW8IPPE
         TH9JeMdWUKTlC0E8Nb7n2szgWgWelDPQTrq1LmD1vBkS0SMO/B1INDpNMcm/sY75lFLI
         0Nng==
X-Gm-Message-State: AOAM531HfVPKq12zavwL8hrv+B10vEdNbZTK/mnG2RvKLb7FOjSO04h8
        NCyEeAa7fV+Gf1BZp4aMO2abPjVJPr++6CF5XDs=
X-Google-Smtp-Source: ABdhPJzvnTHQWbVwW3YQNlq46cce1TC+7IJkaMsbaJym2AQb9zrnUaUUaNaoJfu5qOG8rhiPGjg0H3eUNuOopAfW+ko=
X-Received: by 2002:a02:76d5:: with SMTP id z204mr8735973jab.93.1599998435593;
 Sun, 13 Sep 2020 05:00:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200912101424.5659-1-jlayton@kernel.org>
In-Reply-To: <20200912101424.5659-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Sun, 13 Sep 2020 14:00:25 +0200
Message-ID: <CAOi1vP9=wJNo0vywfBUnGz7qhJegTS=-bRWyqnJ=z7_54A+0vQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: use kill_anon_super helper
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, Sep 12, 2020 at 12:14 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> ceph open-codes this around some other activity and the rationale
> for it isn't clear. There is no need to delay free_anon_bdev until
> the end of kill_sb.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/super.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 7ec0e6d03d10..b3fc9bb61afc 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1205,14 +1205,13 @@ static int ceph_init_fs_context(struct fs_context *fc)
>  static void ceph_kill_sb(struct super_block *s)
>  {
>         struct ceph_fs_client *fsc = ceph_sb_to_client(s);
> -       dev_t dev = s->s_dev;
>
>         dout("kill_sb %p\n", s);
>
>         ceph_mdsc_pre_umount(fsc->mdsc);
>         flush_fs_workqueues(fsc);
>
> -       generic_shutdown_super(s);
> +       kill_anon_super(s);
>
>         fsc->client->extra_mon_dispatch = NULL;
>         ceph_fs_debugfs_cleanup(fsc);
> @@ -1220,7 +1219,6 @@ static void ceph_kill_sb(struct super_block *s)
>         ceph_fscache_unregister_fs(fsc);
>
>         destroy_fs_client(fsc);
> -       free_anon_bdev(dev);
>  }
>
>  static struct file_system_type ceph_fs_type = {
> --
> 2.26.2
>

Hi Jeff,

Just curious, did you attempt to figure out why it used to be
necessary?  Looks like it goes back to a very old commit 5dfc589a8467
("ceph: unregister bdi before kill_anon_super releases device name"),
but it's not obvious to me at first sight...

A lot has changed in the bdi area since then, so if not, it probably
doesn't matter much -- AFAICT bdi would still get unregistered before
the minor number is released with this patch.

Thanks,

                Ilya
