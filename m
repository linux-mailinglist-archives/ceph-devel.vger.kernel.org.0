Return-Path: <ceph-devel+bounces-563-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ABF4F82FF8F
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Jan 2024 05:30:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 362581F24FBA
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Jan 2024 04:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59F1D79CD;
	Wed, 17 Jan 2024 04:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ARwlG1sR"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB4C8BF9
	for <ceph-devel@vger.kernel.org>; Wed, 17 Jan 2024 04:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705465820; cv=none; b=SPXGex9EEMXGV14PBcFSJ1AKYv9G+wI4VOjHgtIDShkrqsiUgek830aZzQRLu32iF8QJOwLAnrxDpF58Z20OuqJZHUY74oMpl3Pno6zz1AzJv/Q7QEAqsamldmqMNCcIiXQx5Nu/n8VwJ/MhxE26LIZvlbsaQlqqGAu9ajR89q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705465820; c=relaxed/simple;
	bh=Y2xQc6iQRpib9EmrRH/Ps7tLN7TLp6U/v2kzW/km0Iw=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By; b=Z/Ps9D88IYRs5rUZFI714UnKDsFTDQ8oaz25cwqI1F2XUAFYk+W1EahhOG3mWSpSwhBbxqmrf0vZncdaa9q3uUwosfuxyaocq/3w158s4aATkHWI4v/pvnMFQSFZLy0LEaN6hGj23aZFuADkyXFJ1XmWfxaFeWm92DjDUIG7s5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ARwlG1sR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705465817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xQJKAV6VC4PRQoyOW9WTIgv0wlr9BWcq9NMhaHk/4Ow=;
	b=ARwlG1sRsmToObonVUCHd2+6fFyHDasOlZnMe1A1Ok2nl4kLGYzPcoPA+eaZEFvkTgq2sG
	74m6F5PVC2dJ00ZSZEcwy3U3X1AhmA4jwswt+dIExItqbj/sVeXaLuxN8gh5Vo6W6yLiWM
	Q8rv4hby7+JvOWYhC28SeAzAmxNeJPI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-aWcZ3j0PODaM1sxOSTxCSw-1; Tue, 16 Jan 2024 23:30:12 -0500
X-MC-Unique: aWcZ3j0PODaM1sxOSTxCSw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B52E385A596;
	Wed, 17 Jan 2024 04:30:11 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.62])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F079F1121312;
	Wed, 17 Jan 2024 04:30:08 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 2/2] ceph: add ceph_cap_unlink_work to fire check_caps() immediately
Date: Wed, 17 Jan 2024 12:27:58 +0800
Message-ID: <20240117042758.700349-3-xiubli@redhat.com>
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

When unlinking a file the check caps could be delayed for more than
5 seconds, but in MDS side it maybe waiting for the clients to
release caps.

This will use the cap_wq work queue and a dedicated list to help
fire the check_caps() and dirty buffer flushing immediately.

URL: https://tracker.ceph.com/issues/50223
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c       | 17 +++++++++++++++-
 fs/ceph/mds_client.c | 48 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.h |  5 +++++
 3 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index c0db0e9e82d2..ba94ad6d45fe 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4785,7 +4785,22 @@ int ceph_drop_caps_for_unlink(struct inode *inode)
 		if (__ceph_caps_dirty(ci)) {
 			struct ceph_mds_client *mdsc =
 				ceph_inode_to_fs_client(inode)->mdsc;
-			__cap_delay_requeue_front(mdsc, ci);
+
+			doutc(mdsc->fsc->client, "%p %llx.%llx\n", inode,
+			      ceph_vinop(inode));
+			spin_lock(&mdsc->cap_unlink_delay_lock);
+			ci->i_ceph_flags |= CEPH_I_FLUSH;
+			if (!list_empty(&ci->i_cap_delay_list))
+				list_del_init(&ci->i_cap_delay_list);
+			list_add_tail(&ci->i_cap_delay_list,
+				      &mdsc->cap_unlink_delay_list);
+			spin_unlock(&mdsc->cap_unlink_delay_lock);
+
+			/*
+			 * Fire the work immediately, because the MDS maybe
+			 * waiting for caps release.
+			 */
+			ceph_queue_cap_unlink_work(mdsc);
 		}
 	}
 	spin_unlock(&ci->i_ceph_lock);
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 29295041b7b4..e2352e94c5bc 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2512,6 +2512,50 @@ void ceph_reclaim_caps_nr(struct ceph_mds_client *mdsc, int nr)
 	}
 }
 
+void ceph_queue_cap_unlink_work(struct ceph_mds_client *mdsc)
+{
+	struct ceph_client *cl = mdsc->fsc->client;
+	if (mdsc->stopping)
+		return;
+
+        if (queue_work(mdsc->fsc->cap_wq, &mdsc->cap_unlink_work)) {
+                doutc(cl, "caps unlink work queued\n");
+        } else {
+                doutc(cl, "failed to queue caps unlink work\n");
+        }
+}
+
+static void ceph_cap_unlink_work(struct work_struct *work)
+{
+	struct ceph_mds_client *mdsc =
+		container_of(work, struct ceph_mds_client, cap_unlink_work);
+	struct ceph_client *cl = mdsc->fsc->client;
+
+	doutc(cl, "begin\n");
+	spin_lock(&mdsc->cap_unlink_delay_lock);
+	while (!list_empty(&mdsc->cap_unlink_delay_list)) {
+		struct ceph_inode_info *ci;
+		struct inode *inode;
+
+		ci = list_first_entry(&mdsc->cap_unlink_delay_list,
+				      struct ceph_inode_info,
+				      i_cap_delay_list);
+		list_del_init(&ci->i_cap_delay_list);
+
+		inode = igrab(&ci->netfs.inode);
+		if (inode) {
+			spin_unlock(&mdsc->cap_unlink_delay_lock);
+			doutc(cl, "on %p %llx.%llx\n", inode,
+			      ceph_vinop(inode));
+			ceph_check_caps(ci, CHECK_CAPS_FLUSH);
+			iput(inode);
+			spin_lock(&mdsc->cap_unlink_delay_lock);
+		}
+	}
+	spin_unlock(&mdsc->cap_unlink_delay_lock);
+	doutc(cl, "done\n");
+}
+
 /*
  * requests
  */
@@ -5493,6 +5537,8 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 	INIT_LIST_HEAD(&mdsc->cap_delay_list);
 	INIT_LIST_HEAD(&mdsc->cap_wait_list);
 	spin_lock_init(&mdsc->cap_delay_lock);
+	INIT_LIST_HEAD(&mdsc->cap_unlink_delay_list);
+	spin_lock_init(&mdsc->cap_unlink_delay_lock);
 	INIT_LIST_HEAD(&mdsc->snap_flush_list);
 	spin_lock_init(&mdsc->snap_flush_lock);
 	mdsc->last_cap_flush_tid = 1;
@@ -5501,6 +5547,7 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 	spin_lock_init(&mdsc->cap_dirty_lock);
 	init_waitqueue_head(&mdsc->cap_flushing_wq);
 	INIT_WORK(&mdsc->cap_reclaim_work, ceph_cap_reclaim_work);
+	INIT_WORK(&mdsc->cap_unlink_work, ceph_cap_unlink_work);
 	err = ceph_metric_init(&mdsc->metric);
 	if (err)
 		goto err_mdsmap;
@@ -5931,6 +5978,7 @@ void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
 	ceph_cleanup_global_and_empty_realms(mdsc);
 
 	cancel_work_sync(&mdsc->cap_reclaim_work);
+	cancel_work_sync(&mdsc->cap_unlink_work);
 	cancel_delayed_work_sync(&mdsc->delayed_work); /* cancel timer */
 
 	doutc(cl, "done\n");
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 65f0720d1671..317a0fd6a8ba 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -482,6 +482,8 @@ struct ceph_mds_client {
 	unsigned long    last_renew_caps;  /* last time we renewed our caps */
 	struct list_head cap_delay_list;   /* caps with delayed release */
 	spinlock_t       cap_delay_lock;   /* protects cap_delay_list */
+	struct list_head cap_unlink_delay_list;  /* caps with delayed release for unlink */
+	spinlock_t       cap_unlink_delay_lock;  /* protects cap_unlink_delay_list */
 	struct list_head snap_flush_list;  /* cap_snaps ready to flush */
 	spinlock_t       snap_flush_lock;
 
@@ -495,6 +497,8 @@ struct ceph_mds_client {
 	struct work_struct cap_reclaim_work;
 	atomic_t	   cap_reclaim_pending;
 
+	struct work_struct cap_unlink_work;
+
 	/*
 	 * Cap reservations
 	 *
@@ -597,6 +601,7 @@ extern void ceph_flush_cap_releases(struct ceph_mds_client *mdsc,
 				    struct ceph_mds_session *session);
 extern void ceph_queue_cap_reclaim_work(struct ceph_mds_client *mdsc);
 extern void ceph_reclaim_caps_nr(struct ceph_mds_client *mdsc, int nr);
+extern void ceph_queue_cap_unlink_work(struct ceph_mds_client *mdsc);
 extern int ceph_iterate_session_caps(struct ceph_mds_session *session,
 				     int (*cb)(struct inode *, int mds, void *),
 				     void *arg);
-- 
2.43.0


