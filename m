Return-Path: <ceph-devel+bounces-28-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 871D07DFE72
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Nov 2023 04:41:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B50D2B21351
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Nov 2023 03:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FEB215C0;
	Fri,  3 Nov 2023 03:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FJAanasa"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C0A7E
	for <ceph-devel@vger.kernel.org>; Fri,  3 Nov 2023 03:41:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9A51A1
	for <ceph-devel@vger.kernel.org>; Thu,  2 Nov 2023 20:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698982879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MqLiB/+bzYZj9l/XajEoQRxw0UD32Ekm65PUDSpL8UM=;
	b=FJAanasaIjJNeSV9/qvb14ssOUjbSvn9lrJwFCHMt92zk70mQi+nvn1b+uvTW1455GNp8q
	C18JBKqAi0vXTdY6Ken12LQzctjuVoUk6s0Z/PIeCKQf7TCNLUnU+OuicvGlQuO0zEIDUJ
	TNhTO7wOtS+KNnjRA7bvYar8RIq6S6E=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-468-hjKzPxtZOb63pEFsjw_k_w-1; Thu,
 02 Nov 2023 23:41:15 -0400
X-MC-Unique: hjKzPxtZOb63pEFsjw_k_w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71CCD2808FC8;
	Fri,  3 Nov 2023 03:41:15 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.124])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B711225C0;
	Fri,  3 Nov 2023 03:41:12 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] libceph: remove the max extents check for sparse read
Date: Fri,  3 Nov 2023 11:39:00 +0800
Message-ID: <20231103033900.122990-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

From: Xiubo Li <xiubli@redhat.com>

There is no any limit for the extent array size and it's possible
that when reading with a large size contents. Else the messager
will fail by reseting the connection and keeps resending the inflight
IOs.

URL: https://tracker.ceph.com/issues/62081
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 net/ceph/osd_client.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 7af35106acaf..177a1d92c517 100644
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
@@ -5882,16 +5880,6 @@ static int osd_sparse_read(struct ceph_connection *con,
 
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
-- 
2.39.1


