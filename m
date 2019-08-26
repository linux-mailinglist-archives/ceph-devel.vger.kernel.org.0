Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBB9B9C774
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Aug 2019 04:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbfHZCyB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 25 Aug 2019 22:54:01 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:18990 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729384AbfHZCyB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 25 Aug 2019 22:54:01 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAB3kWaaSWNdDtx8AQ--.0S2;
        Mon, 26 Aug 2019 10:53:14 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: Re: [PATCH v3 01/15] libceph: introduce
 ceph_extract_encoded_string_kvmalloc
To:     Ilya Dryomov <idryomov@gmail.com>
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
 <1564393377-28949-2-git-send-email-dongsheng.yang@easystack.cn>
 <CAOi1vP8fFzVmKeQAqbk1om8tZ2fFw0xbT=LPSGJbiDsaaeo4xA@mail.gmail.com>
Cc:     Jason Dillaman <jdillama@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Message-ID: <5D63499A.2090301@easystack.cn>
Date:   Mon, 26 Aug 2019 10:53:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP8fFzVmKeQAqbk1om8tZ2fFw0xbT=LPSGJbiDsaaeo4xA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowAB3kWaaSWNdDtx8AQ--.0S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjfUUMa0UUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiSwQdeldp-7FTNAAAs-
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 08/19/2019 03:26 PM, Ilya Dryomov wrote:
> On Mon, Jul 29, 2019 at 11:43 AM Dongsheng Yang
> <dongsheng.yang@easystack.cn>  wrote:
>> When we are going to extract the encoded string, there
>> would be a large string encoded.
>>
>> Especially in the journaling case, if we use the default
>> journal object size, 16M, there could be a 16M string
>> encoded in this object.
>>
>> Signed-off-by: Dongsheng Yang<dongsheng.yang@easystack.cn>
>> ---
>>   include/linux/ceph/decode.h | 21 ++++++++++++++++++---
>>   1 file changed, 18 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/ceph/decode.h b/include/linux/ceph/decode.h
>> index 450384f..555879f 100644
>> --- a/include/linux/ceph/decode.h
>> +++ b/include/linux/ceph/decode.h
>> @@ -104,8 +104,11 @@ static inline bool ceph_has_room(void **p, void *end, size_t n)
>>    *     beyond the "end" pointer provided (-ERANGE)
>>    *   - memory could not be allocated for the result (-ENOMEM)
>>    */
>> -static inline char *ceph_extract_encoded_string(void **p, void *end,
>> -                                               size_t *lenp, gfp_t gfp)
>> +typedef void * (mem_alloc_t)(size_t size, gfp_t flags);
>> +extern void *ceph_kvmalloc(size_t size, gfp_t flags);
>> +static inline char *extract_encoded_string(void **p, void *end,
>> +                                          mem_alloc_t alloc_fn,
>> +                                          size_t *lenp, gfp_t gfp)
>>   {
>>          u32 len;
>>          void *sp = *p;
>> @@ -115,7 +118,7 @@ static inline char *ceph_extract_encoded_string(void **p, void *end,
>>          if (!ceph_has_room(&sp, end, len))
>>                  goto bad;
>>
>> -       buf = kmalloc(len + 1, gfp);
>> +       buf = alloc_fn(len + 1, gfp);
>>          if (!buf)
>>                  return ERR_PTR(-ENOMEM);
>>
>> @@ -133,6 +136,18 @@ static inline char *ceph_extract_encoded_string(void **p, void *end,
>>          return ERR_PTR(-ERANGE);
>>   }
>>
>> +static inline char *ceph_extract_encoded_string(void **p, void *end,
>> +                                               size_t *lenp, gfp_t gfp)
>> +{
>> +       return extract_encoded_string(p, end, kmalloc, lenp, gfp);
>> +}
>> +
>> +static inline char *ceph_extract_encoded_string_kvmalloc(void **p, void *end,
>> +                                                        size_t *lenp, gfp_t gfp)
>> +{
>> +       return extract_encoded_string(p, end, ceph_kvmalloc, lenp, gfp);
>> +}
>> +
>>   /*
>>    * skip helpers
>>    */
> This is only for replaying, right?

This is for journal fetching, which is a part for replaying. But if we 
don't do replay,
we still need to do journal fetching and journal preprocess to know 
whether there is
uncommitted journal.

Thanx
> Thanks,
>
>                  Ilya
>


