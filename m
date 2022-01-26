Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64B649CF8C
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jan 2022 17:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236680AbiAZQXB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jan 2022 11:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236678AbiAZQW5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Jan 2022 11:22:57 -0500
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A836C06173B
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jan 2022 08:22:57 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id f24so43684738uab.11
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jan 2022 08:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vETmeA6tinmqzcUDXeuDneNYUmaCBjkURijLL4y6ARo=;
        b=YBT6iPR3C/u/Jqg5gegLpCk3qRitewH3OR5xO9NpO3443QTpwRSEZSYK2kH8cL+tGf
         FG1VXdbyPnE58JFnRU5ZwlKs8MX2ZxDL9ZuEaMb+c/whDgYLzQxDnGewDNGfCiV4u6R8
         Q/UsuxW0vlN5cw+/biq+8p5N54cnyVM1MppIIbbWDDKR6U0ccNIEFZGxH8syBiYEKJWu
         7Y/r3QrlYaK4bX7XfPje7ay3yFK6x2OX4iSgW4v7+WqzBfZLUaBpenSORGqO34ys/R4v
         zeRRDeI4/k7u55HUYRvSumTV4HdeNuOpj6JDFKqoPQPUPDIkJ+C4MOVEY4FIHe4U0vza
         SIKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vETmeA6tinmqzcUDXeuDneNYUmaCBjkURijLL4y6ARo=;
        b=JVLJXbeVKFEf3dT3+ushUOgyGJUmVBpAaPecat0qXuEF6qGg0y0xnigCDgjkkvKVQ3
         xSCh0oy3AUGZ8dTxmzJpg7bM3AZNtDjMeFhXwK7ckLies8jokXdHgi/Or93z6Y9zTYhc
         cWGqrRszx65YxxWBxiDF4pH+lZhOF/L3jToaaUrcAkvtt5aulOvPGKm/Fbd2pTva/Ocn
         GfoSLrRYtF8UthxsBfNyDp6qggAI8ecnI9Wjf6O+P55pQisZwzD0r3o98d6tezSE/b5I
         PhuWtX8EpIyr4KHn3n2v/BMKVNZjOv4dXnpjuPLtFvrF64V0oXfQWsvEqMndrERoZeGS
         0Qmg==
X-Gm-Message-State: AOAM531c2LRClzzXSdx6wH8oYuqRRljtpsPDHiW86Zpi38LuSHm3KpD/
        p0E6IG9nJwzTgiqkx50EFnlyo6RblN6SeNOv9D4=
X-Google-Smtp-Source: ABdhPJzdBNr38f5Eas9rebor5y4zH8H3gGuOHJaeCUIBVkeVyA9X0qBtQLP1I66QH/VjkDRaQtjIr587CUOJP/JixJ8=
X-Received: by 2002:ab0:2c17:: with SMTP id l23mr9917122uar.130.1643214176208;
 Wed, 26 Jan 2022 08:22:56 -0800 (PST)
MIME-Version: 1.0
References: <20220125211022.114286-1-jlayton@kernel.org>
In-Reply-To: <20220125211022.114286-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 26 Jan 2022 17:23:04 +0100
Message-ID: <CAOi1vP-W=k=dAmMoXCfQ4McyyP-boRYCdUF6HthCNyfgbOzNWw@mail.gmail.com>
Subject: Re: [PATCH] ceph: set pool_ns in new inode layout for async creates
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Dan van der Ster <dan@vanderster.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jan 25, 2022 at 10:10 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Dan reported that he was unable to write to files that had been
> asynchronously created when the client's OSD caps are restricted to a
> particular namespace.
>
> The issue is that the layout for the new inode is only partially being
> filled. Ensure that we populate the pool_ns_data and pool_ns_len in the
> iinfo before calling ceph_fill_inode.
>
> Reported-by: Dan van der Ster <dan@vanderster.com>
> Fixes: 9a8d03ca2e2c ("ceph: attempt to do async create when possible")
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/file.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index cbe4d5a5cde5..efea321ff643 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -599,6 +599,7 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
>         struct ceph_inode_info *ci = ceph_inode(dir);
>         struct inode *inode;
>         struct timespec64 now;
> +       struct ceph_string *pool_ns;
>         struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
>         struct ceph_vino vino = { .ino = req->r_deleg_ino,
>                                   .snap = CEPH_NOSNAP };
> @@ -648,11 +649,17 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
>         in.max_size = cpu_to_le64(lo->stripe_unit);
>
>         ceph_file_layout_to_legacy(lo, &in.layout);
> +       pool_ns = ceph_try_get_string(lo->pool_ns);
> +       if (pool_ns) {
> +               iinfo.pool_ns_len = pool_ns->len;
> +               iinfo.pool_ns_data = pool_ns->str;
> +       }

Considering that we have a reference from try_prep_async_create(), do
we actually need to bother with ceph_try_get_string() here?

Thanks,

                Ilya
