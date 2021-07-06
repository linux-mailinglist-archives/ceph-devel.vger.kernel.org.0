Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E1E3BDBE2
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jul 2021 19:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhGFRFx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jul 2021 13:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230282AbhGFRFw (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 6 Jul 2021 13:05:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BB3C619B6;
        Tue,  6 Jul 2021 17:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625590993;
        bh=tkJ1rHdvM80Gb8kEGPp6CCoPCgRCkm25KpJf42ZG7NA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RGfxJeWV0boJA0jwsuNrwzBEHeiwJh2+4fkzQk+Giw+M4YHEO+ogQrDb+3Os6bjb/
         wxnwADfHBBiHIj6E+ctw/7uZfkIFJy1Cwfs4BIpIiWlRKbVfKlVeHU7AEwByG8xO/O
         RGZzIphA495mLWis3a+FZyW7aBsOEu4YoGrZy9jUKtSHrh17lu7ZnzjoMmCb5kGQpV
         VluIiGj4l4ctozeuumFo4Rm8Jrz7dkrtfg83erq+sT6E8UnERyLm1IVYEwlvdQ7PGF
         Vdh3KVB3awoMJybnaz24stG39TjCiSkVkp6hmWvtxhH3KxW+VrQiClvIBly6/J4KtY
         kEINhHzwEptgg==
Message-ID: <287160b0eba2b2c5e7fe8e1df95ed2ddf077311c.camel@kernel.org>
Subject: Re: [PATCH v3 0/2] ceph_check_delayed_caps() softlockup
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Jul 2021 13:03:12 -0400
In-Reply-To: <20210706135242.9978-1-lhenriques@suse.de>
References: <20210706135242.9978-1-lhenriques@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
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

Looks good. I'll do some testing with this today and will merge into
testing branch if all goes well.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

