Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B315E6AD8C4
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Mar 2023 09:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjCGIJC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Mar 2023 03:09:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjCGIIs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Mar 2023 03:08:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F17989F16
        for <ceph-devel@vger.kernel.org>; Tue,  7 Mar 2023 00:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678176448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/kwxEy9aVtTXMKLFhcO5Fkmd7yonjVa7wqIeVyn4NZk=;
        b=aFPLXx7QV45bIFbP6T+cjOLrWtrGlvuiyhQdt1wxk1snOaxaZplwW9n8UZfCgSq5H2Mhyg
        0LwNhY1gYX7PWSaqIhbNsy5QpKHqayS7Qs41RLR5mOEFJ/f96tI8JUivf6+kXgVCfZJ8gp
        dDQIFQc7jI42o7WiaQbIjbmL5OJFM+o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467-kK63j-H9MeurbGIVsguPDw-1; Tue, 07 Mar 2023 03:07:25 -0500
X-MC-Unique: kK63j-H9MeurbGIVsguPDw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF985887405;
        Tue,  7 Mar 2023 08:07:24 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10E9618EC6;
        Tue,  7 Mar 2023 08:07:21 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, lhenriques@suse.de, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fix updating the i_truncate_pagecache_size for fscrypt
Date:   Tue,  7 Mar 2023 16:07:14 +0800
Message-Id: <20230307080714.122306-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

This is for fscrypt feature and based on the testing branch.


 fs/ceph/caps.c  |  4 ++--
 fs/ceph/inode.c | 35 ++++++++++++++++++++++++-----------
 2 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 4a17ee6942ac..07b29b72ac39 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3928,8 +3928,8 @@ static bool handle_cap_trunc(struct inode *inode,
 	if (IS_ENCRYPTED(inode) && size)
 		size = extra_info->fscrypt_file_size;
 
-	dout("handle_cap_trunc inode %p mds%d seq %d to %lld seq %d\n",
-	     inode, mds, seq, truncate_size, truncate_seq);
+	dout("%s inode %p mds%d seq %d to %lld truncate seq %d\n",
+	     __func__, inode, mds, seq, truncate_size, truncate_seq);
 	queue_trunc = ceph_fill_file_size(inode, issued,
 					  truncate_seq, truncate_size,
 					  size, 0);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index b9a3ff7ecbcb..dfa69bc346bf 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -765,7 +765,7 @@ int ceph_fill_file_size(struct inode *inode, int issued,
 			ceph_fscache_update(inode);
 		ci->i_reported_size = size;
 		if (truncate_seq != ci->i_truncate_seq) {
-			dout("truncate_seq %u -> %u\n",
+			dout("%s truncate_seq %u -> %u\n", __func__,
 			     ci->i_truncate_seq, truncate_seq);
 			ci->i_truncate_seq = truncate_seq;
 
@@ -799,15 +799,26 @@ int ceph_fill_file_size(struct inode *inode, int issued,
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
@@ -2162,7 +2173,7 @@ void __ceph_do_pending_vmtruncate(struct inode *inode)
 retry:
 	spin_lock(&ci->i_ceph_lock);
 	if (ci->i_truncate_pending == 0) {
-		dout("__do_pending_vmtruncate %p none pending\n", inode);
+		dout("%s %p none pending\n", __func__, inode);
 		spin_unlock(&ci->i_ceph_lock);
 		mutex_unlock(&ci->i_truncate_mutex);
 		return;
@@ -2174,8 +2185,7 @@ void __ceph_do_pending_vmtruncate(struct inode *inode)
 	 */
 	if (ci->i_wrbuffer_ref_head < ci->i_wrbuffer_ref) {
 		spin_unlock(&ci->i_ceph_lock);
-		dout("__do_pending_vmtruncate %p flushing snaps first\n",
-		     inode);
+		dout("%s %p flushing snaps first\n", __func__, inode);
 		filemap_write_and_wait_range(&inode->i_data, 0,
 					     inode->i_sb->s_maxbytes);
 		goto retry;
@@ -2186,7 +2196,7 @@ void __ceph_do_pending_vmtruncate(struct inode *inode)
 
 	to = ci->i_truncate_pagecache_size;
 	wrbuffer_refs = ci->i_wrbuffer_ref;
-	dout("__do_pending_vmtruncate %p (%d) to %lld\n", inode,
+	dout("%s %p (%d) to %lld\n", __func__, inode,
 	     ci->i_truncate_pending, to);
 	spin_unlock(&ci->i_ceph_lock);
 
@@ -2373,6 +2383,9 @@ static int fill_fscrypt_truncate(struct inode *inode,
 		header.data_len = cpu_to_le32(8 + 8 + 4 + CEPH_FSCRYPT_BLOCK_SIZE);
 		header.file_offset = cpu_to_le64(orig_pos);
 
+		dout("%s encrypt block boff/bsize %d/%lu\n", __func__,
+		     boff, CEPH_FSCRYPT_BLOCK_SIZE);
+
 		/* truncate and zero out the extra contents for the last block */
 		memset(iov.iov_base + boff, 0, PAGE_SIZE - boff);
 
-- 
2.31.1

