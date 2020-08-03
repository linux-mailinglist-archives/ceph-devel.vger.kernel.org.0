Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F7F23A1C7
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Aug 2020 11:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbgHCJdW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Aug 2020 05:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgHCJdV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Aug 2020 05:33:21 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A83C06174A
        for <ceph-devel@vger.kernel.org>; Mon,  3 Aug 2020 02:33:21 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id g19so25765531ioh.8
        for <ceph-devel@vger.kernel.org>; Mon, 03 Aug 2020 02:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oIqRFHnKQ4sbt6VePv/bd/7OXJaquKXH3h5pwm9ejTs=;
        b=FUK/A0eVBUnqsgggMLyO21TtP+ZBkU8KjwZ6rsLuUwLLKU3u8L/bWuGtrdQEb5bMmQ
         ac11AyuPOMJtZcGnJ2/aJQYdoOlAzmh3I3j36YRWKVtd5UL5xsJ+jdILr6xfQFNPv0jM
         AD8yheRCjAySCHhLEuxIl4M64Y72od+wiVr73bGPPimD4wunwTb5+hSwfeOS2GZlVJwi
         W9AfhK6LijAXULv2lM+tFWgcn8R1Sy+ldi887OOW+Dogbl/XWswKwllD3CYxWmccNsnq
         GbrbhQzIcj4Gf8fnTZl4VPda/Ux3TCL2qq+zhl9FO8b0QfwB7bsZD4hqUifBpYr0AV55
         icUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oIqRFHnKQ4sbt6VePv/bd/7OXJaquKXH3h5pwm9ejTs=;
        b=h/q0A629DrSLtW3uLdm5LnjPd3PghneJ4ECioxGv0fGpZEWJBvs4I0+PiEKjtwMksi
         Y7YGoGuj394CgBTPLNF3AB/PCqJlRmvScKtlKTKlXNm0o2E6dLZHvFlpFtTNVkycvvCy
         lAPQf5kdBnzSq5B7obhdOpP5lrtSe4niw+NvUGivhBqLhTVA8UaBGbQbypKhvNjHyZcF
         gczNg/56DxZ5Q83RlAa+kRkzsvTd5KqcSjyXastAn1XmOKqN2jhoJBbUyy0VfVr5GobS
         kLi7rcTE/8gJDPln9xtt7fctia/y6R4cxyl+x9V3aQ3VvD3PiArJPWw2hwE7jkyHek+V
         ElyA==
X-Gm-Message-State: AOAM533KzxG0gjRmlHqrItaAiPe7CEDq1WNsEyUXraLcvMXfYDuiPJWY
        DqRlT80+7g+Lgnxxe+3jsus6Yq3TbabAyHqZGRGT3zPoRl4=
X-Google-Smtp-Source: ABdhPJyYPHOgJQW3IwUzy7IJ6HDN09detMPtCFDTpQRgv2yDc3HASG8jT7hVkxTZyYwY7e2fJjWbGRP0v6aoUX/B2LQ=
X-Received: by 2002:a05:6638:1125:: with SMTP id f5mr18926742jar.51.1596447200889;
 Mon, 03 Aug 2020 02:33:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200728191838.315530-1-jlayton@kernel.org>
In-Reply-To: <20200728191838.315530-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 3 Aug 2020 11:33:21 +0200
Message-ID: <CAOi1vP8PKN2ojoEkrmB4+rDoO0WKoo07oB_wRRBK8h6RE=p=bg@mail.gmail.com>
Subject: Re: [PATCH] ceph: set sec_context xattr on symlink creation
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jul 28, 2020 at 10:04 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Symlink inodes should have the security context set in their xattrs on
> creation. We already set the context on creation, but we don't attach
> the pagelist. Make it do so.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/dir.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 39f5311404b0..060bdcc5ce32 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -930,6 +930,10 @@ static int ceph_symlink(struct inode *dir, struct dentry *dentry,
>         req->r_num_caps = 2;
>         req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
>         req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
> +       if (as_ctx.pagelist) {
> +               req->r_pagelist = as_ctx.pagelist;
> +               as_ctx.pagelist = NULL;
> +       }
>         err = ceph_mdsc_do_request(mdsc, dir, req);
>         if (!err && !req->r_reply_info.head->is_dentry)
>                 err = ceph_handle_notrace_create(dir, dentry);

What is the side effect?  Should this go to stable?

Thanks,

                Ilya
