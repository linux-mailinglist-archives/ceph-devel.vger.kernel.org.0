Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA8FAA24FB
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Aug 2019 20:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbfH2S1T (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 29 Aug 2019 14:27:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729326AbfH2SPe (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 29 Aug 2019 14:15:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B06FD2342B;
        Thu, 29 Aug 2019 18:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102533;
        bh=1AygM8Vd3GSX/fOlcCAGnWCFxkFENZvDPuie4ftI3pU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ew2xJK/o3U8uUfOIFSwJe4dgI6VxNIxRq/0FAzOE6vA/CBP1WSbBWcH2fYHCjStja
         6/h1WxWsBq/+Gkc9Zl8txUH33gq+60mv5mlre410UkPF53H4gsMamWz3nhem/IaImr
         YPkh5t5zfVXpoof/W3lGT8cw6GSxf3uHvAkNdOXA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luis Henriques <lhenriques@suse.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 68/76] ceph: fix buffer free while holding i_ceph_lock in fill_inode()
Date:   Thu, 29 Aug 2019 14:13:03 -0400
Message-Id: <20190829181311.7562-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Luis Henriques <lhenriques@suse.com>

[ Upstream commit af8a85a41734f37b67ba8ce69d56b685bee4ac48 ]

Calling ceph_buffer_put() in fill_inode() may result in freeing the
i_xattrs.blob buffer while holding the i_ceph_lock.  This can be fixed by
postponing the call until later, when the lock is released.

The following backtrace was triggered by fstests generic/070.

  BUG: sleeping function called from invalid context at mm/vmalloc.c:2283
  in_atomic(): 1, irqs_disabled(): 0, pid: 3852, name: kworker/0:4
  6 locks held by kworker/0:4/3852:
   #0: 000000004270f6bb ((wq_completion)ceph-msgr){+.+.}, at: process_one_work+0x1b8/0x5f0
   #1: 00000000eb420803 ((work_completion)(&(&con->work)->work)){+.+.}, at: process_one_work+0x1b8/0x5f0
   #2: 00000000be1c53a4 (&s->s_mutex){+.+.}, at: dispatch+0x288/0x1476
   #3: 00000000559cb958 (&mdsc->snap_rwsem){++++}, at: dispatch+0x2eb/0x1476
   #4: 000000000d5ebbae (&req->r_fill_mutex){+.+.}, at: dispatch+0x2fc/0x1476
   #5: 00000000a83d0514 (&(&ci->i_ceph_lock)->rlock){+.+.}, at: fill_inode.isra.0+0xf8/0xf70
  CPU: 0 PID: 3852 Comm: kworker/0:4 Not tainted 5.2.0+ #441
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58-prebuilt.qemu.org 04/01/2014
  Workqueue: ceph-msgr ceph_con_workfn
  Call Trace:
   dump_stack+0x67/0x90
   ___might_sleep.cold+0x9f/0xb1
   vfree+0x4b/0x60
   ceph_buffer_release+0x1b/0x60
   fill_inode.isra.0+0xa9b/0xf70
   ceph_fill_trace+0x13b/0xc70
   ? dispatch+0x2eb/0x1476
   dispatch+0x320/0x1476
   ? __mutex_unlock_slowpath+0x4d/0x2a0
   ceph_con_workfn+0xc97/0x2ec0
   ? process_one_work+0x1b8/0x5f0
   process_one_work+0x244/0x5f0
   worker_thread+0x4d/0x3e0
   kthread+0x105/0x140
   ? process_one_work+0x5f0/0x5f0
   ? kthread_park+0x90/0x90
   ret_from_fork+0x3a/0x50

Signed-off-by: Luis Henriques <lhenriques@suse.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/inode.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 3c7a32779574b..ca3821b0309f7 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -743,6 +743,7 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
 	int issued, new_issued, info_caps;
 	struct timespec64 mtime, atime, ctime;
 	struct ceph_buffer *xattr_blob = NULL;
+	struct ceph_buffer *old_blob = NULL;
 	struct ceph_string *pool_ns = NULL;
 	struct ceph_cap *new_cap = NULL;
 	int err = 0;
@@ -883,7 +884,7 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
 	if ((ci->i_xattrs.version == 0 || !(issued & CEPH_CAP_XATTR_EXCL))  &&
 	    le64_to_cpu(info->xattr_version) > ci->i_xattrs.version) {
 		if (ci->i_xattrs.blob)
-			ceph_buffer_put(ci->i_xattrs.blob);
+			old_blob = ci->i_xattrs.blob;
 		ci->i_xattrs.blob = xattr_blob;
 		if (xattr_blob)
 			memcpy(ci->i_xattrs.blob->vec.iov_base,
@@ -1023,8 +1024,8 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
 out:
 	if (new_cap)
 		ceph_put_cap(mdsc, new_cap);
-	if (xattr_blob)
-		ceph_buffer_put(xattr_blob);
+	ceph_buffer_put(old_blob);
+	ceph_buffer_put(xattr_blob);
 	ceph_put_string(pool_ns);
 	return err;
 }
-- 
2.20.1

