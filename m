Return-Path: <ceph-devel+bounces-3549-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4431B4654F
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 23:16:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F678A44D30
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 21:16:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD5062F1FF4;
	Fri,  5 Sep 2025 21:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="QEqt2BR6"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E402F0681
	for <ceph-devel@vger.kernel.org>; Fri,  5 Sep 2025 21:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757106941; cv=none; b=Qm8tsXcgekrIovSSlzXTWKA57lMazLatWCG/slhDtSfCaw9/7Bu06kGOm8UhYc7G0W4Z4nKppP6xsY3YvaMvAFg1Fbvke+1PM9yD6vSJDOJCvBU+4UBtWLKh2ES+FrHdBkujEld2855Nmxe73+RVeGo98tQ1YhMQSGRlcu1Sodg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757106941; c=relaxed/simple;
	bh=ZbpTJpgq5eLZVl33raMdiFnvHNLuPpzwtxq8hWiMSh4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=InC/Edph4RrtoHW98oonibJumfILHc1GEgikKYtBQyKWOEcf/6BPftXEl+SMVp8NCPijGRMpIC3Hxh/UZFwWnaDbDoeqP8lNEx85bQ4Y4gpA69CHIalKN9DzTyo3cd/kBOIxWv+J1vyVMTTLRfzBmchQRArq0sI2qk2EeGhB83w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=QEqt2BR6; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b042cc3954fso450673866b.0
        for <ceph-devel@vger.kernel.org>; Fri, 05 Sep 2025 14:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1757106936; x=1757711736; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wo0Nm6QkVqDa5/FEJy5jxjvhuwrT2EEIYGSEnkzS3xU=;
        b=QEqt2BR6/Y+P4loZL4Fxi4YgPMVPzPDPExdrMSbcCzjV+Li2LxmIWA1JRN9IRDDJ3H
         STy7JFQnEmUgSpb6aa2g/JsGfyA+Abu1gFOLAnb9qTqmC0wJi7zXrxCj4MEaEiuMyeTJ
         +xNSOUFn0lS4VoaDn0mLoju+Vrd5z1M0ouuJBTk8l+Z/BsVL43/1SPld+0M+CsMky1jl
         8G2efjJGK6WylmPdsVcWlk6Zk/GmB84lhOpKw4OBd1nxE6Wl+9d7JZ2tN+S0ma06Phei
         M/LgcdA/srbQm4l+tgGs6F0CvoKSjsCGC0o5yDwLI30hCoBCJ33HrgoWFhuzFSAxjszd
         ouEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757106936; x=1757711736;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wo0Nm6QkVqDa5/FEJy5jxjvhuwrT2EEIYGSEnkzS3xU=;
        b=TFpxz002PkA/G6idYV6TnCKipzlB7by327iXLbELbuo9n2/iJVk6mDXrEGGojaU2/0
         SaLeO8OIRf0s8F/1IOQfFkRnSbL7b+vdIG5oYXrgJwEh+MolKJZ37EAt4vX4K1rj0g99
         OepgIUefBTs+qeKVO4nIZQ5A1J/+Xn2VekIdCUUnKvdN/tmoX0De6hNnVR6aYSJFQdR3
         MTafX1bxkXcsXQorrqICA1OZVumtTly8OmZRIYYlbH85AQTVTM+U+gD8JuQmEIMhNRm/
         dNlIhOeIFqGTY8tud4Exrh90LPJLtRcD3zwdx3narbWldjiO3RtwVFDP4EuHWQA0wAo6
         O+yg==
X-Forwarded-Encrypted: i=1; AJvYcCVybnkWf3YlDAXdJ90H3Lgs9zndtX3wKdCb5pt0nD86fsZNCB92+fNGQpnEx3m/cVYyNcOEwr/jSRF9@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5xVpOqjB5anrYG4w5anGR6pg9rmX3UKE5SUO4jrJoAeoOSMi+
	Yu7jfjqdV/OH3iHmb+doeJnNRvb54JGCBbWBjjgR8FXPoJEtsX8vSmGGCuyy+/w+CyI=
X-Gm-Gg: ASbGncuRbEJV5ZhOH7YwJVl2qivVVA9/7Q2AAcU5yA4OC/n01lvhudXu6TxnZzf6gXh
	W4JVq1zS4XR2diKzmcW87wonUhFhaqdoBfI5NA/sPTdQ3vosM1IZu9+JbEIBBw+5bW0HtWx185H
	iS0XB5w5JlQmvrJuCX6RAJwjeZvNMjNR+REPJbVVL8GogOPwH5sAo+9KHlUwdtEYyhaXq9Z1dMQ
	zc047OcHowg12HVhQQw5Uq+LQdgGgWT0iY3Ql1HiEs745vnkiTefZv7M77PYGP6HsyAT9q9/usB
	e8gk2vVlMpGiXCBHo/JK6/+ay9IdUXChUr1E1y94XTe/AK5VeluIkYXIfwPbWHGjsFLw1aq379u
	2pYP75Mkrvm1lb1XeeBl4ymTxtOlOXwhmhDcLyex6jzyGcfQFKKz9WzN6K3om/8BeNiUzQnfTWr
	85eCwCZEj97TgPWzQpwVpjtGqGd/4o8oLAJLRVgIJtkFfa
X-Google-Smtp-Source: AGHT+IEI0UMFbxLDbFHi93Xgr79JgLgv6e0CgFXtb2r6z2caSDYapP71MxTt7L0Jmccte/7ICI7YVw==
X-Received: by 2002:a17:907:3c92:b0:b04:1249:2b24 with SMTP id a640c23a62f3a-b04b1696062mr15691166b.37.1757106936248;
        Fri, 05 Sep 2025 14:15:36 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f356800023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f35:6800:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b047373afcesm604498166b.57.2025.09.05.14.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 14:15:35 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: slava.dubeyko@ibm.com,
	xiubli@redhat.com,
	idryomov@gmail.com,
	amarkuze@redhat.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>,
	stable@vger.kernel.org
Subject: [PATCH] fs/ceph/dir: fix `i_nlink` underrun during async unlink
Date: Fri,  5 Sep 2025 23:15:30 +0200
Message-ID: <20250905211530.43296-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During async unlink, we drop the `i_nlink` counter before we receive
the completion (that will eventually update the `i_nlink`) because "we
assume that the unlink will succeed".  That is not a bad idea, but it
races against deletions by other clients (or against the completion of
our own unlink) and can lead to an underrun which emits a WARNING like
this one:

 WARNING: CPU: 85 PID: 25093 at fs/inode.c:407 drop_nlink+0x50/0x68
 Modules linked in:
 CPU: 85 UID: 3221252029 PID: 25093 Comm: php-cgi8.1 Not tainted 6.14.11-cm4all1-ampere #655
 Hardware name: Supermicro ARS-110M-NR/R12SPD-A, BIOS 1.1b 10/17/2023
 pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : drop_nlink+0x50/0x68
 lr : ceph_unlink+0x6c4/0x720
 sp : ffff80012173bc90
 x29: ffff80012173bc90 x28: ffff086d0a45aaf8 x27: ffff0871d0eb5680
 x26: ffff087f2a64a718 x25: 0000020000000180 x24: 0000000061c88647
 x23: 0000000000000002 x22: ffff07ff9236d800 x21: 0000000000001203
 x20: ffff07ff9237b000 x19: ffff088b8296afc0 x18: 00000000f3c93365
 x17: 0000000000070000 x16: ffff08faffcbdfe8 x15: ffff08faffcbdfec
 x14: 0000000000000000 x13: 45445f65645f3037 x12: 34385f6369706f74
 x11: 0000a2653104bb20 x10: ffffd85f26d73290 x9 : ffffd85f25664f94
 x8 : 00000000000000c0 x7 : 0000000000000000 x6 : 0000000000000002
 x5 : 0000000000000081 x4 : 0000000000000481 x3 : 0000000000000000
 x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff08727d3f91e8
 Call trace:
  drop_nlink+0x50/0x68 (P)
  vfs_unlink+0xb0/0x2e8
  do_unlinkat+0x204/0x288
  __arm64_sys_unlinkat+0x3c/0x80
  invoke_syscall.constprop.0+0x54/0xe8
  do_el0_svc+0xa4/0xc8
  el0_svc+0x18/0x58
  el0t_64_sync_handler+0x104/0x130
  el0t_64_sync+0x154/0x158

In ceph_unlink(), a call to ceph_mdsc_submit_request() submits the
CEPH_MDS_OP_UNLINK to the MDS, but does not wait for completion.

Meanwhile, between this call and the following drop_nlink() call, a
worker thread may process a CEPH_CAP_OP_IMPORT, CEPH_CAP_OP_GRANT or
just a CEPH_MSG_CLIENT_REPLY (the latter of which could be our own
completion).  These will lead to a set_nlink() call, updating the
`i_nlink` counter to the value received from the MDS.  If that new
`i_nlink` value happens to be zero, it is illegal to decrement it
further.  But that is exactly what ceph_unlink() will do then.

The WARNING can be reproduced this way:

1. Force async unlink; only the async code path is affected.  Having
   no real clue about Ceph internals, I was unable to find out why the
   MDS wouldn't give me the "Fxr" capabilities, so I patched
   get_caps_for_async_unlink() to always succeed.

   (Note that the WARNING dump above was found on an unpatched kernel,
   without this kludge - this is not a theoretical bug.)

2. Add a sleep call after ceph_mdsc_submit_request() so the unlink
   completion gets handled by a worker thread before drop_nlink() is
   called.  This guarantees that the `i_nlink` is already zero before
   drop_nlink() runs.

The solution is to skip the counter decrement when it is already zero,
but doing so without a lock is still racy (TOCTOU).  Since
ceph_fill_inode() and handle_cap_grant() both hold the
`ceph_inode_info.i_ceph_lock` spinlock while set_nlink() runs, this
seems like the proper lock to protect the `i_nlink` updates.

I found prior art in NFS and SMB (using `inode.i_lock`) and AFS (using
`afs_vnode.cb_lock`).  All three have the zero check as well.

Fixes: 2ccb45462aea ("ceph: perform asynchronous unlink if we have sufficient caps")
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 fs/ceph/dir.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 8478e7e75df6..67f04e23f78a 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1341,6 +1341,7 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
 	struct ceph_client *cl = fsc->client;
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct inode *inode = d_inode(dentry);
+	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_request *req;
 	bool try_async = ceph_test_mount_opt(fsc, ASYNC_DIROPS);
 	struct dentry *dn;
@@ -1427,7 +1428,19 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
 			 * We have enough caps, so we assume that the unlink
 			 * will succeed. Fix up the target inode and dcache.
 			 */
-			drop_nlink(inode);
+
+			/*
+			 * Protect the i_nlink update with i_ceph_lock
+			 * to precent racing against ceph_fill_inode()
+			 * handling our completion on a worker thread
+			 * and don't decrement if i_nlink has already
+			 * been updated to zero by this completion.
+			 */
+			spin_lock(&ci->i_ceph_lock);
+			if (inode->i_nlink > 0)
+				drop_nlink(inode);
+			spin_unlock(&ci->i_ceph_lock);
+
 			d_delete(dentry);
 		} else {
 			spin_lock(&fsc->async_unlink_conflict_lock);
-- 
2.47.2


