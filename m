Return-Path: <ceph-devel+bounces-1705-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C36D95911E
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Aug 2024 01:22:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 462F1285E37
	for <lists+ceph-devel@lfdr.de>; Tue, 20 Aug 2024 23:22:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 043EA1C9EA5;
	Tue, 20 Aug 2024 23:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aO2za/8c"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B8B1C8FB2
	for <ceph-devel@vger.kernel.org>; Tue, 20 Aug 2024 23:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724196098; cv=none; b=N9cYuGVCLzpBXBf1jTJ7+o56o30/GXlm1g8cd86E2I3Y2YfWc+ENQdQNxHEt9ZIx7/gYv8+p5MVTiqRAoX/UCCAx5NwFGg4LfL9Ytqs6rKT9dElpuCsSQGCAn4g8+Tv4OOOoDpALZhvXXIdJLcnJe6PoQLXJtzrn8qNaPvG5q2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724196098; c=relaxed/simple;
	bh=g8vGiYgfUHHfeHz8oFJMF7SqHkz4KAmGdS17s4e9lUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMvW1bi9xwi2OmqTdM/3DSF/xoNGJEXztEHQGxJJZeQ+Z/n4nxwFcb1/2WZ6Vb8NcgfxLP51AmlvozKfnqGUBtizjKqyZUr2riCNJJUQIxnatI/g+CFW7h/9yyqTVWLg8xSj58u9rrzQfdvNTHkLIuCWaTSx81d1N2ENlvyu36M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aO2za/8c; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724196094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LLNXobqu9Lr51n4CzgcItZvbbRppxWdYVF89daxGYJk=;
	b=aO2za/8cvuqSE2mLiHck1Njwte3AfjONKe6DRKx2ep10rTjHjpDVGQjseHt+Fp/Gdgt20J
	5oPnr7IVTHk7hB9quOyqg4tbnKLJq/TPwlGhiHoEU4oxXy01tNHwIZoECrwClKCAa65Gqy
	yLspn9EAQSPkUSeu/+BBM1Ati17WDp0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-34-12CfHN9WNkObG7tnXd9WhA-1; Tue,
 20 Aug 2024 19:21:29 -0400
X-MC-Unique: 12CfHN9WNkObG7tnXd9WhA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3436B195608A;
	Tue, 20 Aug 2024 23:21:25 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.30])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 09A0F1955E8C;
	Tue, 20 Aug 2024 23:21:20 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Jeff Layton <jlayton@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Marc Dionne <marc.dionne@auristor.com>
Subject: [PATCH 2/4] afs: Fix post-setattr file edit to do truncation correctly
Date: Wed, 21 Aug 2024 00:20:56 +0100
Message-ID: <20240820232105.3792638-3-dhowells@redhat.com>
In-Reply-To: <20240820232105.3792638-1-dhowells@redhat.com>
References: <20240820232105.3792638-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

At the end of an kAFS RPC operation, there is an "edit" phase (originally
intended for post-directory modification ops to edit the local image) that
the setattr VFS op uses to fix up the pagecache if the RPC that requested
truncation of a file was successful.

afs_setattr_edit_file() calls truncate_setsize() which sets i_size, expands
the pagecache if needed and truncates the pagecache.  The first two of
those, however, are redundant as they've already been done by
afs_setattr_success() under the io_lock and the first is also done under
the callback lock (cb_lock).

Fix afs_setattr_edit_file() to call truncate_pagecache() instead (which is
called by truncate_setsize(), thereby skipping the redundant parts.

Fixes: 100ccd18bb41 ("netfs: Optimise away reads above the point at which there can be no data")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Matthew Wilcox (Oracle) <willy@infradead.org>
cc: Pankaj Raghav <p.raghav@samsung.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: netfs@lists.linux.dev
cc: linux-mm@kvack.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/afs/inode.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 3acf5e050072..a95e77670b49 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -695,13 +695,18 @@ static void afs_setattr_edit_file(struct afs_operation *op)
 {
 	struct afs_vnode_param *vp = &op->file[0];
 	struct afs_vnode *vnode = vp->vnode;
+	struct inode *inode = &vnode->netfs.inode;
 
 	if (op->setattr.attr->ia_valid & ATTR_SIZE) {
 		loff_t size = op->setattr.attr->ia_size;
-		loff_t i_size = op->setattr.old_i_size;
+		loff_t old = op->setattr.old_i_size;
+
+		/* Note: inode->i_size was updated by afs_apply_status() inside
+		 * the I/O and callback locks.
+		 */
 
-		if (size != i_size) {
-			truncate_setsize(&vnode->netfs.inode, size);
+		if (size != old) {
+			truncate_pagecache(inode, size);
 			netfs_resize_file(&vnode->netfs, size, true);
 			fscache_resize_cookie(afs_vnode_cache(vnode), size);
 		}


