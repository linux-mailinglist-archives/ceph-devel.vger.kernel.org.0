Return-Path: <ceph-devel+bounces-1029-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 60ECA8905D1
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Mar 2024 17:42:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1715C299EC6
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Mar 2024 16:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8428F535BA;
	Thu, 28 Mar 2024 16:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SaNjyCml"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F596339A0
	for <ceph-devel@vger.kernel.org>; Thu, 28 Mar 2024 16:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643864; cv=none; b=BqvDB4iIHokzzSX4VdLaFNmCSWfiKccGHNL2keqbzZ6tls/TCMU3Egp/k56LHNOkNO+6TaftfpdJl/+cof8Dpl3tp2jxT6WB7oTGbw1kNS4noj62Z/OOAE/S4Fxv3rtmPwXc/vHQyYBuGqFKvUzwXuKbDSDh5LjJB+IMgCHfgS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643864; c=relaxed/simple;
	bh=Yud/SqK60w36+ZiKUPNBoKLBlBi9Da312E4fzea2Wnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdoJfIvtV0mi4CLTvDvMi+w4Hbpso24Jxi9FKTVseug+rikSWNz/snkKqb3nmaSjtjxX9ZclQ6i8666xjDTn6zslJG+CNuMuauURJypTu+1YEgW2/DXSq2HCuXjJ0PbOTKk5h18HX0UB/QdWij4St6YSesMugP+3+nr9txQQQTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SaNjyCml; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711643861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UDqhr06HS33V6vFM7dYIX30CATG7yaNP9QU79jSdPNo=;
	b=SaNjyCmlggbysqe6buKktukKnvpNjTQ4O0EPjBAmyqEEdQKGqnheaXA+zdvMNXwUmkHdyh
	FL/v5tFpgYPVHtB/pC6Nl3/BPt36yxAMhAgSbwZ+K/5EZ44EGrGJ1g0YrmrHvrPFuyukFj
	eADpa8ob8zWFw2Nghe4ji9SoiXDxAb0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418-u7tjA_N8McG-eKGjvAI-3w-1; Thu, 28 Mar 2024 12:37:39 -0400
X-MC-Unique: u7tjA_N8McG-eKGjvAI-3w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DEAA88F2EB;
	Thu, 28 Mar 2024 16:37:38 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.146])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 509B03C20;
	Thu, 28 Mar 2024 16:37:35 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Jeff Layton <jlayton@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Dominique Martinet <asmadeus@codewreck.org>
Cc: David Howells <dhowells@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Steve French <smfrench@gmail.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	netfs@lists.linux.dev,
	linux-cachefs@redhat.com,
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
Subject: [PATCH 14/26] netfs: Use mempools for allocating requests and subrequests
Date: Thu, 28 Mar 2024 16:34:06 +0000
Message-ID: <20240328163424.2781320-15-dhowells@redhat.com>
In-Reply-To: <20240328163424.2781320-1-dhowells@redhat.com>
References: <20240328163424.2781320-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

Use mempools for allocating requests and subrequests in an effort to make
sure that allocation always succeeds so that when performing writeback we
can always make progress.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
cc: linux-mm@kvack.org
---
 fs/netfs/internal.h   |  2 ++
 fs/netfs/main.c       | 51 ++++++++++++++++++++++++++++++++-----
 fs/netfs/objects.c    | 59 ++++++++++++++++++++++++++++---------------
 include/linux/netfs.h |  5 ++--
 4 files changed, 89 insertions(+), 28 deletions(-)

diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index 156ab138e224..c67da478cd2b 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -37,6 +37,8 @@ int netfs_begin_read(struct netfs_io_request *rreq, bool sync);
 extern unsigned int netfs_debug;
 extern struct list_head netfs_io_requests;
 extern spinlock_t netfs_proc_lock;
+extern mempool_t netfs_request_pool;
+extern mempool_t netfs_subrequest_pool;
 
 #ifdef CONFIG_PROC_FS
 static inline void netfs_proc_add_rreq(struct netfs_io_request *rreq)
diff --git a/fs/netfs/main.c b/fs/netfs/main.c
index 844efbb2e7a2..4805b9377364 100644
--- a/fs/netfs/main.c
+++ b/fs/netfs/main.c
@@ -7,6 +7,7 @@
 
 #include <linux/module.h>
 #include <linux/export.h>
+#include <linux/mempool.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include "internal.h"
@@ -23,6 +24,11 @@ unsigned netfs_debug;
 module_param_named(debug, netfs_debug, uint, S_IWUSR | S_IRUGO);
 MODULE_PARM_DESC(netfs_debug, "Netfs support debugging mask");
 
+static struct kmem_cache *netfs_request_slab;
+static struct kmem_cache *netfs_subrequest_slab;
+mempool_t netfs_request_pool;
+mempool_t netfs_subrequest_pool;
+
 #ifdef CONFIG_PROC_FS
 LIST_HEAD(netfs_io_requests);
 DEFINE_SPINLOCK(netfs_proc_lock);
@@ -98,25 +104,54 @@ static int __init netfs_init(void)
 {
 	int ret = -ENOMEM;
 
+	netfs_request_slab = kmem_cache_create("netfs_request",
+					       sizeof(struct netfs_io_request), 0,
+					       SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT,
+					       NULL);
+	if (!netfs_request_slab)
+		goto error_req;
+
+	if (mempool_init_slab_pool(&netfs_request_pool, 100, netfs_request_slab) < 0)
+		goto error_reqpool;
+
+	netfs_subrequest_slab = kmem_cache_create("netfs_subrequest",
+						  sizeof(struct netfs_io_subrequest), 0,
+						  SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT,
+						  NULL);
+	if (!netfs_subrequest_slab)
+		goto error_subreq;
+
+	if (mempool_init_slab_pool(&netfs_subrequest_pool, 100, netfs_subrequest_slab) < 0)
+		goto error_subreqpool;
+
 	if (!proc_mkdir("fs/netfs", NULL))
-		goto error;
+		goto error_proc;
 	if (!proc_create_seq("fs/netfs/requests", S_IFREG | 0444, NULL,
 			     &netfs_requests_seq_ops))
-		goto error_proc;
+		goto error_procfile;
 #ifdef CONFIG_FSCACHE_STATS
 	if (!proc_create_single("fs/netfs/stats", S_IFREG | 0444, NULL,
 				netfs_stats_show))
-		goto error_proc;
+		goto error_procfile;
 #endif
 
 	ret = fscache_init();
 	if (ret < 0)
-		goto error_proc;
+		goto error_fscache;
 	return 0;
 
-error_proc:
+error_fscache:
+error_procfile:
 	remove_proc_entry("fs/netfs", NULL);
-error:
+error_proc:
+	mempool_exit(&netfs_subrequest_pool);
+error_subreqpool:
+	kmem_cache_destroy(netfs_subrequest_slab);
+error_subreq:
+	mempool_exit(&netfs_request_pool);
+error_reqpool:
+	kmem_cache_destroy(netfs_request_slab);
+error_req:
 	return ret;
 }
 fs_initcall(netfs_init);
@@ -125,5 +160,9 @@ static void __exit netfs_exit(void)
 {
 	fscache_exit();
 	remove_proc_entry("fs/netfs", NULL);
+	mempool_exit(&netfs_subrequest_pool);
+	kmem_cache_destroy(netfs_subrequest_slab);
+	mempool_exit(&netfs_request_pool);
+	kmem_cache_destroy(netfs_request_slab);
 }
 module_exit(netfs_exit);
diff --git a/fs/netfs/objects.c b/fs/netfs/objects.c
index 8acc03a64059..1a4e2ce735ce 100644
--- a/fs/netfs/objects.c
+++ b/fs/netfs/objects.c
@@ -6,6 +6,8 @@
  */
 
 #include <linux/slab.h>
+#include <linux/mempool.h>
+#include <linux/delay.h>
 #include "internal.h"
 
 /*
@@ -20,17 +22,22 @@ struct netfs_io_request *netfs_alloc_request(struct address_space *mapping,
 	struct inode *inode = file ? file_inode(file) : mapping->host;
 	struct netfs_inode *ctx = netfs_inode(inode);
 	struct netfs_io_request *rreq;
+	mempool_t *mempool = ctx->ops->request_pool ?: &netfs_request_pool;
+	struct kmem_cache *cache = mempool->pool_data;
 	bool is_unbuffered = (origin == NETFS_UNBUFFERED_WRITE ||
 			      origin == NETFS_DIO_READ ||
 			      origin == NETFS_DIO_WRITE);
 	bool cached = !is_unbuffered && netfs_is_cache_enabled(ctx);
 	int ret;
 
-	rreq = kzalloc(ctx->ops->io_request_size ?: sizeof(struct netfs_io_request),
-		       GFP_KERNEL);
-	if (!rreq)
-		return ERR_PTR(-ENOMEM);
+	for (;;) {
+		rreq = mempool_alloc(mempool, GFP_KERNEL);
+		if (rreq)
+			break;
+		msleep(10);
+	}
 
+	memset(rreq, 0, kmem_cache_size(cache));
 	rreq->start	= start;
 	rreq->len	= len;
 	rreq->upper_len	= len;
@@ -56,7 +63,7 @@ struct netfs_io_request *netfs_alloc_request(struct address_space *mapping,
 	if (rreq->netfs_ops->init_request) {
 		ret = rreq->netfs_ops->init_request(rreq, file);
 		if (ret < 0) {
-			kfree(rreq);
+			mempool_free(rreq, rreq->netfs_ops->request_pool ?: &netfs_request_pool);
 			return ERR_PTR(ret);
 		}
 	}
@@ -88,6 +95,14 @@ void netfs_clear_subrequests(struct netfs_io_request *rreq, bool was_async)
 	}
 }
 
+static void netfs_free_request_rcu(struct rcu_head *rcu)
+{
+	struct netfs_io_request *rreq = container_of(rcu, struct netfs_io_request, rcu);
+
+	mempool_free(rreq, rreq->netfs_ops->request_pool ?: &netfs_request_pool);
+	netfs_stat_d(&netfs_n_rh_rreq);
+}
+
 static void netfs_free_request(struct work_struct *work)
 {
 	struct netfs_io_request *rreq =
@@ -110,8 +125,7 @@ static void netfs_free_request(struct work_struct *work)
 		}
 		kvfree(rreq->direct_bv);
 	}
-	kfree_rcu(rreq, rcu);
-	netfs_stat_d(&netfs_n_rh_rreq);
+	call_rcu(&rreq->rcu, netfs_free_request_rcu);
 }
 
 void netfs_put_request(struct netfs_io_request *rreq, bool was_async,
@@ -143,20 +157,25 @@ void netfs_put_request(struct netfs_io_request *rreq, bool was_async,
 struct netfs_io_subrequest *netfs_alloc_subrequest(struct netfs_io_request *rreq)
 {
 	struct netfs_io_subrequest *subreq;
-
-	subreq = kzalloc(rreq->netfs_ops->io_subrequest_size ?:
-			 sizeof(struct netfs_io_subrequest),
-			 GFP_KERNEL);
-	if (subreq) {
-		INIT_WORK(&subreq->work, NULL);
-		INIT_LIST_HEAD(&subreq->rreq_link);
-		refcount_set(&subreq->ref, 2);
-		subreq->rreq = rreq;
-		subreq->debug_index = atomic_inc_return(&rreq->subreq_counter);
-		netfs_get_request(rreq, netfs_rreq_trace_get_subreq);
-		netfs_stat(&netfs_n_rh_sreq);
+	mempool_t *mempool = rreq->netfs_ops->subrequest_pool ?: &netfs_subrequest_pool;
+	struct kmem_cache *cache = mempool->pool_data;
+
+	for (;;) {
+		subreq = mempool_alloc(rreq->netfs_ops->subrequest_pool ?: &netfs_subrequest_pool,
+				       GFP_KERNEL);
+		if (subreq)
+			break;
+		msleep(10);
 	}
 
+	memset(subreq, 0, kmem_cache_size(cache));
+	INIT_WORK(&subreq->work, NULL);
+	INIT_LIST_HEAD(&subreq->rreq_link);
+	refcount_set(&subreq->ref, 2);
+	subreq->rreq = rreq;
+	subreq->debug_index = atomic_inc_return(&rreq->subreq_counter);
+	netfs_get_request(rreq, netfs_rreq_trace_get_subreq);
+	netfs_stat(&netfs_n_rh_sreq);
 	return subreq;
 }
 
@@ -178,7 +197,7 @@ static void netfs_free_subrequest(struct netfs_io_subrequest *subreq,
 	trace_netfs_sreq(subreq, netfs_sreq_trace_free);
 	if (rreq->netfs_ops->free_subrequest)
 		rreq->netfs_ops->free_subrequest(subreq);
-	kfree(subreq);
+	mempool_free(subreq, rreq->netfs_ops->subrequest_pool ?: &netfs_subrequest_pool);
 	netfs_stat_d(&netfs_n_rh_sreq);
 	netfs_put_request(rreq, was_async, netfs_rreq_trace_put_subreq);
 }
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 3af589dabd7f..0b6c2c2d3c23 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -20,6 +20,7 @@
 #include <linux/uio.h>
 
 enum netfs_sreq_ref_trace;
+typedef struct mempool_s mempool_t;
 
 /**
  * folio_start_private_2 - Start an fscache write on a folio.  [DEPRECATED]
@@ -236,8 +237,8 @@ struct netfs_io_request {
  * Operations the network filesystem can/must provide to the helpers.
  */
 struct netfs_request_ops {
-	unsigned int	io_request_size;	/* Alloc size for netfs_io_request struct */
-	unsigned int	io_subrequest_size;	/* Alloc size for netfs_io_subrequest struct */
+	mempool_t *request_pool;
+	mempool_t *subrequest_pool;
 	int (*init_request)(struct netfs_io_request *rreq, struct file *file);
 	void (*free_request)(struct netfs_io_request *rreq);
 	void (*free_subrequest)(struct netfs_io_subrequest *rreq);


