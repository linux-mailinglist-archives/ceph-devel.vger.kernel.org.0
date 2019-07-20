Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED7666ED06
	for <lists+ceph-devel@lfdr.de>; Sat, 20 Jul 2019 02:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390084AbfGTAgj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 19 Jul 2019 20:36:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389904AbfGTAfm (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 20:35:42 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E94EC21874;
        Sat, 20 Jul 2019 00:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563582941;
        bh=9PtDy/ZTq6mqmfYsecqNaovIbWAGNo389ImL2mCZgCk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=z20H/jRY57Eqvw6lTekNSJhyWlpVWsNG3AUzUmGAajjmbjdteBXx0PDFnIdExDHnu
         pv9bBiA81IvTdyfvNKczPNtGubunLrRhwg0lf9GhEWeQ24la/UhaYWv7OmrHBs1Rj4
         o6o/jJH67jy9ndNo8LnVUq4mwDVyg1Qbe2iZmzCk=
Message-ID: <3925c4f98ea836b53f8c0e325d6e4334f3436f86.camel@kernel.org>
Subject: Re: [PATCH 2/4] ceph: fix buffer free while holding i_ceph_lock in
 __ceph_setxattr()
From:   Jeff Layton <jlayton@kernel.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Luis Henriques <lhenriques@suse.com>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 19 Jul 2019 20:35:39 -0400
In-Reply-To: <20190719233032.GB17978@ZenIV.linux.org.uk>
References: <20190719143222.16058-1-lhenriques@suse.com>
         <20190719143222.16058-3-lhenriques@suse.com>
         <1dee14212043f12ef5b26e4aee0c3155e118abf3.camel@kernel.org>
         <20190719232307.GA17978@ZenIV.linux.org.uk>
         <20190719233032.GB17978@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2019-07-20 at 00:30 +0100, Al Viro wrote:
> On Sat, Jul 20, 2019 at 12:23:08AM +0100, Al Viro wrote:
> > On Fri, Jul 19, 2019 at 07:07:49PM -0400, Jeff Layton wrote:
> > 
> > > Al pointed out on IRC that vfree should be callable under spinlock.
> > 
> > Al had been near-terminally low on caffeine at the time, posted
> > a retraction a few minutes later and went to grab some coffee...
> > 
> > > It
> > > only sleeps if !in_interrupt(), and I think that should return true if
> > > we're holding a spinlock.
> > 
> > It can be used from RCU callbacks and all such; it *can't* be used from
> > under spinlock - on non-preempt builds there's no way to recognize that.
> 
> 	Re original patch: looks like the sane way to handle that.
> Alternatively, we could add kvfree_atomic() for use in such situations,
> but I rather doubt that it's a good idea - not unless you need to free
> something under a spinlock held over a large area, which is generally
> a bad idea to start with...
> 
> 	Note that vfree_atomic() has only one caller in the entire tree,
> BTW.

In that case, I wonder if we ought to add this to the top of kvfree():

	might_sleep_if(!in_interrupt());

Might there be other places that are calling it under spinlock that are
almost always going down the kfree() path?
-- 
Jeff Layton <jlayton@kernel.org>

