Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B451127ADC
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Dec 2019 13:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbfLTMSH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 20 Dec 2019 07:18:07 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25223 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727197AbfLTMSH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 20 Dec 2019 07:18:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576844286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NQuN7afK6ORyfRmAkCpJNaDwbAHawweNFqbGtZDBKgo=;
        b=d1mkKSdg7R6vnCI+8M7NRhxYWUVwdnByhoYpKE/57jvG3XGV+2dwsAT4v2htz1XcA6V4Mj
        Z2o5RCRVaVocDEK4/9agRagJmjGxE9TqVOFxQOYCuxGvTZNnoWgwi88XQ/XjjH3iC7sP+9
        dnZJkr2sEzd9Bjxughmn+aRqaBphepQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-GWu_jj7SPkSiFa54D9vK-w-1; Fri, 20 Dec 2019 07:18:05 -0500
X-MC-Unique: GWu_jj7SPkSiFa54D9vK-w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F767800D48;
        Fri, 20 Dec 2019 12:18:04 +0000 (UTC)
Received: from [10.72.12.19] (ovpn-12-19.pek2.redhat.com [10.72.12.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B43141001B07;
        Fri, 20 Dec 2019 12:17:59 +0000 (UTC)
Subject: Re: [PATCH v3] ceph: rename get_session and switch to use
 ceph_get_mds_session
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     Sage Weil <sage@redhat.com>, "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20191220004409.12793-1-xiubli@redhat.com>
 <CAOi1vP85em7ase08xywaOTfaxrsMq7Y9yeYcxcgKz8QH=oxOGQ@mail.gmail.com>
 <ca915587-290a-fb10-2fd6-8a5d5bbb4fc0@redhat.com>
 <CAOi1vP-idYF2K-ENT2o6sJko-0b+EzbLF70ipqp3m65uT+pXYw@mail.gmail.com>
 <fb235fdb3f49ceea1397e09cea992d9cdd833373.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <851c1082-996b-0a0f-1071-53432b22d08c@redhat.com>
Date:   Fri, 20 Dec 2019 20:17:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <fb235fdb3f49ceea1397e09cea992d9cdd833373.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/12/20 19:09, Jeff Layton wrote:
> On Fri, 2019-12-20 at 11:46 +0100, Ilya Dryomov wrote:
>> On Fri, Dec 20, 2019 at 10:21 AM Xiubo Li <xiubli@redhat.com> wrote:
>>> On 2019/12/20 17:11, Ilya Dryomov wrote:
>>>> On Fri, Dec 20, 2019 at 1:44 AM <xiubli@redhat.com> wrote:
>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>
>>>>> Just in case the session's refcount reach 0 and is releasing, and
>>>>> if we get the session without checking it, we may encounter kernel
>>>>> crash.
>>>>>
>>>>> Rename get_session to ceph_get_mds_session and make it global.
>>>>>
>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>> ---
>>>>>
>>>>> Changed in V3:
>>>>> - Clean all the local commit and pull it and rebased again, it is based
>>>>>     the following commit:
>>>>>
>>>>>     commit 3a1deab1d5c1bb693c268cc9b717c69554c3ca5e
>>>>>     Author: Xiubo Li <xiubli@redhat.com>
>>>>>     Date:   Wed Dec 4 06:57:39 2019 -0500
>>>>>
>>>>>         ceph: add possible_max_rank and make the code more readable
>>>> Hi Xiubo,
>>>>
>>>> The base is correct, but the patch still appears to have been
>>>> corrupted, either by your email client or somewhere in transit.
>>> Ah, I have no idea of this now, I was doing the following command to
>>> post it:
>>>
>>> # git send-email --smtp-server=... --to=...
>> Hrm, I've looked through my archives and the last non-mangled patch
>> I see from you is "[PATCH RFC] libceph: remove the useless monc check"
>> dated Oct 15.  If you are using the same send-email command as before
>> and haven't changed anything on your end, it's probably one of the
>> intermediate servers...
>>
>>> And my git version is:
>>>
>>> # git --version
>>> git version 2.21.0
>>>
>>> I attached it or should I post it again ?
>> You attached the old version ;)  It's not mangled, but it doesn't
>> apply.
>>
>> Jeff, are you getting Xiubo's patches intact?
>>
> Yep. This patch applied just fine using git-am. Patch looks reasonable
> to me -- I like guarding against a 0->1 transition on a refcount.  I'll
> go ahead and push it to testing.

Cool.

Thanks.


> Thanks,


