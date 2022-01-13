Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0CC48D829
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Jan 2022 13:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbiAMMn2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Jan 2022 07:43:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51256 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234659AbiAMMn1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 07:43:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642077807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iylKHGb+CQQYWFW0nViwKNPHa0m9jp4K1ksrerssKik=;
        b=dm2J5hYdE+GgX0zVshFQNfv1nxdMbKX/d6mBX6t/Y/rQfV/pj1CKBNYTpT90GlyNye8kTy
        e2bb0EaBpt44Wlix44bzMOkGvLkbV8xM51oyobZM3US+Z/F2LMOeKzKD+eGodUj5jP6izi
        zH+cdERhHsAIxMyzAdsEorXWaKiYsxo=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-vhRKgkxVP7i5j3m19lv2bw-1; Thu, 13 Jan 2022 07:43:25 -0500
X-MC-Unique: vhRKgkxVP7i5j3m19lv2bw-1
Received: by mail-pj1-f71.google.com with SMTP id x14-20020a17090a8a8e00b001b3b14c53afso6747030pjn.6
        for <ceph-devel@vger.kernel.org>; Thu, 13 Jan 2022 04:43:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=iylKHGb+CQQYWFW0nViwKNPHa0m9jp4K1ksrerssKik=;
        b=26ryPNfDrN8IAGdINdlpuii53t2KrRg78m72HU1WNXUxJhRO4t42RPbPro9o0VGxOU
         ZAVzRj/NbVI6H0z1M0f3xtKb9uykuks+9iMSkX/WcNq1CMkoC07TuDOSKdrte4UMtxPp
         y5WwefodslqsPygEf42sl2RW/UdzjBGHaJvTmlgyQBUmdfZIYEvRB+mp839rzTh9kFw4
         xKPOZCyfTHVESwi52n7vgy6N4vC/SwcKb3idUVfUed59At2KPOuisAWGNQ+niVyb7oxw
         +qdGG+tw6vfDDGZLubC+a184Wk7Dt0/ML/MCD7d+sZyjrmLiKjb0+qyWCeH3jLx1xZLi
         Uzwg==
X-Gm-Message-State: AOAM531yhR7p2IoMZtTvcj5tadOJ+AbjxPpT4ew4unigM4Dk4p7Of6m1
        Dd7F2HwqpPha7cnMqzBx9NsW1CaMULApq6LUX7kGku/hbbY6QcOFBbLDIA8Rbrd1UcDFpVoVxJr
        OpsRDM0X+eI6J5q1+cG52/3X35EjONlHmQ/IyegqwUBakZ1btBdMVC4Z8bmW7x0z9Sc8wpAY=
X-Received: by 2002:a17:90b:1892:: with SMTP id mn18mr14463911pjb.60.1642077804216;
        Thu, 13 Jan 2022 04:43:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw05vrf6kFT+Imwn+4E64Gi58OIygEd9BS8bXX3kfz38WxQZMcFJZnxM7gir5X2/nVuMlrmOg==
X-Received: by 2002:a17:90b:1892:: with SMTP id mn18mr14463874pjb.60.1642077803779;
        Thu, 13 Jan 2022 04:43:23 -0800 (PST)
Received: from [10.72.12.73] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q4sm2904058pfj.84.2022.01.13.04.43.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jan 2022 04:43:23 -0800 (PST)
Subject: Re: [PATCH] ceph: put the requests/sessions when it fails to alloc
 memory
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220112042904.8557-1-xiubli@redhat.com>
 <97635942aaf34c5b2f3a18b3fef92ff0950c2127.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <4c81eda9-c177-4c5f-28f9-07bfacc82d96@redhat.com>
Date:   Thu, 13 Jan 2022 20:43:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <97635942aaf34c5b2f3a18b3fef92ff0950c2127.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 1/13/22 7:01 PM, Jeff Layton wrote:
> On Wed, 2022-01-12 at 12:29 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When failing to allocate the sessions memory we should make sure
>> the req1 and req2 and the sessions get put. And also in case the
>> max_sessions decreased so when kreallocate the new memory some
>> sessions maybe missed being put.
>>
>> And if the max_sessions is 0 krealloc will return ZERO_SIZE_PTR,
>> which will lead to a distinct access fault.
>>
>> URL: https://tracker.ceph.com/issues/53819
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> Fixes: e1a4541ec0b9 ("ceph: flush the mdlog before waiting on unsafe reqs")
>> ---
>>   fs/ceph/caps.c | 55 +++++++++++++++++++++++++++++++++-----------------
>>   1 file changed, 37 insertions(+), 18 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 944b18b4e217..5c2719f66f62 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -2276,6 +2276,7 @@ static int unsafe_request_wait(struct inode *inode)
>>   	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>>   	struct ceph_mds_request *req1 = NULL, *req2 = NULL;
>> +	unsigned int max_sessions;
>>   	int ret, err = 0;
>>   
>>   	spin_lock(&ci->i_unsafe_lock);
>> @@ -2293,37 +2294,45 @@ static int unsafe_request_wait(struct inode *inode)
>>   	}
>>   	spin_unlock(&ci->i_unsafe_lock);
>>   
>> +	/*
>> +	 * The mdsc->max_sessions is unlikely to be changed
>> +	 * mostly, here we will retry it by reallocating the
>> +	 * sessions arrary memory to get rid of the mdsc->mutex
>> +	 * lock.
>> +	 */
>> +retry:
>> +	max_sessions = mdsc->max_sessions;
>> +
>>   	/*
>>   	 * Trigger to flush the journal logs in all the relevant MDSes
>>   	 * manually, or in the worst case we must wait at most 5 seconds
>>   	 * to wait the journal logs to be flushed by the MDSes periodically.
>>   	 */
>> -	if (req1 || req2) {
>> +	if ((req1 || req2) && likely(max_sessions)) {
>>   		struct ceph_mds_session **sessions = NULL;
>>   		struct ceph_mds_session *s;
>>   		struct ceph_mds_request *req;
>> -		unsigned int max;
>>   		int i;
>>   
>> -		/*
>> -		 * The mdsc->max_sessions is unlikely to be changed
>> -		 * mostly, here we will retry it by reallocating the
>> -		 * sessions arrary memory to get rid of the mdsc->mutex
>> -		 * lock.
>> -		 */
>> -retry:
>> -		max = mdsc->max_sessions;
>> -		sessions = krealloc(sessions, max * sizeof(s), __GFP_ZERO);
>> -		if (!sessions)
>> -			return -ENOMEM;
>> +		sessions = kzalloc(max_sessions * sizeof(s), GFP_KERNEL);
>> +		if (!sessions) {
>> +			err = -ENOMEM;
>> +			goto out;
>> +		}
>>   
>>   		spin_lock(&ci->i_unsafe_lock);
>>   		if (req1) {
>>   			list_for_each_entry(req, &ci->i_unsafe_dirops,
>>   					    r_unsafe_dir_item) {
>>   				s = req->r_session;
>> -				if (unlikely(s->s_mds >= max)) {
>> +				if (unlikely(s->s_mds >= max_sessions)) {
>>   					spin_unlock(&ci->i_unsafe_lock);
>> +					for (i = 0; i < max_sessions; i++) {
>> +						s = sessions[i];
>> +						if (s)
>> +							ceph_put_mds_session(s);
>> +					}
>> +					kfree(sessions);
>>   					goto retry;
>>   				}
>>   				if (!sessions[s->s_mds]) {
>> @@ -2336,8 +2345,14 @@ static int unsafe_request_wait(struct inode *inode)
>>   			list_for_each_entry(req, &ci->i_unsafe_iops,
>>   					    r_unsafe_target_item) {
>>   				s = req->r_session;
>> -				if (unlikely(s->s_mds >= max)) {
>> +				if (unlikely(s->s_mds >= max_sessions)) {
>>   					spin_unlock(&ci->i_unsafe_lock);
>> +					for (i = 0; i < max_sessions; i++) {
>> +						s = sessions[i];
>> +						if (s)
>> +							ceph_put_mds_session(s);
>> +					}
>> +					kfree(sessions);
>>   					goto retry;
>>   				}
>>   				if (!sessions[s->s_mds]) {
>> @@ -2358,7 +2373,7 @@ static int unsafe_request_wait(struct inode *inode)
>>   		spin_unlock(&ci->i_ceph_lock);
>>   
>>   		/* send flush mdlog request to MDSes */
>> -		for (i = 0; i < max; i++) {
>> +		for (i = 0; i < max_sessions; i++) {
>>   			s = sessions[i];
>>   			if (s) {
>>   				send_flush_mdlog(s);
>> @@ -2375,15 +2390,19 @@ static int unsafe_request_wait(struct inode *inode)
>>   					ceph_timeout_jiffies(req1->r_timeout));
>>   		if (ret)
>>   			err = -EIO;
>> -		ceph_mdsc_put_request(req1);
>>   	}
>>   	if (req2) {
>>   		ret = !wait_for_completion_timeout(&req2->r_safe_completion,
>>   					ceph_timeout_jiffies(req2->r_timeout));
>>   		if (ret)
>>   			err = -EIO;
>> -		ceph_mdsc_put_request(req2);
>>   	}
>> +
>> +out:
>> +	if (req1)
>> +		ceph_mdsc_put_request(req1);
>> +	if (req2)
>> +		ceph_mdsc_put_request(req2);
>>   	return err;
>>   }
>>   
> Looks good. I fixed up the minor spelling error in the comment that
> Venky noticed too. Merged into testing branch.

Okay, thanks Venky and Jeff.


>
> Thanks,

