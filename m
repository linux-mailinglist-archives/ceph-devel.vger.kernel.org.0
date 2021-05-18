Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09685386EA3
	for <lists+ceph-devel@lfdr.de>; Tue, 18 May 2021 03:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345301AbhERBBv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 May 2021 21:01:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33291 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239539AbhERBBt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 May 2021 21:01:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621299631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r0t6deYIVcRXZIRfZnnq1BbzLoqrt/WuYir452iK3dc=;
        b=ha2+4OYPSSO0f46gKOQ+axwnQt32qnTyyuGWg8nEWh34/QTliHE0TmYSOswySUTE53OFwo
        mtjJZScv7LtYIX9hJWcENhSNDSYD/0y9anz/LX5GAmrYuNGlHj+3SsXvwkjlAZG/gdYJ67
        a167iBHZzTyBm6x6Z/3EyiNkv1wIaSk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-UyLcSgmvMZuKYV7T8KsdaQ-1; Mon, 17 May 2021 21:00:28 -0400
X-MC-Unique: UyLcSgmvMZuKYV7T8KsdaQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC20B107ACE3;
        Tue, 18 May 2021 01:00:27 +0000 (UTC)
Received: from [10.72.12.181] (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 34BC45C232;
        Tue, 18 May 2021 01:00:24 +0000 (UTC)
Subject: Re: [PATCH v2 0/2] ceph: send io size metrics to mds daemon
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20210513014053.81346-1-xiubli@redhat.com>
 <89def1a8e65e443ba7aca7c4ff138e6c6041a5df.camel@kernel.org>
 <70554cca-9985-338c-de04-4053a4a04872@redhat.com>
 <CAOi1vP-dpSUO5F_cyhzBycvuCp6N2cRPifJPAZ1Ybws+T=pGcA@mail.gmail.com>
 <de9304d8-8428-5634-24ec-fdae07b9ec24@redhat.com>
 <7a9d7350f30ee91138876b7330324db582713ee8.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <04b4b11c-0411-cacd-9504-36be3437169c@redhat.com>
Date:   Tue, 18 May 2021 09:00:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <7a9d7350f30ee91138876b7330324db582713ee8.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/17/21 11:46 PM, Jeff Layton wrote:
> On Fri, 2021-05-14 at 17:14 +0800, Xiubo Li wrote:
>> On 5/14/21 4:57 PM, Ilya Dryomov wrote:
>>> On Fri, May 14, 2021 at 2:47 AM Xiubo Li <xiubli@redhat.com> wrote:
>>>> On 5/13/21 7:30 PM, Jeff Layton wrote:
>>>>> On Thu, 2021-05-13 at 09:40 +0800, xiubli@redhat.com wrote:
>>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>>
>>>>>> V2:
>>>>>> - change the patch order
>>>>>> - replace the fixed 10 with sizeof(struct ceph_metric_header)
>>>>>>
>>>>>> Xiubo Li (2):
>>>>>>      ceph: simplify the metrics struct
>>>>>>      ceph: send the read/write io size metrics to mds
>>>>>>
>>>>>>     fs/ceph/metric.c | 90 ++++++++++++++++++++++++++++++------------------
>>>>>>     fs/ceph/metric.h | 79 +++++++++++++++++-------------------------
>>>>>>     2 files changed, 89 insertions(+), 80 deletions(-)
>>>>>>
>>>>> Thanks Xiubo,
>>>>>
>>>>> These look good. I'll do some testing with them and plan to merge these
>>>>> into the testing branch later today.
>>>> Sure, take your time.
>>> FYI I squashed "ceph: send the read/write io size metrics to mds" into
>>> "ceph: add IO size metrics support".
> I've dropped this combined patch for now, as it was triggering an MDS
> assertion that was hampering testing [1]. I'll plan to add it back once
> that problem is resolved in the MDS.
>
> [1]: https://github.com/ceph/ceph/pull/41357
>
> Cheers,

Ack. Thanks.


