Return-Path: <ceph-devel+bounces-637-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EE91E837641
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jan 2024 23:35:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E5131F274E2
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jan 2024 22:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 567234A986;
	Mon, 22 Jan 2024 22:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ad8o9wV9"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911DB48CFE
	for <ceph-devel@vger.kernel.org>; Mon, 22 Jan 2024 22:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705962773; cv=none; b=nRVKdIkeGKCJYTE2ejhw4GM5AJfF3Lc1mBGD9iJPpIr5W7dXid00A1UMuJJNVZQtC+aNFGBGPEXT+KFpzwdg6QDB9gWbjgmi7xnyx5Z1XrklT632CpV5RoBPF14gTgLuOHVtrbMzSCNuPhsFzY2EAibV6H2n8b5k8gwo3T6fjVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705962773; c=relaxed/simple;
	bh=OfIzfUBOegY/aA+DNYcmnKkvNEOiMv9jvlr290zr5sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Df0eRbug4+5aapcyhEAxXDD2J0Gmhj1LebUPw2D9uC8DL1+fA1xfjWT5UC8iuU2uNRxKFp+sHZooxFyfiNTTxnXJqpQdOgy5MgdKOlP8zHlo+iefiMWPNwKDMtmPAHayb0K58CA4rs8HH1WaWalafDLEITtk9aRZFIyyF43FPZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ad8o9wV9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705962770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8CJ3I/7LDGs8hexTud6zRTfvlS0atGDHH81M3ADEHcQ=;
	b=Ad8o9wV9ht4mFlJgkxsLVWWwRDT16Qrnao9z+VscOCDVXtTF/bH++0tW383CrDnwtVP3Pf
	LdRBfXWiotNnyKuKQN9DzpciXiUUE5zdPwv2oJS3uCrZf5oSRVoDY3DhCL+IjDI08K4ix7
	DcBolSkAr2ObDEvkwjbCQ+rAGsj7MSE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-kqQQMgafNgqLwRACAr_1zQ-1; Mon, 22 Jan 2024 17:32:45 -0500
X-MC-Unique: kqQQMgafNgqLwRACAr_1zQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D92CC106CFE2;
	Mon, 22 Jan 2024 22:32:44 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.67])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 040A32026D66;
	Mon, 22 Jan 2024 22:32:42 +0000 (UTC)
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
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH v2 04/10] netfs, fscache: Prevent Oops in fscache_put_cache()
Date: Mon, 22 Jan 2024 22:32:17 +0000
Message-ID: <20240122223230.4000595-5-dhowells@redhat.com>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

This function dereferences "cache" and then checks if it's
IS_ERR_OR_NULL().  Check first, then dereference.

Fixes: 9549332df4ed ("fscache: Implement cache registration")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/e84bc740-3502-4f16-982a-a40d5676615c@moroto.mountain/ # v2
---
 fs/netfs/fscache_cache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/netfs/fscache_cache.c b/fs/netfs/fscache_cache.c
index d645f8b302a2..9397ed39b0b4 100644
--- a/fs/netfs/fscache_cache.c
+++ b/fs/netfs/fscache_cache.c
@@ -179,13 +179,14 @@ EXPORT_SYMBOL(fscache_acquire_cache);
 void fscache_put_cache(struct fscache_cache *cache,
 		       enum fscache_cache_trace where)
 {
-	unsigned int debug_id = cache->debug_id;
+	unsigned int debug_id;
 	bool zero;
 	int ref;
 
 	if (IS_ERR_OR_NULL(cache))
 		return;
 
+	debug_id = cache->debug_id;
 	zero = __refcount_dec_and_test(&cache->ref, &ref);
 	trace_fscache_cache(debug_id, ref - 1, where);
 


