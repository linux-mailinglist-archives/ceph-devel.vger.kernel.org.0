Return-Path: <ceph-devel+bounces-38-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B82257E1823
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 01:25:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDB5C1C20A46
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 00:25:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39D7238C;
	Mon,  6 Nov 2023 00:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cH/ahsX+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD2B37E
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 00:25:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3460D8
	for <ceph-devel@vger.kernel.org>; Sun,  5 Nov 2023 16:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699230315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nRudtxmz8tbsj1puxMygJtSrg3rVby2+6NF9ZSNalqg=;
	b=cH/ahsX+g0Q/4tDX/gaWEucbYreQx3tnxjd0FwkYqoTJ3N12q0WDORgSF8DIWo2a27lvyn
	NcQQF3XhQKNkokq1DDgpbYYNZw7lG8F9JHWnkNzJF64x7IKBB0X3Ags2jsmK4fg4rPKhLJ
	gNptwKwiztTol1g91MXaH6SbmVBokJY=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-u-Vb4HRnMF2NjMS5aeZ2jg-1; Sun, 05 Nov 2023 19:25:14 -0500
X-MC-Unique: u-Vb4HRnMF2NjMS5aeZ2jg-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3b3fb625e3bso5595315b6e.3
        for <ceph-devel@vger.kernel.org>; Sun, 05 Nov 2023 16:25:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699230314; x=1699835114;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nRudtxmz8tbsj1puxMygJtSrg3rVby2+6NF9ZSNalqg=;
        b=XRnNWeSrgKmUCiJvWJvRWF+DAN5EjqDuOphbek43ooQ9tsl3yXxNPVOh+0xnQFSrqC
         PYn56BRq7sfhjg5QTZsF1T9ni9W9rhnK+oTaEFxNV9m6+WZHvT8iyaFIhRWrFVtb52df
         ucXdaibEoOLf0dxbW6fOHHsVsWu/YfwUbmGa+Fc9Q5kux1q6+2TPABHeyqsTj3tXcvS5
         cpFSGUCkXFTLEPQstFN9jaeU3JlJ3J1Mrhh0yskUIx3lDnr61cbr/rsjuB+NpL/9m4ke
         HpGhNCoh6rCuYJYKhtxHBcwwWukbR+Kc01/E+UxActqjARMu9+EMBPRN5Kt5AocBVo99
         ESpA==
X-Gm-Message-State: AOJu0YymWFNqrJnHlGXqj5Kdy0N6R+QrU1nn2de7lIUP0blgjTA6iZPP
	S2jXMgX8426GK758JwIfuPHCKNnTDfo/sw2zqqwSUdInF1iCwyVA3JjByooMmVMRwg3kNU+GPvE
	w95oYjIxTyHXrKM9JLOCopL62aHSD3A==
X-Received: by 2002:a54:451a:0:b0:3ab:929e:c5e1 with SMTP id l26-20020a54451a000000b003ab929ec5e1mr29298852oil.39.1699230313845;
        Sun, 05 Nov 2023 16:25:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFzs3XKvYl9aSaZPjslCfEED59SXQYvDXS5Te3z/SV/mPBOgmNUVN4ArheyC5rk1ipuyc8Mdw==
X-Received: by 2002:a54:451a:0:b0:3ab:929e:c5e1 with SMTP id l26-20020a54451a000000b003ab929ec5e1mr29298838oil.39.1699230313300;
        Sun, 05 Nov 2023 16:25:13 -0800 (PST)
Received: from [10.72.112.124] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a24-20020aa78658000000b006b287c0ed63sm4468282pfo.137.2023.11.05.16.25.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Nov 2023 16:25:12 -0800 (PST)
Message-ID: <2b13b358-68be-1a7b-0847-d79270358445@redhat.com>
Date: Mon, 6 Nov 2023 08:25:09 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ceph: reinitialize mds feature bit even when session in
 open
Content-Language: en-US
To: Venky Shankar <vshankar@redhat.com>
Cc: mchangir@redhat.com, ceph-devel@vger.kernel.org
References: <20231103064027.316296-1-vshankar@redhat.com>
 <CACPzV1mkHsWmUy60MxZg0VA-ewm=KW62ODT019jDtSL5EzErNw@mail.gmail.com>
 <184d7c48-42de-e602-e394-3c0b2cbeb0b7@redhat.com>
 <CACPzV1=ZfG-4AMMhE1_uCNDaC-bRXK8mng7s_zD8GQ0YbUafqg@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CACPzV1=ZfG-4AMMhE1_uCNDaC-bRXK8mng7s_zD8GQ0YbUafqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 11/3/23 17:29, Venky Shankar wrote:
> On Fri, Nov 3, 2023 at 1:23 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 11/3/23 14:43, Venky Shankar wrote:
>>> On Fri, Nov 3, 2023 at 12:10 PM Venky Shankar <vshankar@redhat.com> wrote:
>>>> Following along the same lines as per the user-space fix. Right
>>>> now this isn't really an issue with the ceph kernel driver because
>>>> of the feature bit laginess, however, that can change over time
>>>> (when the new snaprealm info type is ported to the kernel driver)
>>>> and depending on the MDS version that's being upgraded can cause
>>>> message decoding issues - so, fix that early on.
>>>>
>>>> URL: Fixes: http://tracker.ceph.com/issues/63188
>>>> Signed-off-by: Venky Shankar <vshankar@redhat.com>
>>>> ---
>>>>    fs/ceph/mds_client.c | 1 +
>>>>    1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>> index a7bffb030036..48d75e17115c 100644
>>>> --- a/fs/ceph/mds_client.c
>>>> +++ b/fs/ceph/mds_client.c
>>>> @@ -4192,6 +4192,7 @@ static void handle_session(struct ceph_mds_session *session,
>>>>                   if (session->s_state == CEPH_MDS_SESSION_OPEN) {
>>>>                           pr_notice_client(cl, "mds%d is already opened\n",
>>>>                                            session->s_mds);
>>>> +                       session->s_features = features;
>>> Xiubo, the metrics stuff isn't done here (as it's done in the else
>>> case). That's probably required I guess??
>> That should be okay, but it harmless to do it here.
>>
>> So let's just fix it by:
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 41be58baaa57..de3c6b6cbd07 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -4263,17 +4263,16 @@ static void handle_session(struct
>> ceph_mds_session *session,
>>                           pr_info_client(cl, "mds%d reconnect success\n",
>>                                          session->s_mds);
>>
>> -               if (session->s_state == CEPH_MDS_SESSION_OPEN) {
>> +               if (session->s_state == CEPH_MDS_SESSION_OPEN)
>>                           pr_notice_client(cl, "mds%d is already opened\n",
>>                                            session->s_mds);
>> -               } else {
>> +               else
>>                           session->s_state = CEPH_MDS_SESSION_OPEN;
>> -                       session->s_features = features;
>> -                       renewed_caps(mdsc, session, 0);
>> -                       if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT,
>> -                                    &session->s_features))
>> - metric_schedule_delayed(&mdsc->metric);
>> -               }
>> +               session->s_features = features;
>> +               renewed_caps(mdsc, session, 0);
> Call to renewed_caps() isn't really required if the session state is
> already open, isn't it? Doesn't harm to call it I guess, but...

Yeah.

Then let's just do:

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 41be58baaa57..45d0f445cdef 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4263,12 +4263,12 @@ static void handle_session(struct 
ceph_mds_session *session,
                         pr_info_client(cl, "mds%d reconnect success\n",
                                        session->s_mds);

+               session->s_features = features;
                 if (session->s_state == CEPH_MDS_SESSION_OPEN) {
                         pr_notice_client(cl, "mds%d is already opened\n",
                                          session->s_mds);
                 } else {
                         session->s_state = CEPH_MDS_SESSION_OPEN;
-                       session->s_features = features;
                         renewed_caps(mdsc, session, 0);
                         if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT,
                                      &session->s_features))

Thanks

- Xiubo


>> +               if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT,
>> +                            &session->s_features))
>> + metric_schedule_delayed(&mdsc->metric);
>>
>>                   /*
>>                    * The connection maybe broken and the session in client
>>
>> Thanks
>>
>> - Xiubo
>>
>>
>>>>                   } else {
>>>>                           session->s_state = CEPH_MDS_SESSION_OPEN;
>>>>                           session->s_features = features;
>>>> --
>>>> 2.39.3
>>>>
>


