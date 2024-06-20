Return-Path: <ceph-devel+bounces-1481-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B15A910F0D
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2024 19:40:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0BFB1F22A95
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2024 17:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB5C51C0DC2;
	Thu, 20 Jun 2024 17:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dH1T4xoM"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032211B29BE
	for <ceph-devel@vger.kernel.org>; Thu, 20 Jun 2024 17:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718904785; cv=none; b=rZ0qDoWQfl+cIb8hIdYuyy7qdM8HIMFPmhfP/BYzPJ7f/6zpyaNziEELKX2u5DB0o1PFFdLaEgGqK1t0HUFD7TIUg04zKXB/RN17iYf8/yFjsPy7XCyHLWXuUoU0LPMQF2dCu15djQD4BsrK+ITOKTjDtw6FsuJaF1QoE+yOVLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718904785; c=relaxed/simple;
	bh=eQA2m+/oh5puIWGDHPkbWIqBNxkv0PR5UIbNP0fwDzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHNbZlYQwwqg6R+96yGAFAfRo9aLkXJ7LKqM31yN0B6J7JZ9SVu6BB0AkNAOy/y78po0cdvusQPhvnNKX616dln/lqQSUGV6B8WzyASOy0UxLDt7xMcRB9oEMBBCxT+P+szFgHziWDqeKoxbNqvAtUj5FagnzWLGc1PGt3IlwII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dH1T4xoM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718904783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JsgLdDMxlbFRDEl04HJEi9WqLkbVt68ZbQT1Q/QXXG4=;
	b=dH1T4xoMyBxm1RERpTdYY+leHFreaTBqDheqSsng6b4sL4IDgcK5sqaiLq2pe56HhSkiCm
	0eGAP+lZtPsc0g+5fqblitr8acOZ/CPq5gyiLgKHLYO8ps2veL1T/pCI0RgksXiNKppN10
	HiVwwE4USC6gcCdX8UTriGOU68iKU/g=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-324-4DqBux0nMw2-JdVI-Ia2qg-1; Thu,
 20 Jun 2024 13:32:58 -0400
X-MC-Unique: 4DqBux0nMw2-JdVI-Ia2qg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D829719560AD;
	Thu, 20 Jun 2024 17:32:55 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.39.195.156])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C147319560B0;
	Thu, 20 Jun 2024 17:32:49 +0000 (UTC)
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
Subject: [PATCH 08/17] netfs: Delete some xarray-wangling functions that aren't used
Date: Thu, 20 Jun 2024 18:31:26 +0100
Message-ID: <20240620173137.610345-9-dhowells@redhat.com>
In-Reply-To: <20240620173137.610345-1-dhowells@redhat.com>
References: <20240620173137.610345-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Delete some xarray-based buffer wangling functions that are intended for
use with bounce buffering, but aren't used because bounce-buffering got
deferred to a later patch series.  Now, however, the intention is to use
something other than an xarray to do this.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/internal.h |  9 -----
 fs/netfs/misc.c     | 81 ---------------------------------------------
 2 files changed, 90 deletions(-)

diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index 42443d99967d..a44d480a0fa2 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -63,15 +63,6 @@ static inline void netfs_proc_del_rreq(struct netfs_io_request *rreq) {}
 /*
  * misc.c
  */
-#define NETFS_FLAG_PUT_MARK		BIT(0)
-#define NETFS_FLAG_PAGECACHE_MARK	BIT(1)
-int netfs_xa_store_and_mark(struct xarray *xa, unsigned long index,
-			    struct folio *folio, unsigned int flags,
-			    gfp_t gfp_mask);
-int netfs_add_folios_to_buffer(struct xarray *buffer,
-			       struct address_space *mapping,
-			       pgoff_t index, pgoff_t to, gfp_t gfp_mask);
-void netfs_clear_buffer(struct xarray *buffer);
 
 /*
  * objects.c
diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
index bc1fc54fb724..83e644bd518f 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -8,87 +8,6 @@
 #include <linux/swap.h>
 #include "internal.h"
 
-/*
- * Attach a folio to the buffer and maybe set marks on it to say that we need
- * to put the folio later and twiddle the pagecache flags.
- */
-int netfs_xa_store_and_mark(struct xarray *xa, unsigned long index,
-			    struct folio *folio, unsigned int flags,
-			    gfp_t gfp_mask)
-{
-	XA_STATE_ORDER(xas, xa, index, folio_order(folio));
-
-retry:
-	xas_lock(&xas);
-	for (;;) {
-		xas_store(&xas, folio);
-		if (!xas_error(&xas))
-			break;
-		xas_unlock(&xas);
-		if (!xas_nomem(&xas, gfp_mask))
-			return xas_error(&xas);
-		goto retry;
-	}
-
-	if (flags & NETFS_FLAG_PUT_MARK)
-		xas_set_mark(&xas, NETFS_BUF_PUT_MARK);
-	if (flags & NETFS_FLAG_PAGECACHE_MARK)
-		xas_set_mark(&xas, NETFS_BUF_PAGECACHE_MARK);
-	xas_unlock(&xas);
-	return xas_error(&xas);
-}
-
-/*
- * Create the specified range of folios in the buffer attached to the read
- * request.  The folios are marked with NETFS_BUF_PUT_MARK so that we know that
- * these need freeing later.
- */
-int netfs_add_folios_to_buffer(struct xarray *buffer,
-			       struct address_space *mapping,
-			       pgoff_t index, pgoff_t to, gfp_t gfp_mask)
-{
-	struct folio *folio;
-	int ret;
-
-	if (to + 1 == index) /* Page range is inclusive */
-		return 0;
-
-	do {
-		/* TODO: Figure out what order folio can be allocated here */
-		folio = filemap_alloc_folio(readahead_gfp_mask(mapping), 0);
-		if (!folio)
-			return -ENOMEM;
-		folio->index = index;
-		ret = netfs_xa_store_and_mark(buffer, index, folio,
-					      NETFS_FLAG_PUT_MARK, gfp_mask);
-		if (ret < 0) {
-			folio_put(folio);
-			return ret;
-		}
-
-		index += folio_nr_pages(folio);
-	} while (index <= to && index != 0);
-
-	return 0;
-}
-
-/*
- * Clear an xarray buffer, putting a ref on the folios that have
- * NETFS_BUF_PUT_MARK set.
- */
-void netfs_clear_buffer(struct xarray *buffer)
-{
-	struct folio *folio;
-	XA_STATE(xas, buffer, 0);
-
-	rcu_read_lock();
-	xas_for_each_marked(&xas, folio, ULONG_MAX, NETFS_BUF_PUT_MARK) {
-		folio_put(folio);
-	}
-	rcu_read_unlock();
-	xa_destroy(buffer);
-}
-
 /**
  * netfs_dirty_folio - Mark folio dirty and pin a cache object for writeback
  * @mapping: The mapping the folio belongs to.


