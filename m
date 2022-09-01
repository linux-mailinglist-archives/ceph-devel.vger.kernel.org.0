Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA8D5A8A20
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Sep 2022 02:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbiIAA6Q (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 31 Aug 2022 20:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiIAA6P (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 31 Aug 2022 20:58:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8E2DD746
        for <ceph-devel@vger.kernel.org>; Wed, 31 Aug 2022 17:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661993893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0R8SVFiF8na6pYATGRJKoC8Q/wSeCd2n+32o8MhUsqE=;
        b=HTXVpxWf1zkFK/rfdzGgiTYNSE2TfYjpWjelpQGCcIwqVT6IeOK0ZtvEUuv//AOjcVzX8m
        Te6iFTqyRxjKTeOj6ge5os0yMeWxrt2UkZqn1RL499MMHK0qSfmMGZZtr1vAUJxoDHY02d
        +2hxie+9kRsDMyRXoZW6Pw1wkS9i9Iw=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-283-SWdt3h-yPxKBaBN0FMdi3w-1; Wed, 31 Aug 2022 20:58:09 -0400
X-MC-Unique: SWdt3h-yPxKBaBN0FMdi3w-1
Received: by mail-pj1-f70.google.com with SMTP id e1-20020a17090a7c4100b001fd7e8c4eb1so423134pjl.1
        for <ceph-devel@vger.kernel.org>; Wed, 31 Aug 2022 17:58:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date;
        bh=0R8SVFiF8na6pYATGRJKoC8Q/wSeCd2n+32o8MhUsqE=;
        b=LtFkbfyW2W6xOr5O6wMsxyMcn8dhgCwdj6jdHtJQbefuTlaujTulpWxZnQQ85+fw6Q
         yff4CgMZnpktWj/Ens9gPkUyj2mG+0GruhyDuEGNasUJfnnbx/2fgj8/GZkzYAHVX3uG
         UE7sOtLf+DAMdPXLvaL4hfOkdwINoF8YoUZx0/s1+m8H8btd67N8j48G6P6K65AvGWMs
         wUhK99S9m6GdyuXah8xFbRW3kwdRqIFzs5+ZX+SKsWK/RYF4k/vQqyvvjbLbhwWjgXZC
         9DcyYsmEjIh7wCXxACVVyLITGWophnHqoZI9AYY2v5T5lEksXQtUTia2XW7uBGEJi6mc
         V0tg==
X-Gm-Message-State: ACgBeo1W10GuWp4poQReZTRH5HfeqMbPtQtOeJexLoVVrhDIQ7lPQLFZ
        xQzaLcqGdpaAztinokT3s8/6QcEY9g2FJ96zfv/Rfis4yeH6XQ0tu9C0IAo+6f7Ae3T2WU7DHAj
        AL9qWrEltDtahgW64ZqgmuA==
X-Received: by 2002:a62:ea14:0:b0:535:c678:8106 with SMTP id t20-20020a62ea14000000b00535c6788106mr29075826pfh.9.1661993888642;
        Wed, 31 Aug 2022 17:58:08 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4e6mFTPjmCaFOESXYsjcMrIxu9XpiiPK+pSMB2ypuYBdP9j6Gb9T+hEiHkUm3tOgV/r0GGJw==
X-Received: by 2002:a62:ea14:0:b0:535:c678:8106 with SMTP id t20-20020a62ea14000000b00535c6788106mr29075807pfh.9.1661993888364;
        Wed, 31 Aug 2022 17:58:08 -0700 (PDT)
Received: from [10.72.12.34] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q9-20020a170902bd8900b0016f035dcd75sm12158042pls.193.2022.08.31.17.58.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Aug 2022 17:58:07 -0700 (PDT)
Subject: Re: [PATCH v3] ceph: fail the open_by_handle_at() if the dentry is
 being unlinked
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org, idryomov@gmail.com,
        mchangir@redhat.com
References: <20220831021617.11058-1-xiubli@redhat.com>
 <Yw9sfh8pqVwu1t5n@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <beae4a6e-c905-07aa-7626-39e5e6cc9900@redhat.com>
Date:   Thu, 1 Sep 2022 08:58:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Yw9sfh8pqVwu1t5n@suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/31/22 10:13 PM, Luís Henriques wrote:
> On Wed, Aug 31, 2022 at 10:16:17AM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When unlinking a file the kclient will send a unlink request to MDS
>> by holding the dentry reference, and then the MDS will return 2 replies,
>> which are unsafe reply and a deferred safe reply.
>>
>> After the unsafe reply received the kernel will return and succeed
>> the unlink request to user space apps.
>>
>> Only when the safe reply received the dentry's reference will be
>> released. Or the dentry will only be unhashed from dcache. But when
>> the open_by_handle_at() begins to open the unlinked files it will
>> succeed.
>>
>> The inode->i_count couldn't be used to check whether the inode is
>> opened or not.
>>
>> URL: https://tracker.ceph.com/issues/56524
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V3:
>> - The inode->i_count couldn't be correctly indicate that whether the
>>    file is opened or not.
>>
>> V2:
>> - If the dentry was released and inode is evicted such as by dropping
>>    the caches, it will allocate a new dentry, which is also unhashed.
>>
>>   fs/ceph/export.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
>> index 0ebf2bd93055..8559990a59a5 100644
>> --- a/fs/ceph/export.c
>> +++ b/fs/ceph/export.c
>> @@ -182,6 +182,7 @@ struct inode *ceph_lookup_inode(struct super_block *sb, u64 ino)
>>   static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
>>   {
>>   	struct inode *inode = __lookup_inode(sb, ino);
>> +	struct ceph_inode_info *ci = ceph_inode(inode);
>>   	int err;
>>   
>>   	if (IS_ERR(inode))
>> @@ -193,7 +194,7 @@ static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
>>   		return ERR_PTR(err);
>>   	}
>>   	/* -ESTALE if inode as been unlinked and no file is open */
>> -	if ((inode->i_nlink == 0) && (atomic_read(&inode->i_count) == 1)) {
>> +	if ((inode->i_nlink == 0) && !__ceph_is_file_opened(ci)) {
>>   		iput(inode);
>>   		return ERR_PTR(-ESTALE);
>>   	}
>> -- 
>> 2.36.0.rc1
>>
> Thanks, this seems be correct.  I was able to reproduce this locally, and
> I can confirm this patch fixes it.  (Although I had this fixed this in the
> past with 878dabb64117 and at that time it looked like it was fixed too.)

Yeah, this is much harder to reproduce since you last two fixes about 
this. Locally I need to make a change in the xfstests source code to 
trigger it easier or I may need half day or more to see it.

> Feel free to add my:
>
> Tested-by: Luís Henriques <lhenriques@suse.de>
> Reviewed-by: Luís Henriques <lhenriques@suse.de>

Thanks Luis and Jeff.

Updated this.

-- Xiubo


> Cheers,
> --
> Luís
>

