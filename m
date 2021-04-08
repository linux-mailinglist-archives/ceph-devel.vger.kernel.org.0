Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE050358D6C
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Apr 2021 21:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbhDHTUp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Apr 2021 15:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbhDHTUp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Apr 2021 15:20:45 -0400
X-Greylist: delayed 562 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 08 Apr 2021 12:20:33 PDT
Received: from smtp.bit.nl (smtp.bit.nl [IPv6:2001:7b8:3:5::25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13570C061760
        for <ceph-devel@vger.kernel.org>; Thu,  8 Apr 2021 12:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bit.nl;
        s=smtp01; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:From:To:Subject:Sender:Cc;
        bh=XNvVjW2d8SDEnphzr7jM4yCSoVY5xGaouYbiRLJk16I=; b=MLcmAx7JVflRF9wTBdEgK/8E0k
        hdOiKkM+9zjYT+7TnVKwAGR5iIltUMQTpXp8SrICCPG+3qPHR5BhzYxJhLNerAMauv3314N1Efw2e
        vWkaLuoEFJqrxJgZ4lhdlgN9Ryv91nxP1BqBg2Th/9K95BxLc8xA95JGDzcCFGZXqECi5BK3sdoIC
        xpDIQ3vW6wTRrVNjCSiJJX0Gxn+hQ6aiVBAF7iojklxFTS9ELOEg8BfWFFK0sphGrT5x7Bh1/QQQQ
        TTPfoSxwjZ3zKE5oWYi8KVFKdheCAbhg8jEE0aoQMeAtReHoqqv3DEIj08mWLPOSVLCNOfOflfOUP
        BD31zhFg==;
Received: from [2001:7b8:3:1002::1011] (port=6477)
        by smtp1.smtp.dmz.bit.nl with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <stefan@bit.nl>)
        id 1lUa3X-00055e-1A; Thu, 08 Apr 2021 21:11:07 +0200
Subject: Re: [ceph-users] Nautilus 14.2.19 mon 100% CPU
To:     Robert LeBlanc <robert@leblancnet.us>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@ceph.io>
References: <CAANLjFpjRLtV+GR4WV15iXXCvkig6tJAr_G=_bZpZ=jKnYfvTQ@mail.gmail.com>
From:   Stefan Kooman <stefan@bit.nl>
Message-ID: <68fa3e03-55bd-c9aa-b19a-7cbe44af704e@bit.nl>
Date:   Thu, 8 Apr 2021 21:11:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CAANLjFpjRLtV+GR4WV15iXXCvkig6tJAr_G=_bZpZ=jKnYfvTQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 4/8/21 6:22 PM, Robert LeBlanc wrote:
> I upgraded our Luminous cluster to Nautilus a couple of weeks ago and 
> converted the last batch of FileStore OSDs to BlueStore about 36 hours 
> ago. Yesterday our monitor cluster went nuts and started constantly 
> calling elections because monitor nodes were at 100% and wouldn't 
> respond to heartbeats. I reduced the monitor cluster to one to prevent 
> the constant elections and that let the system limp along until the 
> backfills finished. There are large amounts of time where ceph commands 
> hang with the CPU is at 100%, when the CPU drops I see a lot of work 
> getting done in the monitor logs which stops as soon as the CPU is at 
> 100% again.


Try reducing mon_sync_max_payload_size=4096. I have seen Frank Schilder 
advise this several times because of monitor issues. Also recently for a 
cluster that got upgraded from Luminous -> Mimic -> Nautilus.

Worth a shot.

Otherwise I'll try to look in depth and see if I can come up with 
something smart (for now I need to go catch some sleep).

Gr. Stefan
