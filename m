Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334C053570F
	for <lists+ceph-devel@lfdr.de>; Fri, 27 May 2022 02:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiE0A2l (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 May 2022 20:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiE0A2k (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 26 May 2022 20:28:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 077926A044
        for <ceph-devel@vger.kernel.org>; Thu, 26 May 2022 17:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653611315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uJqMB+oYybU10pw+cs8z8WJsK4+2XanXFpgt7JVINfY=;
        b=U/+M5cLfqAswC7MaqtSNJgXu76T4eKMKSedvmGrPehGjDDV9uU8p1bPfHMIvkAkPaX+0Od
        4K+DFJUEs1Sq2zjXO9w+s52DSDJpHG0EP8ltCwYrFy2oAVrXIMjBEojh90IkXFQbetoDIg
        nkq6kL1YXp1Rf/cBfpnfv6yOBqMKIIM=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-oUFma3w1PQ6RdpKLeghS8g-1; Thu, 26 May 2022 20:28:34 -0400
X-MC-Unique: oUFma3w1PQ6RdpKLeghS8g-1
Received: by mail-pj1-f72.google.com with SMTP id r14-20020a17090a1bce00b001df665a2f8bso1886306pjr.4
        for <ceph-devel@vger.kernel.org>; Thu, 26 May 2022 17:28:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=uJqMB+oYybU10pw+cs8z8WJsK4+2XanXFpgt7JVINfY=;
        b=7xQkZLbPeZJ6jJAHj3jbJ7XhEyIgnektAuXCWLegCJY1z9pnSMCwjw1OZ8i+WLGvLb
         CkG97KZf8wjtFgtyScUdpqjHIPOihisXJOxonwGYMPKbuh2p9uJKlp5Jz5+ztes2tuS3
         gSOYGysvkTqukAubnOL/M0Iy4NotTdqs45CddHRVuZo3Lhcp2Cpl6hN3nx4ctDDOaWkZ
         awOF1pKVmXUNEw7lumnkmO82bdvb4Pi9mGakKi248j4FNQEcVT6cWNjwt7FVV998fs5l
         hSmQHydcCjdpP3O/5Innd+SLoEvgjRIDZuYncfw802b5JZn1CC+puoHGMOe0M/xfSHUj
         AxUA==
X-Gm-Message-State: AOAM531BVt/UoMULu0rcAOrJZnAEet+GXjy9+tJl3mOiNh1hKnLvWQ3v
        FwlO+novKp+NXmVDG1W629lYBJDQ6briNsYOGRd3LOaLCrtdjTYNjjo3pBCKGymtLbURhqcVH9G
        6FXVBqVoLTY+8AE7VOtLhhfMjrcMD8lHxY0FYKbLawBAiWeqRQWYanFnBjFjWOz/uIwvb49A=
X-Received: by 2002:a05:6a00:228d:b0:510:7594:a73c with SMTP id f13-20020a056a00228d00b005107594a73cmr41351714pfe.17.1653611312949;
        Thu, 26 May 2022 17:28:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKB4Isw3H/MH8vPe+of6Ef8SmNaPBR1+kmsaBosB0aHPbY/972cFbxLtarAJvwsnePmFkGEQ==
X-Received: by 2002:a05:6a00:228d:b0:510:7594:a73c with SMTP id f13-20020a056a00228d00b005107594a73cmr41351688pfe.17.1653611312553;
        Thu, 26 May 2022 17:28:32 -0700 (PDT)
Received: from [10.72.12.81] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id cm24-20020a056a00339800b00518142f8c37sm2122156pfb.171.2022.05.26.17.28.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 May 2022 17:28:31 -0700 (PDT)
Subject: Re: [PATCH] ceph: add session already open notify support
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     lhenriques@suse.de, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220526060619.735109-1-xiubli@redhat.com>
 <79f391cfae8c84525c10fb795521e33c014b20bb.camel@kernel.org>
 <7b6cd1dd-4636-16be-0179-f90109b7a021@redhat.com>
 <278dc8e098cf144b04b58f70f0a25fb106cd6d40.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b4378e48-913f-dca4-2b7c-dc0fa3e5b83d@redhat.com>
Date:   Fri, 27 May 2022 08:28:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <278dc8e098cf144b04b58f70f0a25fb106cd6d40.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/26/22 10:20 PM, Jeff Layton wrote:
> On Thu, 2022-05-26 at 20:45 +0800, Xiubo Li wrote:
>> On 5/26/22 6:44 PM, Jeff Layton wrote:
>>> On Thu, 2022-05-26 at 14:06 +0800, Xiubo Li wrote:
>>>> If the connection was accidently closed due to the socket issue or
>>>> something else the clients will try to open the opened sessions, the
>>>> MDSes will send the session open reply one more time if the clients
>>>> support the notify feature.
>>>>
>>>> When the clients retry to open the sessions the s_seq will be 0 as
>>>> default, we need to update it anyway.
>>>>
>>>> URL: https://tracker.ceph.com/issues/53911
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/mds_client.c | 25 ++++++++++++++++++++-----
>>>>    fs/ceph/mds_client.h |  5 ++++-
>>>>    2 files changed, 24 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>> index 4ced8d1e18ba..3e528b89b77a 100644
>>>> --- a/fs/ceph/mds_client.c
>>>> +++ b/fs/ceph/mds_client.c
>>>> @@ -3569,11 +3569,26 @@ static void handle_session(struct ceph_mds_session *session,
>>>>    	case CEPH_SESSION_OPEN:
>>>>    		if (session->s_state == CEPH_MDS_SESSION_RECONNECTING)
>>>>    			pr_info("mds%d reconnect success\n", session->s_mds);
>>>> -		session->s_state = CEPH_MDS_SESSION_OPEN;
>>>> -		session->s_features = features;
>>>> -		renewed_caps(mdsc, session, 0);
>>>> -		if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &session->s_features))
>>>> -			metric_schedule_delayed(&mdsc->metric);
>>>> +
>>>> +		if (session->s_state == CEPH_MDS_SESSION_OPEN) {
>>>> +			pr_info("mds%d already opened\n", session->s_mds);
>>> Does the above pr_info actually help anything? What will the admin do
>>> with this info? I'd probably just skip this since this is sort of
>>> expected to happen from time to time.
>> Currently from the MDS side code, it won't be allowed to send the
>> session open reply more than once. So this should be something wrong
>> somewhere just like this issue we are fixing. So it's should be okay,
>> but maybe a warning instead ?
>>
> Ok. I'd probably go with pr_notice instead. It's not indicative of a
> kernel bug, necessarily, and we don't really need the admin to take any
> action (other than maybe report it to the ceph administrators).

Sure, will switch to notice instead.

Thanks

-- Xiubo

>>>> +		} else {
>>>> +			session->s_state = CEPH_MDS_SESSION_OPEN;
>>>> +			session->s_features = features;
>>>> +			renewed_caps(mdsc, session, 0);
>>>> +			if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT,
>>>> +				     &session->s_features))
>>>> +				metric_schedule_delayed(&mdsc->metric);
>>>> +		}
>>>> +
>>>> +		/*
>>>> +		 * The connection maybe broken and the session in client
>>>> +		 * side has been reinitialized, need to update the seq
>>>> +		 * anyway.
>>>> +		 */
>>>> +		if (!session->s_seq && seq)
>>>> +			session->s_seq = seq;
>>>> +
>>>>    		wake = 1;
>>>>    		if (mdsc->stopping)
>>>>    			__close_session(mdsc, session);
>>>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>>>> index d8ec2ac93da3..256e3eada6c1 100644
>>>> --- a/fs/ceph/mds_client.h
>>>> +++ b/fs/ceph/mds_client.h
>>>> @@ -29,8 +29,10 @@ enum ceph_feature_type {
>>>>    	CEPHFS_FEATURE_MULTI_RECONNECT,
>>>>    	CEPHFS_FEATURE_DELEG_INO,
>>>>    	CEPHFS_FEATURE_METRIC_COLLECT,
>>>> +	CEPHFS_FEATURE_ALTERNATE_NAME,
>>>> +	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
>>>>    
>>>> -	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
>>>> +	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
>>>>    };
>>>>    
>>>>    #define CEPHFS_FEATURES_CLIENT_SUPPORTED {	\
>>>> @@ -41,6 +43,7 @@ enum ceph_feature_type {
>>>>    	CEPHFS_FEATURE_MULTI_RECONNECT,		\
>>>>    	CEPHFS_FEATURE_DELEG_INO,		\
>>>>    	CEPHFS_FEATURE_METRIC_COLLECT,		\
>>>> +	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,	\
>>>>    }
>>>>    
>>>>    /*
>>> The rest looks OK though.

