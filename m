Return-Path: <ceph-devel+bounces-1964-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2940E9B1084
	for <lists+ceph-devel@lfdr.de>; Fri, 25 Oct 2024 22:48:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A03951F213B3
	for <lists+ceph-devel@lfdr.de>; Fri, 25 Oct 2024 20:48:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C14B229B5C;
	Fri, 25 Oct 2024 20:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CvDRxUZH"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE46B21745A
	for <ceph-devel@vger.kernel.org>; Fri, 25 Oct 2024 20:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729888929; cv=none; b=JPJkzBOBgclzV+B0zl9K+PzDXx0Xrylko2uoYGGw3fTKNx3Oq0HXAvccMof87wbvfJTzYN1UjqZGVrlAH9z4+g1tB+LP0vA/yBERlNDmsOdU1jS2siZi0pW7Qha7RIOq98ozYO0IZn1lOqktdO0s2otChLMds80C02xSCpz5eLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729888929; c=relaxed/simple;
	bh=90tmfXdOk7PUXqQduFPRhL3TyDiNo9WZvTnvimUkG4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9iBgNUd09FkwbCZrvk+sSf5zKZ7rma9H2se3VUSFRtqhZAH6YwSuum6gjq7kLJlEc7dYRPfAvwRDBssN8R6DvORYee+PBkYlDcmhvB0Wm0+1vZc4GS1KjwXBH66BAX9xjqkt7mKhZ5kitJbkcxnw45wfJbPJCYBF74ornjBcqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CvDRxUZH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729888927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PpSYjRYWbFXxWDdh6eO8irNXCJzGx0/SlE83d2O2JK0=;
	b=CvDRxUZHPj3qk34PGI1GssZayyNuKqgezwhi2OX9O72TBs7TOO9riwvCbElluxEEruCiyt
	2Hovo58fnvmM2GOEiPY78b6yA9CsQBHy74g2bX0I3UiAIoyPNCGhgwpNzhPP4iLFhkl+7a
	SfRzS7+0qLb1eloJVFbzfrfixjlg65Q=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-594-7APQz8RuOqaEYTPIQAnFpw-1; Fri,
 25 Oct 2024 16:42:03 -0400
X-MC-Unique: 7APQz8RuOqaEYTPIQAnFpw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9CC691956077;
	Fri, 25 Oct 2024 20:42:00 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.231])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AB2EE300018D;
	Fri, 25 Oct 2024 20:41:55 +0000 (UTC)
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
Subject: [PATCH v2 15/31] netfs: Remove some extraneous directory invalidations
Date: Fri, 25 Oct 2024 21:39:42 +0100
Message-ID: <20241025204008.4076565-16-dhowells@redhat.com>
In-Reply-To: <20241025204008.4076565-1-dhowells@redhat.com>
References: <20241025204008.4076565-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

In the directory editing code, we shouldn't re-invalidate the directory
if it is already invalidated.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---
 fs/afs/dir_edit.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/fs/afs/dir_edit.c b/fs/afs/dir_edit.c
index fe223fb78111..13fb236a3f50 100644
--- a/fs/afs/dir_edit.c
+++ b/fs/afs/dir_edit.c
@@ -247,7 +247,7 @@ void afs_edit_dir_add(struct afs_vnode *vnode,
 		 */
 		index = b / AFS_DIR_BLOCKS_PER_PAGE;
 		if (nr_blocks >= AFS_DIR_MAX_BLOCKS)
-			goto error;
+			goto error_too_many_blocks;
 		if (index >= folio_nr_pages(folio0)) {
 			folio = afs_dir_get_folio(vnode, index);
 			if (!folio)
@@ -260,7 +260,7 @@ void afs_edit_dir_add(struct afs_vnode *vnode,
 
 		/* Abandon the edit if we got a callback break. */
 		if (!test_bit(AFS_VNODE_DIR_VALID, &vnode->flags))
-			goto invalidated;
+			goto already_invalidated;
 
 		_debug("block %u: %2u %3u %u",
 		       b,
@@ -348,9 +348,8 @@ void afs_edit_dir_add(struct afs_vnode *vnode,
 	_leave("");
 	return;
 
-invalidated:
+already_invalidated:
 	trace_afs_edit_dir(vnode, why, afs_edit_dir_create_inval, 0, 0, 0, 0, name->name);
-	clear_bit(AFS_VNODE_DIR_VALID, &vnode->flags);
 	kunmap_local(block);
 	if (folio != folio0) {
 		folio_unlock(folio);
@@ -358,9 +357,10 @@ void afs_edit_dir_add(struct afs_vnode *vnode,
 	}
 	goto out_unmap;
 
+error_too_many_blocks:
+	clear_bit(AFS_VNODE_DIR_VALID, &vnode->flags);
 error:
 	trace_afs_edit_dir(vnode, why, afs_edit_dir_create_error, 0, 0, 0, 0, name->name);
-	clear_bit(AFS_VNODE_DIR_VALID, &vnode->flags);
 	goto out_unmap;
 }
 
@@ -421,7 +421,7 @@ void afs_edit_dir_remove(struct afs_vnode *vnode,
 
 		/* Abandon the edit if we got a callback break. */
 		if (!test_bit(AFS_VNODE_DIR_VALID, &vnode->flags))
-			goto invalidated;
+			goto already_invalidated;
 
 		if (b > AFS_DIR_BLOCKS_WITH_CTR ||
 		    meta->meta.alloc_ctrs[b] <= AFS_DIR_SLOTS_PER_BLOCK - 1 - need_slots) {
@@ -475,10 +475,9 @@ void afs_edit_dir_remove(struct afs_vnode *vnode,
 	_leave("");
 	return;
 
-invalidated:
+already_invalidated:
 	trace_afs_edit_dir(vnode, why, afs_edit_dir_delete_inval,
 			   0, 0, 0, 0, name->name);
-	clear_bit(AFS_VNODE_DIR_VALID, &vnode->flags);
 	kunmap_local(block);
 	if (folio != folio0) {
 		folio_unlock(folio);
@@ -489,7 +488,6 @@ void afs_edit_dir_remove(struct afs_vnode *vnode,
 error:
 	trace_afs_edit_dir(vnode, why, afs_edit_dir_delete_error,
 			   0, 0, 0, 0, name->name);
-	clear_bit(AFS_VNODE_DIR_VALID, &vnode->flags);
 	goto out_unmap;
 }
 
@@ -530,7 +528,7 @@ void afs_edit_dir_update_dotdot(struct afs_vnode *vnode, struct afs_vnode *new_d
 
 		/* Abandon the edit if we got a callback break. */
 		if (!test_bit(AFS_VNODE_DIR_VALID, &vnode->flags))
-			goto invalidated;
+			goto already_invalidated;
 
 		slot = afs_dir_scan_block(block, &dotdot_name, b);
 		if (slot >= 0)
@@ -564,18 +562,16 @@ void afs_edit_dir_update_dotdot(struct afs_vnode *vnode, struct afs_vnode *new_d
 	_leave("");
 	return;
 
-invalidated:
+already_invalidated:
 	kunmap_local(block);
 	folio_unlock(folio);
 	folio_put(folio);
 	trace_afs_edit_dir(vnode, why, afs_edit_dir_update_inval,
 			   0, 0, 0, 0, "..");
-	clear_bit(AFS_VNODE_DIR_VALID, &vnode->flags);
 	goto out;
 
 error:
 	trace_afs_edit_dir(vnode, why, afs_edit_dir_update_error,
 			   0, 0, 0, 0, "..");
-	clear_bit(AFS_VNODE_DIR_VALID, &vnode->flags);
 	goto out;
 }


