Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29D3D17F532
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Mar 2020 11:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbgCJKki (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Mar 2020 06:40:38 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:40444 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbgCJKki (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Mar 2020 06:40:38 -0400
Received: by mail-io1-f67.google.com with SMTP id d8so12226309ion.7
        for <ceph-devel@vger.kernel.org>; Tue, 10 Mar 2020 03:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=odd7hD2+l8QahjS/8Y1IgN5kLSsxnDrfM25qBP/twcI=;
        b=o/9F48cnkavhXkdEKjUb/XScdc9n+vrWEHTZGAgBDI75ijA0Zl1LDOO9D95Zkc6sUu
         eKQ0GTvqnC5sy1zrkugRRjhtlTBV8hOOU9N/TTpcStA+Znp7TBR4lbCNtdohtOeVIjtn
         RugRCsMY6k96sbBYv5+hcDDg768kbWJpAh/ytCgx0En9CX7hfPSr9F47vlQQlpTRNYYr
         8taK+BzudVUcsZU514BJiCIVbeaOvDAp5tB2xc2UqVzrKeBTB5yDgvT6q8Tk2LbZAMte
         mXUFUwzALdJJg9ffJONdmdil68EGGebj1QVpUuhgTGi85QLCs9pwMYT/YoIbUbOp2VrZ
         nrDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=odd7hD2+l8QahjS/8Y1IgN5kLSsxnDrfM25qBP/twcI=;
        b=qkJhkYYEnm8+cu9Lg0eR0Z7o1gz1Qf1Nu1zVwS4C6yuIG93TeiYqnWLRg/efzKteDM
         PcGq/YJEoObAg0g0pV/KlBTNc+XeONH89Uluc0CDA43aUYT5xoEH2txkMKZ5mXYCOqES
         X0ThFOotIu01nLBqvgi0tn0T1x73z3fmZAPI/VuAUHm7UxkCJLZ2O9zVEG83TXxZHKAZ
         I4OkMxnEseZgxZKKAug90M9ba5AO8eh8EM0ZQVjEpCcyL5aolqmRR7YPJzvUTMQPqsSR
         GmTn4gavcXHz6ttCGlQiqwQOIYp1LahnJb4iXGPPbtzM6brHL9H9qkvH0CcGz5UMKcLy
         +Naw==
X-Gm-Message-State: ANhLgQ331JDPY6hcE0sSQQvpZrpgeE1pTFW6jCKyFYOORo/bbe0d58J0
        PHN4AV7LUQL1LCWdiYh31y0gDdKLR/kuXIGI2/c=
X-Google-Smtp-Source: ADFU+vtJKVAwZBF9SjEbITBpHezEiQzzjtXARxmqy8my180sU6i8vENxhtm1Zyo4xf1He9c296V2T9LgrdFcrU7GUac=
X-Received: by 2002:a02:76c2:: with SMTP id z185mr3232547jab.76.1583836837430;
 Tue, 10 Mar 2020 03:40:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200310090924.49788-1-rpenyaev@suse.de> <CAOi1vP9chc5PZD8SpSKXWMec2jMgESQuoAqkwy5GpF61Qs2Uhg@mail.gmail.com>
 <9998629d1021eb8c2bd3a1bd5c2d87c8@suse.de>
In-Reply-To: <9998629d1021eb8c2bd3a1bd5c2d87c8@suse.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 10 Mar 2020 11:40:38 +0100
Message-ID: <CAOi1vP8S6xTpbNaeRHZ=pKOf4vbw03LxT5RbheDMSHidDPGr+w@mail.gmail.com>
Subject: Re: [PATCH 1/1] libceph: fix memory leak for messages allocated with CEPH_MSG_DATA_PAGES
To:     Roman Penyaev <rpenyaev@suse.de>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Mar 10, 2020 at 11:15 AM Roman Penyaev <rpenyaev@suse.de> wrote:
>
> On 2020-03-10 11:03, Ilya Dryomov wrote:
> > On Tue, Mar 10, 2020 at 10:09 AM Roman Penyaev <rpenyaev@suse.de>
> > wrote:
> >>
> >> OSD client allocates a message with a page vector for OSD_MAP,
> >> OSD_BACKOFF
> >> and WATCH_NOTIFY message types (see alloc_msg_with_page_vector()
> >> caller),
> >> but pages vector release is never called.
> >>
> >> Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
> >> Cc: Ilya Dryomov <idryomov@gmail.com>
> >> Cc: Jeff Layton <jlayton@kernel.org>
> >> Cc: Sage Weil <sage@redhat.com>
> >> Cc: ceph-devel@vger.kernel.org
> >> ---
> >>  net/ceph/messenger.c | 9 ++++++++-
> >>  1 file changed, 8 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> >> index 5b4bd8261002..28cbd55ec2e3 100644
> >> --- a/net/ceph/messenger.c
> >> +++ b/net/ceph/messenger.c
> >> @@ -3248,8 +3248,15 @@ static struct ceph_msg_data
> >> *ceph_msg_data_add(struct ceph_msg *msg)
> >>
> >>  static void ceph_msg_data_destroy(struct ceph_msg_data *data)
> >>  {
> >> -       if (data->type == CEPH_MSG_DATA_PAGELIST)
> >> +       if (data->type == CEPH_MSG_DATA_PAGES) {
> >> +               int num_pages;
> >> +
> >> +               num_pages = calc_pages_for(data->alignment,
> >> +                                          data->length);
> >> +               ceph_release_page_vector(data->pages, num_pages);
> >> +       } else if (data->type == CEPH_MSG_DATA_PAGELIST) {
> >>                 ceph_pagelist_release(data->pagelist);
> >> +       }
> >>  }
> >>
> >>  void ceph_msg_data_add_pages(struct ceph_msg *msg, struct page
> >> **pages,
> >
> > Hi Roman,
> >
> > I don't think there is a leak here.
> >
> > osdmap and backoff messages don't have data.
>
> I tried to be symmetric on this path: allocation path
> exists, but there is no deallocation.
>
> > watch_notify message may or may not have data and this is dealt
> > with in handle_watch_notify().  The pages are either released in
> > handle_watch_notify() or transferred to ceph_osdc_notify() through
> > lreq.  The caller of ceph_osdc_notify() is then responsible for
> > them:
> >
> >    * @preply_{pages,len} are initialized both on success and error.
> >    * The caller is responsible for:
> >    *
> >    *     ceph_release_page_vector(...)
> >    */
> >   int ceph_osdc_notify(struct ceph_osd_client *osdc,
>
> Thanks for taking a look. Then there is a rare and unobvious
> leak, please check ceph_con_in_msg_alloc() in messenger.c.
> Message can be allocated for osd client (->alloc_msg) and then
> can be immediately put by the following path:
>
>         if (con->state != CON_STATE_OPEN) {
>                 if (msg)
>                         ceph_msg_put(msg);
>
> (also few lines below where con->in_msg is put)
>
> without reaching the dispatch and set of handle_* functions,
> which you've referred.

Yeah, this one is real, and rather old.  That is why there is a TODO
on top of alloc_msg_with_page_vector():

  /*
   * TODO: switch to a msg-owned pagelist
   */

>
> And seems if the ownership of the ->pages is transferred to
> the handle_watch_notify() and freed there, then it should be
> fixed by having release in one place: here or there.

The problem is that at least at one point CEPH_MSG_DATA_PAGES needed
a reference count -- it couldn't be freed it in one place.  pagelists
are reference counted, but can't be easily swapped in, hence that TODO.

Thanks for reminding me about this.  I'll take a look -- perhaps the
reference count is no longer required and we can get away with a simple
flag.

                Ilya
