Return-Path: <ceph-devel+bounces-1836-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BF1B984518
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Sep 2024 13:47:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9F0C1F225B1
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Sep 2024 11:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F339C126BE0;
	Tue, 24 Sep 2024 11:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MO6rlmjb"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4193F9D5
	for <ceph-devel@vger.kernel.org>; Tue, 24 Sep 2024 11:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727178425; cv=none; b=nrA6VjH3HLvFaoNg2GW3XBWNFrpkfSWFiepVxV+PS8dA04bIAKH2fPqz+VFrg+OCZzGKErxfSJySgc0c34WKOxTBm9+S+YCz7iOi0fl4QeZ2ud0uHPPHYkxx7Vxt6cKvxmYXBJ+V64ufPEh/PowveexNMpHVuUcCZ0p1Y1BzxWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727178425; c=relaxed/simple;
	bh=1Rno3X/tcUXyjAzZFybjHt5u8uoSvmFC1uiy7YhMS6g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=naM5UEEepddaQ1unI89YlGJp3Vrxf6ayQp0kpKGjsPArvnx/cirCrDMFInZcOXL3WDS9qPUxqorhb9R80kWhKf+bg6eJGkho6z5xpDbZRM5TQoITFK4wffFVCrDdFX3PTjUPSEwo4ibMpK2VJZXcIWNHV0o7IELLPe9Vq2Md5zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MO6rlmjb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727178421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/ocVpdGpwmay2oJQ3a8TNZ1kfq4jlTVv5kM5n0IJVcE=;
	b=MO6rlmjbxAc84heBNFKZugBSLTMRPBzUne2ws8bC5ygU3UgDeT8Ge7WCOw6QInil45qpk1
	vyWZvFydmiwMrO6FifDexFR3/Rmpe1SObBkprPALGej2jfo3t3G3lnmCe0erLwqdtAAKz8
	sOLaIxXuTABpKMZ5P2fKEHzTSDIS31A=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-p__N551COgmXyOgqQHjf-Q-1; Tue, 24 Sep 2024 07:47:00 -0400
X-MC-Unique: p__N551COgmXyOgqQHjf-Q-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2052a68430fso62532905ad.2
        for <ceph-devel@vger.kernel.org>; Tue, 24 Sep 2024 04:47:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727178419; x=1727783219;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ocVpdGpwmay2oJQ3a8TNZ1kfq4jlTVv5kM5n0IJVcE=;
        b=rTDsMgHP4DCsPVbalmzPGyMV5UzOsnGKK76XQWGDwp/Z4ZjqFMN7w4FVGxDcR+RnWO
         +K6LKyZX1POWe7OETrgMXZUaZuH849ApmuttC7SJTpRNfCAbkyGKi6J/fKk69kEePF8d
         WFgOqvzOHdqeOW/N+6xMNBdCwNzofl2JCWFPo8Mudrxn540KUMcOg6DcY8/fKz8Y33pG
         GvZ2KQ5/GKjjmzWOMUfXxLT7IrRTWtkL09u+MBk/hBDruAE2CxhMNHJ/K0Ql1HW5Tl+r
         8palpWIEEH33B3WZj5CmcTwoHzcKX4oy52d+lhwmnDzbfZmZqT7odOau85SwmL0n7HGJ
         Svqg==
X-Gm-Message-State: AOJu0Yxac8afFeQkEqFUrdiyq5SOkOeFy4kiNh5f2h4NZQajsm1lToWL
	orEUE8dFfyzvG1WCfSNXdgZ5BsZm05AeBRSgjJbHs1KSg7KMEMtn28K/yps/hWcVyRkgQ8zLufW
	sW/7z7pNAlbUQEpHgYfQnM0bUiQd59MS/r8L0LI+DR1ughlTgQvaPmeylAW4=
X-Received: by 2002:a17:903:22c5:b0:205:6f2d:adf7 with SMTP id d9443c01a7336-208d83a8387mr186046045ad.21.1727178419260;
        Tue, 24 Sep 2024 04:46:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzqT2VGJE3w+prt4FsKWnRv5qQpgZKE/po0qC1Yab4/u73TH9DY01BnYu3ZU8PV3a6JR3s7Q==
X-Received: by 2002:a17:903:22c5:b0:205:6f2d:adf7 with SMTP id d9443c01a7336-208d83a8387mr186045855ad.21.1727178418899;
        Tue, 24 Sep 2024 04:46:58 -0700 (PDT)
Received: from [10.72.116.56] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20af17e3272sm9174985ad.179.2024.09.24.04.46.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2024 04:46:58 -0700 (PDT)
Message-ID: <336f83cc-4a57-48dd-8598-e5b4ceab7d46@redhat.com>
Date: Tue, 24 Sep 2024 19:46:49 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] ceph: flush all the caps release when syncing the
 whole filesystem
To: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org, vshankar@redhat.com
References: <20240730054135.640396-1-xiubli@redhat.com>
 <20240730054135.640396-3-xiubli@redhat.com>
 <CAOi1vP9g92tv8sEbFbSkV73PwrqqNNQktcYxUvdwCYBZkhhnsw@mail.gmail.com>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP9g92tv8sEbFbSkV73PwrqqNNQktcYxUvdwCYBZkhhnsw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 9/24/24 14:26, Ilya Dryomov wrote:
> On Tue, Jul 30, 2024 at 7:41 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> We have hit a race between cap releases and cap revoke request
>> that will cause the check_caps() to miss sending a cap revoke ack
>> to MDS. And the client will depend on the cap release to release
>> that revoking caps, which could be delayed for some unknown reasons.
>>
>> In Kclient we have figured out the RCA about race and we need
>> a way to explictly trigger this manually could help to get rid
>> of the caps revoke stuck issue.
>>
>> URL: https://tracker.ceph.com/issues/67221
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c       | 22 ++++++++++++++++++++++
>>   fs/ceph/mds_client.c |  1 +
>>   fs/ceph/super.c      |  1 +
>>   fs/ceph/super.h      |  1 +
>>   4 files changed, 25 insertions(+)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index c09add6d6516..a0a39243aeb3 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -4729,6 +4729,28 @@ void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc)
>>          ceph_mdsc_iterate_sessions(mdsc, flush_dirty_session_caps, true);
>>   }
>>
>> +/*
>> + * Flush all cap releases to the mds
>> + */
>> +static void flush_cap_releases(struct ceph_mds_session *s)
>> +{
>> +       struct ceph_mds_client *mdsc = s->s_mdsc;
>> +       struct ceph_client *cl = mdsc->fsc->client;
>> +
>> +       doutc(cl, "begin\n");
>> +       spin_lock(&s->s_cap_lock);
>> +       if (s->s_num_cap_releases)
>> +               ceph_flush_session_cap_releases(mdsc, s);
>> +       spin_unlock(&s->s_cap_lock);
>> +       doutc(cl, "done\n");
>> +
>> +}
>> +
>> +void ceph_flush_cap_releases(struct ceph_mds_client *mdsc)
>> +{
>> +       ceph_mdsc_iterate_sessions(mdsc, flush_cap_releases, true);
>> +}
>> +
>>   void __ceph_touch_fmode(struct ceph_inode_info *ci,
>>                          struct ceph_mds_client *mdsc, int fmode)
>>   {
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 86d0148819b0..fc563b59959a 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -5904,6 +5904,7 @@ void ceph_mdsc_sync(struct ceph_mds_client *mdsc)
>>          want_tid = mdsc->last_tid;
>>          mutex_unlock(&mdsc->mutex);
>>
>> +       ceph_flush_cap_releases(mdsc);
>>          ceph_flush_dirty_caps(mdsc);
>>          spin_lock(&mdsc->cap_dirty_lock);
>>          want_flush = mdsc->last_cap_flush_tid;
>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> index f489b3e12429..0a1215b4f0ba 100644
>> --- a/fs/ceph/super.c
>> +++ b/fs/ceph/super.c
>> @@ -126,6 +126,7 @@ static int ceph_sync_fs(struct super_block *sb, int wait)
>>          if (!wait) {
>>                  doutc(cl, "(non-blocking)\n");
>>                  ceph_flush_dirty_caps(fsc->mdsc);
>> +               ceph_flush_cap_releases(fsc->mdsc);
> Hi Xiubo,
>
> Is there a significance to flushing cap releases before dirty caps on
> the blocking path and doing it vice versa (i.e. flushing cap releases
> after dirty caps) on the non-blocking path?

Hi Ilya,

The dirty caps and the cap releases are not related.

If caps are dirty it should be in the dirty list anyway in theory. Else 
when the file is closed or inode is released will it be in the release 
lists.

Thanks

- Xiubo


> Thanks,
>
>                  Ilya
>


