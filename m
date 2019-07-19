Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E926E7E6
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Jul 2019 17:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbfGSPUi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 19 Jul 2019 11:20:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726711AbfGSPUh (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 11:20:37 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37F4C2083B;
        Fri, 19 Jul 2019 15:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563549636;
        bh=8RmchD2l/bQKOy5engQ2eeDSOmx7TCxD1k24iaIMbZ8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KQLv5u08yyAKXzEUPKpbKlUHiHHPOt7/5VvYLjgbCzXCT9uiALvaGBrw5N/tqYH1T
         ioGJNewKrHA6GNGdPdh5gQL3ZS/cmgIw46bWjT+XmDXVD/iJsaqJ4P/JN+wz6pi6ZV
         h7nLu6bzmRR4LBwP4Xk1fC3LpOHWvkwmJRv4pUBQ=
Message-ID: <ab5ccaa05994e2eef05bdb54510e6b017db2d807.camel@kernel.org>
Subject: Re: [PATCH 0/4] Sleeping functions in invalid context bug fixes
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 19 Jul 2019 11:20:34 -0400
In-Reply-To: <20190719143222.16058-1-lhenriques@suse.com>
References: <20190719143222.16058-1-lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2019-07-19 at 15:32 +0100, Luis Henriques wrote:
> Hi,
> 
> I'm sending three "sleeping function called from invalid context" bug
> fixes that I had on my TODO for a while.  All of them are ceph_buffer_put
> related, and all the fixes follow the same pattern: delay the operation
> until the ci->i_ceph_lock is released.
> 
> The first patch simply allows ceph_buffer_put to receive a NULL buffer so
> that the NULL check doesn't need to be performed in all the other patches.
> IOW, it's not really required, just convenient.
> 
> (Note: maybe these patches should all be tagged for stable.)
> 
> Luis Henriques (4):
>   libceph: allow ceph_buffer_put() to receive a NULL ceph_buffer
>   ceph: fix buffer free while holding i_ceph_lock in __ceph_setxattr()
>   ceph: fix buffer free while holding i_ceph_lock in
>     __ceph_build_xattrs_blob()
>   ceph: fix buffer free while holding i_ceph_lock in fill_inode()
> 
>  fs/ceph/caps.c              |  5 ++++-
>  fs/ceph/inode.c             |  7 ++++---
>  fs/ceph/snap.c              |  4 +++-
>  fs/ceph/super.h             |  2 +-
>  fs/ceph/xattr.c             | 19 ++++++++++++++-----
>  include/linux/ceph/buffer.h |  3 ++-
>  6 files changed, 28 insertions(+), 12 deletions(-)

This all looks good to me. I'll plan to merge these into the testing
branch soon, and tag them for stable.

PS: On a related note (and more of a question for Ilya)...

I'm wondering if we get any benefit from having our own ceph_kvmalloc
routine. Why are we not better off using the stock kvmalloc routine
instead? Forcing a vmalloc just because we've gone above 32k allocation
doesn't seem like the right thing to do.

PPS: I also wonder if we ought to put a might_sleep() in kvfree(). I
think that kfree generally doesn't, and I wonder how many uses of this
end up using kfree until memory ends up fragmented.
-- 
Jeff Layton <jlayton@kernel.org>

