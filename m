Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0BD139A643
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Jun 2021 18:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhFCQyS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Jun 2021 12:54:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229947AbhFCQyS (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 3 Jun 2021 12:54:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BA8B613B1;
        Thu,  3 Jun 2021 16:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622739153;
        bh=G4A7oTlzaHn8JFOVl1VhLtsu/ULMscXistcDr0xTHkM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=l7/SLyQsxLPvId5wY4EvzewxaZXegk5wKF28TXCXWF+bvuL1EAV5i1iURs9SSSkMJ
         rtXC3dn9P9r81ehvV1gNXM285VRcuSNbYtmBzNfNlMqnzFBg3gqTxRUDqnjkI5OKsv
         sOqVpszX6Sv18XIoXf/NNmuQmTgbnGZ5zfjEemvjSQrg3tVoGOFKw7UD/fqFw8BtAt
         yjH/wZwWgdZ4ae9yvqTph8YB+uJKIqPR3PoSRdfrBwpCOcZjQiFSg4gzddlpU7Xrzd
         1jM8+PZTfeTmx7/lw2K5Ogihh3bKh6VtNNN30oipDWSp7HtClrkEgPsGiw0NxKnwge
         O/KOIlPS56ltw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Subject: [PATCH 1/3] ceph: add some lockdep assertions around snaprealm handling
Date:   Thu,  3 Jun 2021 12:52:29 -0400
Message-Id: <20210603165231.110559-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603165231.110559-1-jlayton@kernel.org>
References: <20210603165231.110559-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Turn some comments into lockdep asserts.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/snap.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 2a63fb37778b..bc6c33d485e6 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -65,6 +65,8 @@
 void ceph_get_snap_realm(struct ceph_mds_client *mdsc,
 			 struct ceph_snap_realm *realm)
 {
+	lockdep_assert_held_write(&mdsc->snap_rwsem);
+
 	dout("get_realm %p %d -> %d\n", realm,
 	     atomic_read(&realm->nref), atomic_read(&realm->nref)+1);
 	/*
@@ -113,6 +115,8 @@ static struct ceph_snap_realm *ceph_create_snap_realm(
 {
 	struct ceph_snap_realm *realm;
 
+	lockdep_assert_held_write(&mdsc->snap_rwsem);
+
 	realm = kzalloc(sizeof(*realm), GFP_NOFS);
 	if (!realm)
 		return ERR_PTR(-ENOMEM);
@@ -143,6 +147,8 @@ static struct ceph_snap_realm *__lookup_snap_realm(struct ceph_mds_client *mdsc,
 	struct rb_node *n = mdsc->snap_realms.rb_node;
 	struct ceph_snap_realm *r;
 
+	lockdep_assert_held_write(&mdsc->snap_rwsem);
+
 	while (n) {
 		r = rb_entry(n, struct ceph_snap_realm, node);
 		if (ino < r->ino)
@@ -176,6 +182,8 @@ static void __put_snap_realm(struct ceph_mds_client *mdsc,
 static void __destroy_snap_realm(struct ceph_mds_client *mdsc,
 				 struct ceph_snap_realm *realm)
 {
+	lockdep_assert_held_write(&mdsc->snap_rwsem);
+
 	dout("__destroy_snap_realm %p %llx\n", realm, realm->ino);
 
 	rb_erase(&realm->node, &mdsc->snap_realms);
@@ -198,6 +206,8 @@ static void __destroy_snap_realm(struct ceph_mds_client *mdsc,
 static void __put_snap_realm(struct ceph_mds_client *mdsc,
 			     struct ceph_snap_realm *realm)
 {
+	lockdep_assert_held_write(&mdsc->snap_rwsem);
+
 	dout("__put_snap_realm %llx %p %d -> %d\n", realm->ino, realm,
 	     atomic_read(&realm->nref), atomic_read(&realm->nref)-1);
 	if (atomic_dec_and_test(&realm->nref))
@@ -236,6 +246,8 @@ static void __cleanup_empty_realms(struct ceph_mds_client *mdsc)
 {
 	struct ceph_snap_realm *realm;
 
+	lockdep_assert_held_write(&mdsc->snap_rwsem);
+
 	spin_lock(&mdsc->snap_empty_lock);
 	while (!list_empty(&mdsc->snap_empty)) {
 		realm = list_first_entry(&mdsc->snap_empty,
@@ -269,6 +281,8 @@ static int adjust_snap_realm_parent(struct ceph_mds_client *mdsc,
 {
 	struct ceph_snap_realm *parent;
 
+	lockdep_assert_held_write(&mdsc->snap_rwsem);
+
 	if (realm->parent_ino == parentino)
 		return 0;
 
@@ -696,6 +710,8 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	int err = -ENOMEM;
 	LIST_HEAD(dirty_realms);
 
+	lockdep_assert_held_write(&mdsc->snap_rwsem);
+
 	dout("update_snap_trace deletion=%d\n", deletion);
 more:
 	ceph_decode_need(&p, e, sizeof(*ri), bad);
-- 
2.31.1

