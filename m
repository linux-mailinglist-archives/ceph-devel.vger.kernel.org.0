Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7315A6B2344
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Mar 2023 12:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbjCILmR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Mar 2023 06:42:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjCILmQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Mar 2023 06:42:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DD2E2C62
        for <ceph-devel@vger.kernel.org>; Thu,  9 Mar 2023 03:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678362092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f+f6TWNPTVU+8CpowNWVvgVWWHUhBdC9XTBZ/9Wtqvw=;
        b=V4fS8Xk+MpdvKW5bdQjW8GiBshLqDOoTgVM/LJCr+EblGC/M+nRmdtorFXCoZhlF32tcY0
        SdC5gzPIL2XvSZ6kQ1IA3RdHgM+QaSAqVA4yWkxVUx+DloTKuHsBsXxNg5YT07JaVTlsO4
        kC5wEFubP0TIABSKj1Tx9seKGSa9Zvk=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-48-T1Mo8nBoORiZZ87uLDWzTw-1; Thu, 09 Mar 2023 06:41:30 -0500
X-MC-Unique: T1Mo8nBoORiZZ87uLDWzTw-1
Received: by mail-pj1-f71.google.com with SMTP id mp16-20020a17090b191000b0023ab4b5b064so1023838pjb.9
        for <ceph-devel@vger.kernel.org>; Thu, 09 Mar 2023 03:41:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678362090;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f+f6TWNPTVU+8CpowNWVvgVWWHUhBdC9XTBZ/9Wtqvw=;
        b=WV7aYGZgZuJnVrJTnieez3oVjqevJ0rVI4LTMU1Pgr08+neTgKXA6KPsNAjUwnNFpR
         Tm8r6uMOeeHRh5COURLSHUwX/Isrcl17Ss8K8/ffQTv3jokT2JgU6w+3MtpYBq1wnfbC
         Fj0LuUcJcCKTYs9FdBOUrbS+OK0K+mtNWKJiWFzfeSygP/bUmINpZuUUSNSaNFg8PykM
         69haJVSeVkcF7ocV8F1TEOeB3vlCAVLTqW+Qdx5TlEcpdtI4uEQSMLsbBjMd02OsnMY0
         ZBnWDjhrjFurICOK4Imr1GoOPKWTHurBCdmUSbxqTZPZeWK2gq27u965rw9AiU1SpA+u
         zfBg==
X-Gm-Message-State: AO0yUKV27wu6xxJ+kKBEj16whX51Bjve4+pA7iis7+kW1ndgF4LrTsUn
        NNG1vLExFO1MV3KXgvoPnt6KLUkwNDh4uUCNR+v4TITNG+OE0lekRIELcU3hYEPqpBvthoI4/iv
        6/g+oaW4iJsRszKmhLscbIw==
X-Received: by 2002:a62:6185:0:b0:5a9:d4fa:d3c7 with SMTP id v127-20020a626185000000b005a9d4fad3c7mr20703260pfb.7.1678362089666;
        Thu, 09 Mar 2023 03:41:29 -0800 (PST)
X-Google-Smtp-Source: AK7set8GpxIVG+FSjbSp4tdyebdfiXOFzWweD1u4SJ2NWaXxS1qDbYpG8GSsFbhZcf//buEiEYui3A==
X-Received: by 2002:a62:6185:0:b0:5a9:d4fa:d3c7 with SMTP id v127-20020a626185000000b005a9d4fad3c7mr20703237pfb.7.1678362089333;
        Thu, 09 Mar 2023 03:41:29 -0800 (PST)
Received: from [10.72.13.99] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a14-20020a62e20e000000b00582f222f088sm11055493pfi.47.2023.03.09.03.41.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Mar 2023 03:41:28 -0800 (PST)
Message-ID: <3fe4469f-5906-34c0-4a23-4ca2923be5fc@redhat.com>
Date:   Thu, 9 Mar 2023 19:41:23 +0800
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
 <30b9604e-d5fa-7191-5743-b7b5e72acd6b@redhat.com> <87fsaf88sc.fsf@suse.de>
 <d2eedcdc-9019-2004-acd9-7bdbc953488f@redhat.com> <87o7p26ygw.fsf@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <87o7p26ygw.fsf@suse.de>
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


On 09/03/2023 17:55, Luís Henriques wrote:
> Xiubo Li <xiubli@redhat.com> writes:
>
>> On 09/03/2023 01:14, Luís Henriques wrote:
>>> Xiubo Li <xiubli@redhat.com> writes:
>>>
>>>> On 08/03/2023 17:29, Luís Henriques wrote:
>>>>> Xiubo Li <xiubli@redhat.com> writes:
>>>>>
>>>>>> On 08/03/2023 02:53, Luís Henriques wrote:
>>>>>>> xiubli@redhat.com writes:
>>>>>>>
>>>>>>>> From: Jeff Layton <jlayton@kernel.org>
>>>>>>>>
>>>>>>>> If we have a dentry which represents a no-key name, then we need to test
>>>>>>>> whether the parent directory's encryption key has since been added.  Do
>>>>>>>> that before we test anything else about the dentry.
>>>>>>>>
>>>>>>>> Reviewed-by: Xiubo Li <xiubli@redhat.com>
>>>>>>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>>>>>>> ---
>>>>>>>>      fs/ceph/dir.c | 8 ++++++--
>>>>>>>>      1 file changed, 6 insertions(+), 2 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>>>>>>>> index d3c2853bb0f1..5ead9f59e693 100644
>>>>>>>> --- a/fs/ceph/dir.c
>>>>>>>> +++ b/fs/ceph/dir.c
>>>>>>>> @@ -1770,6 +1770,10 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
>>>>>>>>      	struct inode *dir, *inode;
>>>>>>>>      	struct ceph_mds_client *mdsc;
>>>>>>>>      +	valid = fscrypt_d_revalidate(dentry, flags);
>>>>>>>> +	if (valid <= 0)
>>>>>>>> +		return valid;
>>>>>>>> +
>>>>>>> This patch has confused me in the past, and today I found myself
>>>>>>> scratching my head again looking at it.
>>>>>>>
>>>>>>> So, I've started seeing generic/123 test failing when running it with
>>>>>>> test_dummy_encryption.  I was almost sure that this test used to run fine
>>>>>>> before, but I couldn't find any evidence (somehow I lost my old testing
>>>>>>> logs...).
>>>>>>>
>>>>>>> Anyway, the test is quite simple:
>>>>>>>
>>>>>>> 1. Creates a directory with write permissions for root only
>>>>>>> 2. Writes into a file in that directory
>>>>>>> 3. Uses 'su' to try to modify that file as a different user, and
>>>>>>>        gets -EPERM
>>>>>>>
>>>>>>> All these steps run fine, and the test should pass.  *However*, in the
>>>>>>> test cleanup function, a simple 'rm -rf <dir>' will fail with -ENOTEMPTY.
>>>>>>> 'strace' shows that calling unlinkat() to remove the file got a '-ENOENT'
>>>>>>> and then -ENOTEMPTY for the directory.
>>>>>>>
>>>>>>> Some digging allowed me to figure out that running commands with 'su' will
>>>>>>> drop caches (I see 'su (874): drop_caches: 2' in the log).  And this is
>>>>>>> how I ended up looking at this patch.  fscrypt_d_revalidate() will return
>>>>>>> '0' if the parent directory does has a key (fscrypt_has_encryption_key()).
>>>>>>> Can we really say here that the dentry is *not* valid in that case?  Or
>>>>>>> should that '<= 0' be a '< 0'?
>>>>>>>
>>>>>>> (But again, this patch has confused me before...)
>>>>>> Luis,
>>>>>>
>>>>>> Could you reproduce it with the latest testing branch ?
>>>>> Yes, I'm seeing this with the latest code.
>>>> Okay. That's odd.
>>>>
>>>> BTW, are you using the non-root user to run the test ?
>>>>
>>>> Locally I am using the root user and still couldn't reproduce it.
>>> Yes, I'm running the tests as root but I've also 'fsgqa' user in the
>>> system (which is used by this test.  Anyway, for reference, here's what
>>> I'm using in my fstests configuration:
>>>
>>> TEST_FS_MOUNT_OPTS="-o name=admin,secret=<key>,copyfrom,ms_mode=crc,test_dummy_encryption"
>>> MOUNT_OPTIONS="-o name=admin,secret=<key>,copyfrom,ms_mode=crc,test_dummy_encryption"
>>>
>>>>>> I never seen the generic/123 failure yet. And just now I ran the test for many
>>>>>> times locally it worked fine.
>>>>> That's odd.  With 'test_dummy_encryption' mount option I can reproduce it
>>>>> every time.
>>>>>
>>>>>>    From the generic/123 test code it will never touch the key while testing, that
>>>>>> means the dentries under the test dir will always have the keyed name. And then
>>>>>> the 'fscrypt_d_revalidate()' should return 1 always.
>>>>>>
>>>>>> Only when we remove the key will it trigger evicting the inodes and then when we
>>>>>> add the key back will the 'fscrypt_d_revalidate()' return 0 by checking the
>>>>>> 'fscrypt_has_encryption_key()'.
>>>>>>
>>>>>> As I remembered we have one or more fixes about this those days, not sure
>>>>>> whether you were hitting those bugs we have already fixed ?
>>>>> Yeah, I remember now, and I guess there's yet another one here!
>>>>>
>>>>> I'll look closer into this and see if I can find out something else.  I'm
>>>>> definitely seeing 'fscrypt_d_revalidate()' returning 0, so probably the
>>>>> bug is in the error paths, when the 'fsgqa' user tries to write into the
>>>>> file.
>>>> Please add some debug logs in the code.
>>> I *think* I've something.  The problem seems to be that, after the
>>> drop_caches, the test directory is evicted and ceph_evict_inode() will
>>> call fscrypt_put_encryption_info().  This last function will clear the
>>> inode fscrypt info.  Later on, when the test tries to write to the file
>>> with:
>>>
>>>     _user_do "echo goo >> $my_test_subdir/data_coherency.txt"
>>>
>>> function ceph_atomic_open() will correctly identify that '$my_test_subdir'
>>> is encrypted, but the key isn't set because the inode was evicted.  This
>>> means that fscrypt_has_encryption_key() will return '0' and DCACHE_NOKEY_NAME
>>> will be *incorrectly* added to the 'data_coherency.txt' dentry flags.
>>>
>>> Later on, ceph_d_revalidate() will see the problem I initially described.
>>>
>>> The (RFC) patch bellow seems to fix the issue.  Basically, it will force
>>> the fscrypt info to be set in the directory by calling __fscrypt_prepare_readdir()
>>> and the fscrypt_has_encryption_key() will then return 'true'.
>> Interesting.
>>
>> It's worth to add one separated commit to fix this.
>>
>> Luis, could you send one patch to the mail list ? And please add the detail
>> comments in the code to explain it.
>>
>> This will help us to under stand the code and to debug potential similar bugs in
>> future.
> Sure, I'll do that.  In fact, I'll probably send out two patches as Jeff
> also suggested a better name for __fscrypt_prepare_readdir().  Not sure
> Eric will take it, but it's worth trying.
Sure. Thanks.
> Cheers,

