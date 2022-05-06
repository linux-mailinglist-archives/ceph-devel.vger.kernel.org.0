Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6542251DBE4
	for <lists+ceph-devel@lfdr.de>; Fri,  6 May 2022 17:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442813AbiEFP0e (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 May 2022 11:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236859AbiEFP0d (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 May 2022 11:26:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 359C96D181
        for <ceph-devel@vger.kernel.org>; Fri,  6 May 2022 08:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651850569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IM365+AHg0AZZTvRcHswsg9LpepY6bpadHKKaJD8QFE=;
        b=FkEdR8u70MKFw0H8hfa97HW8BlasqF9SFPxyXYO/Olz3+M7/dzXtr82hejkSnP4RpO1fL6
        bmpq+6Luhfkmjcbd5NjHrZG7/MGDuSqKeKaoF0wwjWPg4wBGDhF3DNk7ZJmvyuNVr8o0t+
        9Q1iXtVTkob+6iPSpPZEvxhqdblJlCA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-572-UQABsKx0N_-Vaet24FKyVQ-1; Fri, 06 May 2022 11:22:48 -0400
X-MC-Unique: UQABsKx0N_-Vaet24FKyVQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87D203802127;
        Fri,  6 May 2022 15:22:47 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1E7940D2832;
        Fri,  6 May 2022 15:22:46 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3] ceph: switch to VM_BUG_ON_FOLIO and continue the loop for none write op
Date:   Fri,  6 May 2022 23:22:43 +0800
Message-Id: <20220506152243.497173-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
index 04a6c3f02f0c..63b7430e1ce6 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -85,7 +85,7 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
 	if (folio_test_dirty(folio)) {
 		dout("%p dirty_folio %p idx %lu -- already dirty\n",
 		     mapping->host, folio, folio->index);
-		BUG_ON(!folio_get_private(folio));
+		VM_BUG_ON_FOLIO(!folio_get_private(folio), folio);
 		return false;
 	}
 
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
+		if (req->r_ops[i].op != CEPH_OSD_OP_WRITE) {
+			pr_warn("%s incorrect op %d req %p index %d tid %llu\n",
+				__func__, req->r_ops[i].op, req, i, req->r_tid);
 			break;
+		}
 
 		osd_data = osd_req_op_extent_osd_data(req, i);
 		BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_PAGES);
-- 
2.36.0.rc1

