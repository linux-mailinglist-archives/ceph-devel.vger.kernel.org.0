Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0DC5150486
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Feb 2020 11:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbgBCKrF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Feb 2020 05:47:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29611 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727309AbgBCKrF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Feb 2020 05:47:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580726823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mMH6KiGNW1bKGKWrQArbx0PcaoFZNa68qq3rbBD0Kfg=;
        b=dDCO3ysieyKI9Q07K2AKgGe96tSmdnFcy0RrwhihqAeBaGuhbmdhicMggpjLeIShB3UKfk
        YDSKZdvmC7OEcCeoHUwdgLCe5yzoUst9dNEMSRaC/+lTzx7xUkxWNj5a4pyIdC1xDUlx7t
        Z8tyg6ECSfe/EWI/YkSqHYeJFhEwjo4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-o2lHD_hcN5SwF3mNWcba6w-1; Mon, 03 Feb 2020 05:47:02 -0500
X-MC-Unique: o2lHD_hcN5SwF3mNWcba6w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 067571005512;
        Mon,  3 Feb 2020 10:47:01 +0000 (UTC)
Received: from [10.72.12.34] (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 41A085DA82;
        Mon,  3 Feb 2020 10:46:54 +0000 (UTC)
Subject: Re: [RFC PATCH] ceph: fix the debug message for calc_layout
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20200203040133.39319-1-xiubli@redhat.com>
 <CAOi1vP-pGZ1dBhr_EY8t=jas-16T887HTmtyJuVz70roKiYW1A@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <a032d2e1-e463-e4e7-5583-5c71e52edd96@redhat.com>
Date:   Mon, 3 Feb 2020 18:46:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP-pGZ1dBhr_EY8t=jas-16T887HTmtyJuVz70roKiYW1A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/3 18:25, Ilya Dryomov wrote:
> On Mon, Feb 3, 2020 at 5:02 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   net/ceph/osd_client.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>> index 108c9457d629..6afe36ffc1ba 100644
>> --- a/net/ceph/osd_client.c
>> +++ b/net/ceph/osd_client.c
>> @@ -113,10 +113,11 @@ static int calc_layout(struct ceph_file_layout *layout, u64 off, u64 *plen,
>>          if (*objlen < orig_len) {
>>                  *plen = *objlen;
>>                  dout(" skipping last %llu, final file extent %llu~%llu\n",
>> -                    orig_len - *plen, off, *plen);
>> +                    orig_len - *plen, off, off + *plen);
>>          }
>>
>> -       dout("calc_layout objnum=%llx %llu~%llu\n", *objnum, *objoff, *objlen);
>> +       dout("calc_layout objnum=%llx, object extent %llu~%llu\n", *objnum,
>> +            *objoff, *objoff + *objlen);
> Hi Xiubo,
>
> offset~length is how extents are printed both on the OSD side and
> elsewhere in the kernel client.

Okay, so my understanding is not correct then.

Thanks.


> Thanks,
>
>                  Ilya
>

