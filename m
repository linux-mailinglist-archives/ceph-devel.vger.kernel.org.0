Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03BF58D742
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Aug 2022 12:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241882AbiHIKQs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 Aug 2022 06:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241091AbiHIKQr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 Aug 2022 06:16:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 59CE618B06
        for <ceph-devel@vger.kernel.org>; Tue,  9 Aug 2022 03:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660040205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6I3wXNh3dRPmltZANYH5S8GtS7rH7aNgBbZ/2xABTAw=;
        b=Dtkd7v7OvOBx1XrusoZ3rfC1jA0aAWUqsgrBzu0SNKLMxD2HUR9mgXnihBZeZCnscyBTO+
        cayzZ5HL850+6XrIWbmNVpTFZKOA9BWG4ic0Uql7n9u3LDjKRQB27esxMnfIr8/BTm5SRn
        cSJU7A+gfx7f2+7H2CnQRpNhuZBj+Lw=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-363-fJ7MME6gOWyePWlGm3m8XA-1; Tue, 09 Aug 2022 06:16:44 -0400
X-MC-Unique: fJ7MME6gOWyePWlGm3m8XA-1
Received: by mail-pl1-f198.google.com with SMTP id m5-20020a170902f64500b0016d313f3ce7so7815190plg.23
        for <ceph-devel@vger.kernel.org>; Tue, 09 Aug 2022 03:16:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=6I3wXNh3dRPmltZANYH5S8GtS7rH7aNgBbZ/2xABTAw=;
        b=xnY4fJWhrJTKz0AnERGT9ihwVdk+1uiQCYF/59r1fdUisdtk8ECVAQ68NIYgFQenB5
         /vqScULXRMj6jmlzWsLSnxxAHG4Gy4yWWfeBYvefPUI01IYqM90QwDyf8j+zXQwSHeyQ
         lBlyNmn77kC85Od+guPo98uobP+yqCHpR/sLhgJO17Dnfpnd8/1GmGrrDzynN/cJvtCv
         GKbS6VbJNj3Sgumo/ZJiBpg3iM2z+iZ4hF4MqIFakc67Paxb5KP5lgwwUAqnOGUlQkAz
         y0roZ0nXl3BeEN/211dU57GFE/0Rsny7ydpq0EVcl8ALUqQzOqLx52DVqXPcaffth/GX
         bSHg==
X-Gm-Message-State: ACgBeo2/eh8z3cQiVhSPLMNpu+KXXJI5PdDVqtxYkQbVNFz7t/GetFuM
        6TaBWqnqsdKZxkaR3FAfmV9IXcWUx4dgRu4L4X5GKlXyvxOZq8uURm9BAWYh3q6juOEjnGN/+VR
        sznleC2m/SyoeA0q9c/QNAjbK15qPpVX4t9UuVrdfTC/HYBxeg0LY+5H5mC5FCzCAAgclPcA=
X-Received: by 2002:a17:90b:4b46:b0:1f7:2430:2286 with SMTP id mi6-20020a17090b4b4600b001f724302286mr15947417pjb.138.1660040203112;
        Tue, 09 Aug 2022 03:16:43 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4axDDdQvNCTHqN8xUIrOB3Yn0zcX4Qg8dJR4B3qQ+zbpAFFdiECxQdQuvndUuPSSU/eDTT+A==
X-Received: by 2002:a17:90b:4b46:b0:1f7:2430:2286 with SMTP id mi6-20020a17090b4b4600b001f724302286mr15947389pjb.138.1660040202702;
        Tue, 09 Aug 2022 03:16:42 -0700 (PDT)
Received: from [10.72.12.61] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u14-20020a62790e000000b0052d78e73e6asm10097523pfc.184.2022.08.09.03.16.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 03:16:42 -0700 (PDT)
Subject: Re: [PATCH v3] ceph: fail the request if the peer MDS doesn't support
 getvxattr op
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org
References: <20220808070823.707829-1-xiubli@redhat.com>
 <YvIx0bVHx676J953@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <5b26a327-b514-3fa3-835b-4dedee061166@redhat.com>
Date:   Tue, 9 Aug 2022 18:16:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YvIx0bVHx676J953@suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/9/22 6:07 PM, Luís Henriques wrote:
> On Mon, Aug 08, 2022 at 03:08:23PM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Just fail the request instead sending the request out, or the peer
>> MDS will crash.
>>
>> URL: https://tracker.ceph.com/issues/56529
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/inode.c      |  1 +
>>   fs/ceph/mds_client.c | 11 +++++++++++
>>   fs/ceph/mds_client.h |  6 +++++-
>>   3 files changed, 17 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>> index 79ff197c7cc5..cfa0b550eef2 100644
>> --- a/fs/ceph/inode.c
>> +++ b/fs/ceph/inode.c
>> @@ -2607,6 +2607,7 @@ int ceph_do_getvxattr(struct inode *inode, const char *name, void *value,
>>   		goto out;
>>   	}
>>   
>> +	req->r_feature_needed = CEPHFS_FEATURE_OP_GETVXATTR;
>>   	req->r_path2 = kstrdup(name, GFP_NOFS);
>>   	if (!req->r_path2) {
>>   		err = -ENOMEM;
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 598012ddc401..3e22783109ad 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -2501,6 +2501,7 @@ ceph_mdsc_create_request(struct ceph_mds_client *mdsc, int op, int mode)
>>   	INIT_LIST_HEAD(&req->r_unsafe_dir_item);
>>   	INIT_LIST_HEAD(&req->r_unsafe_target_item);
>>   	req->r_fmode = -1;
>> +	req->r_feature_needed = -1;
>>   	kref_init(&req->r_kref);
>>   	RB_CLEAR_NODE(&req->r_node);
>>   	INIT_LIST_HEAD(&req->r_wait);
>> @@ -3255,6 +3256,16 @@ static void __do_request(struct ceph_mds_client *mdsc,
>>   
>>   	dout("do_request mds%d session %p state %s\n", mds, session,
>>   	     ceph_session_state_name(session->s_state));
>> +
>> +	/*
>> +	 * The old ceph will crash the MDSs when see unknown OPs
>> +	 */
>> +	if (req->r_feature_needed > 0 &&
>> +	    !test_bit(req->r_feature_needed, &session->s_features)) {
>> +		err = -ENODATA;
>> +		goto out_session;
>> +	}
> This patch looks good to me.  The only thing I would have preferred would
> be to have ->r_feature_needed defined as an unsigned and initialised to
> zero (instead of -1).  But that's me, so feel free to ignore this nit.

I am just following the 'test_bit()':

    9    132  include/asm-generic/bitops/instrumented-non-atomic.h 
<<test_bit>>
              static inline bool test_bit(long nr, const volatile 
unsigned long *addr)
   10    104  include/asm-generic/bitops/non-atomic.h <<test_bit>>
              static inline int test_bit(int nr, const volatile unsigned 
long *addr)

Which is a signed type. If we use a unsigned, won't compiler complain 
about it ?

BRs

-- Xiubo

> Cheers,
> --
> Luís
>
>> +
>>   	if (session->s_state != CEPH_MDS_SESSION_OPEN &&
>>   	    session->s_state != CEPH_MDS_SESSION_HUNG) {
>>   		/*
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index e15ee2858fef..728b7d72bf76 100644
>> --- a/fs/ceph/mds_client.h
>> +++ b/fs/ceph/mds_client.h
>> @@ -31,8 +31,9 @@ enum ceph_feature_type {
>>   	CEPHFS_FEATURE_METRIC_COLLECT,
>>   	CEPHFS_FEATURE_ALTERNATE_NAME,
>>   	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
>> +	CEPHFS_FEATURE_OP_GETVXATTR,
>>   
>> -	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
>> +	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_OP_GETVXATTR,
>>   };
>>   
>>   #define CEPHFS_FEATURES_CLIENT_SUPPORTED {	\
>> @@ -45,6 +46,7 @@ enum ceph_feature_type {
>>   	CEPHFS_FEATURE_METRIC_COLLECT,		\
>>   	CEPHFS_FEATURE_ALTERNATE_NAME,		\
>>   	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,	\
>> +	CEPHFS_FEATURE_OP_GETVXATTR,		\
>>   }
>>   
>>   /*
>> @@ -352,6 +354,8 @@ struct ceph_mds_request {
>>   	long long	  r_dir_ordered_cnt;
>>   	int		  r_readdir_cache_idx;
>>   
>> +	int		  r_feature_needed;
>> +
>>   	struct ceph_cap_reservation r_caps_reservation;
>>   };
>>   
>> -- 
>> 2.36.0.rc1
>>

