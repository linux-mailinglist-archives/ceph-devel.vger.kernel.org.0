Return-Path: <ceph-devel+bounces-592-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A471F832416
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Jan 2024 05:35:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 71867B22C0F
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Jan 2024 04:35:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7D5A28E8;
	Fri, 19 Jan 2024 04:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SOaaOxje"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12346FB1
	for <ceph-devel@vger.kernel.org>; Fri, 19 Jan 2024 04:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705638928; cv=none; b=LrHhmZJgurmQtc6ys5+Vr+oX/oXFGpDmeuhtovnY2CvFw/WDveuFmEiSfvID88xrshbm90gg5b/brq0lyqlcePCaMq4fBtG1vBbO0dsm/xwO8NeyXjuQXXyFQpE/siKF6py1a6FnDehNLR5Tj3Nam7Ze3AzkgMnqeh3cVUHr9MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705638928; c=relaxed/simple;
	bh=Kargcit0LZPJ4w39JSB+Q2ju/Zq81Sli6rJxNhhDR40=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SO1DG04Bfroy0ITP//9vXGZw1y+eCmMInU4B4HUThN0guUX14o3MMkv7V38p1WJ+WiIwjCWhTadAcQyX+2WsW27zGk3iRjadFtTSPumT9CX88SlqDStiW6i6NI8CLWXKPSIo97hv59XpD6yr+2XQjMBZvvQdsb2rDEHitX19Bas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SOaaOxje; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705638925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=osg153nRw9JOKBNh0EQe3lH1mYAvTie6XJ0QTDflKHI=;
	b=SOaaOxjelWJDpHu5Mhk7xD7PsiwzrUVJ9LEEO1q5NLgLxGC3mRUJio8EgJZobUuvGqXKKx
	yGRNtpiEV+zNopYV2bubEAKpjrHOf0pRL09enVmPRZ0l6KfYzcpE7hNb53TH8D/KGkoUGd
	tso37NiN5TZNfjlmrma1DdFxOeL2Z4I=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-325-6brjZBQfOhe03QiMneQBqQ-1; Thu, 18 Jan 2024 23:35:23 -0500
X-MC-Unique: 6brjZBQfOhe03QiMneQBqQ-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-5cdf9a354a0so316458a12.3
        for <ceph-devel@vger.kernel.org>; Thu, 18 Jan 2024 20:35:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705638922; x=1706243722;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=osg153nRw9JOKBNh0EQe3lH1mYAvTie6XJ0QTDflKHI=;
        b=jDDGqSb1KzKkBUz1kf1y48o7Sf6VuxWHU8c5bTmVU0nL7NDq7jh7uJ5p2nqKcz8NMQ
         8PACOLTSHfx9fMPAiZJ08fz2NOMwL2K/KZpNSXx49isqvk3fWGgeY+GI9HBEp5LuYdTW
         GZ3sOwv7tj0/p7mdlgbL1xl98dJFQRiD87TET57/1bq8UHjc1kPe4epa2lY3OwqLidnl
         8vGAfYCWI1DyyQgATuJ2ksjn+OXyJzHBidROYc8L2+LZS5WbHHeUiYYQsD0twJK3ndcj
         bLTPXVDBjugj2AC/JBaust9w9mK20HzMb7nQf69sQ2Ds0aHfYhY9ztYhe3Pt5zx1EYKX
         VCoQ==
X-Gm-Message-State: AOJu0YzlNIQ/cKKDlPFlTWE900oC7k4MB9Dg2yXv6z60P6BSaOxYW1d3
	aCthrH2NiUPdDNWmRLSnN2ZnBAWL7Awz4RtPMsOZaN02rHHKneLmJgOZeG0PKQ+AC83Yz3zXEAu
	0RYhLGCgQPtmyUaaVGbnhddDR7YCPoeru+ap0X4xaCjtW5IqOi5TlIQw6p2A=
X-Received: by 2002:a05:6a20:2454:b0:19a:f1bb:5b1 with SMTP id t20-20020a056a20245400b0019af1bb05b1mr1501317pzc.96.1705638922496;
        Thu, 18 Jan 2024 20:35:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGfTHq90oTB9Rid4sw03VB7yz57s17bNWAc2NU651jNgzRCP36oKf2gdsdzVhezR1AcZgWt8g==
X-Received: by 2002:a05:6a20:2454:b0:19a:f1bb:5b1 with SMTP id t20-20020a056a20245400b0019af1bb05b1mr1501314pzc.96.1705638922207;
        Thu, 18 Jan 2024 20:35:22 -0800 (PST)
Received: from [10.72.112.62] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id cq13-20020a17090af98d00b0028dbd1f7165sm2747789pjb.47.2024.01.18.20.35.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jan 2024 20:35:21 -0800 (PST)
Message-ID: <ede93dec-3faf-48d1-859e-5edf4323fd15@redhat.com>
Date: Fri, 19 Jan 2024 12:35:18 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] libceph: just wait for more data to be available
 on the socket
Content-Language: en-US
To: Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com, vshankar@redhat.com, mchangir@redhat.com
References: <20240118105047.792879-1-xiubli@redhat.com>
 <20240118105047.792879-4-xiubli@redhat.com>
 <ca7f6ba894524474d513807a165f02f4ad50a506.camel@kernel.org>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <ca7f6ba894524474d513807a165f02f4ad50a506.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 1/19/24 02:24, Jeff Layton wrote:
> On Thu, 2024-01-18 at 18:50 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The messages from ceph maybe split into multiple socket packages
>> and we just need to wait for all the data to be availiable on the
>> sokcet.
>>
>> This will add 'sr_total_resid' to record the total length for all
>> data items for sparse-read message and 'sr_resid_elen' to record
>> the current extent total length.
>>
>> URL: https://tracker.ceph.com/issues/63586
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   include/linux/ceph/messenger.h |  1 +
>>   net/ceph/messenger_v1.c        | 32 +++++++++++++++++++++-----------
>>   2 files changed, 22 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
>> index 2eaaabbe98cb..ca6f82abed62 100644
>> --- a/include/linux/ceph/messenger.h
>> +++ b/include/linux/ceph/messenger.h
>> @@ -231,6 +231,7 @@ struct ceph_msg_data {
>>   
>>   struct ceph_msg_data_cursor {
>>   	size_t			total_resid;	/* across all data items */
>> +	size_t			sr_total_resid;	/* across all data items for sparse-read */
>>   
>>   	struct ceph_msg_data	*data;		/* current data item */
>>   	size_t			resid;		/* bytes not yet consumed */
>> diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
>> index 4cb60bacf5f5..2733da891688 100644
>> --- a/net/ceph/messenger_v1.c
>> +++ b/net/ceph/messenger_v1.c
>> @@ -160,7 +160,9 @@ static size_t sizeof_footer(struct ceph_connection *con)
>>   static void prepare_message_data(struct ceph_msg *msg, u32 data_len)
>>   {
>>   	/* Initialize data cursor if it's not a sparse read */
>> -	if (!msg->sparse_read)
>> +	if (msg->sparse_read)
>> +		msg->cursor.sr_total_resid = data_len;
>> +	else
>>   		ceph_msg_data_cursor_init(&msg->cursor, msg, data_len);
>>   }
>>   
>> @@ -1032,35 +1034,43 @@ static int read_partial_sparse_msg_data(struct ceph_connection *con)
>>   	bool do_datacrc = !ceph_test_opt(from_msgr(con->msgr), NOCRC);
>>   	u32 crc = 0;
>>   	int ret = 1;
>> +	int len;
>>   
>>   	if (do_datacrc)
>>   		crc = con->in_data_crc;
>>   
>> -	do {
>> -		if (con->v1.in_sr_kvec.iov_base)
>> +	while (cursor->sr_total_resid) {
>> +		len = 0;
>> +		if (con->v1.in_sr_kvec.iov_base) {
>> +			len = con->v1.in_sr_kvec.iov_len;
>>   			ret = read_partial_message_chunk(con,
>>   							 &con->v1.in_sr_kvec,
>>   							 con->v1.in_sr_len,
>>   							 &crc);
>> -		else if (cursor->sr_resid > 0)
>> +			len = con->v1.in_sr_kvec.iov_len - len;
>> +		} else if (cursor->sr_resid > 0) {
>> +			len = cursor->sr_resid;
>>   			ret = read_partial_sparse_msg_extent(con, &crc);
>> -
>> -		if (ret <= 0) {
>> -			if (do_datacrc)
>> -				con->in_data_crc = crc;
>> -			return ret;
>> +			len -= cursor->sr_resid;
>>   		}
>> +		cursor->sr_total_resid -= len;
>> +		if (ret <= 0)
>> +			break;
>>   
>>   		memset(&con->v1.in_sr_kvec, 0, sizeof(con->v1.in_sr_kvec));
>>   		ret = con->ops->sparse_read(con, cursor,
>>   				(char **)&con->v1.in_sr_kvec.iov_base);
>> +		if (ret <= 0) {
>> +			ret = ret ? : 1; /* must return > 0 to indicate success */
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
> Looking back over this code...
>
> The way it works today, once we determine it's a sparse read, we call
> read_sparse_msg_data. At that point we call either
> read_partial_message_chunk (to read into the kvec) or
> read_sparse_msg_extent if sr_resid is already set (indicating that we're
> receiving an extent).
>
> read_sparse_msg_extent calls ceph_tcp_recvpage in a loop until
> cursor->sr_resid have been received. The exception there when
> ceph_tcp_recvpage returns <= 0.
>
> ceph_tcp_recvpage returns 0 if sock_recvmsg returns -EAGAIN (maybe also
> in other cases). So it sounds like the client just timed out on a read
> from the socket or caught a signal or something?
>
> If that's correct, then do we know what ceph_tcp_recvpage returned when
> the problem happened?

It should just return parital data, and we should continue from here in 
the next loop when the reset data comes.

Thanks

- Xiubo




