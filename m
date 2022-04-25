Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEDF450DF98
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Apr 2022 13:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236419AbiDYMBq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Apr 2022 08:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239639AbiDYMBm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Apr 2022 08:01:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0EE3C2ADA
        for <ceph-devel@vger.kernel.org>; Mon, 25 Apr 2022 04:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650887917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Njj9KS5g5zsLxn4MmuLCVHIaOCw34PXThsh9mk/l4bU=;
        b=e1R8aUJ0fdI7qf9scVq+/EuPAT0CRsz2CuDnLGN4Xwp/NzAUTi/Qnv+xpmbQoMJFlN4HPx
        SzJ3nRhhrR7S8/dQksJkPek85YpKJLdM88RnxLRB17KOuF6abNlMLkZWCeC20yCEdHCDGY
        cFzho6RiiuZoxLS1wVUi++JXEtkCodY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-iiM4nv41PSyh6wuzE6UNrA-1; Mon, 25 Apr 2022 07:58:33 -0400
X-MC-Unique: iiM4nv41PSyh6wuzE6UNrA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F7A3811E7A;
        Mon, 25 Apr 2022 11:58:33 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E58572166B2F;
        Mon, 25 Apr 2022 11:58:32 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fix possible deadlock when holding Fwb to get inline_data
Date:   Mon, 25 Apr 2022 19:58:28 +0800
Message-Id: <20220425115828.6966-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

1, mount with wsync.
2, create a file with O_RDWR, and the request was sent to mds.0:

   ceph_atomic_open()-->
     ceph_mdsc_do_request(openc)
     finish_open(file, dentry, ceph_open)-->
       ceph_open()-->
         ceph_init_file()-->
           ceph_init_file_info()-->
             ceph_uninline_data()-->
             {
               ...
               if (inline_version == 1 || /* initial version, no data */
                   inline_version == CEPH_INLINE_NONE)
                     goto out_unlock;
               ...
             }

The inline_version will be 1, which is the initial version for the
new create file. And here the ci->i_inline_version will keep with 1,
it's buggy.

3, buffer write to the file immediately:

   ceph_write_iter()-->
     ceph_get_caps(file, need=Fw, want=Fb, ...);
     generic_perform_write()-->
       a_ops->write_begin()-->
         ceph_write_begin()-->
           netfs_write_begin()-->
             netfs_begin_read()-->
               netfs_rreq_submit_slice()-->
                 netfs_read_from_server()-->
                   rreq->netfs_ops->issue_read()-->
                     ceph_netfs_issue_read()-->
                     {
                       ...
                       if (ci->i_inline_version != CEPH_INLINE_NONE &&
                           ceph_netfs_issue_op_inline(subreq))
                         return;
                       ...
                     }
     ceph_put_cap_refs(ci, Fwb);

The ceph_netfs_issue_op_inline() will send a getattr(Fsr) request to
mds.1.

4, then the mds.1 will request the rd lock for CInode::filelock from
the auth mds.0, the mds.0 will do the CInode::filelock state transation
from excl --> sync, but it need to revoke the Fxwb caps back from the
clients.

While the kernel client has aleady held the Fwb caps and waiting for
the getattr(Fsr).

It's deadlock!!!!

URL: https://tracker.ceph.com/issues/55377
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 02722ac86d73..15e7b48cbc95 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1641,7 +1641,7 @@ int ceph_uninline_data(struct file *file)
 	struct inode *inode = file_inode(file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
-	struct ceph_osd_request *req;
+	struct ceph_osd_request *req = NULL;
 	struct ceph_cap_flush *prealloc_cf;
 	struct folio *folio = NULL;
 	u64 inline_version = CEPH_INLINE_NONE;
@@ -1649,10 +1649,23 @@ int ceph_uninline_data(struct file *file)
 	int err = 0;
 	u64 len;
 
+	spin_lock(&ci->i_ceph_lock);
+	inline_version = ci->i_inline_version;
+	spin_unlock(&ci->i_ceph_lock);
+
+	dout("uninline_data %p %llx.%llx inline_version %llu\n",
+	     inode, ceph_vinop(inode), inline_version);
+
+	if (inline_version == CEPH_INLINE_NONE)
+		return 0;
+
 	prealloc_cf = ceph_alloc_cap_flush();
 	if (!prealloc_cf)
 		return -ENOMEM;
 
+	if (inline_version == 1) /* initial version, no data */
+		goto out_uninline;
+
 	folio = read_mapping_folio(inode->i_mapping, 0, file);
 	if (IS_ERR(folio)) {
 		err = PTR_ERR(folio);
@@ -1661,17 +1674,6 @@ int ceph_uninline_data(struct file *file)
 
 	folio_lock(folio);
 
-	spin_lock(&ci->i_ceph_lock);
-	inline_version = ci->i_inline_version;
-	spin_unlock(&ci->i_ceph_lock);
-
-	dout("uninline_data %p %llx.%llx inline_version %llu\n",
-	     inode, ceph_vinop(inode), inline_version);
-
-	if (inline_version == 1 || /* initial version, no data */
-	    inline_version == CEPH_INLINE_NONE)
-		goto out_unlock;
-
 	len = i_size_read(inode);
 	if (len > folio_size(folio))
 		len = folio_size(folio);
@@ -1736,6 +1738,7 @@ int ceph_uninline_data(struct file *file)
 	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
 				  req->r_end_latency, len, err);
 
+out_uninline:
 	if (!err) {
 		int dirty;
 
@@ -1754,8 +1757,10 @@ int ceph_uninline_data(struct file *file)
 	if (err == -ECANCELED)
 		err = 0;
 out_unlock:
-	folio_unlock(folio);
-	folio_put(folio);
+	if (folio) {
+		folio_unlock(folio);
+		folio_put(folio);
+	}
 out:
 	ceph_free_cap_flush(prealloc_cf);
 	dout("uninline_data %p %llx.%llx inline_version %llu = %d\n",
-- 
2.36.0.rc1

