Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29D44456EF
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Jun 2019 10:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbfFNIGJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Jun 2019 04:06:09 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44632 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbfFNIGI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 14 Jun 2019 04:06:08 -0400
Received: by mail-qt1-f193.google.com with SMTP id x47so1447961qtk.11
        for <ceph-devel@vger.kernel.org>; Fri, 14 Jun 2019 01:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9W9yEllBGuvnKfoInthMdHBQrQumvpWRKfJ7538MiVk=;
        b=LIgzctlr810RRWnc+zNmzLx68SyC2YpJdqwYNq0JYY0dtdkvFk3j1Ff03e6Fw7X/OU
         rIM4MAFt4MZCK/KH3kd8S+SYpv2lBlKpncUehYD1lapDAGIqFm4MVD4pgJyhf/CmMiiV
         3OXQHPtHveVVRQUjIbZ4jZW2iH3UzaKuXbs721xXLJSX3PZXZ1edhy2wW+fMp07zjFYv
         Gmui0bUbQRUHGKD/06fFyKUFSzOwZP15unb8NndaGIJwretfCSYHZqVkjP2uGym30kc2
         WKjWxW2pug5ozOu2/0vbSpN5XwSicsVWlk0en69ZRvayJWoKfiDits1/eZ70cLn248CF
         m+8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9W9yEllBGuvnKfoInthMdHBQrQumvpWRKfJ7538MiVk=;
        b=oLh5UuVd5fHptngoDTRECtqk7xQdBiYyG8rnpNTggdCpFdgQEw3N5u7vn5Vzq/YVZR
         hoHRPglZdemQk7z7dhTXxcVNiW19fnUlaHE5XgzrsYvTuru/2wl7XA+X0GUfhu/7Xg5f
         0oDhaTaP+r5/ygsanGKj5OL7HMd5L02EUINZkKDkB+ZV+7XQyGeaSu4wOkDG+LU4OjyM
         sP6JcpF/e0AjXwEAoXdJpcqzJZ2ly0r/BrWYgnVFk98+uxEkyM8iqfZt+iHblLNPNtHE
         Q3X8ifEj4fN8EhIeuzKztRsaCaK2t9DywUiejBP9adA/RoKCj9qEF45TEKfA4nP0ckqy
         jpiw==
X-Gm-Message-State: APjAAAUkGcHOBbcYtDl1P9ycBQ953RTS7Q4xbjUdsuf+Kb/DhN+6nwOw
        /zceZ6X6VMOTBohpErJJuqyutNzX2TD6bzHk51w=
X-Google-Smtp-Source: APXvYqz63gs6A5xVBt0HNU/CQIyQIMIvq6y6d2P6QIBYMSBuB/fSKoSGpi1dBujRJwegJiS2zJ0UDaASIJZCzqK5GYc=
X-Received: by 2002:ac8:32e9:: with SMTP id a38mr81220610qtb.245.1560499567229;
 Fri, 14 Jun 2019 01:06:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190607153816.12918-1-jlayton@kernel.org> <20190607153816.12918-3-jlayton@kernel.org>
In-Reply-To: <20190607153816.12918-3-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Fri, 14 Jun 2019 16:05:55 +0800
Message-ID: <CAAM7YAnVF_+m-Ege6u5mS9wcT_ttJZrvRuWh7F3-49Yxd98kEA@mail.gmail.com>
Subject: Re: [PATCH 02/16] libceph: add ceph_decode_entity_addr
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@redhat.com>, Zheng Yan <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jun 7, 2019 at 11:38 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Add a way to decode an entity_addr_t. Once CEPH_FEATURE_MSG_ADDR2 is
> enabled, the server daemons will start encoding entity_addr_t
> differently.
>
> Add a new helper function that can handle either format.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  include/linux/ceph/decode.h |  2 +
>  net/ceph/Makefile           |  2 +-
>  net/ceph/decode.c           | 75 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 78 insertions(+), 1 deletion(-)
>  create mode 100644 net/ceph/decode.c
>
> diff --git a/include/linux/ceph/decode.h b/include/linux/ceph/decode.h
> index a6c2a48d42e0..1c0a665bfc03 100644
> --- a/include/linux/ceph/decode.h
> +++ b/include/linux/ceph/decode.h
> @@ -230,6 +230,8 @@ static inline void ceph_decode_addr(struct ceph_entity_addr *a)
>         WARN_ON(a->in_addr.ss_family == 512);
>  }
>
> +extern int ceph_decode_entity_addr(void **p, void *end,
> +                                  struct ceph_entity_addr *addr);
>  /*
>   * encoders
>   */
> diff --git a/net/ceph/Makefile b/net/ceph/Makefile
> index db09defe27d0..59d0ba2072de 100644
> --- a/net/ceph/Makefile
> +++ b/net/ceph/Makefile
> @@ -5,7 +5,7 @@
>  obj-$(CONFIG_CEPH_LIB) += libceph.o
>
>  libceph-y := ceph_common.o messenger.o msgpool.o buffer.o pagelist.o \
> -       mon_client.o \
> +       mon_client.o decode.o \
>         cls_lock_client.o \
>         osd_client.o osdmap.o crush/crush.o crush/mapper.o crush/hash.o \
>         striper.o \
> diff --git a/net/ceph/decode.c b/net/ceph/decode.c
> new file mode 100644
> index 000000000000..27edf5d341ec
> --- /dev/null
> +++ b/net/ceph/decode.c
> @@ -0,0 +1,75 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/ceph/decode.h>
> +
> +int
> +ceph_decode_entity_addr(void **p, void *end, struct ceph_entity_addr *addr)
> +{
> +       u8 marker, v, compat;

It's better to use name struct_v, struct_compat


> +       u32 len;
> +
> +       ceph_decode_8_safe(p, end, marker, bad);
> +       if (marker == 1) {
> +               ceph_decode_8_safe(p, end, v, bad);
> +               ceph_decode_8_safe(p, end, compat, bad);
> +               if (!v || compat != 1)
> +                       goto bad;
> +               /* FIXME: sanity check? */
> +               ceph_decode_32_safe(p, end, len, bad);
> +               /* type is __le32, so we must copy into place as-is */
> +               ceph_decode_copy_safe(p, end, &addr->type,
> +                                       sizeof(addr->type), bad);
> +
> +               /*
> +                * TYPE_NONE == 0
> +                * TYPE_LEGACY == 1
> +                *
> +                * Clients that don't support ADDR2 always send TYPE_NONE.
> +                * For now, since all we support is msgr1, just set this to 0
> +                * when we get a TYPE_LEGACY type.
> +                */
> +               if (addr->type == cpu_to_le32(1))
> +                       addr->type = 0;
> +       } else if (marker == 0) {
> +               addr->type = 0;
> +               /* Skip rest of type field */
> +               ceph_decode_skip_n(p, end, 3, bad);
> +       } else {

versioned encoding has forward compatibility.  The code should looks like

if (struct_v == 0) {
  /* old format */
  return;
}

if (struct_compat != 1)
   goto bad

end = *p + struct_len;

if  (struct_v == 1) {
....
}

if (struct_v == 2) {
...
}

*p = end;




> +               goto bad;
> +       }
> +
> +       ceph_decode_need(p, end, sizeof(addr->nonce), bad);
> +       ceph_decode_copy(p, &addr->nonce, sizeof(addr->nonce));
> +
> +       /* addr length */
> +       if (marker ==  1) {
> +               ceph_decode_32_safe(p, end, len, bad);
> +               if (len > sizeof(addr->in_addr))
> +                       goto bad;
> +       } else  {
> +               len = sizeof(addr->in_addr);
> +       }
> +
> +       memset(&addr->in_addr, 0, sizeof(addr->in_addr));
> +
> +       if (len) {
> +               ceph_decode_need(p, end, len, bad);
> +               ceph_decode_copy(p, &addr->in_addr, len);
> +
> +               /*
> +                * Fix up sa_family. Legacy encoding sends it in BE, addr2
> +                * encoding uses LE.
> +                */
> +               if (marker == 1)
> +                       addr->in_addr.ss_family =
> +                               le16_to_cpu((__force __le16)addr->in_addr.ss_family);
> +               else
> +                       addr->in_addr.ss_family =
> +                               be16_to_cpu((__force __be16)addr->in_addr.ss_family);
> +       }
> +       return 0;
> +bad:
> +       return -EINVAL;
> +}
> +EXPORT_SYMBOL(ceph_decode_entity_addr);
> +
> --
> 2.21.0
> _______________________________________________
> Dev mailing list -- dev@ceph.io
> To unsubscribe send an email to dev-leave@ceph.io
