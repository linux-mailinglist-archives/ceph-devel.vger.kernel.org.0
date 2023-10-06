Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889847BB5B1
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Oct 2023 12:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbjJFKxc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 Oct 2023 06:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbjJFKxb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 Oct 2023 06:53:31 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD26383;
        Fri,  6 Oct 2023 03:53:29 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id 006d021491bc7-57be3d8e738so1062729eaf.1;
        Fri, 06 Oct 2023 03:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696589609; x=1697194409; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E6vE3/krN1AO7j/bpBiLGzhOiia0/4oh1GEJ69E90i0=;
        b=VDNQgqAGie/WFKpUoxKr8D/zyefQ46ApeYQU5VXmLlqIBAAedb+SZt3hJzwCUcJaA2
         5Ba96BcR/72Gq2Q6nYE6ChpQaGlMMx1lTX5qKUliWETXl1ir6ZjJeFjD2gVJOZwKoGRX
         BIXiDrRQIUUSW04FrwUu1TntgrAQbSwU+ZFrNCP66ycH6BVXfyJoxVG1pbmA5Ihb0Sxs
         M1Gf6G3JqYL2zICw6Ot+uyVjIavruxtHGlrnI9ljOaVNw+uwLnAGOdXjF5dxLVU2wGKO
         1RNJ7O6bPbl0cG8pEx3iqGBE9STlPLIxiuQe4cVdox2Mx0H1icY4d5H7dTqPS9yevX+B
         vcJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696589609; x=1697194409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E6vE3/krN1AO7j/bpBiLGzhOiia0/4oh1GEJ69E90i0=;
        b=F/PK0a4jF3+rEnAp94MoSrucbKa8Ll2PqnL9g1y9kWxIeCO8GyQ6V1cMZLyzxCq5pA
         haFJMTtpnKuVi+kVL9KCK6PqbA3nyrlm5OU+dHpovcJUqkcqKyOk5GnZBoUPDT8CeHUe
         dG41/bDIVS2YjZpxR9AP9SrsOXWvoGI6/FPT6bknBaqisx75nHVgLJHtv3aj36iYEnmi
         pL2wPL94CddQiCqhDbTw55/Qn6tQnA4FXvMUHknH+888s6g/kzw1Beauju2Y+GAdeB34
         YNeVm9TdRGNmebrKL7jKDcWUo2nI8qnGDq5boYKNlA+T31SHOiJTx68aMVS0zub9RMKA
         8yEw==
X-Gm-Message-State: AOJu0YwLZGDEPGidykFlIbmhent/YcG39Xmj0VvOFIoK2HeleIY3Kyzr
        mfKpWojO6ALw8+PNeOAH0zCDB04rJrnPIc4EcXY=
X-Google-Smtp-Source: AGHT+IEfKjob26JT9W05dIl3WLBo9U7hfgjJU2Rcr+N6dOI+zpgwbWFUqONWtnPMnSvNA4fvDvTN/wVkNJMchlF66Ko=
X-Received: by 2002:a4a:d2dc:0:b0:571:1a1d:f230 with SMTP id
 j28-20020a4ad2dc000000b005711a1df230mr7726107oos.9.1696589609082; Fri, 06 Oct
 2023 03:53:29 -0700 (PDT)
MIME-Version: 1.0
References: <20231004233827.1274148-1-jrife@google.com>
In-Reply-To: <20231004233827.1274148-1-jrife@google.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 6 Oct 2023 12:53:17 +0200
Message-ID: <CAOi1vP-9L7rDxL6Wv_=6uuxVV_d-qK7StyDLBbvpZZcXmg6+Mg@mail.gmail.com>
Subject: Re: [PATCH] ceph: use kernel_connect()
To:     Jordan Rife <jrife@google.com>
Cc:     ceph-devel@vger.kernel.org, xiubli@redhat.com, jlayton@kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Oct 5, 2023 at 1:39=E2=80=AFAM Jordan Rife <jrife@google.com> wrote=
:
>
> Direct calls to ops->connect() can overwrite the address parameter when
> used in conjunction with BPF SOCK_ADDR hooks. Recent changes to
> kernel_connect() ensure that callers are insulated from such side
> effects. This patch wraps the direct call to ops->connect() with
> kernel_connect() to prevent unexpected changes to the address passed to
> ceph_tcp_connect().
>
> This change was originally part of a larger patch targeting the net tree
> addressing all instances of unprotected calls to ops->connect()
> throughout the kernel, but this change was split up into several patches
> targeting various trees.
>
> Link: https://lore.kernel.org/netdev/20230821100007.559638-1-jrife@google=
.com/
> Link: https://lore.kernel.org/netdev/9944248dba1bce861375fcce9de663934d93=
3ba9.camel@redhat.com/
> Fixes: d74bad4e74ee ("bpf: Hooks for sys_connect")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jordan Rife <jrife@google.com>
> ---
>  net/ceph/messenger.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index 10a41cd9c5235..3c8b78d9c4d1c 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -459,8 +459,8 @@ int ceph_tcp_connect(struct ceph_connection *con)
>         set_sock_callbacks(sock, con);
>
>         con_sock_state_connecting(con);
> -       ret =3D sock->ops->connect(sock, (struct sockaddr *)&ss, sizeof(s=
s),
> -                                O_NONBLOCK);
> +       ret =3D kernel_connect(sock, (struct sockaddr *)&ss, sizeof(ss),
> +                            O_NONBLOCK);
>         if (ret =3D=3D -EINPROGRESS) {
>                 dout("connect %s EINPROGRESS sk_state =3D %u\n",
>                      ceph_pr_addr(&con->peer_addr),
> --
> 2.42.0.582.g8ccd20d70d-goog
>

Hi Jordan,

I'm a bit confused.  This is marked as fixing commit d74bad4e74ee
("bpf: Hooks for sys_connect") and also for stable, but doesn't
(explicitly, at least) mention the prerequisite commit 0bdf399342c5
("net: Avoid address overwrite in kernel_connect") which isn't marked
for stable.  Was it forwarded to the stable team separately?

Thanks,

                Ilya
