Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE8C66F7C4
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jul 2019 05:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfGVDLk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 21 Jul 2019 23:11:40 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:20448 "EHLO
        cdptpa-cmomta02.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726106AbfGVDLk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 21 Jul 2019 23:11:40 -0400
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Jul 2019 23:11:37 EDT
Received: from JohnDoey ([68.204.117.149])
        by cmsmtp with ESMTP
        id pOblhUSvszqEzpObohe8mn; Mon, 22 Jul 2019 03:03:29 +0000
From:   "Brent Kennedy" <bkennedy@cfl.rr.com>
To:     "'Sage Weil'" <sage@newdream.net>, <ceph-users@ceph.com>,
        <ceph-devel@vger.kernel.org>, <dev@ceph.io>
References: <alpine.DEB.2.11.1906051556500.987@piezo.novalocal>
In-Reply-To: <alpine.DEB.2.11.1906051556500.987@piezo.novalocal>
Subject: RE: [ceph-users] Changing the release cadence
Date:   Sun, 21 Jul 2019 23:03:25 -0400
Message-ID: <02cb01d5403a$09b89430$1d29bc90$@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQLxqoXA8cGz7tBL+zGTlxd79GmfiaSdHplQ
Content-Language: en-us
X-CMAE-Envelope: MS4wfEoj5NksvFGbC3ZD+hPgMPTjYuZwbe08J3FdIl29B15J+8jP/KPCaWsQeGNSk3A269vrtL/7VwW2IicL7qqAq32xl8+YldXqYVjIFKRpwJYkTvGCBKGu
 wba7MjpzGa6i7C6q7MJLYwm2RqGcMp+jIu7/E00xowg0LINY7KBLpyr0QLb1lC3apJupu3hCXXZK8eOb3bUVtCNFgBWITuwrK6gpEkx2mpOxqLV+Lt15WOyA
 jGOAL5MPppPShX0w6wGvPg==
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

12 months sounds good to me, I like the idea of march as well since we plan
on doing upgrades in June/July each year.  Gives it time to be discussed and
marinate before we decide to upgrade.

-Brent

-----Original Message-----
From: ceph-users <ceph-users-bounces@lists.ceph.com> On Behalf Of Sage Weil
Sent: Wednesday, June 5, 2019 11:58 AM
To: ceph-users@ceph.com; ceph-devel@vger.kernel.org; dev@ceph.io
Subject: [ceph-users] Changing the release cadence

Hi everyone,

Since luminous, we have had the follow release cadence and policy:   
 - release every 9 months
 - maintain backports for the last two releases
 - enable upgrades to move either 1 or 2 releases heads
   (e.g., luminous -> mimic or nautilus; mimic -> nautilus or octopus; ...)

This has mostly worked out well, except that the mimic release received less
attention that we wanted due to the fact that multiple downstream Ceph
products (from Red Has and SUSE) decided to based their next release on
nautilus.  Even though upstream every release is an "LTS" release, as a
practical matter mimic got less attention than luminous or nautilus.

We've had several requests/proposals to shift to a 12 month cadence. This
has several advantages:

 - Stable/conservative clusters only have to be upgraded every 2 years
   (instead of every 18 months)
 - Yearly releases are more likely to intersect with downstream
   distribution release (e.g., Debian).  In the past there have been 
   problems where the Ceph releases included in consecutive releases of a 
   distro weren't easily upgradeable.
 - Vendors that make downstream Ceph distributions/products tend to
   release yearly.  Aligning with those vendors means they are more likely 
   to productize *every* Ceph release.  This will help make every Ceph 
   release an "LTS" release (not just in name but also in terms of 
   maintenance attention).

So far the balance of opinion seems to favor a shift to a 12 month cycle[1],
especially among developers, so it seems pretty likely we'll make that
shift.  (If you do have strong concerns about such a move, now is the time
to raise them.)

That brings us to an important decision: what time of year should we
release?  Once we pick the timing, we'll be releasing at that time *every
year* for each release (barring another schedule shift, which we want to
avoid), so let's choose carefully!

A few options:

 - November: If we release Octopus 9 months from the Nautilus release
   (planned for Feb, released in Mar) then we'd target this November.  We 
   could shift to a 12 months candence after that.
 - February: That's 12 months from the Nautilus target.
 - March: That's 12 months from when Nautilus was *actually* released.

November is nice in the sense that we'd wrap things up before the holidays.
It's less good in that users may not be inclined to install the new release
when many developers will be less available in December.

February kind of sucked in that the scramble to get the last few things done
happened during the holidays.  OTOH, we should be doing what we can to avoid
such scrambles, so that might not be something we should factor in.  March
may be a bit more balanced, with a solid 3 months before when people are
productive, and 3 months after before they disappear on holiday to address
any post-release issues.

People tend to be somewhat less available over the summer months due to
holidays etc, so an early or late summer release might also be less than
ideal.

Thoughts?  If we can narrow it down to a few options maybe we could do a
poll to gauge user preferences.

Thanks!
sage


[1] https://twitter.com/larsmb/status/1130010208971952129

_______________________________________________
ceph-users mailing list
ceph-users@lists.ceph.com
http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com

