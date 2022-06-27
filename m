Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA1E55E2FA
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Jun 2022 15:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbiF0KZt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Jun 2022 06:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiF0KZs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 27 Jun 2022 06:25:48 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA96D5FEF;
        Mon, 27 Jun 2022 03:25:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 78FA11FD62;
        Mon, 27 Jun 2022 10:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1656325546; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7ETJOF0iAdEqALMtiewRf6iCPPgSCTqbTRHs+voWVt8=;
        b=YpJh7Ed0E7sDDUWT83nGOM7GjBjLP4EMxJyOKaWYkkyFkeuAJI1EOS37XmPV9G+4kjDuc5
        DKoG76vhbPqnHaztpzEhlx6raT5fDOXaEOY6p8W6WwINJpOEY7LuKyMTZQGTeLtpIrPrST
        +AMoEBxJXB97puVxLBjCjDM4msFPnFI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1656325546;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7ETJOF0iAdEqALMtiewRf6iCPPgSCTqbTRHs+voWVt8=;
        b=iIBT/i4P+KrLRpcSupTwtQ82GOGPCuPV69Gx3o9pEgUutNfI8wePaXEX2dUv7wMyKzRV7t
        O2SrM405BYzFzsCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F1D6313AB2;
        Mon, 27 Jun 2022 10:25:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id i3EVOKmFuWJuRAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 27 Jun 2022 10:25:45 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 7fa14c51;
        Mon, 27 Jun 2022 10:26:32 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     fstests@vger.kernel.org
Cc:     David Disseldorp <ddiss@suse.de>, Zorro Lang <zlang@redhat.com>,
        Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        ceph-devel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH v3] ceph/005: verify correct statfs behaviour with quotas
Date:   Mon, 27 Jun 2022 11:26:31 +0100
Message-Id: <20220627102631.5006-1-lhenriques@suse.de>
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

When using a directory with 'max_bytes' quota as a base for a mount,
statfs shall use that 'max_bytes' value as the total disk size.  That
value shall be used even when using subdirectory as base for the mount.

A bug was found where, when this subdirectory also had a 'max_files'
quota, the real filesystem size would be returned instead of the parent
'max_bytes' quota value.  This test case verifies this bug is fixed.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
Changes since v2:
 - correctly set SCRATCH_DEV, always using its original value

Changes since v1 are:
 - creation of an helper for getting total mount space using 'df'
 - now the test sends quota size to stdout

 common/rc          | 13 +++++++++++++
 tests/ceph/005     | 39 +++++++++++++++++++++++++++++++++++++++
 tests/ceph/005.out |  4 ++++
 3 files changed, 56 insertions(+)
 create mode 100755 tests/ceph/005
 create mode 100644 tests/ceph/005.out

diff --git a/common/rc b/common/rc
index 2f31ca464621..72eabb7a428c 100644
--- a/common/rc
+++ b/common/rc
@@ -4254,6 +4254,19 @@ _get_available_space()
 	echo $((avail_kb * 1024))
 }
 
+# get the total space in bytes
+#
+_get_total_space()
+{
+	if [ -z "$1" ]; then
+		echo "Usage: _get_total_space <mnt>"
+		exit 1
+	fi
+	local total_kb;
+	total_kb=`$DF_PROG $1 | tail -n1 | awk '{ print $3 }'`
+	echo $(($total_kb * 1024))
+}
+
 # return device size in kb
 _get_device_size()
 {
diff --git a/tests/ceph/005 b/tests/ceph/005
new file mode 100755
index 000000000000..fd71d91350db
--- /dev/null
+++ b/tests/ceph/005
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2022 SUSE Linux Products GmbH. All Rights Reserved.
+#
+# FS QA Test 005
+#
+# Make sure statfs reports correct total size when:
+# 1. using a directory with 'max_byte' quota as base for a mount
+# 2. using a subdirectory of the above directory with 'max_files' quota
+#
+. ./common/preamble
+_begin_fstest auto quick quota
+
+_supported_fs ceph
+_require_scratch
+
+_scratch_mount
+mkdir -p "$SCRATCH_MNT/quota-dir/subdir"
+
+# set quota
+quota=$((2 ** 30)) # 1G 
+$SETFATTR_PROG -n ceph.quota.max_bytes -v "$quota" "$SCRATCH_MNT/quota-dir"
+$SETFATTR_PROG -n ceph.quota.max_files -v "$quota" "$SCRATCH_MNT/quota-dir/subdir"
+_scratch_unmount
+
+SCRATCH_DEV_ORIG="$SCRATCH_DEV"
+SCRATCH_DEV="$SCRATCH_DEV/quota-dir" _scratch_mount
+echo ceph quota size is $(_get_total_space "$SCRATCH_MNT") bytes
+SCRATCH_DEV="$SCRATCH_DEV_ORIG/quota-dir" _scratch_unmount
+
+SCRATCH_DEV="$SCRATCH_DEV_ORIG/quota-dir/subdir" _scratch_mount
+echo subdir ceph quota size is $(_get_total_space "$SCRATCH_MNT") bytes
+SCRATCH_DEV="$SCRATCH_DEV_ORIG/quota-dir/subdir" _scratch_unmount
+
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
diff --git a/tests/ceph/005.out b/tests/ceph/005.out
new file mode 100644
index 000000000000..47798b1fcd6f
--- /dev/null
+++ b/tests/ceph/005.out
@@ -0,0 +1,4 @@
+QA output created by 005
+ceph quota size is 1073741824 bytes
+subdir ceph quota size is 1073741824 bytes
+Silence is golden
