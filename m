Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEDDE5A1251
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 15:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242745AbiHYNcL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 09:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242732AbiHYNby (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 09:31:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140F4B5A41
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 06:31:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA3E661D0A
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 13:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B477C433D7;
        Thu, 25 Aug 2022 13:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661434308;
        bh=z2aflkalwHIpJsFf6Q9u8pNnGxfuBkdd3AKDaoFoRww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d9rvzEH+bHheSst7564zK/Rh1Z6x4vmzgzKAmceLf1CxzXV5nwylASdkx9XIajBcO
         aRjEjebiWPkHXHaGAdCJ5aZNY3fONgxRCdS4G1IRSzbZpxqaiIsudewTECz2rOrmxj
         KxzRcaoukXo/DxzIZ6H5oD7HwZ9Hw89xGLXRNqTQgnlicc4dDAAVbA/Ao+8lTRNEkc
         g0+AoGGhOq8qgf0FElTAG9hsRJcFpBOpqs3fb9lOsYD/Y1mz6bdvxB3N6eSVV4fwR6
         7M42mY9c+OLOsP5kZyH0C6RsH4lTgUgIViajLc1N7Nhe5FJRiF2CLeGUfvi0HxAa6H
         Y8KmHSOx/Abuw==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     lhenriques@suse.de, ceph-devel@vger.kernel.org
Subject: [PATCH v15 20/29] ceph: add fscrypt decryption support to ceph_netfs_issue_op
Date:   Thu, 25 Aug 2022 09:31:23 -0400
Message-Id: <20220825133132.153657-21-jlayton@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220825133132.153657-1-jlayton@kernel.org>
References: <20220825133132.153657-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Force the use of sparse reads when the inode is encrypted, and add the
appropriate code to decrypt the extent map after receiving.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 64 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 55 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 3369c54d8002..8de6b647658d 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -18,6 +18,7 @@
 #include "mds_client.h"
 #include "cache.h"
 #include "metric.h"
+#include "crypto.h"
 #include <linux/ceph/osd_client.h>
 #include <linux/ceph/striper.h>
 
@@ -216,7 +217,8 @@ static bool ceph_netfs_clamp_length(struct netfs_io_subrequest *subreq)
 
 static void finish_netfs_read(struct ceph_osd_request *req)
 {
-	struct ceph_fs_client *fsc = ceph_inode_to_client(req->r_inode);
+	struct inode *inode = req->r_inode;
+	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_osd_data *osd_data = osd_req_op_extent_osd_data(req, 0);
 	struct netfs_io_subrequest *subreq = req->r_priv;
 	struct ceph_osd_req_op *op = &req->r_ops[0];
@@ -230,16 +232,30 @@ static void finish_netfs_read(struct ceph_osd_request *req)
 	     subreq->len, i_size_read(req->r_inode));
 
 	/* no object means success but no data */
-	if (sparse && err >= 0)
-		err = ceph_sparse_ext_map_end(op);
-	else if (err == -ENOENT)
+	if (err == -ENOENT)
 		err = 0;
 	else if (err == -EBLOCKLISTED)
 		fsc->blocklisted = true;
 
-	if (err >= 0 && err < subreq->len)
-		__set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
+	if (err >= 0) {
+		if (sparse && err > 0)
+			err = ceph_sparse_ext_map_end(op);
+		if (err < subreq->len)
+			__set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
+		if (IS_ENCRYPTED(inode) && err > 0) {
+			err = ceph_fscrypt_decrypt_extents(inode, osd_data->pages,
+					subreq->start, op->extent.sparse_ext,
+					op->extent.sparse_ext_cnt);
+			if (err > subreq->len)
+				err = subreq->len;
+		}
+	}
 
+	if (osd_data->type == CEPH_OSD_DATA_TYPE_PAGES) {
+		ceph_put_page_vector(osd_data->pages,
+				     calc_pages_for(osd_data->alignment,
+					osd_data->length), false);
+	}
 	netfs_subreq_terminated(subreq, err, false);
 	iput(req->r_inode);
 }
@@ -310,12 +326,15 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	struct iov_iter iter;
 	int err = 0;
 	u64 len = subreq->len;
-	bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
+	bool sparse = IS_ENCRYPTED(inode) || ceph_test_mount_opt(fsc, SPARSEREAD);
+	u64 off = subreq->start;
 
 	if (ceph_has_inline_data(ci) && ceph_netfs_issue_op_inline(subreq))
 		return;
 
-	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout, vino, subreq->start, &len,
+	ceph_fscrypt_adjust_off_and_len(inode, &off, &len);
+
+	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout, vino, off, &len,
 			0, 1, sparse ? CEPH_OSD_OP_SPARSE_READ : CEPH_OSD_OP_READ,
 			CEPH_OSD_FLAG_READ | fsc->client->osdc.client->options->read_from_replica,
 			NULL, ci->i_truncate_seq, ci->i_truncate_size, false);
@@ -334,8 +353,35 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	}
 
 	dout("%s: pos=%llu orig_len=%zu len=%llu\n", __func__, subreq->start, subreq->len, len);
+
 	iov_iter_xarray(&iter, READ, &rreq->mapping->i_pages, subreq->start, len);
-	osd_req_op_extent_osd_iter(req, 0, &iter);
+
+	/*
+	 * FIXME: For now, use CEPH_OSD_DATA_TYPE_PAGES instead of _ITER for
+	 * encrypted inodes. We'd need infrastructure that handles an iov_iter
+	 * instead of page arrays, and we don't have that as of yet. Once the
+	 * dust settles on the write helpers and encrypt/decrypt routines for
+	 * netfs, we should be able to rework this.
+	 */
+	if (IS_ENCRYPTED(inode)) {
+		struct page **pages;
+		size_t page_off;
+
+		err = iov_iter_get_pages_alloc2(&iter, &pages, len, &page_off);
+		if (err < 0) {
+			dout("%s: iov_ter_get_pages_alloc returned %d\n", __func__, err);
+			goto out;
+		}
+
+		/* should always give us a page-aligned read */
+		WARN_ON_ONCE(page_off);
+		len = err;
+		err = 0;
+
+		osd_req_op_extent_osd_data_pages(req, 0, pages, len, 0, false, false);
+	} else {
+		osd_req_op_extent_osd_iter(req, 0, &iter);
+	}
 	req->r_callback = finish_netfs_read;
 	req->r_priv = subreq;
 	req->r_inode = inode;
-- 
2.37.2

