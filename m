Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9270E1E429E
	for <lists+ceph-devel@lfdr.de>; Wed, 27 May 2020 14:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbgE0Mrw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 May 2020 08:47:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56924 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728513AbgE0Mrv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 May 2020 08:47:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590583670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kny5gpk/tyvczQjeAXkCFOeRV31o5z+jzt0kLHU8LPE=;
        b=BCl+sGTwTKVPSwvJM++kl85P+Sy7Mdc5sGtBryj/uSvSGqu5JSIe7ja5zDcuCfhnVY+Nk3
        FYT4oMgpwaUOJRnSY0FNrz1ZABsoemzSxIBZsojM97ALS1AAsgXj5bc0O0i0d2U5Fq79n+
        sOG203CXO2au0mnm/QussRTIrES9P8w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-9vmi_KXeOI-cSBYCr1JJ9Q-1; Wed, 27 May 2020 08:47:37 -0400
X-MC-Unique: 9vmi_KXeOI-cSBYCr1JJ9Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C92E107ACF7;
        Wed, 27 May 2020 12:47:36 +0000 (UTC)
Received: from [10.72.12.125] (ovpn-12-125.pek2.redhat.com [10.72.12.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4125F768AB;
        Wed, 27 May 2020 12:47:33 +0000 (UTC)
Subject: Re: [PATCH] ceph: make sure the mdsc->mutex is nested in s->s_mutex
 to fix dead lock
To:     Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <1589961079-27932-1-git-send-email-xiubli@redhat.com>
 <17832c6b42a2f3876190d8e85ce0380a0f38f541.camel@kernel.org>
 <CAOi1vP906qkoK=QvSB=R4iVfmeN9JjFXLNsPqNxohj3bpK8JpQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <6be48ac4-6743-e328-c1bf-fe2a8639a655@redhat.com>
Date:   Wed, 27 May 2020 20:47:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP906qkoK=QvSB=R4iVfmeN9JjFXLNsPqNxohj3bpK8JpQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/5/27 20:25, Ilya Dryomov wrote:
> On Wed, May 20, 2020 at 1:44 PM Jeff Layton <jlayton@kernel.org> wrote:
>> On Wed, 2020-05-20 at 03:51 -0400, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> The call trace:
>>>
>>> <6>[15981.740583] libceph: mon2 (1)10.72.36.245:40083 session lost, hunting for new mon
>>> <3>[16097.960293] INFO: task kworker/18:1:32111 blocked for more than 122 seconds.
>>> <3>[16097.960860]       Tainted: G            E     5.7.0-rc5+ #80
>>> <3>[16097.961332] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> <6>[16097.961868] kworker/18:1    D    0 32111      2 0x80004080
>>> <6>[16097.962151] Workqueue: ceph-msgr ceph_con_workfn [libceph]
>>> <4>[16097.962188] Call Trace:
>>> <4>[16097.962353]  ? __schedule+0x276/0x6e0
>>> <4>[16097.962359]  ? schedule+0x40/0xb0
>>> <4>[16097.962364]  ? schedule_preempt_disabled+0xa/0x10
>>> <4>[16097.962368]  ? __mutex_lock.isra.8+0x2b5/0x4a0
>>> <4>[16097.962460]  ? kick_requests+0x21/0x100 [ceph]
>>> <4>[16097.962485]  ? ceph_mdsc_handle_mdsmap+0x19c/0x5f0 [ceph]
>>> <4>[16097.962503]  ? extra_mon_dispatch+0x34/0x40 [ceph]
>>> <4>[16097.962523]  ? extra_mon_dispatch+0x34/0x40 [ceph]
>>> <4>[16097.962580]  ? dispatch+0x77/0x930 [libceph]
>>> <4>[16097.962602]  ? try_read+0x78b/0x11e0 [libceph]
>>> <4>[16097.962619]  ? __switch_to_asm+0x40/0x70
>>> <4>[16097.962623]  ? __switch_to_asm+0x34/0x70
>>> <4>[16097.962627]  ? __switch_to_asm+0x40/0x70
>>> <4>[16097.962631]  ? __switch_to_asm+0x34/0x70
>>> <4>[16097.962635]  ? __switch_to_asm+0x40/0x70
>>> <4>[16097.962654]  ? ceph_con_workfn+0x130/0x5e0 [libceph]
>>> <4>[16097.962713]  ? process_one_work+0x1ad/0x370
>>> <4>[16097.962717]  ? worker_thread+0x30/0x390
>>> <4>[16097.962722]  ? create_worker+0x1a0/0x1a0
>>> <4>[16097.962737]  ? kthread+0x112/0x130
>>> <4>[16097.962742]  ? kthread_park+0x80/0x80
>>> <4>[16097.962747]  ? ret_from_fork+0x35/0x40
>>> <3>[16097.962758] INFO: task kworker/25:1:1747 blocked for more than 122 seconds.
>>> <3>[16097.963233]       Tainted: G            E     5.7.0-rc5+ #80
>>> <3>[16097.963792] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> <6>[16097.964298] kworker/25:1    D    0  1747      2 0x80004080
>>> <6>[16097.964325] Workqueue: ceph-msgr ceph_con_workfn [libceph]
>>> <4>[16097.964331] Call Trace:
>>> <4>[16097.964340]  ? __schedule+0x276/0x6e0
>>> <4>[16097.964344]  ? schedule+0x40/0xb0
>>> <4>[16097.964347]  ? schedule_preempt_disabled+0xa/0x10
>>> <4>[16097.964351]  ? __mutex_lock.isra.8+0x2b5/0x4a0
>>> <4>[16097.964376]  ? handle_reply+0x33f/0x6f0 [ceph]
>>> <4>[16097.964407]  ? dispatch+0xa6/0xbc0 [ceph]
>>> <4>[16097.964429]  ? read_partial_message+0x214/0x770 [libceph]
>>> <4>[16097.964449]  ? try_read+0x78b/0x11e0 [libceph]
>>> <4>[16097.964454]  ? __switch_to_asm+0x40/0x70
>>> <4>[16097.964458]  ? __switch_to_asm+0x34/0x70
>>> <4>[16097.964461]  ? __switch_to_asm+0x40/0x70
>>> <4>[16097.964465]  ? __switch_to_asm+0x34/0x70
>>> <4>[16097.964470]  ? __switch_to_asm+0x40/0x70
>>> <4>[16097.964489]  ? ceph_con_workfn+0x130/0x5e0 [libceph]
>>> <4>[16097.964494]  ? process_one_work+0x1ad/0x370
>>> <4>[16097.964498]  ? worker_thread+0x30/0x390
>>> <4>[16097.964501]  ? create_worker+0x1a0/0x1a0
>>> <4>[16097.964506]  ? kthread+0x112/0x130
>>> <4>[16097.964511]  ? kthread_park+0x80/0x80
>>> <4>[16097.964516]  ? ret_from_fork+0x35/0x40
>>>
>>> URL: https://tracker.ceph.com/issues/45609
>>> Reported-by: "Yan, Zheng" <zyan@redhat.com>
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>   fs/ceph/mds_client.c | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>> index 6c283c5..0e0ab01 100644
>>> --- a/fs/ceph/mds_client.c
>>> +++ b/fs/ceph/mds_client.c
>>> @@ -3769,8 +3769,6 @@ static int encode_snap_realms(struct ceph_mds_client *mdsc,
>>>    * recovering MDS might have.
>>>    *
>>>    * This is a relatively heavyweight operation, but it's rare.
>>> - *
>>> - * called with mdsc->mutex held.
>>>    */
>>>   static void send_mds_reconnect(struct ceph_mds_client *mdsc,
>>>                               struct ceph_mds_session *session)
>>> @@ -4024,7 +4022,9 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>>>                            oldstate != CEPH_MDS_STATE_STARTING)
>>>                                pr_info("mds%d recovery completed\n", s->s_mds);
>>>                        kick_requests(mdsc, i);
>>> +                     mutex_unlock(&mdsc->mutex);
>>>                        mutex_lock(&s->s_mutex);
>>> +                     mutex_lock(&mdsc->mutex);
>>>                        ceph_kick_flushing_caps(mdsc, s);
>>>                        mutex_unlock(&s->s_mutex);
>>>                        wake_up_session_caps(s, RECONNECT);
>>
>> Good catch. Merged into testing branch.
> These stack traces take up the entire screen and provide very
> little information.  Since this is a simple lock ordering issue,
> could they be replaced with a short description and perhaps a
> reference to mds_client.h where lock dependencies are documented?

Hmm, it makes sense.

Should I post a V2 ? Or will Jeff do the fix on the testing branch ?

Thanks
BRs
Xiubo


> Thanks,
>
>                  Ilya
>

