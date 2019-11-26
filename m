Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE35B109DEB
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Nov 2019 13:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbfKZM1r (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Nov 2019 07:27:47 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60865 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727408AbfKZM1r (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 26 Nov 2019 07:27:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574771266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8lfD2SDCmfAxTpc5kc18Wui0u5bwuQDSN923sxKLj4Q=;
        b=Gd4ps8JIyWa7S8c6laAHkgKSOeij7jD/gFGfyt0qG698pfxuKntLc9xGjnRX0H4tlRnKJN
        C1xTD4CKOOl5BijXWLcUru2fs4X6zDmRKS5hgKwHFfP+HNZ7AB1if2a/jds0uZSZNS05IC
        rcozr/J4HdBAD3D8nm6Iw3Q7WUAL9gY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-1fo76IM-Nt2jvx2FGrAxog-1; Tue, 26 Nov 2019 07:27:42 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C23B01007293;
        Tue, 26 Nov 2019 12:27:41 +0000 (UTC)
Received: from [10.72.12.66] (ovpn-12-66.pek2.redhat.com [10.72.12.66])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D08A25C1D8;
        Tue, 26 Nov 2019 12:27:36 +0000 (UTC)
Subject: Re: [PATCH] ceph: trigger the reclaim work once there has enough
 pending caps
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <20191126085114.40326-1-xiubli@redhat.com>
 <CAAM7YA=SAY-DQ5iUB-837=eC-ERV46_1_6Zi4SLNdD13_x4U4A@mail.gmail.com>
 <b0714ccd-4844-4b3e-24d4-d75e10bb6b08@redhat.com>
 <62d6459b-f227-64c9-482b-80148bdea696@redhat.com>
 <f215a5ce-f71a-4811-3650-5d62ec00262d@redhat.com>
 <CAAM7YAnRwKtMKH2=jnaLZovd1+t1pAx1qf0BceUYRS-Mv385VQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <8bfca8cb-9191-2b8b-bde2-8ca57d3b84b9@redhat.com>
Date:   Tue, 26 Nov 2019 20:27:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <CAAM7YAnRwKtMKH2=jnaLZovd1+t1pAx1qf0BceUYRS-Mv385VQ@mail.gmail.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 1fo76IM-Nt2jvx2FGrAxog-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/11/26 20:24, Yan, Zheng wrote:
> On Tue, Nov 26, 2019 at 7:25 PM Xiubo Li <xiubli@redhat.com> wrote:
>> On 2019/11/26 19:03, Yan, Zheng wrote:
>>> On 11/26/19 6:01 PM, Xiubo Li wrote:
>>>> On 2019/11/26 17:49, Yan, Zheng wrote:
>>>>> On Tue, Nov 26, 2019 at 4:57 PM <xiubli@redhat.com> wrote:
>>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>>
>>>>>> The nr in ceph_reclaim_caps_nr() is very possibly larger than 1,
>>>>>> so we may miss it and the reclaim work couldn't triggered as expected.
>>>>>>
>>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>>> ---
>>>>>>    fs/ceph/mds_client.c | 2 +-
>>>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>>>> index 08b70b5ee05e..547ffe16f91c 100644
>>>>>> --- a/fs/ceph/mds_client.c
>>>>>> +++ b/fs/ceph/mds_client.c
>>>>>> @@ -2020,7 +2020,7 @@ void ceph_reclaim_caps_nr(struct
>>>>>> ceph_mds_client *mdsc, int nr)
>>>>>>           if (!nr)
>>>>>>                   return;
>>>>>>           val = atomic_add_return(nr, &mdsc->cap_reclaim_pending);
>>>>>> -       if (!(val % CEPH_CAPS_PER_RELEASE)) {
>>>>>> +       if (val / CEPH_CAPS_PER_RELEASE) {
>>>>>> atomic_set(&mdsc->cap_reclaim_pending, 0);
>>>>>>                   ceph_queue_cap_reclaim_work(mdsc);
>>>>>>           }
>>>>> this will call ceph_queue_cap_reclaim_work too frequently
>>>> No it won't, the '/' here equals to '>=' and then the
>>>> "mdsc->cap_reclaim_pending" will be reset and it will increase from 0
>>>> again.
>>>>
>>>> It will make sure that only when "mdsc->cap_reclaim_pending >=
>>>> CEPH_CAPS_PER_RELEASE" will call the work queue.
>>> Work does not get executed immediately. call
>>> ceph_queue_cap_reclaim_work() when val == CEPH_CAPS_PER_RELEASE is
>>> enough. There is no point to call it too frequently
>>>
>>>
>> Yeah, it true and I am okay with this. Just going through the session
>> release related code, and saw the "nr" parameter will be "ctx->used" in
>> ceph_reclaim_caps_nr(mdsc, ctx->used), and in case there has many
>> sessions with tremendous amount of caps. In corner case that we may
>> always miss the condition that the "val == CEPH_CAPS_PER_RELEASE" here.
>>
> good catch. But the test should be something like
>
> "if ((val % CEPH_CAPS_PER_RELEASE) < nr)"

Sure, this looks a bit more graceful.

Will fix it.

Thanks Yan

BRs


>> IMO, it wants to fire the work queue once "val >=
>> CEPH_CAPS_PER_RELEASE", but it is not working like this, the val may
>> just skip it without doing any thing.
>>
>> Thanks
>>
>>
>>>>>> --
>>>>>> 2.21.0
>>>>>>

