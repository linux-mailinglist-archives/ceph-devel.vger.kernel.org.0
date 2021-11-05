Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA02445D1C
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Nov 2021 01:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbhKEAxf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 Nov 2021 20:53:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59339 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230257AbhKEAxf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 Nov 2021 20:53:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636073455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=obPgCKfBZnJMx/e3Uxlyv0lu9pWFi6IgIY2FQZOeNCk=;
        b=XLrqYLS6nzo6uhZyP97MhXwldubx8G7gCR4CYRR8SFtP9vQPlJAx4grQUg708SZslVvulz
        qmxm15RA1lucB4zvfUntqANcC4LiechI+R6oBaagjtHXR1IqEYw5HU8sniHSet/tb2+Kmc
        frRMiIxseANmIJV3y2X+ODjXaFPLcbE=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-iuXFyZhlPk6eGbbULfreJw-1; Thu, 04 Nov 2021 20:50:54 -0400
X-MC-Unique: iuXFyZhlPk6eGbbULfreJw-1
Received: by mail-pf1-f197.google.com with SMTP id 184-20020a6217c1000000b0049f9aad0040so251386pfx.21
        for <ceph-devel@vger.kernel.org>; Thu, 04 Nov 2021 17:50:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=obPgCKfBZnJMx/e3Uxlyv0lu9pWFi6IgIY2FQZOeNCk=;
        b=49SyctJZoRSMOM6wTL6zUXpSnV1Dj85dnDt/0Ahs2NiyZC6YryeJyjichnXG0d4pot
         aHZLiLfHX948VoHMMSQze/eUH0eZX89fC5ppOcLAlnFSJJjpM8TpJbK4oPtlEFjPNWxM
         XUtA14Jiyi54AS22xV14IDEgKQMWmFESS8H4yA6CKOAn6IhX4t56xrNBpy55hNdgI3kX
         OyxmA9orF0DSeIdZShIxdbdZ/8keVk3neIJ1kFphbKgyRC7TbBYbenucH9aJWNdqnVhc
         gbO5QOnHAXv8Qg+jcDB+VRiuZ+JX/2PeRNQqnZHA4mzvGGmUZmCGTvXayelnXho3Ds8m
         i/iA==
X-Gm-Message-State: AOAM531fZYU1mY63jEyVPixGbpp0hLXn/iOfUISpYirEAnMsb3fDW8bo
        FSXmEE/Qygz2nWoK/aa7ZynZS6MsYvhhIZq71YNnB1eS4t+jVis2UymMRumPL/blZxzwwA/iZ0P
        A2zpxbHT11LXgIf/xuspW9hyJPs+dR4SUmtovJW34DuOESu0lgB1TIrENY9Jn9iuer0B8mnA=
X-Received: by 2002:a63:1453:: with SMTP id 19mr28758707pgu.201.1636073453108;
        Thu, 04 Nov 2021 17:50:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyM/yCkbNJ7jLf6Ne6vcdfZPRo4/Vrg8EzHnxKI0OZIJ1zPUmBT39/2Ena2F0txa/hu8LX0mA==
X-Received: by 2002:a63:1453:: with SMTP id 19mr28758682pgu.201.1636073452811;
        Thu, 04 Nov 2021 17:50:52 -0700 (PDT)
Received: from [10.72.12.174] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y9sm4836670pjj.6.2021.11.04.17.50.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 17:50:52 -0700 (PDT)
Subject: Re: [PATCH v5 0/8] ceph: size handling for the fscrypt
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211103012232.14488-1-xiubli@redhat.com>
 <f4b219eb57b373f99b755c6398be6e6c9562deee.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <ea27cc27-77f1-d09a-3bfd-33db3034dfe5@redhat.com>
Date:   Fri, 5 Nov 2021 08:50:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <f4b219eb57b373f99b755c6398be6e6c9562deee.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/5/21 8:13 AM, Jeff Layton wrote:
> On Wed, 2021-11-03 at 09:22 +0800, xiubli@redhat.com wrote:
>> From: Jeff Layton <jlayton@kernel.org>
>>
>> This patch series is based on the "wip-fscrypt-fnames" branch in
>> repo https://github.com/ceph/ceph-client.git.
>>
>> And I have picked up 5 patches from the "ceph-fscrypt-size-experimental"
>> branch in repo
>> https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git.
>>
>> ====
>>
>> This approach is based on the discussion from V1 and V2, which will
>> pass the encrypted last block contents to MDS along with the truncate
>> request.
>>
>> This will send the encrypted last block contents to MDS along with
>> the truncate request when truncating to a smaller size and at the
>> same time new size does not align to BLOCK SIZE.
>>
>> The MDS side patch is raised in PR
>> https://github.com/ceph/ceph/pull/43588, which is also based Jeff's
>> previous great work in PR https://github.com/ceph/ceph/pull/41284.
>>
>> The MDS will use the filer.write_trunc(), which could update and
>> truncate the file in one shot, instead of filer.truncate().
>>
>> This just assume kclient won't support the inline data feature, which
>> will be remove soon, more detail please see:
>> https://tracker.ceph.com/issues/52916
>>
>> Changed in V5:
>> - Rebase to "wip-fscrypt-fnames" branch in ceph-client.git repo.
>> - Pick up 5 patches from Jeff's "ceph-fscrypt-size-experimental" branch
>>    in linux.git repo.
>> - Add "i_truncate_pagecache_size" member support in ceph_inode_info
>>    struct, this will be used to truncate the pagecache only in kclient
>>    side, because the "i_truncate_size" will always be aligned to BLOCK
>>    SIZE. In fscrypt case we need to use the real size to truncate the
>>    pagecache.
>>
>>
>> Changed in V4:
>> - Retry the truncate request by 20 times before fail it with -EAGAIN.
>> - Remove the "fill_last_block" label and move the code to else branch.
>> - Remove the #3 patch, which has already been sent out separately, in
>>    V3 series.
>> - Improve some comments in the code.
>>
>> Changed in V3:
>> - Fix possibly corrupting the file just before the MDS acquires the
>>    xlock for FILE lock, another client has updated it.
>> - Flush the pagecache buffer before reading the last block for the
>>    when filling the truncate request.
>> - Some other minore fixes.
>>
>>
>>
>> Jeff Layton (5):
>>    libceph: add CEPH_OSD_OP_ASSERT_VER support
>>    ceph: size handling for encrypted inodes in cap updates
>>    ceph: fscrypt_file field handling in MClientRequest messages
>>    ceph: get file size from fscrypt_file when present in inode traces
>>    ceph: handle fscrypt fields in cap messages from MDS
>>
>> Xiubo Li (3):
>>    ceph: add __ceph_get_caps helper support
>>    ceph: add __ceph_sync_read helper support
>>    ceph: add truncate size handling support for fscrypt
>>
>>   fs/ceph/caps.c                  | 136 ++++++++++++++----
>>   fs/ceph/crypto.h                |   4 +
>>   fs/ceph/dir.c                   |   3 +
>>   fs/ceph/file.c                  |  43 ++++--
>>   fs/ceph/inode.c                 | 236 +++++++++++++++++++++++++++++---
>>   fs/ceph/mds_client.c            |   9 +-
>>   fs/ceph/mds_client.h            |   2 +
>>   fs/ceph/super.h                 |  10 ++
>>   include/linux/ceph/crypto.h     |  28 ++++
>>   include/linux/ceph/osd_client.h |   6 +-
>>   include/linux/ceph/rados.h      |   4 +
>>   net/ceph/osd_client.c           |   5 +
>>   12 files changed, 427 insertions(+), 59 deletions(-)
>>   create mode 100644 include/linux/ceph/crypto.h
>>
> Nice work, Xiubo. This looks good.
>
> I've been testing it some today and it seems to work fine so far.

Cool.


>   I've
> got a bit more testing that I want to do tomorrow,

At the same time I will test more.


> but this should
> hopefully clear the way for us to finish the content encryption piece!
Yeah, the experimental branch for the content encryption is not working 
well as the fname branch does, we may need more review and testing about it.

BRs

Xiubo

> Many thanks!

