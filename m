Return-Path: <ceph-devel+bounces-1156-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C8758CB1C6
	for <lists+ceph-devel@lfdr.de>; Tue, 21 May 2024 17:55:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9AA3DB23B18
	for <lists+ceph-devel@lfdr.de>; Tue, 21 May 2024 15:55:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B85C0142E73;
	Tue, 21 May 2024 15:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thofu.net header.i=@thofu.net header.b="PglxLQMG"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7892614291B
	for <ceph-devel@vger.kernel.org>; Tue, 21 May 2024 15:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716306941; cv=none; b=i3HGurEfpjVdMhQJN7XwK7/5GbkkH7PhukvxIXY528lwD5vOIFjQ17NslHLzMXRXfVrDJDM+EuY0eazMx8smvihIz3NktSlPe68P+LIqphRFbRmTzIK5oX995Y+bwtecGQ7zTcEIVRdZPwt2pbgaGFUiI0K9AvVUlOnmLqZejms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716306941; c=relaxed/simple;
	bh=bNkN5SquYHJd28wHlLOnKEWzd1d8/AqJrr6SNYxKAb0=;
	h=Message-ID:Date:MIME-Version:From:Subject:References:To:
	 In-Reply-To:Content-Type; b=B1zUwePsoCqL7/eCh4HBxfYHl2wC7VRQzsghAaM2pj+g2wYyGesQzaJj0aEDFykz2/f4GsKOQxtnVZ/VKa/gav1MjCHusSSgJkJJMEPo0V5p9eurrLy9jUqSTXgqn6J6QStDhAAcNqL2YM/hNv9FpIgGnHW8bHfYtsO92M2ztAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thofu.net; spf=pass smtp.mailfrom=thofu.net; dkim=pass (2048-bit key) header.d=thofu.net header.i=@thofu.net header.b=PglxLQMG; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thofu.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thofu.net
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4VkJtX4kBpz9sGf
	for <ceph-devel@vger.kernel.org>; Tue, 21 May 2024 17:55:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=thofu.net; s=MBO0001;
	t=1716306932; h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fsHiM9sS/wBJ2+boiqxIBYUTMmMgXr74bMLWlaX6jL8=;
	b=PglxLQMGdHl2RBeUYVFyS0WMX6OTOsz8EAu0rWIdZmkWABwGSi6+ysY4fRdEbO6CHcRQYD
	M6Mmek/QQ7sRnE2dvH0zSRlN8IT2kDTNM0PIBU1LPAQ+uMLGj0Z2l8LgxztLThebg2GWNJ
	XvzeIlEtcJChY0bHj8thuDjXoI+ZyoZLUU2MpOqLNzMxc3DYqhQ3EppucKZO8gfnlYWnY4
	NCimmzeB1KNEJgBfGZKJmVznJTDf6CbxseHTv3jZjby4qEPQGeexoNVWKPg9ZHUSGxCekU
	p77lqkF69k9eC90vhnhzdS/nX88QQMesVkvAm0Fzck6EDlKxTRp6zyarkU458g==
Message-ID: <94937c2e-f8e3-438b-bde9-a1d290891469@thofu.net>
Date: Tue, 21 May 2024 17:55:32 +0200
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Thorsten Fuchs <t.fuchs@thofu.net>
Subject: Re: [PATCH] ceph: fix stale xattr when using read() on dir with '-o
 dirstat'
References: <10830198.216745.1716300283630@office.mailbox.org>
Reply-To: t.fuchs@thofu.net
To: ceph-devel@vger.kernel.org
In-Reply-To: <10830198.216745.1716300283630@office.mailbox.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Xiubo Li <xiubli@redhat.com> hat am 21.05.2024 15:31 CEST geschrieben:
>
> On 5/21/24 14:13, Xiubo Li wrote:
>>
>> Hi Thorsten
>>
>> On 5/17/24 12:47, t.fuchs@thofu.net wrote:
>>> Hi Xiubo,
>>>
>>> Thanks for the response.
>>>
>>> These are the steps I used to test the issue on a cephfs mount with the dirstat option enabled:
>>>
>>> ```
>>> mkdir -p dir1/dir2
>>> touch dir1/dir2/file
>>> cat dir1
>>> ```
>>>
>>> Output without patch applied:
>>> ```
>>> entries:                      1
>>>   files:                       0
>>>   subdirs:                     1
>>> rentries:                     2
>>>   rfiles:                      0
>>>   rsubdirs:                    2
>>> rbytes:                       0
>>> rctime:    1715919375.649629819
>>> ```
>>>
>>> Output with patch applied:
>>> ```
>>> entries:                      1
>>>   files:                       0
>>>   subdirs:                     1
>>> rentries:                     3
>>>   rfiles:                      1
>>>   rsubdirs:                    2
>>> rbytes:                       0
>>> rctime:    1715919859.046790099
>>> ```
>>
>> Unfortunately, it doesn't work in case of:
>>
>> $ mkdir -p dir1/dir2; touch dir1/dir2/file
>>
>> $ cat dir1
>>
>> It seems in this case the mds still will send the stale metadatas 
>> back for some reasons.
>>
> It's because in MDS it will defer propagating rstat if multiple 
> mkdir/create requests come and are handled in 
> 'mds_dirstat_min_interval' seconds.
>
> In this case as a workaround we need to wait around 5 seconds, which 
> is 'mds_tick_interval' and the scatter_tick() is fired.
>
> Maybe this should be fixed in both kclient and mds.
>
> - Xiubo
>
I improved my test environment and did some more checks. Seems I made a 
mistake
in the assumption that `cat` or `getfattr` would return the correct 
value immediately after
creating the file; it indeed takes a few seconds to get propagated.
This behavior is well explained by your description.
So the initial patch only fixes the behavior of `cat` to be equivalent 
to `getfattr` and return
correct values after a few seconds instead of keeping stale values for a 
longer timespan.
It's not immediate.
>>
>> And also I think you means 's/CEPH_STAT_CAP_XATTR/CEPH_STAT_CAP_RSTAT/' ?
>>
>> Thanks
>>
>> - Xiubo
>>
Did you mean CEPH_STAT_RSTAT? I couldn't find the symbol 
CEPH_STAT_CAP_RSTAT.
I tested this with `err = ceph_do_getattr(inode, CEPH_STAT_RSTAT, 
false);` which works fine.
Unlike CEPH_STAT_CAP_XATTR it does not require the force flag to be set 
to true.
- Thorsten
>>> The unpatched code does not show the new file in the recursive
>>> attributes.
>>> Accessing the directory with e.g. `ls dir1` seems to update the
>>> attributes and `cat` will return the correct information
>>> afterwards.
>>>
>>> Interestingly the call `mkdir -p dir1/dir2/dir3 && cat dir1` will
>>> not count dir3 initially even with the patch but fixes itself after
>>> a few seconds with the patch.
>>> This behavior is the same for `getfattr` though; hence I did not
>>> investigate more.
>>>
>>> Best regards,
>>> Thorsten
>>>
>>>> Xiubo Li<xiubli@redhat.com>  hat am 17.05.2024 02:32 CEST geschrieben:
>>>>
>>>>   
>>>> Hi Thorsten,
>>>>
>>>> Thanks for your patch.
>>>>
>>>> BTW, could share the steps to reproduce this issue you are trying to fix ?
>>>>
>>>> Maybe this worth to add a test case in ceph qa suite.
>>>>
>>>> Thanks
>>>>
>>>> - Xiubo
>>>>
>>>> On 5/17/24 01:00, Thorsten Fuchs wrote:
>>>>> Fixes stale recursive stats (rbytes, rentries, ...) being returned for
>>>>> a directory after creating/deleting entries in subdirectories.
>>>>>
>>>>> Now `getfattr` and `cat` return the same values for the attributes.
>>>>>
>>>>> Signed-off-by: Thorsten Fuchs<t.fuchs@thofu.net>
>>>>> ---
>>>>>    fs/ceph/dir.c | 6 +++++-
>>>>>    1 file changed, 5 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>>>>> index 0e9f56eaba1e..e3cf76660305 100644
>>>>> --- a/fs/ceph/dir.c
>>>>> +++ b/fs/ceph/dir.c
>>>>> @@ -2116,12 +2116,16 @@ static ssize_t ceph_read_dir(struct file *file, char __user *buf, size_t size,
>>>>>     struct ceph_dir_file_info *dfi = file->private_data;
>>>>>     struct inode *inode = file_inode(file);
>>>>>     struct ceph_inode_info *ci = ceph_inode(inode);
>>>>> - int left;
>>>>> + int left, err;
>>>>>     const int bufsize = 1024;
>>>>>    
>>>>>     if (!ceph_test_mount_opt(ceph_sb_to_fs_client(inode->i_sb), DIRSTAT))
>>>>>      return -EISDIR;
>>>>>    
>>>>> + err = ceph_do_getattr(inode, CEPH_STAT_CAP_XATTR, true);
>>>>> + if (err)
>>>>> +  return err;
>>>>> +
>>>>>     if (!dfi->dir_info) {
>>>>>      dfi->dir_info = kmalloc(bufsize, GFP_KERNEL);
>>>>>      if (!dfi->dir_info)

