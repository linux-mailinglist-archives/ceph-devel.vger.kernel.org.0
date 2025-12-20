Return-Path: <ceph-devel+bounces-4212-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3851BCD30A4
	for <lists+ceph-devel@lfdr.de>; Sat, 20 Dec 2025 15:12:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EB562301E58F
	for <lists+ceph-devel@lfdr.de>; Sat, 20 Dec 2025 14:12:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19DD727F724;
	Sat, 20 Dec 2025 14:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chaospixel.com header.i=@chaospixel.com header.b="EpHkiryg"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail.chaospixel.com (mail.chaospixel.com [78.46.244.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548632773C6
	for <ceph-devel@vger.kernel.org>; Sat, 20 Dec 2025 14:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.46.244.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766239928; cv=none; b=i6R+ygSnRhX1Q5GWn6HiY8M5Sg+mLxsjaqQMf8v1fNSu4z2TeWqRxw/CRMom2s7EBUhfA/cb93Fv4njZ5nZlG6FY6kb3fW8bJI0/Iz+q/bFE0A1Y2DIWz9tmXsX8pJ5MybwsRM7SYGwaADUlZuWv6XNhEMpaI5D00yJyAEKcjWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766239928; c=relaxed/simple;
	bh=4+CtjpwgNlQljIby/0a9F996RnZTKsCe4CrdhSynNdg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LHczMdWOuwxdOOXtCwTkj5Cg2UXO1jtV+/UCBB50AC0DbUKi3LAseOHmnhzUM9ZkZpOI80Kt8m+xQuHipkSz5Aj6dru43ean1geGVZ+9PyqoUU39mMrbDEdsbLZ5m9B0fDJLSQTRlNwtShjKanWgJCgaJULiSf57e2MnOjoSjJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chaospixel.com; spf=pass smtp.mailfrom=chaospixel.com; dkim=pass (2048-bit key) header.d=chaospixel.com header.i=@chaospixel.com header.b=EpHkiryg; arc=none smtp.client-ip=78.46.244.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chaospixel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chaospixel.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=chaospixel.com;
	s=201811; t=1766239320;
	bh=4+CtjpwgNlQljIby/0a9F996RnZTKsCe4CrdhSynNdg=;
	h=From:To:Cc:Subject:Date:From;
	b=EpHkiryg8AqUsM6+HzUPpb/IngLJUe+Yqcd+KGDTZq28f1VHjnGWJWDznkj4n9l3R
	 9iHib4s2r28ogKwS8QTZEMPVqp0J/sab/acvaCXlOSGPJAk+oXsVCzBAQ/XpPm+9Hd
	 hFpzWukQCq9X26PyesdjRNPekJlFrl6LGVr3utlG5u13vcGUF1kR0jXCqKVFuWrmpP
	 H9pHfrAa8hmgGCZ0H31BsvEsJs8boKAKR40nOp9hxFTost1j4unc0JsFLc6oiygIB5
	 w9P84xWY70051+Ssh3fxFMp5qLe5240LJ1QONSR8ci/mwVR7nd/pOpaVwQtVRvAk2/
	 PcPp/4xktMaag==
Received: from pollux.home.lan (unknown [IPv6:2a02:8071:b8a:89e1:4ce:5f41:c510:16fe])
	by mail.chaospixel.com (Postfix) with ESMTPSA id 4145564170FE;
	Sat, 20 Dec 2025 15:02:00 +0100 (CET)
From: Daniel Vogelbacher <daniel@chaospixel.com>
To: ceph-devel@vger.kernel.org
Cc: xiubli@redhat.com,
	idryomov@gmail.com
Subject: [PATCH] fs/ceph: Fix kernel oops due invalid pointer for kfree() in parse_longname()
Date: Sat, 20 Dec 2025 15:01:53 +0100
Message-ID: <20251220140153.1523907-1-daniel@chaospixel.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This fixes a kernel oops when reading ceph snapshot directories (.snap),
for example by simply run `ls /mnt/my_ceph/.snap`.

The bug was introduced in commit:

bb80f7618832 - parse_longname(): strrchr() expects NUL-terminated string

str is guarded by __free(kfree), but advanced later for skipping
the initial '_' in snapshot names.
This patch removes the need for advancing the pointer so kfree()
could do proper memory cleanup.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220807
Fixes: bb80f7618832 - parse_longname(): strrchr() expects NUL-terminated string

Cc: stable@vger.kernel.org
Suggested-by: Helge Deller <deller@gmx.de>
Signed-off-by: Daniel Vogelbacher <daniel@chaospixel.com>
---
 fs/ceph/crypto.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 0ea4db650f85..3e051972e49d 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -166,12 +166,12 @@ static struct inode *parse_longname(const struct inode *parent,
 	struct ceph_vino vino = { .snap = CEPH_NOSNAP };
 	char *name_end, *inode_number;
 	int ret = -EIO;
-	/* NUL-terminate */
-	char *str __free(kfree) = kmemdup_nul(name, *name_len, GFP_KERNEL);
+	if (*name_len <= 1)
+		return ERR_PTR(-EIO);
+	/* Skip initial '_' and NUL-terminate */
+	char *str __free(kfree) = kmemdup_nul(name + 1, *name_len - 1, GFP_KERNEL);
 	if (!str)
 		return ERR_PTR(-ENOMEM);
-	/* Skip initial '_' */
-	str++;
 	name_end = strrchr(str, '_');
 	if (!name_end) {
 		doutc(cl, "failed to parse long snapshot name: %s\n", str);
-- 
2.47.3


