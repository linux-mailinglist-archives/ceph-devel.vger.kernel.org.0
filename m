Return-Path: <ceph-devel+bounces-3878-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 223F4C0AB63
	for <lists+ceph-devel@lfdr.de>; Sun, 26 Oct 2025 15:52:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6C363B3945
	for <lists+ceph-devel@lfdr.de>; Sun, 26 Oct 2025 14:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3020B2E9EC4;
	Sun, 26 Oct 2025 14:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="boGwnm9W"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB2321255B;
	Sun, 26 Oct 2025 14:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490261; cv=none; b=McDmrW5a9efNxsfpLlFxTZovey7SHZcOMLrKy8Dnm2fGykQdJPI8v8aUlm1/haYcfx0AMH0nVPHMYSRy7bY5coGv2F9mYqEmAPO2Cc5ZH5AdWeWaP95gkexXloBxERBeGJgCVE9bIG3cI3gnuKZlq7mBslgf/4RBHVmcxmB3mrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490261; c=relaxed/simple;
	bh=dXeotwzdMhN+LIB60hZBFH4F856LOJKEQ6/9mVrYTV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D4E3wl79TiDZIU4ZlM+MQWFQwGZk9Y0LWzr8CMRaIhqhfq/XpXwE75KPYnIQs6JOTGuUOcNktEVxcuhdGaHGni16xM+IH1giTST90EaSSFc4zTCvVQw9L7B4PyY+NQ/ygOwzavwP8w7X+c0TwIiSEJXdgHZVs3TT6Q56JGhSp/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=boGwnm9W; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD418C4CEF1;
	Sun, 26 Oct 2025 14:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490260;
	bh=dXeotwzdMhN+LIB60hZBFH4F856LOJKEQ6/9mVrYTV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=boGwnm9WKvHYQzuIbX9dJZxavNfgACe3LZ9CJPLLGDNYOeWpRm1pr3eNrjVf6peoW
	 OH/V1SUy8j7TyGU1jceBWaLlXW0fuuBV8rM6WB4UOduOVO0u1moHGovb+YAYLVo8/c
	 B5wTiZAhFg7GWVZM2OZ6CryYft/YqFUbqdvbOnI1DhU+6xYH2JFT8+A0mPhHCYor4V
	 pHT+Oz0iuH0Nzz0MMY9fFgyfJqTTXISiBbhW4ZdEVOT4p4tTz/MGVgFbwH6YXKLkjg
	 9HDoWDYwlrCFc1yEdCMa/8JI36ZjQmL8UV+Yi1wdmnhUG7cKZdt+y3YpEZJZwlAwHn
	 R4lF61Rex/BbQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	xiubli@redhat.com,
	ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.6] ceph: refactor wake_up_bit() pattern of calling
Date: Sun, 26 Oct 2025 10:49:06 -0400
Message-ID: <20251026144958.26750-28-sashal@kernel.org>
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

[ Upstream commit 53db6f25ee47cb1265141d31562604e56146919a ]

The wake_up_bit() is called in ceph_async_unlink_cb(),
wake_async_create_waiters(), and ceph_finish_async_create().
It makes sense to switch on clear_bit() function, because
it makes the code much cleaner and easier to understand.
More important rework is the adding of smp_mb__after_atomic()
memory barrier after the bit modification and before
wake_up_bit() call. It can prevent potential race condition
of accessing the modified bit in other threads. Luckily,
clear_and_wake_up_bit() already implements the required
functionality pattern:

static inline void clear_and_wake_up_bit(int bit, unsigned long *word)
{
	clear_bit_unlock(bit, word);
	/* See wake_up_bit() for which memory barrier you need to use. */
	smp_mb__after_atomic();
	wake_up_bit(word, bit);
}

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – this patch fixes a real wakeup race in the Ceph client and is well
suited for stable backporting.
**Why Backport**
- clear_and_wake_up_bit at fs/ceph/dir.c:1263 and fs/ceph/file.c:582,764
  replaces the ad-hoc clear+wake sequence and injects the
  smp_mb__after_atomic() that wake_up_bit() demands, preventing stale-
  bit wakeups.
- Waiters in ceph_wait_on_async_create (fs/ceph/mds_client.h:657-662)
  and ceph_wait_on_conflict_unlink (fs/ceph/mds_client.c:836-885) depend
  on the bit being visible before the wake; otherwise wake_bit_function
  (kernel/sched/wait_bit.c:24-34) refuses to wake them and those threads
  can hang.
- Leveraging the helper also gives the release semantics of
  clear_bit_unlock (include/linux/wait_bit.h:550-556), so any state
  published before clearing di->flags or ci->i_ceph_flags becomes
  observable to the awakened waiters.

**Risk**
- Change is limited to swapping in an existing core helper within Ceph
  flag handling, so functional risk is minimal and there are no external
  dependencies.

Next steps: 1) If possible, run CephFS async create/unlink regression
tests or exercise the workloads that originally hit the wait-on-bit
stalls.

 fs/ceph/dir.c  | 3 +--
 fs/ceph/file.c | 6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 32973c62c1a23..d18c0eaef9b7e 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1260,8 +1260,7 @@ static void ceph_async_unlink_cb(struct ceph_mds_client *mdsc,
 	spin_unlock(&fsc->async_unlink_conflict_lock);
 
 	spin_lock(&dentry->d_lock);
-	di->flags &= ~CEPH_DENTRY_ASYNC_UNLINK;
-	wake_up_bit(&di->flags, CEPH_DENTRY_ASYNC_UNLINK_BIT);
+	clear_and_wake_up_bit(CEPH_DENTRY_ASYNC_UNLINK_BIT, &di->flags);
 	spin_unlock(&dentry->d_lock);
 
 	synchronize_rcu();
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 978acd3d4b329..d7b943feb9320 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -579,8 +579,7 @@ static void wake_async_create_waiters(struct inode *inode,
 
 	spin_lock(&ci->i_ceph_lock);
 	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
-		ci->i_ceph_flags &= ~CEPH_I_ASYNC_CREATE;
-		wake_up_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT);
+		clear_and_wake_up_bit(CEPH_ASYNC_CREATE_BIT, &ci->i_ceph_flags);
 
 		if (ci->i_ceph_flags & CEPH_I_ASYNC_CHECK_CAPS) {
 			ci->i_ceph_flags &= ~CEPH_I_ASYNC_CHECK_CAPS;
@@ -762,8 +761,7 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
 	}
 
 	spin_lock(&dentry->d_lock);
-	di->flags &= ~CEPH_DENTRY_ASYNC_CREATE;
-	wake_up_bit(&di->flags, CEPH_DENTRY_ASYNC_CREATE_BIT);
+	clear_and_wake_up_bit(CEPH_DENTRY_ASYNC_CREATE_BIT, &di->flags);
 	spin_unlock(&dentry->d_lock);
 
 	return ret;
-- 
2.51.0


