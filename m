Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA613A6674
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Jun 2021 14:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbhFNMZd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Jun 2021 08:25:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233406AbhFNMZb (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 08:25:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A030761002;
        Mon, 14 Jun 2021 12:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623673409;
        bh=NNFtUoSA3BPcLcUKCIoPYr9H10iOagQu2r27xzwPfqw=;
        h=From:To:Cc:Subject:Date:From;
        b=WLSK/33Ui8dPEws53qEcsU4oPmAXP14BqdVJQlekSLVciJd6c+zLmlaOFPSVORT0k
         M4HCx4gRvnIv7aRVFqpUNa6Vu2iqBipFvwmB6pdgJzOLe6XWg6Ff0sixAJLPglr++0
         HsctlMKmOdjmrpWGYKlmaolEjhXJIli6Ket4szdTsqeDAGo2DrTXU0LRTBWB9cOJaD
         FfT+OAM13jM12Yr93lQseVVWgdFq0GHgmFBd4B05YHcmYF9XHq0GOt+A9urv9nIQMQ
         Acms8h8ECDE+t0wDxbA/K6IIot/q2Ca8LxsA7mDsUZFOFtSiuUk0o1GI2oePma2Me8
         vao6FrkY9XfXQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     dhowells@redhat.com
Cc:     linux-cachefs@redhat.com, idryomov@gmail.com, willy@infradead.org,
        pfmeec@rit.edu, ceph-devel@vger.kernel.org,
        Andrew W Elble <aweits@rit.edu>
Subject: [PATCH v2] netfs: fix test for whether we can skip read when writing beyond EOF
Date:   Mon, 14 Jun 2021 08:23:27 -0400
Message-Id: <20210614122327.8332-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

It's not sufficient to skip reading when the pos is beyond the EOF.
There may be data at the head of the page that we need to fill in
before the write.

Add a new helper function that corrects and clarifies the logic of
when we can skip reads, and have it only zero out the part of the page
that won't have data copied in for the write.

Finally, don't set the page Uptodate after zeroing. It's not up to date
since the write data won't have been copied in yet.

Fixes: e1b1240c1ff5f ("netfs: Add write_begin helper")
Reported-by: Andrew W Elble <aweits@rit.edu>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/netfs/read_helper.c | 47 +++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 12 deletions(-)

v2:
- rename new helper with netfs_* prefix
- return early for full page writes
- no need to calculate index to see if write is beyond last page
- no need to special case i_size == 0

diff --git a/fs/netfs/read_helper.c b/fs/netfs/read_helper.c
index 725614625ed4..489ab54da062 100644
--- a/fs/netfs/read_helper.c
+++ b/fs/netfs/read_helper.c
@@ -1011,12 +1011,42 @@ int netfs_readpage(struct file *file,
 }
 EXPORT_SYMBOL(netfs_readpage);
 
-static void netfs_clear_thp(struct page *page)
+/**
+ * prep_noread_page - prep a page for writing without reading first
+ * @page: page being prepared
+ * @pos: starting position for the write
+ * @len: length of write
+ *
+ * In some cases, write_begin doesn't need to read at all:
+ * - full page write
+ * - write that lies in a page that is completely beyond EOF
+ * - write that covers the the page from start to EOF or beyond it
+ *
+ * If any of these criteria are met, then zero out the unwritten parts
+ * of the page and return true. Otherwise, return false.
+ */
+static bool netfs_prep_noread_page(struct page *page, loff_t pos, size_t len)
 {
-	unsigned int i;
+	struct inode *inode = page->mapping->host;
+	loff_t i_size = i_size_read(inode);
+	size_t offset = offset_in_page(pos);
+
+	/* full page write -- no need to zero anything */
+	if (offset == 0 && len >= thp_size(page))
+		return true;
+
+	/* pos beyond last page in the file */
+	if (pos - offset >= i_size)
+		goto zero_out;
+
+	/* write that covers the whole page from start to EOF or beyond it */
+	if (offset == 0 && (pos + len) >= i_size)
+		goto zero_out;
 
-	for (i = 0; i < thp_nr_pages(page); i++)
-		clear_highpage(page + i);
+	return false;
+zero_out:
+	zero_user_segments(page, 0, offset, offset + len, thp_size(page));
+	return true;
 }
 
 /**
@@ -1061,8 +1091,6 @@ int netfs_write_begin(struct file *file, struct address_space *mapping,
 	struct inode *inode = file_inode(file);
 	unsigned int debug_index = 0;
 	pgoff_t index = pos >> PAGE_SHIFT;
-	int pos_in_page = pos & ~PAGE_MASK;
-	loff_t size;
 	int ret;
 
 	DEFINE_READAHEAD(ractl, file, NULL, mapping, index);
@@ -1090,13 +1118,8 @@ int netfs_write_begin(struct file *file, struct address_space *mapping,
 	 * within the cache granule containing the EOF, in which case we need
 	 * to preload the granule.
 	 */
-	size = i_size_read(inode);
 	if (!ops->is_cache_enabled(inode) &&
-	    ((pos_in_page == 0 && len == thp_size(page)) ||
-	     (pos >= size) ||
-	     (pos_in_page == 0 && (pos + len) >= size))) {
-		netfs_clear_thp(page);
-		SetPageUptodate(page);
+	    netfs_prep_noread_page(page, pos, len)) {
 		netfs_stat(&netfs_n_rh_write_zskip);
 		goto have_page_no_wait;
 	}
-- 
2.31.1

