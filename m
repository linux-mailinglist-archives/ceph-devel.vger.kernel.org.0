Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171B941E92B
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Oct 2021 10:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352839AbhJAInA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 1 Oct 2021 04:43:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30617 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229683AbhJAInA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 1 Oct 2021 04:43:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633077676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dhNIePRei7bZdcHXZbKSNX6qZ3ejOKhtUEFXAfOo+jU=;
        b=bnojhW5qVaXV0smAM6NTqw6MMzQg1kUOf0H0sVnUhk7jwi8g7/C6uID/BwSevAHVW0/r0w
        qFE82X04oCB0Bp3sVRQvjLIbF90eQTqSnR1CPcUkE3W5FMSSI+yrx7VlcBUmuEIQsNq00M
        3uEZYxxpQOv18/C2YJwZy5uNsb/fb7A=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-yokotSejMzmMrBJ6xUT7bQ-1; Fri, 01 Oct 2021 04:41:15 -0400
X-MC-Unique: yokotSejMzmMrBJ6xUT7bQ-1
Received: by mail-pf1-f198.google.com with SMTP id w6-20020a62dd06000000b0044bb97ced47so5638895pff.3
        for <ceph-devel@vger.kernel.org>; Fri, 01 Oct 2021 01:41:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=dhNIePRei7bZdcHXZbKSNX6qZ3ejOKhtUEFXAfOo+jU=;
        b=xwYdUs3nd9KTseqihC7QYRKdjTsqvW6vhwpovYQzM6y+gYoOY7pdIHvrzSuvUaY3Z5
         KeFQa1MyYRvIZFwpZxDUpBvGaWnUcfQSpI63rZ2aXLvUjg68hBqDy20tViHL/BG//Pu/
         X0HWCb7lH1l2RBrM/n1v3YXw5Yuo8LyYVZFt8BUZNf+wb3BqLVIWGah5Q/UvPxKAE2oR
         zFmfA9TkMPCpg/k8woud7Ztq3lHHGSnKp6VS620uKS5PYfBEzt++opjVP0ELFvf18Zks
         9Q29s29/0m/H7/UowHMweBnS4GPjIKmkFgp2SCyM8EZG9bjL0sv5dE/jcaHHlZDMv1tK
         7aeA==
X-Gm-Message-State: AOAM533hox0+XWvH5ObSL1K2FcuT0fXv7s3cvMt7u/WVDR4nVKHWvcpy
        QyzW7djWLeFHILk6xwnCvoYQ/8oTeNRRaT5z48Q9uGILPQkkj4I96pRJWwQofFyj4FkWf/qDxkz
        ArXFO5hQUfAzews3XYNEVuagasbYR+URnBD9fy/48eBXq4mMxdgOHwX1dDL5MRXzvo8ScMUc=
X-Received: by 2002:a17:90a:7d11:: with SMTP id g17mr12103680pjl.150.1633077673747;
        Fri, 01 Oct 2021 01:41:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCsCfcl8LCk5MrL4xlW+svRhe8YVZzkNWEMRKazkHCsAyWtRHQzOXA/wjMUWdjtU95kd+fcQ==
X-Received: by 2002:a17:90a:7d11:: with SMTP id g17mr12103650pjl.150.1633077673356;
        Fri, 01 Oct 2021 01:41:13 -0700 (PDT)
Received: from [10.72.12.53] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i24sm4807172pjl.8.2021.10.01.01.41.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 01:41:12 -0700 (PDT)
Subject: Re: [PATCH] ceph: buffer the truncate when size won't change with Fx
 caps issued
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210925085149.429710-1-xiubli@redhat.com>
 <550e38fbacfb539f55aa66bb9241c7825c8fc446.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d8b2757d-f5c5-e745-22fc-349b991f4f80@redhat.com>
Date:   Fri, 1 Oct 2021 16:41:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <550e38fbacfb539f55aa66bb9241c7825c8fc446.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 9/30/21 9:30 PM, Jeff Layton wrote:
> On Sat, 2021-09-25 at 16:51 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> If the new size is the same with current size, the MDS will do nothing
>> except changing the mtime/atime. We can just buffer the truncate in
>> this case.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/inode.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>> index 03530793c969..14989b961431 100644
>> --- a/fs/ceph/inode.c
>> +++ b/fs/ceph/inode.c
>> @@ -2370,7 +2370,7 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>>   		loff_t isize = i_size_read(inode);
>>   
>>   		dout("setattr %p size %lld -> %lld\n", inode, isize, attr->ia_size);
>> -		if ((issued & CEPH_CAP_FILE_EXCL) && attr->ia_size > isize) {
>> +		if ((issued & CEPH_CAP_FILE_EXCL) && attr->ia_size >= isize) {
>>   			i_size_write(inode, attr->ia_size);
>>   			inode->i_blocks = calc_inode_blocks(attr->ia_size);
>>   			ci->i_reported_size = attr->ia_size;
> I wonder if we ought to just ignore the attr->ia_size == isize case
> altogether instead? Truncating to the same size should be a no-op, so we
> shouldn't even need to dirty caps or anything.
>
> Thoughts?

I agree with it. Really it's doing nothing except updating the 
atime/mtime. Currently this patch will just delay doing that.

In some filesystems they will ignore it by doing nothing in this case. 
And some others may will try to release the preallocated blocks in the 
lower layer in this case, this makes no sense for ceph.

