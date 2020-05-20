Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794071DA81A
	for <lists+ceph-devel@lfdr.de>; Wed, 20 May 2020 04:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgETCgF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 May 2020 22:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgETCgE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 May 2020 22:36:04 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5E6C061A0E
        for <ceph-devel@vger.kernel.org>; Tue, 19 May 2020 19:36:02 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id j145so1666670oib.5
        for <ceph-devel@vger.kernel.org>; Tue, 19 May 2020 19:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uNNvsxTOKbbkovzdTsfqK5sQFnpWYKEsk5xYvaNEbow=;
        b=N7+KGYC8aQ0ziZM+UslKvjHAC+tEWUqY0ronDsgzmON99RG++ZSLtAEVaEvpsweOb4
         9jRJ0lGLKS/OrSuP5xxKwJOt4Ha6ZSAuGzYR9kpgcukOClEsJ5dTOaRbOmU+H59j57PX
         WWTe4KVSDRyL2MUb/Mbkp1DWp+7is2WPkiu30c+lEFb4OVRMUqqf2xwBUCj5s88Rzxf7
         9vLN1JE90K9O19B4viEVHD3/j5/Xls6gkvW4258yt8yjrmNtRyt1LKslbUHQ8QNA6ae6
         PCUldTRuYYOX77LUcmN4g1SNE5YEEsUF5mvcDL60YdKm0BzKi0pIvwK4EvBfxvZGpj/M
         8veQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uNNvsxTOKbbkovzdTsfqK5sQFnpWYKEsk5xYvaNEbow=;
        b=oHTVeDN8bAZ4FWkuW32JZj2KL/uwbq9OnvqZDRSgAGqg09EJaiqP+QXXfaRecPH1y+
         q9C8b3T0gmakJaERitRJIu6uGLNgDcSRA/obMG5qE4dWgU3p30HZQg0L2iHTTSBa3xxt
         whtBYsWdcYtf0kA7LjvAK9cPAMcEPm/jpxhIC9NWaeuf86FE/6K5kxGTpocdCYo8+2Jk
         FRyuYyQMQEPv/0gExNRUKduDWsNFU7F8t0atvqudtwl0B8CwnYoHRjyIxyta7z6NITn9
         UNgm3S6QCh8V1cFhEhqiJpx9hj0vLDN0tre6+EEPPzY2UyiwaDrHq5xvUweHTtOFbd6H
         Bcng==
X-Gm-Message-State: AOAM530zJM1R4pjnEbJj6mxGgfBU2kJZOjfN3BQNmxJd4F2aVxrNhL58
        lhglj3Y3IkHmm33Ra23HH7YP1bD/73evVzxwzoo=
X-Google-Smtp-Source: ABdhPJzY1DwJ+ZTQ4iYDUWYDKXKEYgb8dOwQU+T3kKKGu097N6py2g+f3MxVP4RWGj8VJWmgYineuI82ANfY/ltI1DM=
X-Received: by 2002:aca:c34f:: with SMTP id t76mr1803009oif.95.1589942161655;
 Tue, 19 May 2020 19:36:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAKQB+fug_Y4y8wYe-vG=itf+0BmYFPfDm-ch7DTobtkipQz-yw@mail.gmail.com>
 <CAOi1vP-uF1_0R=5LApR=rdTXSzDWJq3LzuOYPrPmC_TPL909qA@mail.gmail.com>
 <CAKQB+ftbtXv0ET6OmUMsqKUoz5sRHQA35EprTY82_GC34b10XA@mail.gmail.com> <CAOi1vP-oMe2SsbuXQ9oeF+nZaCD87Een5Q1=kNPTeXeLAyHH_w@mail.gmail.com>
In-Reply-To: <CAOi1vP-oMe2SsbuXQ9oeF+nZaCD87Een5Q1=kNPTeXeLAyHH_w@mail.gmail.com>
From:   Jerry Lee <leisurelysw24@gmail.com>
Date:   Wed, 20 May 2020 10:35:50 +0800
Message-ID: <CAKQB+ftke+gqQQ9OHG9mNvgHJeMbVAN9kKQacgV_Li-B5KWnCw@mail.gmail.com>
Subject: Re: [PATCH] libceph: add ignore cache/overlay flag if got redirect reply
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 19 May 2020 at 21:32, Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Tue, May 19, 2020 at 12:30 PM Jerry Lee <leisurelysw24@gmail.com> wrote:
> >
> > On Tue, 19 May 2020 at 17:14, Ilya Dryomov <idryomov@gmail.com> wrote:
> > >
> > > On Mon, May 18, 2020 at 10:03 AM Jerry Lee <leisurelysw24@gmail.com> wrote:
> > > >
> > > > osd client should ignore cache/overlay flag if got redirect reply.
> > > > Otherwise, the client hangs when the cache tier is in forward mode.
> > > >
> > > > Similar issues:
> > > >    https://tracker.ceph.com/issues/23296
> > > >    https://tracker.ceph.com/issues/36406
> > > >
> > > > Signed-off-by: Jerry Lee <leisurelysw24@gmail.com>
> > > > ---
> > > >  net/ceph/osd_client.c | 4 +++-
> > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > > > index 998e26b..1d4973f 100644
> > > > --- a/net/ceph/osd_client.c
> > > > +++ b/net/ceph/osd_client.c
> > > > @@ -3649,7 +3649,9 @@ static void handle_reply(struct ceph_osd *osd,
> > > > struct ceph_msg *msg)
> > > >                  * supported.
> > > >                  */
> > > >                 req->r_t.target_oloc.pool = m.redirect.oloc.pool;
> > > > -               req->r_flags |= CEPH_OSD_FLAG_REDIRECTED;
> > > > +               req->r_flags |= CEPH_OSD_FLAG_REDIRECTED |
> > > > +                               CEPH_OSD_FLAG_IGNORE_OVERLAY |
> > > > +                               CEPH_OSD_FLAG_IGNORE_CACHE;
> > > >                 req->r_tid = 0;
> > > >                 __submit_request(req, false);
> > > >                 goto out_unlock_osdc;
> > >
> > > Hi Jerry,
> > >
> > > Looks good (although the patch was whitespace damaged).  I've fixed
> > > it up, but check out Documentation/process/email-clients.rst.
> > Thanks for sharing the doc!
> > >
> > > Also, out of curiosity, are you actually using the forward cache mode?
> > No, we accidentally found the issue when removing a writeback cache.
> > The kernel client got blocked when the cache mode switched from
> > writeback to forward and waited for the cache pool to be flushed.
> >
> > BTW, a warning (Error EPERM: 'forward' is not a well-supported cache
> > mode and may corrupt your data.) is shown when the cache mode is
> > changed to forward mode.  Does it mean that the data integrity and IO
> > ordering cannot be ensured in this mode?
>
> Yes.  The problem with redirects is that they can mess up the order
> of requests.  The forward mode is based on redirects and therefore
> inherently flawed.
>
> Use proxy and readproxy modes instead of forward and readforward.
>

Thanks for the clarification.  I refer to the mimic version
cache-tering configuration guide which states that forward mode is
configured when removing a writeback cache.  However, in the
up-to-date doc (master), proxy mode is recommended.  I'll use proxy
mode instead.

Thanks,
- Jerry

> Thanks,
>
>                 Ilya
