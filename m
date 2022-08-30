Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8B85A5BD4
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Aug 2022 08:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiH3G3o (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Aug 2022 02:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiH3G3n (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 Aug 2022 02:29:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3415A74E07
        for <ceph-devel@vger.kernel.org>; Mon, 29 Aug 2022 23:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661840981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=impt9ItCIJl9SSNlo0CJ3Pag4MujBbnFA0lWLhrytUE=;
        b=bw/y9bTxs1vreD6kJVDHoXBHQoeHbqLNFQyc5rfkmK89GmzruBgR7HyG1XYGWP5JKgXMOJ
        bhEzpnD1q31wgbNnN0C06UdgpzRUwq2LPx1WTnGAlAMQ9X+KA4yLLhAKUyIC87FBv+H8WB
        7Nh2oaS4ODAj8oQ22jtdAZWzNMBzr5s=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-106-oAp2zEPbPVy6S0aFyy964g-1; Tue, 30 Aug 2022 02:29:39 -0400
X-MC-Unique: oAp2zEPbPVy6S0aFyy964g-1
Received: by mail-pg1-f198.google.com with SMTP id i25-20020a635859000000b0042bbb74be8bso3176853pgm.5
        for <ceph-devel@vger.kernel.org>; Mon, 29 Aug 2022 23:29:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:references:cc:to:from:subject
         :x-gm-message-state:from:to:cc;
        bh=impt9ItCIJl9SSNlo0CJ3Pag4MujBbnFA0lWLhrytUE=;
        b=P6Q5u3MeNmlpmvydsY2iuQ7xyXiAVP5QTdazJniJHpKinIV+lMeqS2hrhdZ3JzNR18
         v/NPYevTEknjGavAf2LSKrnAcmKS1GsUfhN/h7peu+MxkLT7gptKMsoUg2K/1aUoHg51
         t01GN6VsrACl8dMZqPYKdPQuvvNI4KEyYXvfvxfi/dJ1o0aD1qoxlI2kaSDE11Xz9/jB
         LbfaZXmrnX0uDdG7QzqZtAuaZiDoKWYnPLlLY6oVFZUwS/NeCBT8A5bUtiLFQxKJLWvR
         a5FKu+M58rBASjRidNIsPwneTINTyXTdqQH+5f8Le2kbvwnn9fRy6jZ7BNsTl0DikENk
         59XA==
X-Gm-Message-State: ACgBeo2lp+Wd3txID2G/uNk8xXj1hwolziKAvzadygWDmly3p340qZUP
        9qg1j1+zgkEbtT4cYn8bKyx3gO9xL/vSBpx7IP6gJOEGECrrJLKFh1xg8qIB8iRVH5J4Pq/5ISl
        +z/w4Zrvbv1u+MFNadXUOpQ==
X-Received: by 2002:a05:6a00:cd:b0:535:d9e2:d137 with SMTP id e13-20020a056a0000cd00b00535d9e2d137mr1705245pfj.29.1661840978605;
        Mon, 29 Aug 2022 23:29:38 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5u5HnObHCv++g1kemot9LYQgZuf4M6RElyFj1Uj9qdw+TWPLZnhGHJSrmQhpm82umNCm6Kgg==
X-Received: by 2002:a05:6a00:cd:b0:535:d9e2:d137 with SMTP id e13-20020a056a0000cd00b00535d9e2d137mr1705233pfj.29.1661840978321;
        Mon, 29 Aug 2022 23:29:38 -0700 (PDT)
Received: from [10.72.12.34] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d33-20020a630e21000000b0042c012adf30sm826772pgl.2.2022.08.29.23.29.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Aug 2022 23:29:37 -0700 (PDT)
Subject: Re: [PATCH v2] ceph: fail the open_by_handle_at() if the dentry is
 being unlinked
From:   Xiubo Li <xiubli@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
References: <20220829045728.488148-1-xiubli@redhat.com>
 <7ae458b7a4000ae6c4ee59dc6f0373490c9d7381.camel@kernel.org>
 <68425412-d0c7-6f6f-8982-8c18add75c9e@redhat.com>
Message-ID: <9889ca8e-1cc7-7ffd-2732-45044c0fa1d3@redhat.com>
Date:   Tue, 30 Aug 2022 14:29:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <68425412-d0c7-6f6f-8982-8c18add75c9e@redhat.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/30/22 10:30 AM, Xiubo Li wrote:
>
> On 8/30/22 2:17 AM, Jeff Layton wrote:
>> On Mon, 2022-08-29 at 12:57 +0800, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> When unlinking a file the kclient will send a unlink request to MDS
>>> by holding the dentry reference, and then the MDS will return 2 
>>> replies,
>>> which are unsafe reply and a deferred safe reply.
>>>
>>> After the unsafe reply received the kernel will return and succeed
>>> the unlink request to user space apps.
>>>
>>> Only when the safe reply received the dentry's reference will be
>>> released. Or the dentry will only be unhashed from dcache. But when
>>> the open_by_handle_at() begins to open the unlinked files it will
>>> succeed.
>>>
>>> URL: https://tracker.ceph.com/issues/56524
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>
>>> V2:
>>> - If the dentry was released and inode is evicted such as by dropping
>>>    the caches, it will allocate a new dentry, which is also unhashed.
>>>
>>>
>>>   fs/ceph/export.c | 17 ++++++++++++++++-
>>>   1 file changed, 16 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
>>> index 0ebf2bd93055..5edc1d31cd79 100644
>>> --- a/fs/ceph/export.c
>>> +++ b/fs/ceph/export.c
>>> @@ -182,6 +182,7 @@ struct inode *ceph_lookup_inode(struct 
>>> super_block *sb, u64 ino)
>>>   static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
>>>   {
>>>       struct inode *inode = __lookup_inode(sb, ino);
>>> +    struct dentry *dentry;
>>>       int err;
>>>         if (IS_ERR(inode))
>>> @@ -197,7 +198,21 @@ static struct dentry *__fh_to_dentry(struct 
>>> super_block *sb, u64 ino)
>>>           iput(inode);
>>>           return ERR_PTR(-ESTALE);
>>>       }
>>> -    return d_obtain_alias(inode);
>>> +
>>> +    /*
>>> +     * -ESTALE if the dentry exists and is unhashed,
>>> +     * which should be being released
>>> +     */
>>> +    dentry = d_find_any_alias(inode);
>>> +    if (dentry && unlikely(d_unhashed(dentry))) {
>>> +        dput(dentry);
>>> +        return ERR_PTR(-ESTALE);
>>> +    }
>>> +
>>> +    if (!dentry)
>>> +        dentry = d_obtain_alias(inode);
>>> +
>>> +    return dentry;
>>>   }
>>>     static struct dentry *__snapfh_to_dentry(struct super_block *sb,
>> This looks racy.
>>
>> Suppose we have 2 racing tasks calling __fh_to_dentry for the same
>> inode. The first one races in and doesn't find anything. d_obtain alias
>> creates a disconnected dentry and returns it. The next task then finds
>> it, sees that it's disconnected and gets back -ESTALE.
>>
>> I think you may need to detect this situation in a different way.
>
> Yeah, you're right. Locally I have another version of patch, which 
> will add one di->flags bit, which is "CEPH_DENTRY_IS_UNLINKING".
>
> If the file have hard links and there are more than one alias and one 
> of them is being unlinked, shouldn't we make sure we will pick a 
> normal one here ? If so we should iterate all the alias and filter out 
> the being unlinked ones.
>
> At the same time I found another issue for the "ceph_fh_to_dentry()". 
> That is we never check the inode->i_generation like other filesystems, 
> which will make sure the inode we are trying to open is the exactly 
> the same one saved in userspace. The inode maybe deleted and created 
> before this.
>
It seems never happening for ceph. The MDS will make sure it won't reuse 
the freed ino#.

- Xiubo

> Thanks
>
> Xiubo
>
>

