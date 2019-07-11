Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE70E65F92
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Jul 2019 20:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730245AbfGKSln (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 11 Jul 2019 14:41:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730233AbfGKSlm (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 11 Jul 2019 14:41:42 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28F2820872;
        Thu, 11 Jul 2019 18:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562870501;
        bh=1IQ8CRZGrUEIL+er6bqz+G7m7Y5M9tSjzZf1rEd17UQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tCBvl4qMck41XUS90jr6lESE57mJqR0HV1Xmt6MIdUhSylOc2RrJdoYWukNqUqVkT
         tHUZYldJxxsXv1iaE6OO/Z3cTi6j6U3QaIy614oUYxGTu/3MQu5+C+PuKPL+xfsStg
         l1TRGRwn3YcXlqWvIM7RdyJBwHgd+/T0pe0Y8SFs=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, idryomov@gmail.com, sage@redhat.com,
        lhenriques@suse.com
Subject: [PATCH v2 2/5] ceph: pass unlocked page to ceph_uninline_data
Date:   Thu, 11 Jul 2019 14:41:33 -0400
Message-Id: <20190711184136.19779-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190711184136.19779-1-jlayton@kernel.org>
References: <20190711184136.19779-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The only caller locks the page and then has to unlock it again once it
returns. Just have ceph_uninline_data do that itself. Also, in the case
where we are allocating a local page for this, lock it to help simplify
the code a bit.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c  | 27 ++++++++++++---------------
 fs/ceph/super.h |  2 +-
 2 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 859d2cbfeccb..038678963cf9 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1542,14 +1542,7 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 	ceph_block_sigs(&oldset);
 
 	if (ci->i_inline_version != CEPH_INLINE_NONE) {
-		struct page *locked_page = NULL;
-		if (off == 0) {
-			lock_page(page);
-			locked_page = page;
-		}
-		err = ceph_uninline_data(inode, locked_page);
-		if (locked_page)
-			unlock_page(locked_page);
+		err = ceph_uninline_data(inode, off == 0 ? page : NULL);
 		if (err < 0)
 			goto out_free;
 	}
@@ -1663,7 +1656,7 @@ void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
 	}
 }
 
-int ceph_uninline_data(struct inode *inode, struct page *locked_page)
+int ceph_uninline_data(struct inode *inode, struct page *provided_page)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
@@ -1672,6 +1665,7 @@ int ceph_uninline_data(struct inode *inode, struct page *locked_page)
 	u64 len, inline_version;
 	int err = 0;
 	bool from_pagecache = false;
+	bool allocated_page = false;
 
 	spin_lock(&ci->i_ceph_lock);
 	inline_version = ci->i_inline_version;
@@ -1684,8 +1678,9 @@ int ceph_uninline_data(struct inode *inode, struct page *locked_page)
 	    inline_version == CEPH_INLINE_NONE)
 		goto out;
 
-	if (locked_page) {
-		page = locked_page;
+	if (provided_page) {
+		page = provided_page;
+		lock_page(page);
 		WARN_ON(!PageUptodate(page));
 	} else if (ceph_caps_issued(ci) &
 		   (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) {
@@ -1711,6 +1706,8 @@ int ceph_uninline_data(struct inode *inode, struct page *locked_page)
 			err = -ENOMEM;
 			goto out;
 		}
+		allocated_page = true;
+		lock_page(page);
 		err = __ceph_do_getattr(inode, page,
 					CEPH_STAT_CAP_INLINE_DATA, true);
 		if (err < 0) {
@@ -1782,11 +1779,11 @@ int ceph_uninline_data(struct inode *inode, struct page *locked_page)
 	if (err == -ECANCELED)
 		err = 0;
 out:
-	if (page && page != locked_page) {
-		if (from_pagecache) {
-			unlock_page(page);
+	if (page) {
+		unlock_page(page);
+		if (from_pagecache)
 			put_page(page);
-		} else
+		else if (allocated_page)
 			__free_pages(page, 0);
 	}
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index dd2a242d5d22..0182577e6dae 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1070,7 +1070,7 @@ extern void ceph_put_fmode(struct ceph_inode_info *ci, int mode);
 /* addr.c */
 extern const struct address_space_operations ceph_aops;
 extern int ceph_mmap(struct file *file, struct vm_area_struct *vma);
-extern int ceph_uninline_data(struct inode *inode, struct page *locked_page);
+extern int ceph_uninline_data(struct inode *inode, struct page *provided_page);
 extern int ceph_pool_perm_check(struct ceph_inode_info *ci, int need);
 extern void ceph_pool_perm_destroy(struct ceph_mds_client* mdsc);
 
-- 
2.21.0

