Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AADB746FD1
	for <lists+ceph-devel@lfdr.de>; Sat, 15 Jun 2019 13:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfFOLmx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 15 Jun 2019 07:42:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56044 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbfFOLmx (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 15 Jun 2019 07:42:53 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 512043082134;
        Sat, 15 Jun 2019 11:42:52 +0000 (UTC)
Received: from [10.72.12.43] (ovpn-12-43.pek2.redhat.com [10.72.12.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B2985C269;
        Sat, 15 Jun 2019 11:42:46 +0000 (UTC)
Subject: Re: [PATCH 02/16] libceph: add ceph_decode_entity_addr
To:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <ukernel@gmail.com>
Cc:     Ilya Dryomov <idryomov@redhat.com>, Sage Weil <sage@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <20190607153816.12918-1-jlayton@kernel.org>
 <20190607153816.12918-3-jlayton@kernel.org>
 <CAAM7YAnVF_+m-Ege6u5mS9wcT_ttJZrvRuWh7F3-49Yxd98kEA@mail.gmail.com>
 <c6c5d94ce2526a3885050eb2395f2c4efa2a9c17.camel@kernel.org>
 <CAAM7YAmSWzumRthVmpW1FKK+0XBrNsrFNU2GvKDytOc1hHabjw@mail.gmail.com>
 <06392cf35efc9ebd6fc12dd44d644e92c693af4a.camel@kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <4ad912cb-9aa3-cca6-c6d7-9e0858b065af@redhat.com>
Date:   Sat, 15 Jun 2019 19:42:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <06392cf35efc9ebd6fc12dd44d644e92c693af4a.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Sat, 15 Jun 2019 11:42:52 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 6/15/19 6:57 PM, Jeff Layton wrote:
> On Sat, 2019-06-15 at 10:25 +0800, Yan, Zheng wrote:
>> On Fri, Jun 14, 2019 at 9:13 PM Jeff Layton <jlayton@kernel.org> wrote:
>>> On Fri, 2019-06-14 at 16:05 +0800, Yan, Zheng wrote:
>>>> On Fri, Jun 7, 2019 at 11:38 PM Jeff Layton <jlayton@kernel.org> wrote:
>>>>> Add a way to decode an entity_addr_t. Once CEPH_FEATURE_MSG_ADDR2 is
>>>>> enabled, the server daemons will start encoding entity_addr_t
>>>>> differently.
>>>>>
>>>>> Add a new helper function that can handle either format.
>>>>>
>>>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>>>> ---
>>>>>   include/linux/ceph/decode.h |  2 +
>>>>>   net/ceph/Makefile           |  2 +-
>>>>>   net/ceph/decode.c           | 75 +++++++++++++++++++++++++++++++++++++
>>>>>   3 files changed, 78 insertions(+), 1 deletion(-)
>>>>>   create mode 100644 net/ceph/decode.c
>>>>>
>>>>> diff --git a/include/linux/ceph/decode.h b/include/linux/ceph/decode.h
>>>>> index a6c2a48d42e0..1c0a665bfc03 100644
>>>>> --- a/include/linux/ceph/decode.h
>>>>> +++ b/include/linux/ceph/decode.h
>>>>> @@ -230,6 +230,8 @@ static inline void ceph_decode_addr(struct ceph_entity_addr *a)
>>>>>          WARN_ON(a->in_addr.ss_family == 512);
>>>>>   }
>>>>>
>>>>> +extern int ceph_decode_entity_addr(void **p, void *end,
>>>>> +                                  struct ceph_entity_addr *addr);
>>>>>   /*
>>>>>    * encoders
>>>>>    */
>>>>> diff --git a/net/ceph/Makefile b/net/ceph/Makefile
>>>>> index db09defe27d0..59d0ba2072de 100644
>>>>> --- a/net/ceph/Makefile
>>>>> +++ b/net/ceph/Makefile
>>>>> @@ -5,7 +5,7 @@
>>>>>   obj-$(CONFIG_CEPH_LIB) += libceph.o
>>>>>
>>>>>   libceph-y := ceph_common.o messenger.o msgpool.o buffer.o pagelist.o \
>>>>> -       mon_client.o \
>>>>> +       mon_client.o decode.o \
>>>>>          cls_lock_client.o \
>>>>>          osd_client.o osdmap.o crush/crush.o crush/mapper.o crush/hash.o \
>>>>>          striper.o \
>>>>> diff --git a/net/ceph/decode.c b/net/ceph/decode.c
>>>>> new file mode 100644
>>>>> index 000000000000..27edf5d341ec
>>>>> --- /dev/null
>>>>> +++ b/net/ceph/decode.c
>>>>> @@ -0,0 +1,75 @@
>>>>> +// SPDX-License-Identifier: GPL-2.0
>>>>> +
>>>>> +#include <linux/ceph/decode.h>
>>>>> +
>>>>> +int
>>>>> +ceph_decode_entity_addr(void **p, void *end, struct ceph_entity_addr *addr)
>>>>> +{
>>>>> +       u8 marker, v, compat;
>>>>
>>>> It's better to use name struct_v, struct_compat
>>>>
>>>>
>>>>> +       u32 len;
>>>>> +
>>>>> +       ceph_decode_8_safe(p, end, marker, bad);
>>>>> +       if (marker == 1) {
>>>>> +               ceph_decode_8_safe(p, end, v, bad);
>>>>> +               ceph_decode_8_safe(p, end, compat, bad);
>>>>> +               if (!v || compat != 1)
>>>>> +                       goto bad;
>>>>> +               /* FIXME: sanity check? */
>>>>> +               ceph_decode_32_safe(p, end, len, bad);
>>>>> +               /* type is __le32, so we must copy into place as-is */
>>>>> +               ceph_decode_copy_safe(p, end, &addr->type,
>>>>> +                                       sizeof(addr->type), bad);
>>>>> +
>>>>> +               /*
>>>>> +                * TYPE_NONE == 0
>>>>> +                * TYPE_LEGACY == 1
>>>>> +                *
>>>>> +                * Clients that don't support ADDR2 always send TYPE_NONE.
>>>>> +                * For now, since all we support is msgr1, just set this to 0
>>>>> +                * when we get a TYPE_LEGACY type.
>>>>> +                */
>>>>> +               if (addr->type == cpu_to_le32(1))
>>>>> +                       addr->type = 0;
>>>>> +       } else if (marker == 0) {
>>>>> +               addr->type = 0;
>>>>> +               /* Skip rest of type field */
>>>>> +               ceph_decode_skip_n(p, end, 3, bad);
>>>>> +       } else {
>>>>
>>>> versioned encoding has forward compatibility.  The code should looks like
>>>>
>>>> if (struct_v == 0) {
>>>>    /* old format */
>>>>    return;
>>>> }
>>>>
>>>> if (struct_compat != 1)
>>>>     goto bad
>>>>
>>>> end = *p + struct_len;
>>>>
>>>> if  (struct_v == 1) {
>>>> ....
>>>> }
>>>>
>>>> if (struct_v == 2) {
>>>> ...
>>>> }
>>>>
>>>> *p = end;
>>>>
>>>>
>>>>
>>>>
>>>>> +               goto bad;
>>>>> +       }
>>>>> +
>>>>> +       ceph_decode_need(p, end, sizeof(addr->nonce), bad);
>>>>> +       ceph_decode_copy(p, &addr->nonce, sizeof(addr->nonce));
>>>>> +
>>>>> +       /* addr length */
>>>>> +       if (marker ==  1) {
>>>>> +               ceph_decode_32_safe(p, end, len, bad);
>>>>> +               if (len > sizeof(addr->in_addr))
>>>>> +                       goto bad;
>>>>> +       } else  {
>>>>> +               len = sizeof(addr->in_addr);
>>>>> +       }
>>>>> +
>>>>> +       memset(&addr->in_addr, 0, sizeof(addr->in_addr));
>>>>> +
>>>>> +       if (len) {
>>>>> +               ceph_decode_need(p, end, len, bad);
>>>>> +               ceph_decode_copy(p, &addr->in_addr, len);
>>>>> +
>>>>> +               /*
>>>>> +                * Fix up sa_family. Legacy encoding sends it in BE, addr2
>>>>> +                * encoding uses LE.
>>>>> +                */
>>>>> +               if (marker == 1)
>>>>> +                       addr->in_addr.ss_family =
>>>>> +                               le16_to_cpu((__force __le16)addr->in_addr.ss_family);
>>>>> +               else
>>>>> +                       addr->in_addr.ss_family =
>>>>> +                               be16_to_cpu((__force __be16)addr->in_addr.ss_family);
>>>>> +       }
>>>>> +       return 0;
>>>>> +bad:
>>>>> +       return -EINVAL;
>>>>> +}
>>>>> +EXPORT_SYMBOL(ceph_decode_entity_addr);
>>>>> +
>>>>> --
>>>>> 2.21.0
>>>
>>> (Dropping dev@ceph.io from cc list since they evidently _really_ don't
>>> want to see kernel patches there)
>>>
>>> Something like this then on top of the original patch?
>>>
>>> SQUASH: address Zheng's comments
>>>
>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>> ---
>>>   net/ceph/decode.c | 21 ++++++++++++---------
>>>   1 file changed, 12 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/net/ceph/decode.c b/net/ceph/decode.c
>>> index 27edf5d341ec..5a008567d018 100644
>>> --- a/net/ceph/decode.c
>>> +++ b/net/ceph/decode.c
>>> @@ -5,18 +5,20 @@
>>>   int
>>>   ceph_decode_entity_addr(void **p, void *end, struct ceph_entity_addr *addr)
>>>   {
>>> -       u8 marker, v, compat;
>>> +       u8 marker, struct_v, struct_compat;
>>>          u32 len;
>>>
>>>          ceph_decode_8_safe(p, end, marker, bad);
>>>          if (marker == 1) {
>>> -               ceph_decode_8_safe(p, end, v, bad);
>>> -               ceph_decode_8_safe(p, end, compat, bad);
>>> -               if (!v || compat != 1)
>>> +               ceph_decode_8_safe(p, end, struct_v, bad);
>>> +               ceph_decode_8_safe(p, end, struct_compat, bad);
>>> +               if (!struct_v || struct_compat != 1)
>>>                          goto bad;
>>> +
>>>                  /* FIXME: sanity check? */
>>>                  ceph_decode_32_safe(p, end, len, bad);
>>> -               /* type is __le32, so we must copy into place as-is */
>>> +
>>> +               /* type is defined as __le32, copy into place as-is */
>>>                  ceph_decode_copy_safe(p, end, &addr->type,
>>>                                          sizeof(addr->type), bad);
>>>
>>> @@ -32,17 +34,18 @@ ceph_decode_entity_addr(void **p, void *end, struct ceph_entity_addr *addr)
>>>                          addr->type = 0;
>>>          } else if (marker == 0) {
>>>                  addr->type = 0;
>>> +               struct_v = 0;
>>> +               struct_compat = 0;
>>>                  /* Skip rest of type field */
>>>                  ceph_decode_skip_n(p, end, 3, bad);
>>>          } else {
>>>                  goto bad;
>>>          }
>>>
>>> -       ceph_decode_need(p, end, sizeof(addr->nonce), bad);
>>> -       ceph_decode_copy(p, &addr->nonce, sizeof(addr->nonce));
>>> +       ceph_decode_copy_safe(p, end, &addr->nonce, sizeof(addr->nonce), bad);
>>>
>>>          /* addr length */
>>> -       if (marker ==  1) {
>>> +       if (struct_v > 0) {
>>>                  ceph_decode_32_safe(p, end, len, bad);
>>>                  if (len > sizeof(addr->in_addr))
>>>                          goto bad;
>>> @@ -60,7 +63,7 @@ ceph_decode_entity_addr(void **p, void *end, struct ceph_entity_addr *addr)
>>>                   * Fix up sa_family. Legacy encoding sends it in BE, addr2
>>>                   * encoding uses LE.
>>>                   */
>>> -               if (marker == 1)
>>> +               if (struct_v > 0)
>>>                          addr->in_addr.ss_family =
>>>                                  le16_to_cpu((__force __le16)addr->in_addr.ss_family);
>>>                  else
>>> --
>>> 2.21.0
>>>
>>>
>>
>> still missing  code that updates (*p) at the very end.
>>
>> if (struct_compat != 1)ENCODE_FINISH
>>    goto bad
>> end = *p + struct_len;
>> ...
>> *p = end;
>>
> 
> Huh? The ceph_decode_* routines update *p as they go. There is no need
> to do anything like what you're suggesting at the end of this function.
> 

Currently there is no need. but it will cause problem if server side 
changes encoding version to 2 or larger. See ENCODE_FINISH in ceph code.

Regards
Yan, Zheng



>> I think It's better to define separate functions for legacy encoding
>> and new format.
> 
> I disagree. That will just mean that we end up duplicating some of this
> code.
> 

