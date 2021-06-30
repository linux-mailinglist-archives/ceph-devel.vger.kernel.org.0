Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7583B7B10
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Jun 2021 02:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235665AbhF3AjU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 20:39:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41367 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235617AbhF3AjT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 20:39:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625013411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TkDOBsWhlF2k9NQBmfcK2xkhstPyW/ObcxSa/KPp7WY=;
        b=gYV+/w3eaL3ddyHvdgvKMS8X1IW8TfecN6LZ7IIqxpTgx2l38dmbkq1dOP5hz6d3qU0/3P
        ujAazc+RPGIA8SsgRwe5XUx3Ct4cQ5HmuPtAqlpr08IZpZCBbdOEFWqtq0uqlPrQWwvMDI
        y4Ca5w0EcZgKPcSIS4cOaDoUScAfNE0=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-Q1EumYoAN_2gwPLQU9BsQg-1; Tue, 29 Jun 2021 20:36:50 -0400
X-MC-Unique: Q1EumYoAN_2gwPLQU9BsQg-1
Received: by mail-pg1-f197.google.com with SMTP id y1-20020a655b410000b02902235977d00cso303039pgr.21
        for <ceph-devel@vger.kernel.org>; Tue, 29 Jun 2021 17:36:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=TkDOBsWhlF2k9NQBmfcK2xkhstPyW/ObcxSa/KPp7WY=;
        b=EoGczqu5C8ecjpYgBoJzvZUlDAw0oNN+Z0DeyfDVQuOwUqvaUHf1LSvrKXUZPEmdz0
         W38YEaLPs7iJKStk8VLWLjnzlF5f8Qh+OfKHBEMGopH8DtBUmfHMe2vfJuIaolKBfCeu
         ibYGgp0z6uBfG+1R1wAjM9chbcbnIC+sGMX8ngAQEVNrHxpDHYT0vAOxsZ7g4UgbsTFU
         1mx4KjEfS7nGor27k0SWcStI0Faevvr4Xg3ivfVxjOnzcrfQ3F2S8PqXyPosWwd/+fXy
         srSR5oYz2VRMS197iZFVRB6J0r8B0y93gRHWB0ugS3cJ9Ho4kvCjXD3LFeNzPNKqM3zh
         ECGw==
X-Gm-Message-State: AOAM533EhSLdio8/bVILyEJLjtLjl8CUKoXYc2O1jMTQr960tZVqSYD4
        h8weV01V+UAje71uKNzRMESWrN7Y7GtGj1O8fEmNA8pfcFHqZ2frI6DETDYwsfOTvYHFsxmoWQU
        Ccfs95oqj0/qIaVWX06rgvCEeITc9w8kWQQJ1bzPS6s65AWx8OGqoTtQJ9UbxFCU2Ew8YQuw=
X-Received: by 2002:a17:90a:194a:: with SMTP id 10mr1547464pjh.188.1625013409289;
        Tue, 29 Jun 2021 17:36:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyab1Y9cswBb6IwdvZMcg8OkUJSx8ddbtJjjRSXP5H42L/Pw4EsbPItYW4hfKs4aUMitEw9aA==
X-Received: by 2002:a17:90a:194a:: with SMTP id 10mr1547442pjh.188.1625013409021;
        Tue, 29 Jun 2021 17:36:49 -0700 (PDT)
Received: from [10.72.12.103] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y16sm12462869pfe.70.2021.06.29.17.36.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 17:36:48 -0700 (PDT)
Subject: Re: [PATCH 3/5] ceph: flush mdlog before umounting
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210629044241.30359-1-xiubli@redhat.com>
 <20210629044241.30359-4-xiubli@redhat.com>
 <74d612a2a09533fcd184f89e8a1c4d4c0d7354cb.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <6a5f99e7-ed8d-369c-6b31-9a6dcf9dc8d2@redhat.com>
Date:   Wed, 30 Jun 2021 08:36:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <74d612a2a09533fcd184f89e8a1c4d4c0d7354cb.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/29/21 11:34 PM, Jeff Layton wrote:
> On Tue, 2021-06-29 at 12:42 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c         | 29 +++++++++++++++++++++++++++++
>>   fs/ceph/mds_client.h         |  1 +
>>   include/linux/ceph/ceph_fs.h |  1 +
>>   3 files changed, 31 insertions(+)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 96bef289f58f..2db87a5c68d4 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -4689,6 +4689,34 @@ static void wait_requests(struct ceph_mds_client *mdsc)
>>   	dout("wait_requests done\n");
>>   }
>>   
>> +static void send_flush_mdlog(struct ceph_mds_session *s)
>> +{
>> +	u64 seq = s->s_seq;
>> +	struct ceph_msg *msg;
>> +
> The s_seq field is protected by the s_mutex (at least, AFAICT). I think
> you probably need to take it before fetching the s_seq and release it
> after calling ceph_con_send.

Will fix it.


>
> Long term, we probably need to rethink how the session sequence number
> handling is done. The s_mutex is a terribly heavyweight mechanism for
> this.

Yeah, makes sense.


>> +	/*
>> +	 * For the MDS daemons lower than Luminous will crash when it
>> +	 * saw this unknown session request.
>> +	 */
>> +	if (!CEPH_HAVE_FEATURE(s->s_con.peer_features, SERVER_LUMINOUS))
>> +		return;
>> +
>> +	dout("send_flush_mdlog to mds%d (%s)s seq %lld\n",
>> +	     s->s_mds, ceph_session_state_name(s->s_state), seq);
>> +	msg = ceph_create_session_msg(CEPH_SESSION_REQUEST_FLUSH_MDLOG, seq);
>> +	if (!msg) {
>> +		pr_err("failed to send_flush_mdlog to mds%d (%s)s seq %lld\n",
>> +		       s->s_mds, ceph_session_state_name(s->s_state), seq);
>> +	} else {
>> +		ceph_con_send(&s->s_con, msg);
>> +	}
>> +}
>> +
>> +void flush_mdlog(struct ceph_mds_client *mdsc)
>> +{
>> +	ceph_mdsc_iterate_sessions(mdsc, send_flush_mdlog, true);
>> +}
>> +
>>   /*
>>    * called before mount is ro, and before dentries are torn down.
>>    * (hmm, does this still race with new lookups?)
>> @@ -4698,6 +4726,7 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
>>   	dout("pre_umount\n");
>>   	mdsc->stopping = 1;
>>   
>> +	flush_mdlog(mdsc);
>>   	ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
>>   	ceph_flush_dirty_caps(mdsc);
>>   	wait_requests(mdsc);
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index fca2cf427eaf..79d5b8ed62bf 100644
>> --- a/fs/ceph/mds_client.h
>> +++ b/fs/ceph/mds_client.h
>> @@ -537,6 +537,7 @@ extern int ceph_iterate_session_caps(struct ceph_mds_session *session,
>>   				     int (*cb)(struct inode *,
>>   					       struct ceph_cap *, void *),
>>   				     void *arg);
>> +extern void flush_mdlog(struct ceph_mds_client *mdsc);
>>   extern void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc);
>>   
>>   static inline void ceph_mdsc_free_path(char *path, int len)
>> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
>> index 57e5bd63fb7a..ae60696fe40b 100644
>> --- a/include/linux/ceph/ceph_fs.h
>> +++ b/include/linux/ceph/ceph_fs.h
>> @@ -300,6 +300,7 @@ enum {
>>   	CEPH_SESSION_FLUSHMSG_ACK,
>>   	CEPH_SESSION_FORCE_RO,
>>   	CEPH_SESSION_REJECT,
>> +	CEPH_SESSION_REQUEST_FLUSH_MDLOG,
>>   };
>>   
>>   extern const char *ceph_session_op_name(int op);

