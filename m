Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C28477888
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Dec 2021 17:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239549AbhLPQWL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Dec 2021 11:22:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23647 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239794AbhLPQWH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 11:22:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639671727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BKFfNCdyLxK7TJmSVkoedTwtCAhulYTib2ADJFc6mJ4=;
        b=dEVeIQHmqMNmX44ykLmTRfj7pIZWh1gLOoO+jSW4GCb2NG7QpIpUjh65Cz4s2F7cqpHnM5
        zlkfmjLgXygdzWuMPOnnuw+MczIVB9gPl5k1uFXhOnClPAjTElLB5z6GzYCsnI1kJGkCjN
        U49bO2PTH+BWZm2a9NaDpmEyL0WV1/U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-F0TJpfgOMTWC332uDjiC6A-1; Thu, 16 Dec 2021 11:22:01 -0500
X-MC-Unique: F0TJpfgOMTWC332uDjiC6A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CD0964083;
        Thu, 16 Dec 2021 16:21:58 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 25D8E1037F42;
        Thu, 16 Dec 2021 16:21:37 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH v3 56/68] afs: Handle len being extending over page end in
 write_begin/write_end
From:   David Howells <dhowells@redhat.com>
To:     linux-cachefs@redhat.com
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jeff Layton <jlayton@kernel.org>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Jeff Layton <jlayton@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Omar Sandoval <osandov@osandov.com>,
        JeffleXu <jefflexu@linux.alibaba.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-afs@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 16 Dec 2021 16:21:37 +0000
Message-ID: <163967169723.1823006.2868573008412053995.stgit@warthog.procyon.org.uk>
In-Reply-To: <163967073889.1823006.12237147297060239168.stgit@warthog.procyon.org.uk>
References: <163967073889.1823006.12237147297060239168.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

With transparent huge pages, in the future, write_begin() and write_end()
may be passed a length parameter that, in combination with the offset into
the page, exceeds the length of that page.  This allows
grab_cache_page_write_begin() to better choose the size of THP to allocate.

Fix afs's functions to handle this by trimming the length as needed after
the page has been allocated.

[Removed the now-unnecessary index var; spotted by kernel test robot]

Fixes: e1b1240c1ff5 ("netfs: Add write_begin helper")
Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Jeff Layton <jlayton@kernel.org>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/162367681795.460125.11729955608839747375.stgit@warthog.procyon.org.uk/ # v1
Link: https://lore.kernel.org/r/163819657068.215744.601051542491746150.stgit@warthog.procyon.org.uk/ # v1
Link: https://lore.kernel.org/r/163906965274.143852.11487892388439890377.stgit@warthog.procyon.org.uk/ # v2
---

 fs/afs/write.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index ca4909baf5e6..8e4e87d66855 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -25,7 +25,8 @@ int afs_set_page_dirty(struct page *page)
 }
 
 /*
- * prepare to perform part of a write to a page
+ * Prepare to perform part of a write to a page.  Note that len may extend
+ * beyond the end of the page.
  */
 int afs_write_begin(struct file *file, struct address_space *mapping,
 		    loff_t pos, unsigned len, unsigned flags,
@@ -36,7 +37,6 @@ int afs_write_begin(struct file *file, struct address_space *mapping,
 	unsigned long priv;
 	unsigned f, from;
 	unsigned t, to;
-	pgoff_t index;
 	int ret;
 
 	_enter("{%llx:%llu},%llx,%x",
@@ -51,8 +51,8 @@ int afs_write_begin(struct file *file, struct address_space *mapping,
 	if (ret < 0)
 		return ret;
 
-	index = folio_index(folio);
-	from = pos - index * PAGE_SIZE;
+	from = offset_in_folio(folio, pos);
+	len = min_t(size_t, len, folio_size(folio) - from);
 	to = from + len;
 
 try_again:
@@ -103,7 +103,8 @@ int afs_write_begin(struct file *file, struct address_space *mapping,
 }
 
 /*
- * finalise part of a write to a page
+ * Finalise part of a write to a page.  Note that len may extend beyond the end
+ * of the page.
  */
 int afs_write_end(struct file *file, struct address_space *mapping,
 		  loff_t pos, unsigned len, unsigned copied,


