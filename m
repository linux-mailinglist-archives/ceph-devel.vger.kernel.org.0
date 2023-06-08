Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3FBD7274BC
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jun 2023 04:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbjFHCIW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jun 2023 22:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbjFHCIV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jun 2023 22:08:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26E626A3
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 19:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686190054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cGbxdnE4kF02ZAat0YucTxFSuVc3j8XkEalI37UwAYo=;
        b=Budvlc3Leg2s+y4h3gFYYJZQ1MXN/O34pBL7Wxd8QPGXAafjaDt+BYJl1EyBFnUzaJKrzz
        tUKWTLWbIN7gbn6zOwecC/XZyViuIAKc7dpEbNNHxNslMBiXZdb61N+JGGOBVdwQ2OjkE7
        U/1cVw5YHccXAv24/6E/sgAykpizadE=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118-1194w7mvMaitN6gCdAZEAg-1; Wed, 07 Jun 2023 22:07:32 -0400
X-MC-Unique: 1194w7mvMaitN6gCdAZEAg-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-6540e7d7db6so14768b3a.1
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jun 2023 19:07:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686190052; x=1688782052;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cGbxdnE4kF02ZAat0YucTxFSuVc3j8XkEalI37UwAYo=;
        b=YqJz2z2na4AADgQcr2d6rywHi/bS21wXE+wVXso+30Ru3Q9LzUtmK+AQbftRmwHqkW
         HZI7y+ecZxj/9RNa9wQXsA/wguoCY0WkYCjboH7MoOOuEw4o4Y3AnTTbxkQc0k9vv8EO
         5Ek6OJP5Ik0W/pHr/3nJcLKpb4ksr3IlAW6m3V3OUhUi6NzFfJ++2lOV6mAuYiODMAjj
         axScXGr/WZ2JQ/mJdlqpGkYCwZu+RR9aD3X9961HfSG4a2kCFr5YcmhLxtcfRHqS89MW
         bwf5XzurVKELKjXQ/09y3qY+a/+xRtI2CBr2V877vfq+C7r0etbr216qdTnu9UyxqzrI
         yAiQ==
X-Gm-Message-State: AC+VfDy5AJstLKwiUscLyWR6ZLnzWCyg8p0b5zvQ8NSzM6grV1/Cd7on
        ENF+8FzLZlV+Hj/6O9eRhnxWhkV9NhM1ikUQHTfmIbKwZIE22qGu8Y267OfkXSQLunYzLOTtATl
        rbnPx2ssEcNS2VZjN6AJFPTMRwS7idPIN
X-Received: by 2002:a05:6a20:144e:b0:10c:49e:6c67 with SMTP id a14-20020a056a20144e00b0010c049e6c67mr3099493pzi.33.1686190051725;
        Wed, 07 Jun 2023 19:07:31 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7fCH/GCxnQ8Lw+Duf/tDRO1hR1DptB/ZSHIQ+Oca/DShTY6Spm+XO5HzqrSpMBoDMDzPNvWA==
X-Received: by 2002:a05:6a20:144e:b0:10c:49e:6c67 with SMTP id a14-20020a056a20144e00b0010c049e6c67mr3099482pzi.33.1686190051331;
        Wed, 07 Jun 2023 19:07:31 -0700 (PDT)
Received: from [10.72.13.135] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id jc22-20020a17090325d600b001a6f7744a27sm167810plb.87.2023.06.07.19.07.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 19:07:31 -0700 (PDT)
Message-ID: <eaa3e03d-2c12-9095-0533-cb5b19f0ef4d@redhat.com>
Date:   Thu, 8 Jun 2023 10:07:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v3] ceph: fix use-after-free bug for inodes when flushing
 capsnaps
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
References: <20230606005253.1055933-1-xiubli@redhat.com>
 <CAOi1vP_Xr6iMgjo7RKtc4-oZdF_FX7_U3Wx4Y=REdpa4Gj7Oig@mail.gmail.com>
 <b0ec84e4-1999-8284-dc90-307831f1e04b@redhat.com>
 <CAOi1vP_ma6pQ35FpG6wEYBhwxRXYB73vP-B1Jziji7zDodDpGQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP_ma6pQ35FpG6wEYBhwxRXYB73vP-B1Jziji7zDodDpGQ@mail.gmail.com>
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


On 6/7/23 16:03, Ilya Dryomov wrote:
> On Tue, Jun 6, 2023 at 3:30 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 6/6/23 18:21, Ilya Dryomov wrote:
>>> On Tue, Jun 6, 2023 at 2:55 AM <xiubli@redhat.com> wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> There is a race between capsnaps flush and removing the inode from
>>>> 'mdsc->snap_flush_list' list:
>>>>
>>>>      == Thread A ==                     == Thread B ==
>>>> ceph_queue_cap_snap()
>>>>    -> allocate 'capsnapA'
>>>>    ->ihold('&ci->vfs_inode')
>>>>    ->add 'capsnapA' to 'ci->i_cap_snaps'
>>>>    ->add 'ci' to 'mdsc->snap_flush_list'
>>>>       ...
>>>>      == Thread C ==
>>>> ceph_flush_snaps()
>>>>    ->__ceph_flush_snaps()
>>>>     ->__send_flush_snap()
>>>>                                   handle_cap_flushsnap_ack()
>>>>                                    ->iput('&ci->vfs_inode')
>>>>                                      this also will release 'ci'
>>>>                                       ...
>>>>                                         == Thread D ==
>>>>                                   ceph_handle_snap()
>>>>                                    ->flush_snaps()
>>>>                                     ->iterate 'mdsc->snap_flush_list'
>>>>                                      ->get the stale 'ci'
>>>>    ->remove 'ci' from                ->ihold(&ci->vfs_inode) this
>>>>      'mdsc->snap_flush_list'           will WARNING
>>>>
>>>> To fix this we will increase the inode's i_count ref when adding 'ci'
>>>> to the 'mdsc->snap_flush_list' list.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> URL: https://bugzilla.redhat.com/show_bug.cgi?id=2209299
>>>> Reviewed-by: Milind Changire <mchangir@redhat.com>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>
>>>> V3:
>>>> - Fix two minor typo in commit comments.
>>>>
>>>>
>>>>
>>>>    fs/ceph/caps.c | 6 ++++++
>>>>    fs/ceph/snap.c | 4 +++-
>>>>    2 files changed, 9 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>>> index feabf4cc0c4f..7c2cb813aba4 100644
>>>> --- a/fs/ceph/caps.c
>>>> +++ b/fs/ceph/caps.c
>>>> @@ -1684,6 +1684,7 @@ void ceph_flush_snaps(struct ceph_inode_info *ci,
>>>>           struct inode *inode = &ci->netfs.inode;
>>>>           struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
>>>>           struct ceph_mds_session *session = NULL;
>>>> +       int put = 0;
>>> Hi Xiubo,
>>>
>>> Nit: renaming this variable to need_put and making it a bool would
>>> communicate the intent better.
>> Hi Ilya
>>
>> Sure, will update it.
>>
>>>>           int mds;
>>>>
>>>>           dout("ceph_flush_snaps %p\n", inode);
>>>> @@ -1728,8 +1729,13 @@ void ceph_flush_snaps(struct ceph_inode_info *ci,
>>>>                   ceph_put_mds_session(session);
>>>>           /* we flushed them all; remove this inode from the queue */
>>>>           spin_lock(&mdsc->snap_flush_lock);
>>>> +       if (!list_empty(&ci->i_snap_flush_item))
>>>> +               put++;
>>> What are the cases when ci is expected to not be on snap_flush_list
>>> list (and therefore there is no corresponding reference to put)?
>>>
>>> The reason I'm asking is that ceph_flush_snaps() is called from two
>>> other places directly (i.e. without iterating snap_flush_list list) and
>>> then __ceph_flush_snaps() is called from two yet other places.  The
>>> problem that we are presented with here is that __ceph_flush_snaps()
>>> effectively consumes a reference on ci.  Is ci protected from being
>>> freed by handle_cap_flushsnap_ack() very soon after __send_flush_snap()
>>> returns in all these other places?
>> There are 4 places will call the 'ceph_flush_snaps()':
>>
>> Cscope tag: ceph_flush_snaps
>>      #   line  filename / context / line
>>      1   3221  fs/ceph/caps.c <<__ceph_put_cap_refs>>
>>                ceph_flush_snaps(ci, NULL);
>>      2   3336  fs/ceph/caps.c <<ceph_put_wrbuffer_cap_refs>>
>>                ceph_flush_snaps(ci, NULL);
>>      3   2243  fs/ceph/inode.c <<ceph_inode_work>>
>>                ceph_flush_snaps(ci, NULL);
>>      4    941  fs/ceph/snap.c <<flush_snaps>>
>>                ceph_flush_snaps(ci, &session);
>> Type number and <Enter> (q or empty cancels):
>>
>> For #1 it will add the 'ci' to the 'mdsc->snap_flush_list' list by
>> calling '__ceph_finish_cap_snap()' and then call the
>> 'ceph_flush_snaps()' directly or defer call it in the queue work in #3.
>>
>> The #3 is the reason why we need the 'mdsc->snap_flush_list' list.
>>
>> For #2 it won't add the 'ci' to the list because it will always call the
>> 'ceph_flush_snaps()' directly.
>>
>> For #4 it will call 'ceph_flush_snaps()' by iterating the
>> 'mdsc->snap_flush_list' list just before the #3 being triggered.
>>
>> The problem only exists in case of #1 --> #4, which will make the stale
>> 'ci' to be held in the 'mdsc->snap_flush_list' list after 'capsnap' and
>> 'ci' being freed. All the other cases are okay because the 'ci' will be
>> protected by increasing the ref when allocating the 'capsnap' and will
>> decrease the ref in 'handle_cap_flushsnap_ack()' when freeing the 'capsnap'.
>>
>> Note: the '__ceph_flush_snaps()' won't increase the ref. The
>> 'handle_cap_flushsnap_ack()' will just try to decrease the ref and only
>> in case the ref reaches to '0' will the 'ci' be freed.
> So my question is: are all __ceph_flush_snaps() callers guaranteed to
> hold an extra (i.e. one that is not tied to capsnap) reference on ci so
> that when handle_cap_flushsnap_ack() drops one that is tied to capsnap
> the reference count doesn't reach 0?  It sounds like you are confident
> that there is no issue with ceph_flush_snaps() callers, but it would be
> nice if you could confirm the same for bare __ceph_flush_snaps() call
> sites in caps.c.

Yeah, checked the code again carefully.  I am sure that when calling the 
'__ceph_flush_snaps()' it has already well handled the reference too.

Once the 'capsnap' is in 'ci->i_cap_snaps' list the inode's reference 
must have already been increased, please see 'ceph_queue_cap_snap()', 
which will allocate and insert 'capsnap' to this list.

Except the 'mdsc->snap_flush_list' list, the 'capsnap' will be added to 
three other lists, which are 'ci->i_cap_snaps', 'mdsc->cap_flush_list' 
and 'ci->i_cap_flush_list'.


  744 INIT_LIST_HEAD(&capsnap->cap_flush.i_list);      --> 
ci->i_cap_flush_list
  745 INIT_LIST_HEAD(&capsnap->cap_flush.g_list);    --> 
mdsc->cap_flush_list
  746 INIT_LIST_HEAD(&capsnap->ci_item);                   --> 
ci->i_cap_snaps


But 'capsnap' will be removed from them all just before freeing the 
'capsnap' and iput(inode), more detail please see:


   handle_cap_flushsnap_ack()
       -->  ceph_remove_capsnap()
             --> __ceph_remove_capsnap()
                  --> list_del_init(&capsnap->ci_item); // remove from 
'ci->i_cap_snaps' list
                  --> __detach_cap_flush_from_ci()         // remove 
from 'ci->i_cap_flush_list' list
                 --> __detach_cap_flush_from_mdsc()} // remove from 
'mdsc->cap_flush_list'
       --> ceph_put_cap_snap(capsnap)
       --> iput(inode)


The 'mdsc->cap_flush_list' list will be proected by 
'mdsc->cap_dirty_lock', so do not have any issue here.

So I am sure that just before 'capsnap' being freed the 'ci' won't 
released in the above case.

Thanks

- Xiubo

> Thanks,
>
>                  Ilya
>

