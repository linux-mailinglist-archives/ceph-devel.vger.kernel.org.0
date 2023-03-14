Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8531E6B871D
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Mar 2023 01:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjCNAlt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Mar 2023 20:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjCNAlr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 Mar 2023 20:41:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27700911D6
        for <ceph-devel@vger.kernel.org>; Mon, 13 Mar 2023 17:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678754339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TACuEVUrpVGXTKr6EQlyJHtwWOffnTkzlOP52YnEJ9Q=;
        b=O8Eon15FzDtIu+G35t9ULCn118DiZKOW1PO9bm+ydFC07Vx5Gm9A4+6ABMrfMWmzIbh5R/
        ZU3dX6YacaP7OYegUnxPzDUD5MCRfVMhkBviaplQYYSo3OpLkJHx2lcXmJUtdvep/Cjvhv
        fOWRDie1yOfDfpB13opqGJ7SoWos5aw=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-iaIDFzuJMpSsBJQpcNQZ8Q-1; Mon, 13 Mar 2023 20:38:57 -0400
X-MC-Unique: iaIDFzuJMpSsBJQpcNQZ8Q-1
Received: by mail-pf1-f197.google.com with SMTP id a10-20020a056a000c8a00b005fc6b117942so7443806pfv.2
        for <ceph-devel@vger.kernel.org>; Mon, 13 Mar 2023 17:38:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678754336;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TACuEVUrpVGXTKr6EQlyJHtwWOffnTkzlOP52YnEJ9Q=;
        b=SpDju8crndz91UPLt3pqiDKW/Rirzs+UIGA27l9cvLcwIFjb6XwCobmRb3bA9GWNsV
         5IjSj8eYU3OVKo9aJ5dYO2HJjIHSa4+ZEsdxfNYJftBiQMTXDQ2eESTSbgEUJA6nd0I4
         onvn/VRNE05IEzPbL7XNfJ0zSiskX9SasTsGeAHUWp/Z2SBj45uwdZf9C92xDvOu+CoU
         nF6RZOzhXOGAGrmNlaxisb35eCE1+SpJfHV4MVLUMG3Atfp/YddHKgP1juqLJP1IBWZY
         VYChUlpkN4WRQfWf5i9+oz8im1M9Jp+a4PnQHKBPFpwrd9QXousZcIGnDlT3IGvJER/5
         95uw==
X-Gm-Message-State: AO0yUKWqQCiE5dUWswLRGLP3AlVWwaPi6OHhEugQ7kb3iyh8mjHr+NDz
        F1USPU8vJAZnM1SxohmnlkP2JxmKU2DuJxSm/95HZ/0eut3DzTKUz6dXePczPBYJyX3ChFaYC8E
        QFm7SSRgGLOimGOj6wo2ujp8PZJ0Qkfaf
X-Received: by 2002:a05:6a20:258c:b0:cc:24de:4d6d with SMTP id k12-20020a056a20258c00b000cc24de4d6dmr36702646pzd.4.1678754336407;
        Mon, 13 Mar 2023 17:38:56 -0700 (PDT)
X-Google-Smtp-Source: AK7set9K+B8tzulqAPV8mv2hXEb5R62MQmg30WDjLsaks6kCiaul6YikY8Z+atOv0CNqRJUSEzKycQ==
X-Received: by 2002:a05:6a20:258c:b0:cc:24de:4d6d with SMTP id k12-20020a056a20258c00b000cc24de4d6dmr36702628pzd.4.1678754336077;
        Mon, 13 Mar 2023 17:38:56 -0700 (PDT)
Received: from [10.72.12.147] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s14-20020a65644e000000b0050362744b63sm285320pgv.90.2023.03.13.17.38.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 17:38:55 -0700 (PDT)
Message-ID: <8aa61954-b6c4-d9b5-bb81-c03ca3631e3b@redhat.com>
Date:   Tue, 14 Mar 2023 08:38:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 2/2] ceph: switch atomic open to use new fscrypt helper
Content-Language: en-US
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Jeff Layton <jlayton@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230313123310.13040-1-lhenriques@suse.de>
 <20230313123310.13040-3-lhenriques@suse.de>
 <ZA9nPXNpBX0U5joC@sol.localdomain> <87cz5cv6h2.fsf@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <87cz5cv6h2.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 14/03/2023 02:42, Luís Henriques wrote:
> Eric Biggers <ebiggers@kernel.org> writes:
>
>> On Mon, Mar 13, 2023 at 12:33:10PM +0000, Luís Henriques wrote:
>>> Switch ceph atomic open to use fscrypt_prepare_atomic_open().  This fixes
>>> a bug where a dentry is incorrectly set with DCACHE_NOKEY_NAME when 'dir'
>>> has been evicted but the key is still available (for example, where there's
>>> a drop_caches).
>>>
>>> Signed-off-by: Luís Henriques <lhenriques@suse.de>
>>> ---
>>>   fs/ceph/file.c | 8 +++-----
>>>   1 file changed, 3 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>> index dee3b445f415..5ad57cc4c13b 100644
>>> --- a/fs/ceph/file.c
>>> +++ b/fs/ceph/file.c
>>> @@ -795,11 +795,9 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>>>   	ihold(dir);
>>>   	if (IS_ENCRYPTED(dir)) {
>>>   		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
>>> -		if (!fscrypt_has_encryption_key(dir)) {
>>> -			spin_lock(&dentry->d_lock);
>>> -			dentry->d_flags |= DCACHE_NOKEY_NAME;
>>> -			spin_unlock(&dentry->d_lock);
>>> -		}
>>> +		err = fscrypt_prepare_atomic_open(dir, dentry);
>>> +		if (err)
>>> +			goto out_req;
>> Note that this patch does not apply to upstream or even to linux-next.
> True, I should have mentioned that in the cover-letter.  This patch should
> be applied against the 'testing' branch in https://github.com/ceph/ceph-client,
> which is where the ceph fscrypt currently lives.
>
>> I'd be glad to take patch 1 through the fscrypt tree for 6.4.  But I'm wondering
>> what the current plans are for getting ceph's fscrypt support upstream?
> As far as I know, the current plan is to try to merge the ceph code during
> the next merge window for 6.4 (but Xiubo and Ilya may correct me if I'm
> wrong).  Also, regarding who picks which patch, I'm fine with you picking
> the first one.  But I'll let the ceph maintainers say what they think,
> because it may be easier for them to keep both patches together due to the
> testing infrastructure being used.
>
> Anyway, I'll send out a new rev tomorrow taking your comments into
> account.  Thanks, Eric!

Eric, Luis,

It will be fine if Eric could merge patch 1 into the fscrypt tree. Then 
I will merge the patch 1 into the ceph-client's testing by tagging as 
[DO NOT MERGE] to run our tests.

And locally we are still running the test, and there have several fixes 
followed and need more time to review.

Thanks

- Xiubo

> Cheers,

-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

