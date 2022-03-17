Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024AF4DC5F4
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Mar 2022 13:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbiCQMqD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Mar 2022 08:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiCQMqC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Mar 2022 08:46:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4A42F7F5C
        for <ceph-devel@vger.kernel.org>; Thu, 17 Mar 2022 05:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647521084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qMMzKWFseA5pvZnvZFNeWATrNWxH9U0hOpDhOpSAHMA=;
        b=BeV4UdvHsaNXjLfUXTpgT/A3H4YoPsGb08PYrLkVJI9AMjRbbsgUjiiwszZ8TEJtJcuhXA
        dEXU2gNoj85L4fmih6bWyliWvBvUAV3SfwBDS0EivgWRgyML6PQjBxIzDgp1RCwpcyIK6v
        EMmrHG4++qS2pDJv5pkkPKRtJQorQOs=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-V_2RKDoxO12TUdIfWDxbFg-1; Thu, 17 Mar 2022 08:44:42 -0400
X-MC-Unique: V_2RKDoxO12TUdIfWDxbFg-1
Received: by mail-pg1-f197.google.com with SMTP id j15-20020a633c0f000000b00380ed7c5e91so1714811pga.6
        for <ceph-devel@vger.kernel.org>; Thu, 17 Mar 2022 05:44:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=qMMzKWFseA5pvZnvZFNeWATrNWxH9U0hOpDhOpSAHMA=;
        b=YbqFajj+ryxDBvgcaU+PbdzZKqEX8jSMMjV7QtRDa32aZmkx2GbthUn1bWkrK1b/+z
         D/laLLKPQ0YQy5/KGSInuE9QZCn9+Fv9KXrDuTgphoZpiG4FkvmATO0cN7ekJwA0lJr8
         hHNH8baTVFcq27JT3Bj5mF2exqWgtKcFKBUZk7gJItYraoC0KVOeWJYZ0kHk3YvR2FcI
         Qbcu6thXVfzVxDxFqgIUhNbVDtbwa6khskcwDu/VP+YG+7cv0KKM2StdYUHMFhu9zA9d
         pu2YWOg8zQTLy8BBzau1NlUyzOhHiQfdWoQSRFB/xAOXnDt/1XnKRjPKjz4IRx4CnwY1
         WmLQ==
X-Gm-Message-State: AOAM531vP00X9j4n/Yk4HcTcQZbetZYnSYQFn5UPV5+F1lpkhojnk65z
        1NPbsSBjpD7htioqoxSKnmv/69koJtd5bWz14XlnC5liQmrknbFe1fjdM0TmqI/Gy3yL+v6iauq
        yChh6IhtD2hCFgBisOcoWQQ==
X-Received: by 2002:a17:903:18b:b0:151:efb5:778 with SMTP id z11-20020a170903018b00b00151efb50778mr4910754plg.45.1647521081601;
        Thu, 17 Mar 2022 05:44:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIgTyejXrAySnL1Eq9BOZqMWOd0RvmJOndJCN1VReO/UPbivuId+iGemQGSvzVIZFxqWS8og==
X-Received: by 2002:a17:903:18b:b0:151:efb5:778 with SMTP id z11-20020a170903018b00b00151efb50778mr4910728plg.45.1647521081288;
        Thu, 17 Mar 2022 05:44:41 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o5-20020a655bc5000000b00372f7ecfcecsm5207974pgr.37.2022.03.17.05.44.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 05:44:40 -0700 (PDT)
Subject: Re: [RFC PATCH v2 0/3] ceph: add support for snapshot names
 encryption
To:     Jeff Layton <jlayton@kernel.org>,
        =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <20220315161959.19453-1-lhenriques@suse.de>
 <5b53e812-d49b-45f0-1219-3dbc96febbc1@redhat.com>
 <329abedd9d9938de95bf4f5600acdcd6a846e6be.camel@kernel.org>
 <3c8b78c4-5392-b81c-e76f-64fcce4f3c0f@redhat.com>
 <87wngshlzb.fsf@brahms.olymp>
 <c2f494b61674e63985e4e2a0fb3b6c503e17334b.camel@kernel.org>
 <a4d26edc-a65f-27e2-2ea9-ef43f364eb9b@redhat.com>
 <93ac97c750456fe77d33f432629bad209dc14e81.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <83db0781-2e9a-55e1-fb0b-ee0923f0b11a@redhat.com>
Date:   Thu, 17 Mar 2022 20:44:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <93ac97c750456fe77d33f432629bad209dc14e81.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/17/22 8:41 PM, Jeff Layton wrote:
> On Thu, 2022-03-17 at 20:31 +0800, Xiubo Li wrote:
>> On 3/17/22 8:01 PM, Jeff Layton wrote:
>>> On Thu, 2022-03-17 at 11:11 +0000, Luís Henriques wrote:
>>>> Xiubo Li <xiubli@redhat.com> writes:
>>>>
>>>>> On 3/17/22 6:01 PM, Jeff Layton wrote:
>>>>>> I'm not sure we want to worry about .snap directories here since they
>>>>>> aren't "real". IIRC, snaps are inherited from parents too, so you could
>>>>>> do something like
>>>>>>
>>>>>>        mkdir dir1
>>>>>>        mkdir dir1/.snap/snap1
>>>>>>        mkdir dir1/dir2
>>>>>>        fscrypt encrypt dir1/dir2
>>>>>>
>>>>>> There should be nothing to prevent encrypting dir2, but I'm pretty sure
>>>>>> dir2/.snap will not be empty at that point.
>>>>> If we don't take care of this. Then we don't know which snapshots should do
>>>>> encrypt/dencrypt and which shouldn't when building the path in lookup and when
>>>>> reading the snapdir ?
>>>> In my patchset (which I plan to send a new revision later today, I think I
>>>> still need to rebase it) this is handled by using the *real* snapshot
>>>> parent inode.  If we're decrypting/encrypting a name for a snapshot that
>>>> starts with a '_' character, we first find the parent inode for that
>>>> snapshot and only do the operation if that parent is encrypted.
>>>>
>>>> In the other email I suggested that we could prevent enabling encryption
>>>> in a directory when there are snapshots above in the hierarchy.  But now
>>>> that I think more about it, it won't solve any problem because you could
>>>> create those snapshots later and then you would still need to handle these
>>>> (non-encrypted) "_name_xxxx" snapshots anyway.
>>>>
>>> Yeah, that sounds about right.
>>>
>>> What happens if you don't have the snapshot parent's inode in cache?
>>> That can happen if you (e.g.) are running NFS over ceph, or if you get
>>> crafty with name_to_handle_at() and open_by_handle_at().
>>>
>>> Do we have to do a LOOKUPINO in that case or does the trace contain that
>>> info? If it doesn't then that could really suck in a big hierarchy if
>>> there are a lot of different snapshot parent inodes to hunt down.
>>>
>>> I think this is a case where the client just doesn't have complete
>>> control over the dentry name. It may be better to just not encrypt them
>>> if it's too ugly.
>>>
>>> Another idea might be to just use the same parent inode (maybe the
>>> root?) for all snapshot names. It's not as secure, but it's probably
>>> better than nothing.
>> Does it allow to have different keys for the subdirs in the hierarchy ?
>>   From my test it doesn't.
>>
> No. Once you set a key on directory you can't set another on a subtree
> of it.
If so. Yeah, I think your approach mentioned above is the best.
>> If so we can always use the same oldest ancestor in the hierarchy, who
>> has encryption key, to encyrpt/decrypt all the .snap in the hierarchy,
>> then just need to lookup oldest ancestor inode only once.
>>
Just like this.

-- Xiubo

> That's a possibility.

