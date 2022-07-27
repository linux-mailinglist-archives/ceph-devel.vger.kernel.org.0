Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9785A581FB0
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Jul 2022 08:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiG0GAQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Jul 2022 02:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiG0GAP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Jul 2022 02:00:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E7198D93
        for <ceph-devel@vger.kernel.org>; Tue, 26 Jul 2022 23:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658901612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=z00Klq0keI1GnkDaDmpavZd69ZV71utER+K2hjuiSBg=;
        b=aJ/WDZLv56mFsAMnd5OHKHZnSIPeIUqPHvAma5HuY866SFhyd91QntXA8qBqA7eAoioeTg
        j2YAKGc7yJWHPHn/ss4ywE9WvkQ4t1eyWjqDof+XRFmvAdX3zDLGJ/FXx5IczUOHcMecyE
        sEaft+6mGw+1nKnk4S4lyGY+tEGySNk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-206-FtCOLP2EM4iL6IywefCxmA-1; Wed, 27 Jul 2022 02:00:09 -0400
X-MC-Unique: FtCOLP2EM4iL6IywefCxmA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DCE82101A54E
        for <ceph-devel@vger.kernel.org>; Wed, 27 Jul 2022 06:00:08 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F99A1121314;
        Wed, 27 Jul 2022 06:00:07 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fall back to use old method to get xattr
Date:   Wed, 27 Jul 2022 13:56:37 +0800
Message-Id: <20220727055637.11949-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

If the peer MDS doesn't support getvxattr op then just fall back to
use old getattr method to get it. Or for the old MDSs they will crash
when receive an unknown op.

URL: https://tracker.ceph.com/issues/56529
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 10 ++++++++++
 fs/ceph/mds_client.h |  4 +++-
 fs/ceph/xattr.c      |  9 ++++++---
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 598012ddc401..bfe6d6393eba 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3255,6 +3255,16 @@ static void __do_request(struct ceph_mds_client *mdsc,
 
 	dout("do_request mds%d session %p state %s\n", mds, session,
 	     ceph_session_state_name(session->s_state));
+
+	/*
+	 * The old ceph will crash the MDSs when see unknown OPs
+	 */
+	if (req->r_op == CEPH_MDS_OP_GETVXATTR &&
+	    !test_bit(CEPHFS_FEATURE_OP_GETVXATTR, &session->s_features)) {
+		err = -EOPNOTSUPP;
+		goto out_session;
+	}
+
 	if (session->s_state != CEPH_MDS_SESSION_OPEN &&
 	    session->s_state != CEPH_MDS_SESSION_HUNG) {
 		/*
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index e15ee2858fef..0e03efab872a 100644
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
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index b10d459c2326..8f8db621772a 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -984,9 +984,12 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 		return err;
 	} else {
 		err = ceph_do_getvxattr(inode, name, value, size);
-		/* this would happen with a new client and old server combo */
+		/*
+		 * This would happen with a new client and old server combo,
+		 * then fall back to use old method to get it
+		 */
 		if (err == -EOPNOTSUPP)
-			err = -ENODATA;
+			goto handle_non_vxattrs;
 		return err;
 	}
 handle_non_vxattrs:
@@ -996,7 +999,7 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 	dout("getxattr %p name '%s' ver=%lld index_ver=%lld\n", inode, name,
 	     ci->i_xattrs.version, ci->i_xattrs.index_version);
 
-	if (ci->i_xattrs.version == 0 ||
+	if (ci->i_xattrs.version == 0 || err == -EOPNOTSUPP ||
 	    !((req_mask & CEPH_CAP_XATTR_SHARED) ||
 	      __ceph_caps_issued_mask_metric(ci, CEPH_CAP_XATTR_SHARED, 1))) {
 		spin_unlock(&ci->i_ceph_lock);
-- 
2.36.0.rc1

