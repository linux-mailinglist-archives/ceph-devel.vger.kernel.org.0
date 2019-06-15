Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D120046FB4
	for <lists+ceph-devel@lfdr.de>; Sat, 15 Jun 2019 12:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfFOK5Z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 15 Jun 2019 06:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbfFOK5Z (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 15 Jun 2019 06:57:25 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6AC4206B7;
        Sat, 15 Jun 2019 10:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560596243;
        bh=tNVh6AyOepORp7hbavixLPxoeoyHJzRj2Fmt5Xk9sf8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=0dwT63xIxwPzEI11H6+cjtCpNEXLkmvVrXUAT/hqMnOWjfvSCagU9gwJWdHte3Npr
         pvn/0jj07YfE+aqFv1ZmwBspFsZNhPNZ6xfii9eBob1t+zlBWbyIts0Y3PmWyQGxD3
         RFDU/H4HUJSBJAORjj5h/IXWcCFHqnizZLnFWOzY=
Message-ID: <06392cf35efc9ebd6fc12dd44d644e92c693af4a.camel@kernel.org>
Subject: Re: [PATCH 02/16] libceph: add ceph_decode_entity_addr
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     Ilya Dryomov <idryomov@redhat.com>, Zheng Yan <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Date:   Sat, 15 Jun 2019 06:57:21 -0400
In-Reply-To: <CAAM7YAmSWzumRthVmpW1FKK+0XBrNsrFNU2GvKDytOc1hHabjw@mail.gmail.com>
References: <20190607153816.12918-1-jlayton@kernel.org>
         <20190607153816.12918-3-jlayton@kernel.org>
         <CAAM7YAnVF_+m-Ege6u5mS9wcT_ttJZrvRuWh7F3-49Yxd98kEA@mail.gmail.com>
         <c6c5d94ce2526a3885050eb2395f2c4efa2a9c17.camel@kernel.org>
         <CAAM7YAmSWzumRthVmpW1FKK+0XBrNsrFNU2GvKDytOc1hHabjw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2019-06-15 at 10:25 +0800, Yan, Zheng wrote:
> On Fri, Jun 14, 2019 at 9:13 PM Jeff Layton <jlayton@kernel.org> wrote:
> > On Fri, 2019-06-14 at 16:05 +0800, Yan, Zheng wrote:
> > > On Fri, Jun 7, 2019 at 11:38 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > Add a way to decode an entity_addr_t. Once CEPH_FEATURE_MSG_ADDR2 is
> > > > enabled, the server daemons will start encoding entity_addr_t
> > > > differently.
> > > > 
> > > > Add a new helper function that can handle either format.
> > > > 
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >  include/linux/ceph/decode.h |  2 +
> > > >  net/ceph/Makefile           |  2 +-
> > > >  net/ceph/decode.c           | 75 +++++++++++++++++++++++++++++++++++++
> > > >  3 files changed, 78 insertions(+), 1 deletion(-)
> > > >  create mode 100644 net/ceph/decode.c
> > > > 
> > > > diff --git a/include/linux/ceph/decode.h b/include/linux/ceph/decode.h
> > > > index a6c2a48d42e0..1c0a665bfc03 100644
> > > > --- a/include/linux/ceph/decode.h
> > > > +++ b/include/linux/ceph/decode.h
> > > > @@ -230,6 +230,8 @@ static inline void ceph_decode_addr(struct ceph_entity_addr *a)
> > > >         WARN_ON(a->in_addr.ss_family == 512);
> > > >  }
> > > > 
> > > > +extern int ceph_decode_entity_addr(void **p, void *end,
> > > > +                                  struct ceph_entity_addr *addr);
> > > >  /*
> > > >   * encoders
> > > >   */
> > > > diff --git a/net/ceph/Makefile b/net/ceph/Makefile
> > > > index db09defe27d0..59d0ba2072de 100644
> > > > --- a/net/ceph/Makefile
> > > > +++ b/net/ceph/Makefile
> > > > @@ -5,7 +5,7 @@
> > > >  obj-$(CONFIG_CEPH_LIB) += libceph.o
> > > > 
> > > >  libceph-y := ceph_common.o messenger.o msgpool.o buffer.o pagelist.o \
> > > > -       mon_client.o \
> > > > +       mon_client.o decode.o \
> > > >         cls_lock_client.o \
> > > >         osd_client.o osdmap.o crush/crush.o crush/mapper.o crush/hash.o \
> > > >         striper.o \
> > > > diff --git a/net/ceph/decode.c b/net/ceph/decode.c
> > > > new file mode 100644
> > > > index 000000000000..27edf5d341ec
> > > > --- /dev/null
> > > > +++ b/net/ceph/decode.c
> > > > @@ -0,0 +1,75 @@
> > > > +// SPDX-License-Identifier: GPL-2.0
> > > > +
> > > > +#include <linux/ceph/decode.h>
> > > > +
> > > > +int
> > > > +ceph_decode_entity_addr(void **p, void *end, struct ceph_entity_addr *addr)
> > > > +{
> > > > +       u8 marker, v, compat;
> > > 
> > > It's better to use name struct_v, struct_compat
> > > 
> > > 
> > > > +       u32 len;
> > > > +
> > > > +       ceph_decode_8_safe(p, end, marker, bad);
> > > > +       if (marker == 1) {
> > > > +               ceph_decode_8_safe(p, end, v, bad);
> > > > +               ceph_decode_8_safe(p, end, compat, bad);
> > > > +               if (!v || compat != 1)
> > > > +                       goto bad;
> > > > +               /* FIXME: sanity check? */
> > > > +               ceph_decode_32_safe(p, end, len, bad);
> > > > +               /* type is __le32, so we must copy into place as-is */
> > > > +               ceph_decode_copy_safe(p, end, &addr->type,
> > > > +                                       sizeof(addr->type), bad);
> > > > +
> > > > +               /*
> > > > +                * TYPE_NONE == 0
> > > > +                * TYPE_LEGACY == 1
> > > > +                *
> > > > +                * Clients that don't support ADDR2 always send TYPE_NONE.
> > > > +                * For now, since all we support is msgr1, just set this to 0
> > > > +                * when we get a TYPE_LEGACY type.
> > > > +                */
> > > > +               if (addr->type == cpu_to_le32(1))
> > > > +                       addr->type = 0;
> > > > +       } else if (marker == 0) {
> > > > +               addr->type = 0;
> > > > +               /* Skip rest of type field */
> > > > +               ceph_decode_skip_n(p, end, 3, bad);
> > > > +       } else {
> > > 
> > > versioned encoding has forward compatibility.  The code should looks like
> > > 
> > > if (struct_v == 0) {
> > >   /* old format */
> > >   return;
> > > }
> > > 
> > > if (struct_compat != 1)
> > >    goto bad
> > > 
> > > end = *p + struct_len;
> > > 
> > > if  (struct_v == 1) {
> > > ....
> > > }
> > > 
> > > if (struct_v == 2) {
> > > ...
> > > }
> > > 
> > > *p = end;
> > > 
> > > 
> > > 
> > > 
> > > > +               goto bad;
> > > > +       }
> > > > +
> > > > +       ceph_decode_need(p, end, sizeof(addr->nonce), bad);
> > > > +       ceph_decode_copy(p, &addr->nonce, sizeof(addr->nonce));
> > > > +
> > > > +       /* addr length */
> > > > +       if (marker ==  1) {
> > > > +               ceph_decode_32_safe(p, end, len, bad);
> > > > +               if (len > sizeof(addr->in_addr))
> > > > +                       goto bad;
> > > > +       } else  {
> > > > +               len = sizeof(addr->in_addr);
> > > > +       }
> > > > +
> > > > +       memset(&addr->in_addr, 0, sizeof(addr->in_addr));
> > > > +
> > > > +       if (len) {
> > > > +               ceph_decode_need(p, end, len, bad);
> > > > +               ceph_decode_copy(p, &addr->in_addr, len);
> > > > +
> > > > +               /*
> > > > +                * Fix up sa_family. Legacy encoding sends it in BE, addr2
> > > > +                * encoding uses LE.
> > > > +                */
> > > > +               if (marker == 1)
> > > > +                       addr->in_addr.ss_family =
> > > > +                               le16_to_cpu((__force __le16)addr->in_addr.ss_family);
> > > > +               else
> > > > +                       addr->in_addr.ss_family =
> > > > +                               be16_to_cpu((__force __be16)addr->in_addr.ss_family);
> > > > +       }
> > > > +       return 0;
> > > > +bad:
> > > > +       return -EINVAL;
> > > > +}
> > > > +EXPORT_SYMBOL(ceph_decode_entity_addr);
> > > > +
> > > > --
> > > > 2.21.0
> > 
> > (Dropping dev@ceph.io from cc list since they evidently _really_ don't
> > want to see kernel patches there)
> > 
> > Something like this then on top of the original patch?
> > 
> > SQUASH: address Zheng's comments
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  net/ceph/decode.c | 21 ++++++++++++---------
> >  1 file changed, 12 insertions(+), 9 deletions(-)
> > 
> > diff --git a/net/ceph/decode.c b/net/ceph/decode.c
> > index 27edf5d341ec..5a008567d018 100644
> > --- a/net/ceph/decode.c
> > +++ b/net/ceph/decode.c
> > @@ -5,18 +5,20 @@
> >  int
> >  ceph_decode_entity_addr(void **p, void *end, struct ceph_entity_addr *addr)
> >  {
> > -       u8 marker, v, compat;
> > +       u8 marker, struct_v, struct_compat;
> >         u32 len;
> > 
> >         ceph_decode_8_safe(p, end, marker, bad);
> >         if (marker == 1) {
> > -               ceph_decode_8_safe(p, end, v, bad);
> > -               ceph_decode_8_safe(p, end, compat, bad);
> > -               if (!v || compat != 1)
> > +               ceph_decode_8_safe(p, end, struct_v, bad);
> > +               ceph_decode_8_safe(p, end, struct_compat, bad);
> > +               if (!struct_v || struct_compat != 1)
> >                         goto bad;
> > +
> >                 /* FIXME: sanity check? */
> >                 ceph_decode_32_safe(p, end, len, bad);
> > -               /* type is __le32, so we must copy into place as-is */
> > +
> > +               /* type is defined as __le32, copy into place as-is */
> >                 ceph_decode_copy_safe(p, end, &addr->type,
> >                                         sizeof(addr->type), bad);
> > 
> > @@ -32,17 +34,18 @@ ceph_decode_entity_addr(void **p, void *end, struct ceph_entity_addr *addr)
> >                         addr->type = 0;
> >         } else if (marker == 0) {
> >                 addr->type = 0;
> > +               struct_v = 0;
> > +               struct_compat = 0;
> >                 /* Skip rest of type field */
> >                 ceph_decode_skip_n(p, end, 3, bad);
> >         } else {
> >                 goto bad;
> >         }
> > 
> > -       ceph_decode_need(p, end, sizeof(addr->nonce), bad);
> > -       ceph_decode_copy(p, &addr->nonce, sizeof(addr->nonce));
> > +       ceph_decode_copy_safe(p, end, &addr->nonce, sizeof(addr->nonce), bad);
> > 
> >         /* addr length */
> > -       if (marker ==  1) {
> > +       if (struct_v > 0) {
> >                 ceph_decode_32_safe(p, end, len, bad);
> >                 if (len > sizeof(addr->in_addr))
> >                         goto bad;
> > @@ -60,7 +63,7 @@ ceph_decode_entity_addr(void **p, void *end, struct ceph_entity_addr *addr)
> >                  * Fix up sa_family. Legacy encoding sends it in BE, addr2
> >                  * encoding uses LE.
> >                  */
> > -               if (marker == 1)
> > +               if (struct_v > 0)
> >                         addr->in_addr.ss_family =
> >                                 le16_to_cpu((__force __le16)addr->in_addr.ss_family);
> >                 else
> > --
> > 2.21.0
> > 
> > 
> 
> still missing  code that updates (*p) at the very end.
> 
> if (struct_compat != 1)
>   goto bad
> end = *p + struct_len;
> ...
> *p = end;
> 

Huh? The ceph_decode_* routines update *p as they go. There is no need
to do anything like what you're suggesting at the end of this function.

> I think It's better to define separate functions for legacy encoding
> and new format.

I disagree. That will just mean that we end up duplicating some of this
code.

-- 
Jeff Layton <jlayton@kernel.org>

