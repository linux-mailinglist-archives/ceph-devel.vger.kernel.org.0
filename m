Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F05A73A5B0D
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Jun 2021 01:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbhFMXfu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 13 Jun 2021 19:35:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232156AbhFMXft (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 13 Jun 2021 19:35:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F65261159;
        Sun, 13 Jun 2021 23:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623627227;
        bh=AXh5QKC14hxJqvf8Bu1DCB303cTQiE6eslvW4tp11D8=;
        h=From:To:Cc:Subject:Date:From;
        b=VFDk7opuBf9IAKjq03ndAMhs3OZF9kJCvQ75ipWn7jaIUuFD8EOcBJjIBWtaAt3dd
         o0IJS8JdNS+iQiNvOKyDkGtnh/BZ+sCFP1tHOV+C43y6xbUVv/pULfzQAPlfZrkhmt
         JCC6iYBIH9Ghi2khfiHWYQajWgkGw9HfN6TRKelbeOWGJutJdP3Mm25REwPk5BSApd
         qrW2+QVXsrvQXrJR1nDG6xuAL7OgnsoVaMzKVntdOV2pqSWS56U+yu8WM8tbiUwlun
         m6dGbhCsvJkRyVHn7bB5zSh5FsGgCevaXqeXOVKBm8QbZcn8JAjNs3/WgDjkjbagjj
         JFoQDEpk7FZpw==
From:   Jeff Layton <jlayton@kernel.org>
To:     dhowells@redhat.com
Cc:     linux-cachefs@redhat.com, idryomov@gmail.com, willy@infradead.org,
        pfmeec@rit.edu, ceph-devel@vger.kernel.org,
        Andrew W Elble <aweits@rit.edu>
Subject: [PATCH] netfs: fix test for whether we can skip read when writing beyond EOF
Date:   Sun, 13 Jun 2021 19:33:45 -0400
Message-Id: <20210613233345.113565-1-jlayton@kernel.org>
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
 fs/netfs/read_helper.c | 53 ++++++++++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 12 deletions(-)

diff --git a/fs/netfs/read_helper.c b/fs/netfs/read_helper.c
index 725614625ed4..fcf3a8a09a00 100644
--- a/fs/netfs/read_helper.c
+++ b/fs/netfs/read_helper.c
@@ -1011,12 +1011,48 @@ int netfs_readpage(struct file *file,
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
+ * - file is currently zero-length
+ * - write that lies in a page that is completely beyond EOF
+ * - write that covers the the page from start to EOF or beyond it
+ *
+ * If any of these criteria are met, then zero out the unwritten parts
+ * of the page and return true. Otherwise, return false.
+ */
+static bool prep_noread_page(struct page *page, loff_t pos, size_t len)
 {
-	unsigned int i;
+	struct inode *inode = page->mapping->host;
+	loff_t i_size = i_size_read(inode);
+	pgoff_t index = pos / thp_size(page);
+	size_t offset = offset_in_page(pos);
+
+	/* full page write */
+	if (offset == 0 && len >= thp_size(page))
+		goto zero_out;
 
-	for (i = 0; i < thp_nr_pages(page); i++)
-		clear_highpage(page + i);
+	/* zero-length file */
+	if (i_size == 0)
+		goto zero_out;
+
+	/* pos beyond last page in the file */
+	if (index > ((i_size - 1) / thp_size(page)))
+		goto zero_out;
+
+	/* write that covers the whole page from start to EOF or beyond it */
+	if (offset == 0 && (pos + len) >= i_size)
+		goto zero_out;
+
+	return false;
+zero_out:
+	zero_user_segments(page, 0, offset, offset + len, thp_size(page));
+	return true;
 }
 
 /**
@@ -1061,8 +1097,6 @@ int netfs_write_begin(struct file *file, struct address_space *mapping,
 	struct inode *inode = file_inode(file);
 	unsigned int debug_index = 0;
 	pgoff_t index = pos >> PAGE_SHIFT;
-	int pos_in_page = pos & ~PAGE_MASK;
-	loff_t size;
 	int ret;
 
 	DEFINE_READAHEAD(ractl, file, NULL, mapping, index);
@@ -1090,13 +1124,8 @@ int netfs_write_begin(struct file *file, struct address_space *mapping,
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
+	    prep_noread_page(page, pos, len)) {
 		netfs_stat(&netfs_n_rh_write_zskip);
 		goto have_page_no_wait;
 	}
-- 
2.31.1

