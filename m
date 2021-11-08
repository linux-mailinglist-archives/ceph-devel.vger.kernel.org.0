Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B6A4481FE
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Nov 2021 15:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239693AbhKHOoe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Nov 2021 09:44:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25738 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236869AbhKHOo3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 Nov 2021 09:44:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636382505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K+ZvgG5MM16eoC/17jusYNQD+qUdRQv9eyvefMtcwa0=;
        b=Fc5O07DaAmII0pDI4bqxR92IIjjiCLFiAfg4PO9Ff065cwfEzyHK0o+MC82I/eSrG0yWqY
        XqvVyrRmm4+/MAzBjNQ5i0+sX9IcNciS1ymyHd30MbQ/E4VFGUxNAd2kAdaI7dSV5T1gEb
        xfjtZzTqGWZM3PV+CUeICDbpVt0Ojbo=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-H0emywj5PLa1F2cXj2NPcw-1; Mon, 08 Nov 2021 09:41:44 -0500
X-MC-Unique: H0emywj5PLa1F2cXj2NPcw-1
Received: by mail-pg1-f200.google.com with SMTP id w5-20020a654105000000b002692534afceso10147936pgp.8
        for <ceph-devel@vger.kernel.org>; Mon, 08 Nov 2021 06:41:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=K+ZvgG5MM16eoC/17jusYNQD+qUdRQv9eyvefMtcwa0=;
        b=nTeO8dULfZjDRFqkb50r8hT8gephwFzOzIjaYf/yfVsSqkWRefEw8q9V8KMlMQfzes
         pxx+TAsAeCxOLHu+8wvGU1rMWntCCAfmNbJ63wgis+HJEgBsOax0LlBskt5ANzQRjFgz
         GkUyueDX6f7NXmxkFR+pCOnJ9IQUEG9n5w7lF3SEftAkKJ98xtI4HxNuHBswPan624lQ
         K0fHrzLjFLl8BCJw5X3w1dPO4E3cbqXnx/N73DYfNaNqLurk13ly8o4+jTw73Er1pqKv
         S9l+cnuC4ObFMYfAcnEznffivcUzIbikk/ga6evkVs6ZCGhrJNWt0BJuv/GJseQx1W6P
         2y9A==
X-Gm-Message-State: AOAM5332JNihQCzvuUN3aI1hh0hjeh363IePcM8n3gxR7nMD6Ykpsca2
        oHsUtUXYiD/WLbrDUvzWMXAnUIjs0UdxNvSe3+zLNGPXOBdA8I5Eg/MJR6vJ0diFkDb1cTzfAGi
        2EX4CcAmd1XOqA0uiPZg2ilU4r7x8DIRhKNpOmrIl8Q1LAl/1JS/rW4T/tAp1bvNjT8oFvs8=
X-Received: by 2002:a17:902:6acb:b0:142:76c3:d35f with SMTP id i11-20020a1709026acb00b0014276c3d35fmr155959plt.89.1636382502767;
        Mon, 08 Nov 2021 06:41:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyeL2CxiRCKVcHKM5kQSmuxD5pMyf9PJUoVM8RcWidpLx2EXmvDxQlQ6M24pA0w2p+FDLO6IQ==
X-Received: by 2002:a17:902:6acb:b0:142:76c3:d35f with SMTP id i11-20020a1709026acb00b0014276c3d35fmr155901plt.89.1636382502276;
        Mon, 08 Nov 2021 06:41:42 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 7sm6267537pgk.55.2021.11.08.06.41.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 06:41:41 -0800 (PST)
Subject: Re: [PATCH 0/2] ceph: misc fixes for the fscrypt truncate size
 handling
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org
References: <20211108135012.79941-1-xiubli@redhat.com>
 <25c8bbac-99c1-66a9-cb79-96eb0213c702@redhat.com>
 <b4ce8eecc10c0796f233d42c5a92d2dead4a5f85.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <8569597c-4b56-07e2-6fbe-ce5d42ecb720@redhat.com>
Date:   Mon, 8 Nov 2021 22:41:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <b4ce8eecc10c0796f233d42c5a92d2dead4a5f85.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/8/21 10:26 PM, Jeff Layton wrote:
> On Mon, 2021-11-08 at 22:10 +0800, Xiubo Li wrote:
>> Hi Jeff,
>>
>> After this fixing, there still has one bug and I am still looking at it:
>>
>> [root@lxbceph1 xfstests]# ./check generic/075
>> FSTYP         -- ceph
>> PLATFORM      -- Linux/x86_64 lxbceph1 5.15.0-rc6+
>>
>> generic/075     [failed, exit status 1] - output mismatch (see
>> /mnt/kcephfs/xfstests/results//generic/075.out.bad)
>>       --- tests/generic/075.out    2021-11-08 20:54:07.456980801 +0800
>>       +++ /mnt/kcephfs/xfstests/results//generic/075.out.bad 2021-11-08
>> 21:20:49.741906997 +0800
>>       @@ -12,7 +12,4 @@
>>        -----------------------------------------------
>>        fsx.2 : -d -N numops -l filelen -S 0
>>        -----------------------------------------------
>>       -
>>       ------------------------------------------------
>>       -fsx.3 : -d -N numops -l filelen -S 0 -x
>>       ------------------------------------------------
>>       ...
>>       (Run 'diff -u tests/generic/075.out
>> /mnt/kcephfs/xfstests/results//generic/075.out.bad'  to see the entire diff)
>> Ran: generic/075
>> Failures: generic/075
>> Failed 1 of 1 tests
>>
>>
>> I checked the result outputs, it seems when truncating the size to a
>> smaller sizeA and then to a bigger sizeB again, in theory those contents
>> between sizeA and sizeB should be zeroed, but it didn't.
>>
>> The last block updating is correct.
>>
>> Any idea ?
>>
>
> Yep, that's the one I saw (intermittently) too. I also saw some failures
> around generic/029 and generic/030 that may be related. I haven't dug
> down as far into the problem as you have though.
>
> The nice thing about fsx is that it gives you a lot of info about what
> it does. There is also a way to replay a series of ops too, so you may
> want to try to see if you can make a reliable reproducer for this
> problem.

I can reproduce this every time.


> Are these truncates running concurrently in different tasks?

No, from the "075.2.fsxlog" they are serialized. The truncates 
themselves worked well, but there also have some 
mapwrite/write/mapread/read between them. From the logs, I am sure that 
those none zeroed contents are from mapwrite/write. It seems the dirty 
pages are flushed to OSDs just after the truncates.


>   If so, then
> we may need some mechanism to ensure that they are serialized vs. one
> another.

The truncate will hold the 'inode->i_rwsem' lock too, so it won't allow 
the truncate/read/write to run in parallel. But I am not sure the mapwrite ?


>
>> On 11/8/21 9:50 PM, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> Hi Jeff,
>>>
>>> The #1 could be squashed to the previous "ceph: add truncate size handling support for fscrypt" commit.
>>> The #2 could be squashed to the previous "ceph: fscrypt_file field handling in MClientRequest messages" commit.
>>>
>>> Thanks.
>>>
>>> Xiubo Li (2):
>>>     ceph: fix possible crash and data corrupt bugs
>>>     ceph: there is no need to round up the sizes when new size is 0
>>>
>>>    fs/ceph/inode.c | 8 +++++---
>>>    1 file changed, 5 insertions(+), 3 deletions(-)
>>>

