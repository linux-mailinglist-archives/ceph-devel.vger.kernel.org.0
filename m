Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3002D211377
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Jul 2020 21:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgGATZR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Jul 2020 15:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbgGATZN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 1 Jul 2020 15:25:13 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD18C08C5C1
        for <ceph-devel@vger.kernel.org>; Wed,  1 Jul 2020 12:25:13 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id c16so26260533ioi.9
        for <ceph-devel@vger.kernel.org>; Wed, 01 Jul 2020 12:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O4ClDqL/tyloI00kUgCfabQYaDoq1brc7srGsCdzOhE=;
        b=Afy9+OqlpV14rtA89HmOV/xXSgWYA73ymcfWsw1GEhMpAkzDKvOyNjDPdKhJPxZ7EP
         h4AlMiQ1UgZWV6JYU7/N0Xs6stHEVFFsh9VesdQ1h/p2KKuVXkMi11QcDVUffTIffcUo
         dkFwPUtIQTabpIIYN3yEb48L/S8zSgRCAvhbt2HsMlxgRRjfq9okJZNGJDUcax2Gq+dC
         FMQffk83mvF+KnpEwv9T2J/qA3RDgNE+qLISIUeoftF4WRaBVnp/nIZt9t39Qs0n/A86
         VgGUAqKuB5MaCrp925nmSYg1V21tt82gJbRP6C83gfdYj/R4xZOCJ5ZtZfMVDRfIhXp+
         pgJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O4ClDqL/tyloI00kUgCfabQYaDoq1brc7srGsCdzOhE=;
        b=R2JOIjRiIVHL0TVhZdGU3L9KC979D1A4aEn9sQPdwHiMyDXBaLK2wDzC1a2cob9TKN
         H6Lh5oWLFDpypK82JjdpeEpgBL7codSTIVTzTXqPACs9mPp6T6tokgS3vzE5wxytYJPg
         +1gS5zdWK3MUBF6rTFBQk6QpfqXxMwkPzIvVRHgzazJZETWH1KCjcyvD0ikUcjctKaX3
         fJR9j0Kf+BdcgVbI5ALOV+eIcxJLBOHM2gQq1l65H4DrCOfHcr8fLOjT1WN9lS3oZf3w
         uInkXcCIEnBmJT7bnkDsk75VCg77ZM9VgtXWz1yZO3aQo/bypQkx+qpqLB4wUyKMCNoP
         sd2Q==
X-Gm-Message-State: AOAM531645WB4SBAM2Dosw53/TiqRU6HKzzfJsuYwRcVZf4B1Dd12RwJ
        5s1Kbx8WQi8FKJsOxpBufoKCMoHuq/FS7EcdvTCxLcNjmdY=
X-Google-Smtp-Source: ABdhPJx6agxGYAviN9cymEI5SxqPhkRG8of4xErnkHqJQkcx2U1HEWdM1lG2V5kr1m8ThZfec8GtJ3vOSvk82Mioaeo=
X-Received: by 2002:a6b:ee15:: with SMTP id i21mr3876740ioh.25.1593631512763;
 Wed, 01 Jul 2020 12:25:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200701155446.41141-1-jlayton@kernel.org> <20200701155446.41141-3-jlayton@kernel.org>
 <CAOi1vP-o16swX+oHd0Xj30jdTqYUUrm5Fk4O7rA2LwNBKne5QQ@mail.gmail.com> <4b7f50556f879d8aa724fc6dc96edad577c00d85.camel@kernel.org>
In-Reply-To: <4b7f50556f879d8aa724fc6dc96edad577c00d85.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 1 Jul 2020 21:25:18 +0200
Message-ID: <CAOi1vP8UDRD3Ef1xWQzD+W_JxtBq6gg+pz86-81PtyXXKjpa4A@mail.gmail.com>
Subject: Re: [PATCH 2/4] libceph: refactor osdc request initialization
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jul 1, 2020 at 8:24 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2020-07-01 at 20:08 +0200, Ilya Dryomov wrote:
> > On Wed, Jul 1, 2020 at 5:54 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > Turn the request_init helper into a more full-featured initialization
> > > routine that we can use to initialize an already-allocated request.
> > > Make it a public and exported function so we can use it from ceph.ko.
> > >
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  include/linux/ceph/osd_client.h |  4 ++++
> > >  net/ceph/osd_client.c           | 28 +++++++++++++++-------------
> > >  2 files changed, 19 insertions(+), 13 deletions(-)
> > >
> > > diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> > > index 8d63dc22cb36..40a08c4e5d8d 100644
> > > --- a/include/linux/ceph/osd_client.h
> > > +++ b/include/linux/ceph/osd_client.h
> > > @@ -495,6 +495,10 @@ extern struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *,
> > >
> > >  extern void ceph_osdc_get_request(struct ceph_osd_request *req);
> > >  extern void ceph_osdc_put_request(struct ceph_osd_request *req);
> > > +void ceph_osdc_init_request(struct ceph_osd_request *req,
> > > +                           struct ceph_osd_client *osdc,
> > > +                           struct ceph_snap_context *snapc,
> > > +                           unsigned int num_ops);
> > >
> > >  extern int ceph_osdc_start_request(struct ceph_osd_client *osdc,
> > >                                    struct ceph_osd_request *req,
> > > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > > index 3cff29d38b9f..4ddf23120b1a 100644
> > > --- a/net/ceph/osd_client.c
> > > +++ b/net/ceph/osd_client.c
> > > @@ -523,7 +523,10 @@ void ceph_osdc_put_request(struct ceph_osd_request *req)
> > >  }
> > >  EXPORT_SYMBOL(ceph_osdc_put_request);
> > >
> > > -static void request_init(struct ceph_osd_request *req)
> > > +void ceph_osdc_init_request(struct ceph_osd_request *req,
> > > +                           struct ceph_osd_client *osdc,
> > > +                           struct ceph_snap_context *snapc,
> > > +                           unsigned int num_ops)
> > >  {
> > >         /* req only, each op is zeroed in osd_req_op_init() */
> > >         memset(req, 0, sizeof(*req));
> > > @@ -535,7 +538,13 @@ static void request_init(struct ceph_osd_request *req)
> > >         INIT_LIST_HEAD(&req->r_private_item);
> > >
> > >         target_init(&req->r_t);
> > > +
> > > +       req->r_osdc = osdc;
> > > +       req->r_num_ops = num_ops;
> > > +       req->r_snapid = CEPH_NOSNAP;
> > > +       req->r_snapc = ceph_get_snap_context(snapc);
> > >  }
> > > +EXPORT_SYMBOL(ceph_osdc_init_request);
> > >
> > >  /*
> > >   * This is ugly, but it allows us to reuse linger registration and ping
> > > @@ -563,12 +572,9 @@ static void request_reinit(struct ceph_osd_request *req)
> > >         WARN_ON(kref_read(&reply_msg->kref) != 1);
> > >         target_destroy(&req->r_t);
> > >
> > > -       request_init(req);
> > > -       req->r_osdc = osdc;
> > > +       ceph_osdc_init_request(req, osdc, snapc, num_ops);
> > >         req->r_mempool = mempool;
> > > -       req->r_num_ops = num_ops;
> > >         req->r_snapid = snapid;
> > > -       req->r_snapc = snapc;
> > >         req->r_linger = linger;
> > >         req->r_request = request_msg;
> > >         req->r_reply = reply_msg;
> > > @@ -591,15 +597,11 @@ struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *osdc,
> > >                 BUG_ON(num_ops > CEPH_OSD_MAX_OPS);
> > >                 req = kmalloc(struct_size(req, r_ops, num_ops), gfp_flags);
> > >         }
> > > -       if (unlikely(!req))
> > > -               return NULL;
> > >
> > > -       request_init(req);
> > > -       req->r_osdc = osdc;
> > > -       req->r_mempool = use_mempool;
> > > -       req->r_num_ops = num_ops;
> > > -       req->r_snapid = CEPH_NOSNAP;
> > > -       req->r_snapc = ceph_get_snap_context(snapc);
> > > +       if (likely(req)) {
> > > +               req->r_mempool = use_mempool;
> > > +               ceph_osdc_init_request(req, osdc, snapc, num_ops);
> > > +       }
> > >
> > >         dout("%s req %p\n", __func__, req);
> > >         return req;
> >
> > What is going to use ceph_osdc_init_request()?
> >
> > Given that OSD request allocation is non-trivial, exporting a
> > routine for initializing already allocated requests doesn't seem
> > like a good idea.  How do you ensure that the OSD request to be
> > initialized has enough room for passed num_ops?  What about calling
> > this routine on a request that has already been initialized?
> > None of these issues exist today...
> >
>
> Oops, I put this one in the pile by mistake. We don't need this,
> currently. I'll drop this patch from the series.
>
> I've been working with dhowells' fscache rework and the exported helper
> would be needed in the patches I have to wire that up to cephfs.
> Basically we'll need to allocate a structure that contains both a
> fscache request and an OSD request. If those come to fruition, then
> we'll need something like this (and an updated way to handle freeing
> those objects).

Is there a problem with storing a pointer to ceph_osd_request in
that structure?  It can be allocated with ceph_osdc_alloc_request()
and put with ceph_osdc_put_request(), no changes needed.

Thanks,

                Ilya
