Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63D4223BF7
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Jul 2020 15:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgGQNJE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 17 Jul 2020 09:09:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21266 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726386AbgGQNJE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 17 Jul 2020 09:09:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594991342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IZD0zYUZ2wi+bnftHUecvlsVpq3TWBzUPBkY9mA1QoU=;
        b=eGb2AlRpV+1Ap6wNPdOha3tFbfdUveDnbqMnxv7/EuajvobmGPPMOKcnoFVq3FSD/0K6+T
        9+2jDUjy56uHbJHVGLu1uo3s2FUTbbzj3+eKBa82817a6H16JYmTM5xf5Iyok6O7hofuC7
        WPwKzbS76Ns1HeQh/Zw9ngovlrae+RY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-FHl-PstjPTW88Jh1G9wLfw-1; Fri, 17 Jul 2020 09:08:50 -0400
X-MC-Unique: FHl-PstjPTW88Jh1G9wLfw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CE59800465;
        Fri, 17 Jul 2020 13:08:49 +0000 (UTC)
Received: from [10.72.12.127] (ovpn-12-127.pek2.redhat.com [10.72.12.127])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 41CB761982;
        Fri, 17 Jul 2020 13:08:46 +0000 (UTC)
Subject: Re: [PATCH v6 1/2] ceph: periodically send perf metrics to ceph
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, zyan@redhat.com,
        pdonnell@redhat.com, vshankar@redhat.com
References: <20200716140558.5185-1-xiubli@redhat.com>
 <20200716140558.5185-2-xiubli@redhat.com>
 <fe0b6307eb3efe0d5cd8cbe87bde95d268cd7722.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <78a27a18-5aec-c957-17bd-b150b6dd3e25@redhat.com>
Date:   Fri, 17 Jul 2020 21:08:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <fe0b6307eb3efe0d5cd8cbe87bde95d268cd7722.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/7/17 19:24, Jeff Layton wrote:
> On Thu, 2020-07-16 at 10:05 -0400, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This will send the caps/read/write/metadata metrics to any available
>> MDS only once per second as default, which will be the same as the
>> userland client. It will skip the MDS sessions which don't support
>> the metric collection, or the MDSs will close the socket connections
>> directly when it get an unknown type message.
>>
>> We can disable the metric sending via the disable_send_metric module
>> parameter.
>>
>> URL: https://tracker.ceph.com/issues/43215
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c         |   4 +
>>   fs/ceph/mds_client.h         |   4 +-
>>   fs/ceph/metric.c             | 151 +++++++++++++++++++++++++++++++++++
>>   fs/ceph/metric.h             |  77 ++++++++++++++++++
>>   fs/ceph/super.c              |  42 ++++++++++
>>   fs/ceph/super.h              |   2 +
>>   include/linux/ceph/ceph_fs.h |   1 +
>>   7 files changed, 280 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 9a09d12569bd..cf4c2ba2311f 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -3334,6 +3334,8 @@ static void handle_session(struct ceph_mds_session *session,
>>   		session->s_state = CEPH_MDS_SESSION_OPEN;
>>   		session->s_features = features;
>>   		renewed_caps(mdsc, session, 0);
>> +		if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &session->s_features))
>> +			metric_schedule_delayed(&mdsc->metric);
>>   		wake = 1;
>>   		if (mdsc->stopping)
>>   			__close_session(mdsc, session);
>> @@ -4303,6 +4305,7 @@ bool check_session_state(struct ceph_mds_session *s)
>>   	}
>>   	if (s->s_state == CEPH_MDS_SESSION_NEW ||
>>   	    s->s_state == CEPH_MDS_SESSION_RESTARTING ||
>> +	    s->s_state == CEPH_MDS_SESSION_CLOSED  ||
> ^^^
> Is this an independent bugfix that should be a standalone patch?
>
Yeah, it makes sense.

Thanks Jeff.


>

