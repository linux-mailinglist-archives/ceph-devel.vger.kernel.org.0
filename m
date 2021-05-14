Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695D9380149
	for <lists+ceph-devel@lfdr.de>; Fri, 14 May 2021 02:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbhENAtE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 May 2021 20:49:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47954 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231822AbhENAtE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 13 May 2021 20:49:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620953273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lG+oUrWMidm2T3GUG/jm/U1WqvAE/2ip7RsPaZFo2YI=;
        b=gk9ozx8It1Q71DzZ/lJk+fFpjI0UlNEAy3YHc38Coa/OdMwJhSoFaGPtP4SPl/pYztkZbm
        uJS1zqXajCPhdG+gVXs/sN9x1WW85dyCpauK/rAwSsO/da6lpFr+rnUCxkUHq0jHQ0BoG2
        Gf1DjAhcqFXapHnx4BxcIcn1B7gMB/Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-3o1JqLJkNNKFAKpzgYmJCQ-1; Thu, 13 May 2021 20:47:51 -0400
X-MC-Unique: 3o1JqLJkNNKFAKpzgYmJCQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29927801B14;
        Fri, 14 May 2021 00:47:50 +0000 (UTC)
Received: from [10.72.12.181] (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2682110013C1;
        Fri, 14 May 2021 00:47:47 +0000 (UTC)
Subject: Re: [PATCH v2 0/2] ceph: send io size metrics to mds daemon
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ukernel@gmail.com,
        ceph-devel@vger.kernel.org
References: <20210513014053.81346-1-xiubli@redhat.com>
 <89def1a8e65e443ba7aca7c4ff138e6c6041a5df.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <70554cca-9985-338c-de04-4053a4a04872@redhat.com>
Date:   Fri, 14 May 2021 08:47:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <89def1a8e65e443ba7aca7c4ff138e6c6041a5df.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/13/21 7:30 PM, Jeff Layton wrote:
> On Thu, 2021-05-13 at 09:40 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> V2:
>> - change the patch order
>> - replace the fixed 10 with sizeof(struct ceph_metric_header)
>>
>> Xiubo Li (2):
>>    ceph: simplify the metrics struct
>>    ceph: send the read/write io size metrics to mds
>>
>>   fs/ceph/metric.c | 90 ++++++++++++++++++++++++++++++------------------
>>   fs/ceph/metric.h | 79 +++++++++++++++++-------------------------
>>   2 files changed, 89 insertions(+), 80 deletions(-)
>>
> Thanks Xiubo,
>
> These look good. I'll do some testing with them and plan to merge these
> into the testing branch later today.

Sure, take your time.

BRs

Xiubo


> Cheers,

