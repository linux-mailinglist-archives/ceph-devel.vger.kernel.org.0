Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE5B3FE73C
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Sep 2021 03:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhIBBm1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Sep 2021 21:42:27 -0400
Received: from smtp1.onthe.net.au ([203.22.196.249]:58466 "EHLO
        smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhIBBm0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 1 Sep 2021 21:42:26 -0400
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 6713A61C5E;
        Thu,  2 Sep 2021 11:41:26 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id R6pfIcyn11nR; Thu,  2 Sep 2021 11:41:26 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 585BE61BE8;
        Thu,  2 Sep 2021 11:41:25 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 37BD3680291; Thu,  2 Sep 2021 11:41:25 +1000 (AEST)
Date:   Thu, 2 Sep 2021 11:41:25 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Subject: Re: New pacific mon won't join with octopus mons
Message-ID: <20210902014125.GA13333@onthe.net.au>
References: <20210830234929.GA3817015@onthe.net.au>
 <CAJ4mKGZN+zAzyMM1+mWuPw5r1v=b-QQrChm+_0nfWtzcbyx=_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAJ4mKGZN+zAzyMM1+mWuPw5r1v=b-QQrChm+_0nfWtzcbyx=_g@mail.gmail.com>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Gregory,

On Wed, Sep 01, 2021 at 10:56:56AM -0700, Gregory Farnum wrote:
> Why are you trying to create a new pacific monitor instead of
> upgrading an existing one?

The "ceph orch upgrade" failed twice at the point of upgrading the 
mons, once due to the octopus mons getting the "--init" argument added 
to their docker startup and the docker version on Debian Buster not 
supporting both the "--init" and "-v /dev:/dev" args at the same time, 
per:

https://github.com/moby/moby/pull/37665

...and once due to never having a cephfs on the cluster:

https://tracker.ceph.com/issues/51673

So at one point I had one mon down due to the failed upgrade, then 
another of the 3 originals was taken out by the host's disk filling up 
(due, I think, to the excessive logging occurring at the time in 
combination with having both docker and podman images pulled in), 
leaving me with a single octopus mon running and no quorum, bringing 
the cluster to a stand still, and me panic-learning how to deal with 
the situation. Fun times.

So yes, I was feeling just a little leery about upgrading the octopus 
mons and potentialy losing quorum again!

> I *think* what's going on here is that since you're deploying a new
> pacific mon, and you're not giving it a starting monmap, it's set up
> to assume the use of pacific features. It can find peers at the
> locations you've given it, but since they're on octopus there are
> mismatches.
>
> Now, I would expect and want this to work so you should file a bug,

https://tracker.ceph.com/issues/52488

> but the initial bootstrapping code is a bit hairy and may not account
> for cross-version initial setup in this fashion, or have gotten buggy
> since written. So I'd try upgrading the existing mons, or generating a
> new pacific mon and upgrading that one to octopus if you're feeling
> leery.

Yes, I thought a safer / less stressful way of progressing would be to 
add a new octopus mon to the existing quorum and upgrade that one 
first as a test. I went ahead with that and checked the cluster health 
immediately afterwards: "ceph -s" showed HEALTH_OK, with 4 mons, i.e. 
3 x octopus and 1 x pacific.

Nice!  

But shortly later alarms started going off and the health of the 
cluster was coming back as more than a little gut-wrenching, with ALL 
pgs showing up as inactive / unknown:

$ ceph -s
   cluster:
     id:     c6618970-0ce0-4cb2-bc9a-dd5f29b62e24
     health: HEALTH_WARN
             Reduced data availability: 5721 pgs inactive
             (muted: OSDMAP_FLAGS POOL_NO_REDUNDANCY)

   services:
     mon: 4 daemons, quorum k2,b2,b4,b5 (age 43m)
     mgr: b5(active, starting, since 40m), standbys: b4, b2
     osd: 78 osds: 78 up (since 4d), 78 in (since 3w)
          flags noout

   data:
     pools:   12 pools, 5721 pgs
     objects: 0 objects, 0 B
     usage:   0 B used, 0 B / 0 B avail
     pgs:     100.000% pgs unknown
              5721 unknown

$ ceph health detail
HEALTH_WARN Reduced data availability: 5721 pgs inactive; (muted: OSDMAP_FLAGS POOL_NO_REDUNDANCY)
(MUTED) [WRN] OSDMAP_FLAGS: noout flag(s) set
[WRN] PG_AVAILABILITY: Reduced data availability: 5721 pgs inactive
     pg 6.fcd is stuck inactive for 41m, current state unknown, last acting []
     pg 6.fce is stuck inactive for 41m, current state unknown, last acting []
     pg 6.fcf is stuck inactive for 41m, current state unknown, last acting []
     pg 6.fd0 is stuck inactive for 41m, current state unknown, last acting []
     ...etc.

So that was also heaps of fun for a while, until I thought to remove 
the pacific mon and the health reverted to normal. Bug filed:

https://tracker.ceph.com/issues/52489

At this point I'm more than a little gun shy, but I'm girding my loins 
to go ahead with the rest of the upgrade on the basis the health issue 
is "just" a temporary reporting problem (albeit a highly startling 
one!) with mixed octopus and pacific mons.

Cheers,

Chris
