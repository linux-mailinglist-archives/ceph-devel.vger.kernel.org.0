Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC9E3F554D
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Aug 2021 03:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbhHXBGd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Aug 2021 21:06:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29737 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234116AbhHXBGW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 21:06:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629767138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9st6w9NvqY6kol76KpVziBDBNVECjsJU3w0jr6Fx8bE=;
        b=LbAWwtXF1H1ibGn78Uca6BDTKXTpB44Ydn7ekhp+yjx5NAquM9pATeGsy32ZNMcX3R8CG0
        6t0LBRxQdglXjo1i8rCBpsHeS8wgF5GpGT8FYCNiLHb7YcWzsYS7ZfAw2JroILyopiYSJ9
        9ARhGUvFRGANzccHCGqpAInx/3hRz7Y=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-OLF2fXAJO4qBdmkdy150XQ-1; Mon, 23 Aug 2021 21:05:37 -0400
X-MC-Unique: OLF2fXAJO4qBdmkdy150XQ-1
Received: by mail-pl1-f198.google.com with SMTP id u12-20020a170902e80c00b0012da2362222so4908342plg.8
        for <ceph-devel@vger.kernel.org>; Mon, 23 Aug 2021 18:05:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=9st6w9NvqY6kol76KpVziBDBNVECjsJU3w0jr6Fx8bE=;
        b=jLXZfeO/8RSsdx3ugU7ARq0BvfR4MBjCJbANpTiSLMLcDOYfVhi59r8GKXet5t3hRQ
         xys1QRsGQbkFo1k3o9ADCzNHnHpuqPRNnFCqawdMeg4hP0UyZHIEJFf/CAxLJsak5TEP
         x2++rkBI/WHSsf8bwPMc9yzdcKrpDjmuh82qhu2+Qyjah1iRDcDudIwCIDxcU9Necw5J
         gg0RjDozIaRj9LX9z4cVlfDzNlKSVVg5DXRuW57g3AsL6BnG0pLBcBNBfbdDjzEqpZAs
         3rfMIqhPCBMj2OZiasSOhu+32IvnslYE3BMgDta18BVt2EN2+zaAEG+fZh0CL1qSxav0
         5GlA==
X-Gm-Message-State: AOAM533VXEP9G1Uc6RWqXeP0YYJ7WLMhWc5ddRY0S658aTL1WZjIGpxU
        XSX5eAxZXbVbWiiI+OLCPcQuXAvkrL1Xfzow3v0WTMWFyJE6fcgFvKVcIo/9YP7A4YEc2a4osb6
        3fgitMkAGHRcLLyRRR90Ty39HZMY3wAFgwyufa5FsCpyt6NUQ+iaZd0PU/ZlRsjE3zAV4XO0=
X-Received: by 2002:a62:8491:0:b029:3dd:a29a:a1e4 with SMTP id k139-20020a6284910000b02903dda29aa1e4mr36220429pfd.13.1629767136358;
        Mon, 23 Aug 2021 18:05:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzpKphnrhBEeDGXLA21tFgXio0qZIF5PZ2mXKcSZqhpfLMoGvgSSlJHDk27TtrC/8lCEzgMZg==
X-Received: by 2002:a62:8491:0:b029:3dd:a29a:a1e4 with SMTP id k139-20020a6284910000b02903dda29aa1e4mr36220405pfd.13.1629767136096;
        Mon, 23 Aug 2021 18:05:36 -0700 (PDT)
Received: from [10.72.12.33] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u16sm20171327pgh.53.2021.08.23.18.05.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 18:05:35 -0700 (PDT)
Subject: Re: [PATCH 1/3] ceph: remove the capsnaps when removing the caps
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210818080603.195722-1-xiubli@redhat.com>
 <20210818080603.195722-2-xiubli@redhat.com>
 <be0e28cf34dfcf65b1772e621557ecc276d46b95.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <0917a4a5-03d3-d887-d769-6968bdeada26@redhat.com>
Date:   Tue, 24 Aug 2021 09:05:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <be0e28cf34dfcf65b1772e621557ecc276d46b95.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/23/21 10:58 PM, Jeff Layton wrote:
> On Wed, 2021-08-18 at 16:06 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The capsnaps will ihold the inodes when queuing to flush, so when
>> force umounting it will close the sessions first and if the MDSes
>> respond very fast and the session connections are closed just
>> before killing the superblock, which will flush the msgr queue,
>> then the flush capsnap callback won't ever be called, which will
>> lead the memory leak bug for the ceph_inode_info.
>>
>> URL: https://tracker.ceph.com/issues/52295
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c       | 47 +++++++++++++++++++++++++++++---------------
>>   fs/ceph/mds_client.c | 23 +++++++++++++++++++++-
>>   fs/ceph/super.h      |  3 +++
>>   3 files changed, 56 insertions(+), 17 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index e239f06babbc..7def99fbdca6 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -3663,6 +3663,34 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
>>   		iput(inode);
>>   }
>>   
>> +/*
>> + * Caller hold s_mutex and i_ceph_lock.
>> + */
>> +void ceph_remove_capsnap(struct inode *inode, struct ceph_cap_snap *capsnap,
>> +			 bool *wake_ci, bool *wake_mdsc)
>> +{
>> +	struct ceph_inode_info *ci = ceph_inode(inode);
>> +	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
>> +	bool ret;
>> +
>> +	dout("removing capsnap %p, inode %p ci %p\n", capsnap, inode, ci);
>> +
>> +	WARN_ON(capsnap->dirty_pages || capsnap->writing);
> Can we make this a WARN_ON_ONCE too?

Yeah, will fix it.

Thanks

