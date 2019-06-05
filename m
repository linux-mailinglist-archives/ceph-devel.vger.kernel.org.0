Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56586364C4
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Jun 2019 21:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfFETfP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Wed, 5 Jun 2019 15:35:15 -0400
Received: from mailpro.odiso.net ([89.248.211.110]:56934 "EHLO
        mailpro.odiso.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbfFETfP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Jun 2019 15:35:15 -0400
X-Greylist: delayed 1140 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Jun 2019 15:35:14 EDT
Received: from localhost (localhost [127.0.0.1])
        by mailpro.odiso.net (Postfix) with ESMTP id 7E7BC14A2986;
        Wed,  5 Jun 2019 21:16:13 +0200 (CEST)
Received: from mailpro.odiso.net ([127.0.0.1])
        by localhost (mailpro.odiso.net [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Nx8BNjEdyjqw; Wed,  5 Jun 2019 21:16:13 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mailpro.odiso.net (Postfix) with ESMTP id 6504314A298A;
        Wed,  5 Jun 2019 21:16:13 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mailpro.odiso.com
Received: from mailpro.odiso.net ([127.0.0.1])
        by localhost (mailpro.odiso.net [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fT8uRu3wmyAy; Wed,  5 Jun 2019 21:16:13 +0200 (CEST)
Received: from mailpro.odiso.net (mailpro.odiso.net [10.1.31.111])
        by mailpro.odiso.net (Postfix) with ESMTP id 4F16014A2986;
        Wed,  5 Jun 2019 21:16:13 +0200 (CEST)
Date:   Wed, 5 Jun 2019 21:16:13 +0200 (CEST)
From:   Alexandre DERUMIER <aderumier@odiso.com>
To:     Sage Weil <sage@newdream.net>
Cc:     ceph-users <ceph-users@ceph.com>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Message-ID: <12252276.433203.1559762173198.JavaMail.zimbra@odiso.com>
In-Reply-To: <alpine.DEB.2.11.1906051556500.987@piezo.novalocal>
References: <alpine.DEB.2.11.1906051556500.987@piezo.novalocal>
Subject: Re: Changing the release cadence
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Mailer: Zimbra 8.8.12_GA_3803 (ZimbraWebClient - GC71 (Linux)/8.8.12_GA_3794)
Thread-Topic: Changing the release cadence
Thread-Index: JEDPZL2hf2MXql9JV6NUM+ayilQ2Mw==
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,


>>- November: If we release Octopus 9 months from the Nautilus release 
>>(planned for Feb, released in Mar) then we'd target this November. We 
>>could shift to a 12 months candence after that. 

For the 2 last debian releases, the freeze was around january-february,
november seem to be a good time for ceph release.

----- Mail original -----
De: "Sage Weil" <sage@newdream.net>
À: "ceph-users" <ceph-users@ceph.com>, "ceph-devel" <ceph-devel@vger.kernel.org>, dev@ceph.io
Envoyé: Mercredi 5 Juin 2019 17:57:52
Objet: Changing the release cadence

Hi everyone, 

Since luminous, we have had the follow release cadence and policy: 
- release every 9 months 
- maintain backports for the last two releases 
- enable upgrades to move either 1 or 2 releases heads 
(e.g., luminous -> mimic or nautilus; mimic -> nautilus or octopus; ...) 

This has mostly worked out well, except that the mimic release received 
less attention that we wanted due to the fact that multiple downstream 
Ceph products (from Red Has and SUSE) decided to based their next release 
on nautilus. Even though upstream every release is an "LTS" release, as a 
practical matter mimic got less attention than luminous or nautilus. 

We've had several requests/proposals to shift to a 12 month cadence. This 
has several advantages: 

- Stable/conservative clusters only have to be upgraded every 2 years 
(instead of every 18 months) 
- Yearly releases are more likely to intersect with downstream 
distribution release (e.g., Debian). In the past there have been 
problems where the Ceph releases included in consecutive releases of a 
distro weren't easily upgradeable. 
- Vendors that make downstream Ceph distributions/products tend to 
release yearly. Aligning with those vendors means they are more likely 
to productize *every* Ceph release. This will help make every Ceph 
release an "LTS" release (not just in name but also in terms of 
maintenance attention). 

So far the balance of opinion seems to favor a shift to a 12 month 
cycle[1], especially among developers, so it seems pretty likely we'll 
make that shift. (If you do have strong concerns about such a move, now 
is the time to raise them.) 

That brings us to an important decision: what time of year should we 
release? Once we pick the timing, we'll be releasing at that time *every 
year* for each release (barring another schedule shift, which we want to 
avoid), so let's choose carefully! 

A few options: 

- November: If we release Octopus 9 months from the Nautilus release 
(planned for Feb, released in Mar) then we'd target this November. We 
could shift to a 12 months candence after that. 
- February: That's 12 months from the Nautilus target. 
- March: That's 12 months from when Nautilus was *actually* released. 

November is nice in the sense that we'd wrap things up before the 
holidays. It's less good in that users may not be inclined to install the 
new release when many developers will be less available in December. 

February kind of sucked in that the scramble to get the last few things 
done happened during the holidays. OTOH, we should be doing what we can 
to avoid such scrambles, so that might not be something we should factor 
in. March may be a bit more balanced, with a solid 3 months before when 
people are productive, and 3 months after before they disappear on holiday 
to address any post-release issues. 

People tend to be somewhat less available over the summer months due to 
holidays etc, so an early or late summer release might also be less than 
ideal. 

Thoughts? If we can narrow it down to a few options maybe we could do a 
poll to gauge user preferences. 

Thanks! 
sage 


[1] https://twitter.com/larsmb/status/1130010208971952129 

