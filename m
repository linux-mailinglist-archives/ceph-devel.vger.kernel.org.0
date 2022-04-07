Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1F94F8AF9
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Apr 2022 02:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbiDHAAj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Apr 2022 20:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbiDHAAi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Apr 2022 20:00:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD5D414B01F
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 16:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649375915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PjX8o8aP7Fx3QgvJX5GjaY4BTGhchPqxWWwenbPPMtQ=;
        b=F9zmLSxkvWJ4bUmF+fClgBIpLqU4F4uWKI1iFXeH6vyc9VCMF7bbJYurUPwg09BldjwO50
        8GeOMNdAxv+pzW2Ajpv/DqmzhffAMbe7/XK9W77u8M9izg4XiIp6qfd/ND7BCOtd+Q0Hyy
        DdH94IgEUytlRlGub2SJUlDjwvJ1U1Y=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-70-kBhkdRl5MUWPEGr8rsv5aQ-1; Thu, 07 Apr 2022 19:58:34 -0400
X-MC-Unique: kBhkdRl5MUWPEGr8rsv5aQ-1
Received: by mail-pf1-f198.google.com with SMTP id i65-20020a628744000000b0050565784b53so2120411pfe.7
        for <ceph-devel@vger.kernel.org>; Thu, 07 Apr 2022 16:58:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=PjX8o8aP7Fx3QgvJX5GjaY4BTGhchPqxWWwenbPPMtQ=;
        b=dpJFhnBq15Kv7WCf2Mj0Yrv6nru0gjko0K4zk9BiLnEjZ0C0E3aJffZsVMak3mhcRk
         VxOBMx4GWdm5umGXajHugjP/oWVHqYk56M1K71t+BZLvNEHc3BwjfL1ady0VhKirQwEn
         xptUOiKDw6PjON22l+4UouSiOO+s/bsiM6BgfLXOrBFnHxx55hnKHQUQw9oK2jnt06mS
         euQCaCPnT/5iWqIJ9+I18GEiEg0MNxj3/bF9+PluQOTIIF+ouMOLJFclmBBpW3RhVNHh
         jE8XhSaNeEp75QWJuPWx0WNlHMehlghwbYSCev58HgyM+57DIQIvx1jApQmi8yzHyrZL
         VM7g==
X-Gm-Message-State: AOAM532fZ/DSHS4Bl2JT4o6nYq9SzIYx/sVylhnDkvVf5QD0uxTe8UdI
        RhfWeg779a31eB1n/OyTX0AQUOmdPVnO5hzwVwmXSRrAtdnlBnPvXypNTmKdt9qgX0sHUWoyD6A
        /cXht1XZnWk/2WTMopMEdHiJCMzDJxoZgp4jtrRMy8hfQ2EOER+Xs0JL4Tbw+Yhv3BIjnF3g=
X-Received: by 2002:a63:520c:0:b0:382:2953:a338 with SMTP id g12-20020a63520c000000b003822953a338mr13112278pgb.610.1649375913509;
        Thu, 07 Apr 2022 16:58:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyuKKN9OAYmMnz7s3kXr+Qu41y4f+5xkH0Yl0cCRUP4rzsqPBneP5/oQ7Lb/Dg8Zr7AunxkPw==
X-Received: by 2002:a63:520c:0:b0:382:2953:a338 with SMTP id g12-20020a63520c000000b003822953a338mr13112263pgb.610.1649375913162;
        Thu, 07 Apr 2022 16:58:33 -0700 (PDT)
Received: from [10.72.12.194] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u19-20020a056a00125300b004fafa43330csm23347177pfi.163.2022.04.07.16.58.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 16:58:32 -0700 (PDT)
Subject: Re: [PATCH 2/2] ceph: fix coherency issue when truncating file size
 for fscrypt
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
References: <20220407144112.8455-1-xiubli@redhat.com>
 <20220407144112.8455-3-xiubli@redhat.com>
 <3315c167cc44f38c4eb9ebe76685418e85c9b9f2.camel@kernel.org>
 <6439751daf27285f77239172a9bb5d5f0f80eede.camel@kernel.org>
 <fd37ed30-b066-ce4d-ba99-1a85d593c5d3@redhat.com>
 <11456415d8729639ff7de083e833d49461d3c50c.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d03a3a47-8c9c-d97b-e823-c00b8c477a52@redhat.com>
Date:   Fri, 8 Apr 2022 07:58:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <11456415d8729639ff7de083e833d49461d3c50c.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/8/22 4:32 AM, Jeff Layton wrote:
> On Fri, 2022-04-08 at 03:14 +0800, Xiubo Li wrote:
>> On 4/7/22 11:38 PM, Jeff Layton wrote:
>>> On Thu, 2022-04-07 at 11:33 -0400, Jeff Layton wrote:
>>>> On Thu, 2022-04-07 at 22:41 +0800, xiubli@redhat.com wrote:
>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>
>>>>> When truncating the file size the MDS will help update the last
>>>>> encrypted block, and during this we need to make sure the client
>>>>> won't fill the pagecaches.
>>>>>
>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>> ---
>>>>>    fs/ceph/inode.c | 7 ++++++-
>>>>>    1 file changed, 6 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>>>>> index f4059d73edd5..cc1829ab497d 100644
>>>>> --- a/fs/ceph/inode.c
>>>>> +++ b/fs/ceph/inode.c
>>>>> @@ -2647,9 +2647,12 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>>>>>    		req->r_num_caps = 1;
>>>>>    		req->r_stamp = attr->ia_ctime;
>>>>>    		if (fill_fscrypt) {
>>>>> +			filemap_invalidate_lock(inode->i_mapping);
>>>>>    			err = fill_fscrypt_truncate(inode, req, attr);
>>>>> -			if (err)
>>>>> +			if (err) {
>>>>> +				filemap_invalidate_unlock(inode->i_mapping);
>>>>>    				goto out;
>>>>> +			}
>>>>>    		}
>>>>>    
>>>>>    		/*
>>>>> @@ -2660,6 +2663,8 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>>>>>    		 * it.
>>>>>    		 */
>>>>>    		err = ceph_mdsc_do_request(mdsc, NULL, req);
>>>>> +		if (fill_fscrypt)
>>>>> +			filemap_invalidate_unlock(inode->i_mapping);
>>>>>    		if (err == -EAGAIN && truncate_retry--) {
>>>>>    			dout("setattr %p result=%d (%s locally, %d remote), retry it!\n",
>>>>>    			     inode, err, ceph_cap_string(dirtied), mask);
>>>> Looks reasonable. Is there any reason we shouldn't do this in the non-
>>>> encrypted case too? I suppose it doesn't make as much difference in that
>>>> case.
>> We only need this in encrypted case, which will do the RMW for the last
>> block.
>>
>>
>>>> I'll plan to pull this and the other patch into the wip-fscrypt branch.
>>>> Should I just fold them into your earlier patches?
>> Yeah, certainly.
>>> OTOH...do we really need this? I'm not sure I understand the race you're
>>> trying to prevent. Can you lay it out for me?
>> I am thinking during the RMW for the last block, the page fault still
>> could happen because the page fault function doesn't prevent that.
>>
>> And we should prevent it during the RMW is going on.
>>
> Right, but the RMW is being done using an anonymous page, and at this
> point in the process we haven't really touched the pagecache yet. That
> doesn't happen until __ceph_do_pending_vmtruncate.
>
> Most of the callers for filemap_invalidate_lock/_unlock are in the hole
> punching codepaths, and not so much in truncate. What outcome are you
> trying to prevent with this? Can you lay out the potential race and why
> it would be harmful?

Yeah, here I forgot to invalidate the mapping. After writing the dirty 
pagecache back we should invalidate the mapping and drop the related 
page too.

It should be:

filemap_invalidate_lock(inode->i_mapping);

write pagecache back;

invalidate the mapping and drop the pages;

do the RMW;

filemap_invalidate_unlock(inode->i_mapping);


As you mentioned in another mail, other processes could do the map read 
at the same time, and we should make sure that when we are truncating 
the size, we should block map read to continue and just trigger a page 
fault and the page fault should wait our truncate size finish ?

-- Xiubo

