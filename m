Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F42D53F54B
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jun 2022 06:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236546AbiFGEzN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jun 2022 00:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiFGEzL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jun 2022 00:55:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 835A2D4103
        for <ceph-devel@vger.kernel.org>; Mon,  6 Jun 2022 21:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654577709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JJiGb1dZ7QAU9fFZYIH64Cw6eGjEIbU+yOmAU19NeuE=;
        b=BfmmxQg7FpfJA/ewrxAH74pGCDid4gsijsQpqWowjQgw9wMgb/7huNNMfFitVAM4mMjsYy
        cIDf8N5yJiRAB2UCwK7zvtliDXndNC20w47FtnG62UHtWuJprJO2wfgpYUzAfk6bP5QeEx
        2UeszR01u6DfVtcrLOLL5rIkxM5t9Qo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-GML11etdOQerji_r4vMlog-1; Tue, 07 Jun 2022 00:55:05 -0400
X-MC-Unique: GML11etdOQerji_r4vMlog-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DD62101AA46;
        Tue,  7 Jun 2022 04:55:05 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BF3B1121314;
        Tue,  7 Jun 2022 04:55:04 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     lhenriques@suse.de, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: don't get the inline data for new creating files
Date:   Tue,  7 Jun 2022 12:54:53 +0800
Message-Id: <20220607045454.71246-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If the 'i_inline_version' is 1, that means the file is just new
created and there shouldn't have any inline data in it, we should
skip retrieving the inline data from MDS.

This also could help reduce possiblity of dead lock issue introduce
by the inline data and Fcr caps.

Gradually we will remove the inline feature from kclient after ceph's
scrub too have support to unline the inline data, currently this
could help reduce the teuthology test failures.

This is possiblly could also fix a bug that for some old clients if
they couldn't explictly uninline the inline data when writing, the
inline version will keep as 1 always. We may always reading non-exist
data from inline data.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c  | 5 ++---
 fs/ceph/caps.c  | 2 +-
 fs/ceph/file.c  | 5 ++---
 fs/ceph/inode.c | 5 +++--
 fs/ceph/super.h | 8 ++++++++
 5 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 40830cb9b599..dc975d64f1f4 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -318,8 +318,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	u64 len = subreq->len;
 	bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
 
-	if (ci->i_inline_version != CEPH_INLINE_NONE &&
-	    ceph_netfs_issue_op_inline(subreq))
+	if (ceph_has_inline_data(ci) && ceph_netfs_issue_op_inline(subreq))
 		return;
 
 	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout, vino, subreq->start, &len,
@@ -1451,7 +1450,7 @@ static vm_fault_t ceph_filemap_fault(struct vm_fault *vmf)
 	     inode, off, ceph_cap_string(got));
 
 	if ((got & (CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_LAZYIO)) ||
-	    ci->i_inline_version == CEPH_INLINE_NONE) {
+	    !ceph_has_inline_data(ci)) {
 		CEPH_DEFINE_RW_CONTEXT(rw_ctx, got);
 		ceph_add_rw_context(fi, &rw_ctx);
 		ret = filemap_fault(vmf);
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 0a48bf829671..4a2628799e99 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3006,7 +3006,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
 		}
 
 		if (S_ISREG(ci->vfs_inode.i_mode) &&
-		    ci->i_inline_version != CEPH_INLINE_NONE &&
+		    ceph_has_inline_data(ci) &&
 		    (_got & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) &&
 		    i_size_read(inode) > 0) {
 			struct page *page =
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 0c13a3f23c99..252c3c248cd7 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -241,8 +241,7 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
 	INIT_LIST_HEAD(&fi->rw_contexts);
 	fi->filp_gen = READ_ONCE(ceph_inode_to_client(inode)->filp_gen);
 
-	if ((file->f_mode & FMODE_WRITE) &&
-	    ci->i_inline_version != CEPH_INLINE_NONE) {
+	if ((file->f_mode & FMODE_WRITE) && ceph_has_inline_data(ci)) {
 		ret = ceph_uninline_data(file);
 		if (ret < 0)
 			goto error;
@@ -1686,7 +1685,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		     inode, ceph_vinop(inode), iocb->ki_pos, (unsigned)len,
 		     ceph_cap_string(got));
 
-		if (ci->i_inline_version == CEPH_INLINE_NONE) {
+		if (!ceph_has_inline_data(ci)) {
 			if (!retry_op && (iocb->ki_flags & IOCB_DIRECT)) {
 				ret = ceph_direct_read_write(iocb, to,
 							     NULL, NULL);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 66bfdced26b3..5c84b7f15dc7 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1118,7 +1118,7 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 	    iinfo->inline_version >= ci->i_inline_version) {
 		int cache_caps = CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_LAZYIO;
 		ci->i_inline_version = iinfo->inline_version;
-		if (ci->i_inline_version != CEPH_INLINE_NONE &&
+		if (ceph_has_inline_data(ci) &&
 		    (locked_page || (info_caps & cache_caps)))
 			fill_inline = true;
 	}
@@ -2396,7 +2396,8 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
 		if (inline_version == 0) {
 			/* the reply is supposed to contain inline data */
 			err = -EINVAL;
-		} else if (inline_version == CEPH_INLINE_NONE) {
+		} else if (inline_version == CEPH_INLINE_NONE ||
+			   inline_version == 1) {
 			err = -ENODATA;
 		} else {
 			err = req->r_reply_info.targeti.inline_len;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index c5e8665d0586..a25465b56687 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1239,6 +1239,14 @@ extern int ceph_pool_perm_check(struct inode *inode, int need);
 extern void ceph_pool_perm_destroy(struct ceph_mds_client* mdsc);
 int ceph_purge_inode_cap(struct inode *inode, struct ceph_cap *cap, bool *invalidate);
 
+static inline bool ceph_has_inline_data(struct ceph_inode_info *ci)
+{
+	if (ci->i_inline_version == CEPH_INLINE_NONE ||
+	    ci->i_inline_version == 1) /* initial version, no data */
+		return false;
+	return true;
+}
+
 /* file.c */
 extern const struct file_operations ceph_file_fops;
 
-- 
2.36.0.rc1

