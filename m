Return-Path: <ceph-devel+bounces-597-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 66CE4835977
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jan 2024 03:52:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF5621F221DD
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jan 2024 02:52:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A8971368;
	Mon, 22 Jan 2024 02:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A7jqbyWp"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E6DEBB
	for <ceph-devel@vger.kernel.org>; Mon, 22 Jan 2024 02:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705891963; cv=none; b=A3IgtGbLmGd9wrcNHro7tVc00N+2MWADg4+RjOlpRSkenJAgHN2n8JwfI7J5n2y8gG4zaJQ3axxzzPGqy2q/HOE1kVW3L0Mt/uMdRdGLaB9YRVR/yCde/ox44+M4jGSCDJ5sr2f04ksN6ZV133uYXjBdxv4fQOPj69z71m/wFMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705891963; c=relaxed/simple;
	bh=AP0C/G5I7+9Rw3LrAhEteySbmRiljCmtPAV7fZiY0uc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bCE5N/PpoI0CK6aQWOgQ+eT9dM8ijP0Kwr9GTZrXt5LMdjo5u58J7cuUFtHlo7FEzLtjqxXPzwpW8MyRLnC8ki8spK1kxF9uE2MHS56Yvqz8fsS2tnA4QBi9Hw+kVPqK9Wpgc6byHKJ92tKaO70HajtQWNyVBw17YUG7pxrnJHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A7jqbyWp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705891960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=USJYbZ6I5vcuqwViMr5XoFXAQe88iTRYgm4PmiBsc58=;
	b=A7jqbyWpIfy+SDkcyooYc/gQgtdP43/Sq+RijpfQ8qatVvbGiWg1A8q+7svSpAb19WI3WT
	M3lYlM/wvQGZ5zBWzBWH+CJlsFmpdydi90P+ZPxGj59y+Ol36gYw1EwvikIgohXeD9XCDk
	PBqf7wEkpdXVAA45cpRoC5h8D7ds3Yk=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-hJzzfwGwOv-6eOTUdKyXMA-1; Sun, 21 Jan 2024 21:52:38 -0500
X-MC-Unique: hJzzfwGwOv-6eOTUdKyXMA-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-5cec8bc5c66so1138504a12.1
        for <ceph-devel@vger.kernel.org>; Sun, 21 Jan 2024 18:52:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705891957; x=1706496757;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=USJYbZ6I5vcuqwViMr5XoFXAQe88iTRYgm4PmiBsc58=;
        b=HtAFwXKlDp54NVuXuo/9u3bRWkvYrh5g6mS/gk9Qn9nGGrl6WqJI7O8fRVx7/TaQVb
         SqBHD9u5kP8BWHlyG6ecy9Pz3CL005lX1VxQ4hfS1ndH1pkZwItMbibtK+K6VvjDMtWv
         kFfhoQQQtCvp7wWOgWQncKE0MXSFj9tRec4KumWXXhChncQA4QMvYl084MXgVME8thOU
         8FgOGbblCc7vszdmD8mJV6+6jkYF142aJw9QX03rM5+SHbIMWVyccwBwNKXkiVvo6fYq
         CQUJGwQ5tB5fXO7d8Q/6Yc7N1Q3d+GTqBVD1pVn5li4pjcSCFYOzliIJatYS35ka4P7w
         NTeQ==
X-Gm-Message-State: AOJu0Yxy7wwPLE8Q8J4TWNS1GaTAKSEiHNA+AoM/DpQqiTomOTl/70Wb
	rA5tWgH3if+e8aG6y2B/3zBRm5kFxoja1G5LGmTxWJCXTul8AO7jtuZIEn78mxLEhYT4WmisQAT
	ybdvFBmO1Rnj4BOgg9b4mRQ20lIjNEzautSc3Xs8cR0xycS2rD8ymRfBT2o3Re6kFVyOCGg==
X-Received: by 2002:a17:902:e548:b0:1d7:4cf0:60a8 with SMTP id n8-20020a170902e54800b001d74cf060a8mr458883plf.97.1705891957139;
        Sun, 21 Jan 2024 18:52:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHVjEseRQ5lVwxZ31UbkJLKN+r+iL0y/zt9BOMJQZNfNO9CxLLuB20ejgkBuUd0xY8X+/CgYw==
X-Received: by 2002:a17:902:e548:b0:1d7:4cf0:60a8 with SMTP id n8-20020a170902e54800b001d74cf060a8mr458875plf.97.1705891956835;
        Sun, 21 Jan 2024 18:52:36 -0800 (PST)
Received: from [10.72.112.62] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id p9-20020a170902e34900b001d73289e7e4sm2703007plc.243.2024.01.21.18.52.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jan 2024 18:52:36 -0800 (PST)
Message-ID: <ef23a41a-65c1-476d-b8e6-ebf1fe654c57@redhat.com>
Date: Mon, 22 Jan 2024 10:52:32 +0800
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
 <ede93dec-3faf-48d1-859e-5edf4323fd15@redhat.com>
 <f0c7ec2741851ff71e77f2e7598c0de665cce4ac.camel@kernel.org>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <f0c7ec2741851ff71e77f2e7598c0de665cce4ac.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 1/19/24 19:09, Jeff Layton wrote:
> On Fri, 2024-01-19 at 12:35 +0800, Xiubo Li wrote:
>> On 1/19/24 02:24, Jeff Layton wrote:
>>> On Thu, 2024-01-18 at 18:50 +0800, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> The messages from ceph maybe split into multiple socket packages
>>>> and we just need to wait for all the data to be availiable on the
>>>> sokcet.
>>>>
>>>> This will add 'sr_total_resid' to record the total length for all
>>>> data items for sparse-read message and 'sr_resid_elen' to record
>>>> the current extent total length.
>>>>
>>>> URL: https://tracker.ceph.com/issues/63586
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    include/linux/ceph/messenger.h |  1 +
>>>>    net/ceph/messenger_v1.c        | 32 +++++++++++++++++++++-----------
>>>>    2 files changed, 22 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
>>>> index 2eaaabbe98cb..ca6f82abed62 100644
>>>> --- a/include/linux/ceph/messenger.h
>>>> +++ b/include/linux/ceph/messenger.h
>>>> @@ -231,6 +231,7 @@ struct ceph_msg_data {
>>>>    
>>>>    struct ceph_msg_data_cursor {
>>>>    	size_t			total_resid;	/* across all data items */
>>>> +	size_t			sr_total_resid;	/* across all data items for sparse-read */
>>>>    
>>>>    	struct ceph_msg_data	*data;		/* current data item */
>>>>    	size_t			resid;		/* bytes not yet consumed */
>>>> diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
>>>> index 4cb60bacf5f5..2733da891688 100644
>>>> --- a/net/ceph/messenger_v1.c
>>>> +++ b/net/ceph/messenger_v1.c
>>>> @@ -160,7 +160,9 @@ static size_t sizeof_footer(struct ceph_connection *con)
>>>>    static void prepare_message_data(struct ceph_msg *msg, u32 data_len)
>>>>    {
>>>>    	/* Initialize data cursor if it's not a sparse read */
>>>> -	if (!msg->sparse_read)
>>>> +	if (msg->sparse_read)
>>>> +		msg->cursor.sr_total_resid = data_len;
>>>> +	else
>>>>    		ceph_msg_data_cursor_init(&msg->cursor, msg, data_len);
>>>>    }
>>>>    
>>>> @@ -1032,35 +1034,43 @@ static int read_partial_sparse_msg_data(struct ceph_connection *con)
>>>>    	bool do_datacrc = !ceph_test_opt(from_msgr(con->msgr), NOCRC);
>>>>    	u32 crc = 0;
>>>>    	int ret = 1;
>>>> +	int len;
>>>>    
>>>>    	if (do_datacrc)
>>>>    		crc = con->in_data_crc;
>>>>    
>>>> -	do {
>>>> -		if (con->v1.in_sr_kvec.iov_base)
>>>> +	while (cursor->sr_total_resid) {
>>>> +		len = 0;
>>>> +		if (con->v1.in_sr_kvec.iov_base) {
>>>> +			len = con->v1.in_sr_kvec.iov_len;
>>>>    			ret = read_partial_message_chunk(con,
>>>>    							 &con->v1.in_sr_kvec,
>>>>    							 con->v1.in_sr_len,
>>>>    							 &crc);
>>>> -		else if (cursor->sr_resid > 0)
>>>> +			len = con->v1.in_sr_kvec.iov_len - len;
>>>> +		} else if (cursor->sr_resid > 0) {
>>>> +			len = cursor->sr_resid;
>>>>    			ret = read_partial_sparse_msg_extent(con, &crc);
>>>> -
>>>> -		if (ret <= 0) {
>>>> -			if (do_datacrc)
>>>> -				con->in_data_crc = crc;
>>>> -			return ret;
>>>> +			len -= cursor->sr_resid;
>>>>    		}
>>>> +		cursor->sr_total_resid -= len;
>>>> +		if (ret <= 0)
>>>> +			break;
>>>>    
>>>>    		memset(&con->v1.in_sr_kvec, 0, sizeof(con->v1.in_sr_kvec));
>>>>    		ret = con->ops->sparse_read(con, cursor,
>>>>    				(char **)&con->v1.in_sr_kvec.iov_base);
>>>> +		if (ret <= 0) {
>>>> +			ret = ret ? : 1; /* must return > 0 to indicate success */
>>>> +			break;
>>>> +		}
>>>>    		con->v1.in_sr_len = ret;
>>>> -	} while (ret > 0);
>>>> +	}
>>>>    
>>>>    	if (do_datacrc)
>>>>    		con->in_data_crc = crc;
>>>>    
>>>> -	return ret < 0 ? ret : 1;  /* must return > 0 to indicate success */
>>>> +	return ret;
>>>>    }
>>>>    
>>>>    static int read_partial_msg_data(struct ceph_connection *con)
>>> Looking back over this code...
>>>
>>> The way it works today, once we determine it's a sparse read, we call
>>> read_sparse_msg_data. At that point we call either
>>> read_partial_message_chunk (to read into the kvec) or
>>> read_sparse_msg_extent if sr_resid is already set (indicating that we're
>>> receiving an extent).
>>>
>>> read_sparse_msg_extent calls ceph_tcp_recvpage in a loop until
>>> cursor->sr_resid have been received. The exception there when
>>> ceph_tcp_recvpage returns <= 0.
>>>
>>> ceph_tcp_recvpage returns 0 if sock_recvmsg returns -EAGAIN (maybe also
>>> in other cases). So it sounds like the client just timed out on a read
>>> from the socket or caught a signal or something?
>>>
>>> If that's correct, then do we know what ceph_tcp_recvpage returned when
>>> the problem happened?
>> It should just return parital data, and we should continue from here in
>> the next loop when the reset data comes.
>>
> Tracking this extra length seems like the wrong fix. We're already
> looping in read_sparse_msg_extent until the sr_resid goes to 0.
Yeah, it is and it works well.
>   ISTM
> that it's just that read_sparse_msg_extent is returning inappropriately
> in the face of timeouts.
>
> IOW, it does this:
>
>                  ret = ceph_tcp_recvpage(con->sock, rpage, (int)off, len);
>                  if (ret <= 0)
>                          return ret;
>
> ...should it just not be returning there when ret == 0? Maybe it should
> be retrying the recvpage instead?

Currently the the ceph_tcp_recvpage() will read data without blocking. 
If so we will change the logic here then all the other non-sparse-read 
cases will be changed to.

Please note this won't fix anything here in this bug.

Because currently the sparse-read code works well if in step 4 it 
partially read the sparse-read data or extents.

But in case of partially reading 'footer' in step 5. What we need to 
guarantee is that in the second loop we could skip triggering a new 
sparse-read in step 4:

1, /* header */         ===> will skip and do nothing if it has already 
read the 'header' data in last loop

2, /* front */             ===> will skip and do nothing if it has 
already read the 'front' data in last loop

3, /* middle */         ===> will skip and do nothing if it has already 
read the 'middle' data in last loop

4, /* (page) data */   ===> sparse-read here, it also should skip and do 
nothing if it has already read the whole 'sparse-read' data in last 
loop, but it won't. This is the ROOT CAUSE of this bug.

5, /* footer */            ===> the 'read_partial()' will only read 
partial 'footer' data then need to loop start from /* header */ when the 
data comes

My patch could guarantee that the sparse-read code will do nothing. 
While currently the code will trigger a new sparse-read from beginning 
again, which is incorrect.

Jeff, please let me know if you have better approaches.  The last one 
Ilya mentioned didn't work.

Thanks

- Xiubo


