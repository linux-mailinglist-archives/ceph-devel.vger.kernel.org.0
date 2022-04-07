Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2714F87EA
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Apr 2022 21:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiDGTRE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Apr 2022 15:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiDGTQ7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Apr 2022 15:16:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B63AAE5A
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 12:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649358896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ScwoVRj/Z3c+akFDyumwZFSc5md9VQ6/hqaGifKY1Us=;
        b=YscPpaBYE6CIJLaxFZGWv5qmc7HbXD1MD27Xn7LY8lqTAo4j84HsUJKT1BzBKSqlLpEHHL
        d3fAPNeWKAZaFOV6aFN2wW/5PgttKAFNPkUaq3TCnIBe4hZD9ez1JIcHvP31VevJ6vmh3j
        5/oPkPI9a7Yp/QBUgJ/tSuXardpaV7Q=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-swvC-LS-Pb2-0Qquk6Jx3A-1; Thu, 07 Apr 2022 15:14:55 -0400
X-MC-Unique: swvC-LS-Pb2-0Qquk6Jx3A-1
Received: by mail-pf1-f197.google.com with SMTP id d5-20020a62f805000000b0050566b4f4c0so1642685pfh.11
        for <ceph-devel@vger.kernel.org>; Thu, 07 Apr 2022 12:14:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ScwoVRj/Z3c+akFDyumwZFSc5md9VQ6/hqaGifKY1Us=;
        b=nctKmAi4y5wNoK9oInDiPJDgdok6OIQQ1QbSaauv4BLzdxZGT+CatF5/LKuDGy57SJ
         TVrs4OfYkQvVnA3eK4hWJnLLblWakVbqe5sC4mN5KYoUsLPpRyA3uBje2jXxcRnx3pCz
         iG0VNQVglN7eGpQQOcbPGHljv/5iZ04yPbx9HjVxLPZVMtSlD79SDTgLJNHsBegBd2X1
         AwOu7AUs0keNFxM5DoTzgfvtnFom3zReWURSxWlfcC7wZHHt2Z97CdW9X9Di3VjabKzz
         a/BucEYs1bZaTN3Ks8B6XanAeCeDwYYQ3BtHQvMSQXDMVLhAR7PuYHhXUNr0OAAETNj5
         0AwQ==
X-Gm-Message-State: AOAM531ZgsX9yIkqfaSQgU9VM3ZJ0RIWrIUmFiMw5zBWdC9g7Ent6CwV
        Nm5pPYID39s4BI0yeHjH+TTS1f+WvlhyNjTG1Bd9SccECRIgEfmENzpYU/o6KPGBfQIjTpiBoM/
        fz6THsONMTgQCogZ50qxglYU0HbSg1bPKz1R+Mv0SL5QXJe3GBj0kFc3XbbkBqjlLjsVnUyw=
X-Received: by 2002:a62:1d09:0:b0:4fd:8b00:d28 with SMTP id d9-20020a621d09000000b004fd8b000d28mr15815907pfd.81.1649358893781;
        Thu, 07 Apr 2022 12:14:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4aYwhDQkMPWdcWqpHpGMx+BKiK+ZDiySbrlcC/0hW9kcmF4qf7m24c2PCu8QeB0PLyMN9ZQ==
X-Received: by 2002:a62:1d09:0:b0:4fd:8b00:d28 with SMTP id d9-20020a621d09000000b004fd8b000d28mr15815850pfd.81.1649358892977;
        Thu, 07 Apr 2022 12:14:52 -0700 (PDT)
Received: from [10.72.12.194] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a00115000b004f6ff260c9esm23099920pfm.207.2022.04.07.12.14.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 12:14:52 -0700 (PDT)
Subject: Re: [PATCH 2/2] ceph: fix coherency issue when truncating file size
 for fscrypt
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
References: <20220407144112.8455-1-xiubli@redhat.com>
 <20220407144112.8455-3-xiubli@redhat.com>
 <3315c167cc44f38c4eb9ebe76685418e85c9b9f2.camel@kernel.org>
 <6439751daf27285f77239172a9bb5d5f0f80eede.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <fd37ed30-b066-ce4d-ba99-1a85d593c5d3@redhat.com>
Date:   Fri, 8 Apr 2022 03:14:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <6439751daf27285f77239172a9bb5d5f0f80eede.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/7/22 11:38 PM, Jeff Layton wrote:
> On Thu, 2022-04-07 at 11:33 -0400, Jeff Layton wrote:
>> On Thu, 2022-04-07 at 22:41 +0800, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> When truncating the file size the MDS will help update the last
>>> encrypted block, and during this we need to make sure the client
>>> won't fill the pagecaches.
>>>
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>   fs/ceph/inode.c | 7 ++++++-
>>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>>> index f4059d73edd5..cc1829ab497d 100644
>>> --- a/fs/ceph/inode.c
>>> +++ b/fs/ceph/inode.c
>>> @@ -2647,9 +2647,12 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>>>   		req->r_num_caps = 1;
>>>   		req->r_stamp = attr->ia_ctime;
>>>   		if (fill_fscrypt) {
>>> +			filemap_invalidate_lock(inode->i_mapping);
>>>   			err = fill_fscrypt_truncate(inode, req, attr);
>>> -			if (err)
>>> +			if (err) {
>>> +				filemap_invalidate_unlock(inode->i_mapping);
>>>   				goto out;
>>> +			}
>>>   		}
>>>   
>>>   		/*
>>> @@ -2660,6 +2663,8 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>>>   		 * it.
>>>   		 */
>>>   		err = ceph_mdsc_do_request(mdsc, NULL, req);
>>> +		if (fill_fscrypt)
>>> +			filemap_invalidate_unlock(inode->i_mapping);
>>>   		if (err == -EAGAIN && truncate_retry--) {
>>>   			dout("setattr %p result=%d (%s locally, %d remote), retry it!\n",
>>>   			     inode, err, ceph_cap_string(dirtied), mask);
>> Looks reasonable. Is there any reason we shouldn't do this in the non-
>> encrypted case too? I suppose it doesn't make as much difference in that
>> case.

We only need this in encrypted case, which will do the RMW for the last 
block.


>> I'll plan to pull this and the other patch into the wip-fscrypt branch.
>> Should I just fold them into your earlier patches?
Yeah, certainly.
> OTOH...do we really need this? I'm not sure I understand the race you're
> trying to prevent. Can you lay it out for me?

I am thinking during the RMW for the last block, the page fault still 
could happen because the page fault function doesn't prevent that.

And we should prevent it during the RMW is going on.

-- Xiubo

>
> Thanks,

