Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AE51E8197
	for <lists+ceph-devel@lfdr.de>; Fri, 29 May 2020 17:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgE2PUQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 29 May 2020 11:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbgE2PT5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 29 May 2020 11:19:57 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8906AC08C5CA
        for <ceph-devel@vger.kernel.org>; Fri, 29 May 2020 08:19:56 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id k8so2029006edq.4
        for <ceph-devel@vger.kernel.org>; Fri, 29 May 2020 08:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YEcKGFOGw1I9vaRJMaoops5/vE1w/jgO+sLZD29F5gA=;
        b=rT6OwhkzkbSN2qAWzJ215h4dWn7UjZj1NzndZ42iHinEMpeKJEMEirPRi+i+AqgS4B
         U8IIk5ZY2CrYS/3s8qlPDQ+0OYcDmr4yeaRPoOuWS6zwetF2SBoXlVU3jjDLbmzvMV7C
         AV5QGu/ybjLIBNaheUhL1jsm/K3jk16UhSnQVyAMDpEFcNTGCIWxxwPEEZmFNmI7lrlO
         86DSkB/n4Xbdoi0RQSsMl0vVC3lIqYmLj1nVZTHi1YYkeM6+Rj4z4K7FiVwCOpI2/Bub
         kSi/fdQ3bcIPBFKyBEyxhroESib8KJtHvweUeby3Jy6WD26cBqG+AKM5sRr7eP17oxfB
         O19w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YEcKGFOGw1I9vaRJMaoops5/vE1w/jgO+sLZD29F5gA=;
        b=Vhe7KQWIzoVrUu0PWUe5U274h3nnA3dlmwRVAOHoiypgVMq4Ua9cV58Bl6raT5LexT
         1aTfEW3Ta5JjtvuIlDlOA3Wdb131Y4pRDjzSY9qlKx2hYNZvxkpBHUeNT9ISu7Ws7bM4
         HhMRaf5Tq03VDtz4IcIadkf9n17zCuYCm52AvliR08metjeRcJXKgrf2xe9loftsD2wz
         LU5Y7DyJ/8goyNOn0cOomoE7MeqQzExdB/ehxJcnh8P0LQV9QLJpxYycF5OwnsjSwXGM
         sSk36kTIw+uEDQgQpU6D4laDAyhfYW2TTRzOtP/GFkNb//q5PW2mQLcTgpbaK/siTp7k
         3Ttw==
X-Gm-Message-State: AOAM531iY+YCuzxP5Fo45CzXQ+D2CX8S05qxcB/g7Jb7dxsSp4LsUxhT
        a2qJm+rv0TBoHQ0v71kKgoQN5l9fEkQ=
X-Google-Smtp-Source: ABdhPJzEfQ61I5ioZtE1AghBVWu0K6NDKLKdK7f6BH5UtLYrc5SmOWKrZFyy/nsAG71t4okofsvVSw==
X-Received: by 2002:a50:a7a5:: with SMTP id i34mr8618807edc.55.1590765594827;
        Fri, 29 May 2020 08:19:54 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id cd17sm6616663ejb.115.2020.05.29.08.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 08:19:54 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 2/5] libceph: decode CRUSH device/bucket types and names
Date:   Fri, 29 May 2020 17:19:49 +0200
Message-Id: <20200529151952.15184-3-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200529151952.15184-1-idryomov@gmail.com>
References: <20200529151952.15184-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

These would be matched with the provided client location to calculate
the locality value.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 include/linux/crush/crush.h |  6 +++
 net/ceph/crush/crush.c      |  3 ++
 net/ceph/osdmap.c           | 85 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 92 insertions(+), 2 deletions(-)

diff --git a/include/linux/crush/crush.h b/include/linux/crush/crush.h
index 38b0e4d50ed9..29b0de2e202b 100644
--- a/include/linux/crush/crush.h
+++ b/include/linux/crush/crush.h
@@ -301,6 +301,12 @@ struct crush_map {
 
 	__u32 *choose_tries;
 #else
+	/* device/bucket type id -> type name (CrushWrapper::type_map) */
+	struct rb_root type_names;
+
+	/* device/bucket id -> name (CrushWrapper::name_map) */
+	struct rb_root names;
+
 	/* CrushWrapper::choose_args */
 	struct rb_root choose_args;
 #endif
diff --git a/net/ceph/crush/crush.c b/net/ceph/crush/crush.c
index 3d70244bc1b6..2e6b29fa8518 100644
--- a/net/ceph/crush/crush.c
+++ b/net/ceph/crush/crush.c
@@ -2,6 +2,7 @@
 #ifdef __KERNEL__
 # include <linux/slab.h>
 # include <linux/crush/crush.h>
+void clear_crush_names(struct rb_root *root);
 void clear_choose_args(struct crush_map *c);
 #else
 # include "crush_compat.h"
@@ -130,6 +131,8 @@ void crush_destroy(struct crush_map *map)
 #ifndef __KERNEL__
 	kfree(map->choose_tries);
 #else
+	clear_crush_names(&map->type_names);
+	clear_crush_names(&map->names);
 	clear_choose_args(map);
 #endif
 	kfree(map);
diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index 5d00ce2b5339..e74130876d3a 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -138,6 +138,79 @@ static int crush_decode_straw2_bucket(void **p, void *end,
 	return -EINVAL;
 }
 
+struct crush_name_node {
+	struct rb_node cn_node;
+	int cn_id;
+	char cn_name[];
+};
+
+static struct crush_name_node *alloc_crush_name(size_t name_len)
+{
+	struct crush_name_node *cn;
+
+	cn = kmalloc(sizeof(*cn) + name_len + 1, GFP_NOIO);
+	if (!cn)
+		return NULL;
+
+	RB_CLEAR_NODE(&cn->cn_node);
+	return cn;
+}
+
+static void free_crush_name(struct crush_name_node *cn)
+{
+	WARN_ON(!RB_EMPTY_NODE(&cn->cn_node));
+
+	kfree(cn);
+}
+
+DEFINE_RB_FUNCS(crush_name, struct crush_name_node, cn_id, cn_node)
+
+static int decode_crush_names(void **p, void *end, struct rb_root *root)
+{
+	u32 n;
+
+	ceph_decode_32_safe(p, end, n, e_inval);
+	while (n--) {
+		struct crush_name_node *cn;
+		int id;
+		u32 name_len;
+
+		ceph_decode_32_safe(p, end, id, e_inval);
+		ceph_decode_32_safe(p, end, name_len, e_inval);
+		ceph_decode_need(p, end, name_len, e_inval);
+
+		cn = alloc_crush_name(name_len);
+		if (!cn)
+			return -ENOMEM;
+
+		cn->cn_id = id;
+		memcpy(cn->cn_name, *p, name_len);
+		cn->cn_name[name_len] = '\0';
+		*p += name_len;
+
+		if (!__insert_crush_name(root, cn)) {
+			free_crush_name(cn);
+			return -EEXIST;
+		}
+	}
+
+	return 0;
+
+e_inval:
+	return -EINVAL;
+}
+
+void clear_crush_names(struct rb_root *root)
+{
+	while (!RB_EMPTY_ROOT(root)) {
+		struct crush_name_node *cn =
+		    rb_entry(rb_first(root), struct crush_name_node, cn_node);
+
+		erase_crush_name(root, cn);
+		free_crush_name(cn);
+	}
+}
+
 static struct crush_choose_arg_map *alloc_choose_arg_map(void)
 {
 	struct crush_choose_arg_map *arg_map;
@@ -354,6 +427,8 @@ static struct crush_map *crush_decode(void *pbyval, void *end)
 	if (c == NULL)
 		return ERR_PTR(-ENOMEM);
 
+	c->type_names = RB_ROOT;
+	c->names = RB_ROOT;
 	c->choose_args = RB_ROOT;
 
         /* set tunables to default values */
@@ -510,8 +585,14 @@ static struct crush_map *crush_decode(void *pbyval, void *end)
 		}
 	}
 
-	ceph_decode_skip_map(p, end, 32, string, bad); /* type_map */
-	ceph_decode_skip_map(p, end, 32, string, bad); /* name_map */
+	err = decode_crush_names(p, end, &c->type_names);
+	if (err)
+		goto fail;
+
+	err = decode_crush_names(p, end, &c->names);
+	if (err)
+		goto fail;
+
 	ceph_decode_skip_map(p, end, 32, string, bad); /* rule_name_map */
 
         /* tunables */
-- 
2.19.2

