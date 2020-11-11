Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5438C2AE5E6
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Nov 2020 02:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732505AbgKKBhW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 20:37:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24943 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731657AbgKKBhV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 20:37:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605058639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=72a2kaiKe4x1LEXkdSeZq0vRPoi0wiM4gMSEMntC6BY=;
        b=Wufb2zOfx3mAEPcY9bKbpldOUB3U/yHyd0H/Lk1oqz8s7T4dDYfkkdRxkIEOsfxS2YWiDp
        FKnou4iKb1AgGLmdUqgem4ko2cWrFUQafKJKDWzIoXG8hsxlzKNnmDKN//WCxjPFGO3NET
        1bEyAxq7oJvRu5kvZ4py3YlIn4WOpUI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-e37P8qznMm67yPo98qhyCA-1; Tue, 10 Nov 2020 20:37:18 -0500
X-MC-Unique: e37P8qznMm67yPo98qhyCA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 255B58030D7;
        Wed, 11 Nov 2020 01:37:17 +0000 (UTC)
Received: from [10.72.12.102] (ovpn-12-102.pek2.redhat.com [10.72.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2998375138;
        Wed, 11 Nov 2020 01:37:14 +0000 (UTC)
Subject: Re: [PATCH v3] libceph: add osd op counter metric support
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20201110141937.414301-1-xiubli@redhat.com>
 <CAOi1vP-tBRNEgkmhvieUyBzOms-n=vge4XpYSpnU6cnq86SRMQ@mail.gmail.com>
 <0ba63df09fe52cb3f650473f4d005a1abe301e3c.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <4ebc49eb-5f17-14a3-17d5-1f2607d16ad5@redhat.com>
Date:   Wed, 11 Nov 2020 09:37:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <0ba63df09fe52cb3f650473f4d005a1abe301e3c.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/11/11 1:11, Jeff Layton wrote:
> On Tue, 2020-11-10 at 16:44 +0100, Ilya Dryomov wrote:
>> On Tue, Nov 10, 2020 at 3:19 PM <xiubli@redhat.com> wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> The logic is the same with osdc/Objecter.cc in ceph in user space.
>>>
>>> URL: https://tracker.ceph.com/issues/48053
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>
>>> V3:
>>> - typo fixing about oring the _WRITE
>>>
>>>   include/linux/ceph/osd_client.h |  9 ++++++
>>>   net/ceph/debugfs.c              | 13 ++++++++
>>>   net/ceph/osd_client.c           | 56 +++++++++++++++++++++++++++++++++
>>>   3 files changed, 78 insertions(+)
>>>
>>> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
>>> index 83fa08a06507..24301513b186 100644
>>> --- a/include/linux/ceph/osd_client.h
>>> +++ b/include/linux/ceph/osd_client.h
>>> @@ -339,6 +339,13 @@ struct ceph_osd_backoff {
>>>          struct ceph_hobject_id *end;
>>>   };
>>>
>>> +struct ceph_osd_metric {
>>> +       struct percpu_counter op_ops;
>>> +       struct percpu_counter op_rmw;
>>> +       struct percpu_counter op_r;
>>> +       struct percpu_counter op_w;
>>> +};
>> OK, so only reads and writes are really needed.  Why not expose them
>> through the existing metrics framework in fs/ceph?  Wouldn't "fs top"
>> want to display them?  Exposing latency information without exposing
>> overall counts seems rather weird to me anyway.
>>
>> The fundamental problem is that debugfs output format is not stable.
>> The tracker mentions test_readahead -- updating some teuthology test
>> cases from time to time is not a big deal, but if a user facing tool
>> such as "fs top" starts relying on these, it would be bad.
>>
>> Thanks,
>>
>>                  Ilya
> Those are all good points. The tracker is light on details. I had
> assumed that you'd also be uploading this to the MDS in a later patch.
> Is that also planned?

Yeah, this is on my todo list.


> I'll also add that it might be nice to keeps stats on copy_from2 as
> well, since we do have a copy_file_range operation in cephfs.

Make sense and I will add it.

Thanks

BRs

