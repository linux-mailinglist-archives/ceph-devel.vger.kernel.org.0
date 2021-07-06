Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2EAC3BD6B8
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jul 2021 14:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbhGFMoN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jul 2021 08:44:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44537 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241986AbhGFMkY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jul 2021 08:40:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625575065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AhGSAgy3BcnNBAUCzHJ0PLSkejiM0xWWdVhc6I3Fob0=;
        b=i0U58FKgIdNJv3D9MwFKG2k92+gelUD2f+MlXOBtEyCL0znt9a68ZyAnG648lKEpw+WJol
        KQ0+EFCIHiTlNcLj9G6C6qQhKiahYJQ1RlmuW4Ozd1yLLszrCy2Umh0dv3z/RvFc6GgC5g
        bjVP1dYe/Et23v6+4TxyK2bei59BhHU=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-ngZXYbQYMFuZXFZLJcdF_Q-1; Tue, 06 Jul 2021 08:37:44 -0400
X-MC-Unique: ngZXYbQYMFuZXFZLJcdF_Q-1
Received: by mail-pl1-f198.google.com with SMTP id b2-20020a1709027e02b0290128e572ee46so7248319plm.3
        for <ceph-devel@vger.kernel.org>; Tue, 06 Jul 2021 05:37:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=AhGSAgy3BcnNBAUCzHJ0PLSkejiM0xWWdVhc6I3Fob0=;
        b=NCJRrVGNyBVdLrgxRbFIRN4i+iRebp9nN1QD6+x64IR+e5FVTXeFw0k+xB4P1HX1mb
         6NjbQ4aln3uWmkLksfXSBoPrHXrd8f96l1zGctmbB4ynF3bY67V5Zu//Dp2TRNLVfYLO
         P9oeJfVWGrzdBWK/tqDKP7MRw0vs+UYrKp/VfCGhj/rneIbMhs2j6+VEfh9wqe5smt6C
         6DJhfXcOIniwOZ4C2VBif40U2aWkU3YNfBv8mOh+okSdDiYUKg8WOjsW8MXfBjLqKPkQ
         xzw7ntzS4HS9v5PbPG0JPWrhMTuSyDOuwvUb7u/Yr/E6NHEzEK2AYssDCIsi2KX9Jc79
         4iYw==
X-Gm-Message-State: AOAM532V9L5cxSIHGDA7+ORhIMfZhx+LYmT3q17v2L4T9TM02Hex+Vsm
        nKq+N+woMtPXiAMuvwDvgWbUdnA4hdS5VKbkfzM62DFgWQBkAI8chqpcYdCRZPL1GyeCIZNg27y
        3yy3Fde0kDztEPgcvuaDN6d0yND4WUcJ6ZEMXaAc8H1m6KRHVIg75yFdD9ayoT5K5CIl+J88=
X-Received: by 2002:a63:f516:: with SMTP id w22mr20913666pgh.188.1625575062997;
        Tue, 06 Jul 2021 05:37:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEH0mKXyNDZuq8C0WtsiZCgjt9Zv+sl5VUIx73lpaDp5nNtsck9KHmHGuVerFeTODNi4C6IA==
X-Received: by 2002:a63:f516:: with SMTP id w22mr20913640pgh.188.1625575062620;
        Tue, 06 Jul 2021 05:37:42 -0700 (PDT)
Received: from [10.72.13.230] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x26sm369185pfu.37.2021.07.06.05.37.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 05:37:42 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] ceph: flush the mdlog before waiting on unsafe
 reqs
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210705012257.182669-1-xiubli@redhat.com>
 <20210705012257.182669-5-xiubli@redhat.com>
 <60e6a0d99abe921232b6cb4b9ce5e31272a06790.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b6e463c2-6b51-81ce-ee90-36e48e77110b@redhat.com>
Date:   Tue, 6 Jul 2021 20:37:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <60e6a0d99abe921232b6cb4b9ce5e31272a06790.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/6/21 7:42 PM, Jeff Layton wrote:
> On Mon, 2021-07-05 at 09:22 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> For the client requests who will have unsafe and safe replies from
>> MDS daemons, in the MDS side the MDS daemons won't flush the mdlog
>> (journal log) immediatelly, because they think it's unnecessary.
>> That's true for most cases but not all, likes the fsync request.
>> The fsync will wait until all the unsafe replied requests to be
>> safely replied.
>>
>> Normally if there have multiple threads or clients are running, the
>> whole mdlog in MDS daemons could be flushed in time if any request
>> will trigger the mdlog submit thread. So usually we won't experience
>> the normal operations will stuck for a long time. But in case there
>> has only one client with only thread is running, the stuck phenomenon
>> maybe obvious and the worst case it must wait at most 5 seconds to
>> wait the mdlog to be flushed by the MDS's tick thread periodically.
>>
>> This patch will trigger to flush the mdlog in the relevant and auth
>> MDSes to which the in-flight requests are sent just before waiting
>> the unsafe requests to finish.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 78 insertions(+)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index c6a3352a4d52..4b966c29d9b5 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -2286,6 +2286,7 @@ static int caps_are_flushed(struct inode *inode, u64 flush_tid)
>>    */
>>   static int unsafe_request_wait(struct inode *inode)
>>   {
>> +	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>>   	struct ceph_mds_request *req1 = NULL, *req2 = NULL;
>>   	int ret, err = 0;
>> @@ -2305,6 +2306,82 @@ static int unsafe_request_wait(struct inode *inode)
>>   	}
>>   	spin_unlock(&ci->i_unsafe_lock);
>>   
>> +	/*
>> +	 * Trigger to flush the journal logs in all the relevant MDSes
>> +	 * manually, or in the worst case we must wait at most 5 seconds
>> +	 * to wait the journal logs to be flushed by the MDSes periodically.
>> +	 */
>> +	if (req1 || req2) {
>> +		struct ceph_mds_session **sessions = NULL;
>> +		struct ceph_mds_session *s;
>> +		struct ceph_mds_request *req;
>> +		unsigned int max;
>> +		int i;
>> +
>> +		/*
>> +		 * The mdsc->max_sessions is unlikely to be changed
>> +		 * mostly, here we will retry it by reallocating the
>> +		 * sessions arrary memory to get rid of the mdsc->mutex
>> +		 * lock.
>> +		 */
>> +retry:
>> +		max = mdsc->max_sessions;
>> +		sessions = krealloc(sessions, max * sizeof(s), __GFP_ZERO);
> The kerneldoc over krealloc() says:
>
>   * The contents of the object pointed to are preserved up to the
>   * lesser of the new and old sizes (__GFP_ZERO flag is effectively
> ignored).
>
> This code however relies on krealloc zeroing out the new part of the
> allocation. Do you know for certain that that works?

I readed the krealloc() code, the "__GFP_ZERO flag will be ignored" only 
for the preserved contents. If the slab really needs to allocate a new 
object, the slab will help zero it first and then copy the old contents 
to it, the new part will keep zeroed.


>> +		if (!sessions) {
>> +			err = -ENOMEM;
>> +			goto out;
>> +		}
>> +		spin_lock(&ci->i_unsafe_lock);
>> +		if (req1) {
>> +			list_for_each_entry(req, &ci->i_unsafe_dirops,
>> +					    r_unsafe_dir_item) {
>> +				s = req->r_session;
>> +				if (unlikely(s->s_mds > max)) {
>> +					spin_unlock(&ci->i_unsafe_lock);
>> +					goto retry;
>> +				}
>> +				if (!sessions[s->s_mds]) {
>> +					s = ceph_get_mds_session(s);
>> +					sessions[s->s_mds] = s;
> nit: maybe just do:
>
>      sessions[s->s_mds] = ceph_get_mds_session(s);

Then it will exceed 80 chars for this line. Should we ignore it here ?

Thanks.

>
>
>> +				}
>> +			}
>> +		}
>> +		if (req2) {
>> +			list_for_each_entry(req, &ci->i_unsafe_iops,
>> +					    r_unsafe_target_item) {
>> +				s = req->r_session;
>> +				if (unlikely(s->s_mds > max)) {
>> +					spin_unlock(&ci->i_unsafe_lock);
>> +					goto retry;
>> +				}
>> +				if (!sessions[s->s_mds]) {
>> +					s = ceph_get_mds_session(s);
>> +					sessions[s->s_mds] = s;
>> +				}
>> +			}
>> +		}
>> +		spin_unlock(&ci->i_unsafe_lock);
>> +
>> +		/* the auth MDS */
>> +		spin_lock(&ci->i_ceph_lock);
>> +		if (ci->i_auth_cap) {
>> +		      s = ci->i_auth_cap->session;
>> +		      if (!sessions[s->s_mds])
>> +			      sessions[s->s_mds] = ceph_get_mds_session(s);
>> +		}
>> +		spin_unlock(&ci->i_ceph_lock);
>> +
>> +		/* send flush mdlog request to MDSes */
>> +		for (i = 0; i < max; i++) {
>> +			s = sessions[i];
>> +			if (s) {
>> +				send_flush_mdlog(s);
>> +				ceph_put_mds_session(s);
>> +			}
>> +		}
>> +		kfree(sessions);
>> +	}
>> +
>>   	dout("unsafe_request_wait %p wait on tid %llu %llu\n",
>>   	     inode, req1 ? req1->r_tid : 0ULL, req2 ? req2->r_tid : 0ULL);
>>   	if (req1) {
>> @@ -2321,6 +2398,7 @@ static int unsafe_request_wait(struct inode *inode)
>>   			err = -EIO;
>>   		ceph_mdsc_put_request(req2);
>>   	}
>> +out:
>>   	return err;
>>   }
>>   
> Otherwise the whole set looks pretty reasonable.
>
> Thanks,

