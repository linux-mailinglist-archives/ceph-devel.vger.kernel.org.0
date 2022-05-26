Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9124E534A4B
	for <lists+ceph-devel@lfdr.de>; Thu, 26 May 2022 08:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbiEZGGg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 May 2022 02:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231702AbiEZGGf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 26 May 2022 02:06:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 436B4BA9BC
        for <ceph-devel@vger.kernel.org>; Wed, 25 May 2022 23:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653545193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3uSPS2sdAjwPGdVQWJlMn+AZCVC4oSxtlGQnu/wtuhc=;
        b=HsCzuSj594WFXZYeZT5rTehA/E84F5zbwWTox9PTaxRTj5EWgLxGdEt/6zW4j5TAXeWCLx
        LXdCh/LtRgv3u8a4nKpiVyL5qDY0/VvZTufv++Bujl/9I794p+xTm+LVsF3GrAnxurP5/d
        9WkyXNpHUlNmxBU6TW5RFVYTpQZETPM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493--mBWyrwnM5S24WEjqkMV_A-1; Thu, 26 May 2022 02:06:27 -0400
X-MC-Unique: -mBWyrwnM5S24WEjqkMV_A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C03F43831C53;
        Thu, 26 May 2022 06:06:26 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F19F82886;
        Thu, 26 May 2022 06:06:25 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     lhenriques@suse.de, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: add session already open notify support
Date:   Thu, 26 May 2022 14:06:19 +0800
Message-Id: <20220526060619.735109-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
 fs/ceph/mds_client.c | 25 ++++++++++++++++++++-----
 fs/ceph/mds_client.h |  5 ++++-
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 4ced8d1e18ba..3e528b89b77a 100644
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
+			pr_info("mds%d already opened\n", session->s_mds);
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

