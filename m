Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019513FB3B4
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Aug 2021 12:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236334AbhH3KPl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 Aug 2021 06:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236316AbhH3KPk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 30 Aug 2021 06:15:40 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B430C061575;
        Mon, 30 Aug 2021 03:14:47 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id q3so19064906iot.3;
        Mon, 30 Aug 2021 03:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X8UjoR+cxk9dXaV8b/ZX2ooM+v51xP64NJ+eDD8X3xA=;
        b=kFazPhcqZKP4SjeyC0vPyoENZupRq10KVhvxutm3YwW7dTSqsLncMJicy6FcL+7hok
         gV+bkHLXToMmKPM5wuPnvBe6fEDML6OemIjq716C9PtG+j9KY8GbZxPbSpLxsBLM06Lp
         wjm+YwsjevoG/fewf6S9RB6wsedeuoSH2vMwgnvuYJ0mUYEHW7+mpmZkAwLZlyLRYq+d
         V+00boN/yj4vVcKlUIAP8X+MS22RIO/t8u1RLmnWhDKBCDNbEJwPcifE3mVN/YkFYA3L
         NHkO1EkYG4YqPsEkfhmslFESkpDjD3cTWrtflSId2SfhpAG60m/QHgPu6uYjsCHwFKiH
         D0tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X8UjoR+cxk9dXaV8b/ZX2ooM+v51xP64NJ+eDD8X3xA=;
        b=qeKJI9YuPUgT744ejQH3MbDSVqTDFy09swDzrrVaWU5u+Aw3RMR2x5eu4JjRtYx9Zb
         oZvHOMbUWRMTWZYRBE+y6FN6OFAyTXp6CjivcXg0TAdfMOLWJn4nLlV/lH5oJ7l8nqLv
         4zBSjkt7tcLkj4GyjoLohSaVH2GNAKgdYSVneILavddSTDcdfKXMewxDdfTZKh6nBqXE
         KpE1wUTloGUA+Geg68P77eIzTxeASZPnY3vzXdECQ4z+y49wIUd7wr0DN9KtYkazB223
         EgOtnG7m/dzFmwhUuzII7+xi4FfE8lgFv4rON/Kxdc6Q+THh2y6yiYEAqlYDfFlRWJ9m
         onaw==
X-Gm-Message-State: AOAM533+UH13+8QFlM6cFmB6+KSOUgavY99clWyesajCsUwtQr0wkW3P
        cTQ9bpV18lphmUXGWtvyD8Yp4Vw6k98cx76vpWM=
X-Google-Smtp-Source: ABdhPJy9ZhcxG3nwBOzHBwk609HqrVKr6kxs+KBqO+rIhtDT+UkIbCxzcQNxSnD/cwxZZoO/yvuBXQh8w61REiD5dt4=
X-Received: by 2002:a02:b183:: with SMTP id t3mr4387131jah.93.1630318481377;
 Mon, 30 Aug 2021 03:14:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210829181824.534447-1-colin.king@canonical.com>
In-Reply-To: <20210829181824.534447-1-colin.king@canonical.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 30 Aug 2021 12:14:20 +0200
Message-ID: <CAOi1vP8e4xXUwGe5G260rOM8xgQVi6zcLTs_6bq-ND23G6e1YQ@mail.gmail.com>
Subject: Re: [PATCH][next] ceph: Fix dereference of null pointer cf
To:     Colin King <colin.king@canonical.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, Aug 29, 2021 at 8:18 PM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> Currently in the case where kmem_cache_alloc fails the null pointer
> cf is dereferenced when assigning cf->is_capsnap = false. Fix this
> by adding a null pointer check and return path.
>
> Addresses-Coverity: ("Dereference null return")
> Fixes: b2f9fa1f3bd8 ("ceph: correctly handle releasing an embedded cap flush")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/ceph/caps.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 39db97f149b9..eceb3ceaac48 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1746,6 +1746,8 @@ struct ceph_cap_flush *ceph_alloc_cap_flush(void)
>         struct ceph_cap_flush *cf;
>
>         cf = kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
> +       if (!cf)
> +               return NULL;
>         cf->is_capsnap = false;
>         return cf;
>  }
> --
> 2.32.0
>

Hi Colin,

I guess we were too focused on the details of b2f9fa1f3bd8 to spot the
obvious...  It sat in next for a few days but apparently not enough to
be included in the Coverity run.  What is the frequency of these runs?

Applied and added an explicit stable tag since b2f9fa1f3bd8 is already
on its way to stable kernels.

Thanks,

                Ilya
