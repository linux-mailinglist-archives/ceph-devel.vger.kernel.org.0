Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C217380594
	for <lists+ceph-devel@lfdr.de>; Fri, 14 May 2021 10:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhENIyR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 May 2021 04:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbhENIyR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 14 May 2021 04:54:17 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E6BC061574;
        Fri, 14 May 2021 01:53:05 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id r5so25239104ilb.2;
        Fri, 14 May 2021 01:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qayX7zhi1zPzWfW6+6qw+j9s4Gb6sXImv1cPAAHWTPc=;
        b=NsOSXd5lSsEgESDlXDj+Nzr2yzyy8QbLdeMrHPW+gesGwaAemQY0NqnbhYlo7SGtp7
         0p8sRUPBuim+yCrGNklS4DfhQDs4isJqz6m/gzUT07HKYgQl2XO49/+LNotGrFiKwNry
         0q7burohApTyz/cpNFt2PL1nwLYruGM8sc1XrdSVEwIwiSIDKzEzAqYtZ6qLd+XMIRO1
         VeU4Iz/Z+KeQufMM7cZmeuE8JDEhHpLQVfmmp0pCtf9YMFXhGtSfrzfZvoUUtyreAe7N
         NpYiUNcb1aAwxvvU+u/gK4R/FnpX6rHrcqcrejoVhgzFL4VKnm+o9Yx0PKsMhsD5Ygfr
         tyRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qayX7zhi1zPzWfW6+6qw+j9s4Gb6sXImv1cPAAHWTPc=;
        b=GCdcQ7sR5bP8CLk7plQijXHuz4VkHRH7gaYqY/rkyHIWD85YNxCKzWTFWqLb8MRpGQ
         INljHQ/huRXq4Kuteq+MDIoM6ZgPygQ/KqtmdwKgGBulWGhdnp5TFbY2ByLbwiHPaQtd
         iEoYdrTgs6ceyRA4I3S6Q4/n/mpvPiacigGwptsUNkzOIh8rR7UClq5Y7XEcdT+/wJhx
         CsbaFGUcDVnhWg+mAgjMTeCGs81OxNYCLnQ0gZMNn4kts7mcKzD8ijeiIydBPs4/8rUY
         FKVLhvCLDwJAJxswr+Lumw1NYbCSPBMhNYiBtCVC1NTLC1oVbEKGLI1ZrjrCWtOAJgdL
         6stw==
X-Gm-Message-State: AOAM533JGZXtyK8lG5qVdRYTMVjGVu9VFmOfqaf1w/vC/MFFoRiCmjCW
        d9hYA0pZdvUwinWGazGSPavD37B3MKC57ffT0JY=
X-Google-Smtp-Source: ABdhPJynVVQ5BLTIsbnyQ2xjJBlWg+YMqKO2eOLz8o6Rj7suiQMI/hLmQVtqhyULHB4J6nYNfScxLV03hSiACROvdpk=
X-Received: by 2002:a05:6e02:eac:: with SMTP id u12mr40364277ilj.177.1620982384742;
 Fri, 14 May 2021 01:53:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210514063953.3242049-1-weiyongjun1@huawei.com>
In-Reply-To: <20210514063953.3242049-1-weiyongjun1@huawei.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 14 May 2021 10:53:14 +0200
Message-ID: <CAOi1vP9h=VNP1NP=Vb3kjoAKYzAGZOaznBgqn5v1RuKeh7zEOg@mail.gmail.com>
Subject: Re: [PATCH -next] ceph: make symbol 'ceph_netfs_read_ops' static
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, May 14, 2021 at 8:30 AM Wei Yongjun <weiyongjun1@huawei.com> wrote:
>
> The sparse tool complains as follows:
>
> fs/ceph/addr.c:316:37: warning:
>  symbol 'ceph_netfs_read_ops' was not declared. Should it be static?
>
> This symbol is not used outside of addr.c, so marks it static.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  fs/ceph/addr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index c1570fada3d8..5dfd18d84a3b 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -313,7 +313,7 @@ static void ceph_readahead_cleanup(struct address_space *mapping, void *priv)
>                 ceph_put_cap_refs(ci, got);
>  }
>
> -const struct netfs_read_request_ops ceph_netfs_read_ops = {
> +static const struct netfs_read_request_ops ceph_netfs_read_ops = {
>         .init_rreq              = ceph_init_rreq,
>         .is_cache_enabled       = ceph_is_cache_enabled,
>         .begin_cache_operation  = ceph_begin_cache_operation,
>

Applied.

Thanks,

                Ilya
