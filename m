Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6780F43E11B
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Oct 2021 14:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhJ1MoT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Oct 2021 08:44:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29858 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229835AbhJ1MoT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 08:44:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635424912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q7T/I/O2ogJuMKFNNOUdl/fDvRkAEtRTDcKuWcsif7I=;
        b=OITqJFSl9iG9wf/AyLKN/W6SP0BoAQsbVJYrT0wlIVjEqQkP6Q8epbaiDen2MBafT+xw0b
        CXfdj1b/wEStdqw0AYHuwnDqIPh2xG1OmOJ4Hai/WsoUcrrM40eLvjqRj7he4hMA7W0aWq
        ZHjFW18ZCWmAIXxWCYfjtU/OwObgBAU=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-ajPU5h4CORW0VVugbtaPYA-1; Thu, 28 Oct 2021 08:41:50 -0400
X-MC-Unique: ajPU5h4CORW0VVugbtaPYA-1
Received: by mail-pf1-f198.google.com with SMTP id c140-20020a624e92000000b0044d3de98438so3235699pfb.14
        for <ceph-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:41:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Q7T/I/O2ogJuMKFNNOUdl/fDvRkAEtRTDcKuWcsif7I=;
        b=GcRql8Vk3kP+oEuWzdXJV9eUZ4nOIlWHf5AFy7cwJ1DQvrcdYNDlAnxJdbObMKIMDa
         uKZtI9Hvc2d8ZA0yKXTpakEOxfWBcjP1WLE/oKys7+VTDVBLPnYP8J0GMhhlVU86HdU0
         3HH2/xgScZB7kIPEF3WNn7GhOwEPimfvPjnjULHguIp7u5YjaoNQ6gw33Pqm38ZGiG8i
         t6EVirCYiHsuFj7gDaxIyN8dzjYKKY9NgNLTVXxmOT7kOs2XsNe/GHXe1SkDNoqZ1IMf
         pux6zSoTfn2kUMmw9J1MPErMtts3g2tMTPV3jR5CPnK+aaQ8RbxKLtbxczrfjNlL7LKJ
         DvUg==
X-Gm-Message-State: AOAM531jIrXxGTfwqywjym0WrkPgnGT741+srhx/dUiDnlb+4Nxi3vjB
        3juYcPZAKReUbfoM7u7Y2/WYXJXLB7Bv1QUyheVhCPkQ9Gvu5477B299duX83nHTQZgdXTVUpVt
        XSUUzKk6wqLJI06dZL4OIUVB7rykSEbxse21G1KOEorl+CEBaSpbxEeHuCHHT/4hC4/ii2ss=
X-Received: by 2002:a17:90b:33c8:: with SMTP id lk8mr12647094pjb.106.1635424908428;
        Thu, 28 Oct 2021 05:41:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAAwKAybOhrv23xTR7rIrhSna4Pe3DrO09wgRzl3BC90OnQJS9zuP6YbjX9RPbmTgusdh9+w==
X-Received: by 2002:a17:90b:33c8:: with SMTP id lk8mr12647055pjb.106.1635424908030;
        Thu, 28 Oct 2021 05:41:48 -0700 (PDT)
Received: from [10.72.12.20] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f4sm2687456pgn.93.2021.10.28.05.41.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 05:41:47 -0700 (PDT)
Subject: Re: [PATCH v3 1/4] ceph: add __ceph_get_caps helper support
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211028091438.21402-1-xiubli@redhat.com>
 <20211028091438.21402-2-xiubli@redhat.com>
 <c9255017-333d-68dd-880a-96952e08ca08@redhat.com>
 <03058ef4a3a783b1a879c5e4059aac72d475f9c4.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <5471c136-c5d0-329f-283c-5ea6143ffd5f@redhat.com>
Date:   Thu, 28 Oct 2021 20:41:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <03058ef4a3a783b1a879c5e4059aac72d475f9c4.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 10/28/21 6:44 PM, Jeff Layton wrote:
> I see your cover letter for this series on the list. You may just be
> running across how gmail's (infuriating) labeling works? I don't think
> they ever show up in patchwork though (since they don't have patches in
> them).

Okay, I searched the cover-letters everywhere, still couldn't see them 
suddenly since last week :-(


>
> -- Jeff
>
>
> On Thu, 2021-10-28 at 17:23 +0800, Xiubo Li wrote:
>> Hi Jeff,
>>
>> Not sure why the cover-letter is not displayed in both the mail list and
>> ceph patchwork, locally it was successfully sent out.
>>
>> Any idea ?
>>
>> Thanks
>>
>> -- Xiubo
>>
>>
>> On 10/28/21 5:14 PM, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>    fs/ceph/caps.c  | 19 +++++++++++++------
>>>    fs/ceph/super.h |  2 ++
>>>    2 files changed, 15 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>> index d628dcdbf869..4e2a588465c5 100644
>>> --- a/fs/ceph/caps.c
>>> +++ b/fs/ceph/caps.c
>>> @@ -2876,10 +2876,9 @@ int ceph_try_get_caps(struct inode *inode, int need, int want,
>>>     * due to a small max_size, make sure we check_max_size (and possibly
>>>     * ask the mds) so we don't get hung up indefinitely.
>>>     */
>>> -int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got)
>>> +int __ceph_get_caps(struct inode *inode, struct ceph_file_info *fi, int need,
>>> +		    int want, loff_t endoff, int *got)
>>>    {
>>> -	struct ceph_file_info *fi = filp->private_data;
>>> -	struct inode *inode = file_inode(filp);
>>>    	struct ceph_inode_info *ci = ceph_inode(inode);
>>>    	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>>>    	int ret, _got, flags;
>>> @@ -2888,7 +2887,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
>>>    	if (ret < 0)
>>>    		return ret;
>>>    
>>> -	if ((fi->fmode & CEPH_FILE_MODE_WR) &&
>>> +	if (fi && (fi->fmode & CEPH_FILE_MODE_WR) &&
>>>    	    fi->filp_gen != READ_ONCE(fsc->filp_gen))
>>>    		return -EBADF;
>>>    
>>> @@ -2896,7 +2895,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
>>>    
>>>    	while (true) {
>>>    		flags &= CEPH_FILE_MODE_MASK;
>>> -		if (atomic_read(&fi->num_locks))
>>> +		if (fi && atomic_read(&fi->num_locks))
>>>    			flags |= CHECK_FILELOCK;
>>>    		_got = 0;
>>>    		ret = try_get_cap_refs(inode, need, want, endoff,
>>> @@ -2941,7 +2940,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
>>>    				continue;
>>>    		}
>>>    
>>> -		if ((fi->fmode & CEPH_FILE_MODE_WR) &&
>>> +		if (fi && (fi->fmode & CEPH_FILE_MODE_WR) &&
>>>    		    fi->filp_gen != READ_ONCE(fsc->filp_gen)) {
>>>    			if (ret >= 0 && _got)
>>>    				ceph_put_cap_refs(ci, _got);
>>> @@ -3004,6 +3003,14 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
>>>    	return 0;
>>>    }
>>>    
>>> +int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got)
>>> +{
>>> +	struct ceph_file_info *fi = filp->private_data;
>>> +	struct inode *inode = file_inode(filp);
>>> +
>>> +	return __ceph_get_caps(inode, fi, need, want, endoff, got);
>>> +}
>>> +
>>>    /*
>>>     * Take cap refs.  Caller must already know we hold at least one ref
>>>     * on the caps in question or we don't know this is safe.
>>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>>> index 7f3976b3319d..027d5f579ba0 100644
>>> --- a/fs/ceph/super.h
>>> +++ b/fs/ceph/super.h
>>> @@ -1208,6 +1208,8 @@ extern int ceph_encode_dentry_release(void **p, struct dentry *dn,
>>>    				      struct inode *dir,
>>>    				      int mds, int drop, int unless);
>>>    
>>> +extern int __ceph_get_caps(struct inode *inode, struct ceph_file_info *fi,
>>> +			   int need, int want, loff_t endoff, int *got);
>>>    extern int ceph_get_caps(struct file *filp, int need, int want,
>>>    			 loff_t endoff, int *got);
>>>    extern int ceph_try_get_caps(struct inode *inode,

