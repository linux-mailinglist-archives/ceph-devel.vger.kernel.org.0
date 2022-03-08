Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED844D1A59
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Mar 2022 15:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243822AbiCHOZW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Mar 2022 09:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238086AbiCHOZS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Mar 2022 09:25:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 595C249F92
        for <ceph-devel@vger.kernel.org>; Tue,  8 Mar 2022 06:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646749460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WkHAWuHLQDncjQxjmkbxQ3iuJHALNkZp4UO1YnNGn7c=;
        b=QHkVf/chpLvevD7IDxnd6CU4SSHxnYC8M6iifDMxYrKQzev2K6TSwAhio0Eh10sf6Iefkk
        CzZMT9b5nqxpd/tG2ovN+WwdTUtd00dQjBEl4U3r66iz1+Vn4LMu01NAMoHo82gsHaII0d
        cIbjEE4vIr3QTvAowrsoz/HXD4Layik=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-483-8fi21rRxN6SFlphfnjkPdQ-1; Tue, 08 Mar 2022 09:24:19 -0500
X-MC-Unique: 8fi21rRxN6SFlphfnjkPdQ-1
Received: by mail-pf1-f199.google.com with SMTP id a23-20020aa794b7000000b004f6a3ac7a87so9420914pfl.23
        for <ceph-devel@vger.kernel.org>; Tue, 08 Mar 2022 06:24:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=WkHAWuHLQDncjQxjmkbxQ3iuJHALNkZp4UO1YnNGn7c=;
        b=f2oF7DpEbVL+LZslI+bI5ASAS6eTbpz1rrXvJ7oABEGSSp2Sv2kr157ap6MJ7mqDSi
         lqnTYgaQYv0djVcCzdStwbZgvW19RvhWm/JeODdTHE9MaZu3ysTYE5fzFq69+K0g6Uvg
         iKOgwReEr6LGF/zLnitt5WOAcX6NmSAOKTMYNyd2pwALXQOT8lPsZFeMadkPehhvvDbd
         hCuLhvG0UlwuJ4/1yCtJej2D72RHKtohrLvzAorxtVQntU6vFQhxyqVImqg8yEmE8TsU
         Ezyyp247yGoWVDSlD4PGXdlXsjt410yJNtWrphLpTNjSlS0Km7OayEdIrkvmkBlghsFI
         eaIQ==
X-Gm-Message-State: AOAM530zJ1XvRF/zy5DUPTIusKCKCyG/ZPXUBWPMPw+WJi6kjRx+bU4r
        DwRStrFyKi1LaJmasGj6VV9GjFK6t6EXyWKhLJuIZqkF//Ipoqd5xU6EWjlDvVv9p3Up9ypGBUp
        ViP/CjR7AdlrLF1YsG5oFefL0kU/mu3g1AaVtyI+AjfJw0LDnTWZ0w2pfyQk6T4R/7qEGmH0=
X-Received: by 2002:a63:1554:0:b0:363:794c:9e31 with SMTP id 20-20020a631554000000b00363794c9e31mr14189369pgv.66.1646749458031;
        Tue, 08 Mar 2022 06:24:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwhXi3gqKqCWi3bn5Zd6gPdaVzFpAUY3dttO0L8wgc2pLuTS2A7HnmQw0OifzvWY8J6eb1E9g==
X-Received: by 2002:a63:1554:0:b0:363:794c:9e31 with SMTP id 20-20020a631554000000b00363794c9e31mr14189343pgv.66.1646749457639;
        Tue, 08 Mar 2022 06:24:17 -0800 (PST)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b17-20020a056a000a9100b004e1b7cdb8fdsm21174628pfl.70.2022.03.08.06.24.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 06:24:17 -0800 (PST)
Subject: Re: [PATCH v2] libceph: wait for con->work to finish when cancelling
 con
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220308132322.1309992-1-xiubli@redhat.com>
 <d8836bda20bdf1c23a42045e002d99165481230e.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <e4f01a2b-5237-7aaf-75db-4f18a63c42e1@redhat.com>
Date:   Tue, 8 Mar 2022 22:24:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <d8836bda20bdf1c23a42045e002d99165481230e.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/8/22 9:37 PM, Jeff Layton wrote:
> On Tue, 2022-03-08 at 21:23 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When reconnecting MDS it will reopen the con with new ip address,
>> but the when opening the con with new address it couldn't be sure
>> that the stale work has finished. So it's possible that the stale
>> work queued will use the new data.
>>
>> This will use cancel_delayed_work_sync() instead.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V2:
>> - Call cancel_con() after dropping the mutex
>>
>>
>>   net/ceph/messenger.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
>> index d3bb656308b4..62e39f63f94c 100644
>> --- a/net/ceph/messenger.c
>> +++ b/net/ceph/messenger.c
>> @@ -581,8 +581,8 @@ void ceph_con_close(struct ceph_connection *con)
>>   
>>   	ceph_con_reset_protocol(con);
>>   	ceph_con_reset_session(con);
>> -	cancel_con(con);
>>   	mutex_unlock(&con->mutex);
>> +	cancel_con(con);
>
> Now the question is: Is it safe to cancel this work outside the mutex or
> will this open up any races. Unfortunately with coarse-grained locks
> like this, it's hard to tell what the lock actually protects.
>
> If we need to keep the cancel inside the lock for some reason, you could
> instead just add a "flush_workqueue()" after dropping the mutex in the
> above function.
>
> So, this looks reasonable to me at first glance, but I'd like Ilya to
> ack this before we merge it.

IMO it should be okay, since the 'queue_con(con)', which doing the 
similar things, also outside the mutex.

- Xiubo

>
>>   }
>>   EXPORT_SYMBOL(ceph_con_close);
>>   
>> @@ -1416,7 +1416,7 @@ static void queue_con(struct ceph_connection *con)
>>   
>>   static void cancel_con(struct ceph_connection *con)
>>   {
>> -	if (cancel_delayed_work(&con->work)) {
>> +	if (cancel_delayed_work_sync(&con->work)) {
>>   		dout("%s %p\n", __func__, con);
>>   		con->ops->put(con);
>>   	}

