Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10B3233981
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2019 22:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfFCUH3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Jun 2019 16:07:29 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:55860 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfFCUH3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Jun 2019 16:07:29 -0400
Received: by mail-it1-f196.google.com with SMTP id i21so9939996ita.5
        for <ceph-devel@vger.kernel.org>; Mon, 03 Jun 2019 13:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6CPBqc6lRhdPB+5HZlKleYNZbK28kO3EUcnMAaHSWXM=;
        b=mRuw7vso7/MrjBXN1izA2ZIyTSSqVC+eovQyLkYBT/28R3Ddl+Jwg5y8pcJUyuzVqI
         WIpG4MgYLP16ViL4JRMU/Xs5WVvzIr0VfBPKTGhC6sxypFqMgqNZgAlCMn2KwYxXLTCb
         fbDNfAdcLy5juYE81PDsZAdp0hBPBZ3IDg+Imvef4hq56DgbThmAkttVuoO/8dUG+3Ug
         TCRPu8c881WLj3n/vidMXgGG3XYAfV7i48ix9bAOY3mMU3T5/u5WmOP+VyQvF4nQgVC4
         fvmn/G5LplozsNWNx5x6t1nSUzCc30AXIxE3oI8HcelqhIucL/8aER6thPm4nhGTiPY5
         W0VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6CPBqc6lRhdPB+5HZlKleYNZbK28kO3EUcnMAaHSWXM=;
        b=C7sBEtV1xT7UWa8QDsR8Er5M3YEp2i0A45MnceZbz5eBDICu0R9SPF6kjkhN5BApI3
         3e/GHJXvRoV/NaR90uRrYtZZQVn3pD84t8wAg4o8gbCZRofMi8E08/QIry0dHfV5pKEe
         RWSqB8zT3x5mMcssiY5n+q9RbOPFu9wovIZA9uyl09WRZ+g2yj1vN0iwczQo0DlcCcIq
         6RXNQfuVbNhzJ1fchk3QW4Djvte3JX9WRcUmfBv0XWItRuOhKG3P4WJc9qYPe/d97nLL
         bxz5c6P2yKAaaafCymYEE0JUxMw+dDbcM702Es5j/HkvhvUS06UpGAMtdHa5m6+OzQfn
         YCew==
X-Gm-Message-State: APjAAAUUc4rlrZ++3tWfPTq6qoPlstNdeEqkl94isDXYwi0J/hCajR2Y
        Gg5r0uGaOfTrnvBnvxFC79BoqdX2jtTSyrTcJG4=
X-Google-Smtp-Source: APXvYqx2dgux7f0wP7LWn3z+fu6o2yf6RS8v+MoWhARSa9LqAd5T23QKnkL/rP27QfRcfJsiJBgG3xTlvxAD6OtOx8g=
X-Received: by 2002:a24:8957:: with SMTP id s84mr3750395itd.131.1559592448582;
 Mon, 03 Jun 2019 13:07:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190531122802.12814-1-zyan@redhat.com> <20190531122802.12814-2-zyan@redhat.com>
 <CAOi1vP8O6VviiNKrozmwUOtVN+GtvA=-0fEOXcdbg8O+pu1PhQ@mail.gmail.com>
 <CAAM7YAmY-ky2E_9aPHNSNMmmTp9rC+Aw-eBMN_KP1suY_u+Wmg@mail.gmail.com> <CAJ4mKGZHm3TqwU8Q=rn1xQtePMhaJNvU4yHGj0jDqR_9oxz2fA@mail.gmail.com>
In-Reply-To: <CAJ4mKGZHm3TqwU8Q=rn1xQtePMhaJNvU4yHGj0jDqR_9oxz2fA@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 3 Jun 2019 22:07:32 +0200
Message-ID: <CAOi1vP8k88mFJgLYvD-zWBFgwV4vQ4DR0wBDzSDeDCDBaSLj_g@mail.gmail.com>
Subject: Re: [PATCH 2/3] ceph: add method that forces client to reconnect
 using new entity addr
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     "Yan, Zheng" <ukernel@gmail.com>, "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Luis Henriques <lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 3, 2019 at 7:54 PM Gregory Farnum <gfarnum@redhat.com> wrote:
>
> On Mon, Jun 3, 2019 at 6:51 AM Yan, Zheng <ukernel@gmail.com> wrote:
> >
> > On Fri, May 31, 2019 at 10:20 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> > >
> > > On Fri, May 31, 2019 at 2:30 PM Yan, Zheng <zyan@redhat.com> wrote:
> > > >
> > > > echo force_reconnect > /sys/kernel/debug/ceph/xxx/control
> > > >
> > > > Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> > >
> > > Hi Zheng,
> > >
> > > There should be an explanation in the commit message of what this is
> > > and why it is needed.
> > >
> > > I'm assuming the use case is recovering a blacklisted mount, but what
> > > is the intended semantics?  What happens to in-flight OSD requests,
> > > MDS requests, open files, etc?  These are things that should really be
> > > written down.
> > >
> > got it
> >
> > > Looking at the previous patch, it appears that in-flight OSD requests
> > > are simply retried, as they would be on a regular connection fault.  Is
> > > that safe?
> > >
> >
> > It's not safe. I still thinking about how to handle dirty data and
> > in-flight osd requests in the this case.
>
> Can we figure out the consistency-handling story before we start
> adding interfaces for people to mis-use then please?
>
> It's not pleasant but if the client gets disconnected I'd assume we
> have to just return EIO or something on all outstanding writes and
> toss away our dirty data. There's not really another option that makes
> any sense, is there?

Can we also discuss how useful is allowing to recover a mount after it
has been blacklisted?  After we fail everything with EIO and throw out
all dirty state, how many applications would continue working without
some kind of restart?  And if you are restarting your application, why
not get a new mount?

IOW what is the use case for introducing a new debugfs knob that isn't
that much different from umount+mount?

Thanks,

                Ilya
