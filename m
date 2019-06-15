Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC00846DC9
	for <lists+ceph-devel@lfdr.de>; Sat, 15 Jun 2019 04:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfFOC0L (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Jun 2019 22:26:11 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34796 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbfFOC0L (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 14 Jun 2019 22:26:11 -0400
Received: by mail-qt1-f194.google.com with SMTP id m29so4774496qtu.1
        for <ceph-devel@vger.kernel.org>; Fri, 14 Jun 2019 19:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XC3aUpncAEc7x+1YX5XWe4x0xnCwQ0iqQSDOCvHlcyY=;
        b=sZuNw+WZ7ciGA6e4x3Is8iF2150/948PFzYcBdLmqV/BXZC5ydmJAREcGRzV5hzq/f
         RoIQJI1kkV1ehmDtPz5ZvsML3KgAopqcjjmBi9R7+/FePDrQBtQQg0IepMmsZOCSZibR
         sFeh/MXtMZ/xAQkDgBf6S9g8oTg5UScfxUtja/dnZhSqqLRQjD5Ux1/AezbxfRw8GA5R
         tBC0CMRtLKU74nUkmr/8+UImZ8+MkZT94JEnHihd0IrUKKIxUjFuwiMUuC/rzMqolBWb
         wK79YOPULm0f7paDzxFhNhpo5uF9jLaXlX4F2J49jfM4gR1cLIPlH3YfLHKBvIbOmvJH
         8e2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XC3aUpncAEc7x+1YX5XWe4x0xnCwQ0iqQSDOCvHlcyY=;
        b=HovHSs+yiKqGJD0C6QgjFqUrh0pbGe4VbtuVkGHM+lURU3x+jt9HoZU/fxfzGjI25v
         +8/j9iQig+/Nhery1pG8VUm8okD38Zm9+VZkAqoCK9RDEBvGurzdATlilBxH1FyYWzPe
         C4hn3ngBIsKwIGhncvjp4XLAjYD2bXelhAV3xaZo1VeqRGLt24/KJTnmnPoVQ1iQZPKb
         yoD5s++Xm+Hxf5w2FvC3xzvC89j/upCm8D3jtSWEOOklG1PPJ/lIybaeEnUv7lt0qonE
         pgeLSoBD34LyiRmRmHz1qpqY5fCxtmSubNZQEl5UdxOyHZlQV12FqCQzmhSKm2/cEItP
         BsRg==
X-Gm-Message-State: APjAAAW61DQLgJjG2G4sZZRZoygOeVbTRJn3j0GlFspw8rTYGCQ2zH06
        SLAklg9VByhm/j7o9EQPU/MBGH4lK0DiYPx5ShQ=
X-Google-Smtp-Source: APXvYqwnEYfTjhT0Gt20mkoBlJYC4nsrlis1+JU8RT7dfba0+eatqY8i5iemGsE3gGr+Tn6gruwvbUnlxVQdjtj2mA0=
X-Received: by 2002:ac8:368a:: with SMTP id a10mr1365670qtc.143.1560565570155;
 Fri, 14 Jun 2019 19:26:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190607153816.12918-1-jlayton@kernel.org> <20190607153816.12918-3-jlayton@kernel.org>
 <CAAM7YAnVF_+m-Ege6u5mS9wcT_ttJZrvRuWh7F3-49Yxd98kEA@mail.gmail.com> <c6c5d94ce2526a3885050eb2395f2c4efa2a9c17.camel@kernel.org>
In-Reply-To: <c6c5d94ce2526a3885050eb2395f2c4efa2a9c17.camel@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Sat, 15 Jun 2019 10:25:58 +0800
Message-ID: <CAAM7YAmSWzumRthVmpW1FKK+0XBrNsrFNU2GvKDytOc1hHabjw@mail.gmail.com>
Subject: Re: [PATCH 02/16] libceph: add ceph_decode_entity_addr
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@redhat.com>, Zheng Yan <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jun 14, 2019 at 9:13 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Fri, 2019-06-14 at 16:05 +0800, Yan, Zheng wrote:
> > On Fri, Jun 7, 2019 at 11:38 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > Add a way to decode an entity_addr_t. Once CEPH_FEATURE_MSG_ADDR2 is
> > > enabled, the server daemons will start encoding entity_addr_t
> > > differently.
> > >
> > > Add a new helper function that can handle either format.
> > >
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  include/linux/ceph/decode.h |  2 +
> > >  net/ceph/Makefile           |  2 +-
> > >  net/ceph/decode.c           | 75 +++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 78 insertions(+), 1 deletion(-)
> > >  create mode 100644 net/ceph/decode.c
> > >
> > > diff --git a/include/linux/ceph/decode.h b/include/linux/ceph/decode.h
> > > index a6c2a48d42e0..1c0a665bfc03 100644
> > > --- a/include/linux/ceph/decode.h
> > > +++ b/include/linux/ceph/decode.h
> > > @@ -230,6 +230,8 @@ static inline void ceph_decode_addr(struct ceph_entity_addr *a)
> > >         WARN_ON(a->in_addr.ss_family == 512);
> > >  }
> > >
> > > +extern int ceph_decode_entity_addr(void **p, void *end,
> > > +                                  struct ceph_entity_addr *addr);
> > >  /*
> > >   * encoders
> > >   */
> > > diff --git a/net/ceph/Makefile b/net/ceph/Makefile
> > > index db09defe27d0..59d0ba2072de 100644
> > > --- a/net/ceph/Makefile
> > > +++ b/net/ceph/Makefile
> > > @@ -5,7 +5,7 @@
> > >  obj-$(CONFIG_CEPH_LIB) += libceph.o
> > >
> > >  libceph-y := ceph_common.o messenger.o msgpool.o buffer.o pagelist.o \
> > > -       mon_client.o \
> > > +       mon_client.o decode.o \
> > >         cls_lock_client.o \
> > >         osd_client.o osdmap.o crush/crush.o crush/mapper.o crush/hash.o \
> > >         striper.o \
> > > diff --git a/net/ceph/decode.c b/net/ceph/decode.c
> > > new file mode 100644
> > > index 000000000000..27edf5d341ec
> > > --- /dev/null
> > > +++ b/net/ceph/decode.c
> > > @@ -0,0 +1,75 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +
> > > +#include <linux/ceph/decode.h>
> > > +
> > > +int
> > > +ceph_decode_entity_addr(void **p, void *end, struct ceph_entity_addr *addr)
> > > +{
> > > +       u8 marker, v, compat;
> >
> > It's better to use name struct_v, struct_compat
> >
> >
> > > +       u32 len;
> > > +
> > > +       ceph_decode_8_safe(p, end, marker, bad);
> > > +       if (marker == 1) {
> > > +               ceph_decode_8_safe(p, end, v, bad);
> > > +               ceph_decode_8_safe(p, end, compat, bad);
> > > +               if (!v || compat != 1)
> > > +                       goto bad;
> > > +               /* FIXME: sanity check? */
> > > +               ceph_decode_32_safe(p, end, len, bad);
> > > +               /* type is __le32, so we must copy into place as-is */
> > > +               ceph_decode_copy_safe(p, end, &addr->type,
> > > +                                       sizeof(addr->type), bad);
> > > +
> > > +               /*
> > > +                * TYPE_NONE == 0
> > > +                * TYPE_LEGACY == 1
> > > +                *
> > > +                * Clients that don't support ADDR2 always send TYPE_NONE.
> > > +                * For now, since all we support is msgr1, just set this to 0
> > > +                * when we get a TYPE_LEGACY type.
> > > +                */
> > > +               if (addr->type == cpu_to_le32(1))
> > > +                       addr->type = 0;
> > > +       } else if (marker == 0) {
> > > +               addr->type = 0;
> > > +               /* Skip rest of type field */
> > > +               ceph_decode_skip_n(p, end, 3, bad);
> > > +       } else {
> >
> > versioned encoding has forward compatibility.  The code should looks like
> >
> > if (struct_v == 0) {
> >   /* old format */
> >   return;
> > }
> >
> > if (struct_compat != 1)
> >    goto bad
> >
> > end = *p + struct_len;
> >
> > if  (struct_v == 1) {
> > ....
> > }
> >
> > if (struct_v == 2) {
> > ...
> > }
> >
> > *p = end;
> >
> >
> >
> >
> > > +               goto bad;
> > > +       }
> > > +
> > > +       ceph_decode_need(p, end, sizeof(addr->nonce), bad);
> > > +       ceph_decode_copy(p, &addr->nonce, sizeof(addr->nonce));
> > > +
> > > +       /* addr length */
> > > +       if (marker ==  1) {
> > > +               ceph_decode_32_safe(p, end, len, bad);
> > > +               if (len > sizeof(addr->in_addr))
> > > +                       goto bad;
> > > +       } else  {
> > > +               len = sizeof(addr->in_addr);
> > > +       }
> > > +
> > > +       memset(&addr->in_addr, 0, sizeof(addr->in_addr));
> > > +
> > > +       if (len) {
> > > +               ceph_decode_need(p, end, len, bad);
> > > +               ceph_decode_copy(p, &addr->in_addr, len);
> > > +
> > > +               /*
> > > +                * Fix up sa_family. Legacy encoding sends it in BE, addr2
> > > +                * encoding uses LE.
> > > +                */
> > > +               if (marker == 1)
> > > +                       addr->in_addr.ss_family =
> > > +                               le16_to_cpu((__force __le16)addr->in_addr.ss_family);
> > > +               else
> > > +                       addr->in_addr.ss_family =
> > > +                               be16_to_cpu((__force __be16)addr->in_addr.ss_family);
> > > +       }
> > > +       return 0;
> > > +bad:
> > > +       return -EINVAL;
> > > +}
> > > +EXPORT_SYMBOL(ceph_decode_entity_addr);
> > > +
> > > --
> > > 2.21.0
>
>
> (Dropping dev@ceph.io from cc list since they evidently _really_ don't
> want to see kernel patches there)
>
> Something like this then on top of the original patch?
>
> SQUASH: address Zheng's comments
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  net/ceph/decode.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
>
> diff --git a/net/ceph/decode.c b/net/ceph/decode.c
> index 27edf5d341ec..5a008567d018 100644
> --- a/net/ceph/decode.c
> +++ b/net/ceph/decode.c
> @@ -5,18 +5,20 @@
>  int
>  ceph_decode_entity_addr(void **p, void *end, struct ceph_entity_addr *addr)
>  {
> -       u8 marker, v, compat;
> +       u8 marker, struct_v, struct_compat;
>         u32 len;
>
>         ceph_decode_8_safe(p, end, marker, bad);
>         if (marker == 1) {
> -               ceph_decode_8_safe(p, end, v, bad);
> -               ceph_decode_8_safe(p, end, compat, bad);
> -               if (!v || compat != 1)
> +               ceph_decode_8_safe(p, end, struct_v, bad);
> +               ceph_decode_8_safe(p, end, struct_compat, bad);
> +               if (!struct_v || struct_compat != 1)
>                         goto bad;
> +
>                 /* FIXME: sanity check? */
>                 ceph_decode_32_safe(p, end, len, bad);
> -               /* type is __le32, so we must copy into place as-is */
> +
> +               /* type is defined as __le32, copy into place as-is */
>                 ceph_decode_copy_safe(p, end, &addr->type,
>                                         sizeof(addr->type), bad);
>
> @@ -32,17 +34,18 @@ ceph_decode_entity_addr(void **p, void *end, struct ceph_entity_addr *addr)
>                         addr->type = 0;
>         } else if (marker == 0) {
>                 addr->type = 0;
> +               struct_v = 0;
> +               struct_compat = 0;
>                 /* Skip rest of type field */
>                 ceph_decode_skip_n(p, end, 3, bad);
>         } else {
>                 goto bad;
>         }
>
> -       ceph_decode_need(p, end, sizeof(addr->nonce), bad);
> -       ceph_decode_copy(p, &addr->nonce, sizeof(addr->nonce));
> +       ceph_decode_copy_safe(p, end, &addr->nonce, sizeof(addr->nonce), bad);
>
>         /* addr length */
> -       if (marker ==  1) {
> +       if (struct_v > 0) {
>                 ceph_decode_32_safe(p, end, len, bad);
>                 if (len > sizeof(addr->in_addr))
>                         goto bad;
> @@ -60,7 +63,7 @@ ceph_decode_entity_addr(void **p, void *end, struct ceph_entity_addr *addr)
>                  * Fix up sa_family. Legacy encoding sends it in BE, addr2
>                  * encoding uses LE.
>                  */
> -               if (marker == 1)
> +               if (struct_v > 0)
>                         addr->in_addr.ss_family =
>                                 le16_to_cpu((__force __le16)addr->in_addr.ss_family);
>                 else
> --
> 2.21.0
>
>

still missing  code that updates (*p) at the very end.

if (struct_compat != 1)
  goto bad
end = *p + struct_len;
...
*p = end;

I think It's better to define separate functions for legacy encoding
and new format.
