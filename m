Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C211E4C8C54
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Mar 2022 14:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbiCANNx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Mar 2022 08:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbiCANNx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Mar 2022 08:13:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C06E24BFF
        for <ceph-devel@vger.kernel.org>; Tue,  1 Mar 2022 05:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646140391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pa/93NjB/f6EauEUP8czWGYsdEfpwkCjjkpWmEDM3gU=;
        b=Z6aHMYQ6dgiE55pnqaKARKyFyg0rC/a+P8Ihgwselif9y7hwZusffZf89krQdDfAnVySJv
        b+uqJJwdCacr+041LUvgsvAY8pS9HKIUSPgOt0FKdeH1VTyKa5Z4UxOvI0S7/y6ahDbREj
        PG+hR03PeDnJDE0uXxUrRFeW6XK+eTM=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-150-r75cNq5GNKOQx4NJPmuR7g-1; Tue, 01 Mar 2022 08:13:10 -0500
X-MC-Unique: r75cNq5GNKOQx4NJPmuR7g-1
Received: by mail-pf1-f198.google.com with SMTP id d5-20020a623605000000b004e01ccd08abso9771177pfa.10
        for <ceph-devel@vger.kernel.org>; Tue, 01 Mar 2022 05:13:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Pa/93NjB/f6EauEUP8czWGYsdEfpwkCjjkpWmEDM3gU=;
        b=ypTjIl7dwLr5wF30UP5rgSsJdOflT49Ug2SDBJofZM6LWoRbniGJsxqWJJg7z2ec5C
         Gv3RBTrc8kzr7PSmtd5RzDU95wyymoB4vtmmJe4QoA/AGWaPAGtVAVKjMR3hdr2L+G7n
         dNjICoDPT2mU589VXcShU00JYnQLjpsouMjvEKJQzK7bvXDGPzYdMoWYHc1LFW3Vt6Fk
         spj1tc4VtFFT8WlR3WIIRyfLFNNzrmP2uavTdTluVINMMD5KzxAoZHhHWtQedeMzUFM1
         MmxA8MVtEX9u1OoYoH5M8YtFHZVWEqGlYcm0pW/plIAHHoDY9c4VniYhzAubH/AWkU7c
         dDAQ==
X-Gm-Message-State: AOAM531N6Lqrf7L5e2t4TOMQcaCfu+PGgLGo0wawWnfYh3hBq8yurs4J
        zYjTCMzD2EC3gXMYnIsPogj+489bBg0AQG77uJflHbRhnCRrFjRPglyXr2MMmFMkTAnOEJ8fMBv
        DzN/5FARX+Nr7kI//mPID4QLdsXUbUEIWHFOUeQq0p5kv2Ug9G0zuN3nDjoa+Rb8FoaCp5sg=
X-Received: by 2002:aa7:9902:0:b0:4cb:95a7:a4c4 with SMTP id z2-20020aa79902000000b004cb95a7a4c4mr26994397pff.85.1646140389212;
        Tue, 01 Mar 2022 05:13:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJznq+e915tNmOdqhjKxQNpKe8bqFuAb5EoSOR5iVvJ4DjvZs3OEuAqg9t6le+9tvLIWbFOZeA==
X-Received: by 2002:aa7:9902:0:b0:4cb:95a7:a4c4 with SMTP id z2-20020aa79902000000b004cb95a7a4c4mr26994357pff.85.1646140388773;
        Tue, 01 Mar 2022 05:13:08 -0800 (PST)
Received: from [10.72.12.114] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s42-20020a056a0017aa00b004df8133df4asm18610252pfg.179.2022.03.01.05.13.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 05:13:08 -0800 (PST)
Subject: Re: [PATCH] ceph: fix memory leakage in ceph_readdir
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220301055915.425624-1-xiubli@redhat.com>
 <baa7c5eaa9304c60aa87f5304faa84d5ce0ea038.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <654024fb-cd88-ca25-631d-694a8c3dacc7@redhat.com>
Date:   Tue, 1 Mar 2022 21:13:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <baa7c5eaa9304c60aa87f5304faa84d5ce0ea038.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/1/22 8:49 PM, Jeff Layton wrote:
> On Tue, 2022-03-01 at 13:59 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/dir.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>> index 0cf6afe283e9..6184cf123fa2 100644
>> --- a/fs/ceph/dir.c
>> +++ b/fs/ceph/dir.c
>> @@ -521,6 +521,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>   			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
>>   			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
>>   			dout("filldir stopping us...\n");
>> +			ceph_mdsc_put_request(dfi->last_readdir);
>>   			return 0;
>>   		}
>>   		ctx->pos++;
> Good catch!
>
> It looks like there is another missing put around line 482 after the
> note_last_dentry call. Could you fix that one up in the same patch?
>
Sure. Will fix it.

- Xiubo


> Reviewed-by: Jeff Layton <jlayton@kernel.org>
>

