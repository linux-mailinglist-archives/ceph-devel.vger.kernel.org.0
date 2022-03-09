Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48C54D2585
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Mar 2022 02:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiCIBHK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Mar 2022 20:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiCIBHD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Mar 2022 20:07:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 235741390C4
        for <ceph-devel@vger.kernel.org>; Tue,  8 Mar 2022 16:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646786785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J1HoSNHaKJxiXTIro01sKw6b2jsQX8ctyZCofPBbDWY=;
        b=WX183+6lmw1Ud6E2LVnt0hsVYYJUSsZpCWli6vb2C+4I2f2hnJoAVyJ2ZAY4GkNFapllPJ
        vMvE2Qxn6j3izBwm3wQ98INHlTxnsjxPKkTxA3aE5Tge38AELo7nYbdkyEEZpiVrMADCve
        4LNOBIhC2peYiOXent7c8ioqrC2gMuM=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-FNKkuaxmOyKCDLL7lVr9uQ-1; Tue, 08 Mar 2022 19:46:24 -0500
X-MC-Unique: FNKkuaxmOyKCDLL7lVr9uQ-1
Received: by mail-pj1-f70.google.com with SMTP id c14-20020a17090a674e00b001bf1c750f9bso2658454pjm.9
        for <ceph-devel@vger.kernel.org>; Tue, 08 Mar 2022 16:46:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=J1HoSNHaKJxiXTIro01sKw6b2jsQX8ctyZCofPBbDWY=;
        b=0Rt0GJhbC4ToCdC+l7jaHFC0JUJPyb5PN/THwF3Njv8JtB1laauW+mKBgRqxwfuDUf
         yOGFM76OUHfeViNU6AHkEnmqGUJnEkskWoTdIZYuFXbTzsILTrt19qe6urrvBOTuC4wX
         R1UQHbfZ7aHOi9wJtlQi9lnLC/T3pQS3zHZ6PPNL2/TsQWjHVCcGSHUlutcrqUpG7ay6
         dMzHf1LoRGPMfTKhNzxyH3VvBBmlcEzSMUcMYa8epJuXA5H41lPWWnWhzvYV/4VYWyFp
         33cLHOieRHrLseB0AmkyRDfhnX1a1XGRFZJpGDwjDnHNqsnQ1P3w9w99+cOw09k1TVqg
         6lCA==
X-Gm-Message-State: AOAM532DkZguM9lB+30n1MYaw7JFeYGD3dYGJmfrRqktqbVjPlrfiLZ+
        0GXt5uEsQe7hqpCezwXULfiXlUOcmqm/4Axu63DEAsqNja0H0gRfjrzBP+i/hx+Jx80IeILukSR
        +iqwZErKa41d1DiBthISTnR7lkbTB7l7t5f+K8Q2KyfP+ogf7gajnQ90OrsmGEQSJdrDQJsU=
X-Received: by 2002:a17:902:8f8b:b0:149:6639:4b86 with SMTP id z11-20020a1709028f8b00b0014966394b86mr20860769plo.60.1646786782792;
        Tue, 08 Mar 2022 16:46:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyK218gI8qvzEu2jwJtIkXPC0XgjQoJSFNOGjF0lMzEAT4nMn9XwPDRLk6g9+o5YQCL+A7wmg==
X-Received: by 2002:a17:902:8f8b:b0:149:6639:4b86 with SMTP id z11-20020a1709028f8b00b0014966394b86mr20860755plo.60.1646786782417;
        Tue, 08 Mar 2022 16:46:22 -0800 (PST)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j16-20020a63e750000000b00373598b8cbfsm271938pgk.74.2022.03.08.16.46.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 16:46:21 -0800 (PST)
Subject: Re: [PATCH v3] ceph: fix memory leakage in ceph_readdir
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20220305115259.1076790-1-xiubli@redhat.com>
 <008e0b72ab9412afe8f2dcf9f47ad4f000c44228.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <dea9ffeb-fae0-9b33-2787-f46e7ffbd277@redhat.com>
Date:   Wed, 9 Mar 2022 08:46:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <008e0b72ab9412afe8f2dcf9f47ad4f000c44228.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/8/22 11:06 PM, Jeff Layton wrote:
> On Sat, 2022-03-05 at 19:52 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Reset the last_readdir at the same time.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/dir.c | 11 ++++++++++-
>>   1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>> index 6be0c1f793c2..6df2a91af236 100644
>> --- a/fs/ceph/dir.c
>> +++ b/fs/ceph/dir.c
>> @@ -498,8 +498,11 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>   					2 : (fpos_off(rde->offset) + 1);
>>   			err = note_last_dentry(dfi, rde->name, rde->name_len,
>>   					       next_offset);
>> -			if (err)
>> +			if (err) {
>> +				ceph_mdsc_put_request(dfi->last_readdir);
>> +				dfi->last_readdir = NULL;
>>   				goto out;
>> +			}
> Looks good, but this doesn't apply cleanly to the testing branch since
> it still does a "return 0" there instead of "goto out". I adapted it to
> work with testing branch and will do some testing with it today.
>
I think I was working on the wip-fscrypt branch. Thanks Jeff.

- Xiubo


>>   		} else if (req->r_reply_info.dir_end) {
>>   			dfi->next_offset = 2;
>>   			/* keep last name */
>> @@ -552,6 +555,12 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>   		if (!dir_emit(ctx, oname.name, oname.len,
>>   			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
>>   			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
>> +			/*
>> +			 * NOTE: Here no need to put the 'dfi->last_readdir',
>> +			 * because when dir_emit stops us it's most likely
>> +			 * doesn't have enough memory, etc. So for next readdir
>> +			 * it will continue.
>> +			 */
>>   			dout("filldir stopping us...\n");
>>   			err = 0;
>>   			goto out;

