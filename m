Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95682AD22F
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 10:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbgKJJQh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 04:16:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60370 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726213AbgKJJQh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 04:16:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604999795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I8dPepJnZsiKvCnPi+5ugL9v5R/kPZKdstHTZhVRcBU=;
        b=drByL4ScdjsiwHAT5Bg4wcxGzSMzvyIujOkuGe/AXS1J3ZMr8GNiE4XBT3vDaB11dDryMq
        kmbdDz+g++LASWQQyFBPUZO8DjFFEO5bNjXM+g1HXKG4LUMEGXCK1OsNLiGmgprky/qTgP
        ZdeTXTYKWPHmrH0vuELqjQI8p5TlfJ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-MACFJaaWMWmw7tpOPP31oA-1; Tue, 10 Nov 2020 04:16:29 -0500
X-MC-Unique: MACFJaaWMWmw7tpOPP31oA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C72A310054FF;
        Tue, 10 Nov 2020 09:16:28 +0000 (UTC)
Received: from [10.72.12.62] (ovpn-12-62.pek2.redhat.com [10.72.12.62])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DBCB875135;
        Tue, 10 Nov 2020 09:16:26 +0000 (UTC)
Subject: Re: [PATCH] libceph: add osd op counter metric support
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20201110020051.118461-1-xiubli@redhat.com>
 <CAOi1vP_QnxYX-cLu_-UPbYAYa14e6KHnujAaNG5dW0iWHMfaZg@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3b55e040-9426-0205-7a13-a332075bbdf5@redhat.com>
Date:   Tue, 10 Nov 2020 17:16:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP_QnxYX-cLu_-UPbYAYa14e6KHnujAaNG5dW0iWHMfaZg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/11/10 16:11, Ilya Dryomov wrote:
> On Tue, Nov 10, 2020 at 3:01 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The logic is the same with osdc/Objecter.cc in ceph in user space.
>>
>> URL: https://tracker.ceph.com/issues/48053
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   include/linux/ceph/osd_client.h |  46 ++++++
>>   net/ceph/debugfs.c              |  51 +++++++
>>   net/ceph/osd_client.c           | 249 +++++++++++++++++++++++++++++++-
>>   3 files changed, 343 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
>> index 83fa08a06507..9ff9ceed7cb5 100644
>> --- a/include/linux/ceph/osd_client.h
>> +++ b/include/linux/ceph/osd_client.h
>> @@ -339,6 +339,50 @@ struct ceph_osd_backoff {
>>          struct ceph_hobject_id *end;
>>   };
>>
>> +struct ceph_osd_metric {
>> +       struct percpu_counter op_ops;
>> +       struct percpu_counter op_oplen_avg;
>> +       struct percpu_counter op_send;
>> +       struct percpu_counter op_send_bytes;
>> +       struct percpu_counter op_resend;
>> +       struct percpu_counter op_reply;
>> +
>> +       struct percpu_counter op_rmw;
>> +       struct percpu_counter op_r;
>> +       struct percpu_counter op_w;
>> +       struct percpu_counter op_pgop;
>> +
>> +       struct percpu_counter op_stat;
>> +       struct percpu_counter op_create;
>> +       struct percpu_counter op_read;
>> +       struct percpu_counter op_write;
>> +       struct percpu_counter op_writefull;
>> +       struct percpu_counter op_append;
>> +       struct percpu_counter op_zero;
>> +       struct percpu_counter op_truncate;
>> +       struct percpu_counter op_delete;
>> +       struct percpu_counter op_mapext;
>> +       struct percpu_counter op_sparse_read;
>> +       struct percpu_counter op_clonerange;
>> +       struct percpu_counter op_getxattr;
>> +       struct percpu_counter op_setxattr;
>> +       struct percpu_counter op_cmpxattr;
>> +       struct percpu_counter op_rmxattr;
>> +       struct percpu_counter op_resetxattrs;
>> +       struct percpu_counter op_call;
>> +       struct percpu_counter op_watch;
>> +       struct percpu_counter op_notify;
>> +
>> +       struct percpu_counter op_omap_rd;
>> +       struct percpu_counter op_omap_wr;
>> +       struct percpu_counter op_omap_del;
>> +
>> +       struct percpu_counter op_linger_active;
>> +       struct percpu_counter op_linger_send;
>> +       struct percpu_counter op_linger_resend;
>> +       struct percpu_counter op_linger_ping;
> Many of these ops aren't supported by the kernel client.  Let's trim
> this down to what your use case actually needs.

Sure.


>   If it's just reads and
> writes, aren't they already surfaced through the new filesystem metrics
> framework?

That framework only includes the read/write latency related metrics, but 
for the test_readahead and some other qa test cases that metrics make no 
sense.

Thanks

BRs

> Thanks,
>
>                  Ilya
>

