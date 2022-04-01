Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9FF4EE582
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Apr 2022 02:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243610AbiDAAwn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 31 Mar 2022 20:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiDAAwm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 31 Mar 2022 20:52:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6CDBE1AA4A6
        for <ceph-devel@vger.kernel.org>; Thu, 31 Mar 2022 17:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648774253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=37Z5I0Fg6IlZ40cy0BbOVuAbxa/7D4oBqGd/Q+aw/CY=;
        b=L82Wmq4jw2Bug+MD+mZgyo1HCa9Ou31ejcnzXjG44pU/53Q01IhSthPq75dEL8vZuZoC1O
        aUiVPXV14p3I88ttB2umC780lc0JBibyZl00L/Tef+YT3tj/LixORhAJepAy50k6vHjaef
        3602MCQfbG1SbRzYWDLslhna4MvvPx8=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-380-QKEMURq5ONy3hHbJBiKS7A-1; Thu, 31 Mar 2022 20:50:52 -0400
X-MC-Unique: QKEMURq5ONy3hHbJBiKS7A-1
Received: by mail-pg1-f200.google.com with SMTP id l6-20020a637006000000b003811a27370aso729268pgc.2
        for <ceph-devel@vger.kernel.org>; Thu, 31 Mar 2022 17:50:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=37Z5I0Fg6IlZ40cy0BbOVuAbxa/7D4oBqGd/Q+aw/CY=;
        b=wawI689jrj5CzXpDdtXZNhXEf9UfDB0p8SX81bjQcaDSAdSR8wugToPg3VUOiTN6s8
         /I8RUEqBRuKX3eoh275GaKAZnA55ybLU9+z0WtykWcNI4DMAISzuKaANNs4saT7chhEm
         I2esshGDQMIZkfdnaoYmnAhBP4ORizMN0KQnafoXuIcFL0h5cpUcTPNDQMDIKLnZxpQH
         /mTwUcqk6edDHq9kanFdjrlctoEyyGWc7vpm/NtzWHEpys5XOmbuz1D9bpUUVOYMn5Rq
         jsHrO+hv61DFe3ZDlVnkzg6HgG9bIZWP7YByLxVoLY2tWOE5Z3tejiNAwWwSQQGSI0Lj
         Yixg==
X-Gm-Message-State: AOAM531j5vzARn0Zgyc0QsO+8cRSD8cyf59oECA19DQ+RwHlVDqE3HBP
        7/GizxNqGSWuESiIeIr+xed9fROaNd3MPjo+scR8xmrUPQ7azJQADfOOs3EajFYRvqMM7dsrBwD
        OIYabvSl4AW4R1W9ib/8DXyW20aS72N2Fv511gdyot/p2BDbZduIPWsCI8ec/jSWKt46eiV8=
X-Received: by 2002:a17:90b:3889:b0:1c7:a31f:2a50 with SMTP id mu9-20020a17090b388900b001c7a31f2a50mr8985538pjb.193.1648774250562;
        Thu, 31 Mar 2022 17:50:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJ1PZR9uTs/an+eQrl/4uRhJSHa36d0pXavBr0MbjwbI5pgSw310PAA7axjb+2p6OSXrkEZw==
X-Received: by 2002:a17:90b:3889:b0:1c7:a31f:2a50 with SMTP id mu9-20020a17090b388900b001c7a31f2a50mr8985500pjb.193.1648774250166;
        Thu, 31 Mar 2022 17:50:50 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k10-20020a056a00168a00b004f7e2a550ccsm664473pfc.78.2022.03.31.17.50.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 17:50:49 -0700 (PDT)
Subject: Re: [PATCH] ceph: discard r_new_inode if open O_CREAT opened existing
 inode
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com,
        =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20220330190457.73279-1-jlayton@kernel.org>
 <fa050107-0103-54d9-5e3c-2f29629d231d@redhat.com>
 <ffc91437b148637bf08f1c8c3bf9bdbcb39e3b0d.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <6d871447-e658-27eb-af98-b0083e67c437@redhat.com>
Date:   Fri, 1 Apr 2022 08:50:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <ffc91437b148637bf08f1c8c3bf9bdbcb39e3b0d.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/31/22 5:53 PM, Jeff Layton wrote:
> On Thu, 2022-03-31 at 09:47 +0800, Xiubo Li wrote:
>> On 3/31/22 3:04 AM, Jeff Layton wrote:
>>> When we do an unchecked create, we optimistically pre-create an inode
>>> and populate it, including its fscrypt context. It's possible though
>>> that we'll end up opening an existing inode, in which case the
>>> precreated inode will have a crypto context that doesn't match the
>>> existing data.
>>>
>>> If we're issuing an O_CREAT open and find an existing inode, just
>>> discard the precreated inode and create a new one to ensure the context
>>> is properly set.
>>>
>>> Cc: Luís Henriques <lhenriques@suse.de>
>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>> ---
>>>    fs/ceph/mds_client.c | 10 ++++++++--
>>>    1 file changed, 8 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>> index 840a60b812fc..b03128fdbb07 100644
>>> --- a/fs/ceph/mds_client.c
>>> +++ b/fs/ceph/mds_client.c
>>> @@ -3504,13 +3504,19 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>>>    	/* Must find target inode outside of mutexes to avoid deadlocks */
>>>    	rinfo = &req->r_reply_info;
>>>    	if ((err >= 0) && rinfo->head->is_target) {
>>> -		struct inode *in;
>>> +		struct inode *in = xchg(&req->r_new_inode, NULL);
>>>    		struct ceph_vino tvino = {
>>>    			.ino  = le64_to_cpu(rinfo->targeti.in->ino),
>>>    			.snap = le64_to_cpu(rinfo->targeti.in->snapid)
>>>    		};
>>>    
>>> -		in = ceph_get_inode(mdsc->fsc->sb, tvino, xchg(&req->r_new_inode, NULL));
>>> +		/* If we ended up opening an existing inode, discard r_new_inode */
>>> +		if (req->r_op == CEPH_MDS_OP_CREATE && !req->r_reply_info.has_create_ino) {
>>> +			iput(in);
>> If the 'in' has a delegated ino, should we give it back here ?
>>
>> -- Xiubo
>>
>>
> This really shouldn't be a delegated ino. We only grab a delegated ino
> if we're doing an async create, and in that case we should know that the
> dentry doesn't exist and the create will succeed or fail without opening
> the file.

Yeah, right.

-- Xiubo

> It's probably worth throwing a warning though if we ever _do_ get a
> delegated ino here. Let me consider how best to catch that situation.
>
>>> +			in = NULL;
>>> +		}
>>> +
>>> +		in = ceph_get_inode(mdsc->fsc->sb, tvino, in);
>>>    		if (IS_ERR(in)) {
>>>    			err = PTR_ERR(in);
>>>    			mutex_lock(&session->s_mutex);
> Thanks,

