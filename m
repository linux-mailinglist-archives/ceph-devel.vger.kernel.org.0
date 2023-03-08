Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77DC6B04D8
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Mar 2023 11:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjCHKn7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Mar 2023 05:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjCHKn5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Mar 2023 05:43:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EDB1514D
        for <ceph-devel@vger.kernel.org>; Wed,  8 Mar 2023 02:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678272177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OBZpiWeEBMcF1zRE788ds/axli9yBXzOPwYYdnfxzSk=;
        b=Yv0VOp+/tO3ZrQgXZ8nDLQWxFdpx2xHYemv60kLHc2oy804mdU9yndfx/lduKvCBoSlwzG
        xihJxwSKx75F1oZOT0UPDuqUdtpniBW+oFfEjO49iUIP9cT6RgjPg8nY8Zy75AnjAxZ6lV
        Y0A86pok1aRjwbyIJdCX2KYZT5MBJbM=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-538-NdzH3M8aPUGrME8vluqobQ-1; Wed, 08 Mar 2023 05:42:56 -0500
X-MC-Unique: NdzH3M8aPUGrME8vluqobQ-1
Received: by mail-pl1-f198.google.com with SMTP id c3-20020a170902724300b0019d1ffec36dso9179635pll.9
        for <ceph-devel@vger.kernel.org>; Wed, 08 Mar 2023 02:42:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678272175;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OBZpiWeEBMcF1zRE788ds/axli9yBXzOPwYYdnfxzSk=;
        b=4L23muVCNtJU32ZfyHyYffX4GqsB+oYS7+JHA+bzCtb9UjETRUvN/rvZEE0xr2PCOj
         IU/nghdIcpifG0jxXYBiKn72oPPOdQuC74HC2giJC0BS4hOkub3rezEIu488iHgjFcMe
         lSEBOra1YZLJxO8k9+3AtJU1e4ThY88ng5OrxZPFoThzs9FJLTMXdfhcNlj6Wx+3JQ3G
         TO/ZTP+jQkqEau0ut1ipmCSBF82u1bIrHZpM0aDswrlJUV+0xlEdRvlB4J/ZTRpvIso6
         1UQ7kA9C+vl9jwpzKDEYJUnV76gX1rl5aWqYFgaedJ8w20CeM0+eWta3VKFJPP/1TY+J
         e/QA==
X-Gm-Message-State: AO0yUKXP4Yz8vItiYKpamm8LQiJYjcgXm8111D0uTPReL20g6THpC3LY
        nLvVFwCPYcAhez+Oy9OU4wIwZZ8CNOEU7xTldRBk402pl2a8JT7W5WR+mz9GF3yD1RYcAemEMZJ
        OREoQkk1wvS9SRONjzWZ/Yg==
X-Received: by 2002:a05:6a20:69a3:b0:cd:49a4:305d with SMTP id t35-20020a056a2069a300b000cd49a4305dmr29989507pzk.11.1678272175124;
        Wed, 08 Mar 2023 02:42:55 -0800 (PST)
X-Google-Smtp-Source: AK7set+gmd6GBuiV5i1H9Vae9cvuBcLcCEp1ORIuhszQXXBsH6i+EAEIqiYxNZE51uX5BuvWNliYPQ==
X-Received: by 2002:a05:6a20:69a3:b0:cd:49a4:305d with SMTP id t35-20020a056a2069a300b000cd49a4305dmr29989482pzk.11.1678272174747;
        Wed, 08 Mar 2023 02:42:54 -0800 (PST)
Received: from [10.72.12.78] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e16-20020aa78250000000b005e093020cabsm9152963pfn.45.2023.03.08.02.42.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 02:42:54 -0800 (PST)
Message-ID: <30b9604e-d5fa-7191-5743-b7b5e72acd6b@redhat.com>
Date:   Wed, 8 Mar 2023 18:42:47 +0800
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
 <72e7b6cc-ba6b-796e-2ff6-1e8ff2ac7eee@redhat.com> <87jzzr8ubv.fsf@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <87jzzr8ubv.fsf@suse.de>
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


On 08/03/2023 17:29, Luís Henriques wrote:
> Xiubo Li <xiubli@redhat.com> writes:
>
>> On 08/03/2023 02:53, Luís Henriques wrote:
>>> xiubli@redhat.com writes:
>>>
>>>> From: Jeff Layton <jlayton@kernel.org>
>>>>
>>>> If we have a dentry which represents a no-key name, then we need to test
>>>> whether the parent directory's encryption key has since been added.  Do
>>>> that before we test anything else about the dentry.
>>>>
>>>> Reviewed-by: Xiubo Li <xiubli@redhat.com>
>>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>>> ---
>>>>    fs/ceph/dir.c | 8 ++++++--
>>>>    1 file changed, 6 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>>>> index d3c2853bb0f1..5ead9f59e693 100644
>>>> --- a/fs/ceph/dir.c
>>>> +++ b/fs/ceph/dir.c
>>>> @@ -1770,6 +1770,10 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
>>>>    	struct inode *dir, *inode;
>>>>    	struct ceph_mds_client *mdsc;
>>>>    +	valid = fscrypt_d_revalidate(dentry, flags);
>>>> +	if (valid <= 0)
>>>> +		return valid;
>>>> +
>>> This patch has confused me in the past, and today I found myself
>>> scratching my head again looking at it.
>>>
>>> So, I've started seeing generic/123 test failing when running it with
>>> test_dummy_encryption.  I was almost sure that this test used to run fine
>>> before, but I couldn't find any evidence (somehow I lost my old testing
>>> logs...).
>>>
>>> Anyway, the test is quite simple:
>>>
>>> 1. Creates a directory with write permissions for root only
>>> 2. Writes into a file in that directory
>>> 3. Uses 'su' to try to modify that file as a different user, and
>>>      gets -EPERM
>>>
>>> All these steps run fine, and the test should pass.  *However*, in the
>>> test cleanup function, a simple 'rm -rf <dir>' will fail with -ENOTEMPTY.
>>> 'strace' shows that calling unlinkat() to remove the file got a '-ENOENT'
>>> and then -ENOTEMPTY for the directory.
>>>
>>> Some digging allowed me to figure out that running commands with 'su' will
>>> drop caches (I see 'su (874): drop_caches: 2' in the log).  And this is
>>> how I ended up looking at this patch.  fscrypt_d_revalidate() will return
>>> '0' if the parent directory does has a key (fscrypt_has_encryption_key()).
>>> Can we really say here that the dentry is *not* valid in that case?  Or
>>> should that '<= 0' be a '< 0'?
>>>
>>> (But again, this patch has confused me before...)
>> Luis,
>>
>> Could you reproduce it with the latest testing branch ?
> Yes, I'm seeing this with the latest code.

Okay. That's odd.

BTW, are you using the non-root user to run the test ?

Locally I am using the root user and still couldn't reproduce it.

>
>> I never seen the generic/123 failure yet. And just now I ran the test for many
>> times locally it worked fine.
> That's odd.  With 'test_dummy_encryption' mount option I can reproduce it
> every time.
>
>>  From the generic/123 test code it will never touch the key while testing, that
>> means the dentries under the test dir will always have the keyed name. And then
>> the 'fscrypt_d_revalidate()' should return 1 always.
>>
>> Only when we remove the key will it trigger evicting the inodes and then when we
>> add the key back will the 'fscrypt_d_revalidate()' return 0 by checking the
>> 'fscrypt_has_encryption_key()'.
>>
>> As I remembered we have one or more fixes about this those days, not sure
>> whether you were hitting those bugs we have already fixed ?
> Yeah, I remember now, and I guess there's yet another one here!
>
> I'll look closer into this and see if I can find out something else.  I'm
> definitely seeing 'fscrypt_d_revalidate()' returning 0, so probably the
> bug is in the error paths, when the 'fsgqa' user tries to write into the
> file.

Please add some debug logs in the code.

Thanks

- Xiubo

> Thanks for your feedback, Xiubo.
>
> Cheers,

