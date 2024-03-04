Return-Path: <ceph-devel+bounces-950-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BBD286F814
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Mar 2024 02:02:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DEAFE281136
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Mar 2024 01:02:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4804C10F2;
	Mon,  4 Mar 2024 01:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MCWFUcB/"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA6AA31
	for <ceph-devel@vger.kernel.org>; Mon,  4 Mar 2024 01:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709514168; cv=none; b=NecZxV21Z9EoYeaQJ0grzeBioGVhcRvTcWKPwvWRQ+Aa8zm1NXgKTu63n7tc3UMKnw3P4DLH5XxeXxRoQpeHk9tQXr2kluP1N9V76s45z77Qg593b+PM+wAQ6z8OMLsZFprkhL/u/AZKr/ucxpUop/kAglhVjgQqHXdgV2hiwXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709514168; c=relaxed/simple;
	bh=fv/dEhjuZMSmJm7bwvBQHoIjAnf5geoAYftFqrw0Zxo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rIwpPn93eh/U+369S6Vw6/y6K2/4MGXfDiQ3lHLJRBEydz79QAci+fa/wobi6gX7fPeG8MvRaOtBFq0cDgV0K5UCTlVoCpfArWgNY+xyC4JPHulYtyIkbp1iuggkruJoXE8TNro8/0cjT3te8sjq2EJtanc7BNTTy40kWOjwCKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MCWFUcB/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709514165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ux/l/uAdMQn6URnJwMHST/+jcvMEvOJC7Jlz3La/aMw=;
	b=MCWFUcB/HmVDdPdHgp/RZdgLkiThnSSNg3NdhB3+7lFJeeZ8D8QHzV6r55kJCItCwl8nmD
	l2LrwjMmez1GkmJMM7KtljgKy3fWVp1H0eKKpgnoHRnO0wj2wgCBnwDSLyxEb6zgbIyCYI
	ISkbCgHqVpsKVSmXe7fpMTOmv19UxWM=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-61-KYwPPJNoNVCoL6ZHK2TOow-1; Sun, 03 Mar 2024 20:02:43 -0500
X-MC-Unique: KYwPPJNoNVCoL6ZHK2TOow-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-6e4d0e28cd1so3040714b3a.0
        for <ceph-devel@vger.kernel.org>; Sun, 03 Mar 2024 17:02:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709514163; x=1710118963;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ux/l/uAdMQn6URnJwMHST/+jcvMEvOJC7Jlz3La/aMw=;
        b=xKug0/1aU1pvrSc+hhZ0mkR+hh/HL77h6vAb7cayQ0G+p0R8Jo37sdIkjizL05uZCN
         8cWA/dh9YY6c0HQnht7kKouH3vJkp2ZSrm9MGwQGV99QE1gAOQScVUlAwIxCVTdoNjV7
         WS3QsAcdHrmrnG4CA0RvMMAyESSNRfsbsBHyPdpc/w0Txw45RJ7xOHs3jVLf4laa5JcJ
         xxH8M59f5zqvSuqSfzR3np/u3KZgps9wPp+F/d983swqbdt1vNlQ46QtWrQvGOJgIUwl
         ZQR6lF4u39mPt7tPfU/oNARUAX5xOsn5rI7xyjQBbNMt8SNW45sZLosCoejtxSbYucHR
         28xw==
X-Gm-Message-State: AOJu0YwxRqJUR9TCBg9cOPSnHigozKHtQtcwc5lPhKcyaBHHVH4Y8xH+
	d6zMvGgESGvWcVLhAVsZPAkKxttCb7ax8HjjZ0bhvCKQ06vqG7wWEcJ+qbQPoijddKxR0GTZmjg
	5jBSZMLxAWLuxaUhyGekBKoJ5rrMqggYt725Hyye+CXRuHc+v9IAbW+sCgsI=
X-Received: by 2002:a05:6a00:ad1:b0:6e6:1df9:af92 with SMTP id c17-20020a056a000ad100b006e61df9af92mr2709777pfl.14.1709514161289;
        Sun, 03 Mar 2024 17:02:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFkeOVoLL87DoaL4mqpI5+F+wb6XuYAautK83KE/VzbgdDZjC1/ta7Omgd9DS5FZ3oyi2O+4g==
X-Received: by 2002:a05:6a00:ad1:b0:6e6:1df9:af92 with SMTP id c17-20020a056a000ad100b006e61df9af92mr2709695pfl.14.1709514159468;
        Sun, 03 Mar 2024 17:02:39 -0800 (PST)
Received: from [10.72.112.32] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id p20-20020a62ab14000000b006e47e57d976sm6129396pff.166.2024.03.03.17.02.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Mar 2024 17:02:39 -0800 (PST)
Message-ID: <10abc117-a0e8-47ab-b9e2-05424c358c4e@redhat.com>
Date: Mon, 4 Mar 2024 09:02:33 +0800
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
 <CAOi1vP-hp7jmECXP4WNDT801qmBBZJjnUm0ic61Pw-JgipOyNw@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP-hp7jmECXP4WNDT801qmBBZJjnUm0ic61Pw-JgipOyNw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 3/2/24 00:16, Ilya Dryomov wrote:
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
> Hi Xiubo,
>
> Why is sparse_read_total being tested here?  Isn't this function
> supposed to be called only for sparse reads, after the state is set to
> IN_S_PREPARE_SPARSE_DATA based on a similar test:
>
>      if (msg->sparse_read_total)
>              con->v2.in_state = IN_S_PREPARE_SPARSE_DATA;
>      else
>              con->v2.in_state = IN_S_PREPARE_READ_DATA;

Then the patch could be simplified and just be:

diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index a0ca5414b333..ab3ab130a911 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -2034,6 +2034,9 @@ static int prepare_sparse_read_data(struct 
ceph_connection *con)
         if (!con_secure(con))
                 con->in_data_crc = -1;

+       ceph_msg_data_cursor_init(&con->v2.in_cursor, con->in_msg,
+ con->in_msg->sparse_read_total);
+
         reset_in_kvecs(con);
         con->v2.in_state = IN_S_PREPARE_SPARSE_DATA_CONT;
         con->v2.data_len_remain = data_len(msg);

Else where should we do the test like this ?

Thanks

- Xiubo

> Thanks,
>
>                  Ilya
>


