Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72DC7292822
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Oct 2020 15:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgJSN1y (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Oct 2020 09:27:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:55640 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727811AbgJSN1x (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 19 Oct 2020 09:27:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EE637AD68;
        Mon, 19 Oct 2020 13:27:49 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 001ec119;
        Mon, 19 Oct 2020 13:27:53 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     fstests@vger.kernel.org
Cc:     Eryu Guan <guan@eryu.me>, Jeff Layton <jlayton@kernel.org>,
        ceph-devel@vger.kernel.org, Luis Henriques <lhenriques@suse.com>
Subject: [PATCH v2 1/3] ceph: add copy_file_range (remote copy operation) testing
Date:   Mon, 19 Oct 2020 14:27:48 +0100
Message-Id: <20201019132750.29293-2-lhenriques@suse.de>
In-Reply-To: <20201019132750.29293-1-lhenriques@suse.de>
References: <20201019132750.29293-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Luis Henriques <lhenriques@suse.com>

Test remote copy operation (CEPH_OSD_OP_COPY_FROM) with different
combinations of both object sizes and copy sizes.

Test remote copy operation (CEPH_OSD_OP_COPY_FROM) with several
combinations of both object sizes and copy sizes.  It also uses several
combinations of copy ranges.  For example, copying the 1st object in the
src file into:

  1) the beginning (1st object) of dst file,
  2) the end (last object) of dst file and
  3) the middle of the dst file.

Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
 common/ceph        |  23 +++++
 common/rc          |   1 +
 tests/ceph/001     | 233 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ceph/001.out | 129 +++++++++++++++++++++++++
 tests/ceph/group   |   1 +
 5 files changed, 387 insertions(+)
 create mode 100644 common/ceph
 create mode 100755 tests/ceph/001
 create mode 100644 tests/ceph/001.out
 create mode 100644 tests/ceph/group

diff --git a/common/ceph b/common/ceph
new file mode 100644
index 000000000000..f80209f98b23
--- /dev/null
+++ b/common/ceph
@@ -0,0 +1,23 @@
+#
+# CephFS specific common functions.
+#
+
+# _ceph_create_file_layout <filename> <stripe unit> <stripe count> <object size>
+# This function creates a new empty file and sets the file layout according to
+# parameters.  It will exit if the file already exists.
+_ceph_create_file_layout()
+{
+	local fname=$1
+	local stripe_unit=$2
+	local stripe_count=$3
+	local obj_size=$4
+
+	if [ -e $fname ]; then
+		echo "File $fname already exists."
+		exit 1
+	fi
+	touch $fname
+	$SETFATTR_PROG -n ceph.file.layout \
+		-v "stripe_unit=$objsz stripe_count=1 object_size=$objsz" \
+		$fname
+}
diff --git a/common/rc b/common/rc
index 27a27ea36f75..65ebfe201139 100644
--- a/common/rc
+++ b/common/rc
@@ -138,6 +138,7 @@ case "$FSTYP" in
     9p)
 	 ;;
     ceph)
+	 . ./common/ceph
 	 ;;
     glusterfs)
 	 ;;
diff --git a/tests/ceph/001 b/tests/ceph/001
new file mode 100755
index 000000000000..0515fff81262
--- /dev/null
+++ b/tests/ceph/001
@@ -0,0 +1,233 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 SUSE Linux Products GmbH. All Rights Reserved.
+#
+# FS QA Test No. ceph/001
+#
+# Test remote copy operation (CEPH_OSD_OP_COPY_FROM) with several combinations
+# of both object sizes and copy sizes.  It also uses several combinations of
+# copy ranges.  For example, copying the 1st object in the src file into
+# 1) the beginning (1st object) of dst file, 2) the end (last object) of dst
+# file and 3) the middle of the dst file.
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
+run_copy_range_tests()
+{
+	objsz=$1
+	halfobj=$(($objsz / 2))
+	file="$workdir/file-$objsz"
+	copy="$workdir/copy-$objsz"
+	dest="$workdir/dest-$objsz"
+
+	# create files and set file layout, which needs to be done before
+	# writing any data
+	_ceph_create_file_layout $file $objsz 1 $objsz
+	_ceph_create_file_layout $copy $objsz 1 $objsz
+	_ceph_create_file_layout $dest $objsz 1 $objsz
+
+	# file containing 3 objects with 'aaaa|bbbb|cccc'
+	$XFS_IO_PROG -c "pwrite -S 0x61 0 $objsz" $file >> $seqres.full 2>&1
+	$XFS_IO_PROG -c "pwrite -S 0x62 $objsz $objsz" $file >> $seqres.full 2>&1
+	$XFS_IO_PROG -c "pwrite -S 0x63 $(($objsz * 2)) $objsz" $file >> $seqres.full 2>&1
+
+	echo "  Copy whole file (3 objects):"
+	echo "    aaaa|bbbb|cccc => aaaa|bbbb|cccc"
+	$XFS_IO_PROG -c "copy_range -s 0 -d 0 -l $(($objsz * 3)) $file" "$copy"
+	cmp $file $copy
+
+	echo "  Copy single object to beginning:"
+	# dest file with 3 objects with 'dddd|dddd|dddd'
+	$XFS_IO_PROG -c "pwrite -S 0x64 0 $(($objsz * 3))" $dest >> $seqres.full 2>&1
+
+	echo "    dddd|dddd|dddd => aaaa|dddd|dddd"
+	$XFS_IO_PROG -c "copy_range -s 0 -d 0 -l $objsz $file" "$dest"
+	check_range $dest 0 $objsz 61
+	check_range $dest $objsz $(($objsz * 2)) 64
+
+	echo "    aaaa|dddd|dddd => bbbb|dddd|dddd"
+	$XFS_IO_PROG -c "copy_range -s $objsz -d 0 -l $objsz $file" "$dest"
+	check_range $dest 0 $objsz 62
+	check_range $dest $objsz $(($objsz * 2)) 64
+
+	echo "    bbbb|dddd|dddd => cccc|dddd|dddd"
+	$XFS_IO_PROG -c "copy_range -s $(($objsz * 2)) -d 0 -l $objsz $file" "$dest"
+	check_range $dest 0 $objsz 63
+	check_range $dest $objsz $(($objsz * 2)) 64
+
+	echo "  Copy single object to middle:"
+
+	echo "    cccc|dddd|dddd => cccc|aaaa|dddd"
+	$XFS_IO_PROG -c "copy_range -s 0 -d $objsz -l $objsz $file" "$dest"
+	check_range $dest 0 $objsz 63
+	check_range $dest $objsz $objsz 61
+	check_range $dest $(($objsz * 2)) $objsz 64
+
+	echo "    cccc|aaaa|dddd => cccc|bbbb|dddd"
+	$XFS_IO_PROG -c "copy_range -s $objsz -d $objsz -l $objsz $file" "$dest"
+	check_range $dest 0 $objsz 63
+	check_range $dest $objsz $objsz 62
+	check_range $dest $(($objsz * 2)) $objsz 64
+
+	echo "    cccc|bbbb|dddd => cccc|cccc|dddd"
+	$XFS_IO_PROG -c "copy_range -s $((objsz * 2)) -d $objsz -l $objsz $file" "$dest"
+	check_range $dest 0 $objsz 63
+	check_range $dest $objsz $objsz 63
+	check_range $dest $(($objsz * 2)) $objsz 64
+
+	echo "  Copy single object to end:"
+
+	echo "    cccc|cccc|dddd => cccc|cccc|aaaa"
+	$XFS_IO_PROG -c "copy_range -s 0 -d $(($objsz * 2)) -l $objsz $file" "$dest"
+	check_range $dest 0 $(($objsz * 2)) 63
+	check_range $dest $(($objsz * 2)) $objsz 61
+
+	echo "    cccc|cccc|aaaa => cccc|cccc|bbbb"
+	$XFS_IO_PROG -c "copy_range -s $objsz -d $(($objsz * 2)) -l $objsz $file" "$dest"
+	check_range $dest 0 $(($objsz * 2)) 63
+	check_range $dest $(($objsz * 2)) $objsz 62
+
+	echo "    cccc|cccc|aaaa => cccc|cccc|cccc"
+	$XFS_IO_PROG -c "copy_range -s $(($objsz * 2)) -d $(($objsz * 2)) -l $objsz $file" "$dest"
+	check_range $dest 0 $(($objsz * 3)) 63
+
+	echo "  Copy 2 objects to beginning:"
+
+	echo "    cccc|cccc|cccc => aaaa|bbbb|cccc"
+	$XFS_IO_PROG -c "copy_range -s 0 -d 0 -l $(($objsz * 2)) $file" "$dest"
+	cmp $file $dest
+
+	echo "    aaaa|bbbb|cccc => bbbb|cccc|cccc"
+	$XFS_IO_PROG -c "copy_range -s $objsz -d 0 -l $(($objsz * 2)) $file" "$dest"
+	check_range $dest 0 $objsz 62
+	check_range $dest $objsz $(($objsz * 2)) 63
+
+	echo "  Copy 2 objects to end:"
+
+	echo "    bbbb|cccc|cccc => bbbb|aaaa|bbbb"
+	$XFS_IO_PROG -c "copy_range -s 0 -d $objsz -l $(($objsz * 2)) $file" "$dest"
+	check_range $dest 0 $objsz 62
+	check_range $dest $objsz $objsz 61
+	check_range $dest $(($objsz * 2)) $objsz 62
+
+	echo "    bbbb|aaaa|bbbb => bbbb|bbbb|cccc"
+	$XFS_IO_PROG -c "copy_range -s $objsz -d $objsz -l $(($objsz * 2)) $file" "$dest"
+	check_range $dest 0 $(($objsz * 2)) 62
+	check_range $dest $(($objsz * 2)) $objsz 63
+
+	echo "  Append 1 object:"
+
+	echo "    bbbb|bbbb|cccc => bbbb|bbbb|cccc|aaaa"
+	$XFS_IO_PROG -c "copy_range -s 0 -d $(($objsz * 3)) -l $objsz $file" "$dest"
+	check_range $dest 0 $(($objsz * 2)) 62
+	check_range $dest $(($objsz * 2)) $objsz 63
+	check_range $dest $(($objsz * 3)) $objsz 61
+
+	echo "  Cross object boundary (no full object copy)"
+	echo "    dddd|dddd|dddd|dddd => ddaa|aadd|dddd|dddd"
+	$XFS_IO_PROG -c "pwrite -S 0x64 0 $(($objsz * 4))" $dest >> $seqres.full 2>&1
+	$XFS_IO_PROG -c "copy_range -s 0 -d $halfobj -l $objsz $file" "$dest"
+	check_range $dest 0 $halfobj 64
+	check_range $dest $halfobj $objsz 61
+	check_range $dest $(($objsz + $halfobj)) $(($objsz * 2 + $halfobj)) 64
+
+	echo "    dddd|dddd|dddd|dddd => ddaa|bbdd|dddd|dddd"
+	$XFS_IO_PROG -c "pwrite -S 0x64 0 $(($objsz * 4))" $dest >> $seqres.full 2>&1
+	$XFS_IO_PROG -c "copy_range -s $halfobj -d $halfobj -l $objsz $file" "$dest"
+	check_range $dest 0 $halfobj 64
+	check_range $dest $halfobj $halfobj 61
+	check_range $dest $objsz $halfobj 62
+	check_range $dest $(($objsz + $halfobj)) $(($objsz * 2 + $halfobj)) 64
+
+	echo "  Cross object boundaries (with full object copy)"
+	echo "    dddd|dddd|dddd|dddd => ddaa|bbbb|dddd|dddd"
+	$XFS_IO_PROG -c "pwrite -S 0x64 0 $(($objsz * 4))" $dest >> $seqres.full 2>&1
+	$XFS_IO_PROG -c "copy_range -s $halfobj -d $halfobj -l $(($objsz + $halfobj)) $file" "$dest"
+	check_range $dest 0 $halfobj 64
+	check_range $dest $halfobj $halfobj 61
+	check_range $dest $objsz $objsz 62
+	check_range $dest $(($objsz * 2)) $(($objsz * 2)) 64
+
+	echo "    dddd|dddd|dddd|dddd => ddaa|bbbb|ccdd|dddd"
+	$XFS_IO_PROG -c "pwrite -S 0x64 0 $(($objsz * 4))" $dest >> $seqres.full 2>&1
+	$XFS_IO_PROG -c "copy_range -s $halfobj -d $halfobj -l $(($objsz * 2)) $file" "$dest"
+	check_range $dest 0 $halfobj 64
+	check_range $dest $halfobj $halfobj 61
+	check_range $dest $objsz $objsz 62
+	check_range $dest $(($objsz * 2)) $halfobj 63
+	check_range $dest $(($objsz * 2 + $halfobj)) $(($objsz + $halfobj)) 64
+
+	echo "    dddd|dddd|dddd|dddd => dddd|aaaa|bbdd|dddd"
+	$XFS_IO_PROG -c "pwrite -S 0x64 0 $(($objsz * 4))" $dest >> $seqres.full 2>&1
+	$XFS_IO_PROG -c "copy_range -s 0 -d $objsz -l $(($objsz + $halfobj)) $file" "$dest"
+	check_range $dest 0 $objsz 64
+	check_range $dest $objsz $objsz 61
+	check_range $dest $(($objsz * 2)) $halfobj 62
+	check_range $dest $(($objsz * 2 + $halfobj)) $(($objsz + $halfobj)) 64
+
+	echo "  Cross object boundaries (with 2 full object copies)"
+	echo "    dddd|dddd|dddd|dddd => ddaa|aabb|bbcc|ccdd"
+	$XFS_IO_PROG -c "pwrite -S 0x64 0 $(($objsz * 4))" $dest >> $seqres.full 2>&1
+	$XFS_IO_PROG -c "copy_range -s 0 -d $halfobj -l $(($objsz * 3)) $file" "$dest"
+	check_range $dest 0 $halfobj 64
+	check_range $dest $halfobj $objsz 61
+	check_range $dest $(($objsz + $halfobj)) $objsz 62
+	check_range $dest $(($objsz * 2 + $halfobj)) $objsz 63
+	check_range $dest $(($objsz * 3 + $halfobj)) $halfobj 64
+
+}
+
+echo "Object size: 65536" # CEPH_MIN_STRIPE_UNIT
+run_copy_range_tests 65536
+echo "Object size: 1M"
+run_copy_range_tests 1048576
+echo "Object size: 4M"
+run_copy_range_tests 4194304
+# the max object size is 1TB, but by default OSDs only accept a max of 128M objects
+echo "Object size: 128M"
+run_copy_range_tests 134217728
+
+# success, all done
+status=0
+exit
diff --git a/tests/ceph/001.out b/tests/ceph/001.out
new file mode 100644
index 000000000000..3cc7837a595d
--- /dev/null
+++ b/tests/ceph/001.out
@@ -0,0 +1,129 @@
+QA output created by 001
+Object size: 65536
+  Copy whole file (3 objects):
+    aaaa|bbbb|cccc => aaaa|bbbb|cccc
+  Copy single object to beginning:
+    dddd|dddd|dddd => aaaa|dddd|dddd
+    aaaa|dddd|dddd => bbbb|dddd|dddd
+    bbbb|dddd|dddd => cccc|dddd|dddd
+  Copy single object to middle:
+    cccc|dddd|dddd => cccc|aaaa|dddd
+    cccc|aaaa|dddd => cccc|bbbb|dddd
+    cccc|bbbb|dddd => cccc|cccc|dddd
+  Copy single object to end:
+    cccc|cccc|dddd => cccc|cccc|aaaa
+    cccc|cccc|aaaa => cccc|cccc|bbbb
+    cccc|cccc|aaaa => cccc|cccc|cccc
+  Copy 2 objects to beginning:
+    cccc|cccc|cccc => aaaa|bbbb|cccc
+    aaaa|bbbb|cccc => bbbb|cccc|cccc
+  Copy 2 objects to end:
+    bbbb|cccc|cccc => bbbb|aaaa|bbbb
+    bbbb|aaaa|bbbb => bbbb|bbbb|cccc
+  Append 1 object:
+    bbbb|bbbb|cccc => bbbb|bbbb|cccc|aaaa
+  Cross object boundary (no full object copy)
+    dddd|dddd|dddd|dddd => ddaa|aadd|dddd|dddd
+    dddd|dddd|dddd|dddd => ddaa|bbdd|dddd|dddd
+  Cross object boundaries (with full object copy)
+    dddd|dddd|dddd|dddd => ddaa|bbbb|dddd|dddd
+    dddd|dddd|dddd|dddd => ddaa|bbbb|ccdd|dddd
+    dddd|dddd|dddd|dddd => dddd|aaaa|bbdd|dddd
+  Cross object boundaries (with 2 full object copies)
+    dddd|dddd|dddd|dddd => ddaa|aabb|bbcc|ccdd
+Object size: 1M
+  Copy whole file (3 objects):
+    aaaa|bbbb|cccc => aaaa|bbbb|cccc
+  Copy single object to beginning:
+    dddd|dddd|dddd => aaaa|dddd|dddd
+    aaaa|dddd|dddd => bbbb|dddd|dddd
+    bbbb|dddd|dddd => cccc|dddd|dddd
+  Copy single object to middle:
+    cccc|dddd|dddd => cccc|aaaa|dddd
+    cccc|aaaa|dddd => cccc|bbbb|dddd
+    cccc|bbbb|dddd => cccc|cccc|dddd
+  Copy single object to end:
+    cccc|cccc|dddd => cccc|cccc|aaaa
+    cccc|cccc|aaaa => cccc|cccc|bbbb
+    cccc|cccc|aaaa => cccc|cccc|cccc
+  Copy 2 objects to beginning:
+    cccc|cccc|cccc => aaaa|bbbb|cccc
+    aaaa|bbbb|cccc => bbbb|cccc|cccc
+  Copy 2 objects to end:
+    bbbb|cccc|cccc => bbbb|aaaa|bbbb
+    bbbb|aaaa|bbbb => bbbb|bbbb|cccc
+  Append 1 object:
+    bbbb|bbbb|cccc => bbbb|bbbb|cccc|aaaa
+  Cross object boundary (no full object copy)
+    dddd|dddd|dddd|dddd => ddaa|aadd|dddd|dddd
+    dddd|dddd|dddd|dddd => ddaa|bbdd|dddd|dddd
+  Cross object boundaries (with full object copy)
+    dddd|dddd|dddd|dddd => ddaa|bbbb|dddd|dddd
+    dddd|dddd|dddd|dddd => ddaa|bbbb|ccdd|dddd
+    dddd|dddd|dddd|dddd => dddd|aaaa|bbdd|dddd
+  Cross object boundaries (with 2 full object copies)
+    dddd|dddd|dddd|dddd => ddaa|aabb|bbcc|ccdd
+Object size: 4M
+  Copy whole file (3 objects):
+    aaaa|bbbb|cccc => aaaa|bbbb|cccc
+  Copy single object to beginning:
+    dddd|dddd|dddd => aaaa|dddd|dddd
+    aaaa|dddd|dddd => bbbb|dddd|dddd
+    bbbb|dddd|dddd => cccc|dddd|dddd
+  Copy single object to middle:
+    cccc|dddd|dddd => cccc|aaaa|dddd
+    cccc|aaaa|dddd => cccc|bbbb|dddd
+    cccc|bbbb|dddd => cccc|cccc|dddd
+  Copy single object to end:
+    cccc|cccc|dddd => cccc|cccc|aaaa
+    cccc|cccc|aaaa => cccc|cccc|bbbb
+    cccc|cccc|aaaa => cccc|cccc|cccc
+  Copy 2 objects to beginning:
+    cccc|cccc|cccc => aaaa|bbbb|cccc
+    aaaa|bbbb|cccc => bbbb|cccc|cccc
+  Copy 2 objects to end:
+    bbbb|cccc|cccc => bbbb|aaaa|bbbb
+    bbbb|aaaa|bbbb => bbbb|bbbb|cccc
+  Append 1 object:
+    bbbb|bbbb|cccc => bbbb|bbbb|cccc|aaaa
+  Cross object boundary (no full object copy)
+    dddd|dddd|dddd|dddd => ddaa|aadd|dddd|dddd
+    dddd|dddd|dddd|dddd => ddaa|bbdd|dddd|dddd
+  Cross object boundaries (with full object copy)
+    dddd|dddd|dddd|dddd => ddaa|bbbb|dddd|dddd
+    dddd|dddd|dddd|dddd => ddaa|bbbb|ccdd|dddd
+    dddd|dddd|dddd|dddd => dddd|aaaa|bbdd|dddd
+  Cross object boundaries (with 2 full object copies)
+    dddd|dddd|dddd|dddd => ddaa|aabb|bbcc|ccdd
+Object size: 128M
+  Copy whole file (3 objects):
+    aaaa|bbbb|cccc => aaaa|bbbb|cccc
+  Copy single object to beginning:
+    dddd|dddd|dddd => aaaa|dddd|dddd
+    aaaa|dddd|dddd => bbbb|dddd|dddd
+    bbbb|dddd|dddd => cccc|dddd|dddd
+  Copy single object to middle:
+    cccc|dddd|dddd => cccc|aaaa|dddd
+    cccc|aaaa|dddd => cccc|bbbb|dddd
+    cccc|bbbb|dddd => cccc|cccc|dddd
+  Copy single object to end:
+    cccc|cccc|dddd => cccc|cccc|aaaa
+    cccc|cccc|aaaa => cccc|cccc|bbbb
+    cccc|cccc|aaaa => cccc|cccc|cccc
+  Copy 2 objects to beginning:
+    cccc|cccc|cccc => aaaa|bbbb|cccc
+    aaaa|bbbb|cccc => bbbb|cccc|cccc
+  Copy 2 objects to end:
+    bbbb|cccc|cccc => bbbb|aaaa|bbbb
+    bbbb|aaaa|bbbb => bbbb|bbbb|cccc
+  Append 1 object:
+    bbbb|bbbb|cccc => bbbb|bbbb|cccc|aaaa
+  Cross object boundary (no full object copy)
+    dddd|dddd|dddd|dddd => ddaa|aadd|dddd|dddd
+    dddd|dddd|dddd|dddd => ddaa|bbdd|dddd|dddd
+  Cross object boundaries (with full object copy)
+    dddd|dddd|dddd|dddd => ddaa|bbbb|dddd|dddd
+    dddd|dddd|dddd|dddd => ddaa|bbbb|ccdd|dddd
+    dddd|dddd|dddd|dddd => dddd|aaaa|bbdd|dddd
+  Cross object boundaries (with 2 full object copies)
+    dddd|dddd|dddd|dddd => ddaa|aabb|bbcc|ccdd
diff --git a/tests/ceph/group b/tests/ceph/group
new file mode 100644
index 000000000000..11f0b9ad03d3
--- /dev/null
+++ b/tests/ceph/group
@@ -0,0 +1 @@
+001 auto quick copy
