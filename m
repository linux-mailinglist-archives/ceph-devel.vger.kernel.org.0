Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D431B51342A
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Apr 2022 14:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346643AbiD1Mwp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Apr 2022 08:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbiD1Mwp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 28 Apr 2022 08:52:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 187F447051
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 05:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651150170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mXfwdcdotgDYx3rxWiNlYj9nINKcnzaBFflo9cbJawI=;
        b=QfAfvgVFB0+UQBYyEavogw67wn4sZSltRhWbDUBIvy8jRDt67CCOS7IYhxyt5W3saOSKTr
        ZEooa+9+QxTFvpgC/MQW4rL+Utmtz1Uonx4wmBpCP/BGH8y85D2fnHbeKg0ZO4tbYKr+7E
        FYDSpF1UFbZBMMFyqUmkbw6B3kcPjFw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-xAq0dSDgPOCM6YMnEtqkhw-1; Thu, 28 Apr 2022 08:49:27 -0400
X-MC-Unique: xAq0dSDgPOCM6YMnEtqkhw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AEA5F1C0BF11;
        Thu, 28 Apr 2022 12:49:26 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11F2040869CB;
        Thu, 28 Apr 2022 12:49:25 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: try to queue a writeback if revoking fails
Date:   Thu, 28 Apr 2022 20:49:23 +0800
Message-Id: <20220428124923.80759-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If the pagecaches writeback just finished and the i_wrbuffer_ref
reaches zero it will try to trigger ceph_check_caps(). But if just
before ceph_check_caps() the i_wrbuffer_ref could be increased
again by mmap/cache write, then the Fwb revoke will fail.

We need to try to queue a writeback in this case instead of
triggering the writeback by BDI's delayed work per 5 seconds.

URL: https://tracker.ceph.com/issues/55377
URL: https://tracker.ceph.com/issues/46904
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 906c95d2a4ed..22dae29be64d 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1912,6 +1912,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 	struct rb_node *p;
 	bool queue_invalidate = false;
 	bool tried_invalidate = false;
+	bool queue_writeback = false;
 
 	if (session)
 		ceph_get_mds_session(session);
@@ -2064,10 +2065,27 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 		}
 
 		/* completed revocation? going down and there are no caps? */
-		if (revoking && (revoking & cap_used) == 0) {
-			dout("completed revocation of %s\n",
-			     ceph_cap_string(cap->implemented & ~cap->issued));
-			goto ack;
+		if (revoking) {
+			if ((revoking & cap_used) == 0) {
+				dout("completed revocation of %s\n",
+				      ceph_cap_string(cap->implemented & ~cap->issued));
+				goto ack;
+			}
+
+			/*
+			 * If the "i_wrbuffer_ref" was increased by mmap or generic
+			 * cache write just before the ceph_check_caps() is called,
+			 * the Fb capability revoking will fail this time. Then we
+			 * must wait for the BDI's delayed work to flush the dirty
+			 * pages and to release the "i_wrbuffer_ref", which will cost
+			 * at most 5 seconds. That means the MDS needs to wait at
+			 * most 5 seconds to finished the Fb capability's revocation.
+			 *
+			 * Let's queue a writeback for it.
+			 */
+			if (S_ISREG(inode->i_mode) && ci->i_wrbuffer_ref &&
+			    (revoking & CEPH_CAP_FILE_BUFFER))
+				queue_writeback = true;
 		}
 
 		/* want more caps from mds? */
@@ -2137,6 +2155,8 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 	spin_unlock(&ci->i_ceph_lock);
 
 	ceph_put_mds_session(session);
+	if (queue_writeback)
+		ceph_queue_writeback(inode);
 	if (queue_invalidate)
 		ceph_queue_invalidate(inode);
 }
-- 
2.36.0.rc1

