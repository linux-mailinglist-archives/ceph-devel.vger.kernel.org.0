Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEDAF4AE6DF
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Feb 2022 03:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344187AbiBICkm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Feb 2022 21:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243941AbiBIB4P (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Feb 2022 20:56:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2026EC06157B
        for <ceph-devel@vger.kernel.org>; Tue,  8 Feb 2022 17:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644371773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kF7zFs6uWrQixjE3UIfsKtN86sf3+WHAJ5yXDpKcxR4=;
        b=SG70p0mGDf+F0XCkgnn58aLJqyLyHyJ1csAbNzdS/QY5Zag/I5EfPQk2P2dyEop+YILG7/
        t57EFfcvpoNuBXlYR2/kdHfvjeFYk1VyhDawo4yEaZssjHgau4NeRTpqXA06Zu5j6Qfy2K
        QBcwiP7YmzHx+7EzrzEeqhvUrLXRNq4=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-aEGCsJSXPYG5j3_ICbz-6g-1; Tue, 08 Feb 2022 20:56:11 -0500
X-MC-Unique: aEGCsJSXPYG5j3_ICbz-6g-1
Received: by mail-pl1-f200.google.com with SMTP id q4-20020a170902f78400b0014d57696618so677181pln.20
        for <ceph-devel@vger.kernel.org>; Tue, 08 Feb 2022 17:56:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=kF7zFs6uWrQixjE3UIfsKtN86sf3+WHAJ5yXDpKcxR4=;
        b=4SQTM5Y38JpHOUQEQqmaX18EU39NqyHCOSzzbJMEGORDT/Lcpeo9jVVfJN4z634xf/
         hHeUCEk+P8rFomQTPPzMU1Y9Wuqf9VzknwNHoU4y9jpNqhnDGokuSdjv9+82KsU09nKm
         R203AgKzFTu66Rn2k4h+woIUaTpQsN9d/4GTCSezC+GUbTmZjxft+lpnLnRVCiCYFYfZ
         WXqOCWbsyq+DFTxaPh8X9L/LBA/DKbcWlvX0XCgp1Gd8aOttKnQEc4UfNmTpjMNjys1X
         fJpLGr/JAYKhAZNZng7/3PGpDXfulYppxVV8ubayBLQ/wjumeq0/JS5lWNcYCdqGxBmo
         iVzQ==
X-Gm-Message-State: AOAM531MoC1qixT6G9enAWINUdkY3qyIl81b71fHMh695DVYCBp8AWpC
        LqGCOmeCZFtVtKzW63g3FrPyhlFBmnuOinoaxLgoV9HUBcx/dBdVbgj8ooVK7i6+UfCtHVF/Q0a
        TurOsruXL8RsTekHx55hY8g==
X-Received: by 2002:a63:d1:: with SMTP id 200mr117773pga.402.1644371770832;
        Tue, 08 Feb 2022 17:56:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzrGMcTyFH3A/1IrnCHGtdjvTWEvwZEHaSJRFyGA/LICopy6cB5aTBzMk5ul8XIiokIqQG4dw==
X-Received: by 2002:a63:d1:: with SMTP id 200mr117764pga.402.1644371770526;
        Tue, 08 Feb 2022 17:56:10 -0800 (PST)
Received: from [10.72.12.153] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m1sm18054085pfk.202.2022.02.08.17.56.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 17:56:09 -0800 (PST)
Subject: Re: [PATCH] ceph: fail the request directly if handle_reply gets an
 ESTALE
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Sage Weil <sage@newdream.net>,
        Gregory Farnum <gfarnum@redhat.com>,
        ukernel <ukernel@gmail.com>
References: <20220207050340.872893-1-xiubli@redhat.com>
 <77bd8ec8fb97107deb57c641b5e471b8eeb828c8.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <888cde9d-251b-ee64-66ff-5f705684ed20@redhat.com>
Date:   Wed, 9 Feb 2022 09:56:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <77bd8ec8fb97107deb57c641b5e471b8eeb828c8.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
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


On 2/7/22 11:12 PM, Jeff Layton wrote:
> On Mon, 2022-02-07 at 13:03 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> If MDS return ESTALE, that means the MDS has already iterated all
>> the possible active MDSes including the auth MDS or the inode is
>> under purging. No need to retry in auth MDS and will just return
>> ESTALE directly.
>>
> When you say "purging" here, do you mean that it's effectively being
> cleaned up after being unlinked? Or is it just being purged from the
> MDS's cache?
>
>> Or it will cause definite loop for retrying it.
>>
>> URL: https://tracker.ceph.com/issues/53504
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c | 29 -----------------------------
>>   1 file changed, 29 deletions(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 93e5e3c4ba64..c918d2ac8272 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -3368,35 +3368,6 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>>   
>>   	result = le32_to_cpu(head->result);
>>   
>> -	/*
>> -	 * Handle an ESTALE
>> -	 * if we're not talking to the authority, send to them
>> -	 * if the authority has changed while we weren't looking,
>> -	 * send to new authority
>> -	 * Otherwise we just have to return an ESTALE
>> -	 */
>> -	if (result == -ESTALE) {
>> -		dout("got ESTALE on request %llu\n", req->r_tid);
>> -		req->r_resend_mds = -1;
>> -		if (req->r_direct_mode != USE_AUTH_MDS) {
>> -			dout("not using auth, setting for that now\n");
>> -			req->r_direct_mode = USE_AUTH_MDS;
>> -			__do_request(mdsc, req);
>> -			mutex_unlock(&mdsc->mutex);
>> -			goto out;
>> -		} else  {
>> -			int mds = __choose_mds(mdsc, req, NULL);
>> -			if (mds >= 0 && mds != req->r_session->s_mds) {
>> -				dout("but auth changed, so resending\n");
>> -				__do_request(mdsc, req);
>> -				mutex_unlock(&mdsc->mutex);
>> -				goto out;
>> -			}
>> -		}
>> -		dout("have to return ESTALE on request %llu\n", req->r_tid);
>> -	}
>> -
>> -
>>   	if (head->safe) {
>>   		set_bit(CEPH_MDS_R_GOT_SAFE, &req->r_req_flags);
>>   		__unregister_request(mdsc, req);
>
> (cc'ing Greg, Sage and Zheng)
>
> This patch sort of contradicts the original design, AFAICT, and I'm not
> sure what the correct behavior should be. I could use some
> clarification.
>
> The original code (from the 2009 merge) would tolerate 2 ESTALEs before
> giving up and returning that to userland. Then in 2010, Greg added this
> commit:
>
>      https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e55b71f802fd448a79275ba7b263fe1a8639be5f

The find_ino_peer was support after the original code:

c2c333d8cb0 mds: find_ino_peer

Date:   Thu Mar 31 15:55:10 2011 -0700

 From the code the find_ino_peer should have already checked all the 
possible MDSes even the auth changed.


- Xiubo

> ...which would presumably make it retry indefinitely as long as the auth
> MDS kept changing. Then, Zheng made this change in 2013:
>
>      https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ca18bede048e95a749d13410ce1da4ad0ffa7938
>
> ...which seems to try to do the same thing, but detected the auth mds
> change in a different way.
>
> Is that where livelock detection was broken? Or was there some
> corresponding change to __choose_mds that should prevent infinitely
> looping on the same request?
>
> In NFS, ESTALE errors mean that the filehandle (inode) no longer exists
> and that the server has forgotten about it. Does it mean the same thing
> to the ceph MDS?
>
> Has the behavior of the MDS changed such that these retries are no
> longer necessary on an ESTALE? If so, when did this change, and does the
> client need to do anything to detect what behavior it should be using?

