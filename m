Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106D76A654C
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Mar 2023 03:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjCACIh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Feb 2023 21:08:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjCACIg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 28 Feb 2023 21:08:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2DC3646C
        for <ceph-devel@vger.kernel.org>; Tue, 28 Feb 2023 18:07:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677636466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ED5XjjmM9m4o8ZkoSXU/xAeHv8sNQVmEbMS+K5GlgBs=;
        b=V6gS+QXq2Sli/NTg4MqAEOU7d7fUs2OUCvLBUH0tyw5Oo1vKBOQ1yIrmDbE85cpKbtLGdQ
        Ro/DxttsspoqrhtANQpFpxwfIXlFtYuHFK2JBZ/kefs7hUALYyr0mGXxs2gdaXCGpBl39p
        YoEDMUAD1IHfIqpaZnl1+67n++KIrEQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-SJ8x4P1oO8CjWXI1UHz6cA-1; Tue, 28 Feb 2023 21:07:45 -0500
X-MC-Unique: SJ8x4P1oO8CjWXI1UHz6cA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A874938123A5;
        Wed,  1 Mar 2023 02:07:44 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F29DE2026D4B;
        Wed,  1 Mar 2023 02:07:41 +0000 (UTC)
From:   xiubli@redhat.com
To:     fstests@vger.kernel.org
Cc:     david@fromorbit.com, djwong@kernel.org, ceph-devel@vger.kernel.org,
        vshankar@redhat.com, zlang@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] generic/075: no need to move the .fsxlog to the same directory
Date:   Wed,  1 Mar 2023 10:07:30 +0800
Message-Id: <20230301020730.92354-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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

Actually it was trying to move the '075.$_n.fsxlog' from results
directory to the same results directory.

Fixes: https://tracker.ceph.com/issues/58834
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 tests/generic/075 | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tests/generic/075 b/tests/generic/075
index 9f24ad41..03a394a6 100755
--- a/tests/generic/075
+++ b/tests/generic/075
@@ -57,7 +57,6 @@ _do_test()
     then
 	echo "    fsx ($_param) failed, $? - compare $seqres.$_n.{good,bad,fsxlog}"
 	mv $out/$seq.$_n $seqres.$_n.full
-	mv "$RESULT_DIR"/$seq.$_n.fsxlog $seqres.$_n.fsxlog
 	od -xAx $seqres.$_n.full > $seqres.$_n.bad
 	od -xAx "$RESULT_DIR"/$seq.$_n.fsxgood > $seqres.$_n.good
 	rm -f "$RESULT_DIR"/$seq.$_n.fsxgood
-- 
2.31.1

