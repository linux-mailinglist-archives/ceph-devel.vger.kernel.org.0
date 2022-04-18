Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA65505762
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Apr 2022 15:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244409AbiDRNyq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Apr 2022 09:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245340AbiDRNxZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Apr 2022 09:53:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5442F6546
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 06:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650286957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XfPAY5+QlEq5KjCj2jnoPqy/L7oyMV9114NbM6SBWWg=;
        b=gnrzxHL5UPu4Fa5dEguKfcFKMSZ4/DPop41dcMkdHOYXN911KFKacK77lvIza3y6juK2Mw
        w0GiCOVQXrlh9nIFI/lPtFTtEY1f3IPcg09zOWkajq7Kox5O+8zkc2iJvO8EGGF3fs16/p
        +esesQPUZ+eXzP2rOHx6X8P9Ygi2kw0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-nxnwqTrROQizUeY-ok4ndA-1; Mon, 18 Apr 2022 09:02:34 -0400
X-MC-Unique: nxnwqTrROQizUeY-ok4ndA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29FCD803B22;
        Mon, 18 Apr 2022 13:02:34 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80D8840FD370;
        Mon, 18 Apr 2022 13:02:33 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 1/2] ceph: rename unsafe_request_wait()
Date:   Mon, 18 Apr 2022 21:02:17 +0800
Message-Id: <20220418130218.738980-2-xiubli@redhat.com>
In-Reply-To: <20220418130218.738980-1-xiubli@redhat.com>
References: <20220418130218.738980-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Rename it to flush_mdlog_and_wait_inode_unsafe_requests() to make
it more descriptive.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 69af17df59be..f16f6274b150 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2277,9 +2277,9 @@ static int caps_are_flushed(struct inode *inode, u64 flush_tid)
 }
 
 /*
- * wait for any unsafe requests to complete.
+ * flush the mdlog and wait for any unsafe requests to complete.
  */
-static int unsafe_request_wait(struct inode *inode)
+static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
 {
 	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
 	struct ceph_inode_info *ci = ceph_inode(inode);
@@ -2391,7 +2391,7 @@ static int unsafe_request_wait(struct inode *inode)
 		kfree(sessions);
 	}
 
-	dout("unsafe_request_wait %p wait on tid %llu %llu\n",
+	dout("%s %p wait on tid %llu %llu\n", __func__,
 	     inode, req1 ? req1->r_tid : 0ULL, req2 ? req2->r_tid : 0ULL);
 	if (req1) {
 		ret = !wait_for_completion_timeout(&req1->r_safe_completion,
@@ -2435,7 +2435,7 @@ int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	dirty = try_flush_caps(inode, &flush_tid);
 	dout("fsync dirty caps are %s\n", ceph_cap_string(dirty));
 
-	err = unsafe_request_wait(inode);
+	err = flush_mdlog_and_wait_inode_unsafe_requests(inode);
 
 	/*
 	 * only wait on non-file metadata writeback (the mds
-- 
2.36.0.rc1

