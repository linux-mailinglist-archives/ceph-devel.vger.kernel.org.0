Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 168D65A596F
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Aug 2022 04:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiH3Cac (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Aug 2022 22:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiH3Caa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Aug 2022 22:30:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94D8474E3
        for <ceph-devel@vger.kernel.org>; Mon, 29 Aug 2022 19:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661826626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1f2ODq2lEPmH0/crJMegtqDNzg0u91vSPDp3nqdFCzM=;
        b=fryRcXmc7LSxp6S8zaXX5MBemmVXR1s6eTHVsdE9NSZchBLxE6TB7IR7NcvHWpSgDNl1lZ
        KS9wdB7is5Ugm+q+fDrSTVI0zdIKiFZf0c/C+jVj/tAZU61o7mv8pXEReWETwDcIQVu4Es
        waZEIGMG2nfcYTe4wd6hKIxqh8aSvnY=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-549-WIhrTpI8OnyrOmwkKdqaAw-1; Mon, 29 Aug 2022 22:30:25 -0400
X-MC-Unique: WIhrTpI8OnyrOmwkKdqaAw-1
Received: by mail-pf1-f200.google.com with SMTP id i74-20020a62874d000000b005381588912bso2157944pfe.0
        for <ceph-devel@vger.kernel.org>; Mon, 29 Aug 2022 19:30:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=1f2ODq2lEPmH0/crJMegtqDNzg0u91vSPDp3nqdFCzM=;
        b=jCGBH0i+h/SPnn29nKHQWBWA+nguTcFoX7i/ddyZkZIJalkawrtYbI+jdn/5HcQEXZ
         lPEmLnHpgFSpksqfMEEbn57CurOK8T/uqY8HJAUO/eRRHqaIRppP9+R8z2dUbeNtg1nc
         WyantZ4XgQZkZbpkZygDh6ZWe8tTal0nA/oAJX3FVTpPZgP4mui0u/ONHeHa+6hiP0uc
         9rcA/spzlC8j+DV++AtuxgIHuD/sYzu9fHA7+eq5MeHWqnyfH0sT/ClS9v5sb0IvjrJs
         U0djuq4/BtG7DIt9NVsU0bbQVoxgZL/ZhTqEpGO8Q9puIa8lGInuJda2365A8Xxjr5mR
         cXMA==
X-Gm-Message-State: ACgBeo2A/Qa67a12QWUmssX0jCnjPgEksU3e1FeuRTPO8GmUKl/dn1uN
        Cz1OrFXANO2FO+XD77mVigF/k+ww8YF0USr+PcOXbv8XzmooJBQ7qhe4owifzf+Q73lWWw8xTII
        YzONbNdPp2dSxXoQDuipY+g==
X-Received: by 2002:a17:902:e8d1:b0:172:9bc0:bc9d with SMTP id v17-20020a170902e8d100b001729bc0bc9dmr19284432plg.20.1661826623898;
        Mon, 29 Aug 2022 19:30:23 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6QcAqQJMsqNpFVkkPXTtsv2wvZPQ3R/7y+3PEO+3AijvWllMX9VTFmcukN+YOTj4+PKNKvjA==
X-Received: by 2002:a17:902:e8d1:b0:172:9bc0:bc9d with SMTP id v17-20020a170902e8d100b001729bc0bc9dmr19284414plg.20.1661826623582;
        Mon, 29 Aug 2022 19:30:23 -0700 (PDT)
Received: from [10.72.12.34] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 7-20020a621807000000b0052a297324cbsm7922930pfy.41.2022.08.29.19.30.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Aug 2022 19:30:23 -0700 (PDT)
Subject: Re: [PATCH v2] ceph: fail the open_by_handle_at() if the dentry is
 being unlinked
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
References: <20220829045728.488148-1-xiubli@redhat.com>
 <7ae458b7a4000ae6c4ee59dc6f0373490c9d7381.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <68425412-d0c7-6f6f-8982-8c18add75c9e@redhat.com>
Date:   Tue, 30 Aug 2022 10:30:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <7ae458b7a4000ae6c4ee59dc6f0373490c9d7381.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
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


On 8/30/22 2:17 AM, Jeff Layton wrote:
> On Mon, 2022-08-29 at 12:57 +0800, xiubli@redhat.com wrote:
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
>> URL: https://tracker.ceph.com/issues/56524
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V2:
>> - If the dentry was released and inode is evicted such as by dropping
>>    the caches, it will allocate a new dentry, which is also unhashed.
>>
>>
>>   fs/ceph/export.c | 17 ++++++++++++++++-
>>   1 file changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
>> index 0ebf2bd93055..5edc1d31cd79 100644
>> --- a/fs/ceph/export.c
>> +++ b/fs/ceph/export.c
>> @@ -182,6 +182,7 @@ struct inode *ceph_lookup_inode(struct super_block *sb, u64 ino)
>>   static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
>>   {
>>   	struct inode *inode = __lookup_inode(sb, ino);
>> +	struct dentry *dentry;
>>   	int err;
>>   
>>   	if (IS_ERR(inode))
>> @@ -197,7 +198,21 @@ static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
>>   		iput(inode);
>>   		return ERR_PTR(-ESTALE);
>>   	}
>> -	return d_obtain_alias(inode);
>> +
>> +	/*
>> +	 * -ESTALE if the dentry exists and is unhashed,
>> +	 * which should be being released
>> +	 */
>> +	dentry = d_find_any_alias(inode);
>> +	if (dentry && unlikely(d_unhashed(dentry))) {
>> +		dput(dentry);
>> +		return ERR_PTR(-ESTALE);
>> +	}
>> +
>> +	if (!dentry)
>> +		dentry = d_obtain_alias(inode);
>> +
>> +	return dentry;
>>   }
>>   
>>   static struct dentry *__snapfh_to_dentry(struct super_block *sb,
> This looks racy.
>
> Suppose we have 2 racing tasks calling __fh_to_dentry for the same
> inode. The first one races in and doesn't find anything. d_obtain alias
> creates a disconnected dentry and returns it. The next task then finds
> it, sees that it's disconnected and gets back -ESTALE.
>
> I think you may need to detect this situation in a different way.

Yeah, you're right. Locally I have another version of patch, which will 
add one di->flags bit, which is "CEPH_DENTRY_IS_UNLINKING".

If the file have hard links and there are more than one alias and one of 
them is being unlinked, shouldn't we make sure we will pick a normal one 
here ? If so we should iterate all the alias and filter out the being 
unlinked ones.

At the same time I found another issue for the "ceph_fh_to_dentry()". 
That is we never check the inode->i_generation like other filesystems, 
which will make sure the inode we are trying to open is the exactly the 
same one saved in userspace. The inode maybe deleted and created before 
this.

Thanks

Xiubo


