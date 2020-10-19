Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353A8292823
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Oct 2020 15:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgJSN1x (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Oct 2020 09:27:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:55656 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728203AbgJSN1w (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 19 Oct 2020 09:27:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6E5B2ACDF;
        Mon, 19 Oct 2020 13:27:50 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 39482c5b;
        Mon, 19 Oct 2020 13:27:54 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     fstests@vger.kernel.org
Cc:     Eryu Guan <guan@eryu.me>, Jeff Layton <jlayton@kernel.org>,
        ceph-devel@vger.kernel.org, Luis Henriques <lhenriques@suse.com>
Subject: [PATCH v2 2/3] ceph: test combination of copy_file_range with truncate
Date:   Mon, 19 Oct 2020 14:27:49 +0100
Message-Id: <20201019132750.29293-3-lhenriques@suse.de>
In-Reply-To: <20201019132750.29293-1-lhenriques@suse.de>
References: <20201019132750.29293-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Luis Henriques <lhenriques@suse.com>

This tests a bug found while testing copy_file_range.  This bug was an
issue with how the OSDs handled the truncate_seq value, which was being
copied from the original object into the destination object.  This test
ensures the kernel client correctly handles fixed/non-fixed OSDs.

Link: https://tracker.ceph.com/issues/37378
Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
 tests/ceph/002     | 79 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/ceph/002.out |  8 +++++
 tests/ceph/group   |  1 +
 3 files changed, 88 insertions(+)
 create mode 100755 tests/ceph/002
 create mode 100644 tests/ceph/002.out

diff --git a/tests/ceph/002 b/tests/ceph/002
new file mode 100755
index 000000000000..f0fd28a14991
--- /dev/null
+++ b/tests/ceph/002
@@ -0,0 +1,79 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 SUSE Linux Products GmbH. All Rights Reserved.
+#
+# FS QA Test No. ceph/002
+#
+# Test bug found while testing copy_file_range.
+#
+# This bug was an issue with how the OSDs handled the truncate_seq, copying it
+# from the original object into the destination object.  This test ensures the
+# kernel client correctly handles fixed/non-fixed OSDs.
+#
+# The bug was tracked here:
+#
+#   https://tracker.ceph.com/issues/37378
+#
+# The most relevant commits are:
+#
+#   ceph OSD:     dcd6a99ef9f5 ("osd: add new 'copy-from2' operation")
+#   linux kernel: 78beb0ff2fec ("ceph: use copy-from2 op in copy_file_range")
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
+# Use 4M object size
+objsz=4194304
+file="$workdir/file-$objsz"
+dest="$workdir/dest-$objsz"
+
+# object_size has to be a multiple of stripe_unit
+_ceph_create_file_layout $file $objsz 1 $objsz
+_ceph_create_file_layout $dest $objsz 1 $objsz
+
+# Create a 3 objects size files
+$XFS_IO_PROG -c "pwrite -S 0x61 0 $objsz" $file >> $seqres.full 2>&1
+$XFS_IO_PROG -c "pwrite -S 0x62 $objsz $objsz" $file >> $seqres.full 2>&1
+$XFS_IO_PROG -c "pwrite -S 0x63 $(($objsz * 2)) $objsz" $file >> $seqres.full 2>&1
+
+$XFS_IO_PROG -c "pwrite -S 0x64 0 $(($objsz * 3))" $dest >> $seqres.full 2>&1
+# Truncate the destination file (messing up with the truncate_seq)
+$XFS_IO_PROG -c "truncate 0" $dest >> $seqres.full 2>&1
+
+# copy the whole file over
+$XFS_IO_PROG -c "copy_range -s 0 -d 0 -l $(($objsz * 3)) $file" "$dest"
+
+hexdump $dest
+
+#success, all done
+status=0
+exit
diff --git a/tests/ceph/002.out b/tests/ceph/002.out
new file mode 100644
index 000000000000..6f067250afff
--- /dev/null
+++ b/tests/ceph/002.out
@@ -0,0 +1,8 @@
+QA output created by 002
+0000000 6161 6161 6161 6161 6161 6161 6161 6161
+*
+0400000 6262 6262 6262 6262 6262 6262 6262 6262
+*
+0800000 6363 6363 6363 6363 6363 6363 6363 6363
+*
+0c00000
diff --git a/tests/ceph/group b/tests/ceph/group
index 11f0b9ad03d3..c28fe473c1a4 100644
--- a/tests/ceph/group
+++ b/tests/ceph/group
@@ -1 +1,2 @@
 001 auto quick copy
+002 auto quick copy
