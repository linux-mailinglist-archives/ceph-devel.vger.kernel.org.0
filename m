Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBEBD3E04E8
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Aug 2021 17:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239517AbhHDPxB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Aug 2021 11:53:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239206AbhHDPxB (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 4 Aug 2021 11:53:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DEF060F25;
        Wed,  4 Aug 2021 15:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628092368;
        bh=y2K70y5ON2gciIK11tOs4PeOiKpsBaGaEf50u+gW4Hw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NBegZvTMP7uNDbx7CHoU/WMe7lEg96WP1fBO4QD1jt/YmqnyoHcMrDpBNrGCfAXNI
         ysuu6kDRyv/1RKdMZXrBRauEryGlG8oGbBHFFHYYONw0Wq971ZJku/z9RAEbb7yUmh
         LPKP9Q4Q03ktBlGA6uPp1d2EVAPJkD0lfomGNM7GtGsvw1GU9suP3sEKsTS6BX8u+L
         +H7PUWMqFJ8BoLZ9ZgVIvDXrpYPfX8NEqP4hzoDm64PVW51G8knBmdWKjc7WGLjQt4
         qQtQ5sZLAfh3EmYn9qWY6T2rUpWBHxCrB3892NNYkzhoWHzdj2j0nXY6eHoNRefrgo
         nR+4F4GaclIPQ==
Message-ID: <c4d437beb2ccecc776ee6cd8e5b345c8d87080f8.camel@kernel.org>
Subject: Re: [PATCH v3 0/2] ceph_check_delayed_caps() softlockup
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 04 Aug 2021 11:52:47 -0400
In-Reply-To: <20210706135242.9978-1-lhenriques@suse.de>
References: <20210706135242.9978-1-lhenriques@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-07-06 at 14:52 +0100, Luis Henriques wrote:
> * changes since v3:
>   - always round the delay with round_jiffies_relative() in function
>     schedule_delayed() (patch 0001)
> 
> This is an attempt to fix the softlock on the delayed_work workqueue.  As
> stated in 0002 patch:
> 
>   Function ceph_check_delayed_caps() is called from the mdsc->delayed_work
>   workqueue and it can be kept looping for quite some time if caps keep being
>   added back to the mdsc->cap_delay_list.  This may result in the watchdog
>   tainting the kernel with the softlockup flag.
> 
> v2 of this fix modifies the approach by time-bounding the loop in this
> function, so that any caps added to the list *after* the loop starts will
> be postponed to the next wq run.
> 
> An extra change in 0001 (suggested by Jeff) allows scheduling runs for
> periods smaller than the default (5 secs) period.  This way,
> delayed_work() can have the next run scheduled for the next list element
> ci->i_hold_caps_max instead of 5 secs.
> 
> This patchset should fix the issue reported here [1], although a quick
> search for "ceph_check_delayed_caps" in the tracker returns a few more
> bugs, possibly duplicates.
> 
> [1] https://tracker.ceph.com/issues/46284
> 
> Luis Henriques (2):
>   ceph: allow schedule_delayed() callers to set delay for workqueue
>   ceph: reduce contention in ceph_check_delayed_caps()
> 
>  fs/ceph/caps.c       | 17 ++++++++++++++++-
>  fs/ceph/mds_client.c | 25 ++++++++++++++++---------
>  fs/ceph/super.h      |  2 +-
>  3 files changed, 33 insertions(+), 11 deletions(-)
> 

FWIW, we've had some more reports of this, so I think we should get this
into mainline and stable soon. I'm going to squash these two patches
together as it should (hopefully) make it simpler for stable backports.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

