Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A59627FAF
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Nov 2022 14:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237695AbiKNNB0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Nov 2022 08:01:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237672AbiKNNBS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 14 Nov 2022 08:01:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B311026481
        for <ceph-devel@vger.kernel.org>; Mon, 14 Nov 2022 05:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668430818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XbnOKNFz0QFpr0L/BEERrr3p9C0lyZVLkIZ75c02Fh8=;
        b=OuiQkGtosVdi8OcvvFCQ7FF95WV84pUsT6RJ4VyAIURhll7dQw06h+T2xddvfELBo7mkoP
        skWbpQA103cwPtQ9G6Wx9DEn6nolSakr824k2jpxraauv/DzOx1RN3rBRK9VQ+Lm33hc/b
        zWoTGA+A8tOBcJqFCdvlSzeUeTNp+a4=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-148-Qgec6TrjN8iJOeMobzXPAQ-1; Mon, 14 Nov 2022 08:00:17 -0500
X-MC-Unique: Qgec6TrjN8iJOeMobzXPAQ-1
Received: by mail-pl1-f198.google.com with SMTP id n12-20020a170902e54c00b00188515e81a6so9004017plf.23
        for <ceph-devel@vger.kernel.org>; Mon, 14 Nov 2022 05:00:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XbnOKNFz0QFpr0L/BEERrr3p9C0lyZVLkIZ75c02Fh8=;
        b=Qzh0QRMBIOThpQ7iXuThoeOIjrT8ytYJPf95wD0tqyctu9h+p70+tbydpWT3hLh0kZ
         PNg2PnIMIRFxjmJt7IPxk0siFQc3sixnd5nuz/+1flNYVPeHNUHd03batk+x4cnzjLsl
         BeQzO2nj8pnhM9xDYNQxpUMUxzzdv5PbzJdjd8Tvqqp4VCXRW4RoEEc2FI6C/mFeXgcm
         usp2OZthUotzKtXo/ll9BGTvMUCTUXV7eNSZLVC/Gd0Go52Ef4PzBeTTdEuG3wGxk8FO
         p7ZBCKQWwmunaa4diqNhGWPtsU9eZ3nJz5yN+qKwRFGy/NCaajXSmf4oMd4Kko/gBtwu
         PV8w==
X-Gm-Message-State: ANoB5pmOSiMh5r3dS5i0ZmGDwY3TdwqGNNYVy34PHeOKgmi5BAutjAT9
        lvgwtphnC+o3acsssHDm8j9tDTNkexeftn6KQKvqO0HyI6786CDZRrXCTNzIfWsmcbydDc5p0K5
        3XzC2CFAa6/0xJyZNrkCEoA==
X-Received: by 2002:a17:902:6b87:b0:187:1a3f:d552 with SMTP id p7-20020a1709026b8700b001871a3fd552mr14015224plk.5.1668430816539;
        Mon, 14 Nov 2022 05:00:16 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7PelnllhUECNg95HS+A2FAfeyz67tAnA4tlyPp96EoUln1X8uQMw0aPOqBKxB+EIWHj+s1Hw==
X-Received: by 2002:a17:902:6b87:b0:187:1a3f:d552 with SMTP id p7-20020a1709026b8700b001871a3fd552mr14015186plk.5.1668430816228;
        Mon, 14 Nov 2022 05:00:16 -0800 (PST)
Received: from [10.72.12.148] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n3-20020a17090ab80300b00210c84b8ae5sm6377845pjr.35.2022.11.14.05.00.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 05:00:15 -0800 (PST)
Subject: Re: [PATCH 1/2 v2] ceph: add ceph_lock_info support for file_lock
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        idryomov@gmail.com, viro@zeniv.linux.org.uk
Cc:     lhenriques@suse.de, mchangir@redhat.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
References: <20221114051901.15371-1-xiubli@redhat.com>
 <20221114051901.15371-2-xiubli@redhat.com>
 <f2d6f7a3fa75710a1170a8969d948e85d056c272.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <46c13ca8-ed59-d033-cf7a-0c35770e7df0@redhat.com>
Date:   Mon, 14 Nov 2022 21:00:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <f2d6f7a3fa75710a1170a8969d948e85d056c272.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 14/11/2022 19:24, Jeff Layton wrote:
> On Mon, 2022-11-14 at 13:19 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When ceph releasing the file_lock it will try to get the inode pointer
>> from the fl->fl_file, which the memory could already be released by
>> another thread in filp_close(). Because in VFS layer the fl->fl_file
>> doesn't increase the file's reference counter.
>>
>> Will switch to use ceph dedicate lock info to track the inode.
>>
>> And in ceph_fl_release_lock() we should skip all the operations if
>> the fl->fl_u.ceph_fl.fl_inode is not set, which should come from
>> the request file_lock. And we will set fl->fl_u.ceph_fl.fl_inode when
>> inserting it to the inode lock list, which is when copying the lock.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://tracker.ceph.com/issues/57986
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/locks.c                 | 18 +++++++++++++++---
>>   include/linux/ceph/ceph_fs_fl.h | 26 ++++++++++++++++++++++++++
>>   include/linux/fs.h              |  2 ++
>>   3 files changed, 43 insertions(+), 3 deletions(-)
>>   create mode 100644 include/linux/ceph/ceph_fs_fl.h
>>
>> diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
>> index 3e2843e86e27..d8385dd0076e 100644
>> --- a/fs/ceph/locks.c
>> +++ b/fs/ceph/locks.c
>> @@ -34,22 +34,34 @@ static void ceph_fl_copy_lock(struct file_lock *dst, struct file_lock *src)
>>   {
>>   	struct ceph_file_info *fi = dst->fl_file->private_data;
>>   	struct inode *inode = file_inode(dst->fl_file);
>> +
>>   	atomic_inc(&ceph_inode(inode)->i_filelock_ref);
>>   	atomic_inc(&fi->num_locks);
>> +	dst->fl_u.ceph_fl.fl_inode = igrab(inode);
>>   }
>>   
>>   static void ceph_fl_release_lock(struct file_lock *fl)
>>   {
>>   	struct ceph_file_info *fi = fl->fl_file->private_data;
>> -	struct inode *inode = file_inode(fl->fl_file);
>> -	struct ceph_inode_info *ci = ceph_inode(inode);
>> -	atomic_dec(&fi->num_locks);
>> +	struct inode *inode = fl->fl_u.ceph_fl.fl_inode;
>> +	struct ceph_inode_info *ci;
>> +
>> +	/*
>> +	 * If inode is NULL it should be a request file_lock,
>> +	 * nothing we can do.
>> +	 */
>> +	if (!inode)
>> +		return;
>> +
>> +	ci = ceph_inode(inode);
>>   	if (atomic_dec_and_test(&ci->i_filelock_ref)) {
>>   		/* clear error when all locks are released */
>>   		spin_lock(&ci->i_ceph_lock);
>>   		ci->i_ceph_flags &= ~CEPH_I_ERROR_FILELOCK;
>>   		spin_unlock(&ci->i_ceph_lock);
>>   	}
>> +	iput(inode);
>> +	atomic_dec(&fi->num_locks);
> It doesn't look like this fixes the original issue. "fi" may be pointing
> to freed memory at this point, right?

Yeah, I didn't fix this in the this patch. I fixed it in a dedicated 2/2 
patch.

>   I think you may need to get rid of
> the "num_locks" field in ceph_file_info, and do that in a different way?
>
This is a dedicated field for each 'file' struct. I have no idea how to 
fix this in a different way yet.

Thanks!

- Xiubo


>>   }
>>   
>>   static const struct file_lock_operations ceph_fl_lock_ops = {
>> diff --git a/include/linux/ceph/ceph_fs_fl.h b/include/linux/ceph/ceph_fs_fl.h
>> new file mode 100644
>> index 000000000000..02a412b26095
>> --- /dev/null
>> +++ b/include/linux/ceph/ceph_fs_fl.h
>> @@ -0,0 +1,26 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * ceph_fs.h - Ceph constants and data types to share between kernel and
>> + * user space.
>> + *
>> + * Most types in this file are defined as little-endian, and are
>> + * primarily intended to describe data structures that pass over the
>> + * wire or that are stored on disk.
>> + *
>> + * LGPL2
>> + */
>> +
>> +#ifndef CEPH_FS_FL_H
>> +#define CEPH_FS_FL_H
>> +
>> +#include <linux/fs.h>
>> +
>> +/*
>> + * Ceph lock info
>> + */
>> +
>> +struct ceph_lock_info {
>> +	struct inode *fl_inode;
>> +};
>> +
>> +#endif
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index e654435f1651..db4810d19e26 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -1066,6 +1066,7 @@ bool opens_in_grace(struct net *);
>>   
>>   /* that will die - we need it for nfs_lock_info */
>>   #include <linux/nfs_fs_i.h>
>> +#include <linux/ceph/ceph_fs_fl.h>
>>   
>>   /*
>>    * struct file_lock represents a generic "file lock". It's used to represent
>> @@ -1119,6 +1120,7 @@ struct file_lock {
>>   			int state;		/* state of grant or error if -ve */
>>   			unsigned int	debug_id;
>>   		} afs;
>> +		struct ceph_lock_info	ceph_fl;
>>   	} fl_u;
>>   } __randomize_layout;
>>   

