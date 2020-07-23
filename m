Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E90422A4A9
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Jul 2020 03:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387436AbgGWBjC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Jul 2020 21:39:02 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:38086 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728914AbgGWBjC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 22 Jul 2020 21:39:02 -0400
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 26FAA2475C9651CB9133;
        Thu, 23 Jul 2020 09:38:52 +0800 (CST)
Received: from dggeme716-chm.china.huawei.com (10.1.199.112) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Thu, 23 Jul 2020 09:38:50 +0800
Received: from [10.174.177.240] (10.174.177.240) by
 dggeme716-chm.china.huawei.com (10.1.199.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Thu, 23 Jul 2020 09:38:50 +0800
Subject: Re: [PATCH V2] fs:ceph: Remove unused variables in
 ceph_mdsmap_decode()
To:     Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>
CC:     Ceph Development <ceph-devel@vger.kernel.org>
References: <20200722134604.3026-1-jiayang5@huawei.com>
 <CAOi1vP9kMKVTr4K0WzEpr1cjvguuH-gOy8vnOrMm3ELdiBfk_A@mail.gmail.com>
 <a2264c76c59e6bcb39acc7704fb169856d28f7b4.camel@kernel.org>
 <CAOi1vP9avh+h0d7vqLeLMfojzN8nWVk9OrnBZwUppMOQpDDm1w@mail.gmail.com>
From:   Jia Yang <jiayang5@huawei.com>
Message-ID: <a7d2b6fd-adad-efe2-bb65-0a6a3f6f4ec5@huawei.com>
Date:   Thu, 23 Jul 2020 09:38:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP9avh+h0d7vqLeLMfojzN8nWVk9OrnBZwUppMOQpDDm1w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.240]
X-ClientProxiedBy: dggeme704-chm.china.huawei.com (10.1.199.100) To
 dggeme716-chm.china.huawei.com (10.1.199.112)
X-CFilter-Loop: Reflected
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/7/23 0:23, Ilya Dryomov wrote:
> On Wed, Jul 22, 2020 at 5:59 PM Jeff Layton <jlayton@kernel.org> wrote:
>>
>> On Wed, 2020-07-22 at 15:53 +0200, Ilya Dryomov wrote:
>>> On Wed, Jul 22, 2020 at 3:39 PM Jia Yang <jiayang5@huawei.com> wrote:
>>>> Fix build warnings:
>>>>
>>>> fs/ceph/mdsmap.c: In function ‘ceph_mdsmap_decode’:
>>>> fs/ceph/mdsmap.c:192:7: warning:
>>>> variable ‘info_cv’ set but not used [-Wunused-but-set-variable]
>>>> fs/ceph/mdsmap.c:177:7: warning:
>>>> variable ‘state_seq’ set but not used [-Wunused-but-set-variable]
>>>> fs/ceph/mdsmap.c:123:15: warning:
>>>> variable ‘mdsmap_cv’ set but not used [-Wunused-but-set-variable]
>>>>
>>>> Use ceph_decode_skip_* instead of ceph_decode_*, because p is
>>>> increased in ceph_decode_*.
>>>>
>>>> Signed-off-by: Jia Yang <jiayang5@huawei.com>
>>>> ---
>>>>  fs/ceph/mdsmap.c | 10 ++++------
>>>>  1 file changed, 4 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
>>>> index 889627817e52..7455ba83822a 100644
>>>> --- a/fs/ceph/mdsmap.c
>>>> +++ b/fs/ceph/mdsmap.c
>>>> @@ -120,7 +120,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>>>>         const void *start = *p;
>>>>         int i, j, n;
>>>>         int err;
>>>> -       u8 mdsmap_v, mdsmap_cv;
>>>> +       u8 mdsmap_v;
>>>>         u16 mdsmap_ev;
>>>>
>>>>         m = kzalloc(sizeof(*m), GFP_NOFS);
>>>> @@ -129,7 +129,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>>>>
>>>>         ceph_decode_need(p, end, 1 + 1, bad);
>>>>         mdsmap_v = ceph_decode_8(p);
>>>> -       mdsmap_cv = ceph_decode_8(p);
>>>> +       ceph_decode_skip_8(p, end, bad);
>>>
>>> Hi Jia,
>>>
>>> The bounds are already checked in ceph_decode_need(), so using
>>> ceph_decode_skip_*() is unnecessary.  Just increment the position
>>> with *p += 1, staying consistent with ceph_decode_8(), which does
>>> not bounds check.
>>>
>>
>> I suggested using ceph_decode_skip_*, mostly just because it's more
>> self-documenting and I didn't think it that significant an overhead.
>> Just incrementing the pointer will also work too, of course.
> 
> Either is fine (the overhead is negligible), but I prefer to be
> consistent: either ceph_decode_need() + unsafe variants or safe
> variants (i.e. ceph_decode_*_safe / ceph_decode_skip_*).
> 
>>
>> While you're doing that though, please also make note of what would have
>> been decoded there too. So in this case, something like this is what I'd
>> suggest:
>>
>>         *p += 1;        /* mdsmap_cv */
>>

These comments are understandable and useful. I will also use it.

Thanks a lot.

>> These sorts of comments are helpful later, esp. with a protocol like
>> ceph that continually has fields being deprecated.
> 
> Yup, definitely useful and done in many other places.
> 
> Thanks,
> 
>                 Ilya
> .
> 
