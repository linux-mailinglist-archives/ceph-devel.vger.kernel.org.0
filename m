Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63337534F95
	for <lists+ceph-devel@lfdr.de>; Thu, 26 May 2022 14:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiEZMqF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 May 2022 08:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239795AbiEZMqE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 26 May 2022 08:46:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 408396EB3B
        for <ceph-devel@vger.kernel.org>; Thu, 26 May 2022 05:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653569162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ek1QivexrObnhOwcFX61yxBmWNlWv6Sxpos3VA2NIzA=;
        b=Xj8xh4HvKSfd9lSwRGkAsjHyfN3KRslHwynhJTVFiMUm95T3kfjkgt+0ancsVCBabYwAcA
        jPFqRgXfjex1CwSyo/Fw4I5rHfvPqx3UaFLh6Vmrs1ppWFwcg011Y4/yuc/Wdb+yQQPEHr
        tAqajxZPriI7W4g0rejYz0Io54DFPBM=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-3HQhawJ5NaSiMWmj_Eot6g-1; Thu, 26 May 2022 08:46:01 -0400
X-MC-Unique: 3HQhawJ5NaSiMWmj_Eot6g-1
Received: by mail-pj1-f69.google.com with SMTP id t15-20020a17090a3e4f00b001dfe714e279so1081887pjm.7
        for <ceph-devel@vger.kernel.org>; Thu, 26 May 2022 05:46:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Ek1QivexrObnhOwcFX61yxBmWNlWv6Sxpos3VA2NIzA=;
        b=eDfRt/RmQCPmQeJT5vHYOXJhoCBpAllbAwGRoXEHk7GeF2489fgy8gsvyZD/3Vs+iX
         ghZHsSMPzIOH+zhpd7sHD2obImJPqfyk7KO42YAtJr0HoI9wEMbgK6YLN2Q4wxwFAMT+
         ts2C/k4lom66GMDM8/wWR4/vFdbLyf0By6keGBvSqt99bJZmpdKEXrdiUldYVhxURwLZ
         JmTUcxrxW8U7oxIuA+Tyz/rVZzDAlML6Kfs0ehpmUR4wnULhOMriAUV8dNPolxwbmTkR
         jvcjDqcy8baR9iiKi3B6SGCG+qVoaX747pJykF2MnxQzJ7helIWUv0p2QVMlsoBer9Zv
         +wTw==
X-Gm-Message-State: AOAM532J3lvsQPuvWEi1R1sV9jxs5FxJ1C285VaxZAAo5o/S+4wK7vvO
        uligyNvflte7vAIZjc+60P4Wf1uNcvrKR5cEBdY0JMl+KP3RO45WS8tyKaNGO4aJFVcUr67K6us
        af6h+n7dbe7Cdn/rGzKIPxQmt/0MX3AeRe4lHHNbLzYEAkwD/8jUBF5AprzGNH988fWZzHlE=
X-Received: by 2002:a17:902:dac6:b0:161:f394:3e7a with SMTP id q6-20020a170902dac600b00161f3943e7amr31348081plx.19.1653569159783;
        Thu, 26 May 2022 05:45:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCVLFSxxL15TInCDPisF3WmKEfA+os1EnlyhMOXncEMJbGwqZc+ZSkChtlRD9hYjfeqJ/c2A==
X-Received: by 2002:a17:902:dac6:b0:161:f394:3e7a with SMTP id q6-20020a170902dac600b00161f3943e7amr31348027plx.19.1653569159201;
        Thu, 26 May 2022 05:45:59 -0700 (PDT)
Received: from [10.72.12.81] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q5-20020a6557c5000000b003f60df4a5d5sm1475276pgr.54.2022.05.26.05.45.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 May 2022 05:45:58 -0700 (PDT)
Subject: Re: [PATCH] ceph: add session already open notify support
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     lhenriques@suse.de, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220526060619.735109-1-xiubli@redhat.com>
 <79f391cfae8c84525c10fb795521e33c014b20bb.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <7b6cd1dd-4636-16be-0179-f90109b7a021@redhat.com>
Date:   Thu, 26 May 2022 20:45:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <79f391cfae8c84525c10fb795521e33c014b20bb.camel@kernel.org>
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


On 5/26/22 6:44 PM, Jeff Layton wrote:
> On Thu, 2022-05-26 at 14:06 +0800, Xiubo Li wrote:
>> If the connection was accidently closed due to the socket issue or
>> something else the clients will try to open the opened sessions, the
>> MDSes will send the session open reply one more time if the clients
>> support the notify feature.
>>
>> When the clients retry to open the sessions the s_seq will be 0 as
>> default, we need to update it anyway.
>>
>> URL: https://tracker.ceph.com/issues/53911
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c | 25 ++++++++++++++++++++-----
>>   fs/ceph/mds_client.h |  5 ++++-
>>   2 files changed, 24 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 4ced8d1e18ba..3e528b89b77a 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -3569,11 +3569,26 @@ static void handle_session(struct ceph_mds_session *session,
>>   	case CEPH_SESSION_OPEN:
>>   		if (session->s_state == CEPH_MDS_SESSION_RECONNECTING)
>>   			pr_info("mds%d reconnect success\n", session->s_mds);
>> -		session->s_state = CEPH_MDS_SESSION_OPEN;
>> -		session->s_features = features;
>> -		renewed_caps(mdsc, session, 0);
>> -		if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &session->s_features))
>> -			metric_schedule_delayed(&mdsc->metric);
>> +
>> +		if (session->s_state == CEPH_MDS_SESSION_OPEN) {
>> +			pr_info("mds%d already opened\n", session->s_mds);
> Does the above pr_info actually help anything? What will the admin do
> with this info? I'd probably just skip this since this is sort of
> expected to happen from time to time.

Currently from the MDS side code, it won't be allowed to send the 
session open reply more than once. So this should be something wrong 
somewhere just like this issue we are fixing. So it's should be okay, 
but maybe a warning instead ?


>> +		} else {
>> +			session->s_state = CEPH_MDS_SESSION_OPEN;
>> +			session->s_features = features;
>> +			renewed_caps(mdsc, session, 0);
>> +			if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT,
>> +				     &session->s_features))
>> +				metric_schedule_delayed(&mdsc->metric);
>> +		}
>> +
>> +		/*
>> +		 * The connection maybe broken and the session in client
>> +		 * side has been reinitialized, need to update the seq
>> +		 * anyway.
>> +		 */
>> +		if (!session->s_seq && seq)
>> +			session->s_seq = seq;
>> +
>>   		wake = 1;
>>   		if (mdsc->stopping)
>>   			__close_session(mdsc, session);
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index d8ec2ac93da3..256e3eada6c1 100644
>> --- a/fs/ceph/mds_client.h
>> +++ b/fs/ceph/mds_client.h
>> @@ -29,8 +29,10 @@ enum ceph_feature_type {
>>   	CEPHFS_FEATURE_MULTI_RECONNECT,
>>   	CEPHFS_FEATURE_DELEG_INO,
>>   	CEPHFS_FEATURE_METRIC_COLLECT,
>> +	CEPHFS_FEATURE_ALTERNATE_NAME,
>> +	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
>>   
>> -	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
>> +	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
>>   };
>>   
>>   #define CEPHFS_FEATURES_CLIENT_SUPPORTED {	\
>> @@ -41,6 +43,7 @@ enum ceph_feature_type {
>>   	CEPHFS_FEATURE_MULTI_RECONNECT,		\
>>   	CEPHFS_FEATURE_DELEG_INO,		\
>>   	CEPHFS_FEATURE_METRIC_COLLECT,		\
>> +	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,	\
>>   }
>>   
>>   /*
> The rest looks OK though.

