Return-Path: <ceph-devel+bounces-3876-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E49BC0AAEB
	for <lists+ceph-devel@lfdr.de>; Sun, 26 Oct 2025 15:50:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3ED494E9664
	for <lists+ceph-devel@lfdr.de>; Sun, 26 Oct 2025 14:50:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAB482E8E10;
	Sun, 26 Oct 2025 14:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="loD0NY81"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995F524CEEA;
	Sun, 26 Oct 2025 14:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490202; cv=none; b=csrMiLXMMeo/ufdbXoLPccmojIntVcLQq8CEle5lqyInMJ+1NRvdvv8TA6KMn8/VLLNh6h++0IOaPF1KD+phmJPZZVFDeTjjmRqH5Im9e85OUCH9TVspViXBJS4im3WIPHKh84/6KxwQ3zfDv8K2JaSQ4Zs8KiRkTcI8EwUmiiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490202; c=relaxed/simple;
	bh=6wk8jRVivK0iIZZi18gIIDWTUm2t/lrXDKdYW8y8jKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BNvPXMnFKjZgFR8kfV3+cKur5ZVsep8eLQJXjQgbyXQq4qdtwCPj/LSmFAk7I9JFT59GMu9KBPztwieGCsmXOl8gdxXVSxAnFUQwSPAXTHj+XI46vloeGEpY4rFMrG5PbnLRzaXAcCHArw4L4iOY0YQlLbIA+aRByZ9bVOdcLsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=loD0NY81; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6ABC116B1;
	Sun, 26 Oct 2025 14:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490202;
	bh=6wk8jRVivK0iIZZi18gIIDWTUm2t/lrXDKdYW8y8jKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=loD0NY81twU/z3UCGgzyiNsUJjI+j5+GCjTnXUVzhuw8MD/jng3y2l24cqXQJuftM
	 k0q4D9/CUpMqwkbUlkIEpNZ1F9LWcf6ykbPFO2/DhCrUFqWbg98crY0BUIQ7oqHHpk
	 BntnH+xaYqSySQCIIykg+eY3kIsAgzCQ7gwL1tjK5oZsUgv2DpqO1LvLFeVnYuVAss
	 0Mi79dR+laaZ1Bf8UU2EFx6w7/mdzCCowWCePPlfHP+2NXKHk9XQk7YSFa5kKcm9K5
	 f15eLKlepufAbrFzbrIEYeaagt/PEf5CUWWi0K4HfvrUdFx+aAh/JDD8ZetKSJ7bRy
	 fsohLjEjLEGKg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	xiubli@redhat.com,
	ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.4] ceph: add checking of wait_for_completion_killable() return value
Date: Sun, 26 Oct 2025 10:48:40 -0400
Message-ID: <20251026144958.26750-2-sashal@kernel.org>
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

[ Upstream commit b7ed1e29cfe773d648ca09895b92856bd3a2092d ]

The Coverity Scan service has detected the calling of
wait_for_completion_killable() without checking the return
value in ceph_lock_wait_for_completion() [1]. The CID 1636232
defect contains explanation: "If the function returns an error
value, the error value may be mistaken for a normal value.
In ceph_lock_wait_for_completion(): Value returned from
a function is not checked for errors before being used. (CWE-252)".

The patch adds the checking of wait_for_completion_killable()
return value and return the error code from
ceph_lock_wait_for_completion().

[1] https://scan5.scan.coverity.com/#/project-view/64304/10063?selectedIssue=1636232

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – returning the error from the killable wait is required for correct
abort handling in the Ceph MDS client.

- `fs/ceph/locks.c:224-226` now propagates the
  `wait_for_completion_killable()` status instead of unconditionally
  succeeding. This covers the case where a task waiting for
  `req->r_safe_completion` is interrupted by a fatal signal (the helper
  returns `-ERESTARTSYS` per `kernel/sched/completion.c`), so
  `ceph_lock_wait_for_completion()` no longer hides that failure.
- `ceph_mdsc_wait_request()` relies on the wait callback’s return code
  to drive error cleanup (`fs/ceph/mds_client.c:3761-3776`): only when
  the callback returns `< 0` does it set `CEPH_MDS_R_ABORTED`, preserve
  the error, and call `ceph_invalidate_dir_request()` for write-style
  operations. With the old code the callback always returned 0, so a
  second signal during the safe-completion wait would skip that abort
  path even though `req->r_err` eventually propagates a failure; in
  turn, the caller could observe stale directory state and inconsistent
  locking semantics.
- The change is tiny, affects only the Ceph lock abort path, and has no
  dependencies. It keeps normal success cases untouched (`err == 0`
  still returns early) while making the error handling consistent.
- Given it fixes a real user-visible bug (signals during lock abort
  losing associated cleanup) with negligible regression risk, it’s a
  good candidate for the stable series.

 fs/ceph/locks.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index ebf4ac0055ddc..dd764f9c64b9f 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -221,7 +221,10 @@ static int ceph_lock_wait_for_completion(struct ceph_mds_client *mdsc,
 	if (err && err != -ERESTARTSYS)
 		return err;
 
-	wait_for_completion_killable(&req->r_safe_completion);
+	err = wait_for_completion_killable(&req->r_safe_completion);
+	if (err)
+		return err;
+
 	return 0;
 }
 
-- 
2.51.0


