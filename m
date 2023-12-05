Return-Path: <ceph-devel+bounces-195-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B31B8043E4
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Dec 2023 02:17:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCE191C20C74
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Dec 2023 01:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AECBB1375;
	Tue,  5 Dec 2023 01:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UvpjQiUw"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF900111
	for <ceph-devel@vger.kernel.org>; Mon,  4 Dec 2023 17:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701739042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GiDZOQBiKnWmaDfjTKtNgKLu1hWO56EX9C6xsB2O6n4=;
	b=UvpjQiUwjAWor5TwoGe//VgBZ4fvMGhW0/oxCkYNgxNe2tdQLdzvMBHGqqkMw9sburHVcI
	QD2c8lUyyl/vy4oe1qf7uDz+mLQ5zZUkwjcvXdBp32lmMIrbn0+ja/xnKRfaglH7zDPY/B
	pLGknEWlUEjC+rqjeETKlNPB4KX5BfA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-Qx49NPp1MCKgNy1MjfuLOQ-1; Mon, 04 Dec 2023 20:17:19 -0500
X-MC-Unique: Qx49NPp1MCKgNy1MjfuLOQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CDCCC185A783;
	Tue,  5 Dec 2023 01:17:18 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.113.153])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 199CC492BE0;
	Tue,  5 Dec 2023 01:17:15 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 6/6] ceph: add CEPHFS_FEATURE_MDS_AUTH_CAPS_CHECK feature bit
Date: Tue,  5 Dec 2023 09:14:39 +0800
Message-ID: <20231205011439.84238-7-xiubli@redhat.com>
In-Reply-To: <20231205011439.84238-1-xiubli@redhat.com>
References: <20231205011439.84238-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

From: Xiubo Li <xiubli@redhat.com>

Since we have support checking the mds auth cap in kclient, just
set the feature bit.

URL: https://tracker.ceph.com/issues/61333
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 8be57267c253..e85172a92e6c 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -35,8 +35,9 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_32BITS_RETRY_FWD,
 	CEPHFS_FEATURE_NEW_SNAPREALM_INFO,
 	CEPHFS_FEATURE_HAS_OWNER_UIDGID,
+	CEPHFS_FEATURE_MDS_AUTH_CAPS_CHECK,
 
-	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_HAS_OWNER_UIDGID,
+	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_MDS_AUTH_CAPS_CHECK,
 };
 
 #define CEPHFS_FEATURES_CLIENT_SUPPORTED {	\
@@ -52,6 +53,7 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_OP_GETVXATTR,		\
 	CEPHFS_FEATURE_32BITS_RETRY_FWD,	\
 	CEPHFS_FEATURE_HAS_OWNER_UIDGID,	\
+	CEPHFS_FEATURE_MDS_AUTH_CAPS_CHECK,	\
 }
 
 /*
-- 
2.41.0


