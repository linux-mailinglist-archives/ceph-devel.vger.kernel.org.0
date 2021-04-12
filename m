Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB00535C7FB
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Apr 2021 15:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240188AbhDLNxM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 12 Apr 2021 09:53:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237043AbhDLNxM (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 12 Apr 2021 09:53:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2355611AD;
        Mon, 12 Apr 2021 13:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618235574;
        bh=vj23IOSSF/JvuU1eE4ApfmrJkmFzEikW4rwzJuoHt5Y=;
        h=From:To:Cc:Subject:Date:From;
        b=ad8W8IQkUi1gy7es9afPwCVwolF5273XVEXR/PrgoYAYa/mMGuzY/Ctpp31cQUQCT
         pSE43oJcGkKifSnTRP2CWK7SsS1FnAoQq8PQY55DXV1uraKBvvRv3+DfvJLJx0AIzP
         7EhHZXvhVGqwbTjo1fr6pONv4ICS9iiUQ0kYtTJa+AR6fkoOIZhWTr72uJHZPI9Njz
         lecoNxfN4drcaVoxleDnHjukIXPtCqJ+mq0AqxZtV/p+m3daKxUGvrcA8Mc+PdEQxs
         T8CMttzbK+42/jZqBJy9DEpbjMZ0Vdb8FfoTeMNXC8ungWaQiXhtnsEfnk7Td4kBAO
         FBJOfFDLwqVJA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
Subject: [PATCH] ceph: convert some PAGE_SIZE invocations to thp_size()
Date:   Mon, 12 Apr 2021 09:52:52 -0400
Message-Id: <20210412135252.42983-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Start preparing to allow the use of THPs in the pagecache with ceph by
making it use thp_size() in lieu of PAGE_SIZE in the appropriate places.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 51 +++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index a49f23edae14..9939100f9f9d 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -154,7 +154,7 @@ static void ceph_invalidatepage(struct page *page, unsigned int offset,
 	inode = page->mapping->host;
 	ci = ceph_inode(inode);
 
-	if (offset != 0 || length != PAGE_SIZE) {
+	if (offset != 0 || length != thp_size(page)) {
 		dout("%p invalidatepage %p idx %lu partial dirty page %u~%u\n",
 		     inode, page, page->index, offset, length);
 		return;
@@ -330,7 +330,7 @@ static int ceph_readpage(struct file *file, struct page *page)
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_vino vino = ceph_vino(inode);
 	u64 off = page_offset(page);
-	u64 len = PAGE_SIZE;
+	u64 len = thp_size(page);
 
 	if (ci->i_inline_version != CEPH_INLINE_NONE) {
 		/*
@@ -341,7 +341,7 @@ static int ceph_readpage(struct file *file, struct page *page)
 			unlock_page(page);
 			return -EINVAL;
 		}
-		zero_user_segment(page, 0, PAGE_SIZE);
+		zero_user_segment(page, 0, thp_size(page));
 		SetPageUptodate(page);
 		unlock_page(page);
 		return 0;
@@ -476,8 +476,8 @@ static u64 get_writepages_data_length(struct inode *inode,
 		spin_unlock(&ci->i_ceph_lock);
 		WARN_ON(!found);
 	}
-	if (end > page_offset(page) + PAGE_SIZE)
-		end = page_offset(page) + PAGE_SIZE;
+	if (end > page_offset(page) + thp_size(page))
+		end = page_offset(page) + thp_size(page);
 	return end > start ? end - start : 0;
 }
 
@@ -495,7 +495,7 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 	struct ceph_snap_context *snapc, *oldest;
 	loff_t page_off = page_offset(page);
 	int err;
-	loff_t len = PAGE_SIZE;
+	loff_t len = thp_size(page);
 	struct ceph_writeback_ctl ceph_wbc;
 	struct ceph_osd_client *osdc = &fsc->client->osdc;
 	struct ceph_osd_request *req;
@@ -523,7 +523,7 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 	/* is this a partial page at end of file? */
 	if (page_off >= ceph_wbc.i_size) {
 		dout("%p page eof %llu\n", page, ceph_wbc.i_size);
-		page->mapping->a_ops->invalidatepage(page, 0, PAGE_SIZE);
+		page->mapping->a_ops->invalidatepage(page, 0, thp_size(page));
 		return 0;
 	}
 
@@ -549,7 +549,7 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 	}
 
 	/* it may be a short write due to an object boundary */
-	WARN_ON_ONCE(len > PAGE_SIZE);
+	WARN_ON_ONCE(len > thp_size(page));
 	osd_req_op_extent_osd_data_pages(req, 0, &page, len, 0, false, false);
 	dout("writepage %llu~%llu (%llu bytes)\n", page_off, len, len);
 
@@ -838,7 +838,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 				    page_offset(page) >= i_size_read(inode)) &&
 				    clear_page_dirty_for_io(page))
 					mapping->a_ops->invalidatepage(page,
-								0, PAGE_SIZE);
+								0, thp_size(page));
 				unlock_page(page);
 				continue;
 			}
@@ -927,7 +927,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 			pages[locked_pages++] = page;
 			pvec.pages[i] = NULL;
 
-			len += PAGE_SIZE;
+			len += thp_size(page);
 		}
 
 		/* did we get anything? */
@@ -976,7 +976,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 			BUG_ON(IS_ERR(req));
 		}
 		BUG_ON(len < page_offset(pages[locked_pages - 1]) +
-			     PAGE_SIZE - offset);
+			     thp_size(page) - offset);
 
 		req->r_callback = writepages_finish;
 		req->r_inode = inode;
@@ -1006,7 +1006,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 			}
 
 			set_page_writeback(pages[i]);
-			len += PAGE_SIZE;
+			len += thp_size(page);
 		}
 
 		if (ceph_wbc.size_stable) {
@@ -1015,7 +1015,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 			/* writepages_finish() clears writeback pages
 			 * according to the data length, so make sure
 			 * data length covers all locked pages */
-			u64 min_len = len + 1 - PAGE_SIZE;
+			u64 min_len = len + 1 - thp_size(page);
 			len = get_writepages_data_length(inode, pages[i - 1],
 							 offset);
 			len = max(len, min_len);
@@ -1252,7 +1252,7 @@ static int ceph_write_begin(struct file *file, struct address_space *mapping,
 			}
 			goto out;
 		}
-		zero_user_segment(page, 0, PAGE_SIZE);
+		zero_user_segment(page, 0, thp_size(page));
 		SetPageUptodate(page);
 		goto out;
 	}
@@ -1363,8 +1363,8 @@ static vm_fault_t ceph_filemap_fault(struct vm_fault *vmf)
 
 	ceph_block_sigs(&oldset);
 
-	dout("filemap_fault %p %llx.%llx %llu~%zd trying to get caps\n",
-	     inode, ceph_vinop(inode), off, (size_t)PAGE_SIZE);
+	dout("filemap_fault %p %llx.%llx %llu trying to get caps\n",
+	     inode, ceph_vinop(inode), off);
 	if (fi->fmode & CEPH_FILE_MODE_LAZY)
 		want = CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_LAZYIO;
 	else
@@ -1375,8 +1375,8 @@ static vm_fault_t ceph_filemap_fault(struct vm_fault *vmf)
 	if (err < 0)
 		goto out_restore;
 
-	dout("filemap_fault %p %llu~%zd got cap refs on %s\n",
-	     inode, off, (size_t)PAGE_SIZE, ceph_cap_string(got));
+	dout("filemap_fault %p %llu got cap refs on %s\n",
+	     inode, off, ceph_cap_string(got));
 
 	if ((got & (CEPH_CAP_FILE_CACHE | CEPH_CAP_FILE_LAZYIO)) ||
 	    ci->i_inline_version == CEPH_INLINE_NONE) {
@@ -1384,9 +1384,8 @@ static vm_fault_t ceph_filemap_fault(struct vm_fault *vmf)
 		ceph_add_rw_context(fi, &rw_ctx);
 		ret = filemap_fault(vmf);
 		ceph_del_rw_context(fi, &rw_ctx);
-		dout("filemap_fault %p %llu~%zd drop cap refs %s ret %x\n",
-			inode, off, (size_t)PAGE_SIZE,
-				ceph_cap_string(got), ret);
+		dout("filemap_fault %p %llu drop cap refs %s ret %x\n",
+		     inode, off, ceph_cap_string(got), ret);
 	} else
 		err = -EAGAIN;
 
@@ -1424,8 +1423,8 @@ static vm_fault_t ceph_filemap_fault(struct vm_fault *vmf)
 		vmf->page = page;
 		ret = VM_FAULT_MAJOR | VM_FAULT_LOCKED;
 out_inline:
-		dout("filemap_fault %p %llu~%zd read inline data ret %x\n",
-		     inode, off, (size_t)PAGE_SIZE, ret);
+		dout("filemap_fault %p %llu read inline data ret %x\n",
+		     inode, off, ret);
 	}
 out_restore:
 	ceph_restore_sigs(&oldset);
@@ -1470,10 +1469,10 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 			goto out_free;
 	}
 
-	if (off + PAGE_SIZE <= size)
-		len = PAGE_SIZE;
+	if (off + thp_size(page) <= size)
+		len = thp_size(page);
 	else
-		len = size & ~PAGE_MASK;
+		len = offset_in_thp(page, size);
 
 	dout("page_mkwrite %p %llx.%llx %llu~%zd getting caps i_size %llu\n",
 	     inode, ceph_vinop(inode), off, len, size);
-- 
2.30.2

