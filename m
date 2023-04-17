Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850F16E3E46
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Apr 2023 05:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbjDQDgZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Apr 2023 23:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjDQDgC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 16 Apr 2023 23:36:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BA43AA1
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 20:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681702387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TBFRaDK7mceB8LzeiQQjLfsePnlvbZht9MPS5mOUKI0=;
        b=V6gTx0gX0BDapBu1yMkPiFuafqjfJ52o8c6f1Nqt1DT0X9wk4mnF7Kb8R3uavSvJDiNwwf
        60s5tfGtArWub4AyFml7Ao7RqbGWm54NWPwZQ3rnsbB5275tNv7QdyaXIK7nYK8TiNe5Mj
        ruWLtdNRKFIwzIdb9cK6S4ZfrpHY54Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-pnpCk_h0N--egXFXrBv-lg-1; Sun, 16 Apr 2023 23:33:04 -0400
X-MC-Unique: pnpCk_h0N--egXFXrBv-lg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BC6929ABA20;
        Mon, 17 Apr 2023 03:33:04 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF7902027044;
        Mon, 17 Apr 2023 03:32:59 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, lhenriques@suse.de,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v19 68/70] ceph: fix updating the i_truncate_pagecache_size for fscrypt
Date:   Mon, 17 Apr 2023 11:26:52 +0800
Message-Id: <20230417032654.32352-69-xiubli@redhat.com>
In-Reply-To: <20230417032654.32352-1-xiubli@redhat.com>
References: <20230417032654.32352-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When fscrypt is enabled we will align the truncate size up to the
CEPH_FSCRYPT_BLOCK_SIZE always, so if we truncate the size in the
same block more than once, the latter ones will be skipped being
invalidated from the page caches.

This will force invalidating the page caches by using the smaller
size than the real file size.

At the same time add more debug log and fix the debug log for
truncate code.

URL: https://tracker.ceph.com/issues/58834
Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c  |  4 ++--
 fs/ceph/inode.c | 35 ++++++++++++++++++++++++-----------
 2 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index e1bb6d9c16f8..3c5450f9d825 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3929,8 +3929,8 @@ static bool handle_cap_trunc(struct inode *inode,
 	if (IS_ENCRYPTED(inode) && size)
 		size = extra_info->fscrypt_file_size;
 
-	dout("handle_cap_trunc inode %p mds%d seq %d to %lld seq %d\n",
-	     inode, mds, seq, truncate_size, truncate_seq);
+	dout("%s inode %p mds%d seq %d to %lld truncate seq %d\n",
+	     __func__, inode, mds, seq, truncate_size, truncate_seq);
 	queue_trunc = ceph_fill_file_size(inode, issued,
 					  truncate_seq, truncate_size, size);
 	return queue_trunc;
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 1cfcbc39f7c6..059ebe42367c 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -763,7 +763,7 @@ int ceph_fill_file_size(struct inode *inode, int issued,
 			ceph_fscache_update(inode);
 		ci->i_reported_size = size;
 		if (truncate_seq != ci->i_truncate_seq) {
-			dout("truncate_seq %u -> %u\n",
+			dout("%s truncate_seq %u -> %u\n", __func__,
 			     ci->i_truncate_seq, truncate_seq);
 			ci->i_truncate_seq = truncate_seq;
 
@@ -787,15 +787,26 @@ int ceph_fill_file_size(struct inode *inode, int issued,
 			}
 		}
 	}
-	if (ceph_seq_cmp(truncate_seq, ci->i_truncate_seq) >= 0 &&
-	    ci->i_truncate_size != truncate_size) {
-		dout("truncate_size %lld -> %llu\n", ci->i_truncate_size,
-		     truncate_size);
+
+	/*
+	 * It's possible that the new sizes of the two consecutive
+	 * size truncations will be in the same fscrypt last block,
+	 * and we need to truncate the corresponding page caches
+	 * anyway.
+	 */
+	if (ceph_seq_cmp(truncate_seq, ci->i_truncate_seq) >= 0) {
+		dout("%s truncate_size %lld -> %llu, encrypted %d\n", __func__,
+		     ci->i_truncate_size, truncate_size, !!IS_ENCRYPTED(inode));
+
 		ci->i_truncate_size = truncate_size;
-		if (IS_ENCRYPTED(inode))
+
+		if (IS_ENCRYPTED(inode)) {
+			dout("%s truncate_pagecache_size %lld -> %llu\n",
+			     __func__, ci->i_truncate_pagecache_size, size);
 			ci->i_truncate_pagecache_size = size;
-		else
+		} else {
 			ci->i_truncate_pagecache_size = truncate_size;
+		}
 	}
 	return queue_trunc;
 }
@@ -2150,7 +2161,7 @@ void __ceph_do_pending_vmtruncate(struct inode *inode)
 retry:
 	spin_lock(&ci->i_ceph_lock);
 	if (ci->i_truncate_pending == 0) {
-		dout("__do_pending_vmtruncate %p none pending\n", inode);
+		dout("%s %p none pending\n", __func__, inode);
 		spin_unlock(&ci->i_ceph_lock);
 		mutex_unlock(&ci->i_truncate_mutex);
 		return;
@@ -2162,8 +2173,7 @@ void __ceph_do_pending_vmtruncate(struct inode *inode)
 	 */
 	if (ci->i_wrbuffer_ref_head < ci->i_wrbuffer_ref) {
 		spin_unlock(&ci->i_ceph_lock);
-		dout("__do_pending_vmtruncate %p flushing snaps first\n",
-		     inode);
+		dout("%s %p flushing snaps first\n", __func__, inode);
 		filemap_write_and_wait_range(&inode->i_data, 0,
 					     inode->i_sb->s_maxbytes);
 		goto retry;
@@ -2174,7 +2184,7 @@ void __ceph_do_pending_vmtruncate(struct inode *inode)
 
 	to = ci->i_truncate_pagecache_size;
 	wrbuffer_refs = ci->i_wrbuffer_ref;
-	dout("__do_pending_vmtruncate %p (%d) to %lld\n", inode,
+	dout("%s %p (%d) to %lld\n", __func__, inode,
 	     ci->i_truncate_pending, to);
 	spin_unlock(&ci->i_ceph_lock);
 
@@ -2361,6 +2371,9 @@ static int fill_fscrypt_truncate(struct inode *inode,
 		header.data_len = cpu_to_le32(8 + 8 + 4 + CEPH_FSCRYPT_BLOCK_SIZE);
 		header.file_offset = cpu_to_le64(orig_pos);
 
+		dout("%s encrypt block boff/bsize %d/%lu\n", __func__,
+		     boff, CEPH_FSCRYPT_BLOCK_SIZE);
+
 		/* truncate and zero out the extra contents for the last block */
 		memset(iov.iov_base + boff, 0, PAGE_SIZE - boff);
 
-- 
2.39.1

