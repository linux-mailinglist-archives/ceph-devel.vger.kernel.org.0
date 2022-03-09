Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105D04D2788
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Mar 2022 05:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiCIBs1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Mar 2022 20:48:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbiCIBsK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Mar 2022 20:48:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1BFCD2656F
        for <ceph-devel@vger.kernel.org>; Tue,  8 Mar 2022 17:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646790432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AJqEGfuzZSGm0NCKuSgPWpob5Gn+J013RgBfgV+kFgc=;
        b=Ub7YYCvYkrIaEQWG/9lsPLeNp4afrCbECeGYZ/IaYJJUUB6NeXGuHBxUL914Z7MfWyB41T
        aPCh0mpxe3x0zf8Jhh5C4guCFD7yoUFHnddxW+uKAsJf68q3lIW5YR6V6q2bYP8P4SQzMN
        FSHxN3LKruXyqahONKnA/qbuk3NYFzM=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-82X3vWmpN3e2qwRfv7aHGw-1; Tue, 08 Mar 2022 20:47:11 -0500
X-MC-Unique: 82X3vWmpN3e2qwRfv7aHGw-1
Received: by mail-pl1-f197.google.com with SMTP id l6-20020a170903120600b0014f43ba55f3so337676plh.11
        for <ceph-devel@vger.kernel.org>; Tue, 08 Mar 2022 17:47:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=AJqEGfuzZSGm0NCKuSgPWpob5Gn+J013RgBfgV+kFgc=;
        b=yfAX8m1bxHzX/R/I+ORoVQ6RdQ6Pn8SweNwiBF7xfuH2/wVg3ETQ6hodjPcJps68un
         7LOftxhPhoSKRJlIM9mNapTbjJTsI30HAIodjCZftPLG8K2aYQxyfz0ssrRvQVUqXloT
         50GaIo5OPXVi6FaPk5/8Z4SjK1zCe+jnHlT/F3h0s/ImbD/En2nN+uG3m8gYe14r64fj
         yTMFWKNolyH+Uyb+N3EsmJ86aiJu1P1Xzp48K9bJtdEJ2ysT1DAaNivIlSFyd37p3z+5
         E6p/7FS8n3WD981hkoeqdExwfk7sNQTgwoc0sbhtsb+s6Mahc8waEiWWjj+wcfUI3LNr
         QImw==
X-Gm-Message-State: AOAM5339TUSi3WFexj4ZtZdXtTTmrOdeL573jylVUhrV5ooe4hqnX+hQ
        jaRlpwNnXZ1f9Q1EY67iY/UZnxwm85VhH9TLuXMiT7lRbu8MtWCAw2PMmzF3BOjkOeGWMNVMZGU
        og0EhZx54Eke1nHtuVjicN/AdcmraTxKNtb82LnI15dFUsB+ESDhGrx2H9TkNMVMHHGvau78=
X-Received: by 2002:a62:7a10:0:b0:4f6:9396:ddde with SMTP id v16-20020a627a10000000b004f69396dddemr21069431pfc.82.1646790429386;
        Tue, 08 Mar 2022 17:47:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJygM4XlXF7mc0AFxWDoCqL7oZeDbRN5X9ehqWOzF4EYRR0aSmlfU8SqaP+7KkBCIr21vRs58w==
X-Received: by 2002:a62:7a10:0:b0:4f6:9396:ddde with SMTP id v16-20020a627a10000000b004f69396dddemr21069360pfc.82.1646790428194;
        Tue, 08 Mar 2022 17:47:08 -0800 (PST)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t5-20020a654b85000000b00373cbfbf965sm351905pgq.46.2022.03.08.17.47.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 17:47:07 -0800 (PST)
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
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <6cd01bfa-3e50-29b4-d20d-4672abc5a2b0@redhat.com>
Date:   Wed, 9 Mar 2022 09:46:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP8njuV0HVmP+K+ehHdW07frc6wJ8GcJe3DhVK=Wv6Vi4w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
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


On 3/8/22 11:36 PM, Ilya Dryomov wrote:
> On Tue, Mar 8, 2022 at 3:24 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 3/8/22 9:37 PM, Jeff Layton wrote:
>>> On Tue, 2022-03-08 at 21:23 +0800, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> When reconnecting MDS it will reopen the con with new ip address,
>>>> but the when opening the con with new address it couldn't be sure
>>>> that the stale work has finished. So it's possible that the stale
>>>> work queued will use the new data.
>>>>
>>>> This will use cancel_delayed_work_sync() instead.
>>>>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>
>>>> V2:
>>>> - Call cancel_con() after dropping the mutex
>>>>
>>>>
>>>>    net/ceph/messenger.c | 4 ++--
>>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
>>>> index d3bb656308b4..62e39f63f94c 100644
>>>> --- a/net/ceph/messenger.c
>>>> +++ b/net/ceph/messenger.c
>>>> @@ -581,8 +581,8 @@ void ceph_con_close(struct ceph_connection *con)
>>>>
>>>>       ceph_con_reset_protocol(con);
>>>>       ceph_con_reset_session(con);
>>>> -    cancel_con(con);
>>>>       mutex_unlock(&con->mutex);
>>>> +    cancel_con(con);
>>> Now the question is: Is it safe to cancel this work outside the mutex or
>>> will this open up any races. Unfortunately with coarse-grained locks
>>> like this, it's hard to tell what the lock actually protects.
>>>
>>> If we need to keep the cancel inside the lock for some reason, you could
>>> instead just add a "flush_workqueue()" after dropping the mutex in the
>>> above function.
>>>
>>> So, this looks reasonable to me at first glance, but I'd like Ilya to
>>> ack this before we merge it.
>> IMO it should be okay, since the 'queue_con(con)', which doing the
>> similar things, also outside the mutex.
> Hi Xiubo,
>
> I read the patch description and skimmed through the linked trackers
> but I don't understand the issue.  ceph_con_workfn() holds con->mutex
> for most of the time it's running and cancel_delayed_work() is called
> under the same con->mutex.  It's true that ceph_con_workfn() work may
> not be finished by the time ceph_con_close() returns but I don't see
> how that can result in anything bad happening.
>
> Can you explain the issue in more detail, with pointers to specific
> code snippets in the MDS client and the messenger?  Where exactly is
> the "new data" (what data, please be specific) gets misused by the
> "stale work"?

The tracker I attached in V1 is not exact, please ignore that.

 From the current code, there has one case that for ceph fs in 
send_mds_reconnect():

4256         ceph_con_close(&session->s_con);
4257         ceph_con_open(&session->s_con,
4258                       CEPH_ENTITY_TYPE_MDS, mds,
4259                       ceph_mdsmap_get_addr(mdsc->mdsmap, mds));

If in ceph_con_close() just before cancelling the con->work, it was 
already fired but then the queue thread was just scheduled out when the 
con->work was trying to take the con->mutex.

And then in ceph_con_open() it will update the con->state to 
'CEPH_CON_S_PREOPEN' and other members then queue the con->work again.

That means the con->work will be run twice with the state 
'CEPH_CON_S_PREOPEN'.

I am not sure whether will this cause strange issues like the URL I 
attached in V1.

- Xiubo

> Thanks,
>
>                  Ilya
>

