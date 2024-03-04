Return-Path: <ceph-devel+bounces-949-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4E4B86F802
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Mar 2024 01:43:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D924F1C2098A
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Mar 2024 00:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77AF4A41;
	Mon,  4 Mar 2024 00:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b53mMlcl"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E15E399
	for <ceph-devel@vger.kernel.org>; Mon,  4 Mar 2024 00:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709513022; cv=none; b=AXVZPlx3CqRXAgOrqQJULa/gZK0iSWIe88H7Lwn5Ri9HUCMOuW6qhh4roYTv9kt1Z+mIhR5cNNV+0cAOz5FxgPczKsYBC2ELyhdTv0Ow05sZcaSWvYedwWBdLjWRitKRB/WKrun3xIdLevDyzB3tA0+OhWiI3Z6TgJAaVEXpbTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709513022; c=relaxed/simple;
	bh=EGostBWyT69PX+ts+J4Vvjs49jXBgL3WmfSpp+jGldY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PD+J9LodZ8l4HEvucerflQsKDcD7KfGpT3mErxQ5G6loiXK1hsrsnFy/SEDz5oHEjgeil4TaIhNjctrvWMObhE3MHfHFu3/YmGg3ycH7OqIzB95mvUPdZfLsJxmsvReUWbCxH1Su7//MyTa4+hAjK7cbGoKLQjnmDtiy4F9JpDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b53mMlcl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709513019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AAgzwk1DNmevBoMFD56mm6serJC9gvrljxIZzVIRPeY=;
	b=b53mMlclb0o/BKKgZpqTOBtSkgSjdcgJos6CspWj+WsGIGsV6ssiebOELN/n2UyxG1aWtz
	SjJsN6e+qVGhoXqSQyJI6uOKqIDnxH88sGAoBCriMFdBSfg59UQjSBJPpjd62CUZ6qzjhN
	DooBSVyCn36xuLuI5a7v0neSLuzbLZs=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-8lAHZHYePo63hOeWJZ84Ug-1; Sun, 03 Mar 2024 19:43:38 -0500
X-MC-Unique: 8lAHZHYePo63hOeWJZ84Ug-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-29b2c29b9e5so2154512a91.2
        for <ceph-devel@vger.kernel.org>; Sun, 03 Mar 2024 16:43:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709513017; x=1710117817;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AAgzwk1DNmevBoMFD56mm6serJC9gvrljxIZzVIRPeY=;
        b=pauANFrc0bNIqVkv5optbSge6pcQ4O9F9E9uWpyRjLADzj2NME0IX40TpfZjH2r+K9
         gL1dgdzz80TkVrGkYKNT5pbtzgNgkNT0w2eeSVpKXPv0Wpf7JjAyst7+zQDmJPyO0naW
         DDL5s3g94lfQB4jywZ6e3OBG0JVR2Usr2dD2dBHBRyo3NYFOpaJLjMpJlDClSTyp3xWL
         4O+/GYXnpTUGdzSzpOlw7FJ8BuTpQEWRAQDWFS2t7UzUHHY3VV0/z+F26vEdOXB1SLvX
         BLFnvI/4V60QRnm4nLb2LR1HHMxT9yZsjUc8cgOdLsMWpmndKybIzIe1gLfqAf+sIf0r
         aDtA==
X-Gm-Message-State: AOJu0YzqS/h2MU/f9gImykhfmWRc8/cqr0AxIZiEKZFlc0zlZoHvRCQH
	wBHjD9vvJW5Lk9BByWOrXbZFUkT/42CogM9Dan885+fwnpit/mTQP+g5On/lNcgaspb8YzL016t
	/K9yPJptuvZ0lERS4U7lVuXFt5LZDAyQ94KV+ninaq4r5QJi26qUdYVLldvY=
X-Received: by 2002:a17:90a:e64a:b0:29a:e9cd:74aa with SMTP id ep10-20020a17090ae64a00b0029ae9cd74aamr5640117pjb.35.1709513016769;
        Sun, 03 Mar 2024 16:43:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGasvtAI4LF7kjqQSpUtfWr34OKLH0V5MQG9JDO8MeYGvB5JqAcKjGqWhhK6oSEWOhLZqQ+Kw==
X-Received: by 2002:a17:90a:e64a:b0:29a:e9cd:74aa with SMTP id ep10-20020a17090ae64a00b0029ae9cd74aamr5640109pjb.35.1709513016472;
        Sun, 03 Mar 2024 16:43:36 -0800 (PST)
Received: from [10.72.112.32] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y6-20020a17090aca8600b0029a78f22bd2sm5788124pjt.33.2024.03.03.16.43.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Mar 2024 16:43:36 -0800 (PST)
Message-ID: <256b4b68-87e6-4686-9c51-e00712add8b3@redhat.com>
Date: Mon, 4 Mar 2024 08:43:31 +0800
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
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP_WGs4yQz62UaVBDWk-vkcAQ7=SgQG37Zu86Q2QusMgOw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 3/2/24 01:15, Ilya Dryomov wrote:
> On Fri, Mar 1, 2024 at 2:53 AM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 2/29/24 18:48, Ilya Dryomov wrote:
>>> On Thu, Feb 29, 2024 at 5:22 AM <xiubli@redhat.com> wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> The osd code has remove cursor initilizing code and this will make
>>>> the sparse read state into a infinite loop. We should initialize
>>>> the cursor just before each sparse-read in messnger v2.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> URL: https://tracker.ceph.com/issues/64607
>>>> Fixes: 8e46a2d068c9 ("libceph: just wait for more data to be available on the socket")
>>>> Reported-by: Luis Henriques <lhenriques@suse.de>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    net/ceph/messenger_v2.c | 3 +++
>>>>    1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
>>>> index a0ca5414b333..7ae0f80100f4 100644
>>>> --- a/net/ceph/messenger_v2.c
>>>> +++ b/net/ceph/messenger_v2.c
>>>> @@ -2025,6 +2025,7 @@ static int prepare_sparse_read_cont(struct ceph_connection *con)
>>>>    static int prepare_sparse_read_data(struct ceph_connection *con)
>>>>    {
>>>>           struct ceph_msg *msg = con->in_msg;
>>>> +       u64 len = con->in_msg->sparse_read_total ? : data_len(con->in_msg);
>>>>
>>>>           dout("%s: starting sparse read\n", __func__);
>>>>
>>>> @@ -2034,6 +2035,8 @@ static int prepare_sparse_read_data(struct ceph_connection *con)
>>>>           if (!con_secure(con))
>>>>                   con->in_data_crc = -1;
>>>>
>>>> +       ceph_msg_data_cursor_init(&con->v2.in_cursor, con->in_msg, len);
>>>> +
>>>>           reset_in_kvecs(con);
>>>>           con->v2.in_state = IN_S_PREPARE_SPARSE_DATA_CONT;
>>>>           con->v2.data_len_remain = data_len(msg);
>>>> --
>>>> 2.43.0
>>>>
>>> Hi Xiubo,
>>>
>>> How did this get missed?  Was generic/580 not paired with msgr2 in crc
>>> mode or are we not running generic/580 at all?
>>>
>>> Multiple runs have happened since the patch was staged so if the matrix
>>> is set up correctly ms_mode=crc should have been in effect for xfstests
>>> at least a couple of times.
>> I just found that my test script is incorrect and missed this case.
>>
>> The test locally is covered the msgr1 mostly and I think the qa test
>> suite also doesn't cover it too. I will try to improve the qa tests later.
> Could you please provide some details on the fixes needed to address
> the coverage gap in the fs suite?

Mainly to support the msgr v2 for fscrypt, before we only tested the 
fscrypt based on the msgr v1 for kclient. In ceph upstream we have 
support this while not backport it to reef yet.

>    I'm lost because you marked [1] for
> backporting to reef as (part of?) the solution, however Venky's job [2]
> that is linked there in the tracker is based on main and therefore has
> everything.
>
> Additionally, [2] seems to be have failed when installing packages, so
> the relationship to [1] isn't obvious to me.

It should be a wrong link, let me check and correct it later.

Thanks

- Xiubo

>
> [1] https://tracker.ceph.com/issues/59195
> [2] https://pulpito.ceph.com/vshankar-2024-02-27_04:05:06-fs-wip-vshankar-testing-20240226.124304-testing-default-smithi/7574417/
>
> Thanks,
>
>                  Ilya
>


