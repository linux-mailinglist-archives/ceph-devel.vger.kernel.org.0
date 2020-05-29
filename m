Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD4A1E819A
	for <lists+ceph-devel@lfdr.de>; Fri, 29 May 2020 17:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgE2PUS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 29 May 2020 11:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727112AbgE2PTz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 29 May 2020 11:19:55 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8756FC08C5C9
        for <ceph-devel@vger.kernel.org>; Fri, 29 May 2020 08:19:55 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id f7so2438007ejq.6
        for <ceph-devel@vger.kernel.org>; Fri, 29 May 2020 08:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ov7nxW5TiLjWSwfVp/IQQ5hYY/XlVfFLR6R+V2uXe3A=;
        b=ASa5ogceyK26dyH7cjaMx3wnhPk4gK3LERI2nbAyYJNZJfgltsIyAViatQV4+WN4NH
         ogCf30Jmz0KiatW3zlSq2dYNUpWzFyAsXkM/2U8GxJiE2jvbjJ/TMDoVWgfkGMrDp5MH
         HBw0X3WC6WYnOuj9mwIrqVg6he/bqjfJPcAqqBsTyFbe3SQL2DOw3B3flDdXU6/m+VcL
         u5dQGaTyT0vKFJX8xlkSJivANtZtWE1oYIknS4QPcmrHtyhX+QplSI7dCxq5alnlj/QM
         IC3kpAlv9rjBFxeMaMRs6soB6mdhp8cxAELzYeRsIe9Axnpz7eanm6oqig3HFJfeHrfS
         INxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ov7nxW5TiLjWSwfVp/IQQ5hYY/XlVfFLR6R+V2uXe3A=;
        b=bcM0wntsTYF2/okf3Mu4o+NoM9h7b2moXJ3LWoE6bBLKb4XK74BffnI6oq39mfnEMy
         3UKtNZ9LkY2oUQ+sqD7qSKkllaD0pb/6joRblqS8TaD6uqfm7OSIiMmlkmX+igSNjc65
         Yd/OSRYy847yc6izmTCfofjXl9ZDiiFZSP8g0U24mHcRNrbCTI4n/wvJB5v7IBm+4Joh
         X111jchhBTaf/wHvO44oyUKiup2MHZnQjAhZvO+pi7S7ocPX2w9HJHi0qDciMG495Xiz
         0axLEsCDi9MT+/2cmRDXsHOA7Y2sM2xb/j5cLmohMckbOg8Iq0cSEtGgEF7UUZFaeKLj
         SH4Q==
X-Gm-Message-State: AOAM530NKuFZP/JJKx5lsiOW4P4+LaUriDrB3ANBJVS0nZLWl8ok+CCp
        6rns0Ll2CGEbK3509CyYd2V7pXB7e88=
X-Google-Smtp-Source: ABdhPJzXcTqTSzPybkFi6HuSKe5frUhxMKA5QzvtHzHBMsuLeDOqP+jZBmxAr9SR63xG5dFe1RLxAA==
X-Received: by 2002:a17:906:ae93:: with SMTP id md19mr8174076ejb.4.1590765593838;
        Fri, 29 May 2020 08:19:53 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id cd17sm6616663ejb.115.2020.05.29.08.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 08:19:53 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 1/5] libceph: add non-asserting rbtree insertion helper
Date:   Fri, 29 May 2020 17:19:48 +0200
Message-Id: <20200529151952.15184-2-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200529151952.15184-1-idryomov@gmail.com>
References: <20200529151952.15184-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Needed for the next commit and useful for ceph_pg_pool_info tree as
well.  I'm leaving the asserting helper in for now, but we should look
at getting rid of it in the future.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 include/linux/ceph/libceph.h | 10 ++++--
 net/ceph/osdmap.c            | 60 +++++++-----------------------------
 2 files changed, 19 insertions(+), 51 deletions(-)

diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 525b7c3f1c81..4b5a47bcaba4 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -188,7 +188,7 @@ static inline int calc_pages_for(u64 off, u64 len)
 #define RB_CMP3WAY(a, b) ((a) < (b) ? -1 : (a) > (b))
 
 #define DEFINE_RB_INSDEL_FUNCS2(name, type, keyfld, cmpexp, keyexp, nodefld) \
-static void insert_##name(struct rb_root *root, type *t)		\
+static bool __insert_##name(struct rb_root *root, type *t)		\
 {									\
 	struct rb_node **n = &root->rb_node;				\
 	struct rb_node *parent = NULL;					\
@@ -206,11 +206,17 @@ static void insert_##name(struct rb_root *root, type *t)		\
 		else if (cmp > 0)					\
 			n = &(*n)->rb_right;				\
 		else							\
-			BUG();						\
+			return false;					\
 	}								\
 									\
 	rb_link_node(&t->nodefld, parent, n);				\
 	rb_insert_color(&t->nodefld, root);				\
+	return true;							\
+}									\
+static void __maybe_unused insert_##name(struct rb_root *root, type *t)	\
+{									\
+	if (!__insert_##name(root, t))					\
+		BUG();							\
 }									\
 static void erase_##name(struct rb_root *root, type *t)			\
 {									\
diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index 2a6e63a8edbe..5d00ce2b5339 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -636,48 +636,11 @@ DEFINE_RB_FUNCS2(pg_mapping, struct ceph_pg_mapping, pgid, ceph_pg_compare,
 /*
  * rbtree of pg pool info
  */
-static int __insert_pg_pool(struct rb_root *root, struct ceph_pg_pool_info *new)
-{
-	struct rb_node **p = &root->rb_node;
-	struct rb_node *parent = NULL;
-	struct ceph_pg_pool_info *pi = NULL;
-
-	while (*p) {
-		parent = *p;
-		pi = rb_entry(parent, struct ceph_pg_pool_info, node);
-		if (new->id < pi->id)
-			p = &(*p)->rb_left;
-		else if (new->id > pi->id)
-			p = &(*p)->rb_right;
-		else
-			return -EEXIST;
-	}
-
-	rb_link_node(&new->node, parent, p);
-	rb_insert_color(&new->node, root);
-	return 0;
-}
-
-static struct ceph_pg_pool_info *__lookup_pg_pool(struct rb_root *root, u64 id)
-{
-	struct ceph_pg_pool_info *pi;
-	struct rb_node *n = root->rb_node;
-
-	while (n) {
-		pi = rb_entry(n, struct ceph_pg_pool_info, node);
-		if (id < pi->id)
-			n = n->rb_left;
-		else if (id > pi->id)
-			n = n->rb_right;
-		else
-			return pi;
-	}
-	return NULL;
-}
+DEFINE_RB_FUNCS(pg_pool, struct ceph_pg_pool_info, id, node)
 
 struct ceph_pg_pool_info *ceph_pg_pool_by_id(struct ceph_osdmap *map, u64 id)
 {
-	return __lookup_pg_pool(&map->pg_pools, id);
+	return lookup_pg_pool(&map->pg_pools, id);
 }
 
 const char *ceph_pg_pool_name_by_id(struct ceph_osdmap *map, u64 id)
@@ -690,8 +653,7 @@ const char *ceph_pg_pool_name_by_id(struct ceph_osdmap *map, u64 id)
 	if (WARN_ON_ONCE(id > (u64) INT_MAX))
 		return NULL;
 
-	pi = __lookup_pg_pool(&map->pg_pools, (int) id);
-
+	pi = lookup_pg_pool(&map->pg_pools, id);
 	return pi ? pi->name : NULL;
 }
 EXPORT_SYMBOL(ceph_pg_pool_name_by_id);
@@ -714,14 +676,14 @@ u64 ceph_pg_pool_flags(struct ceph_osdmap *map, u64 id)
 {
 	struct ceph_pg_pool_info *pi;
 
-	pi = __lookup_pg_pool(&map->pg_pools, id);
+	pi = lookup_pg_pool(&map->pg_pools, id);
 	return pi ? pi->flags : 0;
 }
 EXPORT_SYMBOL(ceph_pg_pool_flags);
 
 static void __remove_pg_pool(struct rb_root *root, struct ceph_pg_pool_info *pi)
 {
-	rb_erase(&pi->node, root);
+	erase_pg_pool(root, pi);
 	kfree(pi->name);
 	kfree(pi);
 }
@@ -903,7 +865,7 @@ static int decode_pool_names(void **p, void *end, struct ceph_osdmap *map)
 		ceph_decode_32_safe(p, end, len, bad);
 		dout("  pool %llu len %d\n", pool, len);
 		ceph_decode_need(p, end, len, bad);
-		pi = __lookup_pg_pool(&map->pg_pools, pool);
+		pi = lookup_pg_pool(&map->pg_pools, pool);
 		if (pi) {
 			char *name = kstrndup(*p, len, GFP_NOFS);
 
@@ -1154,18 +1116,18 @@ static int __decode_pools(void **p, void *end, struct ceph_osdmap *map,
 
 		ceph_decode_64_safe(p, end, pool, e_inval);
 
-		pi = __lookup_pg_pool(&map->pg_pools, pool);
+		pi = lookup_pg_pool(&map->pg_pools, pool);
 		if (!incremental || !pi) {
 			pi = kzalloc(sizeof(*pi), GFP_NOFS);
 			if (!pi)
 				return -ENOMEM;
 
+			RB_CLEAR_NODE(&pi->node);
 			pi->id = pool;
 
-			ret = __insert_pg_pool(&map->pg_pools, pi);
-			if (ret) {
+			if (!__insert_pg_pool(&map->pg_pools, pi)) {
 				kfree(pi);
-				return ret;
+				return -EEXIST;
 			}
 		}
 
@@ -1829,7 +1791,7 @@ struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end,
 		struct ceph_pg_pool_info *pi;
 
 		ceph_decode_64_safe(p, end, pool, e_inval);
-		pi = __lookup_pg_pool(&map->pg_pools, pool);
+		pi = lookup_pg_pool(&map->pg_pools, pool);
 		if (pi)
 			__remove_pg_pool(&map->pg_pools, pi);
 	}
-- 
2.19.2

