Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 074E617E05D
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Mar 2020 13:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgCIMfk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Mar 2020 08:35:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31827 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726368AbgCIMfk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Mar 2020 08:35:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583757339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+nREdQX4Lwf+L8rRl8r6V/Byz8wKcbctMITGasCELg4=;
        b=HPgF7D/PyQaQxXVlG6kW4XBAPRqnFug4Jpm8Kx+H8m/77Lheyx3f3y0HzSjx8dtDd+ALm7
        DnzVWo1zSjuaczemHpZ+OlShy402c++yPY/dFQmxLcshbVr1EqRhQL7opfSWyYQGkqhad/
        +AKK0SUjxQuKCOd7w9HPPyxXpuJjGxI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-qJJ2dauhPIKfYPWBYWVqpA-1; Mon, 09 Mar 2020 08:35:38 -0400
X-MC-Unique: qJJ2dauhPIKfYPWBYWVqpA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 109408017CC;
        Mon,  9 Mar 2020 12:35:37 +0000 (UTC)
Received: from [10.72.13.87] (ovpn-13-87.pek2.redhat.com [10.72.13.87])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 378CE62667;
        Mon,  9 Mar 2020 12:35:31 +0000 (UTC)
Subject: Re: [PATCH v9 0/5] ceph: add perf metrics support
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <1583739430-4928-1-git-send-email-xiubli@redhat.com>
 <5f1c8c66f573ce499a1232c2346f5baaff413a57.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <af49cb5d-4876-79dd-e68d-142036c4d1cb@redhat.com>
Date:   Mon, 9 Mar 2020 20:35:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <5f1c8c66f573ce499a1232c2346f5baaff413a57.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/3/9 20:09, Jeff Layton wrote:
> On Mon, 2020-03-09 at 03:37 -0400, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Changed in V9:
>> - add an r_ended field to the mds request struct and use that to calculate the metric
>> - fix some commit comments
>>
>> We can get the metrics from the debugfs:
>>
>> $ cat /sys/kernel/debug/ceph/0c93a60d-5645-4c46-8568-4c8f63db4c7f.client4267/metrics
>> item          total       sum_lat(us)     avg_lat(us)
>> -----------------------------------------------------
>> read          13          417000          32076
>> write         42          131205000       3123928
>> metadata      104         493000          4740
>>
>> item          total           miss            hit
>> -------------------------------------------------
>> d_lease       204             0               918
>> caps          204             213             368218
>>
> Thanks Xiubo! This looks good. One minor issue with the cap patch, but I
> can just fix that up before merging if you're ok with my proposed
> change.
>
> Beyond this...while average latency is a good metric, it's often not
> enough to help diagnose problems. I wonder if we ought to be at least
> tracking min/max latency for all calls too. I wonder if there's way to
> track standard deviation too? That would be really nice to have.

yeah, the min/max latencies here make sense, it is on my todo list and I 
will do it after this patch series.

And for the standard deviation I will try to have a investigate of it.

Thanks

> Cheers,


