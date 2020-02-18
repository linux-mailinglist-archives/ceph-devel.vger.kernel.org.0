Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66EAC162837
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Feb 2020 15:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgBROcT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Feb 2020 09:32:19 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27044 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726556AbgBROcT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 18 Feb 2020 09:32:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582036337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uUmqz7MMAWuq28CNltcC+AuvW+Ak7Q0I3Xs9bvN6wLg=;
        b=ZN8ppTcUeuxFHweLCoy/U0BPJBh42qOc2aDLh+lOlzlw4rjWx/0MIcZUi7HSwoS3Nvu2lt
        sUsWBPP/KdUXOh5YkprsV+uvXIfP9q2QuJYQHiUDGGLENlNoa0pWB5rxrCC5Sd6pfCzDhx
        BOp+o9Ijv06aA3W7UDtwsWzY19q8tls=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-JIBzqG06M9yOz_NZKpdyCg-1; Tue, 18 Feb 2020 09:32:11 -0500
X-MC-Unique: JIBzqG06M9yOz_NZKpdyCg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35D60802560;
        Tue, 18 Feb 2020 14:32:10 +0000 (UTC)
Received: from [10.72.12.94] (ovpn-12-94.pek2.redhat.com [10.72.12.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BBB8C8AC30;
        Tue, 18 Feb 2020 14:32:04 +0000 (UTC)
Subject: Re: [PATCH] ceph: add halt mount option support
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20200216064945.61726-1-xiubli@redhat.com>
 <78ff80dd12d497be7a6606a60973f7e2d864e910.camel@kernel.org>
 <36e1f3a9-1688-9eb0-27d7-351a12bca85a@redhat.com>
 <4a4cfe2a5fc1de6f73fa3f557921c1ad5802add6.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <ad8663c9-aaf0-84fb-9810-9d27ccdc5fe0@redhat.com>
Date:   Tue, 18 Feb 2020 22:32:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <4a4cfe2a5fc1de6f73fa3f557921c1ad5802add6.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/18 20:01, Jeff Layton wrote:
> On Tue, 2020-02-18 at 15:19 +0800, Xiubo Li wrote:
>> On 2020/2/17 21:04, Jeff Layton wrote:
>>> On Sun, 2020-02-16 at 01:49 -0500, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> This will simulate pulling the power cable situation, which will
>>>> do:
>>>>
>>>> - abort all the inflight osd/mds requests and fail them with -EIO.
>>>> - reject any new coming osd/mds requests with -EIO.
>>>> - close all the mds connections directly without doing any clean up
>>>>     and disable mds sessions recovery routine.
>>>> - close all the osd connections directly without doing any clean up.
>>>> - set the msgr as stopped.
>>>>
>>>> URL: https://tracker.ceph.com/issues/44044
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> There is no explanation of how to actually _use_ this feature? I assume
>>> you have to remount the fs with "-o remount,halt" ? Is it possible to
>>> reenable the mount as well?  If not, why keep the mount around? Maybe we
>>> should consider wiring this in to a new umount2() flag instead?
>>>
>>> This needs much better documentation.
>>>
>>> In the past, I've generally done this using iptables. Granted that that
>>> is difficult with a clustered fs like ceph (given that you potentially
>>> have to set rules for a lot of addresses), but I wonder whether a scheme
>>> like that might be more viable in the long run.
>>>
>> How about fulfilling the DROP iptable rules in libceph ? Could you
>> foresee any problem ? This seems the one approach could simulate pulling
>> the power cable.
>>
> Yeah, I've mostly done this using DROP rules when I needed to test things.
> But, I think I was probably just guilty of speculating out loud here.
>
> I think doing this by just closing down the sockets is probably fine. I
> wouldn't pursue anything relating to to iptables here, unless we have
> some larger reason to go that route.

I have digged into the socket and netfilter code today, to do this in 
kernel space is kind easy.

Let's have a test if closing socket direct could not work well or as 
expected, let's have try that then.

Thanks.

BRs


