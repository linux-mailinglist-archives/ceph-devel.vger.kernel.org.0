Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B164B2113B3
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Jul 2020 21:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgGATkH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Jul 2020 15:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgGATkH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 1 Jul 2020 15:40:07 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38296C08C5C1
        for <ceph-devel@vger.kernel.org>; Wed,  1 Jul 2020 12:40:07 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id v6so12643492iob.4
        for <ceph-devel@vger.kernel.org>; Wed, 01 Jul 2020 12:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PG0eomNU7myttnvwAxZhto6f5ZJq3PoqDn29ciAGi3c=;
        b=emcMKVLqu3DLYPLpM5Pw7AFD5SeyPC8yHi52A7c+oIU17xfR2mD+EqIz+e+Qt0pDcd
         r6zu6wX11gnEftha6/QwypCAQHpzj8Bic9c4JL2KP0U3yQBZJ8JI3QtKO8swjsgoaMQi
         i+tGh4H3AequjYGbyUevS97ewvgjlz4yeWClXC49XOoWl/1CnMPIYpiyKpx9+2X3I1Da
         yHm5GoCy2NIKUXXq3/ibc6ui5o8aguu9WD3pHEP4h/u+nW6lyEdbHU446ZOvkoQsC2Z2
         PEkm+3tactrBv02DNlROVUw+5vR293hLy2BvIP1zYJgEIrMlZea/AdZeCmT6TgJvfgkn
         EdKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PG0eomNU7myttnvwAxZhto6f5ZJq3PoqDn29ciAGi3c=;
        b=HvCJg3flexzuMmKMiPuyAo55x+ayIJdQjy4/HK4fRWbf5uErHnx1QO6dDkOamalb5Y
         vQEr0q4BCYYSCbG5H0W37qCseEq2IF8nhXThLE617vj9JfMPPPOs4WV2+m00EjHihySF
         1AB8H372aX09vLjzCvnVu+Jo8A1m50KwEBGXy9jjUAbBdaWn+BJC3zQyHrEqV0I7hPza
         odTl2ctaV64MdIMvoFXxyaljCnFguvJ3kywQWBgRiQXiMRGh8xH8Zn3itewqVpAXj0A8
         xo4jOfpQHrJAZBycfX/eb+o2cUFFcH4PDSnUjIG2mAegYGD2XvgUb3OtBqjGpUAdlWZc
         sHcw==
X-Gm-Message-State: AOAM531lalW1Vui9Vu5zVYTsljvckl4Lwz/hpVFYiTGSuRshgBWrS+Qd
        MbF77iCRYxs0nTrGGTnmnif49wcAAMsIyjMXt8g=
X-Google-Smtp-Source: ABdhPJwOUHTuPTbmxgLXPCFthai5jwk7nsOTUmo3g+bWZRKZKBmI2HhEMOOpMMDBVXaQwWVlCMjSCiTnNaWgTny5GnE=
X-Received: by 2002:a6b:ee15:: with SMTP id i21mr3933217ioh.25.1593632406554;
 Wed, 01 Jul 2020 12:40:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200701155446.41141-1-jlayton@kernel.org> <20200701155446.41141-4-jlayton@kernel.org>
 <CAOi1vP_200rymwrks34JTn224Y6yGaBfu2oX01xj-qKS+c08sQ@mail.gmail.com> <1d5a9f273770150266e3e45e11116a82484e4a14.camel@kernel.org>
In-Reply-To: <1d5a9f273770150266e3e45e11116a82484e4a14.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 1 Jul 2020 21:40:12 +0200
Message-ID: <CAOi1vP9prxnVNbTDvJM8os6K_o7EcqSif4Ey4Moba-j7FJdOtg@mail.gmail.com>
Subject: Re: [PATCH 3/4] libceph: rename __ceph_osdc_alloc_messages to ceph_osdc_alloc_num_messages
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jul 1, 2020 at 9:17 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2020-07-01 at 20:48 +0200, Ilya Dryomov wrote:
> > On Wed, Jul 1, 2020 at 5:54 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > ...and make it public and export it.
> > >
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  include/linux/ceph/osd_client.h |  3 +++
> > >  net/ceph/osd_client.c           | 13 +++++++------
> > >  2 files changed, 10 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> > > index 40a08c4e5d8d..71b7610c3a3c 100644
> > > --- a/include/linux/ceph/osd_client.h
> > > +++ b/include/linux/ceph/osd_client.h
> > > @@ -481,6 +481,9 @@ extern struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *
> > >                                                unsigned int num_ops,
> > >                                                bool use_mempool,
> > >                                                gfp_t gfp_flags);
> > > +int ceph_osdc_alloc_num_messages(struct ceph_osd_request *req, gfp_t gfp,
> > > +                                int num_request_data_items,
> > > +                                int num_reply_data_items);
> > >  int ceph_osdc_alloc_messages(struct ceph_osd_request *req, gfp_t gfp);
> > >
> > >  extern struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *,
> > > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > > index 4ddf23120b1a..7be78fa6e2c3 100644
> > > --- a/net/ceph/osd_client.c
> > > +++ b/net/ceph/osd_client.c
> > > @@ -613,9 +613,9 @@ static int ceph_oloc_encoding_size(const struct ceph_object_locator *oloc)
> > >         return 8 + 4 + 4 + 4 + (oloc->pool_ns ? oloc->pool_ns->len : 0);
> > >  }
> > >
> > > -static int __ceph_osdc_alloc_messages(struct ceph_osd_request *req, gfp_t gfp,
> > > -                                     int num_request_data_items,
> > > -                                     int num_reply_data_items)
> > > +int ceph_osdc_alloc_num_messages(struct ceph_osd_request *req, gfp_t gfp,
> > > +                                int num_request_data_items,
> > > +                                int num_reply_data_items)
> > >  {
> > >         struct ceph_osd_client *osdc = req->r_osdc;
> > >         struct ceph_msg *msg;
> > > @@ -672,6 +672,7 @@ static int __ceph_osdc_alloc_messages(struct ceph_osd_request *req, gfp_t gfp,
> > >
> > >         return 0;
> > >  }
> > > +EXPORT_SYMBOL(ceph_osdc_alloc_num_messages);
> > >
> > >  static bool osd_req_opcode_valid(u16 opcode)
> > >  {
> > > @@ -738,8 +739,8 @@ int ceph_osdc_alloc_messages(struct ceph_osd_request *req, gfp_t gfp)
> > >         int num_request_data_items, num_reply_data_items;
> > >
> > >         get_num_data_items(req, &num_request_data_items, &num_reply_data_items);
> > > -       return __ceph_osdc_alloc_messages(req, gfp, num_request_data_items,
> > > -                                         num_reply_data_items);
> > > +       return ceph_osdc_alloc_num_messages(req, gfp, num_request_data_items,
> > > +                                                 num_reply_data_items);
> > >  }
> > >  EXPORT_SYMBOL(ceph_osdc_alloc_messages);
> > >
> > > @@ -1129,7 +1130,7 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
> > >                  * also covers ceph_uninline_data().  If more multi-op request
> > >                  * use cases emerge, we will need a separate helper.
> > >                  */
> > > -               r = __ceph_osdc_alloc_messages(req, GFP_NOFS, num_ops, 0);
> > > +               r = ceph_osdc_alloc_num_messages(req, GFP_NOFS, num_ops, 0);
> > >         else
> > >                 r = ceph_osdc_alloc_messages(req, GFP_NOFS);
> > >         if (r)
> >
> > I think exporting __ceph_osdc_alloc_messages() is wrong, at least
> > conceptually.  Only the OSD client should be concerned with message
> > data items and their count, as they are an implementation detail of
> > the OSD client and the messenger.  Exporting something that takes
> > message data items counts without exporting something for counting
> > them suggests that users will somehow do that on their own and we
> > don't want that.
> >
>
> We already do that in ceph_osdc_new_request(). That function takes a
> num_ops value that describes the number of OSD ops needed, and the
> callers have to fill it out with the number of ops they expect the call
> to use (see the calls in ceph_writepages_start for example).

The number of message data items is not necessarily the same as
the number of OSD ops.  Further, the number of message data items
is different for request and reply messages of the OSD request.
__ceph_osdc_alloc_messages() is private precisely to avoid this
confusion.

Thanks,

                Ilya
