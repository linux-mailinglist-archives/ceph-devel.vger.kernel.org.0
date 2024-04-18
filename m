Return-Path: <ceph-devel+bounces-1100-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A40D48A9CF8
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Apr 2024 16:26:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60B4128219B
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Apr 2024 14:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C30D1168B06;
	Thu, 18 Apr 2024 14:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jce5rIBB"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF6816E897
	for <ceph-devel@vger.kernel.org>; Thu, 18 Apr 2024 14:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713450179; cv=none; b=tUz2Io0hV1yAn1R2cCVTmtewYdCTe1O9ybV2KksEd6VIMaDigctxKHo+p5vOh7GF/40jgKtJLk+d5L+ftHA/cOp37+SQutKjFHk4c3UfMML+cGCDut5ZZYKTow/5sXfqxdSXj9ER825bWC4RIvQJEzWFe9qhnXOJAcdTkVGXNm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713450179; c=relaxed/simple;
	bh=72AnnAUiezh+FbXgLGnLYxiCZu3uG/Vh/gdvX/Z/Egc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgKbtQp8hDRXMNCp188bc6FlAcIa1+/Osp8GR5ai6UGiWYJju03Hu+hI0g5ZpqhbENRGXS0xzi4kvufi6PePMXZqD3ngZmj4TgiElFwiATf/lgl+fCAXi5h9bIFs7JMFPdk5bkourzqohj1Pt1GGtTJMMGj738yXTDmkDYlr7sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jce5rIBB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713450177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=405/Ib014H0t8PmuvN85ek41Br4yY4YaM7xugt0iZck=;
	b=Jce5rIBBxdgFgocZlX9A0FHTAOVDZDgLiVL1qJ27rqw/CEaOxi5SwnQEQvpjciLULM1vXE
	WvLJBXnVAVOUxy+AhS8bxylwDxY66xXvqhGSVLbrsLsU9/o2vBdMlWQXC0efrWTu45BZWM
	b2U+an3ZH7S9/buw3hnEvV+PB8Kukek=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-327-faGbicrrOG6XdDYB_LbONQ-1; Thu, 18 Apr 2024 10:22:55 -0400
X-MC-Unique: faGbicrrOG6XdDYB_LbONQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7167D81F317;
	Thu, 18 Apr 2024 14:22:52 +0000 (UTC)
Received: from li-25d5c94c-2c69-11b2-a85c-c76ff7643ea0.ibm.com.com (unknown [10.72.116.7])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1CD8443FAD;
	Thu, 18 Apr 2024 14:22:49 +0000 (UTC)
From: xiubli@redhat.com
To: idryomov@gmail.com,
	ceph-devel@vger.kernel.org
Cc: vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v5 6/6] ceph: add CEPHFS_FEATURE_MDS_AUTH_CAPS_CHECK feature bit
Date: Thu, 18 Apr 2024 22:20:19 +0800
Message-ID: <20240418142019.133191-7-xiubli@redhat.com>
In-Reply-To: <20240418142019.133191-1-xiubli@redhat.com>
References: <20240418142019.133191-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

From: Xiubo Li <xiubli@redhat.com>

Since we have support checking the mds auth cap in kclient, just
set the feature bit.

URL: https://tracker.ceph.com/issues/61333
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 4c45b95abbcd..a58bcf7491d0 100644
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
2.43.0


