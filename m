Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 479153658C
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Jun 2019 22:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfFEUfE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jun 2019 16:35:04 -0400
Received: from mail.eyonic.com ([173.164.195.35]:45726 "EHLO mail.eyonic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbfFEUfE (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 16:35:04 -0400
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Jun 2019 16:35:03 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.eyonic.com (Postfix) with ESMTP id 292612089A;
        Wed,  5 Jun 2019 13:27:05 -0700 (PDT)
X-Virus-Scanned: Debian amavisd-new at eyonic.com
Received: from mail.eyonic.com ([127.0.0.1])
        by localhost (mail.eyonic.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kVlFElR3iKBD; Wed,  5 Jun 2019 13:27:02 -0700 (PDT)
Received: from mail.eyonic.com (localhost [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: ctaylor)
        by mail.eyonic.com (Postfix) with ESMTPSA id 15D6D2019C;
        Wed,  5 Jun 2019 13:27:01 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 05 Jun 2019 13:27:01 -0700
From:   Chris Taylor <ctaylor@eyonic.com>
To:     Alexandre DERUMIER <aderumier@odiso.com>
Cc:     Sage Weil <sage@newdream.net>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@ceph.com>, dev@ceph.io
Subject: Re: [ceph-users] Changing the release cadence
In-Reply-To: <12252276.433203.1559762173198.JavaMail.zimbra@odiso.com>
References: <alpine.DEB.2.11.1906051556500.987@piezo.novalocal>
 <12252276.433203.1559762173198.JavaMail.zimbra@odiso.com>
Message-ID: <c7af8b1292cd0c82f14ef99f977468b8@mail.eyonic.com>
X-Sender: ctaylor@eyonic.com
User-Agent: Roundcube Webmail/1.2-beta
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


It seems like since the change to the 9 months cadence it has been bumpy 
for the Debian based installs. Changing to a 12 month cadence sounds 
like a good idea. Perhaps some Debian maintainers can suggest a good 
month for them to get the packages in time for their release cycle.


On 2019-06-05 12:16 pm, Alexandre DERUMIER wrote:
> Hi,
> 
> 
>>> - November: If we release Octopus 9 months from the Nautilus release
>>> (planned for Feb, released in Mar) then we'd target this November. We
>>> could shift to a 12 months candence after that.
> 
> For the 2 last debian releases, the freeze was around january-february,
> november seem to be a good time for ceph release.
> 
> ----- Mail original -----
> De: "Sage Weil" <sage@newdream.net>
> À: "ceph-users" <ceph-users@ceph.com>, "ceph-devel"
> <ceph-devel@vger.kernel.org>, dev@ceph.io
> Envoyé: Mercredi 5 Juin 2019 17:57:52
> Objet: Changing the release cadence
> 
> Hi everyone,
> 
> Since luminous, we have had the follow release cadence and policy:
> - release every 9 months
> - maintain backports for the last two releases
> - enable upgrades to move either 1 or 2 releases heads
> (e.g., luminous -> mimic or nautilus; mimic -> nautilus or octopus; 
> ...)
> 
> This has mostly worked out well, except that the mimic release received
> less attention that we wanted due to the fact that multiple downstream
> Ceph products (from Red Has and SUSE) decided to based their next 
> release
> on nautilus. Even though upstream every release is an "LTS" release, as 
> a
> practical matter mimic got less attention than luminous or nautilus.
> 
> We've had several requests/proposals to shift to a 12 month cadence. 
> This
> has several advantages:
> 
> - Stable/conservative clusters only have to be upgraded every 2 years
> (instead of every 18 months)
> - Yearly releases are more likely to intersect with downstream
> distribution release (e.g., Debian). In the past there have been
> problems where the Ceph releases included in consecutive releases of a
> distro weren't easily upgradeable.
> - Vendors that make downstream Ceph distributions/products tend to
> release yearly. Aligning with those vendors means they are more likely
> to productize *every* Ceph release. This will help make every Ceph
> release an "LTS" release (not just in name but also in terms of
> maintenance attention).
> 
> So far the balance of opinion seems to favor a shift to a 12 month
> cycle[1], especially among developers, so it seems pretty likely we'll
> make that shift. (If you do have strong concerns about such a move, now
> is the time to raise them.)
> 
> That brings us to an important decision: what time of year should we
> release? Once we pick the timing, we'll be releasing at that time 
> *every
> year* for each release (barring another schedule shift, which we want 
> to
> avoid), so let's choose carefully!
> 
> A few options:
> 
> - November: If we release Octopus 9 months from the Nautilus release
> (planned for Feb, released in Mar) then we'd target this November. We
> could shift to a 12 months candence after that.
> - February: That's 12 months from the Nautilus target.
> - March: That's 12 months from when Nautilus was *actually* released.
> 
> November is nice in the sense that we'd wrap things up before the
> holidays. It's less good in that users may not be inclined to install 
> the
> new release when many developers will be less available in December.
> 
> February kind of sucked in that the scramble to get the last few things
> done happened during the holidays. OTOH, we should be doing what we can
> to avoid such scrambles, so that might not be something we should 
> factor
> in. March may be a bit more balanced, with a solid 3 months before when
> people are productive, and 3 months after before they disappear on 
> holiday
> to address any post-release issues.
> 
> People tend to be somewhat less available over the summer months due to
> holidays etc, so an early or late summer release might also be less 
> than
> ideal.
> 
> Thoughts? If we can narrow it down to a few options maybe we could do a
> poll to gauge user preferences.
> 
> Thanks!
> sage
> 
> 
> [1] https://twitter.com/larsmb/status/1130010208971952129
> 
> _______________________________________________
> ceph-users mailing list
> ceph-users@lists.ceph.com
> http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com
