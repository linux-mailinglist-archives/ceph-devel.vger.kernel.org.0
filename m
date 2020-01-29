Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCE514C75A
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Jan 2020 09:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgA2IXy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 Jan 2020 03:23:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50916 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726091AbgA2IXx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 Jan 2020 03:23:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580286232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j25GC93ueLZwnbY7escMG6dBN/monClqNMuYpA3kd3o=;
        b=CP7i9UBNoFu5OxOyk9GPqL7NhjwFRa/p09OkKkB7zVPRKq66UxmyfNs0rG1NvN/1431JpV
        yrtIu3F4dfzNo7hTZisNyBshRPiQLEOgQ3QXWlchsFhSPPfuWd8FTXP2gnCYpBsRUxbtSS
        d5MQzHydGYndZTD2e08IQ/8cTFrCyCU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-pnJkImy5MLew70QMJu1aVw-1; Wed, 29 Jan 2020 03:23:49 -0500
X-MC-Unique: pnJkImy5MLew70QMJu1aVw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58F9C18C43C0;
        Wed, 29 Jan 2020 08:23:48 +0000 (UTC)
Received: from [10.72.12.34] (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 89ECD88831;
        Wed, 29 Jan 2020 08:23:43 +0000 (UTC)
Subject: Re: [PATCH v5 0/10] ceph: add perf metrics support
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20200128130248.4266-1-xiubli@redhat.com>
 <CAOi1vP-o+mNPprtFKjD-=ifEzHS6uMva2ZDf=LM6PCT4CJuPoA@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <9305ac55-3436-6f66-bd7b-7f107323e1dd@redhat.com>
Date:   Wed, 29 Jan 2020 16:23:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP-o+mNPprtFKjD-=ifEzHS6uMva2ZDf=LM6PCT4CJuPoA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/1/28 22:16, Ilya Dryomov wrote:
> On Tue, Jan 28, 2020 at 2:03 PM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Changed in V2:
>> - add read/write/metadata latency metric support.
>> - add and send client provided metric flags in client metadata
>> - addressed the comments from Ilya and merged the 4/4 patch into 3/4.
>> - addressed all the other comments in v1 series.
>>
>> Changed in V3:
>> - addressed Jeff's comments and let's the callers do the metric
>> counting.
>> - with some small fixes for the read/write latency
>> - tested based on the latest testing branch
>>
>> Changed in V4:
>> - fix the lock issue
>>
>> Changed in V5:
>> - add r_end_stamp for the osdc request
>> - delete reset metric and move it to metric sysfs
>> - move ceph_osdc_{read,write}pages to ceph.ko
>> - use percpu counters instead for read/write/metadata latencies
>>
>> It will send the metrics to the MDSs every second if sending_metrics is enabled, disable as default.
> Hi Xiubo,
>
> What is this series based on?  "[PATCH v5 01/10] ceph: add caps perf
> metric for each session" changes metric_show() in fs/ceph/debugfs.c,
> but there is no such function upstream or in the testing branch.

There actually 11 patches, I missed the first one, will resend it.

Thanks.


> Thanks,
>
>                  Ilya
>

