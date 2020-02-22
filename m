Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C844168B8C
	for <lists+ceph-devel@lfdr.de>; Sat, 22 Feb 2020 02:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgBVBVH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 21 Feb 2020 20:21:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58477 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726852AbgBVBVG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 21 Feb 2020 20:21:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582334465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1q04baIwUBRhTXHkOKRKjnOkPIUhhJ6J3uwG6+YEYDE=;
        b=bitXpJs8x/tfF6+tWX9ICHEPGUIpD2c65rcHSZIfIBkO47SjRkzLRn9/w4VFKcAHpCQL6x
        A9+ieHCSnoWdZFRnevzI4JGKqmeuB3Cf1qvjW1osVNl+PPEsM/iEolxAYMkka3dQxlUwEw
        jK7Up+biadANEXn6HyVvVUDrx7Tg160=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-9MCpR0ilNvySQfyICA5Ttw-1; Fri, 21 Feb 2020 20:21:01 -0500
X-MC-Unique: 9MCpR0ilNvySQfyICA5Ttw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9BA28017CC;
        Sat, 22 Feb 2020 01:21:00 +0000 (UTC)
Received: from [10.72.12.94] (ovpn-12-94.pek2.redhat.com [10.72.12.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 44D2360BE0;
        Sat, 22 Feb 2020 01:20:55 +0000 (UTC)
Subject: Re: [PATCH v8 5/5] ceph: add global metadata perf metric support
To:     Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>
Cc:     Sage Weil <sage@redhat.com>, "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20200221070556.18922-1-xiubli@redhat.com>
 <20200221070556.18922-6-xiubli@redhat.com>
 <68e496bca563ed6439c16f0de04d7daeb17f718a.camel@kernel.org>
 <CAOi1vP92XUaOfQ_xJFZDXuH4r9D07fW6ckEyd2csr7EhUSRkpg@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <8d977d6a-da80-5900-aead-395b9b4eaa76@redhat.com>
Date:   Sat, 22 Feb 2020 09:20:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP92XUaOfQ_xJFZDXuH4r9D07fW6ckEyd2csr7EhUSRkpg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/21 22:56, Ilya Dryomov wrote:
> On Fri, Feb 21, 2020 at 1:03 PM Jeff Layton <jlayton@kernel.org> wrote:
>> On Fri, 2020-02-21 at 02:05 -0500, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> It will calculate the latency for the metedata requests, which only
>>> include the time cousumed by network and the ceph.
>>>
>> "and the ceph MDS" ?
>>
>>> item          total       sum_lat(us)     avg_lat(us)
>>> -----------------------------------------------------
>>> metadata      113         220000          1946
>>>
>>> URL: https://tracker.ceph.com/issues/43215
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>   fs/ceph/debugfs.c    |  6 ++++++
>>>   fs/ceph/mds_client.c | 20 ++++++++++++++++++++
>>>   fs/ceph/metric.h     | 13 +++++++++++++
>>>   3 files changed, 39 insertions(+)
>>>
>>> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
>>> index 464bfbdb970d..60f3e307fca1 100644
>>> --- a/fs/ceph/debugfs.c
>>> +++ b/fs/ceph/debugfs.c
>>> @@ -146,6 +146,12 @@ static int metric_show(struct seq_file *s, void *p)
>>>        avg = total ? sum / total : 0;
>>>        seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "write", total, sum, avg);
>>>
>>> +     total = percpu_counter_sum(&mdsc->metric.total_metadatas);
>>> +     sum = percpu_counter_sum(&mdsc->metric.metadata_latency_sum);
>>> +     sum = jiffies_to_usecs(sum);
>>> +     avg = total ? sum / total : 0;
>>> +     seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "metadata", total, sum, avg);
>>> +
>>>        seq_printf(s, "\n");
>>>        seq_printf(s, "item          total           miss            hit\n");
>>>        seq_printf(s, "-------------------------------------------------\n");
>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>> index 0a3447966b26..3e792eca6af7 100644
>>> --- a/fs/ceph/mds_client.c
>>> +++ b/fs/ceph/mds_client.c
>>> @@ -3017,6 +3017,12 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>>>
>>>        /* kick calling process */
>>>        complete_request(mdsc, req);
>>> +
>>> +     if (!result || result == -ENOENT) {
>>> +             s64 latency = jiffies - req->r_started;
>>> +
>>> +             ceph_update_metadata_latency(&mdsc->metric, latency);
>>> +     }
>> Should we add an r_end_stamp field to the mds request struct and use
>> that to calculate this? Many jiffies may have passed between the reply
>> coming in and this point. If you really want to measure the latency that
>> would be more accurate, I think.
> Yes, capturing it after invoking the callback is inconsistent
> with what is done for OSD requests (the new r_end_stamp is set in
> finish_request()).
>
> It looks like this is the only place where MDS r_end_stamp would be
> needed, so perhaps just move this before complete_request() call?

Currently for the OSD requests, they are almost in the same place where 
at the end of the handle_reply.

If we don't want to calculate the consumption by the most of 
handle_reply code, we may set the r_end_stamp in the begin of it for 
both OSD/MDS requests ?

I'm thinking since in the handle_reply, it may also wait for the mutex 
locks and then sleeps, so move the r_end_stamp to the beginning should 
make sense...

Thanks
BRs


> Thanks,
>
>                  Ilya
>

