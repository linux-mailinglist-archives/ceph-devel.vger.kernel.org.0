Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07C021B1C9
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jul 2020 10:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgGJI54 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Jul 2020 04:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726644AbgGJI54 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 10 Jul 2020 04:57:56 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B34EC08C5CE
        for <ceph-devel@vger.kernel.org>; Fri, 10 Jul 2020 01:57:56 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id h16so4422580ilj.11
        for <ceph-devel@vger.kernel.org>; Fri, 10 Jul 2020 01:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7BeHqHgNDviJoCB9XUZY9JuB2hHWftmD5A0GXQv7Wyc=;
        b=gij2IIxJlCMd/AM/EJfVNcf/wkoPDraTD8OVyC00VNtKzJl+ZdSdWFhwID9wcqCEty
         y3DPquBWuLmwBqwpWuFO37vMwMP5+eyrpoqrcHdgFC0/qg/IuQSV3UpB2N8OKMmlvewg
         b5KOpBsTUp7oT5MBiyi2ZzokQZxnTer1W3OadTb3op1dI17o0RisoBcmxkITiKU8rLBZ
         hBnWSbyb4xTnVV1idKdA5ag/H++Ssxs3ZAFXDlNZXqYtDjfpsqRI4EhbvpZoSjvk2Lhh
         a8HkmRmWu7RDi0ECJMGO1LDLsWjRKddY8Av8erFNG/v5Jnwcb3SFnXZwzRczPziTPrBB
         c0jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7BeHqHgNDviJoCB9XUZY9JuB2hHWftmD5A0GXQv7Wyc=;
        b=NmfqF5DcTX35m2FeHfU+tyQODtz3vZtFKbMx6qVDTmojWRhlWnd4hKVH35Bu9f3mVV
         9Fu4OXE6/N07tZxK0Q44hfM5HDapcr+kj+jTziwDi7Lp2W84ynP52A/RRHUXhsIxc0GJ
         pyi3pNgL1SdkezVfECI5tLRW3CfDYS9DGpjDAN+tDycK0p0Tx4+g7EUE9mPRNvk/YNxM
         quZJFbttIaWFFXR3iEha8dhvhCPa8VTVQ9BeG9Qnc/nWwXnCrX4fIGDyubbwrPKMbPhz
         oN0fhF7gpp9kugbnnd4rcRICst8qWy5ipvNugxg2WpYzfm3X9yw38t3VuioCRZdLNiB8
         ssBg==
X-Gm-Message-State: AOAM533z9SMZjceKhNaIuLOhPC2vJidJG1Su/S3z0FwhoScOhgHE/kYs
        1RcIXetDh9EYXZYUTnQNvSOIdqm95Wybx2wcBKA=
X-Google-Smtp-Source: ABdhPJwVz3r5VzcBpEqylcVudPcGUj4pFv6HT1E/6UiLEbZx5YdR5gJVdCpy6ARmqH4t8t+fYMzNTmIer+zG3SgpmRI=
X-Received: by 2002:a92:794f:: with SMTP id u76mr46936555ilc.215.1594371475497;
 Fri, 10 Jul 2020 01:57:55 -0700 (PDT)
MIME-Version: 1.0
References: <1594355944-7137-1-git-send-email-simon29rock@gmail.com>
In-Reply-To: <1594355944-7137-1-git-send-email-simon29rock@gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 10 Jul 2020 10:58:02 +0200
Message-ID: <CAOi1vP9vPq9TcG9qiEEtDb795PZ2QjDTye=89E4yrjEaFSHE7g@mail.gmail.com>
Subject: Re: [PATCH] net : client only want latest osdmap. If the gap with the
 latest version exceeds the threshold, mon will send the fullosdmap instead of
 incremental osdmap
To:     simon gao <simon29rock@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jul 10, 2020 at 6:39 AM simon gao <simon29rock@gmail.com> wrote:
>
> Fix: https://tracker.ceph.com/issues/43421
> Signed-off-by: simon gao <simon29rock@gmail.com>
> ---
>  include/linux/ceph/ceph_fs.h | 1 +
>  net/ceph/mon_client.c        | 3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index ebf5ba6..9dcc132 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -208,6 +208,7 @@ struct ceph_client_mount {
>  } __attribute__ ((packed));
>
>  #define CEPH_SUBSCRIBE_ONETIME    1  /* i want only 1 update after have */
> +#define CEPH_SUBSCRIBE_LATEST_OSDMAP   2  /* i want the latest fullmap, for client */

Hi Simon,

Where is this flag introduced?  Looks like it is mentioned in the
comments of https://github.com/ceph/ceph/pull/32422, but it is not
actually added anywhere I can see.

>
>  struct ceph_mon_subscribe_item {
>         __le64 start;
> diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
> index 3d8c801..b0d1ce6 100644
> --- a/net/ceph/mon_client.c
> +++ b/net/ceph/mon_client.c
> @@ -349,7 +349,8 @@ static bool __ceph_monc_want_map(struct ceph_mon_client *monc, int sub,
>  {
>         __le64 start = cpu_to_le64(epoch);
>         u8 flags = !continuous ? CEPH_SUBSCRIBE_ONETIME : 0;
> -
> +    if (CEPH_SUB_OSDMAP == sub)
> +        flags |= CEPH_SUBSCRIBE_LATEST_OSDMAP

This won't compile because of the missing semicolon.

Thanks,

                Ilya
