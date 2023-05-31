Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A797717FED
	for <lists+ceph-devel@lfdr.de>; Wed, 31 May 2023 14:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbjEaMa5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 31 May 2023 08:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbjEaMa4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 31 May 2023 08:30:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803478E
        for <ceph-devel@vger.kernel.org>; Wed, 31 May 2023 05:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685536212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yH7kDZ+wFzF7aRzVNhfdmUJ4IGjCjBHrOwpgvaY4wRE=;
        b=djuruahyZXJfkJHf3W61Es7eLbO0DI0ZeoGA43RpXKWNUhZbgVIE5HX9roIRxdAkkvtrSd
        r9PuNaW/hxvJfJzWpgCUQCBfvE6dsxbfX30Yca7+MIz7JiUHypAu16jLyObvY89q6tOJDh
        S8Nl+D7rvHHXswcMAGn+01ZFbUXOZLA=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-UFQs5uWVNvy3XqZ4BsmUxw-1; Wed, 31 May 2023 08:30:11 -0400
X-MC-Unique: UFQs5uWVNvy3XqZ4BsmUxw-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-53fa6346e9dso1188886a12.2
        for <ceph-devel@vger.kernel.org>; Wed, 31 May 2023 05:30:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685536210; x=1688128210;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yH7kDZ+wFzF7aRzVNhfdmUJ4IGjCjBHrOwpgvaY4wRE=;
        b=Hczh+47KCt3Z3D2oYPd1A07quQrD7uKwtkNaVAh8/vpoMfwGmt6HIiR5Hsvn5DrtfQ
         tr5Gwhed8t5Nc1hD20DRzHUBNK844GHsndPqLtXoaJyf8Z2SjYTcwm12AF8JHt+SRLGT
         QQYcPe4FzpntcLaPewrtOal2QtgUg4l+1W+t833SzvrO1xHaRqZB1PH9zhzHvyYXZc0I
         asq7y0cUuu+maGWLVW5fbqiCazE0JJHXbvtl946MN/ioPdMbLho49rO10q8C3BAxzQ1j
         VLEYN7aulGkeiQcgg/mLtrXSvEEnw9FTe3SSrd4p+lMU5zs7hP0PXLJrahc3qooTmsXq
         kylQ==
X-Gm-Message-State: AC+VfDzbPCpWwVPG/VZM1MeRrh+L1HfV/odxfoTzMwgKdKX5hScNsLRg
        6ZRY5CLzyDn0nqiQt+pdMWFg3jpo0RZQwN874FwKIDbGZes2ibhZFLp5ReGweaE4C2L3TvaU1yg
        /Y1LNM+G5UMNDnegZ3OMEnhwzaj6RA4tp
X-Received: by 2002:a05:6a20:441f:b0:10e:d90f:35d5 with SMTP id ce31-20020a056a20441f00b0010ed90f35d5mr5583556pzb.51.1685536210142;
        Wed, 31 May 2023 05:30:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7C0wATNaMIj2YXuV3bDC7VwLEnTQtY1dUNErvuxPLf03ezsIOuq1+T42Ank7kxZKPRyJbhJQ==
X-Received: by 2002:a05:6a20:441f:b0:10e:d90f:35d5 with SMTP id ce31-20020a056a20441f00b0010ed90f35d5mr5583535pzb.51.1685536209777;
        Wed, 31 May 2023 05:30:09 -0700 (PDT)
Received: from [10.72.12.188] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id g22-20020aa78756000000b0064d48d98260sm3063909pfo.156.2023.05.31.05.30.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 05:30:09 -0700 (PDT)
Message-ID: <df8cfbc7-c48f-0080-4519-c3cade2a6bf0@redhat.com>
Date:   Wed, 31 May 2023 20:30:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] ceph: fix use-after-free bug for inodes when flushing
 capsnaps
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, stable@vger.kernel.org
References: <20230525024438.507082-1-xiubli@redhat.com>
 <CAOi1vP8aR=fnbUnpOSJ1yA6Je5c4tS3Ks4xMb10dymYv+y2EgQ@mail.gmail.com>
 <5e82e988-fa03-c580-dc53-0ffdbbc944f5@redhat.com>
 <CAOi1vP_nX659D-jNThVx3wr63zpiWeSf7-ZE9UJ4V0gdCutOJw@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP_nX659D-jNThVx3wr63zpiWeSf7-ZE9UJ4V0gdCutOJw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/31/23 20:01, Ilya Dryomov wrote:
> On Wed, May 31, 2023 at 1:33 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 5/31/23 19:09, Ilya Dryomov wrote:
>>> On Thu, May 25, 2023 at 4:45 AM <xiubli@redhat.com> wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> There is racy between capsnaps flush and removing the inode from
>>>> 'mdsc->snap_flush_list' list:
>>>>
>>>>      Thread A                            Thread B
>>>> ceph_queue_cap_snap()
>>>>    -> allocate 'capsnapA'
>>>>    ->ihold('&ci->vfs_inode')
>>>>    ->add 'capsnapA' to 'ci->i_cap_snaps'
>>>>    ->add 'ci' to 'mdsc->snap_flush_list'
>>>>       ...
>>>> ceph_flush_snaps()
>>>>    ->__ceph_flush_snaps()
>>>>     ->__send_flush_snap()
>>>>                                   handle_cap_flushsnap_ack()
>>>>                                    ->iput('&ci->vfs_inode')
>>>>                                      this also will release 'ci'
>>>>                                       ...
>>>>                                   ceph_handle_snap()
>>>>                                    ->flush_snaps()
>>>>                                     ->iterate 'mdsc->snap_flush_list'
>>>>                                      ->get the stale 'ci'
>>>>    ->remove 'ci' from                ->ihold(&ci->vfs_inode) this
>>>>      'mdsc->snap_flush_list'           will WARNING
>>>>
>>>> To fix this we will remove the 'ci' from 'mdsc->snap_flush_list'
>>>> list just before '__send_flush_snaps()' to make sure the flushsnap
>>>> 'ack' will always after removing the 'ci' from 'snap_flush_list'.
>>> Hi Xiubo,
>>>
>>> I'm not sure I'm following the logic here.  If the issue is that the
>>> inode can be released by handle_cap_flushsnap_ack(), meaning that ci is
>>> unsafe to dereference after the ack is received, what makes e.g. the
>>> following snippet in __ceph_flush_snaps() work:
>>>
>>>       ret = __send_flush_snap(inode, session, capsnap, cap->mseq,
>>>                               oldest_flush_tid);
>>>       if (ret < 0) {
>>>               pr_err("__flush_snaps: error sending cap flushsnap, "
>>>                      "ino (%llx.%llx) tid %llu follows %llu\n",
>>>                       ceph_vinop(inode), cf->tid, capsnap->follows);
>>>       }
>>>
>>>       ceph_put_cap_snap(capsnap);
>>>       spin_lock(&ci->i_ceph_lock);
>>>
>>> If the ack is handled after capsnap is put but before ci->i_ceph_lock
>>> is reacquired, could use-after-free occur inside spin_lock()?
>> Yeah, certainly this could happen.
>>
>> After the 'ci' being freed it's possible that the 'ci' is still cached
>> in the 'ceph_inode_cachep' slab caches or reused by others, so
>> dereferring the 'ci' mostly won't crash. But just before freeing 'ci'
> Dereferencing an invalid pointer is a major bug regardless of whether
> it leads to a crash.  Crashing fast is actually a pretty good case as
> far as potential outcomes go.
>
> This needs to be addressed: just removing ci from mdsc->snap_flush_list
> earlier obviously doesn't cut it.

This could make sure that the 'ci' will be remove from the 
'mdsc->snap_flush_list' list before the ack.

While there is another method to fix this, which is to increase the 
'i_count' instead when adding the 'ci' to the 'mdsc->snap_flush_list' 
list. This one seems safer ?

Thanks

- Xiubo


> Thanks,
>
>                  Ilya
>

