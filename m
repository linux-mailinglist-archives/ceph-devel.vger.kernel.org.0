Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B923B7B39
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Jun 2021 03:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhF3B3R (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 21:29:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21368 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229792AbhF3B3Q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 21:29:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625016408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1gXdweYAvmoVSZusyvVA1+aJqKCN/cjHLO+JhTnYTeU=;
        b=L9EJYEQsf8XdwS4L3cjOpG3TefMj90lV7UMcR7txYmmP6gQJBR0vRXWn6n+6szirQ7rmNU
        s0GdBTu+Q5o0OzIm6x1CkE9F7YFtRpsdlkwKEIEJzaaIpzwR0d+nkmZbXfnUi3wQom26kh
        WV8jLpE9PtbXgWPTdWsiwj3VIvRRg7g=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-2NFsPPJ9MZ-6RZt-uA8SKg-1; Tue, 29 Jun 2021 21:26:45 -0400
X-MC-Unique: 2NFsPPJ9MZ-6RZt-uA8SKg-1
Received: by mail-pl1-f198.google.com with SMTP id b2-20020a1709027e02b0290128e572ee46so302029plm.3
        for <ceph-devel@vger.kernel.org>; Tue, 29 Jun 2021 18:26:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=1gXdweYAvmoVSZusyvVA1+aJqKCN/cjHLO+JhTnYTeU=;
        b=ulyx1faptVtwDXL7/xd2xzTDW90JstTN/hNYhhOmse+rJE3IaTR/+iaa41CAYSUr4Q
         US0A9xZpiTvhu/ah8D2DNGJuEJPaUSp0UOD2hujmpE30MR0CrpoRIC8w3eJCM02n5mUH
         GeO5JwHdKqFomaAwXT+n0gfF1iGX/NHDk869um1LVlljZxIun0t0g+P3AC3Z0d7vMGFS
         pcoXira21o3RrSw2nSZj+LqrjPUuStLdu/5pxESremk18cHlnoUkL+tT2ot0lCr7bvvp
         A8fbNBZZ1oUkSPfkHZebX8/Z9fJ0UX0h1b7eJduymfxL6LlaF6vMWsf5zffNd1XEUBam
         3Veg==
X-Gm-Message-State: AOAM531kWDIW6vchZfv3NzIUFNIsJel6jitPalFd0/0qvlmTBSxnM+bO
        IDzgLB1oUev2gsIoWBm6R9GhplCw5SkzlkrxWcpRVu1PauNBdAx/5Eatp34gM0xnfGWTp0eB5Em
        B2IfMnBN/UpL1HKZVSX1tPAWzTIkIdOe1ivjmCthCnKGnJqlyPo9EnmjdfJUegrjWb4uuWnI=
X-Received: by 2002:a65:4244:: with SMTP id d4mr31335345pgq.83.1625016404808;
        Tue, 29 Jun 2021 18:26:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgYPb3EjLm9vsQKHA0e3TDrqII7Nh0t0ZRjeggBRVeZLrDmXwbAe3q36jtQi2AVe9CGVXLmg==
X-Received: by 2002:a65:4244:: with SMTP id d4mr31335324pgq.83.1625016404521;
        Tue, 29 Jun 2021 18:26:44 -0700 (PDT)
Received: from [10.72.12.103] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b6sm19242548pgw.67.2021.06.29.18.26.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 18:26:44 -0700 (PDT)
Subject: Re: [PATCH 4/5] ceph: flush the mdlog before waiting on unsafe reqs
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210629044241.30359-1-xiubli@redhat.com>
 <20210629044241.30359-5-xiubli@redhat.com>
 <b531585184df099e633a4b92e3be23b4b8384253.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <4f2f6de6-eb1f-1527-de73-2378f262228b@redhat.com>
Date:   Wed, 30 Jun 2021 09:26:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <b531585184df099e633a4b92e3be23b4b8384253.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/29/21 9:25 PM, Jeff Layton wrote:
> On Tue, 2021-06-29 at 12:42 +0800, xiubli@redhat.com wrote:
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
>> This patch will trigger to flush the mdlog in all the MDSes manually
>> just before waiting the unsafe requests to finish.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index c6a3352a4d52..6e80e4649c7a 100644
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
>> @@ -2305,6 +2306,14 @@ static int unsafe_request_wait(struct inode *inode)
>>   	}
>>   	spin_unlock(&ci->i_unsafe_lock);
>>   
>> +	/*
>> +	 * Trigger to flush the journal logs in all the MDSes manually,
>> +	 * or in the worst case we must wait at most 5 seconds to wait
>> +	 * the journal logs to be flushed by the MDSes periodically.
>> +	 */
>> +	if (req1 || req2)
>> +		flush_mdlog(mdsc);
>> +
> So this is called on fsync(). Do we really need to flush all of the mds
> logs on every fsync? That sounds like it might have some performance
> impact. Would it be possible to just flush the mdslog on the MDS that's
> authoritative for this inode?

I hit one case before, the mds.0 is the auth mds, but the client just 
sent the request to mds.2, then when the mds.2 tried to gather the 
rdlocks then it was stuck for waiting for the mds.0 to flush the mdlog. 
I think it also will happen that if the mds.0 could also be stuck just 
like this even its the auth MDS.

Normally the mdlog submit thread will be triggered per MDS's tick, 
that's 5 seconds. But this is not always true mostly because any other 
client request could trigger the mdlog submit thread to run at any time. 
Since the fsync is not running all the time, so IMO the performance 
impact should be okay.


>
>>   	dout("unsafe_request_wait %p wait on tid %llu %llu\n",
>>   	     inode, req1 ? req1->r_tid : 0ULL, req2 ? req2->r_tid : 0ULL);
>>   	if (req1) {

