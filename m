Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986BD504F05
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Apr 2022 12:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbiDRKyF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Apr 2022 06:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiDRKyF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Apr 2022 06:54:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4865D15FFB
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 03:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650279085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pohRCrtQpXp0xM/Gs4y5+nuloL1qPHjOr39juO/cMHk=;
        b=FY1wkJouEDOXCnEc/UB6kqlETIMUvMH0e9JGIEaX1sxaL3Nv9Wceujo/EJbUbsFmB+oMKK
        +8yi6OhRAcD3527ZKHA7rr9sYDgyv91DDB3un3zY93/5VR+9nPzcXWK4rXeuRwlzc2OUHB
        p2OivHqzeDsLsf7hQC/c4WZWqueKv9g=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-b564e08sNOiOe98ThZKwXQ-1; Mon, 18 Apr 2022 06:51:24 -0400
X-MC-Unique: b564e08sNOiOe98ThZKwXQ-1
Received: by mail-pg1-f200.google.com with SMTP id t3-20020a656083000000b0039cf337edd6so8761915pgu.18
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 03:51:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=pohRCrtQpXp0xM/Gs4y5+nuloL1qPHjOr39juO/cMHk=;
        b=SRV7/5LL6K+p+zK7LLUSY4Lg7VVulHboREXBoT9JCaXetlfE7zggBt47xtJXs3pqfh
         h6nt6ssNLW94Co0/W4ZF9NPV4B2ZwNCWd93R4pVgfavhdxLJcFHyk1bs5GKkABT+YnBx
         NSjlUuvY5Gw7p8esAgjBiWqG4fIWcKU1/HTjrvULW1DB0YZk8IEkcKM30q6eOdPFor5u
         BMbngpcg8aLAWChCaAiNpebRCLqrLwGld6MtG39Mxm+MONyulCo4vp58WWEd5Co2e0o3
         SDT1xWRWWCs8EmlEVeXDBCTeO7LZDdkRPXTPz64gUaEywgHlbBdULkqqJ6rfLHqGwBjG
         fTmA==
X-Gm-Message-State: AOAM533tbO5p+i+MQw/nCEXNQogGBWDlF76jB32dxZaSAloejlTZc5l6
        z7PokVGkMJKezB2EyLgaz4CStXEenV9iMdw3BRu8xey63V+BlzyEBKdr7DFcVZwqt13iwKilHne
        pw8dVZydseDL0E0fe1nREp8+qQgpZNJFbNYPlYcdbv1ZFIuB+MObmk635cHH6m3w0ZAuFdFk=
X-Received: by 2002:a05:6a00:10c7:b0:4fd:9ee6:4130 with SMTP id d7-20020a056a0010c700b004fd9ee64130mr11975001pfu.84.1650279082601;
        Mon, 18 Apr 2022 03:51:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxy176h8owULPxHmYHYOOwF9HMuDO3Cyd/2rmtJez2IotRDigreGan3jIWlMgiwPBZFyhMD2w==
X-Received: by 2002:a05:6a00:10c7:b0:4fd:9ee6:4130 with SMTP id d7-20020a056a0010c700b004fd9ee64130mr11974973pfu.84.1650279082258;
        Mon, 18 Apr 2022 03:51:22 -0700 (PDT)
Received: from [10.72.12.77] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j13-20020a056a00130d00b004f1025a4361sm12975543pfu.202.2022.04.18.03.51.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 03:51:21 -0700 (PDT)
Subject: Re: [RFC resend PATCH] ceph: fix statx AT_STATX_DONT_SYNC vs
 AT_STATX_FORCE_SYNC check
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, dhowells@redhat.com,
        ceph-devel@vger.kernel.org
References: <20220411093405.301667-1-xiubli@redhat.com>
 <c013aafd233d4ec303238425b11f6c96c8a3b7a7.camel@kernel.org>
 <b38b37bc-faa7-cbae-ce3a-f10c0818a293@redhat.com>
 <d57a0fd93e18d065a0deb3c82dc43595e67b2326.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d81b7216-2694-4ec2-17b4-0869f485f757@redhat.com>
Date:   Mon, 18 Apr 2022 18:51:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <d57a0fd93e18d065a0deb3c82dc43595e67b2326.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/18/22 6:29 PM, Jeff Layton wrote:
> On Mon, 2022-04-18 at 18:25 +0800, Xiubo Li wrote:
>> On 4/18/22 6:15 PM, Jeff Layton wrote:
>>> On Mon, 2022-04-11 at 17:34 +0800, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>>   From the posix and the initial statx supporting commit comments,
>>>> the AT_STATX_DONT_SYNC is a lightweight stat flag and the
>>>> AT_STATX_FORCE_SYNC is a heaverweight one. And also checked all
>>>> the other current usage about these two flags they are all doing
>>>> the same, that is only when the AT_STATX_FORCE_SYNC is not set
>>>> and the AT_STATX_DONT_SYNC is set will they skip sync retriving
>>>> the attributes from storage.
>>>>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/inode.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>>>> index 6788a1f88eb6..1ee6685def83 100644
>>>> --- a/fs/ceph/inode.c
>>>> +++ b/fs/ceph/inode.c
>>>> @@ -2887,7 +2887,7 @@ int ceph_getattr(struct user_namespace *mnt_userns, const struct path *path,
>>>>    		return -ESTALE;
>>>>    
>>>>    	/* Skip the getattr altogether if we're asked not to sync */
>>>> -	if (!(flags & AT_STATX_DONT_SYNC)) {
>>>> +	if ((flags & AT_STATX_SYNC_TYPE) != AT_STATX_DONT_SYNC) {
>>>>    		err = ceph_do_getattr(inode,
>>>>    				statx_to_caps(request_mask, inode->i_mode),
>>>>    				flags & AT_STATX_FORCE_SYNC);
>>> I don't get it.
>>>
>>> The only way I can see that this is a problem is if someone sent down a
>>> mask with both DONT_SYNC and FORCE_SYNC set in it, and in that case I
>>> don't see that ignoring FORCE_SYNC would be wrong...
>>>
>> There has 3 cases for the flags:
>>
>> case1: flags & AT_STATX_SYNC_TYPE == 0
>>
>> case2: flags & AT_STATX_SYNC_TYPE == AT_STATX_DONT_SYNC
>>
>> case3: flags & AT_STATX_SYNC_TYPE == AT_STATX_DONT_SYNC |
>> AT_STATX_FORCE_SYNC
>>
>>
>> Only in case2, which is only the DONT_SYNC bit is set, will ignore
>> calling ceph_do_getattr() here. And for case3 it will ignore the
>> DONT_SYNC bit.
>>
> Sure, but the patch doesn't functionally change the behavior of the
> code. It may make the condition more idiomatic to read, but I don't
> think there is a bug here.

-	if (!(flags & AT_STATX_DONT_SYNC)) {


For example, in both case2 and case3 the above condition is false, right 
? That means for case3 it will ignore the FORCE_SYNC always.

+	if ((flags & AT_STATX_SYNC_TYPE) != AT_STATX_DONT_SYNC) {

For exmaple in case2 the above condition is false and then it will skip 
calling the ceph_do_getattr(). And in case3 the above condition is true, 
it will call the ceph_do_getattr(..., flags & FORCE_SYNC).

The logic changed, right ?

-- Xiubo


