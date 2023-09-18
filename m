Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613867A3F5E
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Sep 2023 04:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236197AbjIRCD2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 17 Sep 2023 22:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237279AbjIRCDX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 17 Sep 2023 22:03:23 -0400
Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F59F11F
        for <ceph-devel@vger.kernel.org>; Sun, 17 Sep 2023 19:03:16 -0700 (PDT)
Received: from eig-obgw-6004a.ext.cloudfilter.net ([10.0.30.197])
        by cmsmtp with ESMTP
        id i12qqra7gbK1Vi3bXqvUqj; Mon, 18 Sep 2023 02:03:15 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with ESMTPS
        id i3bWqysmYqP3vi3bWqqPt7; Mon, 18 Sep 2023 02:03:15 +0000
X-Authority-Analysis: v=2.4 cv=Po6A0iA3 c=1 sm=1 tr=0 ts=6507afe3
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=P7XfKmiOJ4/qXqHZrN7ymg==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=zNV7Rl7Rt7sA:10 a=wYkD_t78qR0A:10 a=NEAV23lmAAAA:8
 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=J1Y8HTJGAAAA:8
 a=1XWaLZrsAAAA:8 a=cm27Pg_UAAAA:8 a=JpHVVEXmboDBK7eC_9wA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=y1Q9-5lHfBjTkpIzbSAN:22 a=xmb-EsYY8bH0VWELuYED:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=UlXOjAI1vcYD/S7BUlPFNO7DfoUazxLJA+6LNczUyX8=; b=MPXyoloKapQ5EfgkeTs8ziRP9I
        dPdpzlx9bjBQBAO0TNOrB6cDZXPRM7rUSmeieJnk71kqqoRaTBuuywE8r8YdtU2ZvSrHhxbmSOzjq
        tBcm+mKIBEc9JT+xoCRGrXsGl1Lf/82gj4oJ/xf09hSvdWz85yPQP1nPwHv+s/5ap3Zwv9/hKXVlq
        0m0v0PUTXHcCWZMaTUF/0dCZvy1V9RP6NF30yGFjQ/OLaQLX2wewUX2/tfH6X4xpL2HiEQfRkOWEg
        RuDJB91vtdBo8fzlpcWiuocFGLHy2fMSdmnhAc7Nie4wS0oJiON6ZUXi5sF4ddpR/F3jqKzTPQ2h/
        kllW8pdw==;
Received: from [94.239.20.48] (port=45764 helo=[192.168.1.98])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.96)
        (envelope-from <gustavo@embeddedor.com>)
        id 1qi3bV-000Sdq-0U;
        Sun, 17 Sep 2023 21:03:13 -0500
Message-ID: <8455fd0c-1871-1e4d-3d46-0cc63f856ded@embeddedor.com>
Date:   Sun, 17 Sep 2023 20:04:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ceph: Annotate struct ceph_monmap with __counted_by
Content-Language: en-US
To:     Xiubo Li <xiubli@redhat.com>, Kees Cook <keescook@chromium.org>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ceph-devel@vger.kernel.org,
        netdev@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
References: <20230915201510.never.365-kees@kernel.org>
 <3c4c7ca8-e1a2-fbb1-bda4-b7000eb9a8d9@redhat.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <3c4c7ca8-e1a2-fbb1-bda4-b7000eb9a8d9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 94.239.20.48
X-Source-L: No
X-Exim-ID: 1qi3bV-000Sdq-0U
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.1.98]) [94.239.20.48]:45764
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 8
X-Org:  HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNfUw8JvrGjXB+W7IiHf8GV/J5r/7jZGeh/1Jr7Nxwo5UIZ8F4BAsT9A9GkW9FSvG+y4vfxYcZuYMWxPolOAyd5q1j1Xh1ZPFoF/lb5bXh9rdt9lxtOy
 kVN8EqK/RzgsU8GDrdk64no7gJGl++ZOzQYxO2ihX+i31MhikjwLVVpSK33eW6yqLIBlJn3G+v7+1RVOfIAHG8Vls4QlwOtw35hD1N6xAA8lKdPeZo5dyN5w
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 9/17/23 18:25, Xiubo Li wrote:
> 
> On 9/16/23 04:15, Kees Cook wrote:
>> Prepare for the coming implementation by GCC and Clang of the __counted_by
>> attribute. Flexible array members annotated with __counted_by can have
>> their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
>> (for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
>> functions).
>>
>> As found with Coccinelle[1], add __counted_by for struct ceph_monmap.
>> Additionally, since the element count member must be set before accessing
>> the annotated flexible array member, move its initialization earlier.
>>
>> [1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci
>>
>> Cc: Ilya Dryomov <idryomov@gmail.com>
>> Cc: Xiubo Li <xiubli@redhat.com>
>> Cc: Jeff Layton <jlayton@kernel.org>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Eric Dumazet <edumazet@google.com>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: Paolo Abeni <pabeni@redhat.com>
>> Cc: ceph-devel@vger.kernel.org
>> Cc: netdev@vger.kernel.org
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>   include/linux/ceph/mon_client.h | 2 +-
>>   net/ceph/mon_client.c           | 2 +-
>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/ceph/mon_client.h b/include/linux/ceph/mon_client.h
>> index b658961156a0..7a9a40163c0f 100644
>> --- a/include/linux/ceph/mon_client.h
>> +++ b/include/linux/ceph/mon_client.h
>> @@ -19,7 +19,7 @@ struct ceph_monmap {
>>       struct ceph_fsid fsid;
>>       u32 epoch;
>>       u32 num_mon;
>> -    struct ceph_entity_inst mon_inst[];
>> +    struct ceph_entity_inst mon_inst[] __counted_by(num_mon);
>>   };
>>   struct ceph_mon_client;
>> diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
>> index faabad6603db..f263f7e91a21 100644
>> --- a/net/ceph/mon_client.c
>> +++ b/net/ceph/mon_client.c
>> @@ -1136,6 +1136,7 @@ static int build_initial_monmap(struct ceph_mon_client *monc)
>>                      GFP_KERNEL);
>>       if (!monc->monmap)
>>           return -ENOMEM;
>> +    monc->monmap->num_mon = num_mon;
>>       for (i = 0; i < num_mon; i++) {
>>           struct ceph_entity_inst *inst = &monc->monmap->mon_inst[i];
>> @@ -1147,7 +1148,6 @@ static int build_initial_monmap(struct ceph_mon_client *monc)
>>           inst->name.type = CEPH_ENTITY_TYPE_MON;
>>           inst->name.num = cpu_to_le64(i);
>>       }
>> -    monc->monmap->num_mon = num_mon;
> 
> BTW, is this change related ?

Yes, it is, and it's described in the changelog text.

`num_mon` must be updated before the first access to flex-array `mon_inst`.
Otherwise the compiler cannot properly instrument the code to catch any
out-of-bounds access to `mon_inst`.

--
Gustavo

> 
>>       return 0;
>>   }
> 
> Else LGTM.
> 
> Reviewed-by: Xiubo Li <xiubli@redhat.com>
> 
> Thanks!
> 
> - Xiubo
> 
> 
