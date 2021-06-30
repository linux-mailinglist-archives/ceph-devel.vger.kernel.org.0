Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236793B7B25
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Jun 2021 02:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhF3A6O (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 20:58:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43436 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229564AbhF3A6O (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 20:58:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625014546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J/NED8fD+0kcwMRJHty+XmHTtM+cMtfcDsr/vBPC7hc=;
        b=DzvgSTon32eRwzwOjGTqGw/68JXpye8YeUK1Z66jsTIhixvWhCqhJBLlW5Jb2jS54uv11C
        AlDM1rvjgUA53/SNh/xy7ppZYs+wI8wqgGlfXYkCgJk8Lr7HTL+ddXzi1++ljGOGLUXtIQ
        GhMHyxYOjA9ov7IBXSkX43pfrmZcSPg=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-RBSuWfvoOEmMZZSCFNucVQ-1; Tue, 29 Jun 2021 20:55:45 -0400
X-MC-Unique: RBSuWfvoOEmMZZSCFNucVQ-1
Received: by mail-pj1-f69.google.com with SMTP id bx13-20020a17090af48db029016fb6fa83beso2837472pjb.3
        for <ceph-devel@vger.kernel.org>; Tue, 29 Jun 2021 17:55:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=J/NED8fD+0kcwMRJHty+XmHTtM+cMtfcDsr/vBPC7hc=;
        b=N+M5U6JWb4O+6I+jccngOtU1+hIsS3mNylvIgogqwivS174/Zg17hT84UDAZxKwjw/
         OYHvQMgPRxE7jy3RXsGxARsUGQs2+8fYYWtlzjzmyLSRjiEEnCAEBNZh+d59wwQI6n6r
         eGMM3juSnLmRXfXlti2oTte8973fnxaNE7PDOMfWiPWXZ+RyRuarKH6IaBi1aZ/HGKAF
         yUbiW80pys0xMaaWZQ5pp5UWkpEaGWfZalXxWEdBWhrri/n9VhXoqq6Nha3+4ZyWp9yY
         Y94lrXDZcNfLC0KR91LLuQjOB/UpEnoSRx6n6ei7D6AceBuVVfd4tH68L4ZnCHG6aCSq
         6j5g==
X-Gm-Message-State: AOAM533F6zGDnl7VZRw8e8vFQjVoY1WWPsIqXQzLa9KLsofKjtKgQXPW
        a0ote/N4AvqCbLqMAgiCpfHUJoxmCyBROnFgyltqbx8h3drpoUuzPl7aTprgNXoviH9eI+rx/TI
        bN06QrdwqpcJ4E3tlnzzvzvfjcHKZU2BIj5JQNUMwQgdXkvB5neO7a5gVctMH8slZOciIg+A=
X-Received: by 2002:a17:90b:3104:: with SMTP id gc4mr1630648pjb.182.1625014543926;
        Tue, 29 Jun 2021 17:55:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxhcfHgqUXP/JBv2UD1VkX1nZq+b9IxFDxioTbBYHg57Q/W8l2CPezWgwtka7KFlJbLkXGyGw==
X-Received: by 2002:a17:90b:3104:: with SMTP id gc4mr1630633pjb.182.1625014543697;
        Tue, 29 Jun 2021 17:55:43 -0700 (PDT)
Received: from [10.72.12.103] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t17sm4579686pji.34.2021.06.29.17.55.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 17:55:43 -0700 (PDT)
Subject: Re: [PATCH 2/5] ceph: export iterate_sessions
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210629044241.30359-1-xiubli@redhat.com>
 <20210629044241.30359-3-xiubli@redhat.com>
 <0d114802ce33ec63fa4ef09053e31d410de194d4.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <64b0b2e6-ccbd-4c16-2243-3ad99605f1b4@redhat.com>
Date:   Wed, 30 Jun 2021 08:55:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <0d114802ce33ec63fa4ef09053e31d410de194d4.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/29/21 11:39 PM, Jeff Layton wrote:
> On Tue, 2021-06-29 at 12:42 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c       | 26 +-----------------------
>>   fs/ceph/mds_client.c | 47 +++++++++++++++++++++++++++++---------------
>>   fs/ceph/mds_client.h |  3 +++
>>   3 files changed, 35 insertions(+), 41 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index e712826ea3f1..c6a3352a4d52 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -4280,33 +4280,9 @@ static void flush_dirty_session_caps(struct ceph_mds_session *s)
>>   	dout("flush_dirty_caps done\n");
>>   }
>>   
>> -static void iterate_sessions(struct ceph_mds_client *mdsc,
>> -			     void (*cb)(struct ceph_mds_session *))
>> -{
>> -	int mds;
>> -
>> -	mutex_lock(&mdsc->mutex);
>> -	for (mds = 0; mds < mdsc->max_sessions; ++mds) {
>> -		struct ceph_mds_session *s;
>> -
>> -		if (!mdsc->sessions[mds])
>> -			continue;
>> -
>> -		s = ceph_get_mds_session(mdsc->sessions[mds]);
>> -		if (!s)
>> -			continue;
>> -
>> -		mutex_unlock(&mdsc->mutex);
>> -		cb(s);
>> -		ceph_put_mds_session(s);
>> -		mutex_lock(&mdsc->mutex);
>> -	}
>> -	mutex_unlock(&mdsc->mutex);
>> -}
>> -
>>   void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc)
>>   {
>> -	iterate_sessions(mdsc, flush_dirty_session_caps);
>> +	ceph_mdsc_iterate_sessions(mdsc, flush_dirty_session_caps, true);
>>   }
>>   
>>   void __ceph_touch_fmode(struct ceph_inode_info *ci,
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index e49d3e230712..96bef289f58f 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -802,6 +802,33 @@ static void put_request_session(struct ceph_mds_request *req)
>>   	}
>>   }
>>   
>> +void ceph_mdsc_iterate_sessions(struct ceph_mds_client *mdsc,
>> +			       void (*cb)(struct ceph_mds_session *),
>> +			       bool check_state)
>> +{
>> +	int mds;
>> +
>> +	mutex_lock(&mdsc->mutex);
>> +	for (mds = 0; mds < mdsc->max_sessions; ++mds) {
>> +		struct ceph_mds_session *s;
>> +
>> +		s = __ceph_lookup_mds_session(mdsc, mds);
>> +		if (!s)
>> +			continue;
>> +
>> +		if (check_state && !check_session_state(s)) {
>> +			ceph_put_mds_session(s);
>> +			continue;
>> +		}
>> +
>> +		mutex_unlock(&mdsc->mutex);
>> +		cb(s);
>> +		ceph_put_mds_session(s);
>> +		mutex_lock(&mdsc->mutex);
>> +	}
>> +	mutex_unlock(&mdsc->mutex);
>> +}
>> +
>>   void ceph_mdsc_release_request(struct kref *kref)
>>   {
>>   	struct ceph_mds_request *req = container_of(kref,
>> @@ -4416,22 +4443,10 @@ void ceph_mdsc_lease_send_msg(struct ceph_mds_session *session,
>>   /*
>>    * lock unlock sessions, to wait ongoing session activities
>>    */
>> -static void lock_unlock_sessions(struct ceph_mds_client *mdsc)
>> +static void lock_unlock_session(struct ceph_mds_session *s)
>>   {
>> -	int i;
>> -
>> -	mutex_lock(&mdsc->mutex);
>> -	for (i = 0; i < mdsc->max_sessions; i++) {
>> -		struct ceph_mds_session *s = __ceph_lookup_mds_session(mdsc, i);
>> -		if (!s)
>> -			continue;
>> -		mutex_unlock(&mdsc->mutex);
>> -		mutex_lock(&s->s_mutex);
>> -		mutex_unlock(&s->s_mutex);
>> -		ceph_put_mds_session(s);
>> -		mutex_lock(&mdsc->mutex);
>> -	}
>> -	mutex_unlock(&mdsc->mutex);
>> +	mutex_lock(&s->s_mutex);
>> +	mutex_unlock(&s->s_mutex);
>>   }
>>   
> Your patch doesn't materially change this, but it sure would be nice to
> know what purpose this lock/unlock garbage serves. Barf.

Yeah, it just simplify the code.

I will add some comments about it.


>
>>   static void maybe_recover_session(struct ceph_mds_client *mdsc)
>> @@ -4683,7 +4698,7 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
>>   	dout("pre_umount\n");
>>   	mdsc->stopping = 1;
>>   
>> -	lock_unlock_sessions(mdsc);
>> +	ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
>>   	ceph_flush_dirty_caps(mdsc);
>>   	wait_requests(mdsc);
>>   
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index bf2683f0ba43..fca2cf427eaf 100644
>> --- a/fs/ceph/mds_client.h
>> +++ b/fs/ceph/mds_client.h
>> @@ -523,6 +523,9 @@ static inline void ceph_mdsc_put_request(struct ceph_mds_request *req)
>>   	kref_put(&req->r_kref, ceph_mdsc_release_request);
>>   }
>>   
>> +extern void ceph_mdsc_iterate_sessions(struct ceph_mds_client *mdsc,
>> +				       void (*cb)(struct ceph_mds_session *),
>> +				       bool check_state);
>>   extern struct ceph_msg *ceph_create_session_msg(u32 op, u64 seq);
>>   extern void __ceph_queue_cap_release(struct ceph_mds_session *session,
>>   				    struct ceph_cap *cap);
> Again, not really exporting this function, so maybe reword the subject
> line?
Sure, will fix it.
> Thanks,

