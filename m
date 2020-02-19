Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E0C16408A
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Feb 2020 10:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgBSJjN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Feb 2020 04:39:13 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28539 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgBSJjM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Feb 2020 04:39:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582105150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pRwL+SLj1BR9vXhDUPHXVEQoFvvr2IaxhCNBk8GkP/c=;
        b=bOmxEYODdULyuaw7QH6V8rdVxa7r+XQgAJmGWuIhWALovhgacAwS/6+O2Aew6ve0mbzfKL
        Hucge/8HlsabeWhEDzxZyq66jSaJqSpOJLhOKRCzlk/Zd3CdNAwRLblnCdhUm1bkFZO/KS
        dlnPEeX379+1ytAXVW2L5xJRMMZLLPU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-9Q2hV7vdMJOWZ8Po8q5TXA-1; Wed, 19 Feb 2020 04:38:54 -0500
X-MC-Unique: 9Q2hV7vdMJOWZ8Po8q5TXA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D46C618C43C0;
        Wed, 19 Feb 2020 09:38:53 +0000 (UTC)
Received: from [10.72.12.94] (ovpn-12-94.pek2.redhat.com [10.72.12.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 39E1B19756;
        Wed, 19 Feb 2020 09:38:50 +0000 (UTC)
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Subject: BUG: ceph_inode_cachep and ceph_dentry_cachep caches are not clean
 when destroying
Message-ID: <23e2b9a7-5ff6-1f07-ff03-08abcbf1457f@redhat.com>
Date:   Wed, 19 Feb 2020 17:38:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Jeff, Ilya and all

I hit this call traces by running some test cases when unmounting the fs=20
mount points.

It seems there still have some inodes or dentries are not destroyed.

Will this be a problem ? Any idea ?


<6>[ 3336.729015] libceph: mon1 (1)192.168.195.165:40291 session establis=
hed
<6>[ 3336.732380] libceph: client4297 fsid=20
f7621edd-ef06-4ca3-8a5b-1ba8c52ae15f
<6>[ 3336.768752] rbd: rbd0: capacity 209715200 features 0x3d
<6>[ 3571.749795] libceph: mon1 (1)192.168.195.165:40291 session establis=
hed
<6>[ 3571.758259] libceph: client4300 fsid=20
f7621edd-ef06-4ca3-8a5b-1ba8c52ae15f
<6>[ 3571.792768] rbd: rbd0: capacity 209715200 features 0x3d
<6>[ 3927.396784] libceph: mon2 (1)192.168.195.165:40293 session establis=
hed
<6>[ 3927.397900] libceph: client4307 fsid=20
f7621edd-ef06-4ca3-8a5b-1ba8c52ae15f
<3>[ 3943.896176]=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
<3>[ 3943.896179] BUG ceph_inode_info (Tainted: G E=C2=A0=C2=A0=C2=A0 ): =
Objects=20
remaining in ceph_inode_info on __kmem_cache_shutdown()
<3>[ 3943.896180]=20
-------------------------------------------------------------------------=
----
<3>[ 3943.896180]
<4>[ 3943.896181] Disabling lock debugging due to kernel taint
<3>[ 3943.896184] INFO: Slab 0x0000000005d371ba objects=3D23 used=3D1=20
fp=3D0x00000000347baa56 flags=3D0x17ffe000010200
<4>[ 3943.896187] CPU: 0 PID: 26423 Comm: rmmod Tainted: G=C2=A0=C2=A0=C2=
=A0 B=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=20
E=C2=A0=C2=A0=C2=A0=C2=A0 5.6.0-rc1+ #23
<4>[ 3943.896188] Hardware name: VMware, Inc. VMware Virtual=20
Platform/440BX Desktop Reference Platform, BIOS 6.00 05/19/2017
<4>[ 3943.896189] Call Trace:
<4>[ 3943.896197]=C2=A0 dump_stack+0x66/0x90
<4>[ 3943.896201]=C2=A0 slab_err+0xb7/0xdc
<4>[ 3943.896205]=C2=A0 ? ksm_migrate_page+0xe0/0xe0
<4>[ 3943.896207]=C2=A0 ? slub_cpu_dead+0xb0/0xb0
<4>[ 3943.896209]=C2=A0 __kmem_cache_shutdown.cold+0x29/0x153
<4>[ 3943.896213]=C2=A0 shutdown_cache+0x13/0x1b0
<4>[ 3943.896215]=C2=A0 kmem_cache_destroy+0x239/0x260
<4>[ 3943.896310]=C2=A0 destroy_caches+0x16/0x57 [ceph]
<4>[ 3943.896316]=C2=A0 __x64_sys_delete_module+0x13d/0x290
<4>[ 3943.896320]=C2=A0 ? exit_to_usermode_loop+0x94/0xd0
<4>[ 3943.896323]=C2=A0 do_syscall_64+0x5b/0x1b0
<4>[ 3943.896327]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
<4>[ 3943.896329] RIP: 0033:0x7fbbb91fc97b
<4>[ 3943.896332] Code: 73 01 c3 48 8b 0d 0d 45 0c 00 f7 d8 64 89 01 48=20
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00=20
0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 44 0c 00 f7 d8 64 89 01 48
<4>[ 3943.896334] RSP: 002b:00007ffef23f7368 EFLAGS: 00000206 ORIG_RAX:=20
00000000000000b0
<4>[ 3943.896336] RAX: ffffffffffffffda RBX: 000055f423b5e7a0 RCX:=20
00007fbbb91fc97b
<4>[ 3943.896336] RDX: 000000000000000a RSI: 0000000000000800 RDI:=20
000055f423b5e808
<4>[ 3943.896337] RBP: 00007ffef23f73b8 R08: 000000000000000a R09:=20
00007ffef23f62e1
<4>[ 3943.896338] R10: 00007fbbb9271ac0 R11: 0000000000000206 R12:=20
00007ffef23f7580
<4>[ 3943.896339] R13: 00007ffef23f8f17 R14: 000055f423b5e260 R15:=20
00007ffef23f73c0
<3>[ 3943.896346] INFO: Object 0x000000005792a1ca @offset=3D14080
<3>[ 3943.896348]=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
<3>[ 3943.896349] BUG ceph_inode_info (Tainted: G=C2=A0=C2=A0=C2=A0 B E=C2=
=A0=C2=A0=C2=A0 ): Objects=20
remaining in ceph_inode_info on __kmem_cache_shutdown()
<3>[ 3943.896350]=20
-------------------------------------------------------------------------=
----
<3>[ 3943.896350]
<3>[ 3943.896352] INFO: Slab 0x0000000048f8188c objects=3D23 used=3D1=20
fp=3D0x00000000a5d1ff93 flags=3D0x17ffe000010200
<4>[ 3943.896354] CPU: 0 PID: 26423 Comm: rmmod Tainted: G=C2=A0=C2=A0=C2=
=A0 B=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=20
E=C2=A0=C2=A0=C2=A0=C2=A0 5.6.0-rc1+ #23
<4>[ 3943.896354] Hardware name: VMware, Inc. VMware Virtual=20
Platform/440BX Desktop Reference Platform, BIOS 6.00 05/19/2017
<4>[ 3943.896355] Call Trace:
<4>[ 3943.896358]=C2=A0 dump_stack+0x66/0x90
<4>[ 3943.896360]=C2=A0 slab_err+0xb7/0xdc
<4>[ 3943.896364]=C2=A0 ? printk+0x58/0x6f
<4>[ 3943.896366]=C2=A0 ? slub_cpu_dead+0xb0/0xb0
<4>[ 3943.896368]=C2=A0 __kmem_cache_shutdown.cold+0x29/0x153
<4>[ 3943.896371]=C2=A0 shutdown_cache+0x13/0x1b0
<4>[ 3943.896374]=C2=A0 kmem_cache_destroy+0x239/0x260
<4>[ 3943.896388]=C2=A0 destroy_caches+0x16/0x57 [ceph]
<4>[ 3943.896391]=C2=A0 __x64_sys_delete_module+0x13d/0x290
<4>[ 3943.896393]=C2=A0 ? exit_to_usermode_loop+0x94/0xd0
<4>[ 3943.896396]=C2=A0 do_syscall_64+0x5b/0x1b0
<4>[ 3943.896398]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
<4>[ 3943.896400] RIP: 0033:0x7fbbb91fc97b
<4>[ 3943.896401] Code: 73 01 c3 48 8b 0d 0d 45 0c 00 f7 d8 64 89 01 48=20
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00=20
0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 44 0c 00 f7 d8 64 89 01 48
<4>[ 3943.896402] RSP: 002b:00007ffef23f7368 EFLAGS: 00000206 ORIG_RAX:=20
00000000000000b0
<4>[ 3943.896404] RAX: ffffffffffffffda RBX: 000055f423b5e7a0 RCX:=20
00007fbbb91fc97b
<4>[ 3943.896405] RDX: 000000000000000a RSI: 0000000000000800 RDI:=20
000055f423b5e808
<4>[ 3943.896406] RBP: 00007ffef23f73b8 R08: 000000000000000a R09:=20
00007ffef23f62e1
<4>[ 3943.896407] R10: 00007fbbb9271ac0 R11: 0000000000000206 R12:=20
00007ffef23f7580
<4>[ 3943.896407] R13: 00007ffef23f8f17 R14: 000055f423b5e260 R15:=20
00007ffef23f73c0
<3>[ 3943.896412] INFO: Object 0x00000000376f6bfe @offset=3D15488
<3>[ 3943.896429]=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
<3>[ 3943.896431] BUG ceph_inode_info (Tainted: G=C2=A0=C2=A0=C2=A0 B E=C2=
=A0=C2=A0=C2=A0 ): Objects=20
remaining in ceph_inode_info on __kmem_cache_shutdown()
<3>[ 3943.896431]=20
-------------------------------------------------------------------------=
----
<3>[ 3943.896431]
<3>[ 3943.896433] INFO: Slab 0x00000000b9901e11 objects=3D23 used=3D1=20
fp=3D0x0000000039e61a30 flags=3D0x17ffe000010200
<4>[ 3943.896434] CPU: 0 PID: 26423 Comm: rmmod Tainted: G=C2=A0=C2=A0=C2=
=A0 B=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=20
E=C2=A0=C2=A0=C2=A0=C2=A0 5.6.0-rc1+ #23
<4>[ 3943.896435] Hardware name: VMware, Inc. VMware Virtual=20
Platform/440BX Desktop Reference Platform, BIOS 6.00 05/19/2017
<4>[ 3943.896436] Call Trace:
<4>[ 3943.896439]=C2=A0 dump_stack+0x66/0x90
<4>[ 3943.896441]=C2=A0 slab_err+0xb7/0xdc
<4>[ 3943.896445]=C2=A0 ? printk+0x58/0x6f
<4>[ 3943.896446]=C2=A0 ? slub_cpu_dead+0xb0/0xb0
<4>[ 3943.896448]=C2=A0 __kmem_cache_shutdown.cold+0x29/0x153
<4>[ 3943.896451]=C2=A0 shutdown_cache+0x13/0x1b0
<4>[ 3943.896452]=C2=A0 kmem_cache_destroy+0x239/0x260
<4>[ 3943.896466]=C2=A0 destroy_caches+0x16/0x57 [ceph]
<4>[ 3943.896469]=C2=A0 __x64_sys_delete_module+0x13d/0x290
<4>[ 3943.896472]=C2=A0 ? exit_to_usermode_loop+0x94/0xd0
<4>[ 3943.896474]=C2=A0 do_syscall_64+0x5b/0x1b0
<4>[ 3943.896477]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
<4>[ 3943.896478] RIP: 0033:0x7fbbb91fc97b
<4>[ 3943.896479] Code: 73 01 c3 48 8b 0d 0d 45 0c 00 f7 d8 64 89 01 48=20
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00=20
0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 44 0c 00 f7 d8 64 89 01 48
<4>[ 3943.896480] RSP: 002b:00007ffef23f7368 EFLAGS: 00000206 ORIG_RAX:=20
00000000000000b0
<4>[ 3943.896482] RAX: ffffffffffffffda RBX: 000055f423b5e7a0 RCX:=20
00007fbbb91fc97b
<4>[ 3943.896483] RDX: 000000000000000a RSI: 0000000000000800 RDI:=20
000055f423b5e808
<4>[ 3943.896483] RBP: 00007ffef23f73b8 R08: 000000000000000a R09:=20
00007ffef23f62e1
<4>[ 3943.896484] R10: 00007fbbb9271ac0 R11: 0000000000000206 R12:=20
00007ffef23f7580
<4>[ 3943.896485] R13: 00007ffef23f8f17 R14: 000055f423b5e260 R15:=20
00007ffef23f73c0
<3>[ 3943.896489] INFO: Object 0x0000000090e93ce6 @offset=3D16896
<3>[ 3943.896550] kmem_cache_destroy ceph_inode_info: Slab cache still=20
has objects
<4>[ 3943.896553] CPU: 0 PID: 26423 Comm: rmmod Tainted: G=C2=A0=C2=A0=C2=
=A0 B=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=20
E=C2=A0=C2=A0=C2=A0=C2=A0 5.6.0-rc1+ #23
<4>[ 3943.896554] Hardware name: VMware, Inc. VMware Virtual=20
Platform/440BX Desktop Reference Platform, BIOS 6.00 05/19/2017
<4>[ 3943.896554] Call Trace:
<4>[ 3943.896558]=C2=A0 dump_stack+0x66/0x90
<4>[ 3943.896560]=C2=A0 kmem_cache_destroy.cold+0x15/0x1a
<4>[ 3943.896575]=C2=A0 destroy_caches+0x16/0x57 [ceph]
<4>[ 3943.896578]=C2=A0 __x64_sys_delete_module+0x13d/0x290
<4>[ 3943.896581]=C2=A0 ? exit_to_usermode_loop+0x94/0xd0
<4>[ 3943.896583]=C2=A0 do_syscall_64+0x5b/0x1b0
<4>[ 3943.896586]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
<4>[ 3943.896589] RIP: 0033:0x7fbbb91fc97b
<4>[ 3943.896593] Code: 73 01 c3 48 8b 0d 0d 45 0c 00 f7 d8 64 89 01 48=20
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00=20
0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 44 0c 00 f7 d8 64 89 01 48
<4>[ 3943.896595] RSP: 002b:00007ffef23f7368 EFLAGS: 00000206 ORIG_RAX:=20
00000000000000b0
<4>[ 3943.896597] RAX: ffffffffffffffda RBX: 000055f423b5e7a0 RCX:=20
00007fbbb91fc97b
<4>[ 3943.896600] RDX: 000000000000000a RSI: 0000000000000800 RDI:=20
000055f423b5e808
<4>[ 3943.896601] RBP: 00007ffef23f73b8 R08: 000000000000000a R09:=20
00007ffef23f62e1
<4>[ 3943.896606] R10: 00007fbbb9271ac0 R11: 0000000000000206 R12:=20
00007ffef23f7580
<4>[ 3943.896609] R13: 00007ffef23f8f17 R14: 000055f423b5e260 R15:=20
00007ffef23f73c0
<3>[ 3943.914328]=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
<3>[ 3943.914330] BUG ceph_dentry_info (Tainted: G B=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 E=C2=A0=C2=A0=C2=A0 ):=20
Objects remaining in ceph_dentry_info on __kmem_cache_shutdown()
<3>[ 3943.914331]=20
-------------------------------------------------------------------------=
----
<3>[ 3943.914331]
<3>[ 3943.914333] INFO: Slab 0x00000000713366a2 objects=3D51 used=3D2=20
fp=3D0x00000000c5c96d72 flags=3D0x17ffe000000200
<4>[ 3943.914335] CPU: 0 PID: 26423 Comm: rmmod Tainted: G=C2=A0=C2=A0=C2=
=A0 B=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=20
E=C2=A0=C2=A0=C2=A0=C2=A0 5.6.0-rc1+ #23
<4>[ 3943.914336] Hardware name: VMware, Inc. VMware Virtual=20
Platform/440BX Desktop Reference Platform, BIOS 6.00 05/19/2017
<4>[ 3943.914336] Call Trace:
<4>[ 3943.914343]=C2=A0 dump_stack+0x66/0x90
<4>[ 3943.914345]=C2=A0 slab_err+0xb7/0xdc
<4>[ 3943.914349]=C2=A0 ? ksm_migrate_page+0xe0/0xe0
<4>[ 3943.914350]=C2=A0 ? slub_cpu_dead+0xb0/0xb0
<4>[ 3943.914351]=C2=A0 __kmem_cache_shutdown.cold+0x29/0x153
<4>[ 3943.914353]=C2=A0 shutdown_cache+0x13/0x1b0
<4>[ 3943.914354]=C2=A0 kmem_cache_destroy+0x239/0x260
<4>[ 3943.914367]=C2=A0 destroy_caches+0x3a/0x57 [ceph]
<4>[ 3943.914370]=C2=A0 __x64_sys_delete_module+0x13d/0x290
<4>[ 3943.914373]=C2=A0 ? exit_to_usermode_loop+0x94/0xd0
<4>[ 3943.914374]=C2=A0 do_syscall_64+0x5b/0x1b0
<4>[ 3943.914376]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
<4>[ 3943.914378] RIP: 0033:0x7fbbb91fc97b
<4>[ 3943.914380] Code: 73 01 c3 48 8b 0d 0d 45 0c 00 f7 d8 64 89 01 48=20
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00=20
0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 44 0c 00 f7 d8 64 89 01 48
<4>[ 3943.914381] RSP: 002b:00007ffef23f7368 EFLAGS: 00000206 ORIG_RAX:=20
00000000000000b0
<4>[ 3943.914382] RAX: ffffffffffffffda RBX: 000055f423b5e7a0 RCX:=20
00007fbbb91fc97b
<4>[ 3943.914383] RDX: 000000000000000a RSI: 0000000000000800 RDI:=20
000055f423b5e808
<4>[ 3943.914383] RBP: 00007ffef23f73b8 R08: 000000000000000a R09:=20
00007ffef23f62e1
<4>[ 3943.914383] R10: 00007fbbb9271ac0 R11: 0000000000000206 R12:=20
00007ffef23f7580
<4>[ 3943.914384] R13: 00007ffef23f8f17 R14: 000055f423b5e260 R15:=20
00007ffef23f73c0
<3>[ 3943.914387] INFO: Object 0x000000000917f90f @offset=3D2800
<3>[ 3943.914387] INFO: Object 0x00000000cea9f98e @offset=3D2880
<3>[ 3943.914388]=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
<3>[ 3943.914389] BUG ceph_dentry_info (Tainted: G B=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 E=C2=A0=C2=A0=C2=A0 ):=20
Objects remaining in ceph_dentry_info on __kmem_cache_shutdown()
<3>[ 3943.914389]=20
-------------------------------------------------------------------------=
----
<3>[ 3943.914389]
<3>[ 3943.914390] INFO: Slab 0x00000000d49f198a objects=3D51 used=3D1=20
fp=3D0x000000007a03922c flags=3D0x17ffe000000200
<4>[ 3943.914391] CPU: 0 PID: 26423 Comm: rmmod Tainted: G=C2=A0=C2=A0=C2=
=A0 B=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=20
E=C2=A0=C2=A0=C2=A0=C2=A0 5.6.0-rc1+ #23
<4>[ 3943.914391] Hardware name: VMware, Inc. VMware Virtual=20
Platform/440BX Desktop Reference Platform, BIOS 6.00 05/19/2017
<4>[ 3943.914392] Call Trace:
<4>[ 3943.914393]=C2=A0 dump_stack+0x66/0x90
<4>[ 3943.914394]=C2=A0 slab_err+0xb7/0xdc
<4>[ 3943.914397]=C2=A0 ? printk+0x58/0x6f
<4>[ 3943.914397]=C2=A0 ? slub_cpu_dead+0xb0/0xb0
<4>[ 3943.914398]=C2=A0 __kmem_cache_shutdown.cold+0x29/0x153
<4>[ 3943.914400]=C2=A0 shutdown_cache+0x13/0x1b0
<4>[ 3943.914401]=C2=A0 kmem_cache_destroy+0x239/0x260
<4>[ 3943.914409]=C2=A0 destroy_caches+0x3a/0x57 [ceph]
<4>[ 3943.914411]=C2=A0 __x64_sys_delete_module+0x13d/0x290
<4>[ 3943.914413]=C2=A0 ? exit_to_usermode_loop+0x94/0xd0
<4>[ 3943.914414]=C2=A0 do_syscall_64+0x5b/0x1b0
<4>[ 3943.914416]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
<4>[ 3943.914416] RIP: 0033:0x7fbbb91fc97b
<4>[ 3943.914417] Code: 73 01 c3 48 8b 0d 0d 45 0c 00 f7 d8 64 89 01 48=20
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00=20
0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 44 0c 00 f7 d8 64 89 01 48
<4>[ 3943.914418] RSP: 002b:00007ffef23f7368 EFLAGS: 00000206 ORIG_RAX:=20
00000000000000b0
<4>[ 3943.914418] RAX: ffffffffffffffda RBX: 000055f423b5e7a0 RCX:=20
00007fbbb91fc97b
<4>[ 3943.914419] RDX: 000000000000000a RSI: 0000000000000800 RDI:=20
000055f423b5e808
<4>[ 3943.914419] RBP: 00007ffef23f73b8 R08: 000000000000000a R09:=20
00007ffef23f62e1
<4>[ 3943.914419] R10: 00007fbbb9271ac0 R11: 0000000000000206 R12:=20
00007ffef23f7580
<4>[ 3943.914420] R13: 00007ffef23f8f17 R14: 000055f423b5e260 R15:=20
00007ffef23f73c0
<3>[ 3943.914422] INFO: Object 0x00000000a465a019 @offset=3D240
<3>[ 3943.914423] kmem_cache_destroy ceph_dentry_info: Slab cache still=20
has objects
<4>[ 3943.914424] CPU: 0 PID: 26423 Comm: rmmod Tainted: G=C2=A0=C2=A0=C2=
=A0 B=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=20
E=C2=A0=C2=A0=C2=A0=C2=A0 5.6.0-rc1+ #23
<4>[ 3943.914425] Hardware name: VMware, Inc. VMware Virtual=20
Platform/440BX Desktop Reference Platform, BIOS 6.00 05/19/2017
<4>[ 3943.914425] Call Trace:
<4>[ 3943.914426]=C2=A0 dump_stack+0x66/0x90
<4>[ 3943.914427]=C2=A0 kmem_cache_destroy.cold+0x15/0x1a
<4>[ 3943.914434]=C2=A0 destroy_caches+0x3a/0x57 [ceph]
<4>[ 3943.914436]=C2=A0 __x64_sys_delete_module+0x13d/0x290
<4>[ 3943.914437]=C2=A0 ? exit_to_usermode_loop+0x94/0xd0
<4>[ 3943.914438]=C2=A0 do_syscall_64+0x5b/0x1b0
<4>[ 3943.914440]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
<4>[ 3943.914440] RIP: 0033:0x7fbbb91fc97b
<4>[ 3943.914441] Code: 73 01 c3 48 8b 0d 0d 45 0c 00 f7 d8 64 89 01 48=20
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00=20
0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 44 0c 00 f7 d8 64 89 01 48
<4>[ 3943.914441] RSP: 002b:00007ffef23f7368 EFLAGS: 00000206 ORIG_RAX:=20
00000000000000b0
<4>[ 3943.914442] RAX: ffffffffffffffda RBX: 000055f423b5e7a0 RCX:=20
00007fbbb91fc97b
<4>[ 3943.914442] RDX: 000000000000000a RSI: 0000000000000800 RDI:=20
000055f423b5e808
<4>[ 3943.914442] RBP: 00007ffef23f73b8 R08: 000000000000000a R09:=20
00007ffef23f62e1
<4>[ 3943.914443] R10: 00007fbbb9271ac0 R11: 0000000000000206 R12:=20
00007ffef23f7580
<4>[ 3943.914443] R13: 00007ffef23f8f17 R14: 000055f423b5e260 R15:=20
00007ffef23f73c0
<5>[ 3943.923089] FS-Cache: Netfs 'ceph' unregistered from caching
<5>[ 4022.394090] Key type ceph unregistered
<5>[ 4028.645127] Key type ceph registered
<6>[ 4028.645522] libceph: loaded (mon/osd proto 15/24)
<5>[ 4028.658549] FS-Cache: Netfs 'ceph' registered for caching
<6>[ 4028.658558] ceph: loaded (mds proto 32)
<6>[ 4028.662334] libceph: mon1 (1)192.168.195.165:40291 session establis=
hed
<6>[ 4028.663998] libceph: client4303 fsid=20
f7621edd-ef06-4ca3-8a5b-1ba8c52ae15f
<3>[11275.766909]=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
<3>[11275.766910] BUG ceph_dentry_info (Tainted: G B=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 E=C2=A0=C2=A0=C2=A0 ):=20
Objects remaining in ceph_dentry_info on __kmem_cache_shutdown()
<3>[11275.766911]=20
-------------------------------------------------------------------------=
----
<3>[11275.766911]
<3>[11275.766912] INFO: Slab 0x00000000d49f198a objects=3D51 used=3D1=20
fp=3D0x000000007a03922c flags=3D0x17ffe000000200
<4>[11275.766915] CPU: 0 PID: 40095 Comm: rmmod Tainted: G=C2=A0=C2=A0=C2=
=A0 B=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=20
E=C2=A0=C2=A0=C2=A0=C2=A0 5.6.0-rc1+ #23
<4>[11275.766916] Hardware name: VMware, Inc. VMware Virtual=20
Platform/440BX Desktop Reference Platform, BIOS 6.00 05/19/2017
<4>[11275.766916] Call Trace:
<4>[11275.767023]=C2=A0 dump_stack+0x66/0x90
<4>[11275.767043]=C2=A0 slab_err+0xb7/0xdc
<4>[11275.767046]=C2=A0 ? ksm_migrate_page+0xe0/0xe0
<4>[11275.767047]=C2=A0 ? slub_cpu_dead+0xb0/0xb0
<4>[11275.767048]=C2=A0 __kmem_cache_shutdown.cold+0x29/0x153
<4>[11275.767050]=C2=A0 shutdown_cache+0x13/0x1b0
<4>[11275.767051]=C2=A0 kmem_cache_destroy+0x239/0x260
<4>[11275.767083]=C2=A0 destroy_caches+0x3a/0x57 [ceph]
<4>[11275.767086]=C2=A0 __x64_sys_delete_module+0x13d/0x290
<4>[11275.767108]=C2=A0 ? exit_to_usermode_loop+0x94/0xd0
<4>[11275.767109]=C2=A0 do_syscall_64+0x5b/0x1b0
<4>[11275.767129]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
<4>[11275.767164] RIP: 0033:0x7f6da227797b
<4>[11275.767167] Code: 73 01 c3 48 8b 0d 0d 45 0c 00 f7 d8 64 89 01 48=20
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00=20
0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 44 0c 00 f7 d8 64 89 01 48
<4>[11275.767168] RSP: 002b:00007ffdb75aa098 EFLAGS: 00000206 ORIG_RAX:=20
00000000000000b0
<4>[11275.767169] RAX: ffffffffffffffda RBX: 000055de019007a0 RCX:=20
00007f6da227797b
<4>[11275.767169] RDX: 000000000000000a RSI: 0000000000000800 RDI:=20
000055de01900808
<4>[11275.767170] RBP: 00007ffdb75aa0e8 R08: 000000000000000a R09:=20
00007ffdb75a9011
<4>[11275.767170] R10: 00007f6da22ecac0 R11: 0000000000000206 R12:=20
00007ffdb75aa2b0
<4>[11275.767171] R13: 00007ffdb75abf17 R14: 000055de01900260 R15:=20
00007ffdb75aa0f0
<3>[11275.767175] INFO: Object 0x00000000a465a019 @offset=3D240
<3>[11275.767177]=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
<3>[11275.767177] BUG ceph_dentry_info (Tainted: G B=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 E=C2=A0=C2=A0=C2=A0 ):=20
Objects remaining in ceph_dentry_info on __kmem_cache_shutdown()
<3>[11275.767178]=20
-------------------------------------------------------------------------=
----
<3>[11275.767178]
<3>[11275.767178] INFO: Slab 0x00000000713366a2 objects=3D51 used=3D2=20
fp=3D0x0000000062e48697 flags=3D0x17ffe000000200
<4>[11275.767180] CPU: 0 PID: 40095 Comm: rmmod Tainted: G=C2=A0=C2=A0=C2=
=A0 B=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=20
E=C2=A0=C2=A0=C2=A0=C2=A0 5.6.0-rc1+ #23
<4>[11275.767180] Hardware name: VMware, Inc. VMware Virtual=20
Platform/440BX Desktop Reference Platform, BIOS 6.00 05/19/2017
<4>[11275.767180] Call Trace:
<4>[11275.767182]=C2=A0 dump_stack+0x66/0x90
<4>[11275.767183]=C2=A0 slab_err+0xb7/0xdc
<4>[11275.767185]=C2=A0 ? printk+0x58/0x6f
<4>[11275.767186]=C2=A0 ? slub_cpu_dead+0xb0/0xb0
<4>[11275.767188]=C2=A0 __kmem_cache_shutdown.cold+0x29/0x153
<4>[11275.767189]=C2=A0 shutdown_cache+0x13/0x1b0
<4>[11275.767190]=C2=A0 kmem_cache_destroy+0x239/0x260
<4>[11275.767198]=C2=A0 destroy_caches+0x3a/0x57 [ceph]
<4>[11275.767200]=C2=A0 __x64_sys_delete_module+0x13d/0x290
<4>[11275.767202]=C2=A0 ? exit_to_usermode_loop+0x94/0xd0
<4>[11275.767203]=C2=A0 do_syscall_64+0x5b/0x1b0
<4>[11275.767205]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
<4>[11275.767205] RIP: 0033:0x7f6da227797b
<4>[11275.767206] Code: 73 01 c3 48 8b 0d 0d 45 0c 00 f7 d8 64 89 01 48=20
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00=20
0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 44 0c 00 f7 d8 64 89 01 48
<4>[11275.767207] RSP: 002b:00007ffdb75aa098 EFLAGS: 00000206 ORIG_RAX:=20
00000000000000b0
<4>[11275.767208] RAX: ffffffffffffffda RBX: 000055de019007a0 RCX:=20
00007f6da227797b
<4>[11275.767208] RDX: 000000000000000a RSI: 0000000000000800 RDI:=20
000055de01900808
<4>[11275.767208] RBP: 00007ffdb75aa0e8 R08: 000000000000000a R09:=20
00007ffdb75a9011
<4>[11275.767209] R10: 00007f6da22ecac0 R11: 0000000000000206 R12:=20
00007ffdb75aa2b0
<4>[11275.767209] R13: 00007ffdb75abf17 R14: 000055de01900260 R15:=20
00007ffdb75aa0f0
<3>[11275.767212] INFO: Object 0x000000000917f90f @offset=3D2800
<3>[11275.767212] INFO: Object 0x00000000cea9f98e @offset=3D2880
<3>[11275.767213] kmem_cache_destroy ceph_dentry_info: Slab cache still=20
has objects
<4>[11275.767214] CPU: 0 PID: 40095 Comm: rmmod Tainted: G=C2=A0=C2=A0=C2=
=A0 B=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=20
E=C2=A0=C2=A0=C2=A0=C2=A0 5.6.0-rc1+ #23
<4>[11275.767214] Hardware name: VMware, Inc. VMware Virtual=20
Platform/440BX Desktop Reference Platform, BIOS 6.00 05/19/2017
<4>[11275.767215] Call Trace:
<4>[11275.767215]=C2=A0 dump_stack+0x66/0x90
<4>[11275.767217]=C2=A0 kmem_cache_destroy.cold+0x15/0x1a
<4>[11275.767223]=C2=A0 destroy_caches+0x3a/0x57 [ceph]
<4>[11275.767225]=C2=A0 __x64_sys_delete_module+0x13d/0x290
<4>[11275.767226]=C2=A0 ? exit_to_usermode_loop+0x94/0xd0
<4>[11275.767227]=C2=A0 do_syscall_64+0x5b/0x1b0
<4>[11275.767229]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
<4>[11275.767229] RIP: 0033:0x7f6da227797b
<4>[11275.767230] Code: 73 01 c3 48 8b 0d 0d 45 0c 00 f7 d8 64 89 01 48=20
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00=20
0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 44 0c 00 f7 d8 64 89 01 48
<4>[11275.767230] RSP: 002b:00007ffdb75aa098 EFLAGS: 00000206 ORIG_RAX:=20
00000000000000b0
<4>[11275.767231] RAX: ffffffffffffffda RBX: 000055de019007a0 RCX:=20
00007f6da227797b
<4>[11275.767231] RDX: 000000000000000a RSI: 0000000000000800 RDI:=20
000055de01900808
<4>[11275.767232] RBP: 00007ffdb75aa0e8 R08: 000000000000000a R09:=20
00007ffdb75a9011
<4>[11275.767232] R10: 00007f6da22ecac0 R11: 0000000000000206 R12:=20
00007ffdb75aa2b0
<4>[11275.767232] R13: 00007ffdb75abf17 R14: 000055de01900260 R15:=20
00007ffdb75aa0f0
<5>[11275.767361] FS-Cache: Netfs 'ceph' unregistered from caching
<5>[11275.807037] Key type ceph unregistered
<4>[11594.856257] hrtimer: interrupt took 3786932 ns
<5>[11842.570801] Key type ceph registered
<6>[11842.571477] libceph: loaded (mon/osd proto 15/24)
<5>[11842.671795] FS-Cache: Netfs 'ceph' registered for caching
<6>[11842.671803] ceph: loaded (mds proto 32)
<6>[11842.705475] libceph: mon2 (1)192.168.195.165:40293 session establis=
hed
<6>[11842.708894] libceph: client4310 fsid=20
f7621edd-ef06-4ca3-8a5b-1ba8c52ae15f
<3>[12247.488188]=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
<3>[12247.488189] BUG ceph_dentry_info (Tainted: G B=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 E=C2=A0=C2=A0=C2=A0 ):=20
Objects remaining in ceph_dentry_info on __kmem_cache_shutdown()
<3>[12247.488228]=20
-------------------------------------------------------------------------=
----
<3>[12247.488228]
<3>[12247.488231] INFO: Slab 0x00000000713366a2 objects=3D51 used=3D2=20
fp=3D0x0000000062e48697 flags=3D0x17ffe000000200
<4>[12247.488233] CPU: 2 PID: 42854 Comm: rmmod Tainted: G=C2=A0=C2=A0=C2=
=A0 B=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=20
E=C2=A0=C2=A0=C2=A0=C2=A0 5.6.0-rc1+ #23
<4>[12247.488234] Hardware name: VMware, Inc. VMware Virtual=20
Platform/440BX Desktop Reference Platform, BIOS 6.00 05/19/2017
<4>[12247.488234] Call Trace:
<4>[12247.488241]=C2=A0 dump_stack+0x66/0x90
<4>[12247.488244]=C2=A0 slab_err+0xb7/0xdc
<4>[12247.488246]=C2=A0 ? ksm_migrate_page+0xe0/0xe0
<4>[12247.488247]=C2=A0 ? slub_cpu_dead+0xb0/0xb0
<4>[12247.488249]=C2=A0 __kmem_cache_shutdown.cold+0x29/0x153
<4>[12247.488251]=C2=A0 shutdown_cache+0x13/0x1b0
<4>[12247.488252]=C2=A0 kmem_cache_destroy+0x239/0x260
<4>[12247.488265]=C2=A0 destroy_caches+0x3a/0x57 [ceph]
<4>[12247.488268]=C2=A0 __x64_sys_delete_module+0x13d/0x290
<4>[12247.488271]=C2=A0 ? exit_to_usermode_loop+0x94/0xd0
<4>[12247.488272]=C2=A0 do_syscall_64+0x5b/0x1b0
<4>[12247.488299]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
<4>[12247.488301] RIP: 0033:0x7fd1c5bb797b
<4>[12247.488304] Code: 73 01 c3 48 8b 0d 0d 45 0c 00 f7 d8 64 89 01 48=20
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00=20
0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 44 0c 00 f7 d8 64 89 01 48
<4>[12247.488304] RSP: 002b:00007ffd37a293f8 EFLAGS: 00000206 ORIG_RAX:=20
00000000000000b0
<4>[12247.488306] RAX: ffffffffffffffda RBX: 0000559e2ce707a0 RCX:=20
00007fd1c5bb797b
<4>[12247.488306] RDX: 000000000000000a RSI: 0000000000000800 RDI:=20
0000559e2ce70808
<4>[12247.488307] RBP: 00007ffd37a29448 R08: 000000000000000a R09:=20
00007ffd37a28371
<4>[12247.488307] R10: 00007fd1c5c2cac0 R11: 0000000000000206 R12:=20
00007ffd37a29610
<4>[12247.488307] R13: 00007ffd37a2af17 R14: 0000559e2ce70260 R15:=20
00007ffd37a29450
<3>[12247.488312] INFO: Object 0x000000000917f90f @offset=3D2800
<3>[12247.488313] INFO: Object 0x00000000cea9f98e @offset=3D2880
<3>[12247.488314]=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
<3>[12247.488315] BUG ceph_dentry_info (Tainted: G B=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 E=C2=A0=C2=A0=C2=A0 ):=20
Objects remaining in ceph_dentry_info on __kmem_cache_shutdown()
<3>[12247.488315]=20
-------------------------------------------------------------------------=
----
<3>[12247.488315]
<3>[12247.488316] INFO: Slab 0x00000000d49f198a objects=3D51 used=3D1=20
fp=3D0x000000001b4111af flags=3D0x17ffe000000200
<4>[12247.488317] CPU: 2 PID: 42854 Comm: rmmod Tainted: G=C2=A0=C2=A0=C2=
=A0 B=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=20
E=C2=A0=C2=A0=C2=A0=C2=A0 5.6.0-rc1+ #23
<4>[12247.488317] Hardware name: VMware, Inc. VMware Virtual=20
Platform/440BX Desktop Reference Platform, BIOS 6.00 05/19/2017
<4>[12247.488318] Call Trace:
<4>[12247.488319]=C2=A0 dump_stack+0x66/0x90
<4>[12247.488321]=C2=A0 slab_err+0xb7/0xdc
<4>[12247.488324]=C2=A0 ? printk+0x58/0x6f
<4>[12247.488324]=C2=A0 ? slub_cpu_dead+0xb0/0xb0
<4>[12247.488326]=C2=A0 __kmem_cache_shutdown.cold+0x29/0x153
<4>[12247.488327]=C2=A0 shutdown_cache+0x13/0x1b0
<4>[12247.488329]=C2=A0 kmem_cache_destroy+0x239/0x260
<4>[12247.488337]=C2=A0 destroy_caches+0x3a/0x57 [ceph]
<4>[12247.488339]=C2=A0 __x64_sys_delete_module+0x13d/0x290
<4>[12247.488341]=C2=A0 ? exit_to_usermode_loop+0x94/0xd0
<4>[12247.488342]=C2=A0 do_syscall_64+0x5b/0x1b0
<4>[12247.488344]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
<4>[12247.488345] RIP: 0033:0x7fd1c5bb797b
<4>[12247.488346] Code: 73 01 c3 48 8b 0d 0d 45 0c 00 f7 d8 64 89 01 48=20
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00=20
0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 44 0c 00 f7 d8 64 89 01 48
<4>[12247.488346] RSP: 002b:00007ffd37a293f8 EFLAGS: 00000206 ORIG_RAX:=20
00000000000000b0
<4>[12247.488347] RAX: ffffffffffffffda RBX: 0000559e2ce707a0 RCX:=20
00007fd1c5bb797b
<4>[12247.488347] RDX: 000000000000000a RSI: 0000000000000800 RDI:=20
0000559e2ce70808
<4>[12247.488348] RBP: 00007ffd37a29448 R08: 000000000000000a R09:=20
00007ffd37a28371
<4>[12247.488348] R10: 00007fd1c5c2cac0 R11: 0000000000000206 R12:=20
00007ffd37a29610
<4>[12247.488349] R13: 00007ffd37a2af17 R14: 0000559e2ce70260 R15:=20
00007ffd37a29450
<3>[12247.488352] INFO: Object 0x00000000a465a019 @offset=3D240
<3>[12247.488353] kmem_cache_destroy ceph_dentry_info: Slab cache still=20
has objects
<4>[12247.488354] CPU: 2 PID: 42854 Comm: rmmod Tainted: G=C2=A0=C2=A0=C2=
=A0 B=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=20
E=C2=A0=C2=A0=C2=A0=C2=A0 5.6.0-rc1+ #23
<4>[12247.488354] Hardware name: VMware, Inc. VMware Virtual=20
Platform/440BX Desktop Reference Platform, BIOS 6.00 05/19/2017
<4>[12247.488354] Call Trace:
<4>[12247.488355]=C2=A0 dump_stack+0x66/0x90
<4>[12247.488357]=C2=A0 kmem_cache_destroy.cold+0x15/0x1a
<4>[12247.488364]=C2=A0 destroy_caches+0x3a/0x57 [ceph]
<4>[12247.488366]=C2=A0 __x64_sys_delete_module+0x13d/0x290
<4>[12247.488367]=C2=A0 ? exit_to_usermode_loop+0x94/0xd0
<4>[12247.488369]=C2=A0 do_syscall_64+0x5b/0x1b0
<4>[12247.488370]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
<4>[12247.488371] RIP: 0033:0x7fd1c5bb797b
<4>[12247.488372] Code: 73 01 c3 48 8b 0d 0d 45 0c 00 f7 d8 64 89 01 48=20
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00=20
0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 44 0c 00 f7 d8 64 89 01 48
<4>[12247.488372] RSP: 002b:00007ffd37a293f8 EFLAGS: 00000206 ORIG_RAX:=20
00000000000000b0
<4>[12247.488373] RAX: ffffffffffffffda RBX: 0000559e2ce707a0 RCX:=20
00007fd1c5bb797b
<4>[12247.488373] RDX: 000000000000000a RSI: 0000000000000800 RDI:=20
0000559e2ce70808
<4>[12247.488374] RBP: 00007ffd37a29448 R08: 000000000000000a R09:=20
00007ffd37a28371
<4>[12247.488374] R10: 00007fd1c5c2cac0 R11: 0000000000000206 R12:=20
00007ffd37a29610
<4>[12247.488375] R13: 00007ffd37a2af17 R14: 0000559e2ce70260 R15:=20
00007ffd37a29450
<5>[12247.499349] FS-Cache: Netfs 'ceph' unregistered from caching
<5>[12247.524579] Key type ceph unregistered
<5>[12403.035063] Key type ceph registered
<6>[12403.040353] libceph: loaded (mon/osd proto 15/24)
<5>[12403.100932] FS-Cache: Netfs 'ceph' registered for caching
<6>[12403.100939] ceph: loaded (mds proto 32)
<6>[12403.117931] libceph: mon1 (1)192.168.195.165:40291 session establis=
hed
<6>[12403.124988] libceph: client4306 fsid=20
f7621edd-ef06-4ca3-8a5b-1ba8c52ae15f
<3>[12577.319568]=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
<3>[12577.319572] BUG ceph_dentry_info (Tainted: G B=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 E=C2=A0=C2=A0=C2=A0 ):=20
Objects remaining in ceph_dentry_info on __kmem_cache_shutdown()
<3>[12577.319572]=20
-------------------------------------------------------------------------=
----
<3>[12577.319572]
<3>[12577.319575] INFO: Slab 0x00000000d49f198a objects=3D51 used=3D1=20
fp=3D0x000000001b4111af flags=3D0x17ffe000000200
<4>[12577.319579] CPU: 1 PID: 1919 Comm: rmmod Tainted: G B=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 E=C2=A0=C2=A0=C2=A0=C2=A0=20
5.6.0-rc1+ #23
<4>[12577.319580] Hardware name: VMware, Inc. VMware Virtual=20
Platform/440BX Desktop Reference Platform, BIOS 6.00 05/19/2017
<4>[12577.319581] Call Trace:
<4>[12577.319590]=C2=A0 dump_stack+0x66/0x90
<4>[12577.319593]=C2=A0 slab_err+0xb7/0xdc
<4>[12577.319596]=C2=A0 ? slub_cpu_dead+0xb0/0xb0
<4>[12577.319599]=C2=A0 ? ksm_migrate_page+0xe0/0xe0
<4>[12577.319601]=C2=A0 ? ksm_migrate_page+0xe0/0xe0
<4>[12577.319603]=C2=A0 __kmem_cache_shutdown.cold+0x29/0x153
<4>[12577.319606]=C2=A0 shutdown_cache+0x13/0x1b0
<4>[12577.319609]=C2=A0 kmem_cache_destroy+0x239/0x260
<4>[12577.319628]=C2=A0 destroy_caches+0x3a/0x57 [ceph]
<4>[12577.319632]=C2=A0 __x64_sys_delete_module+0x13d/0x290
<4>[12577.319636]=C2=A0 ? exit_to_usermode_loop+0x94/0xd0
<4>[12577.319638]=C2=A0 do_syscall_64+0x5b/0x1b0
<4>[12577.319641]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
<4>[12577.319644] RIP: 0033:0x7eff79c6997b
<4>[12577.319647] Code: 73 01 c3 48 8b 0d 0d 45 0c 00 f7 d8 64 89 01 48=20
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00=20
0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 44 0c 00 f7 d8 64 89 01 48
<4>[12577.319648] RSP: 002b:00007ffd9d0f24c8 EFLAGS: 00000206 ORIG_RAX:=20
00000000000000b0
<4>[12577.319650] RAX: ffffffffffffffda RBX: 000055a5357457a0 RCX:=20
00007eff79c6997b
<4>[12577.319651] RDX: 000000000000000a RSI: 0000000000000800 RDI:=20
000055a535745808
<4>[12577.319652] RBP: 00007ffd9d0f2518 R08: 000000000000000a R09:=20
00007ffd9d0f1441
<4>[12577.319653] R10: 00007eff79cdeac0 R11: 0000000000000206 R12:=20
00007ffd9d0f26e0
<4>[12577.319654] R13: 00007ffd9d0f3f17 R14: 000055a535745260 R15:=20
00007ffd9d0f2520
<3>[12577.319660] INFO: Object 0x00000000a465a019 @offset=3D240
<3>[12577.319662]=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
<3>[12577.319664] BUG ceph_dentry_info (Tainted: G B=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 E=C2=A0=C2=A0=C2=A0 ):=20
Objects remaining in ceph_dentry_info on __kmem_cache_shutdown()
<3>[12577.319664]=20
-------------------------------------------------------------------------=
----
<3>[12577.319664]
<3>[12577.319666] INFO: Slab 0x00000000713366a2 objects=3D51 used=3D2=20
fp=3D0x00000000c5c96d72 flags=3D0x17ffe000000200
<4>[12577.319668] CPU: 1 PID: 1919 Comm: rmmod Tainted: G B=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 E=C2=A0=C2=A0=C2=A0=C2=A0=20
5.6.0-rc1+ #23
<4>[12577.319669] Hardware name: VMware, Inc. VMware Virtual=20
Platform/440BX Desktop Reference Platform, BIOS 6.00 05/19/2017
<4>[12577.319669] Call Trace:
<4>[12577.319671]=C2=A0 dump_stack+0x66/0x90
<4>[12577.319673]=C2=A0 slab_err+0xb7/0xdc
<4>[12577.319677]=C2=A0 ? printk+0x58/0x6f
<4>[12577.319679]=C2=A0 ? ksm_migrate_page+0xe0/0xe0
<4>[12577.319682]=C2=A0 __kmem_cache_shutdown.cold+0x29/0x153
<4>[12577.319684]=C2=A0 shutdown_cache+0x13/0x1b0
<4>[12577.319687]=C2=A0 kmem_cache_destroy+0x239/0x260
<4>[12577.319701]=C2=A0 destroy_caches+0x3a/0x57 [ceph]
<4>[12577.319703]=C2=A0 __x64_sys_delete_module+0x13d/0x290
<4>[12577.319706]=C2=A0 ? exit_to_usermode_loop+0x94/0xd0
<4>[12577.319709]=C2=A0 do_syscall_64+0x5b/0x1b0
<4>[12577.319711]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
<4>[12577.319712] RIP: 0033:0x7eff79c6997b
<4>[12577.319714] Code: 73 01 c3 48 8b 0d 0d 45 0c 00 f7 d8 64 89 01 48=20
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00=20
0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 44 0c 00 f7 d8 64 89 01 48
<4>[12577.319715] RSP: 002b:00007ffd9d0f24c8 EFLAGS: 00000206 ORIG_RAX:=20
00000000000000b0
<4>[12577.319716] RAX: ffffffffffffffda RBX: 000055a5357457a0 RCX:=20
00007eff79c6997b
<4>[12577.319717] RDX: 000000000000000a RSI: 0000000000000800 RDI:=20
000055a535745808
<4>[12577.319718] RBP: 00007ffd9d0f2518 R08: 000000000000000a R09:=20
00007ffd9d0f1441
<4>[12577.319719] R10: 00007eff79cdeac0 R11: 0000000000000206 R12:=20
00007ffd9d0f26e0
<4>[12577.319720] R13: 00007ffd9d0f3f17 R14: 000055a535745260 R15:=20
00007ffd9d0f2520
<3>[12577.319724] INFO: Object 0x000000000917f90f @offset=3D2800
<3>[12577.319725] INFO: Object 0x00000000cea9f98e @offset=3D2880
<3>[12577.319727] kmem_cache_destroy ceph_dentry_info: Slab cache still=20
has objects
<4>[12577.319728] CPU: 1 PID: 1919 Comm: rmmod Tainted: G B=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 E=C2=A0=C2=A0=C2=A0=C2=A0=20
5.6.0-rc1+ #23
<4>[12577.319729] Hardware name: VMware, Inc. VMware Virtual=20
Platform/440BX Desktop Reference Platform, BIOS 6.00 05/19/2017
<4>[12577.319729] Call Trace:
<4>[12577.319731]=C2=A0 dump_stack+0x66/0x90
<4>[12577.319733]=C2=A0 kmem_cache_destroy.cold+0x15/0x1a
<4>[12577.319747]=C2=A0 destroy_caches+0x3a/0x57 [ceph]
<4>[12577.319750]=C2=A0 __x64_sys_delete_module+0x13d/0x290
<4>[12577.319752]=C2=A0 ? exit_to_usermode_loop+0x94/0xd0
<4>[12577.319754]=C2=A0 do_syscall_64+0x5b/0x1b0
<4>[12577.319757]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
<4>[12577.319758] RIP: 0033:0x7eff79c6997b
<4>[12577.319759] Code: 73 01 c3 48 8b 0d 0d 45 0c 00 f7 d8 64 89 01 48=20
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00=20
0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd 44 0c 00 f7 d8 64 89 01 48
<4>[12577.319760] RSP: 002b:00007ffd9d0f24c8 EFLAGS: 00000206 ORIG_RAX:=20
00000000000000b0
<4>[12577.319761] RAX: ffffffffffffffda RBX: 000055a5357457a0 RCX:=20
00007eff79c6997b
<4>[12577.319762] RDX: 000000000000000a RSI: 0000000000000800 RDI:=20
000055a535745808
<4>[12577.319763] RBP: 00007ffd9d0f2518 R08: 000000000000000a R09:=20
00007ffd9d0f1441
<4>[12577.319764] R10: 00007eff79cdeac0 R11: 0000000000000206 R12:=20
00007ffd9d0f26e0
<4>[12577.319765] R13: 00007ffd9d0f3f17 R14: 000055a535745260 R15:=20
00007ffd9d0f2520
<5>[12577.343429] FS-Cache: Netfs 'ceph' unregistered from caching
<5>[12577.377374] Key type ceph unregistered
<5>[12824.742825] Key type ceph registered
<6>[12824.743522] libceph: loaded (mon/osd proto 15/24)
<5>[12824.754924] FS-Cache: Netfs 'ceph' registered for caching
<6>[12824.754931] ceph: loaded (mds proto 32)
<6>[12824.759841] libceph: mon0 (1)192.168.195.165:40289 session establis=
hed
<6>[12824.762760] libceph: client4296 fsid=20
f7621edd-ef06-4ca3-8a5b-1ba8c52ae15f
<4>[12891.829780] ceph: mdsmap_decode got incorrect state(up:creating)
<4>[12892.874795] ceph: mdsmap_decode got incorrect state(up:creating)
<6>[13362.740912] libceph: mon2 (1)192.168.195.165:40293 session establis=
hed
<6>[13362.743519] libceph: client4316 fsid=20
f7621edd-ef06-4ca3-8a5b-1ba8c52ae15f
<6>[13480.045907] libceph: mon2 (1)192.168.195.165:40293 session establis=
hed
<6>[13480.046889] libceph: client4319 fsid=20
f7621edd-ef06-4ca3-8a5b-1ba8c52ae15f


Thanks,

BRs


