Return-Path: <ceph-devel+bounces-1158-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C011E8CB6C3
	for <lists+ceph-devel@lfdr.de>; Wed, 22 May 2024 02:36:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CC5A7B21181
	for <lists+ceph-devel@lfdr.de>; Wed, 22 May 2024 00:36:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82BF123BE;
	Wed, 22 May 2024 00:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sf/A9gri"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD721865
	for <ceph-devel@vger.kernel.org>; Wed, 22 May 2024 00:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716338185; cv=none; b=smxCnpNE4KKkJJWZA3VU/UcLm2BVp5sEKjr1cqEernRP1XRtzD/SswYtaQX+peuSCBciYcsrfqr+q6GjQPOXa+Bofued+H9kPVyDt54c+WknCyfAB54D+f9N90KbldlkbVjHYcDGZr8Rw3d99zZk+yJt1YdjTiyYYRW1rJyJyZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716338185; c=relaxed/simple;
	bh=dYvhYS3udARCeFDF+EoyTtVpYGJvMvjRH7o5mk1JYys=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VzaB3jAGo1PRh19HwhOCseHE6O2lNTln7EGgLVSil6ECG8IgX3w05vNKn64gXs8zLvR9QgAOLPkAqpAqSh6iswXEQ3LCCjjfWM1KNtqzU6RKySxXb6WygFPKyS80g38Pw8fwsPFAGEIoGGKM4AkIeyIWnmDfemJp8hOhMZCeHjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sf/A9gri; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716338181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uaz4Sd2RkpY+9/VNwGRDVgLEG4C4q2c1v6Ol5eywNRA=;
	b=Sf/A9grimumbk0EjgnZ+rbv0VfQ2jw8X67H4br5IobpwMMKqPJt6v9zvQ2fZtVG6U6zPFi
	DRYd7RxgnuUwuhBx7lhaEkkYykjT7/ceA3PferJlVQi1UYa9P+LRiatS5aI1IdzNXaPW5c
	OoJ6G2/jNbWgog3y84bKUEanpMSU0sY=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-mi6kI8p8NBePkHFemC86Ng-1; Tue, 21 May 2024 20:36:19 -0400
X-MC-Unique: mi6kI8p8NBePkHFemC86Ng-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6f446a1ec59so11870783b3a.1
        for <ceph-devel@vger.kernel.org>; Tue, 21 May 2024 17:36:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716338178; x=1716942978;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uaz4Sd2RkpY+9/VNwGRDVgLEG4C4q2c1v6Ol5eywNRA=;
        b=INlN7JtnKv0I5cGFMb5IlxnyOev48lDjmZN2A5RPBlcpvqP+az04oOV2+or5K9iGKV
         CAaY2Uvbvc5l2dHX+DjjehRBvjdzBF67Jbkpt/ISXCuYW8bIX2NZGntZeoqdycb0jTnY
         dZg62qrf3A9KkxLpX8G+Faqj1qhOUznti3CNH6fhkhpUND2T9qWK5ZdTvIEOuEuM7GSN
         rqZAXsyRVI2LYoQq2FAPc3yEvtXzw4hLGWHaoW5l7iM4mCRgKl+oN8FpBK9I3fjiFaJP
         hofgyZZaUYS+T8VqdD3ub/MQyVa0UZwEUXUgcOessyjZeBhaTutlJmu/eJdPDi908Tak
         3LEg==
X-Forwarded-Encrypted: i=1; AJvYcCUJrJBvsVI7wvvyD8eSb9nA7OjrvXEtfYRz7DL+l1Rnm2gUYSiEkqhSds5W4zl/XZ2fo/LDkZYzbGUWA9rvGM7nDeqZ+zzJ6rQaqg==
X-Gm-Message-State: AOJu0YxAVyTjhFSGkQbtgIw3h4pLEr3AJElW+2r/OMpPzPRqezCcPAoO
	jAIgHvuwQOSQFTqAifP8bHh3kQsZPvDrFlosixmwxrknCT1pjkMpu161ZDsOdnvpSeSG/MzZ5uV
	MciSYFV3QFiwW5l0tlA7fbx+pzEUxEGseIsX2/TIyzFSamrPBMQsnPX9fsuq28WuH7b4N3w==
X-Received: by 2002:a05:6a00:929e:b0:6ed:cd4c:cc21 with SMTP id d2e1a72fcca58-6f6d60ce15amr536478b3a.13.1716338178031;
        Tue, 21 May 2024 17:36:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIKnKPC0YL0E4yq8LCtdyGnwjlXYRWhOK/xDLWKebz2DzSVyzIXXog9jFEzCCXNryjrMjNvg==
X-Received: by 2002:a05:6a00:929e:b0:6ed:cd4c:cc21 with SMTP id d2e1a72fcca58-6f6d60ce15amr536460b3a.13.1716338177587;
        Tue, 21 May 2024 17:36:17 -0700 (PDT)
Received: from [10.72.116.32] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4efd0b5a1sm18036018b3a.219.2024.05.21.17.36.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 May 2024 17:36:17 -0700 (PDT)
Message-ID: <40da7420-fa4d-4fb8-a281-1d25da3ac808@redhat.com>
Date: Wed, 22 May 2024 08:36:13 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ceph: fix stale xattr when using read() on dir with '-o
 dirstat'
To: t.fuchs@thofu.net, ceph-devel@vger.kernel.org
References: <10830198.216745.1716300283630@office.mailbox.org>
 <94937c2e-f8e3-438b-bde9-a1d290891469@thofu.net>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <94937c2e-f8e3-438b-bde9-a1d290891469@thofu.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 5/21/24 23:55, Thorsten Fuchs wrote:
> Xiubo Li <xiubli@redhat.com> hat am 21.05.2024 15:31 CEST geschrieben:
>>
>> On 5/21/24 14:13, Xiubo Li wrote:
>>>
>>> Hi Thorsten
>>>
>>> On 5/17/24 12:47, t.fuchs@thofu.net wrote:
>>>> Hi Xiubo,
>>>>
>>>> Thanks for the response.
>>>>
>>>> These are the steps I used to test the issue on a cephfs mount with 
>>>> the dirstat option enabled:
>>>>
>>>> ```
>>>> mkdir -p dir1/dir2
>>>> touch dir1/dir2/file
>>>> cat dir1
>>>> ```
>>>>
>>>> Output without patch applied:
>>>> ```
>>>> entries:                      1
>>>>   files:                       0
>>>>   subdirs:                     1
>>>> rentries:                     2
>>>>   rfiles:                      0
>>>>   rsubdirs:                    2
>>>> rbytes:                       0
>>>> rctime:    1715919375.649629819
>>>> ```
>>>>
>>>> Output with patch applied:
>>>> ```
>>>> entries:                      1
>>>>   files:                       0
>>>>   subdirs:                     1
>>>> rentries:                     3
>>>>   rfiles:                      1
>>>>   rsubdirs:                    2
>>>> rbytes:                       0
>>>> rctime:    1715919859.046790099
>>>> ```
>>>
>>> Unfortunately, it doesn't work in case of:
>>>
>>> $ mkdir -p dir1/dir2; touch dir1/dir2/file
>>>
>>> $ cat dir1
>>>
>>> It seems in this case the mds still will send the stale metadatas 
>>> back for some reasons.
>>>
>> It's because in MDS it will defer propagating rstat if multiple 
>> mkdir/create requests come and are handled in 
>> 'mds_dirstat_min_interval' seconds.
>>
>> In this case as a workaround we need to wait around 5 seconds, which 
>> is 'mds_tick_interval' and the scatter_tick() is fired.
>>
>> Maybe this should be fixed in both kclient and mds.
>>
>> - Xiubo
>>
> I improved my test environment and did some more checks. Seems I made 
> a mistake
> in the assumption that `cat` or `getfattr` would return the correct 
> value immediately after
> creating the file; it indeed takes a few seconds to get propagated.
> This behavior is well explained by your description.
> So the initial patch only fixes the behavior of `cat` to be equivalent 
> to `getfattr` and return
> correct values after a few seconds instead of keeping stale values for 
> a longer timespan.
> It's not immediate.

Yeah, it is.

The defer propagating should be another issue and exists in 'getfattr' too.

If you like you can fix it in a separate patch and ceph PR. Else please 
let me know if you want me to fix it and will do it in late future.

>>>
>>> And also I think you means 
>>> 's/CEPH_STAT_CAP_XATTR/CEPH_STAT_CAP_RSTAT/' ?
>>>
>>> Thanks
>>>
>>> - Xiubo
>>>
> Did you mean CEPH_STAT_RSTAT? I couldn't find the symbol 
> CEPH_STAT_CAP_RSTAT.
> I tested this with `err = ceph_do_getattr(inode, CEPH_STAT_RSTAT, 
> false);` which works fine.
> Unlike CEPH_STAT_CAP_XATTR it does not require the force flag to be 
> set to true.

Yeah, correct.

Checked the code again and you need to set more flags:

CEPH_STAT_RSTAT | CEPH_CAP_FILE_SHARED

The CEPH_CAP_FILE_SHARED is for 'entries/files/subdirs' entries, while 
CEPH_STAT_RSTAT is for 'rentries/rfiles/rsubdirs/rbytes/rctime'.

More detail please see the __ceph_getxattr() function in fs/ceph/xattr.c

- Xiubo

> - Thorsten
>>>> The unpatched code does not show the new file in the recursive
>>>> attributes.
>>>> Accessing the directory with e.g. `ls dir1` seems to update the
>>>> attributes and `cat` will return the correct information
>>>> afterwards.
>>>>
>>>> Interestingly the call `mkdir -p dir1/dir2/dir3 && cat dir1` will
>>>> not count dir3 initially even with the patch but fixes itself after
>>>> a few seconds with the patch.
>>>> This behavior is the same for `getfattr` though; hence I did not
>>>> investigate more.
>>>>
>>>> Best regards,
>>>> Thorsten
>>>>
>>>>> Xiubo Li<xiubli@redhat.com> hat am 17.05.2024 02:32 CEST geschrieben:
>>>>>
>>>>>   Hi Thorsten,
>>>>>
>>>>> Thanks for your patch.
>>>>>
>>>>> BTW, could share the steps to reproduce this issue you are trying 
>>>>> to fix ?
>>>>>
>>>>> Maybe this worth to add a test case in ceph qa suite.
>>>>>
>>>>> Thanks
>>>>>
>>>>> - Xiubo
>>>>>
>>>>> On 5/17/24 01:00, Thorsten Fuchs wrote:
>>>>>> Fixes stale recursive stats (rbytes, rentries, ...) being 
>>>>>> returned for
>>>>>> a directory after creating/deleting entries in subdirectories.
>>>>>>
>>>>>> Now `getfattr` and `cat` return the same values for the attributes.
>>>>>>
>>>>>> Signed-off-by: Thorsten Fuchs<t.fuchs@thofu.net>
>>>>>> ---
>>>>>>    fs/ceph/dir.c | 6 +++++-
>>>>>>    1 file changed, 5 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>>>>>> index 0e9f56eaba1e..e3cf76660305 100644
>>>>>> --- a/fs/ceph/dir.c
>>>>>> +++ b/fs/ceph/dir.c
>>>>>> @@ -2116,12 +2116,16 @@ static ssize_t ceph_read_dir(struct file 
>>>>>> *file, char __user *buf, size_t size,
>>>>>>     struct ceph_dir_file_info *dfi = file->private_data;
>>>>>>     struct inode *inode = file_inode(file);
>>>>>>     struct ceph_inode_info *ci = ceph_inode(inode);
>>>>>> - int left;
>>>>>> + int left, err;
>>>>>>     const int bufsize = 1024;
>>>>>>        if 
>>>>>> (!ceph_test_mount_opt(ceph_sb_to_fs_client(inode->i_sb), DIRSTAT))
>>>>>>      return -EISDIR;
>>>>>>    + err = ceph_do_getattr(inode, CEPH_STAT_CAP_XATTR, true);
>>>>>> + if (err)
>>>>>> +  return err;
>>>>>> +
>>>>>>     if (!dfi->dir_info) {
>>>>>>      dfi->dir_info = kmalloc(bufsize, GFP_KERNEL);
>>>>>>      if (!dfi->dir_info)
>


