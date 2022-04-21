Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4B35098CB
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Apr 2022 09:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385677AbiDUHWI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Apr 2022 03:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243064AbiDUHWF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 21 Apr 2022 03:22:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 41367165BE
        for <ceph-devel@vger.kernel.org>; Thu, 21 Apr 2022 00:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650525555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6M4twLpFfHUxiJ4ybXXGDqz/g1AgL5CoZtp3XcrX9/k=;
        b=HcFB83r7Rrhk+uNQXoKSsWemyOcM5SbwTEYgV10SJ2wLZ520rHMH16wtNXFfw6ws5YLaw8
        N6VmMP+3cyyUaTUkrwNHfwJ6vdJZPIJArna4jN/YuiwzTiWKWr7eitL8JOQ8pXkmWtJ68d
        a0asZ4AB8Fuojs11vIpkxalSWWuWiYc=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-365-mO8HqhUXNfaLMhE9UIp4OQ-1; Thu, 21 Apr 2022 03:19:14 -0400
X-MC-Unique: mO8HqhUXNfaLMhE9UIp4OQ-1
Received: by mail-pl1-f198.google.com with SMTP id u8-20020a170903124800b0015195a5826cso2107751plh.4
        for <ceph-devel@vger.kernel.org>; Thu, 21 Apr 2022 00:19:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6M4twLpFfHUxiJ4ybXXGDqz/g1AgL5CoZtp3XcrX9/k=;
        b=QqIbltGo/sxmKGy7pjKoMrz7MMhTAgrmW+dpjrRbGthfrOA4+kMtQbHKUkthP1NJT3
         BcnOyfvyS/s6VKvFKk6fIYBLjyWgvhdkRAPkhORwIGuRwZOqALnjDgeN0mg4IdmTkreo
         Cym0JLefp+O8h9uGTW+Ey/kVHw2n/RfxmPh06yHFJIEp1wQxKdTMDB78hwJgXj5eVtnP
         5vWAUkkM3eMX512nB/dDxq5noW8LfDWOAYbaP1XbBXLFHPSeIbEkgM6I37/xMGilsMvv
         XerHGWA1dKQoFaUjsU9+n7p3GeWbDOeBLsd+HtARIMQCpiy1Cpva7Uc/9xCAGfrNtNMU
         EiXg==
X-Gm-Message-State: AOAM533XunyJQ+p64qIjjZV9kx8uxA0ezcs6zwfvk97mRGxNCs7BZ7UL
        0Qcq3pXhac71IwuOU3mn/aS/dgKNtekCV6T9GSWJGO0ql3uOpcl0h2yYQY4Hz2C0bOsvyBvfQia
        6JPjee0zW2VLpUjXuGVOc9A==
X-Received: by 2002:a62:ed0e:0:b0:4fa:11ed:2ad1 with SMTP id u14-20020a62ed0e000000b004fa11ed2ad1mr27550120pfh.34.1650525552777;
        Thu, 21 Apr 2022 00:19:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+9NGblz+MpWiyZutqVVG0lHQmII+1m9ant71KLWeqX4IiJsuw14IDZtluppvd6C9S/M58/g==
X-Received: by 2002:a62:ed0e:0:b0:4fa:11ed:2ad1 with SMTP id u14-20020a62ed0e000000b004fa11ed2ad1mr27550101pfh.34.1650525552510;
        Thu, 21 Apr 2022 00:19:12 -0700 (PDT)
Received: from [10.72.12.77] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c138-20020a624e90000000b005081f92826dsm22824735pfb.99.2022.04.21.00.18.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 00:19:11 -0700 (PDT)
Subject: Re: [RFC PATCH] ceph: disable updating the atime since cephfs won't
 maintain it
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Gregory Farnum <gfarnum@redhat.com>
References: <20220420052404.1144209-1-xiubli@redhat.com>
 <5b6832315f8561010bb2a7dd93638752ebf8166b.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <57af3b8d-5899-8812-8f55-34155cd92a58@redhat.com>
Date:   Thu, 21 Apr 2022 15:18:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <5b6832315f8561010bb2a7dd93638752ebf8166b.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/20/22 9:56 PM, Jeff Layton wrote:
> On Wed, 2022-04-20 at 13:24 +0800, Xiubo Li wrote:
>> Since the cephFS makes no attempt to maintain atime, we shouldn't
>> try to update it in mmap and generic read cases and ignore updating
>> it in direct and sync read cases.
>>
>> And even we update it in mmap and generic read cases we will drop
>> it and won't sync it to MDS. And we are seeing the atime will be
>> updated and then dropped to the floor again and again.
>>
>> URL: https://lists.ceph.io/hyperkitty/list/ceph-users@ceph.io/thread/VSJM7T4CS5TDRFF6XFPIYMHP75K73PZ6/
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/addr.c  | 1 -
>>   fs/ceph/super.c | 1 +
>>   2 files changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index aa25bffd4823..02722ac86d73 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -1774,7 +1774,6 @@ int ceph_mmap(struct file *file, struct vm_area_struct *vma)
>>   
>>   	if (!mapping->a_ops->readpage)
>>   		return -ENOEXEC;
>> -	file_accessed(file);
>>   	vma->vm_ops = &ceph_vmops;
>>   	return 0;
>>   }
>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> index e6987d295079..b73b4f75462c 100644
>> --- a/fs/ceph/super.c
>> +++ b/fs/ceph/super.c
>> @@ -1119,6 +1119,7 @@ static int ceph_set_super(struct super_block *s, struct fs_context *fc)
>>   	s->s_time_gran = 1;
>>   	s->s_time_min = 0;
>>   	s->s_time_max = U32_MAX;
>> +	s->s_flags |= SB_NODIRATIME | SB_NOATIME;
>>   
>>   	ret = set_anon_super_fc(s, fc);
>>   	if (ret != 0)
> (cc'ing Greg since he claimed this...)
>
> I confess, I've never dug into the MDS code that should track atime, but
> I'm rather surprised that the MDS just drops those updates onto the
> floor.
>
> It's obviously updated when the mtime changes. The SETATTR operation
> allows the client to set the atime directly, and there is an "atime"
> slot in the cap structure that does get populated by the client. I guess
> though that it has never been 100% clear what cap the atime should be
> governed by so maybe it just always ignores that field?
>
> Anyway, I've no firm objection to this since no one in their right mind
> should use the atime anyway, but you may see some complaints if you just
> turn it off like this. There are some applications that use it.
> Hopefully no one is running those on ceph.
>
> It would be nice to document this somewhere as well -- maybe on the ceph
> POSIX conformance page?
>
>      https://docs.ceph.com/en/latest/cephfs/posix/

Have update this in ceph PR https://github.com/ceph/ceph/pull/45979.

-- Xiubo


>

