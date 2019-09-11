Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE923B0497
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2019 21:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbfIKTfx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Sep 2019 15:35:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728285AbfIKTfx (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Sep 2019 15:35:53 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FFF1206A5;
        Wed, 11 Sep 2019 19:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568230552;
        bh=6d/cYa6+FD68raDbTyz2Mu6mUuEJP7/J5qlIbY0qE7c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bc+Y0p+3hWikC8iljW5S5vb4rOyg0uzdZumAlxmenEky0X4AbQp3X9SFAatBqn7fa
         0ABtWgXNC71R6cXZwtvN6H7FnG1fyNMFGXP6XuZCEGCnduCS77bEJtumrqsSVpSsiY
         dDcafBVTRlHoZlpSfl9XMgHXNtBjpv3yaA4gxaOs=
Message-ID: <dc75c171278e4dd1fc00c20b3a9843bb412901ac.camel@kernel.org>
Subject: Re: [PATCH] ceph: add mount opt, always_auth
From:   Jeff Layton <jlayton@kernel.org>
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     simon gao <simon29rock@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Date:   Wed, 11 Sep 2019 15:35:51 -0400
In-Reply-To: <CAJ4mKGbY+veWdLv588Hz4mQidz5ofiGemOQ2Nwx_M6XN0WXGJw@mail.gmail.com>
References: <1568083391-920-1-git-send-email-simon29rock@gmail.com>
         <e413734270fc43cabbf9df09b0ed4bff06a96699.camel@kernel.org>
         <CAJ4mKGbY+veWdLv588Hz4mQidz5ofiGemOQ2Nwx_M6XN0WXGJw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-09-11 at 11:30 -0700, Gregory Farnum wrote:
> On Tue, Sep 10, 2019 at 3:11 AM Jeff Layton <jlayton@kernel.org> wrote:
> > I've no particular objection here, but I'd prefer Greg's ack before we
> > merge it, since he raised earlier concerns.
> 
> You have my acked-by in light of Zheng's comments elsewhere and the
> evidence that this actually works in some scenarios.
> 
> Might be nice to at least get far enough to generate tickets based on
> your questions in the other thread, though:
> 

I'm not sold yet.

Why is this something the client should have to worry about at all? Can
we do something on the MDS to better handle this situation? This really
feels like we're exposing an implementation detail via mount option.

At a bare minimum, if we take this, I'd like to see some documentation.
When should a user decide to turn this on or off? There are no
guidelines to the use of this thing so far.


> On Wed, Sep 11, 2019 at 9:26 AM Jeff Layton <jlayton@kernel.org> wrote:
> > In an ideal world, what should happen in this case? Should we be
> > changing MDS policy to forward the request in this situation?
> > 
> > This mount option seems like it's exposing something that is really an
> > internal implementation detail to the admin. That might be justified,
> > but I'm unclear on why we don't expect more saner behavior from the MDS
> > on this?
> 
> I think partly it's that early designs underestimated the cost of
> replication and overestimated its utility, but I also thought forwards
> were supposed to happen more often than replication so I'm curious why
> it's apparently not doing that.
> -Greg

-- 
Jeff Layton <jlayton@kernel.org>

