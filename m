Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 887DD58D8FE
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Aug 2022 14:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243303AbiHIM4F (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 Aug 2022 08:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239490AbiHIM4E (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 Aug 2022 08:56:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3EDF65FB0
        for <ceph-devel@vger.kernel.org>; Tue,  9 Aug 2022 05:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660049762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lnmWQkRDQDLJtB1i3f5bm5cHhfY+sx4Zvqp+fv1DkKc=;
        b=JaWoQWYBwOLac8okcac6Hv/wiaj234AJvfBtXOqOplSclwrU1hNAkZQgC5n3LRNUtO1Akg
        bQ4s6gswSmY23YXpn8XY7szXOrWARWkyFgLDSXiOSdLmsY5IMbMj7XWeSUEEpFebpCSTEB
        R9ZD4MotI4Fz/963Di/NlchzaODTsKo=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-c26mueXwNGG6CsNCr62CMg-1; Tue, 09 Aug 2022 08:56:01 -0400
X-MC-Unique: c26mueXwNGG6CsNCr62CMg-1
Received: by mail-pl1-f197.google.com with SMTP id a15-20020a170902eccf00b0016f92ee2d54so7360143plh.15
        for <ceph-devel@vger.kernel.org>; Tue, 09 Aug 2022 05:56:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=lnmWQkRDQDLJtB1i3f5bm5cHhfY+sx4Zvqp+fv1DkKc=;
        b=YphnJH+Z3fUgtjqyM9D2TfOwuoOq8nLwwWvTaOjvFnBgq09tF8Ad1kVI6zX1F/mf8D
         huktFXwmQqh948uZRnf5CT8/n+1QogiRXfOcAEOU+qR17yrc81tPf5dwYROZDJOZ+pUf
         KPenmCFgbfNlp1BHgPCjzFxy5+x4Sg9q7B/2X3/J3LVMEthUxPhQHAcbdkacy40S7r9o
         3R9KmSit+aTuJM6VynzSp0XS4fQ3KnvkkJx/irciMSWEGz9TKEL8NSjHVbvmkaSfcTaD
         f+aN0il9JVttTrdpVRczkanGR5v4z2K33bZ2Hg/P0MRqaa3HMY3NXC+6eXise6yxd4r1
         A+CQ==
X-Gm-Message-State: ACgBeo0C1tX7BdsmOqfE9x/VhcZVHrzBFIlKVzgwpkosyoFTf/+mXJL3
        Scc7gvhq+mu2zt35t9RNOHplqk/eDXPfe6Uwrxmm4ZoD5xcfL/b298ddA+Cm53KYWc3G/QZE1ss
        PX5bvfUgK/oFcye/zu2MgvCVUMWq1DA2VU5Hq6380yCMv6vxexrhW8ze2fMxq9M0HqzpHOb8=
X-Received: by 2002:a63:1ce:0:b0:41c:6c25:5ae with SMTP id 197-20020a6301ce000000b0041c6c2505aemr19409237pgb.155.1660049760000;
        Tue, 09 Aug 2022 05:56:00 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6BT5j4GSyM69ABX9R59CbM0IlcVfV7t7wAyS/EKBgFMUahyIl3PSaf81pAHfbTqPtf8/oi6g==
X-Received: by 2002:a63:1ce:0:b0:41c:6c25:5ae with SMTP id 197-20020a6301ce000000b0041c6c2505aemr19409217pgb.155.1660049759686;
        Tue, 09 Aug 2022 05:55:59 -0700 (PDT)
Received: from [10.72.12.61] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j1-20020a170902da8100b0016f8e80336esm9751405plx.298.2022.08.09.05.55.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 05:55:59 -0700 (PDT)
Subject: Re: [PATCH v3] ceph: fail the request if the peer MDS doesn't support
 getvxattr op
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org
References: <20220808070823.707829-1-xiubli@redhat.com>
 <YvIx0bVHx676J953@suse.de> <5b26a327-b514-3fa3-835b-4dedee061166@redhat.com>
 <YvJYt7B9uLDLSVji@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f30e6d1d-9a0a-00ef-cd5c-f7331dd56825@redhat.com>
Date:   Tue, 9 Aug 2022 20:55:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YvJYt7B9uLDLSVji@suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/9/22 8:53 PM, Luís Henriques wrote:
> On Tue, Aug 09, 2022 at 06:16:36PM +0800, Xiubo Li wrote:
>> On 8/9/22 6:07 PM, Luís Henriques wrote:
>>> On Mon, Aug 08, 2022 at 03:08:23PM +0800, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> Just fail the request instead sending the request out, or the peer
>>>> MDS will crash.
>>>>
>>>> URL: https://tracker.ceph.com/issues/56529
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/inode.c      |  1 +
>>>>    fs/ceph/mds_client.c | 11 +++++++++++
>>>>    fs/ceph/mds_client.h |  6 +++++-
>>>>    3 files changed, 17 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>>>> index 79ff197c7cc5..cfa0b550eef2 100644
>>>> --- a/fs/ceph/inode.c
>>>> +++ b/fs/ceph/inode.c
>>>> @@ -2607,6 +2607,7 @@ int ceph_do_getvxattr(struct inode *inode, const char *name, void *value,
>>>>    		goto out;
>>>>    	}
>>>> +	req->r_feature_needed = CEPHFS_FEATURE_OP_GETVXATTR;
>>>>    	req->r_path2 = kstrdup(name, GFP_NOFS);
>>>>    	if (!req->r_path2) {
>>>>    		err = -ENOMEM;
>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>> index 598012ddc401..3e22783109ad 100644
>>>> --- a/fs/ceph/mds_client.c
>>>> +++ b/fs/ceph/mds_client.c
>>>> @@ -2501,6 +2501,7 @@ ceph_mdsc_create_request(struct ceph_mds_client *mdsc, int op, int mode)
>>>>    	INIT_LIST_HEAD(&req->r_unsafe_dir_item);
>>>>    	INIT_LIST_HEAD(&req->r_unsafe_target_item);
>>>>    	req->r_fmode = -1;
>>>> +	req->r_feature_needed = -1;
>>>>    	kref_init(&req->r_kref);
>>>>    	RB_CLEAR_NODE(&req->r_node);
>>>>    	INIT_LIST_HEAD(&req->r_wait);
>>>> @@ -3255,6 +3256,16 @@ static void __do_request(struct ceph_mds_client *mdsc,
>>>>    	dout("do_request mds%d session %p state %s\n", mds, session,
>>>>    	     ceph_session_state_name(session->s_state));
>>>> +
>>>> +	/*
>>>> +	 * The old ceph will crash the MDSs when see unknown OPs
>>>> +	 */
>>>> +	if (req->r_feature_needed > 0 &&
>>>> +	    !test_bit(req->r_feature_needed, &session->s_features)) {
>>>> +		err = -ENODATA;
>>>> +		goto out_session;
>>>> +	}
>>> This patch looks good to me.  The only thing I would have preferred would
>>> be to have ->r_feature_needed defined as an unsigned and initialised to
>>> zero (instead of -1).  But that's me, so feel free to ignore this nit.
>> I am just following the 'test_bit()':
>>
>>     9    132  include/asm-generic/bitops/instrumented-non-atomic.h
>> <<test_bit>>
>>               static inline bool test_bit(long nr, const volatile unsigned
>> long *addr)
>>    10    104  include/asm-generic/bitops/non-atomic.h <<test_bit>>
>>               static inline int test_bit(int nr, const volatile unsigned long
>> *addr)
>>
>> Which is a signed type. If we use a unsigned, won't compiler complain about
>> it ?
>>
> Oh, yeah you're right.  And now that I think about it, I think I've been
> there already in the past.  Sorry for the noise.

No worry about that.

Thanks very much Luis for your reviewing of this !

-- Xiubo


> Cheers,
> --
> Luís
>
>> BRs
>>
>> -- Xiubo
>>
>>> Cheers,
>>> --
>>> Luís
>>>
>>>> +
>>>>    	if (session->s_state != CEPH_MDS_SESSION_OPEN &&
>>>>    	    session->s_state != CEPH_MDS_SESSION_HUNG) {
>>>>    		/*
>>>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>>>> index e15ee2858fef..728b7d72bf76 100644
>>>> --- a/fs/ceph/mds_client.h
>>>> +++ b/fs/ceph/mds_client.h
>>>> @@ -31,8 +31,9 @@ enum ceph_feature_type {
>>>>    	CEPHFS_FEATURE_METRIC_COLLECT,
>>>>    	CEPHFS_FEATURE_ALTERNATE_NAME,
>>>>    	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
>>>> +	CEPHFS_FEATURE_OP_GETVXATTR,
>>>> -	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
>>>> +	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_OP_GETVXATTR,
>>>>    };
>>>>    #define CEPHFS_FEATURES_CLIENT_SUPPORTED {	\
>>>> @@ -45,6 +46,7 @@ enum ceph_feature_type {
>>>>    	CEPHFS_FEATURE_METRIC_COLLECT,		\
>>>>    	CEPHFS_FEATURE_ALTERNATE_NAME,		\
>>>>    	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,	\
>>>> +	CEPHFS_FEATURE_OP_GETVXATTR,		\
>>>>    }
>>>>    /*
>>>> @@ -352,6 +354,8 @@ struct ceph_mds_request {
>>>>    	long long	  r_dir_ordered_cnt;
>>>>    	int		  r_readdir_cache_idx;
>>>> +	int		  r_feature_needed;
>>>> +
>>>>    	struct ceph_cap_reservation r_caps_reservation;
>>>>    };
>>>> -- 
>>>> 2.36.0.rc1
>>>>

