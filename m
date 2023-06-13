Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F9C72D94C
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 07:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240222AbjFMFef (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 01:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240131AbjFMFd7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 01:33:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5968C1FFC
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 22:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686634256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wvd5lz/Np0NWee/Rc/o4iPx7ITdWXARMr+Jmu5JyuYM=;
        b=cWAEk2EUVhOiFyreU/xY8XUeyHs0YoPvZ/S9+dRp4xelwsMg/hn93OtAVmcYYORMXRlWxu
        spr/eGGDDmeA8QweyEx7PnL6k6gHSPEY7Xr8icEkLmam4deJ6K7z7Qim4IhemJcp9/BCS7
        EHJsMw3eZpHpP2N+k4+q3n0WI2xpAvc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-WuXdPhvcOFGmE4jkhTCHKA-1; Tue, 13 Jun 2023 01:30:52 -0400
X-MC-Unique: WuXdPhvcOFGmE4jkhTCHKA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FC0D185A791;
        Tue, 13 Jun 2023 05:30:51 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-155.pek2.redhat.com [10.72.12.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 075C11121314;
        Tue, 13 Jun 2023 05:30:47 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v20 57/71] ceph: add fscrypt decryption support to ceph_netfs_issue_op
Date:   Tue, 13 Jun 2023 13:24:10 +0800
Message-Id: <20230613052424.254540-58-xiubli@redhat.com>
In-Reply-To: <20230613052424.254540-1-xiubli@redhat.com>
References: <20230613052424.254540-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

Force the use of sparse reads when the inode is encrypted, and add the
appropriate code to decrypt the extent map after receiving.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 64 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 55 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 3c80afa9d0e8..cd79ba8906a3 100644
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
@@ -310,7 +326,8 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	struct iov_iter iter;
 	int err = 0;
 	u64 len = subreq->len;
-	bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
+	bool sparse = IS_ENCRYPTED(inode) || ceph_test_mount_opt(fsc, SPARSEREAD);
+	u64 off = subreq->start;
 
 	if (ceph_inode_is_shutdown(inode)) {
 		err = -EIO;
@@ -320,7 +337,9 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	if (ceph_has_inline_data(ci) && ceph_netfs_issue_op_inline(subreq))
 		return;
 
-	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout, vino, subreq->start, &len,
+	ceph_fscrypt_adjust_off_and_len(inode, &off, &len);
+
+	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout, vino, off, &len,
 			0, 1, sparse ? CEPH_OSD_OP_SPARSE_READ : CEPH_OSD_OP_READ,
 			CEPH_OSD_FLAG_READ | fsc->client->osdc.client->options->read_from_replica,
 			NULL, ci->i_truncate_seq, ci->i_truncate_size, false);
@@ -337,8 +356,35 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	}
 
 	dout("%s: pos=%llu orig_len=%zu len=%llu\n", __func__, subreq->start, subreq->len, len);
+
 	iov_iter_xarray(&iter, ITER_DEST, &rreq->mapping->i_pages, subreq->start, len);
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
2.40.1

