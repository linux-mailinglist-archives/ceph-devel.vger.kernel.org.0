Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8AD3B732D
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 15:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbhF2N3s (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 09:29:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50348 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234044AbhF2N3p (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 09:29:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624973238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A7g9vqGPXUs045Z6ucI3uczGPp6L2pSsG0db1Mo8HFE=;
        b=d3OpNhSLNvLr2ABRBGv87xbvD5bYURnrDn6Qay8vT5QTxcqR0ElVNif+ob7ytyfW8zv6MR
        JlGCQkIam9R/b0pLwi2zXZDkndjmD5XTS4YxswqXYyslPDVk3ayNGphy/Q+PN1cLBhy/t7
        pMriyKC81ABh4EG4h9G59O13J8yGXJg=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-guJSmXIZMc27EKTgnKuRiA-1; Tue, 29 Jun 2021 09:27:16 -0400
X-MC-Unique: guJSmXIZMc27EKTgnKuRiA-1
Received: by mail-pg1-f199.google.com with SMTP id h5-20020a6357450000b02902275ef514faso7986496pgm.6
        for <ceph-devel@vger.kernel.org>; Tue, 29 Jun 2021 06:27:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=A7g9vqGPXUs045Z6ucI3uczGPp6L2pSsG0db1Mo8HFE=;
        b=ZBnYNzk2sifH0VZgOekp4H/ibOOc+6E4AUReWxWYHEVc6/I4DdWnZIywQj2j8ICjhY
         id+wc41fPx9mSASiwt5YhMcqOGndHdLrl6eyXW6Xm8EQiaQebDhqM6Pu7YGjyqfQlfu0
         BDxYZlU/lHLclygFAKJD8KoY00o8N3vNQd5vgkvPsRsUJn5UjZ/rXUV2Ew/KvX3DaMql
         fRwrDiThXrLGfuO/QttWLoHQ7UyyTw5aBLtdmpQFPebi2xfWU3N2cklUp0s+a44U0lJm
         g1J6oNUZL+V/8atX7A2wtwoS4qcGFIej4uGEUlsUXjgBT1mSt2qQ/bTDaRLUJz4JCd2c
         9+uw==
X-Gm-Message-State: AOAM533wq9QXDiNh7sL/YhCcZWlyve58LmvE0O8bruLvg7bmUizM5eHq
        d+aa9rJ+wnQdc8KvLNJvgXNdFtfKN2S/FMm/0iWtCDxUojYLBDhDHC24wmL+Y8yN7B/3jB6HLaS
        YM6/px5S3/g3LBewAhEUtg+5rhBnCFLiRhqdQdL1xw6Sz+DaiapVU7VQurX4ZeuJ41dc14XI=
X-Received: by 2002:a63:64d:: with SMTP id 74mr28320188pgg.13.1624973235729;
        Tue, 29 Jun 2021 06:27:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyUIqwDdor430ZpsPyvh8gdwvfzZWa21vm+f2WvWpRZ6kt5apa/bWddPiDZzeSfaaNbnGVBoQ==
X-Received: by 2002:a63:64d:: with SMTP id 74mr28320167pgg.13.1624973235511;
        Tue, 29 Jun 2021 06:27:15 -0700 (PDT)
Received: from [10.72.12.103] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g10sm120322pjv.46.2021.06.29.06.27.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 06:27:15 -0700 (PDT)
Subject: Re: [PATCH 1/5] ceph: export ceph_create_session_msg
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210629044241.30359-1-xiubli@redhat.com>
 <20210629044241.30359-2-xiubli@redhat.com>
 <88c1bdbf8235b35671a84f0b0d5feca855017940.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <8cc0a19a-2c67-f807-5085-46455727e8ab@redhat.com>
Date:   Tue, 29 Jun 2021 21:27:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <88c1bdbf8235b35671a84f0b0d5feca855017940.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/29/21 9:12 PM, Jeff Layton wrote:
> On Tue, 2021-06-29 at 12:42 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
> nit: the subject of this patch is not quite right. You aren't exporting
> it here, just making it a global symbol (within ceph.ko).
>   

Yeah, will fix it.


>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c | 15 ++++++++-------
>>   fs/ceph/mds_client.h |  1 +
>>   2 files changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 2d7dcd295bb9..e49d3e230712 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -1150,7 +1150,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>>   /*
>>    * session messages
>>    */
>> -static struct ceph_msg *create_session_msg(u32 op, u64 seq)
>> +struct ceph_msg *ceph_create_session_msg(u32 op, u64 seq)
>>   {
>>   	struct ceph_msg *msg;
>>   	struct ceph_mds_session_head *h;
>> @@ -1158,7 +1158,7 @@ static struct ceph_msg *create_session_msg(u32 op, u64 seq)
>>   	msg = ceph_msg_new(CEPH_MSG_CLIENT_SESSION, sizeof(*h), GFP_NOFS,
>>   			   false);
>>   	if (!msg) {
>> -		pr_err("create_session_msg ENOMEM creating msg\n");
>> +		pr_err("ceph_create_session_msg ENOMEM creating msg\n");
> instead of hardcoding the function names in these error messages, use
> __func__ instead? That makes it easier to keep up with code changes.
>
> 	pr_err("%s ENOMEM creating msg\n", __func__);

Sure, will fix this too.

Thanks.

>>   		return NULL;
>>   	}
>>   	h = msg->front.iov_base;
>> @@ -1289,7 +1289,7 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
>>   	msg = ceph_msg_new(CEPH_MSG_CLIENT_SESSION, sizeof(*h) + extra_bytes,
>>   			   GFP_NOFS, false);
>>   	if (!msg) {
>> -		pr_err("create_session_msg ENOMEM creating msg\n");
>> +		pr_err("ceph_create_session_msg ENOMEM creating msg\n");
>>   		return ERR_PTR(-ENOMEM);
>>   	}
>>   	p = msg->front.iov_base;
>> @@ -1801,8 +1801,8 @@ static int send_renew_caps(struct ceph_mds_client *mdsc,
>>   
>>   	dout("send_renew_caps to mds%d (%s)\n", session->s_mds,
>>   		ceph_mds_state_name(state));
>> -	msg = create_session_msg(CEPH_SESSION_REQUEST_RENEWCAPS,
>> -				 ++session->s_renew_seq);
>> +	msg = ceph_create_session_msg(CEPH_SESSION_REQUEST_RENEWCAPS,
>> +				      ++session->s_renew_seq);
>>   	if (!msg)
>>   		return -ENOMEM;
>>   	ceph_con_send(&session->s_con, msg);
>> @@ -1816,7 +1816,7 @@ static int send_flushmsg_ack(struct ceph_mds_client *mdsc,
>>   
>>   	dout("send_flushmsg_ack to mds%d (%s)s seq %lld\n",
>>   	     session->s_mds, ceph_session_state_name(session->s_state), seq);
>> -	msg = create_session_msg(CEPH_SESSION_FLUSHMSG_ACK, seq);
>> +	msg = ceph_create_session_msg(CEPH_SESSION_FLUSHMSG_ACK, seq);
>>   	if (!msg)
>>   		return -ENOMEM;
>>   	ceph_con_send(&session->s_con, msg);
>> @@ -1868,7 +1868,8 @@ static int request_close_session(struct ceph_mds_session *session)
>>   	dout("request_close_session mds%d state %s seq %lld\n",
>>   	     session->s_mds, ceph_session_state_name(session->s_state),
>>   	     session->s_seq);
>> -	msg = create_session_msg(CEPH_SESSION_REQUEST_CLOSE, session->s_seq);
>> +	msg = ceph_create_session_msg(CEPH_SESSION_REQUEST_CLOSE,
>> +				      session->s_seq);
>>   	if (!msg)
>>   		return -ENOMEM;
>>   	ceph_con_send(&session->s_con, msg);
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index bf99c5ba47fc..bf2683f0ba43 100644
>> --- a/fs/ceph/mds_client.h
>> +++ b/fs/ceph/mds_client.h
>> @@ -523,6 +523,7 @@ static inline void ceph_mdsc_put_request(struct ceph_mds_request *req)
>>   	kref_put(&req->r_kref, ceph_mdsc_release_request);
>>   }
>>   
>> +extern struct ceph_msg *ceph_create_session_msg(u32 op, u64 seq);
>>   extern void __ceph_queue_cap_release(struct ceph_mds_session *session,
>>   				    struct ceph_cap *cap);
>>   extern void ceph_flush_cap_releases(struct ceph_mds_client *mdsc,

