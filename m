Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D023A511AF7
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 16:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238086AbiD0OhD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 10:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238251AbiD0Ogx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 10:36:53 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B283B2711;
        Wed, 27 Apr 2022 07:33:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6B8011F74E;
        Wed, 27 Apr 2022 14:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651070020; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=TJGsd2vyilOxS/TRuC7c7/caltdCv/57VqwYPzi41Tg=;
        b=lhM7tFJuqzatgjsp+j6/7cDkxgvELkcagCYKDxKj3RcCaQX0c+2HbTDGXAKHsU0ug1a9j7
        sSI0h5NS18mnImzCu5Kjvd+EplF/CB/yTu3vlm5tlfgur24uaGR71VZHRsja9BJEZE74sg
        htRS91GSO82Lo3S1JaI9/8y3TnWnMCk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651070020;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=TJGsd2vyilOxS/TRuC7c7/caltdCv/57VqwYPzi41Tg=;
        b=Bjy6l+MU8vi8U+DhE9EYPKtTH1Bc6e27aR5X/SNaFin1vbxBClndadkW1LrszYLN2I/008
        juLh1TjYYFLCJmCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0524E13A39;
        Wed, 27 Apr 2022 14:33:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VobyOUNUaWKJeQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 27 Apr 2022 14:33:39 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 5ea18923;
        Wed, 27 Apr 2022 14:34:10 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, fstests@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH] ceph/005: verify correct statfs behaviour with quotas
Date:   Wed, 27 Apr 2022 15:34:09 +0100
Message-Id: <20220427143409.987-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 tests/ceph/005     | 40 ++++++++++++++++++++++++++++++++++++++++
 tests/ceph/005.out |  2 ++
 2 files changed, 42 insertions(+)
 create mode 100755 tests/ceph/005
 create mode 100644 tests/ceph/005.out

diff --git a/tests/ceph/005 b/tests/ceph/005
new file mode 100755
index 000000000000..0763a235a677
--- /dev/null
+++ b/tests/ceph/005
@@ -0,0 +1,40 @@
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
+_supported_fs generic
+_require_scratch
+
+_scratch_mount
+mkdir -p $SCRATCH_MNT/quota-dir/subdir
+
+# set quotas
+quota=$((1024*10000))
+$SETFATTR_PROG -n ceph.quota.max_bytes -v $quota $SCRATCH_MNT/quota-dir
+$SETFATTR_PROG -n ceph.quota.max_files -v $quota $SCRATCH_MNT/quota-dir/subdir
+_scratch_unmount
+
+SCRATCH_DEV=$SCRATCH_DEV/quota-dir _scratch_mount
+total=`df -kP $SCRATCH_MNT | grep -v Filesystem | awk '{print $2}'`
+SCRATCH_DEV=$SCRATCH_DEV/quota-dir _scratch_unmount
+[ $total -eq 8192 ] || _fail "Incorrect statfs for quota-dir: $total"
+
+SCRATCH_DEV=$SCRATCH_DEV/quota-dir/subdir _scratch_mount
+total=`df -kP $SCRATCH_MNT | grep -v Filesystem | awk '{print $2}'`
+SCRATCH_DEV=$SCRATCH_DEV/quota-dir/subdir _scratch_unmount
+[ $total -eq 8192 ] || _fail "Incorrect statfs for quota-dir/subdir: $total"
+
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
diff --git a/tests/ceph/005.out b/tests/ceph/005.out
new file mode 100644
index 000000000000..a5027f127cf0
--- /dev/null
+++ b/tests/ceph/005.out
@@ -0,0 +1,2 @@
+QA output created by 005
+Silence is golden
