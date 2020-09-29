Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADD127CE08
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Sep 2020 14:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730749AbgI2Msa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Sep 2020 08:48:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728632AbgI2MsZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 08:48:25 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF52A2083B;
        Tue, 29 Sep 2020 12:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601383704;
        bh=vbxzyR83QewFUg1q1jRuRlk5dC8cWidPMEgsft8BWtY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uxe5LwDD8tafghBMZvtk8OTB0hDt8VZQl0BMR/vme5RiI3yFT4TPb3jk8zWE+rwNk
         J4wV40ZXE6nN7wLOPXMWFoNp5PdnXGuO8BcHMFuA+3xFdPGN/sstIqQWZUYZ2zRGjn
         jgTmEMf60y02NJTyOQ96giwDpfwskn8I/Oq9pjJI=
Message-ID: <3224feb0441327729dc777666c33042b4ced82a8.camel@kernel.org>
Subject: Re: [RFC PATCH 0/4] ceph: fix spurious recover_session=clean errors
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>
Date:   Tue, 29 Sep 2020 08:48:22 -0400
In-Reply-To: <CAOi1vP_E9he3RaTHAZ3qeXGe1xgcSkEXdrCYOY7rjab4-vr=6w@mail.gmail.com>
References: <20200925140851.320673-1-jlayton@kernel.org>
         <CAAM7YAmJfNCbt4ON5c44FFVYOUhXu0ipK858aLJK22ZX2E-FdA@mail.gmail.com>
         <CAOi1vP9Nz2Art=rq06qBuU3DvKzZs+RR7pf+qsGxYZkrbSB-1Q@mail.gmail.com>
         <CAAM7YA=bo-pdnLuxFAyChtZCoP6VZ3oUJEX_+Sn5r6i6bO_+8Q@mail.gmail.com>
         <CAOi1vP_E9he3RaTHAZ3qeXGe1xgcSkEXdrCYOY7rjab4-vr=6w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-09-29 at 12:58 +0200, Ilya Dryomov wrote:
> On Tue, Sep 29, 2020 at 12:44 PM Yan, Zheng <ukernel@gmail.com> wrote:
> > On Tue, Sep 29, 2020 at 4:55 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> > > On Tue, Sep 29, 2020 at 10:28 AM Yan, Zheng <ukernel@gmail.com> wrote:
> > > > On Fri, Sep 25, 2020 at 10:08 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > > Ilya noticed that he would get spurious EACCES errors on calls done just
> > > > > after blocklisting the client on mounts with recover_session=clean. The
> > > > > session would get marked as REJECTED and that caused in-flight calls to
> > > > > die with EACCES. This patchset seems to smooth over the problem, but I'm
> > > > > not fully convinced it's the right approach.
> > > > > 
> > > > 
> > > > the root is cause is that client does not recover session instantly
> > > > after getting rejected by mds. Before session gets recovered, client
> > > > continues to return error.
> > > 
> > > Hi Zheng,
> > > 
> > > I don't think it's about whether that happens instantly or not.
> > > In the example from [1], the first "ls" would fail even if issued
> > > minutes after the session reject message and the reconnect.  From
> > > the user's POV it is well after the automatic recovery promised by
> > > recover_session=clean.
> > > 
> > > [1] https://tracker.ceph.com/issues/47385
> > 
> > Reconnect should close all old session. It's likely because that
> > client didn't detect it's blacklisted.
> 
> Sorry, I should have pasted dmesg there as well.  It _does_ detect
> blacklisting -- notice that I wrote "after the session reject message
> and the reconnect".
> 

Yep, this is pretty easy to reproduce too (as Ilya points out in the tracker).

I'm open to other ways of smoothing this over. If we end up with a small
window where errors can occur, then so be it, but I think we can
probably do better than we have now.

-- 
Jeff Layton <jlayton@kernel.org>

