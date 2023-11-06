Return-Path: <ceph-devel+bounces-46-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B8A17E1A53
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 07:44:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1A441C208D0
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 06:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADAC01C29;
	Mon,  6 Nov 2023 06:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NDynq0lx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DF4642
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 06:44:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56362112
	for <ceph-devel@vger.kernel.org>; Sun,  5 Nov 2023 22:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699253037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BZZUw4CsnDvzQR2YUoq3MZLv5f6YmzwniwQK2DbPzSs=;
	b=NDynq0lxWAnsV0KpkSu6NU2Hz7OJfbBBHZiF/1P1o32hqwKpVHbUFWHfAh1f6BKu7GpImr
	4ZbMfVmFLBg5bzAK31vD9jXWZEEVn5QdH/8Rx42GOUn8KIC/if/ZyZheFEEbU9CPWzJ+Fo
	L2gyHRvlJnrtgLST9mgiR5DpdZqWtdM=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-iYIOsioYNy-NtmPTrPihWg-1; Mon, 06 Nov 2023 01:43:56 -0500
X-MC-Unique: iYIOsioYNy-NtmPTrPihWg-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6c0362a50bbso2840032b3a.2
        for <ceph-devel@vger.kernel.org>; Sun, 05 Nov 2023 22:43:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699253035; x=1699857835;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BZZUw4CsnDvzQR2YUoq3MZLv5f6YmzwniwQK2DbPzSs=;
        b=cQbBk/GE7LalkoVSWcqn6AJMbUF9Tpe3OipIqsJz+Eiuz3B9KxeFF1+byKmpO/rrzr
         GC6D0lm46XG0x7ORqtcqcYljpeSkh78DAvh8Z9gGtAaZ+zBHPY8zk3mHlABJ9o8ahYbd
         93VM131tHeK1zd2pgAe83Ia482fD5ylY0PF7vl+lXLFQ+YI5BeZlM/DSDFpn2uxyyX3t
         XF6poO4liRz4uVyy3B8aQx7H/8LtT2t5eZi4nhPixkLOsyUexfv6Xd4M1NseoJMxpLci
         8Ykry/fzsR2//sDjBCu8J5P5XfrEF1Osw6ZgAMuQNxEVODzqR2sCL1YpaNVtc1gbdC/2
         V8EA==
X-Gm-Message-State: AOJu0YytCMRk3IT1FarBbulwQqrtNT5T7LBh19wBMdlvThDrVTnMVbol
	4STlALznJmExqZ62282LHAuJptEhnfFyhpP+wskaUKucQ3a0iXrojfRzf2ZG47uvNgUMOZM+DVi
	5nDMakvK8Eem8RjdyptiZfq3AbdbjpPu1
X-Received: by 2002:a05:6a00:2307:b0:68e:380c:6b15 with SMTP id h7-20020a056a00230700b0068e380c6b15mr22291172pfh.26.1699253034719;
        Sun, 05 Nov 2023 22:43:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGz3PJPlCb+U2Q4KnavFN67WZb9MkvPyW/7julO+mQy60DP9XrLR4XFLKYkxcpiFVKuKyljpQ==
X-Received: by 2002:a05:6a00:2307:b0:68e:380c:6b15 with SMTP id h7-20020a056a00230700b0068e380c6b15mr22291160pfh.26.1699253034351;
        Sun, 05 Nov 2023 22:43:54 -0800 (PST)
Received: from [10.72.112.124] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a23-20020aa78657000000b0069ea08a2a99sm4907701pfo.211.2023.11.05.22.43.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Nov 2023 22:43:54 -0800 (PST)
Message-ID: <1cded211-047b-ae79-fcf8-0838c1f8a21c@redhat.com>
Date: Mon, 6 Nov 2023 14:43:49 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] libceph: remove the max extents check for sparse read
Content-Language: en-US
To: Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org, vshankar@redhat.com, mchangir@redhat.com
References: <20231103033900.122990-1-xiubli@redhat.com>
 <CAOi1vP8EtALzni0sdj0o4j61KkC6XqgzEgikCDhDPOHX6LNYZw@mail.gmail.com>
 <23b5dc4e0607a033714e50c3326d587fd0cf99bf.camel@kernel.org>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <23b5dc4e0607a033714e50c3326d587fd0cf99bf.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 11/3/23 18:14, Jeff Layton wrote:
> On Fri, 2023-11-03 at 11:07 +0100, Ilya Dryomov wrote:
>> On Fri, Nov 3, 2023 at 4:41 AM <xiubli@redhat.com> wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> There is no any limit for the extent array size and it's possible
>>> that when reading with a large size contents. Else the messager
>>> will fail by reseting the connection and keeps resending the inflight
>>> IOs.
>>>
>>> URL: https://tracker.ceph.com/issues/62081
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>   net/ceph/osd_client.c | 12 ------------
>>>   1 file changed, 12 deletions(-)
>>>
>>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>>> index 7af35106acaf..177a1d92c517 100644
>>> --- a/net/ceph/osd_client.c
>>> +++ b/net/ceph/osd_client.c
>>> @@ -5850,8 +5850,6 @@ static inline void convert_extent_map(struct ceph_sparse_read *sr)
>>>   }
>>>   #endif
>>>
>>> -#define MAX_EXTENTS 4096
>>> -
>>>   static int osd_sparse_read(struct ceph_connection *con,
>>>                             struct ceph_msg_data_cursor *cursor,
>>>                             char **pbuf)
>>> @@ -5882,16 +5880,6 @@ static int osd_sparse_read(struct ceph_connection *con,
>>>
>>>                  if (count > 0) {
>>>                          if (!sr->sr_extent || count > sr->sr_ext_len) {
>>> -                               /*
>>> -                                * Apply a hard cap to the number of extents.
>>> -                                * If we have more, assume something is wrong.
>>> -                                */
>>> -                               if (count > MAX_EXTENTS) {
>>> -                                       dout("%s: OSD returned 0x%x extents in a single reply!\n",
>>> -                                            __func__, count);
>>> -                                       return -EREMOTEIO;
>>> -                               }
>>> -
>>>                                  /* no extent array provided, or too short */
>>>                                  kfree(sr->sr_extent);
>>>                                  sr->sr_extent = kmalloc_array(count,
>>> --
>>> 2.39.1
>>>
>> Hi Xiubo,
>>
>> As noted in the tracker ticket, there are many "sanity" limits like
>> that in the messenger and other parts of the kernel client.  First,
>> let's change that dout to pr_warn_ratelimited so that it's immediately
>> clear what is going on.  Then, if the limit actually gets hit, let's
>> dig into why and see if it can be increased rather than just removed.
>>
> Yeah, agreed. I think when I wrote this, I couldn't figure out if there
> was an actual hard cap on the number of extents, so I figured 4k ought
> to be enough for anybody. Clearly that was wrong though.
>
> I'd still favor raising the cap instead eliminating it altogether. Is
> there a hard cap on the number of extents that the OSD will send in a
> single reply? That's really what this limit should be.

I went through the messager code again carefully, I found that even in 
case when the errno is '-ENOMEM' for a request the messager will trigger 
the connection fault, which will reconnect the connection and retry all 
the osd requests. This looks incorrect.

IMO only in case when the errno is any of '-EBADMSG' or '-EREMOTEIO', 
etc should we retry the osd requests. And for the errors that caused by 
the client side we should fail the osd requests instead.

Thanks

- Xiubo





