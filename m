Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B4A36BE86
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Apr 2021 06:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhD0Ei2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Apr 2021 00:38:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43039 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229535AbhD0Ei2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 00:38:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619498265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KXHJIyz16VoDRdukZeCItJDOTJgIDW93oKd0AmotTZk=;
        b=TlIaUeMuxKZz1cJDnXNPukLfStR5J9ky3R8XUrbaWBSp/Az2B9ED0s3prz4STp4/HBo1aO
        JklWkLBZB0UPraJvN5DDciWosHqJsH/xS+UzY6n0NsqIx+CgZEHk6KJy1DjUHySdvLZvmD
        uqP7aPin0/+75/8t7lh2AONB2YYqqP4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-597-eAoTG5VTOi2XW55t-ONeIQ-1; Tue, 27 Apr 2021 00:37:41 -0400
X-MC-Unique: eAoTG5VTOi2XW55t-ONeIQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65F3A1006C80;
        Tue, 27 Apr 2021 04:37:40 +0000 (UTC)
Received: from [10.72.13.181] (ovpn-13-181.pek2.redhat.com [10.72.13.181])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D4A58E17D;
        Tue, 27 Apr 2021 04:37:38 +0000 (UTC)
Subject: Re: [PATCH v3] libceph: add osd op counter metric support
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20201110141937.414301-1-xiubli@redhat.com>
 <CAOi1vP-tBRNEgkmhvieUyBzOms-n=vge4XpYSpnU6cnq86SRMQ@mail.gmail.com>
 <0ba63df09fe52cb3f650473f4d005a1abe301e3c.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f4e89e10-70f7-4568-5635-1ac8082f13a9@redhat.com>
Date:   Tue, 27 Apr 2021 12:37:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <0ba63df09fe52cb3f650473f4d005a1abe301e3c.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

Yeah, it is, the next plan is to send these metrics to MDS.

> I'll also add that it might be nice to keeps stats on copy_from2 as
> well, since we do have a copy_file_range operation in cephfs.

Okay, will check it.

