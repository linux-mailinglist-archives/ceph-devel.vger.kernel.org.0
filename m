Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D4F3FF7EC
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Sep 2021 01:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345824AbhIBXhT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Sep 2021 19:37:19 -0400
Received: from smtp1.onthe.net.au ([203.22.196.249]:35211 "EHLO
        smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235909AbhIBXhT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 Sep 2021 19:37:19 -0400
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id C329961C21;
        Fri,  3 Sep 2021 09:36:18 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id zpIE0xQVEYIg; Fri,  3 Sep 2021 09:36:18 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 165E261C1F;
        Fri,  3 Sep 2021 09:36:18 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id E9210680291; Fri,  3 Sep 2021 09:36:17 +1000 (AEST)
Date:   Fri, 3 Sep 2021 09:36:17 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Drew Freiberger <drew.freiberger@canonical.com>
Cc:     Gregory Farnum <gfarnum@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Subject: Re: New pacific mon won't join with octopus mons
Message-ID: <20210902233617.GA70949@onthe.net.au>
References: <20210830234929.GA3817015@onthe.net.au>
 <CAJ4mKGZN+zAzyMM1+mWuPw5r1v=b-QQrChm+_0nfWtzcbyx=_g@mail.gmail.com>
 <20210902014125.GA13333@onthe.net.au>
 <e48c8f1a-b6ac-e811-cd45-ffba451a133e@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e48c8f1a-b6ac-e811-cd45-ffba451a133e@canonical.com>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Drew,

On Thu, Sep 02, 2021 at 01:19:07PM -0500, Drew Freiberger wrote:
> Given your history of being on pre-octopus release on this environment 
> and having gone through other upgrades, have you ensured you've 
> completed all steps of the upgrade and set your minimum versions per 
> the documentation?  I've seen where octopus will drop nautilus osds if 
> the osd_minimum_version wasn't set to nautilus before introduction of 
> the octopus mons.  I wonder if you're running into something similar 
> with the o->p upgrade.
>
> Check here for further details about completing upgrades (this started 
> in Luminous series):
>
> https://ceph.io/en/news/blog/2017/new-luminous-upgrade-complete/

I'm confident the upgrade to octopus was completed per:

https://docs.ceph.com/en/latest/releases/octopus/#upgrading-from-mimic-or-nautilus

Cheers,

Chris
