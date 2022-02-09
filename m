Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB5E4AE6E5
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Feb 2022 03:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243323AbiBICkx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Feb 2022 21:40:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243191AbiBIBf5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Feb 2022 20:35:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF272C061576
        for <ceph-devel@vger.kernel.org>; Tue,  8 Feb 2022 17:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644370553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wksSa73risRM8uvcxJy93RRxsaJJvAn4a1R1qyoYZuA=;
        b=LEkLbjeERF0yFp7LUMbARvGEwrMMgwDDjhufiThJGU/VLfHOKwQHEqwPyljrvUSWk/z6Uk
        Kv6oUp74+JuJIRl2D9NBrTismvXHyOnzV5cy+FMzs0cOm1JR24bFoB0ri24sp01YdVtgEN
        +tBn4y+yXfdXvhpLdA157E43QAKBwCA=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-qy9tLrFCPh6s6kCciETE4g-1; Tue, 08 Feb 2022 20:35:52 -0500
X-MC-Unique: qy9tLrFCPh6s6kCciETE4g-1
Received: by mail-pf1-f199.google.com with SMTP id bd15-20020a056a00278f00b004c7617c47dbso688566pfb.0
        for <ceph-devel@vger.kernel.org>; Tue, 08 Feb 2022 17:35:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=wksSa73risRM8uvcxJy93RRxsaJJvAn4a1R1qyoYZuA=;
        b=d+7xkWKpcY0dFZpr0VqQbGRVyXgpF59dgxYLjdwHVVD0pXfLNg/wuWz5POMcF/Ec5Y
         1ifZHgwI2Ve253cTWmS5ff5MKN05qPx8QZ2IyF9mqLrvuCDyJY+EVIyiq9lCh172YUdm
         jzUp34H9qgAc3fp+upQI/ehbQcEycdulewi+F8IngqpLf8IT4ZrlrhtCF1d25VqWUqVJ
         Q4UthtOODcykQoKiiQs4NZAfVJ6OdLgzgGr91CyNktc8vaUFpQB4tmvS6iKFgGifRgCN
         L9EBj4Zgpz0ih7xAXcaMml93EoNQkuntko1AqWzSR00K0RIrIuaAZNpjYt/h1QKtP2tg
         NbcA==
X-Gm-Message-State: AOAM531Emme70wMROuM2hMGFq98k+pipjMH+/N3oNZemDEfc2QIjSFxO
        E4BhiFOQcHT5Mpvou5vKy6l0m+Uqm2im3E50P/1bnNMKYrLyFDLKhBxAjPCJ6ripzbUcZP/pG31
        QMqqA+rIWpwcfgTW1T5IwIA==
X-Received: by 2002:a17:90b:3b47:: with SMTP id ot7mr13175pjb.143.1644370551581;
        Tue, 08 Feb 2022 17:35:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwb73O8hNwsORngfBsiqRV/MnHAR03WzEWOnWOJovbiGu1emIB2T5bzaojYmNbxdLK73x3mbw==
X-Received: by 2002:a17:90b:3b47:: with SMTP id ot7mr13143pjb.143.1644370551271;
        Tue, 08 Feb 2022 17:35:51 -0800 (PST)
Received: from [10.72.12.153] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ob12sm1955061pjb.47.2022.02.08.17.35.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 17:35:50 -0800 (PST)
Subject: Re: [PATCH] ceph: fail the request directly if handle_reply gets an
 ESTALE
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@newdream.net>, ukernel <ukernel@gmail.com>
References: <20220207050340.872893-1-xiubli@redhat.com>
 <77bd8ec8fb97107deb57c641b5e471b8eeb828c8.camel@kernel.org>
 <056ab110-9e3f-5d47-0a4b-9ec03afda651@redhat.com>
 <CAJ4mKGY=Yq6fLHRamgC3WkPWCsrQPQNseF1iTc5iVm12LQDwqQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <660c6ee5-7238-4c0e-dcaa-d4cc8fb1615e@redhat.com>
Date:   Wed, 9 Feb 2022 09:35:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAJ4mKGY=Yq6fLHRamgC3WkPWCsrQPQNseF1iTc5iVm12LQDwqQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 2/8/22 11:16 PM, Gregory Farnum wrote:
> On Mon, Feb 7, 2022 at 11:56 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 2/7/22 11:12 PM, Jeff Layton wrote:
>>> On Mon, 2022-02-07 at 13:03 +0800, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> If MDS return ESTALE, that means the MDS has already iterated all
>>>> the possible active MDSes including the auth MDS or the inode is
>>>> under purging. No need to retry in auth MDS and will just return
>>>> ESTALE directly.
>>>>
>>> When you say "purging" here, do you mean that it's effectively being
>>> cleaned up after being unlinked? Or is it just being purged from the
>>> MDS's cache?
>> There is one case when the client just removes the file or the file is
>> force overrode via renaming, the related dentry in MDS will be put to
>> stray dir and the Inode will be marked as under purging.
> I'm confused by this statement. Renaming inode B over inode A should
> still just be a normal unlink for A, and not trigger an immediate
> purge. Is there something in the MDS that force-starts that and breaks
> clients who still have the inode held open?

Yeah, you are right. I went through the mds related code again and if 
there has any caps is held by clients will it be deferred queuing to the 
purge queue.

I will went the mds code today try to figure out whether there has bugs 
when replaying the journals and reconnecting the clients when the MDS 
starting.

Thanks.

> -Greg
>
>> So in case when
>> the client try to call getattr, for example, after that, or retries the
>> pending getattr request, which can cause the MDS returns ESTALE errno in
>> theory.
>>
>> Locally I still haven't reproduced it yet.
>>
>>>> Or it will cause definite loop for retrying it.
>>>>
>>>> URL: https://tracker.ceph.com/issues/53504
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/mds_client.c | 29 -----------------------------
>>>>    1 file changed, 29 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>> index 93e5e3c4ba64..c918d2ac8272 100644
>>>> --- a/fs/ceph/mds_client.c
>>>> +++ b/fs/ceph/mds_client.c
>>>> @@ -3368,35 +3368,6 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>>>>
>>>>       result = le32_to_cpu(head->result);
>>>>
>>>> -    /*
>>>> -     * Handle an ESTALE
>>>> -     * if we're not talking to the authority, send to them
>>>> -     * if the authority has changed while we weren't looking,
>>>> -     * send to new authority
>>>> -     * Otherwise we just have to return an ESTALE
>>>> -     */
>>>> -    if (result == -ESTALE) {
>>>> -            dout("got ESTALE on request %llu\n", req->r_tid);
>>>> -            req->r_resend_mds = -1;
>>>> -            if (req->r_direct_mode != USE_AUTH_MDS) {
>>>> -                    dout("not using auth, setting for that now\n");
>>>> -                    req->r_direct_mode = USE_AUTH_MDS;
>>>> -                    __do_request(mdsc, req);
>>>> -                    mutex_unlock(&mdsc->mutex);
>>>> -                    goto out;
>>>> -            } else  {
>>>> -                    int mds = __choose_mds(mdsc, req, NULL);
>>>> -                    if (mds >= 0 && mds != req->r_session->s_mds) {
>>>> -                            dout("but auth changed, so resending\n");
>>>> -                            __do_request(mdsc, req);
>>>> -                            mutex_unlock(&mdsc->mutex);
>>>> -                            goto out;
>>>> -                    }
>>>> -            }
>>>> -            dout("have to return ESTALE on request %llu\n", req->r_tid);
>>>> -    }
>>>> -
>>>> -
>>>>       if (head->safe) {
>>>>               set_bit(CEPH_MDS_R_GOT_SAFE, &req->r_req_flags);
>>>>               __unregister_request(mdsc, req);
>>> (cc'ing Greg, Sage and Zheng)
>>>
>>> This patch sort of contradicts the original design, AFAICT, and I'm not
>>> sure what the correct behavior should be. I could use some
>>> clarification.
>>>
>>> The original code (from the 2009 merge) would tolerate 2 ESTALEs before
>>> giving up and returning that to userland. Then in 2010, Greg added this
>>> commit:
>>>
>>>       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e55b71f802fd448a79275ba7b263fe1a8639be5f
>>>
>>> ...which would presumably make it retry indefinitely as long as the auth
>>> MDS kept changing. Then, Zheng made this change in 2013:
>>>
>>>       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ca18bede048e95a749d13410ce1da4ad0ffa7938
>>>
>>> ...which seems to try to do the same thing, but detected the auth mds
>>> change in a different way.
>>>
>>> Is that where livelock detection was broken? Or was there some
>>> corresponding change to __choose_mds that should prevent infinitely
>>> looping on the same request?
>>>
>>> In NFS, ESTALE errors mean that the filehandle (inode) no longer exists
>>> and that the server has forgotten about it. Does it mean the same thing
>>> to the ceph MDS?
>>>
>>> Has the behavior of the MDS changed such that these retries are no
>>> longer necessary on an ESTALE? If so, when did this change, and does the
>>> client need to do anything to detect what behavior it should be using?

