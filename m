Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA7621D7B7
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Jul 2020 16:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729910AbgGMOBr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Jul 2020 10:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729695AbgGMOBr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 Jul 2020 10:01:47 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F2CC061755
        for <ceph-devel@vger.kernel.org>; Mon, 13 Jul 2020 07:01:47 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id x9so11249047ila.3
        for <ceph-devel@vger.kernel.org>; Mon, 13 Jul 2020 07:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C/ldBOVg/9zo/Thh80xmgTfndCMiEGo4nwBB79ciReM=;
        b=L07JlyZ7w6BXdPSUoe7yIp4BZXN0BRN4sxQ54O8WupLzUmT5mETd1Cp3R/M4sR5iXf
         onA99C0R/rIEEHUUYafazKjfoNsWiVUt3oSw3eXX2lTg921P/KlFKaXVQBAH7kmLhP1a
         YMlolQgXlaQ1IvwGkbkqfZ105ctTuJiAY5pHSsbKB2uzn3P3OhCNQhySWJ+WdumOzuqe
         usOD0vdBZ9R0h9y4CLtNlfAO1RzZP2kodEKkCDFwXWo/S/fHMkbZJVMr+15K8eCztEnW
         XEIyjMWEGg1a1F5GKMB/cxgCm0MxbfdGkWNUInUbOcFjqJjGXnXbtJh9H9N+uYvA69bH
         Yb9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C/ldBOVg/9zo/Thh80xmgTfndCMiEGo4nwBB79ciReM=;
        b=hW/YgRVQ9Xr8sAVfpsbWDThthkuDEhCLgtyy/G6HuqXu3RZZWeFZ8zJULS+AsFWayz
         FTeitX+SNGWxN1QZOsyL2dpXTJ+ULjKkWlGFZpwakTtQv3eKksfOccCXeHA6hVbIE/h3
         KX+UDhjhI+2cBlI9T7/s7Ddpu6cDWK4SKyqu/vMcD50btsECl0Nig00U/vGoGA0TuCnQ
         3MTdpGaolehVNcyv86+Idu4J6dcNGFGAh/DP6bx/Ds/wj2M0dEcHVy0fnS9K1Fjs1n5I
         e0eUOMTtlGGhqX4HY7egv1ChjinRk8d98K6+gw+smLuue024RmRJT03e3L7fRPjgNPTT
         nxUw==
X-Gm-Message-State: AOAM531pMvai5drNOAV1kK+brXvpUXqYpGiHuy+tBAMJ7U1YrgOmWrjv
        vIjHlgPd80zG8rQ6DumcTNcxks6zEPbKE9XZp8s=
X-Google-Smtp-Source: ABdhPJxmndsCk436sd4q2SOYZzCa7krVM/DHHNEYy7K5MkrnlaJUvHSCFJlmyGv3ysB0N2AEEbC0DhTdiMOnHmbhPRg=
X-Received: by 2002:a05:6e02:d51:: with SMTP id h17mr66348183ilj.131.1594648906499;
 Mon, 13 Jul 2020 07:01:46 -0700 (PDT)
MIME-Version: 1.0
References: <1594439373-2120-1-git-send-email-simon29rock@gmail.com>
In-Reply-To: <1594439373-2120-1-git-send-email-simon29rock@gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 13 Jul 2020 16:01:51 +0200
Message-ID: <CAOi1vP9Qu4QZcpLBYcpmxfsBFh-p0MxOFKw75qZH6QM=AusSPQ@mail.gmail.com>
Subject: Re: [PATCH] libceph : client only want latest osdmap. If the gap with
 the latest version exceeds the threshold, mon will send the fullosdmap
 instead of incremental osdmap
To:     simon gao <simon29rock@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, Jul 11, 2020 at 5:52 AM simon gao <simon29rock@gmail.com> wrote:
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
>
>  struct ceph_mon_subscribe_item {
>         __le64 start;
> diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
> index 3d8c801..8d67671 100644
> --- a/net/ceph/mon_client.c
> +++ b/net/ceph/mon_client.c
> @@ -349,7 +349,8 @@ static bool __ceph_monc_want_map(struct ceph_mon_client *monc, int sub,
>  {
>         __le64 start = cpu_to_le64(epoch);
>         u8 flags = !continuous ? CEPH_SUBSCRIBE_ONETIME : 0;
> -
> +       if (CEPH_SUB_OSDMAP == sub)
> +            flags |= CEPH_SUBSCRIBE_LATEST_OSDMAP;
>         dout("%s %s epoch %u continuous %d\n", __func__, ceph_sub_str[sub],
>              epoch, continuous);

I left my comments in https://github.com/ceph/ceph/pull/32422.
This patch cannot be considered unless a corresponding change is
merged into Objecter.

Thanks,

                Ilya
