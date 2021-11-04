Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC217444DAD
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Nov 2021 04:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhKDD1F (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Nov 2021 23:27:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20122 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229787AbhKDD1E (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Nov 2021 23:27:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635996267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yA3ctjjufn+taFfXu93e1AeYa7pUjGOXrfh8wgqeUk0=;
        b=Decg3DDy+8as/ElTBI16upZ/tcTfD0LgZsl8QLrJ2XFciz3DK8eUFMHFQzmuieBgHxKzUJ
        PHBLRmzxJs9ne+iMik0oZySsTzr6bkR2aB1gl+m8GL3PH+Oys2E9PpF/bJbEp5tgynvfTy
        wACG/jgD5Dg/j2t+3TSjCXIiBz8RiCw=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-HfFV8hPiPUS4T30xmrGIng-1; Wed, 03 Nov 2021 23:24:26 -0400
X-MC-Unique: HfFV8hPiPUS4T30xmrGIng-1
Received: by mail-pl1-f198.google.com with SMTP id h2-20020a170902f54200b001422a32c821so1050685plf.13
        for <ceph-devel@vger.kernel.org>; Wed, 03 Nov 2021 20:24:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=yA3ctjjufn+taFfXu93e1AeYa7pUjGOXrfh8wgqeUk0=;
        b=Vw7zC0lSWknMo8LEVGxNGWKZRupiMHC8CXtGSrNEPd2/+zFdKnXYXHiUBThtM15nx+
         7qZ2vFEximkIgW5suWNia7NcdnKuZfPdmQ4OVJvdPtAkaohmQBBmfpKe4rfLAlsgu15N
         8tDIDgP8+QeqbYv2bo8HQTKhwObO36VtLDQABq92CaCAJGjBXp0ia5EjvbuFjZTtrg3R
         miCpssvm55rjkQOgQHSlNAurVPqRNTm5ydhPJ7iJExCsNbT2AqQeKxzIDlJMFFfSfx1v
         aekMMOiZsYwufm1DPexXz8gWNCnhOkYk+dc92Vohtp7AoSxOMYnII2+ExKDsYaobg0FG
         F/yg==
X-Gm-Message-State: AOAM5309RrYg81paBNvZFeuYXojLHHb0Wb2AkoW/1ADcygnpKHA0S988
        c9TfvXlbdPaxFvYcGuHvrhMoTOTmHIwQpUF8ythmob+yS8j8Rr8p1jtKW7l7NTvppxh6ctw4cCT
        5Lah0gO2ZxeffA3Z23C1rIylSxs1ao553pOrohu2Ko2Eg9CqanjshYLXMyXRnTKQY5FzyNOc=
X-Received: by 2002:a17:90b:1bd1:: with SMTP id oa17mr6303992pjb.246.1635996263834;
        Wed, 03 Nov 2021 20:24:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDW/ENbh3X5B1luvua+oWTqkKI30VU6c8KE6dMDKagOzTpa+V7uYQUU6YmEjzSfRLMeFgScQ==
X-Received: by 2002:a17:90b:1bd1:: with SMTP id oa17mr6303917pjb.246.1635996263048;
        Wed, 03 Nov 2021 20:24:23 -0700 (PDT)
Received: from [10.72.12.174] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d7sm4077498pfj.91.2021.11.03.20.24.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 20:24:22 -0700 (PDT)
Subject: Re: [PATCH v5 0/8] ceph: size handling for the fscrypt
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211103012232.14488-1-xiubli@redhat.com>
 <cedf7aeb9bca77c0e31ceef0d3044f474674d0b6.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <0bbde05e-df0c-0431-6008-8eb47ba4f8ba@redhat.com>
Date:   Thu, 4 Nov 2021 11:24:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <cedf7aeb9bca77c0e31ceef0d3044f474674d0b6.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/3/21 8:56 PM, Jeff Layton wrote:
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
> Thanks Xiubo,
>
> This looks like a great start. I set up an environment vs. a cephadm
> cluster with your fscrypt changes, and started running xfstests against
> it with test_dummy_encryption enabled. It got to generic/014 and the
> test hung waiting on a SETATTR call to come back:
>
> [root@client1 f3cf8b7a-38ec-11ec-a0e4-52540031ba78.client74208]# cat mdsc
> 89447	mds0	setattr	 #1000003b19c
>
> Looking at the MDS that it was talking to, I see:
>
> Nov 03 08:25:09 cephadm2 ceph-mds[3133]: log_channel(cluster) log [WRN] : 1 slow requests, 1 included below; oldest blocked for > 31.627241 secs
> Nov 03 08:25:09 cephadm2 ceph-mds[3133]: log_channel(cluster) log [WRN] : slow request 31.627240 seconds old, received at 2021-11-03T12:24:37.911553+0000: client_request(client.74208:89447 setattr size=102498304 #0x1000003b19c 2021-11-03T12:24:37.895292+0000 caller_uid=0, caller_gid=0{0,}) currently acquired locks
> Nov 03 08:25:14 cephadm2 ceph-mds[3133]: log_channel(cluster) log [WRN] : 1 slow requests, 0 included below; oldest blocked for > 36.627323 secs
> Nov 03 08:25:19 cephadm2 ceph-mds[3133]: log_channel(cluster) log [WRN] : 1 slow requests, 0 included below; oldest blocked for > 41.627389 secs
>
> ...and it still hasn't resolved.
>
> I'll keep looking around a bit more, but I think there are still some
> bugs in here. Let me know if you have thoughts as to what the issue is.

 From MDS side log, it keeps retrying the truncate request:

2021-11-04T10:24:25.542+0800 149d48288700  1 -- 
v1:10.72.47.117:6814/424105754 <== osd.0 v1:10.72.47.117:6800/10035 
249354 ==== osd_op_reply(358495 10000000ed7.00000016 [read 92872704~8] 
v0'0 uv0 ondisk = -2 ((2) No such file or directory)) v8 ==== 164+0+0 
(unknown 4045992944 0 0) 0x55cd75169440 con 0x55cd7514dc00
2021-11-04T10:24:25.542+0800 149d46278700 10 MDSIOContextBase::complete: 
24C_IO_MDC_ReadtruncFinish
2021-11-04T10:24:25.542+0800 149d46278700 10 MDSContext::complete: 
24C_IO_MDC_ReadtruncFinish

It's a bug when hit a file hole. I will fix it soon.

Thanks.

BRs


> Thanks,

