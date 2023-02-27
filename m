Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4356A39B3
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 04:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbjB0Ddc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Feb 2023 22:33:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbjB0Ddb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Feb 2023 22:33:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7701D931
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 19:32:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677468692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HyCD9YOEggO9v6XGVQ43+YUlcRWgkOah+tBRE2e3lP4=;
        b=iIN+4552KFeZEZPo0fLq7tULqAGFys+AJ9y8fM9ZBJoGoyW6wCUPSgpxDFAQW/60nh6TT4
        LReyhNLZ2p86y/cSTg6EqI+y5u6BF3dYiWhH3F9kKTS7/gUmYlG5vDOBQLXNclEyYcMRYz
        KPTyvt0/LRnSOQJl3LYrNY+sCykkZ8s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-OexOF-NLM-issdqkm0xYAg-1; Sun, 26 Feb 2023 22:31:29 -0500
X-MC-Unique: OexOF-NLM-issdqkm0xYAg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9415029AA38B;
        Mon, 27 Feb 2023 03:31:28 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C26971731B;
        Mon, 27 Feb 2023 03:31:25 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, lhenriques@suse.de, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v16 54/68] ceph: align data in pages in ceph_sync_write
Date:   Mon, 27 Feb 2023 11:27:59 +0800
Message-Id: <20230227032813.337906-55-xiubli@redhat.com>
In-Reply-To: <20230227032813.337906-1-xiubli@redhat.com>
References: <20230227032813.337906-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

Encrypted files will need to be dealt with in block-sized chunks and
once we do that, the way that ceph_sync_write aligns the data in the
bounce buffer won't be acceptable.

Change it to align the data the same way it would be aligned in the
pagecache.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 830d22d80662..cc46aa9b8090 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1583,6 +1583,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 	bool check_caps = false;
 	struct timespec64 mtime = current_time(inode);
 	size_t count = iov_iter_count(from);
+	size_t off;
 
 	if (ceph_snap(file_inode(file)) != CEPH_NOSNAP)
 		return -EROFS;
@@ -1620,12 +1621,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 			break;
 		}
 
-		/*
-		 * write from beginning of first page,
-		 * regardless of io alignment
-		 */
-		num_pages = (len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-
+		num_pages = calc_pages_for(pos, len);
 		pages = ceph_alloc_page_vector(num_pages, GFP_KERNEL);
 		if (IS_ERR(pages)) {
 			ret = PTR_ERR(pages);
@@ -1633,9 +1629,12 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 		}
 
 		left = len;
+		off = offset_in_page(pos);
 		for (n = 0; n < num_pages; n++) {
-			size_t plen = min_t(size_t, left, PAGE_SIZE);
-			ret = copy_page_from_iter(pages[n], 0, plen, from);
+			size_t plen = min_t(size_t, left, PAGE_SIZE - off);
+
+			ret = copy_page_from_iter(pages[n], off, plen, from);
+			off = 0;
 			if (ret != plen) {
 				ret = -EFAULT;
 				break;
@@ -1650,8 +1649,9 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 
 		req->r_inode = inode;
 
-		osd_req_op_extent_osd_data_pages(req, 0, pages, len, 0,
-						false, true);
+		osd_req_op_extent_osd_data_pages(req, 0, pages, len,
+						 offset_in_page(pos),
+						 false, true);
 
 		req->r_mtime = mtime;
 		ceph_osdc_start_request(&fsc->client->osdc, req);
-- 
2.31.1

