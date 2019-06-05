Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5A303609C
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Jun 2019 17:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbfFEP5z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jun 2019 11:57:55 -0400
Received: from tragedy.dreamhost.com ([66.33.205.236]:47129 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbfFEP5z (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Jun 2019 11:57:55 -0400
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id E445815F888;
        Wed,  5 Jun 2019 08:57:53 -0700 (PDT)
Date:   Wed, 5 Jun 2019 15:57:52 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     ceph-users@ceph.com, ceph-devel@vger.kernel.org, dev@ceph.io
Subject: Changing the release cadence
Message-ID: <alpine.DEB.2.11.1906051556500.987@piezo.novalocal>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-VR-STATUS: OK
X-VR-SCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrudegvddgleekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfgggtgesthdtredttdervdenucfhrhhomhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqeenucffohhmrghinhepthifihhtthgvrhdrtghomhenucfkphepuddvjedrtddrtddrudenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplhhotggrlhhhohhsthdpihhnvghtpeduvdejrddtrddtrddupdhrvghtuhhrnhdqphgrthhhpefurghgvgcuhggvihhluceoshgrghgvsehnvgifughrvggrmhdrnhgvtheqpdhmrghilhhfrhhomhepshgrghgvsehnvgifughrvggrmhdrnhgvthdpnhhrtghpthhtoheptggvphhhqdgrnhhnohhunhgtvgestggvphhhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi everyone,

Since luminous, we have had the follow release cadence and policy:   
 - release every 9 months
 - maintain backports for the last two releases
 - enable upgrades to move either 1 or 2 releases heads
   (e.g., luminous -> mimic or nautilus; mimic -> nautilus or octopus; ...)

This has mostly worked out well, except that the mimic release received 
less attention that we wanted due to the fact that multiple downstream 
Ceph products (from Red Has and SUSE) decided to based their next release 
on nautilus.  Even though upstream every release is an "LTS" release, as a 
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

So far the balance of opinion seems to favor a shift to a 12 month 
cycle[1], especially among developers, so it seems pretty likely we'll 
make that shift.  (If you do have strong concerns about such a move, now 
is the time to raise them.)

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

November is nice in the sense that we'd wrap things up before the 
holidays.  It's less good in that users may not be inclined to install the 
new release when many developers will be less available in December.

February kind of sucked in that the scramble to get the last few things
done happened during the holidays.  OTOH, we should be doing what we can
to avoid such scrambles, so that might not be something we should factor
in.  March may be a bit more balanced, with a solid 3 months before when
people are productive, and 3 months after before they disappear on holiday
to address any post-release issues.

People tend to be somewhat less available over the summer months due to
holidays etc, so an early or late summer release might also be less than
ideal.

Thoughts?  If we can narrow it down to a few options maybe we could do a
poll to gauge user preferences.

Thanks!
sage


[1] https://twitter.com/larsmb/status/1130010208971952129

