Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5CD3F0282
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Aug 2021 13:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbhHRLU2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Aug 2021 07:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235256AbhHRLU1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 18 Aug 2021 07:20:27 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8787DC061764
        for <ceph-devel@vger.kernel.org>; Wed, 18 Aug 2021 04:19:52 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id d11so2223096ioo.9
        for <ceph-devel@vger.kernel.org>; Wed, 18 Aug 2021 04:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vCDlcUqMAkO3zwC8G4VMIUMDkYnj0faBkJME7DsuS/g=;
        b=UbCJVUfgVV0szJnUU+7XSGZw1GKjrXtsEzvmjfElzMSCBA9nnn45JQBGoGxy2M//ZH
         ZEWkDxHxNGaGoaT2xCGGcqV7PJ0zyFHDvQo1OM0tp2qiAgHmhAv9FePrf0tjcy23+80i
         McFlt+NVciY0nREZj+sehXNiflwKQ0ycrzIOGjdscNChydN8KfQuPU9DVsj40SsWVfnQ
         LBx8klnr/xdjg01weNGDbw0h1lpxcIFOudUIq9cEUZYTD6TgcpLwkpn9FI58Uv0DE3i1
         sDGQ1RDYd2EQ07ZtbS3WrnlEmCHGv/uwn7haFWpKMDlvsRHBfiiRXeENeI1pQNGv1zfi
         kQGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vCDlcUqMAkO3zwC8G4VMIUMDkYnj0faBkJME7DsuS/g=;
        b=WXKtTa4u6sKNEGVCfeK7R4uAzsakUVTEPW/GxgdLwqZFBgWubiBTMBfaTxG8LC6vss
         m0M7RRGuWa3mERFar47lA3q55fI/8gMmG8cQeRAlIFgeanB/vHqDiHIAnYHR+1nfpbEY
         qkw6mmSF/OxhHjxXOltSKGp4Z99VIXpjwEK7FaMEATxLiQ4gUkrou0rP8BnyA8suBCHD
         mjGnIT5Uu2ay273mueRSy/Wvg/Nh6/VMsnM8eAjql+8lZ1njfJfqCm23F+YMDAkQfkBv
         eMP1uGyFD/t5f2+iixl0x6+uMNj24UHqVy5OwlgMNo3W14U3kUsWgjq9JlqUH0z6K+gs
         qs3w==
X-Gm-Message-State: AOAM531yPQHRhKdHcnDvDuu2bPHRG47MByqk3/eKzO1gCpR38017kax0
        SqzxaRB/impt0auIcx8eVcBYz2uTvvQT1VIbkIY=
X-Google-Smtp-Source: ABdhPJx/aqXxiUsTn5HPBi3Gx6knX+MXwksVFuUzapwX5y0Yoe2FpUvEmjvvRzE2MxAkYL3uZ4y/8FsEcN6C25aYTws=
X-Received: by 2002:a5d:9ad0:: with SMTP id x16mr6841225ion.182.1629285591950;
 Wed, 18 Aug 2021 04:19:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210818012515.64564-1-xiubli@redhat.com>
In-Reply-To: <20210818012515.64564-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 18 Aug 2021 13:18:50 +0200
Message-ID: <CAOi1vP96mWo_pOyRX__t6gNhPofdY_HTqe+b8ekM40vjoEmShg@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: correctly release memory from capsnap
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 18, 2021 at 3:25 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> When force umounting, it will try to remove all the session caps.
> If there has any capsnap is in the flushing list, the remove session
> caps callback will try to release the capsnap->flush_cap memory to
> "ceph_cap_flush_cachep" slab cache, while which is allocated from
> kmalloc-256 slab cache.
>
> At the same time switch to list_del_init() because just in case the
> force umount has removed it from the lists and the
> handle_cap_flushsnap_ack() comes then the seconds list_del_init()
> won't crash the kernel.
>
> URL: https://tracker.ceph.com/issues/52283
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V3:
> - rebase to the upstream
>
>
>  fs/ceph/caps.c       | 18 ++++++++++++++----
>  fs/ceph/mds_client.c |  7 ++++---
>  2 files changed, 18 insertions(+), 7 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 1b9ca437da92..e239f06babbc 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1712,7 +1712,16 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
>
>  struct ceph_cap_flush *ceph_alloc_cap_flush(void)
>  {
> -       return kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
> +       struct ceph_cap_flush *cf;
> +
> +       cf = kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
> +       /*
> +        * caps == 0 always means for the capsnap
> +        * caps > 0 means dirty caps being flushed
> +        * caps == -1 means preallocated, not used yet
> +        */

Hi Xiubo,

This comment should be in super.h, on struct ceph_cap_flush
definition.

But more importantly, are you sure that overloading cf->caps this way
is safe?  For example, __kick_flushing_caps() tests for cf->caps != 0
and cf->caps == -1 would be interpreted as a cue to call __prep_cap().

Thanks,

                Ilya

> +       cf->caps = -1;
> +       return cf;
>  }
>
>  void ceph_free_cap_flush(struct ceph_cap_flush *cf)
> @@ -1747,7 +1756,7 @@ static bool __detach_cap_flush_from_mdsc(struct ceph_mds_client *mdsc,
>                 prev->wake = true;
>                 wake = false;
>         }
> -       list_del(&cf->g_list);
> +       list_del_init(&cf->g_list);
>         return wake;
>  }
>
> @@ -1762,7 +1771,7 @@ static bool __detach_cap_flush_from_ci(struct ceph_inode_info *ci,
>                 prev->wake = true;
>                 wake = false;
>         }
> -       list_del(&cf->i_list);
> +       list_del_init(&cf->i_list);
>         return wake;
>  }
>
> @@ -3642,7 +3651,8 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
>                 cf = list_first_entry(&to_remove,
>                                       struct ceph_cap_flush, i_list);
>                 list_del(&cf->i_list);
> -               ceph_free_cap_flush(cf);
> +               if (cf->caps)
> +                       ceph_free_cap_flush(cf);
>         }
>
>         if (wake_ci)
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 1e013fb09d73..a44adbd1841b 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1636,7 +1636,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>                 spin_lock(&mdsc->cap_dirty_lock);
>
>                 list_for_each_entry(cf, &to_remove, i_list)
> -                       list_del(&cf->g_list);
> +                       list_del_init(&cf->g_list);
>
>                 if (!list_empty(&ci->i_dirty_item)) {
>                         pr_warn_ratelimited(
> @@ -1688,8 +1688,9 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>                 struct ceph_cap_flush *cf;
>                 cf = list_first_entry(&to_remove,
>                                       struct ceph_cap_flush, i_list);
> -               list_del(&cf->i_list);
> -               ceph_free_cap_flush(cf);
> +               list_del_init(&cf->i_list);
> +               if (cf->caps)
> +                       ceph_free_cap_flush(cf);
>         }
>
>         wake_up_all(&ci->i_cap_wq);
> --
> 2.27.0
>
