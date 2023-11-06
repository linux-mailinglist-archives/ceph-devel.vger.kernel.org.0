Return-Path: <ceph-devel+bounces-39-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A08EC7E183C
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 02:05:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6E481C20A76
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 01:05:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48D7F396;
	Mon,  6 Nov 2023 01:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZLMjXwpo"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511EE19C
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 01:05:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03604BE
	for <ceph-devel@vger.kernel.org>; Sun,  5 Nov 2023 17:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699232723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/ebKuazesoDzCm18sf0uHkiN+AvthWTuxrIcdS0CzYs=;
	b=ZLMjXwpoeXfV+0ww+7xrFVHFshkL+ZfAghLAs2BIN+wLmdKB0MP/aRON/oz7WVPTdMNna3
	GBLaZrWTqDlP866IUm9rPVU56eh8u8eEZqDqACuunodZ79uXc5O3ua4K/Fy188iPrdrkUZ
	bXJ2ADeoVG6BoLbTn1E9iWgM5WBaU9g=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-219-Q6-SUzBYMiqvA1xKlFoddw-1; Sun,
 05 Nov 2023 20:05:20 -0500
X-MC-Unique: Q6-SUzBYMiqvA1xKlFoddw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8AB3829ABA2B;
	Mon,  6 Nov 2023 01:05:20 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.124])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CA1AF1121307;
	Mon,  6 Nov 2023 01:05:17 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] libceph: increase the max extents check for sparse read
Date: Mon,  6 Nov 2023 09:03:00 +0800
Message-ID: <20231106010300.247597-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

From: Xiubo Li <xiubli@redhat.com>

There is no any limit for the extent array size and it's possible
that we will hit 4096 limit just after a lot of random writes to
a file and then read with a large size. In this case the messager
will fail by reseting the connection and keeps resending the inflight
IOs infinitely.

Just increase the limit to a larger number and then warn it to
let user know that allocating memory could fail with this.

URL: https://tracker.ceph.com/issues/62081
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V2:
- Increase the MAX_EXTENTS instead of removing it.
- Do not return an errno when hit the limit.


 net/ceph/osd_client.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index c03d48bd3aff..050dc39065fb 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5850,7 +5850,7 @@ static inline void convert_extent_map(struct ceph_sparse_read *sr)
 }
 #endif
 
-#define MAX_EXTENTS 4096
+#define MAX_EXTENTS (16*1024*1024)
 
 static int osd_sparse_read(struct ceph_connection *con,
 			   struct ceph_msg_data_cursor *cursor,
@@ -5883,14 +5883,13 @@ static int osd_sparse_read(struct ceph_connection *con,
 		if (count > 0) {
 			if (!sr->sr_extent || count > sr->sr_ext_len) {
 				/*
-				 * Apply a hard cap to the number of extents.
-				 * If we have more, assume something is wrong.
+				 * Warn if hits a hard cap to the number of extents.
+				 * Too many extents could make the following
+				 * kmalloc_array() fail.
 				 */
-				if (count > MAX_EXTENTS) {
-					dout("%s: OSD returned 0x%x extents in a single reply!\n",
-					     __func__, count);
-					return -EREMOTEIO;
-				}
+				if (count > MAX_EXTENTS)
+					pr_warn_ratelimited("%s: OSD returned 0x%x extents in a single reply!\n",
+							    __func__, count);
 
 				/* no extent array provided, or too short */
 				kfree(sr->sr_extent);
-- 
2.39.1


