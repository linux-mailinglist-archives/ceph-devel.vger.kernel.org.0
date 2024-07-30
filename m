Return-Path: <ceph-devel+bounces-1611-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DFBD9407B4
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jul 2024 07:42:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F5311C22325
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jul 2024 05:42:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96FE8167D83;
	Tue, 30 Jul 2024 05:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U1a/butG"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BB016133E
	for <ceph-devel@vger.kernel.org>; Tue, 30 Jul 2024 05:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722318121; cv=none; b=GJUuP8D6wP7CU8HCNapkrebGOYpvb0It0/I1UKEAzdSLdJzoGDW/S35AZBlHm7TcLRoS0fmqwKh3b0PcBqsUEQ8LuM64aWu6Xvr8mNRUotcV3HmuXXcW/TleugxeAHBB0bHCP4QPZoztX+wG4Pzct7ALyZtkIzk1ffIyjkrbsxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722318121; c=relaxed/simple;
	bh=qHR0iMONiXxSJaSqwu9Okve39ObHtdXnsCzBlRprJSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLs3oeNAtRe8YQyNnHKt96O/lb7iRkb0+fZFrBJsDsxcWSYb8Vkr4mSLBCWs7xM4o2t/oUtBvUC0UgC83dY4z+Tw1YP5w045vJebJltUVIT3khYnT0jp1CR7TDWPhPlyYlgfkE7L+qU8vSYud9mZ2rxw0+ziNneUU4tPj6JeOqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U1a/butG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722318117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aee2aAqctAeG8+ua65z2QTPGM3CW/M53YTyrDhg+Zpk=;
	b=U1a/butGDU3Vw8tNYBTnphbvYssiOtc5v4j6WbAPZeeXW1/TN8VBDo1UB9CwHY3NjzAzJG
	4CZTP12zn1O4Sg7H16pLS1U67zTWta5XthsK3wq71igJN3mLdrtQf8KPm+pf2vBLl10xSl
	MebSsy6opCewhKP8jJhQRyvTQ/ECQIs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-70-IZ_ldJ7LNIu6JoPHuaf7Zg-1; Tue,
 30 Jul 2024 01:41:54 -0400
X-MC-Unique: IZ_ldJ7LNIu6JoPHuaf7Zg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA1741955D4D;
	Tue, 30 Jul 2024 05:41:53 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.72.116.98])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 96AA819560AE;
	Tue, 30 Jul 2024 05:41:50 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	vshankar@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 2/2] ceph: flush all the caps release when syncing the whole filesystem
Date: Tue, 30 Jul 2024 13:41:35 +0800
Message-ID: <20240730054135.640396-3-xiubli@redhat.com>
In-Reply-To: <20240730054135.640396-1-xiubli@redhat.com>
References: <20240730054135.640396-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Xiubo Li <xiubli@redhat.com>

We have hit a race between cap releases and cap revoke request
that will cause the check_caps() to miss sending a cap revoke ack
to MDS. And the client will depend on the cap release to release
that revoking caps, which could be delayed for some unknown reasons.

In Kclient we have figured out the RCA about race and we need
a way to explictly trigger this manually could help to get rid
of the caps revoke stuck issue.

URL: https://tracker.ceph.com/issues/67221
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c       | 22 ++++++++++++++++++++++
 fs/ceph/mds_client.c |  1 +
 fs/ceph/super.c      |  1 +
 fs/ceph/super.h      |  1 +
 4 files changed, 25 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index c09add6d6516..a0a39243aeb3 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4729,6 +4729,28 @@ void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc)
 	ceph_mdsc_iterate_sessions(mdsc, flush_dirty_session_caps, true);
 }
 
+/*
+ * Flush all cap releases to the mds
+ */
+static void flush_cap_releases(struct ceph_mds_session *s)
+{
+	struct ceph_mds_client *mdsc = s->s_mdsc;
+	struct ceph_client *cl = mdsc->fsc->client;
+
+	doutc(cl, "begin\n");
+	spin_lock(&s->s_cap_lock);
+	if (s->s_num_cap_releases)
+		ceph_flush_session_cap_releases(mdsc, s);
+	spin_unlock(&s->s_cap_lock);
+	doutc(cl, "done\n");
+
+}
+
+void ceph_flush_cap_releases(struct ceph_mds_client *mdsc)
+{
+	ceph_mdsc_iterate_sessions(mdsc, flush_cap_releases, true);
+}
+
 void __ceph_touch_fmode(struct ceph_inode_info *ci,
 			struct ceph_mds_client *mdsc, int fmode)
 {
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 86d0148819b0..fc563b59959a 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5904,6 +5904,7 @@ void ceph_mdsc_sync(struct ceph_mds_client *mdsc)
 	want_tid = mdsc->last_tid;
 	mutex_unlock(&mdsc->mutex);
 
+	ceph_flush_cap_releases(mdsc);
 	ceph_flush_dirty_caps(mdsc);
 	spin_lock(&mdsc->cap_dirty_lock);
 	want_flush = mdsc->last_cap_flush_tid;
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index f489b3e12429..0a1215b4f0ba 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -126,6 +126,7 @@ static int ceph_sync_fs(struct super_block *sb, int wait)
 	if (!wait) {
 		doutc(cl, "(non-blocking)\n");
 		ceph_flush_dirty_caps(fsc->mdsc);
+		ceph_flush_cap_releases(fsc->mdsc);
 		doutc(cl, "(non-blocking) done\n");
 		return 0;
 	}
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 831e8ec4d5da..5645121337cf 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1273,6 +1273,7 @@ extern bool __ceph_should_report_size(struct ceph_inode_info *ci);
 extern void ceph_check_caps(struct ceph_inode_info *ci, int flags);
 extern unsigned long ceph_check_delayed_caps(struct ceph_mds_client *mdsc);
 extern void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc);
+extern void ceph_flush_cap_releases(struct ceph_mds_client *mdsc);
 extern int  ceph_drop_caps_for_unlink(struct inode *inode);
 extern int ceph_encode_inode_release(void **p, struct inode *inode,
 				     int mds, int drop, int unless, int force);
-- 
2.43.0


