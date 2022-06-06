Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8919553E906
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jun 2022 19:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbiFFLz4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jun 2022 07:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235865AbiFFLzx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Jun 2022 07:55:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7D06875201
        for <ceph-devel@vger.kernel.org>; Mon,  6 Jun 2022 04:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654516550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VKQvvA4DhvFl6px6dOmSCLfPfvkO9Tl+JJjwhZLZ6uw=;
        b=GWD2iyGKuZrp+z90fPoMxaxY7B7iWRVVJFBgKA83ji7E2O0TrdMLK0qTf22q6/oy6qlKLP
        zXcQSw/t5n5Wg06FjieGPdxr4At40H9u1JNaN0ASQ+8Sq9MMRiyWUTTN9BJK4GwB/0UA7S
        C/AxUAxSMpbEndiCy3fGT6ToWQDC/DE=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-X53-s-tbOY-CANW5hKdhnA-1; Mon, 06 Jun 2022 07:55:49 -0400
X-MC-Unique: X53-s-tbOY-CANW5hKdhnA-1
Received: by mail-pf1-f197.google.com with SMTP id x11-20020aa79acb000000b0051b9d3136fdso7772180pfp.1
        for <ceph-devel@vger.kernel.org>; Mon, 06 Jun 2022 04:55:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=VKQvvA4DhvFl6px6dOmSCLfPfvkO9Tl+JJjwhZLZ6uw=;
        b=rVBSky26ucDtoAT0GQqwIeTfpP+Ci1W+ExEjI/3P1niZaV7QpuSSDy4QZns/jm2pCZ
         xyMkuus38LTmFNbqPd9X81+pq/Pre3Ix1OYrczVAhMhWqVtYJX68twNecgypp4ZGk++K
         oFSdQfk2UZqOewL3eBt7ZvI1ECiTI05Z+wP65ACtgEQGlmUI+9h5yaJE8qcy+pH6iCzK
         L1l0dPiOG1sxR8mCAOXyg7NDNiMtxZPCsJx8vkMkDcZs71TU/Cop/9bblbr08lD97UI3
         XkFHcnWd+eNRuWYltATrw0FbVhRYn+CTK3diU2FaWp916NLEkGZQBrIUtViVdJtqBC9U
         cSMQ==
X-Gm-Message-State: AOAM532z3kHqZXO5+r1iWaUElxk54n3W2clSMuivqLYx1YzSFXaWUv1D
        adGSFIQs7wfyxOS5WjeXxzJeAbC1JYGIx8VRc5CHtG1KQBYvdr59bfFwCRleQp9dM5WlG6Pyvgi
        NL9LWlIC7A3YL67DzkRzUgQ==
X-Received: by 2002:a17:902:db0a:b0:165:1672:480e with SMTP id m10-20020a170902db0a00b001651672480emr23710782plx.165.1654516548143;
        Mon, 06 Jun 2022 04:55:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzf9qAtAHdDjHfg+0m6F+ibBpRhVlY10XdhaLg4flGJ+DuZBShRh/7tNrSSoHVaXC5MjMj4DQ==
X-Received: by 2002:a17:902:db0a:b0:165:1672:480e with SMTP id m10-20020a170902db0a00b001651672480emr23710764plx.165.1654516547874;
        Mon, 06 Jun 2022 04:55:47 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k18-20020aa79732000000b0050e006279bfsm10678111pfg.137.2022.06.06.04.55.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jun 2022 04:55:47 -0700 (PDT)
Subject: Re: [PATCH] ceph: don't leak snap_rwsem in handle_cap_grant
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org,
        ukernel <ukernel@gmail.com>
References: <20220603203957.55337-1-jlayton@kernel.org>
 <4aa4ce81-4a49-7e0a-ede7-204149d1c9ca@redhat.com>
 <a461492826894c4cba6ba793469c8ba1ce8b140c.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <8c8981bc-5a53-b3c6-6ecd-3e15173a85c6@redhat.com>
Date:   Mon, 6 Jun 2022 19:55:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <a461492826894c4cba6ba793469c8ba1ce8b140c.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/6/22 6:26 PM, Jeff Layton wrote:
> On Mon, 2022-06-06 at 13:17 +0800, Xiubo Li wrote:
>> On 6/4/22 4:39 AM, Jeff Layton wrote:
>>> When handle_cap_grant is called on an IMPORT op, then the snap_rwsem is
>>> held and the function is expected to release it before returning. It
>>> currently fails to do that in all cases which could lead to a deadlock.
>>>
>>> URL: https://tracker.ceph.com/issues/55857
>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>> ---
>>>    fs/ceph/caps.c | 27 +++++++++++++--------------
>>>    1 file changed, 13 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>> index 258093e9074d..0a48bf829671 100644
>>> --- a/fs/ceph/caps.c
>>> +++ b/fs/ceph/caps.c
>>> @@ -3579,24 +3579,23 @@ static void handle_cap_grant(struct inode *inode,
>>>    			fill_inline = true;
>>>    	}
>>>    
>>> -	if (ci->i_auth_cap == cap &&
>>> -	    le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
>>> -		if (newcaps & ~extra_info->issued)
>>> -			wake = true;
>>> +	if (le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
>>> +		if (ci->i_auth_cap == cap) {
>>> +			if (newcaps & ~extra_info->issued)
>>> +				wake = true;
>>> +
>>> +			if (ci->i_requested_max_size > max_size ||
>>> +			    !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
>>> +				/* re-request max_size if necessary */
>>> +				ci->i_requested_max_size = 0;
>>> +				wake = true;
>>> +			}
>>>    
>>> -		if (ci->i_requested_max_size > max_size ||
>>> -		    !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
>>> -			/* re-request max_size if necessary */
>>> -			ci->i_requested_max_size = 0;
>>> -			wake = true;
>>> +			ceph_kick_flushing_inode_caps(session, ci);
>>>    		}
>>> -
>>> -		ceph_kick_flushing_inode_caps(session, ci);
>>> -		spin_unlock(&ci->i_ceph_lock);
>>>    		up_read(&session->s_mdsc->snap_rwsem);
>>> -	} else {
>>> -		spin_unlock(&ci->i_ceph_lock);
>>>    	}
>>> +	spin_unlock(&ci->i_ceph_lock);
>>>    
>>>    	if (fill_inline)
>>>    		ceph_fill_inline_data(inode, NULL, extra_info->inline_data,
>> I am not sure what the following code in Line#4139 wants to do, more
>> detail please see [1].
>>
>> 4131         if (msg_version >= 3) {
>> 4132                 if (op == CEPH_CAP_OP_IMPORT) {
>> 4133                         if (p + sizeof(*peer) > end)
>> 4134                                 goto bad;
>> 4135                         peer = p;
>> 4136                         p += sizeof(*peer);
>> 4137                 } else if (op == CEPH_CAP_OP_EXPORT) {
>> 4138                         /* recorded in unused fields */
>> 4139                         peer = (void *)&h->size;
>> 4140 }
>> 4141         }
>>
>> For the export case the members in the 'peer' are always assigned to
>> 'random' values. And seems could cause this issue.
>>
>> [1] https://github.com/ceph/ceph-client/blob/for-linus/fs/ceph/caps.c#L4134
>>
>> I am still reading the code. Any idea ?
>>
>>
> I'm not sure that this is the case. It looks like most of the places in
> the mds code that make a CEPH_CAP_OP_EXPORT message call set_cap_peer
> just afterward. Why do you think this is given random values?
>
Misread the ceph message protocol related code. Please ignore this.

-- Xiubo


