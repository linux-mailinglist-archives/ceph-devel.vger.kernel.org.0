Return-Path: <ceph-devel+bounces-1628-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FC519461E3
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Aug 2024 18:40:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 512221C20F69
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Aug 2024 16:40:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D8D7136322;
	Fri,  2 Aug 2024 16:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AxQTifAU"
X-Original-To: ceph-devel@vger.kernel.org
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE4816BE0E
	for <ceph-devel@vger.kernel.org>; Fri,  2 Aug 2024 16:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722616812; cv=none; b=dznWrcBodkWF5CoAzQbHuF30hiGiVnRXItdrlrxbXMGajtOkFAGZIXLfNgUQzy1t/RPBsDBKDiKoaoeihz9/ZFQ3PcXrKXIH2VqlLLXyy5ULnJkHOBMu/QTVXNyYMYVHpmwp1YP6S2PTq43T7GfS4wmxrlosU+NpJ4pdr6Lm04k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722616812; c=relaxed/simple;
	bh=Av3CMbOfqxeH/P0aQdA3DkZrIZsiQkzipEDbE4jG6Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TYO2lcoTz7S5nUbNc65GDR7zwq6ARG2+/3H0KLEokamQNtvARCdjmUuwFe+3kgf5n7CCiCBvGI+S2GKA7+wgBZTai7f/OjAW12gFFL1AEoxGYYwivD3NMb1d4HBx6Irb4AjEKMOHARFDswWIpTDSKrasAvSABbMDrjFeFoGp7S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AxQTifAU; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1722616807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vyYDckYfsFydPd+BpVoLXG24dl8LbFtGg3ZdMUVEJEo=;
	b=AxQTifAUNWUUn2o0AgHBJSxTHasBlfd9tT+8u6p9iSt+CpIUb44kRipKLX/Wk0z6ZhRJt0
	4DULaEZkSLiogxuL0Y6x+WytpUdmy+UHvMzFy70cku5NT35sjLC4UMy3bFVWTX/1+IWqUa
	CS+3nOAMfH4Rn/BUzGop9tRansgddAw=
From: Luis Henriques <luis.henriques@linux.dev>
To: Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org
Subject: ceph_read_iter NULL pointer dereference
Date: Fri, 02 Aug 2024 17:39:57 +0100
Message-ID: <87msluswte.fsf@linux.dev>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

Hi Xiubo,

I was wondering if you ever seen the BUG below.  I've debugged it a bit
and the issue seems occurs here, while doing the SetPageUptodate():

		if (ret <=3D 0)
			left =3D 0;
		else if (off + ret > i_size)
			left =3D i_size - off;
		else
			left =3D ret;
		while (left > 0) {
			size_t plen, copied;

			plen =3D min_t(size_t, left, PAGE_SIZE - page_off);
			SetPageUptodate(pages[idx]);
			copied =3D copy_page_to_iter(pages[idx++],
						   page_off, plen, to);
			off +=3D copied;
			left -=3D copied;
			page_off =3D 0;
			if (copied < plen) {
				ret =3D -EFAULT;
				break;
			}
		}

So, the issue is that we have idx > num_pages.  And I'm almost sure that's
because of i_size being '0' and 'left' ending up with a huge value.  But
haven't managed to figure out yet why i_size is '0'.

(Note: I'll be offline next week, but I'll continue looking into this the
week after.  But I figured I should report the bug anyway, in case you've
seen something similar.)

Cheers,
--=20
Lu=C3=ADs

BUG: kernel NULL pointer dereference, address: 0000000000000002=20=20
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
PGD 1032b4067 P4D 1032b4067 PUD 1032ce067 PMD 0=20
Oops: Oops: 0002 [#1] PREEMPT SMP=20=20=20
CPU: 0 UID: 0 PID: 427 Comm: python3 Not tainted 6.11.0-rc1+ #14
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-3-gd=
478f380-prebuilt.qemu.org 04/01/2014=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
RIP: 0010:__ceph_sync_read+0x4fd/0xa60=20=20=20=20=20
Code: 31 f6 4d 89 e7 4d 85 ff 0f 84 ed 03 00 00 ba 00 10 00 00 49 63 c6 48 =
29 f2 48 8d 04 c3 4c 39 fa 48 8b 08 49 0f 47 d7 49 89 d4 <f0> 80 09 08 48 8=
b 38 48 8b 4d b8 41 836
RSP: 0018:ffffc900008dfcb0 EFLAGS: 00010207=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20
RAX: ffff888101858000 RBX: ffff888101856000 RCX: 0000000000000002
RDX: 0000000000001000 RSI: 0000000000000000 RDI: 00000000282c61c0
RBP: ffffc900008dfd80 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000012c00 R12: 0000000000001000=20=20=20=
=20=20=20=20=20=20=20=20
R13: 0000000000421000 R14: 0000000000000400 R15: ffffffffffbdf000
FS:  00007f2eccd69040(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000002 CR3: 0000000103e0e000 CR4: 00000000000006b0
Call Trace:
 <TASK>
 ? __die+0x23/0x60
 ? page_fault_oops+0x158/0x450
 ? __ceph_sync_read+0x4fd/0xa60
 ? search_module_extables+0x4e/0x70
 ? exc_page_fault+0x2ab/0x880
 ? asm_exc_page_fault+0x26/0x30
 ? __ceph_sync_read+0x4fd/0xa60
 ceph_read_iter+0x3eb/0x8f0
 ? rcu_core+0x997/0xa60
 ? lock_release+0x148/0x2b0
 ? vfs_read+0x244/0x310
 vfs_read+0x244/0x310
 ksys_read+0x6d/0xf0
 do_syscall_64+0x71/0x140
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
RIP: 0033:0x7f2ecce6209d
Code: 31 c0 e9 c6 fe ff ff 50 48 8d 3d 66 55 0a 00 e8 89 fe 01 00 66 0f 1f =
84 00 00 00 00 00 80 3d 41 25 0e 00 00 74 17 31 c0 0f 05 <48> 3d 00 f0 ff f=
f 77 5b c3 66 2e 0f 1fc
RSP: 002b:00007ffcdaa10578 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 0000000000a840d8 RCX: 00007f2ecce6209d
RDX: 0000000000400000 RSI: 0000000027ec61c0 RDI: 0000000000000004
RBP: 00007f2eccd68fc0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000400000
R13: 0000000027ec61c0 R14: 0000000000000004 R15: 0000000000000000
 </TASK>
Modules linked in:
CR2: 0000000000000002
---[ end trace 0000000000000000 ]---
RIP: 0010:__ceph_sync_read+0x4fd/0xa60
Code: 31 f6 4d 89 e7 4d 85 ff 0f 84 ed 03 00 00 ba 00 10 00 00 49 63 c6 48 =
29 f2 48 8d 04 c3 4c 39 fa 48 8b 08 49 0f 47 d7 49 89 d4 <f0> 80 09 08 48 8=
b 38 48 8b 4d b8 41 836
RSP: 0018:ffffc900008dfcb0 EFLAGS: 00010207
RAX: ffff888101858000 RBX: ffff888101856000 RCX: 0000000000000002
RDX: 0000000000001000 RSI: 0000000000000000 RDI: 00000000282c61c0
RBP: ffffc900008dfd80 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000012c00 R12: 0000000000001000
R13: 0000000000421000 R14: 0000000000000400 R15: ffffffffffbdf000
FS:  00007f2eccd69040(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fac71216a40 CR3: 0000000103e0e000 CR4: 00000000000006b0

