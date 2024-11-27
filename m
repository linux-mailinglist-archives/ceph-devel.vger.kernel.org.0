Return-Path: <ceph-devel+bounces-2206-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 14C1D9DAEDD
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Nov 2024 22:21:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1669C166B58
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Nov 2024 21:21:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33B4D2036EE;
	Wed, 27 Nov 2024 21:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="gxhBTWRa"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com [209.85.221.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CEC2036E3
	for <ceph-devel@vger.kernel.org>; Wed, 27 Nov 2024 21:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732742498; cv=none; b=Qog5+TQVlpaHzqD0VVWNzGhiN2C0+HlWU9Js/vzx534N1uzEpzjqoF8JKnm4qYnJzPn9LKl073WvLNHgK+/yLviH4T80LfLuTAV/fzoZeYby7qvAje5LAjygXopkWdBESVhoLCsbirQyLwDzYsjfZE/jRQSWPfa6zAWWEmWk2j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732742498; c=relaxed/simple;
	bh=rPTniYQST2LX56hL3IAn0a87LvGKVrQ9Wttax9WpO58=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hUC8WvfuowQDUsWpTsK+sw9u/JXwyLQ+cfHJ5wh4fM5aYmqN/wRJ9XC+iktLzP++VNdtj+L+l1VEg5eKolw/BOflnJopsD5urTefVvs51kl6MXPoa683myBxX9HZl3dpz2BDYm5nESaV1Tm9rgdZFW8U6riFRMT4Q/L//do3iiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=gxhBTWRa; arc=none smtp.client-ip=209.85.221.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-wr1-f66.google.com with SMTP id ffacd0b85a97d-38230ed9baeso125992f8f.1
        for <ceph-devel@vger.kernel.org>; Wed, 27 Nov 2024 13:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1732742493; x=1733347293; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sfbd6zr4WusYwlFGb5dpOn7y9zqZFAu0taySTTD+C0w=;
        b=gxhBTWRaW3swxEYRGIxQjJSuChSdG+2u7UhiGMg+X5gpluWjmaQn+9zldmhdL9uOu+
         pAeyTiS8qNrwSO0OEe8oTn9gqWs9nxXyCbSO75jl3Ezw5MqwX57QobvSwB2pKYbrc2C0
         SDLE2rinDxaQNtyQtzVjyxcIH9cCN6EgH60xNfqa2f8aKB166yTD97NGMqMeXXSspaZS
         xKyS5YKBYVbJytI1ikGz1x+pu9Mg1jHQvjUyHPlunnIRiVBFpWCnDE9mI9xycHfEsjbY
         e14gVl/92TvsPU84TXP9L0mScjxn1Adr/1U5oplJgiWD6E1LJFmbbe917fQ5hT2KHSAi
         DdCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732742493; x=1733347293;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sfbd6zr4WusYwlFGb5dpOn7y9zqZFAu0taySTTD+C0w=;
        b=w6AeT6tfjJDYYX2g/cKWmYowdV7vKNddK3KmNjrhD+lkfIf1ckoz83vyOq9cBCUvxm
         dtgkeC5acigxxruyWcSSlIr4IjoIPpdIhJakmI/wnnlo2uLeqFg9feEx0NZwcD4jRRPb
         DoCo5oU2HdIeRwlguHUFjMHVJAy3WJCJdry9Tf63YvnKxHTWdUZdjXiTb8HxthSjm89m
         7HY+KRtOd2xm8+zN/T5N6ccyffyUbOmTqpDgz5yJBikdWZMIYSjitGoVTa89OJyCUGS3
         +Ym+DKpZ6WLLP+Zp/RhUTWC4/2Y6SW4oENpAuByDqWEnaY/1s9j9aGPbwOXdQT5Y93Jo
         DBqw==
X-Forwarded-Encrypted: i=1; AJvYcCU7RSnCf4pM+sCRClVllhADjopUeGj3h1OLakM9+Wzta4YjWyaFRYW2+ZmrIz23u0ipWq5wynvCPrOF@vger.kernel.org
X-Gm-Message-State: AOJu0YzxdTOUx1fxmfR9pVvEE5KTUzjLkRGFaYmVjySnIrSefh7ioKo/
	+/ntH36BGJv5AT2YcddCQLoXBzCeFMEPDIgXmm7Tw06NTiz7I7a/0OGbvW0hAms=
X-Gm-Gg: ASbGncuOj91oxYLzUfH2dt7v3C/SNICwJN8TylX6vH0h40fBTJ08XL75d4qgbRgxQx8
	HQK9hE8aYWEfouLhAfHPHtDGXGVwrxyPN9C10r0Hz4CNdca+KNiYmexRorsTNiPeDV5URGi1jus
	+/cmZ/esmvxceCLICSUvDewOv6+dWYRyFBX5UF9+EqRUKzQbbhiJEU3JvCk4EcVeoJUi+HBe8s5
	WQrhwQeDiqznXkKB48nRoaVNN9uinrdbsQ9BGLWRXAQkgixogBKo1is6Ih0pOsmjGVaJG7GWCtX
	zFBfZLTwXIfyunHbMs4kpFHzcJO6aiS3b0sTEBTv1HMwNRTcOQ==
X-Google-Smtp-Source: AGHT+IEFXg9qIPS98sD/f5eOvNVK1li5TqAcZmPXigzvIhDP7IxYcPP1lYKtrz0Q3kajch1ijwXQVw==
X-Received: by 2002:a05:6000:4819:b0:382:38e6:1ee3 with SMTP id ffacd0b85a97d-385c6ebd102mr4136346f8f.16.1732742492911;
        Wed, 27 Nov 2024 13:21:32 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f2c8700023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f2c:8700:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fad6270sm17162268f8f.14.2024.11.27.13.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2024 13:21:32 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: amarkuze@redhat.com,
	xiubli@redhat.com,
	idryomov@gmail.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org,
	Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v3] fs/ceph/file: fix buffer overflow in __ceph_sync_read()
Date: Wed, 27 Nov 2024 22:21:30 +0100
Message-ID: <20241127212130.2704804-1-max.kellermann@ionos.com>
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
v3: memory leak fix
---
 fs/ceph/file.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 4b8d59ebda00..1f0aed6cd9d5 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1154,6 +1154,16 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		doutc(cl, "%llu~%llu got %zd i_size %llu%s\n", off, len,
 		      ret, i_size, (more ? " MORE" : ""));
 
+		if (off >= i_size) {
+			/* meanwhile, the file has been truncated by
+			 * another task and the offset is no longer
+			 * valid; stop here
+			 */
+			ceph_release_page_vector(pages, num_pages);
+			ceph_osdc_put_request(req);
+			break;
+		}
+
 		/* Fix it to go to end of extent map */
 		if (sparse && ret >= 0)
 			ret = ceph_sparse_ext_map_end(op);
-- 
2.45.2


