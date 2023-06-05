Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5B2721BC1
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jun 2023 03:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbjFEB6x (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 4 Jun 2023 21:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbjFEB6v (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 4 Jun 2023 21:58:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10EB9F
        for <ceph-devel@vger.kernel.org>; Sun,  4 Jun 2023 18:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685930288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9VClkkNHeK50sZ133Rwmt5NycO7pcbfGwaxw6ExSAj4=;
        b=XaTdKhSt7hYRIDD1dMNbo3juTmEUgBSN/SO8UMfCvpG4ODk3Dwc+OmbwoZjbkKB4WmsEge
        yGwP8HL6257dUWSCKV+44dwW74HllRs+7ryP12zycVtOHiWsuUUT2GbKWvez13+9a+aANl
        lZFXPpUic7zuujnj/Eiwc4acgc298zg=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-9qqVWeh1Pd-XgIrdxgvmoA-1; Sun, 04 Jun 2023 21:58:07 -0400
X-MC-Unique: 9qqVWeh1Pd-XgIrdxgvmoA-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-33bbffccf69so42294535ab.3
        for <ceph-devel@vger.kernel.org>; Sun, 04 Jun 2023 18:58:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685930287; x=1688522287;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9VClkkNHeK50sZ133Rwmt5NycO7pcbfGwaxw6ExSAj4=;
        b=FIWRH0hcMnpP1NgGJdLG8SqIyu5AkC7fJQh8Ox3g9i+svWYxCKhMQAOjQq3ZG78ZL7
         uJA5Go+a03DzD3CaSbAdO2YsbWkrqutkAXIYTMXXduxX5tBSzHKvPIzuPnONgfElJQjd
         cECx4x6Drg5lJ+hGlegQhftP+GWS5QNlJyWD7rvSGM4V97JXCjPQUfC/y31sqt6cNX2r
         g5AF5bMu2biylrykE59OpNn09MKWDKFh+Ej8wJUs31mUYYtxWWDjlnFOL+Czg/PeQ/PZ
         7TejPX1cZh9/JCe4xFfzdaD8vQcD53x7esqq6xmnHaZtWZ+JrmrGGvfWqV6/b8m9u/Gi
         cIDA==
X-Gm-Message-State: AC+VfDwTJcZdyoVa62zhnG07HNlKCx0DTSCqflDNeXt8/QJK9OXfP+Uv
        8ownioolYBCiCpc48ikEqYUsQ2xqGsOmS6WYogiaDRwmI2y7lw6oR0OYGWexb5sTzpnSat/qTc1
        nkMjy1H9SMgYamBayhnajVTNtPkvjyaUD
X-Received: by 2002:a92:d410:0:b0:331:7203:b8b0 with SMTP id q16-20020a92d410000000b003317203b8b0mr19987879ilm.3.1685930286850;
        Sun, 04 Jun 2023 18:58:06 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5jvmWmK/EZ1INnXQ/XsB5m3u10iK1oDT7X+4P0XdvETd3nzXEqGQQ+OiJAXbzxc27PUWzpcg==
X-Received: by 2002:a92:d410:0:b0:331:7203:b8b0 with SMTP id q16-20020a92d410000000b003317203b8b0mr19987726ilm.3.1685930284246;
        Sun, 04 Jun 2023 18:58:04 -0700 (PDT)
Received: from [10.72.12.216] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id v23-20020a62a517000000b0063d44634d8csm4125456pfm.71.2023.06.04.18.58.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jun 2023 18:58:03 -0700 (PDT)
Message-ID: <6f9af9e3-067a-6d98-7679-915a4a6aa474@redhat.com>
Date:   Mon, 5 Jun 2023 09:57:58 +0800
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
 <871qiu2jcx.fsf@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <871qiu2jcx.fsf@suse.de>
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


On 6/2/23 19:29, Luís Henriques wrote:
> xiubli@redhat.com writes:
>
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The sync_filesystem() will flush all the dirty buffer and submit the
>> osd reqs to the osdc and then is blocked to wait for all the reqs to
>> finish. But the when the reqs' replies come, the reqs will be removed
>> from osdc just before the req->r_callback()s are called. Which means
>> the sync_filesystem() will be woke up by leaving the req->r_callback()s
>> are still running.
>>
>> This will be buggy when the waiter require the req->r_callback()s to
>> release some resources before continuing. So we need to make sure the
>> req->r_callback()s are called before removing the reqs from the osdc.
>>
>> WARNING: CPU: 4 PID: 168846 at fs/crypto/keyring.c:242 fscrypt_destroy_keyring+0x7e/0xd0
>> CPU: 4 PID: 168846 Comm: umount Tainted: G S  6.1.0-rc5-ceph-g72ead199864c #1
>> Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 2.0 12/17/2015
>> RIP: 0010:fscrypt_destroy_keyring+0x7e/0xd0
>> RSP: 0018:ffffc9000b277e28 EFLAGS: 00010202
>> RAX: 0000000000000002 RBX: ffff88810d52ac00 RCX: ffff88810b56aa00
>> RDX: 0000000080000000 RSI: ffffffff822f3a09 RDI: ffff888108f59000
>> RBP: ffff8881d394fb88 R08: 0000000000000028 R09: 0000000000000000
>> R10: 0000000000000001 R11: 11ff4fe6834fcd91 R12: ffff8881d394fc40
>> R13: ffff888108f59000 R14: ffff8881d394f800 R15: 0000000000000000
>> FS:  00007fd83f6f1080(0000) GS:ffff88885fd00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007f918d417000 CR3: 000000017f89a005 CR4: 00000000003706e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>> <TASK>
>> generic_shutdown_super+0x47/0x120
>> kill_anon_super+0x14/0x30
>> ceph_kill_sb+0x36/0x90 [ceph]
>> deactivate_locked_super+0x29/0x60
>> cleanup_mnt+0xb8/0x140
>> task_work_run+0x67/0xb0
>> exit_to_user_mode_prepare+0x23d/0x240
>> syscall_exit_to_user_mode+0x25/0x60
>> do_syscall_64+0x40/0x80
>> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> RIP: 0033:0x7fd83dc39e9b
>>
>> We need to increase the blocker counter to make sure all the osd
>> requests' callbacks have been finished just before calling the
>> kill_anon_super() when unmounting.
> (Sorry for taking so long replying to this patch!  And I've still a few
> others on the queue!)
>
> I've been looking at this patch and at patch "ceph: drop the messages from
> MDS when unmounting", but I still can't say whether they are correct or
> not.  They seem to be working, but they don't _look_ right.
>
> For example, mdsc->stopping is being used by ceph_dec_stopping_blocker()
> and ceph_inc_stopping_blocker() for setting the ceph_mds_client state, but
> the old usage for that field (e.g. in ceph_mdsc_pre_umount()) is being
> kept.  Is that correct?  Maybe, but it looks wrong: the old usage isn't
> protected by the spinlock and doesn't use the atomic counter.

This is okay, the spin lock "stopping_lock" is not trying to protect the 
"stopping", and it's just trying to protect the "stopping_blockers" and 
the order of accessing "fsc->mdsc->stopping" and 
"fsc->mdsc->stopping_blockers", you can try without this you can 
reproduce it again.


>
> Another example: in patch "ceph: drop the messages from MDS when
> unmounting" we're adding calls to ceph_inc_stopping_blocker() in
> ceph_handle_caps(), ceph_handle_quota(), and ceph_handle_snap().  Are
> those the only places where this is needed?  Obviously not, because this
> new patch is adding extra calls in the read/write paths.  But maybe there
> are more places...?

I have gone through all the related code and this should be all the 
places, which will grab the inode, we need to do this. You can confirm that.

> And another one: changing ceph_inc_stopping_blocker() to accept NULL to
> distinguish between mds and osd requests makes things look even more
> hacky :-(

This can be improved.

Let me update it to make it easier to read.

>
> On the other end, I've been testing these patches thoroughly and couldn't
> see any issues with them.  And although I'm still not convinced that they
> will not deadlock in some corner cases, I don't have a better solution
> either for the problem they're solving.
>
> FWIW you can add my:
>
> Tested-by: Luís Henriques <lhenriques@suse.de>
>
> to this patch (the other one already has it), but I'll need to spend more
> time to see if there are better solutions.

Thanks Luis for your test and review.

- Xiubo

>
> Cheers,

