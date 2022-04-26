Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F40950EEF2
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Apr 2022 04:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242710AbiDZC5M (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Apr 2022 22:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242634AbiDZC5L (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Apr 2022 22:57:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 87A8711F96E
        for <ceph-devel@vger.kernel.org>; Mon, 25 Apr 2022 19:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650941639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+500b5GKzu7RWWw3KSFVj0nJ8mi1vlJI11+mnaPgRR4=;
        b=ATXz10UC7ulTa8z/MsnlfMh1NYZ6quy8b2CGOAR6Lqu1mGgWpPzYuYCHEsKygovulkPMVi
        71eE6i43XkWxhe/50mQ0eLKprbX28sdb6UgKf3Q/CWFkOw+6ELeC48sbscTczZXxu6WOOL
        Opo/lRNHYwB4i6d4znGuhkuqaWir6Mw=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-298-sXBqR-SmNCeIlxDTzzTt4w-1; Mon, 25 Apr 2022 22:53:57 -0400
X-MC-Unique: sXBqR-SmNCeIlxDTzzTt4w-1
Received: by mail-pl1-f198.google.com with SMTP id i10-20020a1709026aca00b00158f14b4f2fso10536387plt.2
        for <ceph-devel@vger.kernel.org>; Mon, 25 Apr 2022 19:53:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=+500b5GKzu7RWWw3KSFVj0nJ8mi1vlJI11+mnaPgRR4=;
        b=Kc5gPNhve1LuGCEN0+jYGQ11uZ/e0kYaEcws4sze7lS0BYIP5pdPHm+Y7f6XWLj8nJ
         yX+DWalcoJxrhGrZ+93BGwaxTesvpR9LhIZOwvkonsnHiJBaMiwfZf6HfeOduTsa8A1f
         wKlO0q9mK9elzt28JOx3+tCHIo2KajRZK/RbOZX9i9vunDpTKGD/3PgiQgsBVxYv6mmk
         8q0GoVMZGaZQIEweAl+TES/Sf69sbPotew99veIpIhk1mfDhFrRaXKPVrFhRwx6HEz1/
         iuS+EJlVhxdhnaRniFbGsZ8M5ZJVGM6exrlJ6rtfjuQC9eDqELQl7dP2nIaaGdIznWY+
         2BJg==
X-Gm-Message-State: AOAM5330C0KkQ8bpQoavkWjh3xX7Kly5UjuYbrfwml73ZijUy6fxnPyF
        pMq70quDsm9jBJQ+62VbnBgL5NZ+2o+ZOtyVBRHXqUiYSSlUbnCosgeLd4WUYXqu2tkg1FULDsA
        tlSIwbuYfPSUobO3Jujdzsw==
X-Received: by 2002:a17:90b:1a8f:b0:1d2:acdc:71d2 with SMTP id ng15-20020a17090b1a8f00b001d2acdc71d2mr24547233pjb.41.1650941636700;
        Mon, 25 Apr 2022 19:53:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6M05wZQX0yjlgxO/3ZfACIjcvj0GWnHA37N1kuHJczSNdp3/50aKpKIdERVTX3kfSO1LFlw==
X-Received: by 2002:a17:90b:1a8f:b0:1d2:acdc:71d2 with SMTP id ng15-20020a17090b1a8f00b001d2acdc71d2mr24547213pjb.41.1650941636432;
        Mon, 25 Apr 2022 19:53:56 -0700 (PDT)
Received: from [10.72.12.77] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t20-20020a63eb14000000b0039e28245722sm10941863pgh.54.2022.04.25.19.53.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 19:53:55 -0700 (PDT)
Subject: Re: [PATCH] ceph: fix setting of xattrs on async created inodes
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org,
        John Fortin <fortinj66@gmail.com>,
        Sri Ramanujam <sri@ramanujam.io>
References: <20220425195427.60738-1-jlayton@kernel.org>
 <0263808c24d40c8672b17805327c585fe4b08703.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c78f65ee-a43a-9994-bd28-f6d65f082aa2@redhat.com>
Date:   Tue, 26 Apr 2022 10:53:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <0263808c24d40c8672b17805327c585fe4b08703.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/26/22 3:57 AM, Jeff Layton wrote:
> On Mon, 2022-04-25 at 15:54 -0400, Jeff Layton wrote:
>> Currently when we create a file, we spin up an xattr buffer to send
>> along with the create request. If we end up doing an async create
>> however, then we currently pass down a zero-length xattr buffer.
>>
>> Fix the code to send down the xattr buffer in req->r_pagelist. If the
>> xattrs span more than a page, however give up and don't try to do an
>> async create.
>>
>> Fixes: 9a8d03ca2e2c ("ceph: attempt to do async create when possible")
>> URL: https://bugzilla.redhat.com/show_bug.cgi?id=2063929
>> Reported-by: John Fortin <fortinj66@gmail.com>
>> Reported-by: Sri Ramanujam <sri@ramanujam.io>
>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>> ---
>>   fs/ceph/file.c | 16 +++++++++++++---
>>   1 file changed, 13 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 6c9e837aa1d3..8c8226c0feac 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -629,9 +629,15 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
>>   	iinfo.change_attr = 1;
>>   	ceph_encode_timespec64(&iinfo.btime, &now);
>>   
>> -	iinfo.xattr_len = ARRAY_SIZE(xattr_buf);
>> -	iinfo.xattr_data = xattr_buf;
>> -	memset(iinfo.xattr_data, 0, iinfo.xattr_len);
>> +	if (req->r_pagelist) {
>> +		iinfo.xattr_len = req->r_pagelist->length;
>> +		iinfo.xattr_data = req->r_pagelist->mapped_tail;
>> +	} else {
>> +		/* fake it */
>> +		iinfo.xattr_len = ARRAY_SIZE(xattr_buf);
>> +		iinfo.xattr_data = xattr_buf;
>> +		memset(iinfo.xattr_data, 0, iinfo.xattr_len);
>> +	}
>>   
>>   	in.ino = cpu_to_le64(vino.ino);
>>   	in.snapid = cpu_to_le64(CEPH_NOSNAP);
>> @@ -743,6 +749,10 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>>   		err = ceph_security_init_secctx(dentry, mode, &as_ctx);
>>   		if (err < 0)
>>   			goto out_ctx;
>> +		/* Async create can't handle more than a page of xattrs */
>> +		if (as_ctx.pagelist &&
>> +		    !list_is_singular(&as_ctx.pagelist->head))
>> +			try_async = false;
>>   	} else if (!d_in_lookup(dentry)) {
>>   		/* If it's not being looked up, it's negative */
>>   		return -ENOENT;
> Oh, I meant to mark this for stable as well. Xiubo, can you do that when
> you merge it?

Sure, Jeff.

Looks nice. Merged into the testing branch.

Thanks

-- Xiubo


Looks good. I fixed up the minor spelling error in the comment that
Venky noticed too. Merged into testing branch.

Thanks,



> Thanks,

