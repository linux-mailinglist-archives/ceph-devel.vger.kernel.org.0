Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8DCE14B5C
	for <lists+ceph-devel@lfdr.de>; Mon,  6 May 2019 15:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfEFN5a (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 May 2019 09:57:30 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:53048 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbfEFN5a (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 May 2019 09:57:30 -0400
Received: by mail-it1-f196.google.com with SMTP id q65so18900930itg.2
        for <ceph-devel@vger.kernel.org>; Mon, 06 May 2019 06:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BgmdBDC+AZt2Xq/br9uLua448SZi0DJ4DadVR17K6Qg=;
        b=pK2r7SiaDuyoyGHxuuldBZ0qIoY3ptXjCR8sKPpeYrg0MGE2kLGGaIPoUuxi0rqxsF
         eGJwkDCwZvkwTpg2uuZjVDtDV7KXgxsyrXMWZR34g7biMg1cqRQgKZxE34aXHCaXgZ3g
         G3MIJxQ09JIb+7on4RWBDKG7Qjnzg0wzcnFRfhCCrcTrEt+I2TGEr4kc1lJyJFsf/4Hj
         bsoBjQoc3v8+g//6u+fwWMiB0S2aQrixHvPx+zY4xl+wn0qValVCoHjrjOX9kagyMLyy
         dEhjPoIlp4lkJ+8E1TBEWmNg1TNhYCTwaEnPIjunj5h0bXo56HwH52zKM5mgbbiPTXiO
         oVsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BgmdBDC+AZt2Xq/br9uLua448SZi0DJ4DadVR17K6Qg=;
        b=au4HuH5ohhwgcd9FoF/wJ3vrNmy8YAzdqK2OrGcNYzJNIIR4OpsG4m63WWS4zN11m8
         PgumDkWAHGAMDSuwYAB4D0lpqW0Uv+dzciuZXPuKqpAJ+T+CjMnYRmJjxwrK37PGCPFY
         geVpA+45yO+RNCGuYalP+F0xFlmblrneHO1GcYmkCjakOXnr8lSHsUlF9tU0ok5MzSX/
         eF8z1ZoSHYFXhqCq+TXoBvKiKjOPjT4Dka+qTt+y3mifSiG2EvbINGi7djq45G9lg60I
         2g1zQDPvGX7TmIxIeOqbQZmuIEXJ0xvaYhEIgivT89dPSrhDzpKPwqQ3/5Svv0E30Kmg
         VOcQ==
X-Gm-Message-State: APjAAAWktd3Z97aT4qai9rCc9tPk+4YzuB1PMRtJ2AfGJV+1EsrtYOsx
        47IR7SVE+g6pNzIEW0t8KNbT/uGDEA3BwRf8uFs=
X-Google-Smtp-Source: APXvYqzIFnc3Mby4rc5juYnf9GioyYpR2GUS/3bKFShSHvrqgkt7clCqdms7lJpl0YW08L1qs4brJh1ZwZvTad7ve0g=
X-Received: by 2002:a24:7688:: with SMTP id z130mr17483189itb.57.1557151049421;
 Mon, 06 May 2019 06:57:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190506133847.7394-1-jlayton@kernel.org>
In-Reply-To: <20190506133847.7394-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 6 May 2019 15:57:36 +0200
Message-ID: <CAOi1vP8Fs2mYvH276PNghEhE2ro1UR8yStxrM8a1awjskXczRw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] libceph: fix unaligned accesses in
 ceph_entity_addr handling
To:     Jeff Layton <jlayton@kernel.org>
Cc:     "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, May 6, 2019 at 3:38 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> GCC9 is throwing a lot of warnings about unaligned access. This patch
> fixes some of them by changing most of the sockaddr handling functions
> to take a pointer to struct ceph_entity_addr instead of struct
> sockaddr_storage.  The lower functions can then make copies or do
> unaligned accesses as needed.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  net/ceph/messenger.c | 75 +++++++++++++++++++++-----------------------
>  1 file changed, 36 insertions(+), 39 deletions(-)
>
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index 3083988ce729..3cb8ce385fce 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -449,7 +449,7 @@ static void set_sock_callbacks(struct socket *sock,
>   */
>  static int ceph_tcp_connect(struct ceph_connection *con)
>  {
> -       struct sockaddr_storage *paddr = &con->peer_addr.in_addr;
> +       struct sockaddr_storage addr = con->peer_addr.in_addr; /* align */
>         struct socket *sock;
>         unsigned int noio_flag;
>         int ret;
> @@ -458,7 +458,7 @@ static int ceph_tcp_connect(struct ceph_connection *con)
>
>         /* sock_create_kern() allocates with GFP_KERNEL */
>         noio_flag = memalloc_noio_save();
> -       ret = sock_create_kern(read_pnet(&con->msgr->net), paddr->ss_family,
> +       ret = sock_create_kern(read_pnet(&con->msgr->net), addr.ss_family,
>                                SOCK_STREAM, IPPROTO_TCP, &sock);
>         memalloc_noio_restore(noio_flag);
>         if (ret)
> @@ -474,7 +474,7 @@ static int ceph_tcp_connect(struct ceph_connection *con)
>         dout("connect %s\n", ceph_pr_addr(&con->peer_addr.in_addr));
>
>         con_sock_state_connecting(con);
> -       ret = sock->ops->connect(sock, (struct sockaddr *)paddr, sizeof(*paddr),
> +       ret = sock->ops->connect(sock, (struct sockaddr *)&addr, sizeof(addr),
>                                  O_NONBLOCK);
>         if (ret == -EINPROGRESS) {
>                 dout("connect %s EINPROGRESS sk_state = %u\n",
> @@ -1795,12 +1795,13 @@ static int verify_hello(struct ceph_connection *con)
>         return 0;
>  }
>
> -static bool addr_is_blank(struct sockaddr_storage *ss)
> +static bool addr_is_blank(struct ceph_entity_addr *ea)
>  {
> -       struct in_addr *addr = &((struct sockaddr_in *)ss)->sin_addr;
> -       struct in6_addr *addr6 = &((struct sockaddr_in6 *)ss)->sin6_addr;
> +       struct sockaddr_storage ss = ea->in_addr;
> +       struct in_addr *addr = &((struct sockaddr_in *)&ss)->sin_addr;
> +       struct in6_addr *addr6 = &((struct sockaddr_in6 *)&ss)->sin6_addr;
>
> -       switch (ss->ss_family) {
> +       switch (ss.ss_family) {
>         case AF_INET:
>                 return addr->s_addr == htonl(INADDR_ANY);
>         case AF_INET6:
> @@ -1810,25 +1811,25 @@ static bool addr_is_blank(struct sockaddr_storage *ss)
>         }
>  }
>
> -static int addr_port(struct sockaddr_storage *ss)
> +static int addr_port(struct ceph_entity_addr *ea)
>  {
> -       switch (ss->ss_family) {
> +       switch (get_unaligned(&ea->in_addr.ss_family)) {
>         case AF_INET:
> -               return ntohs(((struct sockaddr_in *)ss)->sin_port);
> +               return ntohs(get_unaligned(&((struct sockaddr_in *)&ea->in_addr)->sin_port));
>         case AF_INET6:
> -               return ntohs(((struct sockaddr_in6 *)ss)->sin6_port);
> +               return ntohs(get_unaligned(&((struct sockaddr_in6 *)&ea->in_addr)->sin6_port));
>         }
>         return 0;
>  }

This is what I had in mind (I don't have gcc 9 around to play with).

Looks good.  I have a couple of naming nits: sockaddr_storage in
ceph_tcp_connect() can be "ss" and ceph_entity_addr * here and in
addr_is_blank() can be "*addr" for consistency with existing code.
I'll fix that and apply.

Thanks,

                Ilya
