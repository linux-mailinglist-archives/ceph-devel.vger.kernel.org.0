Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E0F6055CA
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Oct 2022 05:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiJTDKM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Oct 2022 23:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbiJTDKI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Oct 2022 23:10:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6955C4E193
        for <ceph-devel@vger.kernel.org>; Wed, 19 Oct 2022 20:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666235403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rZC6+ToPTVw90Wnz576PIbBOGIevd9F/Dg3iNGIUqzY=;
        b=Cyrn/uJbQGhq5RIxIVE3A5nOQew04zWR53xWeF9teQoq+boEXF46BQxKhtp5vpt+ItxNs/
        jODqC9tIqPtcl6UspTDMNuyzIXzSS1SHhdsbITEG3M+owCRG/DHQOzmx/buun2K9ip86WL
        QkLcifMvEvM5AEmFicpDDYOHIN3vPfg=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-479-o0acD0ytPtuuSBtT8H4xgQ-1; Wed, 19 Oct 2022 21:29:39 -0400
X-MC-Unique: o0acD0ytPtuuSBtT8H4xgQ-1
Received: by mail-pl1-f199.google.com with SMTP id l16-20020a170902f69000b001865f863784so790328plg.2
        for <ceph-devel@vger.kernel.org>; Wed, 19 Oct 2022 18:29:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rZC6+ToPTVw90Wnz576PIbBOGIevd9F/Dg3iNGIUqzY=;
        b=Dpcjbpo9X3nyoZ6h0kYXx11RhFlXGa7hfut9fOwQUt3pxaw65PrnF/D1JDOOy0WPRB
         OBxPVvB3IklXB6xfhDNcoFGt497GSnwyqri9Pw3eIWSKjhq15gDZpq0BnEX/1FgAQqSP
         FqUMKOVpiZXge8fGzRYFxhBrbXdeLfu5dgP71chUic/S9gviONymuoKHyw7MuhAx5nho
         XvhzkYCt+DqsFfY3JA4YsyJFSNtGrQan6fLrj/U6R+4+q3vVc8NIENnA+/n4B7p5pMkX
         E3xHsHoTQh84rDRVxapl5Rg1a84t3b3EBvNaCGWN275HvrkD7kQQ/NuN4sPC+pG6d0fW
         pXZg==
X-Gm-Message-State: ACrzQf3WngUhlSAN7LrHGyOto+70PTBEZ+dBVZD7Jy6g+OQG9KiwB4QZ
        XboOT8iPucVbkAl/3pFskSICObGxmIlcYbD/4kidl4f5WVyH56f7Delz4fxuy/7Y8h5VtpoUk4H
        TeWTWYt15hH3BSDbvdCMl1w==
X-Received: by 2002:a17:90b:3912:b0:20d:4151:1b65 with SMTP id ob18-20020a17090b391200b0020d41511b65mr49381507pjb.233.1666229378604;
        Wed, 19 Oct 2022 18:29:38 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM50N30+f9apTD5DfIKQUIhu3CELsyaW6/XmNiGAQqCBy6DMFFkfGh7J/RwGOCfxUOD7q5ynug==
X-Received: by 2002:a17:90b:3912:b0:20d:4151:1b65 with SMTP id ob18-20020a17090b391200b0020d41511b65mr49381487pjb.233.1666229378246;
        Wed, 19 Oct 2022 18:29:38 -0700 (PDT)
Received: from [10.72.12.79] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s3-20020aa78bc3000000b0056323de479bsm11966507pfd.120.2022.10.19.18.29.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 18:29:37 -0700 (PDT)
Subject: Re: [PATCH] fs/ceph/super: add mount options "snapdir{mode,uid,gid}"
To:     Jeff Layton <jlayton@kernel.org>,
        Max Kellermann <max.kellermann@ionos.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220927120857.639461-1-max.kellermann@ionos.com>
 <88f8941f-82bf-5152-b49a-56cb2e465abb@redhat.com>
 <CAKPOu+88FT1SeFDhvnD_NC7aEJBxd=-T99w67mA-s4SXQXjQNw@mail.gmail.com>
 <75e7f676-8c85-af0a-97b2-43664f60c811@redhat.com>
 <CAKPOu+-rKOVsZ1T=1X-T-Y5Fe1MW2Fs9ixQh8rgq3S9shi8Thw@mail.gmail.com>
 <baf42d14-9bc8-93e1-3d75-7248f93afbd2@redhat.com>
 <cd5ed50a3c760f746a43f8d68fdbc69b01b89b39.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <7e28f7d1-cfd5-642a-dd4e-ab521885187c@redhat.com>
Date:   Thu, 20 Oct 2022 09:29:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <cd5ed50a3c760f746a43f8d68fdbc69b01b89b39.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/10/2022 18:45, Jeff Layton wrote:
> On Mon, 2022-10-10 at 10:02 +0800, Xiubo Li wrote:
>> On 09/10/2022 18:27, Max Kellermann wrote:
>>> On Sun, Oct 9, 2022 at 10:43 AM Xiubo Li <xiubli@redhat.com> wrote:
>>>> I mean CEPHFS CLIENT CAPABILITIES [1].
>>> I know that, but that's suitable for me. This is client-specific, not
>>> user (uid/gid) specific.
>>>
>>> In my use case, a server can run unprivileged user processes which
>>> should not be able create snapshots for their own home directory, and
>>> ideally they should not even be able to traverse into the ".snap"
>>> directory and access the snapshots created of their home directory.
>>> Other (non-superuser) system processes however should be able to
>>> manage snapshots. It should be possible to bind-mount snapshots into
>>> the user's mount namespace.
>>>
>>> All of that is possible with my patch, but impossible with your
>>> suggestion. The client-specific approach is all-or-nothing (unless I
>>> miss something vital).
>>>
>>>> The snapdir name is a different case.
>>> But this is only about the snapdir. The snapdir does not exist on the
>>> server, it is synthesized on the client (in the Linux kernel cephfs
>>> code).
>> This could be applied to it's parent dir instead as one metadata in mds
>> side and in client side it will be transfer to snapdir's metadata, just
>> like what the snapshots.
>>
>> But just ignore this approach.
>>
>>>> But your current approach will introduce issues when an UID/GID is reused after an user/groud is deleted ?
>>> The UID I would specify is one which exists on the client, for a
>>> dedicated system user whose purpose is to manage cephfs snapshots of
>>> all users. The UID is created when the machine is installed, and is
>>> never deleted.
>> This is an ideal use case IMO.
>>
>> I googled about reusing the UID/GID issues and found someone has hit a
>> similar issue in their use case.
>>
> This is always a danger and not just with ceph. The solution to that is
> good sysadmin practices (i.e. don't reuse uid/gid values without
> sanitizing the filesystems first).

Yeah, this sounds reasonable.

>>>> Maybe the proper approach is the posix acl. Then by default the .snap dir will inherit the permission from its parent and you can change it as you wish. This permission could be spread to all the other clients too ?
>>> No, that would be impractical and unreliable.
>>> Impractical because it would require me to walk the whole filesystem
>>> tree and let the kernel synthesize the snapdir inode for all
>>> directories and change its ACL;
>> No, it don't have to. This could work simply as the snaprealm hierarchy
>> thing in kceph.
>>
>> Only the up top directory need to record the ACL and all the descendants
>> will point and use it if they don't have their own ACLs.
>>
>>>    impractical because walking millions
>>> of directories takes longer than I am willing to wait.
>>> Unreliable because there would be race problems when another client
>>> (or even the local client) creates a new directory. Until my local
>>> "snapdir ACL daemon" learns about the existence of the new directory
>>> and is able to update its ACL, the user can already have messed with
>>> it.
>> For multiple clients case I think the cephfs capabilities [3] could
>> guarantee the consistency of this. While for the single client case if
>> before the user could update its ACL just after creating it someone else
>> has changed it or messed it up, then won't the existing ACLs have the
>> same issue ?
>>
>> [3] https://docs.ceph.com/en/quincy/cephfs/capabilities/
>>
>>
>>> Both of that is not a problem with my patch.
>>>
>> Jeff,
>>
>> Any idea ?
>>
> I tend to agree with Max here. The .snap dir is a client-side fiction,
> so trying to do something on the MDS to govern its use seems a bit odd.
> cephx is really about authenticating clients. I know we do things like
> enforce root squashing on the MDS, but this is a little different.
>
> Now, all of that said, snapshot handling is an area where I'm just not
> that knowledgeable. Feel free to ignore my opinion here as uninformed.

I am thinking currently the cephfs have the same issue we discussed 
here. Because the cephfs is saving the UID/GID number in the CInode 
metedata. While when there have multiple clients are sharing the same 
cephfs, so in different client nodes another user could cross access a 
specified user's files. For example:

In client nodeA:

user1's UID is 123, user2's UID is 321.

In client nodeB:

user1's UID is 321, user2's UID is 123.

And if user1 create a fileA in the client nodeA, then user2 could access 
it from client nodeB.

Doesn't this also sound more like a client-side fiction ?

- Xiubo


