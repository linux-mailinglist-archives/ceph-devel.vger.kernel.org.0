Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECEBCD49C8
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Oct 2019 23:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbfJKVVC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Oct 2019 17:21:02 -0400
Received: from gproxy3-pub.mail.unifiedlayer.com ([69.89.30.42]:43326 "EHLO
        gproxy3-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727500AbfJKVVC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 11 Oct 2019 17:21:02 -0400
X-Greylist: delayed 1355 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Oct 2019 17:21:01 EDT
Received: from CMGW (unknown [10.9.0.13])
        by gproxy3.mail.unifiedlayer.com (Postfix) with ESMTP id 32E6E40320
        for <ceph-devel@vger.kernel.org>; Fri, 11 Oct 2019 14:58:26 -0600 (MDT)
Received: from host449.hostmonster.com ([67.20.76.149])
        by cmsmtp with ESMTP
        id J1zWiEQU320MZJ1zWiy4dV; Fri, 11 Oct 2019 14:58:26 -0600
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.2 cv=NPylwwyg c=1 sm=1 tr=0
 a=yEtxjLh4/o1uitG8KVajyg==:117 a=yEtxjLh4/o1uitG8KVajyg==:17
 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=XobE76Q3jBoA:10 a=KDLhjfZvl3oA:10 a=4u6H09k7AAAA:8
 a=g_j2K2K2AAAA:20 a=euUTByVmV6qcwb6YcNAA:9 a=QEXdDO2ut3YA:10
 a=f1e5DWh3MDoA:10 a=5yerskEF2kbSkDMynNst:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=petasan.org
        ; s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iXr0bgG7EphJk1mPh/+JmXVjXvJ6MGbfzbb4Q45H/fE=; b=XB5+pX0ysGTGMqEtpUmWjLqbHw
        ykc1KH/f15BYJZZIGsWl/uWlRhsOOUEcHkhB7bZY16dxu7e2GZbXqxqf1yzhytQN6iUrv8t+NGddN
        zhEEbPBHiZ+BYbDd2AnwKDwjyVFVlDhFb3tC/abdkdLgzrdxdON4BDf4Q30xxYf/hpah7IZ4kHjGj
        dhSiZoDQEEG0xltsvRjMbH+1vlR04E589rbLadPNMNS5FBNNKOyEVXT3+UnBL9rdIOIXxwPcoESQt
        nH9VUyYWJVe5i+pcTCtnJ/juYAUcD6lNNabtS9FHKa/thIm7EoHmPUsnI3We8NVuq7dJDf1QMovWl
        m7FxwWCA==;
Received: from [196.144.129.170] (port=47604 helo=[192.168.100.132])
        by host449.hostmonster.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <mmokhtar@petasan.org>)
        id 1iJ1zV-003TiZ-6G; Fri, 11 Oct 2019 14:58:25 -0600
Subject: Re: local mode -- a new tier mode
To:     "Honggang(Joseph) Yang" <eagle.rtlinux@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
References: <CAMrPN_JjckOAnQC_=C+YJ1+QTMRbUkGSu24Pyuo1EC=rfXGuRQ@mail.gmail.com>
From:   Maged Mokhtar <mmokhtar@petasan.org>
Message-ID: <6ca5062a-911e-e68f-7d16-8495044b4049@petasan.org>
Date:   Fri, 11 Oct 2019 22:58:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAMrPN_JjckOAnQC_=C+YJ1+QTMRbUkGSu24Pyuo1EC=rfXGuRQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host449.hostmonster.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - petasan.org
X-BWhitelist: no
X-Source-IP: 196.144.129.170
X-Source-L: No
X-Exim-ID: 1iJ1zV-003TiZ-6G
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.100.132]) [196.144.129.170]:47604
X-Source-Auth: mmokhtar@petasan.org
X-Email-Count: 5
X-Source-Cap: cGV0YXNhbm87cGV0YXNhbm87aG9zdDQ0OS5ob3N0bW9uc3Rlci5jb20=
X-Org:  HG=bhcustomer;ORG=bluehost;
X-Local-Domain: yes
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Looks quite interesting, i do however think local caching is better done 
at the block level (bcache, dm-cache, dm-writecache) rather than in 
Ceph. In theory they can deal with a smaller granularity than a Ceph 
object + go through the kernel block layer which is more optimized than 
a Ceph OSD.

Your results do show favorable comparison with bcache, it will be good 
to try to know why this is the case (at least at a high level), i know 
cache testing/simulation is not easy to compare two caching methods, but 
i think it is important to know why local Ceph caching would be better.

It will also be interesting to compare it with dm-writecache, which is 
optimized for writes (using pmem or ssd devices) which is in many cases 
the main performance bottleneck as reads can be cached in memory 
(assuming you have enough ram).

So i think more tests need to be done, which for caching is not a simple 
matter. I believe fio does have a random_distribution=zipf:[theta] 
parameter trying to simulate semi real io, as pure serial or pure random 
io is not suitable for testing cache.

/Maged

On 11/10/2019 18:04, Honggang(Joseph) Yang wrote:
> Hi,
>
> We implemented a new cache tier mode - local mode. In this mode, an
> osd is configured to manage two data devices, one is fast device, one
> is slow device. Hot objects are promoted from slow device to fast
> device, and demoted from fast device to slow device when they become
> cold.
>
> The introduction of tier local mode in detail is
> https://tracker.ceph.com/issues/42286
>
> tier local mode: https://github.com/yanghonggang/ceph/commits/wip-tier-new
>
> This work is based on ceph v12.2.5. I'm glad to port it to master
> branch if needed.
>
> Any advice and suggestions will be greatly appreciated.
>
> thx,
>
> Yang Honggang
> _______________________________________________
> Dev mailing list -- dev@ceph.io
> To unsubscribe send an email to dev-leave@ceph.io

