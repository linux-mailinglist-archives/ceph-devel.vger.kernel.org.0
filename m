Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1266A3A0D
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 05:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjB0EPN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Feb 2023 23:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjB0EPM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Feb 2023 23:15:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519EAEB74
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 20:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677471248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=o6eBJd3hpO6XAkHQyGbYVPkc1JFXUxjDTT6VMs25oxw=;
        b=M/Iq3WyAKPUyM1nt7zdAcuPjI1wH2Dnbcr9nXvOmjHxDnKP8Dhrw+rxraHXpuugCoDaGDi
        gPZXoyfvtJD+xwbJ47TiiH6h/LcwTM2gjEt8QTAxf809c3zMoyOmOjcSLYv8oCanq8uMB3
        wZOct8cTskNStE4bNjaW66L0HGmVFFA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-ELOP_AqoPq2cKrwNN--TjA-1; Sun, 26 Feb 2023 23:14:07 -0500
X-MC-Unique: ELOP_AqoPq2cKrwNN--TjA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD1C695D600;
        Mon, 27 Feb 2023 04:14:06 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EACAF1121314;
        Mon, 27 Feb 2023 04:14:03 +0000 (UTC)
From:   xiubli@redhat.com
To:     fstests@vger.kernel.org
Cc:     david@fromorbit.com, djwong@kernel.org, ceph-devel@vger.kernel.org,
        vshankar@redhat.com, zlang@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] generic/020: fix really long attr test failure for ceph
Date:   Mon, 27 Feb 2023 12:13:58 +0800
Message-Id: <20230227041358.350309-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

If the CONFIG_CEPH_FS_SECURITY_LABEL is enabled the kernel ceph
itself will set the security.selinux extended attribute to MDS.
And it will also eat some space of the total size.

Fixes: https://tracker.ceph.com/issues/58742
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V2:
- make the 'size' and the 'selinux_size' to be local

 tests/generic/020 | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tests/generic/020 b/tests/generic/020
index be5cecad..538a24c6 100755
--- a/tests/generic/020
+++ b/tests/generic/020
@@ -150,9 +150,11 @@ _attr_get_maxval_size()
 		# it imposes a maximum size for the full set of xattrs
 		# names+values, which by default is 64K.  Compute the maximum
 		# taking into account the already existing attributes
-		max_attrval_size=$(getfattr --dump -e hex $filename 2>/dev/null | \
+		local size=$(getfattr --dump -e hex $filename 2>/dev/null | \
 			awk -F "=0x" '/^user/ {len += length($1) + length($2) / 2} END {print len}')
-		max_attrval_size=$((65536 - $max_attrval_size - $max_attrval_namelen))
+		local selinux_size=$(getfattr -n 'security.selinux' --dump -e hex $filename 2>/dev/null | \
+			awk -F "=0x" '/^security/ {len += length($1) + length($2) / 2} END {print len}')
+		max_attrval_size=$((65536 - $size - $selinux_size - $max_attrval_namelen))
 		;;
 	*)
 		# Assume max ~1 block of attrs
-- 
2.31.1

