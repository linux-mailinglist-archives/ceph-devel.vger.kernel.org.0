Return-Path: <ceph-devel+bounces-953-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BBCFC870293
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Mar 2024 14:24:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2ED401F240C3
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Mar 2024 13:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C553D96A;
	Mon,  4 Mar 2024 13:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GDhsbwsK"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20CC3D548
	for <ceph-devel@vger.kernel.org>; Mon,  4 Mar 2024 13:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709558650; cv=none; b=IctXGsbbi0wWMlQ67kUtzK7Ss8Ymbnn0KoiMZ411m2All+VKLk2XH7dzUYoIUoP/Z50v130t8lGtO4jtyf9tVrro/lypqNsuiiKW0IGKbzWX0mYznoDbgmMy7ksZ++wG98kaTO9s/vL9G82irsW4ksvtGHa1RJhLnMJYMTJR2Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709558650; c=relaxed/simple;
	bh=bxq3CiHzJRGANTeCS3Lik8MxNKEU5wk57JGAtLp6kt8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qHl3/tcBoTP7yVbsjiaA6VsBvC73e/O/8QY29otq7qzb7ouHKPS4CVqOFkvDNJVGJ9aAIPs4gitXhVGQEadi/qzTGnSdun/8BdwxfC72MlX5Ad8ivVABliMrBp+WQ8EhLtGcum6Z4G5iFGVufub40q9eg0zhkp0Iew/b6n7Bzdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GDhsbwsK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709558647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0e0aVBH8Bbwp/svtEKmKZLJTI4f+E4WaUIjl97DqXSU=;
	b=GDhsbwsKqv8/vjU0ajiDl9ZscKhukuwiX1x2Zm9yTHiSGA90q+tvdLkmlRidl64j1353gr
	5lzFHtHAKS51h7KcLTbPs/XYTNlyjmQabzr+a6DNLtPUcRQoHSYShkP0M7Q3Jm1rqtmwUe
	kK94NRwi60x5PQDsdYRglX1XWFfJuGQ=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-k9m_Uj4cPgCI18RYKjmAcA-1; Mon, 04 Mar 2024 08:24:04 -0500
X-MC-Unique: k9m_Uj4cPgCI18RYKjmAcA-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-5d5a080baf1so3647111a12.1
        for <ceph-devel@vger.kernel.org>; Mon, 04 Mar 2024 05:24:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709558643; x=1710163443;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0e0aVBH8Bbwp/svtEKmKZLJTI4f+E4WaUIjl97DqXSU=;
        b=H8irK+Osvd5/NMea6C2r1GFpZBWrHHaZILokNf+EzUtB9VXQuGth4p57msyX58c72I
         BVS9p7SUJ9Ho5x84+1HNCmGxopREwBDYmLtJDylfgI4EZ+7joh10aS9dW/3Me1HMX9i9
         KLU2hdnqrV1jtMgfD/EKDLlFdkj5qg7sYwI1yfOzOlbOt6HY2iMYC3DFSapETlxZlEZJ
         oJZKijencjKnphJ8ifD9VKkSjF3jIcNCojWUzJht2DTTc2t6NI1nncNYGAJ9y/McUXeM
         sL4FyYGwt5vALnQkiYesKM5dizXsTnPNl2iDLt/04SPTuTnymMWwoBY4N45AafuuaO1j
         kQjg==
X-Gm-Message-State: AOJu0YySC7XKaPugDy8OTZW9W/fSjf9gGRXhDjHGTgRvl0eA6gBWh1Jk
	Ve6ox/+zjDc/xdlkp5nDsm9im32+a0CTQC5IpwM1lf2OU+QPt71cbZfaHPc5Tnzj2u/rKlIHQ0l
	f5u6JdXB8IQ4V1qweoEgDc8L973XHVynNtrEz2LGlmpQuL3YwE8+PNJOOQcU=
X-Received: by 2002:a17:902:fe82:b0:1db:8fd9:ba0d with SMTP id x2-20020a170902fe8200b001db8fd9ba0dmr6802822plm.23.1709558643338;
        Mon, 04 Mar 2024 05:24:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEJv5/sMWjUl805F2QTGqPcxSDc7h/6Kqp1/yxqlGlU3EtvZznDtzI9+Zpf8qSHe+ESsR2KWQ==
X-Received: by 2002:a17:902:fe82:b0:1db:8fd9:ba0d with SMTP id x2-20020a170902fe8200b001db8fd9ba0dmr6802808plm.23.1709558643049;
        Mon, 04 Mar 2024 05:24:03 -0800 (PST)
Received: from [10.72.112.93] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id u10-20020a170903124a00b001dc944299acsm8464378plh.217.2024.03.04.05.24.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 05:24:02 -0800 (PST)
Message-ID: <4db59457-d2d7-42f9-b0d9-6719a10e2a3b@redhat.com>
Date: Mon, 4 Mar 2024 21:23:49 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] libceph: init the cursor when preparing the sparse read
Content-Language: en-US
To: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com,
 mchangir@redhat.com, stable@vger.kernel.org,
 Luis Henriques <lhenriques@suse.de>
References: <20240229041950.738878-1-xiubli@redhat.com>
 <CAOi1vP-n34TCcKoLLKe3yXRqS93qT4nc5pkM8Byo-D4zH-KZWA@mail.gmail.com>
 <6c3f5ef9-e350-4a1e-81dd-6ab63e7e5ef3@redhat.com>
 <CAOi1vP_WGs4yQz62UaVBDWk-vkcAQ7=SgQG37Zu86Q2QusMgOw@mail.gmail.com>
 <256b4b68-87e6-4686-9c51-e00712add8b3@redhat.com>
 <CAOi1vP-LFKzij5pYz+HLWAUiBZ-6+UYpoND08ceDofhN7xN-zw@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP-LFKzij5pYz+HLWAUiBZ-6+UYpoND08ceDofhN7xN-zw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 3/4/24 19:12, Ilya Dryomov wrote:
> On Mon, Mar 4, 2024 at 1:43 AM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 3/2/24 01:15, Ilya Dryomov wrote:
>>> On Fri, Mar 1, 2024 at 2:53 AM Xiubo Li <xiubli@redhat.com> wrote:
>>>> On 2/29/24 18:48, Ilya Dryomov wrote:
>>>>> On Thu, Feb 29, 2024 at 5:22 AM <xiubli@redhat.com> wrote:
>>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>>
>>>>>> The osd code has remove cursor initilizing code and this will make
>>>>>> the sparse read state into a infinite loop. We should initialize
>>>>>> the cursor just before each sparse-read in messnger v2.
>>>>>>
>>>>>> Cc: stable@vger.kernel.org
>>>>>> URL: https://tracker.ceph.com/issues/64607
>>>>>> Fixes: 8e46a2d068c9 ("libceph: just wait for more data to be available on the socket")
>>>>>> Reported-by: Luis Henriques <lhenriques@suse.de>
>>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>>> ---
>>>>>>     net/ceph/messenger_v2.c | 3 +++
>>>>>>     1 file changed, 3 insertions(+)
>>>>>>
>>>>>> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
>>>>>> index a0ca5414b333..7ae0f80100f4 100644
>>>>>> --- a/net/ceph/messenger_v2.c
>>>>>> +++ b/net/ceph/messenger_v2.c
>>>>>> @@ -2025,6 +2025,7 @@ static int prepare_sparse_read_cont(struct ceph_connection *con)
>>>>>>     static int prepare_sparse_read_data(struct ceph_connection *con)
>>>>>>     {
>>>>>>            struct ceph_msg *msg = con->in_msg;
>>>>>> +       u64 len = con->in_msg->sparse_read_total ? : data_len(con->in_msg);
>>>>>>
>>>>>>            dout("%s: starting sparse read\n", __func__);
>>>>>>
>>>>>> @@ -2034,6 +2035,8 @@ static int prepare_sparse_read_data(struct ceph_connection *con)
>>>>>>            if (!con_secure(con))
>>>>>>                    con->in_data_crc = -1;
>>>>>>
>>>>>> +       ceph_msg_data_cursor_init(&con->v2.in_cursor, con->in_msg, len);
>>>>>> +
>>>>>>            reset_in_kvecs(con);
>>>>>>            con->v2.in_state = IN_S_PREPARE_SPARSE_DATA_CONT;
>>>>>>            con->v2.data_len_remain = data_len(msg);
>>>>>> --
>>>>>> 2.43.0
>>>>>>
>>>>> Hi Xiubo,
>>>>>
>>>>> How did this get missed?  Was generic/580 not paired with msgr2 in crc
>>>>> mode or are we not running generic/580 at all?
>>>>>
>>>>> Multiple runs have happened since the patch was staged so if the matrix
>>>>> is set up correctly ms_mode=crc should have been in effect for xfstests
>>>>> at least a couple of times.
>>>> I just found that my test script is incorrect and missed this case.
>>>>
>>>> The test locally is covered the msgr1 mostly and I think the qa test
>>>> suite also doesn't cover it too. I will try to improve the qa tests later.
>>> Could you please provide some details on the fixes needed to address
>>> the coverage gap in the fs suite?
>> Mainly to support the msgr v2 for fscrypt, before we only tested the
>> fscrypt based on the msgr v1 for kclient. In ceph upstream we have
>> support this while not backport it to reef yet.
> I'm even more confused now...  If the fs suite in main covers msgr2 +
> fscrypt (I'm taking your "in ceph upstream we have support" to mean
> that), how did this bug get missed by runs on main?  At least a dozen
> of them must have gone through in the form of Venky's integration
> branches.

Maybe some other known issues have masked this bug, before the qa tests 
didn't behave well for a long time for some reasons.

And many test will run base on reef branch, which hasn't backport it yet.

Thanks

- Xiubo

> Thanks,
>
>                  Ilya
>


