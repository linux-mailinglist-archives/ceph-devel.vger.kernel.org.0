Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C942AFE84
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Nov 2020 06:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbgKLFin (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Nov 2020 00:38:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58579 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726083AbgKLCaV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Nov 2020 21:30:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605148218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kHjcPin1N01FZMho5xFMaucKCCPKXpTXKCBilFdKtL0=;
        b=Lt5f6cC3ZL5wgdUlgwrClw+QYgNC1MbFSEvELZIpP8gVYCeDLPCbUCb55uTj3SYb5zGMvY
        rqd2MZKSC2yNkhKH8OjZgNqk8RdpDJ3GbzBjCZuosSlxLJOAWJ3T1F8LA6nVlzv9FDNwh0
        usclGBVb/WUEP2PCQOKCpe6anHazxNw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-f3yzMYqEPICTEFy20xH3vA-1; Wed, 11 Nov 2020 21:30:13 -0500
X-MC-Unique: f3yzMYqEPICTEFy20xH3vA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73C881006CA9;
        Thu, 12 Nov 2020 02:30:12 +0000 (UTC)
Received: from [10.72.13.24] (ovpn-13-24.pek2.redhat.com [10.72.13.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A32C27BD8;
        Thu, 12 Nov 2020 02:30:10 +0000 (UTC)
Subject: Re: [PATCH v3] libceph: add osd op counter metric support
To:     Patrick Donnelly <pdonnell@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20201110141937.414301-1-xiubli@redhat.com>
 <CAOi1vP-tBRNEgkmhvieUyBzOms-n=vge4XpYSpnU6cnq86SRMQ@mail.gmail.com>
 <CA+2bHPb1pP-xRGVrKfOqB8D94Nku_s5Kj+kVSzOzg3Zxpypzfg@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <08cde4b0-29b6-5846-56ab-df38268bba04@redhat.com>
Date:   Thu, 12 Nov 2020 10:30:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <CA+2bHPb1pP-xRGVrKfOqB8D94Nku_s5Kj+kVSzOzg3Zxpypzfg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/11/11 23:18, Patrick Donnelly wrote:
> On Tue, Nov 10, 2020 at 7:45 AM Ilya Dryomov <idryomov@gmail.com> wrote:
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
>>>   include/linux/ceph/osd_client.h |  9 ++++++
>>>   net/ceph/debugfs.c              | 13 ++++++++
>>>   net/ceph/osd_client.c           | 56 +++++++++++++++++++++++++++++++++
>>>   3 files changed, 78 insertions(+)
>>>
>>> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
>>> index 83fa08a06507..24301513b186 100644
>>> --- a/include/linux/ceph/osd_client.h
>>> +++ b/include/linux/ceph/osd_client.h
>>> @@ -339,6 +339,13 @@ struct ceph_osd_backoff {
>>>          struct ceph_hobject_id *end;
>>>   };
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
> `fs top` may want to eventually display this information but the
> intention was to have a "perf dump"-like debugfs file that has
> information about the number of osd op reads/writes. We need that for
> this test:
>
> https://github.com/ceph/ceph/blob/master/qa/tasks/cephfs/test_readahead.py#L20
>
> Pulling the information out through `fs top` is not a direction I'd like to go.
>
>> The fundamental problem is that debugfs output format is not stable.
>> The tracker mentions test_readahead -- updating some teuthology test
>> cases from time to time is not a big deal, but if a user facing tool
>> such as "fs top" starts relying on these, it would be bad.
> `fs top` will not rely on debugfs files.
>
There has one bug in the "test_readahead.py", I have fixed it in [1]. I 
think the existing cephfs metric framework is far enough for us to 
support the readahead qa test for kclient.

[1] https://github.com/ceph/ceph/pull/38016

Thanks

BRs

