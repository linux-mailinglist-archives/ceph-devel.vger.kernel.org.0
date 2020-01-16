Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA9513DC33
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Jan 2020 14:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgAPNhJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Jan 2020 08:37:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23623 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726278AbgAPNhI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 16 Jan 2020 08:37:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579181827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B+npmZFmUB6yUDHD05ZXn78SPiMnZzzmLEP7b19IYpE=;
        b=QJX0gCcZfi5UN3DHM2Fk7JSeCI+EFFvUM7JS3+xeLv13KXLPpUj3j1C3RTqjGGLwv+Os2t
        L/fW8WSJYM2+amBj23vZjxLvLiw/6F9I5PkZfzgYFzUJDKSeK3PfPOcyZuTxQRnKjbTesg
        ZqFiJMoZCCn4hoLa7Nc7yTWLLXTq8kA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-3ufkTAV3MJqo_FIeOMjpGA-1; Thu, 16 Jan 2020 08:37:04 -0500
X-MC-Unique: 3ufkTAV3MJqo_FIeOMjpGA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91C02184B986;
        Thu, 16 Jan 2020 13:37:02 +0000 (UTC)
Received: from [10.72.12.100] (ovpn-12-100.pek2.redhat.com [10.72.12.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2087350A8F;
        Thu, 16 Jan 2020 13:36:56 +0000 (UTC)
Subject: Re: [PATCH]--fix the race condition of remove_session_caps of ceph
 which tirgger bugon
To:     Jeff Layton <jlayton@kernel.org>,
        =?UTF-8?B?6ZmI5a6J5bqG?= <chenanqing@oppo.com>,
        Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <HK0PR02MB256313E669FF1C2BDA9155EEAB360@HK0PR02MB2563.apcprd02.prod.outlook.com>
 <eb1e0cd575d21b744acdc8b588769f0e648fecb2.camel@kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <1059104d-9ca9-76cb-b3f2-8dd422a4f2eb@redhat.com>
Date:   Thu, 16 Jan 2020 21:36:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <eb1e0cd575d21b744acdc8b588769f0e648fecb2.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 1/16/20 9:31 PM, Jeff Layton wrote:
> On Thu, 2020-01-16 at 02:02 +0000, =E9=99=88=E5=AE=89=E5=BA=86 wrote:
>> Hi All=EF=BC=8CI think I find a bug in the ceph .
>>  =20
>>  =20
>> background:
>> [3418687.123610] kernel BUG at fs/ceph/mds_client.c:1325!
>> [3418687.124102] invalid opcode: 0000 [#1] SMP
>> [3418687.130132] CPU: 27 PID: 453692 Comm: kworker/27:2 Kdump: loaded =
Tainted: P OE ------------ T 3.10.0-957.27.2.el7.x86_64 #1
>> [3418687.131427] Hardware name: Inspur NF5288M5/YZMB-00834-101, BIOS 4=
.0.08 09/19/2019
>> [3418687.132109] Workqueue: ceph-msgr ceph_con_workfn [libceph]
>> [3418687.132792] task: ffff94c932652080 ti: ffff94b73dae4000 task.ti: =
ffff94b73dae4000
>> [3418687.133488] RIP: 0010:[<ffffffffc1acdc9f>] [<ffffffffc1acdc9f>] r=
emove_session_caps+0x1bf/0x1d0 [ceph]
>> [3418687.134213] RSP: 0018:ffff94b73dae7be0 EFLAGS: 00010202
>> [3418687.134933] RAX: 0000000000000001 RBX: ffff94a09a49ed38 RCX: ffff=
94b73dae7be8
>> [3418687.135668] RDX: ffff94c409f78118 RSI: ffff94b73dae7be8 RDI: ffff=
94a09a49e800
>> [3418687.136407] RBP: ffff94b73dae7c38 R08: ffff94c409f78118 R09: 0000=
000000000001
>> [3418687.137147] R10: 0000000000000000 R11: 0000000000000000 R12: ffff=
94a09a49e800
>> [3418687.137895] R13: ffff94b73dae7be8 R14: ffff94c409f78000 R15: ffff=
94a09a49ed40
>> [3418687.138648] FS: 0000000000000000(0000) GS:ffff94e0bc0c0000(0000) =
knlGS:0000000000000000
>> [3418687.139414] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [3418687.140175] CR2: 00007f49c861a330 CR3: 0000002e4eec4000 CR4: 0000=
0000007607e0
>> [3418687.140939] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000=
000000000000
>> [3418687.141694] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000=
000000000400
>> [3418687.142439] PKRU: 00000000
>> [3418687.143173] Call Trace:
>> [3418687.143907] [<ffffffffc1ad399c>] dispatch+0x39c/0xb00 [ceph]
>> [3418687.144635] [<ffffffffbd81b56a>] ? kernel_recvmsg+0x3a/0x50
>> [3418687.145361] [<ffffffffc1a60fb4>] try_read+0x514/0x12c0 [libceph]
>> [3418687.146081] [<ffffffffc1a61f64>] ceph_con_workfn+0xe4/0x1530 [lib=
ceph]
>> [3418687.146795] [<ffffffffbd2d1b60>] ? finish_task_switch+0xe0/0x1c0
>> [3418687.147502] [<ffffffffbd969aba>] ? __schedule+0x42a/0x860
>> [3418687.148201] [<ffffffffbd2baf9f>] process_one_work+0x17f/0x440
>> [3418687.148895] [<ffffffffbd2bc036>] worker_thread+0x126/0x3c0
>> [3418687.149579] [<ffffffffbd2bbf10>] ? manage_workers.isra.25+0x2a0/0=
x2a0
>> [3418687.150261] [<ffffffffbd2c2e81>] kthread+0xd1/0xe0
>> [3418687.150933] [<ffffffffbd2c2db0>] ? insert_kthread_work+0x40/0x40
>> [3418687.151603] [<ffffffffbd976c1d>] ret_from_fork_nospec_begin+0x7/0=
x21
>> [3418687.152266] [<ffffffffbd2c2db0>] ? insert_kthread_work+0x40/0x40
>> [3418687.152921] Code: 5d 41 5e 41 5f 5d c3 48 89 fa 48 c7 c6 68 31 ae=
 c1 48 c7 c7 98 0f af c1 31 c0 e8 8d 5c ad fb e9 96 fe ff ff e8 03 a9 7c =
fb 0f 0b <0f> 0b 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00
>> [3418687.154318] RIP [<ffffffffc1acdc9f>] remove_session_caps+0x1bf/0x=
1d0 [ceph]
>> [3418687.154998] RSP <ffff94b73dae7be0>
>>  =20
>>  =20
>> and I find another thread which is waiting for the spinlock of session=
->s_cap_lock.
>> PID: 512130 TASK: ffff94bcb5afc100 CPU: 62 COMMAND: "kworker/62:4"
>> #0 [ffff94e0bc588e48] crash_nmi_callback at ffffffffbd256027
>> #1 [ffff94e0bc588e58] nmi_handle at ffffffffbd96e91c
>> #2 [ffff94e0bc588eb0] do_nmi at ffffffffbd96eb3d
>> #3 [ffff94e0bc588ef0] end_repeat_nmi at ffffffffbd96dd89
>> [exception RIP: native_queued_spin_lock_slowpath+462]
>> RIP: ffffffffbd3135de RSP: ffff94cfbf2cf800 RFLAGS: 00000202
>> RAX: 0000000000000001 RBX: ffff94c409f78000 RCX: 0000000000000001
>> RDX: 0000000000000101 RSI: 0000000000000001 RDI: ffff94a09a49ed38
>> RBP: ffff94cfbf2cf800 R8: 0000000000000101 R9: ffff94a1e6d2e180
>> R10: ffff94e1bfbba0e0 R11: ffffffffffffffff R12: ffff94a6c763e9b0
>> R13: ffff94a09a49ed38 R14: ffff94a09a49e800 R15: 0000000000000400
>> ORIG_RAX: ffffffffffffffff CS: 0010 SS: 0018
>> --- <NMI exception stack> ---
>> #4 [ffff94cfbf2cf800] native_queued_spin_lock_slowpath at ffffffffbd31=
35de
>> #5 [ffff94cfbf2cf808] queued_spin_lock_slowpath at ffffffffbd95e2cb
>> #6 [ffff94cfbf2cf818] _raw_spin_lock at ffffffffbd96c7a0
>> #7 [ffff94cfbf2cf828] __ceph_remove_cap at ffffffffc1ac1366 [ceph]----=
------this function is waiting for spinlock of session->s_cap_lock
>> #8 [ffff94cfbf2cf870] ceph_queue_caps_release at ffffffffc1ac156c [cep=
h]
>> #9 [ffff94cfbf2cf890] ceph_destroy_inode at ffffffffc1aaabd5 [ceph]
>> #10 [ffff94cfbf2cf8d0] destroy_inode at ffffffffbd45fe4b
>> #11 [ffff94cfbf2cf8e8] evict at ffffffffbd45ff85
>> #12 [ffff94cfbf2cf910] iput at ffffffffbd46082c
>> #13 [ffff94cfbf2cf940] ceph_put_wrbuffer_cap_refs at ffffffffc1ac46e4 =
[ceph]
>> #14 [ffff94cfbf2cf9b0] writepages_finish at ffffffffc1ab9ecc [ceph]
>> #15 [ffff94cfbf2cfa30] __complete_request at ffffffffc1a67ebe [libceph=
]
>> #16 [ffff94cfbf2cfa50] handle_reply at ffffffffc1a70d1d [libceph]
>> #17 [ffff94cfbf2cfc10] dispatch at ffffffffc1a72ae3 [libceph]
>> #18 [ffff94cfbf2cfcd0] try_read at ffffffffc1a60fb4 [libceph]
>> #19 [ffff94cfbf2cfd90] ceph_con_workfn at ffffffffc1a61f64 [libceph]
>> #20 [ffff94cfbf2cfe20] process_one_work at ffffffffbd2baf9f
>> #21 [ffff94cfbf2cfe68] worker_thread at ffffffffbd2bc036
>> #22 [ffff94cfbf2cfec8] kthread at ffffffffbd2c2e81
>> #23 [ffff94cfbf2cff50] ret_from_fork_nospec_begin at ffffffffbd976c1d
>>  =20
>> after I read the ceph module of https://github.com/torvalds/linux.git =
and
>> kernel/git/next/linux-next.git ,I think the bug is existed all the sam=
e.
>>  =20
>> so I make a patch,maybe I should replace the pr_warn_ratelimited by so=
me function like udelay?
>>  =20
>=20

I think this bug is fixed by.

commit 87bc5b895d94a0f40fe170d4cf5771c8e8f85d15
Author: Yan, Zheng <zyan@redhat.com>
Date:   Sun Jun 2 09:45:38 2019 +0800

ceph: use ceph_evict_inode to cleanup inode's resource

remove_session_caps() relies on __wait_on_freeing_inode(), to wait for
freeing inode to remove its caps. But VFS wakes freeing inode waiters
before calling destroy_inode().

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/40102
Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>




> Thanks for the patch.
>=20
> First, be sure you follow the patch submission guidelines when sending =
a
> patch. In particular, git-send-email is really the best way to submit
> patches.
>=20
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 4cfc4df9fc34..3734d2afb3c5 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -1503,8 +1503,14 @@ static void remove_session_caps(struct ceph_mds=
_session *session)
>>                  while (!list_empty(&session->s_caps)) {
>>                          cap =3D list_entry(session->s_caps.next,
>>                                           struct ceph_cap, session_cap=
s);
>> -                       if (cap =3D=3D prev)
>> -                                break;
>> +                       if (cap =3D=3D prev) {
>> +                               spin_unlock(&session->s_cap_lock);
>> +                               pr_warn_ratelimited(
>> +                               "removing cap %p, inode is %p be delay=
ed\n",
>> +                               cap,  inode);
>> +                               spin_lock(&session->s_cap_lock);
>> +                               continue;
>> +                       }
>=20
> (cc'ing Zheng)
>=20
> That seems like it might be prone to spinning for a very long time if w=
e
> have an inode with an outstanding reference for a long time. I get that
> this is a problem though.
>=20
> I think the real bug is that this is not moving the cap to the end of
> the list, so that it can attempt to clean up more than one that might b=
e
> there. Probably we just need to do a list_move_tail on the entry before
> dropping the spinlock?
>=20
>=20
>=20
>>                          prev =3D cap;
>>                          vino =3D cap->ci->i_vino;
>>                          spin_unlock(&session->s_cap_lock);
>> @@ -1520,6 +1526,13 @@ static void remove_session_caps(struct ceph_mds=
_session *session)
>>          // drop cap expires and unlock s_cap_lock
>>          detach_cap_releases(session, &dispose);
>>  =20
>> +       /*
>> +        * if ceph_async_iput execute ceph_destroy_inode which
>> +        * call __ceph_remove_cap finally to dec the session->s_nr_cap=
s
>> +        * maybe after than BUGON,because it need session->s_cap_lock
>> +        * then BUGON(session->s_nr_caps > 0) must be triggered ,
>> +        * although it is just a race condition.
>> +        */
>>          BUG_ON(session->s_nr_caps > 0);
>>          BUG_ON(!list_empty(&session->s_cap_flushing));
>>          spin_unlock(&session->s_cap_lock);
>> OPPO
>>
>> =E6=9C=AC=E7=94=B5=E5=AD=90=E9=82=AE=E4=BB=B6=E5=8F=8A=E5=85=B6=E9=99=84=
=E4=BB=B6=E5=90=AB=E6=9C=89OPPO=E5=85=AC=E5=8F=B8=E7=9A=84=E4=BF=9D=E5=AF=
=86=E4=BF=A1=E6=81=AF=EF=BC=8C=E4=BB=85=E9=99=90=E4=BA=8E=E9=82=AE=E4=BB=B6=
=E6=8C=87=E6=98=8E=E7=9A=84=E6=94=B6=E4=BB=B6=E4=BA=BA=E4=BD=BF=E7=94=A8=EF=
=BC=88=E5=8C=85=E5=90=AB=E4=B8=AA=E4=BA=BA=E5=8F=8A=E7=BE=A4=E7=BB=84=EF=BC=
=89=E3=80=82=E7=A6=81=E6=AD=A2=E4=BB=BB=E4=BD=95=E4=BA=BA=E5=9C=A8=E6=9C=AA=
=E7=BB=8F=E6=8E=88=E6=9D=83=E7=9A=84=E6=83=85=E5=86=B5=E4=B8=8B=E4=BB=A5=E4=
=BB=BB=E4=BD=95=E5=BD=A2=E5=BC=8F=E4=BD=BF=E7=94=A8=E3=80=82=E5=A6=82=E6=9E=
=9C=E6=82=A8=E9=94=99=E6=94=B6=E4=BA=86=E6=9C=AC=E9=82=AE=E4=BB=B6=EF=BC=8C=
=E8=AF=B7=E7=AB=8B=E5=8D=B3=E4=BB=A5=E7=94=B5=E5=AD=90=E9=82=AE=E4=BB=B6=E9=
=80=9A=E7=9F=A5=E5=8F=91=E4=BB=B6=E4=BA=BA=E5=B9=B6=E5=88=A0=E9=99=A4=E6=9C=
=AC=E9=82=AE=E4=BB=B6=E5=8F=8A=E5=85=B6=E9=99=84=E4=BB=B6=E3=80=82
>> This e-mail and its attachments contain confidential information from =
OPPO, which is intended only for the person or entity whose address is li=
sted above. Any use of the information contained herein in any way (inclu=
ding, but not limited to, total or partial disclosure, reproduction, or d=
issemination) by persons other than the intended recipient(s) is prohibit=
ed. If you receive this e-mail in error, please notify the sender by phon=
e or email immediately and delete it!
>=20

