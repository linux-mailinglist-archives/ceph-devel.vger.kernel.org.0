Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90966B171F
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Sep 2019 04:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfIMCIt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Sep 2019 22:08:49 -0400
Received: from mail-qk1-f174.google.com ([209.85.222.174]:41424 "EHLO
        mail-qk1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbfIMCIs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 12 Sep 2019 22:08:48 -0400
Received: by mail-qk1-f174.google.com with SMTP id p10so8616038qkg.8
        for <ceph-devel@vger.kernel.org>; Thu, 12 Sep 2019 19:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EEAUha08WwXMr6vSCzrwki1TYoUjz7IDQNUcB9XnE20=;
        b=M0g83gJlxohS/X2I9NPgAg+2LPwK0h6Zfo01HdYs2lWvXp/QtNGlTTgIyMRkpl4h3o
         AYee39WEBG5xLC9G7uTQHr+DSFsx/sNGYVVHmwfugpW7xiru3Dyd//Jxf5D/4wEGYbJ7
         MKP0sJ39x6hhmhzGetrtz5BFMDATw81elH2yljx7uBWLbNaZdkXvhUvW1mW0uvQY/QHW
         2SjSN1xzLV8EurFP7zpPOzH7TDQTv9sRxuCbf9S90AutSXe7WGhbrhS7J41uaWdE/QXt
         wbG62XfJloCwTLZG9x49wpKN0rfRHZ3BfW8oGOkAmNX9H9t++dVPcV7ewLtMA2HOPe1m
         YKBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EEAUha08WwXMr6vSCzrwki1TYoUjz7IDQNUcB9XnE20=;
        b=WDWaNNrdeVjy7pIOEQDogOK327Tw4EqSZqKsyPAwTXxNhWor4a0UHaX6xd+UmhC3nA
         kUVhK/kQzuhF0dXn1Lm93jtXgZuvKFDXmZRmOeEWYl1ol82Xtc8fWvkB1WejidWakqLB
         5Woqh/zvSixoz5o5j3o7sfwTtgLOa2+8esRmmlO2Q0Zp4u1jFMkYZaZfN5KztUg9vClV
         zXavRsAyirebvl8pqJM7Ev9uWHGYIu64mdxX40xODjBlfKvU0vAXt3NnhpsAeC18SOV0
         WBr2jpPH/n/XR5U0e16cYvA39I8piFTPIHxrsYEjAo/rCL4aRy4mxXaEhuOCUnQMQiFy
         zIXg==
X-Gm-Message-State: APjAAAUk0kVjLs3cZzbkunfFxK2ORcGh/pttBUqchaUsq0HD/sOvCC0u
        a1FQlBOdF2kdOJdazUAr06rGxbip6mX+XHFkQxs=
X-Google-Smtp-Source: APXvYqw+IqKZKo67YO52XHd+1wx7m9+Xtiio9aWwPuqqvNBoWDiZQK0W7vPjz2fKx+RCzeazbd55pxAaEcIupULiO/8=
X-Received: by 2002:a37:a612:: with SMTP id p18mr42229411qke.56.1568340527588;
 Thu, 12 Sep 2019 19:08:47 -0700 (PDT)
MIME-Version: 1.0
References: <1568083391-920-1-git-send-email-simon29rock@gmail.com>
 <e413734270fc43cabbf9df09b0ed4bff06a96699.camel@kernel.org>
 <CAJ4mKGbY+veWdLv588Hz4mQidz5ofiGemOQ2Nwx_M6XN0WXGJw@mail.gmail.com> <dc75c171278e4dd1fc00c20b3a9843bb412901ac.camel@kernel.org>
In-Reply-To: <dc75c171278e4dd1fc00c20b3a9843bb412901ac.camel@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Fri, 13 Sep 2019 10:08:35 +0800
Message-ID: <CAAM7YAmdccvHiOB6+qk5MOLX5u3NrTa4MrUOH_MG+VD=_TV3cA@mail.gmail.com>
Subject: Re: [PATCH] ceph: add mount opt, always_auth
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Gregory Farnum <gfarnum@redhat.com>,
        simon gao <simon29rock@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Sep 12, 2019 at 6:21 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2019-09-11 at 11:30 -0700, Gregory Farnum wrote:
> > On Tue, Sep 10, 2019 at 3:11 AM Jeff Layton <jlayton@kernel.org> wrote:
> > > I've no particular objection here, but I'd prefer Greg's ack before we
> > > merge it, since he raised earlier concerns.
> >
> > You have my acked-by in light of Zheng's comments elsewhere and the
> > evidence that this actually works in some scenarios.
> >
> > Might be nice to at least get far enough to generate tickets based on
> > your questions in the other thread, though:
> >
>
> I'm not sold yet.
>
> Why is this something the client should have to worry about at all? Can
> we do something on the MDS to better handle this situation? This really
> feels like we're exposing an implementation detail via mount option.
>

I think we can.  make mds return empty DirStat::dist in request reply

> At a bare minimum, if we take this, I'd like to see some documentation.
> When should a user decide to turn this on or off? There are no
> guidelines to the use of this thing so far.
>
>
> > On Wed, Sep 11, 2019 at 9:26 AM Jeff Layton <jlayton@kernel.org> wrote:
> > > In an ideal world, what should happen in this case? Should we be
> > > changing MDS policy to forward the request in this situation?
> > >
> > > This mount option seems like it's exposing something that is really an
> > > internal implementation detail to the admin. That might be justified,
> > > but I'm unclear on why we don't expect more saner behavior from the MDS
> > > on this?
> >
> > I think partly it's that early designs underestimated the cost of
> > replication and overestimated its utility, but I also thought forwards
> > were supposed to happen more often than replication so I'm curious why
> > it's apparently not doing that.
> > -Greg
>
> --
> Jeff Layton <jlayton@kernel.org>
>
