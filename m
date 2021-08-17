Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4173EEC3E
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Aug 2021 14:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbhHQMOg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Aug 2021 08:14:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54031 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239858AbhHQMOg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 08:14:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629202442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B9rlBl96VtYG3+CA4iws7JCEdoqWurqm0vgAy8tBaPk=;
        b=KFGpdX6r/sQiAqk56uNPMryLD6PskEIJ6psDmVLB6e5aAFb4Gyd7s0o0mkjxzVOuSSzOde
        k4HNuOf8psDl1fSmBg/Ro6DD1KTVpAGBHr/Aov5fl4vgtQvnEiaSdp2oU9Ri22Xo34uLF6
        y2liUAxuzKhUTuhJeChXNExKqkU9jFs=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-jqjLYUjfOCqHl7ZD3UwTlQ-1; Tue, 17 Aug 2021 08:14:01 -0400
X-MC-Unique: jqjLYUjfOCqHl7ZD3UwTlQ-1
Received: by mail-pl1-f199.google.com with SMTP id g12-20020a1709026b4cb029012c0d2e483cso13088220plt.5
        for <ceph-devel@vger.kernel.org>; Tue, 17 Aug 2021 05:14:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=B9rlBl96VtYG3+CA4iws7JCEdoqWurqm0vgAy8tBaPk=;
        b=ht/uyGznN9a5tPoKBajA017NZeIfgFFi4bHeonD02FRlyo9T8PHz5yKiXN5OMh7cE2
         KOCMM7+U7bkF5wN5ULBUbyCOP8lAYfWVVfiROQDV1/C5mzYkdNs2M44UoRu/fjInNHYn
         7mjDO0mAPtY5IHJx8z8shlsTRQPo2kvYFu9Sk1tlO/FV8ZMpqDhuzgSSi3B/H87UitEW
         l1DOuX3TzQuR1rXOTh+eCl0ZF3WPniUdAm2cXaa41HYG98mlUGPps7KcH1V84CLtRAx2
         8xq7c/+L3RMkwt1wKTOn4XID6ZWENeYbYsf1q4SbGrMUAmmOrGC/D+xYg2v8ilc2dch+
         wtPg==
X-Gm-Message-State: AOAM531z9wgZbXbre5lUqXuvRmU8XmMRlajP/DLZOrQoISj1Netfmw4V
        S7pKqHw9kRRXL+tgLj/N0Ah3KTVb7SjOXXHu3G1uUlR8TieRJUpsukINLFxhp8xwAftEwLwZMLX
        marSm2UjRyyGBJ2bZ2lELP51SGInyM3TxRXEfqZclvJ8z5+NJspuXh1bZBHWdViA81AnqRxg=
X-Received: by 2002:a65:6883:: with SMTP id e3mr3282669pgt.90.1629202440272;
        Tue, 17 Aug 2021 05:14:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJrOYG2mv7G210OT2O0zNtoSZHq7FTDEfuAkCzaZsdP3buA6nVnBAEh4hRLBKdXya0JgQWbg==
X-Received: by 2002:a65:6883:: with SMTP id e3mr3282638pgt.90.1629202439842;
        Tue, 17 Aug 2021 05:13:59 -0700 (PDT)
Received: from [10.72.12.44] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x4sm2697840pfc.191.2021.08.17.05.13.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 05:13:59 -0700 (PDT)
Subject: Re: [PATCH] ceph: correctly release memory from capsnap
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20210817075816.190025-1-xiubli@redhat.com>
 <CAOi1vP_sO19Fpt=_4J9x-m_PSjP6oNsR2X9PvXZMTeqRsr5Twg@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <32ab6092-ef2f-a02b-cf30-b49ea3843713@redhat.com>
Date:   Tue, 17 Aug 2021 20:13:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP_sO19Fpt=_4J9x-m_PSjP6oNsR2X9PvXZMTeqRsr5Twg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/17/21 6:46 PM, Ilya Dryomov wrote:
> On Tue, Aug 17, 2021 at 9:58 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When force umounting, it will try to remove all the session caps.
>> If there has any capsnap is in the flushing list, the remove session
>> caps callback will try to release the capsnap->flush_cap memory to
>> "ceph_cap_flush_cachep" slab cache, while which is allocated from
>> kmalloc-256 slab cache.
>>
>> URL: https://tracker.ceph.com/issues/52283
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c | 10 +++++++++-
>>   1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 00b3b0a0beb8..cb517753bb17 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -1264,10 +1264,18 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>          spin_unlock(&ci->i_ceph_lock);
>>          while (!list_empty(&to_remove)) {
>>                  struct ceph_cap_flush *cf;
>> +               struct ceph_cap_snap *capsnap;
> Hi Xiubo,
>
> Add an empty line here.

Sure.


>>                  cf = list_first_entry(&to_remove,
>>                                        struct ceph_cap_flush, i_list);
>>                  list_del(&cf->i_list);
>> -               ceph_free_cap_flush(cf);
>> +               if (cf->caps) {
>> +                       ceph_free_cap_flush(cf);
>> +               } else if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
> What does this condition guard against?  Are there other cases of
> ceph_cap_flush being embedded that need to be handled differently
> on !SHUTDOWN?

 From my test this issue could only be reproduced when doing force 
umount. When doing the session close it will also do this.

Checked it again, without this it can works well too. I am not very sure 
whether will this code is needed.

Since removing this won't block my tests, I will remove this logic from 
this patch temporarily and will keep this patch simple to resolve the 
crash issue only.

For the force unmount, there have some other issues, like:

<3>[  324.020531] 
=============================================================================
<3>[  324.020541] BUG ceph_inode_info (Tainted: G E    --------- -  -): 
Objects remaining in ceph_inode_info on __kmem_cache_shutdown()
<3>[  324.020544] 
-----------------------------------------------------------------------------
<3>[  324.020544]
<4>[  324.020549] Disabling lock debugging due to kernel taint
<3>[  324.020553] INFO: Slab 0x000000007ac655b7 objects=20 used=1 
fp=0x00000000ab658885 flags=0x17ffffc0008100
<4>[  324.020559] CPU: 30 PID: 5124 Comm: rmmod Kdump: loaded Tainted: 
G    B       E    --------- -  - 4.18.0+ #10
<4>[  324.020561] Hardware name: Red Hat RHEV Hypervisor, BIOS 
1.11.0-2.el7 04/01/2014
<4>[  324.020563] Call Trace:
<4>[  324.020745]  dump_stack+0x5c/0x80
<4>[  324.020829]  slab_err+0xb0/0xd4
<4>[  324.020872]  ? ksm_migrate_page+0x60/0x60
<4>[  324.020876]  ? __kmalloc+0x16f/0x210
<4>[  324.020879]  ? __kmem_cache_shutdown+0x238/0x290
<4>[  324.020883]  __kmem_cache_shutdown.cold.102+0x1c/0x10d
<4>[  324.020897]  shutdown_cache+0x15/0x200
<4>[  324.020928]  kmem_cache_destroy+0x21f/0x250
<4>[  324.020957]  destroy_caches+0x16/0x52 [ceph]
<4>[  324.021008]  __x64_sys_delete_module+0x139/0x270
<4>[  324.021075]  do_syscall_64+0x5b/0x1b0
<4>[  324.021143]  entry_SYSCALL_64_after_hwframe+0x65/0xca
<4>[  324.021174] RIP: 0033:0x148c0b2c2a8b

I will fix all the memleak issues in a separate patch later.


>
> Should capsnaps be on to_remove list in the first place?
>
> This sounds like stable material to me.
>
> Thanks,
>
>                  Ilya
>

