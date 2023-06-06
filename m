Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56521724474
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jun 2023 15:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237229AbjFFNa7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jun 2023 09:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbjFFNa6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jun 2023 09:30:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA163E6A
        for <ceph-devel@vger.kernel.org>; Tue,  6 Jun 2023 06:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686058210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kc05BFqLyCU2e2CV0ONH8N6xaZCCq9xxm2JAMN543CY=;
        b=EZJWo8UaD4oqEKNCuBl2q5eHri50xxR62brqrDDK1e6CLJtmtskDy6xldp2YAEfB0uf7PU
        orPsINMT9rD7tV3xxOEsrYqnLm6bkeLy0U8JKFR6Jen0JzKe0SAMVgZwtHntJ4w9mB4pRO
        4QFhQnsO9hqMi1Up6BG9P4Fs/wIjGmc=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-557-Ij-nETaRPhqJuCQ4rm6LXg-1; Tue, 06 Jun 2023 09:30:10 -0400
X-MC-Unique: Ij-nETaRPhqJuCQ4rm6LXg-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2566e9b14a4so5587665a91.2
        for <ceph-devel@vger.kernel.org>; Tue, 06 Jun 2023 06:30:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686058208; x=1688650208;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kc05BFqLyCU2e2CV0ONH8N6xaZCCq9xxm2JAMN543CY=;
        b=Z6XIVr5x1XL43oE9T6rvTTvPpV1TPAwJLBbO82g6P3bKJ3Wb+vDsbSFElkNWFuJRlc
         2BMSE/2eUJSdnXeeaGk4WxoPXzDwOx+4A9BRLlifAg+rbh2weJjMCLwmjpiIG92uWB0U
         R1Fld+qcfnjIBSONW/QZwod3qQYNW4kIcFDVJJFC2Ez7ZqWd6foyO7YYHQE4vD9v+HEZ
         Yujc3/kHIWq+EkXUYK37o8/80RjR57D+vKzMdB76/M7t2b+oW1DBjYE+Ag3pdAl1EF8O
         2B/cDlo7ZUfiwwYr0bpXVwiSQ/CZM2JufXU28ewxGgEsoolBKWO+yEfH9Cj41u1xjeDA
         lSIg==
X-Gm-Message-State: AC+VfDxMzCgbPpsn33IPUyDvNgBVEj5bSdr3b4XW1lmQXMgtyaeBTSdA
        iLzGUdcdhx+zAhQj29guFpX6gYIe5JdPrUxta5A/2WY8leadfovpwEzmBz3X8yCb7/HU8rxnw1T
        nBBPXQOpLMVqZJDlFwtx2ozjtL+jbxYO+
X-Received: by 2002:a17:90a:199d:b0:259:3e17:7e15 with SMTP id 29-20020a17090a199d00b002593e177e15mr2035913pji.7.1686058207722;
        Tue, 06 Jun 2023 06:30:07 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7J7ul/koMOF7Miwqh/LGXLelFn7h/dMC5InMnz9fKy06a2cKhGn7iJWHuXOTIxipyVUaylFg==
X-Received: by 2002:a17:90a:199d:b0:259:3e17:7e15 with SMTP id 29-20020a17090a199d00b002593e177e15mr2035895pji.7.1686058207369;
        Tue, 06 Jun 2023 06:30:07 -0700 (PDT)
Received: from [10.72.12.128] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h16-20020a17090ac39000b0024752ff8061sm7726359pjt.12.2023.06.06.06.30.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 06:30:07 -0700 (PDT)
Message-ID: <b0ec84e4-1999-8284-dc90-307831f1e04b@redhat.com>
Date:   Tue, 6 Jun 2023 21:29:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3] ceph: fix use-after-free bug for inodes when flushing
 capsnaps
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
References: <20230606005253.1055933-1-xiubli@redhat.com>
 <CAOi1vP_Xr6iMgjo7RKtc4-oZdF_FX7_U3Wx4Y=REdpa4Gj7Oig@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP_Xr6iMgjo7RKtc4-oZdF_FX7_U3Wx4Y=REdpa4Gj7Oig@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/6/23 18:21, Ilya Dryomov wrote:
> On Tue, Jun 6, 2023 at 2:55 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> There is a race between capsnaps flush and removing the inode from
>> 'mdsc->snap_flush_list' list:
>>
>>     == Thread A ==                     == Thread B ==
>> ceph_queue_cap_snap()
>>   -> allocate 'capsnapA'
>>   ->ihold('&ci->vfs_inode')
>>   ->add 'capsnapA' to 'ci->i_cap_snaps'
>>   ->add 'ci' to 'mdsc->snap_flush_list'
>>      ...
>>     == Thread C ==
>> ceph_flush_snaps()
>>   ->__ceph_flush_snaps()
>>    ->__send_flush_snap()
>>                                  handle_cap_flushsnap_ack()
>>                                   ->iput('&ci->vfs_inode')
>>                                     this also will release 'ci'
>>                                      ...
>>                                        == Thread D ==
>>                                  ceph_handle_snap()
>>                                   ->flush_snaps()
>>                                    ->iterate 'mdsc->snap_flush_list'
>>                                     ->get the stale 'ci'
>>   ->remove 'ci' from                ->ihold(&ci->vfs_inode) this
>>     'mdsc->snap_flush_list'           will WARNING
>>
>> To fix this we will increase the inode's i_count ref when adding 'ci'
>> to the 'mdsc->snap_flush_list' list.
>>
>> Cc: stable@vger.kernel.org
>> URL: https://bugzilla.redhat.com/show_bug.cgi?id=2209299
>> Reviewed-by: Milind Changire <mchangir@redhat.com>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V3:
>> - Fix two minor typo in commit comments.
>>
>>
>>
>>   fs/ceph/caps.c | 6 ++++++
>>   fs/ceph/snap.c | 4 +++-
>>   2 files changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index feabf4cc0c4f..7c2cb813aba4 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -1684,6 +1684,7 @@ void ceph_flush_snaps(struct ceph_inode_info *ci,
>>          struct inode *inode = &ci->netfs.inode;
>>          struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
>>          struct ceph_mds_session *session = NULL;
>> +       int put = 0;
> Hi Xiubo,
>
> Nit: renaming this variable to need_put and making it a bool would
> communicate the intent better.

Hi Ilya

Sure, will update it.

>>          int mds;
>>
>>          dout("ceph_flush_snaps %p\n", inode);
>> @@ -1728,8 +1729,13 @@ void ceph_flush_snaps(struct ceph_inode_info *ci,
>>                  ceph_put_mds_session(session);
>>          /* we flushed them all; remove this inode from the queue */
>>          spin_lock(&mdsc->snap_flush_lock);
>> +       if (!list_empty(&ci->i_snap_flush_item))
>> +               put++;
> What are the cases when ci is expected to not be on snap_flush_list
> list (and therefore there is no corresponding reference to put)?
>
> The reason I'm asking is that ceph_flush_snaps() is called from two
> other places directly (i.e. without iterating snap_flush_list list) and
> then __ceph_flush_snaps() is called from two yet other places.  The
> problem that we are presented with here is that __ceph_flush_snaps()
> effectively consumes a reference on ci.  Is ci protected from being
> freed by handle_cap_flushsnap_ack() very soon after __send_flush_snap()
> returns in all these other places?

There are 4 places will call the 'ceph_flush_snaps()':

Cscope tag: ceph_flush_snaps
    #   line  filename / context / line
    1   3221  fs/ceph/caps.c <<__ceph_put_cap_refs>>
              ceph_flush_snaps(ci, NULL);
    2   3336  fs/ceph/caps.c <<ceph_put_wrbuffer_cap_refs>>
              ceph_flush_snaps(ci, NULL);
    3   2243  fs/ceph/inode.c <<ceph_inode_work>>
              ceph_flush_snaps(ci, NULL);
    4    941  fs/ceph/snap.c <<flush_snaps>>
              ceph_flush_snaps(ci, &session);
Type number and <Enter> (q or empty cancels):

For #1 it will add the 'ci' to the 'mdsc->snap_flush_list' list by 
calling '__ceph_finish_cap_snap()' and then call the 
'ceph_flush_snaps()' directly or defer call it in the queue work in #3.

The #3 is the reason why we need the 'mdsc->snap_flush_list' list.

For #2 it won't add the 'ci' to the list because it will always call the 
'ceph_flush_snaps()' directly.

For #4 it will call 'ceph_flush_snaps()' by iterating the 
'mdsc->snap_flush_list' list just before the #3 being triggered.

The problem only exists in case of #1 --> #4, which will make the stale 
'ci' to be held in the 'mdsc->snap_flush_list' list after 'capsnap' and 
'ci' being freed. All the other cases are okay because the 'ci' will be 
protected by increasing the ref when allocating the 'capsnap' and will 
decrease the ref in 'handle_cap_flushsnap_ack()' when freeing the 'capsnap'.

Note: the '__ceph_flush_snaps()' won't increase the ref. The 
'handle_cap_flushsnap_ack()' will just try to decrease the ref and only 
in case the ref reaches to '0' will the 'ci' be freed.


Thanks

- Xiubo

> Thanks,
>
>                  Ilya
>

