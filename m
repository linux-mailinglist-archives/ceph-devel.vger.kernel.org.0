Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98C7347614
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Mar 2021 11:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbhCXK1K (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Mar 2021 06:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbhCXK0m (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 Mar 2021 06:26:42 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4BAC061763;
        Wed, 24 Mar 2021 03:26:41 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id x126so16980721pfc.13;
        Wed, 24 Mar 2021 03:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nf7VchMs6htoZeGSFku0LDUaOmU3BoTimhnUNRW5sjM=;
        b=UrugiYqlrYHF9A0d8xOYXYUfz18X+K526znw1E6RyhmVQMtZeBkv2+7INwHtai7E98
         2b49tQGeMqCPRaqkPGkr8yQlaDLvwOKhvQGgU4eJaCWKraslssyZTfSXZzQHI1jO//Pm
         scwFZBSBmls1ezwP9JOpk+aaFWe7/S+uIy9XX+MIiUZV1WseDXC3eZNVwSg2LXqzI7tP
         4aG5f40mHkYZeCfkYXEer+fmXlimEV0jklgUcYq7fOi5b4dlCoNowThT8gBkvsDJsYB0
         izwKr/0wjUaeByEzySxsbKjfKWnajd0qkZI8aCFY4Buw+mDaf0RWCi9feTJm7+0cnnFB
         Nvxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nf7VchMs6htoZeGSFku0LDUaOmU3BoTimhnUNRW5sjM=;
        b=Bh4YHUYU+mGNdqgss+w3XSjUtkKHL1gOHDnWWp1fqwQ4OsakLZOYIXKom/och1Iun5
         ikS1jvwUMMl2WrLgdfymceNVfyqhTS91vkOpTCTnVPFxo4Uy8TprVDeF6YUffBZbRvRC
         tVgjVnghCaM2BEmEV8Lh2z49gwpLs3uDqy+DoiNkgsgLKoqMQm8iK8TYQDRCqif6ECjV
         a8o7wxS7l+C0Ky5bL+bC4PUwYPdoYPJatka6dFSdJ2fEli+LFR3VQ07Rw2U+x9gNkP2R
         2HLpjHVIiy1T8Lp2fUU6g2CCEdQWLKym1fZ/dozetAbUXXvgEH+HFEYvBbEtXYrR0iZ9
         wJZA==
X-Gm-Message-State: AOAM530tBYYDbEqtTJP5l+ruU3uswdSKBeBN21cncY8MiEH6jObNQrM1
        /hGdbK2KwfNEtolTS2llcfc=
X-Google-Smtp-Source: ABdhPJzOMKcRis0raRH04Lr6r6d9Dp9MSFm1NA3lJP2/qD9Y3CeDKcc0vYhW2tIBGjP9pjeAS3bDwQ==
X-Received: by 2002:a62:e90c:0:b029:203:90f:6f34 with SMTP id j12-20020a62e90c0000b0290203090f6f34mr2534564pfh.29.1616581601428;
        Wed, 24 Mar 2021 03:26:41 -0700 (PDT)
Received: from localhost.localdomain ([122.10.161.207])
        by smtp.gmail.com with ESMTPSA id v27sm2181816pfi.89.2021.03.24.03.26.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Mar 2021 03:26:40 -0700 (PDT)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yejune Deng <yejune.deng@gmail.com>
Subject: [PATCH] ceph: convert {n}ref from atomic_t to refcount_t
Date:   Wed, 24 Mar 2021 18:26:25 +0800
Message-Id: <20210324102625.112640-1-yejune.deng@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

refcount_t type should be used instead of atomic_t when the variable
is used as a reference counter. This is because the implementation of
refcount_t can prevent overflows and detect possible use-after-free.

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 fs/ceph/mds_client.h |  2 +-
 fs/ceph/snap.c       | 27 +++++++++++++++------------
 fs/ceph/super.h      |  2 +-
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index eaa7c5422116..bf99c5ba47fc 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -351,7 +351,7 @@ struct ceph_pool_perm {
 struct ceph_snapid_map {
 	struct rb_node node;
 	struct list_head lru;
-	atomic_t ref;
+	refcount_t ref;
 	u64 snap;
 	dev_t dev;
 	unsigned long last_used;
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 0728b01d4d43..c0fbbb56b259 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -66,14 +66,15 @@ void ceph_get_snap_realm(struct ceph_mds_client *mdsc,
 			 struct ceph_snap_realm *realm)
 {
 	dout("get_realm %p %d -> %d\n", realm,
-	     atomic_read(&realm->nref), atomic_read(&realm->nref)+1);
+	     refcount_read(&realm->nref), refcount_read(&realm->nref)+1);
 	/*
 	 * since we _only_ increment realm refs or empty the empty
 	 * list with snap_rwsem held, adjusting the empty list here is
 	 * safe.  we do need to protect against concurrent empty list
 	 * additions, however.
 	 */
-	if (atomic_inc_return(&realm->nref) == 1) {
+	refcount_inc(&realm->nref);
+	if (refcount_read(&realm->nref) == 1) {
 		spin_lock(&mdsc->snap_empty_lock);
 		list_del_init(&realm->empty_item);
 		spin_unlock(&mdsc->snap_empty_lock);
@@ -117,7 +118,7 @@ static struct ceph_snap_realm *ceph_create_snap_realm(
 	if (!realm)
 		return ERR_PTR(-ENOMEM);
 
-	atomic_set(&realm->nref, 1);    /* for caller */
+	refcount_set(&realm->nref, 1);    /* for caller */
 	realm->ino = ino;
 	INIT_LIST_HEAD(&realm->children);
 	INIT_LIST_HEAD(&realm->child_item);
@@ -199,8 +200,8 @@ static void __put_snap_realm(struct ceph_mds_client *mdsc,
 			     struct ceph_snap_realm *realm)
 {
 	dout("__put_snap_realm %llx %p %d -> %d\n", realm->ino, realm,
-	     atomic_read(&realm->nref), atomic_read(&realm->nref)-1);
-	if (atomic_dec_and_test(&realm->nref))
+	     refcount_read(&realm->nref), refcount_read(&realm->nref)-1);
+	if (refcount_dec_and_test(&realm->nref))
 		__destroy_snap_realm(mdsc, realm);
 }
 
@@ -211,8 +212,8 @@ void ceph_put_snap_realm(struct ceph_mds_client *mdsc,
 			 struct ceph_snap_realm *realm)
 {
 	dout("put_snap_realm %llx %p %d -> %d\n", realm->ino, realm,
-	     atomic_read(&realm->nref), atomic_read(&realm->nref)-1);
-	if (!atomic_dec_and_test(&realm->nref))
+	     refcount_read(&realm->nref), refcount_read(&realm->nref)-1);
+	if (!refcount_dec_and_test(&realm->nref))
 		return;
 
 	if (down_write_trylock(&mdsc->snap_rwsem)) {
@@ -1034,7 +1035,8 @@ struct ceph_snapid_map* ceph_get_snapid_map(struct ceph_mds_client *mdsc,
 		} else if (snap < exist->snap) {
 			p = &(*p)->rb_right;
 		} else {
-			if (atomic_inc_return(&exist->ref) == 1)
+			refcount_inc(&exist->ref);
+			if (refcount_read(&exist->ref) == 1)
 				list_del_init(&exist->lru);
 			break;
 		}
@@ -1057,7 +1059,7 @@ struct ceph_snapid_map* ceph_get_snapid_map(struct ceph_mds_client *mdsc,
 	}
 
 	INIT_LIST_HEAD(&sm->lru);
-	atomic_set(&sm->ref, 1);
+	refcount_set(&sm->ref, 1);
 	sm->snap = snap;
 
 	exist = NULL;
@@ -1076,7 +1078,8 @@ struct ceph_snapid_map* ceph_get_snapid_map(struct ceph_mds_client *mdsc,
 		exist = NULL;
 	}
 	if (exist) {
-		if (atomic_inc_return(&exist->ref) == 1)
+		refcount_inc(&exist->ref);
+		if (refcount_read(&exist->ref) == 1)
 			list_del_init(&exist->lru);
 	} else {
 		rb_link_node(&sm->node, parent, p);
@@ -1099,7 +1102,7 @@ void ceph_put_snapid_map(struct ceph_mds_client* mdsc,
 {
 	if (!sm)
 		return;
-	if (atomic_dec_and_lock(&sm->ref, &mdsc->snapid_map_lock)) {
+	if (refcount_dec_and_lock(&sm->ref, &mdsc->snapid_map_lock)) {
 		if (!RB_EMPTY_NODE(&sm->node)) {
 			sm->last_used = jiffies;
 			list_add_tail(&sm->lru, &mdsc->snapid_map_lru);
@@ -1161,7 +1164,7 @@ void ceph_cleanup_snapid_map(struct ceph_mds_client *mdsc)
 		sm = list_first_entry(&to_free, struct ceph_snapid_map, lru);
 		list_del(&sm->lru);
 		free_anon_bdev(sm->dev);
-		if (WARN_ON_ONCE(atomic_read(&sm->ref))) {
+		if (WARN_ON_ONCE(refcount_read(&sm->ref))) {
 			pr_err("snapid map %llx -> %x still in use\n",
 			       sm->snap, sm->dev);
 		}
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index c48bb30c8d70..062123a73ef1 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -835,7 +835,7 @@ struct ceph_readdir_cache_control {
 struct ceph_snap_realm {
 	u64 ino;
 	struct inode *inode;
-	atomic_t nref;
+	refcount_t nref;
 	struct rb_node node;
 
 	u64 created, seq;
-- 
2.29.0

