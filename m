Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3982558C3A1
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Aug 2022 09:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbiHHHIe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Aug 2022 03:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiHHHIc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 Aug 2022 03:08:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D1BE9260A
        for <ceph-devel@vger.kernel.org>; Mon,  8 Aug 2022 00:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659942510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zuncU+quZd4o5dPo71MMiTlizwUeWZTy3FRUsMymdCY=;
        b=iMwaCJQ6LDDJBffqG9qr5NCCWIyJUl8WBFo718xGD2nxjJzMZrNhul6HKs5bN7CJvDxjaX
        FR+PYnjnK7Kwnt39Hqd/Zah5gxtgL6vUVf60Oe/yYyFvQ5/28erfm/LKxyTxCb8nm8J9zy
        nPm6ccRONeSt4d94sHozZwazvs16jGI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463--1z8jPxDO9yrkmKocyIJ8Q-1; Mon, 08 Aug 2022 03:08:27 -0400
X-MC-Unique: -1z8jPxDO9yrkmKocyIJ8Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1EAF51884985;
        Mon,  8 Aug 2022 07:08:27 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA9AA492C3B;
        Mon,  8 Aug 2022 07:08:25 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org
Cc:     lhenriques@suse.de
Subject: [PATCH v3] ceph: fail the request if the peer MDS doesn't support getvxattr op
Date:   Mon,  8 Aug 2022 15:08:23 +0800
Message-Id: <20220808070823.707829-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Just fail the request instead sending the request out, or the peer
MDS will crash.

URL: https://tracker.ceph.com/issues/56529
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/inode.c      |  1 +
 fs/ceph/mds_client.c | 11 +++++++++++
 fs/ceph/mds_client.h |  6 +++++-
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 79ff197c7cc5..cfa0b550eef2 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2607,6 +2607,7 @@ int ceph_do_getvxattr(struct inode *inode, const char *name, void *value,
 		goto out;
 	}
 
+	req->r_feature_needed = CEPHFS_FEATURE_OP_GETVXATTR;
 	req->r_path2 = kstrdup(name, GFP_NOFS);
 	if (!req->r_path2) {
 		err = -ENOMEM;
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 598012ddc401..3e22783109ad 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2501,6 +2501,7 @@ ceph_mdsc_create_request(struct ceph_mds_client *mdsc, int op, int mode)
 	INIT_LIST_HEAD(&req->r_unsafe_dir_item);
 	INIT_LIST_HEAD(&req->r_unsafe_target_item);
 	req->r_fmode = -1;
+	req->r_feature_needed = -1;
 	kref_init(&req->r_kref);
 	RB_CLEAR_NODE(&req->r_node);
 	INIT_LIST_HEAD(&req->r_wait);
@@ -3255,6 +3256,16 @@ static void __do_request(struct ceph_mds_client *mdsc,
 
 	dout("do_request mds%d session %p state %s\n", mds, session,
 	     ceph_session_state_name(session->s_state));
+
+	/*
+	 * The old ceph will crash the MDSs when see unknown OPs
+	 */
+	if (req->r_feature_needed > 0 &&
+	    !test_bit(req->r_feature_needed, &session->s_features)) {
+		err = -ENODATA;
+		goto out_session;
+	}
+
 	if (session->s_state != CEPH_MDS_SESSION_OPEN &&
 	    session->s_state != CEPH_MDS_SESSION_HUNG) {
 		/*
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index e15ee2858fef..728b7d72bf76 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -31,8 +31,9 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_METRIC_COLLECT,
 	CEPHFS_FEATURE_ALTERNATE_NAME,
 	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
+	CEPHFS_FEATURE_OP_GETVXATTR,
 
-	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
+	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_OP_GETVXATTR,
 };
 
 #define CEPHFS_FEATURES_CLIENT_SUPPORTED {	\
@@ -45,6 +46,7 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_METRIC_COLLECT,		\
 	CEPHFS_FEATURE_ALTERNATE_NAME,		\
 	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,	\
+	CEPHFS_FEATURE_OP_GETVXATTR,		\
 }
 
 /*
@@ -352,6 +354,8 @@ struct ceph_mds_request {
 	long long	  r_dir_ordered_cnt;
 	int		  r_readdir_cache_idx;
 
+	int		  r_feature_needed;
+
 	struct ceph_cap_reservation r_caps_reservation;
 };
 
-- 
2.36.0.rc1

