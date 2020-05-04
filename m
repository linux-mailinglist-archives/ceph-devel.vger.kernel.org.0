Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C2D1C41FC
	for <lists+ceph-devel@lfdr.de>; Mon,  4 May 2020 19:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730628AbgEDRPW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 4 May 2020 13:15:22 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58007 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730342AbgEDRPS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 4 May 2020 13:15:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588612515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sRKCOH1sRy+XZxFgfi8EwSj60MsXZTzK2qeSb/MCbWE=;
        b=iD+Fq8Iu6utIC7RpuHqt65S7mj+BeH2gHJMIq1tVaCS34bjdjKXZbHqnyNYbzSsVzQwB6D
        zZAAgoR7MQhRTx+smqW6nSMDZsGDKyRaS4FSDmUJeXvFZGTykZ4NRmoo2bOOStY69OVzRl
        +ePpeZGvbhaZVbucPsU5XSNI7H2OuwQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-goNvru-CMTCSQ5eSI_ciYA-1; Mon, 04 May 2020 13:15:09 -0400
X-MC-Unique: goNvru-CMTCSQ5eSI_ciYA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3C5519200C0;
        Mon,  4 May 2020 17:15:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-118-225.rdu2.redhat.com [10.10.118.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E4812C264;
        Mon,  4 May 2020 17:15:01 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [RFC PATCH 50/61] afs: Set up the iov_iter before calling
 afs_extract_data()
From:   David Howells <dhowells@redhat.com>
To:     Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Jeff Layton <jlayton@redhat.com>
Cc:     dhowells@redhat.com, Matthew Wilcox <willy@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-afs@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 04 May 2020 18:15:00 +0100
Message-ID: <158861250059.340223.1248231474865140653.stgit@warthog.procyon.org.uk>
In-Reply-To: <158861203563.340223.7585359869938129395.stgit@warthog.procyon.org.uk>
References: <158861203563.340223.7585359869938129395.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

afs_extract_data sets up a temporary iov_iter and passes it to AF_RXRPC
each time it is called to describe the remaining buffer to be filled.

Instead:

 (1) Put an iterator in the afs_call struct.

 (2) Set the iterator for each marshalling stage to load data into the
     appropriate places.  A number of convenience functions are provided to
     this end (eg. afs_extract_to_buf()).

     This iterator is then passed to afs_extract_data().

 (3) Use the new ITER_MAPPING iterator when reading data to load directly
     into the inode's pages without needing to create a list of them.  This
     comes with a page-done callback that can be used to unlock pages as
     they are filled.

This will allow O_DIRECT calls to be supported in future patches.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/dir.c       |  223 +++++++++++++++++++++++++++++++++++-----------------
 fs/afs/file.c      |  188 +++++++++++++++++++++++++-------------------
 fs/afs/fsclient.c  |   54 +++----------
 fs/afs/internal.h  |   16 ++--
 fs/afs/write.c     |    8 +-
 fs/afs/yfsclient.c |   53 +++---------
 6 files changed, 296 insertions(+), 246 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 9d8504885f6a..a10bcf632e0c 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -104,6 +104,35 @@ struct afs_lookup_cookie {
 	struct afs_fid		fids[50];
 };
 
+/*
+ * Drop the refs that we're holding on the pages we were reading into.  We've
+ * got refs on the first nr_pages pages.
+ */
+static void afs_dir_read_cleanup(struct afs_read *req)
+{
+	struct address_space *mapping = req->iter->mapping;
+	struct page *page;
+	pgoff_t last = req->nr_pages - 1;
+
+	XA_STATE(xas, &mapping->i_pages, 0);
+
+	if (unlikely(!req->nr_pages))
+		return;
+
+	rcu_read_lock();
+	xas_for_each(&xas, page, last) {
+		if (xas_retry(&xas, page))
+			continue;
+		BUG_ON(xa_is_value(page));
+		BUG_ON(PageCompound(page));
+		ASSERTCMP(page->mapping, ==, mapping);
+
+		put_page(page);
+	}
+
+	rcu_read_unlock();
+}
+
 /*
  * check that a directory page is valid
  */
@@ -129,7 +158,7 @@ static bool afs_dir_check_page(struct afs_vnode *dvnode, struct page *page,
 	qty /= sizeof(union afs_xdr_dir_block);
 
 	/* check them */
-	dbuf = kmap(page);
+	dbuf = kmap_atomic(page);
 	for (tmp = 0; tmp < qty; tmp++) {
 		if (dbuf->blocks[tmp].hdr.magic != AFS_DIR_MAGIC) {
 			printk("kAFS: %s(%lx): bad magic %d/%d is %04hx\n",
@@ -148,7 +177,7 @@ static bool afs_dir_check_page(struct afs_vnode *dvnode, struct page *page,
 		((u8 *)&dbuf->blocks[tmp])[AFS_DIR_BLOCK_SIZE - 1] = 0;
 	}
 
-	kunmap(page);
+	kunmap_atomic(dbuf);
 
 checked:
 	afs_stat_v(dvnode, n_read_dir);
@@ -159,35 +188,74 @@ static bool afs_dir_check_page(struct afs_vnode *dvnode, struct page *page,
 }
 
 /*
- * Check the contents of a directory that we've just read.
+ * Dump the contents of a directory.
  */
-static bool afs_dir_check_pages(struct afs_vnode *dvnode, struct afs_read *req)
+static void afs_dir_dump(struct afs_vnode *dvnode, struct afs_read *req)
 {
 	struct afs_xdr_dir_page *dbuf;
-	unsigned int i, j, qty = PAGE_SIZE / sizeof(union afs_xdr_dir_block);
+	struct address_space *mapping = dvnode->vfs_inode.i_mapping;
+	struct page *page;
+	unsigned int i, qty = PAGE_SIZE / sizeof(union afs_xdr_dir_block);
+	pgoff_t last = req->nr_pages - 1;
 
-	for (i = 0; i < req->nr_pages; i++)
-		if (!afs_dir_check_page(dvnode, req->pages[i], req->actual_len))
-			goto bad;
-	return true;
+	XA_STATE(xas, &mapping->i_pages, 0);
 
-bad:
-	pr_warn("DIR %llx:%llx f=%llx l=%llx al=%llx r=%llx\n",
+	pr_warn("DIR %llx:%llx f=%llx l=%llx al=%llx\n",
 		dvnode->fid.vid, dvnode->fid.vnode,
-		req->file_size, req->len, req->actual_len, req->remain);
-	pr_warn("DIR %llx %x %x %x\n",
-		req->pos, req->index, req->nr_pages, req->offset);
+		req->file_size, req->len, req->actual_len);
+	pr_warn("DIR %llx %x %zx %zx\n",
+		req->pos, req->nr_pages,
+		req->iter->iov_offset,  iov_iter_count(req->iter));
+
+	xas_for_each(&xas, page, last) {
+		if (xas_retry(&xas, page))
+			continue;
 
-	for (i = 0; i < req->nr_pages; i++) {
-		dbuf = kmap(req->pages[i]);
-		for (j = 0; j < qty; j++) {
-			union afs_xdr_dir_block *block = &dbuf->blocks[j];
+		BUG_ON(PageCompound(page));
+		BUG_ON(page->mapping != mapping);
 
-			pr_warn("[%02x] %32phN\n", i * qty + j, block);
+		dbuf = kmap_atomic(page);
+		for (i = 0; i < qty; i++) {
+			union afs_xdr_dir_block *block = &dbuf->blocks[i];
+
+			pr_warn("[%02lx] %32phN\n", page->index * qty + i, block);
 		}
-		kunmap(req->pages[i]);
+		kunmap_atomic(dbuf);
 	}
-	return false;
+}
+
+/*
+ * Check all the pages in a directory.  All the pages are held pinned.
+ */
+static int afs_dir_check(struct afs_vnode *dvnode, struct afs_read *req)
+{
+	struct address_space *mapping = dvnode->vfs_inode.i_mapping;
+	struct page *page;
+	pgoff_t last = req->nr_pages - 1;
+	int ret = 0;
+
+	XA_STATE(xas, &mapping->i_pages, 0);
+
+	if (unlikely(!req->nr_pages))
+		return 0;
+
+	rcu_read_lock();
+	xas_for_each(&xas, page, last) {
+		if (xas_retry(&xas, page))
+			continue;
+
+		BUG_ON(PageCompound(page));
+		BUG_ON(page->mapping != mapping);
+
+		ret = afs_dir_check_page(dvnode, page, req->file_size);
+		if (ret < 0) {
+			afs_dir_dump(dvnode, req);
+			break;
+		}
+	}
+
+	rcu_read_unlock();
+	return ret;
 }
 
 /*
@@ -216,58 +284,56 @@ static struct afs_read *afs_read_dir(struct afs_vnode *dvnode, struct key *key)
 {
 	struct afs_read *req;
 	loff_t i_size;
-	int nr_pages, nr_inline, i, n;
-	int ret = -ENOMEM;
+	int nr_pages, i, n;
+	int ret;
 
-retry:
+	_enter("");
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return ERR_PTR(-ENOMEM);
+
+	refcount_set(&req->usage, 1);
+	req->key = key_get(key);
+	req->cleanup = afs_dir_read_cleanup;
+
+expand:
 	i_size = i_size_read(&dvnode->vfs_inode);
-	if (i_size < 2048)
-		return ERR_PTR(afs_bad(dvnode, afs_file_error_dir_small));
+	if (i_size < 2048) {
+		ret = afs_bad(dvnode, afs_file_error_dir_small);
+		goto error;
+	}
 	if (i_size > 2048 * 1024) {
 		trace_afs_file_error(dvnode, -EFBIG, afs_file_error_dir_big);
-		return ERR_PTR(-EFBIG);
+		ret = -EFBIG;
+		goto error;
 	}
 
 	_enter("%llu", i_size);
 
-	/* Get a request record to hold the page list.  We want to hold it
-	 * inline if we can, but we don't want to make an order 1 allocation.
-	 */
 	nr_pages = (i_size + PAGE_SIZE - 1) / PAGE_SIZE;
-	nr_inline = nr_pages;
-	if (nr_inline > (PAGE_SIZE - sizeof(*req)) / sizeof(struct page *))
-		nr_inline = 0;
 
-	req = kzalloc(struct_size(req, array, nr_inline), GFP_KERNEL);
-	if (!req)
-		return ERR_PTR(-ENOMEM);
-
-	refcount_set(&req->usage, 1);
-	req->key = key_get(key);
-	req->nr_pages = nr_pages;
 	req->actual_len = i_size; /* May change */
 	req->len = nr_pages * PAGE_SIZE; /* We can ask for more than there is */
 	req->data_version = dvnode->status.data_version; /* May change */
-	if (nr_inline > 0) {
-		req->pages = req->array;
-	} else {
-		req->pages = kcalloc(nr_pages, sizeof(struct page *),
-				     GFP_KERNEL);
-		if (!req->pages)
-			goto error;
-	}
+	iov_iter_mapping(&req->def_iter, READ, dvnode->vfs_inode.i_mapping,
+			 0, i_size);
+	req->iter = &req->def_iter;
 
-	/* Get a list of all the pages that hold or will hold the directory
-	 * content.  We need to fill in any gaps that we might find where the
-	 * memory reclaimer has been at work.  If there are any gaps, we will
+	/* Fill in any gaps that we might find where the memory reclaimer has
+	 * been at work and pin all the pages.  If there are any gaps, we will
 	 * need to reread the entire directory contents.
 	 */
-	i = 0;
-	do {
+	i = req->nr_pages;
+	while (i < nr_pages) {
+		struct page *pages[8], *page;
+
 		n = find_get_pages_contig(dvnode->vfs_inode.i_mapping, i,
-					  req->nr_pages - i,
-					  req->pages + i);
-		_debug("find %u at %u/%u", n, i, req->nr_pages);
+					  min_t(unsigned int, nr_pages - i,
+						ARRAY_SIZE(pages)),
+					  pages);
+		_debug("find %u at %u/%u", n, i, nr_pages);
+
 		if (n == 0) {
 			gfp_t gfp = dvnode->vfs_inode.i_mapping->gfp_mask;
 
@@ -275,23 +341,25 @@ static struct afs_read *afs_read_dir(struct afs_vnode *dvnode, struct key *key)
 				afs_stat_v(dvnode, n_inval);
 
 			ret = -ENOMEM;
-			req->pages[i] = __page_cache_alloc(gfp);
-			if (!req->pages[i])
+			page = __page_cache_alloc(gfp);
+			if (!page)
 				goto error;
-			ret = add_to_page_cache_lru(req->pages[i],
+			ret = add_to_page_cache_lru(page,
 						    dvnode->vfs_inode.i_mapping,
 						    i, gfp);
 			if (ret < 0)
 				goto error;
 
-			set_page_private(req->pages[i], 1);
-			SetPagePrivate(req->pages[i]);
-			unlock_page(req->pages[i]);
+			set_page_private(page, 1);
+			SetPagePrivate(page);
+			unlock_page(page);
+			req->nr_pages++;
 			i++;
 		} else {
+			req->nr_pages += n;
 			i += n;
 		}
-	} while (i < req->nr_pages);
+	}
 
 	/* If we're going to reload, we need to lock all the pages to prevent
 	 * races.
@@ -315,12 +383,17 @@ static struct afs_read *afs_read_dir(struct afs_vnode *dvnode, struct key *key)
 
 		task_io_account_read(PAGE_SIZE * req->nr_pages);
 
-		if (req->len < req->file_size)
-			goto content_has_grown;
+		if (req->len < req->file_size) {
+			/* The content has grown, so we need to expand the
+			 * buffer.
+			 */
+			up_write(&dvnode->validate_lock);
+			goto expand;
+		}
 
 		/* Validate the data we just read. */
-		ret = -EIO;
-		if (!afs_dir_check_pages(dvnode, req))
+		ret = afs_dir_check(dvnode, req);
+		if (ret < 0)
 			goto error_unlock;
 
 		// TODO: Trim excess pages
@@ -338,11 +411,6 @@ static struct afs_read *afs_read_dir(struct afs_vnode *dvnode, struct key *key)
 	afs_put_read(req);
 	_leave(" = %d", ret);
 	return ERR_PTR(ret);
-
-content_has_grown:
-	up_write(&dvnode->validate_lock);
-	afs_put_read(req);
-	goto retry;
 }
 
 /*
@@ -449,6 +517,7 @@ static int afs_dir_iterate(struct inode *dir, struct dir_context *ctx,
 	struct afs_read *req;
 	struct page *page;
 	unsigned blkoff, limit;
+	void __rcu **slot;
 	int ret;
 
 	_enter("{%lu},%u,,", dir->i_ino, (unsigned)ctx->pos);
@@ -473,9 +542,15 @@ static int afs_dir_iterate(struct inode *dir, struct dir_context *ctx,
 		blkoff = ctx->pos & ~(sizeof(union afs_xdr_dir_block) - 1);
 
 		/* Fetch the appropriate page from the directory and re-add it
-		 * to the LRU.
+		 * to the LRU.  We have all the pages pinned with an extra ref.
 		 */
-		page = req->pages[blkoff / PAGE_SIZE];
+		rcu_read_lock();
+		page = NULL;
+		slot = radix_tree_lookup_slot(&dvnode->vfs_inode.i_mapping->i_pages,
+					      blkoff / PAGE_SIZE);
+		if (slot)
+			page = radix_tree_deref_slot(slot);
+		rcu_read_unlock();
 		if (!page) {
 			ret = afs_bad(dvnode, afs_file_error_dir_missing_page);
 			break;
diff --git a/fs/afs/file.c b/fs/afs/file.c
index 834f47c4dc94..c8ad638590e7 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -196,21 +196,70 @@ int afs_release(struct inode *inode, struct file *file)
 	return ret;
 }
 
+/*
+ * Handle completion of a read operation.
+ */
+static void afs_file_read_done(struct afs_read *req)
+{
+	struct afs_vnode *vnode = req->vnode;
+	struct page *page;
+	pgoff_t index = req->pos >> PAGE_SHIFT;
+	pgoff_t last = index + req->nr_pages - 1;
+
+	XA_STATE(xas, &vnode->vfs_inode.i_mapping->i_pages, index);
+
+	if (iov_iter_count(req->iter) > 0) {
+		/* The read was short - clear the excess buffer. */
+		_debug("afterclear %zx %zx %llx/%llx",
+		       req->iter->iov_offset,
+		       iov_iter_count(req->iter),
+		       req->actual_len, req->len);
+		iov_iter_zero(iov_iter_count(req->iter), req->iter);
+	}
+
+	rcu_read_lock();
+	xas_for_each(&xas, page, last) {
+		page_endio(page, false, 0);
+		put_page(page);
+	}
+	rcu_read_unlock();
+
+	task_io_account_read(req->len);
+	req->cleanup = NULL;
+}
+
+/*
+ * Dispose of our locks and refs on the pages if the read failed.
+ */
+static void afs_file_read_cleanup(struct afs_read *req)
+{
+	struct page *page;
+	pgoff_t index = req->pos >> PAGE_SHIFT;
+	pgoff_t last = index + req->nr_pages - 1;
+
+	XA_STATE(xas, &req->iter->mapping->i_pages, index);
+
+	_enter("%lu,%u,%zu", index, req->nr_pages, iov_iter_count(req->iter));
+
+	rcu_read_lock();
+	xas_for_each(&xas, page, last) {
+		BUG_ON(xa_is_value(page));
+		BUG_ON(PageCompound(page));
+
+		page_endio(page, false, req->error);
+		put_page(page);
+	}
+	rcu_read_unlock();
+}
+
 /*
  * Dispose of a ref to a read record.
  */
 void afs_put_read(struct afs_read *req)
 {
-	int i;
-
 	if (refcount_dec_and_test(&req->usage)) {
-		if (req->pages) {
-			for (i = 0; i < req->nr_pages; i++)
-				if (req->pages[i])
-					put_page(req->pages[i]);
-			if (req->pages != req->array)
-				kfree(req->pages);
-		}
+		if (req->cleanup)
+			req->cleanup(req);
 		key_put(req->key);
 		kfree(req);
 	}
@@ -251,6 +300,7 @@ int afs_fetch_data(struct afs_vnode *vnode, struct afs_read *req)
 		ret = afs_end_vnode_operation(&fc);
 	}
 
+	req->error = ret;
 	if (ret == 0) {
 		afs_stat_v(vnode, n_fetches);
 		atomic_long_add(req->actual_len,
@@ -265,12 +315,11 @@ int afs_fetch_data(struct afs_vnode *vnode, struct afs_read *req)
 /*
  * read page from file, directory or symlink, given a key to use
  */
-int afs_page_filler(void *data, struct page *page)
+static int afs_page_filler(struct key *key, struct page *page)
 {
 	struct inode *inode = page->mapping->host;
 	struct afs_vnode *vnode = AFS_FS_I(inode);
 	struct afs_read *req;
-	struct key *key = data;
 	int ret;
 
 	_enter("{%x},{%lu},{%lu}", key_serial(key), inode->i_ino, page->index);
@@ -281,53 +330,52 @@ int afs_page_filler(void *data, struct page *page)
 	if (test_bit(AFS_VNODE_DELETED, &vnode->flags))
 		goto error;
 
-	req = kzalloc(struct_size(req, array, 1), GFP_KERNEL);
+	req = kzalloc(sizeof(struct afs_read), GFP_KERNEL);
 	if (!req)
 		goto enomem;
 
-	/* We request a full page.  If the page is a partial one at the
-	 * end of the file, the server will return a short read and the
-	 * unmarshalling code will clear the unfilled space.
-	 */
 	refcount_set(&req->usage, 1);
-	req->key = key_get(key);
-	req->pos = (loff_t)page->index << PAGE_SHIFT;
-	req->len = PAGE_SIZE;
-	req->nr_pages = 1;
-	req->pages = req->array;
-	req->pages[0] = page;
+	req->vnode		= vnode;
+	req->key		= key_get(key);
+	req->pos		= (loff_t)page->index << PAGE_SHIFT;
+	req->len		= PAGE_SIZE;
+	req->nr_pages		= 1;
+	req->done		= afs_file_read_done;
+	req->cleanup		= afs_file_read_cleanup;
+
 	get_page(page);
+	iov_iter_mapping(&req->def_iter, READ, page->mapping,
+			 req->pos, req->len);
+	req->iter = &req->def_iter;
 
-	/* read the contents of the file from the server into the
-	 * page */
 	ret = afs_fetch_data(vnode, req);
-	afs_put_read(req);
-
-	if (ret < 0) {
-		if (ret == -ENOENT) {
-			_debug("got NOENT from server"
-			       " - marking file deleted and stale");
-			set_bit(AFS_VNODE_DELETED, &vnode->flags);
-			ret = -ESTALE;
-		}
-
-		if (ret == -EINTR ||
-		    ret == -ENOMEM ||
-		    ret == -ERESTARTSYS ||
-		    ret == -EAGAIN)
-			goto error;
-		goto io_error;
-	}
-
-	SetPageUptodate(page);
-	unlock_page(page);
+	if (ret < 0)
+		goto fetch_error;
 
+	afs_put_read(req);
 	_leave(" = 0");
 	return 0;
 
-io_error:
-	SetPageError(page);
-	goto error;
+fetch_error:
+	switch (ret) {
+	case -EINTR:
+	case -ENOMEM:
+	case -ERESTARTSYS:
+	case -EAGAIN:
+		afs_put_read(req);
+		goto error;
+	case -ENOENT:
+		_debug("got NOENT from server - marking file deleted and stale");
+		set_bit(AFS_VNODE_DELETED, &vnode->flags);
+		ret = -ESTALE;
+		/* Fall through */
+	default:
+		page_endio(page, false, ret);
+		afs_put_read(req);
+		_leave(" = %d", ret);
+		return ret;
+	}
+
 enomem:
 	ret = -ENOMEM;
 error:
@@ -362,19 +410,6 @@ static int afs_readpage(struct file *file, struct page *page)
 	return ret;
 }
 
-/*
- * Make pages available as they're filled.
- */
-static void afs_readpages_page_done(struct afs_read *req)
-{
-	struct page *page = req->pages[req->index];
-
-	req->pages[req->index] = NULL;
-	SetPageUptodate(page);
-	unlock_page(page);
-	put_page(page);
-}
-
 /*
  * Read a contiguous set of pages.
  */
@@ -386,7 +421,7 @@ static int afs_readpages_one(struct file *file, struct address_space *mapping,
 	struct list_head *p;
 	struct page *first, *page;
 	pgoff_t index;
-	int ret, n, i;
+	int ret, n;
 
 	/* Count the number of contiguous pages at the front of the list.  Note
 	 * that the list goes prev-wards rather than next-wards.
@@ -402,21 +437,20 @@ static int afs_readpages_one(struct file *file, struct address_space *mapping,
 		n++;
 	}
 
-	req = kzalloc(struct_size(req, array, n), GFP_NOFS);
+	req = kzalloc(sizeof(struct afs_read), GFP_NOFS);
 	if (!req)
 		return -ENOMEM;
 
 	refcount_set(&req->usage, 1);
 	req->vnode = vnode;
 	req->key = key_get(afs_file_key(file));
-	req->page_done = afs_readpages_page_done;
+	req->done = afs_file_read_done;
+	req->cleanup = afs_file_read_cleanup;
 	req->pos = first->index;
 	req->pos <<= PAGE_SHIFT;
-	req->pages = req->array;
 
-	/* Transfer the pages to the request.  We add them in until one fails
-	 * to add to the LRU and then we stop (as that'll make a hole in the
-	 * contiguous run.
+	/* Add pages to the LRU until it fails.  We keep the pages ref'd and
+	 * locked until the read is complete.
 	 *
 	 * Note that it's possible for the file size to change whilst we're
 	 * doing this, but we rely on the server returning less than we asked
@@ -433,8 +467,7 @@ static int afs_readpages_one(struct file *file, struct address_space *mapping,
 			break;
 		}
 
-		req->pages[req->nr_pages++] = page;
-		req->len += PAGE_SIZE;
+		req->nr_pages++;
 	} while (req->nr_pages < n);
 
 	if (req->nr_pages == 0) {
@@ -442,30 +475,25 @@ static int afs_readpages_one(struct file *file, struct address_space *mapping,
 		return 0;
 	}
 
+	req->len = req->nr_pages * PAGE_SIZE;
+	iov_iter_mapping(&req->def_iter, READ, file->f_mapping,
+			 req->pos, req->len);
+	req->iter = &req->def_iter;
+
 	ret = afs_fetch_data(vnode, req);
 	if (ret < 0)
 		goto error;
 
-	task_io_account_read(PAGE_SIZE * req->nr_pages);
 	afs_put_read(req);
 	return 0;
 
 error:
 	if (ret == -ENOENT) {
-		_debug("got NOENT from server"
-		       " - marking file deleted and stale");
+		_debug("got NOENT from server - marking file deleted and stale");
 		set_bit(AFS_VNODE_DELETED, &vnode->flags);
 		ret = -ESTALE;
 	}
 
-	for (i = 0; i < req->nr_pages; i++) {
-		page = req->pages[i];
-		if (page) {
-			SetPageError(page);
-			unlock_page(page);
-		}
-	}
-
 	afs_put_read(req);
 	return ret;
 }
diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index 492fbd964576..8222ccf01280 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -324,7 +324,6 @@ static int afs_deliver_fs_fetch_data(struct afs_call *call)
 {
 	struct afs_read *req = call->read_request;
 	const __be32 *bp;
-	unsigned int size;
 	int ret;
 
 	_enter("{%u,%zu,%zu/%llu}",
@@ -334,8 +333,6 @@ static int afs_deliver_fs_fetch_data(struct afs_call *call)
 	switch (call->unmarshall) {
 	case 0:
 		req->actual_len = 0;
-		req->index = 0;
-		req->offset = req->pos & (PAGE_SIZE - 1);
 		call->unmarshall++;
 		if (call->operation_ID == FSFETCHDATA64) {
 			afs_extract_to_tmp64(call);
@@ -343,9 +340,13 @@ static int afs_deliver_fs_fetch_data(struct afs_call *call)
 			call->tmp_u = htonl(0);
 			afs_extract_to_tmp(call);
 		}
+
 		/* Fall through */
 
-		/* extract the returned data length */
+		/* Extract the returned data length into
+		 * ->actual_len.  This may indicate more or less data than was
+		 * requested will be returned.
+		 */
 	case 1:
 		_debug("extract data length");
 		ret = afs_extract_data(call, true);
@@ -354,47 +355,25 @@ static int afs_deliver_fs_fetch_data(struct afs_call *call)
 
 		req->actual_len = be64_to_cpu(call->tmp64);
 		_debug("DATA length: %llu", req->actual_len);
-		req->remain = min(req->len, req->actual_len);
-		if (req->remain == 0)
+
+		if (req->actual_len == 0)
 			goto no_more_data;
 
 		call->unmarshall++;
-
-	begin_page:
-		ASSERTCMP(req->index, <, req->nr_pages);
-		if (req->remain > PAGE_SIZE - req->offset)
-			size = PAGE_SIZE - req->offset;
-		else
-			size = req->remain;
-		call->iov_len = size;
-		call->bvec[0].bv_len = size;
-		call->bvec[0].bv_offset = req->offset;
-		call->bvec[0].bv_page = req->pages[req->index];
-		iov_iter_bvec(&call->def_iter, READ, call->bvec, 1, size);
-		ASSERTCMP(size, <=, PAGE_SIZE);
+		call->iter = req->iter;
+		call->iov_len = min(req->actual_len, req->len);
 		/* Fall through */
 
 		/* extract the returned data */
 	case 2:
 		_debug("extract data %zu/%llu",
-		       iov_iter_count(call->iter), req->remain);
+		       iov_iter_count(call->iter), req->actual_len);
 
 		ret = afs_extract_data(call, true);
 		if (ret < 0)
 			return ret;
-		req->remain -= call->bvec[0].bv_len;
-		req->offset += call->bvec[0].bv_len;
-		ASSERTCMP(req->offset, <=, PAGE_SIZE);
-		if (req->offset == PAGE_SIZE) {
-			req->offset = 0;
-			if (req->page_done)
-				req->page_done(req);
-			req->index++;
-			if (req->remain > 0)
-				goto begin_page;
-		}
 
-		ASSERTCMP(req->remain, ==, 0);
+		call->iter = &call->def_iter;
 		if (req->actual_len <= req->len)
 			goto no_more_data;
 
@@ -438,14 +417,8 @@ static int afs_deliver_fs_fetch_data(struct afs_call *call)
 		break;
 	}
 
-	for (; req->index < req->nr_pages; req->index++) {
-		if (req->offset < PAGE_SIZE)
-			zero_user_segment(req->pages[req->index],
-					  req->offset, PAGE_SIZE);
-		if (req->page_done)
-			req->page_done(req);
-		req->offset = 0;
-	}
+	if (req->done)
+		req->done(req);
 
 	_leave(" = 0 [done]");
 	return 0;
@@ -547,6 +520,7 @@ int afs_fs_fetch_data(struct afs_fs_cursor *fc,
 	call->out_scb = scb;
 	call->out_volsync = NULL;
 	call->read_request = afs_get_read(req);
+	req->call_debug_id = call->debug_id;
 
 	/* marshall the parameters */
 	bp = call->request;
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 521a03023112..e676ad145272 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -31,6 +31,7 @@
 
 struct pagevec;
 struct afs_call;
+struct afs_vnode;
 
 /*
  * Partial file-locking emulation mode.  (The problem being that AFS3 only
@@ -226,18 +227,18 @@ struct afs_read {
 	loff_t			pos;		/* Where to start reading */
 	loff_t			len;		/* How much we're asking for */
 	loff_t			actual_len;	/* How much we're actually getting */
-	loff_t			remain;		/* Amount remaining */
 	loff_t			file_size;	/* File size returned by server */
 	struct key		*key;		/* The key to use to reissue the read */
+	struct afs_vnode	*vnode;		/* The file being read into. */
 	afs_dataversion_t	data_version;	/* Version number returned by server */
 	refcount_t		usage;
-	unsigned int		index;		/* Which page we're reading into */
+	unsigned int		call_debug_id;
 	unsigned int		nr_pages;
-	unsigned int		offset;		/* offset into current page */
-	struct afs_vnode	*vnode;
-	void (*page_done)(struct afs_read *);
-	struct page		**pages;
-	struct page		*array[];
+	int			error;
+	void (*done)(struct afs_read *);
+	void (*cleanup)(struct afs_read *);
+	struct iov_iter		*iter;		/* Iterator representing the buffer */
+	struct iov_iter		def_iter;	/* Default iterator */
 };
 
 /*
@@ -924,7 +925,6 @@ extern void afs_put_wb_key(struct afs_wb_key *);
 extern int afs_open(struct inode *, struct file *);
 extern int afs_release(struct inode *, struct file *);
 extern int afs_fetch_data(struct afs_vnode *, struct afs_read *);
-extern int afs_page_filler(void *, struct page *);
 extern void afs_put_read(struct afs_read *);
 
 static inline struct afs_read *afs_get_read(struct afs_read *req)
diff --git a/fs/afs/write.c b/fs/afs/write.c
index 8473f9bc3548..174e355aee6d 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -45,7 +45,7 @@ static int afs_fill_page(struct file *file,
 		return 0;
 	}
 
-	req = kzalloc(struct_size(req, array, 1), GFP_KERNEL);
+	req = kzalloc(sizeof(struct afs_read), GFP_KERNEL);
 	if (!req)
 		return -ENOMEM;
 
@@ -54,9 +54,9 @@ static int afs_fill_page(struct file *file,
 	req->pos = pos;
 	req->len = len;
 	req->nr_pages = 1;
-	req->pages = req->array;
-	req->pages[0] = page;
-	get_page(page);
+	iov_iter_mapping(&req->def_iter, READ, vnode->vfs_inode.i_mapping,
+			 pos, len);
+	req->iter = &req->def_iter;
 
 	ret = afs_fetch_data(vnode, req);
 	afs_put_read(req);
diff --git a/fs/afs/yfsclient.c b/fs/afs/yfsclient.c
index 1164f48e308d..518b9489ff9e 100644
--- a/fs/afs/yfsclient.c
+++ b/fs/afs/yfsclient.c
@@ -439,7 +439,6 @@ static int yfs_deliver_fs_fetch_data64(struct afs_call *call)
 {
 	struct afs_read *req = call->read_request;
 	const __be32 *bp;
-	unsigned int size;
 	int ret;
 
 	_enter("{%u,%zu, %zu/%llu}",
@@ -449,13 +448,15 @@ static int yfs_deliver_fs_fetch_data64(struct afs_call *call)
 	switch (call->unmarshall) {
 	case 0:
 		req->actual_len = 0;
-		req->index = 0;
-		req->offset = req->pos & (PAGE_SIZE - 1);
 		afs_extract_to_tmp64(call);
 		call->unmarshall++;
+
 		/* Fall through */
 
-		/* extract the returned data length */
+		/* Extract the returned data length into ->actual_len.  This
+		 * may indicate more or less data than was requested will be
+		 * returned.
+		 */
 	case 1:
 		_debug("extract data length");
 		ret = afs_extract_data(call, true);
@@ -464,47 +465,25 @@ static int yfs_deliver_fs_fetch_data64(struct afs_call *call)
 
 		req->actual_len = be64_to_cpu(call->tmp64);
 		_debug("DATA length: %llu", req->actual_len);
-		req->remain = min(req->len, req->actual_len);
-		if (req->remain == 0)
+
+		if (req->actual_len == 0)
 			goto no_more_data;
 
 		call->unmarshall++;
-
-	begin_page:
-		ASSERTCMP(req->index, <, req->nr_pages);
-		if (req->remain > PAGE_SIZE - req->offset)
-			size = PAGE_SIZE - req->offset;
-		else
-			size = req->remain;
-		call->iov_len = size;
-		call->bvec[0].bv_len = size;
-		call->bvec[0].bv_offset = req->offset;
-		call->bvec[0].bv_page = req->pages[req->index];
-		iov_iter_bvec(&call->def_iter, READ, call->bvec, 1, size);
-		ASSERTCMP(size, <=, PAGE_SIZE);
+		call->iter = req->iter;
+		call->iov_len = min(req->actual_len, req->len);
 		/* Fall through */
 
 		/* extract the returned data */
 	case 2:
 		_debug("extract data %zu/%llu",
-		       iov_iter_count(call->iter), req->remain);
+		       iov_iter_count(call->iter), req->actual_len);
 
 		ret = afs_extract_data(call, true);
 		if (ret < 0)
 			return ret;
-		req->remain -= call->bvec[0].bv_len;
-		req->offset += call->bvec[0].bv_len;
-		ASSERTCMP(req->offset, <=, PAGE_SIZE);
-		if (req->offset == PAGE_SIZE) {
-			req->offset = 0;
-			if (req->page_done)
-				req->page_done(req);
-			req->index++;
-			if (req->remain > 0)
-				goto begin_page;
-		}
 
-		ASSERTCMP(req->remain, ==, 0);
+		call->iter = &call->def_iter;
 		if (req->actual_len <= req->len)
 			goto no_more_data;
 
@@ -552,14 +531,8 @@ static int yfs_deliver_fs_fetch_data64(struct afs_call *call)
 		break;
 	}
 
-	for (; req->index < req->nr_pages; req->index++) {
-		if (req->offset < PAGE_SIZE)
-			zero_user_segment(req->pages[req->index],
-					  req->offset, PAGE_SIZE);
-		if (req->page_done)
-			req->page_done(req);
-		req->offset = 0;
-	}
+	if (req->done)
+		req->done(req);
 
 	_leave(" = 0 [done]");
 	return 0;


