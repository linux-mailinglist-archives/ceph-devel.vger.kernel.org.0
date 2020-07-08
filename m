Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7422184C2
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jul 2020 12:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbgGHKR5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jul 2020 06:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725949AbgGHKR5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jul 2020 06:17:57 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E371FC08C5DC
        for <ceph-devel@vger.kernel.org>; Wed,  8 Jul 2020 03:17:56 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id v8so46303687iox.2
        for <ceph-devel@vger.kernel.org>; Wed, 08 Jul 2020 03:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4PiOtlWWt6ElDqP6orMU5cg93rIpOPHem5jzAwZ8lWU=;
        b=DszTc5yPkuw7W8oQfJzb4jdFajbWu81uG+2rDCJkBts7M9VuNHDyKNEKkh7owTvl0W
         LBYfTsUooO7pTVKc4ckKPMUTQQNIQ4zeIkct9nrunNgI8D6YuOLgrudwWK6Aeg7ESD4F
         KgSP3UtCkQtFXjW0Y/mknf1ioLU4Ww4XIZL8WxD/GAF2yfZh+GfKpTABB9DEAIRWXSri
         Fc8q07Rf12k22hrrJ67G8v3IL2/aEiWJv7CkVABg/Xpitl5+mGX/yYroWKCcn0lCK4Od
         nmAPpdM58eUhDAfiz6rgAYRmiJV8QXblvDy1A3Jxh7Rta64yKKM4RaOBqN1xIi/Fmbn0
         3ftg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4PiOtlWWt6ElDqP6orMU5cg93rIpOPHem5jzAwZ8lWU=;
        b=HX5DeIJWodShA8yyaV6Ph4zL83yikQ31KT0zdtpuM2fjsl0Bvf+6slwrm/60cxLQFQ
         tl6qsmpdowoG0oJRPQ10WwJo5nztkEiWxjPPXxbH/qTE65Kg+GD5ZmypLuYPTo673hSC
         M74t7RfKJbHBKYvykDaqPX2CkjQBoyOFhX+5V8URVOi14+7oYk0+uGUm4mM+7HePN7WO
         bKBda/PielFkbZsEAQNhgaD6EmIW9BD3MwmIRJe2eB9BsDfSRuGKQt43qCQXakCnjHzN
         p9tg2hpf/Lw4iZkcIE/Mw5THVIHlSUB5s/yI//zrzIPvp5bBI4ne9Dc6segVapteUNqU
         QrNQ==
X-Gm-Message-State: AOAM5339SQ2ZesyD5TQZU0GGfcz9YpXPPRPI15JN7RCMmgcTrkoBuXhS
        lQTOhBhmlr4KVsk3IAa6JEkfytWR5oWWgGCPmBrd6BmOlW4=
X-Google-Smtp-Source: ABdhPJyyMf1LvCC4l4mfz1hMQe4YUtyPiNnjWbSjmbHaJG3Q+5UCHxM4L4DnlFJdsLxLzBNBfCSgiir7gdJdJQHV/+8=
X-Received: by 2002:a05:6638:771:: with SMTP id y17mr27400538jad.96.1594203476198;
 Wed, 08 Jul 2020 03:17:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200701155446.41141-1-jlayton@kernel.org> <20200701155446.41141-2-jlayton@kernel.org>
 <c331c66935cbeab95bd7e32198afb2bc72186df6.camel@kernel.org>
In-Reply-To: <c331c66935cbeab95bd7e32198afb2bc72186df6.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 8 Jul 2020 12:18:05 +0200
Message-ID: <CAOi1vP8ACsjXk_iQurFfmOxvb2UBRQunioUznsrxMEWb82f2Kg@mail.gmail.com>
Subject: Re: [PATCH 1/4] libceph: just have osd_req_op_init return a pointer
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jul 6, 2020 at 6:41 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2020-07-01 at 11:54 -0400, Jeff Layton wrote:
> > The caller can just ignore the return. No need for this wrapper that
> > just casts the other function to void.
> >
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  include/linux/ceph/osd_client.h |  2 +-
> >  net/ceph/osd_client.c           | 31 ++++++++++++-------------------
> >  2 files changed, 13 insertions(+), 20 deletions(-)
> >
> > diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> > index c60b59e9291b..8d63dc22cb36 100644
> > --- a/include/linux/ceph/osd_client.h
> > +++ b/include/linux/ceph/osd_client.h
> > @@ -404,7 +404,7 @@ void ceph_osdc_clear_abort_err(struct ceph_osd_client *osdc);
> >       &__oreq->r_ops[__whch].typ.fld;                                 \
> >  })
> >
> > -extern void osd_req_op_init(struct ceph_osd_request *osd_req,
> > +extern struct ceph_osd_req_op *osd_req_op_init(struct ceph_osd_request *osd_req,
> >                           unsigned int which, u16 opcode, u32 flags);
> >
> >  extern void osd_req_op_raw_data_in_pages(struct ceph_osd_request *,
> > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > index db6abb5a5511..3cff29d38b9f 100644
> > --- a/net/ceph/osd_client.c
> > +++ b/net/ceph/osd_client.c
> > @@ -525,7 +525,7 @@ EXPORT_SYMBOL(ceph_osdc_put_request);
> >
> >  static void request_init(struct ceph_osd_request *req)
> >  {
> > -     /* req only, each op is zeroed in _osd_req_op_init() */
> > +     /* req only, each op is zeroed in osd_req_op_init() */
> >       memset(req, 0, sizeof(*req));
> >
> >       kref_init(&req->r_kref);
> > @@ -746,8 +746,8 @@ EXPORT_SYMBOL(ceph_osdc_alloc_messages);
> >   * other information associated with them.  It also serves as a
> >   * common init routine for all the other init functions, below.
> >   */
> > -static struct ceph_osd_req_op *
> > -_osd_req_op_init(struct ceph_osd_request *osd_req, unsigned int which,
> > +struct ceph_osd_req_op *
> > +osd_req_op_init(struct ceph_osd_request *osd_req, unsigned int which,
> >                u16 opcode, u32 flags)
> >  {
> >       struct ceph_osd_req_op *op;
> > @@ -762,12 +762,6 @@ _osd_req_op_init(struct ceph_osd_request *osd_req, unsigned int which,
> >
> >       return op;
> >  }
> > -
> > -void osd_req_op_init(struct ceph_osd_request *osd_req,
> > -                  unsigned int which, u16 opcode, u32 flags)
> > -{
> > -     (void)_osd_req_op_init(osd_req, which, opcode, flags);
> > -}
> >  EXPORT_SYMBOL(osd_req_op_init);
> >
> >  void osd_req_op_extent_init(struct ceph_osd_request *osd_req,
> > @@ -775,8 +769,7 @@ void osd_req_op_extent_init(struct ceph_osd_request *osd_req,
> >                               u64 offset, u64 length,
> >                               u64 truncate_size, u32 truncate_seq)
> >  {
> > -     struct ceph_osd_req_op *op = _osd_req_op_init(osd_req, which,
> > -                                                   opcode, 0);
> > +     struct ceph_osd_req_op *op = osd_req_op_init(osd_req, which, opcode, 0);
> >       size_t payload_len = 0;
> >
> >       BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE &&
> > @@ -822,7 +815,7 @@ void osd_req_op_extent_dup_last(struct ceph_osd_request *osd_req,
> >       BUG_ON(which + 1 >= osd_req->r_num_ops);
> >
> >       prev_op = &osd_req->r_ops[which];
> > -     op = _osd_req_op_init(osd_req, which + 1, prev_op->op, prev_op->flags);
> > +     op = osd_req_op_init(osd_req, which + 1, prev_op->op, prev_op->flags);
> >       /* dup previous one */
> >       op->indata_len = prev_op->indata_len;
> >       op->outdata_len = prev_op->outdata_len;
> > @@ -845,7 +838,7 @@ int osd_req_op_cls_init(struct ceph_osd_request *osd_req, unsigned int which,
> >       size_t size;
> >       int ret;
> >
> > -     op = _osd_req_op_init(osd_req, which, CEPH_OSD_OP_CALL, 0);
> > +     op = osd_req_op_init(osd_req, which, CEPH_OSD_OP_CALL, 0);
> >
> >       pagelist = ceph_pagelist_alloc(GFP_NOFS);
> >       if (!pagelist)
> > @@ -883,7 +876,7 @@ int osd_req_op_xattr_init(struct ceph_osd_request *osd_req, unsigned int which,
> >                         u16 opcode, const char *name, const void *value,
> >                         size_t size, u8 cmp_op, u8 cmp_mode)
> >  {
> > -     struct ceph_osd_req_op *op = _osd_req_op_init(osd_req, which,
> > +     struct ceph_osd_req_op *op = osd_req_op_init(osd_req, which,
> >                                                     opcode, 0);
> >       struct ceph_pagelist *pagelist;
> >       size_t payload_len;
> > @@ -928,7 +921,7 @@ static void osd_req_op_watch_init(struct ceph_osd_request *req, int which,
> >  {
> >       struct ceph_osd_req_op *op;
> >
> > -     op = _osd_req_op_init(req, which, CEPH_OSD_OP_WATCH, 0);
> > +     op = osd_req_op_init(req, which, CEPH_OSD_OP_WATCH, 0);
> >       op->watch.cookie = cookie;
> >       op->watch.op = watch_opcode;
> >       op->watch.gen = 0;
> > @@ -943,7 +936,7 @@ void osd_req_op_alloc_hint_init(struct ceph_osd_request *osd_req,
> >                               u64 expected_write_size,
> >                               u32 flags)
> >  {
> > -     struct ceph_osd_req_op *op = _osd_req_op_init(osd_req, which,
> > +     struct ceph_osd_req_op *op = osd_req_op_init(osd_req, which,
> >                                                     CEPH_OSD_OP_SETALLOCHINT,
> >                                                     0);
> >
> > @@ -4799,7 +4792,7 @@ static int osd_req_op_notify_ack_init(struct ceph_osd_request *req, int which,
> >       struct ceph_pagelist *pl;
> >       int ret;
> >
> > -     op = _osd_req_op_init(req, which, CEPH_OSD_OP_NOTIFY_ACK, 0);
> > +     op = osd_req_op_init(req, which, CEPH_OSD_OP_NOTIFY_ACK, 0);
> >
> >       pl = ceph_pagelist_alloc(GFP_NOIO);
> >       if (!pl)
> > @@ -4868,7 +4861,7 @@ static int osd_req_op_notify_init(struct ceph_osd_request *req, int which,
> >       struct ceph_pagelist *pl;
> >       int ret;
> >
> > -     op = _osd_req_op_init(req, which, CEPH_OSD_OP_NOTIFY, 0);
> > +     op = osd_req_op_init(req, which, CEPH_OSD_OP_NOTIFY, 0);
> >       op->notify.cookie = cookie;
> >
> >       pl = ceph_pagelist_alloc(GFP_NOIO);
> > @@ -5332,7 +5325,7 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
> >       if (IS_ERR(pages))
> >               return PTR_ERR(pages);
> >
> > -     op = _osd_req_op_init(req, 0, CEPH_OSD_OP_COPY_FROM2,
> > +     op = osd_req_op_init(req, 0, CEPH_OSD_OP_COPY_FROM2,
> >                             dst_fadvise_flags);
> >       op->copy_from.snapid = src_snapid;
> >       op->copy_from.src_version = src_version;
>
> Hi Ilya,
>
> This patch was part of the series that I sent last week. I know you
> nacked the other patches, but were you also opposed to this one? It's a
> fairly straightforward cleanup that gets rid of some unnecessary (and
> odd) casting.

Hi Jeff,

No, this one looked fine.

Applied with a couple of minor style fixups.

Thanks,

                Ilya
