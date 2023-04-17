Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42796E3D1A
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Apr 2023 03:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjDQBJd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Apr 2023 21:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDQBJd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 16 Apr 2023 21:09:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D161BDD
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 18:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681693725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hJcMD9jhyLgKbj8mW43PakTpjV+U4CvStyeqPSu6vAw=;
        b=Vfcem0JK/XFuo2rS0MMJuKDyKpeXBv3k69Q/gNQ1h87bW0+5pxmrorG9Z4Tlmt4TIchssQ
        uBo2JCxBNcfGd1R33+sFpknJT/EF6XAHzqWFv+EMhLwS3Y0p57jrxdY5U4c1X2PvvNaG5o
        NkzxV9X3o0xgdIMkS2e24Rt1m7N/7uM=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-3ZcQXfbKOa2x1YvoREzfBw-1; Sun, 16 Apr 2023 21:08:42 -0400
X-MC-Unique: 3ZcQXfbKOa2x1YvoREzfBw-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-51b51394f32so278281a12.1
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 18:08:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681693721; x=1684285721;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hJcMD9jhyLgKbj8mW43PakTpjV+U4CvStyeqPSu6vAw=;
        b=fBQ+EqdCq77rDdPK1kkwgJiR8pAiatTjYlO+hlCMK5wB1nsaga8AjbUaXUwy0fbJda
         hnMjCv98QGw/LlJL3M95FECaCA5OyaRX1GLBK+jCwjuscxeosgdeN6dVfy62f5ejaGqI
         1X1oYKRLJT8/YC3GKFCCIwVsxr9VaO8Wj0ypZZNiBDHBuJfaLZtkEun/Q/cTbdkmbums
         Aa/tXBKMlAKDE59hsd64SOvvndS8sc6mOMAGaRe1qs7hsyENYzohnBWKV3FR2zLHnhDa
         hAHzzeZBVO4Of5tWrKi2tl1meESDXxB1IeO0EhMzIlmH7KG7HtI1N3pUJatiSAGNMRtO
         ylvQ==
X-Gm-Message-State: AAQBX9ewgGGmI/ULV0hbq2XQV95BWcXBmHCJlq8DmBLZM2PksWzr7L5J
        tbKKg1G9KLz9JXUjuOZRzbodZhc3f/4XauSkwhncgoMM65MDTdS/1oE5skKlpieXjsJrXzXBoJc
        n3zlGjtwUX0NWFk5EnJleAQ==
X-Received: by 2002:a05:6a00:a18:b0:63b:57cb:145f with SMTP id p24-20020a056a000a1800b0063b57cb145fmr17998856pfh.20.1681693721382;
        Sun, 16 Apr 2023 18:08:41 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y3mBFm91Nzu578zYPRZSb40dofV+R7ZNtvn3onkzwu4xPDEXD8HXcZ3n1telpP8vXi5LMmpg==
X-Received: by 2002:a05:6a00:a18:b0:63b:57cb:145f with SMTP id p24-20020a056a000a1800b0063b57cb145fmr17998835pfh.20.1681693721061;
        Sun, 16 Apr 2023 18:08:41 -0700 (PDT)
Received: from [10.72.12.181] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c2-20020aa78802000000b0063b7a0b9cc5sm3095897pfo.186.2023.04.16.18.08.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Apr 2023 18:08:40 -0700 (PDT)
Message-ID: <aace462d-3dee-0cc4-0ebf-825f0e23eff0@redhat.com>
Date:   Mon, 17 Apr 2023 09:08:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v18 67/71] libceph: defer removing the req from osdc just
 after req->r_callback
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, lhenriques@suse.de
References: <20230412110930.176835-1-xiubli@redhat.com>
 <20230412110930.176835-68-xiubli@redhat.com>
 <CAOi1vP_AY=R4w9BZbEXAZwr2MUNjJJXyWzji0EPSgbhL25ip=w@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP_AY=R4w9BZbEXAZwr2MUNjJJXyWzji0EPSgbhL25ip=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/17/23 03:49, Ilya Dryomov wrote:
> On Wed, Apr 12, 2023 at 1:15 PM <xiubli@redhat.com> wrote:
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
>> URL: https://tracker.ceph.com/issues/58126
>> Tested-by: Luís Henriques <lhenriques@suse.de>
>> Tested-by: Venky Shankar <vshankar@redhat.com>
>> Reviewed-by: Luís Henriques <lhenriques@suse.de>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   net/ceph/osd_client.c | 43 +++++++++++++++++++++++++++++++++++--------
>>   1 file changed, 35 insertions(+), 8 deletions(-)
>>
>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>> index 78b622178a3d..db3d93d3e692 100644
>> --- a/net/ceph/osd_client.c
>> +++ b/net/ceph/osd_client.c
>> @@ -2507,7 +2507,7 @@ static void submit_request(struct ceph_osd_request *req, bool wrlocked)
>>          __submit_request(req, wrlocked);
>>   }
>>
>> -static void finish_request(struct ceph_osd_request *req)
>> +static void __finish_request(struct ceph_osd_request *req)
>>   {
>>          struct ceph_osd_client *osdc = req->r_osdc;
>>
>> @@ -2516,12 +2516,6 @@ static void finish_request(struct ceph_osd_request *req)
>>
>>          req->r_end_latency = ktime_get();
>>
>> -       if (req->r_osd) {
>> -               ceph_init_sparse_read(&req->r_osd->o_sparse_read);
>> -               unlink_request(req->r_osd, req);
>> -       }
>> -       atomic_dec(&osdc->num_requests);
>> -
>>          /*
>>           * If an OSD has failed or returned and a request has been sent
>>           * twice, it's possible to get a reply and end up here while the
>> @@ -2532,13 +2526,46 @@ static void finish_request(struct ceph_osd_request *req)
>>          ceph_msg_revoke_incoming(req->r_reply);
>>   }
>>
>> +static void __remove_request(struct ceph_osd_request *req)
>> +{
>> +       struct ceph_osd_client *osdc = req->r_osdc;
>> +
>> +       dout("%s req %p tid %llu\n", __func__, req, req->r_tid);
>> +
>> +       if (req->r_osd) {
>> +               ceph_init_sparse_read(&req->r_osd->o_sparse_read);
>> +               unlink_request(req->r_osd, req);
>> +       }
>> +       atomic_dec(&osdc->num_requests);
>> +}
>> +
>> +static void finish_request(struct ceph_osd_request *req)
>> +{
>> +       __finish_request(req);
>> +       __remove_request(req);
>> +}
>> +
>>   static void __complete_request(struct ceph_osd_request *req)
>>   {
>> +       struct ceph_osd_client *osdc = req->r_osdc;
>> +       struct ceph_osd *osd = req->r_osd;
>> +
>>          dout("%s req %p tid %llu cb %ps result %d\n", __func__, req,
>>               req->r_tid, req->r_callback, req->r_result);
>>
>>          if (req->r_callback)
>>                  req->r_callback(req);
>> +
>> +       down_read(&osdc->lock);
>> +       if (osd) {
>> +               mutex_lock(&osd->lock);
>> +               __remove_request(req);
>> +               mutex_unlock(&osd->lock);
>> +       } else {
>> +               atomic_dec(&osdc->num_requests);
>> +       }
>> +       up_read(&osdc->lock);
> Hi Xiubo,
>
> I think it was highlighted before that this patch is wrong so I'm
> surprised to see it in this series, broken out and with a different
> subject.
>
> On top of changing long-standing behavior which is purposefully
> consistent with Objecter behavior in userspace, it also seems to
> introduce a race condition with ceph_osdc_cancel_request() which can
> lead, among other things, to a use-after-free on req.  Consider what
> would happen if the request is cancelled while the callback is running:
> since it would still be linked at that point, cancel_request() would be
> allowed to go through and eventually put the messenger's reference.

Okay, I may miss or misunderstand it in another thread.

Since the bug has been fixed by the following [68/71] patch, let's 
remove this.

Thanks

- Xiubo

> Thanks,
>
>                  Ilya
>

