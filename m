Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03683AECAB
	for <lists+ceph-devel@lfdr.de>; Mon, 21 Jun 2021 17:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhFUPm5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 21 Jun 2021 11:42:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44040 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229837AbhFUPm4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 21 Jun 2021 11:42:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624290042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Go9MX9URt78M8jN2i7z0+0HeUDLUit2ibTF2M8h6Wk=;
        b=G7Fs/freyVM013GxhVoiZ3yr9I3O3cKeRAHLeQC2M6xtdUu+RKqqsUVm7CnLcar30BJ54T
        Ie2IFAwvrnZuSeIFsyuOBJ5pfDz1LbFzmStjqPjTPs5c9m97Va1Ozj+abxxQYj3WBTRz+G
        k7szqYeZXEkKqe+6r5CNrCzVrEMrebE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-5tRt-NQMPAe3z-m_7VMt0A-1; Mon, 21 Jun 2021 11:40:38 -0400
X-MC-Unique: 5tRt-NQMPAe3z-m_7VMt0A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19094800C78;
        Mon, 21 Jun 2021 15:40:37 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-118-65.rdu2.redhat.com [10.10.118.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E6AB860916;
        Mon, 21 Jun 2021 15:40:31 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH v3 2/2] netfs: fix test for whether we can skip read when
 writing beyond EOF
From:   David Howells <dhowells@redhat.com>
To:     linux-cachefs@redhat.com, linux-afs@lists.infradead.org
Cc:     Andrew W Elble <aweits@rit.edu>, Jeff Layton <jlayton@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        ceph-devel@vger.kernel.org, dhowells@redhat.com,
        Jeff Layton <jlayton@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 21 Jun 2021 16:40:31 +0100
Message-ID: <162429003110.2770648.16870905479999978447.stgit@warthog.procyon.org.uk>
In-Reply-To: <162429000639.2770648.6368710175435880749.stgit@warthog.procyon.org.uk>
References: <162429000639.2770648.6368710175435880749.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

It's not sufficient to skip reading when the pos is beyond the EOF.
There may be data at the head of the page that we need to fill in
before the write.

Add a new helper function that corrects and clarifies the logic of
when we can skip reads, and have it only zero out the part of the page
that won't have data copied in for the write.

Finally, don't set the page Uptodate after zeroing. It's not up to date
since the write data won't have been copied in yet.

[DH made the following changes:

 - Prefixed the new function with "netfs_".

 - Don't call zero_user_segments() for a full-page write.

 - Altered the beyond-last-page check to avoid a DIV instruction and got
   rid of then-redundant zero-length file check.
]

Fixes: e1b1240c1ff5f ("netfs: Add write_begin helper")
Reported-by: Andrew W Elble <aweits@rit.edu>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
cc: ceph-devel@vger.kernel.org
Link: https://lore.kernel.org/r/20210613233345.113565-1-jlayton@kernel.org/
Link: https://lore.kernel.org/r/162367683365.460125.4467036947364047314.stgit@warthog.procyon.org.uk/ # v1
Link: https://lore.kernel.org/r/162391826758.1173366.11794946719301590013.stgit@warthog.procyon.org.uk/ # v2
---

 fs/netfs/read_helper.c |   49 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 13 deletions(-)

diff --git a/fs/netfs/read_helper.c b/fs/netfs/read_helper.c
index 725614625ed4..0b6cd3b8734c 100644
--- a/fs/netfs/read_helper.c
+++ b/fs/netfs/read_helper.c
@@ -1011,12 +1011,42 @@ int netfs_readpage(struct file *file,
 }
 EXPORT_SYMBOL(netfs_readpage);
 
-static void netfs_clear_thp(struct page *page)
+/**
+ * netfs_skip_page_read - prep a page for writing without reading first
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
+static bool netfs_skip_page_read(struct page *page, loff_t pos, size_t len)
 {
-	unsigned int i;
+	struct inode *inode = page->mapping->host;
+	loff_t i_size = i_size_read(inode);
+	size_t offset = offset_in_thp(page, pos);
+
+	/* Full page write */
+	if (offset == 0 && len >= thp_size(page))
+		return true;
+
+	/* pos beyond last page in the file */
+	if (pos - offset >= i_size)
+		goto zero_out;
+
+	/* Write that covers from the start of the page to EOF or beyond */
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
@@ -1024,7 +1054,7 @@ static void netfs_clear_thp(struct page *page)
  * @file: The file to read from
  * @mapping: The mapping to read from
  * @pos: File position at which the write will begin
- * @len: The length of the write in this page
+ * @len: The length of the write (may extend beyond the end of the page chosen)
  * @flags: AOP_* flags
  * @_page: Where to put the resultant page
  * @_fsdata: Place for the netfs to store a cookie
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
+	    netfs_skip_page_read(page, pos, len)) {
 		netfs_stat(&netfs_n_rh_write_zskip);
 		goto have_page_no_wait;
 	}


