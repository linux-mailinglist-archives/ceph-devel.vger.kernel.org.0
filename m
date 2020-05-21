Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E126D1DC8F5
	for <lists+ceph-devel@lfdr.de>; Thu, 21 May 2020 10:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgEUIp7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 May 2020 04:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728389AbgEUIp7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 21 May 2020 04:45:59 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0761CC061A0E
        for <ceph-devel@vger.kernel.org>; Thu, 21 May 2020 01:45:58 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id f89so2723423qva.3
        for <ceph-devel@vger.kernel.org>; Thu, 21 May 2020 01:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ag5H4nYBgzWT3f9xHsNr7WhAiXOdgWe5ZMLqkQ9ASuo=;
        b=WbAde/VxsDCx5bRmL4OAx5TM35nOM8lLJCgJp9C/3G+/n4RDtCye0KsVVqQxWrAskG
         VjuLhQee/YW9tuETQW6ky9FOgbONPAMWago2wJQEn3Bhkg2eNEHoXPYsFhTaiGSukI8g
         oT16hUCLQ32zQVYy4NtbUAVHvymqFtszgkkszE142Ym77KpA6mCrwd9gVYBFwbXR3wNK
         0qGhW4+haOX5ED3yODn6ViquZv+k8OxLERGziaGIKnspJPfVWdUZfTe/NiXulh6+48fC
         6OMCwCyHxSKQLuYFUIsngRDc8f/94KFSk7L7J0z6QBMGMK4Jdc3v8q3pk5ayK3Fpf7ZD
         jr2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ag5H4nYBgzWT3f9xHsNr7WhAiXOdgWe5ZMLqkQ9ASuo=;
        b=VqifbLS0rrA4g6oG3Z2gMRXJSegNmkvrkwB3uYcOawYLeYGT2Ds6HjCa7Hk/1vHwC9
         WfoKeJXaEpgod21hcaV1oBsF/AQ9VJ3TK4BcPvnn0dyoTGWWfAGO4buTvB1474nRy1JY
         TtQXVo2B1imDiyORg9JUm0ita1/Ms7AJZMxYlShpHId6qn25eFA5Ip92LEVFyeow/eOZ
         222kgz+Cm0ZD6/5b5GGBSM8y3E1IqHxFqDTN2qV3jrW56cA4TPkBnRf11HQ0lKNc+eBU
         dvf7lzQVkhxuIqm4lee86lnP1I8ky0PpWSoGIEng8fcT/HKY024/O1dwuuE+MJq0q3oT
         Vwgg==
X-Gm-Message-State: AOAM5306f9JZtgvl8T8YBZvufHKv5WNWzWdwWSBa81PtVQzMzT+TfkGo
        DXEXsGqqxKZGuFjdtwG0Qj6LEgcfWb2qHYVtYHg=
X-Google-Smtp-Source: ABdhPJyHeKGl/nyqXHEEEDQqkOTEIy6Mekg2G/UvSal9l60lmIX+u4gZlBFn0KLy5nuuH1ZoR8rU8LbnKfbo/XtnbBs=
X-Received: by 2002:a05:6214:1594:: with SMTP id m20mr238020qvw.110.1590050757196;
 Thu, 21 May 2020 01:45:57 -0700 (PDT)
MIME-Version: 1.0
References: <1590046576-1262-1-git-send-email-xiubli@redhat.com>
In-Reply-To: <1590046576-1262-1-git-send-email-xiubli@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 21 May 2020 16:45:45 +0800
Message-ID: <CAAM7YAmoCHXB1fLSXt0fqOczqbm9s_2yfWbyAaaMuQRCNR5+3Q@mail.gmail.com>
Subject: Re: [PATCH] ceph: add ceph_async_check_caps() to avoid double lock
 and deadlock
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Zheng Yan <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, May 21, 2020 at 3:39 PM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> In the ceph_check_caps() it may call the session lock/unlock stuff.
>
> There have some deadlock cases, like:
> handle_forward()
> ...
> mutex_lock(&mdsc->mutex)
> ...
> ceph_mdsc_put_request()
>   --> ceph_mdsc_release_request()
>     --> ceph_put_cap_request()
>       --> ceph_put_cap_refs()
>         --> ceph_check_caps()
> ...
> mutex_unlock(&mdsc->mutex)

For this case, it's better to call ceph_mdsc_put_request() after
unlock mdsc->mutex
>
> And also there maybe has some double session lock cases, like:
>
> send_mds_reconnect()
> ...
> mutex_lock(&session->s_mutex);
> ...
>   --> replay_unsafe_requests()
>     --> ceph_mdsc_release_dir_caps()
>       --> ceph_put_cap_refs()
>         --> ceph_check_caps()
> ...
> mutex_unlock(&session->s_mutex);

There is no point to check_caps() and send cap message while
reconnecting caps. So I think it's better to just skip calling
ceph_check_caps() for this case.

Regards
Yan, Zheng

>
> URL: https://tracker.ceph.com/issues/45635
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c  |  2 +-
>  fs/ceph/inode.c | 10 ++++++++++
>  fs/ceph/super.h | 12 ++++++++++++
>  3 files changed, 23 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 27c2e60..08194c4 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3073,7 +3073,7 @@ void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
>              last ? " last" : "", put ? " put" : "");
>
>         if (last)
> -               ceph_check_caps(ci, 0, NULL);
> +               ceph_async_check_caps(ci);
>         else if (flushsnaps)
>                 ceph_flush_snaps(ci, NULL);
>         if (wake)
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 357c937..84a61d4 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -35,6 +35,7 @@
>  static const struct inode_operations ceph_symlink_iops;
>
>  static void ceph_inode_work(struct work_struct *work);
> +static void ceph_check_caps_work(struct work_struct *work);
>
>  /*
>   * find or create an inode, given the ceph ino number
> @@ -518,6 +519,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
>         INIT_LIST_HEAD(&ci->i_snap_flush_item);
>
>         INIT_WORK(&ci->i_work, ceph_inode_work);
> +       INIT_WORK(&ci->check_caps_work, ceph_check_caps_work);
>         ci->i_work_mask = 0;
>         memset(&ci->i_btime, '\0', sizeof(ci->i_btime));
>
> @@ -2012,6 +2014,14 @@ static void ceph_inode_work(struct work_struct *work)
>         iput(inode);
>  }
>
> +static void ceph_check_caps_work(struct work_struct *work)
> +{
> +       struct ceph_inode_info *ci = container_of(work, struct ceph_inode_info,
> +                                                 check_caps_work);
> +
> +       ceph_check_caps(ci, 0, NULL);
> +}
> +
>  /*
>   * symlinks
>   */
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 226f19c..96d0e41 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -421,6 +421,8 @@ struct ceph_inode_info {
>         struct timespec64 i_btime;
>         struct timespec64 i_snap_btime;
>
> +       struct work_struct check_caps_work;
> +
>         struct work_struct i_work;
>         unsigned long  i_work_mask;
>
> @@ -1102,6 +1104,16 @@ extern void ceph_flush_snaps(struct ceph_inode_info *ci,
>  extern bool __ceph_should_report_size(struct ceph_inode_info *ci);
>  extern void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>                             struct ceph_mds_session *session);
> +static void inline
> +ceph_async_check_caps(struct ceph_inode_info *ci)
> +{
> +       struct inode *inode = &ci->vfs_inode;
> +
> +       /* It's okay if queue_work fails */
> +       queue_work(ceph_inode_to_client(inode)->inode_wq,
> +                  &ceph_inode(inode)->check_caps_work);
> +}
> +
>  extern void ceph_check_delayed_caps(struct ceph_mds_client *mdsc);
>  extern void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc);
>  extern int  ceph_drop_caps_for_unlink(struct inode *inode);
> --
> 1.8.3.1
>
