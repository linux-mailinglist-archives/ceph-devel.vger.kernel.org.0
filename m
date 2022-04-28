Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75DFD512E98
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Apr 2022 10:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344477AbiD1IiY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Apr 2022 04:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344305AbiD1Ihz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 28 Apr 2022 04:37:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 715FBE39
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 01:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651134607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=I2wrfYcNIOLgcNYaUH9gIx/gO6yKyq4svmq4ggvJcaw=;
        b=AZJ8QiC7jo+bLBrt6q8VZNhsJEgSzEnCR5lt1t5ltUxRjz7mQdz2syUIGe1BAcAtv0Vn3J
        ZrLRXUkkVcuPz6dZoqPQL1VEDW+bsN/jo2OJYZ9Aq6xofjHeF6AKgImCdU6c63Ggh2LSo/
        THHKFIheChq98TXdhHQWHBjTziEP7cE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-Kk6zolyhPAykjuh09YmnmA-1; Thu, 28 Apr 2022 04:30:04 -0400
X-MC-Unique: Kk6zolyhPAykjuh09YmnmA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 896B7296A606;
        Thu, 28 Apr 2022 08:30:03 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0BCC414A7E9;
        Thu, 28 Apr 2022 08:30:02 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: try to queue a writeback if revoking fails
Date:   Thu, 28 Apr 2022 16:29:49 +0800
Message-Id: <20220428082949.11841-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
 fs/ceph/caps.c  | 44 +++++++++++++++++++++++++++++++++++---------
 fs/ceph/super.h |  7 +++++++
 2 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 906c95d2a4ed..0c0c8f5ae3b3 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1912,6 +1912,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 	struct rb_node *p;
 	bool queue_invalidate = false;
 	bool tried_invalidate = false;
+	bool queue_writeback = false;
 
 	if (session)
 		ceph_get_mds_session(session);
@@ -2064,10 +2065,30 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
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
+			if ((ci->i_last_caps &
+			     (CEPH_CAP_FAKE_WRBUFFER | CEPH_CAP_FILE_BUFFER)) &&
+			    ci->i_wrbuffer_ref && S_ISREG(inode->i_mode) &&
+			    (revoking & CEPH_CAP_FILE_BUFFER)) {
+				queue_writeback = true;
+			}
 		}
 
 		/* want more caps from mds? */
@@ -2134,9 +2155,12 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 		__cap_delay_requeue(mdsc, ci);
 	}
 
+	ci->i_last_caps = 0;
 	spin_unlock(&ci->i_ceph_lock);
 
 	ceph_put_mds_session(session);
+	if (queue_writeback)
+		ceph_queue_writeback(inode);
 	if (queue_invalidate)
 		ceph_queue_invalidate(inode);
 }
@@ -3084,16 +3108,16 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
 		--ci->i_pin_ref;
 	if (had & CEPH_CAP_FILE_RD)
 		if (--ci->i_rd_ref == 0)
-			last++;
+			last |= CEPH_CAP_FILE_RD;
 	if (had & CEPH_CAP_FILE_CACHE)
 		if (--ci->i_rdcache_ref == 0)
-			last++;
+			last |= CEPH_CAP_FILE_CACHE;
 	if (had & CEPH_CAP_FILE_EXCL)
 		if (--ci->i_fx_ref == 0)
-			last++;
+			last |= CEPH_CAP_FILE_EXCL;
 	if (had & CEPH_CAP_FILE_BUFFER) {
 		if (--ci->i_wb_ref == 0) {
-			last++;
+			last |= CEPH_CAP_FILE_BUFFER;
 			/* put the ref held by ceph_take_cap_refs() */
 			put++;
 			check_flushsnaps = true;
@@ -3103,7 +3127,7 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
 	}
 	if (had & CEPH_CAP_FILE_WR) {
 		if (--ci->i_wr_ref == 0) {
-			last++;
+			last |= CEPH_CAP_FILE_WR;
 			check_flushsnaps = true;
 			if (ci->i_wrbuffer_ref_head == 0 &&
 			    ci->i_dirty_caps == 0 &&
@@ -3131,6 +3155,7 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
 			flushsnaps = 1;
 		wake = 1;
 	}
+	ci->i_last_caps |= last;
 	spin_unlock(&ci->i_ceph_lock);
 
 	dout("put_cap_refs %p had %s%s%s\n", inode, ceph_cap_string(had),
@@ -3193,6 +3218,7 @@ void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
 	spin_lock(&ci->i_ceph_lock);
 	ci->i_wrbuffer_ref -= nr;
 	if (ci->i_wrbuffer_ref == 0) {
+		ci->i_last_caps |= CEPH_CAP_FAKE_WRBUFFER;
 		last = true;
 		put++;
 	}
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 73db7f6021f3..f275a41649af 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -362,6 +362,13 @@ struct ceph_inode_info {
 	struct ceph_cap *i_auth_cap;     /* authoritative cap, if any */
 	unsigned i_dirty_caps, i_flushing_caps;     /* mask of dirtied fields */
 
+	/*
+	 * The capabilities whose references reach to 0, and the bit
+	 * (CEPH_CAP_BITS) is for i_wrbuffer_ref.
+	 */
+#define CEPH_CAP_FAKE_WRBUFFER (1 << CEPH_CAP_BITS)
+	unsigned i_last_caps;
+
 	/*
 	 * Link to the auth cap's session's s_cap_dirty list. s_cap_dirty
 	 * is protected by the mdsc->cap_dirty_lock, but each individual item
-- 
2.36.0.rc1

