Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB504FCBAB
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Apr 2022 03:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbiDLBLv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 11 Apr 2022 21:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348120AbiDLBJU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 11 Apr 2022 21:09:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 122E12DD77
        for <ceph-devel@vger.kernel.org>; Mon, 11 Apr 2022 18:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649725335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rqJa4cAPairQwWOF7QGouMogu4P2j9G0CIwTk6olIfE=;
        b=Ny+94+eZJyYftlkOwn14joV5HaRbu2n4wp9RkQtbOLHnBt+x40xCXm3KwQoetlu85hpb1F
        +RF7o1H9Z1oifK5YmBnquvfu3/8iX2CoVraDSTMh3BaledEIv0EfmwXdlvP514VI9bNpqu
        friyN0APgY1jPu9ULUtS8E9LJeLQTzs=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-7NvA-WvlN3S_zphk0yYRpA-1; Mon, 11 Apr 2022 21:02:14 -0400
X-MC-Unique: 7NvA-WvlN3S_zphk0yYRpA-1
Received: by mail-pj1-f72.google.com with SMTP id m8-20020a17090aab0800b001cb1320ef6eso565359pjq.3
        for <ceph-devel@vger.kernel.org>; Mon, 11 Apr 2022 18:02:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=rqJa4cAPairQwWOF7QGouMogu4P2j9G0CIwTk6olIfE=;
        b=zieZyUxCLluRXoblLSpY0pgJHKBL12T78oG3tq0+Neurqney/zcoUYwewJAuyVzJ9X
         K2W3xyeklfcDIZB0rT3aj//hogAe99lirxqe2yaTpXkgjGM8fH0BxEFfMDJhqm2b3bq3
         jIfPTvMJAdvtQ3XdHDlb8T/WGWzq6+ULLynpqrftRRTDolarvLxRmkITBlHv5n8cnf6X
         N3gKz8npA3t/DgREOJVUT46JoaPOU4UnFDejbm5xowMKXWdAP5PdOcYb2XW4wnpX1abS
         NOBe6zMvH5wopb672tH9BDYONIByCKLNwdo1avAHNFlReRB8EA29Q1ZRJ+9TBEXaswHq
         y+kg==
X-Gm-Message-State: AOAM53358XF6lrIHtIFubFX6GYhvD+PlWbFATVCUc0axt+lLf7iAtQy5
        scgHe+M0A4PDzbzIwRX7ksXGSrzxaTHKhqAh6qdzhuQ0CfiTugyaEWBwxaHXfzoxCim4HdYVyx9
        zus05gpsxSTIzCAZqwJqsSXcAe4BFdVm+uHNR0sUE2mi1j8/NuCf1wjOsfy/AAnzotySLYhc=
X-Received: by 2002:a17:903:2283:b0:156:a2c6:f296 with SMTP id b3-20020a170903228300b00156a2c6f296mr34498426plh.10.1649725332970;
        Mon, 11 Apr 2022 18:02:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwrPQGediK6YnrIe1kJ0NrwqSWmYlIgxTsYk37RD3obAE7UmkVBmMqngGSbRDvWYy2gtBj2eQ==
X-Received: by 2002:a17:903:2283:b0:156:a2c6:f296 with SMTP id b3-20020a170903228300b00156a2c6f296mr34498391plh.10.1649725332628;
        Mon, 11 Apr 2022 18:02:12 -0700 (PDT)
Received: from [10.72.12.194] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x2-20020a63aa42000000b0038265eb2495sm805999pgo.88.2022.04.11.18.02.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 18:02:12 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] ceph: fix caps reference leakage for fscrypt size
 truncating
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
References: <20220411001426.251679-1-xiubli@redhat.com>
 <20220411001426.251679-3-xiubli@redhat.com> <YlRXjaKIX/cDeZqP@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f2d5d93c-f127-4a5b-9f2f-1de8d2a81bf4@redhat.com>
Date:   Tue, 12 Apr 2022 09:02:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YlRXjaKIX/cDeZqP@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/12/22 12:30 AM, Luís Henriques wrote:
> On Mon, Apr 11, 2022 at 08:14:26AM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/inode.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>> index a2ff964e332b..6788a1f88eb6 100644
>> --- a/fs/ceph/inode.c
>> +++ b/fs/ceph/inode.c
>> @@ -2301,7 +2301,6 @@ static int fill_fscrypt_truncate(struct inode *inode,
>>   
>>   	pos = orig_pos;
>>   	ret = __ceph_sync_read(inode, &pos, &iter, &retry_op, &objver);
>> -	ceph_put_cap_refs(ci, got);
>>   	if (ret < 0)
>>   		goto out;
>>   
>> @@ -2365,6 +2364,7 @@ static int fill_fscrypt_truncate(struct inode *inode,
>>   out:
>>   	dout("%s %p size dropping cap refs on %s\n", __func__,
>>   	     inode, ceph_cap_string(got));
>> +	ceph_put_cap_refs(ci, got);
>>   	kunmap_local(iov.iov_base);
>>   	if (page)
>>   		__free_pages(page, 0);
>> -- 
>> 2.27.0
>>
> If the plan is to squash this into commit "ceph: add truncate size
> handling support for fscrypt" it may be worth also fix the
> kmap_local_page()/kunmap_local() as the first few 'goto out' jumps
> shouldn't be doing the kunmap.

Good catch, will fix it in V3.

-- Xiubo


> Cheers,
> --
> Luís
>

