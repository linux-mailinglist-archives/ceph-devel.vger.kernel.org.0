Return-Path: <ceph-devel+bounces-3764-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BC67ABABF03
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Sep 2025 09:58:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53D6B1926701
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Sep 2025 07:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AF211A239A;
	Tue, 30 Sep 2025 07:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="rNBfSMGI"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9C22D2390;
	Tue, 30 Sep 2025 07:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759219091; cv=none; b=XgQ/tMuqRrfbrWpXsSrdiDoBnw8D25eeKlHHYvi+WJi4S8E/R05f8kc2cQ3le/NiyZCEzYD1gxkTswYJae3LNJbaHJQv12l1qJZVP/SQa9/RHYhqDLZRqX+xfpq5ebVZuAD8xineOoUL2Qzfd64UXdnLXnWF80745pvMyfTWotk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759219091; c=relaxed/simple;
	bh=OHZNGg7WopG9zm0fu26hShbHYBIBKKUMRHxA+AiPzJY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=J/zlZ71lxvzEv+HE0PhUe8jkHAvgKm6a7uWR7wQaNlMaSdhRDNQ30yhX0i0fU/OG5FRxZ5dQ+9ndtH0xQ/LNYgcExhMZDxtRvOAYGOyLgdcgsfLNvITnDKMUS4wERl2uNRX+XsAInCIzA68GF/KCIk23K/RzCHXsmoG1mSJrDGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=rNBfSMGI; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
From: ethanwu <ethanwu@synology.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1759219086; bh=OHZNGg7WopG9zm0fu26hShbHYBIBKKUMRHxA+AiPzJY=;
	h=From:To:Cc:Subject:Date;
	b=rNBfSMGIXqbMhPYtVMgHRdbVog/OrPwpkwOTVQiaZDJvXyF3iiWOEwAuB28qmGTMZ
	 9sh8Zfj4i7dl8gkAPSpwQqBnekSlh9GX099IDX+gRFD2bJe88jkRFwQ5BohbO5by11
	 MiPZXy/T8Z10Govpb0RiMZVuIe24PdIpnR+uF9OU=
To: fstests@vger.kernel.org
Cc: ceph-devel@vger.kernel.org,
	Slava.Dubeyko@ibm.com,
	ethan198912@gmail.com,
	ethanwu <ethanwu@synology.com>
Subject: [PATCH] ceph/006: test snapshot data integrity after punch hole operations
Date: Tue, 30 Sep 2025 15:57:42 +0800
Message-ID: <20250930075743.2404523-1-ethanwu@synology.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
Content-Type: text/plain

Add test to verify that Ceph snapshots preserve original file data
when the live file is modified with punch hole operations. The test
creates a file, takes a snapshot, punches multiple holes in the
original file, then verifies the snapshot data remains unchanged.

Signed-off-by: ethanwu <ethanwu@synology.com>
---
 tests/ceph/006     | 58 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/ceph/006.out |  2 ++
 2 files changed, 60 insertions(+)
 create mode 100755 tests/ceph/006
 create mode 100644 tests/ceph/006.out

diff --git a/tests/ceph/006 b/tests/ceph/006
new file mode 100755
index 00000000..3f4b4547
--- /dev/null
+++ b/tests/ceph/006
@@ -0,0 +1,58 @@
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

