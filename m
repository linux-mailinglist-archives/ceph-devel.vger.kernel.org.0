Return-Path: <ceph-devel+bounces-1608-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE35F94079D
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jul 2024 07:29:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 46912B23445
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jul 2024 05:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73CE716B3B7;
	Tue, 30 Jul 2024 05:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TmqJEPri"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432B11667FA
	for <ceph-devel@vger.kernel.org>; Tue, 30 Jul 2024 05:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722317235; cv=none; b=eLjyVZFinOwT804xOkC+fJIcCNXhuHFtKJcGO2fkxzlTlpq+P8jv/V6CxSrnMc+VlHudbDQDhb5JjuCMH8naWhOP19idQcr92s1ZCRK268joGEKct/6p2WxZjID5/SmyhzCtmq6UvxcoaY9XXXLw0Um5vibnFwgUAem6a7a5GPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722317235; c=relaxed/simple;
	bh=jjbxYCRUmd/glJitkecE5Sj1VzAorY4LUms+FLHAbdk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QVbLyL7HyB2CAGFSajsF85OsBbjbB0XtJ+W0qO08+lPr2CPFc9MfgPyqfo4deaUgl+vd1kimR0RFbKlsL8ukSxN4OFcv69zkfuSr4BYk/Yl5ZVGTqA4PXRyJLe2jUJaPrdZ0ZTp5mon4/MjEqgl5q+XGzpomNlLnCG8DFE2XJqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TmqJEPri; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722317232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jhwqTIVKgMeGQuGC/4/hWcQcQg1M/PukXYrYy01uOvE=;
	b=TmqJEPri9sUqB4sXgd8yezg62c48Q0kejgmloNv5DbNDd6Il/94GDC4ej03tYkwrjwwVre
	0bVi0tInAidUKaujwufx3RbmaULRjYe0Xea1kyo0KOHWJr4rNLkWcq7Del1n9I9FbHZXkn
	sitBOoEih9sEH640B1F99egLpYguWH8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-214-EVrvrhqlM5CJCBdnwFMJqQ-1; Tue,
 30 Jul 2024 01:27:10 -0400
X-MC-Unique: EVrvrhqlM5CJCBdnwFMJqQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 50AC41955D54;
	Tue, 30 Jul 2024 05:27:09 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.72.116.98])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2F13B1955F40;
	Tue, 30 Jul 2024 05:27:05 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	vshankar@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: flush all the caps release when syncing the whole filesystem
Date: Tue, 30 Jul 2024 13:26:56 +0800
Message-ID: <20240730052656.639650-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

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
index 020bdfc7091e..64f14ee5fb97 100644
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
index 309a9691cc23..86d5ab4fd9a9 100644
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


