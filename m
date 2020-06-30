Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1349A20F454
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jun 2020 14:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387551AbgF3MPB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Jun 2020 08:15:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23560 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387552AbgF3MPA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 Jun 2020 08:15:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593519298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i9Ndu/JVhjkEAOJ/101MDsu4NV6LSp9FnrSpY1Czh+o=;
        b=hGVtY3H4ckq1qSv8USzPrutC/uelKyDpSPoVK3d6dDRRl88M0sh8SD/KiZ6+rh9DqTpLxA
        MlEXqQbE+62YQxHc3SmOddueMOV2Ce2ijoh109psNhJARKLLzDF01R3+mrBy67Ajva05Vk
        4qHVY/90Y41bJy1VWJJlAWMg5IlG3yw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-Wn9HFtGhNIibJIq3JVw66w-1; Tue, 30 Jun 2020 08:14:54 -0400
X-MC-Unique: Wn9HFtGhNIibJIq3JVw66w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D429A1005513;
        Tue, 30 Jun 2020 12:14:52 +0000 (UTC)
Received: from [10.72.13.235] (ovpn-13-235.pek2.redhat.com [10.72.13.235])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B220B19C4F;
        Tue, 30 Jun 2020 12:14:50 +0000 (UTC)
Subject: Re: [PATCH v5 3/5] ceph: periodically send perf metrics to ceph
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <1593503539-1209-1-git-send-email-xiubli@redhat.com>
 <1593503539-1209-4-git-send-email-xiubli@redhat.com>
 <9dd552093a9779589f5bbcc500a3321d20fb0193.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <83f0d842-6b56-f0aa-be29-54b0ccfb952c@redhat.com>
Date:   Tue, 30 Jun 2020 20:14:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <9dd552093a9779589f5bbcc500a3321d20fb0193.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/6/30 19:29, Jeff Layton wrote:
> On Tue, 2020-06-30 at 03:52 -0400, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This will send the caps/read/write/metadata metrics to any available
>> MDS only once per second as default, which will be the same as the
>> userland client. It will skip the MDS sessions which don't support
>> the metric collection, or the MDSs will close the socket connections
>> directly when it get an unknown type message.
>>

[...]

>> +static struct ceph_mds_session *metric_get_session(struct ceph_mds_client *mdsc)
>> +{
>> +	struct ceph_mds_session *s;
>> +	int i;
>> +
>> +	mutex_lock(&mdsc->mutex);
>> +	for (i = 0; i < mdsc->max_sessions; i++) {
>> +		s = __ceph_lookup_mds_session(mdsc, i);
>> +		if (!s)
>> +			continue;
>> +		mutex_unlock(&mdsc->mutex);
>> +
> Why unlock here? AFAICT, it's safe to call ceph_put_mds_session with the
> mdsc->mutex held.

Yeah, it is. Just wanted to make the critical section as small as 
possible. And the following code no need the lock.

Compared to the mutex lock acquisition is very expensive, we might not 
benefit much from the smaller critical section.

I will fix it.

>
>> +		/*
>> +		 * Skip it if MDS doesn't support the metric collection,
>> +		 * or the MDS will close the session's socket connection
>> +		 * directly when it get this message.
>> +		 */
>> +		if (check_session_state(s) &&
>> +		    test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &s->s_features)) {
>> +			mdsc->metric.mds = i;
>> +			return s;
>> +		}
>> +		ceph_put_mds_session(s);
>> +
>> +		mutex_lock(&mdsc->mutex);
>> +	}
>> +	mutex_unlock(&mdsc->mutex);
>> +
>> +	return NULL;
>> +}
>> +
>> +static void metric_delayed_work(struct work_struct *work)
>> +{
>> +	struct ceph_client_metric *m =
>> +		container_of(work, struct ceph_client_metric, delayed_work.work);
>> +	struct ceph_mds_client *mdsc =
>> +		container_of(m, struct ceph_mds_client, metric);
>> +	struct ceph_mds_session *s = NULL;
>> +	u64 nr_caps = atomic64_read(&m->total_caps);
>> +
>> +	/* No mds supports the metric collection, will stop the work */
>> +	if (!atomic_read(&m->mds_cnt))
>> +		return;
>> +
>> +	mutex_lock(&mdsc->mutex);
>> +	s = __ceph_lookup_mds_session(mdsc, m->mds);
>> +	mutex_unlock(&mdsc->mutex);
>
> Instead of doing a lookup of the mds every time we need to do this,
> would it be better to instead just do a lookup before you first schedule
> the work and keep a reference to it until the session state is no longer
> good?
>
> With that, you'd only need to take the mutex here if check_session_state
> indicated that the session you had saved was no longer good.

This sounds very cool and with this we can get rid of the mutex lock in 
normal case.


>
>> +	if (unlikely(!s || !check_session_state(s) ||
>> +	    !test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &s->s_features)))
>> +		s = metric_get_session(mdsc);
>> +
> If we do need to keep doing a lookup every time, then it'd probably be
> better to do the above check while holding the mdsc->mutex and just have
> metric_get_session expect to be called with the mutex already held.
>
> FWIW, mutexes are expensive locks since you can end up having to
> schedule() if you can't get it. Minimizing the number of acquisitions
> and simply holding them for a little longer is often the more efficient
> approach.

Okay, will do that.

[...]

>
>>   
>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> index c9784eb1..cd33836 100644
>> --- a/fs/ceph/super.c
>> +++ b/fs/ceph/super.c
>> @@ -27,6 +27,9 @@
>>   #include <linux/ceph/auth.h>
>>   #include <linux/ceph/debugfs.h>
>>   
>> +static DEFINE_MUTEX(ceph_fsc_lock);
> I think this could be a spinlock. None of the operations it protects
> look like they can sleep.

Will fix it.

Thanks.


