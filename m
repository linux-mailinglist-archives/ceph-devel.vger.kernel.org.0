Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491A03F02D4
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Aug 2021 13:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235818AbhHRLfQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Aug 2021 07:35:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31791 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233798AbhHRLfP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 07:35:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629286480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S0nnUcVPEdeaR6z3sM0ovQ3Vsjna7buOS7uOuE3e8jg=;
        b=VfXkzGUXM2880k8N6cFfzcpUsGDp3B2pEb2UwK9Qwh7ujWezVbmyW1ygZpLE7VxNsNipP9
        86znQAXaC7tVNl+da3ik5pprVJQl2OcTzi1z6+VYZdWgROUbjWrw81WY73/nqDwDj9oB7l
        1EbnsRtt7GWFwWsSXXyjdl7N1pJd+P8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-VNh5iqmCME6N9KqPEWVGpg-1; Wed, 18 Aug 2021 07:34:39 -0400
X-MC-Unique: VNh5iqmCME6N9KqPEWVGpg-1
Received: by mail-ed1-f69.google.com with SMTP id u4-20020a50eac40000b02903bddc52675eso893430edp.4
        for <ceph-devel@vger.kernel.org>; Wed, 18 Aug 2021 04:34:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S0nnUcVPEdeaR6z3sM0ovQ3Vsjna7buOS7uOuE3e8jg=;
        b=IYK//qWqi3oPuCocOXVizsUa10k9hFGSyFld0aCHrerXQ2HPMBIJfswRwyjzvo0TwW
         /CEy23vd9DXFpkk67glUmFK+fyK00I1ejyAfq5ifSf3DmyvqQ7eSgT3dc55DhSwJQK0i
         Clkwjv68c7iySKVsldEYII+kF6PzYq396yYY4b+DUandwW4+8OmLyUtgTsdYOd0bJrsu
         umPrxqkE3J3z5S39l6eGWZJ7zIRQ9ij/wy62c+78lUpinbSPKm7RB+IqtQx0DidV86iY
         /+ewwKXcPgZ+bvOZMTNWOgiAvA5Hwl1UMw9tmMROXSxne90Lpe11r+vBuu95xq283Kfx
         XGwg==
X-Gm-Message-State: AOAM532O/Q+sTasrWDjFjhZJ9hefCtmn0piUZOQccSUKhGHmWKhvxg+E
        /tuxSk1p5mGcv85zaBR+8AMAm37H15s1/A4hh18ccEVRPOqLpB1YPQDvy7ib90yv0J9GjDtQ3rV
        N+Zl+NxOld4i2e67aC7+4PKg4RK0rz82HCUB6LA==
X-Received: by 2002:a05:6402:556:: with SMTP id i22mr9692087edx.380.1629286478062;
        Wed, 18 Aug 2021 04:34:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzLkj/5zVYRq6TVVlOpKycjd4Q/P0Hb82XCjlop0OpVdD9dkfzxXgk2q2iHtyC0DAOh3oZLwBFrGfc83sAkJs0=
X-Received: by 2002:a05:6402:556:: with SMTP id i22mr9692079edx.380.1629286477932;
 Wed, 18 Aug 2021 04:34:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210818060134.208546-1-vshankar@redhat.com> <20210818060134.208546-2-vshankar@redhat.com>
In-Reply-To: <20210818060134.208546-2-vshankar@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Wed, 18 Aug 2021 17:04:01 +0530
Message-ID: <CACPzV1mYj2A2zyDJBq1Yx64BCcLeP_z6Mc1BHSLdr0g3G6K0LQ@mail.gmail.com>
Subject: Re: [RFC 1/2] ceph: add helpers to create/cleanup debugfs
 sub-directories under "ceph" directory
To:     Jeff Layton <jlayton@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

There's a build issue with non-debugfs builds -- I'll fix it up and resend.

On Wed, Aug 18, 2021 at 11:31 AM Venky Shankar <vshankar@redhat.com> wrote:
>
> Callers can use this helper to create a subdirectory under
> "ceph" directory in debugfs to place custom files for exporting
> information to userspace.
>
> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>  include/linux/ceph/debugfs.h |  3 +++
>  net/ceph/debugfs.c           | 26 ++++++++++++++++++++++++--
>  2 files changed, 27 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/ceph/debugfs.h b/include/linux/ceph/debugfs.h
> index 8b3a1a7a953a..c372e6cb8aae 100644
> --- a/include/linux/ceph/debugfs.h
> +++ b/include/linux/ceph/debugfs.h
> @@ -10,5 +10,8 @@ extern void ceph_debugfs_cleanup(void);
>  extern void ceph_debugfs_client_init(struct ceph_client *client);
>  extern void ceph_debugfs_client_cleanup(struct ceph_client *client);
>
> +extern struct dentry *ceph_debugfs_create_subdir(const char *subdir);
> +extern void ceph_debugfs_cleanup_subdir(struct dentry *subdir_dentry);
> +
>  #endif
>
> diff --git a/net/ceph/debugfs.c b/net/ceph/debugfs.c
> index 2110439f8a24..eabac20b3ff4 100644
> --- a/net/ceph/debugfs.c
> +++ b/net/ceph/debugfs.c
> @@ -404,6 +404,18 @@ void ceph_debugfs_cleanup(void)
>         debugfs_remove(ceph_debugfs_dir);
>  }
>
> +struct dentry *ceph_debugfs_create_subdir(const char *subdir)
> +{
> +       return debugfs_create_dir(subdir, ceph_debugfs_dir);
> +}
> +EXPORT_SYMBOL(ceph_debugfs_create_subdir);
> +
> +void ceph_debugfs_cleanup_subdir(struct dentry *subdir_dentry)
> +{
> +       debugfs_remove(subdir_dentry);
> +}
> +EXPORT_SYMBOL(ceph_debugfs_cleanup_subdir);
> +
>  void ceph_debugfs_client_init(struct ceph_client *client)
>  {
>         char name[80];
> @@ -413,7 +425,7 @@ void ceph_debugfs_client_init(struct ceph_client *client)
>
>         dout("ceph_debugfs_client_init %p %s\n", client, name);
>
> -       client->debugfs_dir = debugfs_create_dir(name, ceph_debugfs_dir);
> +       client->debugfs_dir = ceph_debugfs_create_subdir(name);
>
>         client->monc.debugfs_file = debugfs_create_file("monc",
>                                                       0400,
> @@ -454,7 +466,7 @@ void ceph_debugfs_client_cleanup(struct ceph_client *client)
>         debugfs_remove(client->debugfs_monmap);
>         debugfs_remove(client->osdc.debugfs_file);
>         debugfs_remove(client->monc.debugfs_file);
> -       debugfs_remove(client->debugfs_dir);
> +       ceph_debugfs_cleanup_subdir(client->debugfs_dir);
>  }
>
>  #else  /* CONFIG_DEBUG_FS */
> @@ -475,4 +487,14 @@ void ceph_debugfs_client_cleanup(struct ceph_client *client)
>  {
>  }
>
> +struct dentry *ceph_debugfs_create_subdir(const char *subdir)
> +{
> +}
> +EXPORT_SYMBOL(ceph_debugfs_create_subdir);
> +
> +void ceph_debugfs_cleanup_subdir(struct dentry *subdir_dentry)
> +{
> +}
> +EXPORT_SYMBOL(ceph_debugfs_cleanup_subdir);
> +
>  #endif  /* CONFIG_DEBUG_FS */
> --
> 2.27.0
>


-- 
Cheers,
Venky

