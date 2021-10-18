Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2324329D9
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Oct 2021 00:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhJRWof (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Oct 2021 18:44:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60213 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229524AbhJRWoe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 18 Oct 2021 18:44:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634596942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ApRiB1d+7UtFLY72sLG3S1IixULe5c2fqtK8TWUjabk=;
        b=F9Mi6MSvP9AtDcLEC6GoH7S1H/CJineFkBBIua5YFraJi+ia6EMg/t1G2ebylvJ2Py73fP
        x3ZPx1Ul42N94vJ9S3WTD8t0PUFM9+ZjqezabZBmnXCtYqlqMAEWulBAijwhjJJHGg7NVt
        JjpmIll27dj7cRmXX8nWOzcqpZ4Q+FY=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-R8G2DvMCM_KtFBxP2hYTjw-1; Mon, 18 Oct 2021 18:42:21 -0400
X-MC-Unique: R8G2DvMCM_KtFBxP2hYTjw-1
Received: by mail-qv1-f70.google.com with SMTP id gg11-20020a056214252b00b00382e4692e72so15995654qvb.13
        for <ceph-devel@vger.kernel.org>; Mon, 18 Oct 2021 15:42:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ApRiB1d+7UtFLY72sLG3S1IixULe5c2fqtK8TWUjabk=;
        b=Twvk0Ay3rhzu1VppeQXtg33ZpkRu65lPGj0G2KryXzSQp7pRAqPqEhi3srXepfnzmt
         DH+BX7yTfYFtLXoia0K7UAoveMPdOrVwf32X5KGvOSvr5OQK7oisjn8MkM7dzr8EF4t7
         kcf/wad6W+MA0pxbNedw+0sn5Ji4c3pY3m6w1KHLvzndjyJOO+Q6wK+GEyV/yF2Fgczl
         CmsvgWL8WFzMtHMJqJHraayB+TyDtXt0ccqWlnx1XCHvyN1jKIE35wGczPI2OIdZ2ApQ
         eW1txNYEMQxiRJjIZ8lrKRBKgUDOaTl59jYPL06VCYDlISCX8Tr6z7UinYNARcFRQx1K
         eFuQ==
X-Gm-Message-State: AOAM531ctGK761WnCbR0sliUXwLKVDF7JuYTwuPyJ8fyRRbigEy06BbX
        xibwCahODzGwL/AvT/VxAKt+iVEPUMG2raPXE3NGgvANsH3k7LQwzLNDft4GhiAm653NxHLo+Hr
        vH/HviE6J66LFGCvY7ous55mBOyhcpSAhttAiqw==
X-Received: by 2002:a05:6214:5282:: with SMTP id kj2mr24019715qvb.22.1634596940983;
        Mon, 18 Oct 2021 15:42:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJGpe73ARCCw2q/BTYUpb/5XpQtFx9pTJzLs+6mYLb42OLPfwCr0vSkYOqiyy021kNLow9kxLVhUlYE7RrZzI=
X-Received: by 2002:a05:6214:5282:: with SMTP id kj2mr24019691qvb.22.1634596940595;
 Mon, 18 Oct 2021 15:42:20 -0700 (PDT)
MIME-Version: 1.0
References: <20211014165002.92052-1-jlayton@kernel.org>
In-Reply-To: <20211014165002.92052-1-jlayton@kernel.org>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Mon, 18 Oct 2021 15:42:09 -0700
Message-ID: <CAJ4mKGZ2yyRAfPX7qm+pvvxVMbhOtuuj2d_6wcSZJ5AtwBHH=g@mail.gmail.com>
Subject: Re: [PATCH] ceph: shut down mount on bad mdsmap or fsmap decode
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Oct 14, 2021 at 9:50 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> As Greg pointed out, if we get a mangled mdsmap or fsmap, then something
> has gone very wrong, and we should avoid doing any activity on the
> filesystem.
>
> When this occurs, shut down the mount the same way we would with a
> forced umount by calling ceph_umount_begin when decoding fails on either
> map. This causes most operations done against the filesystem to return
> an error. Any dirty data or caps in the cache will be dropped as well.

Hurray, simple fixes!

You have my acked-by, but I'm really not familiar with the kernel
shutdown mechanics so I shouldn't provide anything stronger. :)

>
> The effect is not reversible, so the only remedy is to umount.
>
> URL: https://tracker.ceph.com/issues/52303
> Cc: Greg Farnum <gfarnum@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/mds_client.c | 6 ++++--
>  fs/ceph/super.c      | 2 +-
>  fs/ceph/super.h      | 1 +
>  3 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 598425ccd020..5490f3422ae2 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -5011,7 +5011,8 @@ void ceph_mdsc_handle_fsmap(struct ceph_mds_client *mdsc, struct ceph_msg *msg)
>         return;
>
>  bad:
> -       pr_err("error decoding fsmap\n");
> +       pr_err("error decoding fsmap. Shutting down mount.\n");
> +       ceph_umount_begin(mdsc->fsc->sb);
>  err_out:
>         mutex_lock(&mdsc->mutex);
>         mdsc->mdsmap_err = err;
> @@ -5078,7 +5079,8 @@ void ceph_mdsc_handle_mdsmap(struct ceph_mds_client *mdsc, struct ceph_msg *msg)
>  bad_unlock:
>         mutex_unlock(&mdsc->mutex);
>  bad:
> -       pr_err("error decoding mdsmap %d\n", err);
> +       pr_err("error decoding mdsmap %d. Shutting down mount.\n", err);
> +       ceph_umount_begin(mdsc->fsc->sb);
>         return;
>  }
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 580dad2c832e..fea6e69b94a0 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -969,7 +969,7 @@ static void __ceph_umount_begin(struct ceph_fs_client *fsc)
>   * ceph_umount_begin - initiate forced umount.  Tear down the
>   * mount, skipping steps that may hang while waiting for server(s).
>   */
> -static void ceph_umount_begin(struct super_block *sb)
> +void ceph_umount_begin(struct super_block *sb)
>  {
>         struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
>
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 49ca2106f853..7c3990cd3c3b 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -947,6 +947,7 @@ extern void ceph_put_snapid_map(struct ceph_mds_client* mdsc,
>                                 struct ceph_snapid_map *sm);
>  extern void ceph_trim_snapid_map(struct ceph_mds_client *mdsc);
>  extern void ceph_cleanup_snapid_map(struct ceph_mds_client *mdsc);
> +void ceph_umount_begin(struct super_block *sb);
>
>
>  /*
> --
> 2.31.1
>

