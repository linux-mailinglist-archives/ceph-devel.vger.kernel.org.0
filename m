Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1BC46E3E36
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Apr 2023 05:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbjDQDfJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Apr 2023 23:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbjDQDeZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 16 Apr 2023 23:34:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBD4527F
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 20:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681702312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UE4dvaqGkt4/8fZLJRQXuG6KWRVhRi86Nub7dhkgckg=;
        b=T7OWY8IAoFoPrHK+lUXhliOj/oF2pnxdZIRu6gZQz3fSsh7VDh9eKB9L+6D2DcyDTY1xEP
        kYfzFZMsOsGPsDUuHX8tBq7mOrZbRPiMQqFbb1+p/2KlC9GVHZwVpADqoYKLD31PB1lGci
        19TpfMRRBRylImjiogrSGJeJp282zsc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-0kVO9ecQOji7N-_K8qvoTw-1; Sun, 16 Apr 2023 23:31:51 -0400
X-MC-Unique: 0kVO9ecQOji7N-_K8qvoTw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C40E41C09048;
        Mon, 17 Apr 2023 03:31:50 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9EC6F2027EAC;
        Mon, 17 Apr 2023 03:31:46 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, lhenriques@suse.de,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v19 54/70] ceph: align data in pages in ceph_sync_write
Date:   Mon, 17 Apr 2023 11:26:38 +0800
Message-Id: <20230417032654.32352-55-xiubli@redhat.com>
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

From: Jeff Layton <jlayton@kernel.org>

Encrypted files will need to be dealt with in block-sized chunks and
once we do that, the way that ceph_sync_write aligns the data in the
bounce buffer won't be acceptable.

Change it to align the data the same way it would be aligned in the
pagecache.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 70c9b9d7dc33..c9d83e87e58a 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1579,6 +1579,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 	bool check_caps = false;
 	struct timespec64 mtime = current_time(inode);
 	size_t count = iov_iter_count(from);
+	size_t off;
 
 	if (ceph_snap(file_inode(file)) != CEPH_NOSNAP)
 		return -EROFS;
@@ -1616,12 +1617,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
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
@@ -1629,9 +1625,12 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
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
@@ -1646,8 +1645,9 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 
 		req->r_inode = inode;
 
-		osd_req_op_extent_osd_data_pages(req, 0, pages, len, 0,
-						false, true);
+		osd_req_op_extent_osd_data_pages(req, 0, pages, len,
+						 offset_in_page(pos),
+						 false, true);
 
 		req->r_mtime = mtime;
 		ceph_osdc_start_request(&fsc->client->osdc, req);
-- 
2.39.1

