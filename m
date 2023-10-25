Return-Path: <ceph-devel+bounces-9-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1DFB7D6192
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Oct 2023 08:22:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5F43B2116D
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Oct 2023 06:22:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D19F154BF;
	Wed, 25 Oct 2023 06:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KkZOwXp+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A2D15AD6
	for <ceph-devel@vger.kernel.org>; Wed, 25 Oct 2023 06:22:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FCD10E
	for <ceph-devel@vger.kernel.org>; Tue, 24 Oct 2023 23:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698214946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TdXlbgwkfMWVl5lLYEP376cZGsnbcGUbwYjHotg3pFE=;
	b=KkZOwXp+0280W3ZFNViicp/kV+uB7Hgh3K7bRaCrQNiaJRKcffZUqT3lR9ANpKezd3LiEd
	bGRAcWp/jPlBV8TqPFM05E3vTixTgfklM3elh8diW5JMaRPez3IaI3c3gyQfZzroFJmNMO
	QvuGUFgvNR5NH3lJT+s7UoPW/k72gb0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-ENjFjHsQOKuPKZgsnVXlsg-1; Wed, 25 Oct 2023 02:22:18 -0400
X-MC-Unique: ENjFjHsQOKuPKZgsnVXlsg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C6F58370E2;
	Wed, 25 Oct 2023 06:22:18 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.168])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7FF6C8C0A;
	Wed, 25 Oct 2023 06:22:15 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 1/2] ceph: always queue a writeback when revoking the Fb caps
Date: Wed, 25 Oct 2023 14:19:51 +0800
Message-ID: <20231025061952.288730-2-xiubli@redhat.com>
In-Reply-To: <20231025061952.288730-1-xiubli@redhat.com>
References: <20231025061952.288730-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

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
index c72fcb5a6420..9b9ec1adc19d 100644
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
2.39.1


