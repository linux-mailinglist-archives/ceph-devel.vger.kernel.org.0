Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8C1606C9D
	for <lists+ceph-devel@lfdr.de>; Fri, 21 Oct 2022 02:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiJUArm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Oct 2022 20:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiJUArT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 20 Oct 2022 20:47:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D7322BC92
        for <ceph-devel@vger.kernel.org>; Thu, 20 Oct 2022 17:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666313234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7i3Q+7eBNqgwe8myvD4IZGSdBbgBR1napgG+yyVui4s=;
        b=M/nFneelC/MxWrBX8RTnCpZ/ABww8wdqRiuVgLC6ahcfa+Gvk0eVR2G4Pp8d37LOmR3lEe
        94+Q5TjoeUDpRA7hXjEOC7u+JnrBDmYv45ApI9YifP7eAzqzleQcwDCtwZHim8n0kIH+9U
        Sa7PExplKSJydlb12JtDAtq0a6RZX8w=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-59-7XdXHrOpNL-pNSyFmmIZTw-1; Thu, 20 Oct 2022 20:47:13 -0400
X-MC-Unique: 7XdXHrOpNL-pNSyFmmIZTw-1
Received: by mail-pl1-f200.google.com with SMTP id u9-20020a17090341c900b0017f8514cf61so565607ple.16
        for <ceph-devel@vger.kernel.org>; Thu, 20 Oct 2022 17:47:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7i3Q+7eBNqgwe8myvD4IZGSdBbgBR1napgG+yyVui4s=;
        b=KELKmjaXoNWtsvuNZssVj6GiHs+lhdUlv4d7QKR7XI9NqOX37sOZIniAMJEF4X2FfR
         ZpoK7A3tb/egdfs27KSIUBOf4ngtYYdQhUw0UWFJOVytSMwjych8TwOkaS1++pfAi18O
         U+D8c+z65RIj00p7PrpybnyowCQr0+rKjazBGMe8SMeEN4B9ZVF1LZbcEzBIatPflp20
         wz51LSawgqb6tdeseQoKYDLAh2hK2frR9vZfAa85MKBdV7IcZVnecTGq7k1Gk6qKu587
         93GYuMX4zQsDtM33dWi20y3gicWuApMQvTesY0IjnT2ccau7MWcvW/KBZYFECef+8YYe
         sqVw==
X-Gm-Message-State: ACrzQf3EzF5mSSIFsheyXaRSAYmgrbAspk8EhysTbpXlfasQjhW0RRG0
        JvUCy9FU8fKPPXIHyrX1paSIwkrcwFNby8jH7+FgI4bxSU4shREYTqDQySRqw5OMizsf34GfT9m
        gIagP/6PrJ3V35eWw5BejGQ==
X-Received: by 2002:a63:1508:0:b0:438:eb90:52d1 with SMTP id v8-20020a631508000000b00438eb9052d1mr14302558pgl.252.1666313232260;
        Thu, 20 Oct 2022 17:47:12 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7ihx6oelkUj2fNnsybV62HX8C9tylG/r9sJ0yaY1ucUTSardkqfdcxvqqFijnkv6ecpG4ehA==
X-Received: by 2002:a63:1508:0:b0:438:eb90:52d1 with SMTP id v8-20020a631508000000b00438eb9052d1mr14302539pgl.252.1666313232011;
        Thu, 20 Oct 2022 17:47:12 -0700 (PDT)
Received: from [10.72.12.79] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n11-20020a170903404b00b0017849a2b56asm3547414pla.46.2022.10.20.17.47.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 17:47:11 -0700 (PDT)
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
 <7e28f7d1-cfd5-642a-dd4e-ab521885187c@redhat.com>
 <8ef79208adc82b546cc4c2ba20b5c6ddbc3a2732.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c94ed0d3-a01e-0414-8b0f-827d250b2eef@redhat.com>
Date:   Fri, 21 Oct 2022 08:47:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <8ef79208adc82b546cc4c2ba20b5c6ddbc3a2732.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 20/10/2022 18:13, Jeff Layton wrote:
> On Thu, 2022-10-20 at 09:29 +0800, Xiubo Li wrote:
[...]
>>> I tend to agree with Max here. The .snap dir is a client-side fiction,
>>> so trying to do something on the MDS to govern its use seems a bit odd.
>>> cephx is really about authenticating clients. I know we do things like
>>> enforce root squashing on the MDS, but this is a little different.
>>>
>>> Now, all of that said, snapshot handling is an area where I'm just not
>>> that knowledgeable. Feel free to ignore my opinion here as uninformed.
>> I am thinking currently the cephfs have the same issue we discussed
>> here. Because the cephfs is saving the UID/GID number in the CInode
>> metedata. While when there have multiple clients are sharing the same
>> cephfs, so in different client nodes another user could cross access a
>> specified user's files. For example:
>>
>> In client nodeA:
>>
>> user1's UID is 123, user2's UID is 321.
>>
>> In client nodeB:
>>
>> user1's UID is 321, user2's UID is 123.
>>
>> And if user1 create a fileA in the client nodeA, then user2 could access
>> it from client nodeB.
>>
>> Doesn't this also sound more like a client-side fiction ?
>>
> idmapping is a difficult issue and not at all confined to CephFS. NFSv4
> has a whole upcall facility for mapping IDs, for instance. The MDS has
> no way to know that 123 and 321 are the same user on different machines.
> That sort of mapping must be set up by the administrator.
>
> The real question is: Does it make sense for the MDS to use directory
> permissions to enforce access on something that isn't really a
> directory?
>
> My "gut feeling" here is that the MDS ought to be in charge of governing
> which _clients_ are allowed to make snapshots, but it's up to the client
> to determine which _users_ are allowed to create them. With that concept
> in mind, Max's proposal makes some sense.
>
> Snapshots are not part of POSIX, and the ".snap" directory interface was
> copied from Netapp (AFAICT). Maybe CephFS ought to enforce permissions
> on snapshots the same way Netapps do? I don't know exactly how it works
> there, so some research may be required.
>
> I found this article but it's behind a paywall:
>
>      https://kb.netapp.com/Advice_and_Troubleshooting/Data_Storage_Software/ONTAP_OS_7_Mode/How_to_control_access_to_a_Snapshot_directory
>
Yeah, these days I thought about this more. I will review this patch.

BTW, as we discussed in IRC to switch this to module parameters instead. 
Then how about when the mounts are in different namespace groups, such 
as the containers ? This couldn't be control that precise, maybe we will 
hit the same idmapping issue as I mentioned above ?

So maybe the mount option approach is the best choice here as Max does ?

- Xiubo

