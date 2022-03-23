Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB504E560E
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Mar 2022 17:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238546AbiCWQKi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 23 Mar 2022 12:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238404AbiCWQKi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 23 Mar 2022 12:10:38 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5533982C;
        Wed, 23 Mar 2022 09:09:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E7B20210F4;
        Wed, 23 Mar 2022 16:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1648051746; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2IxN7z4Sowx/xzRwzK7+Dz4IqTH5apCK98k/xw/792U=;
        b=IzlWM6Z33nCChekfuT91r1CRDrJqIn/RZpZzB5RprlEkjVOeBHk+JJDwzSnbs+e6igAyj3
        mGIB58F/Y8wWGUkH+449prECjd1pCNCNxNhn0U7m3I/cMzeAS+WBwrSj6pfEQd+rdUiYSv
        Zu9a19NlRQ+fQ+95ueKKoCYJEdWgEdQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1648051746;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2IxN7z4Sowx/xzRwzK7+Dz4IqTH5apCK98k/xw/792U=;
        b=BeNQbJ5WtwrNPNXWqI2QNFjDeM8PSbLUkfoBhOgzzOiiaJmGjzVVTrIly9EG9Z0UOfz2tK
        i6zboW2FTwcXzVAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8E3C212FC5;
        Wed, 23 Mar 2022 16:09:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9/myHyJGO2IMfgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 23 Mar 2022 16:09:06 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 48c22cc6;
        Wed, 23 Mar 2022 16:09:26 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, fstests@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH] ceph/001: add extra check for remote object copies
Date:   Wed, 23 Mar 2022 16:09:25 +0000
Message-Id: <20220323160925.7142-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Ceph kernel client now has a facility to check stats for certain operations.
One of these operations is the 'copyfrom', the operation that is used to offload
to the OSDs the copy of objects from, for example, the copy_file_range()
syscall.

This patch changes ceph/001 to add an extra check to verify that the copies
performed by the test are _really_ remote copies and not simple read+write
operations.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 common/ceph    | 10 ++++++++
 tests/ceph/001 | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/common/ceph b/common/ceph
index ca756dda8dd3..d6f24df177e7 100644
--- a/common/ceph
+++ b/common/ceph
@@ -28,3 +28,13 @@ _require_ceph_vxattr_caps()
 	$GETFATTR_PROG -n "ceph.caps" $TEST_DIR >/dev/null 2>&1 \
 	  || _notrun "ceph.caps vxattr not supported"
 }
+
+_ceph_get_cluster_fsid()
+{
+	$GETFATTR_PROG --only-values -n "ceph.cluster_fsid" $TEST_DIR 2>/dev/null
+}
+
+_ceph_get_client_id()
+{
+	$GETFATTR_PROG --only-values -n "ceph.client_id" $TEST_DIR 2>/dev/null
+}
diff --git a/tests/ceph/001 b/tests/ceph/001
index 5a828567d500..7970ce352bab 100755
--- a/tests/ceph/001
+++ b/tests/ceph/001
@@ -30,6 +30,10 @@ workdir=$TEST_DIR/test-$seq
 rm -rf $workdir
 mkdir $workdir
 
+cluster_fsid=$(_ceph_get_cluster_fsid)
+client_id=$(_ceph_get_client_id)
+metrics_dir="$DEBUGFS_MNT/ceph/$cluster_fsid.$client_id/metrics"
+
 check_range()
 {
 	local file=$1
@@ -40,8 +44,68 @@ check_range()
 	[ $? -eq 0 ] && echo "file $file is not '$val' in [ $off0 $off1 ]"
 }
 
+#
+# The metrics file has the following fields:
+#   1. item
+#   2. total
+#   3. avg_sz(bytes)
+#   4. min_sz(bytes)
+#   5. max_sz(bytes)
+#   6. total_sz(bytes)
+get_copyfrom_total_copies()
+{
+	local total=0
+
+	if [ -d $metrics_dir ]; then
+		total=$(grep copyfrom $metrics_dir/size | tr -s '[:space:]' | cut -d ' ' -f 2)
+	fi
+	echo $total
+}
+get_copyfrom_total_size()
+{
+	local total=0
+
+	if [ -d $metrics_dir ]; then
+		total=$(grep copyfrom $metrics_dir/size | tr -s '[:space:]' | cut -d ' ' -f 6)
+	fi
+	echo $total
+}
+
+# This function checks that the metrics file has the expected values for number
+# of remote object copies and the total size of the copies.  For this, it
+# expects a input:
+#   $1 - initial number copies in metrics file (field 'total')
+#   $2 - initial total size in bytes in metrics file (field 'total_sz')
+#   $3 - object size used for copies
+#   $4 - number of remote objects copied
+check_copyfrom_metrics()
+{
+	local c0=$1
+	local s0=$2
+	local objsz=$3
+	local copies=$4
+	local c1=$(get_copyfrom_total_copies)
+	local s1=$(get_copyfrom_total_size)
+	local sum
+
+	if [ ! -d $metrics_dir ]; then
+		return # skip metrics check if debugfs isn't mounted
+	fi
+
+	sum=$(($c0+$copies))
+	if [ $sum -ne $c1 ]; then
+		echo "Wrong number of remote copies.  Expected $sum, got $c1"
+	fi
+	sum=$(($s0+$copies*$objsz))
+	if [ $sum -ne $s1 ]; then
+		echo "Wrong size of remote copies.  Expected $sum, got $s1"
+	fi
+}
+
 run_copy_range_tests()
 {
+	total_copies=$(get_copyfrom_total_copies)
+	total_size=$(get_copyfrom_total_size)
 	objsz=$1
 	halfobj=$(($objsz / 2))
 	file="$workdir/file-$objsz"
@@ -203,6 +267,8 @@ run_copy_range_tests()
 	check_range $dest $(($objsz * 2 + $halfobj)) $objsz 63
 	check_range $dest $(($objsz * 3 + $halfobj)) $halfobj 64
 
+	# Confirm that we've done a total of 24 object copies
+	check_copyfrom_metrics $total_copies $total_size $objsz 24
 }
 
 echo "Object size: 65536" # CEPH_MIN_STRIPE_UNIT
