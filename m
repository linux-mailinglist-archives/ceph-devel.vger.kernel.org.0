Return-Path: <ceph-devel+bounces-3744-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A98C9BA37E3
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Sep 2025 13:33:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7247E6262F9
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Sep 2025 11:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F368261B71;
	Fri, 26 Sep 2025 11:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="EVmGarzZ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FF111713
	for <ceph-devel@vger.kernel.org>; Fri, 26 Sep 2025 11:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758886431; cv=none; b=a2rvUyaNDOvV8iUZjKomxjwTx8SU+L6KSRxcxk+rA7dAVBh+No7k41dSEo30tnc5hqYkpJIzAU2Gepez56i3BS6yK/HIco56+MzhmK038v65gEze0aEviQq0Ygz6nrfmxeHYICJLjDQ1hnoCUU/fdf37s/YcyrrfFIJ06Vn7w8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758886431; c=relaxed/simple;
	bh=+spo3ZK4Z1uBE6M3mOZZOxgJViXKLYETfgDyswzHT8k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=upJWvuZZePRYtBYvTUInUwAtY9I7Zj41m+qu2cArxc20NyC9zlk0/hTqESY+vNy+SR+20iAg2Nxzhs7P5maUTLUao/YMnlhBZx93YQemQfcFadWbYZUCHIOxSZtr+xhd2SMaIQjGtGyJbsfHNLvY3nPcpgfBx6SdDdaTh/g0avU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=EVmGarzZ; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
From: ethanwu <ethanwu@synology.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1758886423; bh=+spo3ZK4Z1uBE6M3mOZZOxgJViXKLYETfgDyswzHT8k=;
	h=From:To:Cc:Subject:Date;
	b=EVmGarzZqr5dIv/ws6tT9cEN6yXbEdMEpSFv5+rc7pChMaYSlg3KceGMrlyK5zmr4
	 QykdlcdfLJVYHSTxWQNfCLuGUA9CxoKrhSoGqABrf0IZ2VbJ+fdRmQVma75QL6KuJO
	 mFW7aYGKhPzObTSu6HqOT6ETzl9pCnzQXknYnLd0=
To: ceph-devel@vger.kernel.org
Cc: Slava.Dubeyko@ibm.com,
	ethanwu@synology.com
Subject: [PATCH] ceph/006: test snapshot data integrity after punch hole operations
Date: Fri, 26 Sep 2025 19:32:27 +0800
Message-ID: <20250926113227.609629-1-ethanwu@synology.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
Content-Type: text/plain

Add test to verify that Ceph snapshots preserve original file data
when the live file is modified with punch hole operations. The test
creates a file, takes a snapshot, punches multiple holes in the
original file, then verifies the snapshot data remains unchanged.

Signed-off-by: ethanwu <ethanwu@synology.com>
---
 tests/ceph/006     | 60 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/ceph/006.out |  2 ++
 2 files changed, 62 insertions(+)
 create mode 100755 tests/ceph/006
 create mode 100644 tests/ceph/006.out

diff --git a/tests/ceph/006 b/tests/ceph/006
new file mode 100755
index 00000000..02ebddeb
--- /dev/null
+++ b/tests/ceph/006
@@ -0,0 +1,60 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2025 Synology All Rights Reserved.
+#
+# FS QA Test No. ceph/006
+#
+# Test that snapshot data remains intact after punch hole operations
+# on the original file.
+#
+. ./common/preamble
+_begin_fstest auto quick snapshot
+
+. common/filter
+. common/punch
+
+_require_test
+_require_xfs_io_command "pwrite"
+_require_xfs_io_command "fpunch"
+_exclude_test_mount_option "test_dummy_encryption"
+
+# TODO: Update with final commit SHA when merged
+_fixed_by_kernel_commit 1b7b474b3a78 \
+	"ceph: fix snapshot context missing in ceph_zero_partial_object"
+
+workdir=$TEST_DIR/test-$seq
+snapdir=$workdir/.snap/snap1
+rmdir $snapdir 2>/dev/null
+rm -rf $workdir
+mkdir $workdir
+
+$XFS_IO_PROG -f -c "pwrite -S 0xab 0 1048576" $workdir/foo > /dev/null
+
+mkdir $snapdir
+
+original_md5=$(md5sum $snapdir/foo | cut -d' ' -f1)
+
+# Punch several holes of various sizes at different offsets
+$XFS_IO_PROG -c "fpunch 0 4096" $workdir/foo
+$XFS_IO_PROG -c "fpunch 16384 8192" $workdir/foo
+$XFS_IO_PROG -c "fpunch 65536 16384" $workdir/foo
+$XFS_IO_PROG -c "fpunch 262144 32768" $workdir/foo
+$XFS_IO_PROG -c "fpunch 1024000 4096" $workdir/foo
+
+# Make sure we don't read from cache
+echo 3 > /proc/sys/vm/drop_caches
+
+snapshot_md5=$(md5sum $snapdir/foo | cut -d' ' -f1)
+
+if [ "$original_md5" != "$snapshot_md5" ]; then
+    echo "FAIL: Snapshot data changed after punch hole operations"
+    echo "Original md5sum: $original_md5"
+    echo "Snapshot md5sum: $snapshot_md5"
+fi
+
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
+
diff --git a/tests/ceph/006.out b/tests/ceph/006.out
new file mode 100644
index 00000000..675c1b7c
--- /dev/null
+++ b/tests/ceph/006.out
@@ -0,0 +1,2 @@
+QA output created by 006
+Silence is golden
-- 
2.43.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.

