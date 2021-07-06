Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8302E3BD789
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jul 2021 15:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhGFNTt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jul 2021 09:19:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50635 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231248AbhGFNTt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jul 2021 09:19:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625577430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y4yRqHQ7hwL1Eq/C7bX0VTgY/PRg3wMsWd6PJZc6Tpg=;
        b=J5EhgkAzSab8gDYoD7Sz9F8BunflIzzL3Sx3ggTzk9N/p77eFWzml64tzqsdmOW1aiclQh
        3vJ0/quyejmVWgJRM+z9mU/XFtfzF8P0AEAngmSkUa3TwS6G1/EonYukZ8sciKw/AccVjf
        ZADUAGTMw/ZDRxe6qZh4H2Wh/5Ema58=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-OAjgXzNTOK-McMNOzfYVYw-1; Tue, 06 Jul 2021 09:17:09 -0400
X-MC-Unique: OAjgXzNTOK-McMNOzfYVYw-1
Received: by mail-pf1-f200.google.com with SMTP id d29-20020aa797bd0000b02903147a50038aso9572743pfq.15
        for <ceph-devel@vger.kernel.org>; Tue, 06 Jul 2021 06:17:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Y4yRqHQ7hwL1Eq/C7bX0VTgY/PRg3wMsWd6PJZc6Tpg=;
        b=OPmMGnxoB03mA1P64M8QlmEqPixrgT5paRGy5kEXsQzE8qyme8htEORD2TUWI5Rb7L
         G2uDvy5gTuygUkB5Z0+0exubDJP8bl8BfPrxVZmdNo53WHZZ133EVK6ZYmxnHo4FPVkC
         b09dqI3YTbs7OmTEuM6jA6DxkRXB4jHfRvm4zNAFtoVyHZjYLgNuTFYaDeuD6NFvHaw8
         k3rSy5AUeD3V8JrM01ji+vyduRPV4XSX2LD3rEfVofRMFr3+ejrfzvOW3IUKuBWqYe+T
         gSlLZHigKMcMQ+cSjKYp2ipZ5qg7fh3lgTWd/kcheRE4U22rg71obmgDwQ/gTSYOFdEp
         fWug==
X-Gm-Message-State: AOAM530a94/DUTHxutowxW58CFuimBAl9tcswg2MG3mziux3Nl2gwAIR
        0Rk9pFNFTsbpF/LxfXL+iQo2f6D2K/51OBFXlhU1JMCu0F5KsRItZEY5PegdaXjsgA5rMk7h6vL
        suxV7lJwStm+Ms4fd8NLK6wplYFZ27yGMy/EcclZNqGJTt0rrEbTrF0f4iCjn6Pe9zSmCWuA=
X-Received: by 2002:a17:90a:4490:: with SMTP id t16mr21073562pjg.193.1625577427927;
        Tue, 06 Jul 2021 06:17:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzh54gVUYVZaXbpep0Ln2H8PDJc6KrwxG/yljsA2w1AhpkV/ir/Cc6DqEopQScJXQ4YSd6kpQ==
X-Received: by 2002:a17:90a:4490:: with SMTP id t16mr21073534pjg.193.1625577427593;
        Tue, 06 Jul 2021 06:17:07 -0700 (PDT)
Received: from [10.72.13.230] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g17sm19700151pgh.61.2021.07.06.06.17.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 06:17:07 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] ceph: flush the mdlog before waiting on unsafe
 reqs
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210705012257.182669-1-xiubli@redhat.com>
 <20210705012257.182669-5-xiubli@redhat.com>
 <60e6a0d99abe921232b6cb4b9ce5e31272a06790.camel@kernel.org>
 <b6e463c2-6b51-81ce-ee90-36e48e77110b@redhat.com>
 <e553452368abc74d4ee2943aa3527672dc668f59.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f51c0cf0-e07b-8bfb-19c7-59d23bccca3c@redhat.com>
Date:   Tue, 6 Jul 2021 21:17:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <e553452368abc74d4ee2943aa3527672dc668f59.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/6/21 9:11 PM, Jeff Layton wrote:
> On Tue, 2021-07-06 at 20:37 +0800, Xiubo Li wrote:
>> On 7/6/21 7:42 PM, Jeff Layton wrote:
>>> On Mon, 2021-07-05 at 09:22 +0800, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> For the client requests who will have unsafe and safe replies from
>>>> MDS daemons, in the MDS side the MDS daemons won't flush the mdlog
>>>> (journal log) immediatelly, because they think it's unnecessary.
>>>> That's true for most cases but not all, likes the fsync request.
>>>> The fsync will wait until all the unsafe replied requests to be
>>>> safely replied.
>>>>
>>>> Normally if there have multiple threads or clients are running, the
>>>> whole mdlog in MDS daemons could be flushed in time if any request
>>>> will trigger the mdlog submit thread. So usually we won't experience
>>>> the normal operations will stuck for a long time. But in case there
>>>> has only one client with only thread is running, the stuck phenomenon
>>>> maybe obvious and the worst case it must wait at most 5 seconds to
>>>> wait the mdlog to be flushed by the MDS's tick thread periodically.
>>>>
>>>> This patch will trigger to flush the mdlog in the relevant and auth
>>>> MDSes to which the in-flight requests are sent just before waiting
>>>> the unsafe requests to finish.
>>>>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/caps.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>    1 file changed, 78 insertions(+)
>>>>
>>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>>> index c6a3352a4d52..4b966c29d9b5 100644
>>>> --- a/fs/ceph/caps.c
>>>> +++ b/fs/ceph/caps.c
>>>> @@ -2286,6 +2286,7 @@ static int caps_are_flushed(struct inode *inode, u64 flush_tid)
>>>>     */
>>>>    static int unsafe_request_wait(struct inode *inode)
>>>>    {
>>>> +	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>>>>    	struct ceph_inode_info *ci = ceph_inode(inode);
>>>>    	struct ceph_mds_request *req1 = NULL, *req2 = NULL;
>>>>    	int ret, err = 0;
>>>> @@ -2305,6 +2306,82 @@ static int unsafe_request_wait(struct inode *inode)
>>>>    	}
>>>>    	spin_unlock(&ci->i_unsafe_lock);
>>>>    
>>>> +	/*
>>>> +	 * Trigger to flush the journal logs in all the relevant MDSes
>>>> +	 * manually, or in the worst case we must wait at most 5 seconds
>>>> +	 * to wait the journal logs to be flushed by the MDSes periodically.
>>>> +	 */
>>>> +	if (req1 || req2) {
>>>> +		struct ceph_mds_session **sessions = NULL;
>>>> +		struct ceph_mds_session *s;
>>>> +		struct ceph_mds_request *req;
>>>> +		unsigned int max;
>>>> +		int i;
>>>> +
>>>> +		/*
>>>> +		 * The mdsc->max_sessions is unlikely to be changed
>>>> +		 * mostly, here we will retry it by reallocating the
>>>> +		 * sessions arrary memory to get rid of the mdsc->mutex
>>>> +		 * lock.
>>>> +		 */
>>>> +retry:
>>>> +		max = mdsc->max_sessions;
>>>> +		sessions = krealloc(sessions, max * sizeof(s), __GFP_ZERO);
>>> The kerneldoc over krealloc() says:
>>>
>>>    * The contents of the object pointed to are preserved up to the
>>>    * lesser of the new and old sizes (__GFP_ZERO flag is effectively
>>> ignored).
>>>
>>> This code however relies on krealloc zeroing out the new part of the
>>> allocation. Do you know for certain that that works?
>> I readed the krealloc() code, the "__GFP_ZERO flag will be ignored" only
>> for the preserved contents. If the slab really needs to allocate a new
>> object, the slab will help zero it first and then copy the old contents
>> to it, the new part will keep zeroed.
>>
>>
> Ok, and in the case where it's an initial kmalloc, that will be done
> with __GFP_ZERO so any remaining space in the allocation will already be
> zeroed. That works.

Yeah, it is.


>
>>>> +		if (!sessions) {
>>>> +			err = -ENOMEM;
>>>> +			goto out;
>>>> +		}
>>>> +		spin_lock(&ci->i_unsafe_lock);
>>>> +		if (req1) {
>>>> +			list_for_each_entry(req, &ci->i_unsafe_dirops,
>>>> +					    r_unsafe_dir_item) {
>>>> +				s = req->r_session;
>>>> +				if (unlikely(s->s_mds > max)) {
>>>> +					spin_unlock(&ci->i_unsafe_lock);
>>>> +					goto retry;
>>>> +				}
>>>> +				if (!sessions[s->s_mds]) {
>>>> +					s = ceph_get_mds_session(s);
>>>> +					sessions[s->s_mds] = s;
>>> nit: maybe just do:
>>>
>>>       sessions[s->s_mds] = ceph_get_mds_session(s);
>> Then it will exceed 80 chars for this line. Should we ignore it here ?
>>
> I probably would have but it's not worth respinning over all by itself.
>
> It might also be possible to do all of this without taking the
> i_unsafe_lock twice, but that too probably won't make much difference.
>
> I'll give these a closer look and probably merge into testing branch
> later today unless I see a problem.

Sure, thanks Jeff.


>
> Thanks!
> Jeff
>
>>>> +				}
>>>> +			}
>>>> +		}
>>>> +		if (req2) {
>>>> +			list_for_each_entry(req, &ci->i_unsafe_iops,
>>>> +					    r_unsafe_target_item) {
>>>> +				s = req->r_session;
>>>> +				if (unlikely(s->s_mds > max)) {
>>>> +					spin_unlock(&ci->i_unsafe_lock);
>>>> +					goto retry;
>>>> +				}
>>>> +				if (!sessions[s->s_mds]) {
>>>> +					s = ceph_get_mds_session(s);
>>>> +					sessions[s->s_mds] = s;
>>>> +				}
>>>> +			}
>>>> +		}
>>>> +		spin_unlock(&ci->i_unsafe_lock);
>>>> +
>>>> +		/* the auth MDS */
>>>> +		spin_lock(&ci->i_ceph_lock);
>>>> +		if (ci->i_auth_cap) {
>>>> +		      s = ci->i_auth_cap->session;
>>>> +		      if (!sessions[s->s_mds])
>>>> +			      sessions[s->s_mds] = ceph_get_mds_session(s);
>>>> +		}
>>>> +		spin_unlock(&ci->i_ceph_lock);
>>>> +
>>>> +		/* send flush mdlog request to MDSes */
>>>> +		for (i = 0; i < max; i++) {
>>>> +			s = sessions[i];
>>>> +			if (s) {
>>>> +				send_flush_mdlog(s);
>>>> +				ceph_put_mds_session(s);
>>>> +			}
>>>> +		}
>>>> +		kfree(sessions);
>>>> +	}
>>>> +
>>>>    	dout("unsafe_request_wait %p wait on tid %llu %llu\n",
>>>>    	     inode, req1 ? req1->r_tid : 0ULL, req2 ? req2->r_tid : 0ULL);
>>>>    	if (req1) {
>>>> @@ -2321,6 +2398,7 @@ static int unsafe_request_wait(struct inode *inode)
>>>>    			err = -EIO;
>>>>    		ceph_mdsc_put_request(req2);
>>>>    	}
>>>> +out:
>>>>    	return err;
>>>>    }
>>>>    
>>> Otherwise the whole set looks pretty reasonable.
>>>
>>> Thanks,

