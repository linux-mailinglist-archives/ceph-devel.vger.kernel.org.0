Return-Path: <ceph-devel+bounces-61-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F5967E32AD
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Nov 2023 02:47:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9EC32B20AFF
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Nov 2023 01:47:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3348F1873;
	Tue,  7 Nov 2023 01:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X+1eNOP8"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7910D38D
	for <ceph-devel@vger.kernel.org>; Tue,  7 Nov 2023 01:47:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370E01B2
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 17:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699321633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6q9/rI7HIT4FH35QHUqXtjjixFY18szVqozv21VZkU8=;
	b=X+1eNOP8LW67tQT/ryVH3w4WGooqDRa9jE5fGweOGlY6GRHXMEs4SM1a2XnZ65N/4/490C
	sGCqm7sFWvYpikra7VuI+RWRhlOZet+HkR7+TYabaUrWFkReT7I4O8eIYk1aa299j8kjUP
	0gRMDz5fbNpgyBTOQGlGhbolHuRhcLo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-60--PrE1HMyOT-k_8HsurDXPQ-1; Mon,
 06 Nov 2023 20:47:10 -0500
X-MC-Unique: -PrE1HMyOT-k_8HsurDXPQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C682D1C113E7;
	Tue,  7 Nov 2023 01:47:09 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.221])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F08C5502B;
	Tue,  7 Nov 2023 01:47:06 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3] libceph: remove the max extents check for sparse read
Date: Tue,  7 Nov 2023 09:44:58 +0800
Message-ID: <20231107014458.299637-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

From: Xiubo Li <xiubli@redhat.com>

There is no any limit for the extent array size and it's possible
that when reading with a large size contents the total number of
extents will exceed 4096. Then the messager will fail by reseting
the connection and keeps resending the inflight IOs infinitely.

URL: https://tracker.ceph.com/issues/62081
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V3:
- Remove the max extents check and add one debug log.

V2:
- Increase the MAX_EXTENTS instead of removing it.
- Do not return an errno when hit the limit.




 net/ceph/osd_client.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index c03d48bd3aff..5f10ab76d0f3 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5850,8 +5850,6 @@ static inline void convert_extent_map(struct ceph_sparse_read *sr)
 }
 #endif
 
-#define MAX_EXTENTS 4096
-
 static int osd_sparse_read(struct ceph_connection *con,
 			   struct ceph_msg_data_cursor *cursor,
 			   char **pbuf)
@@ -5882,23 +5880,16 @@ static int osd_sparse_read(struct ceph_connection *con,
 
 		if (count > 0) {
 			if (!sr->sr_extent || count > sr->sr_ext_len) {
-				/*
-				 * Apply a hard cap to the number of extents.
-				 * If we have more, assume something is wrong.
-				 */
-				if (count > MAX_EXTENTS) {
-					dout("%s: OSD returned 0x%x extents in a single reply!\n",
-					     __func__, count);
-					return -EREMOTEIO;
-				}
-
 				/* no extent array provided, or too short */
 				kfree(sr->sr_extent);
 				sr->sr_extent = kmalloc_array(count,
 							      sizeof(*sr->sr_extent),
 							      GFP_NOIO);
-				if (!sr->sr_extent)
+				if (!sr->sr_extent) {
+					pr_err("%s: failed to allocate %u sparse read extents\n",
+					       __func__, count);
 					return -ENOMEM;
+				}
 				sr->sr_ext_len = count;
 			}
 			ret = count * sizeof(*sr->sr_extent);
-- 
2.41.0


