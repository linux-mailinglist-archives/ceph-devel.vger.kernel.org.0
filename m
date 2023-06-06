Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0EC7235A4
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jun 2023 05:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbjFFDP0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Jun 2023 23:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbjFFDPY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Jun 2023 23:15:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9BF118
        for <ceph-devel@vger.kernel.org>; Mon,  5 Jun 2023 20:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686021278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QOL0idvkrRhos2Uds6ZL1DvL+dRJt/kN4YRb1Z69tGw=;
        b=DqOTKP+vNzAQhjzt803mY7JVnJmJ8BdQ313XP/VXRdG3AHaYIsxYDEU0dSUclIS1Nl5SpE
        MjJh3JPbjMOy4g6IHh7drcvhAIzgTlDYvQOYvngdwMi5KzZkcrgFqfm3c/Ej/7+zUgpmUJ
        18OPyKB66guPhKRIKFUnCfAES+F8o2g=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-CRpcRLaZMp6p2h-rz7KE8A-1; Mon, 05 Jun 2023 23:14:34 -0400
X-MC-Unique: CRpcRLaZMp6p2h-rz7KE8A-1
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-558a4e869bcso2156950eaf.0
        for <ceph-devel@vger.kernel.org>; Mon, 05 Jun 2023 20:14:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686021274; x=1688613274;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QOL0idvkrRhos2Uds6ZL1DvL+dRJt/kN4YRb1Z69tGw=;
        b=fJqgPxS66HnphUzh8ZOl9vC3BterL4wFO/FN73e/l4dlY87Y4Vfv3uPWzYmm7V0piw
         ysz4PZDzvG0icxV/ST6Y52CX4yn5yiJVijt1Pme5qY7IQic+yrWnAHthLJYI7itad3GZ
         YxbwOS86fubAa5fZtgUJX2pRu+AaPB2MGtJiExvj+6oCGdNJY0yYcAsLrBfjjirTnQfA
         0f+xoMkBkmTmUCe2uW+Eo11i5SOcktaddjOGNXY+zmPF2JCuaTkV5TuRv1Gm1xU/Xi9O
         ULTNOnpWRZ0bHZzPJ3B6CqHFqQbXoHLOhlVx6wS7vTMyj6cUP80PdXVAlfseghPYfvE1
         MbKg==
X-Gm-Message-State: AC+VfDySDDNsBv5CamhiFwtVAGYAmfDJ9x/LZCbNcCBqyuyuaO354BUh
        Dbd9h7gOY5hI4oUvpd1/li9PD1+AxTqj+kcz/0Ggw9skOIOSYu+XeFpx9Tb8XgX/LtAN1NlFD1P
        +4It7aPo4dBfHU6rFbARwBQ==
X-Received: by 2002:a05:6358:c0a1:b0:129:bc2d:204d with SMTP id fa33-20020a056358c0a100b00129bc2d204dmr1164454rwb.29.1686021273998;
        Mon, 05 Jun 2023 20:14:33 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4Igc48HTgtIGkksAwWnzbDxBldlvjH6NdjAZIYbH8L7hrCx0AaAt1q990S2ZbqpYn2X37Bew==
X-Received: by 2002:a05:6358:c0a1:b0:129:bc2d:204d with SMTP id fa33-20020a056358c0a100b00129bc2d204dmr1164433rwb.29.1686021273631;
        Mon, 05 Jun 2023 20:14:33 -0700 (PDT)
Received: from [10.72.12.128] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b3-20020a17090a5a0300b00256833cd9a4sm6430756pjd.54.2023.06.05.20.14.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 20:14:33 -0700 (PDT)
Message-ID: <953dadb0-98cd-cab6-694f-ac62dd9bb298@redhat.com>
Date:   Tue, 6 Jun 2023 11:14:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] ceph: just wait the osd requests' callbacks to finish
 when unmounting
Content-Language: en-US
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com
References: <20230509084637.213326-1-xiubli@redhat.com>
 <871qiu2jcx.fsf@suse.de> <6f9af9e3-067a-6d98-7679-915a4a6aa474@redhat.com>
 <874jnm9cyi.fsf@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <874jnm9cyi.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/5/23 22:54, Luís Henriques wrote:
> Xiubo Li <xiubli@redhat.com> writes:
>
>> On 6/2/23 19:29, Luís Henriques wrote:
>>> xiubli@redhat.com writes:
>>>
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> The sync_filesystem() will flush all the dirty buffer and submit the
>>>> osd reqs to the osdc and then is blocked to wait for all the reqs to
>>>> finish. But the when the reqs' replies come, the reqs will be removed
>>>> from osdc just before the req->r_callback()s are called. Which means
>>>> the sync_filesystem() will be woke up by leaving the req->r_callback()s
>>>> are still running.
>>>>
>>>> This will be buggy when the waiter require the req->r_callback()s to
>>>> release some resources before continuing. So we need to make sure the
>>>> req->r_callback()s are called before removing the reqs from the osdc.
>>>>
>>>> WARNING: CPU: 4 PID: 168846 at fs/crypto/keyring.c:242 fscrypt_destroy_keyring+0x7e/0xd0
>>>> CPU: 4 PID: 168846 Comm: umount Tainted: G S  6.1.0-rc5-ceph-g72ead199864c #1
>>>> Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 2.0 12/17/2015
>>>> RIP: 0010:fscrypt_destroy_keyring+0x7e/0xd0
>>>> RSP: 0018:ffffc9000b277e28 EFLAGS: 00010202
>>>> RAX: 0000000000000002 RBX: ffff88810d52ac00 RCX: ffff88810b56aa00
>>>> RDX: 0000000080000000 RSI: ffffffff822f3a09 RDI: ffff888108f59000
>>>> RBP: ffff8881d394fb88 R08: 0000000000000028 R09: 0000000000000000
>>>> R10: 0000000000000001 R11: 11ff4fe6834fcd91 R12: ffff8881d394fc40
>>>> R13: ffff888108f59000 R14: ffff8881d394f800 R15: 0000000000000000
>>>> FS:  00007fd83f6f1080(0000) GS:ffff88885fd00000(0000) knlGS:0000000000000000
>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> CR2: 00007f918d417000 CR3: 000000017f89a005 CR4: 00000000003706e0
>>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>> Call Trace:
>>>> <TASK>
>>>> generic_shutdown_super+0x47/0x120
>>>> kill_anon_super+0x14/0x30
>>>> ceph_kill_sb+0x36/0x90 [ceph]
>>>> deactivate_locked_super+0x29/0x60
>>>> cleanup_mnt+0xb8/0x140
>>>> task_work_run+0x67/0xb0
>>>> exit_to_user_mode_prepare+0x23d/0x240
>>>> syscall_exit_to_user_mode+0x25/0x60
>>>> do_syscall_64+0x40/0x80
>>>> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>>> RIP: 0033:0x7fd83dc39e9b
>>>>
>>>> We need to increase the blocker counter to make sure all the osd
>>>> requests' callbacks have been finished just before calling the
>>>> kill_anon_super() when unmounting.
>>> (Sorry for taking so long replying to this patch!  And I've still a few
>>> others on the queue!)
>>>
>>> I've been looking at this patch and at patch "ceph: drop the messages from
>>> MDS when unmounting", but I still can't say whether they are correct or
>>> not.  They seem to be working, but they don't _look_ right.
>>>
>>> For example, mdsc->stopping is being used by ceph_dec_stopping_blocker()
>>> and ceph_inc_stopping_blocker() for setting the ceph_mds_client state, but
>>> the old usage for that field (e.g. in ceph_mdsc_pre_umount()) is being
>>> kept.  Is that correct?  Maybe, but it looks wrong: the old usage isn't
>>> protected by the spinlock and doesn't use the atomic counter.
>> This is okay, the spin lock "stopping_lock" is not trying to protect the
>> "stopping", and it's just trying to protect the "stopping_blockers" and the
>> order of accessing "fsc->mdsc->stopping" and "fsc->mdsc->stopping_blockers", you
>> can try without this you can reproduce it again.
>>
>>
>>> Another example: in patch "ceph: drop the messages from MDS when
>>> unmounting" we're adding calls to ceph_inc_stopping_blocker() in
>>> ceph_handle_caps(), ceph_handle_quota(), and ceph_handle_snap().  Are
>>> those the only places where this is needed?  Obviously not, because this
>>> new patch is adding extra calls in the read/write paths.  But maybe there
>>> are more places...?
>> I have gone through all the related code and this should be all the places,
>> which will grab the inode, we need to do this. You can confirm that.
>>
>>> And another one: changing ceph_inc_stopping_blocker() to accept NULL to
>>> distinguish between mds and osd requests makes things look even more
>>> hacky :-(
>> This can be improved.
>>
>> Let me update it to make it easier to read.
>>
>>> On the other end, I've been testing these patches thoroughly and couldn't
>>> see any issues with them.  And although I'm still not convinced that they
>>> will not deadlock in some corner cases, I don't have a better solution
>>> either for the problem they're solving.
>>>
>>> FWIW you can add my:
>>>
>>> Tested-by: Luís Henriques <lhenriques@suse.de>
>>>
>>> to this patch (the other one already has it), but I'll need to spend more
>>> time to see if there are better solutions.
>> Thanks Luis for your test and review.
> One final question:
>
> Would it be better to use wait_for_completion_timeout() in ceph_kill_sb()?

I will add one mount option at the same time for the umount timeout and 
switch to wait_for_completion_killable_timeout().


> I'm mostly worried with the read/write paths, of course.  For example, the
> complexity of function ceph_writepages_start() makes it easy to introduce
> a bug where we'll have an ceph_inc_stopping_blocker() without an
> ceph_dec_stopping_blocker().

This also could be improved, we can just skip submitting the requests in 
case failing to increase the counters.

>
> On the other hand, adding a timeout won't solve anything as we'll get the
> fscrypt warning in the unlikely even of timing-out; but maybe that's more
> acceptable than blocking the umount operation forever.  So, I'm not really
> sure it's worth it.

This sound reasonable to me.

Thanks Luis,

- Xiubo

> Cheers,

