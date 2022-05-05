Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688E351BFC2
	for <lists+ceph-devel@lfdr.de>; Thu,  5 May 2022 14:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377723AbiEEMvK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 May 2022 08:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377714AbiEEMvH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 May 2022 08:51:07 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E56074ECD3
        for <ceph-devel@vger.kernel.org>; Thu,  5 May 2022 05:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651754847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ng/yS4CDuZeioJqwFKAzCOJfDAtzZ/LR/AXfhVXojRM=;
        b=fvusXyapynGAIbpKr10eZavN95TLmTAeMIMHMm7Urlh1rZHdQLTQIisbe+Kf/aXE3wkqPD
        ipTKvi9jENdUjLJS8bnhPzgwmpam32buPWyp3JVtybrLfVCXbH2s5IzmhdgzhKuCMaJ3sH
        bPZ+363O1gvgi1MMEDcI9ibPiq8XMM4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-dvZBLCgnOBGTHxdzEVceqw-1; Thu, 05 May 2022 08:47:25 -0400
X-MC-Unique: dvZBLCgnOBGTHxdzEVceqw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D887803D4E;
        Thu,  5 May 2022 12:47:25 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F32BB40CF8ED;
        Thu,  5 May 2022 12:47:24 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: switch to VM_BUG_ON_FOLIO and continue the loop for none write op
Date:   Thu,  5 May 2022 20:47:18 +0800
Message-Id: <20220505124718.50261-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Use the VM_BUG_ON_FOLIO macro to get more infomation when we hit
the BUG_ON, and continue the loop when seeing the incorrect none
write opcode in writepages_finish().

URL: https://tracker.ceph.com/issues/55421
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index e52b62407b10..d4bcef1d9549 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -122,7 +122,7 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
 	 * Reference snap context in folio->private.  Also set
 	 * PagePrivate so that we get invalidate_folio callback.
 	 */
-	BUG_ON(folio_get_private(folio));
+	VM_BUG_ON_FOLIO(folio_get_private(folio), folio);
 	folio_attach_private(folio, snapc);
 
 	return ceph_fscache_dirty_folio(mapping, folio);
@@ -733,8 +733,11 @@ static void writepages_finish(struct ceph_osd_request *req)
 
 	/* clean all pages */
 	for (i = 0; i < req->r_num_ops; i++) {
-		if (req->r_ops[i].op != CEPH_OSD_OP_WRITE)
-			break;
+		if (req->r_ops[i].op != CEPH_OSD_OP_WRITE) {
+			pr_warn("%s incorrect op %d req %p index %d tid %llu\n",
+				__func__, req->r_ops[i].op, req, i, req->r_tid);
+			continue;
+		}
 
 		osd_data = osd_req_op_extent_osd_data(req, i);
 		BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_PAGES);
-- 
2.36.0.rc1

