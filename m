Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8493327BF22
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Sep 2020 10:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbgI2IUT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Sep 2020 04:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbgI2IUN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Sep 2020 04:20:13 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEEE2C061755
        for <ceph-devel@vger.kernel.org>; Tue, 29 Sep 2020 01:20:12 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id o9so3983044ils.9
        for <ceph-devel@vger.kernel.org>; Tue, 29 Sep 2020 01:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p2fUYfzFUpxqE9+CQAnoynp8wP5mF9/aPJjum44j7/A=;
        b=BOout97pnftk+59lnSlZ365Mk7hHzTdNhZMnlLIK7YHeNKo9KhVACiN/rtCzgcuzw8
         uJsHMNW+Hi8G5yqSz8hNtFoGycmQVfNfkDzJMhclkYexO+UhYvRuDXVcOdn7igyrrLUf
         HTjWb3xTmWWLgn2A5N515DTCeDB4pZpFMDLrx3s/O9QJuNZqerA8dkxWv7NahB9tWwOs
         MpjPhEJ7qI4cExiyIQthJHxBWCJmmsgSUw1SaLkhrsvOGsYjoMetf/Rfod1gqORiBe30
         ZJYIegNL7iEZcB09jfOoxpvyFSjPWbSf1RgVjAzg6n9Ud7xId9CFbqng9zkYeOChqlZ0
         oEqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p2fUYfzFUpxqE9+CQAnoynp8wP5mF9/aPJjum44j7/A=;
        b=ihb/OQK60H5oVlhpGajIkH+W0uBxgC5eo/oJgisg+6OZLWfkJn9q3mto2k9l86jc6h
         CKC8WKog0FyLM+wrKj+3yYMhB1o46TdEpXwWXJyhUTfSnLiIhGymRw5/ygFCtaCEk1Ha
         VBl4KqYN5ubqNBCWRb5Bc3bhRtSRcXewaW9UJpCKR1YTWK5Td5UVpJbw76akKomxxRbc
         r77dDjQfezfNS7Iw7Sl+YRc/Si6cuHRAMX98/vmkhIc5tZtl17yVyNNUlF8iKEZL55sR
         xFlJcLbS+ujYxCRSQqPoJwIHCaDWHmpCRkpGuTtlxySzHkmDrkeDwYFpiUYRxlP0fAKr
         z+Jg==
X-Gm-Message-State: AOAM530Meuy2c1U31BO49vnWqopEuE+fJr9Fwpyf+DaW4v0aOONJ2hRD
        AnNXqS/c47BY1f6biPJdhxQKYKvK6wdozvLzOw8=
X-Google-Smtp-Source: ABdhPJxkltTrNibaZqznEybJd2srrtflrevlnnIL7GyF31aXdtBYm4GXvs8rVw0d14RCpATh2d9BauBbGd7O7BOUf1o=
X-Received: by 2002:a05:6e02:8a:: with SMTP id l10mr2166279ilm.130.1601367611997;
 Tue, 29 Sep 2020 01:20:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200925140851.320673-1-jlayton@kernel.org> <20200925140851.320673-3-jlayton@kernel.org>
In-Reply-To: <20200925140851.320673-3-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 29 Sep 2020 16:20:00 +0800
Message-ID: <CAAM7YAm834Kbf1YYcNa0XGR7EYMnAH4eYs0uBbCr3KNaHccCcQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] ceph: don't mark mount as SHUTDOWN when
 recovering session
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Sep 25, 2020 at 10:08 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> When recovering a session (a'la recover_session=clean), we want to do
> all of the operations that we do on a forced umount, but changing the
> mount state to SHUTDOWN is wrong and can cause queued MDS requests to
> fail when the session comes back.
>

code that cleanup page cache check the SHUTDOWN state.

> Only mark it as SHUTDOWN when umount_begin is called.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/super.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 2516304379d3..46a0e4e1b177 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -832,6 +832,13 @@ static void destroy_caches(void)
>         ceph_fscache_unregister();
>  }
>
> +static void __ceph_umount_begin(struct ceph_fs_client *fsc)
> +{
> +       ceph_osdc_abort_requests(&fsc->client->osdc, -EIO);
> +       ceph_mdsc_force_umount(fsc->mdsc);
> +       fsc->filp_gen++; // invalidate open files
> +}
> +
>  /*
>   * ceph_umount_begin - initiate forced umount.  Tear down the
>   * mount, skipping steps that may hang while waiting for server(s).
> @@ -844,9 +851,7 @@ static void ceph_umount_begin(struct super_block *sb)
>         if (!fsc)
>                 return;
>         fsc->mount_state = CEPH_MOUNT_SHUTDOWN;
> -       ceph_osdc_abort_requests(&fsc->client->osdc, -EIO);
> -       ceph_mdsc_force_umount(fsc->mdsc);
> -       fsc->filp_gen++; // invalidate open files
> +       __ceph_umount_begin(fsc);
>  }
>
>  static const struct super_operations ceph_super_ops = {
> @@ -1235,7 +1240,7 @@ int ceph_force_reconnect(struct super_block *sb)
>         struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
>         int err = 0;
>
> -       ceph_umount_begin(sb);
> +       __ceph_umount_begin(fsc);
>
>         /* Make sure all page caches get invalidated.
>          * see remove_session_caps_cb() */
> --
> 2.26.2
>
