Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCA82FD031
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Jan 2021 13:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731788AbhATMfO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Jan 2021 07:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730407AbhATKqj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 Jan 2021 05:46:39 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EA6C061757
        for <ceph-devel@vger.kernel.org>; Wed, 20 Jan 2021 02:45:52 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id u17so46003453iow.1
        for <ceph-devel@vger.kernel.org>; Wed, 20 Jan 2021 02:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JA/pBHefc3AoAai4fsw9sMci0V1QddjZowJocmFSVEg=;
        b=SJWKxDdAOjrRw2DekyJQ/mDN2eKv4B/1fI8TPptuCLh0KhKS/w72qyHsWvaA3b6OYC
         WN6prV2dwXUPnJgXgMACpcBgcg4w6wlFwzsd1WVnPBgyDjSebiSoji0/tBVMbWGAaMIw
         0DNjLyoS1Rk5nRjrinubZYaNw6yEFma5xYRFurQKmZy3FKfYeIzPUYK9DjFLMxeN3n3+
         uIK7WeLg6X4eTKWazl0OkrDCWQF+jrkCTRFbJz36XPJdhklTG2WtRQHfOHBpPeImw8ix
         AWJD12vFCIZWNR+TZBnW2gR3zZ0MJTR3Hmr1rzmLKW+AyFlDAo94N0vJeWKx2GtynO4K
         cUkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JA/pBHefc3AoAai4fsw9sMci0V1QddjZowJocmFSVEg=;
        b=Ig7OCZMBsOh97w/03VklvePuR6sf1f6gi03XQhBNAO2Qk3iJb1vUaN6x+5tMGKpSmI
         zaVXX6LfQ2Vd6Dw1w19TA/4ncsyr22K/h11qLIjtA9zflCavCBC2uMCiUI9agr0D81zl
         VP0oFH1UWjr2N0bxLphzy6t/VHpGXfRXlraVFGuZYn6mKWBJBIahYRuhMo8WtfkKtMEK
         W3KlLDnl+wzxRdUsM3S6zPgcySjVappxV4x4I1tfZ+oy66gx66lsaksy04GnEmWx18sL
         I++I3XcstX42+oE09YgvEFpyEAnZJfMQWpbowEpm9984eqyEwTrYPJHzQ4XDnNTdXXwF
         yu3g==
X-Gm-Message-State: AOAM530uGSXhxj8KRVkS/gaEOaFmIpnaJZlPmewMqm2ekbFkdPgAPnC1
        peUc/GjP/ywcby3djJNot+ZtCiKVQoicHOlxWwRJs4II9xQ=
X-Google-Smtp-Source: ABdhPJyL6e7eTwOYEIg/HANK2gLzTDRZAgwpsFv40+15ANxGEtypm5ZYNhiK74IkuLr0iSUFR0HYnGhijWjP9ua6H/Q=
X-Received: by 2002:a05:6e02:1566:: with SMTP id k6mr7173469ilu.19.1611139552294;
 Wed, 20 Jan 2021 02:45:52 -0800 (PST)
MIME-Version: 1.0
References: <20210119144430.337370-1-jlayton@kernel.org>
In-Reply-To: <20210119144430.337370-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 20 Jan 2021 11:46:05 +0100
Message-ID: <CAOi1vP-1_4eHzAKS3BP6_fL6=BgV1NCYy6-+0e+gyhC0ZnUTVw@mail.gmail.com>
Subject: Re: [PATCH] ceph: enable async dirops by default
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jan 19, 2021 at 4:06 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> This has been behaving reasonably well in testing, and enabling this
> offers significant performance benefits. Enable async dirops by default
> in the kclient going forward, and change show_options to add "wsync"
> when they are disabled.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/super.c | 4 ++--
>  fs/ceph/super.h | 5 +++--
>  2 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 9b1b7f4cfdd4..884e2ffabfaf 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -577,8 +577,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
>         if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
>                 seq_show_option(m, "recover_session", "clean");
>
> -       if (fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS)
> -               seq_puts(m, ",nowsync");
> +       if (!(fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS))
> +               seq_puts(m, ",wsync");
>
>         if (fsopt->wsize != CEPH_MAX_WRITE_SIZE)
>                 seq_printf(m, ",wsize=%u", fsopt->wsize);
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 13b02887b085..8ee2745f6257 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -46,8 +46,9 @@
>  #define CEPH_MOUNT_OPT_ASYNC_DIROPS    (1<<15) /* allow async directory ops */
>
>  #define CEPH_MOUNT_OPT_DEFAULT                 \
> -       (CEPH_MOUNT_OPT_DCACHE |                \
> -        CEPH_MOUNT_OPT_NOCOPYFROM)
> +       (CEPH_MOUNT_OPT_DCACHE          |       \
> +        CEPH_MOUNT_OPT_NOCOPYFROM      |       \
> +        CEPH_MOUNT_OPT_ASYNC_DIROPS)
>
>  #define ceph_set_mount_opt(fsc, opt) \
>         (fsc)->mount_options->flags |= CEPH_MOUNT_OPT_##opt
> --
> 2.29.2
>

Hi Jeff,

Is it being tested by teuthology?   I see commit 4181742a3ba8 ("qa:
allow arbitrary mount options on kclient mounts"), but nothing beyond
that.  I think "nowsync" needs to be turned on and get at least some
nightly coverage before the default is flipped.

Thanks,

                Ilya
