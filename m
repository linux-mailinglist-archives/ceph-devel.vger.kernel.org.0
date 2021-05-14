Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546C93805F4
	for <lists+ceph-devel@lfdr.de>; Fri, 14 May 2021 11:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbhENJPc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 May 2021 05:15:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57269 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231735AbhENJPb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 14 May 2021 05:15:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620983660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KMGs/QynIOOiaXrxHQadH1YEi4RJh7qBjDay7+/Jlk0=;
        b=gaNDhcoASs+hD1SWgDNuA6KPSNkUDJ1ObqcOyEvNNXhYafb6qheD5HZU921K6iZZwhFXBJ
        TB6xmlP6PncxoBa0ffgkL20mz73MOmn5oyJ0EcfCXSHO4Zc7FT6WnbY0a/4KdAcA0gxAEA
        KP65BXlJFLQlWCrTzPzximRksp7MR+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-Bj76slDhO_2jtOPA11Ofzg-1; Fri, 14 May 2021 05:14:17 -0400
X-MC-Unique: Bj76slDhO_2jtOPA11Ofzg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4C0019253C5;
        Fri, 14 May 2021 09:14:15 +0000 (UTC)
Received: from [10.72.12.181] (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 901985D9CD;
        Fri, 14 May 2021 09:14:13 +0000 (UTC)
Subject: Re: [PATCH v2 0/2] ceph: send io size metrics to mds daemon
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20210513014053.81346-1-xiubli@redhat.com>
 <89def1a8e65e443ba7aca7c4ff138e6c6041a5df.camel@kernel.org>
 <70554cca-9985-338c-de04-4053a4a04872@redhat.com>
 <CAOi1vP-dpSUO5F_cyhzBycvuCp6N2cRPifJPAZ1Ybws+T=pGcA@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <de9304d8-8428-5634-24ec-fdae07b9ec24@redhat.com>
Date:   Fri, 14 May 2021 17:14:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP-dpSUO5F_cyhzBycvuCp6N2cRPifJPAZ1Ybws+T=pGcA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/14/21 4:57 PM, Ilya Dryomov wrote:
> On Fri, May 14, 2021 at 2:47 AM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 5/13/21 7:30 PM, Jeff Layton wrote:
>>> On Thu, 2021-05-13 at 09:40 +0800, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> V2:
>>>> - change the patch order
>>>> - replace the fixed 10 with sizeof(struct ceph_metric_header)
>>>>
>>>> Xiubo Li (2):
>>>>     ceph: simplify the metrics struct
>>>>     ceph: send the read/write io size metrics to mds
>>>>
>>>>    fs/ceph/metric.c | 90 ++++++++++++++++++++++++++++++------------------
>>>>    fs/ceph/metric.h | 79 +++++++++++++++++-------------------------
>>>>    2 files changed, 89 insertions(+), 80 deletions(-)
>>>>
>>> Thanks Xiubo,
>>>
>>> These look good. I'll do some testing with them and plan to merge these
>>> into the testing branch later today.
>> Sure, take your time.
> FYI I squashed "ceph: send the read/write io size metrics to mds" into
> "ceph: add IO size metrics support".

Got it.

Thanks


> Thanks,
>
>                  Ilya
>

