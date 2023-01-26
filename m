Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E6967D45F
	for <lists+ceph-devel@lfdr.de>; Thu, 26 Jan 2023 19:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbjAZSjJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 Jan 2023 13:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbjAZSjH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 26 Jan 2023 13:39:07 -0500
X-Greylist: delayed 1444 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 26 Jan 2023 10:38:56 PST
Received: from qproxy6-pub.mail.unifiedlayer.com (qproxy6-pub.mail.unifiedlayer.com [69.89.23.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C2C3EFC6
        for <ceph-devel@vger.kernel.org>; Thu, 26 Jan 2023 10:38:56 -0800 (PST)
Received: from progateway7-pub.mail.pro1.eigbox.com (unknown [67.222.38.55])
        by qproxy6.mail.unifiedlayer.com (Postfix) with ESMTP id DE4338028E5C
        for <ceph-devel@vger.kernel.org>; Thu, 26 Jan 2023 18:14:46 +0000 (UTC)
Received: from cmgw14.mail.unifiedlayer.com (unknown [10.0.90.129])
        by progateway7.mail.pro1.eigbox.com (Postfix) with ESMTP id 957C410048181
        for <ceph-devel@vger.kernel.org>; Thu, 26 Jan 2023 18:14:28 +0000 (UTC)
Received: from host2059.hostmonster.com ([67.20.112.233])
        by cmsmtp with ESMTP
        id L6lYp0EZKiJ4bL6lYp3avg; Thu, 26 Jan 2023 18:14:28 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=NNEQR22g c=1 sm=1 tr=0 ts=63d2c304
 a=5v2YoY0vS1lTYyFvyOB9ag==:117 a=5v2YoY0vS1lTYyFvyOB9ag==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=RvmDmJFTN0MA:10:nop_rcvd_month_year
 a=Xvffn61C-bAA:10:endurance_base64_authed_username_1 a=20KFwNOVAAAA:8
 a=l_JCGrN5Psr9EYzUQRwA:9 a=QEXdDO2ut3YA:10:nop_charset_2
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=petasan.org
        ; s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2taIIDZ54+p5Urd7tTXVVlacmxUtcfo/PbhCQ37QOV8=; b=Vi48BslfJsK+i29O6Z5Qi3QX+7
        /D0TvArUqX3mgZoxB7RxlqD3BIOSE3bRzL3OdRVaEUq/4MXkjiRIGibOHZhZn5PpHxSXsUtN2PqKh
        m5w6wv6bLhsq9cjPsi0Q3eL9LEKryKPX1bMinGWN/n+3UxTRWIIysHUUAFJeXZyLIYRZnjhNIpfa3
        qUGwcRgeYVnOPRqk+Q4UxW8rAZJNZo0yPmhjHCC6QB4HCqZOj8cAS4AQImG7F06xEtvJXdHl87ZMs
        zqIWBlKYrMLMRalZwnEkphUehuWmXXAlA4XfSxJHAxgF71Yacd7WntxHqJLgqKxihFPp4AzY93sf8
        wJj5Jf3Q==;
Received: from [196.132.103.133] (port=18303 helo=[10.0.2.15])
        by host2059.hostmonster.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <mmokhtar@petasan.org>)
        id 1pL6lX-000DnM-CU;
        Thu, 26 Jan 2023 11:14:27 -0700
Message-ID: <b7021070-0d40-362c-51ab-666922c153a6@petasan.org>
Date:   Thu, 26 Jan 2023 20:14:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: rbd kernel block driver memory usage
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>,
        ceph-devel@vger.kernel.org, vromanso@redhat.com, kwolf@redhat.com,
        mimehta@redhat.com, acardace@redhat.com
References: <Y9FffDxl2sa9762M@fedora>
 <CAOi1vP8+nQMsGPK-SW-FG4C2HAgp76dEHeTEwQ2xxi2oJLH1aA@mail.gmail.com>
 <Y9KP7EX9+Ub/StL/@fedora>
From:   Maged Mokhtar <mmokhtar@petasan.org>
In-Reply-To: <Y9KP7EX9+Ub/StL/@fedora>
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
X-Exim-ID: 1pL6lX-000DnM-CU
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([10.0.2.15]) [196.132.103.133]:18303
X-Source-Auth: mmokhtar@petasan.org
X-Email-Count: 5
X-Source-Cap: cGV0YXNhbm87cGV0YXNhbm87aG9zdDIwNTkuaG9zdG1vbnN0ZXIuY29t
X-Local-Domain: yes
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

in case of object map which the driver loads, takes 2 bits per 4 MB of 
image size. 16 TB image requires 1 MB of memory.

>> I was trying to get a sense ofwhether to look deeper into the rbd driver in a OOM kill scenario.

If you are looking into OOM, maybe look into lowering queue_depth which you can specify when you map the image. Technically it belongs to the block layer queue rather than the rbd driver itself, If you write 4MB block size and your queue_depth is 1000, you need 4GB memory for inflight data for that single image, if you have many images it could add up.

/maged


On 26/01/2023 16:36, Stefan Hajnoczi wrote:
> On Thu, Jan 26, 2023 at 02:48:27PM +0100, Ilya Dryomov wrote:
>> On Wed, Jan 25, 2023 at 5:57 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>>> Hi,
>>> What sort of memory usage is expected under heavy I/O to an rbd block
>>> device with O_DIRECT?
>>>
>>> For example:
>>> - Page cache: none (O_DIRECT)
>>> - Socket snd/rcv buffers: yes
>> Hi Stefan,
>>
>> There is a socket open to each OSD (object storage daemon).  A Ceph
>> cluster may have tens, hundreds or even thousands of OSDs (although the
>> latter is rare -- usually folks end up with several smaller clusters
>> instead a single large cluster).  Under heavy random I/O and given
>> a big enough RBD image, it's reasonable to assume that most if not all
>> OSDs would be involved and therefore their sessions would be active.
>>
>> A thing to note is that, by default, OSD sessions are shared between
>> RBD devices.  So as long as all RBD images that are mapped on a node
>> belong to the same cluster, the same set of sockets would be used.
>>
>> Idle OSD sockets get closed after 60 seconds of inactivity.
>>
>>
>>> - Internal rbd buffers?
>>>
>>> I am trying to understand how similar Linux rbd block devices behave
>>> compared to local block device memory consumption (like NVMe PCI).
>> RBD doesn't do any internal buffering.  Data is read from/written to
>> the wire directly to/from BIO pages.  The only exception to that is the
>> "secure" mode -- built-in encryption for Ceph on-the-wire protocol.  In
>> that case the data is buffered, partly because RBD obviously can't mess
>> with plaintext data in the BIO and partly because the Linux kernel
>> crypto API isn't flexible enough.
>>
>> There is some memory overhead associated with each I/O (OSD request
>> metadata encoding, mostly).  It's surely larger than in the NVMe PCI
>> case.  I don't have the exact number but it should be less than 4K per
>> I/O in almost all cases.  This memory is coming out of private SLAB
>> caches and could be reclaimable had we set SLAB_RECLAIM_ACCOUNT on
>> them.
> Thanks, this information is very useful. I was trying to get a sense of
> whether to look deeper into the rbd driver in a OOM kill scenario.
>
> Stefan

