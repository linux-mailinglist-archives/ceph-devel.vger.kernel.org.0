Return-Path: <ceph-devel+bounces-920-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DD578689F0
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Feb 2024 08:35:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED35C288FE7
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Feb 2024 07:35:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA55F54F91;
	Tue, 27 Feb 2024 07:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dvw/8HoN"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F1554BC8
	for <ceph-devel@vger.kernel.org>; Tue, 27 Feb 2024 07:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709019317; cv=none; b=m5qwbLDmRQsKMT6y81HwPYabU03nWE9BjvY/cYoG6O8kbUCFc+FsDPM8K6Aq3AFdsQtFjAKNkGvJh98iORzSOlVmjFCdK/7kEYZpdQa8JhvlqvOcd+TGDNumlTeVJUBEMf4mdSCWYLIx1KPSd4nz2WXLfYTwkNn2llfo2yRQNv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709019317; c=relaxed/simple;
	bh=SbnvlbVLSrVUIa12z554E3ZwgFFhW67FWkmcrg/edHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4iFgOM0VcneoikecqHO4ggBgSpOkYT+RZNli8/1fFUQJkorlS7c29v/TvoN8xngwtPdb1S/ubYW+22zeK/igSrEx3cF0Q8nQksA4fKc8qlap5DlybJ6t8copkxP/VRWd107Oz3kstjJBT3WGGuSCPbyYzfCjNp/CS3WpWmxD8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dvw/8HoN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709019315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GLFW9RwKtlppoBE+ulPAYSDrSOVlLSJlI0YwqnhKTYg=;
	b=dvw/8HoNiVVF+hJhO53oQ890CilvI92m1nVBHyKCT4QbJWg+kCIt1Q+6mQvewmMHvjGIt1
	HmiZq+g+a4wJ+eWKQ5QCvj2T+t1161C8+o/zzyi8sdZewN36wyZRbJgGhIN9esKfm7H/1c
	BQxeETlXWbyJXevmgeSLWmUycLbvFTM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-681-vIUJLW1YMyWcfMyWET3q2Q-1; Tue,
 27 Feb 2024 02:35:13 -0500
X-MC-Unique: vIUJLW1YMyWcfMyWET3q2Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 47F5B3C2B608;
	Tue, 27 Feb 2024 07:35:13 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.214])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7D0A02166B33;
	Tue, 27 Feb 2024 07:35:10 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 6/6] ceph: add CEPHFS_FEATURE_MDS_AUTH_CAPS_CHECK feature bit
Date: Tue, 27 Feb 2024 15:27:05 +0800
Message-ID: <20240227072705.593676-7-xiubli@redhat.com>
In-Reply-To: <20240227072705.593676-1-xiubli@redhat.com>
References: <20240227072705.593676-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Xiubo Li <xiubli@redhat.com>

Since we have support checking the mds auth cap in kclient, just
set the feature bit.

URL: https://tracker.ceph.com/issues/61333
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 3d9107f72553..317a0fd6a8ba 100644
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


