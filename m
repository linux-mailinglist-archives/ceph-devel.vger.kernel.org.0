Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5FC1B6A2
	for <lists+ceph-devel@lfdr.de>; Mon, 13 May 2019 15:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729365AbfEMNET (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 May 2019 09:04:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59104 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727953AbfEMNET (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 13 May 2019 09:04:19 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8DAAA3084288;
        Mon, 13 May 2019 13:04:18 +0000 (UTC)
Received: from [10.72.12.50] (ovpn-12-50.pek2.redhat.com [10.72.12.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A6C618A47;
        Mon, 13 May 2019 13:04:11 +0000 (UTC)
Subject: Re: [PATCH 4/5] ceph: fix improper use of smp_mb__before_atomic()
To:     Andrea Parri <andrea.parri@amarulasolutions.com>,
        "Yan, Zheng" <ukernel@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <1556568902-12464-1-git-send-email-andrea.parri@amarulasolutions.com>
 <1556568902-12464-5-git-send-email-andrea.parri@amarulasolutions.com>
 <20190430082332.GB2677@hirez.programming.kicks-ass.net>
 <CAAM7YA=YOM79GJK8b7OOQbzT_-sYRD2UFHYithY7Li1yQt5Hog@mail.gmail.com>
 <20190509205452.GA4359@andrea>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <6956e700-ef56-7f20-4e6c-3ad86c9fd89e@redhat.com>
Date:   Mon, 13 May 2019 21:04:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190509205452.GA4359@andrea>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Mon, 13 May 2019 13:04:19 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 5/10/19 4:55 AM, Andrea Parri wrote:
> On Tue, Apr 30, 2019 at 05:08:43PM +0800, Yan, Zheng wrote:
>> On Tue, Apr 30, 2019 at 4:26 PM Peter Zijlstra <peterz@infradead.org> wrote:
>>>
>>> On Mon, Apr 29, 2019 at 10:15:00PM +0200, Andrea Parri wrote:
>>>> This barrier only applies to the read-modify-write operations; in
>>>> particular, it does not apply to the atomic64_set() primitive.
>>>>
>>>> Replace the barrier with an smp_mb().
>>>>
>>>
>>>> @@ -541,7 +541,7 @@ static inline void __ceph_dir_set_complete(struct ceph_inode_info *ci,
>>>>                                           long long release_count,
>>>>                                           long long ordered_count)
>>>>   {
>>>> -     smp_mb__before_atomic();
>>>
>>> same
>>>          /*
>>>           * XXX: the comment that explain this barrier goes here.
>>>           */
>>>
>>
>> makes sure operations that setup readdir cache (update page cache and
>> i_size) are strongly ordered with following atomic64_set.
> 
> Thanks for the suggestion, Yan.
> 
> To be clear: would you like me to integrate your comment and resend?
> any other suggestions?
> 

Yes, please

Regards
Yan, Zheng

> Thanx,
>    Andrea
> 
> 
>>
>>>> +     smp_mb();
>>>
>>>>        atomic64_set(&ci->i_complete_seq[0], release_count);
>>>>        atomic64_set(&ci->i_complete_seq[1], ordered_count);
>>>>   }
>>>> --
>>>> 2.7.4
>>>>

