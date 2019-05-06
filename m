Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 440861485B
	for <lists+ceph-devel@lfdr.de>; Mon,  6 May 2019 12:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbfEFKcD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 May 2019 06:32:03 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:35866 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfEFKcD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 May 2019 06:32:03 -0400
Received: by mail-it1-f195.google.com with SMTP id o190so1963908itc.1
        for <ceph-devel@vger.kernel.org>; Mon, 06 May 2019 03:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uExS0G130Twbb9bXebFAElKupAr2TQx0fgG35DglC6I=;
        b=G/g4uJqLfS5CYp2dgPVEKPzA5Jm9wIRd7ryuMoBr1rjARmbcP4k308ODJkFlR8kUa5
         +tDjCRBiso6ECflN6IwRcd9VRzvA//Wjaow0nAvuZNznp5NUFfNqJ0ddayF/3UNd4Fk7
         wgL+oFZ4B4JtT2q70zNvrgYxPM7p5h7YKq53B6XJnDJlcVWftOWkMOdTUqTK/L2QHDUV
         SXhxUcnAI+eMPf3xbqFJJKUtnd5myCW4KwGV/3lsY3ZfNxgU2QlQr3ZN+6WU3+Ppop9Z
         RGhGpnll6BzeRrLZ/X3V+Ikw1fKHvufx/vZVl1y3Y52FVgCYUsfDa/wQpv9CLQWWWOV/
         HZ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uExS0G130Twbb9bXebFAElKupAr2TQx0fgG35DglC6I=;
        b=HuheeYmmxbCFFGp1H0bPgVh1WTxbBcwJirDMVCKHRcIIdIGytSrkHShaAfjcoSahxU
         TLWQNhiuzecszbkg9xfLRk8zyOp9WfLlnIL3uJO9Sqe6ZHzXvVZn894Xiry5TDHf/hMD
         aimP7ZuE51VzNkgVk3eW9qaWBUKKMTPKWikhNs+jgnsR3O/Weti0apNHPoiD3IHzlMUu
         dyNCikAWV3Vac17CNcWaiu2UhZj054mdfdZgH9lHcQ4AOHTA7wZxOgGo8HC6choU7cJ5
         huKIzoQCvrGpnGWhhzMyFJsIetOZerAM6zvtCq27yFOUngiwWJGglcFoLjoSewYYT35O
         wrjA==
X-Gm-Message-State: APjAAAXP9vj1AcTAOGf0z72BtMMHxXp/+fvzFIVtIXxk+oKJeVdbB9x+
        G8yAJ+a+ODm2AoQ0HBOCGAhv2DxR/V4h+G138wk=
X-Google-Smtp-Source: APXvYqx/8Z4w0i1df65p7a1tLBNHX0552OTB862c4WP4XmTiRJfOJd9fzY3WpuptaHhtbF6EKS2KYpKMv61UgqCz8O0=
X-Received: by 2002:a24:96c1:: with SMTP id z184mr15438917itd.18.1557138722556;
 Mon, 06 May 2019 03:32:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190502184638.3614-1-jlayton@kernel.org>
In-Reply-To: <20190502184638.3614-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 6 May 2019 12:32:09 +0200
Message-ID: <CAOi1vP9JPn6B8Ss8TPOPVND=D=YOYHmd15ghfYvhe4dxX9TZ_g@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] libceph: fix unaligned accesses in
 ceph_entity_addr handling
To:     Jeff Layton <jlayton@kernel.org>
Cc:     "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, May 2, 2019 at 8:46 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> GCC9 is throwing a lot of warnings about unaligned access. This patch
> fixes some of them by changing most of the sockaddr handling functions
> to take a pointer to struct ceph_entity_addr instead of struct
> sockaddr_storage.  The lower functions can then take copies or do
> unaligned accesses as needed.

Linus has disabled this warning in 5.1 [1], but these look real to me,
at least when sockaddr_storage is coming from ceph_entity_inst.  I'd be
happier if we defined non-packed variants of ceph_entity_addr and
ceph_entity_inst and used them throughout the code, but that's likely
a lot more churn.  I might take a stab at it just to see how it goes...

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6f303d60534c46aa1a239f29c321f95c83dda748

>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  net/ceph/messenger.c | 77 ++++++++++++++++++++++----------------------
>  1 file changed, 38 insertions(+), 39 deletions(-)
>
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index 3083988ce729..54713836cac3 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -449,7 +449,7 @@ static void set_sock_callbacks(struct socket *sock,
>   */
>  static int ceph_tcp_connect(struct ceph_connection *con)
>  {
> -       struct sockaddr_storage *paddr = &con->peer_addr.in_addr;
> +       struct sockaddr_storage addr = con->peer_addr.in_addr;

Probably worth a comment, even something as short as /* align */.

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

Same here.

> +       struct in_addr *addr = &((struct sockaddr_in *)&ss)->sin_addr;
> +       struct in6_addr *addr6 = &((struct sockaddr_in6 *)&ss)->sin6_addr;
>
> -       switch (ss->ss_family) {
> +       switch (ss.ss_family) {
>         case AF_INET:
>                 return addr->s_addr == htonl(INADDR_ANY);
>         case AF_INET6:
> @@ -1810,25 +1811,27 @@ static bool addr_is_blank(struct sockaddr_storage *ss)
>         }
>  }
>
> -static int addr_port(struct sockaddr_storage *ss)
> +static int addr_port(struct ceph_entity_addr *ea)
>  {
> -       switch (ss->ss_family) {
> +       struct sockaddr_storage ss = ea->in_addr;
> +
> +       switch (ss.ss_family) {
>         case AF_INET:
> -               return ntohs(((struct sockaddr_in *)ss)->sin_port);
> +               return ntohs(((struct sockaddr_in *)&ss)->sin_port);
>         case AF_INET6:
> -               return ntohs(((struct sockaddr_in6 *)ss)->sin6_port);
> +               return ntohs(((struct sockaddr_in6 *)&ss)->sin6_port);
>         }
>         return 0;
>  }

Can we do the get_unaligned() dance instead of copying here?

Thanks,

                Ilya
