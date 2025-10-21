Return-Path: <ceph-devel+bounces-3861-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DEB03BF55BC
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Oct 2025 10:49:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BE5D14F8A89
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Oct 2025 08:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 948DC255F52;
	Tue, 21 Oct 2025 08:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="bpz8Zhps"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321FA324B21;
	Tue, 21 Oct 2025 08:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761036575; cv=none; b=mRXPlFYnyYAEy1h9UlBbxu9xVP461hx+emd8PO/80Amj1RnL1m/DguereG1/HJfVl1vbIJHn1Zm4djEOOG8cLiFCrfl8sXTtgfcEvYl5f6WHjqHry4peXQPRmRkHz3MjJzkK/BfRBkch/9FxNjJltp0goOzKc2E33twToTvwoo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761036575; c=relaxed/simple;
	bh=mrTQmkGveUndPqwUqnPjSivh/fOygBnPWDwecEpos1U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=O/Ap8mJCU3uPjIsnWKTeLgAzCWd+6ikgoeyszpfM0AyQ6bTx+fzootHyCYv48fDarHyFP012nDCwbGocPuiN8IKVJqCiTbcatJrlJXe6Bp+2rKOdt5n9YpAT38Ji+DzlAJOBI+F/1gryrnpWOGAQ5o47bEAHl+nfjkxuDVWNR2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=bpz8Zhps; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
From: ethanwu <ethanwu@synology.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1761036570; bh=mrTQmkGveUndPqwUqnPjSivh/fOygBnPWDwecEpos1U=;
	h=From:To:Cc:Subject:Date;
	b=bpz8Zhpsh5dvED1U3PeBPm2E2VOCZy+Gt6Qjd3Se2lIgTwSIch3MmqxeunpUNNAvW
	 MHYyO+wZ2O0e59O8RQV4ZaK00rtxx+8wtJ7VDYEJWzxQ/HfOjNIc2CEFnmEBRJcA8w
	 ifANc5b/8Gt38eaOMMCY6WnSyFGepocINirVx9n4=
To: fstests@vger.kernel.org
Cc: zlang@redhat.com,
	ceph-devel@vger.kernel.org,
	Slava.Dubeyko@ibm.com,
	ethan198912@gmail.com,
	ethanwu <ethanwu@synology.com>
Subject: [PATCH v4] ceph/006: test snapshot data integrity after punch hole operations
Date: Tue, 21 Oct 2025 16:49:21 +0800
Message-ID: <20251021084921.3307823-1-ethanwu@synology.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
Content-Type: text/plain

Add test to verify that Ceph snapshots preserve original file data
when the live file is modified with punch hole operations. The test
creates a file, takes a snapshot, punches multiple holes in the
original file, then verifies the snapshot data remains unchanged.

Signed-off-by: ethanwu <ethanwu@synology.com>
---
 v1->v2: previous version is 'ceph/006: test snapshot data integrity
 after punch hole'.
    1. move it to generic and add _require_snapshot check.
    2. modify punch hole offset/len to be 64K aligned
 v2->v3:
    1. move test back to ceph specific since it uses ceph snapshot API.
    2. support custom snapdirname mount option.
    3. add _ceph_remove_snapshot and _ceph_create_snapshot functions.
 v3->v4:
    1. call _fail if snapshot creation fails.
    2. remove _require_xfs_io_command "pwrite"
    3. cleanup snapshot after test
---
 common/ceph        | 76 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/ceph/006     | 63 ++++++++++++++++++++++++++++++++++++++
 tests/ceph/006.out |  2 ++
 3 files changed, 141 insertions(+)
 create mode 100755 tests/ceph/006
 create mode 100644 tests/ceph/006.out

diff --git a/common/ceph b/common/ceph
index df7a6814..5bdcb3ad 100644
--- a/common/ceph
+++ b/common/ceph
@@ -38,3 +38,79 @@ _ceph_get_client_id()
 {
 	$GETFATTR_PROG --only-values -n "ceph.client_id" $TEST_DIR 2>/dev/null
 }
+
+# Get the snapshot directory name from mount options
+# Defaults to ".snap" if snapdirname option is not set
+_ceph_get_snapdirname()
+{
+	local mnt_point=$1
+	local snapdirname
+
+	# Extract snapdirname from mount options
+	snapdirname=$(findmnt -n -o OPTIONS "$mnt_point" | grep -o 'snapdirname=[^,]*' | cut -d'=' -f2)
+
+	# Default to .snap if not set
+	if [ -z "$snapdirname" ]; then
+		echo ".snap"
+	else
+		echo "$snapdirname"
+	fi
+}
+
+# Create a CephFS snapshot
+# _ceph_create_snapshot <directory_path> <snapshot_name>
+# Creates a snapshot under <directory_path>/.snap/<snapshot_name>
+# or <directory_path>/<custom_snapdir>/<snapshot_name> if snapdirname is set
+_ceph_create_snapshot()
+{
+	local dir_path=$1
+	local snap_name=$2
+	local snapdirname
+	local snapdir
+	local mnt_point
+
+	if [ -z "$dir_path" ] || [ -z "$snap_name" ]; then
+		echo "Usage: _ceph_create_snapshot <directory_path> <snapshot_name>"
+		return 1
+	fi
+
+	# Find the mount point for this directory
+	mnt_point=$(df -P "$dir_path" | tail -1 | awk '{print $NF}')
+	snapdirname=$(_ceph_get_snapdirname "$mnt_point")
+	snapdir="$dir_path/$snapdirname/$snap_name"
+
+	mkdir "$snapdir" || _fail "Failed to create snapshot $snapdir"
+	echo "$snapdir"
+}
+
+# Remove a CephFS snapshot
+# _ceph_remove_snapshot <directory_path> <snapshot_name>
+_ceph_remove_snapshot()
+{
+	local dir_path=$1
+	local snap_name=$2
+	local snapdirname
+	local snapdir
+	local mnt_point
+
+	if [ -z "$dir_path" ] || [ -z "$snap_name" ]; then
+		echo "Usage: _ceph_remove_snapshot <directory_path> <snapshot_name>"
+		return 1
+	fi
+
+	# Find the mount point for this directory
+	mnt_point=$(df -P "$dir_path" | tail -1 | awk '{print $NF}')
+	snapdirname=$(_ceph_get_snapdirname "$mnt_point")
+	snapdir="$dir_path/$snapdirname/$snap_name"
+
+	rmdir "$snapdir" 2>/dev/null
+}
+
+# this test requires ceph snapshot support
+_require_ceph_snapshot()
+{
+	local snapdirname=$(_ceph_get_snapdirname "$TEST_DIR")
+	local test_snapdir="$TEST_DIR/$snapdirname/test_snap_$$"
+	mkdir "$test_snapdir" 2>/dev/null || _notrun "Ceph snapshots not supported (requires fs flag 'allow_snaps' and client auth capability 'snap')"
+	rmdir "$test_snapdir"
+}
diff --git a/tests/ceph/006 b/tests/ceph/006
new file mode 100755
index 00000000..a32e3138
--- /dev/null
+++ b/tests/ceph/006
@@ -0,0 +1,63 @@
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
+. common/ceph
+
+# Override the default cleanup function
+_cleanup()
+{
+    _ceph_remove_snapshot $workdir snap1
+}
+
+_require_test
+_require_xfs_io_command "fpunch"
+_require_ceph_snapshot
+_exclude_test_mount_option "test_dummy_encryption"
+
+# TODO: commit is not merged yet. Update with final commit SHA once merged.
+_fixed_by_kernel_commit 1b7b474b3a78 \
+	"ceph: fix snapshot context missing in ceph_zero_partial_object"
+
+workdir=$TEST_DIR/test-$seq
+_ceph_remove_snapshot $workdir snap1
+rm -rf $workdir
+mkdir $workdir
+
+$XFS_IO_PROG -f -c "pwrite -S 0xab 0 1048576" $workdir/foo > /dev/null
+
+snapdir=$(_ceph_create_snapshot $workdir snap1)
+
+original_md5=$(md5sum $snapdir/foo | cut -d' ' -f1)
+
+$XFS_IO_PROG -c "fpunch 0 65536" $workdir/foo
+$XFS_IO_PROG -c "fpunch 131072 65536" $workdir/foo
+$XFS_IO_PROG -c "fpunch 262144 65536" $workdir/foo
+$XFS_IO_PROG -c "fpunch 393216 65536" $workdir/foo
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
+_ceph_remove_snapshot $workdir snap1
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

