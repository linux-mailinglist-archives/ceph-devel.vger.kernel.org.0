Return-Path: <ceph-devel+bounces-3879-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E168C0AB69
	for <lists+ceph-devel@lfdr.de>; Sun, 26 Oct 2025 15:52:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AC333B2CDA
	for <lists+ceph-devel@lfdr.de>; Sun, 26 Oct 2025 14:51:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 227EB2E9ED1;
	Sun, 26 Oct 2025 14:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ha8pX/N+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B702E8E11;
	Sun, 26 Oct 2025 14:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490263; cv=none; b=C1OstHEEJvkfjYMdlafgUeAVn9alrnw+GCsiuptTFE7fEZB8RB/6NHMMwOVyEEaN07TsbUBs5pEm1X2f3Z7ySzEtTM//2ljM3yieCcF5SkKdL1iH6kKe1shxBNJ9dO9PLSkTq8HP//V0iDA1j7oEodNQGldd57m7XBxy79DWAx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490263; c=relaxed/simple;
	bh=HlMAJ9IaNZcUJiFMGnYe3oG9DwObQe8LVhMD4NTvCpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LgJLmnmNS3L9o52F2fUPeEUDMeihA2feLTyOQhC5zZKvTkdtKn/bE0Hbgi3VjzD3pWIcFqDm5svLKhqKZTrZPmZEObLiatTkECNcWwRri6N1vgrjBfgdU8tjYaXhkbCbCr83/7kLlAvUNxeiQQLoiKvuLmQ4eawC6LYR3FM663o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ha8pX/N+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B61AC4CEFB;
	Sun, 26 Oct 2025 14:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490263;
	bh=HlMAJ9IaNZcUJiFMGnYe3oG9DwObQe8LVhMD4NTvCpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ha8pX/N+Xihww4TrFDpgE+t16LQM3Jc5N3Sdv3cr4fqpZYwdBKhGO6SxOmTYPZGtM
	 zGQN9cUCcyxswNucZHr4zzG06Ke+kyh5JedffNOQ/FjVm4kI9DZ8iFRqRqy4lrzsmY
	 MM41Hhnaw0N467YeHlwKRusnmANs5eRpZDCvGmb96MI1cUBcmZprwETjQzLOkHG5bu
	 HcQdim7/dVOleQAykhEr0zbCkFfAU39ZLPTJ/k8GduTFeohanEqPEk6kcw6ZHg87oy
	 1xah2+gULWXfGWv2HofbZcnO2grGz9EyD8FCbGGfYBXy8ehix8ulwpTCs6EGC8o9Xu
	 X26TCwzf+BmoA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	xiubli@redhat.com,
	ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] ceph: fix potential race condition in ceph_ioctl_lazyio()
Date: Sun, 26 Oct 2025 10:49:08 -0400
Message-ID: <20251026144958.26750-30-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026144958.26750-1-sashal@kernel.org>
References: <20251026144958.26750-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

[ Upstream commit 5824ccba9a39a3ad914fc9b2972a2c1119abaac9 ]

The Coverity Scan service has detected potential
race condition in ceph_ioctl_lazyio() [1].

The CID 1591046 contains explanation: "Check of thread-shared
field evades lock acquisition (LOCK_EVASION). Thread1 sets
fmode to a new value. Now the two threads have an inconsistent
view of fmode and updates to fields correlated with fmode
may be lost. The data guarded by this critical section may
be read while in an inconsistent state or modified by multiple
racing threads. In ceph_ioctl_lazyio: Checking the value of
a thread-shared field outside of a locked region to determine
if a locked operation involving that thread shared field
has completed. (CWE-543)".

The patch places fi->fmode field access under ci->i_ceph_lock
protection. Also, it introduces the is_file_already_lazy
variable that is set under the lock and it is checked later
out of scope of critical section.

[1] https://scan5.scan.coverity.com/#/project-view/64304/10063?selectedIssue=1591046

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- The race arises because the pre-patch code reads `fi->fmode` without
  holding `ci->i_ceph_lock`, so two threads can both see the lazy bit
  clear, then each increment
  `ci->i_nr_by_mode[ffs(CEPH_FILE_MODE_LAZY)]++` before either releases
  the lock. That leaves the counter permanently elevated,
  desynchronising the per-mode counts that `ceph_put_fmode()` relies on
  to drop capability refs (`fs/ceph/ioctl.c` before line 212, contrasted
  with `fs/ceph/caps.c:4744-4789`).
- The patch now performs the test and update while the lock is held
  (`fs/ceph/ioctl.c:212-220`), eliminating the window where concurrent
  callers can both act on stale state; the new `is_file_already_lazy`
  flag preserves the existing logging/`ceph_check_caps()` calls after
  the lock is released (`fs/ceph/ioctl.c:221-228`) so behaviour remains
  unchanged aside from closing the race.
- Keeping `i_nr_by_mode` accurate is important beyond metrics: it feeds
  `__ceph_caps_file_wanted()` when deciding what caps to request or drop
  (`fs/ceph/caps.c:1006-1061`). With the race, a leaked lazy count
  prevents the last close path from seeing the inode as idle, delaying
  capability release and defeating the lazyio semantics the ioctl is
  supposed to provide.
- The change is tightly scoped (one function, no API or struct changes,
  same code paths still call `__ceph_touch_fmode()` and
  `ceph_check_caps()`), so regression risk is minimal while the fix
  hardens a locking invariant already respected by other fmode
  transitions such as `ceph_get_fmode()` (`fs/ceph/caps.c:4727-4754`).
- No newer infrastructure is required—the fields, lock, and helpers
  touched here have existed in long-term stable kernels—so this bug fix
  is suitable for stable backporting despite the likely need to adjust
  the `doutc` helper name on older branches.

 fs/ceph/ioctl.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
index e861de3c79b9e..15cde055f3da1 100644
--- a/fs/ceph/ioctl.c
+++ b/fs/ceph/ioctl.c
@@ -246,21 +246,28 @@ static long ceph_ioctl_lazyio(struct file *file)
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_client *mdsc = ceph_inode_to_fs_client(inode)->mdsc;
 	struct ceph_client *cl = mdsc->fsc->client;
+	bool is_file_already_lazy = false;
 
+	spin_lock(&ci->i_ceph_lock);
 	if ((fi->fmode & CEPH_FILE_MODE_LAZY) == 0) {
-		spin_lock(&ci->i_ceph_lock);
 		fi->fmode |= CEPH_FILE_MODE_LAZY;
 		ci->i_nr_by_mode[ffs(CEPH_FILE_MODE_LAZY)]++;
 		__ceph_touch_fmode(ci, mdsc, fi->fmode);
-		spin_unlock(&ci->i_ceph_lock);
+	} else {
+		is_file_already_lazy = true;
+	}
+	spin_unlock(&ci->i_ceph_lock);
+
+	if (is_file_already_lazy) {
+		doutc(cl, "file %p %p %llx.%llx already lazy\n", file, inode,
+		      ceph_vinop(inode));
+	} else {
 		doutc(cl, "file %p %p %llx.%llx marked lazy\n", file, inode,
 		      ceph_vinop(inode));
 
 		ceph_check_caps(ci, 0);
-	} else {
-		doutc(cl, "file %p %p %llx.%llx already lazy\n", file, inode,
-		      ceph_vinop(inode));
 	}
+
 	return 0;
 }
 
-- 
2.51.0


