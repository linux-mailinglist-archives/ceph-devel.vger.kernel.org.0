Return-Path: <ceph-devel+bounces-944-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6973E86D93C
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Mar 2024 02:53:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62ED71C2272C
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Mar 2024 01:53:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 677F2364C4;
	Fri,  1 Mar 2024 01:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DW3ZYV6P"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB613399B
	for <ceph-devel@vger.kernel.org>; Fri,  1 Mar 2024 01:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709258005; cv=none; b=rLqLtlGOinuFGaegQpQSfKBH15ZFhXGMSGFTOYf0g8exUZhzeNzAWG/NoqeF5JDjN6+qztbNNd1b5BtFD/8sSjvgcBYhxkF62lVyiwU5yuhh5BiNtSxWcdgh1uo0MsZdesD5RgQxYeb+Swvk/wad0w8AQj25s9IhLKWhZXuIL5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709258005; c=relaxed/simple;
	bh=nIihlmgW+uwhT9twu/+xEC5jEg7HHf0+JI2opq3SmnI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I/YO+PxDpJOpiTekxD4KXtYvyKMWzmlMFqkZNm4GDKJbnzRIRFEmK53O+fvYiaQvYf8autToFdZ8MCD4rieFJYzii+1N9iVOrsmBAibkWScXp1l73skzkf/D4PVeKJkskwp4A+us/+77g6GAom6ZuTbuE+AkzHh9GENs9UMwCj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DW3ZYV6P; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709258000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H2f+zUV1B6Erfx6sDWIeH2uAfVkZLUavK8muqCOy4L8=;
	b=DW3ZYV6PR2NLDJLELcdEVFDl6aVWtP7j/9BpgMPtaE5u4AvUKzUIix6ExQqKgxDvcNqs1C
	jXkgUM1etqWqJ+n2NXBSlbnRjdte4tMO04reREgL8DhhF1LVkn2ATDdW6FjS50tZWmqj+1
	I8e0IhAlR6nY3DoVf8ax7sx8EtP7VKw=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-5ktKwWcuPyqInj-zvtwg7w-1; Thu, 29 Feb 2024 20:53:18 -0500
X-MC-Unique: 5ktKwWcuPyqInj-zvtwg7w-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1dbcbffd853so17279695ad.3
        for <ceph-devel@vger.kernel.org>; Thu, 29 Feb 2024 17:53:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709257998; x=1709862798;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H2f+zUV1B6Erfx6sDWIeH2uAfVkZLUavK8muqCOy4L8=;
        b=vc1aNWxe0ql+6W8kDYMrXSZ4EGVXo1Hlm7gaInNOSCqM0h/y8NdIwfWU7XpG43nnYC
         Sqd0k0AQUUP/hb6qL9MJMXxcQUVW82wU79SwfgP9ZAW0R+Aa20KLOtMGaWK/e33HNpcU
         8s2aF8OzmFYTkc34UVpwVf/3xBn9J9tWv65KHLwvQfnkibd8W0LL4R6o5qoQrKUSECpd
         btbg4F8y0ZZzUipTFijvkpMB0V5X4/mRaKOuUYOmJtyTOVVAxG/SSjplpZPBac39D+9G
         nP760GKFOGSaO77X6VLSYQJiGz3AXmNKpo6o6e0zDeVJjE5KuyoT4/LbLjqJIypH02MN
         ZGqA==
X-Gm-Message-State: AOJu0YwrlUmkwgnJxZUzOscQ+eUI1ai8j/mzWGZOQg5Txm82SXYeg4E9
	LqrQHMXsuIjzPIeFCEXg7rRjG/hfBZZ4Mpxc5XEjtWjcOQRV6nnxL4mj8AYeagVztX8hhfns3EE
	Xjc4WDmb9CRMrm/NOY/jOqKOoYUf3hV7IwS/I1z0raxPB9Tjg3uFF5lqq3+Q=
X-Received: by 2002:a17:902:ecd1:b0:1db:f372:a93c with SMTP id a17-20020a170902ecd100b001dbf372a93cmr309545plh.43.1709257997771;
        Thu, 29 Feb 2024 17:53:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFgxp8KpJKH+5MY8w2F/PB5Ot/ZUK5Av/ZaZV4KJP/g83TZi3+n+/NnGn+HsPorVx5PFMYwYQ==
X-Received: by 2002:a17:902:ecd1:b0:1db:f372:a93c with SMTP id a17-20020a170902ecd100b001dbf372a93cmr309530plh.43.1709257997437;
        Thu, 29 Feb 2024 17:53:17 -0800 (PST)
Received: from [10.72.112.28] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id z17-20020a170903019100b001db4433ef95sm2184312plg.152.2024.02.29.17.53.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Feb 2024 17:53:17 -0800 (PST)
Message-ID: <6c3f5ef9-e350-4a1e-81dd-6ab63e7e5ef3@redhat.com>
Date: Fri, 1 Mar 2024 09:53:12 +0800
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
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP-n34TCcKoLLKe3yXRqS93qT4nc5pkM8Byo-D4zH-KZWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 2/29/24 18:48, Ilya Dryomov wrote:
> On Thu, Feb 29, 2024 at 5:22 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The osd code has remove cursor initilizing code and this will make
>> the sparse read state into a infinite loop. We should initialize
>> the cursor just before each sparse-read in messnger v2.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://tracker.ceph.com/issues/64607
>> Fixes: 8e46a2d068c9 ("libceph: just wait for more data to be available on the socket")
>> Reported-by: Luis Henriques <lhenriques@suse.de>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   net/ceph/messenger_v2.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
>> index a0ca5414b333..7ae0f80100f4 100644
>> --- a/net/ceph/messenger_v2.c
>> +++ b/net/ceph/messenger_v2.c
>> @@ -2025,6 +2025,7 @@ static int prepare_sparse_read_cont(struct ceph_connection *con)
>>   static int prepare_sparse_read_data(struct ceph_connection *con)
>>   {
>>          struct ceph_msg *msg = con->in_msg;
>> +       u64 len = con->in_msg->sparse_read_total ? : data_len(con->in_msg);
>>
>>          dout("%s: starting sparse read\n", __func__);
>>
>> @@ -2034,6 +2035,8 @@ static int prepare_sparse_read_data(struct ceph_connection *con)
>>          if (!con_secure(con))
>>                  con->in_data_crc = -1;
>>
>> +       ceph_msg_data_cursor_init(&con->v2.in_cursor, con->in_msg, len);
>> +
>>          reset_in_kvecs(con);
>>          con->v2.in_state = IN_S_PREPARE_SPARSE_DATA_CONT;
>>          con->v2.data_len_remain = data_len(msg);
>> --
>> 2.43.0
>>
> Hi Xiubo,
>
> How did this get missed?  Was generic/580 not paired with msgr2 in crc
> mode or are we not running generic/580 at all?
>
> Multiple runs have happened since the patch was staged so if the matrix
> is set up correctly ms_mode=crc should have been in effect for xfstests
> at least a couple of times.

I just found that my test script is incorrect and missed this case.

The test locally is covered the msgr1 mostly and I think the qa test 
suite also doesn't cover it too. I will try to improve the qa tests later.

Thanks

- Xiubo


> Thanks,
>
>                  Ilya
>


