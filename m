Return-Path: <ceph-devel+bounces-1066-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 614F189D2B0
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Apr 2024 08:52:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D86128394F
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Apr 2024 06:52:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA4A06E5EC;
	Tue,  9 Apr 2024 06:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tu8fPiJl"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB8079CC
	for <ceph-devel@vger.kernel.org>; Tue,  9 Apr 2024 06:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712645545; cv=none; b=PssE4o6xD1RtaelYLXrlQh+Ygr5QSGn0eXF97tndrt8GzBJ2ch44euMoMn+mF5xbWw2iy5tkq4d2+1Ur9WTpVvO3LmhaBVQo5JUaDWBfYLDC33Nncl0JlDh9LBWcR17zKL/H5EamodlSglWW1WsJMJ9jYjoGUW2HjQNIrbo59UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712645545; c=relaxed/simple;
	bh=LSwzD4aHetqAkxJvBXtrfnOZLcwx+U/wWrQhv1YK9Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LTi9zLBvd383fS2/jnQ7rkv+mQA83MMmT/BPDhy712Of+V9MiLuyjYNKTq0Wa44RVaUuE+2g7TtGKOX/GtIZtQIFxd6Djg3at8JWG9HnWFOAVtxjBB0Bt8WhL2XHxZEUgkLJapjcDJU8Y1XxoVA4kjauG/w8aDDEZD3DolXM1Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tu8fPiJl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712645542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=V3sfUGiK27taKdjPPwYS4yvg0XTUmJbv0K1bBhfx2ME=;
	b=Tu8fPiJllBMbRR4BNhaMHHo+G3L7FJEb1sN/9AwnbIsykNgt6iMmv8DRxCrjB45KBEBgIS
	L8W3PSOMZHeb/dhdjg9cw1j4ilN4wknpNtIR+w/dB8xWiktgzMCAmeEia4ODAAoVA2p7fH
	PIigjbcxylOK9HmPlddimsOzB7cxLqQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-8-cGvNbXM2PO6CCl64SA_q0w-1; Tue,
 09 Apr 2024 02:52:18 -0400
X-MC-Unique: cGvNbXM2PO6CCl64SA_q0w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28F9429AA39D;
	Tue,  9 Apr 2024 06:52:18 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.191])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 26FC749109;
	Tue,  9 Apr 2024 06:52:14 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org,
	idryomov@gmail.com
Cc: vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>,
	Marc Ruhmann <ruhmann@luis.uni-hannover.de>
Subject: [PATCH] ceph: switch to use cap_delay_lock for the unlink delay list
Date: Tue,  9 Apr 2024 14:49:43 +0800
Message-ID: <20240409064943.1377026-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

From: Xiubo Li <xiubli@redhat.com>

The same list item will be used in both cap_delay_list and
cap_unlink_delay_list, so it's buggy to use two different locks
to protect them.

Reported-by: Marc Ruhmann <ruhmann@luis.uni-hannover.de>
Fixes: dbc347ef7f0c ("ceph: add ceph_cap_unlink_work to fire check_caps() immediately")
URL: https://lists.ceph.io/hyperkitty/list/ceph-users@ceph.io/thread/AODC76VXRAMXKLFDCTK4TKFDDPWUSCN5
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c       | 4 ++--
 fs/ceph/mds_client.c | 9 ++++-----
 fs/ceph/mds_client.h | 3 +--
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index bfa8f72cd3cf..197cb383f829 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4799,13 +4799,13 @@ int ceph_drop_caps_for_unlink(struct inode *inode)
 
 			doutc(mdsc->fsc->client, "%p %llx.%llx\n", inode,
 			      ceph_vinop(inode));
-			spin_lock(&mdsc->cap_unlink_delay_lock);
+			spin_lock(&mdsc->cap_delay_lock);
 			ci->i_ceph_flags |= CEPH_I_FLUSH;
 			if (!list_empty(&ci->i_cap_delay_list))
 				list_del_init(&ci->i_cap_delay_list);
 			list_add_tail(&ci->i_cap_delay_list,
 				      &mdsc->cap_unlink_delay_list);
-			spin_unlock(&mdsc->cap_unlink_delay_lock);
+			spin_unlock(&mdsc->cap_delay_lock);
 
 			/*
 			 * Fire the work immediately, because the MDS maybe
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 639bde44ab23..494d80b3e41d 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2532,7 +2532,7 @@ static void ceph_cap_unlink_work(struct work_struct *work)
 	struct ceph_client *cl = mdsc->fsc->client;
 
 	doutc(cl, "begin\n");
-	spin_lock(&mdsc->cap_unlink_delay_lock);
+	spin_lock(&mdsc->cap_delay_lock);
 	while (!list_empty(&mdsc->cap_unlink_delay_list)) {
 		struct ceph_inode_info *ci;
 		struct inode *inode;
@@ -2544,15 +2544,15 @@ static void ceph_cap_unlink_work(struct work_struct *work)
 
 		inode = igrab(&ci->netfs.inode);
 		if (inode) {
-			spin_unlock(&mdsc->cap_unlink_delay_lock);
+			spin_unlock(&mdsc->cap_delay_lock);
 			doutc(cl, "on %p %llx.%llx\n", inode,
 			      ceph_vinop(inode));
 			ceph_check_caps(ci, CHECK_CAPS_FLUSH);
 			iput(inode);
-			spin_lock(&mdsc->cap_unlink_delay_lock);
+			spin_lock(&mdsc->cap_delay_lock);
 		}
 	}
-	spin_unlock(&mdsc->cap_unlink_delay_lock);
+	spin_unlock(&mdsc->cap_delay_lock);
 	doutc(cl, "done\n");
 }
 
@@ -5538,7 +5538,6 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 	INIT_LIST_HEAD(&mdsc->cap_wait_list);
 	spin_lock_init(&mdsc->cap_delay_lock);
 	INIT_LIST_HEAD(&mdsc->cap_unlink_delay_list);
-	spin_lock_init(&mdsc->cap_unlink_delay_lock);
 	INIT_LIST_HEAD(&mdsc->snap_flush_list);
 	spin_lock_init(&mdsc->snap_flush_lock);
 	mdsc->last_cap_flush_tid = 1;
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 317a0fd6a8ba..80b310e33f2b 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -481,9 +481,8 @@ struct ceph_mds_client {
 	struct delayed_work    delayed_work;  /* delayed work */
 	unsigned long    last_renew_caps;  /* last time we renewed our caps */
 	struct list_head cap_delay_list;   /* caps with delayed release */
-	spinlock_t       cap_delay_lock;   /* protects cap_delay_list */
 	struct list_head cap_unlink_delay_list;  /* caps with delayed release for unlink */
-	spinlock_t       cap_unlink_delay_lock;  /* protects cap_unlink_delay_list */
+	spinlock_t       cap_delay_lock;   /* protects cap_delay_list and cap_unlink_delay_list */
 	struct list_head snap_flush_list;  /* cap_snaps ready to flush */
 	spinlock_t       snap_flush_lock;
 
-- 
2.43.0


