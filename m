Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB6D36C90E
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Apr 2021 18:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236703AbhD0QIc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Apr 2021 12:08:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47913 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233501AbhD0QI3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 12:08:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619539666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xEl8N9V4LZgoxkPvQPzysIttGcM9hCPt9aneDDOvro4=;
        b=ZVNF9ns62Ce5XO9e6+3oUhGb9M5Uica00lByCLDqHRWbEReFjCr/ejJsvGAEBomrOZ2ZeW
        y4XrSFQ6FL1U+w9ldZsr40FI59Twb8dzNi90QBiZ4e8s/mvx2ROP+k/KK+4V63CygN2g63
        t/+SXPUa0WX6Vy0lK/LbrlyOvxngY1s=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-caneHJT1PR69-HLv4GsKjw-1; Tue, 27 Apr 2021 12:07:38 -0400
X-MC-Unique: caneHJT1PR69-HLv4GsKjw-1
Received: by mail-il1-f198.google.com with SMTP id x7-20020a056e021ca7b029016344dffb7bso30822350ill.2
        for <ceph-devel@vger.kernel.org>; Tue, 27 Apr 2021 09:07:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xEl8N9V4LZgoxkPvQPzysIttGcM9hCPt9aneDDOvro4=;
        b=Lthq8PXs0HHBt8FRMROERbXQJPfaZv3t46QmqpJssAdWHfK0yzab4Gog3AUVnhHHPU
         FYQNGDxKJkfycnr1cJXhmobg0D9YZ3XEPzGXfCHbY4+gAu2hYSJL9kfp6myPFe8voOMV
         ooP8+kHsH1unDiYfvRI4u54FUCz7QoN3f7A3beI8/I+dtyfeRescfXYGnLuSmma15X97
         1xb5TIkPUTf8naVs3gfzkFG6zF4ZNOU6ol36H6/mtAMV9Kd7pRXxc3AE1clBKijOzpQV
         xIO5wSR5Xy4XonsMvez/NXze+/t+zwyVqK+uYVs4CWIf9AsSO1sx/6JLqBVhT6uWa9nM
         HSPA==
X-Gm-Message-State: AOAM532YI+aT0d0GhpM2okqFPje7c6fnOB7AVBivTST9mhpcFn+oL4Jw
        IjH/tuKCET63ZOY4zKHktHWRaDRqV3m/yck6dcknx5MiwIxYGyXP8Sd+oGV1NkNfoU8AbEyKLEb
        cv969QY7/wv7Uu2zdb53hReUn3HAjnE541lHQ7w==
X-Received: by 2002:a05:6e02:1cac:: with SMTP id x12mr17657016ill.43.1619539658233;
        Tue, 27 Apr 2021 09:07:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzpoAdKAW3FW7/av8XYRbYtHcE8gtrRhOBNnqY05Ur7qzkD1oj6FKXVpUHRQl92jV44Yp8BQatV95zExoACvBw=
X-Received: by 2002:a05:6e02:1cac:: with SMTP id x12mr17656993ill.43.1619539657965;
 Tue, 27 Apr 2021 09:07:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210425200514.26581-1-idryomov@gmail.com>
In-Reply-To: <20210425200514.26581-1-idryomov@gmail.com>
From:   Sage Weil <sweil@redhat.com>
Date:   Tue, 27 Apr 2021 11:07:27 -0500
Message-ID: <CAOQ2QO9mELUnZF3vWBjyMdpsXQL89KEx-r=VpB_AmrNKAseGtg@mail.gmail.com>
Subject: Re: [PATCH] libceph: bump CephXAuthenticate encoding version
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, Sage Weil <sage@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, Apr 25, 2021 at 3:05 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> A dummy v3 encoding (exactly the same as v2) was introduced so that
> the monitors can distinguish broken clients that may not include their
> auth ticket in CEPHX_GET_AUTH_SESSION_KEY request on reconnects, thus
> failing to prove previous possession of their global_id (one part of
> CVE-2021-20288).
>
> The kernel client has always included its auth ticket, so it is
> compatible with enforcing mode as is.  However we want to bump the
> encoding version to avoid having to authenticate twice on the initial
> connect -- all legacy (CephXAuthenticate < v3) are now forced do so in
> order to expose insecure global_id reclaim.
>
> Marking for stable since at least for 5.11 and 5.12 it is trivial
> (v2 -> v3).
>
> Cc: stable@vger.kernel.org # 5.11+
> URL: https://tracker.ceph.com/issues/50452
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Reviewed-by: Sage Weil <sage@redhat.com>

>
> ---
>  net/ceph/auth_x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ceph/auth_x.c b/net/ceph/auth_x.c
> index ca44c327bace..79641c4afee9 100644
> --- a/net/ceph/auth_x.c
> +++ b/net/ceph/auth_x.c
> @@ -526,7 +526,7 @@ static int ceph_x_build_request(struct ceph_auth_client *ac,
>                 if (ret < 0)
>                         return ret;
>
> -               auth->struct_v = 2;  /* nautilus+ */
> +               auth->struct_v = 3;  /* nautilus+ */
>                 auth->key = 0;
>                 for (u = (u64 *)enc_buf; u + 1 <= (u64 *)(enc_buf + ret); u++)
>                         auth->key ^= *(__le64 *)u;
> --
> 2.19.2
>

