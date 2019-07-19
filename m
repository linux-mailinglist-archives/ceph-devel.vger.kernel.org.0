Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93AB86ECBF
	for <lists+ceph-devel@lfdr.de>; Sat, 20 Jul 2019 01:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732895AbfGSXai (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 19 Jul 2019 19:30:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41416 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728909AbfGSXai (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 19 Jul 2019 19:30:38 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hocKe-0006qC-Fp; Fri, 19 Jul 2019 23:30:32 +0000
Date:   Sat, 20 Jul 2019 00:30:32 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Luis Henriques <lhenriques@suse.com>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ceph: fix buffer free while holding i_ceph_lock in
 __ceph_setxattr()
Message-ID: <20190719233032.GB17978@ZenIV.linux.org.uk>
References: <20190719143222.16058-1-lhenriques@suse.com>
 <20190719143222.16058-3-lhenriques@suse.com>
 <1dee14212043f12ef5b26e4aee0c3155e118abf3.camel@kernel.org>
 <20190719232307.GA17978@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190719232307.GA17978@ZenIV.linux.org.uk>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, Jul 20, 2019 at 12:23:08AM +0100, Al Viro wrote:
> On Fri, Jul 19, 2019 at 07:07:49PM -0400, Jeff Layton wrote:
> 
> > Al pointed out on IRC that vfree should be callable under spinlock.
> 
> Al had been near-terminally low on caffeine at the time, posted
> a retraction a few minutes later and went to grab some coffee...
> 
> > It
> > only sleeps if !in_interrupt(), and I think that should return true if
> > we're holding a spinlock.
> 
> It can be used from RCU callbacks and all such; it *can't* be used from
> under spinlock - on non-preempt builds there's no way to recognize that.

	Re original patch: looks like the sane way to handle that.
Alternatively, we could add kvfree_atomic() for use in such situations,
but I rather doubt that it's a good idea - not unless you need to free
something under a spinlock held over a large area, which is generally
a bad idea to start with...

	Note that vfree_atomic() has only one caller in the entire tree,
BTW.
