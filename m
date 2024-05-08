Return-Path: <ceph-devel+bounces-1134-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 591228BF9B9
	for <lists+ceph-devel@lfdr.de>; Wed,  8 May 2024 11:44:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE56A1F24338
	for <lists+ceph-devel@lfdr.de>; Wed,  8 May 2024 09:44:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7E217A15C;
	Wed,  8 May 2024 09:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="My78PoTV"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF04A78C98
	for <ceph-devel@vger.kernel.org>; Wed,  8 May 2024 09:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715161442; cv=none; b=AFgxfEjFornIS10DrbCBkozSthJQEbk0keTZ+YIjQsArMs8njOfspFd0CD+K2Ft7pCs3DCFb0F5SMkA8YZZC4+m635Tx9iYGM5Tk8oeoaE5R8gfUOUZGJR/i8xsjJeQCp9gEsxE+jaZA/5frVxQHn0rWiaqU2tejVn5EQtYUhr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715161442; c=relaxed/simple;
	bh=kSW/pT/O7/Iw5xbxsAXp1TlMty8Qliv7zEd21f+55Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XeYfabERvhHdL65zGvJPDUSLGGCXBQMFyfJeezgQXrqq/0jiUAizsLSJxvqlIuUxP8VPecgnt2cetlBaZE3QqI5Vx737AMcUa5OnZO0oevaVW2sd3huRFqjQ4IvZcRBVp4DQfc2ayfUXDky8ivLe9PWUhuEQamMPmunnsLCTnBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=My78PoTV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715161439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kZJGjN0aaOfyYHY5FWaP8VsGSluVnWbx5jZl5CWflhY=;
	b=My78PoTVSnH+IRyJ/OgUPjsj+8FXrXKKeBWRBe4IDKcyfxmErhwTT9DIifT3k4L6S58dYD
	+0hynq+ubqCsemTjbz9+tRLQ8kfXN2Y+FjMSyG0edaBr/XzNMLRhRz93RrjVFC1GAAxGli
	vXDT3ImZzmC/VQFB1h8SXvLsAw0nUhs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-6FhHQbQMMY2eVxds6QPTng-1; Wed, 08 May 2024 05:43:56 -0400
X-MC-Unique: 6FhHQbQMMY2eVxds6QPTng-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AFB3B185A780;
	Wed,  8 May 2024 09:43:55 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.72.116.76])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 330B440C6EB7;
	Wed,  8 May 2024 09:43:52 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org,
	idryomov@gmail.com
Cc: vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: defer clearing the CEPH_I_FLUSH_SNAPS flag
Date: Wed,  8 May 2024 17:43:49 +0800
Message-ID: <20240508094349.179222-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

From: Xiubo Li <xiubli@redhat.com>

Clear the flag just after the capsnap request being sent out. Else the
ceph_check_caps() will race with it and send the cap update request
just before this capsnap request. Which will cause the cap update request
to miss setting the CEPH_CLIENT_CAPS_PENDING_CAPSNAP flag and finally
the mds will drop the capsnap request to floor.

URL: https://tracker.ceph.com/issues/64209
URL: https://tracker.ceph.com/issues/65705
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 197cb383f829..fe6452321466 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1678,8 +1678,6 @@ static void __ceph_flush_snaps(struct ceph_inode_info *ci,
 		last_tid = capsnap->cap_flush.tid;
 	}
 
-	ci->i_ceph_flags &= ~CEPH_I_FLUSH_SNAPS;
-
 	while (first_tid <= last_tid) {
 		struct ceph_cap *cap = ci->i_auth_cap;
 		struct ceph_cap_flush *cf = NULL, *iter;
@@ -1724,6 +1722,15 @@ static void __ceph_flush_snaps(struct ceph_inode_info *ci,
 		ceph_put_cap_snap(capsnap);
 		spin_lock(&ci->i_ceph_lock);
 	}
+
+	/*
+	 * Clear the flag just after the capsnap request being sent out. Else the
+	 * ceph_check_caps() will race with it and send the cap update request
+	 * just before this capsnap request. Which will cause the cap update request
+	 * to miss setting the CEPH_CLIENT_CAPS_PENDING_CAPSNAP flag and finally
+	 * the mds will drop the capsnap request to floor.
+	 */
+	ci->i_ceph_flags &= ~CEPH_I_FLUSH_SNAPS;
 }
 
 void ceph_flush_snaps(struct ceph_inode_info *ci,
-- 
2.44.0


