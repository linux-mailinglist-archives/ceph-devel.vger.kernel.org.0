Return-Path: <ceph-devel+bounces-10-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A6CB7D6193
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Oct 2023 08:22:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3B0F281CEA
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Oct 2023 06:22:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7A7F15AD6;
	Wed, 25 Oct 2023 06:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZMttTmm6"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D1C156E7
	for <ceph-devel@vger.kernel.org>; Wed, 25 Oct 2023 06:22:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18589137
	for <ceph-devel@vger.kernel.org>; Tue, 24 Oct 2023 23:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698214950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VnedWDCkdpVsct9cYBxihx7SgvdemxFh3LIWHm4FBBE=;
	b=ZMttTmm6y2BvIpsvITKw08d8ofzbuOTwiPB6x2DcBpgU1DI48S0JV3nHKUpQbwtzO4Zvh6
	VWFo/Vv3LNd/WgLpS5Z4dpdHR84dw5UR6AN71j+OFj7HGHWAJ3t0bKJNjfZIuRls3QEDOV
	dwiVNOMeqn1rxNELElyCuMspaLDtOvw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-ew1I2qyhM0C3pbKIUZZETQ-1; Wed, 25 Oct 2023 02:22:21 -0400
X-MC-Unique: ew1I2qyhM0C3pbKIUZZETQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B53B857F8C;
	Wed, 25 Oct 2023 06:22:21 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.168])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CDEBB8C0B;
	Wed, 25 Oct 2023 06:22:18 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 2/2] ceph: add ceph_cap_unlink_work to fire check caps immediately
Date: Wed, 25 Oct 2023 14:19:52 +0800
Message-ID: <20231025061952.288730-3-xiubli@redhat.com>
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

When unlinking a file the check caps could be delayed for more than
5 seconds, but in MDS side it maybe waiting for the clients to
release caps.

This will add a dedicated work queue and list to help trigger to
fire the check caps and dirty buffer flushing immediately.

URL: https://tracker.ceph.com/issues/50223
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c       | 17 ++++++++++++++++-
 fs/ceph/mds_client.c | 34 ++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.h |  4 ++++
 3 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 9b9ec1adc19d..be4f986e082d 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4790,7 +4790,22 @@ int ceph_drop_caps_for_unlink(struct inode *inode)
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
+			schedule_work(&mdsc->cap_unlink_work);
 		}
 	}
 	spin_unlock(&ci->i_ceph_lock);
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 6fa7134beec8..a7bffb030036 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2500,6 +2500,37 @@ void ceph_reclaim_caps_nr(struct ceph_mds_client *mdsc, int nr)
 	}
 }
 
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
@@ -5372,6 +5403,8 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 	INIT_LIST_HEAD(&mdsc->cap_delay_list);
 	INIT_LIST_HEAD(&mdsc->cap_wait_list);
 	spin_lock_init(&mdsc->cap_delay_lock);
+	INIT_LIST_HEAD(&mdsc->cap_unlink_delay_list);
+	spin_lock_init(&mdsc->cap_unlink_delay_lock);
 	INIT_LIST_HEAD(&mdsc->snap_flush_list);
 	spin_lock_init(&mdsc->snap_flush_lock);
 	mdsc->last_cap_flush_tid = 1;
@@ -5380,6 +5413,7 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 	spin_lock_init(&mdsc->cap_dirty_lock);
 	init_waitqueue_head(&mdsc->cap_flushing_wq);
 	INIT_WORK(&mdsc->cap_reclaim_work, ceph_cap_reclaim_work);
+	INIT_WORK(&mdsc->cap_unlink_work, ceph_cap_unlink_work);
 	err = ceph_metric_init(&mdsc->metric);
 	if (err)
 		goto err_mdsmap;
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 2e6ddaa13d72..f25117fa910f 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -462,6 +462,8 @@ struct ceph_mds_client {
 	unsigned long    last_renew_caps;  /* last time we renewed our caps */
 	struct list_head cap_delay_list;   /* caps with delayed release */
 	spinlock_t       cap_delay_lock;   /* protects cap_delay_list */
+	struct list_head cap_unlink_delay_list;  /* caps with delayed release for unlink */
+	spinlock_t       cap_unlink_delay_lock;  /* protects cap_unlink_delay_list */
 	struct list_head snap_flush_list;  /* cap_snaps ready to flush */
 	spinlock_t       snap_flush_lock;
 
@@ -475,6 +477,8 @@ struct ceph_mds_client {
 	struct work_struct cap_reclaim_work;
 	atomic_t	   cap_reclaim_pending;
 
+	struct work_struct cap_unlink_work;
+
 	/*
 	 * Cap reservations
 	 *
-- 
2.39.1


