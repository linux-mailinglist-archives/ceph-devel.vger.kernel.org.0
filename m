Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD9F4D2CA3
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Mar 2022 10:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbiCIJ7u (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Mar 2022 04:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiCIJ7t (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Mar 2022 04:59:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C0B71275DD
        for <ceph-devel@vger.kernel.org>; Wed,  9 Mar 2022 01:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646819929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0k2Dhgax2n9tbCsMwdLs/u9QfjJzP4zsRrAHj63T478=;
        b=AgUEF8oejsLhTroQ0jqMlmiURF5WOktSASK+b9bSCgpF8WkDv1IuuFbXMgqV6+F/OO3ZeF
        XpswsLxb5InHJcz7omTEgX/pV7xt2OkgnROQhpQ+DQreoZABNH+6tLxIdr9lz7SqkIrLQs
        j843VzWXrRT9+2BN4n9TQwYSxm1AMwA=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-9RZAYHIXMs6w_le6w8D9sg-1; Wed, 09 Mar 2022 04:58:48 -0500
X-MC-Unique: 9RZAYHIXMs6w_le6w8D9sg-1
Received: by mail-pf1-f197.google.com with SMTP id z194-20020a627ecb000000b004f6db380a59so1248577pfc.19
        for <ceph-devel@vger.kernel.org>; Wed, 09 Mar 2022 01:58:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=0k2Dhgax2n9tbCsMwdLs/u9QfjJzP4zsRrAHj63T478=;
        b=LSuVKendl1QqPpPJYarvAbH24p+45X38I1IQBBdB1kaPBckIjuiw4vs4AW+hV4wNND
         IeSdEOPqnfi8lBh72pwRET/Q0RESQ+pI4yqXlk8OmTK5FseisjdZJ0AQAiIYVmFDrHs8
         EVY9pTXavigWHtcfYG7l4Y+no4rTpwZQAx7117NscSqgu7ZGlqzsekSecAMw5BduaDng
         BhBgiLtu2tbkQng6j7zW2o9vSmmDaMgKgnBOOGbHmnZaBsPNHPaMM5te675KDM2K5n9O
         Pn0hMbcoIkTp6uw8yM2vTVNKIK3uqe9iPXluvLlVMVZVFtfTZXkKilRlk8qhyRX9XTZC
         Hm0A==
X-Gm-Message-State: AOAM530CV2xhkhC37Z+IrWT2h3F3/tqOLyk92AJ1RFtn/xbVNNzCxmi5
        KCXy8eSRBTQT9qIA4rNOowKR5EbfVTBJig8B4eRvYswJGIVHmtwaMzu0VUlhlrO35v//rQj5zdM
        MTTj77W6cxUeL7LpmYSzxep1qMLOFjBHpd70/tDfmGZSnW620cr1NqN+/ledP0ynDFuEyJUI=
X-Received: by 2002:a17:90b:1652:b0:1bf:32e9:6db3 with SMTP id il18-20020a17090b165200b001bf32e96db3mr9548426pjb.179.1646819926471;
        Wed, 09 Mar 2022 01:58:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw0iIdoSGkmgSTg7nGuXsToF43Pn+BN0bRrBMV1oZJWg7CM8Z62QA4qqXs40C0hRhLfPUnx7g==
X-Received: by 2002:a17:90b:1652:b0:1bf:32e9:6db3 with SMTP id il18-20020a17090b165200b001bf32e96db3mr9548394pjb.179.1646819926024;
        Wed, 09 Mar 2022 01:58:46 -0800 (PST)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g7-20020a656cc7000000b00375948e63d6sm1740040pgw.91.2022.03.09.01.58.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 01:58:45 -0800 (PST)
Subject: Re: [PATCH v2] libceph: wait for con->work to finish when cancelling
 con
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Venky Shankar <vshankar@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20220308132322.1309992-1-xiubli@redhat.com>
 <d8836bda20bdf1c23a42045e002d99165481230e.camel@kernel.org>
 <e4f01a2b-5237-7aaf-75db-4f18a63c42e1@redhat.com>
 <CAOi1vP8njuV0HVmP+K+ehHdW07frc6wJ8GcJe3DhVK=Wv6Vi4w@mail.gmail.com>
 <6cd01bfa-3e50-29b4-d20d-4672abc5a2b0@redhat.com>
 <CAOi1vP_eQKMqRpbfUgpaorm+NxFTOsiFSBcmaa6Tj4iRnYQL=Q@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <1b289b02-a00a-6562-9999-0b10362f523a@redhat.com>
Date:   Wed, 9 Mar 2022 17:58:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP_eQKMqRpbfUgpaorm+NxFTOsiFSBcmaa6Tj4iRnYQL=Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
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


On 3/9/22 5:44 PM, Ilya Dryomov wrote:
> On Wed, Mar 9, 2022 at 2:47 AM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 3/8/22 11:36 PM, Ilya Dryomov wrote:
>>> On Tue, Mar 8, 2022 at 3:24 PM Xiubo Li <xiubli@redhat.com> wrote:
>>>> On 3/8/22 9:37 PM, Jeff Layton wrote:
>>>>> On Tue, 2022-03-08 at 21:23 +0800, xiubli@redhat.com wrote:
>>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>>
>>>>>> When reconnecting MDS it will reopen the con with new ip address,
>>>>>> but the when opening the con with new address it couldn't be sure
>>>>>> that the stale work has finished. So it's possible that the stale
>>>>>> work queued will use the new data.
>>>>>>
>>>>>> This will use cancel_delayed_work_sync() instead.
>>>>>>
>>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>>> ---
>>>>>>
>>>>>> V2:
>>>>>> - Call cancel_con() after dropping the mutex
>>>>>>
>>>>>>
>>>>>>     net/ceph/messenger.c | 4 ++--
>>>>>>     1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
>>>>>> index d3bb656308b4..62e39f63f94c 100644
>>>>>> --- a/net/ceph/messenger.c
>>>>>> +++ b/net/ceph/messenger.c
>>>>>> @@ -581,8 +581,8 @@ void ceph_con_close(struct ceph_connection *con)
>>>>>>
>>>>>>        ceph_con_reset_protocol(con);
>>>>>>        ceph_con_reset_session(con);
>>>>>> -    cancel_con(con);
>>>>>>        mutex_unlock(&con->mutex);
>>>>>> +    cancel_con(con);
>>>>> Now the question is: Is it safe to cancel this work outside the mutex or
>>>>> will this open up any races. Unfortunately with coarse-grained locks
>>>>> like this, it's hard to tell what the lock actually protects.
>>>>>
>>>>> If we need to keep the cancel inside the lock for some reason, you could
>>>>> instead just add a "flush_workqueue()" after dropping the mutex in the
>>>>> above function.
>>>>>
>>>>> So, this looks reasonable to me at first glance, but I'd like Ilya to
>>>>> ack this before we merge it.
>>>> IMO it should be okay, since the 'queue_con(con)', which doing the
>>>> similar things, also outside the mutex.
>>> Hi Xiubo,
>>>
>>> I read the patch description and skimmed through the linked trackers
>>> but I don't understand the issue.  ceph_con_workfn() holds con->mutex
>>> for most of the time it's running and cancel_delayed_work() is called
>>> under the same con->mutex.  It's true that ceph_con_workfn() work may
>>> not be finished by the time ceph_con_close() returns but I don't see
>>> how that can result in anything bad happening.
>>>
>>> Can you explain the issue in more detail, with pointers to specific
>>> code snippets in the MDS client and the messenger?  Where exactly is
>>> the "new data" (what data, please be specific) gets misused by the
>>> "stale work"?
>> The tracker I attached in V1 is not exact, please ignore that.
>>
>>   From the current code, there has one case that for ceph fs in
>> send_mds_reconnect():
>>
>> 4256         ceph_con_close(&session->s_con);
>> 4257         ceph_con_open(&session->s_con,
>> 4258                       CEPH_ENTITY_TYPE_MDS, mds,
>> 4259                       ceph_mdsmap_get_addr(mdsc->mdsmap, mds));
>>
>> If in ceph_con_close() just before cancelling the con->work, it was
>> already fired but then the queue thread was just scheduled out when the
>> con->work was trying to take the con->mutex.
>>
>> And then in ceph_con_open() it will update the con->state to
>> 'CEPH_CON_S_PREOPEN' and other members then queue the con->work again.
> But ceph_con_close() releases con->mutex before returning, so the
> work that was trying to grab con->mutex would immediately grab it,
> encounter CEPH_CON_S_CLOSED and bail.
>
>> That means the con->work will be run twice with the state
>> 'CEPH_CON_S_PREOPEN'.
> ... so this is very unlikely.  But even it happens somehow, again
> I don't see how that can result in anything bad happening: whoever
> sees CEPH_CON_S_PREOPEN first would transition con to the initial
> "opening" state (e.g. CEPH_CON_S_V1_BANNER for msgr1).
>
>> I am not sure whether will this cause strange issues like the URL I
>> attached in V1.
> Until you can pin point the messenger as the root cause of those
> issues, I'd recommend dropping this patch.

Sure, let's drop it for now, that tracker was caused by other issue and 
I have fixed it.

- Xiubo

> Thanks,
>
>                  Ilya
>

