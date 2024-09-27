Return-Path: <ceph-devel+bounces-1841-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AC9AB987D15
	for <lists+ceph-devel@lfdr.de>; Fri, 27 Sep 2024 04:36:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C35A1F231D5
	for <lists+ceph-devel@lfdr.de>; Fri, 27 Sep 2024 02:36:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72946169AE4;
	Fri, 27 Sep 2024 02:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fNoG65DF"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CA6158203
	for <ceph-devel@vger.kernel.org>; Fri, 27 Sep 2024 02:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727404593; cv=none; b=NpqqTqXdVENngkHc+GjfcX41FLLJF7/7oR0sESu4VCPcVCBbK7zos56MgFj5cfy8NaZL6vl9gWNQD16LVjsh2juWRAGam5CJc1JoJYhD9UMyhK3jqldkDieRk4OiVQkPHU+3/6TZDVs6yAU0zJnWf27hsmIpKmImUnRwjh0MkGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727404593; c=relaxed/simple;
	bh=mZ+KhtQiBSI/+qaapAamwjybeR6ZwApCLrR2UNP8WCU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c3VZpzfUy6eBcb1u321aeSx4XWMl3nlrYrgj43J3ZkbGFjRQayUr5tBxHlY9RAeTUypLMyVP09dKZ3GphX2gkIVXTUBk2Nacr/R0pyT7B1R274WYwiOAFIAdCgdgxVatp23S+/b7eM9oeDMHKP/qtS7nxjIKH50Ci/2N8S7jiCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fNoG65DF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727404590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ym242b+NmBq4yeY0MnkyJlyTL0K7MkuCVeOhxNbnTRU=;
	b=fNoG65DFduPuvWijPPkv2Gsci4N+Jm6to2mJXTYU70jomv9UehT1xvHmvzEx1x/hcbxewO
	fKZeTRWkBwcqu98PmRFUhv7MglkSFsNs3OJwWJ07vFo/hldhsfeIeA3+mnL+jKGgWnGxET
	lQakhequAwfuDSpRVuZ1f9gfVm218qk=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-j79XSRRjPcSgLcALV8rr0A-1; Thu, 26 Sep 2024 22:36:27 -0400
X-MC-Unique: j79XSRRjPcSgLcALV8rr0A-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-208b130a763so18673045ad.0
        for <ceph-devel@vger.kernel.org>; Thu, 26 Sep 2024 19:36:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727404587; x=1728009387;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ym242b+NmBq4yeY0MnkyJlyTL0K7MkuCVeOhxNbnTRU=;
        b=qRhbuDYmtUtdiJ6FUFrzyvWHywxySq/vM8aXSw4CGEN0+dKevzi7C95qJzDLtopwvK
         Hv7Z1zXmFlgxU2sLsTsGEmMu/2StVr8hMNKJh0zv32KjTS0sIRp1p3SU2yndWwrxJ7Gk
         LUX+uxPQeJV3GpQV3prGW3j9jMvndXs6aibfsBEQp6J9a5twkfxK/mnAAk2LRnZP8oAI
         EZLDJwcUxnV5NehXJVuhdqHpO+aYD1konaUer/SMuu9QplcfPu27/G09PtfFBSmBqDhg
         3IMhjGjWACTlfXS7gWssD1MuaNeTP7SuXloDxcCLyBUODYgNHeAuAuVG7Xh9iwtEy2Ob
         X+Nw==
X-Gm-Message-State: AOJu0Yz3ZvukwEow0fhOFU9mc0sAaPoWxtL8bmphojJOTZSqp6f0I+ez
	QCr+ioQX8sO9dtPVPivoNGNqFyWzI2H6H8O5rmrp1w37QCf20feO9q2HqH7r0LGnoUPvMts7tj1
	589fctEQSv5mWNqAPE9KDbP3ZJ80aXLk84J2zSyZZV/jkcl9XSjlQU0NPhpc=
X-Received: by 2002:a17:902:fd05:b0:205:4e4a:72d9 with SMTP id d9443c01a7336-20b367d5bdfmr22900475ad.7.1727404586687;
        Thu, 26 Sep 2024 19:36:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGoR7+AB7T7J2KWTuIVYBQkFR4Wg2FuSYmTGwLggKR+BQ9na48jcWGlovNU5SV4zwc8E7T2mg==
X-Received: by 2002:a17:902:fd05:b0:205:4e4a:72d9 with SMTP id d9443c01a7336-20b367d5bdfmr22900305ad.7.1727404586289;
        Thu, 26 Sep 2024 19:36:26 -0700 (PDT)
Received: from [10.72.116.139] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37d61dfcsm4704365ad.20.2024.09.26.19.36.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2024 19:36:25 -0700 (PDT)
Message-ID: <d564fe25-a425-4e22-82e1-2b034edf370d@redhat.com>
Date: Fri, 27 Sep 2024 10:36:21 +0800
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
 <336f83cc-4a57-48dd-8598-e5b4ceab7d46@redhat.com>
 <CAOi1vP_LbSL2Zh-ndry2jXCMmueEc4=j-gbCTyrWn96g=1jmvg@mail.gmail.com>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP_LbSL2Zh-ndry2jXCMmueEc4=j-gbCTyrWn96g=1jmvg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 9/24/24 21:24, Ilya Dryomov wrote:
> On Tue, Sep 24, 2024 at 1:47 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 9/24/24 14:26, Ilya Dryomov wrote:
>>> On Tue, Jul 30, 2024 at 7:41 AM <xiubli@redhat.com> wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> We have hit a race between cap releases and cap revoke request
>>>> that will cause the check_caps() to miss sending a cap revoke ack
>>>> to MDS. And the client will depend on the cap release to release
>>>> that revoking caps, which could be delayed for some unknown reasons.
>>>>
>>>> In Kclient we have figured out the RCA about race and we need
>>>> a way to explictly trigger this manually could help to get rid
>>>> of the caps revoke stuck issue.
>>>>
>>>> URL: https://tracker.ceph.com/issues/67221
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/caps.c       | 22 ++++++++++++++++++++++
>>>>    fs/ceph/mds_client.c |  1 +
>>>>    fs/ceph/super.c      |  1 +
>>>>    fs/ceph/super.h      |  1 +
>>>>    4 files changed, 25 insertions(+)
>>>>
>>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>>> index c09add6d6516..a0a39243aeb3 100644
>>>> --- a/fs/ceph/caps.c
>>>> +++ b/fs/ceph/caps.c
>>>> @@ -4729,6 +4729,28 @@ void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc)
>>>>           ceph_mdsc_iterate_sessions(mdsc, flush_dirty_session_caps, true);
>>>>    }
>>>>
>>>> +/*
>>>> + * Flush all cap releases to the mds
>>>> + */
>>>> +static void flush_cap_releases(struct ceph_mds_session *s)
>>>> +{
>>>> +       struct ceph_mds_client *mdsc = s->s_mdsc;
>>>> +       struct ceph_client *cl = mdsc->fsc->client;
>>>> +
>>>> +       doutc(cl, "begin\n");
>>>> +       spin_lock(&s->s_cap_lock);
>>>> +       if (s->s_num_cap_releases)
>>>> +               ceph_flush_session_cap_releases(mdsc, s);
>>>> +       spin_unlock(&s->s_cap_lock);
>>>> +       doutc(cl, "done\n");
>>>> +
>>>> +}
>>>> +
>>>> +void ceph_flush_cap_releases(struct ceph_mds_client *mdsc)
>>>> +{
>>>> +       ceph_mdsc_iterate_sessions(mdsc, flush_cap_releases, true);
>>>> +}
>>>> +
>>>>    void __ceph_touch_fmode(struct ceph_inode_info *ci,
>>>>                           struct ceph_mds_client *mdsc, int fmode)
>>>>    {
>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>> index 86d0148819b0..fc563b59959a 100644
>>>> --- a/fs/ceph/mds_client.c
>>>> +++ b/fs/ceph/mds_client.c
>>>> @@ -5904,6 +5904,7 @@ void ceph_mdsc_sync(struct ceph_mds_client *mdsc)
>>>>           want_tid = mdsc->last_tid;
>>>>           mutex_unlock(&mdsc->mutex);
>>>>
>>>> +       ceph_flush_cap_releases(mdsc);
>>>>           ceph_flush_dirty_caps(mdsc);
>>>>           spin_lock(&mdsc->cap_dirty_lock);
>>>>           want_flush = mdsc->last_cap_flush_tid;
>>>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>>>> index f489b3e12429..0a1215b4f0ba 100644
>>>> --- a/fs/ceph/super.c
>>>> +++ b/fs/ceph/super.c
>>>> @@ -126,6 +126,7 @@ static int ceph_sync_fs(struct super_block *sb, int wait)
>>>>           if (!wait) {
>>>>                   doutc(cl, "(non-blocking)\n");
>>>>                   ceph_flush_dirty_caps(fsc->mdsc);
>>>> +               ceph_flush_cap_releases(fsc->mdsc);
>>> Hi Xiubo,
>>>
>>> Is there a significance to flushing cap releases before dirty caps on
>>> the blocking path and doing it vice versa (i.e. flushing cap releases
>>> after dirty caps) on the non-blocking path?
>> Hi Ilya,
>>
>> The dirty caps and the cap releases are not related.
>>
>> If caps are dirty it should be in the dirty list anyway in theory. Else
>> when the file is closed or inode is released will it be in the release
>> lists.
> So doing
>
>      ceph_flush_dirty_caps(mdsc);
>      ceph_flush_cap_releases(mdsc);
>
> in both cases just so that it's consistent is fine, right?

Yeah.


> Thanks,
>
>                  Ilya
>


