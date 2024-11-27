Return-Path: <ceph-devel+bounces-2200-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A85929DAC1B
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Nov 2024 17:54:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6991A283880
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Nov 2024 16:54:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2B08200BBB;
	Wed, 27 Nov 2024 16:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="iWUpNs9p"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com [209.85.218.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58ED1FF7A2
	for <ceph-devel@vger.kernel.org>; Wed, 27 Nov 2024 16:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732726455; cv=none; b=WlNHnbAGKOin834x/Yph5YaoRlHFzjj6H88yzjLMfdsH+uB54tclRSy0+weMS8TDBGoRUzO4N2YKaXLmzXXPD1c07Qp5tnz3Uca1kICeCazS3bKSVVa1amAsnF2cAJUQc7Jj4cJl1JP2UZMn3K0gJMUhIzpXNHQgEdYP4s8vY6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732726455; c=relaxed/simple;
	bh=S4eHcpglmeao1LGl/cJoGVX1FRppa+2e3o3Qu9TAWfg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j3/MllfiNm4I1W1UJHVOq7V0+yDu7r/YGnmBIO/UbhBeBEPT97Sc/sFPHfMYyUYYCKUj2hQjZG2TWNYoN8zAt8biiIYK9zL7onODDgQiQFYLklVayIGDIYm1XyPjgq6c1PiLoSa7etmRf/nNu/8s9wwAm86xB5cKTMaVEv/1fdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=iWUpNs9p; arc=none smtp.client-ip=209.85.218.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f67.google.com with SMTP id a640c23a62f3a-aa51b8c5f4dso731282966b.2
        for <ceph-devel@vger.kernel.org>; Wed, 27 Nov 2024 08:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1732726450; x=1733331250; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Y+Fql9pBERDSrejpdbF7yc4MdeEfFwTo3f5/cemLNsQ=;
        b=iWUpNs9pjdgD7CQNfWB/dDVEHiqdiNTI7j1dCbFOjhLF/IF8cpPG+ye9Yf980QBnC4
         u1fhZVb6zN21CwGSYcrNQtncsqqh2K4jZVv+hEBsFDhGBqUXQs0HwzfR5Ks+FvWN/m6i
         kzft0B6ZPJuyNBpySU04Ni0YnIxXEpRoHbDZfQLduP69IEQOuLse3TgwsOZn/HL41V8Q
         lp5Wl+xxkrYrzSCuxJE5YGsXLsr1Q+K/nzV2z02ziFccJWtRgLckfpbSbb9zGvrFUkHg
         Isb2+xexznUJX2MFmsRoe64JQ7U1pSnwICYWITTwN0gX1POj0UrWBYSL3g0nZiOl9HVU
         RR6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732726450; x=1733331250;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y+Fql9pBERDSrejpdbF7yc4MdeEfFwTo3f5/cemLNsQ=;
        b=VOns/lGJ2fGs6AvpIPMbc3UhNqWuZxjpMNHUb3Vzp8RqroUF/25gw89mS7CoWlzusI
         jAQXTvEqvAgyK50naEIu7nMA6iNYzUFDFSp3IdNpROa1ZIrmoenbCIWP/vhIedaS4rQo
         0aB9yQtRo078b7QifDwTnFDlfq1J0Ms+QACjHD53PAexOqxPw1BYXzKWIAfzzqUSCPLg
         WLdadyObJr9mjA7X+ZoJDlE7hr2nGD0CWywSobk7m3JzXw0jQV9C1BZIjT3ASEuSCxgf
         1Vec/6PbSTg/LufrHadIJTPAHEPS7s6S3dzPhzVyR+nHsoo/5wdDS1X4wmOsr3Sycrgo
         z1UA==
X-Forwarded-Encrypted: i=1; AJvYcCVDkabxS5rR7hiGCUsXAvMNgQSTDEGjzIB/0gw6KqU3oM6Wc8h/3m2aO/Z/dt6pT1XuOCBzzzCg76Yd@vger.kernel.org
X-Gm-Message-State: AOJu0YxwEC062ZtQYpiTzmi7pz/Ffr0jFyGHyOVKkMr/F7c20cKBOYsO
	wqJNHNiGAeesGDGuM4QtVF4eY0TSEZVe2cvr+77QGDJTZuYimHnuMX8dgksJXxDtaDxUIKNgqSm
	IiGCKzg==
X-Gm-Gg: ASbGnctDtWF0X12++fG39mOFeEuflUQ6Pu8JTO+uBCZTKQgMRCgZVgMkiFTIY+k+kva
	OmGIAdew0zRY9yCW6ba/eLt2JSug9qH+hw78wVqNPcrrLlSxmjO8Jwnen9rLriyeJ08kc9uPpQF
	BxSX1eIL6dZRCTg271kxt6aPnJq6/T5n+yqaqvrzmIfl7sSHVz3fk1J21Fy6n7xW5aVs4XraWtL
	BRy7TBE1cxIQNrzQjU6a2mgDuyyXElWIBD24XXzPncK8rMAnY5/eSAmPdV0fP1KFdZrmhxTe1oc
	JzTZat2r3VEvh2I93sSrJxLRUAOmEh2LEIriBhRR3M8ZXWbkpw==
X-Google-Smtp-Source: AGHT+IH2d3QQXMr5TVC8Z87qPqmiPtIEPUeEUvzAxF2WdXJsf53JysbCUBivaeZ9CUFU2/b/zOQk6Q==
X-Received: by 2002:a17:906:3caa:b0:aa5:4ca6:11b1 with SMTP id a640c23a62f3a-aa58106265dmr269711266b.52.1732726449886;
        Wed, 27 Nov 2024 08:54:09 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f2c8700023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f2c:8700:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa54a23545dsm442854766b.152.2024.11.27.08.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2024 08:54:09 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: xiubli@redhat.com,
	idryomov@gmail.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org,
	Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v2] fs/ceph/file: fix buffer overflow in __ceph_sync_read()
Date: Wed, 27 Nov 2024 17:54:05 +0100
Message-ID: <20241127165405.2676516-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the inode size gets truncated by another task, __ceph_sync_read()
may crash with a buffer overflow because it sets `left` to a huge
value:

  else if (off + ret > i_size)
          left = i_size - off;

Imagine `i_size` was truncated to zero; `off + ret > i_size` is always
true, but `i_size - off` can be negative; since `left` is unsigned, it
turns into a rather huge number, and thus the `while (left > 0)` loop
never stops until it eventually crashes because `pages[idx]` overflows
the `pages` allocation.

We need to ensure that `i_size` never becomes smaller than `off`.  I
suggest breaking from the loop as soon as this happens, right after
the `i_size = i_size_read(inode)` update.

This can be reproduced easily by running a program like this on one
Ceph client:

  ioctl(fd, CEPH_IOC_SYNCIO);
  char buffer[16384];
  while (1) pread(fd, buffer, sizeof(buffer), 8192);

Then, on another server, truncate and rewrite the file until the first
server's kernel crashes (I never needed more than two attempts to
trigger the kernel crash):

  dd if=/dev/urandom of=foo bs=1k count=64

This is how the crash looks like (with KASAN and some debug logs from
`__ceph_sync_read` and `ceph_fill_file_size`):

 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] ceph_fill_file_size: truncate_size 0 -> 0, encrypted 0
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: 8192~16384 got 16384 i_size 65536
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: result 16384 retry_op 0
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] ceph_fill_file_size: truncate_size 0 -> 0, encrypted 0
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] ceph_fill_file_size: truncate_size 0 -> 0, encrypted 0
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] ceph_fill_file_size: size 65536 -> 0
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] ceph_fill_file_size: truncate_seq 36656 -> 36657
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] ceph_fill_file_size: truncate_size 0 -> 0, encrypted 0
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] ceph_fill_file_size: truncate_size 0 -> 0, encrypted 0
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: on inode 0000000035059a6f 1000235edb7.fffffffffffffffe 2000~4000
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: orig 8192~16384 reading 8192~16384
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] ceph_fill_file_size: truncate_size 0 -> 0, encrypted 0
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: 8192~16384 got 0 i_size 0
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: result 0 retry_op 0
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: on inode 0000000035059a6f 1000235edb7.fffffffffffffffe 2000~4000
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: orig 8192~16384 reading 8192~16384
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: 8192~16384 got 0 i_size 0
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: result 0 retry_op 0
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: on inode 0000000035059a6f 1000235edb7.fffffffffffffffe 2000~4000
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: orig 8192~16384 reading 8192~16384
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] ceph_fill_file_size: truncate_size 0 -> 0, encrypted 0
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: 8192~16384 got 0 i_size 0
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: result 0 retry_op 0
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: on inode 0000000035059a6f 1000235edb7.fffffffffffffffe 2000~4000
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: orig 8192~16384 reading 8192~16384
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: 8192~16384 got 0 i_size 0
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: result 0 retry_op 0
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: on inode 0000000035059a6f 1000235edb7.fffffffffffffffe 2000~4000
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: orig 8192~16384 reading 8192~16384
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: 8192~16384 got 0 i_size 0
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: result 0 retry_op 0
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: on inode 0000000035059a6f 1000235edb7.fffffffffffffffe 2000~4000
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: orig 8192~16384 reading 8192~16384
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: 8192~16384 got 0 i_size 0
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: result 0 retry_op 0
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: on inode 0000000035059a6f 1000235edb7.fffffffffffffffe 2000~4000
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: orig 8192~16384 reading 8192~16384
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: 8192~16384 got 0 i_size 0
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: result 0 retry_op 0
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: on inode 0000000035059a6f 1000235edb7.fffffffffffffffe 2000~4000
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: orig 8192~16384 reading 8192~16384
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] __ceph_sync_read: 8192~16384 got 1024 i_size 0
 ==================================================================
 BUG: KASAN: slab-out-of-bounds in __ceph_sync_read+0x173f/0x1b10
 Read of size 8 at addr ffff8881d5dfbea0 by task pread/3276

 CPU: 3 UID: 2147488069 PID: 3276 Comm: pread Not tainted 6.11.10-cm4all1-hp+ #254
 Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380 Gen10, BIOS U30 09/05/2019
 Call Trace:
  <TASK>
  dump_stack_lvl+0x62/0x90
  print_report+0xc4/0x5e0
  ? __virt_addr_valid+0x1e9/0x3a0
  ? __ceph_sync_read+0x173f/0x1b10
  kasan_report+0xb9/0xf0
  ? __ceph_sync_read+0x173f/0x1b10
  __ceph_sync_read+0x173f/0x1b10
  ? __pfx___ceph_sync_read+0x10/0x10
  ? lock_acquire+0x186/0x4d0
  ? ceph_read_iter+0xace/0x19f0
  ceph_read_iter+0xace/0x19f0
  ? lock_release+0x648/0xb50
  ? __pfx_ceph_read_iter+0x10/0x10
  ? __rseq_handle_notify_resume+0x8ed/0xd40
  ? __pfx___rseq_handle_notify_resume+0x10/0x10
  ? vfs_read+0x6e0/0xba0
  vfs_read+0x6e0/0xba0
  ? __pfx_vfs_read+0x10/0x10
  ? syscall_exit_to_user_mode+0x9a/0x190
  ? syscall_exit_to_user_mode+0x9a/0x190
  __x64_sys_pread64+0x19b/0x1f0
  ? __pfx___x64_sys_pread64+0x10/0x10
  ? __pfx___rseq_handle_notify_resume+0x10/0x10
  do_syscall_64+0x82/0x130
  ? lockdep_hardirqs_on_prepare+0x275/0x3e0
  ? syscall_exit_to_user_mode+0x9a/0x190
  ? do_syscall_64+0x8e/0x130
  ? do_syscall_64+0x8e/0x130
  ? lockdep_hardirqs_on_prepare+0x275/0x3e0
  ? syscall_exit_to_user_mode+0x9a/0x190
  ? do_syscall_64+0x8e/0x130
  ? do_syscall_64+0x8e/0x130
  ? syscall_exit_to_user_mode+0x9a/0x190
  ? do_syscall_64+0x8e/0x130
  entry_SYSCALL_64_after_hwframe+0x76/0x7e
 RIP: 0033:0x7f8449d18343
 Code: 48 8b 6c 24 48 e8 3d 00 f3 ff 41 b8 02 00 00 00 e9 38 f6 ff ff 66 90 80 3d a1 42 0e 00 00 49 89 ca 74 14 b8 11 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 5d c3 0f 1f 40 00 48 83 ec 28 48 89 54 24 10
 RSP: 002b:00007ffd7a2e8b78 EFLAGS: 00000202 ORIG_RAX: 0000000000000011
 RAX: ffffffffffffffda RBX: 00007ffd7a2e8cc8 RCX: 00007f8449d18343
 RDX: 0000000000004000 RSI: 0000557f7917c2a0 RDI: 0000000000000003
 RBP: 00007ffd7a2e8bb0 R08: 0000557f7919d000 R09: 0000000000021001
 R10: 0000000000002000 R11: 0000000000000202 R12: 0000000000000000
 R13: 00007ffd7a2e8cf0 R14: 0000557f436c2dd8 R15: 00007f8449e43020
  </TASK>

 Allocated by task 3276:
  kasan_save_stack+0x1c/0x40
  kasan_save_track+0x10/0x30
  __kasan_kmalloc+0x8b/0x90
  __kmalloc_noprof+0x1bf/0x490
  ceph_alloc_page_vector+0x36/0x110
  __ceph_sync_read+0x769/0x1b10
  ceph_read_iter+0xace/0x19f0
  vfs_read+0x6e0/0xba0
  __x64_sys_pread64+0x19b/0x1f0
  do_syscall_64+0x82/0x130
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

 The buggy address belongs to the object at ffff8881d5dfbe80
  which belongs to the cache kmalloc-32 of size 32
 The buggy address is located 0 bytes to the right of
  allocated 32-byte region [ffff8881d5dfbe80, ffff8881d5dfbea0)

 The buggy address belongs to the physical page:
 page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1d5dfb
 flags: 0x2fffc0000000000(node=0|zone=2|lastcpupid=0x3fff)
 page_type: 0xfdffffff(slab)
 raw: 02fffc0000000000 ffff888100042780 dead000000000122 0000000000000000
 raw: 0000000000000000 0000000080400040 00000001fdffffff 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ffff8881d5dfbd80: fa fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8881d5dfbe00: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
 >ffff8881d5dfbe80: 00 00 00 00 fc fc fc fc fa fb fb fb fc fc fc fc
                                ^
  ffff8881d5dfbf00: fc fc fc fc fc fc fc fc fa fb fb fb fc fc fc fc
  ffff8881d5dfbf80: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
 ==================================================================
 Disabling lock debugging due to kernel taint
 Oops: general protection fault, probably for non-canonical address 0xe021fc6b8000019a: 0000 [#1] SMP KASAN PTI
 KASAN: maybe wild-memory-access in range [0x0110035c00000cd0-0x0110035c00000cd7]
 CPU: 3 UID: 2147488069 PID: 3276 Comm: pread Tainted: G    B              6.11.10-cm4all1-hp+ #254
 Tainted: [B]=BAD_PAGE
 Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380 Gen10, BIOS U30 09/05/2019
 RIP: 0010:__ceph_sync_read+0xc33/0x1b10
 Code: 39 e7 4d 0f 47 fc 48 8d 0c c6 48 89 c8 48 c1 e8 03 42 80 3c 30 00 0f 85 0b 0b 00 00 48 8b 11 48 8d 7a 08 48 89 f8 48 c1 e8 03 <42> 80 3c 30 00 0f 85 0d 0b 00 00 48 8b 42 08 a8 01 0f 84 ee 04 00
 RSP: 0018:ffff8881ed6e78e0 EFLAGS: 00010207
 RAX: 0022006b8000019a RBX: 0000000000000000 RCX: ffff8881d5dfbea0
 RDX: 0110035c00000ccc RSI: 0000000000000008 RDI: 0110035c00000cd4
 RBP: ffff8881ed6e7a80 R08: 0000000000000001 R09: fffffbfff28b44ac
 R10: ffffffff945a2567 R11: 0000000000000001 R12: ffffffffffffa000
 R13: 0000000000000004 R14: dffffc0000000000 R15: 0000000000001000
 FS:  00007f8449c1f740(0000) GS:ffff88d2b5a00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007fb72c6aecf0 CR3: 00000001ed7b6003 CR4: 00000000007706f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
  <TASK>
  ? die_addr+0x3c/0xa0
  ? exc_general_protection+0x113/0x200
  ? asm_exc_general_protection+0x22/0x30
  ? __ceph_sync_read+0xc33/0x1b10
  ? __pfx___ceph_sync_read+0x10/0x10
  ? lock_acquire+0x186/0x4d0
  ? ceph_read_iter+0xace/0x19f0
  ceph_read_iter+0xace/0x19f0
  ? lock_release+0x648/0xb50
  ? __pfx_ceph_read_iter+0x10/0x10
  ? __rseq_handle_notify_resume+0x8ed/0xd40
  ? __pfx___rseq_handle_notify_resume+0x10/0x10
  ? vfs_read+0x6e0/0xba0
  vfs_read+0x6e0/0xba0
  ? __pfx_vfs_read+0x10/0x10
  ? syscall_exit_to_user_mode+0x9a/0x190
  ? syscall_exit_to_user_mode+0x9a/0x190
  __x64_sys_pread64+0x19b/0x1f0
  ? __pfx___x64_sys_pread64+0x10/0x10
  ? __pfx___rseq_handle_notify_resume+0x10/0x10
  do_syscall_64+0x82/0x130
  ? lockdep_hardirqs_on_prepare+0x275/0x3e0
  ? syscall_exit_to_user_mode+0x9a/0x190
  ? do_syscall_64+0x8e/0x130
  ? do_syscall_64+0x8e/0x130
  ? lockdep_hardirqs_on_prepare+0x275/0x3e0
  ? syscall_exit_to_user_mode+0x9a/0x190
  ? do_syscall_64+0x8e/0x130
  ? do_syscall_64+0x8e/0x130
  ? syscall_exit_to_user_mode+0x9a/0x190
  ? do_syscall_64+0x8e/0x130
  entry_SYSCALL_64_after_hwframe+0x76/0x7e
 RIP: 0033:0x7f8449d18343
 Code: 48 8b 6c 24 48 e8 3d 00 f3 ff 41 b8 02 00 00 00 e9 38 f6 ff ff 66 90 80 3d a1 42 0e 00 00 49 89 ca 74 14 b8 11 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 5d c3 0f 1f 40 00 48 83 ec 28 48 89 54 24 10
 RSP: 002b:00007ffd7a2e8b78 EFLAGS: 00000202 ORIG_RAX: 0000000000000011
 RAX: ffffffffffffffda RBX: 00007ffd7a2e8cc8 RCX: 00007f8449d18343
 RDX: 0000000000004000 RSI: 0000557f7917c2a0 RDI: 0000000000000003
 RBP: 00007ffd7a2e8bb0 R08: 0000557f7919d000 R09: 0000000000021001
 R10: 0000000000002000 R11: 0000000000000202 R12: 0000000000000000
 R13: 00007ffd7a2e8cf0 R14: 0000557f436c2dd8 R15: 00007f8449e43020
  </TASK>
 Modules linked in:
 ---[ end trace 0000000000000000 ]---
 RIP: 0010:__ceph_sync_read+0xc33/0x1b10
 Code: 39 e7 4d 0f 47 fc 48 8d 0c c6 48 89 c8 48 c1 e8 03 42 80 3c 30 00 0f 85 0b 0b 00 00 48 8b 11 48 8d 7a 08 48 89 f8 48 c1 e8 03 <42> 80 3c 30 00 0f 85 0d 0b 00 00 48 8b 42 08 a8 01 0f 84 ee 04 00
 RSP: 0018:ffff8881ed6e78e0 EFLAGS: 00010207
 RAX: 0022006b8000019a RBX: 0000000000000000 RCX: ffff8881d5dfbea0
 RDX: 0110035c00000ccc RSI: 0000000000000008 RDI: 0110035c00000cd4
 RBP: ffff8881ed6e7a80 R08: 0000000000000001 R09: fffffbfff28b44ac
 R10: ffffffff945a2567 R11: 0000000000000001 R12: ffffffffffffa000
 R13: 0000000000000004 R14: dffffc0000000000 R15: 0000000000001000
 FS:  00007f8449c1f740(0000) GS:ffff88d2b5a00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007fb72c6aecf0 CR3: 00000001ed7b6003 CR4: 00000000007706f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 55555554
 workqueue: ceph_con_workfn hogged CPU for >10000us 35 times, consider switching to WQ_UNBOUND
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] ceph_fill_file_size: size 0 -> 65536
 ceph:  [8f7ec2f3-0dcb-468f-bd16-37e0a61bf195 4098067] ceph_fill_file_size: truncate_size 0 -> 0, encrypted 0

Fixes: 1065da21e5df ("ceph: stop copying to iter at EOF on sync reads")
Fixes: https://tracker.ceph.com/issues/67524
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
v2: public posting; added link to Ceph bug tracker (vulnerability had
been known already for 3 months)
---
 fs/ceph/file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 4b8d59ebda00..57d7cdda0f87 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1154,6 +1154,13 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		doutc(cl, "%llu~%llu got %zd i_size %llu%s\n", off, len,
 		      ret, i_size, (more ? " MORE" : ""));
 
+		if (off >= i_size)
+			/* meanwhile, the file has been truncated by
+			 * another task and the offset is no longer
+			 * valid; stop here
+			 */
+			break;
+
 		/* Fix it to go to end of extent map */
 		if (sparse && ret >= 0)
 			ret = ceph_sparse_ext_map_end(op);
-- 
2.45.2


