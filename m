Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCFE2AD0C6
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 09:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbgKJIDT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 03:03:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28151 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726467AbgKJIDT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 03:03:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604995398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OZeqRBSpMaKDUaoQF61qrx5XFGXp6uffT7BSXE7jhyo=;
        b=P4B93hY0BbxSFPDSseCs8biFrGtMpNyCUJwQjh7fJdfYBtNDIVj0qxoDbs4gO3wslvj2ov
        WOY7SLQALqWJjwnsaH6YjemGurmN5wWM/nzF4toEFvm6yjr5X7NuPDEL7OCe0JcWre6yT3
        qFUR5Bk7/VMHPUFcUCkZGOmIrst7vOc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-zCQBg1v4NlqZVS8FEKVSTg-1; Tue, 10 Nov 2020 03:03:14 -0500
X-MC-Unique: zCQBg1v4NlqZVS8FEKVSTg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABAA51005504;
        Tue, 10 Nov 2020 08:03:13 +0000 (UTC)
Received: from [10.72.12.62] (ovpn-12-62.pek2.redhat.com [10.72.12.62])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C4CF110013D9;
        Tue, 10 Nov 2020 08:03:11 +0000 (UTC)
Subject: Re: [PATCH 1/2] ceph: add status debug file support
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20201105023703.735882-1-xiubli@redhat.com>
 <20201105023703.735882-2-xiubli@redhat.com>
 <CAOi1vP9r5FMaLsO_xZ6UDnq24aAL-L1cc0CK2do5sR61vfy=Ag@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <64e0898d-4d76-6e60-4f21-a7fa0b3d208d@redhat.com>
Date:   Tue, 10 Nov 2020 16:03:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP9r5FMaLsO_xZ6UDnq24aAL-L1cc0CK2do5sR61vfy=Ag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/11/10 15:51, Ilya Dryomov wrote:
> On Thu, Nov 5, 2020 at 3:37 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This will help list some useful client side info, like the client
>> entity address/name and bloclisted status, etc.
>>
>> URL: https://tracker.ceph.com/issues/48057
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/debugfs.c | 22 ++++++++++++++++++++++
>>   fs/ceph/super.h   |  1 +
>>   2 files changed, 23 insertions(+)
>>
>> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
>> index 7a8fbe3e4751..8b6db73c94ad 100644
>> --- a/fs/ceph/debugfs.c
>> +++ b/fs/ceph/debugfs.c
>> @@ -14,6 +14,7 @@
>>   #include <linux/ceph/mon_client.h>
>>   #include <linux/ceph/auth.h>
>>   #include <linux/ceph/debugfs.h>
>> +#include <linux/ceph/messenger.h>
>>
>>   #include "super.h"
>>
>> @@ -127,6 +128,20 @@ static int mdsc_show(struct seq_file *s, void *p)
>>          return 0;
>>   }
>>
>> +static int status_show(struct seq_file *s, void *p)
>> +{
>> +       struct ceph_fs_client *fsc = s->private;
>> +       struct ceph_messenger *msgr = &fsc->client->msgr;
>> +       struct ceph_entity_inst *inst = &msgr->inst;
>> +
>> +       seq_printf(s, "status:\n\n"),
> Hi Xiubo,
>
> This header and leading tabs seem rather useless to me.

Sure, will remove them.


>> +       seq_printf(s, "\tinst_str:\t%s.%lld  %s/%u\n", ENTITY_NAME(inst->name),
>                                               ^^ two spaces?
>
>> +                  ceph_pr_addr(&inst->addr), le32_to_cpu(inst->addr.nonce));
>> +       seq_printf(s, "\tblocklisted:\t%s\n", fsc->blocklisted ? "true" : "false");
> This line is too long.

Will fix it.

Thank Ilya.


> Thanks,
>
>                  Ilya
>

