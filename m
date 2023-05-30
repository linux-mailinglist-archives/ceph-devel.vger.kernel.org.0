Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56930715679
	for <lists+ceph-devel@lfdr.de>; Tue, 30 May 2023 09:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjE3HT1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 May 2023 03:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbjE3HTK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 May 2023 03:19:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E857188
        for <ceph-devel@vger.kernel.org>; Tue, 30 May 2023 00:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685431014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4DzuXWdn5q+2H/HkXTGSP4YifSU43L78+nfm+Plm8nw=;
        b=TQLcF/uaQ+n/PsyDCRhR2Kt1kIv4oKuqA224cGL89FZsnAsNW7kPeOc6L1COFtG/idg4LK
        GhwEQWDZwJeMLNM9BAXpo6Ncwor+strrXv3kAnO9l5Sul7Ta1pEH8gtmt6LYbiBVlltTKy
        HwGsEoW6S570TB7oas+OOpxKsiTBEg0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-InVDwGGWPJWEQtJlN3gLZA-1; Tue, 30 May 2023 03:16:51 -0400
X-MC-Unique: InVDwGGWPJWEQtJlN3gLZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DCF73C0CEEA;
        Tue, 30 May 2023 07:16:50 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-188.pek2.redhat.com [10.72.12.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4A6A40C6CCC;
        Tue, 30 May 2023 07:16:30 +0000 (UTC)
From:   xiubli@redhat.com
To:     fstests@vger.kernel.org
Cc:     zlang@redhat.com, david@fromorbit.com, djwong@kernel.org,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] generic/020: add ceph-fuse support
Date:   Tue, 30 May 2023 15:15:52 +0800
Message-Id: <20230530071552.766424-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

For ceph fuse client the fs type will be "ceph-fuse".

Fixes: https://tracker.ceph.com/issues/61496
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 tests/generic/020 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/020 b/tests/generic/020
index e00365a9..da258aa5 100755
--- a/tests/generic/020
+++ b/tests/generic/020
@@ -56,7 +56,7 @@ _attr_get_max()
 {
 	# set maximum total attr space based on fs type
 	case "$FSTYP" in
-	xfs|udf|pvfs2|9p|ceph|fuse|nfs)
+	xfs|udf|pvfs2|9p|ceph|fuse|nfs|ceph-fuse)
 		max_attrs=1000
 		;;
 	ext2|ext3|ext4)
-- 
2.40.1

