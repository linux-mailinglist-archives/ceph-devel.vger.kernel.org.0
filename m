Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08E3535741
	for <lists+ceph-devel@lfdr.de>; Fri, 27 May 2022 03:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbiE0BPP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 May 2022 21:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiE0BPO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 26 May 2022 21:15:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4BAADEAD0B
        for <ceph-devel@vger.kernel.org>; Thu, 26 May 2022 18:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653614112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KibX0K+LtN6v9+oKO5kEpV0UcPgdne4/JYRGihV9iRo=;
        b=H1En/Pz6b/m8DYU5J4ROq4wxBXtjE5fA9yAS1M55Lb4L74PFAUQDy5xwZoEKGZgg2NUgQj
        p1mThjD9JxD91EowyQlABOSUE5TOLyQFUSJjN2Bu8oW8Si4DDLsZFfhXFRSvTuRGLE1j1i
        ueF6RKqgEQGEs0JA9VFQ5S6d4mkj1C4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-MRq0M8b9NW6HvsYXphWU-w-1; Thu, 26 May 2022 21:15:11 -0400
X-MC-Unique: MRq0M8b9NW6HvsYXphWU-w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9EADE80A0B5;
        Fri, 27 May 2022 01:15:10 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF578112131B;
        Fri, 27 May 2022 01:15:09 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, lhenriques@suse.de,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: add session already open notify support
Date:   Fri, 27 May 2022 09:15:02 +0800
Message-Id: <20220527011502.912306-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If the connection was accidently closed due to the socket issue or
something else the clients will try to open the opened sessions, the
MDSes will send the session open reply one more time if the clients
support the notify feature.

When the clients retry to open the sessions the s_seq will be 0 as
default, we need to update it anyway.

URL: https://tracker.ceph.com/issues/53911
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V2:
- s/pr_info()/pr_notice()/


 fs/ceph/mds_client.c | 25 ++++++++++++++++++++-----
 fs/ceph/mds_client.h |  5 ++++-
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 4ced8d1e18ba..3e118492183c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3569,11 +3569,26 @@ static void handle_session(struct ceph_mds_session *session,
 	case CEPH_SESSION_OPEN:
 		if (session->s_state == CEPH_MDS_SESSION_RECONNECTING)
 			pr_info("mds%d reconnect success\n", session->s_mds);
-		session->s_state = CEPH_MDS_SESSION_OPEN;
-		session->s_features = features;
-		renewed_caps(mdsc, session, 0);
-		if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &session->s_features))
-			metric_schedule_delayed(&mdsc->metric);
+
+		if (session->s_state == CEPH_MDS_SESSION_OPEN) {
+			pr_notice("mds%d is already opened\n", session->s_mds);
+		} else {
+			session->s_state = CEPH_MDS_SESSION_OPEN;
+			session->s_features = features;
+			renewed_caps(mdsc, session, 0);
+			if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT,
+				     &session->s_features))
+				metric_schedule_delayed(&mdsc->metric);
+		}
+
+		/*
+		 * The connection maybe broken and the session in client
+		 * side has been reinitialized, need to update the seq
+		 * anyway.
+		 */
+		if (!session->s_seq && seq)
+			session->s_seq = seq;
+
 		wake = 1;
 		if (mdsc->stopping)
 			__close_session(mdsc, session);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index d8ec2ac93da3..256e3eada6c1 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -29,8 +29,10 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_MULTI_RECONNECT,
 	CEPHFS_FEATURE_DELEG_INO,
 	CEPHFS_FEATURE_METRIC_COLLECT,
+	CEPHFS_FEATURE_ALTERNATE_NAME,
+	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
 
-	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
+	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
 };
 
 #define CEPHFS_FEATURES_CLIENT_SUPPORTED {	\
@@ -41,6 +43,7 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_MULTI_RECONNECT,		\
 	CEPHFS_FEATURE_DELEG_INO,		\
 	CEPHFS_FEATURE_METRIC_COLLECT,		\
+	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,	\
 }
 
 /*
-- 
2.36.0.rc1

