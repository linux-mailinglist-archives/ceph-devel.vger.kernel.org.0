Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 089476AFC85
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Mar 2023 02:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjCHBvk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Mar 2023 20:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjCHBvj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Mar 2023 20:51:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE7B13DF6
        for <ceph-devel@vger.kernel.org>; Tue,  7 Mar 2023 17:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678240250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6KZ6mQtcDPw+98sYnXI+uYX6iOmspEPV7l3OUt3lNIk=;
        b=VUo1r2iBEZuKsr4KkyNiOoZQgNMtWcBKPipYPV1gFhiahgCIKij7GTN+zXXnCKsrdTh2yC
        2qWLn01vCYR8WFaTNB4xkUlCuWnHcmeFDiJ3NCFxhvLJ3sqpnAD2FrIRYFPKPp/9wg0qSh
        1opDJrHI6+QdzJZAh0oPn4NHWlSunpQ=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-CNB40NnsNbiNw4A2Y8LDEg-1; Tue, 07 Mar 2023 20:50:48 -0500
X-MC-Unique: CNB40NnsNbiNw4A2Y8LDEg-1
Received: by mail-pg1-f197.google.com with SMTP id o3-20020a634e43000000b0050726979a86so2481996pgl.4
        for <ceph-devel@vger.kernel.org>; Tue, 07 Mar 2023 17:50:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678240247;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6KZ6mQtcDPw+98sYnXI+uYX6iOmspEPV7l3OUt3lNIk=;
        b=vmbGQrzVAFQ+SUk4jgGaczzlJ/SsP+qSl1tGybWbiG8sdEazOT+N4QK5ZhHxZncL/F
         bRcGBoIJIgWWvxtHSIB49xTmfyr5ncXr1hVQuJoK75YEnexvtbse8a+KzW4B/EjgcM0H
         EFcitJCCjetFe/E+EglwoYCi6S9U2bRmMeB5oNez3JcgddinaHUqyiD8MjaTWi5fRpff
         GiwO59rNdl6HrsdMriY24iwWS0hGrC4aavUj4AEr5Ho7wMJsGBD7qBgeFCAOK0GBmlkN
         Qzqr4NdgBZRFj4ykqiX4315HIvkDR3WxCvU6YWYfnTqoI648yLHAjYBtK9vOC8cwrJZo
         JNxw==
X-Gm-Message-State: AO0yUKXJsmFULEWhEAWDvLqEcIMVTbaYW5pHABCj7ueZyRzSh11SUkD/
        aoImZthronErTcT2yeALtRFSrDkQ6Iha81K76K76+Cq61M2XZK0rBvX/IQ9jKMMDyXWAbVtYrfg
        BDSLvhx0b9vbH/GUPzzKQhQ==
X-Received: by 2002:a17:902:ea03:b0:19e:2869:7793 with SMTP id s3-20020a170902ea0300b0019e28697793mr19213092plg.16.1678240247582;
        Tue, 07 Mar 2023 17:50:47 -0800 (PST)
X-Google-Smtp-Source: AK7set9tnnOHPjzLCjeg+Jg9BwISc4SKcbtO1N7nEC0HzHlY8KXoZWBPO7G78b6ozZmDoV6aqR0rRg==
X-Received: by 2002:a17:902:ea03:b0:19e:2869:7793 with SMTP id s3-20020a170902ea0300b0019e28697793mr19213077plg.16.1678240247236;
        Tue, 07 Mar 2023 17:50:47 -0800 (PST)
Received: from [10.72.12.78] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id p16-20020a170902ebd000b001994e74c094sm8980951plg.275.2023.03.07.17.50.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 17:50:46 -0800 (PST)
Message-ID: <72e7b6cc-ba6b-796e-2ff6-1e8ff2ac7eee@redhat.com>
Date:   Wed, 8 Mar 2023 09:50:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v16 25/68] ceph: make d_revalidate call fscrypt
 revalidator for encrypted dentries
Content-Language: en-US
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com
References: <20230227032813.337906-1-xiubli@redhat.com>
 <20230227032813.337906-26-xiubli@redhat.com> <87o7p48kby.fsf@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <87o7p48kby.fsf@suse.de>
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


On 08/03/2023 02:53, Luís Henriques wrote:
> xiubli@redhat.com writes:
>
>> From: Jeff Layton <jlayton@kernel.org>
>>
>> If we have a dentry which represents a no-key name, then we need to test
>> whether the parent directory's encryption key has since been added.  Do
>> that before we test anything else about the dentry.
>>
>> Reviewed-by: Xiubo Li <xiubli@redhat.com>
>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>> ---
>>   fs/ceph/dir.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>> index d3c2853bb0f1..5ead9f59e693 100644
>> --- a/fs/ceph/dir.c
>> +++ b/fs/ceph/dir.c
>> @@ -1770,6 +1770,10 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
>>   	struct inode *dir, *inode;
>>   	struct ceph_mds_client *mdsc;
>>   
>> +	valid = fscrypt_d_revalidate(dentry, flags);
>> +	if (valid <= 0)
>> +		return valid;
>> +
> This patch has confused me in the past, and today I found myself
> scratching my head again looking at it.
>
> So, I've started seeing generic/123 test failing when running it with
> test_dummy_encryption.  I was almost sure that this test used to run fine
> before, but I couldn't find any evidence (somehow I lost my old testing
> logs...).
>
> Anyway, the test is quite simple:
>
> 1. Creates a directory with write permissions for root only
> 2. Writes into a file in that directory
> 3. Uses 'su' to try to modify that file as a different user, and
>     gets -EPERM
>
> All these steps run fine, and the test should pass.  *However*, in the
> test cleanup function, a simple 'rm -rf <dir>' will fail with -ENOTEMPTY.
> 'strace' shows that calling unlinkat() to remove the file got a '-ENOENT'
> and then -ENOTEMPTY for the directory.
>
> Some digging allowed me to figure out that running commands with 'su' will
> drop caches (I see 'su (874): drop_caches: 2' in the log).  And this is
> how I ended up looking at this patch.  fscrypt_d_revalidate() will return
> '0' if the parent directory does has a key (fscrypt_has_encryption_key()).
> Can we really say here that the dentry is *not* valid in that case?  Or
> should that '<= 0' be a '< 0'?
>
> (But again, this patch has confused me before...)

Luis,

Could you reproduce it with the latest testing branch ?

I never seen the generic/123 failure yet. And just now I ran the test 
for many times locally it worked fine.

 From the generic/123 test code it will never touch the key while 
testing, that means the dentries under the test dir will always have the 
keyed name. And then the 'fscrypt_d_revalidate()' should return 1 always.

Only when we remove the key will it trigger evicting the inodes and then 
when we add the key back will the 'fscrypt_d_revalidate()' return 0 by 
checking the 'fscrypt_has_encryption_key()'.

As I remembered we have one or more fixes about this those days, not 
sure whether you were hitting those bugs we have already fixed ?

Thanks

- Xiubo

> Cheers,

