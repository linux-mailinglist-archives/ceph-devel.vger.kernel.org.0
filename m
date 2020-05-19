Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35521D97D1
	for <lists+ceph-devel@lfdr.de>; Tue, 19 May 2020 15:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbgESNcM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 May 2020 09:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728857AbgESNcL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 May 2020 09:32:11 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CF5C08C5C0
        for <ceph-devel@vger.kernel.org>; Tue, 19 May 2020 06:32:11 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id j3so13343051ilk.11
        for <ceph-devel@vger.kernel.org>; Tue, 19 May 2020 06:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZizdxviH2TXk0BT61IPizX530BARmSbGV5SdG3o9lGo=;
        b=FxEt3iJUl04dszDhZHOTNl9r4Mo51R8OzjebmRkq05Qi4KFDrw8gnBWgm6Iu13tR5h
         SJ3CReF8Rundo1c5ZbYshscwgvgsesVL+Ytcjy+m3RLwp39Mem1OqD651ZJRu5fRWEm1
         vxNkhDEj1RDFa9rbSyRL/va6XFR7CEhGe5W21Y8ctPnj/b11L5TBnx47OpDS9TwLrBSN
         rV2ItOCiYZK0+66HMHMN0DX3bEw0mxZNXrNTu8esGNnrJcXd7VbUmUlFqXdAL93G/03W
         hwkTfLp59U1OkBv+tCc3cLmxR6xfKHmfrrc/Uxt7xaurDmNWHzfvK1NpUdOSOakptSex
         KSUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZizdxviH2TXk0BT61IPizX530BARmSbGV5SdG3o9lGo=;
        b=CNjqSPvUKP81tkUIlIuFsK1YHJ8OCWhimGCz7y5pwAgO8GpJPRyLk/DlvDFfbxGwqf
         hYHY5EiaoGmwaBjOozN0bBbfnPbA20UXMeKNG3sFkqU4v2NRCbkNhYuMAJYm3OflL+jG
         96lNSXOt34CUZ/J4dtmNN648bkoQWCDZ6dJ9vRMBUfPCRe7Mg5DWTGCfReVm7jjQztXJ
         qf3rVFsnqmlVB/BEUxo75KmIMRisgWqQbQHDHX/mGYx1SvDje8gOdhzg1A8j0iDxB++b
         7dTe8DDtJDLwt+pOVp0DzN9kQBheUXpAjhqYI/oz/Z/fhX03B10g4ycJQeragSpaS7eF
         UrTA==
X-Gm-Message-State: AOAM532nu0F5tuxIK1vtKwyhS7dSD5VVxPqsAr0mDCnjrhSXF92uf98T
        CmTOtF0hxaR7VWiT/I0xyrZGktkJh0kXE5kds/XpHqGv
X-Google-Smtp-Source: ABdhPJxU13vRL+PkaFxwUgCZnx7nZfkh0hs3o+XlyTQz604stCV/jD/Y/SS40ZBs4StM3+ktUNM4E+ckjwswrTUxfsY=
X-Received: by 2002:a92:9f4e:: with SMTP id u75mr20468426ili.282.1589895130728;
 Tue, 19 May 2020 06:32:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAKQB+fug_Y4y8wYe-vG=itf+0BmYFPfDm-ch7DTobtkipQz-yw@mail.gmail.com>
 <CAOi1vP-uF1_0R=5LApR=rdTXSzDWJq3LzuOYPrPmC_TPL909qA@mail.gmail.com> <CAKQB+ftbtXv0ET6OmUMsqKUoz5sRHQA35EprTY82_GC34b10XA@mail.gmail.com>
In-Reply-To: <CAKQB+ftbtXv0ET6OmUMsqKUoz5sRHQA35EprTY82_GC34b10XA@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 19 May 2020 15:32:15 +0200
Message-ID: <CAOi1vP-oMe2SsbuXQ9oeF+nZaCD87Een5Q1=kNPTeXeLAyHH_w@mail.gmail.com>
Subject: Re: [PATCH] libceph: add ignore cache/overlay flag if got redirect reply
To:     Jerry Lee <leisurelysw24@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, May 19, 2020 at 12:30 PM Jerry Lee <leisurelysw24@gmail.com> wrote:
>
> On Tue, 19 May 2020 at 17:14, Ilya Dryomov <idryomov@gmail.com> wrote:
> >
> > On Mon, May 18, 2020 at 10:03 AM Jerry Lee <leisurelysw24@gmail.com> wrote:
> > >
> > > osd client should ignore cache/overlay flag if got redirect reply.
> > > Otherwise, the client hangs when the cache tier is in forward mode.
> > >
> > > Similar issues:
> > >    https://tracker.ceph.com/issues/23296
> > >    https://tracker.ceph.com/issues/36406
> > >
> > > Signed-off-by: Jerry Lee <leisurelysw24@gmail.com>
> > > ---
> > >  net/ceph/osd_client.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > > index 998e26b..1d4973f 100644
> > > --- a/net/ceph/osd_client.c
> > > +++ b/net/ceph/osd_client.c
> > > @@ -3649,7 +3649,9 @@ static void handle_reply(struct ceph_osd *osd,
> > > struct ceph_msg *msg)
> > >                  * supported.
> > >                  */
> > >                 req->r_t.target_oloc.pool = m.redirect.oloc.pool;
> > > -               req->r_flags |= CEPH_OSD_FLAG_REDIRECTED;
> > > +               req->r_flags |= CEPH_OSD_FLAG_REDIRECTED |
> > > +                               CEPH_OSD_FLAG_IGNORE_OVERLAY |
> > > +                               CEPH_OSD_FLAG_IGNORE_CACHE;
> > >                 req->r_tid = 0;
> > >                 __submit_request(req, false);
> > >                 goto out_unlock_osdc;
> >
> > Hi Jerry,
> >
> > Looks good (although the patch was whitespace damaged).  I've fixed
> > it up, but check out Documentation/process/email-clients.rst.
> Thanks for sharing the doc!
> >
> > Also, out of curiosity, are you actually using the forward cache mode?
> No, we accidentally found the issue when removing a writeback cache.
> The kernel client got blocked when the cache mode switched from
> writeback to forward and waited for the cache pool to be flushed.
>
> BTW, a warning (Error EPERM: 'forward' is not a well-supported cache
> mode and may corrupt your data.) is shown when the cache mode is
> changed to forward mode.  Does it mean that the data integrity and IO
> ordering cannot be ensured in this mode?

Yes.  The problem with redirects is that they can mess up the order
of requests.  The forward mode is based on redirects and therefore
inherently flawed.

Use proxy and readproxy modes instead of forward and readforward.

Thanks,

                Ilya
