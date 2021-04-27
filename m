Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101DA36BE89
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Apr 2021 06:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhD0Eli (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Apr 2021 00:41:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40125 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229535AbhD0Elh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 00:41:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619498454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YbkhZEBskWy51K8dgE/tShKNI4F40SNns3Coi+DA4To=;
        b=HfcTzI0KtDuDTM/fZB17yjYI2DvWQ/Qeo2ZiD6CjFRPx2xp5cFD0bhjJCLlKheblkKJBbz
        J65akYciFVQrfdtLqCSO5hUL0HYG55HpRcnLeTUJwqxPbg3OxdclU3RN+aHNlpUBKHFloP
        kuVfSRZVFcDBmrdvdcGgk1lO1yQxkJk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-M28eNBUwNJivC6l3BYbV9g-1; Tue, 27 Apr 2021 00:40:52 -0400
X-MC-Unique: M28eNBUwNJivC6l3BYbV9g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8791118B9ECA;
        Tue, 27 Apr 2021 04:40:51 +0000 (UTC)
Received: from [10.72.13.181] (ovpn-13-181.pek2.redhat.com [10.72.13.181])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 00F1A6267F;
        Tue, 27 Apr 2021 04:40:49 +0000 (UTC)
Subject: Re: [PATCH v3] libceph: add osd op counter metric support
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20201110141937.414301-1-xiubli@redhat.com>
 <CAOi1vP-tBRNEgkmhvieUyBzOms-n=vge4XpYSpnU6cnq86SRMQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <36f94508-b882-305d-242d-0408829c9611@redhat.com>
Date:   Tue, 27 Apr 2021 12:40:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP-tBRNEgkmhvieUyBzOms-n=vge4XpYSpnU6cnq86SRMQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/11/10 23:44, Ilya Dryomov wrote:
> On Tue, Nov 10, 2020 at 3:19 PM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The logic is the same with osdc/Objecter.cc in ceph in user space.
>>
>> URL: https://tracker.ceph.com/issues/48053
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V3:
>> - typo fixing about oring the _WRITE
>>
>>   include/linux/ceph/osd_client.h |  9 ++++++
>>   net/ceph/debugfs.c              | 13 ++++++++
>>   net/ceph/osd_client.c           | 56 +++++++++++++++++++++++++++++++++
>>   3 files changed, 78 insertions(+)
>>
>> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
>> index 83fa08a06507..24301513b186 100644
>> --- a/include/linux/ceph/osd_client.h
>> +++ b/include/linux/ceph/osd_client.h
>> @@ -339,6 +339,13 @@ struct ceph_osd_backoff {
>>          struct ceph_hobject_id *end;
>>   };
>>
>> +struct ceph_osd_metric {
>> +       struct percpu_counter op_ops;
>> +       struct percpu_counter op_rmw;
>> +       struct percpu_counter op_r;
>> +       struct percpu_counter op_w;
>> +};
> OK, so only reads and writes are really needed.  Why not expose them
> through the existing metrics framework in fs/ceph?  Wouldn't "fs top"
> want to display them?  Exposing latency information without exposing
> overall counts seems rather weird to me anyway.
>
> The fundamental problem is that debugfs output format is not stable.
> The tracker mentions test_readahead -- updating some teuthology test
> cases from time to time is not a big deal, but if a user facing tool
> such as "fs top" starts relying on these, it would be bad.

Sorry, I am not sure whether had I replied this, I may missed this whole 
thread.

As Patrick mentioned, the fs top won't rely on it, it will collect the 
metrics from the MDS instead.

Thanks.

> Thanks,
>
>                  Ilya
>

