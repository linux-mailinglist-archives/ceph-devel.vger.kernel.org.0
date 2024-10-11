Return-Path: <ceph-devel+bounces-1895-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E1B9599AEC4
	for <lists+ceph-devel@lfdr.de>; Sat, 12 Oct 2024 00:47:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 51196B22384
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Oct 2024 22:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CCB81D1503;
	Fri, 11 Oct 2024 22:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="NYzjn6q6"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E241322E;
	Fri, 11 Oct 2024 22:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728686864; cv=none; b=vD3tVqlBHGV5+CETR2UdWJPJ3EXek/dRXSTDmTdPHnBWCoj+Uq89sEhYd8f6u1x8/Jerq/+BvzQ+R7f6pvtvFpTMzfKh3h9CQN8Zvw38AhwWGQmuhhTDOP9xwLCbkUppQUzFhKNkGQGLCZu7uH3kn7xJChRqd/wmbN15b+otM4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728686864; c=relaxed/simple;
	bh=wnFR1KMTiXA09NIs9BwaYu51mrqwZTB59Q9vEXxNXso=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SnC5V+UbDL2bF9uiQk09rXG1wkkV/Gyu1YqR8cr9oFepBhjRpa1ic3VhKitNfq4tayqyDJqEH4pyP+rciQQm1hgphzKoYDQKuHXCY5FS2lsn+lEUE+42YTAHESfv7OMZoC9hMwbB8QZFuYk/fYuTZfbFlipafWpAQVCCJrW7cRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=NYzjn6q6; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=9CRHsu/4o39+CfyKz29v8UH0rvLQukqd+SAqdLtdYMw=; b=NYzjn6q6/VZsZOTv
	YuwEHN3T+ilzOSydXXopeNegjUEP7U1aH9arTDN+EUAxCNC3EFZFc9shZURtRnharQMYgsWzAhoh1
	vCD41DNSdT18mmQW8rc9ZGW6a5YbmD0UowPjrY+2DfOw5u6wl2FnHpee3+9TLM7UhfetX0ct3Dru1
	e3s5aS3Y8AaeLxtShcT2Uvi6Q1pid0C9oniQkQvNy6pSnBu9g5vldSq1K4LVQw6u81o5oqzXhf+t2
	ktofP1Hkp3bOfA5PuSAGB2KbIareUsX+BfgRR1XFEPo0xM8t+jPWECH6KegY2N+CqqEBz/5OWXjqp
	WHW1roQkYXvochH4Og==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1szOQ5-00AcNy-2i;
	Fri, 11 Oct 2024 22:47:37 +0000
From: linux@treblig.org
To: idryomov@gmail.com,
	xiubli@redhat.com,
	ceph-devel@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] libceph: Remove crush deadcode
Date: Fri, 11 Oct 2024 23:47:36 +0100
Message-ID: <20241011224736.236863-1-linux@treblig.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

crush_bucket_alg_name(), crush_get_bucket_item_weight(), crush_hash32(),
and crush_hash32_5() were added by commit
5ecc0a0f8128 ("ceph: CRUSH mapping algorithm")
in 2009 but never used.

crush_hash_name() was added a little later by commit
fb690390e305 ("ceph: make CRUSH hash function a bucket property")
and also not used.

Remove them.

They called a couple of static functions crush_hash32_rjenkins1()
and crush_hash32_rjenkins1_5() which are now unused.

Also remove them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 include/linux/crush/crush.h |  2 --
 include/linux/crush/hash.h  |  5 ----
 net/ceph/crush/crush.c      | 37 -----------------------
 net/ceph/crush/hash.c       | 59 -------------------------------------
 4 files changed, 103 deletions(-)

diff --git a/include/linux/crush/crush.h b/include/linux/crush/crush.h
index 30dba392b730..ed26099957df 100644
--- a/include/linux/crush/crush.h
+++ b/include/linux/crush/crush.h
@@ -117,7 +117,6 @@ enum {
 	CRUSH_BUCKET_STRAW = 4,
 	CRUSH_BUCKET_STRAW2 = 5,
 };
-extern const char *crush_bucket_alg_name(int alg);
 
 /*
  * although tree was a legacy algorithm, it has been buggy, so
@@ -314,7 +313,6 @@ struct crush_map {
 
 
 /* crush.c */
-extern int crush_get_bucket_item_weight(const struct crush_bucket *b, int pos);
 extern void crush_destroy_bucket_uniform(struct crush_bucket_uniform *b);
 extern void crush_destroy_bucket_list(struct crush_bucket_list *b);
 extern void crush_destroy_bucket_tree(struct crush_bucket_tree *b);
diff --git a/include/linux/crush/hash.h b/include/linux/crush/hash.h
index 904df41f7847..0ee007a98236 100644
--- a/include/linux/crush/hash.h
+++ b/include/linux/crush/hash.h
@@ -12,13 +12,8 @@
 
 #define CRUSH_HASH_DEFAULT CRUSH_HASH_RJENKINS1
 
-extern const char *crush_hash_name(int type);
-
-extern __u32 crush_hash32(int type, __u32 a);
 extern __u32 crush_hash32_2(int type, __u32 a, __u32 b);
 extern __u32 crush_hash32_3(int type, __u32 a, __u32 b, __u32 c);
 extern __u32 crush_hash32_4(int type, __u32 a, __u32 b, __u32 c, __u32 d);
-extern __u32 crush_hash32_5(int type, __u32 a, __u32 b, __u32 c, __u32 d,
-			    __u32 e);
 
 #endif
diff --git a/net/ceph/crush/crush.c b/net/ceph/crush/crush.c
index 254ded0b05f6..9331f91f1242 100644
--- a/net/ceph/crush/crush.c
+++ b/net/ceph/crush/crush.c
@@ -7,43 +7,6 @@
 # include "crush.h"
 #endif
 
-const char *crush_bucket_alg_name(int alg)
-{
-	switch (alg) {
-	case CRUSH_BUCKET_UNIFORM: return "uniform";
-	case CRUSH_BUCKET_LIST: return "list";
-	case CRUSH_BUCKET_TREE: return "tree";
-	case CRUSH_BUCKET_STRAW: return "straw";
-	case CRUSH_BUCKET_STRAW2: return "straw2";
-	default: return "unknown";
-	}
-}
-
-/**
- * crush_get_bucket_item_weight - Get weight of an item in given bucket
- * @b: bucket pointer
- * @p: item index in bucket
- */
-int crush_get_bucket_item_weight(const struct crush_bucket *b, int p)
-{
-	if ((__u32)p >= b->size)
-		return 0;
-
-	switch (b->alg) {
-	case CRUSH_BUCKET_UNIFORM:
-		return ((struct crush_bucket_uniform *)b)->item_weight;
-	case CRUSH_BUCKET_LIST:
-		return ((struct crush_bucket_list *)b)->item_weights[p];
-	case CRUSH_BUCKET_TREE:
-		return ((struct crush_bucket_tree *)b)->node_weights[crush_calc_tree_node(p)];
-	case CRUSH_BUCKET_STRAW:
-		return ((struct crush_bucket_straw *)b)->item_weights[p];
-	case CRUSH_BUCKET_STRAW2:
-		return ((struct crush_bucket_straw2 *)b)->item_weights[p];
-	}
-	return 0;
-}
-
 void crush_destroy_bucket_uniform(struct crush_bucket_uniform *b)
 {
 	kfree(b->h.items);
diff --git a/net/ceph/crush/hash.c b/net/ceph/crush/hash.c
index fe79f6d2d0db..33792c0ea132 100644
--- a/net/ceph/crush/hash.c
+++ b/net/ceph/crush/hash.c
@@ -24,17 +24,6 @@
 
 #define crush_hash_seed 1315423911
 
-static __u32 crush_hash32_rjenkins1(__u32 a)
-{
-	__u32 hash = crush_hash_seed ^ a;
-	__u32 b = a;
-	__u32 x = 231232;
-	__u32 y = 1232;
-	crush_hashmix(b, x, hash);
-	crush_hashmix(y, a, hash);
-	return hash;
-}
-
 static __u32 crush_hash32_rjenkins1_2(__u32 a, __u32 b)
 {
 	__u32 hash = crush_hash_seed ^ a ^ b;
@@ -73,34 +62,6 @@ static __u32 crush_hash32_rjenkins1_4(__u32 a, __u32 b, __u32 c, __u32 d)
 	return hash;
 }
 
-static __u32 crush_hash32_rjenkins1_5(__u32 a, __u32 b, __u32 c, __u32 d,
-				      __u32 e)
-{
-	__u32 hash = crush_hash_seed ^ a ^ b ^ c ^ d ^ e;
-	__u32 x = 231232;
-	__u32 y = 1232;
-	crush_hashmix(a, b, hash);
-	crush_hashmix(c, d, hash);
-	crush_hashmix(e, x, hash);
-	crush_hashmix(y, a, hash);
-	crush_hashmix(b, x, hash);
-	crush_hashmix(y, c, hash);
-	crush_hashmix(d, x, hash);
-	crush_hashmix(y, e, hash);
-	return hash;
-}
-
-
-__u32 crush_hash32(int type, __u32 a)
-{
-	switch (type) {
-	case CRUSH_HASH_RJENKINS1:
-		return crush_hash32_rjenkins1(a);
-	default:
-		return 0;
-	}
-}
-
 __u32 crush_hash32_2(int type, __u32 a, __u32 b)
 {
 	switch (type) {
@@ -130,23 +91,3 @@ __u32 crush_hash32_4(int type, __u32 a, __u32 b, __u32 c, __u32 d)
 		return 0;
 	}
 }
-
-__u32 crush_hash32_5(int type, __u32 a, __u32 b, __u32 c, __u32 d, __u32 e)
-{
-	switch (type) {
-	case CRUSH_HASH_RJENKINS1:
-		return crush_hash32_rjenkins1_5(a, b, c, d, e);
-	default:
-		return 0;
-	}
-}
-
-const char *crush_hash_name(int type)
-{
-	switch (type) {
-	case CRUSH_HASH_RJENKINS1:
-		return "rjenkins1";
-	default:
-		return "unknown";
-	}
-}
-- 
2.47.0


