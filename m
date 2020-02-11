Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF5A5158CC8
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Feb 2020 11:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgBKKfN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 11 Feb 2020 05:35:13 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:44326 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728427AbgBKKfM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 11 Feb 2020 05:35:12 -0500
Received: by mail-il1-f193.google.com with SMTP id s85so2980808ill.11
        for <ceph-devel@vger.kernel.org>; Tue, 11 Feb 2020 02:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U0kvfiKtFVH5EI1oI83x4VguHT574yWmRisjA2UYvFQ=;
        b=JSvNs6ZcaS+49RaIYIulbpWf/XXCTDcmJI7hyMrT9UM3lFkPmrmSZ9GbI5s1Mfg2y/
         +oXEdpbA6gSrKR5woMUISeG/DIA9qTJdrU4q7/ylWfW/2bmeZAwRwM+oPj9vIEPnE/cL
         RNj2wX6Sp0/ml65yDA/2kdk6Kz7UIPk5ggmyyjXK84n4ve7OBvxOWzjyMUCPzV6leQ4K
         07gW6gT62WO2XprWVwh1/p2cbZYE+bkujBp5QbDeexzSBNiPYeWLyCx53P95T+5ItBq8
         IUSEkXZf2s1CoLarpgHGCEyn3yvNBJhNxSdHXBAlIK6EZvvfINmqo0DIW2+IDVEwgLrH
         jfCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U0kvfiKtFVH5EI1oI83x4VguHT574yWmRisjA2UYvFQ=;
        b=l3rXcWblvIdpgvfO7YennWckNxjDwlSZXacQMpXSTKD5ML1Fk1OXvviUhMD+oXHJTs
         dUDMThAyuz2wBIj+A42bQhFHWFWDG+5A0Ueo2cRm3ZRrRz0tYm2qGu/mcVXZdSzSuKE+
         fmpFDo57OqhlQqGZb4AmWBPnMChk6mer9a8BkGVwf3Gbk9VnxxI11GTHeswPQRzBZ5ca
         d4lk26aKphxF7wgQNUAduAO1fuH/Ezuh31ucDPcQ+dwoG2CEWGUokp9Ko0C2vdN+WfoD
         JXbukNm49eCpoLhhSITcTHMY1vuI1bb32aQlA75l5UJpb6olYtThPiYMawQ8SF+lttkR
         vrUw==
X-Gm-Message-State: APjAAAUA0Ztc/6Y7lqrlqwhUdkAbhoRoakmrcqmePp8WGmO3PFDJu0Gl
        Wv/AWQucL9xUee2URlQjDD5GyAtMwJiKl3+Jfp8=
X-Google-Smtp-Source: APXvYqwwDwozA5oY33cCtQosfSvt/vEGMloZN/lglo37T1MQKh+/NOgwH1MSdHGmLDZw+P8g/4rSYzGEZ9olZMMtA7o=
X-Received: by 2002:a92:ccd0:: with SMTP id u16mr5368879ilq.215.1581417310912;
 Tue, 11 Feb 2020 02:35:10 -0800 (PST)
MIME-Version: 1.0
References: <20200211065316.59091-1-xiubli@redhat.com>
In-Reply-To: <20200211065316.59091-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 11 Feb 2020 11:35:30 +0100
Message-ID: <CAOi1vP-MZscD1d0DbgqDbjV0SjNmOBWu+onc7xOR31izgxYxOQ@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix posix acl couldn't be settable
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Feb 11, 2020 at 7:53 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> For the old mount API, the module parameters parseing function will
> be called in ceph_mount() and also just after the default posix acl
> flag set, so we can control to enable/disable it via the mount option.
>
> But for the new mount API, it will call the module parameters
> parseing function before ceph_get_tree(), so the posix acl will always
> be enabled.
>
> Fixes: 82995cc6c5ae ("libceph, rbd, ceph: convert to use the new mount API")
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> Changed in V2:
> - move default fc->sb_flags setting to ceph_init_fs_context().
>
>  fs/ceph/super.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 5fef4f59e13e..c3d9ac768cec 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1089,10 +1089,6 @@ static int ceph_get_tree(struct fs_context *fc)
>         if (!fc->source)
>                 return invalf(fc, "ceph: No source");
>
> -#ifdef CONFIG_CEPH_FS_POSIX_ACL
> -       fc->sb_flags |= SB_POSIXACL;
> -#endif
> -
>         /* create client (which we may/may not use) */
>         fsc = create_fs_client(pctx->opts, pctx->copts);
>         pctx->opts = NULL;
> @@ -1215,6 +1211,10 @@ static int ceph_init_fs_context(struct fs_context *fc)
>         fsopt->max_readdir_bytes = CEPH_MAX_READDIR_BYTES_DEFAULT;
>         fsopt->congestion_kb = default_congestion_kb();
>
> +#ifdef CONFIG_CEPH_FS_POSIX_ACL
> +       fc->sb_flags |= SB_POSIXACL;
> +#endif
> +
>         fc->fs_private = pctx;
>         fc->ops = &ceph_context_ops;
>         return 0;

Applied.

Thanks,

                Ilya
