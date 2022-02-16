Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FBB4B7BF7
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Feb 2022 01:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239604AbiBPAaw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 19:30:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245187AbiBPAav (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 19:30:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8570EF70E9
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 16:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644971435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q6MVjNpyqaYfu50bpGCP5UJNJsPnNl1n1nQG1vEhglU=;
        b=N4Gs4wzPWRUqLAkk4oPDjV6jSAj/0jTuHX9gBfTIhQOzU8enbM/B8W2pe06HLA41cTfGhB
        EOcij2cwiF2qMKnnf6kXU54ZJHVbhGePDhRMItrwMBMGUg0PpSIgNIEPJtPQw6/E6rI8wv
        0RXBzFtkyCwbyrCEX7BjpammEeN5/oM=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-45l4KrFPMkyKBRx0x32Z7g-1; Tue, 15 Feb 2022 19:30:34 -0500
X-MC-Unique: 45l4KrFPMkyKBRx0x32Z7g-1
Received: by mail-pf1-f198.google.com with SMTP id y28-20020aa793dc000000b004e160274e3eso423695pff.18
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 16:30:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=q6MVjNpyqaYfu50bpGCP5UJNJsPnNl1n1nQG1vEhglU=;
        b=Go1UdKsuObh8HT6E3pVSLzpmeApXuHOj3XSI4vjbCM52dXNQZtJBlbByf709kQX5HY
         S9E1azmA/7xt5ZOVSKMe3KRItOrq3z96fUhR3BaFoR0YpdrY11E3x9wT9DTWdWD41Guz
         T9u5b/kASATatU28PP/5pg3KMtTu+NvDBahdAhWRXFRdXeU62sQwlBxEYeyaFj1C3oFS
         xH4uXdJ+2VlnlQulbh0Oaj9sGjq1L+UJ1S76VZiRshtpC9CkAeUlrFfkvSNrHYmZmY9c
         fSt2jQfGaDRa3d3v5vwc0IPvIvzNcbWBrV0ooNJkOfldBozqhYRUxBj4qQb8PQm3vwAv
         8hJA==
X-Gm-Message-State: AOAM530aHkv+5kyTTWkXaveaQnFUoGJ/IT8XGhKCgzP/tSyummJSIUG1
        aWg7bhEJj1SBCe0PCky+3pXtcZqRLLqOjctb76EVdEPK2G7eDmRYmIceKvVvshX+M3IPfdauITw
        Gln9IS31DliXJNBRUy/aBJ8/2Q8F2nIC4upGMMSJqNrvLJHw9yIva27F2Kh6hV8l2ToBHgPI=
X-Received: by 2002:a17:90a:2b82:b0:1b8:8d7c:98b with SMTP id u2-20020a17090a2b8200b001b88d7c098bmr7481783pjd.22.1644971432994;
        Tue, 15 Feb 2022 16:30:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzSUSiZP2RN90BEbAX/TGTcGpUDYq+C6p8dFwuhm8B1rVBxECT68JWUoQLHVtNW4RhwPRBDdA==
X-Received: by 2002:a17:90a:2b82:b0:1b8:8d7c:98b with SMTP id u2-20020a17090a2b8200b001b88d7c098bmr7481753pjd.22.1644971432649;
        Tue, 15 Feb 2022 16:30:32 -0800 (PST)
Received: from [10.72.12.153] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k24sm13028579pfi.174.2022.02.15.16.30.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 16:30:31 -0800 (PST)
Subject: Re: [PATCH 3/3] ceph: do no update snapshot context when there is no
 new snapshot
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220215122316.7625-1-xiubli@redhat.com>
 <20220215122316.7625-4-xiubli@redhat.com>
 <13786a0450214e715a01337989660a52f869230c.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <4c65e7ce-b214-5351-57eb-fcdd5dd5b517@redhat.com>
Date:   Wed, 16 Feb 2022 08:30:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <13786a0450214e715a01337989660a52f869230c.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 2/16/22 1:05 AM, Jeff Layton wrote:
> On Tue, 2022-02-15 at 20:23 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> No need to update snapshot context when any of the following two
>> cases happens:
>> 1: if my context seq matches realm's seq and realm has no parent.
>> 2: if my context seq equals or is larger than my parent's, this
>>     works because we rebuild_snap_realms() works _downward_ in
>>     hierarchy after each update.
>>
>> This fix will avoid those inodes which accidently calling
>> ceph_queue_cap_snap() and make no sense, for exmaple:
>>
>> There have 6 directories like:
>>
>> /dir_X1/dir_X2/dir_X3/
>> /dir_Y1/dir_Y2/dir_Y3/
>>
>> Firstly, make a snapshot under /dir_X1/dir_X2/.snap/snap_X2, then
>> make a root snapshot under /.snap/root_snap. And every time when
>> we make snapshots under /dir_Y1/..., the kclient will always try
>> to rebuild the snap context for snap_X2 realm and finally will
>> always try to queue cap snaps for dir_Y2 and dir_Y3, which makes
>> no sense.
>>
>> That's because the snap_X2's seq is 2 and root_snap's seq is 3.
>> So when creating a new snapshot under /dir_Y1/... the new seq
>> will be 4, and then the mds will send kclient a snapshot backtrace
>> in _downward_ in hierarchy: seqs 4, 3. Then in ceph_update_snap_trace()
>> it will always rebuild the from the last realm, that's the root_snap.
>> So later when rebuilding the snap context it will always rebuild
>> the snap_X2 realm and then try to queue cap snaps for all the inodes
>> related in snap_X2 realm, and we are seeing the logs like:
>>
>> "ceph:  queue_cap_snap 00000000a42b796b nothing dirty|writing"
>>
>> URL: https://tracker.ceph.com/issues/44100
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/snap.c | 16 +++++++++-------
>>   1 file changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index d075d3ce5f6d..1f24a5de81e7 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -341,14 +341,16 @@ static int build_snap_context(struct ceph_snap_realm *realm,
>>   		num += parent->cached_context->num_snaps;
>>   	}
>>   
>> -	/* do i actually need to update?  not if my context seq
>> -	   matches realm seq, and my parents' does to.  (this works
>> -	   because we rebuild_snap_realms() works _downward_ in
>> -	   hierarchy after each update.) */
>> +	/* do i actually need to update? No need when any of the following
>> +	 * two cases:
>> +	 * #1: if my context seq matches realm's seq and realm has no parent.
>> +	 * #2: if my context seq equals or is larger than my parent's, this
>> +	 *     works because we rebuild_snap_realms() works _downward_ in
>> +	 *     hierarchy after each update.
>> +	 */
>>   	if (realm->cached_context &&
>> -	    realm->cached_context->seq == realm->seq &&
>> -	    (!parent ||
>> -	     realm->cached_context->seq >= parent->cached_context->seq)) {
>> +	    ((realm->cached_context->seq == realm->seq && !parent) ||
>> +	     (parent && realm->cached_context->seq >= parent->cached_context->seq))) {
>>   		dout("build_snap_context %llx %p: %p seq %lld (%u snaps)"
>>   		     " (unchanged)\n",
>>   		     realm->ino, realm, realm->cached_context,
> I've never had a good feel for the snaprealm handling code, so I'll
> leave it to others that do to comment on whether your logic makes sense.
>
> Either way, I don't think this patch depends on the earlier two, does
> it? The comment is a nice addition though.

Right.

Thanks.

>
> Acked-by: Jeff Layton <jlayton@kernel.org>
>

