Return-Path: <ceph-devel+bounces-1925-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 51C009AE7AD
	for <lists+ceph-devel@lfdr.de>; Thu, 24 Oct 2024 16:09:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CA1BCB27A17
	for <lists+ceph-devel@lfdr.de>; Thu, 24 Oct 2024 14:09:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8195B1E501B;
	Thu, 24 Oct 2024 14:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eRe2lRu5"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316761E2614
	for <ceph-devel@vger.kernel.org>; Thu, 24 Oct 2024 14:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729778806; cv=none; b=Tivd6ZkwSmGB1B1SUFJh8sV8GuXqBmi+mRn4RLJBSzdl380UzrsQk/RbacoMMUISnTW5BFutm0L+KtT0GsxpchtGI8FLcLZ7oIFVwXj/tOP1YeIHLmVtLJ4Q5GhW9YPHh642KZ/FXjLfvG7Tao+bK0jPmUNVMk8bqekCTK0WgNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729778806; c=relaxed/simple;
	bh=UQe8ZQ4qDdUDDw8GhW5Rtv4v1nSE8XZnkM9jJJQs9Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSuwHVicHXcof4vivyp5gS45XpJPfJx0gBxtUxP9Ec81heIkb40S8bXa90OKjEbXNPLrJKxgrn3tCmy66I1OjT/aJ6TXo6QUX/TLr90g3VPQCx785MwBMBtYnztFo61vR0QP7SW1Q/TgBk1bXwX5fcMJAnm0mnoBlL3g6au9Inc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eRe2lRu5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729778801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DUlYZzbaKUHX76MZjhLNdaJFIvV/RRK5UT5LJFkHe/Y=;
	b=eRe2lRu56iS1vEN9+qY0tHIkdx9CydA/ilAC/iAH/dKyxdqd3+P8B8rld+bVDno8m6hms1
	E6nS+XoszJHhiu6lp/RpixI6OLNRZZYhquIIfzKOm+JO/t2Kc2ncYWDfh9h97qh7BHl2Ew
	wqyZS+xy/mYdzz9O3NENB3EUheVGdEY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-362-dFLyIxx0N0msN1U-ylJXxw-1; Thu,
 24 Oct 2024 10:06:35 -0400
X-MC-Unique: dFLyIxx0N0msN1U-ylJXxw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4BA0C1955F3D;
	Thu, 24 Oct 2024 14:06:28 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.231])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9CB30196BB7D;
	Thu, 24 Oct 2024 14:06:22 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Steve French <smfrench@gmail.com>,
	Matthew Wilcox <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 04/27] netfs: Use a folio_queue allocation and free functions
Date: Thu, 24 Oct 2024 15:05:02 +0100
Message-ID: <20241024140539.3828093-5-dhowells@redhat.com>
In-Reply-To: <20241024140539.3828093-1-dhowells@redhat.com>
References: <20241024140539.3828093-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Provide and use folio_queue allocation and free functions to combine the
allocation, initialisation and stat (un)accounting steps that are repeated
in several places.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c | 12 +++---------
 fs/netfs/misc.c          | 38 ++++++++++++++++++++++++++++++++++----
 include/linux/netfs.h    |  5 +++++
 3 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 7ac34550c403..b5a7beb9d01b 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -131,11 +131,9 @@ static ssize_t netfs_prepare_read_iterator(struct netfs_io_subrequest *subreq)
 			struct folio_queue *tail = rreq->buffer_tail, *new;
 			size_t added;
 
-			new = kmalloc(sizeof(*new), GFP_NOFS);
+			new = netfs_folioq_alloc(GFP_NOFS);
 			if (!new)
 				return -ENOMEM;
-			netfs_stat(&netfs_n_folioq);
-			folioq_init(new);
 			new->prev = tail;
 			tail->next = new;
 			rreq->buffer_tail = new;
@@ -359,11 +357,9 @@ static int netfs_prime_buffer(struct netfs_io_request *rreq)
 	struct folio_batch put_batch;
 	size_t added;
 
-	folioq = kmalloc(sizeof(*folioq), GFP_KERNEL);
+	folioq = netfs_folioq_alloc(GFP_KERNEL);
 	if (!folioq)
 		return -ENOMEM;
-	netfs_stat(&netfs_n_folioq);
-	folioq_init(folioq);
 	rreq->buffer = folioq;
 	rreq->buffer_tail = folioq;
 	rreq->submitted = rreq->start;
@@ -436,12 +432,10 @@ static int netfs_create_singular_buffer(struct netfs_io_request *rreq, struct fo
 {
 	struct folio_queue *folioq;
 
-	folioq = kmalloc(sizeof(*folioq), GFP_KERNEL);
+	folioq = netfs_folioq_alloc(GFP_KERNEL);
 	if (!folioq)
 		return -ENOMEM;
 
-	netfs_stat(&netfs_n_folioq);
-	folioq_init(folioq);
 	folioq_append(folioq, folio);
 	BUG_ON(folioq_folio(folioq, 0) != folio);
 	BUG_ON(folioq_folio_order(folioq, 0) != folio_order(folio));
diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
index 78fe5796b2b2..6cd7e1ee7a14 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -8,6 +8,38 @@
 #include <linux/swap.h>
 #include "internal.h"
 
+/**
+ * netfs_folioq_alloc - Allocate a folio_queue struct
+ * @gfp: Allocation constraints
+ *
+ * Allocate, initialise and account the folio_queue struct.
+ */
+struct folio_queue *netfs_folioq_alloc(gfp_t gfp)
+{
+	struct folio_queue *fq;
+
+	fq = kmalloc(sizeof(*fq), gfp);
+	if (fq) {
+		netfs_stat(&netfs_n_folioq);
+		folioq_init(fq);
+	}
+	return fq;
+}
+EXPORT_SYMBOL(netfs_folioq_alloc);
+
+/**
+ * netfs_folioq_free - Free a folio_queue struct
+ * @folioq: The object to free
+ *
+ * Free and unaccount the folio_queue struct.
+ */
+void netfs_folioq_free(struct folio_queue *folioq)
+{
+	netfs_stat_d(&netfs_n_folioq);
+	kfree(folioq);
+}
+EXPORT_SYMBOL(netfs_folioq_free);
+
 /*
  * Make sure there's space in the rolling queue.
  */
@@ -87,8 +119,7 @@ struct folio_queue *netfs_delete_buffer_head(struct netfs_io_request *wreq)
 
 	if (next)
 		next->prev = NULL;
-	netfs_stat_d(&netfs_n_folioq);
-	kfree(head);
+	netfs_folioq_free(head);
 	wreq->buffer = next;
 	return next;
 }
@@ -111,8 +142,7 @@ void netfs_clear_buffer(struct netfs_io_request *rreq)
 				folio_put(folio);
 			}
 		}
-		netfs_stat_d(&netfs_n_folioq);
-		kfree(p);
+		netfs_folioq_free(p);
 	}
 }
 
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 5eaceef41e6c..b2fa569e875d 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -21,6 +21,7 @@
 
 enum netfs_sreq_ref_trace;
 typedef struct mempool_s mempool_t;
+struct folio_queue;
 
 /**
  * folio_start_private_2 - Start an fscache write on a folio.  [DEPRECATED]
@@ -454,6 +455,10 @@ void netfs_end_io_write(struct inode *inode);
 int netfs_start_io_direct(struct inode *inode);
 void netfs_end_io_direct(struct inode *inode);
 
+/* Miscellaneous APIs. */
+struct folio_queue *netfs_folioq_alloc(gfp_t gfp);
+void netfs_folioq_free(struct folio_queue *folioq);
+
 /**
  * netfs_inode - Get the netfs inode context from the inode
  * @inode: The inode to query


