Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A16652498F0
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Aug 2020 11:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgHSJAn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Aug 2020 05:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgHSJAj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Aug 2020 05:00:39 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1748C061342;
        Wed, 19 Aug 2020 02:00:38 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id t15so24046450iob.3;
        Wed, 19 Aug 2020 02:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F6k4LMA75SPnHgZeTuYAvf9mCgrQHf1tbkPJXV7/4U0=;
        b=iGo7HuWUCyTqidvU0fumZUvtetQ+1Q94DOUhyrATBY/Vg+FZZ+o9Tj9xDITUpARQPS
         Qc35O0Nb/cTBSXeMsrYajZF0V76WYKd4sZIiQf/CQwzQzVT5hIxnMUO7sn2LboNX+jLJ
         VR3GvOYrq4KXURiFWqRVf4rpgk47B/5OxBLs75wjOyydjd24ftGNpIG/5JQ+xgfLecPN
         +Z8sWJ5ko3jLt0P7JnW93tvNKC7STfLs+W3UkkNqq47s5lZHTtJNjFIBzXZyYbenjKGf
         fovQEwuy5N8z4FmlLKtPsn936vcMGifin1sFbSX1cTXYVcEeoU8p3Q+PxP4AFHbHgP5J
         B1Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F6k4LMA75SPnHgZeTuYAvf9mCgrQHf1tbkPJXV7/4U0=;
        b=hUEALoG8CxwnqaMMp5qWAKCdxxuUxbQGcurFuDtDTz8kRe+1y4EjnULqk+3d4h8olU
         9Y6JiLx2ZTLH2KPzixTIGcb5FBNePl2Bgvv0nlzhOBof6qwlJbOvfTQ7DmXhjyEt/1Vy
         O2nfdAiOYvK8eEMxqtruUnFR3z4NwPh3YvJed2ncA5V4qRCvMTrOasUpCltv0p07xGow
         7vTPh9ldaMB1x8LfE9mo+FVubmLsc8PwazgrazxmGwTfp6gl6EBgQKi8AkdQfu5EadSN
         nk16ncQLFDqRb7kJDLVH13W/RyRbKT80AnWBbB5y+Lms0wCC7yiFLlOkEu2RHsdYwHQ3
         bxWg==
X-Gm-Message-State: AOAM531RFAUjI6t76v/p0Ppn6BpndWCcqV2VRxf4ClJp5OwNyrxwjbv8
        GcvB5ZdvHLz8s74sJ+pwbSGb6Rv6Odc4wOFuL0o=
X-Google-Smtp-Source: ABdhPJwg0KMn3LjdN0wib3nGWcQISsP5qWOnaaVtFOYWQuj/NY20f9UiP40hGXnIE+zwpUq578DnXkP49iGPQIvNtsc=
X-Received: by 2002:a6b:b513:: with SMTP id e19mr19449253iof.167.1597827638300;
 Wed, 19 Aug 2020 02:00:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200819085142.42652-1-linmiaohe@huawei.com>
In-Reply-To: <20200819085142.42652-1-linmiaohe@huawei.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 19 Aug 2020 11:00:45 +0200
Message-ID: <CAOi1vP_rXAhFXXt5eLNUtrXaqpX-2Wr2vLpkF2WaBKM=AqqX2A@mail.gmail.com>
Subject: Re: [PATCH] ceph: Convert to use the preferred fallthrough macro
To:     Miaohe Lin <linmiaohe@huawei.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 19, 2020 at 10:53 AM Miaohe Lin <linmiaohe@huawei.com> wrote:
>
> Convert the uses of fallthrough comments to fallthrough macro.
>
> Signed-off-by: Hongxiang Lou <louhongxiang@huawei.com>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  fs/ceph/file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index d51c3f2fdca0..30cd00265181 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -252,7 +252,7 @@ static int ceph_init_file(struct inode *inode, struct file *file, int fmode)
>         case S_IFREG:
>                 ceph_fscache_register_inode_cookie(inode);
>                 ceph_fscache_file_set_cookie(inode, file);
> -               /* fall through */
> +               fallthrough;
>         case S_IFDIR:
>                 ret = ceph_init_file_info(inode, file, fmode,
>                                                 S_ISDIR(inode->i_mode));
> --
> 2.19.1
>

Hi Miaohe,

I've already done that, folding into your previous patch:

  https://github.com/ceph/ceph-client/commit/3f19ae89547df1b8ccba359a2f7ddba0f108ffbd

Thanks,

                Ilya
