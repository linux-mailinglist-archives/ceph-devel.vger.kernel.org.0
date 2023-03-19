Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D546BFF95
	for <lists+ceph-devel@lfdr.de>; Sun, 19 Mar 2023 07:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjCSGbP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 19 Mar 2023 02:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjCSGbN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 19 Mar 2023 02:31:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C356E19109
        for <ceph-devel@vger.kernel.org>; Sat, 18 Mar 2023 23:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679207413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oQdoYneqxB38oSnnXNvER25kilgSQblF3svLTyKprLQ=;
        b=R6DllbriQFu4KHEMXcRbQxXv6mz3y7uZsgQR/tCTVcKGlppeE/YjqZ2lyfPSNcpZXSw8Jc
        m0edXhl0aM90qtWeWtyEDhCcPm0b4urco7AWuXIrXkvGTHYlrYZdbGL4PGK45cBwtxFDYF
        GWk0Ymc6bSxLg/fSjbmFFy2Wy99ESMU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-5rrFs7nzNIOfAZ0MHRqnlQ-1; Sun, 19 Mar 2023 02:30:08 -0400
X-MC-Unique: 5rrFs7nzNIOfAZ0MHRqnlQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 641943C0252E;
        Sun, 19 Mar 2023 06:30:08 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 99EF5C15BA0;
        Sun, 19 Mar 2023 06:30:00 +0000 (UTC)
From:   xiubli@redhat.com
To:     fstests@vger.kernel.org
Cc:     david@fromorbit.com, djwong@kernel.org, ceph-devel@vger.kernel.org,
        zlang@redhat.com, vshankar@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] generic/020: fix another really long attr test failure for ceph
Date:   Sun, 19 Mar 2023 14:29:27 +0800
Message-Id: <20230319062928.278235-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

If the CONFIG_CEPH_FS_SECURITY_LABEL is disabled the kernel ceph
the 'selinux_size' will be empty and then:
max_attrval_size=$((65536 - $size - $selinux_size - $max_attrval_namelen))
will be:
max_attrval_size=$((65536 - $size - - $max_attrval_namelen))
which equals to:
max_attrval_size=$((65536 - $size + $max_attrval_namelen))

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 tests/generic/020 | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tests/generic/020 b/tests/generic/020
index 538a24c6..e00365a9 100755
--- a/tests/generic/020
+++ b/tests/generic/020
@@ -154,6 +154,12 @@ _attr_get_maxval_size()
 			awk -F "=0x" '/^user/ {len += length($1) + length($2) / 2} END {print len}')
 		local selinux_size=$(getfattr -n 'security.selinux' --dump -e hex $filename 2>/dev/null | \
 			awk -F "=0x" '/^security/ {len += length($1) + length($2) / 2} END {print len}')
+		if [ -z $size ]; then
+			size=0
+		fi
+		if [ -z $selinux_size ]; then
+			selinux_size=0
+		fi
 		max_attrval_size=$((65536 - $size - $selinux_size - $max_attrval_namelen))
 		;;
 	*)
-- 
2.31.1

