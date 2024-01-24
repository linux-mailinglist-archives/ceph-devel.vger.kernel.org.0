Return-Path: <ceph-devel+bounces-653-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 32E0F839E2A
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jan 2024 02:20:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C9447B22387
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jan 2024 01:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C0791106;
	Wed, 24 Jan 2024 01:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ECK+GHkx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E593CEC5
	for <ceph-devel@vger.kernel.org>; Wed, 24 Jan 2024 01:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706059244; cv=none; b=K/PHC+/Jy/yIDvSs86xGT4Cp3KZKdLSwPfpqHgSZhkERyF6bQQpBqroeWMktCazzaCDf8da+Mng2gqKpLo7O0YScIczyYDq9tfDpxhZZbDwnx1IneY9ykqqcxBbhLPanuj3qpdPAsQudrTrmXNEXdYP23VYJS9ddbuPiDiiugxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706059244; c=relaxed/simple;
	bh=y2BswqU4i22c1HEvovu3sD3vMZpv10iXfJs7DhVIg4M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tsksfI1Gpns3uMlwavTZ90reOuFnrThYP03d1OLlRgtY7JoGmbD+BSh16/CKvwfK7gCRsodWRGMQqOfY9q1IjbKb55SF2q3QzeWhOhiAjMvTfuvH0ZiHmSZqP8tIYd5MmELGDJq/iQIY2eN1fA+xFyWeSDD2KBpSR74sutGjvFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ECK+GHkx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706059240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ernLNckXgAa0tYKW2Y3MqYCPJfv5P4TeQtkjJiWZ5i4=;
	b=ECK+GHkxGORHDstMV/EroslbwEkrn2En/W8r7kihJHCIQGmAYqTd2rGF4qTz/kl920smyb
	rDBgbtFkhRHeAFIy5IK9EaaK4qBr3KG3C4aFksVDIpctc4Paakg1u42oDWbHXnotwXufYk
	W/bL8uOFY2V0G/UqAsMmkwa7dyrKBUM=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-107-635TkM1BNiKwZ1WwCH_Ocg-1; Tue, 23 Jan 2024 20:20:38 -0500
X-MC-Unique: 635TkM1BNiKwZ1WwCH_Ocg-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-290a26e6482so2528879a91.0
        for <ceph-devel@vger.kernel.org>; Tue, 23 Jan 2024 17:20:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706059238; x=1706664038;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ernLNckXgAa0tYKW2Y3MqYCPJfv5P4TeQtkjJiWZ5i4=;
        b=jgj5iQGQ/1W7SfJZjsSrn1Gs3XtINBdrGTkl3uuLlViWE0+7cqQl1YaxyylVd9lt3s
         mTr7YxyMdsysCCMck9Zkw/Lfd0lnfTUtC5TKyHBT1d5/H/Ohu8e4nnTc4ug76y8wGaw9
         8Nm+T9RXfwQ37aV+lCMfmZNGlwpIkrC2J7GqlRIEDKbe0GgTuAl00kXq6lo0SMi5Sf3D
         tdZjjgeITK6itiLIAhp6cTfSVE1JIsXIdYdlPvMbnkbFbKWXoEAJHxeBiCFLeSFHr+k+
         hycPn1M0bi+CSgpRwoubn9y5cuaVMO19SkJKGY1DDGZxGvSFC3wUg5e9WE0GMxwwmf50
         DwBw==
X-Gm-Message-State: AOJu0Yy8uuRIaa/TlNJanob1ig3TP2jrTrHBgwltGDme+ceQH1qu6z+F
	VOqmcQc/ugIYBa+t2097swWDfNC6P7hkYAZM2xZ2tvOydghO/eukdvyQDALCXAmTv7DzdzgEDrf
	1iFxRx7S/zMZDMQsQBRV0pCo6yherSxKYXxrPDug1prlzKQapwDK0KyAlQ7s=
X-Received: by 2002:a05:6a20:dd82:b0:19c:6293:e967 with SMTP id kw2-20020a056a20dd8200b0019c6293e967mr82486pzb.115.1706059237732;
        Tue, 23 Jan 2024 17:20:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFi8LiBWTrV1joHH5CPcD4pcuPwaIMuB7RzreGPwBjyLVrR52+9687xKl3BZcDwayTfjU4g5A==
X-Received: by 2002:a05:6a20:dd82:b0:19c:6293:e967 with SMTP id kw2-20020a056a20dd8200b0019c6293e967mr82481pzb.115.1706059237425;
        Tue, 23 Jan 2024 17:20:37 -0800 (PST)
Received: from [10.72.112.62] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a25-20020aa78659000000b006dd7c177749sm2107989pfo.143.2024.01.23.17.20.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jan 2024 17:20:37 -0800 (PST)
Message-ID: <2d8e9ed1-5854-4dd0-bc05-2d41c731ba2d@redhat.com>
Date: Wed, 24 Jan 2024 09:20:32 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/3] libceph: just wait for more data to be available
 on the socket
Content-Language: en-US
To: Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com, vshankar@redhat.com, mchangir@redhat.com
References: <20240123131204.1166101-1-xiubli@redhat.com>
 <20240123131204.1166101-4-xiubli@redhat.com>
 <3139b844b60348f306449e3ea4a3c91c40a18d74.camel@kernel.org>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <3139b844b60348f306449e3ea4a3c91c40a18d74.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 1/23/24 22:47, Jeff Layton wrote:
> On Tue, 2024-01-23 at 21:12 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> A short read may occur while reading the message footer from the
>> socket.  Later, when the socket is ready for another read, the
>> messenger shoudl invoke all read_partial* handlers, except the
>> read_partial_sparse_msg_data().  The contract between the messenger
>> and these handlers is that the handlers should bail if the area
>> of the message is responsible for is already processed.  So,
>> in this case, it's expected that read_sparse_msg_data() would bail,
>> allowing the messenger to invoke read_partial() for the footer and
>> pick up where it left off.
>>
>> However read_partial_sparse_msg_data() violates that contract and
>> ends up calling into the state machine in the OSD client. The
>> sparse-read state machine just assumes that it's a new op and
>> interprets some piece of the footer as the sparse-read extents/data
>> and then returns bogus extents/data length, etc.
>>
>> This will just reuse the 'total_resid' to determine whether should
>> the read_partial_sparse_msg_data() bail out or not. Because once
>> it reaches to zero that means all the extents and data have been
>> successfully received in last read, else it could break out when
>> partially reading any of the extents and data. And then the
>> osd_sparse_read() could continue where it left off.
>>
> Thanks for the detailed description. That really helps!
>
I just copied from Ilya's comments and with some changes.

>> URL: https://tracker.ceph.com/issues/63586
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   include/linux/ceph/messenger.h |  2 +-
>>   net/ceph/messenger_v1.c        | 25 +++++++++++++------------
>>   net/ceph/messenger_v2.c        |  4 ++--
>>   net/ceph/osd_client.c          |  9 +++------
>>   4 files changed, 19 insertions(+), 21 deletions(-)
>>
>> diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
>> index 2eaaabbe98cb..1717cc57cdac 100644
>> --- a/include/linux/ceph/messenger.h
>> +++ b/include/linux/ceph/messenger.h
>> @@ -283,7 +283,7 @@ struct ceph_msg {
>>   	struct kref kref;
>>   	bool more_to_follow;
>>   	bool needs_out_seq;
>> -	bool sparse_read;
>> +	u64 sparse_read_total;
>>   	int front_alloc_len;
>>   
>>   	struct ceph_msgpool *pool;
>> diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
>> index 4cb60bacf5f5..4c76c8390de1 100644
>> --- a/net/ceph/messenger_v1.c
>> +++ b/net/ceph/messenger_v1.c
>> @@ -160,8 +160,9 @@ static size_t sizeof_footer(struct ceph_connection *con)
>>   static void prepare_message_data(struct ceph_msg *msg, u32 data_len)
>>   {
>>   	/* Initialize data cursor if it's not a sparse read */
>> -	if (!msg->sparse_read)
>> -		ceph_msg_data_cursor_init(&msg->cursor, msg, data_len);
>> +	u64 len = msg->sparse_read_total ? : data_len;
>> +
>> +	ceph_msg_data_cursor_init(&msg->cursor, msg, len);
>>   }
>>   
>>   /*
>> @@ -1036,7 +1037,7 @@ static int read_partial_sparse_msg_data(struct ceph_connection *con)
>>   	if (do_datacrc)
>>   		crc = con->in_data_crc;
>>   
>> -	do {
>> +	while (cursor->total_resid) {
>>   		if (con->v1.in_sr_kvec.iov_base)
>>   			ret = read_partial_message_chunk(con,
>>   							 &con->v1.in_sr_kvec,
>> @@ -1044,23 +1045,23 @@ static int read_partial_sparse_msg_data(struct ceph_connection *con)
>>   							 &crc);
>>   		else if (cursor->sr_resid > 0)
>>   			ret = read_partial_sparse_msg_extent(con, &crc);
>> -
>> -		if (ret <= 0) {
>> -			if (do_datacrc)
>> -				con->in_data_crc = crc;
>> -			return ret;
>> -		}
>> +		if (ret <= 0)
>> +			break;
>>   
>>   		memset(&con->v1.in_sr_kvec, 0, sizeof(con->v1.in_sr_kvec));
>>   		ret = con->ops->sparse_read(con, cursor,
>>   				(char **)&con->v1.in_sr_kvec.iov_base);
>> +		if (ret <= 0) {
>> +			ret = ret ? : 1; /* must return > 0 to indicate success */
> nit: this syntax is a gcc-ism (AIUI) and is not preferred. It'd be
> better spell it out in this case (particularly since it's only 4 extra
> chars:
>
> 			ret = ret ? ret : 1;

Sure.

Thanks Jeff.

- Xiubo


>> +			break;
>> +		}
>>   		con->v1.in_sr_len = ret;
>> -	} while (ret > 0);
>> +	}
>>   
>>   	if (do_datacrc)
>>   		con->in_data_crc = crc;
>>   
>> -	return ret < 0 ? ret : 1;  /* must return > 0 to indicate success */
>> +	return ret;
>>   }
>>   
>>   static int read_partial_msg_data(struct ceph_connection *con)
>> @@ -1253,7 +1254,7 @@ static int read_partial_message(struct ceph_connection *con)
>>   		if (!m->num_data_items)
>>   			return -EIO;
>>   
>> -		if (m->sparse_read)
>> +		if (m->sparse_read_total)
>>   			ret = read_partial_sparse_msg_data(con);
>>   		else if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE))
>>   			ret = read_partial_msg_data_bounce(con);
>> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
>> index f8ec60e1aba3..a0ca5414b333 100644
>> --- a/net/ceph/messenger_v2.c
>> +++ b/net/ceph/messenger_v2.c
>> @@ -1128,7 +1128,7 @@ static int decrypt_tail(struct ceph_connection *con)
>>   	struct sg_table enc_sgt = {};
>>   	struct sg_table sgt = {};
>>   	struct page **pages = NULL;
>> -	bool sparse = con->in_msg->sparse_read;
>> +	bool sparse = !!con->in_msg->sparse_read_total;
>>   	int dpos = 0;
>>   	int tail_len;
>>   	int ret;
>> @@ -2060,7 +2060,7 @@ static int prepare_read_tail_plain(struct ceph_connection *con)
>>   	}
>>   
>>   	if (data_len(msg)) {
>> -		if (msg->sparse_read)
>> +		if (msg->sparse_read_total)
>>   			con->v2.in_state = IN_S_PREPARE_SPARSE_DATA;
>>   		else
>>   			con->v2.in_state = IN_S_PREPARE_READ_DATA;
>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>> index 6beab9be51e2..1a5b1e1e24ca 100644
>> --- a/net/ceph/osd_client.c
>> +++ b/net/ceph/osd_client.c
>> @@ -5510,7 +5510,7 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
>>   	}
>>   
>>   	m = ceph_msg_get(req->r_reply);
>> -	m->sparse_read = (bool)srlen;
>> +	m->sparse_read_total = srlen;
>>   
>>   	dout("get_reply tid %lld %p\n", tid, m);
>>   
>> @@ -5777,11 +5777,8 @@ static int prep_next_sparse_read(struct ceph_connection *con,
>>   	}
>>   
>>   	if (o->o_sparse_op_idx < 0) {
>> -		u64 srlen = sparse_data_requested(req);
>> -
>> -		dout("%s: [%d] starting new sparse read req. srlen=0x%llx\n",
>> -		     __func__, o->o_osd, srlen);
>> -		ceph_msg_data_cursor_init(cursor, con->in_msg, srlen);
>> +		dout("%s: [%d] starting new sparse read req\n",
>> +		     __func__, o->o_osd);
>>   	} else {
>>   		u64 end;
>>   
> The patch itself looks fine though.
>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
>


