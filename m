Return-Path: <ceph-devel+bounces-403-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EF5E81B7F2
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Dec 2023 14:35:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C93728A351
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Dec 2023 13:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5688E768F7;
	Thu, 21 Dec 2023 13:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E1dedVFT"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BA38058C
	for <ceph-devel@vger.kernel.org>; Thu, 21 Dec 2023 13:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703165132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U/y+xm2N9V1erDz4QIGlE5zRDPNtyRW7a99pDjZCrtc=;
	b=E1dedVFTy1Jf7nQ3Y/Dt0wpp714eB52Kov3tQlL7UTh5hhUDnAe7XTQ4Ve5LrnOxU4UVYf
	Re40Iz22heGIkX5EWU7Ym9/y8u7Zsa/D6bmkB94ECijWggD5shoMwaqwSURGMbmJWcqaPK
	xtHaXnv51Jw6ERajDa6SN486SEK4Irk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-417-9pjKgx18P2eV28IFZ7u4ow-1; Thu, 21 Dec 2023 08:25:27 -0500
X-MC-Unique: 9pjKgx18P2eV28IFZ7u4ow-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A30185A58B;
	Thu, 21 Dec 2023 13:25:26 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.39.195.169])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6425F51D5;
	Thu, 21 Dec 2023 13:25:23 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Jeff Layton <jlayton@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: David Howells <dhowells@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Christian Brauner <christian@brauner.io>,
	linux-cachefs@redhat.com,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 21/40] netfs: Make netfs_put_request() handle a NULL pointer
Date: Thu, 21 Dec 2023 13:23:16 +0000
Message-ID: <20231221132400.1601991-22-dhowells@redhat.com>
In-Reply-To: <20231221132400.1601991-1-dhowells@redhat.com>
References: <20231221132400.1601991-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Make netfs_put_request() just return if given a NULL request pointer.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
cc: linux-cachefs@redhat.com
cc: linux-fsdevel@vger.kernel.org
cc: linux-mm@kvack.org
---
 fs/netfs/objects.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/netfs/objects.c b/fs/netfs/objects.c
index 65a17dd4ab49..3aa0bfbc04ec 100644
--- a/fs/netfs/objects.c
+++ b/fs/netfs/objects.c
@@ -106,19 +106,22 @@ static void netfs_free_request(struct work_struct *work)
 void netfs_put_request(struct netfs_io_request *rreq, bool was_async,
 		       enum netfs_rreq_ref_trace what)
 {
-	unsigned int debug_id = rreq->debug_id;
+	unsigned int debug_id;
 	bool dead;
 	int r;
 
-	dead = __refcount_dec_and_test(&rreq->ref, &r);
-	trace_netfs_rreq_ref(debug_id, r - 1, what);
-	if (dead) {
-		if (was_async) {
-			rreq->work.func = netfs_free_request;
-			if (!queue_work(system_unbound_wq, &rreq->work))
-				BUG();
-		} else {
-			netfs_free_request(&rreq->work);
+	if (rreq) {
+		debug_id = rreq->debug_id;
+		dead = __refcount_dec_and_test(&rreq->ref, &r);
+		trace_netfs_rreq_ref(debug_id, r - 1, what);
+		if (dead) {
+			if (was_async) {
+				rreq->work.func = netfs_free_request;
+				if (!queue_work(system_unbound_wq, &rreq->work))
+					BUG();
+			} else {
+				netfs_free_request(&rreq->work);
+			}
 		}
 	}
 }


