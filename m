Return-Path: <ceph-devel+bounces-3779-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4ABDBB34C1
	for <lists+ceph-devel@lfdr.de>; Thu, 02 Oct 2025 10:47:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2227D464A96
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Oct 2025 08:42:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D88082F7AC7;
	Thu,  2 Oct 2025 08:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="mWe6ajnl"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3178312823;
	Thu,  2 Oct 2025 08:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759394005; cv=none; b=kjUJnlRn3gnpnbFfGqHIlwXRQQyj3JprjjWIQULiJSOwaKtjBE/d01sj4KwriP3cvjYn8NV1CPGV29TI8SCV6fHCHOiUnRfPd2Tbpp1w4d6ikt66JDXENAlmqGvmXcizqFQlLaA9tgXKOgPRkbk8IV8TtMFWAOUM78aKGX2CSGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759394005; c=relaxed/simple;
	bh=dUkPv36AtYfV1MVjygQ+4sXlPWH/H09HEOKGEXmTK3k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BsnxljAV5CHPHvh5uKdAwuM5JUKOdTYQL+ueslGWR5ogdhkxFglJBn2jRqIbQeRyGugBAM48doTgp8+CXLoFFl9gv6EAucJATogrJQCiEBOHbhAlKw1G31xeJS67Gdl/fRpR/xPd4PYNSO5qDFQl/otpkOOmZ5beKPhAqtTin+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=mWe6ajnl; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
From: ethanwu <ethanwu@synology.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1759394002; bh=dUkPv36AtYfV1MVjygQ+4sXlPWH/H09HEOKGEXmTK3k=;
	h=From:To:Cc:Subject:Date;
	b=mWe6ajnlfDQGmEKKBUDAjrURiCHHpBfPWKrL3Cq/QzBQ27fdfZF3yvyJXuY8x4IiW
	 3hc1duX9j7/zOEslxa3lTeByG7OiZFxCNIlHQoaWmE9bWDHq1Oh7hyjr5qW6DcVSzw
	 oAfeSY443SIASX+FNGF2rVmoQhkC7x5DRfvATP7I=
To: fstests@vger.kernel.org
Cc: zlang@redhat.com,
	ceph-devel@vger.kernel.org,
	Slava.Dubeyko@ibm.com,
	ethan198912@gmail.com,
	ethanwu <ethanwu@synology.com>
Subject: [PATCH v2] generic/778: test snapshot data integrity after punch hole operations
Date: Thu,  2 Oct 2025 16:30:35 +0800
Message-ID: <20251002083035.3274508-1-ethanwu@synology.com>
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

Add test to verify that snapshots preserve original file data
when the live file is modified with punch hole operations. The test
creates a file, takes a snapshot, punches multiple holes in the
original file, then verifies the snapshot data remains unchanged.

Signed-off-by: ethanwu <ethanwu@synology.com>
---
v1->v2: previous version is 'ceph/006: test snapshot data integrity after
	punch hole'.
	1. move it to generic and add _require_snapshot check.
	2. modify punch hole offset/len to be 64K aligned
---
 common/rc             | 20 +++++++++++
 tests/generic/778     | 80 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/778.out |  2 ++
 3 files changed, 102 insertions(+)
 create mode 100755 tests/generic/778
 create mode 100644 tests/generic/778.out

diff --git a/common/rc b/common/rc
index 81587dad..eec028e7 100644
--- a/common/rc
+++ b/common/rc
@@ -5978,6 +5978,26 @@ _require_inplace_writes()
 	fi
 }
 
+# this test requires filesystem snapshot support
+_require_snapshot()
+{
+	case "$FSTYP" in
+	ceph)
+		local check_dir=$1
+		[ -z "$check_dir" ] && _fail "_require_snapshot: directory argument required for ceph"
+		local test_snapdir="$check_dir/.snap/test_snap_$$"
+		mkdir "$test_snapdir" 2>/dev/null || _notrun "Ceph snapshots not supported (requires fs flag 'allow_snaps' and client auth capability 'snap')"
+		rmdir "$test_snapdir"
+		;;
+	btrfs)
+		# btrfs always supports snapshots, no check needed
+		;;
+	*)
+		_notrun "Snapshots not supported on $FSTYP"
+		;;
+	esac
+}
+
 ################################################################################
 # make sure this script returns success
 /bin/true
diff --git a/tests/generic/778 b/tests/generic/778
new file mode 100755
index 00000000..96a8f1c8
--- /dev/null
+++ b/tests/generic/778
@@ -0,0 +1,80 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2025 Synology All Rights Reserved.
+#
+# FS QA Test No. generic/778
+#
+# Test that snapshot data remains intact after punch hole operations
+# on the original file.
+#
+. ./common/preamble
+_begin_fstest auto quick snapshot
+
+# Override the default cleanup function
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+	if [ -n "$snapdir" ]; then
+		case "$FSTYP" in
+		ceph)
+			rmdir $snapdir 2>/dev/null
+			;;
+		btrfs)
+			$BTRFS_UTIL_PROG subvolume delete $snapdir > /dev/null
+			;;
+		esac
+	fi
+}
+
+_require_test
+_require_xfs_io_command "pwrite"
+_require_xfs_io_command "fpunch"
+_require_snapshot $TEST_DIR
+_exclude_test_mount_option "test_dummy_encryption"
+
+# TODO: Update with final commit SHA when merged
+[ "$FSTYP" = "ceph" ] && _fixed_by_kernel_commit 1b7b474b3a78 \
+	"ceph: fix snapshot context missing in ceph_zero_partial_object"
+
+workdir=$TEST_DIR/test-$seq
+rm -rf $workdir
+mkdir $workdir
+
+$XFS_IO_PROG -f -c "pwrite -S 0xab 0 1048576" $workdir/foo > /dev/null
+
+# Create snapshot - filesystem specific
+case "$FSTYP" in
+ceph)
+	snapdir=$TEST_DIR/.snap/snap1
+	mkdir $snapdir
+	;;
+btrfs)
+	snapdir=$TEST_DIR/snap1
+	$BTRFS_UTIL_PROG subvolume snapshot ${TEST_DIR} $snapdir > /dev/null
+	;;
+esac
+
+original_md5=$(md5sum $snapdir/test-$seq/foo | cut -d' ' -f1)
+
+# Punch several holes of various sizes at different offsets
+$XFS_IO_PROG -c "fpunch 0 65536" $workdir/foo
+$XFS_IO_PROG -c "fpunch 131072 65536" $workdir/foo
+$XFS_IO_PROG -c "fpunch 262144 65536" $workdir/foo
+$XFS_IO_PROG -c "fpunch 393216 65536" $workdir/foo
+
+# Make sure we don't read from cache
+echo 3 > /proc/sys/vm/drop_caches
+
+snapshot_md5=$(md5sum $snapdir/test-$seq/foo | cut -d' ' -f1)
+
+if [ "$original_md5" != "$snapshot_md5" ]; then
+    echo "FAIL: Snapshot data changed after punch hole operations"
+    echo "Original md5sum: $original_md5"
+    echo "Snapshot md5sum: $snapshot_md5"
+fi
+
+echo "Silence is golden"
+
+status=0
+exit
diff --git a/tests/generic/778.out b/tests/generic/778.out
new file mode 100644
index 00000000..e80f72a3
--- /dev/null
+++ b/tests/generic/778.out
@@ -0,0 +1,2 @@
+QA output created by 778
+Silence is golden
-- 
2.43.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.

