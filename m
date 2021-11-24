Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC51E45B262
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Nov 2021 04:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbhKXDDd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 23 Nov 2021 22:03:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51199 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229773AbhKXDDc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 22:03:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637722823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gIN1xBjHuFkoe/ivJu1L43zYtsVLds/0BGEDIyA93vY=;
        b=cVxZwUwWGwNZkRuHDXp6FR0Vesp9a3qWbGP+kYbxVKf7BrGyv9R2uhJkMe1FsI7Eib4gJH
        bG+iDcSHmhOOaBbmC3iI2rmAqWx3L0GzHgEh/T9+xdOrVSkhoYofPl7lxzi7SkdNLzuvq6
        GI7vBCPSi5vNq5StU+V0zwSf8sDXxnI=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-431-j1aEq4x7NmaUGatx__Ajvg-1; Tue, 23 Nov 2021 22:00:20 -0500
X-MC-Unique: j1aEq4x7NmaUGatx__Ajvg-1
Received: by mail-pf1-f199.google.com with SMTP id c6-20020aa781c6000000b004a4fcdf1d6dso689070pfn.4
        for <ceph-devel@vger.kernel.org>; Tue, 23 Nov 2021 19:00:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=gIN1xBjHuFkoe/ivJu1L43zYtsVLds/0BGEDIyA93vY=;
        b=b7zZD6AEgcs8MVddhm7lK0vhcp0tWSVqAUEQ0SP6ke9/apqT7P5JGKEoA1uhc2/jl7
         n+zZ9ScekNXm5HspOQBBDMwo7BjszszVw48Dj7qoNEF36IBPkaq0+qJVveOPfgKkJJc7
         Kd0GrQtg58XN+KKH9a0roZLvMenaQ1isqtuUab3GUpyJWri6xmEqb3VyjbQXkFzqk82J
         t80RAeWiVhsAAouJHj3Au3AYw33JufLwBYtRloJr2BbSB4QV0oX7JUzFepNvYnnjszkX
         mQR7LdN1pGSmp0LkrbSGVpN7bhLPVWLfQgOOCFZ6zv7KZHdvfwB6yZ55r/woRXRfpLKj
         XH+g==
X-Gm-Message-State: AOAM530fcxXjZvC0G9Jvuch8iFZncjxbbkpExOSUKDbXxCcu7jOpW3+X
        DNtlfkNbJnK9PJB4JplfHkEBSwyt5jHvVPafDWBJY5XBmuJV0ZhLz3H/KheoXbq9cYAmGhCgXzU
        Y/QgVBnnXoxU4eCBKoyi2SaK7r6I0s+BmLHyuw3IiFkrFUQgVHrwV8U31lB92bkcFAUR2oMU=
X-Received: by 2002:a62:8fcc:0:b0:4a2:5a1f:6752 with SMTP id n195-20020a628fcc000000b004a25a1f6752mr2423803pfd.77.1637722818942;
        Tue, 23 Nov 2021 19:00:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJziP0uG9jAR69/fhI+lHZXCrY4LaMkkw9aXhWl1rEw5WW1sF3rZ1/jQNIgOcXyxi9FfeReGtg==
X-Received: by 2002:a62:8fcc:0:b0:4a2:5a1f:6752 with SMTP id n195-20020a628fcc000000b004a25a1f6752mr2423748pfd.77.1637722818490;
        Tue, 23 Nov 2021 19:00:18 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id fs21sm3484620pjb.1.2021.11.23.19.00.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 19:00:17 -0800 (PST)
Subject: Re: [PATCH] ceph: fscrypt always set the header.block_size to
 CEPH_FSCRYPT_BLOCK_SIZE
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org
References: <20211123102004.40149-1-xiubli@redhat.com>
 <f3185ff85d5ffbb28d82b8b04727879a04c92436.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c7353f81-0fa8-2a81-bfce-73dfaf34bbb3@redhat.com>
Date:   Wed, 24 Nov 2021 11:00:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <f3185ff85d5ffbb28d82b8b04727879a04c92436.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/23/21 10:27 PM, Jeff Layton wrote:
> On Tue, 2021-11-23 at 18:20 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When hit a file hole, will keep the header.assert_ver as 0, and
>> in MDS side it will check it to decide whether should it do a
>> RMW.
>>
>> And always set the header.block_size to CEPH_FSCRYPT_BLOCK_SIZE,
>> because even in the hole case, the MDS will need to use this to
>> do the filer.truncate().
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>>
>> Hi Jeff,
>>
>> Please squash this patch to the previous "ceph: add truncate size handling support for fscrypt" commit in ceph-client/wip-fscrypt-size branch.
>>
>> And also please sync the ceph PR, I have updated it too.
>>
>>
>>
> Thanks Xiubo. The branches should be updated now. Note that I dropped
> this patch since it was causing regressions for me:
>
>      [PATCH] ceph: do not truncate pagecache if truncate size doesn't change

Yeah, sure.


> With a kernel from the current wip-fscrypt-size branch, and a ceph
> cluster based on your fsize_support branch, I still got a failure on
> generic/029:
>
> generic/029 8s ... - output mismatch (see /home/jlayton/git/xfstests-dev/results//generic/029.out.bad)
>      --- tests/generic/029.out	2020-11-09 14:47:52.488429897 -0500
>      +++ /home/jlayton/git/xfstests-dev/results//generic/029.out.bad	2021-11-23 09:07:18.121501769 -0500
>      @@ -24,13 +24,6 @@
>       *
>       00001400
>       ==== Post-Remount ==
>      -00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58  |XXXXXXXXXXXXXXXX|
>      -*
>      -00000400  57 57 57 57 57 57 57 57  57 57 57 57 57 57 57 57  |WWWWWWWWWWWWWWWW|
>      -*
>      ...
>      (Run 'diff -u /home/jlayton/git/xfstests-dev/tests/generic/029.out /home/jlayton/git/xfstests-dev/results//generic/029.out.bad'  to see the entire diff)
>
>
> Basically, after the second xfs_io test in generic/029, the entire file
> was zeroed out. I still am unable to reproduce this every time however.
> It mostly seems to occur when I do a full -g quick run. If I run
> generic/029 in a loop, it rarely fails.
>
> Here's the test, basically:
>
> # second case is to do a mwrite between the truncate to a block on the
> # same page we are truncating within the EOF. This checks that a mapped
> # write between truncate down and truncate up a further mapped
> # write to the same page into the new space doesn't result in data being lost.
> $XFS_IO_PROG -t -f \
> -c "truncate 5120"              `# truncate     |                        |` \
> -c "pwrite -S 0x58 0 5120"      `# write        |XXXXXXXXXXXXXXXXXXXXXXXX|` \
> -c "mmap -rw 0 5120"            `# mmap         |                        |` \
> -c "mwrite -S 0x5a 2048 3072"   `# mwrite       |          ZZZZZZZZZZZZZZ|` \
> -c "truncate 2048"              `# truncate dn  |         |` \
> -c "mwrite -S 0x57 1024 1024"   `# mwrite       |     WWWWW              |` \
> -c "truncate 5120"              `# truncate up  |                        |` \
> -c "mwrite -S 0x59 2048 3072"   `# mwrite       |          YYYYYYYYYYYYYY|` \
> -c "close"      \
> $testfile | _filter_xfs_io
>   
> echo "==== Pre-Remount ==="
> hexdump -C $testfile
> _scratch_cycle_mount
> echo "==== Post-Remount =="
> hexdump -C $testfile
>
>
> I'll keep playing with this today, and see if I can get closer to a
> reliable reproducer.

Hi Jeff,

 From above logs, it seems saying that the file i_size was reset to 0 
after doing the umount.

In the "handle_cap_grant()" function:

3351 static void handle_cap_grant(struct inode *inode,
3352                              struct ceph_mds_session *session,
3353                              struct ceph_cap *cap,
3354                              struct ceph_mds_caps *grant,
3355                              struct ceph_buffer *xattr_buf,
3356                              struct cap_extra_info *extra_info)
3357         __releases(ci->i_ceph_lock)
3358         __releases(session->s_mdsc->snap_rwsem)
3359 {

...
3375         /*
3376          * If there is at least one crypto block then we'll trust 
fscrypt_file_size.
3377          * If the real length of the file is 0, then ignore it (it 
has probably been
3378          * truncated down to 0 by the MDS).
3379          */
3380         if (IS_ENCRYPTED(inode) && size)
3381                 size = extra_info->fscrypt_file_size;
3382

In Line#3381 it will set the size to fscrypt_file_size, IMO it's 0 in 
some cases.

Checked the MDS code, I didn't find the CInode::encode_cap_message() is 
sending this to kclients in MClientCaps messages. So the 
extra_info->fscrypt_file_size should be 0.

Then in the ceph_fill_file_size() it will update the i_size with 0 in 
case of truncating.

Locally I couldn't reproduce it, could you pull the latest ceph PR and 
retry it ? I have appended one new commit to fix it:

diff --git a/src/mds/CInode.cc b/src/mds/CInode.cc
index eefc6805505..165fd10de74 100644
--- a/src/mds/CInode.cc
+++ b/src/mds/CInode.cc
@@ -4139,6 +4139,7 @@ void CInode::encode_cap_message(const 
ref_t<MClientCaps> &m, Capability *cap)
    m->size = i->size;
    m->truncate_seq = i->truncate_seq;
    m->truncate_size = i->truncate_size;
+  m->fscrypt_file = pi->fscrypt_file;
    m->mtime = i->mtime;
    m->atime = i->atime;
    m->ctime = i->ctime;


Thanks

BRs

-- Xiubo



>>
>>   fs/ceph/inode.c | 14 ++++++++++++--
>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>> index 53b8e2ff3678..b4f7a4b4f15c 100644
>> --- a/fs/ceph/inode.c
>> +++ b/fs/ceph/inode.c
>> @@ -2312,6 +2312,12 @@ static int fill_fscrypt_truncate(struct inode *inode,
>>   	header.ver = 1;
>>   	header.compat = 1;
>>   
>> +	/*
>> +	 * Always set the block_size to CEPH_FSCRYPT_BLOCK_SIZE,
>> +	 * because in MDS it may need this to do the truncate.
>> +	 */
>> +	header.block_size = cpu_to_le32(CEPH_FSCRYPT_BLOCK_SIZE);
>> +
>>   	/*
>>   	 * If we hit a hole here, we should just skip filling
>>   	 * the fscrypt for the request, because once the fscrypt
>> @@ -2327,15 +2333,19 @@ static int fill_fscrypt_truncate(struct inode *inode,
>>   		     pos, i_size);
>>   
>>   		header.data_len = cpu_to_le32(8 + 8 + 4);
>> +
>> +		/*
>> +		 * If the "assert_ver" is 0 means hitting a hole, and
>> +		 * the MDS will use the it to check whether hitting a
>> +		 * hole or not.
>> +		 */
>>   		header.assert_ver = 0;
>>   		header.file_offset = 0;
>> -		header.block_size = 0;
>>   		ret = 0;
>>   	} else {
>>   		header.data_len = cpu_to_le32(8 + 8 + 4 + CEPH_FSCRYPT_BLOCK_SIZE);
>>   		header.assert_ver = cpu_to_le64(objvers.objvers[0].objver);
>>   		header.file_offset = cpu_to_le64(orig_pos);
>> -		header.block_size = cpu_to_le32(CEPH_FSCRYPT_BLOCK_SIZE);
>>   
>>   		/* truncate and zero out the extra contents for the last block */
>>   		memset(iov.iov_base + boff, 0, PAGE_SIZE - boff);

