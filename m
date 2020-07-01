Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15EE8210383
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Jul 2020 07:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgGAF7U (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Jul 2020 01:59:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46596 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725272AbgGAF7U (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 1 Jul 2020 01:59:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593583158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QDvXB4iKWOO1DqTB/daTFn30lEzv7uLdGIwKV4LkAaI=;
        b=eb7jGOgmIT0nvKqiL7KY5C9nz3SE4Z2hC+YTwUe1kohdB3x4Db+4AwZEf3OXjVeCAkLPFy
        AFz8Yy6CwLiDSkRy0iL8eZyW4/n3GpNMtk0on1jEqZCiEWlh07sUVdCHtQ4aT52h9AEkXt
        nO8VVfIbHiAkn+eWBTdwqTnDaplTgCU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-rtDnTnDXMASO-wihfAEw5g-1; Wed, 01 Jul 2020 01:59:16 -0400
X-MC-Unique: rtDnTnDXMASO-wihfAEw5g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D081800C64;
        Wed,  1 Jul 2020 05:59:15 +0000 (UTC)
Received: from [10.72.12.116] (ovpn-12-116.pek2.redhat.com [10.72.12.116])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DAB8DB3A8B;
        Wed,  1 Jul 2020 05:59:12 +0000 (UTC)
Subject: Re: [PATCH v5 3/5] ceph: periodically send perf metrics to ceph
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <1593503539-1209-1-git-send-email-xiubli@redhat.com>
 <1593503539-1209-4-git-send-email-xiubli@redhat.com>
 <9dd552093a9779589f5bbcc500a3321d20fb0193.camel@kernel.org>
 <83f0d842-6b56-f0aa-be29-54b0ccfb952c@redhat.com>
 <c105252fed58e294e615dadb3c4f5bf1acf2f974.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b6b3479b-d952-c380-e6ba-dc72d7a7deed@redhat.com>
Date:   Wed, 1 Jul 2020 13:59:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <c105252fed58e294e615dadb3c4f5bf1acf2f974.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/6/30 22:28, Jeff Layton wrote:
> On Tue, 2020-06-30 at 20:14 +0800, Xiubo Li wrote:
>> On 2020/6/30 19:29, Jeff Layton wrote:
>>> On Tue, 2020-06-30 at 03:52 -0400, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> This will send the caps/read/write/metadata metrics to any available
>>>> MDS only once per second as default, which will be the same as the
>>>> userland client. It will skip the MDS sessions which don't support
>>>> the metric collection, or the MDSs will close the socket connections
>>>> directly when it get an unknown type message.
>>>>
>> [...]
>>
>>>> +static struct ceph_mds_session *metric_get_session(struct ceph_mds_client *mdsc)
>>>> +{
>>>> +	struct ceph_mds_session *s;
>>>> +	int i;
>>>> +
>>>> +	mutex_lock(&mdsc->mutex);
>>>> +	for (i = 0; i < mdsc->max_sessions; i++) {
>>>> +		s = __ceph_lookup_mds_session(mdsc, i);
>>>> +		if (!s)
>>>> +			continue;
>>>> +		mutex_unlock(&mdsc->mutex);
>>>> +
>>> Why unlock here? AFAICT, it's safe to call ceph_put_mds_session with the
>>> mdsc->mutex held.
>> Yeah, it is. Just wanted to make the critical section as small as
>> possible. And the following code no need the lock.
>>
>> Compared to the mutex lock acquisition is very expensive, we might not
>> benefit much from the smaller critical section.
>>
>> I will fix it.
>>
> Generally small critical sections are preferred, but almost all of these
> are in-memory operations. None of that should sleep, so we're almost
> certainly better off with less lock thrashing. If the lock isn't
> contended, then no harm is done. If it is, then we're better off not
> letting the cacheline bounce.

Agree.


>
>
>>>> +		/*
>>>> +		 * Skip it if MDS doesn't support the metric collection,
>>>> +		 * or the MDS will close the session's socket connection
>>>> +		 * directly when it get this message.
>>>> +		 */
>>>> +		if (check_session_state(s) &&
>>>> +		    test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &s->s_features)) {
>>>> +			mdsc->metric.mds = i;
>>>> +			return s;
>>>> +		}
>>>> +		ceph_put_mds_session(s);
>>>> +
>>>> +		mutex_lock(&mdsc->mutex);
>>>> +	}
>>>> +	mutex_unlock(&mdsc->mutex);
>>>> +
>>>> +	return NULL;
>>>> +}
>>>> +
>>>> +static void metric_delayed_work(struct work_struct *work)
>>>> +{
>>>> +	struct ceph_client_metric *m =
>>>> +		container_of(work, struct ceph_client_metric, delayed_work.work);
>>>> +	struct ceph_mds_client *mdsc =
>>>> +		container_of(m, struct ceph_mds_client, metric);
>>>> +	struct ceph_mds_session *s = NULL;
>>>> +	u64 nr_caps = atomic64_read(&m->total_caps);
>>>> +
>>>> +	/* No mds supports the metric collection, will stop the work */
>>>> +	if (!atomic_read(&m->mds_cnt))
>>>> +		return;
>>>> +
>>>> +	mutex_lock(&mdsc->mutex);
>>>> +	s = __ceph_lookup_mds_session(mdsc, m->mds);
>>>> +	mutex_unlock(&mdsc->mutex);
>>> Instead of doing a lookup of the mds every time we need to do this,
>>> would it be better to instead just do a lookup before you first schedule
>>> the work and keep a reference to it until the session state is no longer
>>> good?
>>>
>>> With that, you'd only need to take the mutex here if check_session_state
>>> indicated that the session you had saved was no longer good.
>> This sounds very cool and with this we can get rid of the mutex lock in
>> normal case.
>>
> Yeah. I think the code could be simplified the code in other ways too.
>
> You have per-mdsc work now, so there's no problem scheduling the work
> more than once. You can just schedule it any time you get a new session
> that has the feature flag set.
>
> Keep a metrics session pointer in the mdsc->metric, and start with it
> set to NULL. When the work runs, do a lookup if the pointer is NULL or
> if the current one isn't valid any more. At the end, only reschedule the
> work if we found a suitable session.
>
> That should eliminate the need for the mdsc.metric->mds_cnt counter.
Yeah, this is almost the same with what I did but still with the 
mds_cnt, and I will try to
get rid of it.

Thanks


>>>> +	if (unlikely(!s || !check_session_state(s) ||
>>>> +	    !test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &s->s_features)))
>>>> +		s = metric_get_session(mdsc);
>>>> +
>>> If we do need to keep doing a lookup every time, then it'd probably be
>>> better to do the above check while holding the mdsc->mutex and just have
>>> metric_get_session expect to be called with the mutex already held.
>>>
>>> FWIW, mutexes are expensive locks since you can end up having to
>>> schedule() if you can't get it. Minimizing the number of acquisitions
>>> and simply holding them for a little longer is often the more efficient
>>> approach.
>> Okay, will do that.
>>
>> [...]
>>
>>>>    
>>>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>>>> index c9784eb1..cd33836 100644
>>>> --- a/fs/ceph/super.c
>>>> +++ b/fs/ceph/super.c
>>>> @@ -27,6 +27,9 @@
>>>>    #include <linux/ceph/auth.h>
>>>>    #include <linux/ceph/debugfs.h>
>>>>    
>>>> +static DEFINE_MUTEX(ceph_fsc_lock);
>>> I think this could be a spinlock. None of the operations it protects
>>> look like they can sleep.
>> Will fix it.
>>
>> Thanks.
>>
>>

