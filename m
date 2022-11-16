Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822F162BF5D
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Nov 2022 14:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiKPNZu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Nov 2022 08:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiKPNZt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Nov 2022 08:25:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C395B1C8
        for <ceph-devel@vger.kernel.org>; Wed, 16 Nov 2022 05:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668605100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8S4EX8JSuHau3vosqwen6Gy2O68FW4U6Q1nvqa3SKhg=;
        b=I0fthn+bmZFl370b//4uRMRttdP1TneehuokoygMIiNiaAbzsjwLZTu3Md3B91DS2qKMr8
        jU0ec1ZMt/c1ZZ10s2Bl9E+DJGu7j4gNtufelewJyvat+FjBbaKxACXIaNEBdLJ4b0f4wv
        /W2q4JQhNbAWmyUwjsjutMo59arAOjM=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-261-w3xfR8fbMbO4TSB_KGvPzw-1; Wed, 16 Nov 2022 08:24:59 -0500
X-MC-Unique: w3xfR8fbMbO4TSB_KGvPzw-1
Received: by mail-pj1-f69.google.com with SMTP id my9-20020a17090b4c8900b002130d29fd7cso1738613pjb.7
        for <ceph-devel@vger.kernel.org>; Wed, 16 Nov 2022 05:24:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8S4EX8JSuHau3vosqwen6Gy2O68FW4U6Q1nvqa3SKhg=;
        b=nQqP/+rUHF4uDYqI/625FS+p3dB38FznG/27KeMTYNNQp6gvwLdmx9eMBh0iiqBj3s
         NlLpiCrPOW+7shUmCT84F27zDPJf/O5vQQBy39I4ognqkFYUnJDNpn/GrG67JNk5R3ID
         Fb+25kF8pdMuRW5+Ji9rwH/U1nCna9zwqMzKFLMJiXgHWYBvikEzksiI0nZd82kTKnxu
         eKk3CuRG7t6x06dIDEn+bXeqNPH0ZgpkKqY6nakTxBa3tTgzyM8u0XD5gMCbahRneE2S
         +Py6lw0MPBz3xz/MJLPwAl39fs5KkfWkHuIyPN3iZVBUTn12In491tA5WxSfx2G+Top4
         fypg==
X-Gm-Message-State: ANoB5pltBCDbvEpIiWsziQ6j6mmwIY86AU6QttLIaoFrpcpqx8r6e419
        zcfbAQSyHeBlBWO6OIN04kkYPP/zFNdXKYDHJaZOJxXu3f3ahWdZ0wwlb1JEY5xWEeEUYdke+4y
        B3kLYKTSTXCHYcwqiHDtw0Q==
X-Received: by 2002:a17:902:d2cf:b0:17f:9538:e1f4 with SMTP id n15-20020a170902d2cf00b0017f9538e1f4mr9103973plc.89.1668605097959;
        Wed, 16 Nov 2022 05:24:57 -0800 (PST)
X-Google-Smtp-Source: AA0mqf745cFec8wpDNmFncNCgYqon78RSFcFa72Si1DQJ6l3xs9qJzHPVIimMgAHLRvz80fX8TXDIQ==
X-Received: by 2002:a17:902:d2cf:b0:17f:9538:e1f4 with SMTP id n15-20020a170902d2cf00b0017f9538e1f4mr9103947plc.89.1668605097604;
        Wed, 16 Nov 2022 05:24:57 -0800 (PST)
Received: from [10.72.12.148] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k4-20020a170902c40400b00186a68ec086sm12234562plk.193.2022.11.16.05.24.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 05:24:57 -0800 (PST)
Subject: Re: [RFC PATCH] filelock: new helper: vfs_file_has_locks
To:     Jeff Layton <jlayton@kernel.org>, chuck.lever@oracle.com
Cc:     linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
References: <20221114140747.134928-1-jlayton@kernel.org>
 <30355bc8aa4998cb48b34df958837a8f818ceeb0.camel@kernel.org>
 <54b90281-c575-5aee-e886-e4d7b50236f0@redhat.com>
 <4a8720c8a24a9b06adc40fdada9c621fd5d849df.camel@kernel.org>
 <a8c94ba5-c01f-3bb6-0b35-2aee06b9d6e7@redhat.com>
 <969b751761988e75b11a75b1f44171305019711a.camel@kernel.org>
 <4fac935b-8e33-2202-48c2-80bdfddc074e@redhat.com>
 <76c783969445db694a18a35b51fc886c4efe5fb6.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c8439de2-accc-04c0-a664-9193579e4bbb@redhat.com>
Date:   Wed, 16 Nov 2022 21:24:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <76c783969445db694a18a35b51fc886c4efe5fb6.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 16/11/2022 19:25, Jeff Layton wrote:
> On Wed, 2022-11-16 at 19:16 +0800, Xiubo Li wrote:
>> On 16/11/2022 18:55, Jeff Layton wrote:
>>> On Wed, 2022-11-16 at 14:49 +0800, Xiubo Li wrote:
>>>> On 15/11/2022 22:40, Jeff Layton wrote:
>>>>
>> ...
>>>>> +	spin_lock(&ctx->flc_lock);
>>>>> +	ret = !list_empty(&ctx->flc_posix) || !list_empty(&ctx->flc_flock);
>>>>> +	spin_unlock(&ctx->flc_lock);
>>>> BTW, is the spin_lock/spin_unlock here really needed ?
>>>>
>>> We could probably achieve the same effect with barriers, but I doubt
>>> it's worth it. The flc_lock only protects the lists in the
>>> file_lock_context, so it should almost always be uncontended.
>>>
>> I just see some other places where are also checking this don't use the
>> spin lock.
>>
>>
> True.
>
> There are a number of places that don't and that use list_empty_careful.
> Some of those  We could convert to that here, but again, I'm not sure
> it's worth it. Let's stick with using the spinlocks here, since this
> isn't a performance-critical codepath anyway.
>
Okay.

Thanks!


>>>>> +	return ret;
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(vfs_inode_has_locks);
>>>>> +
>>>>>     #ifdef CONFIG_PROC_FS
>>>>>     #include <linux/proc_fs.h>
>>>>>     #include <linux/seq_file.h>
>>>>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>>>>> index e654435f1651..d6cb42b7e91c 100644
>>>>> --- a/include/linux/fs.h
>>>>> +++ b/include/linux/fs.h
>>>>> @@ -1170,6 +1170,7 @@ extern int locks_delete_block(struct file_lock *);
>>>>>     extern int vfs_test_lock(struct file *, struct file_lock *);
>>>>>     extern int vfs_lock_file(struct file *, unsigned int, struct file_lock *, struct file_lock *);
>>>>>     extern int vfs_cancel_lock(struct file *filp, struct file_lock *fl);
>>>>> +bool vfs_inode_has_locks(struct inode *inode);
>>>>>     extern int locks_lock_inode_wait(struct inode *inode, struct file_lock *fl);
>>>>>     extern int __break_lease(struct inode *inode, unsigned int flags, unsigned int type);
>>>>>     extern void lease_get_mtime(struct inode *, struct timespec64 *time);
>>>> All the others LGTM.
>>>>
>>>> Thanks.
>>>>
>>>> - Xiubo
>>>>
>>>>
>>> Thanks. I'll re-post it "officially" in a bit and will queue it up for
>>> v6.2.

