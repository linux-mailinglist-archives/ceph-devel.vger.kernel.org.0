Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8673401F6A
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Sep 2021 20:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244379AbhIFSE6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Sep 2021 14:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244371AbhIFSE5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Sep 2021 14:04:57 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F374DC061757;
        Mon,  6 Sep 2021 11:03:51 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id f6so9692218iox.0;
        Mon, 06 Sep 2021 11:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4H8KJdOpjjzwiqRcJLFHWd3PQAAxrT81eJ9GkExltUo=;
        b=iEGT4+Q+JXOHwwU9fdZ+0nJsvP0CY1sRAqY4AFrmrfTKeOdLZZCHsVgD3Uys1crhEg
         3x0b0Iqgr73vQVlkCj6GahFd5q4Hsjic20HUbUbWUMxRU00/EerPViKlkf1gcZUv350H
         R9gtbgehmuzA52W4+CXODfoFb2PG2YH9gP9kHd8GPSf1m+OzHMh/eYSY4vpyy5mi+F4T
         mwqMVYAbI0a90fdDqKw1PfdNo9nGrdVqMOQZuKO9CgQGcUPHT9YG9sC2rvuBKDQbdNkw
         eTiCyFe0COBiW3jk2szaFZLRE3ED+6mehauI0LshOZeb4NztEwKGI1P04w9ZDad3owtj
         lyXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4H8KJdOpjjzwiqRcJLFHWd3PQAAxrT81eJ9GkExltUo=;
        b=pc+a219J7Jg4O0XgY0IgDIkygrmqp4cDj1kjcjcBWMFx54CFULLviAPH6tNOfJTF7k
         gxw4xMtEoswqKniQ06ZNG9CMwDgHYDbeSAlKVFdRH1mXweVzC7+RA6hPShid8OdbgMEM
         MGTuKy3r72+fMb9/feIOjEhXhjiacVytkNUX56g0UZbXZdcltREaPi7jzLbu4OUR8Eif
         HnCu+GysDRI6ksixzFmV7a62xGPYxn/JLU8yFNHp+tFEkJpNkdQTK0RDjVBFMc9VIXYn
         5l1HJIMh0YwdNYrEDOLaWycwO0MLnnTV6xAXzw73x+faPLoMurCSgJWYsNSy2jRmcg29
         TM2Q==
X-Gm-Message-State: AOAM5304OIkb4XcTQmcgytlUaD5O6FvhLGDjC1NtO0eX8S4PYm4rnrk5
        oYGwVVrZx+/K3O/ZXtCOqmeoHIbKwb1qqn+6ZRo=
X-Google-Smtp-Source: ABdhPJw783yUnhBinIrQN1PoywcVAxvPqJZP2rGxk3d0PWxbTSrFU4j1s/qRM2lWQnoTCcr8MUgHRd1KAvAW0m0+2TE=
X-Received: by 2002:a05:6638:2257:: with SMTP id m23mr12049282jas.137.1630951431431;
 Mon, 06 Sep 2021 11:03:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210906094301.GB10957@kili>
In-Reply-To: <20210906094301.GB10957@kili>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 6 Sep 2021 20:03:24 +0200
Message-ID: <CAOi1vP9bbs++zmcSJ=hb+PfR5-=QQbicHNNDu0uzcD_7XRG44g@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix off by one bugs in unsafe_request_wait()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Sep 6, 2021 at 11:43 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> The "> max" tests should be ">= max" to prevent an out of bounds access
> on the next lines.
>
> Fixes: e1a4541ec0b9 ("ceph: flush the mdlog before waiting on unsafe reqs")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  fs/ceph/caps.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 26c5029629a4..ebbad9080422 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2260,7 +2260,7 @@ static int unsafe_request_wait(struct inode *inode)
>                         list_for_each_entry(req, &ci->i_unsafe_dirops,
>                                             r_unsafe_dir_item) {
>                                 s = req->r_session;
> -                               if (unlikely(s->s_mds > max)) {
> +                               if (unlikely(s->s_mds >= max)) {
>                                         spin_unlock(&ci->i_unsafe_lock);
>                                         goto retry;
>                                 }
> @@ -2274,7 +2274,7 @@ static int unsafe_request_wait(struct inode *inode)
>                         list_for_each_entry(req, &ci->i_unsafe_iops,
>                                             r_unsafe_target_item) {
>                                 s = req->r_session;
> -                               if (unlikely(s->s_mds > max)) {
> +                               if (unlikely(s->s_mds >= max)) {
>                                         spin_unlock(&ci->i_unsafe_lock);
>                                         goto retry;
>                                 }
> --
> 2.20.1
>

Applied.

Thanks,

                Ilya
