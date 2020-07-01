Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693032113E7
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Jul 2020 21:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgGATvG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Jul 2020 15:51:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgGATvG (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 1 Jul 2020 15:51:06 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73A1620720;
        Wed,  1 Jul 2020 19:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593633065;
        bh=xMnAZmdenoMuafypSf/g6liBIUxNSkaf0iuCAaYXCD0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SHicrZNpSp6h8Ey7aZFJ6DKNm9jzQInnPBnWYimxgR0LJKG3IjuCbhX5+2HT5dNtA
         LBWs1hIKDx/wWdI6gy2PvLokDtsYJ/yXgRvE9Yl4yPlcQ4OzFHxscd/ykSKzO7J+7+
         E8AnuSMR+iEKOXPEX5k/cqsxGqRGkxLkBNFY5/7k=
Message-ID: <7956ae72031fa070f8ac17fb385da960fea67bc1.camel@kernel.org>
Subject: Re: [PATCH 3/4] libceph: rename __ceph_osdc_alloc_messages to
 ceph_osdc_alloc_num_messages
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Date:   Wed, 01 Jul 2020 15:51:04 -0400
In-Reply-To: <CAOi1vP9prxnVNbTDvJM8os6K_o7EcqSif4Ey4Moba-j7FJdOtg@mail.gmail.com>
References: <20200701155446.41141-1-jlayton@kernel.org>
         <20200701155446.41141-4-jlayton@kernel.org>
         <CAOi1vP_200rymwrks34JTn224Y6yGaBfu2oX01xj-qKS+c08sQ@mail.gmail.com>
         <1d5a9f273770150266e3e45e11116a82484e4a14.camel@kernel.org>
         <CAOi1vP9prxnVNbTDvJM8os6K_o7EcqSif4Ey4Moba-j7FJdOtg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-07-01 at 21:40 +0200, Ilya Dryomov wrote:
> On Wed, Jul 1, 2020 at 9:17 PM Jeff Layton <jlayton@kernel.org> wrote:
> > On Wed, 2020-07-01 at 20:48 +0200, Ilya Dryomov wrote:
> > > On Wed, Jul 1, 2020 at 5:54 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > ...and make it public and export it.
> > > > 
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >  include/linux/ceph/osd_client.h |  3 +++
> > > >  net/ceph/osd_client.c           | 13 +++++++------
> > > >  2 files changed, 10 insertions(+), 6 deletions(-)
> > > > 
> > > > diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> > > > index 40a08c4e5d8d..71b7610c3a3c 100644
> > > > --- a/include/linux/ceph/osd_client.h
> > > > +++ b/include/linux/ceph/osd_client.h
> > > > @@ -481,6 +481,9 @@ extern struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *
> > > >                                                unsigned int num_ops,
> > > >                                                bool use_mempool,
> > > >                                                gfp_t gfp_flags);
> > > > +int ceph_osdc_alloc_num_messages(struct ceph_osd_request *req, gfp_t gfp,
> > > > +                                int num_request_data_items,
> > > > +                                int num_reply_data_items);
> > > >  int ceph_osdc_alloc_messages(struct ceph_osd_request *req, gfp_t gfp);
> > > > 
> > > >  extern struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *,
> > > > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > > > index 4ddf23120b1a..7be78fa6e2c3 100644
> > > > --- a/net/ceph/osd_client.c
> > > > +++ b/net/ceph/osd_client.c
> > > > @@ -613,9 +613,9 @@ static int ceph_oloc_encoding_size(const struct ceph_object_locator *oloc)
> > > >         return 8 + 4 + 4 + 4 + (oloc->pool_ns ? oloc->pool_ns->len : 0);
> > > >  }
> > > > 
> > > > -static int __ceph_osdc_alloc_messages(struct ceph_osd_request *req, gfp_t gfp,
> > > > -                                     int num_request_data_items,
> > > > -                                     int num_reply_data_items)
> > > > +int ceph_osdc_alloc_num_messages(struct ceph_osd_request *req, gfp_t gfp,
> > > > +                                int num_request_data_items,
> > > > +                                int num_reply_data_items)
> > > >  {
> > > >         struct ceph_osd_client *osdc = req->r_osdc;
> > > >         struct ceph_msg *msg;
> > > > @@ -672,6 +672,7 @@ static int __ceph_osdc_alloc_messages(struct ceph_osd_request *req, gfp_t gfp,
> > > > 
> > > >         return 0;
> > > >  }
> > > > +EXPORT_SYMBOL(ceph_osdc_alloc_num_messages);
> > > > 
> > > >  static bool osd_req_opcode_valid(u16 opcode)
> > > >  {
> > > > @@ -738,8 +739,8 @@ int ceph_osdc_alloc_messages(struct ceph_osd_request *req, gfp_t gfp)
> > > >         int num_request_data_items, num_reply_data_items;
> > > > 
> > > >         get_num_data_items(req, &num_request_data_items, &num_reply_data_items);
> > > > -       return __ceph_osdc_alloc_messages(req, gfp, num_request_data_items,
> > > > -                                         num_reply_data_items);
> > > > +       return ceph_osdc_alloc_num_messages(req, gfp, num_request_data_items,
> > > > +                                                 num_reply_data_items);
> > > >  }
> > > >  EXPORT_SYMBOL(ceph_osdc_alloc_messages);
> > > > 
> > > > @@ -1129,7 +1130,7 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
> > > >                  * also covers ceph_uninline_data().  If more multi-op request
> > > >                  * use cases emerge, we will need a separate helper.
> > > >                  */
> > > > -               r = __ceph_osdc_alloc_messages(req, GFP_NOFS, num_ops, 0);
> > > > +               r = ceph_osdc_alloc_num_messages(req, GFP_NOFS, num_ops, 0);
> > > >         else
> > > >                 r = ceph_osdc_alloc_messages(req, GFP_NOFS);
> > > >         if (r)
> > > 
> > > I think exporting __ceph_osdc_alloc_messages() is wrong, at least
> > > conceptually.  Only the OSD client should be concerned with message
> > > data items and their count, as they are an implementation detail of
> > > the OSD client and the messenger.  Exporting something that takes
> > > message data items counts without exporting something for counting
> > > them suggests that users will somehow do that on their own and we
> > > don't want that.
> > > 
> > 
> > We already do that in ceph_osdc_new_request(). That function takes a
> > num_ops value that describes the number of OSD ops needed, and the
> > callers have to fill it out with the number of ops they expect the call
> > to use (see the calls in ceph_writepages_start for example).
> 
> The number of message data items is not necessarily the same as
> the number of OSD ops.  Further, the number of message data items
> is different for request and reply messages of the OSD request.
> __ceph_osdc_alloc_messages() is private precisely to avoid this
> confusion.
> 

Got it, thanks. I'll think about how to rework this code in light of that.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

