Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487D7286644
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Oct 2020 19:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbgJGRwW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Oct 2020 13:52:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:39650 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728535AbgJGRwW (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 7 Oct 2020 13:52:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F2C5CAD04;
        Wed,  7 Oct 2020 17:52:19 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 92f51191;
        Wed, 7 Oct 2020 17:52:20 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     fstests@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.com>
Subject: [PATCH 3/3] ceph: test copy_file_range with infile = outfile
Date:   Wed,  7 Oct 2020 18:52:12 +0100
Message-Id: <20201007175212.16218-4-lhenriques@suse.de>
In-Reply-To: <20201007175212.16218-1-lhenriques@suse.de>
References: <20201007175212.16218-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Luis Henriques <lhenriques@suse.com>

This test runs a set of simple checks where the infile file is the same as
the outfile.

Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
 tests/ceph/003     | 118 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ceph/003.out |  11 +++++
 tests/ceph/group   |   1 +
 3 files changed, 130 insertions(+)
 create mode 100644 tests/ceph/003
 create mode 100644 tests/ceph/003.out

diff --git a/tests/ceph/003 b/tests/ceph/003
new file mode 100644
index 000000000000..6fc5e6812545
--- /dev/null
+++ b/tests/ceph/003
@@ -0,0 +1,118 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 SUSE Linux Products GmbH. All Rights Reserved.
+#
+# FS QA Test No. ceph/005
+#
+# Test copy_file_range with infile = outfile
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment
+. common/rc
+. common/filter
+. common/attr
+. common/reflink
+
+# real QA test starts here
+_supported_fs ceph
+
+_require_xfs_io_command "copy_range"
+_require_attrs
+_require_test
+
+workdir=$TEST_DIR/test-$seq
+rm -rf $workdir
+mkdir $workdir
+rm -f $seqres.full
+
+check_range()
+{
+	local file=$1
+	local off0=$2
+	local off1=$3
+	local val=$4
+	_read_range $file $off0 $off1 | grep -v -q $val
+	[ $? -eq 0 ] && echo "file $file is not '$val' in [ $off0 $off1 ]"
+}
+
+objsz=4194304
+halfobj=$(($objsz / 2))
+file="$workdir/file-$objsz"
+copy="$workdir/copy-$objsz"
+dest="$workdir/dest-$objsz"
+backup="$file.backup"
+touch $file $backup
+
+# object_size has to be a multiple of stripe_unit
+$SETFATTR_PROG -n ceph.file.layout \
+	       -v "stripe_unit=$objsz stripe_count=1 object_size=$objsz" \
+	       $file $backup
+
+$XFS_IO_PROG -c "pwrite -S 0x61 0 $objsz" $file >> $seqres.full 2>&1
+$XFS_IO_PROG -c "pwrite -S 0x62 $objsz $objsz" $file >> $seqres.full 2>&1
+$XFS_IO_PROG -c "pwrite -S 0x63 $(($objsz * 2)) $objsz" $file >> $seqres.full 2>&1
+
+cp $file $backup
+
+echo "  Copy single object to the end:"
+echo "    aaaa|bbbb|cccc => aaaa|bbbb|aaaa"
+$XFS_IO_PROG -c "copy_range -s 0 -d $(($objsz * 2)) -l $objsz $file" "$file"
+check_range $file 0 $objsz 61
+check_range $file $objsz $objsz 62
+check_range $file $(($objsz * 2)) $objsz 61
+
+echo "  Copy single object to the beginning:"
+echo "    aaaa|bbbb|aaaa => bbbb|bbbb|aaaa"
+$XFS_IO_PROG -c "copy_range -s $objsz -d 0 -l $objsz $file" "$file"
+check_range $file 0 $(($objsz * 2)) 62
+check_range $file $(($objsz * 2)) $objsz 61
+
+echo "  Copy single object to the middle:"
+echo "    bbbb|bbbb|aaaa => bbbb|aaaa|aaaa"
+$XFS_IO_PROG -c "copy_range -s $(($objsz * 2)) -d $objsz -l $objsz $file" "$file"
+check_range $file 0 $objsz 62
+check_range $file $objsz $(($objsz * 2)) 61
+
+cp $backup $file
+echo "  Cross object boundary (no full object copy)"
+echo "    aaaa|bbbb|cccc => aaaa|bbaa|aacc"
+$XFS_IO_PROG -c "copy_range -s 0 -d $(($objsz + $halfobj)) -l $objsz $file" "$file"
+check_range $file 0 $objsz 61
+check_range $file $objsz $halfobj 62
+check_range $file $(($objsz + $halfobj)) $objsz 61
+check_range $file $(($objsz * 2 + $halfobj)) $halfobj 63
+
+cp $backup $file
+echo "    aaaa|bbbb|cccc => aaaa|bbaa|bbcc"
+$XFS_IO_PROG -c "copy_range -s $halfobj -d $(($objsz + $halfobj)) -l $objsz $file" "$file"
+check_range $file 0 $objsz 61
+check_range $file $objsz $halfobj 62
+check_range $file $(($objsz + $halfobj)) $halfobj 61
+check_range $file $(($objsz * 2)) $halfobj 62
+check_range $file $(($objsz * 2 + $halfobj)) $halfobj 63
+
+cp $backup $file
+echo "    aaaa|bbbb|cccc => aaaa|bbbb|aabb"
+$XFS_IO_PROG -c "copy_range -s $halfobj -d $(($objsz * 2)) -l $objsz $file" "$file"
+check_range $file 0 $objsz 61
+check_range $file $objsz $objsz 62
+check_range $file $(($objsz * 2)) $halfobj 61
+check_range $file $(($objsz * 2 + $halfobj)) $halfobj 62
+
+#success, all done
+status=0
+exit
diff --git a/tests/ceph/003.out b/tests/ceph/003.out
new file mode 100644
index 000000000000..76c83b265253
--- /dev/null
+++ b/tests/ceph/003.out
@@ -0,0 +1,11 @@
+QA output created by 003
+  Copy single object to the end:
+    aaaa|bbbb|cccc => aaaa|bbbb|aaaa
+  Copy single object to the beginning:
+    aaaa|bbbb|aaaa => bbbb|bbbb|aaaa
+  Copy single object to the middle:
+    bbbb|bbbb|aaaa => bbbb|aaaa|aaaa
+  Cross object boundary (no full object copy)
+    aaaa|bbbb|cccc => aaaa|bbaa|aacc
+    aaaa|bbbb|cccc => aaaa|bbaa|bbcc
+    aaaa|bbbb|cccc => aaaa|bbbb|aabb
diff --git a/tests/ceph/group b/tests/ceph/group
index c28fe473c1a4..adbf61547766 100644
--- a/tests/ceph/group
+++ b/tests/ceph/group
@@ -1,2 +1,3 @@
 001 auto quick copy
 002 auto quick copy
+003 auto quick copy
