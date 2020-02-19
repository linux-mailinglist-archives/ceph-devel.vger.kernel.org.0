Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E9A163B27
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Feb 2020 04:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgBSDZy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Feb 2020 22:25:54 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24270 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726446AbgBSDZy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 18 Feb 2020 22:25:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582082752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2aExjW7fcrGAtlqrUQaLtP9zzCQUzYyw+jSxpIJsLHk=;
        b=W2zOSXFyzpCKrH2p/yeKmpBOfbt4e0ZKVeALwLgFp36vsZugOHC8yEpCL9ySdW6bzuORAx
        tbFouaZCmHQ1QoN/hTc2kfDftXoRo2e5f75f64X8OR4nfkpnExDKKG0hEIKFzSjLF+Tda+
        60uhIAwNCsCMoT57BNQUvVUpE2CeA8c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-biYzeO_qOW6gopyHzqGwuQ-1; Tue, 18 Feb 2020 22:25:44 -0500
X-MC-Unique: biYzeO_qOW6gopyHzqGwuQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F519107ACC4;
        Wed, 19 Feb 2020 03:25:43 +0000 (UTC)
Received: from [10.72.12.94] (ovpn-12-94.pek2.redhat.com [10.72.12.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A19D719757;
        Wed, 19 Feb 2020 03:25:35 +0000 (UTC)
Subject: Re: [PATCH] ceph: add halt mount option support
To:     Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>
Cc:     Sage Weil <sage@redhat.com>, "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20200216064945.61726-1-xiubli@redhat.com>
 <78ff80dd12d497be7a6606a60973f7e2d864e910.camel@kernel.org>
 <36e1f3a9-1688-9eb0-27d7-351a12bca85a@redhat.com>
 <4a4cfe2a5fc1de6f73fa3f557921c1ad5802add6.camel@kernel.org>
 <CAOi1vP_yGJGqkY+QLdQoruJrS3gawEC-_NqDnpucCWfXOHL-aQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <0d72bb98-f306-75de-f0db-60cf315b5ce4@redhat.com>
Date:   Wed, 19 Feb 2020 11:25:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <CAOi1vP_yGJGqkY+QLdQoruJrS3gawEC-_NqDnpucCWfXOHL-aQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/18 22:59, Ilya Dryomov wrote:
> On Tue, Feb 18, 2020 at 1:01 PM Jeff Layton <jlayton@kernel.org> wrote:
>> On Tue, 2020-02-18 at 15:19 +0800, Xiubo Li wrote:
>>> On 2020/2/17 21:04, Jeff Layton wrote:
>>>> On Sun, 2020-02-16 at 01:49 -0500, xiubli@redhat.com wrote:
>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>
>>>>> This will simulate pulling the power cable situation, which will
>>>>> do:
>>>>>
>>>>> - abort all the inflight osd/mds requests and fail them with -EIO.
>>>>> - reject any new coming osd/mds requests with -EIO.
>>>>> - close all the mds connections directly without doing any clean up
>>>>>     and disable mds sessions recovery routine.
>>>>> - close all the osd connections directly without doing any clean up.
>>>>> - set the msgr as stopped.
>>>>>
>>>>> URL: https://tracker.ceph.com/issues/44044
>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> There is no explanation of how to actually _use_ this feature? I assume
>>>> you have to remount the fs with "-o remount,halt" ? Is it possible to
>>>> reenable the mount as well?  If not, why keep the mount around? Maybe we
>>>> should consider wiring this in to a new umount2() flag instead?
>>>>
>>>> This needs much better documentation.
>>>>
>>>> In the past, I've generally done this using iptables. Granted that that
>>>> is difficult with a clustered fs like ceph (given that you potentially
>>>> have to set rules for a lot of addresses), but I wonder whether a scheme
>>>> like that might be more viable in the long run.
>>>>
>>> How about fulfilling the DROP iptable rules in libceph ? Could you
>>> foresee any problem ? This seems the one approach could simulate pulling
>>> the power cable.
>>>
>> Yeah, I've mostly done this using DROP rules when I needed to test things.
>> But, I think I was probably just guilty of speculating out loud here.
> I'm not sure what exactly Xiubo meant by "fulfilling" iptables rules
> in libceph, but I will say that any kind of iptables manipulation from
> within libceph is probably out of the question.

Sorry for confusing here.

I meant in libceph add some helpers to enable/disable dropping the any 
new coming packet on the floor without responding anything to the ceph 
cluster for a specified session.


>
>> I think doing this by just closing down the sockets is probably fine. I
>> wouldn't pursue anything relating to to iptables here, unless we have
>> some larger reason to go that route.
> IMO investing into a set of iptables and tc helpers for teuthology
> makes a _lot_ of sense.  It isn't exactly the same as a cable pull,
> but it's probably the next best thing.  First, it will be external to
> the system under test.  Second, it can be made selective -- you can
> cut a single session or all of them, simulate packet loss and latency
> issues, etc.  Third, it can be used for recovery and failover/fencing
> testing -- what happens when these packets get delivered two minutes
> later?  None of this is possible with something that just attempts to
> wedge the mount and acts as a point of no return.

Yeah, cool and this is what the tracker#44044 intends to.

Thanks
BRs
Xiubo
> Thanks,
>
>                  Ilya
>

