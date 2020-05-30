Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655641E9256
	for <lists+ceph-devel@lfdr.de>; Sat, 30 May 2020 17:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729063AbgE3Pem (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 30 May 2020 11:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728998AbgE3Pel (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 30 May 2020 11:34:41 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F370C08C5C9
        for <ceph-devel@vger.kernel.org>; Sat, 30 May 2020 08:34:41 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id c71so6626821wmd.5
        for <ceph-devel@vger.kernel.org>; Sat, 30 May 2020 08:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ov7nxW5TiLjWSwfVp/IQQ5hYY/XlVfFLR6R+V2uXe3A=;
        b=IX00kO/Wkv4vxwC9TzZG1HmMd3CClZoR+RzNBpbQFc3g3U5aN7J0Z1mA7oIvUmW9ep
         //5Jk/pzr0vReuCQecdyAkp/KUEZqiRE0UMm2NsHHubPSiyVqULiCp69diYSl/7LrX6c
         SgkVMRSTNBYdcAZdOjzUSyK7T9AFtteHuS9ZPAdVbigq1L7I/K3E+FBjDAHiMYcYubvs
         5eBr/5DpCqQS0hC59RzszOJh4Q6/bo17iq8fmvRs4MjVv7r8YzDK9yA2QrGHkzoduk/A
         n7lOs/dp2Ay0ii8hH05aEc9/HyhPgq1q01LnF92UWoNbEcYeWo5R1TE7wD5e8OxqSgmW
         MKiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ov7nxW5TiLjWSwfVp/IQQ5hYY/XlVfFLR6R+V2uXe3A=;
        b=kjjcSc6ugNgIB84nR1/aYjNiKXnx7TFNqLw/+oZ2aCy6hN0nqZs1L+8gWca6ZPhzhC
         DlIxgMSy5+sufszeFnJZ/mJg9r6ppdY10BOYIRJ/fv+EWJD/vGKkMUQsB/aQKLEmnJ9k
         X8oeclw174cfgXOQ48cEfDaf0uAkoQTOnw69lXCgtwt9b4RfQpb8OxGW/HMhkcyPuy1k
         zfvM+Ju8OlmI9qg75qsFl8tzHdWeOuyYO/cjmeMu+RVqCjA8JJYqora7fg+dkQweEhqH
         6uTChDa9bSLTJD1PM06M/EVL0nBKKDUC99ZYqB+yLmwC+Sb+idJmlxf3FsH6PJBrJI/t
         QgDQ==
X-Gm-Message-State: AOAM533NadLUbceGXkoj+AcaC4ofSNWTXec0uZO0EsMEZQxIQ8MYtoP6
        9FcVJ1uQLstM3lXmcKMfmaiV4BXblZI=
X-Google-Smtp-Source: ABdhPJywx/06vbUTATas8jQ7cZC+DjfwajCz0y28x1lhx9Rlgzj/Q0ZWND6B7/ldGtRcLaIoAOeiag==
X-Received: by 2002:a7b:c3c6:: with SMTP id t6mr6032692wmj.159.1590852879653;
        Sat, 30 May 2020 08:34:39 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id z132sm4835068wmc.29.2020.05.30.08.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 08:34:39 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 1/5] libceph: add non-asserting rbtree insertion helper
Date:   Sat, 30 May 2020 17:34:35 +0200
Message-Id: <20200530153439.31312-2-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200530153439.31312-1-idryomov@gmail.com>
References: <20200530153439.31312-1-idryomov@gmail.com>
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

