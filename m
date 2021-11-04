Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D0E444E68
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Nov 2021 06:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhKDFis (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 Nov 2021 01:38:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21033 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229866AbhKDFis (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 Nov 2021 01:38:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636004170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0lYD2OCP0KmHw7EXifBG8hpomvJcKMGXwgek20Bx0kA=;
        b=Tj/hfskI+Rw4mYfrJIXmhp0yXLWODJbw7lX3PUov4MLaaIOn3t3HP7JVIE+cHFfHo5Nkbr
        r7mC/RiFpgW+Hcv/aetsT9s5eBMaU6DP+F38UdckQ8SfD+auyhgQVsHWWJvk/A2MHMDxtF
        2vorUYrjBzkhzmdH4c91tV++QLdOl0M=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-Ac7T8I7LMY6bw_lmvHNEcA-1; Thu, 04 Nov 2021 01:36:07 -0400
X-MC-Unique: Ac7T8I7LMY6bw_lmvHNEcA-1
Received: by mail-pg1-f199.google.com with SMTP id w5-20020a654105000000b002692534afceso2906758pgp.8
        for <ceph-devel@vger.kernel.org>; Wed, 03 Nov 2021 22:36:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=0lYD2OCP0KmHw7EXifBG8hpomvJcKMGXwgek20Bx0kA=;
        b=gtuuA4r88uFIPyu64rsPAW1UASlPbaXYBka1DTSgxzXEPalu9B5IIYuWVRinoN6V8F
         JSiZ7J4Eiot7JxFWjagMD7Ri2LtDa3bUOnte8YLMSXMkygyItHWxztTlFaySIH+pnTUm
         lyQ15YU1EzywNY4SR/E55ecSjoLfDc3AxfTuTsX5bjjRh4Gnu5M3o+tceZwnmxHf2v91
         fYHMsLR8xicGs0keIQXZJT4bxvmT/f6+I5keDROF7GAi5KR/vLPm4vhfPMF3ycrGglZ0
         n5q8C9MXxhol3r97DLuoQg6WznPaVHVa/xHlMvQz4B7zAwhXujPnmukJ5OZh092FI4Uq
         hiWQ==
X-Gm-Message-State: AOAM532qJ/sYw225WQPCg1o9xvov7CUM3YjPjCgtUMi2sG/weFfMtdOH
        LvxWVwhi6ZUXh2rgZPc7nJZaesKdUI6ihg5R42xLMjSeOeQppSNzFKsamqzw56bIwiAwS594pWZ
        R2IsxWXb1HWLisqn5eXGwiw==
X-Received: by 2002:a63:7c42:: with SMTP id l2mr36952300pgn.90.1636004165123;
        Wed, 03 Nov 2021 22:36:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxOv7f4tW5bdU2wssoRGCgSkG7E+3CG92TZ/8Vmby/MXMIHU5KsYDwbHCeKYaEmythmryVR8g==
X-Received: by 2002:a63:7c42:: with SMTP id l2mr36952284pgn.90.1636004164890;
        Wed, 03 Nov 2021 22:36:04 -0700 (PDT)
Received: from [10.72.12.174] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p9sm3851186pfn.7.2021.11.03.22.36.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 22:36:04 -0700 (PDT)
Subject: Re: [PATCH v2] ceph: properly handle statfs on multifs setups
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        idryomov@gmail.com
Cc:     Sachin Prabhu <sprabhu@redhat.com>
References: <20211102204547.253710-1-jlayton@kernel.org>
 <fcdeaedc-ab5d-6c0c-d6b2-a59e302975ef@redhat.com>
 <ad0c7708441440665dfa22fc84e978caee03ed65.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <aa091edd-f41c-b4c2-6836-72274bb2fd32@redhat.com>
Date:   Thu, 4 Nov 2021 13:35:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <ad0c7708441440665dfa22fc84e978caee03ed65.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/3/21 6:24 PM, Jeff Layton wrote:
> On Wed, 2021-11-03 at 14:56 +0800, Xiubo Li wrote:
>> On 11/3/21 4:45 AM, Jeff Layton wrote:
>>> ceph_statfs currently stuffs the cluster fsid into the f_fsid field.
>>> This was fine when we only had a single filesystem per cluster, but now
>>> that we have multiples we need to use something that will vary between
>>> them.
>>>
>>> Change ceph_statfs to xor each 32-bit chunk of the fsid (aka cluster id)
>>> into the lower bits of the statfs->f_fsid. Change the lower bits to hold
>>> the fscid (filesystem ID within the cluster).
>>>
>>> That should give us a value that is guaranteed to be unique between
>>> filesystems within a cluster, and should minimize the chance of
>>> collisions between mounts of different clusters.
>>>
>>> URL: https://tracker.ceph.com/issues/52812
>>> Reported-by: Sachin Prabhu <sprabhu@redhat.com>
>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>> ---
>>>    fs/ceph/super.c | 11 ++++++-----
>>>    1 file changed, 6 insertions(+), 5 deletions(-)
>>>
>>> While looking at making an equivalent change to the userland libraries,
>>> it occurred to me that the earlier patch's method for computing this
>>> was overly-complex. This makes it a bit simpler, and avoids the
>>> intermediate step of setting up a u64.
>>>
>>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>>> index 9bb88423417e..e7b839aa08f6 100644
>>> --- a/fs/ceph/super.c
>>> +++ b/fs/ceph/super.c
>>> @@ -52,8 +52,7 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
>>>    	struct ceph_fs_client *fsc = ceph_inode_to_client(d_inode(dentry));
>>>    	struct ceph_mon_client *monc = &fsc->client->monc;
>>>    	struct ceph_statfs st;
>>> -	u64 fsid;
>>> -	int err;
>>> +	int i, err;
>>>    	u64 data_pool;
>>>    
>>>    	if (fsc->mdsc->mdsmap->m_num_data_pg_pools == 1) {
>>> @@ -99,12 +98,14 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
>>>    	buf->f_namelen = NAME_MAX;
>>>    
>>>    	/* Must convert the fsid, for consistent values across arches */
>>> +	buf->f_fsid.val[0] = 0;
>>>    	mutex_lock(&monc->mutex);
>>> -	fsid = le64_to_cpu(*(__le64 *)(&monc->monmap->fsid)) ^
>>> -	       le64_to_cpu(*((__le64 *)&monc->monmap->fsid + 1));
>>> +	for (i = 0; i < 4; ++i)
>>> +		buf->f_fsid.val[0] ^= le32_to_cpu(((__le32 *)&monc->monmap->fsid)[i]);
>>>    	mutex_unlock(&monc->mutex);
>>>    
>>> -	buf->f_fsid = u64_to_fsid(fsid);
>>> +	/* fold the fs_cluster_id into the upper bits */
>>> +	buf->f_fsid.val[1] = monc->fs_cluster_id;
>>>    
>>>    	return 0;
>>>    }
>> This version looks better.
>>
>> Reviewed-by: Xiubo Li <xiubli@redhat.com>
>>
>>
> Thanks. I think I'm going to make one more small change in there and
> express the loop conditional as:
>
>      i < sizeof(monc->monmap->fsid) / sizeof(__le32)
>
> That should work out to be '4', but should be safer in case the size of
> fsid ever changes. I'm not going to bother to re-post for that though.
Yeah, make sense.

