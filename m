Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E320A1B2771
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Apr 2020 15:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgDUNS6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Apr 2020 09:18:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:50002 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728645AbgDUNS6 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 09:18:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DAC56AC5B;
        Tue, 21 Apr 2020 13:18:55 +0000 (UTC)
From:   Roman Penyaev <rpenyaev@suse.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        Roman Penyaev <rpenyaev@suse.de>
Subject: [PATCH 01/16] libceph: remove unused ceph_pagelist_cursor
Date:   Tue, 21 Apr 2020 15:18:35 +0200
Message-Id: <20200421131850.443228-2-rpenyaev@suse.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200421131850.443228-1-rpenyaev@suse.de>
References: <20200421131850.443228-1-rpenyaev@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
---
 include/linux/ceph/pagelist.h | 12 -----------
 net/ceph/pagelist.c           | 38 -----------------------------------
 2 files changed, 50 deletions(-)

diff --git a/include/linux/ceph/pagelist.h b/include/linux/ceph/pagelist.h
index 5dead8486fd8..879bec0863aa 100644
--- a/include/linux/ceph/pagelist.h
+++ b/include/linux/ceph/pagelist.h
@@ -17,12 +17,6 @@ struct ceph_pagelist {
 	refcount_t refcnt;
 };
 
-struct ceph_pagelist_cursor {
-	struct ceph_pagelist *pl;   /* pagelist, for error checking */
-	struct list_head *page_lru; /* page in list */
-	size_t room;		    /* room remaining to reset to */
-};
-
 struct ceph_pagelist *ceph_pagelist_alloc(gfp_t gfp_flags);
 
 extern void ceph_pagelist_release(struct ceph_pagelist *pl);
@@ -33,12 +27,6 @@ extern int ceph_pagelist_reserve(struct ceph_pagelist *pl, size_t space);
 
 extern int ceph_pagelist_free_reserve(struct ceph_pagelist *pl);
 
-extern void ceph_pagelist_set_cursor(struct ceph_pagelist *pl,
-				     struct ceph_pagelist_cursor *c);
-
-extern int ceph_pagelist_truncate(struct ceph_pagelist *pl,
-				  struct ceph_pagelist_cursor *c);
-
 static inline int ceph_pagelist_encode_64(struct ceph_pagelist *pl, u64 v)
 {
 	__le64 ev = cpu_to_le64(v);
diff --git a/net/ceph/pagelist.c b/net/ceph/pagelist.c
index 65e34f78b05d..87074a74d35f 100644
--- a/net/ceph/pagelist.c
+++ b/net/ceph/pagelist.c
@@ -131,41 +131,3 @@ int ceph_pagelist_free_reserve(struct ceph_pagelist *pl)
 	return 0;
 }
 EXPORT_SYMBOL(ceph_pagelist_free_reserve);
-
-/* Create a truncation point. */
-void ceph_pagelist_set_cursor(struct ceph_pagelist *pl,
-			      struct ceph_pagelist_cursor *c)
-{
-	c->pl = pl;
-	c->page_lru = pl->head.prev;
-	c->room = pl->room;
-}
-EXPORT_SYMBOL(ceph_pagelist_set_cursor);
-
-/* Truncate a pagelist to the given point. Move extra pages to reserve.
- * This won't sleep.
- * Returns: 0 on success,
- *          -EINVAL if the pagelist doesn't match the trunc point pagelist
- */
-int ceph_pagelist_truncate(struct ceph_pagelist *pl,
-			   struct ceph_pagelist_cursor *c)
-{
-	struct page *page;
-
-	if (pl != c->pl)
-		return -EINVAL;
-	ceph_pagelist_unmap_tail(pl);
-	while (pl->head.prev != c->page_lru) {
-		page = list_entry(pl->head.prev, struct page, lru);
-		/* move from pagelist to reserve */
-		list_move_tail(&page->lru, &pl->free_list);
-		++pl->num_pages_free;
-	}
-	pl->room = c->room;
-	if (!list_empty(&pl->head)) {
-		page = list_entry(pl->head.prev, struct page, lru);
-		pl->mapped_tail = kmap(page);
-	}
-	return 0;
-}
-EXPORT_SYMBOL(ceph_pagelist_truncate);
-- 
2.24.1

