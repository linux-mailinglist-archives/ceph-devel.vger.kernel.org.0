Return-Path: <ceph-devel+bounces-635-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0053E837636
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jan 2024 23:34:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7FE6EB21CA9
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jan 2024 22:34:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBBD2107A8;
	Mon, 22 Jan 2024 22:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LLIfKqt9"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D13376E3
	for <ceph-devel@vger.kernel.org>; Mon, 22 Jan 2024 22:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705962768; cv=none; b=fhSoszn2Ub+3OewdOu1B5zSAgiXs9a4CM/0neKl7u9KscrYcFuomo9kXGF0DSAFQzF2PHHKC5oUzDo3AJ2gnYlHSaTqF6msp5XaJ75+VfmZVp5zBrriUzizm37oaLhFz3abznOM+4D0eTpF2NRErv3doyiQjDiBgd9TjgyuLaD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705962768; c=relaxed/simple;
	bh=/cvksSSZmxrtzmRzMtQyJ29qGFgkxxbGXyOn+BgtGh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acTXppEAxAX+S3MEiVMtCbNKKQ9ctc8qHShdwrbAdn5UqhiSsjwT5XN1akiG+98xl6zBjPzAG4gf8RPAhp+qYjc7C5AEoZhJpmXST4ssnrDxF1+IFI0i8uCzR7qNPrbSajj5xMOOJZAElR4M43NCk2sIyc0NjcwxsRntzmY4dro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LLIfKqt9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705962766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x1zKGT6uFapv0Zv34dL5cckA4sfK0obP1h5qgfcrNJU=;
	b=LLIfKqt9us/Xb6TaOIFUpnrXI6EAZNEFSg5dav64ZaXMO1zcXkoFA/t5ZhE/7Ha0dNN9uu
	TLiG6z1jWIUM4Ek4gnn1Dxrk0fgZWhL/NUvwGJm4kMdSBscoy4Z8aMoxsSvKvLDclYs2L4
	rzgj04b+L7YQXuF0elchRM8RcyR37hE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-677-D55WZ7cLO0uVwnEeCzBXJA-1; Mon,
 22 Jan 2024 17:32:39 -0500
X-MC-Unique: D55WZ7cLO0uVwnEeCzBXJA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 233F61C04181;
	Mon, 22 Jan 2024 22:32:39 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.67])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4C0FC2026D66;
	Mon, 22 Jan 2024 22:32:37 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
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
Subject: [PATCH v2 02/10] afs: Don't use certain unnecessary folio_*() functions
Date: Mon, 22 Jan 2024 22:32:15 +0000
Message-ID: <20240122223230.4000595-3-dhowells@redhat.com>
In-Reply-To: <20240122223230.4000595-1-dhowells@redhat.com>
References: <20240122223230.4000595-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

Filesystems should use folio->index and folio->mapping, instead of
folio_index(folio), folio_mapping() and folio_file_mapping() since
they know that it's in the pagecache.

Change this automagically with:

perl -p -i -e 's/folio_mapping[(]([^)]*)[)]/\1->mapping/g' fs/afs/*.c
perl -p -i -e 's/folio_file_mapping[(]([^)]*)[)]/\1->mapping/g' fs/afs/*.c
perl -p -i -e 's/folio_index[(]([^)]*)[)]/\1->index/g' fs/afs/*.c

Reported-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/afs/dir.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index c14533ef108f..3f73d61f7c8a 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -124,7 +124,7 @@ static void afs_dir_read_cleanup(struct afs_read *req)
 		if (xas_retry(&xas, folio))
 			continue;
 		BUG_ON(xa_is_value(folio));
-		ASSERTCMP(folio_file_mapping(folio), ==, mapping);
+		ASSERTCMP(folio->mapping, ==, mapping);
 
 		folio_put(folio);
 	}
@@ -202,12 +202,12 @@ static void afs_dir_dump(struct afs_vnode *dvnode, struct afs_read *req)
 		if (xas_retry(&xas, folio))
 			continue;
 
-		BUG_ON(folio_file_mapping(folio) != mapping);
+		BUG_ON(folio->mapping != mapping);
 
 		size = min_t(loff_t, folio_size(folio), req->actual_len - folio_pos(folio));
 		for (offset = 0; offset < size; offset += sizeof(*block)) {
 			block = kmap_local_folio(folio, offset);
-			pr_warn("[%02lx] %32phN\n", folio_index(folio) + offset, block);
+			pr_warn("[%02lx] %32phN\n", folio->index + offset, block);
 			kunmap_local(block);
 		}
 	}
@@ -233,7 +233,7 @@ static int afs_dir_check(struct afs_vnode *dvnode, struct afs_read *req)
 		if (xas_retry(&xas, folio))
 			continue;
 
-		BUG_ON(folio_file_mapping(folio) != mapping);
+		BUG_ON(folio->mapping != mapping);
 
 		if (!afs_dir_check_folio(dvnode, folio, req->actual_len)) {
 			afs_dir_dump(dvnode, req);
@@ -2022,7 +2022,7 @@ static bool afs_dir_release_folio(struct folio *folio, gfp_t gfp_flags)
 {
 	struct afs_vnode *dvnode = AFS_FS_I(folio_inode(folio));
 
-	_enter("{{%llx:%llu}[%lu]}", dvnode->fid.vid, dvnode->fid.vnode, folio_index(folio));
+	_enter("{{%llx:%llu}[%lu]}", dvnode->fid.vid, dvnode->fid.vnode, folio->index);
 
 	folio_detach_private(folio);
 


