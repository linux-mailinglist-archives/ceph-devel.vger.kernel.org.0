Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49CDC51226E
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbiD0TU4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbiD0TTi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CD754BCB
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B017B8294F
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4839C385A9;
        Wed, 27 Apr 2022 19:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086836;
        bh=fxw7rBOvGLOYMtMJ+hDc9AJ5VYh5vxtrf7kGlvoN384=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUyfeABg8SsxiqYvk4cR0FfHUrFgUEN/VRuaTfa7VGjas4lmDn6fi9KeFt3+XmFsT
         lbf7/MNrUYD1QUQnR71tYzEYNIMGE1S1axOswEepoEdEfkII0EQgOxT4sCMr5d8OMm
         1PSRP7MXBzuEefB/itYHLnlzK1pMkAJd8UOsTRhu/h34klA2/vpFTbsx7z9fSI4Lpk
         q5Q0DD4Yiz8xF38h+oeK3U/oDOOUWlONkE1KxJtEI8jOjyyk4GxbQBLjdBw//Brfhl
         YAOi//rnxwe6aSDOAtETx2RiK2XizC1EDJHhT6TEYWDJ0xOP3BV5qES+N1k9vlpKBX
         07PR/I5yl2Lrw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 56/64] ceph: add fscrypt decryption support to ceph_netfs_issue_op
Date:   Wed, 27 Apr 2022 15:13:06 -0400
Message-Id: <20220427191314.222867-57-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427191314.222867-1-jlayton@kernel.org>
References: <20220427191314.222867-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Force the use of sparse reads when the inode is encrypted, and add the
appropriate code to decrypt the extent map after receiving.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 84d0b52010d9..d65d431ec933 100644
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
@@ -231,15 +233,24 @@ static void finish_netfs_read(struct ceph_osd_request *req)
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
 
 	netfs_subreq_terminated(subreq, err, true);
 
@@ -316,13 +327,16 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	size_t page_off;
 	int err = 0;
 	u64 len = subreq->len;
-	bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
+	bool sparse = IS_ENCRYPTED(inode) || ceph_test_mount_opt(fsc, SPARSEREAD);
+	u64 off = subreq->start;
 
 	if (ci->i_inline_version != CEPH_INLINE_NONE &&
 	    ceph_netfs_issue_op_inline(subreq))
 		return;
 
-	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout, vino, subreq->start, &len,
+	ceph_fscrypt_adjust_off_and_len(inode, &off, &len);
+
+	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout, vino, off, &len,
 			0, 1, sparse ? CEPH_OSD_OP_SPARSE_READ : CEPH_OSD_OP_READ,
 			CEPH_OSD_FLAG_READ | fsc->client->osdc.client->options->read_from_replica,
 			NULL, ci->i_truncate_seq, ci->i_truncate_size, false);
@@ -341,7 +355,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	}
 
 	dout("%s: pos=%llu orig_len=%zu len=%llu\n", __func__, subreq->start, subreq->len, len);
-	iov_iter_xarray(&iter, READ, &rreq->mapping->i_pages, subreq->start, len);
+	iov_iter_xarray(&iter, READ, &rreq->mapping->i_pages, off, len);
 	err = iov_iter_get_pages_alloc(&iter, &pages, len, &page_off);
 	if (err < 0) {
 		dout("%s: iov_ter_get_pages_alloc returned %d\n", __func__, err);
-- 
2.35.1

