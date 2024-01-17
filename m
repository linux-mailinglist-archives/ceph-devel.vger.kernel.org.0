Return-Path: <ceph-devel+bounces-562-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CE3C482FF8E
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Jan 2024 05:30:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01871B249AF
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Jan 2024 04:30:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41CDE522D;
	Wed, 17 Jan 2024 04:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CE/TuThN"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BBE567D
	for <ceph-devel@vger.kernel.org>; Wed, 17 Jan 2024 04:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705465814; cv=none; b=BIf0Kxo04ElU6qaB93zYHuAJGcYuaqtm2zIwviFyp+sbkGPUjN8iyYf0PvjObHZat6rwbh/xg3+VR7jhDh4GWpozNZhdurdtnysDdnxsS2/7qfSs5E1WSw5y5tFuXyrEwWtfOMc4tvC7Gyk2PChPTWaL3/iqIq2ef4ouMgSIuAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705465814; c=relaxed/simple;
	bh=E43VpoJIcSq8PNzNsJmooln23Go6+xdzsX7h1n3Ii6w=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By; b=t3U6Dk97vQSJoW5AerV6kFlXXApTcnULV1IbKKMTSlsjrI4/QHc9ST1h9MywMeDYB8BWHC+yr6kY77oIMyEs/xpbAkyt/1ic70w4/pQE0ZxCY4+Exbn42xzBFpp89pVPhJn1GqE6m22QmI8hSiyV8pV2aw6X9iF33c7TJ5G494s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CE/TuThN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705465812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+uzdBfR5/2PaOl6B3M+7Cg+XVN3GWlPHSv3YKK1eEss=;
	b=CE/TuThN0e2yb0McWK1rt9x90VR9i3XiY0c+wJbaVQADbb/f58l9/X7TOyIsd81mew5ZoI
	83N+2KHP8qQdIlQnOCQ6gGpUyf+KSQz8C50vhxPadv3lIfyNZMCKhpvY7KtNpTPTzzOa+I
	rIqLOcnk4hptUUsLClzCmqNNMoxyhCo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-621-JpZwPweVN66ch1K5inBz7g-1; Tue,
 16 Jan 2024 23:30:08 -0500
X-MC-Unique: JpZwPweVN66ch1K5inBz7g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 519BA3C0F1A2;
	Wed, 17 Jan 2024 04:30:08 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.62])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8C76E1121306;
	Wed, 17 Jan 2024 04:30:05 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 1/2] ceph: always queue a writeback when revoking the Fb caps
Date: Wed, 17 Jan 2024 12:27:57 +0800
Message-ID: <20240117042758.700349-2-xiubli@redhat.com>
In-Reply-To: <20240117042758.700349-1-xiubli@redhat.com>
References: <20240117042758.700349-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

From: Xiubo Li <xiubli@redhat.com>

In case there is 'Fw' dirty caps and 'CHECK_CAPS_FLUSH' is set we
will always ignore queue a writeback. Queue a writeback is very
important because it will block kclient flushing the snapcaps to
MDS and which will block MDS waiting for revoking the 'Fb' caps.

URL: https://tracker.ceph.com/issues/50223
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index b8a8e0d3c6b7..c0db0e9e82d2 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2156,6 +2156,30 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags)
 		      ceph_cap_string(cap->implemented),
 		      ceph_cap_string(revoking));
 
+		/* completed revocation? going down and there are no caps? */
+		if (revoking) {
+			if ((revoking & cap_used) == 0) {
+				doutc(cl, "completed revocation of %s\n",
+				      ceph_cap_string(cap->implemented & ~cap->issued));
+				goto ack;
+			}
+
+			/*
+			 * If the "i_wrbuffer_ref" was increased by mmap or generic
+			 * cache write just before the ceph_check_caps() is called,
+			 * the Fb capability revoking will fail this time. Then we
+			 * must wait for the BDI's delayed work to flush the dirty
+			 * pages and to release the "i_wrbuffer_ref", which will cost
+			 * at most 5 seconds. That means the MDS needs to wait at
+			 * most 5 seconds to finished the Fb capability's revocation.
+			 *
+			 * Let's queue a writeback for it.
+			 */
+			if (S_ISREG(inode->i_mode) && ci->i_wrbuffer_ref &&
+			    (revoking & CEPH_CAP_FILE_BUFFER))
+				queue_writeback = true;
+		}
+
 		if (cap == ci->i_auth_cap &&
 		    (cap->issued & CEPH_CAP_FILE_WR)) {
 			/* request larger max_size from MDS? */
@@ -2183,30 +2207,6 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags)
 			}
 		}
 
-		/* completed revocation? going down and there are no caps? */
-		if (revoking) {
-			if ((revoking & cap_used) == 0) {
-				doutc(cl, "completed revocation of %s\n",
-				      ceph_cap_string(cap->implemented & ~cap->issued));
-				goto ack;
-			}
-
-			/*
-			 * If the "i_wrbuffer_ref" was increased by mmap or generic
-			 * cache write just before the ceph_check_caps() is called,
-			 * the Fb capability revoking will fail this time. Then we
-			 * must wait for the BDI's delayed work to flush the dirty
-			 * pages and to release the "i_wrbuffer_ref", which will cost
-			 * at most 5 seconds. That means the MDS needs to wait at
-			 * most 5 seconds to finished the Fb capability's revocation.
-			 *
-			 * Let's queue a writeback for it.
-			 */
-			if (S_ISREG(inode->i_mode) && ci->i_wrbuffer_ref &&
-			    (revoking & CEPH_CAP_FILE_BUFFER))
-				queue_writeback = true;
-		}
-
 		/* want more caps from mds? */
 		if (want & ~cap->mds_wanted) {
 			if (want & ~(cap->mds_wanted | cap->issued))
-- 
2.43.0


