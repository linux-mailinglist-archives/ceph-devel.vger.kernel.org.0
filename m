Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564CA6689EC
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Jan 2023 04:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjAMDKj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Jan 2023 22:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjAMDKh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 12 Jan 2023 22:10:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF1EDC7
        for <ceph-devel@vger.kernel.org>; Thu, 12 Jan 2023 19:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673579390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NvMT/fDP8z61hXVpoKPNXCN8zpHsyty1o6l4dj9ElZk=;
        b=h9OlWytqBplIvYbIv0v22ajCdsgW7aUhTYgZpgqYnCMjkQ9JiE4dD7Htl6ZgVSMzaEdLub
        4EbykMdEnpcHTqMxeRS8nTOUonE4d8PgJZZEw3k9+1o3rr1TRPL/CyOrs8qjG8afsWYJbR
        TUZh7pgGZTRNRPtPh09uuAlEJzYQf8Y=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-379-ePMidbJvOxWIA51p5cGsiw-1; Thu, 12 Jan 2023 22:09:48 -0500
X-MC-Unique: ePMidbJvOxWIA51p5cGsiw-1
Received: by mail-pj1-f72.google.com with SMTP id pm1-20020a17090b3c4100b002292b6258a0so34746pjb.1
        for <ceph-devel@vger.kernel.org>; Thu, 12 Jan 2023 19:09:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NvMT/fDP8z61hXVpoKPNXCN8zpHsyty1o6l4dj9ElZk=;
        b=5huF567BZuif4TMumwt+fBH6jKvp5+yskvbXyUr/PW+CF3TNhqOym0pISek4P3DKwc
         MIItjg+Zw/wmu6Hv/m+cBmSRpsniMlRKhUxLT6MRQ+Bc2sL3VUfXo83xOgBmrwNBu2Ib
         kwPrHhvsBurxWo9CsyD/uKwhj8R4Emobww0gA0DVAZ8amXbstmj3hLEJg6akKgQfUn5t
         jougHwKqTpJSF0L1bPimY0y0y1XOpFjEl5b+kQmDHUjUN2a2DaqTzbYqceAAQL0NbZma
         i+ltoGC2tWEQLZ5Lp3fFJOY2bPi+rEJxh3h7hj9TxYKyMl0dre6YmIfi8j4mfIOvhnzr
         4KpA==
X-Gm-Message-State: AFqh2krCFweZCi4PfO9vtM5srCZjt8HhtaIP65y5fSHbPug5VYrh4bzW
        5/0PqHsFn5LyCY1mjktyvKR1E9Ohptie6Wi7mf+MgTNDDYZ+PEMz0DuUkqkbCItW7owLE3mEhmi
        VNSmHSi+JKxEJje9S20XB5w==
X-Received: by 2002:a17:90a:ead2:b0:226:f8dc:b237 with SMTP id ev18-20020a17090aead200b00226f8dcb237mr20348791pjb.31.1673579387706;
        Thu, 12 Jan 2023 19:09:47 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuu9zJWlpGrnRR6lQkxyRiQZvzE9+yOFDODhOUk8ECpdE4QZMVfIqQ95/ANUFC/AvLyO48kOw==
X-Received: by 2002:a17:90a:ead2:b0:226:f8dc:b237 with SMTP id ev18-20020a17090aead200b00226f8dcb237mr20348771pjb.31.1673579387312;
        Thu, 12 Jan 2023 19:09:47 -0800 (PST)
Received: from [10.72.12.200] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s88-20020a17090a69e100b002262ab43327sm10104537pjj.26.2023.01.12.19.09.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 19:09:46 -0800 (PST)
Message-ID: <8e991fc0-d320-610e-e302-564903efa883@redhat.com>
Date:   Fri, 13 Jan 2023 11:09:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] ceph: fix double free for req when failing to allocate
 sparse ext map
Content-Language: en-US
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        ceph-devel@vger.kernel.org
Cc:     mchangir@redhat.com, vshankar@redhat.com
References: <20230111011403.570964-1-xiubli@redhat.com>
 <18fb6b6426b7a18cd4245e12ac8709c646a81871.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <18fb6b6426b7a18cd4245e12ac8709c646a81871.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 12/01/2023 20:09, Jeff Layton wrote:
> On Wed, 2023-01-11 at 09:14 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Introduced by commit d1f436736924 ("ceph: add new mount option to enable
>> sparse reads") and will fold this into the above commit since it's
>> still in the testing branch.
>>
>> Reported-by: Ilya Dryomov <idryomov@gmail.com>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/addr.c | 4 +---
>>   1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index 17758cb607ec..3561c95d7e23 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -351,10 +351,8 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
>>   
>>   	if (sparse) {
>>   		err = ceph_alloc_sparse_ext_map(&req->r_ops[0]);
>> -		if (err) {
>> -			ceph_osdc_put_request(req);
>> +		if (err)
>>   			goto out;
>> -		}
>>   	}
>>   
>>   	dout("%s: pos=%llu orig_len=%zu len=%llu\n", __func__, subreq->start, subreq->len, len);
> Looks right.
>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>

Already folded this into the previous commit.

Thanks Jeff.

-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

