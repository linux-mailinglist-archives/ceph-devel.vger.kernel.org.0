Return-Path: <ceph-devel+bounces-1888-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3380D991BB3
	for <lists+ceph-devel@lfdr.de>; Sun,  6 Oct 2024 03:20:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D043928330F
	for <lists+ceph-devel@lfdr.de>; Sun,  6 Oct 2024 01:20:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E68DB658;
	Sun,  6 Oct 2024 01:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="TUS8utDz"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E561EBE6C;
	Sun,  6 Oct 2024 01:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728177602; cv=none; b=n98pig9T6xTG8UnDxC+YdznMUlzg0osPpR4mdcU4mDA9Ds5CO3PY4th9Yep4VO3aJGZkGBp12kO4hwYIedoa3cvWFoVqhVHMGVm8XAzAqsOU7UbzIPFdZX4+ScRaqKUSvBaqFkpqUKbfcrgCEI1TLPPJomLxGCASEyXggMG9WB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728177602; c=relaxed/simple;
	bh=UJViJazAd2ZGpzntsVOHSEhvQLlHJxCERyFncInudHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hI/J1OgwEYjDSNN2EPQqzd5w6q/Q9qWU61uYMnl8X1c0MHKYYurVTuXCWYFLl/hWGHe9sKBJyPICCaAVQGxb9tuT9//DUeijTTEl7CIB4Vq/ivOfQhdWigTJk4EJwr4C8D1q7KEQU5YV+NKswhImhimvdgORIUTiXMR1RB6Xqb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=TUS8utDz; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=vC4l2UYKZpyNu5umgYrgsjnU5De5FjNDCKiJd63mSeI=; b=TUS8utDzeN3s+pkB
	ef6wovvrv2TUOt8gb9fAx8kc0bshTeL8PSP5GzgsANf2Jc79VgieFbPflYDq4YlQAoPnX2adwpQQ0
	BdzaqkcT+GRA8fMbFOfrqkX2ywM0gkUbN6OUtqVPUKpChuFcI9rgzfi734PxUcHTMDx0L2sdfeP1p
	dUKvTKeWU3yHWtVmzEF1qwPDjNbvXglsQvTqGJfjPX+zJfYT/v+1z0wdPCditCmzevMbgzXxdpEJ+
	dp39Z7l/y71em2lCa9kekBwxF9aNSlmmn9JZpxXEWKF/tv0yUSj+pctLoDY8//6uq3/QszIe6hR98
	9eSR5YwkZCvNZruCCQ==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1sxFwE-009DsK-0V;
	Sun, 06 Oct 2024 01:19:58 +0000
From: linux@treblig.org
To: xiubli@redhat.com,
	idryomov@gmail.com,
	ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 1/5] libceph: Remove unused ceph_pagelist functions
Date: Sun,  6 Oct 2024 02:19:52 +0100
Message-ID: <20241006011956.373622-2-linux@treblig.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241006011956.373622-1-linux@treblig.org>
References: <20241006011956.373622-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

ceph_pagelist_truncate() and ceph_pagelist_set_cursor() have been unused
since commit
39be95e9c8c0 ("ceph: ceph_pagelist_append might sleep while atomic")

Remove them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
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
index 74622b278d57..5a9c4be5f222 100644
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
2.46.2


