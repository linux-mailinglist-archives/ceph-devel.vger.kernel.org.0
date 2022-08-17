Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890E5596E30
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Aug 2022 14:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239279AbiHQMII (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 Aug 2022 08:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239393AbiHQMHt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 Aug 2022 08:07:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B25C861F2
        for <ceph-devel@vger.kernel.org>; Wed, 17 Aug 2022 05:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660738038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vOd1jJn/Mac+YxT2QRS/fU3QrlP+rX/hl7Y5tY+2fJc=;
        b=NH3fYwqA3nTTMH0cVvJftw34FbBvGKhK3CN+4lkgxSReF3cpJHWI2emBCDqZFGgjyvYj7b
        xJ8207XtmwE57wY7pdYu7chIk3qWDczTTyWMhPb+2EZ/ciMco8tqzoTLLdj3QTcXMBoyZr
        9xqvzsqdoAQFlQvOpBp1/WDgUDFv4Wo=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-513-NFncpKACOh2IcBITxydRoQ-1; Wed, 17 Aug 2022 08:07:17 -0400
X-MC-Unique: NFncpKACOh2IcBITxydRoQ-1
Received: by mail-pj1-f69.google.com with SMTP id x8-20020a17090a1f8800b001faa9857ef2so825161pja.0
        for <ceph-devel@vger.kernel.org>; Wed, 17 Aug 2022 05:07:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:to:subject
         :x-gm-message-state:from:to:cc;
        bh=vOd1jJn/Mac+YxT2QRS/fU3QrlP+rX/hl7Y5tY+2fJc=;
        b=6r1wMWF5L9uKtOJMII/Rz5WgFfiSuPA/9cLS08rRE5nFjaN1sg98dP8nix0D18whT9
         4LEPgfM25y0C3vX7B4W9qBHIjTs+c8Hsd5PWxvymAUsMNX3VLx3QiTCR8XLddlwcWlSH
         dEwId1gmTzmu8Dw1gEOlsfZKWh8bz9BESrxsAbMCSj1Fr2CbMefsDnLgclrbUfkp3OS1
         ysFmDd7SvoE6GcYIVXqkis9wxfKsueNzhHhVi8lVK8wgKUNi6wt/govaD0uae6dpJLaH
         ZtaHBgOAPGapKoxEB6n1OurslNWhQJcp2h8qgO8zU101MPwJ+0Cw0jMIxefikpTQnJS3
         dKfA==
X-Gm-Message-State: ACgBeo2WG13e3gaSy5ZuqZQ3YA7sVl8wSPSh4+XOol80AeLq56z2QbSP
        Kl7LKBPyCEcSTZqx7LSRAFU1N4XRO7roqvM6VOyPIumkfoAQHHiUMfRooU74fVSU0CqA32PWojk
        iymPZamoOLurxvNHkEnqcVCvRQBaquTQXPm2FPtWDR9VL4DQ7jNo8qQH8BZFJe/Q3S6L5qks=
X-Received: by 2002:a05:6a00:114f:b0:528:2c7a:634c with SMTP id b15-20020a056a00114f00b005282c7a634cmr25315441pfm.41.1660738035901;
        Wed, 17 Aug 2022 05:07:15 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7OBPL6mZcw2cOyetKKCRSOWodkDw+EY6bugrMnhIeWq9TlxYMwPc1IY/7VwJCH7a6UfDs4Hw==
X-Received: by 2002:a05:6a00:114f:b0:528:2c7a:634c with SMTP id b15-20020a056a00114f00b005282c7a634cmr25315408pfm.41.1660738035426;
        Wed, 17 Aug 2022 05:07:15 -0700 (PDT)
Received: from [10.72.13.207] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d15-20020a170902cecf00b0016bc947c5b7sm1359160plg.38.2022.08.17.05.07.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 05:07:14 -0700 (PDT)
Subject: Re: [PATCH] libceph: advancing variants of iov_iter_get_pages()
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        ceph-devel@vger.kernel.org
References: <20220816024143.519027-1-xiubli@redhat.com>
 <a21d882df74b91738b56d8a289bb55a9dbe2bc34.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <e17d0f18-8d28-ed99-197e-7b1a3ce841dd@redhat.com>
Date:   Wed, 17 Aug 2022 20:07:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <a21d882df74b91738b56d8a289bb55a9dbe2bc34.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
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


On 8/17/22 6:17 PM, Jeff Layton wrote:
> On Tue, 2022-08-16 at 10:41 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The upper layer has changed it to iov_iter_get_pages2(). And this
>> should be folded into the previous commit.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   net/ceph/messenger.c | 17 ++---------------
>>   1 file changed, 2 insertions(+), 15 deletions(-)
>>
>> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
>> index 945f6d1a9efa..020474cf137c 100644
>> --- a/net/ceph/messenger.c
>> +++ b/net/ceph/messenger.c
>> @@ -985,25 +985,12 @@ static struct page *ceph_msg_data_iter_next(struct ceph_msg_data_cursor *cursor,
>>   	if (cursor->lastlen)
>>   		iov_iter_revert(&cursor->iov_iter, cursor->lastlen);
>>   
>> -	len = iov_iter_get_pages(&cursor->iov_iter, &page, PAGE_SIZE,
>> -				 1, page_offset);
>> +	len = iov_iter_get_pages2(&cursor->iov_iter, &page, PAGE_SIZE,
>> +				  1, page_offset);
>>   	BUG_ON(len < 0);
>>   
>>   	cursor->lastlen = len;
>>   
>> -	/*
>> -	 * FIXME: Al Viro says that he will soon change iov_iter_get_pages
>> -	 * to auto-advance the iterator. Emulate that here for now.
>> -	 */
>> -	iov_iter_advance(&cursor->iov_iter, len);
>> -
>> -	/*
>> -	 * FIXME: The assumption is that the pages represented by the iov_iter
>> -	 * 	  are pinned, with the references held by the upper-level
>> -	 * 	  callers, or by virtue of being under writeback. Eventually,
>> -	 * 	  we'll get an iov_iter_get_pages variant that doesn't take page
>> -	 * 	  refs. Until then, just put the page ref.
>> -	 */
> I think the comment above should not be removed. Eventually Al plans to
> add a version of this that doesn't take page refs, and this patch
> doesn't change that.

Okay, I will remove this.


>
>>   	VM_BUG_ON_PAGE(!PageWriteback(page) && page_count(page) < 2, page);
>>   	put_page(page);
>>   
> Patch itself looks fine though. Thanks for fixing it up!
>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
>
Thanks Jeff.


