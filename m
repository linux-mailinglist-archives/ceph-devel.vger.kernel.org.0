Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027CF65B86C
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Jan 2023 01:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235275AbjACAgM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Jan 2023 19:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbjACAgJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 2 Jan 2023 19:36:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CD6637D
        for <ceph-devel@vger.kernel.org>; Mon,  2 Jan 2023 16:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672706120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hM961epS0QDYelv54QomDRQGneiyQTUvFYbwkk0LVqI=;
        b=SZw2/BLZ0y9/h4CaoYCuELPjA6TWBpI+V5OniqZt/0Ig1X39Ra+epudIQowZzqHFfz3Qbs
        NIwVLmiR+d6Afa42K9bj8Tk6gO4TQ0g1hrbGmwQYOhCqJ5xLwk8ni+HOzw2HQMUdjFoaHH
        CHUPYsb3lNpx7QFTDYZK96ZYgkLgfoA=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-219-QRXZQ254PVKygWtV1JLZ8A-1; Mon, 02 Jan 2023 19:35:19 -0500
X-MC-Unique: QRXZQ254PVKygWtV1JLZ8A-1
Received: by mail-pf1-f200.google.com with SMTP id x28-20020a056a000bdc00b005826732edb6so1788764pfu.22
        for <ceph-devel@vger.kernel.org>; Mon, 02 Jan 2023 16:35:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hM961epS0QDYelv54QomDRQGneiyQTUvFYbwkk0LVqI=;
        b=bYZykQTaR+Kxy0ynhNwM6WLwl3W2PF3YjTv6y8cuI6IOCx2D6qFkWAQ3tkXxfXICva
         KWkzlnCOBo2lOlh0841YS2gXWvk3U5sT0ipXmViGZH1DNbZ2MIS/1z8l7IQi93K4GK8Z
         RhhuCX2G+FvmmC1bfSM+chvNQiClswnU3E7HtMDg131HgNV4e6cmES07oHnIIFbCWDWF
         Zf/hJlrIAAQRLY5zhnYYrnHhN/kfx+o36dqfszVjgm++FwaS/wSI1iY7jBqn3erzMRbf
         b49zTFpifwO6zzcZQ0v5WUBhuegqMqJ8fx80eIrL6e8hSFPPyLTlUmhtji3ONJzdWufQ
         Zw1w==
X-Gm-Message-State: AFqh2krI8kutSvPb+PSDE+yWmdYr9IQCc+KdCqS3l7zDhXUrfNx5lAvX
        22vLqgJ5NbjZ5U8fomx6GikxUroz02P/6vkSh3Jtqng1Gz8AhhlRJSOfJ5DKFjZYLaMhcEU3ZcE
        4ONWORCFEA+HKS4vpqPCDQQ==
X-Received: by 2002:a05:6a21:6d9c:b0:b1:dac3:37b9 with SMTP id wl28-20020a056a216d9c00b000b1dac337b9mr66737358pzb.45.1672706118566;
        Mon, 02 Jan 2023 16:35:18 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt34ID3ilsl76gvpJ2MbHJDhVQg9RHTjR6sw3heFyyo65JAPCwOuqIy3s+HDQA484cOS8xSQQ==
X-Received: by 2002:a05:6a21:6d9c:b0:b1:dac3:37b9 with SMTP id wl28-20020a056a216d9c00b000b1dac337b9mr66737344pzb.45.1672706118339;
        Mon, 02 Jan 2023 16:35:18 -0800 (PST)
Received: from [10.72.12.16] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i27-20020aa796fb000000b00581a5fd4fa7sm9889961pfq.212.2023.01.02.16.35.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jan 2023 16:35:17 -0800 (PST)
Message-ID: <d4dfbe31-cef2-087b-0c7d-b484feeba097@redhat.com>
Date:   Tue, 3 Jan 2023 08:35:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v5 0/2] ceph: fix the use-after-free bug for file_lock
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     jlayton@kernel.org, ceph-devel@vger.kernel.org,
        mchangir@redhat.com, lhenriques@suse.de, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20221214033512.659913-1-xiubli@redhat.com>
 <CAOi1vP8v_ggvwA+FwctU-97a89KU-wrSPz0oMuNdMQU8gFeT7g@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP8v_ggvwA+FwctU-97a89KU-wrSPz0oMuNdMQU8gFeT7g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 02/01/2023 19:50, Ilya Dryomov wrote:
> On Wed, Dec 14, 2022 at 4:35 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Changed in V5:
>> - s/fl_inode/inode/
>>
>> Changed in V4:
>> - repeat the afs in fs.h instead of adding ceph specific header file
>>
>> Changed in V3:
>> - switched to vfs_inode_has_locks() helper to fix another ceph file lock
>> bug, thanks Jeff!
>> - this patch series is based on Jeff's previous VFS lock patch:
>>    https://patchwork.kernel.org/project/ceph-devel/list/?series=695950
>>
>> Changed in V2:
>> - switch to file_lock.fl_u to fix the race bug
>> - and the most code will be in the ceph layer
>>
>>
>> Xiubo Li (2):
>>    ceph: switch to vfs_inode_has_locks() to fix file lock bug
>>    ceph: add ceph specific member support for file_lock
>>
>>   fs/ceph/caps.c     |  2 +-
>>   fs/ceph/locks.c    | 24 ++++++++++++++++++------
>>   fs/ceph/super.h    |  1 -
>>   include/linux/fs.h |  3 +++
>>   4 files changed, 22 insertions(+), 8 deletions(-)
>>
>> --
>> 2.31.1
>>
> Hi Xiubo,
>
> I have adjusted the title of the second patch to actually reflect its
> purpose: "ceph: avoid use-after-free in ceph_fl_release_lock()".  With
> that:
>
> Reviewed-by: Ilya Dryomov <idryomov@gmail.com>

Hi Ilya,

Sure. Looks better.

I will revise it.

Thanks

- Xiubo


> Thanks,
>
>                  Ilya
>

