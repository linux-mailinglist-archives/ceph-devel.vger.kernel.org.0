Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E139456805
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Nov 2021 03:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbhKSCXZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 18 Nov 2021 21:23:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:21311 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232771AbhKSCXY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 18 Nov 2021 21:23:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637288423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GrJ+PJGbRDBmV4WDxjf3OLirumGNqgbiq7ZeIxWKd+M=;
        b=hyZADFylxPpiMezHQ3g+b7W14wx6kX3QFcsvUwkQOyOZGe7lWzvoNSU5aS0tyulycqhBtV
        HPik0N/rTR1ayrqz8huxOcNEPM3guQIFCEf77WfjKpT1041xKBdBcyShxiObAXjIVpoC/d
        FRy16MW8ANG68YIJeNanw/bg38wnzig=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-129-LgOMp4_gNBqA7qYA8WuCBQ-1; Thu, 18 Nov 2021 21:20:20 -0500
X-MC-Unique: LgOMp4_gNBqA7qYA8WuCBQ-1
Received: by mail-pf1-f200.google.com with SMTP id w2-20020a627b02000000b0049fa951281fso4763720pfc.9
        for <ceph-devel@vger.kernel.org>; Thu, 18 Nov 2021 18:20:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=GrJ+PJGbRDBmV4WDxjf3OLirumGNqgbiq7ZeIxWKd+M=;
        b=l1ebdTczQ31mBc07E18Zkr3uX3hnxhwprKzeNO19O1Bg9+duaKv+KpQQRFlF4jMLE3
         1WMGpvjmlruFULF6rReKoaPcPCVNXQddpQ9eS9aN5K0XlhT5bwfiJYh0m+I5p7kB3bUo
         PFjNRkewcAN0W7BDTmyFk3o1I9be/rZUYH5H49eAWGkO3Wopj1P1t0ReXbVfNzmfg5IW
         g5FJWwYxsKcPACdcjfN/HnTH1hh5toQP7R6MfyFNYvHkoA1beRkVaFFDJnq+Au32aBhl
         tWP/G39DDkz48/pS8HBxe+TepOOP3bszR0AXiz0jEXPY4oQvx2sBbBThgq3dD42tftL5
         RnSg==
X-Gm-Message-State: AOAM530DOYKMJySaEb0clesZybuEA/WjbGPNMaXVpl5LRG5EPOMEgppQ
        fj49q6b7i+7z99cF9NDrB7VumaaOU/nogmRRX6Sfrw4uOE7UWiMMfiGK2aGX54a9nODSOHv8ohI
        XJSU/24nAwlIkNqqoqk/Qr5mYSdmcgYtbICcavL/v18/+0URNdje7+5Gy5NdAZT+oXZJ01v8=
X-Received: by 2002:a05:6a00:1c65:b0:49f:d8d0:c5d9 with SMTP id s37-20020a056a001c6500b0049fd8d0c5d9mr19284864pfw.72.1637288418930;
        Thu, 18 Nov 2021 18:20:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxFp9MYjbL3rD6zwGJkqCSBlfqrLTzCHDRPcV+l69bQJgbeWV5cfECpIFd4JH2w3gKzyOLqPg==
X-Received: by 2002:a05:6a00:1c65:b0:49f:d8d0:c5d9 with SMTP id s37-20020a056a001c6500b0049fd8d0c5d9mr19284827pfw.72.1637288418559;
        Thu, 18 Nov 2021 18:20:18 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f4sm920257pfj.61.2021.11.18.18.20.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 18:20:17 -0800 (PST)
Subject: Re: [PATCH] ceph: do not truncate pagecache if truncate size doesn't
 change
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
References: <20211116092002.99439-1-xiubli@redhat.com>
 <d37b49e0048ba3cf6763b83c82ad2fd8f8f36663.camel@kernel.org>
 <672440f9-e812-e97f-1c85-0343d7e8359e@redhat.com>
 <07f04cd3e3aeedf0d37db4acf4c7e8916c85f2b2.camel@kernel.org>
 <3eae0499-6ab3-4541-f26e-89b0f518ab46@redhat.com>
 <b7d901c7f1c660f2f1ec634e18d17988f0e348eb.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3133b10b-677f-cdde-5839-61a0e7bcbc39@redhat.com>
Date:   Fri, 19 Nov 2021 10:20:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <b7d901c7f1c660f2f1ec634e18d17988f0e348eb.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/18/21 8:19 PM, Jeff Layton wrote:
> On Thu, 2021-11-18 at 10:38 +0800, Xiubo Li wrote:
>> On 11/17/21 11:06 PM, Jeff Layton wrote:
>>> On Wed, 2021-11-17 at 09:21 +0800, Xiubo Li wrote:
[...]
>> Hi Jeff,
>>
>> I tested these two cases many times again today and both worked well for me.
>>
>> [root@lxbceph1 xfstests]# ./check generic/075
>> FSTYP         -- ceph
>> PLATFORM      -- Linux/x86_64 lxbceph1 5.15.0+
>> MKFS_OPTIONS  -- 10.72.7.17:40543:/testB
>> MOUNT_OPTIONS -- -o
>> test_dummy_encryption,name=admin,secret=AQDS3IFhEtxvORAAxn1d4FVN2bRUsc/TZMpQvQ==
>> -o context=system_u:object_r:root_t:s0 10.72.7.17:40543:/testB
>> /mnt/kcephfs/testD
>>
>> generic/075 106s ... 356s
>> Ran: generic/075
>> Passed all 1 tests
>>
>> [root@lxbceph1 xfstests]# ./check generic/029
>> FSTYP         -- ceph
>> PLATFORM      -- Linux/x86_64 lxbceph1 5.15.0+
>> MKFS_OPTIONS  -- 10.72.7.17:40543:/testB
>> MOUNT_OPTIONS -- -o
>> test_dummy_encryption,name=admin,secret=AQDS3IFhEtxvORAAxn1d4FVN2bRUsc/TZMpQvQ==
>> -o context=system_u:object_r:root_t:s0 10.72.7.17:40543:/testB
>> /mnt/kcephfs/testD
>>
>> generic/029 4s ... 3s
>> Ran: generic/029
>> Passed all 1 tests
>>
>>
>>> On the cluster-side, I'm using a cephadm cluster built using an image
>>> based on your fsize_support branch, rebased onto master (the Oct 7 base
>>> you're using is not good for cephadm).
>> I have updated this branch last night by rebasing it onto the latest
>> upstream master.
>>
>> And at the same time I have removed the commit:
>>
>>           bf39d32d936 mds: bump truncate seq when fscrypt_file changes
>>
>>> On the client side, I'm using the ceph-client/wip-fscrypt-size branch,
>>> along with this patch on top.
>> This I am also using the same branch from ceph-client repo. Nothing
>> changed in my side.
>>
>> To be safe I just deleted my local branches and synced from ceph-client
>> repo today and test them again, still the same and worked for me.
>>
> Ok, I think I see the problem. You sent this patch with just a [PATCH]
> prefix and there is no mention in the description that it's only
> intended to work on top of the other fscrypt changes, so I interpreted
> that to mean that this was a pre-existing bug and that this needed to go
> in ahead of those patches.
>
> That's not the case here. This patch does seem to work OK on top of the
> regular fscrypt series (but I did still see some failures in certain
> tests even with that). I'll look more closely at those today.
>
> It would probably have been clearer to send this patch along with the
> rest of the series to make that clear. Alternately, when you post a
> series and then find that it needs a follow-on patch, you can send it as
> if you're continuing the series:
>
>      [PATCH v7 10/9] ceph: do not truncate pagecache if truncate size doesn't change
>
> Ideally though, this change would be rolled into one of the other
> patches in your series.

Sure Jeff.

Sorry for confusing, since I am mainly working and testing the fscrypt 
related patches and I didn't make it clear where should this patch go.

In future, I will mention if we need to patch it on top of the fscrypt 
related branches and will do it as you mentioned above.

Thanks.

BRs

-- Xiubo


> Thanks,

