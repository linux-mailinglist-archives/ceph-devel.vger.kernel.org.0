Return-Path: <ceph-devel+bounces-37-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 69E8A7E1820
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 01:23:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BA941C20941
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 00:23:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F11738C;
	Mon,  6 Nov 2023 00:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fIzsZ3xj"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A126837E
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 00:23:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CF4C0
	for <ceph-devel@vger.kernel.org>; Sun,  5 Nov 2023 16:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699230208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LqcA/qPFLsRDYd9JZSBiHNv5GagpBsBx6Xu8+8B8nOc=;
	b=fIzsZ3xjA7DBRBgxclvVBhx3Or9GD49j8vjlJOz6S42M0A7350o95HxbTQxP3Rk2yta9KS
	xdn7JEqH0p+MMqc+l5P6AO0P3DgeVCQNeDpo5lVCDYu8wQbp4eVpi28r9bUICk8g4RKIWy
	bWEeAfFlyyq+oPEfv4XqJEly73KVQKM=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-VLJLpryVN2es8GceCoqKXw-1; Sun, 05 Nov 2023 19:23:27 -0500
X-MC-Unique: VLJLpryVN2es8GceCoqKXw-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-6b1cec068a9so3760207b3a.0
        for <ceph-devel@vger.kernel.org>; Sun, 05 Nov 2023 16:23:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699230206; x=1699835006;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LqcA/qPFLsRDYd9JZSBiHNv5GagpBsBx6Xu8+8B8nOc=;
        b=XScrIMXJwKgDIAOg2IxRtAzRg7WJA74UNQwFyeoMEnpAK1QeCwV/LAY9+uW9rZFPyb
         3+U/drdk2awHNIlY03Lvq4M916ALNTB6eDQnpU2XDCh8Fkx8Cr7/UP0fbnBfmbekPyqz
         s5oJpugNI7+xS/yLIC0cAmBXYacM3lw2YHk4kbkESrqdk3Sd12I1/MfyFgBMzXTYWNI4
         zbXYOAgg14Jo0+04Lz/3qFDQqJ3NNm32+SWECLwDNLJha1Neq+I+xPfxLzprDVDLFWZI
         uvw/yp6Adjo5hbMIr2BZkX27/OCD+Tnmhj1v6O77s8iBQH5cA/AKWwmpTKQZVQGL/tHM
         bEHQ==
X-Gm-Message-State: AOJu0YwKJJQReIKE/bgtnWhyRGWppOyi5uefSCGJheLH1+JQWhOuvyNN
	2RmuZAkl+sgHIDNBuH4Gl5YKbT2RFIErKdNpTK2BllSTTlRJ4mKoL9S5fDjtzKNVw/CIW0eTYTh
	ribsGRXDjgRjX1nSu/1BzTw==
X-Received: by 2002:a05:6a00:2e27:b0:6be:e54e:a540 with SMTP id fc39-20020a056a002e2700b006bee54ea540mr36690511pfb.30.1699230206135;
        Sun, 05 Nov 2023 16:23:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGc4fxzE7u1JoEvpa3vUSXq1pRrrrpQ+4LcPngXnjQi7eR5AR7sNK6wtBYGiRGz5nxdurEhhQ==
X-Received: by 2002:a05:6a00:2e27:b0:6be:e54e:a540 with SMTP id fc39-20020a056a002e2700b006bee54ea540mr36690503pfb.30.1699230205836;
        Sun, 05 Nov 2023 16:23:25 -0800 (PST)
Received: from [10.72.112.124] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n1-20020aa78a41000000b0068fbaea118esm4520656pfa.45.2023.11.05.16.23.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Nov 2023 16:23:25 -0800 (PST)
Message-ID: <9b67a6c7-73ce-1e6a-fc03-ed2cf8cb0cdf@redhat.com>
Date: Mon, 6 Nov 2023 08:23:21 +0800
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

Okay.

> I'd still favor raising the cap instead eliminating it altogether. Is
> there a hard cap on the number of extents that the OSD will send in a
> single reply? That's really what this limit should be.

I didn't find any thing about this in ceph if I didn't miss something.

 From my test it could reach up to very large number, such as 10000 
after randomly writes to a file and then read it with a large size.

I'm thinking could we limit this to depends on the memories being 
allocated for 'sr->sr_extent' ?

Thanks

- Xiubo




