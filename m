Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD3E54594E
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jun 2022 02:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbiFJArW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jun 2022 20:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiFJArV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Jun 2022 20:47:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 703973C0E87
        for <ceph-devel@vger.kernel.org>; Thu,  9 Jun 2022 17:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654822039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I5HaQO1bTgl6NyIRCPfQY2T8zOH392jx6no+DaXW+J8=;
        b=TpBwN7sLZHcQOnT1SKBqwqL7yz03oDRJb8dbTp280eSuRw9hR4A37V9q27vj6iY3zUsWgx
        QoNCCxmUX/lnovE4KIdVVv1ZoXaq6vv8trLZvl3DD21OlzyY534cu/QxTWIqvz748LKZN+
        SKznVBguf2AJruQggWb5Nr6tFx+Pk6U=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-156-B-YxBc3ZNySrZKgAt98bTA-1; Thu, 09 Jun 2022 20:47:18 -0400
X-MC-Unique: B-YxBc3ZNySrZKgAt98bTA-1
Received: by mail-pf1-f200.google.com with SMTP id z186-20020a6233c3000000b00510a6bc2864so13099318pfz.10
        for <ceph-devel@vger.kernel.org>; Thu, 09 Jun 2022 17:47:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=I5HaQO1bTgl6NyIRCPfQY2T8zOH392jx6no+DaXW+J8=;
        b=M1hC7ajmzNTU2R/GZpSVbkib6OR2SaFZDMeFt6CzGo1bml6TMOkvItpJarYoqLj6mW
         ljcpEjurt7PpqcaAJOsfI23hFdqjM1T3X7G+GhMjaIwXqezNrqP8mzrtx6dmCKqWl71p
         ctYgzYaej0zAvSHIbxebja2howmNxDTUvkNohxWsHJkWY1RgpGCGgGWYd0AiyDELnqTe
         82ZgHsj7fUOodsJF5M1Mw/v5SA63OGZygG18tXa9ea6TLxm6cqfrl3T8BOBJA4Q2qg1K
         y/6JgQG6sfyKTKvu6GzY5MoKG4CPg31M/hB5H+nQZoIk23DZJ9cdsANVQOaS0esHiqL8
         nY0w==
X-Gm-Message-State: AOAM5309+FRF3BEnzt75HnXYrJH3BEhK4XhGmCSZ8kmN1QiDC8z1Vtdo
        ulxGq48/FSg4VOxE+9Ygb0oqNzdjUUY9jl8XnYOUjZcTucfwdYYtDhr1aYy3O3GuTEqxyQvnAEG
        4coP+kpmy4UjsSPlhyEenfVVpv8MrZXoOFDiQ6uZT198n8d6+xbw3sFTcMNq9xEnzERtWKDg=
X-Received: by 2002:a65:53cb:0:b0:3fc:5a97:b5fb with SMTP id z11-20020a6553cb000000b003fc5a97b5fbmr36566476pgr.207.1654822036672;
        Thu, 09 Jun 2022 17:47:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwVcjMPOvgWPhWHZmT79LPUgHQ+W3fuMsTucmErjwaSs4I45FDNQ1iVZfmlAP30YnXz6plf/g==
X-Received: by 2002:a65:53cb:0:b0:3fc:5a97:b5fb with SMTP id z11-20020a6553cb000000b003fc5a97b5fbmr36566454pgr.207.1654822036332;
        Thu, 09 Jun 2022 17:47:16 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k14-20020aa7998e000000b0050dc7628137sm18481384pfh.17.2022.06.09.17.47.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 17:47:15 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] generic/020: adjust max_attrval_size for ceph
To:     David Disseldorp <ddiss@suse.de>,
        =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     fstests@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
References: <20220609105343.13591-1-lhenriques@suse.de>
 <20220609105343.13591-2-lhenriques@suse.de> <20220609162109.23883b71@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c2f88303-5360-6dca-93f1-a488f39f2325@redhat.com>
Date:   Fri, 10 Jun 2022 08:47:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220609162109.23883b71@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/9/22 10:21 PM, David Disseldorp wrote:
> Hi Luís,
>
> On Thu,  9 Jun 2022 11:53:42 +0100, Luís Henriques wrote:
>
>> CephFS doesn't have a maximum xattr size.  Instead, it imposes a maximum
>> size for the full set of xattrs names+values, which by default is 64K.
>>
>> This patch fixes the max_attrval_size so that it is slightly < 64K in
>> order to accommodate any already existing xattrs in the file.
>>
>> Signed-off-by: Luís Henriques <lhenriques@suse.de>
>> ---
>>   tests/generic/020 | 10 +++++++++-
>>   1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/tests/generic/020 b/tests/generic/020
>> index d8648e96286e..76f13220fe85 100755
>> --- a/tests/generic/020
>> +++ b/tests/generic/020
>> @@ -128,7 +128,7 @@ _attr_get_max()
>>   	pvfs2)
>>   		max_attrval_size=8192
>>   		;;
>> -	xfs|udf|9p|ceph)
>> +	xfs|udf|9p)
>>   		max_attrval_size=65536
>>   		;;
>>   	bcachefs)
>> @@ -139,6 +139,14 @@ _attr_get_max()
>>   		# the underlying filesystem, so just use the lowest value above.
>>   		max_attrval_size=1024
>>   		;;
>> +	ceph)
>> +		# CephFS does not have a maximum value for attributes.  Instead,
>> +		# it imposes a maximum size for the full set of xattrs
>> +		# names+values, which by default is 64K.  Set this to a value
>> +		# that is slightly smaller than 64K so that it can accommodate
>> +		# already existing xattrs.
>> +		max_attrval_size=65000
>> +		;;
> I take it a more exact calculation would be something like:
> (64K - $max_attrval_namelen - sizeof(user.snrub="fish2\012"))?

Yeah, something like this looks better to me.

I am afraid without reaching up to the real max size we couldn't test 
the real bugs out from ceph. Such as the bug you fixed in ceph Locker.cc 
code.


> Perhaps you could calculate this on the fly for CephFS by passing in the
> filename and subtracting the `getfattr -d $filename` results... That
> said, it'd probably get a bit ugly, expecially if encoding needs to be
> taken into account.
>
> Reviewed-by: David Disseldorp <ddiss@suse.de>
>
> Cheers, David
>

