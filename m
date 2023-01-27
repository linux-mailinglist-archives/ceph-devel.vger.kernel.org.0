Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A9867E081
	for <lists+ceph-devel@lfdr.de>; Fri, 27 Jan 2023 10:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbjA0JlC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 27 Jan 2023 04:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232529AbjA0JlB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 27 Jan 2023 04:41:01 -0500
Received: from qproxy4-pub.mail.unifiedlayer.com (qproxy4-pub.mail.unifiedlayer.com [66.147.248.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B824198
        for <ceph-devel@vger.kernel.org>; Fri, 27 Jan 2023 01:40:59 -0800 (PST)
Received: from outbound-ss-761.bluehost.com (outbound-ss-761.bluehost.com [74.220.211.250])
        by qproxy4.mail.unifiedlayer.com (Postfix) with ESMTP id 4655C8025BE0
        for <ceph-devel@vger.kernel.org>; Fri, 27 Jan 2023 09:40:58 +0000 (UTC)
Received: from cmgw10.mail.unifiedlayer.com (unknown [10.0.90.125])
        by progateway8.mail.pro1.eigbox.com (Postfix) with ESMTP id E3B2A10047D48
        for <ceph-devel@vger.kernel.org>; Fri, 27 Jan 2023 09:40:56 +0000 (UTC)
Received: from host2059.hostmonster.com ([67.20.112.233])
        by cmsmtp with ESMTP
        id LLE8pFCpKPhg5LLE8puo9N; Fri, 27 Jan 2023 09:40:56 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=fsEZ2H0f c=1 sm=1 tr=0 ts=63d39c28
 a=5v2YoY0vS1lTYyFvyOB9ag==:117 a=5v2YoY0vS1lTYyFvyOB9ag==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=RvmDmJFTN0MA:10:nop_rcvd_month_year
 a=Xvffn61C-bAA:10:endurance_base64_authed_username_1 a=J8I1iqoxje4RNO0_lykA:9
 a=QEXdDO2ut3YA:10:nop_charset_2
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=petasan.org
        ; s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7qbxXEE+0HimvY9dgVejEwP7ZsPibHZuLspEHmAR1C0=; b=bSptdy/TFAn+oqMpQV/WYOKAa6
        qkCByDTXvcvbXPAMz0GP8L7ZDDhdKZf4yGcffNYR6NFeY69e2aTZa5p+MmnVFdoPUY21Hrz9W4K64
        LRj91Qcxiyel1QSmPt7FHkBSssM3/y4wN6I+qF2UH7tnkfmpmpJMxYi/4pswbtglLsdcfIwNZmHHC
        Fm7znXVopxRD1TeXe3n5fzmKloHDyBDb+WlHe8Na9Qr7Xo/XtCm8pYWbUOfr5rp6XueGYWZ04aR3Q
        t5sDl87gmm6zZXn1yWHeL4MKMnB4FriqdJiTAkKKOPXSwVF0/LT4SoZiQwEIAfI3gI6SWY0f30XWh
        LuuJC1kA==;
Received: from [196.132.103.133] (port=29544 helo=[10.0.2.15])
        by host2059.hostmonster.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <mmokhtar@petasan.org>)
        id 1pLLE8-0042Pw-85;
        Fri, 27 Jan 2023 02:40:56 -0700
Message-ID: <635e178e-3ba1-1352-f954-4a258d0dfdc9@petasan.org>
Date:   Fri, 27 Jan 2023 11:40:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: rbd kernel block driver memory usage
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     ceph-devel@vger.kernel.org
References: <Y9FffDxl2sa9762M@fedora>
 <CAOi1vP8+nQMsGPK-SW-FG4C2HAgp76dEHeTEwQ2xxi2oJLH1aA@mail.gmail.com>
 <Y9KP7EX9+Ub/StL/@fedora> <b7021070-0d40-362c-51ab-666922c153a6@petasan.org>
 <Y9L1/fK6M0Co4q9a@fedora>
Content-Language: en-US
From:   Maged Mokhtar <mmokhtar@petasan.org>
In-Reply-To: <Y9L1/fK6M0Co4q9a@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host2059.hostmonster.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - petasan.org
X-BWhitelist: no
X-Source-IP: 196.132.103.133
X-Source-L: No
X-Exim-ID: 1pLLE8-0042Pw-85
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([10.0.2.15]) [196.132.103.133]:29544
X-Source-Auth: mmokhtar@petasan.org
X-Email-Count: 1
X-Source-Cap: cGV0YXNhbm87cGV0YXNhbm87aG9zdDIwNTkuaG9zdG1vbnN0ZXIuY29t
X-Local-Domain: yes
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


another thing that can help OOM cases, avoid using rbd client on same 
host as OSDs. This was a general recommendation aseptically with earlier 
kernels (3.x).


On 26/01/2023 23:51, Stefan Hajnoczi wrote:
> On Thu, Jan 26, 2023 at 08:14:22PM +0200, Maged Mokhtar wrote:
>> in case of object map which the driver loads, takes 2 bits per 4 MB of image
>> size. 16 TB image requires 1 MB of memory.
>>
>>>> I was trying to get a sense ofwhether to look deeper into the rbd driver in a OOM kill scenario.
>> If you are looking into OOM, maybe look into lowering queue_depth which you can specify when you map the image. Technically it belongs to the block layer queue rather than the rbd driver itself, If you write 4MB block size and your queue_depth is 1000, you need 4GB memory for inflight data for that single image, if you have many images it could add up.
> Thanks!
>
> Stefan

