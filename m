Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEE562BBDA
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Nov 2022 12:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbiKPL11 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Nov 2022 06:27:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233469AbiKPL01 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Nov 2022 06:26:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3993FD45
        for <ceph-devel@vger.kernel.org>; Wed, 16 Nov 2022 03:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668597383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Igi64m6bRBzBN7ghDkvWtflMRxSEKulyTYZQ8ScYA8g=;
        b=hxlCPVcPDKioLfpSlkJznxvsr/9SqO8My0/ZvkYK/x8I6XtGmYwxC17WhsWMtoiJBa6cKJ
        +IlfGBTA7udNFjqcLYPr+ot8qNj+tX0uuNwpEHNifrIdQkdXkpJsRonsWlXJrUNjyaerXD
        u58Ssx/G8cRDzQk1jbt8Z1C4zFQsos0=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-552-KGJOtSSrM_O0Jsqt4EwbgA-1; Wed, 16 Nov 2022 06:16:22 -0500
X-MC-Unique: KGJOtSSrM_O0Jsqt4EwbgA-1
Received: by mail-pf1-f200.google.com with SMTP id t10-20020aa7946a000000b0057193a6891eso8390807pfq.0
        for <ceph-devel@vger.kernel.org>; Wed, 16 Nov 2022 03:16:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Igi64m6bRBzBN7ghDkvWtflMRxSEKulyTYZQ8ScYA8g=;
        b=78YV73NBfksXtMdCjceL+g4eUkRThbc1vOM63AeljfEtudWm4pdxjhaXWbw2fKUA+H
         uZlLt4RfiWfmS8tWKYeCIF7+zpS0X4FK896xzBgUSglp5WQg3S4zR8dPPJWQAUzGXqXZ
         vMOVdu5pPei2tRUJ57zQ/9UBVAjk0SFvNBpKkMnA0zP3ycATCTNvFycyGzgsFB+/6jIc
         Mz/AOYcL4zSzrdft3aZaTdddQClexqdnMK+aOEOHDgjClgfFei6SJCZPDqZCmTjyO7Vl
         +4lQ3Bwc2d16zw9hgDapwkV28OqQ6EEmZJGNvooag8uxBOBMDL6ErHO2Kic9HJqA247k
         To6w==
X-Gm-Message-State: ANoB5plQjahCzigQzSu9q+NjeuFzk0JXtpZ9j0bRCd+cxNLFvadrY8ZA
        XbVV9q/X1I9zY5r6iFUqivHFxM+8Uwd0Exhbpx6OC23wfY29cgjoKyXMh5WYG2Xx69J6Pl6Qv8J
        tXoQM95MZYeuXhA9toAv49g==
X-Received: by 2002:a63:1c5f:0:b0:476:f119:40b2 with SMTP id c31-20020a631c5f000000b00476f11940b2mr904339pgm.330.1668597381117;
        Wed, 16 Nov 2022 03:16:21 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5db2pOh0sGz41Jivh7/P4YbC5GpBGpTos6azol0EkqmaylMl0nVqJ3Ye1Ws3xRWw67gjXEDQ==
X-Received: by 2002:a63:1c5f:0:b0:476:f119:40b2 with SMTP id c31-20020a631c5f000000b00476f11940b2mr904325pgm.330.1668597380854;
        Wed, 16 Nov 2022 03:16:20 -0800 (PST)
Received: from [10.72.12.148] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q28-20020aa7983c000000b005622f99579esm10533966pfl.160.2022.11.16.03.16.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 03:16:20 -0800 (PST)
Subject: Re: [RFC PATCH] filelock: new helper: vfs_file_has_locks
To:     Jeff Layton <jlayton@kernel.org>, chuck.lever@oracle.com
Cc:     linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
References: <20221114140747.134928-1-jlayton@kernel.org>
 <30355bc8aa4998cb48b34df958837a8f818ceeb0.camel@kernel.org>
 <54b90281-c575-5aee-e886-e4d7b50236f0@redhat.com>
 <4a8720c8a24a9b06adc40fdada9c621fd5d849df.camel@kernel.org>
 <a8c94ba5-c01f-3bb6-0b35-2aee06b9d6e7@redhat.com>
 <969b751761988e75b11a75b1f44171305019711a.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <4fac935b-8e33-2202-48c2-80bdfddc074e@redhat.com>
Date:   Wed, 16 Nov 2022 19:16:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <969b751761988e75b11a75b1f44171305019711a.camel@kernel.org>
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


On 16/11/2022 18:55, Jeff Layton wrote:
> On Wed, 2022-11-16 at 14:49 +0800, Xiubo Li wrote:
>> On 15/11/2022 22:40, Jeff Layton wrote:
>>
...
>>> +	spin_lock(&ctx->flc_lock);
>>> +	ret = !list_empty(&ctx->flc_posix) || !list_empty(&ctx->flc_flock);
>>> +	spin_unlock(&ctx->flc_lock);
>> BTW, is the spin_lock/spin_unlock here really needed ?
>>
> We could probably achieve the same effect with barriers, but I doubt
> it's worth it. The flc_lock only protects the lists in the
> file_lock_context, so it should almost always be uncontended.
>
I just see some other places where are also checking this don't use the 
spin lock.

Thanks,

- Xiubo

>>> +	return ret;
>>> +}
>>> +EXPORT_SYMBOL_GPL(vfs_inode_has_locks);
>>> +
>>>    #ifdef CONFIG_PROC_FS
>>>    #include <linux/proc_fs.h>
>>>    #include <linux/seq_file.h>
>>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>>> index e654435f1651..d6cb42b7e91c 100644
>>> --- a/include/linux/fs.h
>>> +++ b/include/linux/fs.h
>>> @@ -1170,6 +1170,7 @@ extern int locks_delete_block(struct file_lock *);
>>>    extern int vfs_test_lock(struct file *, struct file_lock *);
>>>    extern int vfs_lock_file(struct file *, unsigned int, struct file_lock *, struct file_lock *);
>>>    extern int vfs_cancel_lock(struct file *filp, struct file_lock *fl);
>>> +bool vfs_inode_has_locks(struct inode *inode);
>>>    extern int locks_lock_inode_wait(struct inode *inode, struct file_lock *fl);
>>>    extern int __break_lease(struct inode *inode, unsigned int flags, unsigned int type);
>>>    extern void lease_get_mtime(struct inode *, struct timespec64 *time);
>> All the others LGTM.
>>
>> Thanks.
>>
>> - Xiubo
>>
>>
> Thanks. I'll re-post it "officially" in a bit and will queue it up for
> v6.2.

